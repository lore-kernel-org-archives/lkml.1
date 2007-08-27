Return-Path: <linux-kernel-owner+w=401wt.eu-S1762932AbXH0Qos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932AbXH0Qos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbXH0QiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:38:22 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54335 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757908AbXH0QiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:38:17 -0400
Message-Id: <20070827160214.557976141@polymtl.ca>
References: <20070827155910.336723755@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:59:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 8/8] Scheduler Profiling - Use Immediate Values
Content-Disposition: inline; filename=profiling-use-immediate-values.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 16:38:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use immediate values with lower d-cache hit in optimized version as a
condition for scheduler profiling call.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 drivers/kvm/svm.c       |    2 +-
 drivers/kvm/vmx.c       |    2 +-
 include/linux/profile.h |   10 ++++------
 kernel/profile.c        |   38 ++++++++++++++++++++++++++------------
 kernel/sched.c          |    3 ++-
 5 files changed, 34 insertions(+), 21 deletions(-)

Index: linux-2.6-lttng/kernel/profile.c
===================================================================
--- linux-2.6-lttng.orig/kernel/profile.c	2007-08-27 11:16:08.000000000 -0400
+++ linux-2.6-lttng/kernel/profile.c	2007-08-27 11:49:25.000000000 -0400
@@ -42,9 +42,6 @@ int (*timer_hook)(struct pt_regs *) __re
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
 
-int prof_on __read_mostly;
-EXPORT_SYMBOL_GPL(prof_on);
-
 static cpumask_t prof_cpu_mask = CPU_MASK_ALL;
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct profile_hit *[2], cpu_profile_hits);
@@ -52,6 +49,14 @@ static DEFINE_PER_CPU(int, cpu_profile_f
 static DEFINE_MUTEX(profile_flip_mutex);
 #endif /* CONFIG_SMP */
 
+/* Immediate values */
+immediate_char_t sleep_profiling __read_mostly,
+			sched_profiling __read_mostly,
+			kvm_profiling __read_mostly,
+			cpu_profiling __read_mostly;
+EXPORT_SYMBOL_GPL(kvm_profiling);
+EXPORT_SYMBOL_GPL(cpu_profiling);
+
 static int __init profile_setup(char * str)
 {
 	static char __initdata schedstr[] = "schedule";
@@ -60,7 +65,7 @@ static int __init profile_setup(char * s
 	int par;
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
-		prof_on = SLEEP_PROFILING;
+		immediate_set_early(&sleep_profiling, 1);
 		if (str[strlen(sleepstr)] == ',')
 			str += strlen(sleepstr) + 1;
 		if (get_option(&str, &par))
@@ -69,7 +74,7 @@ static int __init profile_setup(char * s
 			"kernel sleep profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
-		prof_on = SCHED_PROFILING;
+		immediate_set_early(&sched_profiling, 1);
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
 		if (get_option(&str, &par))
@@ -78,7 +83,7 @@ static int __init profile_setup(char * s
 			"kernel schedule profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
-		prof_on = KVM_PROFILING;
+		immediate_set_early(&kvm_profiling, 1);
 		if (str[strlen(kvmstr)] == ',')
 			str += strlen(kvmstr) + 1;
 		if (get_option(&str, &par))
@@ -88,7 +93,7 @@ static int __init profile_setup(char * s
 			prof_shift);
 	} else if (get_option(&str, &par)) {
 		prof_shift = par;
-		prof_on = CPU_PROFILING;
+		immediate_set_early(&cpu_profiling, 1);
 		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
 			prof_shift);
 	}
@@ -99,7 +104,10 @@ __setup("profile=", profile_setup);
 
 void __init profile_init(void)
 {
-	if (!prof_on) 
+	if (!_immediate_read(&sleep_profiling) &&
+		!_immediate_read(&sched_profiling) &&
+		!_immediate_read(&kvm_profiling) &&
+		!_immediate_read(&cpu_profiling))
 		return;
  
 	/* only text is profiled */
@@ -288,7 +296,7 @@ void profile_hits(int type, void *__pc, 
 	int i, j, cpu;
 	struct profile_hit *hits;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
 	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
@@ -398,7 +406,7 @@ void profile_hits(int type, void *__pc, 
 {
 	unsigned long pc;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
 	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
@@ -555,7 +563,10 @@ static int __init create_hash_tables(voi
 	}
 	return 0;
 out_cleanup:
-	prof_on = 0;
+	immediate_set_early(&sleep_profiling, 0);
+	immediate_set_early(&sched_profiling, 0);
+	immediate_set_early(&kvm_profiling, 0);
+	immediate_set_early(&cpu_profiling, 0);
 	smp_mb();
 	on_each_cpu(profile_nop, NULL, 0, 1);
 	for_each_online_cpu(cpu) {
@@ -582,7 +593,10 @@ static int __init create_proc_profile(vo
 {
 	struct proc_dir_entry *entry;
 
-	if (!prof_on)
+	if (!_immediate_read(&sleep_profiling) &&
+		!_immediate_read(&sched_profiling) &&
+		!_immediate_read(&kvm_profiling) &&
+		!_immediate_read(&cpu_profiling))
 		return 0;
 	if (create_hash_tables())
 		return -1;
Index: linux-2.6-lttng/include/linux/profile.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/profile.h	2007-08-27 11:16:08.000000000 -0400
+++ linux-2.6-lttng/include/linux/profile.h	2007-08-27 11:49:25.000000000 -0400
@@ -7,10 +7,12 @@
 #include <linux/init.h>
 #include <linux/cpumask.h>
 #include <linux/cache.h>
+#include <linux/immediate.h>
 
 #include <asm/errno.h>
 
-extern int prof_on __read_mostly;
+extern immediate_char_t sleep_profiling, sched_profiling, kvm_profiling,
+		cpu_profiling;
 
 #define CPU_PROFILING	1
 #define SCHED_PROFILING	2
@@ -35,11 +37,7 @@ void profile_hits(int, void *ip, unsigne
  */
 static inline void profile_hit(int type, void *ip)
 {
-	/*
-	 * Speedup for the common (no profiling enabled) case:
-	 */
-	if (unlikely(prof_on == type))
-		profile_hits(type, ip, 1);
+	profile_hits(type, ip, 1);
 }
 
 #ifdef CONFIG_PROC_FS
Index: linux-2.6-lttng/kernel/sched.c
===================================================================
--- linux-2.6-lttng.orig/kernel/sched.c	2007-08-27 11:16:08.000000000 -0400
+++ linux-2.6-lttng/kernel/sched.c	2007-08-27 11:49:25.000000000 -0400
@@ -3440,7 +3440,8 @@ static inline void schedule_debug(struct
 	if (unlikely(in_atomic_preempt_off()) && unlikely(!prev->exit_state))
 		__schedule_bug(prev);
 
-	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
+	immediate_if (&sched_profiling)
+		profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
 	schedstat_inc(this_rq(), sched_cnt);
 }
Index: linux-2.6-lttng/drivers/kvm/svm.c
===================================================================
--- linux-2.6-lttng.orig/drivers/kvm/svm.c	2007-08-27 11:16:08.000000000 -0400
+++ linux-2.6-lttng/drivers/kvm/svm.c	2007-08-27 11:49:25.000000000 -0400
@@ -1570,7 +1570,7 @@ again:
 	/*
 	 * Profile KVM exit RIPs:
 	 */
-	if (unlikely(prof_on == KVM_PROFILING))
+	immediate_if (&kvm_profiling)
 		profile_hit(KVM_PROFILING,
 			(void *)(unsigned long)svm->vmcb->save.rip);
 
Index: linux-2.6-lttng/drivers/kvm/vmx.c
===================================================================
--- linux-2.6-lttng.orig/drivers/kvm/vmx.c	2007-08-27 11:16:08.000000000 -0400
+++ linux-2.6-lttng/drivers/kvm/vmx.c	2007-08-27 11:49:25.000000000 -0400
@@ -2232,7 +2232,7 @@ again:
 	/*
 	 * Profile KVM exit RIPs:
 	 */
-	if (unlikely(prof_on == KVM_PROFILING))
+	immediate_if (&kvm_profiling)
 		profile_hit(KVM_PROFILING, (void *)vmcs_readl(GUEST_RIP));
 
 	r = kvm_handle_exit(kvm_run, vcpu);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
