Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbYFWMcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbYFWMcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 08:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbYFWMby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 08:31:54 -0400
Received: from [194.117.236.238] ([194.117.236.238]:58486 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758032AbYFWMbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 08:31:53 -0400
Date: Mon, 23 Jun 2008 15:30:56 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: tzanussi@gmail.com
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Full conversion to early_initcall() interface, remove
 old interface.
Message-ID: <20080623153056.1862c14e@linux360.ro>
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
 include/linux/sched.h |    9 ---------
 init/main.c           |   22 +---------------------
 kernel/sched.c        |    6 +++++-
 kernel/softirq.c      |    4 +++-
 kernel/softlockup.c   |   27 ++++++++++++++++++++++++---
 5 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c5d3f84..efd8877 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -291,7 +291,6 @@ extern void sched_show_task(struct task_struct *p);
 
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 extern void softlockup_tick(void);
-extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
 extern unsigned long  softlockup_thresh;
@@ -2200,14 +2199,6 @@ static inline void inc_syscw(struct task_struct *tsk)
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
diff --git a/init/main.c b/init/main.c
index c5397f6..057f364 100644
--- a/init/main.c
+++ b/init/main.c
@@ -766,16 +766,7 @@ static void __init do_basic_setup(void)
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
 
@@ -783,16 +774,6 @@ static void __init __do_pre_smp_initcalls(void)
 		do_one_initcall(*call);
 }
 
-static void __init do_pre_smp_initcalls(void)
-{
-	extern int spawn_ksoftirqd(void);
-
-	migration_init();
-	spawn_ksoftirqd();
-	if (!nosoftlockup)
-		spawn_softlockup_task();
-}
-
 static void run_init_process(char *init_filename)
 {
 	argv_init[0] = init_filename;
@@ -864,7 +845,6 @@ static int __init kernel_init(void * unused)
 
 	smp_prepare_cpus(setup_max_cpus);
 
-	__do_pre_smp_initcalls();
 	do_pre_smp_initcalls();
 
 	smp_init();
diff --git a/kernel/sched.c b/kernel/sched.c
index b048ad8..ccddfdd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6175,7 +6175,7 @@ static struct notifier_block __cpuinitdata migration_notifier = {
 	.priority = 10
 };
 
-void __init migration_init(void)
+static int __init migration_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
@@ -6185,7 +6185,11 @@ void __init migration_init(void)
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
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 36e0617..2ef08c7 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -659,7 +659,7 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
-__init int spawn_ksoftirqd(void)
+static __init int spawn_ksoftirqd(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
@@ -670,6 +670,8 @@ __init int spawn_ksoftirqd(void)
 	return 0;
 }
 
+early_initcall(spawn_ksoftirqd);
+
 #ifdef CONFIG_SMP
 /*
  * Call a function on all processors
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index c828c23..1653802 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -306,14 +306,35 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
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

