Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbXLFCUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbXLFCUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbXLFCUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:20:04 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:61449 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbXLFCUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:20:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAOPqVkdMROHU/2dsb2JhbACBWg
Date: Wed, 5 Dec 2007 21:14:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] Scheduler Profiling - Use Immediate Values
Message-ID: <20071206021452.GA12256@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:13:30 up 32 days,  7:18,  7 users,  load average: 4.16, 1.82,
	1.07
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use immediate values with lower d-cache hit in optimized version as a
condition for scheduler profiling call.

Changelog :
- Use imv_* instead of immediate_*.

It applies on 2.6.24-rc4-git3. It depends on the Immediate Values
(redux) patchset.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 drivers/kvm/kvm_main.c  |    3 ++-
 include/linux/profile.h |    5 +++--
 kernel/profile.c        |   22 +++++++++++-----------
 kernel/sched_fair.c     |    6 +-----
 4 files changed, 17 insertions(+), 19 deletions(-)

Index: linux-2.6-lttng/kernel/profile.c
===================================================================
--- linux-2.6-lttng.orig/kernel/profile.c	2007-12-05 20:50:34.000000000 -0500
+++ linux-2.6-lttng/kernel/profile.c	2007-12-05 20:53:43.000000000 -0500
@@ -42,8 +42,8 @@ static int (*timer_hook)(struct pt_regs 
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
 
-int prof_on __read_mostly;
-EXPORT_SYMBOL_GPL(prof_on);
+DEFINE_IMV(char, prof_on) __read_mostly;
+EXPORT_IMV_SYMBOL_GPL(prof_on);
 
 static cpumask_t prof_cpu_mask = CPU_MASK_ALL;
 #ifdef CONFIG_SMP
@@ -61,7 +61,7 @@ static int __init profile_setup(char * s
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
 #ifdef CONFIG_SCHEDSTATS
-		prof_on = SLEEP_PROFILING;
+		imv_set(prof_on, SLEEP_PROFILING);
 		if (str[strlen(sleepstr)] == ',')
 			str += strlen(sleepstr) + 1;
 		if (get_option(&str, &par))
@@ -74,7 +74,7 @@ static int __init profile_setup(char * s
 			"kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
 #endif /* CONFIG_SCHEDSTATS */
 	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
-		prof_on = SCHED_PROFILING;
+		imv_set(prof_on, SCHED_PROFILING);
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
 		if (get_option(&str, &par))
@@ -83,7 +83,7 @@ static int __init profile_setup(char * s
 			"kernel schedule profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
-		prof_on = KVM_PROFILING;
+		imv_set(prof_on, KVM_PROFILING);
 		if (str[strlen(kvmstr)] == ',')
 			str += strlen(kvmstr) + 1;
 		if (get_option(&str, &par))
@@ -93,7 +93,7 @@ static int __init profile_setup(char * s
 			prof_shift);
 	} else if (get_option(&str, &par)) {
 		prof_shift = par;
-		prof_on = CPU_PROFILING;
+		imv_set(prof_on, CPU_PROFILING);
 		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
 			prof_shift);
 	}
@@ -104,7 +104,7 @@ __setup("profile=", profile_setup);
 
 void __init profile_init(void)
 {
-	if (!prof_on) 
+	if (!_imv_read(prof_on))
 		return;
  
 	/* only text is profiled */
@@ -293,7 +293,7 @@ void profile_hits(int type, void *__pc, 
 	int i, j, cpu;
 	struct profile_hit *hits;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
 	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
@@ -403,7 +403,7 @@ void profile_hits(int type, void *__pc, 
 {
 	unsigned long pc;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
 	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
@@ -560,7 +560,7 @@ static int __init create_hash_tables(voi
 	}
 	return 0;
 out_cleanup:
-	prof_on = 0;
+	imv_set(prof_on, 0);
 	smp_mb();
 	on_each_cpu(profile_nop, NULL, 0, 1);
 	for_each_online_cpu(cpu) {
@@ -587,7 +587,7 @@ static int __init create_proc_profile(vo
 {
 	struct proc_dir_entry *entry;
 
-	if (!prof_on)
+	if (!_imv_read(prof_on))
 		return 0;
 	if (create_hash_tables())
 		return -1;
Index: linux-2.6-lttng/include/linux/profile.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/profile.h	2007-12-05 20:50:34.000000000 -0500
+++ linux-2.6-lttng/include/linux/profile.h	2007-12-05 20:53:43.000000000 -0500
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
 
Index: linux-2.6-lttng/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6-lttng.orig/drivers/kvm/kvm_main.c	2007-12-05 20:50:34.000000000 -0500
+++ linux-2.6-lttng/drivers/kvm/kvm_main.c	2007-12-05 20:53:43.000000000 -0500
@@ -2053,7 +2053,8 @@ again:
 	/*
 	 * Profile KVM exit RIPs:
 	 */
-	if (unlikely(prof_on == KVM_PROFILING)) {
+
+	if (unlikely(imv_read(prof_on) == KVM_PROFILING)) {
 		kvm_x86_ops->cache_regs(vcpu);
 		profile_hit(KVM_PROFILING, (void *)vcpu->rip);
 	}
Index: linux-2.6-lttng/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.orig/kernel/sched_fair.c	2007-12-05 20:52:28.000000000 -0500
+++ linux-2.6-lttng/kernel/sched_fair.c	2007-12-05 20:53:43.000000000 -0500
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
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
