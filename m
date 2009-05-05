Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbZEEJeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbZEEJeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 05:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZEEJeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 05:34:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42944 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbZEEJeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 05:34:07 -0400
Date: Tue, 5 May 2009 11:33:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20090505093355.GA10122@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
H Hartley Sweeten (1):
      kernel/posix-cpu-timers.c: fix sparse warning

Joerg Roedel (1):
      dma-debug: remove broken dma memory leak detection for 2.6.30

Ming Lei (1):
      locking: Documentation: lockdep-design.txt, fix note of state bits


 Documentation/lockdep-design.txt |    6 ++--
 kernel/posix-cpu-timers.c        |    8 +++---
 lib/dma-debug.c                  |   53 +-------------------------------------
 3 files changed, 8 insertions(+), 59 deletions(-)

diff --git a/Documentation/lockdep-design.txt b/Documentation/lockdep-design.txt
index 938ea22..e20d913 100644
--- a/Documentation/lockdep-design.txt
+++ b/Documentation/lockdep-design.txt
@@ -54,9 +54,9 @@ locking error messages, inside curlies. A contrived example:
 The bit position indicates STATE, STATE-read, for each of the states listed
 above, and the character displayed in each indicates:
 
-   '.'  acquired while irqs disabled
-   '+'  acquired in irq context
-   '-'  acquired with irqs enabled
+   '.'  acquired while irqs disabled and not in irq context
+   '-'  acquired in irq context
+   '+'  acquired with irqs enabled
    '?'  acquired in irq context with irqs enabled.
 
 Unused mutexes cannot be part of the cause of an error.
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c9dcf98..bece7c0 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1420,19 +1420,19 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	 * timer call will interfere.
 	 */
 	list_for_each_entry_safe(timer, next, &firing, it.cpu.entry) {
-		int firing;
+		int cpu_firing;
+
 		spin_lock(&timer->it_lock);
 		list_del_init(&timer->it.cpu.entry);
-		firing = timer->it.cpu.firing;
+		cpu_firing = timer->it.cpu.firing;
 		timer->it.cpu.firing = 0;
 		/*
 		 * The firing flag is -1 if we collided with a reset
 		 * of the timer, which already reported this
 		 * almost-firing as an overrun.  So don't generate an event.
 		 */
-		if (likely(firing >= 0)) {
+		if (likely(cpu_firing >= 0))
 			cpu_timer_fire(timer);
-		}
 		spin_unlock(&timer->it_lock);
 	}
 }
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index d3da7ed..69da09a 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -400,60 +400,9 @@ out_err:
 	return -ENOMEM;
 }
 
-static int device_dma_allocations(struct device *dev)
-{
-	struct dma_debug_entry *entry;
-	unsigned long flags;
-	int count = 0, i;
-
-	for (i = 0; i < HASH_SIZE; ++i) {
-		spin_lock_irqsave(&dma_entry_hash[i].lock, flags);
-		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
-			if (entry->dev == dev)
-				count += 1;
-		}
-		spin_unlock_irqrestore(&dma_entry_hash[i].lock, flags);
-	}
-
-	return count;
-}
-
-static int dma_debug_device_change(struct notifier_block *nb,
-				    unsigned long action, void *data)
-{
-	struct device *dev = data;
-	int count;
-
-
-	switch (action) {
-	case BUS_NOTIFY_UNBIND_DRIVER:
-		count = device_dma_allocations(dev);
-		if (count == 0)
-			break;
-		err_printk(dev, NULL, "DMA-API: device driver has pending "
-				"DMA allocations while released from device "
-				"[count=%d]\n", count);
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
 void dma_debug_add_bus(struct bus_type *bus)
 {
-	struct notifier_block *nb;
-
-	nb = kzalloc(sizeof(struct notifier_block), GFP_KERNEL);
-	if (nb == NULL) {
-		printk(KERN_ERR "dma_debug_add_bus: out of memory\n");
-		return;
-	}
-
-	nb->notifier_call = dma_debug_device_change;
-
-	bus_register_notifier(bus, nb);
+	/* FIXME: register notifier */
 }
 
 /*
