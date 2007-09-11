Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbXIKGGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbXIKGGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761153AbXIKGEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:04:38 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56447 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761180AbXIKGEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:30 -0400
Message-Id: <20070911060426.889989352@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:03:57 -0700
From: Christoph Lameter <clameter@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com
Cc: joern@lazybastard.org
Subject: [07/41] Use page_cache_xxx in mm/filemap_xip.c
Content-Disposition: inline; filename=0007-Use-page_cache_xxx-in-mm-filemap_xip.c.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx in mm/filemap_xip.c

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/filemap_xip.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index ba6892d..5237e53 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -61,24 +61,24 @@ do_xip_mapping_read(struct address_space *mapping,
 
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
@@ -117,8 +117,8 @@ do_xip_mapping_read(struct address_space *mapping,
 		 */
 		ret = actor(desc, page, offset, nr);
 		offset += ret;
-		index += offset >> PAGE_CACHE_SHIFT;
-		offset &= ~PAGE_CACHE_MASK;
+		index += page_cache_index(mapping, offset);
+		offset = page_cache_offset(mapping, offset);
 
 		if (ret == nr && desc->count)
 			continue;
@@ -131,7 +131,7 @@ no_xip_page:
 	}
 
 out:
-	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
+	*ppos = page_cache_pos(mapping, index, offset);
 	if (filp)
 		file_accessed(filp);
 }
@@ -220,7 +220,7 @@ static int xip_file_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 
 	/* XXX: are VM_FAULT_ codes OK? */
 
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	size = page_cache_next(mapping, i_size_read(inode));
 	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
 
@@ -289,9 +289,9 @@ __xip_file_write(struct file *filp, const char __user *buf,
 		unsigned long offset;
 		size_t copied;
 
-		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
-		index = pos >> PAGE_CACHE_SHIFT;
-		bytes = PAGE_CACHE_SIZE - offset;
+		offset = page_cache_offset(mapping, pos); /* Within page */
+		index = page_cache_index(mapping, pos);
+		bytes = page_cache_size(mapping) - offset;
 		if (bytes > count)
 			bytes = count;
 
@@ -405,8 +405,8 @@ EXPORT_SYMBOL_GPL(xip_file_write);
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
1.5.2.5

-- 
