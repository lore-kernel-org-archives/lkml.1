Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYDEBLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYDEBLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYDEBLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56565 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751642AbYDEBLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:03 -0400
Message-Id: <20080405011102.189956000@polaris-admin.engr.sgi.com>
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:11:08 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>, Cliff Wickman <cpw@sgi.com>
Subject: [PATCH 08/12] generic: reduce stack pressure in sched_affinity
Content-Disposition: inline; filename=cpumask_affinity
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Modify sched_affinity functions to pass cpumask_t variables by reference
    instead of by value.

  * Use new set_cpus_allowed_ptr function.

Depends on:
	[sched-devel]: sched: add new set_cpus_allowed_ptr function

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Jackson <pj@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |   46 ++++++++++++++++----------------
 include/linux/sched.h                   |    2 -
 kernel/compat.c                         |    2 -
 kernel/rcupreempt.c                     |    4 +-
 kernel/sched.c                          |    5 ++-
 5 files changed, 30 insertions(+), 29 deletions(-)

--- linux-2.6.x86.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ linux-2.6.x86/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -251,18 +251,18 @@ struct threshold_attr {
 	ssize_t(*store) (struct threshold_block *, const char *, size_t count);
 };
 
-static cpumask_t affinity_set(unsigned int cpu)
+static void affinity_set(unsigned int cpu, cpumask_t *oldmask,
+					   cpumask_t *newmask)
 {
-	cpumask_t oldmask = current->cpus_allowed;
-	cpumask_t newmask = CPU_MASK_NONE;
-	cpu_set(cpu, newmask);
-	set_cpus_allowed(current, newmask);
-	return oldmask;
+	*oldmask = current->cpus_allowed;
+	cpus_clear(*newmask);
+	cpu_set(cpu, *newmask);
+	set_cpus_allowed_ptr(current, newmask);
 }
 
-static void affinity_restore(cpumask_t oldmask)
+static void affinity_restore(const cpumask_t *oldmask)
 {
-	set_cpus_allowed(current, oldmask);
+	set_cpus_allowed_ptr(current, oldmask);
 }
 
 #define SHOW_FIELDS(name)                                           \
@@ -277,15 +277,15 @@ static ssize_t store_interrupt_enable(st
 				      const char *buf, size_t count)
 {
 	char *end;
-	cpumask_t oldmask;
+	cpumask_t oldmask, newmask;
 	unsigned long new = simple_strtoul(buf, &end, 0);
 	if (end == buf)
 		return -EINVAL;
 	b->interrupt_enable = !!new;
 
-	oldmask = affinity_set(b->cpu);
+	affinity_set(b->cpu, &oldmask, &newmask);
 	threshold_restart_bank(b, 0, 0);
-	affinity_restore(oldmask);
+	affinity_restore(&oldmask);
 
 	return end - buf;
 }
@@ -294,7 +294,7 @@ static ssize_t store_threshold_limit(str
 				     const char *buf, size_t count)
 {
 	char *end;
-	cpumask_t oldmask;
+	cpumask_t oldmask, newmask;
 	u16 old;
 	unsigned long new = simple_strtoul(buf, &end, 0);
 	if (end == buf)
@@ -306,9 +306,9 @@ static ssize_t store_threshold_limit(str
 	old = b->threshold_limit;
 	b->threshold_limit = new;
 
-	oldmask = affinity_set(b->cpu);
+	affinity_set(b->cpu, &oldmask, &newmask);
 	threshold_restart_bank(b, 0, old);
-	affinity_restore(oldmask);
+	affinity_restore(&oldmask);
 
 	return end - buf;
 }
@@ -316,10 +316,10 @@ static ssize_t store_threshold_limit(str
 static ssize_t show_error_count(struct threshold_block *b, char *buf)
 {
 	u32 high, low;
-	cpumask_t oldmask;
-	oldmask = affinity_set(b->cpu);
+	cpumask_t oldmask, newmask;
+	affinity_set(b->cpu, &oldmask, &newmask);
 	rdmsr(b->address, low, high);
-	affinity_restore(oldmask);
+	affinity_restore(&oldmask);
 	return sprintf(buf, "%x\n",
 		       (high & 0xFFF) - (THRESHOLD_MAX - b->threshold_limit));
 }
@@ -327,10 +327,10 @@ static ssize_t show_error_count(struct t
 static ssize_t store_error_count(struct threshold_block *b,
 				 const char *buf, size_t count)
 {
-	cpumask_t oldmask;
-	oldmask = affinity_set(b->cpu);
+	cpumask_t oldmask, newmask;
+	affinity_set(b->cpu, &oldmask, &newmask);
 	threshold_restart_bank(b, 1, 0);
-	affinity_restore(oldmask);
+	affinity_restore(&oldmask);
 	return 1;
 }
 
@@ -468,7 +468,7 @@ static __cpuinit int threshold_create_ba
 {
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
-	cpumask_t oldmask = CPU_MASK_NONE;
+	cpumask_t oldmask, newmask;
 	char name[32];
 
 	sprintf(name, "threshold_bank%i", bank);
@@ -519,10 +519,10 @@ static __cpuinit int threshold_create_ba
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
-	oldmask = affinity_set(cpu);
+	affinity_set(cpu, &oldmask, &newmask);
 	err = allocate_threshold_blocks(cpu, bank, 0,
 					MSR_IA32_MC0_MISC + bank * 4);
-	affinity_restore(oldmask);
+	affinity_restore(&oldmask);
 
 	if (err)
 		goto out_free;
--- linux-2.6.x86.orig/include/linux/sched.h
+++ linux-2.6.x86/include/linux/sched.h
@@ -2086,7 +2086,7 @@ ftrace_special(unsigned long arg1, unsig
 }
 #endif
 
-extern long sched_setaffinity(pid_t pid, cpumask_t new_mask);
+extern long sched_setaffinity(pid_t pid, const cpumask_t *new_mask);
 extern long sched_getaffinity(pid_t pid, cpumask_t *mask);
 
 extern int sched_mc_power_savings, sched_smt_power_savings;
--- linux-2.6.x86.orig/kernel/compat.c
+++ linux-2.6.x86/kernel/compat.c
@@ -446,7 +446,7 @@ asmlinkage long compat_sys_sched_setaffi
 	if (retval)
 		return retval;
 
-	return sched_setaffinity(pid, new_mask);
+	return sched_setaffinity(pid, &new_mask);
 }
 
 asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid, unsigned int len,
--- linux-2.6.x86.orig/kernel/rcupreempt.c
+++ linux-2.6.x86/kernel/rcupreempt.c
@@ -1005,10 +1005,10 @@ void __synchronize_sched(void)
 	if (sched_getaffinity(0, &oldmask) < 0)
 		oldmask = cpu_possible_map;
 	for_each_online_cpu(cpu) {
-		sched_setaffinity(0, cpumask_of_cpu(cpu));
+		sched_setaffinity(0, &cpumask_of_cpu(cpu));
 		schedule();
 	}
-	sched_setaffinity(0, oldmask);
+	sched_setaffinity(0, &oldmask);
 }
 EXPORT_SYMBOL_GPL(__synchronize_sched);
 
--- linux-2.6.x86.orig/kernel/sched.c
+++ linux-2.6.x86/kernel/sched.c
@@ -4963,9 +4963,10 @@ out_unlock:
 	return retval;
 }
 
-long sched_setaffinity(pid_t pid, cpumask_t new_mask)
+long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
 {
 	cpumask_t cpus_allowed;
+	cpumask_t new_mask = *in_mask;
 	struct task_struct *p;
 	int retval;
 
@@ -5046,7 +5047,7 @@ asmlinkage long sys_sched_setaffinity(pi
 	if (retval)
 		return retval;
 
-	return sched_setaffinity(pid, new_mask);
+	return sched_setaffinity(pid, &new_mask);
 }
 
 /*

-- 
