Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbXGCRIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbXGCRIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbXGCRIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:08:36 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51974 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbXGCRIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:08:35 -0400
Message-Id: <20070703164516.377240547@polymtl.ca>
References: <20070703164046.645090494@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:40:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 10/10] Scheduler profiling - Use immediate values
Content-Disposition: inline; filename=profiling-use-immediate-values.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 17:08:31 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use immediate values with lower d-cache hit in optimized version as a
condition for scheduler profiling call.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

---
 drivers/kvm/svm.c       |    2 +-
 drivers/kvm/vmx.c       |    2 +-
 include/linux/profile.h |    9 +++------
 kernel/profile.c        |   37 +++++++++++++++++++++++++------------
 kernel/sched.c          |    3 ++-
 5 files changed, 32 insertions(+), 21 deletions(-)

Index: linux-2.6-lttng/kernel/profile.c
===================================================================
--- linux-2.6-lttng.orig/kernel/profile.c	2007-06-29 12:21:08.000000000 -0400
+++ linux-2.6-lttng/kernel/profile.c	2007-06-29 14:26:42.000000000 -0400
@@ -23,6 +23,7 @@
 #include <linux/profile.h>
 #include <linux/highmem.h>
 #include <linux/mutex.h>
+#include <linux/immediate.h>
 #include <asm/sections.h>
 #include <asm/semaphore.h>
 #include <asm/irq_regs.h>
@@ -42,9 +43,6 @@
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
 
-int prof_on __read_mostly;
-EXPORT_SYMBOL_GPL(prof_on);
-
 static cpumask_t prof_cpu_mask = CPU_MASK_ALL;
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct profile_hit *[2], cpu_profile_hits);
@@ -52,6 +50,12 @@
 static DEFINE_MUTEX(profile_flip_mutex);
 #endif /* CONFIG_SMP */
 
+/* Immediate values */
+immediate_t __read_mostly sleep_profiling, sched_profiling, kvm_profiling,
+	cpu_profiling;
+EXPORT_SYMBOL_GPL(kvm_profiling);
+EXPORT_SYMBOL_GPL(cpu_profiling);
+
 static int __init profile_setup(char * str)
 {
 	static char __initdata schedstr[] = "schedule";
@@ -60,7 +64,7 @@
 	int par;
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
-		prof_on = SLEEP_PROFILING;
+		immediate_arm(&sleep_profiling);
 		if (str[strlen(sleepstr)] == ',')
 			str += strlen(sleepstr) + 1;
 		if (get_option(&str, &par))
@@ -69,7 +73,7 @@
 			"kernel sleep profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
-		prof_on = SCHED_PROFILING;
+		immediate_arm(&sched_profiling);
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
 		if (get_option(&str, &par))
@@ -78,7 +82,7 @@
 			"kernel schedule profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
-		prof_on = KVM_PROFILING;
+		immediate_arm(&kvm_profiling);
 		if (str[strlen(kvmstr)] == ',')
 			str += strlen(kvmstr) + 1;
 		if (get_option(&str, &par))
@@ -88,7 +92,7 @@
 			prof_shift);
 	} else if (get_option(&str, &par)) {
 		prof_shift = par;
-		prof_on = CPU_PROFILING;
+		immediate_arm(&cpu_profiling);
 		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
 			prof_shift);
 	}
@@ -99,7 +103,10 @@
 
 void __init profile_init(void)
 {
-	if (!prof_on) 
+	if (!immediate_query(&sleep_profiling) &&
+		!immediate_query(&sched_profiling) &&
+		!immediate_query(&kvm_profiling) &&
+		!immediate_query(&cpu_profiling))
 		return;
  
 	/* only text is profiled */
@@ -288,7 +295,7 @@
 	int i, j, cpu;
 	struct profile_hit *hits;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
 	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
@@ -398,7 +405,7 @@
 {
 	unsigned long pc;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
 	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
@@ -555,7 +562,10 @@
 	}
 	return 0;
 out_cleanup:
-	prof_on = 0;
+	immediate_disarm(&sleep_profiling);
+	immediate_disarm(&sched_profiling);
+	immediate_disarm(&kvm_profiling);
+	immediate_disarm(&cpu_profiling);
 	smp_mb();
 	on_each_cpu(profile_nop, NULL, 0, 1);
 	for_each_online_cpu(cpu) {
@@ -582,7 +592,10 @@
 {
 	struct proc_dir_entry *entry;
 
-	if (!prof_on)
+	if (!immediate_query(&sleep_profiling) &&
+		!immediate_query(&sched_profiling) &&
+		!immediate_query(&kvm_profiling) &&
+		!immediate_query(&cpu_profiling))
 		return 0;
 	if (create_hash_tables())
 		return -1;
Index: linux-2.6-lttng/include/linux/profile.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/profile.h	2007-06-29 10:21:44.000000000 -0400
+++ linux-2.6-lttng/include/linux/profile.h	2007-06-29 14:26:42.000000000 -0400
@@ -10,7 +10,8 @@
 
 #include <asm/errno.h>
 
-extern int prof_on __read_mostly;
+extern immediate_t __read_mostly sleep_profiling, sched_profiling, kvm_profiling,
+		cpu_profiling;
 
 #define CPU_PROFILING	1
 #define SCHED_PROFILING	2
@@ -35,11 +36,7 @@
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
--- linux-2.6-lttng.orig/kernel/sched.c	2007-06-29 14:16:23.000000000 -0400
+++ linux-2.6-lttng/kernel/sched.c	2007-06-29 14:27:26.000000000 -0400
@@ -3241,7 +3241,8 @@
 	if (unlikely(in_atomic_preempt_off()) && unlikely(!prev->exit_state))
 		__schedule_bug(prev);
 
-	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
+	if (unlikely(immediate(sched_profiling)))
+		profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
 	schedstat_inc(this_rq(), sched_cnt);
 }
Index: linux-2.6-lttng/drivers/kvm/svm.c
===================================================================
--- linux-2.6-lttng.orig/drivers/kvm/svm.c	2007-06-29 12:27:40.000000000 -0400
+++ linux-2.6-lttng/drivers/kvm/svm.c	2007-06-29 14:26:42.000000000 -0400
@@ -1654,7 +1654,7 @@
 	/*
 	 * Profile KVM exit RIPs:
 	 */
-	if (unlikely(prof_on == KVM_PROFILING))
+	if (unlikely(immediate(kvm_profiling)))
 		profile_hit(KVM_PROFILING,
 			(void *)(unsigned long)vcpu->svm->vmcb->save.rip);
 
Index: linux-2.6-lttng/drivers/kvm/vmx.c
===================================================================
--- linux-2.6-lttng.orig/drivers/kvm/vmx.c	2007-06-29 12:27:40.000000000 -0400
+++ linux-2.6-lttng/drivers/kvm/vmx.c	2007-06-29 14:26:42.000000000 -0400
@@ -2156,7 +2156,7 @@
 	/*
 	 * Profile KVM exit RIPs:
 	 */
-	if (unlikely(prof_on == KVM_PROFILING))
+	if (unlikely(immediate(kvm_profiling)))
 		profile_hit(KVM_PROFILING, (void *)vmcs_readl(GUEST_RIP));
 
 	vcpu->launched = 1;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
