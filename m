Return-Path: <linux-kernel-owner+w=401wt.eu-S965494AbXDGJte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965494AbXDGJte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965650AbXDGJte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:49:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56454 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965494AbXDGJtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:49:32 -0400
Date: Sat, 7 Apr 2007 11:49:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] high-res timers: resume fix
Message-ID: <20070407094924.GA21237@elte.hu>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <1175899460.5393.9.camel@localhost> <Pine.LNX.4.64.0704061552380.6730@woody.linux-foundation.org> <20070407081244.GA28284@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070407081244.GA28284@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


find updated patch below - only the patch description changed: i removed 
the 'UP' thing (patch has relevance on SMP too), and added Thomas' ack.

	Ingo

---------------------------->
Subject: [patch] high-res timers: resume fix
From: Ingo Molnar <mingo@elte.hu>

Soeren Sonnenburg reported that upon resume he is getting
this backtrace:

 [<c0119637>] smp_apic_timer_interrupt+0x57/0x90
 [<c0142d30>] retrigger_next_event+0x0/0xb0
 [<c0104d30>] apic_timer_interrupt+0x28/0x30
 [<c0142d30>] retrigger_next_event+0x0/0xb0
 [<c0140068>] __kfifo_put+0x8/0x90
 [<c0130fe5>] on_each_cpu+0x35/0x60
 [<c0143538>] clock_was_set+0x18/0x20
 [<c0135cdc>] timekeeping_resume+0x7c/0xa0
 [<c02aabe1>] __sysdev_resume+0x11/0x80
 [<c02ab0c7>] sysdev_resume+0x47/0x80
 [<c02b0b05>] device_power_up+0x5/0x10

it turns out that on resume we mistakenly re-enable interrupts.
Do the timer retrigger only on the current CPU.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h |    3 +++
 kernel/hrtimer.c        |   12 ++++++++++++
 2 files changed, 15 insertions(+)

Index: linux/include/linux/hrtimer.h
===================================================================
--- linux.orig/include/linux/hrtimer.h
+++ linux/include/linux/hrtimer.h
@@ -206,6 +206,7 @@ struct hrtimer_cpu_base {
 struct clock_event_device;
 
 extern void clock_was_set(void);
+extern void hres_timers_resume(void);
 extern void hrtimer_interrupt(struct clock_event_device *dev);
 
 /*
@@ -236,6 +237,8 @@ static inline ktime_t hrtimer_cb_get_tim
  */
 static inline void clock_was_set(void) { }
 
+static inline void hres_timers_resume(void) { }
+
 /*
  * In non high resolution mode the time reference is taken from
  * the base softirq time variable.
Index: linux/kernel/hrtimer.c
===================================================================
--- linux.orig/kernel/hrtimer.c
+++ linux/kernel/hrtimer.c
@@ -459,6 +459,18 @@ void clock_was_set(void)
 }
 
 /*
+ * During resume we might have to reprogram the high resolution timer
+ * interrupt (on the local CPU):
+ */
+void hres_timers_resume(void)
+{
+	WARN_ON_ONCE(num_online_cpus() > 1);
+
+	/* Retrigger the CPU local events: */
+	retrigger_next_event(NULL);
+}
+
+/*
  * Check, whether the timer is on the callback pending list
  */
 static inline int hrtimer_cb_pending(const struct hrtimer *timer)
