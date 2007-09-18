Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbXIRVoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbXIRVoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbXIRVoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:44:13 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58132 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbXIRVoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:44:12 -0400
Message-Id: <20070918210854.551546353@polymtl.ca>
References: <20070918210747.828804366@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 17:07:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 7/7] Scheduler Profiling - Use Immediate Values
Content-Disposition: inline; filename=profiling-use-immediate-values.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 18 Sep 2007 21:44:07 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use immediate values with lower d-cache hit in optimized version as a
condition for scheduler profiling call.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 drivers/kvm/kvm_main.c  |    3 ++-
 include/linux/profile.h |    5 +++--
 kernel/profile.c        |   22 +++++++++++-----------
 3 files changed, 16 insertions(+), 14 deletions(-)

Index: linux-2.6-lttng/kernel/profile.c
===================================================================
--- linux-2.6-lttng.orig/kernel/profile.c	2007-09-18 10:09:12.000000000 -0400
+++ linux-2.6-lttng/kernel/profile.c	2007-09-18 13:15:15.000000000 -0400
@@ -42,8 +42,8 @@ static int (*timer_hook)(struct pt_regs 
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
 
-int prof_on __read_mostly;
-EXPORT_SYMBOL_GPL(prof_on);
+DEFINE_IMMEDIATE(char, prof_on) __read_mostly;
+EXPORT_IMMEDIATE_SYMBOL_GPL(prof_on);
 
 static cpumask_t prof_cpu_mask = CPU_MASK_ALL;
 #ifdef CONFIG_SMP
@@ -60,7 +60,7 @@ static int __init profile_setup(char * s
 	int par;
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
-		prof_on = SLEEP_PROFILING;
+		immediate_set_early(prof_on, SLEEP_PROFILING);
 		if (str[strlen(sleepstr)] == ',')
 			str += strlen(sleepstr) + 1;
 		if (get_option(&str, &par))
@@ -69,7 +69,7 @@ static int __init profile_setup(char * s
 			"kernel sleep profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
-		prof_on = SCHED_PROFILING;
+		immediate_set_early(prof_on, SCHED_PROFILING);
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
 		if (get_option(&str, &par))
@@ -78,7 +78,7 @@ static int __init profile_setup(char * s
 			"kernel schedule profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
-		prof_on = KVM_PROFILING;
+		immediate_set_early(prof_on, KVM_PROFILING);
 		if (str[strlen(kvmstr)] == ',')
 			str += strlen(kvmstr) + 1;
 		if (get_option(&str, &par))
@@ -88,7 +88,7 @@ static int __init profile_setup(char * s
 			prof_shift);
 	} else if (get_option(&str, &par)) {
 		prof_shift = par;
-		prof_on = CPU_PROFILING;
+		immediate_set_early(prof_on, CPU_PROFILING);
 		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
 			prof_shift);
 	}
@@ -99,7 +99,7 @@ __setup("profile=", profile_setup);
 
 void __init profile_init(void)
 {
-	if (!prof_on) 
+	if (!_immediate_read(prof_on))
 		return;
  
 	/* only text is profiled */
@@ -288,7 +288,7 @@ void profile_hits(int type, void *__pc, 
 	int i, j, cpu;
 	struct profile_hit *hits;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
 	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
@@ -398,7 +398,7 @@ void profile_hits(int type, void *__pc, 
 {
 	unsigned long pc;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
 	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
@@ -555,7 +555,7 @@ static int __init create_hash_tables(voi
 	}
 	return 0;
 out_cleanup:
-	prof_on = 0;
+	immediate_set_early(prof_on, 0);
 	smp_mb();
 	on_each_cpu(profile_nop, NULL, 0, 1);
 	for_each_online_cpu(cpu) {
@@ -582,7 +582,7 @@ static int __init create_proc_profile(vo
 {
 	struct proc_dir_entry *entry;
 
-	if (!prof_on)
+	if (!_immediate_read(prof_on))
 		return 0;
 	if (create_hash_tables())
 		return -1;
Index: linux-2.6-lttng/include/linux/profile.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/profile.h	2007-09-18 10:09:12.000000000 -0400
+++ linux-2.6-lttng/include/linux/profile.h	2007-09-18 13:15:15.000000000 -0400
@@ -7,10 +7,11 @@
 #include <linux/init.h>
 #include <linux/cpumask.h>
 #include <linux/cache.h>
+#include <linux/immediate.h>
 
 #include <asm/errno.h>
 
-extern int prof_on __read_mostly;
+DECLARE_IMMEDIATE(char, prof_on) __read_mostly;
 
 #define CPU_PROFILING	1
 #define SCHED_PROFILING	2
@@ -38,7 +39,7 @@ static inline void profile_hit(int type,
 	/*
 	 * Speedup for the common (no profiling enabled) case:
 	 */
-	if (unlikely(prof_on == type))
+	if (unlikely(immediate_read(prof_on) == type))
 		profile_hits(type, ip, 1);
 }
 
Index: linux-2.6-lttng/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6-lttng.orig/drivers/kvm/kvm_main.c	2007-09-18 13:16:26.000000000 -0400
+++ linux-2.6-lttng/drivers/kvm/kvm_main.c	2007-09-18 13:18:04.000000000 -0400
@@ -2063,7 +2063,8 @@ again:
 	/*
 	 * Profile KVM exit RIPs:
 	 */
-	if (unlikely(prof_on == KVM_PROFILING)) {
+
+	if (unlikely(immediate_read(prof_on) == KVM_PROFILING)) {
 		kvm_x86_ops->cache_regs(vcpu);
 		profile_hit(KVM_PROFILING, (void *)vcpu->rip);
 	}

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
