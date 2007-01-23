Return-Path: <linux-kernel-owner+w=401wt.eu-S965518AbXAWWKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965518AbXAWWKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965505AbXAWWJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:09:38 -0500
Received: from www.osadl.org ([213.239.205.134]:35889 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965498AbXAWWBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:09 -0500
Message-Id: <20070123211207.046787000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 27/46] hrtimers: clean up callback tracking
Content-Disposition: inline; filename=hrtimers-clean-up-callback-tracking.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Reintroduce ktimers feature "optimized away" by the ktimers review
process: remove the curr_timer pointer from the cpu-base and use the
hrtimer state.

No functional changes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hrtimer.h |    1 -
 kernel/hrtimer.c        |   10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/include/linux/hrtimer.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/hrtimer.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/hrtimer.h
@@ -136,7 +136,6 @@ struct hrtimer_cpu_base {
 	spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
-	struct hrtimer			*curr_timer;
 };
 
 /*
Index: linux-2.6.20-rc4-mm1-bo/kernel/hrtimer.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/hrtimer.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/hrtimer.c
@@ -172,8 +172,6 @@ static inline int hrtimer_callback_runni
  */
 #ifdef CONFIG_SMP
 
-#define set_curr_timer(b, t)		do { (b)->curr_timer = (t); } while (0)
-
 /*
  * We are using hashed locking: holding per_cpu(hrtimer_bases)[n].lock
  * means that all timers which are tied to this base via timer->base are
@@ -227,7 +225,7 @@ switch_hrtimer_base(struct hrtimer *time
 		 * completed. There is no conflict as we hold the lock until
 		 * the timer is enqueued.
 		 */
-		if (unlikely(base->cpu_base->curr_timer == timer))
+		if (unlikely(timer->state & HRTIMER_STATE_CALLBACK))
 			return base;
 
 		/* See the comment in lock_timer_base() */
@@ -241,8 +239,6 @@ switch_hrtimer_base(struct hrtimer *time
 
 #else /* CONFIG_SMP */
 
-#define set_curr_timer(b, t)		do { } while (0)
-
 static inline struct hrtimer_clock_base *
 lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 {
@@ -670,7 +666,6 @@ static inline void run_hrtimer_queue(str
 			break;
 
 		fn = timer->function;
-		set_curr_timer(cpu_base, timer);
 		__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK);
 		spin_unlock_irq(&cpu_base->lock);
 
@@ -684,7 +679,6 @@ static inline void run_hrtimer_queue(str
 			enqueue_hrtimer(timer, base);
 		}
 	}
-	set_curr_timer(cpu_base, NULL);
 	spin_unlock_irq(&cpu_base->lock);
 }
 
@@ -871,8 +865,6 @@ static void migrate_hrtimers(int cpu)
 	spin_lock(&old_base->lock);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
-		BUG_ON(old_base->curr_timer);
-
 		migrate_hrtimer_list(&old_base->clock_base[i],
 				     &new_base->clock_base[i]);
 	}

--

