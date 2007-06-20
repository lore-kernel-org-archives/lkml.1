Return-Path: <linux-kernel-owner+w=401wt.eu-S1759890AbXFTSdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890AbXFTSdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758314AbXFTSaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:30:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54758 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756283AbXFTSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:10 -0400
Message-Id: <20070620183007.844458784@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:16 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [09/37] Use page_cache_xxx in fs/libfs.c
Content-Disposition: inline; filename=vps_fs_libfs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/libfs.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

Index: vps/fs/libfs.c
===================================================================
--- vps.orig/fs/libfs.c	2007-06-11 21:39:09.000000000 -0700
+++ vps/fs/libfs.c	2007-06-11 22:08:13.000000000 -0700
@@ -16,7 +16,8 @@ int simple_getattr(struct vfsmount *mnt,
 {
 	struct inode *inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
-	stat->blocks = inode->i_mapping->nrpages << (PAGE_CACHE_SHIFT - 9);
+	stat->blocks = inode->i_mapping->nrpages <<
+				(page_cache_shift(inode->i_mapping) - 9);
 	return 0;
 }
 
@@ -340,10 +341,10 @@ int simple_prepare_write(struct file *fi
 			unsigned from, unsigned to)
 {
 	if (!PageUptodate(page)) {
-		if (to - from != PAGE_CACHE_SIZE)
+		if (to - from != page_cache_size(file->f_mapping))
 			zero_user_segments(page,
 				0, from,
-				to, PAGE_CACHE_SIZE);
+				to, page_cache_size(file->f_mapping));
 	}
 	return 0;
 }
@@ -356,8 +357,8 @@ int simple_write_begin(struct file *file
 	pgoff_t index;
 	unsigned from;
 
-	index = pos >> PAGE_CACHE_SHIFT;
-	from = pos & (PAGE_CACHE_SIZE - 1);
+	index = page_cache_index(mapping, pos);
+	from = page_cache_offset(mapping, pos);
 
 	page = __grab_cache_page(mapping, index);
 	if (!page)
@@ -371,8 +372,9 @@ int simple_write_begin(struct file *file
 int simple_commit_write(struct file *file, struct page *page,
 			unsigned from, unsigned to)
 {
-	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	loff_t pos = page_cache_pos(mapping, page->index, to);
 
 	if (!PageUptodate(page))
 		SetPageUptodate(page);
@@ -390,7 +392,7 @@ int simple_write_end(struct file *file, 
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata)
 {
-	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+	unsigned from = page_cache_offset(mapping, pos);
 
 	/* zero the stale part of the page if we did a short copy */
 	if (copied < len)

-- 
