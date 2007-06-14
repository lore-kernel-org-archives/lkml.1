Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbXFNTmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbXFNTmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbXFNTlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:41:02 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55602 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753437AbXFNTky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:40:54 -0400
Message-Id: <20070614194054.066688330@sgi.com>
References: <20070614193839.878721298@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 12:38:46 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [patch 07/14] Use page_cache_xx in mm/filemap_xip.c
Content-Disposition: inline; filename=vps_mm_filemap_xip
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/filemap_xip.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

Index: vps/mm/filemap_xip.c
===================================================================
--- vps.orig/mm/filemap_xip.c	2007-06-09 21:52:40.000000000 -0700
+++ vps/mm/filemap_xip.c	2007-06-09 21:58:11.000000000 -0700
@@ -60,24 +60,24 @@ do_xip_mapping_read(struct address_space
 
 	BUG_ON(!mapping->a_ops->get_xip_page);
 
-	index = *ppos >> PAGE_CACHE_SHIFT;
-	offset = *ppos & ~PAGE_CACHE_MASK;
+	index = page_cache_index(mapping, *ppos);
+	offset = page_cache_offset(mapping, *ppos);
 
 	isize = i_size_read(inode);
 	if (!isize)
 		goto out;
 
-	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+	end_index = page_cache_index(mapping, isize - 1);
 	for (;;) {
 		struct page *page;
 		unsigned long nr, ret;
 
 		/* nr is the maximum number of bytes to copy from this page */
-		nr = PAGE_CACHE_SIZE;
+		nr = page_cache_size(mapping);
 		if (index >= end_index) {
 			if (index > end_index)
 				goto out;
-			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
+			nr = page_cache_next(mapping, size - 1) + 1;
 			if (nr <= offset) {
 				goto out;
 			}
@@ -116,8 +116,8 @@ do_xip_mapping_read(struct address_space
 		 */
 		ret = actor(desc, page, offset, nr);
 		offset += ret;
-		index += offset >> PAGE_CACHE_SHIFT;
-		offset &= ~PAGE_CACHE_MASK;
+		index += page_cache_index(mapping, offset);
+		offset = page_cache_offset(mapping, offset);
 
 		if (ret == nr && desc->count)
 			continue;
@@ -130,7 +130,7 @@ no_xip_page:
 	}
 
 out:
-	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
+	*ppos = page_cache_pos(mapping, index, offset);
 	if (filp)
 		file_accessed(filp);
 }
@@ -242,7 +242,7 @@ static struct page *xip_file_fault(struc
 
 	/* XXX: are VM_FAULT_ codes OK? */
 
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	size = page_cache_next(mapping, i_size_read(inode));
 	if (fdata->pgoff >= size) {
 		fdata->type = VM_FAULT_SIGBUS;
 		return NULL;
@@ -320,9 +320,9 @@ __xip_file_write(struct file *filp, cons
 		size_t copied;
 		char *kaddr;
 
-		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
-		index = pos >> PAGE_CACHE_SHIFT;
-		bytes = PAGE_CACHE_SIZE - offset;
+		offset = page_cache_offset(mapping, pos); /* Within page */
+		index = page_cache_index(mapping, pos);
+		bytes = page_cache_size(mapping) - offset;
 		if (bytes > count)
 			bytes = count;
 
@@ -433,8 +433,8 @@ EXPORT_SYMBOL_GPL(xip_file_write);
 int
 xip_truncate_page(struct address_space *mapping, loff_t from)
 {
-	pgoff_t index = from >> PAGE_CACHE_SHIFT;
-	unsigned offset = from & (PAGE_CACHE_SIZE-1);
+	pgoff_t index = page_cache_index(mapping, from);
+	unsigned offset = page_cache_offset(mapping, from);
 	unsigned blocksize;
 	unsigned length;
 	struct page *page;

-- 
