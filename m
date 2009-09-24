Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZIXOna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZIXOna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZIXOn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:43:29 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48240 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbZIXOnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:43:20 -0400
Message-Id: <20090924133400.673442330@polymtl.ca>
References: <20090924132626.485545323@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Sep 2009 09:26:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>, Adrian Bunk <bunk@stusta.de>,
       Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       akpm@osdl.org
Subject: [patch 11/12] Scheduler Profiling - Use Immediate Values
Content-Disposition: inline; filename=scheduler-profiling-use-immediate-values.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 24 Sep 2009 14:07:33 +0000
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
 kernel/ksysfs.c         |    4 ++--
 kernel/profile.c        |   22 +++++++++++-----------
 kernel/sched_fair.c     |    7 ++-----
 5 files changed, 19 insertions(+), 21 deletions(-)

Index: linux.trees.git/kernel/profile.c
===================================================================
--- linux.trees.git.orig/kernel/profile.c	2009-09-24 08:52:55.000000000 -0400
+++ linux.trees.git/kernel/profile.c	2009-09-24 09:03:02.000000000 -0400
@@ -42,8 +42,8 @@ static int (*timer_hook)(struct pt_regs 
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
 
-int prof_on __read_mostly;
-EXPORT_SYMBOL_GPL(prof_on);
+DEFINE_IMV(char, prof_on) __read_mostly;
+EXPORT_IMV_SYMBOL_GPL(prof_on);
 
 static cpumask_var_t prof_cpu_mask;
 #ifdef CONFIG_SMP
@@ -61,7 +61,7 @@ int profile_setup(char *str)
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
 #ifdef CONFIG_SCHEDSTATS
-		prof_on = SLEEP_PROFILING;
+		imv_set(prof_on, SLEEP_PROFILING);
 		if (str[strlen(sleepstr)] == ',')
 			str += strlen(sleepstr) + 1;
 		if (get_option(&str, &par))
@@ -74,7 +74,7 @@ int profile_setup(char *str)
 			"kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
 #endif /* CONFIG_SCHEDSTATS */
 	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
-		prof_on = SCHED_PROFILING;
+		imv_set(prof_on, SCHED_PROFILING);
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
 		if (get_option(&str, &par))
@@ -83,7 +83,7 @@ int profile_setup(char *str)
 			"kernel schedule profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
-		prof_on = KVM_PROFILING;
+		imv_set(prof_on, KVM_PROFILING);
 		if (str[strlen(kvmstr)] == ',')
 			str += strlen(kvmstr) + 1;
 		if (get_option(&str, &par))
@@ -93,7 +93,7 @@ int profile_setup(char *str)
 			prof_shift);
 	} else if (get_option(&str, &par)) {
 		prof_shift = par;
-		prof_on = CPU_PROFILING;
+		imv_set(prof_on, CPU_PROFILING);
 		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
 			prof_shift);
 	}
@@ -105,7 +105,7 @@ __setup("profile=", profile_setup);
 int __ref profile_init(void)
 {
 	int buffer_bytes;
-	if (!prof_on)
+	if (!_imv_read(prof_on))
 		return 0;
 
 	/* only text is profiled */
@@ -309,7 +309,7 @@ void profile_hits(int type, void *__pc, 
 	int i, j, cpu;
 	struct profile_hit *hits;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
 	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
@@ -421,7 +421,7 @@ void profile_hits(int type, void *__pc, 
 {
 	unsigned long pc;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
 	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
@@ -585,7 +585,7 @@ static int create_hash_tables(void)
 	}
 	return 0;
 out_cleanup:
-	prof_on = 0;
+	imv_set(prof_on, 0);
 	smp_mb();
 	on_each_cpu(profile_nop, NULL, 1);
 	for_each_online_cpu(cpu) {
@@ -612,7 +612,7 @@ int __ref create_proc_profile(void) /* f
 {
 	struct proc_dir_entry *entry;
 
-	if (!prof_on)
+	if (!_imv_read(prof_on))
 		return 0;
 	if (create_hash_tables())
 		return -ENOMEM;
Index: linux.trees.git/include/linux/profile.h
===================================================================
--- linux.trees.git.orig/include/linux/profile.h	2008-10-30 20:22:52.000000000 -0400
+++ linux.trees.git/include/linux/profile.h	2009-09-24 09:03:02.000000000 -0400
@@ -5,6 +5,7 @@
 #include <linux/init.h>
 #include <linux/cpumask.h>
 #include <linux/cache.h>
+#include <linux/immediate.h>
 
 #include <asm/errno.h>
 
@@ -38,7 +39,7 @@ enum profile_type {
 
 #ifdef CONFIG_PROFILING
 
-extern int prof_on __read_mostly;
+DECLARE_IMV(char, prof_on) __read_mostly;
 
 /* init basic kernel profiler */
 int profile_init(void);
@@ -58,7 +59,7 @@ static inline void profile_hit(int type,
 	/*
 	 * Speedup for the common (no profiling enabled) case:
 	 */
-	if (unlikely(prof_on == type))
+	if (unlikely(imv_read(prof_on) == type))
 		profile_hits(type, ip, 1);
 }
 
Index: linux.trees.git/kernel/sched_fair.c
===================================================================
--- linux.trees.git.orig/kernel/sched_fair.c	2009-09-24 08:52:55.000000000 -0400
+++ linux.trees.git/kernel/sched_fair.c	2009-09-24 09:03:56.000000000 -0400
@@ -672,11 +672,8 @@ static void enqueue_sleeper(struct cfs_r
 			 * 20 to get a milliseconds-range estimation of the
 			 * amount of time that the task spent sleeping:
 			 */
-			if (unlikely(prof_on == SLEEP_PROFILING)) {
-				profile_hits(SLEEP_PROFILING,
-						(void *)get_wchan(tsk),
-						delta >> 20);
-			}
+			profile_hits(SLEEP_PROFILING, (void *)get_wchan(tsk),
+				     delta >> 20);
 			account_scheduler_latency(tsk, delta >> 10, 0);
 		}
 	}
Index: linux.trees.git/arch/x86/kvm/x86.c
===================================================================
--- linux.trees.git.orig/arch/x86/kvm/x86.c	2009-09-24 08:52:42.000000000 -0400
+++ linux.trees.git/arch/x86/kvm/x86.c	2009-09-24 09:03:02.000000000 -0400
@@ -3672,7 +3672,7 @@ static int vcpu_enter_guest(struct kvm_v
 	/*
 	 * Profile KVM exit RIPs:
 	 */
-	if (unlikely(prof_on == KVM_PROFILING)) {
+	if (unlikely(imv_read(prof_on) == KVM_PROFILING)) {
 		unsigned long rip = kvm_rip_read(vcpu);
 		profile_hit(KVM_PROFILING, (void *)rip);
 	}
Index: linux.trees.git/kernel/ksysfs.c
===================================================================
--- linux.trees.git.orig/kernel/ksysfs.c	2009-03-06 13:29:01.000000000 -0500
+++ linux.trees.git/kernel/ksysfs.c	2009-09-24 09:03:02.000000000 -0400
@@ -58,7 +58,7 @@ KERNEL_ATTR_RW(uevent_helper);
 static ssize_t profiling_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", prof_on);
+	return sprintf(buf, "%d\n", _imv_read(prof_on));
 }
 static ssize_t profiling_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
@@ -66,7 +66,7 @@ static ssize_t profiling_store(struct ko
 {
 	int ret;
 
-	if (prof_on)
+	if (_imv_read(prof_on))
 		return -EEXIST;
 	/*
 	 * This eventually calls into get_option() which

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
