Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbYACAx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbYACAx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759840AbYACAuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:13 -0500
Received: from mx1.suse.de ([195.135.220.2]:51781 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759646AbYACAuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:09 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [12/20] x86: Use a per cpu timer for correctable machine check checking
Message-Id: <20080103005007.CE13A14D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously the code used a single timer that then used smp_call_function
to interrupt all CPUs while the original CPU was waiting for them. 

But it is better / more real time and more power friendly to simply run 
individual timers on each CPU so they all do this independently.

This way no single CPU has to wait for all others.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   68 +++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 20 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -363,17 +363,14 @@ void mce_log_therm_throt_event(unsigned 
 static int check_interval = 5 * 60; /* 5 minutes */
 static int next_interval; /* in jiffies */
 static void mcheck_timer(struct work_struct *work);
-static DECLARE_DELAYED_WORK(mcheck_work, mcheck_timer);
+static DEFINE_PER_CPU(struct delayed_work, mcheck_work);
 
-static void mcheck_check_cpu(void *info)
+static void mcheck_timer(struct work_struct *work)
 {
+	int cpu;
+
 	if (mce_available(&current_cpu_data))
 		do_machine_check(NULL, 0);
-}
-
-static void mcheck_timer(struct work_struct *work)
-{
-	on_each_cpu(mcheck_check_cpu, NULL, 1, 1);
 
 	/*
 	 * Alert userspace if needed.  If we logged an MCE, reduce the
@@ -386,7 +383,8 @@ static void mcheck_timer(struct work_str
 				(int)round_jiffies_relative(check_interval*HZ));
 	}
 
-	schedule_delayed_work(&mcheck_work, next_interval);
+	cpu = smp_processor_id();
+	schedule_delayed_work_on(cpu, &per_cpu(mcheck_work, cpu), next_interval);
 }
 
 /*
@@ -436,12 +434,44 @@ static struct notifier_block mce_idle_no
 };
 #endif
 
+static void mce_timers(int restart)
+{
+	int i;
+	next_interval = restart ? check_interval * HZ : 0;
+	for_each_online_cpu (i) {
+		struct delayed_work *w = &per_cpu(mcheck_work, i);
+		cancel_delayed_work_sync(w);
+		if (restart)
+			schedule_delayed_work_on(i, w,
+					round_jiffies_relative(next_interval));
+	}
+}
+
+static int __cpuinit
+mce_periodic_cpu_cb(struct notifier_block *b, unsigned long action, void *arg)
+{
+	long cpu = (long)arg;
+	struct delayed_work *w = &per_cpu(mcheck_work, cpu);
+	switch (action) {
+	case CPU_DOWN_PREPARE:
+		cancel_delayed_work_sync(w);
+		break;
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		schedule_delayed_work_on(cpu, w, next_interval);
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
 static __init int periodic_mcheck_init(void)
 {
-	next_interval = check_interval * HZ;
-	if (next_interval)
-		schedule_delayed_work(&mcheck_work,
-				      round_jiffies_relative(next_interval));
+	/* RED-PEN: race here with CPU getting added in parallel. But
+	 * if the hotplug lock is aquired here we run into lock ordering
+	 * problems with the scheduler code.
+ 	 */
+	hotcpu_notifier(mce_periodic_cpu_cb, 0);
+	mce_timers(1);
 #ifdef CONFIG_MCE_NOTIFY
 	idle_notifier_register(&mce_idle_notifier);
 #endif
@@ -520,12 +550,15 @@ static void __cpuinit mce_cpu_features(s
  */
 void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 {
+	int cpu = smp_processor_id();
 	static cpumask_t mce_cpus = CPU_MASK_NONE;
 
+	INIT_DELAYED_WORK(&per_cpu(mcheck_work, cpu), mcheck_timer);
+
 	mce_cpu_quirks(c);
 
 	if (mce_dont_init ||
-	    cpu_test_and_set(smp_processor_id(), mce_cpus) ||
+	    cpu_test_and_set(cpu, mce_cpus) ||
 	    !mce_available(c))
 		return;
 
@@ -751,14 +784,9 @@ static int mce_resume(struct sys_device 
 /* Reinit MCEs after user configuration changes */
 static void mce_restart(void)
 {
-	if (next_interval)
-		cancel_delayed_work(&mcheck_work);
-	/* Timer race is harmless here */
+	mce_timers(0);
 	on_each_cpu(mce_init, NULL, 1, 1);
-	next_interval = check_interval * HZ;
-	if (next_interval)
-		schedule_delayed_work(&mcheck_work,
-				      round_jiffies_relative(next_interval));
+	mce_timers(1);
 }
 
 static struct sysdev_class mce_sysclass = {
