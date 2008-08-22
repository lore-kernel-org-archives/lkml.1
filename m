Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYHVKwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYHVKwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 06:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYHVKwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 06:52:06 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:15428 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYHVKwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 06:52:03 -0400
X-IronPort-AV: E=Sophos;i="4.32,251,1217822400"; 
   d="scan'208";a="16925818"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/5] x86:  Add cpu hotplug hooks into smp_ops
Date: Fri, 22 Aug 2008 11:52:11 +0100
Message-Id: <1219402335-29773-1-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 22 Aug 2008 10:51:44.0462 (UTC) FILETIME=[11339EE0:01C90445]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process_32.c |    4 ++--
 arch/x86/kernel/process_64.c |    4 ++--
 arch/x86/kernel/smp.c        |    6 +++++-
 arch/x86/kernel/smpboot.c    |    8 ++++----
 include/asm-x86/smp.h        |   28 ++++++++++++++++++++++++----
 5 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 593b73e..ae376af 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -93,7 +93,7 @@ static void cpu_exit_clear(void)
 }
 
 /* We don't actually take CPU down, just spin without interrupts. */
-static inline void play_dead(void)
+void native_play_dead(void)
 {
 	/* This must be done before dead CPU ack */
 	cpu_exit_clear();
@@ -109,7 +109,7 @@ static inline void play_dead(void)
 	wbinvd_halt();
 }
 #else
-static inline void play_dead(void)
+void native_play_dead(void)
 {
 	BUG();
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 8248dc0..1cca50c 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -92,7 +92,7 @@ DECLARE_PER_CPU(int, cpu_state);
 
 #include <linux/nmi.h>
 /* We halt the CPU with physical CPU hotplug */
-static inline void play_dead(void)
+void native_play_dead(void)
 {
 	idle_task_exit();
 	mb();
@@ -104,7 +104,7 @@ static inline void play_dead(void)
 	wbinvd_halt();
 }
 #else
-static inline void play_dead(void)
+void native_play_dead(void)
 {
 	BUG();
 }
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 361b7a4..18f9b19 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -214,12 +214,16 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 struct smp_ops smp_ops = {
 	.smp_prepare_boot_cpu = native_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = native_smp_prepare_cpus,
-	.cpu_up = native_cpu_up,
 	.smp_cpus_done = native_smp_cpus_done,
 
 	.smp_send_stop = native_smp_send_stop,
 	.smp_send_reschedule = native_smp_send_reschedule,
 
+	.cpu_up = native_cpu_up,
+	.cpu_die = native_cpu_die,
+	.cpu_disable = native_cpu_disable,
+	.play_dead = native_play_dead,
+
 	.send_call_func_ipi = native_send_call_func_ipi,
 	.send_call_func_single_ipi = native_send_call_func_single_ipi,
 };
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2ff0bbc..c6832ca 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1343,7 +1343,7 @@ static void __ref remove_cpu_from_maps(int cpu)
 	numa_remove_cpu(cpu);
 }
 
-int __cpu_disable(void)
+int native_cpu_disable(void)
 {
 	int cpu = smp_processor_id();
 
@@ -1382,7 +1382,7 @@ int __cpu_disable(void)
 	return 0;
 }
 
-void __cpu_die(unsigned int cpu)
+void native_cpu_die(unsigned int cpu)
 {
 	/* We don't do anything here: idle task is faking death itself. */
 	unsigned int i;
@@ -1400,12 +1400,12 @@ void __cpu_die(unsigned int cpu)
 	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
 }
 #else /* ... !CONFIG_HOTPLUG_CPU */
-int __cpu_disable(void)
+int native_cpu_disable(void)
 {
 	return -ENOSYS;
 }
 
-void __cpu_die(unsigned int cpu)
+void native_cpu_die(unsigned int cpu)
 {
 	/* We said "no" in __cpu_disable */
 	BUG();
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 29324c1..cb1d51d 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -50,12 +50,16 @@ extern struct {
 struct smp_ops {
 	void (*smp_prepare_boot_cpu)(void);
 	void (*smp_prepare_cpus)(unsigned max_cpus);
-	int (*cpu_up)(unsigned cpu);
 	void (*smp_cpus_done)(unsigned max_cpus);
 
 	void (*smp_send_stop)(void);
 	void (*smp_send_reschedule)(int cpu);
 
+	int (*cpu_up)(unsigned cpu);
+	int (*cpu_disable)(void);
+	void (*cpu_die)(unsigned int cpu);
+	void (*play_dead)(void);
+
 	void (*send_call_func_ipi)(cpumask_t mask);
 	void (*send_call_func_single_ipi)(int cpu);
 };
@@ -94,6 +98,21 @@ static inline int __cpu_up(unsigned int cpu)
 	return smp_ops.cpu_up(cpu);
 }
 
+static inline int __cpu_disable(void)
+{
+	return smp_ops.cpu_disable();
+}
+
+static inline void __cpu_die(unsigned int cpu)
+{
+	smp_ops.cpu_die(cpu);
+}
+
+static inline void play_dead(void)
+{
+	smp_ops.play_dead();
+}
+
 static inline void smp_send_reschedule(int cpu)
 {
 	smp_ops.smp_send_reschedule(cpu);
@@ -113,12 +132,13 @@ void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
 int native_cpu_up(unsigned int cpunum);
+int native_cpu_disable(void);
+void native_cpu_die(unsigned int cpu);
+void native_play_dead(void);
+
 void native_send_call_func_ipi(cpumask_t mask);
 void native_send_call_func_single_ipi(int cpu);
 
-extern int __cpu_disable(void);
-extern void __cpu_die(unsigned int cpu);
-
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
 
-- 
1.5.4.3

