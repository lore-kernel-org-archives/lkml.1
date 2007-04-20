Return-Path: <linux-kernel-owner+w=401wt.eu-S2993309AbXDTSAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993309AbXDTSAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993301AbXDTSAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:00:04 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36734 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993113AbXDTSAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:00:00 -0400
Date: Fri, 20 Apr 2007 10:59:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 7/8] Enhance ramfs to support higher order pages
In-Reply-To: <20070420171928.GA2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704201057270.20868@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <20070419163540.11948.51549.sendpatchset@schroedinger.engr.sgi.com>
 <20070420134226.GA16878@skynet.ie> <20070420144726.GI31925@holomorphy.com>
 <Pine.LNX.4.64.0704200925160.20232@schroedinger.engr.sgi.com>
 <20070420171118.GZ2986@holomorphy.com> <Pine.LNX.4.64.0704201012500.20723@schroedinger.engr.sgi.com>
 <20070420171928.GA2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Variable Order Page Cache: Readahead fixups

Readahead is now dependent on the page size. For larger page sizes
we want less readahead.

Add a parameter to max_sane_readahead specifying the page order
and update the code in mm/readahead.c to be aware of variant
page sizes.

[WARNING untested likely does not compile.....]

---
 include/linux/mm.h |    2 +-
 mm/fadvise.c       |    5 +++--
 mm/filemap.c       |    5 +++--
 mm/madvise.c       |    4 +++-
 mm/readahead.c     |   12 ++++++------
 5 files changed, 16 insertions(+), 12 deletions(-)

Index: linux-2.6.21-rc7/include/linux/mm.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/mm.h	2007-04-19 21:24:12.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/mm.h	2007-04-19 21:26:16.000000000 -0700
@@ -1084,7 +1084,7 @@ unsigned long page_cache_readahead(struc
 			  unsigned long size);
 void handle_ra_miss(struct address_space *mapping, 
 		    struct file_ra_state *ra, pgoff_t offset);
-unsigned long max_sane_readahead(unsigned long nr);
+unsigned long max_sane_readahead(unsigned long nr, int order);
 
 /* Do stack extension */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
Index: linux-2.6.21-rc7/mm/fadvise.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/fadvise.c	2007-04-19 21:24:12.000000000 -0700
+++ linux-2.6.21-rc7/mm/fadvise.c	2007-04-19 21:26:16.000000000 -0700
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
+				mapping->order));
 		if (ret > 0)
 			ret = 0;
 		break;
Index: linux-2.6.21-rc7/mm/filemap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap.c	2007-04-19 21:24:12.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap.c	2007-04-19 21:26:16.000000000 -0700
@@ -1246,7 +1246,7 @@ do_readahead(struct address_space *mappi
 		return -EINVAL;
 
 	force_page_cache_readahead(mapping, filp, index,
-					max_sane_readahead(nr));
+				max_sane_readahead(nr, mapping->order));
 	return 0;
 }
 
@@ -1381,7 +1381,8 @@ retry_find:
 			count_vm_event(PGMAJFAULT);
 		}
 		did_readaround = 1;
-		ra_pages = max_sane_readahead(file->f_ra.ra_pages);
+		ra_pages = max_sane_readahead(file->f_ra.ra_pages,
+							mapping->order);
 		if (ra_pages) {
 			pgoff_t start = 0;
 
Index: linux-2.6.21-rc7/mm/madvise.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/madvise.c	2007-04-19 21:24:12.000000000 -0700
+++ linux-2.6.21-rc7/mm/madvise.c	2007-04-19 21:26:16.000000000 -0700
@@ -105,7 +105,9 @@ static long madvise_willneed(struct vm_a
 	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
 	force_page_cache_readahead(file->f_mapping,
-			file, start, max_sane_readahead(end - start));
+			file, start,
+			max_sane_readahead(end - start,
+				file->f_mapping->order));
 	return 0;
 }
 
Index: linux-2.6.21-rc7/mm/readahead.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/readahead.c	2007-04-19 21:24:12.000000000 -0700
+++ linux-2.6.21-rc7/mm/readahead.c	2007-04-19 21:26:16.000000000 -0700
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
+ 	end_index = ((isize - 1) >> page_cache_shift(mapping));
 
 	/*
 	 * Preallocate as many pages as we will need.
@@ -330,7 +330,7 @@ int force_page_cache_readahead(struct ad
 	while (nr_to_read) {
 		int err;
 
-		unsigned long this_chunk = (2 * 1024 * 1024) / PAGE_CACHE_SIZE;
+		unsigned long this_chunk = (2 * 1024 * 1024) / page_cache_size(mapping);
 
 		if (this_chunk > nr_to_read)
 			this_chunk = nr_to_read;
@@ -570,11 +570,11 @@ void handle_ra_miss(struct address_space
 }
 
 /*
- * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
+ * Given a desired number of page order readahead pages, return a
  * sensible upper limit.
  */
-unsigned long max_sane_readahead(unsigned long nr)
+unsigned long max_sane_readahead(unsigned long nr, int order)
 {
 	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE)
-		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
+		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2 >> order);
 }
