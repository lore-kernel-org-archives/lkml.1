Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbZCPRxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbZCPRxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757328AbZCPRvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:51:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51216 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741AbZCPRv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:51:28 -0400
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
Subject: [PATCH 07/27] Check in advance if the zonelist needs additional filtering
Date: Mon, 16 Mar 2009 17:53:21 +0000
Message-Id: <1237226020-14057-8-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237226020-14057-1-git-send-email-mel@csn.ul.ie>
References: <1237226020-14057-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zonelist are filtered based on nodemasks for memory policies normally.
It can be additionally filters on cpusets if they exist as well as
noting when zones are full. These simple checks are expensive enough to
be noticed in profiles. This patch checks in advance if zonelist
filtering will ever be needed. If not, then the bulk of the checks are
skipped.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/cpuset.h |    2 ++
 mm/page_alloc.c        |   37 ++++++++++++++++++++++++++-----------
 2 files changed, 28 insertions(+), 11 deletions(-)

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
index d815c8f..fe71147 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1139,7 +1139,11 @@ failed:
 #define ALLOC_WMARK_HIGH	0x08 /* use pages_high watermark */
 #define ALLOC_HARDER		0x10 /* try to alloc harder */
 #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
+#ifdef CONFIG_CPUSETS
 #define ALLOC_CPUSET		0x40 /* check for correct cpuset */
+#else
+#define ALLOC_CPUSET		0x00
+#endif /* CONFIG_CPUSETS */
 
 #ifdef CONFIG_FAIL_PAGE_ALLOC
 
@@ -1403,6 +1407,7 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 	nodemask_t *allowednodes = NULL;/* zonelist_cache approximation */
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
+	int zonelist_filter = 0;
 
 	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
 							&preferred_zone);
@@ -1413,6 +1418,10 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 
 	VM_BUG_ON(order >= MAX_ORDER);
 
+	/* Determine in advance if the zonelist needs filtering */
+	if ((alloc_flags & ALLOC_CPUSET) && unlikely(number_of_cpusets > 1))
+		zonelist_filter = 1;
+
 zonelist_scan:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
@@ -1420,12 +1429,16 @@ zonelist_scan:
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						high_zoneidx, nodemask) {
-		if (NUMA_BUILD && zlc_active &&
-			!zlc_zone_worth_trying(zonelist, z, allowednodes))
-				continue;
-		if ((alloc_flags & ALLOC_CPUSET) &&
-			!cpuset_zone_allowed_softwall(zone, gfp_mask))
-				goto try_next_zone;
+
+		/* Ignore the additional zonelist filter checks if possible */
+		if (zonelist_filter) {
+			if (NUMA_BUILD && zlc_active &&
+				!zlc_zone_worth_trying(zonelist, z, allowednodes))
+					continue;
+			if ((alloc_flags & ALLOC_CPUSET) &&
+				!cpuset_zone_allowed_softwall(zone, gfp_mask))
+					goto try_next_zone;
+		}
 
 		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
 			unsigned long mark;
@@ -1447,13 +1460,15 @@ zonelist_scan:
 		if (page)
 			break;
 this_zone_full:
-		if (NUMA_BUILD)
+		if (NUMA_BUILD && zonelist_filter)
 			zlc_mark_zone_full(zonelist, z);
 try_next_zone:
-		if (NUMA_BUILD && !did_zlc_setup) {
-			/* we do zlc_setup after the first zone is tried */
-			allowednodes = zlc_setup(zonelist, alloc_flags);
-			zlc_active = 1;
+		if (NUMA_BUILD && zonelist_filter) {
+			if (!did_zlc_setup) {
+				/* do zlc_setup after the first zone is tried */
+				allowednodes = zlc_setup(zonelist, alloc_flags);
+				zlc_active = 1;
+			}
 			did_zlc_setup = 1;
 		}
 	}
-- 
1.5.6.5

