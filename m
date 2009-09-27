Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZI0Lez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZI0Lez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 07:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbZI0Lez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 07:34:55 -0400
Received: from www.tglx.de ([62.245.132.106]:41759 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbZI0Ley (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 07:34:54 -0400
Date: Sun, 27 Sep 2009 13:34:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer updates for 2.6.32
Message-ID: <alpine.LFD.2.00.0909271332480.2556@nanos>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus

Thanks,

	tglx

------------------>
Ashwin Chaugule (1):
      hrtimer: Eliminate needless reprogramming of clock events device


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
 
