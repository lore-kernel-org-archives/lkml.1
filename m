Return-Path: <linux-kernel-owner+w=401wt.eu-S1762034AbXH1TPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbXH1TPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761284AbXH1TIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58845 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760891AbXH1THo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:44 -0400
Message-Id: <20070828190735.527906022@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:23 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [32/36] Readahead changes to support large blocksize.
Content-Disposition: inline; filename=0032-Readahead-changes-to-support-large-blocksize.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up readhead for large I/O operations.

Only calculate the readahead until the 2M boundary then fall back to
one page.

Signed-off-by: Fengguang Wu <fengguang.wu@gmail.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

===================================================================
---
 include/linux/mm.h |    2 +-
 mm/fadvise.c       |    4 ++--
 mm/filemap.c       |    5 ++---
 mm/madvise.c       |    2 +-
 mm/readahead.c     |   22 ++++++++++++++--------
 5 files changed, 20 insertions(+), 15 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-08-27 21:03:20.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2007-08-27 21:14:44.000000000 -0700
@@ -1142,7 +1142,7 @@ void page_cache_async_readahead(struct a
 				pgoff_t offset,
 				unsigned long size);
 
-unsigned long max_sane_readahead(unsigned long nr);
+unsigned long max_sane_readahead(unsigned long nr, int order);
 
 /* Do stack extension */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
Index: linux-2.6/mm/fadvise.c
===================================================================
--- linux-2.6.orig/mm/fadvise.c	2007-08-27 20:52:49.000000000 -0700
+++ linux-2.6/mm/fadvise.c	2007-08-27 21:14:44.000000000 -0700
@@ -86,10 +86,10 @@ asmlinkage long sys_fadvise64_64(int fd,
 		nrpages = end_index - start_index + 1;
 		if (!nrpages)
 			nrpages = ~0UL;
-		
+
 		ret = force_page_cache_readahead(mapping, file,
 				start_index,
-				max_sane_readahead(nrpages));
+				nrpages);
 		if (ret > 0)
 			ret = 0;
 		break;
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2007-08-27 21:10:38.000000000 -0700
+++ linux-2.6/mm/filemap.c	2007-08-27 21:14:44.000000000 -0700
@@ -1237,8 +1237,7 @@ do_readahead(struct address_space *mappi
 	if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
 		return -EINVAL;
 
-	force_page_cache_readahead(mapping, filp, index,
-					max_sane_readahead(nr));
+	force_page_cache_readahead(mapping, filp, index, nr);
 	return 0;
 }
 
@@ -1373,7 +1372,7 @@ retry_find:
 			count_vm_event(PGMAJFAULT);
 		}
 		did_readaround = 1;
-		ra_pages = max_sane_readahead(file->f_ra.ra_pages);
+		ra_pages = file->f_ra.ra_pages;
 		if (ra_pages) {
 			pgoff_t start = 0;
 
Index: linux-2.6/mm/madvise.c
===================================================================
--- linux-2.6.orig/mm/madvise.c	2007-08-27 19:22:13.000000000 -0700
+++ linux-2.6/mm/madvise.c	2007-08-27 21:14:44.000000000 -0700
@@ -124,7 +124,7 @@ static long madvise_willneed(struct vm_a
 	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
 	force_page_cache_readahead(file->f_mapping,
-			file, start, max_sane_readahead(end - start));
+			file, start, end - start);
 	return 0;
 }
 
Index: linux-2.6/mm/readahead.c
===================================================================
--- linux-2.6.orig/mm/readahead.c	2007-08-27 19:22:13.000000000 -0700
+++ linux-2.6/mm/readahead.c	2007-08-27 21:14:44.000000000 -0700
@@ -44,7 +44,8 @@ EXPORT_SYMBOL_GPL(default_backing_dev_in
 void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
 {
-	ra->ra_pages = mapping->backing_dev_info->ra_pages;
+	ra->ra_pages = DIV_ROUND_UP(mapping->backing_dev_info->ra_pages,
+				    page_cache_size(mapping));
 	ra->prev_index = -1;
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
@@ -84,7 +85,7 @@ int read_cache_pages(struct address_spac
 			put_pages_list(pages);
 			break;
 		}
-		task_io_account_read(PAGE_CACHE_SIZE);
+		task_io_account_read(page_cache_size(mapping));
 	}
 	pagevec_lru_add(&lru_pvec);
 	return ret;
@@ -151,7 +152,7 @@ __do_page_cache_readahead(struct address
 	if (isize == 0)
 		goto out;
 
-	end_index = ((isize - 1) >> PAGE_CACHE_SHIFT);
+	end_index = page_cache_index(mapping, isize - 1);
 
 	/*
 	 * Preallocate as many pages as we will need.
@@ -204,10 +205,12 @@ int force_page_cache_readahead(struct ad
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
 		return -EINVAL;
 
+	nr_to_read = max_sane_readahead(nr_to_read, mapping_order(mapping));
 	while (nr_to_read) {
 		int err;
 
-		unsigned long this_chunk = (2 * 1024 * 1024) / PAGE_CACHE_SIZE;
+		unsigned long this_chunk = DIV_ROUND_UP(2 * 1024 * 1024,
+						page_cache_size(mapping));
 
 		if (this_chunk > nr_to_read)
 			this_chunk = nr_to_read;
@@ -237,17 +240,20 @@ int do_page_cache_readahead(struct addre
 	if (bdi_read_congested(mapping->backing_dev_info))
 		return -1;
 
+	nr_to_read = max_sane_readahead(nr_to_read, mapping_order(mapping));
 	return __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
 }
 
 /*
- * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
+ * Given a desired number of page order readahead pages, return a
  * sensible upper limit.
  */
-unsigned long max_sane_readahead(unsigned long nr)
+unsigned long max_sane_readahead(unsigned long nr, int order)
 {
-	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE)
-		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
+	unsigned long base_pages = node_page_state(numa_node_id(), NR_INACTIVE)
+			+ node_page_state(numa_node_id(), NR_FREE_PAGES);
+
+	return min(nr, (base_pages / 2) >> order);
 }
 
 /*

-- 
