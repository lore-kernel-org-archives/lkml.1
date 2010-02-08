Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0BHQ4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 11:56:12 -0500
Received: from gir.skynet.ie ([193.1.99.77]:48710 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab0BHQ4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 11:56:09 -0500
Date: Mon, 8 Feb 2010 16:55:55 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, npiggin@suse.de
Subject: Re: Performance regression in scsi sequential throughput (iozone)
	due to "e084b - page-allocator: preserve PFN ordering when
	__GFP_COLD is set"
Message-ID: <20100208165555.GD23680@csn.ul.ie>
References: <20091211112009.GC30670@csn.ul.ie> <4B225B9E.2020702@linux.vnet.ibm.com> <4B2B85C7.80502@linux.vnet.ibm.com> <20091218174250.GC21194@csn.ul.ie> <4B4F0E60.1020601@linux.vnet.ibm.com> <20100119113306.GA23881@csn.ul.ie> <4B6C3E6E.6050303@linux.vnet.ibm.com> <20100205174917.GB11512@csn.ul.ie> <4B70192C.3070601@linux.vnet.ibm.com> <20100208152131.GC23680@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100208152131.GC23680@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> <SNIP>
> The prototype patch for avoiding congestion_wait is below. I'll start
> work on a fallback-to-other-percpu-lists patch.
> 

And here is the prototype of the fallback-to-other-percpu-lists patch.
I'm afraid I've only managed to test it on qemu. My three test machines are
still occupied :(

==== CUT HERE ====
page allocator: Fallback to other per-cpu lists when the target list is empty and memory is low

When a per-cpu list of pages for a given migratetype is empty, the page
allocator is called to refill the PCP list. It's possible when memory
is low that this results in the process entering direct reclaim even
if it wasn't strictly necessary because there were pages free for other
migratetypes. Unconditionally falling back to other PCP lists hurts the
fragmentation-avoidance strategy which is also undesirable.

When the desired PCP list is empty, this patch checks how many free pages
there are on the PCP lists and if refilling the list could result in direct
reclaim. If direct reclaim is unlikely, the PCP list is refilled to maintain
fragmentation-avoidance. Otherwise, a page from an alternative PCP list is
chosen to maintain performance and avoid direct reclaim.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |   37 ++++++++++++++++++++++++++++++++++---
 1 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8deb9d0..009d683 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1168,6 +1168,39 @@ void split_page(struct page *page, unsigned int order)
 		set_page_refcounted(page + i);
 }
 
+/* Decide whether to find an alternative PCP list or refill */
+static struct list_head *pcp_fallback(struct zone *zone,
+			struct per_cpu_pages *pcp, 
+			int start_migratetype, int cold)
+{
+	int i;
+	int migratetype;
+	struct list_head *list;
+	long free_pages = zone_page_state(zone, NR_FREE_PAGES) - pcp->batch;
+
+	/* 
+	 * Find a PCPU list with free pages in the same order as
+	 * fragmentation-avoidance fallback in the event that refilling
+	 * the PCP list may result in direct reclaim
+	 */
+	if (pcp->count && free_pages <= low_wmark_pages(zone)) {
+		for (i = 0; i < MIGRATE_PCPTYPES - 1; i++) {
+			migratetype = fallbacks[start_migratetype][i];
+			list = &pcp->lists[migratetype];
+
+			if (!list_empty(list))
+				return list;
+		}
+	}
+
+	/* Alternatively, we need to allocate more memory to the PCP lists */
+	list = &pcp->lists[start_migratetype];
+	pcp->count += rmqueue_bulk(zone, 0, pcp->batch, list,
+					migratetype, cold);
+
+	return list;
+}
+
 /*
  * Really, prep_compound_page() should be called from __rmqueue_bulk().  But
  * we cheat by calling it from here, in the order > 0 path.  Saves a branch
@@ -1193,9 +1226,7 @@ again:
 		list = &pcp->lists[migratetype];
 		local_irq_save(flags);
 		if (list_empty(list)) {
-			pcp->count += rmqueue_bulk(zone, 0,
-					pcp->batch, list,
-					migratetype, cold);
+			list = pcp_fallback(zone, pcp, migratetype, cold);
 			if (unlikely(list_empty(list)))
 				goto failed;
 		}
