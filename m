Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYFYJD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYFYJD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 05:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYFYJC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 05:02:58 -0400
Received: from [194.117.236.238] ([194.117.236.238]:34807 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbYFYJC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 05:02:56 -0400
Date: Wed, 25 Jun 2008 12:01:51 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Andrew Morton <akpm@linux-foundation.org>, tzanussi@gmail.com
Cc: penberg@cs.helsinki.fi, torvalds@linux-foundation.org,
       compudj@krystal.dyndns.org, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Full conversion to early_initcall() interface, remove
 old interface.
Message-ID: <20080625120151.56180b47@linux360.ro>
In-Reply-To: <20080623172742.be332a53.akpm@linux-foundation.org>
References: <20080623153056.1862c14e@linux360.ro>
	<20080623172742.be332a53.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A previous patch added the early_initcall(), to allow a cleaner hooking of
pre-SMP initcalls. Now we remove the older interface, converting all
existing users to the new one.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/linux/sched.h |   12 ------------
 include/linux/smp.h   |    8 --------
 init/main.c           |   23 +----------------------
 kernel/sched.c        |    6 +++++-
 kernel/smp.c          |    6 +++++-
 kernel/softirq.c      |    4 +++-
 kernel/softlockup.c   |   27 ++++++++++++++++++++++++---
 7 files changed, 38 insertions(+), 48 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 239df23..495996d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -292,7 +292,6 @@ extern void sched_show_task(struct task_struct *p);
 
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 extern void softlockup_tick(void);
-extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
 extern unsigned int  softlockup_panic;
@@ -304,9 +303,6 @@ extern int softlockup_thresh;
 static inline void softlockup_tick(void)
 {
 }
-static inline void spawn_softlockup_task(void)
-{
-}
 static inline void touch_softlockup_watchdog(void)
 {
 }
@@ -2211,14 +2207,6 @@ static inline void inc_syscw(struct task_struct *tsk)
 }
 #endif
 
-#ifdef CONFIG_SMP
-void migration_init(void);
-#else
-static inline void migration_init(void)
-{
-}
-#endif
-
 #ifndef TASK_SIZE_OF
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 4d4c6ad..3c26b21 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -75,12 +75,7 @@ void __smp_call_function_single(int cpuid, struct call_single_data *data);
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 void generic_smp_call_function_single_interrupt(void);
 void generic_smp_call_function_interrupt(void);
-void init_call_single_data(void);
 extern spinlock_t call_function_lock;
-#else
-static inline void init_call_single_data(void)
-{
-}
 #endif
 
 /*
@@ -138,9 +133,6 @@ static inline void smp_send_reschedule(int cpu) { }
 })
 #define smp_call_function_mask(mask, func, info, wait) \
 			(up_smp_call_function(func, info))
-static inline void init_call_single_data(void)
-{
-}
 #endif /* !SMP */
 
 /*
diff --git a/init/main.c b/init/main.c
index 9e34d92..bfbfadd 100644
--- a/init/main.c
+++ b/init/main.c
@@ -776,16 +776,7 @@ static void __init do_basic_setup(void)
 	do_initcalls();
 }
 
-static int __initdata nosoftlockup;
-
-static int __init nosoftlockup_setup(char *str)
-{
-	nosoftlockup = 1;
-	return 1;
-}
-__setup("nosoftlockup", nosoftlockup_setup);
-
-static void __init __do_pre_smp_initcalls(void)
+static void __init do_pre_smp_initcalls(void)
 {
 	initcall_t *call;
 
@@ -793,17 +784,6 @@ static void __init __do_pre_smp_initcalls(void)
 		do_one_initcall(*call);
 }
 
-static void __init do_pre_smp_initcalls(void)
-{
-	extern int spawn_ksoftirqd(void);
-
-	init_call_single_data();
-	migration_init();
-	spawn_ksoftirqd();
-	if (!nosoftlockup)
-		spawn_softlockup_task();
-}
-
 static void run_init_process(char *init_filename)
 {
 	argv_init[0] = init_filename;
@@ -884,7 +864,6 @@ static int __init kernel_init(void * unused)
 
 	smp_prepare_cpus(setup_max_cpus);
 
-	__do_pre_smp_initcalls();
 	do_pre_smp_initcalls();
 
 	smp_init();
diff --git a/kernel/sched.c b/kernel/sched.c
index 306f7f6..3c987f3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6244,7 +6244,7 @@ static struct notifier_block __cpuinitdata migration_notifier = {
 	.priority = 10
 };
 
-void __init migration_init(void)
+static int __init migration_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
@@ -6254,7 +6254,11 @@ void __init migration_init(void)
 	BUG_ON(err == NOTIFY_BAD);
 	migration_call(&migration_notifier, CPU_ONLINE, cpu);
 	register_cpu_notifier(&migration_notifier);
+
+	return err;
 }
+
+early_initcall(migration_init);
 #endif
 
 #ifdef CONFIG_SMP
diff --git a/kernel/smp.c b/kernel/smp.c
index a0c9cb0..f121e1d 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -33,7 +33,7 @@ struct call_single_queue {
 	spinlock_t lock;
 };
 
-void __cpuinit init_call_single_data(void)
+static int __cpuinit init_call_single_data(void)
 {
 	int i;
 
@@ -43,8 +43,12 @@ void __cpuinit init_call_single_data(void)
 		spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->list);
 	}
+
+	return 0;
 }
 
+early_initcall(init_call_single_data);
+
 static void csd_flag_wait(struct call_single_data *data)
 {
 	/* Wait for response */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0592568..efab66a 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -658,7 +658,7 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
-__init int spawn_ksoftirqd(void)
+static int __init spawn_ksoftirqd(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
@@ -669,6 +669,8 @@ __init int spawn_ksoftirqd(void)
 	return 0;
 }
 
+early_initcall(spawn_ksoftirqd);
+
 #ifdef CONFIG_SMP
 /*
  * Call a function on all processors
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 6b682d8..393d310 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -335,14 +335,35 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
-__init void spawn_softlockup_task(void)
+static int __initdata nosoftlockup;
+
+static int __init nosoftlockup_setup(char *str)
+{
+	nosoftlockup = 1;
+	return 1;
+}
+__setup("nosoftlockup", nosoftlockup_setup);
+
+static int __init spawn_softlockup_task(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
-	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
+	int err;
+
+	if (nosoftlockup)
+		return 0;
 
-	BUG_ON(err == NOTIFY_BAD);
+	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
+	if (err == NOTIFY_BAD) {
+		BUG();
+		return 1;
+	}
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 
 	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+
+	return 0;
 }
+
+early_initcall(spawn_softlockup_task);
+
-- 
1.5.5.4

