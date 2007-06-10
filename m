Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbXFJJdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbXFJJdn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbXFJJbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:31:07 -0400
Received: from www.osadl.org ([213.239.205.134]:43060 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751814AbXFJJa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:30:58 -0400
Message-Id: <20070610092446.625214085@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 10 Jun 2007 09:44:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>, john stultz <johnstul@us.ibm.com>
Subject: [patch-mm 07/23] Tick management: spread timer interrupt
Content-Disposition: inline; filename=tick-spread-timer-interrupts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>

After discussing w/ Thomas over IRC, it seems the issue is the sched
tick fires on every cpu at the same time, causing extra lock contention.

This smaller change, adds an extra offset per cpu so the ticks don't
line up. This patch also drops the idle latency from 40us down to under
20us.

Signed-off-by: john stultz <johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/time/tick-sched.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/kernel/time/tick-sched.c	2007-06-10 10:44:37.000000000 +0200
+++ linux-2.6.22-rc4-mm/kernel/time/tick-sched.c	2007-06-10 10:44:38.000000000 +0200
@@ -573,6 +573,7 @@ void tick_setup_sched_timer(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now = ktime_get();
+	u64 offset;
 
 	/*
 	 * Emulate tick processing via per-CPU hrtimers:
@@ -581,8 +582,12 @@ void tick_setup_sched_timer(void)
 	ts->sched_timer.function = tick_sched_timer;
 	ts->sched_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 
-	/* Get the next period */
+	/* Get the next period (per cpu)*/
 	ts->sched_timer.expires = tick_init_jiffy_update();
+	offset = ktime_to_ns(tick_period) >> 1;
+	do_div(offset, NR_CPUS);
+	offset *= smp_processor_id();
+	ts->sched_timer.expires = ktime_add_ns(ts->sched_timer.expires, offset);
 
 	for (;;) {
 		hrtimer_forward(&ts->sched_timer, now, tick_period);

-- 

