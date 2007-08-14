Return-Path: <linux-kernel-owner+w=401wt.eu-S1764371AbXHNPkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764371AbXHNPkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762507AbXHNPfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:35:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52223 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760402AbXHNPfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:35:06 -0400
Message-Id: <20070814153502.997795796@sgi.com>
References: <20070814153021.446917377@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Aug 2007 08:30:30 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 9/9] Testing: Perform GFP_ATOMIC overallocation
Content-Disposition: inline; filename=test_timer
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trigger a failure or reclaim by allocating large amounts of memory from the
timer interrupt.

This will show a protocol of what happened. F.e.

Timer: Excesssive Atomic allocs
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 96 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Atomically reclaimed 64 pages
Timer: Memory freed

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 kernel/timer.c |   30 ++++++++++++++++++++++++++++++
 mm/vmscan.c    |    4 ++++
 2 files changed, 34 insertions(+)

Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c	2007-08-14 07:43:21.000000000 -0700
+++ linux-2.6/kernel/timer.c	2007-08-14 07:43:22.000000000 -0700
@@ -817,6 +817,12 @@ unsigned long next_timer_interrupt(void)
 #endif
 
 /*
+ * Min freekbytes is 2m. 3000 pages give us 12M which is
+ * able to exhaust the reserves
+ */
+#define NR_TEST 3000
+
+/*
  * Called from the timer interrupt handler to charge one tick to the current 
  * process.  user_tick is 1 if the tick is user time, 0 for system.
  */
@@ -824,6 +830,9 @@ void update_process_times(int user_tick)
 {
 	struct task_struct *p = current;
 	int cpu = smp_processor_id();
+	struct page **base;
+	int i;
+	static unsigned long lasttime = 0;
 
 	/* Note: this timer irq context must be accounted for as well. */
 	if (user_tick)
@@ -835,6 +844,27 @@ void update_process_times(int user_tick)
 		rcu_check_callbacks(cpu, user_tick);
 	scheduler_tick();
 	run_posix_cpu_timers(p);
+
+	/* Every 2 minutes */
+	if (jiffies % (120 * HZ) == 0 && time_after(jiffies, lasttime)) {
+		printk(KERN_CRIT "Timer: Excesssive Atomic allocs\n");
+		/* Force memory to become exhausted */
+		base = kzalloc(NR_TEST * sizeof(void *), GFP_ATOMIC);
+
+		for (i = 0; i < NR_TEST; i++) {
+			base[i] = alloc_page(GFP_ATOMIC);
+			if (!base[i]) {
+				printk("Alloc failed at %d\n", i);
+				break;
+			}
+		}
+		for (i = 0; i < NR_TEST; i++)
+			if (base[i])
+				put_page(base[i]);
+		kfree(base);
+		printk(KERN_CRIT "Timer: Memory freed\n");
+		lasttime = jiffies;
+	}
 }
 
 /*
Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c	2007-08-14 07:53:17.000000000 -0700
+++ linux-2.6/mm/vmscan.c	2007-08-14 08:09:12.000000000 -0700
@@ -1232,6 +1232,10 @@ out:
 
 		zone->prev_priority = priority;
 	}
+
+	if (!(gfp_mask & __GFP_WAIT))
+		printk(KERN_WARNING "Atomically reclaimed %lu pages\n", nr_reclaimed);
+
 	return ret;
 }
 

-- 
