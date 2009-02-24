Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZBXMUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZBXMUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbZBXMRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:17:20 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39121 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261AbZBXMRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:17:16 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 08/19] Simplify the check on whether cpusets are a factor or not
Date: Tue, 24 Feb 2009 12:17:04 +0000
Message-Id: <1235477835-14500-9-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235477835-14500-1-git-send-email-mel@csn.ul.ie>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check whether cpuset contraints need to be checked or not is complex
and often repeated.  This patch makes the check in advance to the comparison
is simplier to compute.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/cpuset.h |    2 ++
 mm/page_alloc.c        |   13 +++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 90c6074..6051082 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -83,6 +83,8 @@ extern void cpuset_print_task_mems_allowed(struct task_struct *p);
 
 #else /* !CONFIG_CPUSETS */
 
+#define number_of_cpusets (0)
+
 static inline int cpuset_init_early(void) { return 0; }
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 503d692..405cd8c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1136,7 +1136,11 @@ failed:
 #define ALLOC_WMARK_HIGH	0x08 /* use pages_high watermark */
 #define ALLOC_HARDER		0x10 /* try to alloc harder */
 #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
+#ifdef CONFIG_CPUSETS
 #define ALLOC_CPUSET		0x40 /* check for correct cpuset */
+#else
+#define ALLOC_CPUSET		0x00
+#endif /* CONFIG_CPUSETS */
 
 #ifdef CONFIG_FAIL_PAGE_ALLOC
 
@@ -1400,6 +1404,7 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 	nodemask_t *allowednodes = NULL;/* zonelist_cache approximation */
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
+	int alloc_cpuset = 0;
 
 	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
 							&preferred_zone);
@@ -1410,6 +1415,10 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 
 	VM_BUG_ON(order >= MAX_ORDER);
 
+	/* Determine in advance if the cpuset checks will be needed */
+	if ((alloc_flags & ALLOC_CPUSET) && unlikely(number_of_cpusets > 1))
+		alloc_cpuset = 1;
+
 zonelist_scan:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
@@ -1420,8 +1429,8 @@ zonelist_scan:
 		if (NUMA_BUILD && zlc_active &&
 			!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
-		if ((alloc_flags & ALLOC_CPUSET) &&
-			!cpuset_zone_allowed_softwall(zone, gfp_mask))
+		if (alloc_cpuset)
+			if (!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				goto try_next_zone;
 
 		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
-- 
1.5.6.5

