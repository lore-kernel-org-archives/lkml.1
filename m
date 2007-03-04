Return-Path: <linux-kernel-owner+w=401wt.eu-S1751653AbXCDNEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbXCDNEA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 08:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbXCDNEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 08:04:00 -0500
Received: from www.osadl.org ([213.239.205.134]:38196 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751649AbXCDNEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 08:04:00 -0500
Subject: [PATCH] highres: Do not run the TIMER_SOFTIRQ after switching to
	highres mode
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andres Salomon <dilinger@debian.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <45EAAA21.4040803@debian.org>
References: <45E8E2F8.1030102@debian.org>
	 <1172912540.24738.108.camel@localhost.localdomain>
	 <45EAAA21.4040803@debian.org>
Content-Type: text/plain
Date: Sun, 04 Mar 2007 14:09:54 +0100
Message-Id: <1173013794.24738.130.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The question is, how the tick timer gets enqueued in the softirq queue.
> > Can you isolate the codepath, where this happens ?

The TIMER_SOFTIRQ runs the hrtimers during bootup until a usable
clocksource and clock event sources are registered. The switch to high
resolution mode happens inside of the TIMER_SOFTIRQ, but runs the
softirq afterwards. That way the tick emulation timer, which was set up
in the switch to highres might be executed in the softirq context, which
is a BUG. The rbtree has not to be touched by the softirq after the
highres switch.

This BUG was observed by Andres Salomon, who provided the information to
debug it.

Return early from the softirq, when the switch was sucessful. 

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 476cb0c..b2dd223 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -540,19 +540,19 @@ static inline int hrtimer_enqueue_reprog
 /*
  * Switch to high resolution mode
  */
-static void hrtimer_switch_to_hres(void)
+static int hrtimer_switch_to_hres(void)
 {
 	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
 	unsigned long flags;
 
 	if (base->hres_active)
-		return;
+		return 1;
 
 	local_irq_save(flags);
 
 	if (tick_init_highres()) {
 		local_irq_restore(flags);
-		return;
+		return 0;
 	}
 	base->hres_active = 1;
 	base->clock_base[CLOCK_REALTIME].resolution = KTIME_HIGH_RES;
@@ -565,13 +565,14 @@ static void hrtimer_switch_to_hres(void)
 	local_irq_restore(flags);
 	printk(KERN_INFO "Switched to high resolution mode on CPU %d\n",
 	       smp_processor_id());
+	return 1;
 }
 
 #else
 
 static inline int hrtimer_hres_active(void) { return 0; }
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
-static inline void hrtimer_switch_to_hres(void) { }
+static inline int hrtimer_switch_to_hres(void) { return 0; }
 static inline void hrtimer_force_reprogram(struct hrtimer_cpu_base *base) { }
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 					    struct hrtimer_clock_base *base)
@@ -1173,7 +1174,8 @@ void hrtimer_run_queues(void)
 	 * deadlock vs. xtime_lock.
 	 */
 	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled()))
-		hrtimer_switch_to_hres();
+		if (hrtimer_switch_to_hres())
+			return;
 
 	hrtimer_get_softirq_time(cpu_base);
 

 


