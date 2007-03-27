Return-Path: <linux-kernel-owner+w=401wt.eu-S934231AbXC0W3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231AbXC0W3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934227AbXC0W2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:28:47 -0400
Received: from 49.sub-75-208-212.myvzw.com ([75.208.212.49]:55525 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934226AbXC0W2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:28:42 -0400
Message-Id: <20070327215827.871954359@goop.org>
References: <20070327214919.800272641@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Mar 2007 14:49:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
       Prarit Bhargava <prarit@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>
Subject: [patch 1/4] Ignore stolen time in the softlockup watchdog
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
Cc: Eric Dumazet <dada1@cosmosbay.com>
---
 kernel/softlockup.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

===================================================================
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -35,9 +35,19 @@ static struct notifier_block panic_block
 	.notifier_call = softlock_panic,
 };
 
+/*
+ * Returns seconds, approximately.  We don't need nanosecond
+ * resolution, and we don't need to waste time with a big divide when
+ * 2^30ns == 1.074s.
+ */
+static unsigned long get_timestamp(void)
+{
+	return sched_clock() >> 30;  /* 2^30 ~= 10^9 */
+}
+
 void touch_softlockup_watchdog(void)
 {
-	__raw_get_cpu_var(touch_timestamp) = jiffies;
+	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -48,10 +58,18 @@ void softlockup_tick(void)
 void softlockup_tick(void)
 {
 	int this_cpu = smp_processor_id();
-	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
+	unsigned long touch_timestamp = __get_cpu_var(touch_timestamp);
+	unsigned long print_timestamp;
+	unsigned long now;
 
-	/* prevent double reports: */
-	if (per_cpu(print_timestamp, this_cpu) == touch_timestamp ||
+	/* watchdog task hasn't updated timestamp yet */
+	if (touch_timestamp == 0)
+		return;
+
+	print_timestamp = __get_cpu_var(print_timestamp);
+
+	/* report at most once a second */
+	if (print_timestamp < (touch_timestamp + 1) ||
 		did_panic ||
 			!per_cpu(watchdog_task, this_cpu))
 		return;
@@ -62,12 +80,14 @@ void softlockup_tick(void)
 		return;
 	}
 
+	now = get_timestamp();
+
 	/* Wake up the high-prio watchdog task every second: */
-	if (time_after(jiffies, touch_timestamp + HZ))
+	if (now > (touch_timestamp + 1))
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable 10+ seconds delays: */
-	if (time_after(jiffies, touch_timestamp + 10*HZ)) {
+	if (now > (touch_timestamp + 10)) {
 		per_cpu(print_timestamp, this_cpu) = touch_timestamp;
 
 		spin_lock(&print_lock);
@@ -87,6 +107,9 @@ static int watchdog(void * __bind_cpu)
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->flags |= PF_NOFREEZE;
+
+	/* initialize timestamp */
+	touch_softlockup_watchdog();
 
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
@@ -120,7 +143,7 @@ cpu_callback(struct notifier_block *nfb,
 			printk("watchdog for %i failed\n", hotcpu);
 			return NOTIFY_BAD;
 		}
-  		per_cpu(touch_timestamp, hotcpu) = jiffies;
+  		per_cpu(touch_timestamp, hotcpu) = 0;
   		per_cpu(watchdog_task, hotcpu) = p;
 		kthread_bind(p, hotcpu);
  		break;

-- 

