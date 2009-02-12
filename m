Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbZBLMkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbZBLMkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbZBLMii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:38:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49211 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755AbZBLMif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:38:35 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212137.750180365@firstfloor.org>
In-Reply-To: <20090212137.750180365@firstfloor.org>
To: thockin@google.com, akpm@linux-foundation.org, x86@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [4/10] x86: MCE: Switch machine check polling to per CPU timer v3
Message-Id: <20090212123723.4FED13E666F@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:37:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Higher priority bug fix

The machine check poller runs a single timer and then broadcasted an
IPI to all CPUs to check them. This leads to unnecessary
synchronization between CPUs. The original CPU running the timer has
to wait potentially a long time for all other CPUs answering. This is
also real time unfriendly and in general inefficient.

This was especially a problem on systems with a lot of events where
the poller run with a higher frequency after processing some events. 
There could be more and more CPU time wasted with this, to
the point of significantly slowing down machines.

The machine check polling is actually fully independent per CPU, so
there's no reason to not just do this all with per CPU timers.  This
patch implements that.

Also switch the poller also to use standard timers instead of work
queues. It was using work queues to be able to execute a user program
on a event, but mce_notify_user() handles this case now with a
separate callback. So instead always run the poll code in in a
standard per CPU timer, which means that in the common case of not
having to execute a trigger there will be less overhead.

This allows to clean up the initialization significantly, because
standard timers are already up when machine checks get init'ed.  No
multiple initialization functions.

Thanks to Thomas Gleixner for some help.

Cc: thockin@google.com
v2: Use del_timer_sync() on cpu shutdown and don't try to handle
migrated timers.
v3: Add WARN_ON for timer running on unexpected CPU

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   68 +++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 23 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:21.000000000 +0100
@@ -353,18 +353,17 @@
 
 static int check_interval = 5 * 60; /* 5 minutes */
 static int next_interval; /* in jiffies */
-static void mcheck_timer(struct work_struct *work);
-static DECLARE_DELAYED_WORK(mcheck_work, mcheck_timer);
+static void mcheck_timer(unsigned long);
+static DEFINE_PER_CPU(struct timer_list, mce_timer);
 
-static void mcheck_check_cpu(void *info)
+static void mcheck_timer(unsigned long data)
 {
+	struct timer_list *t = &per_cpu(mce_timer, data);
+
+	WARN_ON(smp_processor_id() != data);
+
 	if (mce_available(&current_cpu_data))
 		do_machine_check(NULL, 0);
-}
-
-static void mcheck_timer(struct work_struct *work)
-{
-	on_each_cpu(mcheck_check_cpu, NULL, 1);
 
 	/*
 	 * Alert userspace if needed.  If we logged an MCE, reduce the
@@ -377,7 +376,8 @@
 				(int)round_jiffies_relative(check_interval*HZ));
 	}
 
-	schedule_delayed_work(&mcheck_work, next_interval);
+	t->expires = jiffies + next_interval;
+	add_timer(t);
 }
 
 static void mce_do_trigger(struct work_struct *work)
@@ -436,16 +436,11 @@
 
 static __init int periodic_mcheck_init(void)
 {
-	next_interval = check_interval * HZ;
-	if (next_interval)
-		schedule_delayed_work(&mcheck_work,
-				      round_jiffies_relative(next_interval));
-	idle_notifier_register(&mce_idle_notifier);
-	return 0;
+       idle_notifier_register(&mce_idle_notifier);
+       return 0;
 }
 __initcall(periodic_mcheck_init);
 
-
 /*
  * Initialize Machine Checks for a CPU.
  */
@@ -515,6 +510,20 @@
 	}
 }
 
+static void mce_init_timer(void)
+{
+	struct timer_list *t = &__get_cpu_var(mce_timer);
+
+	/* data race harmless because everyone sets to the same value */
+	if (!next_interval)
+		next_interval = check_interval * HZ;
+	if (!next_interval)
+		return;
+	setup_timer(t, mcheck_timer, smp_processor_id());
+	t->expires = round_jiffies_relative(jiffies + next_interval);
+	add_timer(t);
+}
+
 /*
  * Called for each booted CPU to set up machine checks.
  * Must be called with preempt off.
@@ -529,6 +538,7 @@
 
 	mce_init(NULL);
 	mce_cpu_features(c);
+	mce_init_timer();
 }
 
 /*
@@ -735,17 +745,19 @@
 	return 0;
 }
 
+static void mce_cpu_restart(void *data)
+{
+	del_timer_sync(&__get_cpu_var(mce_timer));
+	if (mce_available(&current_cpu_data))
+		mce_init(NULL);
+	mce_init_timer();
+}
+
 /* Reinit MCEs after user configuration changes */
 static void mce_restart(void)
 {
-	if (next_interval)
-		cancel_delayed_work(&mcheck_work);
-	/* Timer race is harmless here */
-	on_each_cpu(mce_init, NULL, 1);
 	next_interval = check_interval * HZ;
-	if (next_interval)
-		schedule_delayed_work(&mcheck_work,
-				      round_jiffies_relative(next_interval));
+	on_each_cpu(mce_cpu_restart, NULL, 1);
 }
 
 static struct sysdev_class mce_sysclass = {
@@ -874,6 +886,7 @@
 				      unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
+	struct timer_list *t = &per_cpu(mce_timer, cpu);
 
 	switch (action) {
 	case CPU_ONLINE:
@@ -888,6 +901,15 @@
 			threshold_cpu_callback(action, cpu);
 		mce_remove_device(cpu);
 		break;
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		del_timer_sync(t);
+		break;
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+		t->expires = round_jiffies_relative(jiffies + next_interval);
+		add_timer_on(t, cpu);
+		break;
 	}
 	return NOTIFY_OK;
 }
