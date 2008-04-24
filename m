Return-Path: <linux-kernel-owner+w=401wt.eu-S1764493AbYDXP1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764493AbYDXP1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760352AbYDXPQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:16:22 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56807 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760336AbYDXPQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:16:20 -0400
Message-Id: <20080424151403.749010234@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>, Adrian Bunk <bunk@stusta.de>,
       Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       akpm@osdl.org
Subject: [patch 26/37] Scheduler Profiling - Use Immediate Values
Content-Disposition: inline; filename=scheduler-profiling-use-immediate-values.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:14:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use immediate values with lower d-cache hit in optimized version as a
condition for scheduler profiling call.

Changelog :
- Use imv_* instead of immediate_*.
- Follow the white rabbit : kvm_main.c which becomes x86.c.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Christoph Hellwig <hch@infradead.org>
CC: mingo@elte.hu
CC: akpm@osdl.org
---
 arch/x86/kvm/x86.c      |    2 +-
 include/linux/profile.h |    5 +++--
 kernel/profile.c        |   22 +++++++++++-----------
 kernel/sched_fair.c     |    5 +----
 4 files changed, 16 insertions(+), 18 deletions(-)

Index: linux-2.6-sched-devel/kernel/profile.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/profile.c	2008-04-22 20:04:13.000000000 -0400
+++ linux-2.6-sched-devel/kernel/profile.c	2008-04-22 20:23:26.000000000 -0400
@@ -40,8 +40,8 @@ static int (*timer_hook)(struct pt_regs 
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
 
-int prof_on __read_mostly;
-EXPORT_SYMBOL_GPL(prof_on);
+DEFINE_IMV(char, prof_on) __read_mostly;
+EXPORT_IMV_SYMBOL_GPL(prof_on);
 
 static cpumask_t prof_cpu_mask = CPU_MASK_ALL;
 #ifdef CONFIG_SMP
@@ -59,7 +59,7 @@ static int __init profile_setup(char *st
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
 #ifdef CONFIG_SCHEDSTATS
-		prof_on = SLEEP_PROFILING;
+		imv_set(prof_on, SLEEP_PROFILING);
 		if (str[strlen(sleepstr)] == ',')
 			str += strlen(sleepstr) + 1;
 		if (get_option(&str, &par))
@@ -72,7 +72,7 @@ static int __init profile_setup(char *st
 			"kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
 #endif /* CONFIG_SCHEDSTATS */
 	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
-		prof_on = SCHED_PROFILING;
+		imv_set(prof_on, SCHED_PROFILING);
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
 		if (get_option(&str, &par))
@@ -81,7 +81,7 @@ static int __init profile_setup(char *st
 			"kernel schedule profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
-		prof_on = KVM_PROFILING;
+		imv_set(prof_on, KVM_PROFILING);
 		if (str[strlen(kvmstr)] == ',')
 			str += strlen(kvmstr) + 1;
 		if (get_option(&str, &par))
@@ -91,7 +91,7 @@ static int __init profile_setup(char *st
 			prof_shift);
 	} else if (get_option(&str, &par)) {
 		prof_shift = par;
-		prof_on = CPU_PROFILING;
+		imv_set(prof_on, CPU_PROFILING);
 		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
 			prof_shift);
 	}
@@ -102,7 +102,7 @@ __setup("profile=", profile_setup);
 
 void __init profile_init(void)
 {
-	if (!prof_on)
+	if (!_imv_read(prof_on))
 		return;
 
 	/* only text is profiled */
@@ -289,7 +289,7 @@ void profile_hits(int type, void *__pc, 
 	int i, j, cpu;
 	struct profile_hit *hits;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
 	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
@@ -399,7 +399,7 @@ void profile_hits(int type, void *__pc, 
 {
 	unsigned long pc;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
 	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
@@ -556,7 +556,7 @@ static int __init create_hash_tables(voi
 	}
 	return 0;
 out_cleanup:
-	prof_on = 0;
+	imv_set(prof_on, 0);
 	smp_mb();
 	on_each_cpu(profile_nop, NULL, 0, 1);
 	for_each_online_cpu(cpu) {
@@ -583,7 +583,7 @@ static int __init create_proc_profile(vo
 {
 	struct proc_dir_entry *entry;
 
-	if (!prof_on)
+	if (!_imv_read(prof_on))
 		return 0;
 	if (create_hash_tables())
 		return -1;
Index: linux-2.6-sched-devel/include/linux/profile.h
===================================================================
--- linux-2.6-sched-devel.orig/include/linux/profile.h	2008-04-19 17:41:23.000000000 -0400
+++ linux-2.6-sched-devel/include/linux/profile.h	2008-04-22 20:23:26.000000000 -0400
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
 
Index: linux-2.6-sched-devel/kernel/sched_fair.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/sched_fair.c	2008-04-22 20:04:13.000000000 -0400
+++ linux-2.6-sched-devel/kernel/sched_fair.c	2008-04-22 20:23:26.000000000 -0400
@@ -616,11 +616,8 @@ static void enqueue_sleeper(struct cfs_r
 		 * get a milliseconds-range estimation of the amount of
 		 * time that the task spent sleeping:
 		 */
-		if (unlikely(prof_on == SLEEP_PROFILING)) {
-
-			profile_hits(SLEEP_PROFILING, (void *)get_wchan(tsk),
+		profile_hits(SLEEP_PROFILING, (void *)get_wchan(task_of(se)),
 				     delta >> 20);
-		}
 		account_scheduler_latency(tsk, delta >> 10, 0);
 	}
 #endif
Index: linux-2.6-sched-devel/arch/x86/kvm/x86.c
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/kvm/x86.c	2008-04-19 17:41:23.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/kvm/x86.c	2008-04-22 20:23:26.000000000 -0400
@@ -2604,7 +2604,7 @@ again:
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
