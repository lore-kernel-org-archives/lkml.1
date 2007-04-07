Return-Path: <linux-kernel-owner+w=401wt.eu-S965480AbXDGIM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965480AbXDGIM7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965496AbXDGIM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:12:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35401 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965480AbXDGIM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:12:56 -0400
Date: Sat, 7 Apr 2007 10:12:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] high-res timers: UP resume fix
Message-ID: <20070407081244.GA28284@elte.hu>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <1175899460.5393.9.camel@localhost> <Pine.LNX.4.64.0704061552380.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704061552380.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> In fact,  I have a theory.. Your backtrace is:
> 
>  [<c0119637>] smp_apic_timer_interrupt+0x57/0x90
>  [<c0142d30>] retrigger_next_event+0x0/0xb0
>  [<c0104d30>] apic_timer_interrupt+0x28/0x30
>  [<c0142d30>] retrigger_next_event+0x0/0xb0
>  [<c0140068>] __kfifo_put+0x8/0x90
>  [<c0130fe5>] on_each_cpu+0x35/0x60
>  [<c0143538>] clock_was_set+0x18/0x20
>  [<c0135cdc>] timekeeping_resume+0x7c/0xa0
>  [<c02aabe1>] __sysdev_resume+0x11/0x80
>  [<c02ab0c7>] sysdev_resume+0x47/0x80
>  [<c02b0b05>] device_power_up+0x5/0x10
> 
> and the thing is, I don't think we should have interrupt enabled at 
> this point in time! I susect that the timer resume enables interrupts 
> too early! We should be doing the whole "device_power_up()" sequence 
> with irq's off, I think..

yeah, i think you are right. timekeeping_resume() itself does not 
re-enable interrupts, it's clock_was_set() that does it implicitly:

void clock_was_set(void)
{
        /* Retrigger the CPU local events everywhere */
        on_each_cpu(retrigger_next_event, NULL, 0, 1);
}

on_each_cpu() is safe on SMP during resume 'bootup', because we only 
have a single CPU at that point, and smp_call_function() does:

        spin_lock(&call_lock);
        cpus = num_online_cpus() - 1;
        if (!cpus) {
                spin_unlock(&call_lock);

so we just return. Note that the built-in warning of smp_call_function() 
does not trigger because it's done too late:

        /* Can deadlock when called with interrupts disabled */
        WARN_ON(irqs_disabled());

we should move this up to the head of the function. But for this bug in 
question to trigger we'd have to use an UP kernel, which has this code 
for on_each_cpu():

#define on_each_cpu(func,info,retry,wait)       \
        ({                                      \
                local_irq_disable();            \
                func(info);                     \
                local_irq_enable();             \

ouch!

the solution is this: what we want to call here in timekeeping_resume is 
not clock_was_set() but retrigger_next_event() for the current CPU. The 
patch below should fix it. Soeren, can you confirm that you are using a 
!CONFIG_SMP kernel, and if yes, does the patch below fix the resume 
problem for you?

	Ingo

---------------------------->
Subject: [patch] high-res timers: UP resume fix
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

it turns out that on UP we mistakenly re-enable interrupts,
so do the timer retrigger only on the current CPU.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
