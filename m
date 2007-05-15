Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbXEOMZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbXEOMZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758082AbXEOMYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:24:54 -0400
Received: from verein.lst.de ([213.95.11.210]:60064 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330AbXEOMYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:24:53 -0400
Date: Tue, 15 May 2007 14:24:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: nate.diller@gmail.com, akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] deprecate memclear_highpage_flush deprecation warnings
Message-ID: <20070515122440.GA8765@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recent builds get tons of warnings about memclear_highpage_flush
beeing deprecated.  Turns out it's replaced by zero_user_page
which takes an additional argument.

Now folks, deprecated is for actual functionality going away, there
is no need to mark the old name deprecated for such a trivial
paramter change and rename.  This stuff should go to Linus in one
patch that doesn't create utterly useless warnings and keeps around
stale interfaces.

Here's a patch to kill memclear_highpage_flush and convert the reaming
user to make the build a littler more silent, it's more than noisy
enough due to all the useless addition of __deprecated or __must_check
to widely used functionality and gcc stupid false positives.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/nfs/read.c
===================================================================
--- linux-2.6.orig/fs/nfs/read.c	2007-05-15 14:19:59.000000000 +0200
+++ linux-2.6/fs/nfs/read.c	2007-05-15 14:21:24.000000000 +0200
@@ -79,7 +79,7 @@ void nfs_readdata_release(void *data)
 static
 int nfs_return_empty_page(struct page *page)
 {
-	memclear_highpage_flush(page, 0, PAGE_CACHE_SIZE);
+	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
@@ -103,10 +103,10 @@ static void nfs_readpage_truncate_uninit
 	pglen = PAGE_CACHE_SIZE - base;
 	for (;;) {
 		if (remainder <= pglen) {
-			memclear_highpage_flush(*pages, base, remainder);
+			zero_user_page(*pages, base, remainder, KM_USER0);
 			break;
 		}
-		memclear_highpage_flush(*pages, base, pglen);
+		zero_user_page(*pages, base, pglen, KM_USER0);
 		pages++;
 		remainder -= pglen;
 		pglen = PAGE_CACHE_SIZE;
@@ -130,7 +130,7 @@ static int nfs_readpage_async(struct nfs
 		return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, len, PAGE_CACHE_SIZE - len);
+		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
 
 	nfs_list_add_request(new, &one_request);
 	if (NFS_SERVER(inode)->rsize < PAGE_CACHE_SIZE)
@@ -532,7 +532,7 @@ readpage_async_filler(void *data, struct
 			return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, len, PAGE_CACHE_SIZE - len);
+		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
 	nfs_pageio_add_request(desc->pgio, new);
 	return 0;
 }
Index: linux-2.6/fs/nfs/write.c
===================================================================
--- linux-2.6.orig/fs/nfs/write.c	2007-05-15 14:19:59.000000000 +0200
+++ linux-2.6/fs/nfs/write.c	2007-05-15 14:21:21.000000000 +0200
@@ -168,7 +168,7 @@ static void nfs_mark_uptodate(struct pag
 	if (count != nfs_page_length(page))
 		return;
 	if (count != PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, count, PAGE_CACHE_SIZE - count);
+		zero_user_page(page, count, PAGE_CACHE_SIZE - count, KM_USER0);
 	SetPageUptodate(page);
 }
 
Index: linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_lrw.c	2007-05-15 14:19:59.000000000 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c	2007-05-15 14:21:27.000000000 +0200
@@ -159,7 +159,7 @@ xfs_iozero(
 		if (status)
 			goto unlock;
 
-		memclear_highpage_flush(page, offset, bytes);
+		zero_user_page(page, offset, bytes, KM_USER0);
 
 		status = mapping->a_ops->commit_write(NULL, page, offset,
 							offset + bytes);
Index: linux-2.6/include/linux/highmem.h
===================================================================
--- linux-2.6.orig/include/linux/highmem.h	2007-05-15 14:19:59.000000000 +0200
+++ linux-2.6/include/linux/highmem.h	2007-05-15 14:21:12.000000000 +0200
@@ -110,12 +110,6 @@ static inline void clear_highpage(struct
 		kunmap_atomic(kaddr, (km_type));		\
 	} while (0)
 
-static inline void __deprecated memclear_highpage_flush(struct page *page,
-			unsigned int offset, unsigned int size)
-{
-	zero_user_page(page, offset, size, KM_USER0);
-}
-
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
 
 static inline void copy_user_highpage(struct page *to, struct page *from,

