Return-Path: <linux-kernel-owner+w=401wt.eu-S1758445AbYAXUhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445AbYAXUhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbYAXUeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:34:15 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:58223 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757165AbYAXUeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:34:12 -0500
Message-Id: <20080124203340.878245788@polymtl.ca>
References: <20080124202706.250598537@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jan 2008 15:27:26 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 20/26] Scheduler Profiling - Use Immediate Values
Content-Disposition: inline; filename=profiling-use-immediate-values.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Jan 2008 20:33:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use immediate values with lower d-cache hit in optimized version as a
condition for scheduler profiling call.

Changelog :
- Use imv_* instead of immediate_*.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/x86/kvm/x86.c      |    2 +-
 include/linux/profile.h |    5 +++--
 kernel/profile.c        |   22 +++++++++++-----------
 kernel/sched_fair.c     |    6 +-----
 4 files changed, 16 insertions(+), 19 deletions(-)

Index: linux-2.6-lttng.mm/kernel/profile.c
===================================================================
--- linux-2.6-lttng.mm.orig/kernel/profile.c	2008-01-24 14:10:55.000000000 -0500
+++ linux-2.6-lttng.mm/kernel/profile.c	2008-01-24 14:31:44.000000000 -0500
@@ -41,8 +41,8 @@ static int (*timer_hook)(struct pt_regs 
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
 
-int prof_on __read_mostly;
-EXPORT_SYMBOL_GPL(prof_on);
+DEFINE_IMV(char, prof_on) __read_mostly;
+EXPORT_IMV_SYMBOL_GPL(prof_on);
 
 static cpumask_t prof_cpu_mask = CPU_MASK_ALL;
 #ifdef CONFIG_SMP
@@ -60,7 +60,7 @@ static int __init profile_setup(char *st
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
 #ifdef CONFIG_SCHEDSTATS
-		prof_on = SLEEP_PROFILING;
+		imv_set(prof_on, SLEEP_PROFILING);
 		if (str[strlen(sleepstr)] == ',')
 			str += strlen(sleepstr) + 1;
 		if (get_option(&str, &par))
@@ -73,7 +73,7 @@ static int __init profile_setup(char *st
 			"kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
 #endif /* CONFIG_SCHEDSTATS */
 	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
-		prof_on = SCHED_PROFILING;
+		imv_set(prof_on, SCHED_PROFILING);
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
 		if (get_option(&str, &par))
@@ -82,7 +82,7 @@ static int __init profile_setup(char *st
 			"kernel schedule profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
-		prof_on = KVM_PROFILING;
+		imv_set(prof_on, KVM_PROFILING);
 		if (str[strlen(kvmstr)] == ',')
 			str += strlen(kvmstr) + 1;
 		if (get_option(&str, &par))
@@ -92,7 +92,7 @@ static int __init profile_setup(char *st
 			prof_shift);
 	} else if (get_option(&str, &par)) {
 		prof_shift = par;
-		prof_on = CPU_PROFILING;
+		imv_set(prof_on, CPU_PROFILING);
 		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
 			prof_shift);
 	}
@@ -103,7 +103,7 @@ __setup("profile=", profile_setup);
 
 void __init profile_init(void)
 {
-	if (!prof_on)
+	if (!_imv_read(prof_on))
 		return;
 
 	/* only text is profiled */
@@ -290,7 +290,7 @@ void profile_hits(int type, void *__pc, 
 	int i, j, cpu;
 	struct profile_hit *hits;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
 	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
@@ -400,7 +400,7 @@ void profile_hits(int type, void *__pc, 
 {
 	unsigned long pc;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
 	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
@@ -557,7 +557,7 @@ static int __init create_hash_tables(voi
 	}
 	return 0;
 out_cleanup:
-	prof_on = 0;
+	imv_set(prof_on, 0);
 	smp_mb();
 	on_each_cpu(profile_nop, NULL, 0, 1);
 	for_each_online_cpu(cpu) {
@@ -584,7 +584,7 @@ static int __init create_proc_profile(vo
 {
 	struct proc_dir_entry *entry;
 
-	if (!prof_on)
+	if (!_imv_read(prof_on))
 		return 0;
 	if (create_hash_tables())
 		return -1;
Index: linux-2.6-lttng.mm/include/linux/profile.h
===================================================================
--- linux-2.6-lttng.mm.orig/include/linux/profile.h	2008-01-24 14:04:09.000000000 -0500
+++ linux-2.6-lttng.mm/include/linux/profile.h	2008-01-24 14:30:51.000000000 -0500
@@ -7,10 +7,11 @@
 #include <linux/init.h>
 #include <linux/cpumask.h>
 #include <linux/cache.h>
+#include <linux/immediate.h>
 
 #include <asm/errno.h>
 
-extern int prof_on __read_mostly;
+DECLARE_IMV(char, prof_on) __read_mostly;
 
 #define CPU_PROFILING	1
 #define SCHED_PROFILING	2
@@ -38,7 +39,7 @@ static inline void profile_hit(int type,
 	/*
 	 * Speedup for the common (no profiling enabled) case:
 	 */
-	if (unlikely(prof_on == type))
+	if (unlikely(imv_read(prof_on) == type))
 		profile_hits(type, ip, 1);
 }
 
Index: linux-2.6-lttng.mm/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.mm.orig/kernel/sched_fair.c	2008-01-24 14:10:55.000000000 -0500
+++ linux-2.6-lttng.mm/kernel/sched_fair.c	2008-01-24 14:30:51.000000000 -0500
@@ -461,12 +461,8 @@ static void enqueue_sleeper(struct cfs_r
 		 * get a milliseconds-range estimation of the amount of
 		 * time that the task spent sleeping:
 		 */
-		if (unlikely(prof_on == SLEEP_PROFILING)) {
-			struct task_struct *tsk = task_of(se);
-
-			profile_hits(SLEEP_PROFILING, (void *)get_wchan(tsk),
+		profile_hits(SLEEP_PROFILING, (void *)get_wchan(task_of(se)),
 				     delta >> 20);
-		}
 	}
 #endif
 }
Index: linux-2.6-lttng.mm/arch/x86/kvm/x86.c
===================================================================
--- linux-2.6-lttng.mm.orig/arch/x86/kvm/x86.c	2008-01-24 14:33:35.000000000 -0500
+++ linux-2.6-lttng.mm/arch/x86/kvm/x86.c	2008-01-24 14:34:08.000000000 -0500
@@ -2592,7 +2592,7 @@ again:
 	/*
 	 * Profile KVM exit RIPs:
 	 */
-	if (unlikely(prof_on == KVM_PROFILING)) {
+	if (unlikely(imv_read(prof_on) == KVM_PROFILING)) {
 		kvm_x86_ops->cache_regs(vcpu);
 		profile_hit(KVM_PROFILING, (void *)vcpu->arch.rip);
 	}

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
