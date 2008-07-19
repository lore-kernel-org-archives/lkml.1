Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbYGSMd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbYGSMd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbYGSMdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:33:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35483 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbYGSMdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:33:17 -0400
Date: Sat, 19 Jul 2008 15:33:05 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, riel@redhat.com
Subject: [PATCH 8/8] slub: add defrag statistics
Message-ID: <Pine.LNX.4.64.0807191532450.13345@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>

Add statistics counters for slab defragmentation.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 Documentation/vm/slabinfo.c |   45 +++++++++++++++++++++++++++++++++++-------
 include/linux/slub_def.h    |    6 +++++
 mm/slub.c                   |   29 +++++++++++++++++++++++++-
 3 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/Documentation/vm/slabinfo.c b/Documentation/vm/slabinfo.c
index 05c6c44..8336739 100644
--- a/Documentation/vm/slabinfo.c
+++ b/Documentation/vm/slabinfo.c
@@ -41,6 +41,9 @@ struct slabinfo {
 	unsigned long cpuslab_flush, deactivate_full, deactivate_empty;
 	unsigned long deactivate_to_head, deactivate_to_tail;
 	unsigned long deactivate_remote_frees, order_fallback;
+	unsigned long shrink_calls, shrink_attempt_defrag, shrink_empty_slab;
+	unsigned long shrink_slab_skipped, shrink_slab_reclaimed;
+	unsigned long shrink_object_reclaim_failed;
 	int numa[MAX_NODES];
 	int numa_partial[MAX_NODES];
 } slabinfo[MAX_SLABS];
@@ -79,6 +82,7 @@ int sort_active = 0;
 int set_debug = 0;
 int show_ops = 0;
 int show_activity = 0;
+int show_defragcount = 0;
 
 /* Debug options */
 int sanity = 0;
@@ -113,6 +117,7 @@ void usage(void)
 		"-e|--empty             Show empty slabs\n"
 		"-f|--first-alias       Show first alias\n"
 		"-F|--defrag            Show defragmentable caches\n"
+		"-G:--display-defrag    Display defrag counters\n"
 		"-h|--help              Show usage information\n"
 		"-i|--inverted          Inverted list\n"
 		"-l|--slabs             Show slabs\n"
@@ -300,6 +305,8 @@ void first_line(void)
 {
 	if (show_activity)
 		printf("Name                   Objects      Alloc       Free   %%Fast Fallb O\n");
+	else if (show_defragcount)
+		printf("Name                   Objects DefragRQ  Slabs Success   Empty Skipped  Failed\n");
 	else
 		printf("Name                   Objects Objsize    Space "
 			"Slabs/Part/Cpu  O/S O %%Ra %%Ef Flg\n");
@@ -466,22 +473,28 @@ void slab_stats(struct slabinfo *s)
 
 	printf("Total                %8lu %8lu\n\n", total_alloc, total_free);
 
-	if (s->cpuslab_flush)
-		printf("Flushes %8lu\n", s->cpuslab_flush);
-
-	if (s->alloc_refill)
-		printf("Refill %8lu\n", s->alloc_refill);
+	if (s->cpuslab_flush || s->alloc_refill)
+		printf("CPU Slab  : Flushes=%lu Refills=%lu\n",
+			s->cpuslab_flush, s->alloc_refill);
 
 	total = s->deactivate_full + s->deactivate_empty +
 			s->deactivate_to_head + s->deactivate_to_tail;
 
 	if (total)
-		printf("Deactivate Full=%lu(%lu%%) Empty=%lu(%lu%%) "
+		printf("Deactivate: Full=%lu(%lu%%) Empty=%lu(%lu%%) "
 			"ToHead=%lu(%lu%%) ToTail=%lu(%lu%%)\n",
 			s->deactivate_full, (s->deactivate_full * 100) / total,
 			s->deactivate_empty, (s->deactivate_empty * 100) / total,
 			s->deactivate_to_head, (s->deactivate_to_head * 100) / total,
 			s->deactivate_to_tail, (s->deactivate_to_tail * 100) / total);
+
+	if (s->shrink_calls)
+		printf("Shrink    : Calls=%lu Attempts=%lu Empty=%lu Successful=%lu\n",
+			s->shrink_calls, s->shrink_attempt_defrag,
+			s->shrink_empty_slab, s->shrink_slab_reclaimed);
+	if (s->shrink_slab_skipped || s->shrink_object_reclaim_failed)
+		printf("Defrag    : Slabs skipped=%lu Object reclaim failed=%lu\n",
+		s->shrink_slab_skipped, s->shrink_object_reclaim_failed);
 }
 
 void report(struct slabinfo *s)
@@ -598,7 +611,12 @@ void slabcache(struct slabinfo *s)
 			total_alloc ? (s->alloc_fastpath * 100 / total_alloc) : 0,
 			total_free ? (s->free_fastpath * 100 / total_free) : 0,
 			s->order_fallback, s->order);
-	}
+	} else
+	if (show_defragcount)
+		printf("%-21s %8ld %7d %7d %7d %7d %7d %7d\n",
+			s->name, s->objects, s->shrink_calls, s->shrink_attempt_defrag,
+			s->shrink_slab_reclaimed, s->shrink_empty_slab,
+			s->shrink_slab_skipped, s->shrink_object_reclaim_failed);
 	else
 		printf("%-21s %8ld %7d %8s %14s %4d %1d %3ld %3ld %s\n",
 			s->name, s->objects, s->object_size, size_str, dist_str,
@@ -1210,6 +1228,13 @@ void read_slab_dir(void)
 			slab->deactivate_to_tail = get_obj("deactivate_to_tail");
 			slab->deactivate_remote_frees = get_obj("deactivate_remote_frees");
 			slab->order_fallback = get_obj("order_fallback");
+			slab->shrink_calls = get_obj("shrink_calls");
+			slab->shrink_attempt_defrag = get_obj("shrink_attempt_defrag");
+			slab->shrink_empty_slab = get_obj("shrink_empty_slab");
+			slab->shrink_slab_skipped = get_obj("shrink_slab_skipped");
+			slab->shrink_slab_reclaimed = get_obj("shrink_slab_reclaimed");
+			slab->shrink_object_reclaim_failed =
+					get_obj("shrink_object_reclaim_failed");
 			slab->defrag_ratio = get_obj("defrag_ratio");
 			slab->remote_node_defrag_ratio =
 					get_obj("remote_node_defrag_ratio");
@@ -1274,6 +1299,7 @@ struct option opts[] = {
 	{ "ctor", 0, NULL, 'C' },
 	{ "debug", 2, NULL, 'd' },
 	{ "display-activity", 0, NULL, 'D' },
+	{ "display-defrag", 0, NULL, 'G' },
 	{ "empty", 0, NULL, 'e' },
 	{ "first-alias", 0, NULL, 'f' },
 	{ "defrag", 0, NULL, 'F' },
@@ -1299,7 +1325,7 @@ int main(int argc, char *argv[])
 
 	page_size = getpagesize();
 
-	while ((c = getopt_long(argc, argv, "aACd::DefFhil1noprstvzTS",
+	while ((c = getopt_long(argc, argv, "aACd::DefFGhil1noprstvzTS",
 						opts, NULL)) != -1)
 		switch (c) {
 		case '1':
@@ -1325,6 +1351,9 @@ int main(int argc, char *argv[])
 		case 'f':
 			show_first_alias = 1;
 			break;
+		case 'G':
+			show_defragcount = 1;
+			break;
 		case 'h':
 			usage();
 			return 0;
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 8b1b6cd..dd25af2 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -30,6 +30,12 @@ enum stat_item {
 	DEACTIVATE_TO_TAIL,	/* Cpu slab was moved to the tail of partials */
 	DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects */
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
+	SHRINK_CALLS,		/* Number of invocations of kmem_cache_shrink */
+	SHRINK_ATTEMPT_DEFRAG,	/* Slabs that were attempted to be reclaimed */
+	SHRINK_EMPTY_SLAB,	/* Shrink encountered and freed empty slab */
+	SHRINK_SLAB_SKIPPED,	/* Slab reclaim skipped an slab (busy etc) */
+	SHRINK_SLAB_RECLAIMED,	/* Successfully reclaimed slabs */
+	SHRINK_OBJECT_RECLAIM_FAILED, /* Callbacks signaled busy objects */
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {
diff --git a/mm/slub.c b/mm/slub.c
index b768183..3b8e66d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2835,6 +2835,7 @@ static int kmem_cache_vacate(struct page *page, void *scratch)
 	void *private;
 	unsigned long flags;
 	unsigned long objects;
+	struct kmem_cache_cpu *c;
 
 	local_irq_save(flags);
 	slab_lock(page);
@@ -2845,8 +2846,11 @@ static int kmem_cache_vacate(struct page *page, void *scratch)
 	s = page->slab;
 	objects = page->objects;
 	map = scratch + objects * sizeof(void **);
-	if (!page->inuse || !s->kick || !PageSlabKickable(page))
+	if (!page->inuse || !s->kick || !PageSlabKickable(page)) {
+		c = get_cpu_slab(s, smp_processor_id());
+		stat(c, SHRINK_SLAB_SKIPPED);
 		goto out;
+	}
 
 	/* Determine used objects */
 	bitmap_fill(map, objects);
@@ -2883,9 +2887,13 @@ out:
 	 * Check the result and unfreeze the slab
 	 */
 	leftover = page->inuse;
-	if (leftover)
+	c = get_cpu_slab(s, smp_processor_id());
+	if (leftover) {
 		/* Unsuccessful reclaim. Avoid future reclaim attempts. */
+		stat(c, SHRINK_OBJECT_RECLAIM_FAILED);
 		ClearPageSlabKickable(page);
+	} else
+		stat(c, SHRINK_SLAB_RECLAIMED);
 	unfreeze_slab(s, page, leftover > 0);
 	local_irq_restore(flags);
 	return leftover;
@@ -2936,11 +2944,14 @@ static unsigned long __kmem_cache_shrink(struct kmem_cache *s, int node,
 	LIST_HEAD(zaplist);
 	int freed = 0;
 	struct kmem_cache_node *n = get_node(s, node);
+	struct kmem_cache_cpu *c;
 
 	if (n->nr_partial <= limit)
 		return 0;
 
 	spin_lock_irqsave(&n->list_lock, flags);
+	c = get_cpu_slab(s, smp_processor_id());
+	stat(c, SHRINK_CALLS);
 	list_for_each_entry_safe(page, page2, &n->partial, lru) {
 		if (!slab_trylock(page))
 			/* Busy slab. Get out of the way */
@@ -2960,12 +2971,14 @@ static unsigned long __kmem_cache_shrink(struct kmem_cache *s, int node,
 
 			list_move(&page->lru, &zaplist);
 			if (s->kick) {
+				stat(c, SHRINK_ATTEMPT_DEFRAG);
 				n->nr_partial--;
 				SetSlabFrozen(page);
 			}
 			slab_unlock(page);
 		} else {
 			/* Empty slab page */
+			stat(c, SHRINK_EMPTY_SLAB);
 			list_del(&page->lru);
 			n->nr_partial--;
 			slab_unlock(page);
@@ -4395,6 +4408,12 @@ STAT_ATTR(DEACTIVATE_TO_HEAD, deactivate_to_head);
 STAT_ATTR(DEACTIVATE_TO_TAIL, deactivate_to_tail);
 STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
+STAT_ATTR(SHRINK_CALLS, shrink_calls);
+STAT_ATTR(SHRINK_ATTEMPT_DEFRAG, shrink_attempt_defrag);
+STAT_ATTR(SHRINK_EMPTY_SLAB, shrink_empty_slab);
+STAT_ATTR(SHRINK_SLAB_SKIPPED, shrink_slab_skipped);
+STAT_ATTR(SHRINK_SLAB_RECLAIMED, shrink_slab_reclaimed);
+STAT_ATTR(SHRINK_OBJECT_RECLAIM_FAILED, shrink_object_reclaim_failed);
 #endif
 
 static struct attribute *slab_attrs[] = {
@@ -4449,6 +4468,12 @@ static struct attribute *slab_attrs[] = {
 	&deactivate_to_tail_attr.attr,
 	&deactivate_remote_frees_attr.attr,
 	&order_fallback_attr.attr,
+	&shrink_calls_attr.attr,
+	&shrink_attempt_defrag_attr.attr,
+	&shrink_empty_slab_attr.attr,
+	&shrink_slab_skipped_attr.attr,
+	&shrink_slab_reclaimed_attr.attr,
+	&shrink_object_reclaim_failed_attr.attr,
 #endif
 	NULL
 };
-- 
1.5.4.3

