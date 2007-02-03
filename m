Return-Path: <linux-kernel-owner+w=401wt.eu-S1751246AbXBCTEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbXBCTEM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 14:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbXBCTEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 14:04:12 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:41274 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751246AbXBCTEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 14:04:11 -0500
Date: Sat, 3 Feb 2007 11:03:59 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
In-Reply-To: <1170525860.3073.1054.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com> 
 <20070203005316.eb0b4042.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
 <1170525860.3073.1054.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the second piece removing mlock pages off the LRU during scanning. 
I tried moving them to a separate list but then we run into issues with
locking. We do not need ithe list though since we will encounter the
page again anyways during zap_pte_range.

However, in zap_pte_range we then run into another problem. Multiple 
zap_pte_ranges may handle the same page and without a page flag and 
scanning all the vmas we cannot determine if the page should or should not 
be moved back to the LRU. As a result this patch may decrement NR_MLOCK 
too much so that is goes below zero. Any ideas on how to fix this without 
a page flag and a scan over vmas?

Plus there is the issue of NR_MLOCK only being updated when we are 
reclaiming and when we may already be in trouble. An app may mlock huge 
amounts of memory and NR_MLOCK will stay low. If memory gets too low then
NR_MLOCKED is suddenly become accurate and the VM is likely undergoing a 
shock from that discovery (should we actually use NR_MLOCK elsewhere to 
determine memory management behavior). Hopefully we will not fall over 
then.

Maybe the best would be to handle the counter separately via a page flag? 
But then we go back to ugly vma scans. Yuck.

Index: current/mm/vmscan.c
===================================================================
--- current.orig/mm/vmscan.c	2007-02-03 10:53:15.000000000 -0800
+++ current/mm/vmscan.c	2007-02-03 10:53:25.000000000 -0800
@@ -516,10 +516,11 @@ static unsigned long shrink_page_list(st
 		if (page_mapped(page) && mapping) {
 			switch (try_to_unmap(page, 0)) {
 			case SWAP_FAIL:
-			case SWAP_MLOCK:
 				goto activate_locked;
 			case SWAP_AGAIN:
 				goto keep_locked;
+			case SWAP_MLOCK:
+				goto mlocked;
 			case SWAP_SUCCESS:
 				; /* try to free the page below */
 			}
@@ -594,6 +595,11 @@ free_it:
 			__pagevec_release_nonlru(&freed_pvec);
 		continue;
 
+mlocked:
+		unlock_page(page);
+		__inc_zone_page_state(page, NR_MLOCK);
+		continue;
+
 activate_locked:
 		SetPageActive(page);
 		pgactivate++;
Index: current/mm/memory.c
===================================================================
--- current.orig/mm/memory.c	2007-02-03 10:52:37.000000000 -0800
+++ current/mm/memory.c	2007-02-03 10:53:25.000000000 -0800
@@ -682,6 +682,10 @@ static unsigned long zap_pte_range(struc
 				file_rss--;
 			}
 			page_remove_rmap(page, vma);
+			if (vma->vm_flags & VM_LOCKED) {
+				__dec_zone_page_state(page, NR_MLOCK);
+				lru_cache_add_active(page);
+			}
 			tlb_remove_page(tlb, page);
 			continue;
 		}
Index: current/drivers/base/node.c
===================================================================
--- current.orig/drivers/base/node.c	2007-02-03 10:52:35.000000000 -0800
+++ current/drivers/base/node.c	2007-02-03 10:53:25.000000000 -0800
@@ -60,6 +60,7 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d FilePages:    %8lu kB\n"
 		       "Node %d Mapped:       %8lu kB\n"
 		       "Node %d AnonPages:    %8lu kB\n"
+		       "Node %d Mlock:        %8lu KB\n"
 		       "Node %d PageTables:   %8lu kB\n"
 		       "Node %d NFS_Unstable: %8lu kB\n"
 		       "Node %d Bounce:       %8lu kB\n"
@@ -82,6 +83,7 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
 		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
+		       nid, K(node_page_state(nid, NR_MLOCK)),
 		       nid, K(node_page_state(nid, NR_PAGETABLE)),
 		       nid, K(node_page_state(nid, NR_UNSTABLE_NFS)),
 		       nid, K(node_page_state(nid, NR_BOUNCE)),
Index: current/fs/proc/proc_misc.c
===================================================================
--- current.orig/fs/proc/proc_misc.c	2007-02-03 10:52:36.000000000 -0800
+++ current/fs/proc/proc_misc.c	2007-02-03 10:53:25.000000000 -0800
@@ -166,6 +166,7 @@ static int meminfo_read_proc(char *page,
 		"Writeback:    %8lu kB\n"
 		"AnonPages:    %8lu kB\n"
 		"Mapped:       %8lu kB\n"
+		"Mlock:        %8lu KB\n"
 		"Slab:         %8lu kB\n"
 		"SReclaimable: %8lu kB\n"
 		"SUnreclaim:   %8lu kB\n"
@@ -196,6 +197,7 @@ static int meminfo_read_proc(char *page,
 		K(global_page_state(NR_WRITEBACK)),
 		K(global_page_state(NR_ANON_PAGES)),
 		K(global_page_state(NR_FILE_MAPPED)),
+		K(global_page_state(NR_MLOCK)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE) +
 				global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE)),
Index: current/include/linux/mmzone.h
===================================================================
--- current.orig/include/linux/mmzone.h	2007-02-03 10:52:35.000000000 -0800
+++ current/include/linux/mmzone.h	2007-02-03 10:53:25.000000000 -0800
@@ -58,6 +58,7 @@ enum zone_stat_item {
 	NR_FILE_DIRTY,
 	NR_WRITEBACK,
 	/* Second 128 byte cacheline */
+	NR_MLOCK,		/* Mlocked pages */
 	NR_SLAB_RECLAIMABLE,
 	NR_SLAB_UNRECLAIMABLE,
 	NR_PAGETABLE,		/* used for pagetables */
Index: current/mm/vmstat.c
===================================================================
--- current.orig/mm/vmstat.c	2007-02-03 10:52:36.000000000 -0800
+++ current/mm/vmstat.c	2007-02-03 10:53:25.000000000 -0800
@@ -439,6 +439,7 @@ static const char * const vmstat_text[] 
 	"nr_file_pages",
 	"nr_dirty",
 	"nr_writeback",
+	"nr_mlock",
 	"nr_slab_reclaimable",
 	"nr_slab_unreclaimable",
 	"nr_page_table_pages",
