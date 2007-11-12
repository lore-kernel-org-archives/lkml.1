Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbXKLSZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbXKLSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbXKLSZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:25:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:17160 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbXKLSZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:25:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=D/b9sNmqR1oOhEi1tDWvIATShHQ/2utLb8pCWmrSdUnotfDlNx6N0GfGw6UK3HrPQAP3H8WwN8LXWg/awpz7tgJZywNAb4jsphoowPPvIakmhbn+eE/P2RhgMjIPYCcJaxw71JDXjIU6gB1PcIvNCdZXH+OA68FYz6m+83IH+GA=
Date: Mon, 12 Nov 2007 21:25:26 +0300
To: mel@csn.ul.ie, akpm@osdl.org
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Major mke2fs slowdown (reproducable, bisected)
Message-ID: <20071112182526.GC11244@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cross-compile farm here migrated to .ccache and build dir on separate
disks and now I have a way to blow up .ccache without waiting half an
hour for rm(1) to finish. It's called mke2fs(8).

However, in e.g 2.6.24-rc2 mke2fs is amazingly slow if done right after
several fat cross-compile builds. Normally it takes ~11 seconds to
finish. After commit 5adc5be7cd1bcef6bb64f5255d2a33f20a3cf5be aka
"Bias the placement of kernel pages at lower PFNs" it takes several
minutes. 2.6.24-rc2 without this patch also gives normal mkfs speeds.
I'm pretty sure bisection wasn't screwed up.


Details:

	Core 2 Duo on x86_64, no debugging
	4G RAM
	30G ext2 .ccache partition with noatime
	100G ext2 partition with source tree and build dirs with noatime

I build alpha-allnoconfig, alpha-defconfig and 4 allmodconfigs
(SMP=y/n x DEBUG_KERNEL=y/n).

Right after compilation finishes, free(1) reports more or less the same
picture (VM hackers, please, tell me which info you need):

             total       used       free     shared    buffers     cached
Mem:       4032320    2802604    1229716          0      97160    2424816
-/+ buffers/cache:     280628    3751692
Swap:      7823644          0    7823644

Last steps of build script are:

	umount /home/ad/.ccache
	sudo mkfs.ext2 -m 0 	<=== this is slow

I can prepare standalone script with more affordable x86_64 configs if
needed.


commit 5adc5be7cd1bcef6bb64f5255d2a33f20a3cf5be
Author: Mel Gorman <mel@csn.ul.ie>
Date:   Tue Oct 16 01:25:54 2007 -0700

    Bias the placement of kernel pages at lower PFNs
    
    This patch chooses blocks with lower PFNs when placing kernel allocations.
    This is particularly important during fallback in low memory situations to
    stop unmovable pages being placed throughout the entire address space.
    
    Signed-off-by: Mel Gorman <mel@csn.ul.ie>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 676aec9..e1d87ee 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -765,6 +765,23 @@ int move_freepages_block(struct zone *zone, struct page *page, int migratetype)
 	return move_freepages(zone, start_page, end_page, migratetype);
 }
 
+/* Return the page with the lowest PFN in the list */
+static struct page *min_page(struct list_head *list)
+{
+	unsigned long min_pfn = -1UL;
+	struct page *min_page = NULL, *page;;
+
+	list_for_each_entry(page, list, lru) {
+		unsigned long pfn = page_to_pfn(page);
+		if (pfn < min_pfn) {
+			min_pfn = pfn;
+			min_page = page;
+		}
+	}
+
+	return min_page;
+}
+
 /* Remove an element from the buddy allocator from the fallback list */
 static struct page *__rmqueue_fallback(struct zone *zone, int order,
 						int start_migratetype)
@@ -795,8 +812,11 @@ retry:
 			if (list_empty(&area->free_list[migratetype]))
 				continue;
 
+			/* Bias kernel allocations towards low pfns */
 			page = list_entry(area->free_list[migratetype].next,
 					struct page, lru);
+			if (unlikely(start_migratetype != MIGRATE_MOVABLE))
+				page = min_page(&area->free_list[migratetype]);
 			area->nr_free--;
 
 			/*
