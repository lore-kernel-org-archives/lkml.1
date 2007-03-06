Return-Path: <linux-kernel-owner+w=401wt.eu-S965364AbXCFRXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965364AbXCFRXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965337AbXCFRXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:23:53 -0500
Received: from www.osadl.org ([213.239.205.134]:47445 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965364AbXCFRXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:23:52 -0500
Subject: [PATCH] highres: do not run the TIMER_SOFTIRQ after switching to
	highres mode
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>, Soeren Sonnenburg <kernel@nn7.de>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703060817060.5963@woody.linux-foundation.org>
References: <20070305015040.GJ3441@stusta.de>
	 <1173138193.24738.236.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org>
	 <1173142948.24738.257.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org>
	 <20070306103315.GA4295@mellanox.co.il> <20070306103712.GA10942@elte.hu>
	 <20070306104618.GA5792@mellanox.co.il> <20070306113225.GA22561@elte.hu>
	 <Pine.LNX.4.64.0703060817060.5963@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 18:29:55 +0100
Message-Id: <1173202195.24738.350.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 08:44 -0800, Linus Torvalds wrote:
> This is just a coding style thing, but I thought I should really point it 
> out, because these kinds of things quite often result in nasty bugs simply 
> because the source code is so hard to read properly:

/me pleads guilty !

Replacement patch below.

	tglx

--------------------->

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

Remove also the superfluid hres_active check on top of
hrtimer_switch_to_hres(), as we never get there, once we switched over.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andres Salomon <dilinger@debian.org>

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index de93a81..2e465df 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -540,19 +540,18 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 /*
  * Switch to high resolution mode
  */
-static void hrtimer_switch_to_hres(void)
+static int hrtimer_switch_to_hres(void)
 {
 	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
 	unsigned long flags;
-
-	if (base->hres_active)
-		return;
+	int err;
 
 	local_irq_save(flags);
 
-	if (tick_init_highres()) {
+	err = tick_init_highres();
+	if (err < 0) {
 		local_irq_restore(flags);
-		return;
+		return err;
 	}
 	base->hres_active = 1;
 	base->clock_base[CLOCK_REALTIME].resolution = KTIME_HIGH_RES;
@@ -565,13 +564,14 @@ static void hrtimer_switch_to_hres(void)
 	local_irq_restore(flags);
 	printk(KERN_INFO "Switched to high resolution mode on CPU %d\n",
 	       smp_processor_id());
+	return 0;
 }
 
 #else
 
 static inline int hrtimer_hres_active(void) { return 0; }
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
-static inline void hrtimer_switch_to_hres(void) { }
+static inline int hrtimer_switch_to_hres(void) { return -EINVAL; }
 static inline void hrtimer_force_reprogram(struct hrtimer_cpu_base *base) { }
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 					    struct hrtimer_clock_base *base)
@@ -1173,7 +1173,8 @@ void hrtimer_run_queues(void)
 	 * deadlock vs. xtime_lock.
 	 */
 	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled()))
-		hrtimer_switch_to_hres();
+		if (!hrtimer_switch_to_hres())
+			return;
 
 	hrtimer_get_softirq_time(cpu_base);
 


