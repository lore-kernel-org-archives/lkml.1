Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbXI0TwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbXI0TwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXI0Tvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:51:52 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:48493 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbXI0Tvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:51:51 -0400
Date: Thu, 27 Sep 2007 20:51:14 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: [PATCH mm 3/3] move_tail_pages into lru_add_drain
In-Reply-To: <Pine.LNX.4.64.0709272045180.19737@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0709272049440.19737@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0709272045180.19737@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

a.k.a. mm-use-pagevec-to-rotate-reclaimable-page-cleanup-2.patch

Opinions may differ, but I'm uneasy with leaving pages to be rotated on
their pagevecs for too long: although they're still visible via the LRU,
their page counts are raised, which excludes them from some operations.

Memory hotplug and page migration clearly want to be draining them:
but rather than add move_tail_pages calls in various places, won't we
be safer just to drain them whenever we drain the lru_add pagevecs?

So merge move_tail_pages into __lru_add_drain, which lets us remove
cpu_movetail_callback.  Rename __lru_add_drain to drain_cpu_pagevecs,
and correct the misleading "CPU is dead" comment found there.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
You may disagree with this one, or your unease with these rotation
patches may have grown to the point that you want to back them all out:
I've no strong feeling on it - it was a good idea to try to batch them,
but has turned out to be more complicated than was foreseen.

 include/linux/swap.h |    1 
 mm/swap.c            |   65 +++++++++++++++--------------------------
 mm/vmscan.c          |    1 
 3 files changed, 25 insertions(+), 42 deletions(-)

--- 2.6.23-rc8-mm2/include/linux/swap.h	2007-09-27 11:28:37.000000000 +0100
+++ linux/include/linux/swap.h	2007-09-27 17:51:49.000000000 +0100
@@ -181,7 +181,6 @@ extern void FASTCALL(mark_page_accessed(
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
 extern int rotate_reclaimable_page(struct page *page);
-extern void move_tail_pages(void);
 extern void swap_setup(void);
 
 /* linux/mm/vmscan.c */
--- 2.6.23-rc8-mm2/mm/swap.c	2007-09-27 17:51:33.000000000 +0100
+++ linux/mm/swap.c	2007-09-27 17:51:49.000000000 +0100
@@ -34,6 +34,10 @@
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
 
+static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs) = { 0, };
+
 /*
  * This path almost never happens for VM activity - pages are normally
  * freed via pagevecs.  But it gets used by networking.
@@ -125,20 +129,6 @@ static void pagevec_move_tail(struct pag
 	pagevec_reinit(pvec);
 }
 
-static DEFINE_PER_CPU(struct pagevec, rotate_pvecs) = { 0, };
-
-void move_tail_pages(void)
-{
-	unsigned long flags;
-	struct pagevec *pvec;
-
-	local_irq_save(flags);
-	pvec = &__get_cpu_var(rotate_pvecs);
-	if (pagevec_count(pvec))
-		pagevec_move_tail(pvec);
-	local_irq_restore(flags);
-}
-
 /*
  * Writeback is about to end against a page which has been marked for immediate
  * reclaim.  If it still appears to be reclaimable, move it to the tail of the
@@ -214,9 +204,6 @@ EXPORT_SYMBOL(mark_page_accessed);
  * lru_cache_add: add a page to the page lists
  * @page: the page to add
  */
-static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
-static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
-
 void fastcall lru_cache_add(struct page *page)
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_pvecs);
@@ -237,21 +224,37 @@ void fastcall lru_cache_add_active(struc
 	put_cpu_var(lru_add_active_pvecs);
 }
 
-static void __lru_add_drain(int cpu)
+/*
+ * Drain pages out of the cpu's pagevecs.
+ * Either "cpu" is the current CPU, and preemption has already been
+ * disabled; or "cpu" is being hot-unplugged, and is already dead.
+ */
+static void drain_cpu_pagevecs(int cpu)
 {
-	struct pagevec *pvec = &per_cpu(lru_add_pvecs, cpu);
+	struct pagevec *pvec;
 
-	/* CPU is dead, so no locking needed. */
+	pvec = &per_cpu(lru_add_pvecs, cpu);
 	if (pagevec_count(pvec))
 		__pagevec_lru_add(pvec);
+
 	pvec = &per_cpu(lru_add_active_pvecs, cpu);
 	if (pagevec_count(pvec))
 		__pagevec_lru_add_active(pvec);
+
+	pvec = &per_cpu(lru_rotate_pvecs, cpu);
+	if (pagevec_count(pvec)) {
+		unsigned long flags;
+
+		/* No harm done if a racing interrupt already did this */
+		local_irq_save(flags);
+		pagevec_move_tail(pvec);
+		local_irq_restore(flags);
+	}
 }
 
 void lru_add_drain(void)
 {
-	__lru_add_drain(get_cpu());
+	drain_cpu_pagevecs(get_cpu());
 	put_cpu();
 }
 
@@ -533,25 +536,8 @@ static int cpu_swap_callback(struct noti
 	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
 		atomic_add(*committed, &vm_committed_space);
 		*committed = 0;
-		__lru_add_drain((long)hcpu);
-	}
-	return NOTIFY_OK;
-}
-
-static int cpu_movetail_callback(struct notifier_block *nfb,
-				 unsigned long action, void *hcpu)
-{
-	unsigned long flags;
-	struct pagevec *pvec;
-
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		local_irq_save(flags);
-		pvec = &per_cpu(rotate_pvecs, (long)hcpu);
-		if (pagevec_count(pvec))
-			pagevec_move_tail(pvec);
-		local_irq_restore(flags);
+		drain_cpu_pagevecs((long)hcpu);
 	}
-
 	return NOTIFY_OK;
 }
 #endif /* CONFIG_HOTPLUG_CPU */
@@ -579,6 +565,5 @@ void __init swap_setup(void)
 	 */
 #ifdef CONFIG_HOTPLUG_CPU
 	hotcpu_notifier(cpu_swap_callback, 0);
-	hotcpu_notifier(cpu_movetail_callback, 0);
 #endif
 }
--- 2.6.23-rc8-mm2/mm/vmscan.c	2007-09-27 11:28:39.000000000 +0100
+++ linux/mm/vmscan.c	2007-09-27 17:51:49.000000000 +0100
@@ -824,7 +824,6 @@ static unsigned long shrink_inactive_lis
 
 	pagevec_init(&pvec, 1);
 
-	move_tail_pages();
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
 	do {
