Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbXCWAOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbXCWAOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXCWAOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:14:21 -0400
Received: from gw.goop.org ([64.81.55.164]:50555 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbXCWAOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:14:20 -0400
Message-ID: <46031BDA.2060705@goop.org>
Date: Thu, 22 Mar 2007 17:14:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Akinobu Mita <mita@miraclelinux.com>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC] Change softlockup watchdog to ignore stolen time
References: <460311FA.6070400@goop.org>
In-Reply-To: <460311FA.6070400@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> The softlockup watchdog is currently a nuisance in a virtual machine,
> since the whole system could have the CPU stolen from it for a long
> period of time.  While it would be unlikely for a guest domain to be
> denied timer interrupts for over 10s, it could happen and any softlockup
> message would be completely spurious.
>
> Earlier I proposed that sched_clock() return time in unstolen
> nanoseconds, which is how Xen and VMI currently implement it.  If the
> softlockup watchdog uses sched_clock() to measure time, it would
> automatically ignore stolen time, and therefore only report when the
> guest itself locked up.  When running native, sched_clock() returns
> real-time nanoseconds, so the behaviour would be unchanged.
>
> Does this seem sound?
>
> Also, softlockup.c's use of jiffies seems archaic now.  Should it be
> converted to use timers?  Mightn't it report lockups just because there
> was no timer event?
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Less desperately broken version.

diff -r b41fb9e70d72 kernel/softlockup.c
--- a/kernel/softlockup.c	Thu Mar 22 16:25:15 2007 -0700
+++ b/kernel/softlockup.c	Thu Mar 22 17:03:03 2007 -0700
@@ -17,8 +17,8 @@
 
 static DEFINE_SPINLOCK(print_lock);
 
-static DEFINE_PER_CPU(unsigned long, touch_timestamp);
-static DEFINE_PER_CPU(unsigned long, print_timestamp);
+static DEFINE_PER_CPU(unsigned long long, touch_timestamp);
+static DEFINE_PER_CPU(unsigned long long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
 static int did_panic = 0;
@@ -37,7 +37,7 @@ static struct notifier_block panic_block
 
 void touch_softlockup_watchdog(void)
 {
-	__raw_get_cpu_var(touch_timestamp) = jiffies;
+	__raw_get_cpu_var(touch_timestamp) = sched_clock();
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -48,10 +48,15 @@ void softlockup_tick(void)
 void softlockup_tick(void)
 {
 	int this_cpu = smp_processor_id();
-	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
+	unsigned long long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
+	unsigned long long now;
 
-	/* prevent double reports: */
-	if (per_cpu(print_timestamp, this_cpu) == touch_timestamp ||
+	/* watchdog task hasn't updated timestamp yet */
+	if (touch_timestamp == 0)
+		return;
+
+	/* report at most once a second */
+	if (per_cpu(print_timestamp, this_cpu) < (touch_timestamp + NSEC_PER_SEC) ||
 		did_panic ||
 			!per_cpu(watchdog_task, this_cpu))
 		return;
@@ -62,12 +67,14 @@ void softlockup_tick(void)
 		return;
 	}
 
+	now = sched_clock();
+
 	/* Wake up the high-prio watchdog task every second: */
-	if (time_after(jiffies, touch_timestamp + HZ))
+	if (now > (touch_timestamp + NSEC_PER_SEC))
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable 10+ seconds delays: */
-	if (time_after(jiffies, touch_timestamp + 10*HZ)) {
+	if (now > (touch_timestamp + 10ull*NSEC_PER_SEC)) {
 		per_cpu(print_timestamp, this_cpu) = touch_timestamp;
 
 		spin_lock(&print_lock);
@@ -87,6 +94,9 @@ static int watchdog(void * __bind_cpu)
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->flags |= PF_NOFREEZE;
+
+	/* initialize timestamp */
+	touch_softlockup_watchdog();
 
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
@@ -120,7 +130,7 @@ cpu_callback(struct notifier_block *nfb,
 			printk("watchdog for %i failed\n", hotcpu);
 			return NOTIFY_BAD;
 		}
-  		per_cpu(touch_timestamp, hotcpu) = jiffies;
+  		per_cpu(touch_timestamp, hotcpu) = 0;
   		per_cpu(watchdog_task, hotcpu) = p;
 		kthread_bind(p, hotcpu);
  		break;

