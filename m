Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbZIOPTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbZIOPTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZIOPTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:19:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:48709 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696AbZIOPTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:19:23 -0400
Date: Tue, 15 Sep 2009 15:19:05 GMT
From: tip-bot for Ashwin Chaugule <ashwinc@quicinc.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ashwinc@quicinc.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ashwinc@quicinc.com
In-Reply-To: <4AA00165.90609@codeaurora.org>
References: <4AA00165.90609@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] hrtimer: Eliminate needless reprogramming of clock events device
Message-ID: <tip-7403f41f19574d6805197e9b97dfa7592003be10@git.kernel.org>
Git-Commit-ID: 7403f41f19574d6805197e9b97dfa7592003be10
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 15:19:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7403f41f19574d6805197e9b97dfa7592003be10
Gitweb:     http://git.kernel.org/tip/7403f41f19574d6805197e9b97dfa7592003be10
Author:     Ashwin Chaugule <ashwinc@quicinc.com>
AuthorDate: Tue, 1 Sep 2009 23:03:33 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 15 Sep 2009 17:09:44 +0200

hrtimer: Eliminate needless reprogramming of clock events device

On NOHZ systems the following timers,

-  tick_nohz_restart_sched_tick (tick_sched_timer)
-  hrtimer_start (tick_sched_timer)

are reprogramming the clock events device far more often than needed.
No specific test case was required to observe this effect. This
occurres because there was no check to see if the currently removed or
restarted hrtimer was:

1) the one which previously armed the clock events device.
2) going to be replaced by another timer which has the same expiry time.

Avoid the reprogramming in hrtimer_force_reprogram when the new expiry
value which is evaluated from the clock bases is equal to
cpu_base->expires_next. This results in faster application startup
time by ~4%.

[ tglx: simplified initial solution ]

Signed-off-by: Ashwin Chaugule <ashwinc@quicinc.com>
LKML-Reference: <4AA00165.90609@codeaurora.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/hrtimer.c |   53 +++++++++++++++++++++++++++++++++++------------------
 1 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e2f91ec..1363c1a 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -486,13 +486,14 @@ static inline int hrtimer_hres_active(void)
  * next event
  * Called with interrupts disabled and base->lock held
  */
-static void hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base)
+static void
+hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 {
 	int i;
 	struct hrtimer_clock_base *base = cpu_base->clock_base;
-	ktime_t expires;
+	ktime_t expires, expires_next;
 
-	cpu_base->expires_next.tv64 = KTIME_MAX;
+	expires_next.tv64 = KTIME_MAX;
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
 		struct hrtimer *timer;
@@ -508,10 +509,15 @@ static void hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base)
 		 */
 		if (expires.tv64 < 0)
 			expires.tv64 = 0;
-		if (expires.tv64 < cpu_base->expires_next.tv64)
-			cpu_base->expires_next = expires;
+		if (expires.tv64 < expires_next.tv64)
+			expires_next = expires;
 	}
 
+	if (skip_equal && expires_next.tv64 == cpu_base->expires_next.tv64)
+		return;
+
+	cpu_base->expires_next.tv64 = expires_next.tv64;
+
 	if (cpu_base->expires_next.tv64 != KTIME_MAX)
 		tick_program_event(cpu_base->expires_next, 1);
 }
@@ -594,7 +600,7 @@ static void retrigger_next_event(void *arg)
 	base->clock_base[CLOCK_REALTIME].offset =
 		timespec_to_ktime(realtime_offset);
 
-	hrtimer_force_reprogram(base);
+	hrtimer_force_reprogram(base, 0);
 	spin_unlock(&base->lock);
 }
 
@@ -707,7 +713,8 @@ static int hrtimer_switch_to_hres(void)
 static inline int hrtimer_hres_active(void) { return 0; }
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
 static inline int hrtimer_switch_to_hres(void) { return 0; }
-static inline void hrtimer_force_reprogram(struct hrtimer_cpu_base *base) { }
+static inline void
+hrtimer_force_reprogram(struct hrtimer_cpu_base *base, int skip_equal) { }
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 					    struct hrtimer_clock_base *base,
 					    int wakeup)
@@ -850,19 +857,29 @@ static void __remove_hrtimer(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base,
 			     unsigned long newstate, int reprogram)
 {
-	if (timer->state & HRTIMER_STATE_ENQUEUED) {
-		/*
-		 * Remove the timer from the rbtree and replace the
-		 * first entry pointer if necessary.
-		 */
-		if (base->first == &timer->node) {
-			base->first = rb_next(&timer->node);
-			/* Reprogram the clock event device. if enabled */
-			if (reprogram && hrtimer_hres_active())
-				hrtimer_force_reprogram(base->cpu_base);
+	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
+		goto out;
+
+	/*
+	 * Remove the timer from the rbtree and replace the first
+	 * entry pointer if necessary.
+	 */
+	if (base->first == &timer->node) {
+		base->first = rb_next(&timer->node);
+#ifdef CONFIG_HIGH_RES_TIMERS
+		/* Reprogram the clock event device. if enabled */
+		if (reprogram && hrtimer_hres_active()) {
+			ktime_t expires;
+
+			expires = ktime_sub(hrtimer_get_expires(timer),
+					    base->offset);
+			if (base->cpu_base->expires_next.tv64 == expires.tv64)
+				hrtimer_force_reprogram(base->cpu_base, 1);
 		}
-		rb_erase(&timer->node, &base->active);
+#endif
 	}
+	rb_erase(&timer->node, &base->active);
+out:
 	timer->state = newstate;
 }
 
