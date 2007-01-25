Return-Path: <linux-kernel-owner+w=401wt.eu-S965763AbXAYKkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965763AbXAYKkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 05:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965765AbXAYKkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 05:40:23 -0500
Received: from mx1-2.mail.ru ([194.67.23.121]:25307 "EHLO mx1.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965763AbXAYKkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 05:40:20 -0500
Date: Thu, 25 Jan 2007 13:45:38 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] ufs: rellocation fix
Message-ID: <20070125104538.GA4037@rain>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070122150751.GA11129@rain> <20070124202107.4788d802.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124202107.4788d802.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 08:21:07PM -0800, Andrew Morton wrote:
> On Mon, 22 Jan 2007 18:07:51 +0300
> Evgeniy Dushistov <dushistov@mail.ru> wrote:
> 
> > -	for (i = 0; i < count; i += blk_per_page) {
> > +	for (i = 0; i < count; i = (i | mask) + 1) {
> 
> This is a funny looking thing.  As far as I can tell, this is a more
> complicated way of doing the same thing as the old code did.
> 
> Am I missing something?
> 

No, you right, thanks, work should be done with baseblk+i, not with i.
(It is imposible to catch on my test enviroment: size of page 4096
and baseblk always point to begin of data block which size of 
>=4096 and power of 2).

Here is patch for patch, it also contains typo fixing in previous
patch which lead to compilation failure if ufs debug turn on.

May be it is possible to integrate this patch into previous one,
or resend new version of last patch?

---

Index: linux-2.6.20-rc5/fs/ufs/balloc.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/ufs/balloc.c
+++ linux-2.6.20-rc5/fs/ufs/balloc.c
@@ -227,14 +227,14 @@ failed:
  * We can come here from ufs_writepage or ufs_prepare_write,
  * locked_page is argument of these functions, so we already lock it.
  */
-static void ufs_change_blocknr(struct inode *inode, unsigned int baseblk,
+static void ufs_change_blocknr(struct inode *inode, unsigned int beg,
 			       unsigned int count, unsigned int oldb,
 			       unsigned int newb, struct page *locked_page)
 {
 	const unsigned mask = (1 << (PAGE_CACHE_SHIFT - inode->i_blkbits)) - 1;
 	struct address_space * const mapping = inode->i_mapping;
 	pgoff_t index, cur_index;
-	unsigned i, pos, j;
+	unsigned end, pos, j;
 	struct page *page;
 	struct buffer_head *head, *bh;
 
@@ -246,8 +246,8 @@ static void ufs_change_blocknr(struct in
 
 	cur_index = locked_page->index;
 
-	for (i = 0; i < count; i = (i | mask) + 1) {
-		index = (baseblk+i) >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	for (end = count + beg; beg < end; beg = (beg | mask) + 1) {
+		index = beg >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
 
 		if (likely(cur_index != index)) {
 			page = ufs_get_locked_page(mapping, index);
@@ -258,7 +258,7 @@ static void ufs_change_blocknr(struct in
 
 		head = page_buffers(page);
 		bh = head;
-		pos = i & mask;
+		pos = beg & mask;
 		for (j = 0; j < pos; ++j)
 			bh = bh->b_this_page;
 		j = 0;
@@ -267,7 +267,7 @@ static void ufs_change_blocknr(struct in
 				pos = bh->b_blocknr - oldb;
 				if (pos < count) {
 					UFSD(" change from %llu to %llu\n",
-					     (unsigned long long)pos + odlb,
+					     (unsigned long long)pos + oldb,
 					     (unsigned long long)pos + newb);
 					bh->b_blocknr = newb + pos;
 					unmap_underlying_metadata(bh->b_bdev,

-- 
/Evgeniy

