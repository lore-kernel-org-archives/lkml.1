Return-Path: <linux-kernel-owner+w=401wt.eu-S934025AbXC0FtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934025AbXC0FtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934030AbXC0FtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:49:00 -0400
Received: from gw.goop.org ([64.81.55.164]:59347 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934025AbXC0Fs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:48:59 -0400
Message-Id: <20070327054106.664262413@goop.org>
References: <20070327053816.881735237@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 26 Mar 2007 22:38:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Zachary Amsden <zach@vmware.com>,
       James Morris <jmorris@namei.org>, Dan Hecht <dhecht@vmware.com>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Prarit Bhargava <prarit@redhat.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>
Subject: [patch 1/2] Ignore stolen time in the softlockup watchdog
Content-Disposition: inline; filename=softlockup-ignore-stolen-time.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The softlockup watchdog is currently a nuisance in a virtual machine,
since the whole system could have the CPU stolen from it for a long
period of time.  While it would be unlikely for a guest domain to be
denied timer interrupts for over 10s, it could happen and any softlockup
message would be completely spurious.

Earlier I proposed that sched_clock() return time in unstolen
nanoseconds, which is how Xen and VMI currently implement it.  If the
softlockup watchdog uses sched_clock() to measure time, it would
automatically ignore stolen time, and therefore only report when the
guest itself locked up.  When running native, sched_clock() returns
real-time nanoseconds, so the behaviour would be unchanged.

Note that sched_clock() used this way is inherently per-cpu, so this
patch makes sure that the per-processor watchdog thread initialized
its own timestamp.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: James Morris <jmorris@namei.org>
Cc: Dan Hecht <dhecht@vmware.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Chris Lalancette <clalance@redhat.com>
Cc: Rick Lindsley <ricklind@us.ibm.com>

---
 kernel/softlockup.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

===================================================================
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
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

-- 

