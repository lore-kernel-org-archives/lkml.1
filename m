Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbYA1A7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbYA1A7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 19:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYA1A7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 19:59:12 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:51164 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYA1A7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 19:59:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nU5Fr5oV7xKgaTz7VhG1e7el2UZsKbhaLVr7tdZWEgG4Pdf0VvT2ZaE3G54Y9FY6zrPsCPMqvLGDy6qvEDVHgCKycR8xsuW2BRWpzroc77XEhGXQLW9Hp38QwIo5pSjTgCO1cNzhH+USGAC6SBRyU5cmKXf+wDPDqX1sBsy+RVQ=
Message-ID: <9c9fda240801271659qb2e4b04xaa0c37c3db12e805@mail.gmail.com>
Date: Mon, 28 Jan 2008 09:59:07 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] CRAMFS: Uncompressed files support
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080126220404.5c128ca3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080122022345.GA3678@party>
	 <20080126220404.5c128ca3.akpm@linux-foundation.org>
X-Google-Sender-Auth: 98ed0a17738eb944
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch enables the uncompressed files support in cramfs.
> >
> > The word 'uncompressed file' is from linear cramfs (aka Application XIP).
> > In linear cramfs, it is used to suport XIP on NOR. However it is also helpful on OneNAND. It makes a filesystem faster by removing compression overhead.
> > In XIP mode it runs XIP, But non-XIP mode. It copies data to ram and runs.
> >
> > In my simple test, copy busybox (compressed or uncompressed).
> > It reduces the about 50% time saving from 0.40s to 0.19s.
> > Yes, it incrases the file system size, but nowadays flash has big capacity.
> > It's trade-off between size and performance.
> >
> > Also this patch uses the page cache directly.
> > In previous implementation, it used the local buffer. why?
> > It's already uncompressed and fits to page size. So It uses the page directly to remove useless memory copy.
> >
> > It's compatible the existing linear cramfs image and original one.
> >
> > Any comments are welcome.
> >
> > diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
> > index 3d194a2..edba28f 100644
> > --- a/fs/cramfs/inode.c
> > +++ b/fs/cramfs/inode.c
>
> I don't know what kernel this is against but it generates a lot of rejects
> against present mainline.
>

Sorry, it used another tree instead of mainline. Following patch will
be against mainline.

>
> Are you sure about the kmap/kunmap handling in this patch?  It looks like
> it might be unbalanced.
>

Yes, It's matching. Because cramfs_read returns virtual address, it
returns the kmap-ped address if it had page, then caller kunmap-ed and
release it. Otherwise pg doesn't have page pointer.

Anyway, here's more simple method using get_block sytle.
With this patch, it can also use multi page read, cramfs_readpages.
However, it has no big improvement in my environment.

The goal is same it uses the requested page directly instead of
useless memory copy.

Any comments are welcome.

Thank you,
Kyungmin Park

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 350680f..2d6736d 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -23,6 +23,7 @@
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/mutex.h>
+#include <linux/mpage.h>
 #include <asm/semaphore.h>

 #include <asm/uaccess.h>
@@ -40,6 +41,7 @@ static DEFINE_MUTEX(read_mutex);
 #define CRAMINO(x)	(((x)->offset && (x)->size)?(x)->offset<<2:1)
 #define OFFSET(x)	((x)->i_ino)

+#define CRAMFS_INODE_IS_XIP(x)	((x)->i_mode & S_ISVTX)

 static int cramfs_iget5_test(struct inode *inode, void *opaque)
 {
@@ -468,16 +470,32 @@ static struct dentry * cramfs_lookup(struct
inode *dir, struct dentry *dentry, s
 	return NULL;
 }

+static int cramfs_get_block(struct inode *inode, sector_t iblock,
+		struct buffer_head *bh_result, int create)
+{
+	/* A write? */
+	BUG_ON(unlikely(create));
+
+	iblock += (PAGE_ALIGN(OFFSET(inode)) >> PAGE_CACHE_SHIFT);
+	map_bh(bh_result, inode->i_sb, iblock);
+
+	return 0;
+}
+
 static int cramfs_readpage(struct file *file, struct page * page)
 {
 	struct inode *inode = page->mapping->host;
+	struct super_block *sb = inode->i_sb;
 	u32 maxblock, bytes_filled;
 	void *pgdata;

 	maxblock = (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	bytes_filled = 0;
-	if (page->index < maxblock) {
-		struct super_block *sb = inode->i_sb;
+
+	/* Handle uncompressed files */
+	if (CRAMFS_INODE_IS_XIP(inode) && page->index < maxblock) {
+		return mpage_readpage(page, cramfs_get_block);
+	} else if (page->index < maxblock) {
 		u32 blkptr_offset = OFFSET(inode) + page->index*4;
 		u32 start_offset, compr_len;
