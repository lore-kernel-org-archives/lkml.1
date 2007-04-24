Return-Path: <linux-kernel-owner+w=401wt.eu-S1423179AbXDXW1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423179AbXDXW1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423157AbXDXW10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:27:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43920 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423179AbXDXWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:23:07 -0400
Message-Id: <20070424222307.007652788@sgi.com>
References: <20070424222105.883597089@sgi.com>
User-Agent: quilt/0.45-1
Date: Tue, 24 Apr 2007 15:21:16 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [11/17] Readahead support for the variable order page cache
Content-Disposition: inline; filename=var_pc_readahead
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Readahead is now dependent on the page size. For larger page sizes
we want less readahead.

Add a parameter to max_sane_readahead specifying the page order
and update the code in mm/readahead.c to be aware of variant
page sizes.

Mark the 2M readahead constant as a potential future problem.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |    2 +-
 mm/fadvise.c       |    5 +++--
 mm/filemap.c       |    5 +++--
 mm/madvise.c       |    4 +++-
 mm/readahead.c     |   20 +++++++++++++-------
 5 files changed, 23 insertions(+), 13 deletions(-)

Index: linux-2.6.21-rc7/include/linux/mm.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/mm.h	2007-04-23 22:26:28.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/mm.h	2007-04-23 22:27:44.000000000 -0700
@@ -1115,7 +1115,7 @@ unsigned long page_cache_readahead(struc
 			  unsigned long size);
 void handle_ra_miss(struct address_space *mapping, 
 		    struct file_ra_state *ra, pgoff_t offset);
-unsigned long max_sane_readahead(unsigned long nr);
+unsigned long max_sane_readahead(unsigned long nr, int order);
 
 /* Do stack extension */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
Index: linux-2.6.21-rc7/mm/fadvise.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/fadvise.c	2007-04-23 22:26:28.000000000 -0700
+++ linux-2.6.21-rc7/mm/fadvise.c	2007-04-23 22:27:44.000000000 -0700
@@ -86,10 +86,11 @@ asmlinkage long sys_fadvise64_64(int fd,
 		nrpages = end_index - start_index + 1;
 		if (!nrpages)
 			nrpages = ~0UL;
-		
+
 		ret = force_page_cache_readahead(mapping, file,
 				start_index,
-				max_sane_readahead(nrpages));
+				max_sane_readahead(nrpages,
+					mapping_order(mapping)));
 		if (ret > 0)
 			ret = 0;
 		break;
Index: linux-2.6.21-rc7/mm/filemap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap.c	2007-04-23 22:26:28.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap.c	2007-04-23 22:27:44.000000000 -0700
@@ -1246,7 +1246,7 @@ do_readahead(struct address_space *mappi
 		return -EINVAL;
 
 	force_page_cache_readahead(mapping, filp, index,
-					max_sane_readahead(nr));
+				max_sane_readahead(nr, mapping_order(mapping)));
 	return 0;
 }
 
@@ -1381,7 +1381,8 @@ retry_find:
 			count_vm_event(PGMAJFAULT);
 		}
 		did_readaround = 1;
-		ra_pages = max_sane_readahead(file->f_ra.ra_pages);
+		ra_pages = max_sane_readahead(file->f_ra.ra_pages,
+						mapping_order(mapping));
 		if (ra_pages) {
 			pgoff_t start = 0;
 
Index: linux-2.6.21-rc7/mm/madvise.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/madvise.c	2007-04-23 22:26:28.000000000 -0700
+++ linux-2.6.21-rc7/mm/madvise.c	2007-04-23 22:27:44.000000000 -0700
@@ -105,7 +105,9 @@ static long madvise_willneed(struct vm_a
 	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
 	force_page_cache_readahead(file->f_mapping,
-			file, start, max_sane_readahead(end - start));
+			file, start,
+			max_sane_readahead(end - start,
+				mapping_order(file->f_mapping)));
 	return 0;
 }
 
Index: linux-2.6.21-rc7/mm/readahead.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/readahead.c	2007-04-23 22:26:28.000000000 -0700
+++ linux-2.6.21-rc7/mm/readahead.c	2007-04-23 22:27:44.000000000 -0700
@@ -152,7 +152,7 @@ int read_cache_pages(struct address_spac
 			put_pages_list(pages);
 			break;
 		}
-		task_io_account_read(PAGE_CACHE_SIZE);
+		task_io_account_read(page_cache_size(mapping));
 	}
 	pagevec_lru_add(&lru_pvec);
 	return ret;
@@ -276,7 +276,7 @@ __do_page_cache_readahead(struct address
 	if (isize == 0)
 		goto out;
 
- 	end_index = ((isize - 1) >> PAGE_CACHE_SHIFT);
+ 	end_index = page_cache_index(mapping, isize - 1);
 
 	/*
 	 * Preallocate as many pages as we will need.
@@ -330,7 +330,11 @@ int force_page_cache_readahead(struct ad
 	while (nr_to_read) {
 		int err;
 
-		unsigned long this_chunk = (2 * 1024 * 1024) / PAGE_CACHE_SIZE;
+		/*
+		 * FIXME: Note the 2M constant here that may prove to
+		 * be a problem if page sizes become bigger than one megabyte.
+		 */
+		unsigned long this_chunk = page_cache_index(mapping, 2 * 1024 * 1024);
 
 		if (this_chunk > nr_to_read)
 			this_chunk = nr_to_read;
@@ -570,11 +574,13 @@ void handle_ra_miss(struct address_space
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

--
