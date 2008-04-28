Return-Path: <linux-kernel-owner+w=401wt.eu-S966403AbYD1Uhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966403AbYD1Uhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934753AbYD1Uhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:37:31 -0400
Received: from www.tglx.de ([62.245.132.106]:33096 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934590AbYD1Uh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:37:29 -0400
Date: Mon, 28 Apr 2008 22:36:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [GTI pull] hrtimer fixes
Message-ID: <alpine.LFD.1.10.0804282234040.3261@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull hrtimer fixes from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master

Fix for a potential deadlock which was introduced with the scheduler
hrtimer changes in .25.

Thanks,
	tglx

---
Thomas Gleixner (1):
      hrtimer: raise softirq unlocked to avoid circular lock dependency

 kernel/hrtimer.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e379ef0..dea4c91 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -590,7 +590,6 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 			list_add_tail(&timer->cb_entry,
 				      &base->cpu_base->cb_pending);
 			timer->state = HRTIMER_STATE_PENDING;
-			raise_softirq(HRTIMER_SOFTIRQ);
 			return 1;
 		default:
 			BUG();
@@ -633,6 +632,11 @@ static int hrtimer_switch_to_hres(void)
 	return 1;
 }
 
+static inline void hrtimer_raise_softirq(void)
+{
+	raise_softirq(HRTIMER_SOFTIRQ);
+}
+
 #else
 
 static inline int hrtimer_hres_active(void) { return 0; }
@@ -651,6 +655,7 @@ static inline int hrtimer_reprogram(struct hrtimer *timer,
 {
 	return 0;
 }
+static inline void hrtimer_raise_softirq(void) { }
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
@@ -850,7 +855,7 @@ hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
 {
 	struct hrtimer_clock_base *base, *new_base;
 	unsigned long flags;
-	int ret;
+	int ret, raise;
 
 	base = lock_hrtimer_base(timer, &flags);
 
@@ -884,8 +889,18 @@ hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
 	enqueue_hrtimer(timer, new_base,
 			new_base->cpu_base == &__get_cpu_var(hrtimer_bases));
 
+	/*
+	 * The timer may be expired and moved to the cb_pending
+	 * list. We can not raise the softirq with base lock held due
+	 * to a possible deadlock with runqueue lock.
+	 */
+	raise = timer->state == HRTIMER_STATE_PENDING;
+
 	unlock_hrtimer_base(timer, &flags);
 
+	if (raise)
+		hrtimer_raise_softirq();
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hrtimer_start);
