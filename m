Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbZLOThR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbZLOThR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbZLOThP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:37:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:35320 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359AbZLOThN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:37:13 -0500
Date: Tue, 15 Dec 2009 19:36:36 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
       mingo@redhat.com, rusty@rustcorp.com.au, ak@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, ak@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200911031458.30987.rusty@rustcorp.com.au>
References: <200911031458.30987.rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] cpumask: Use modern cpumask style in arch/x86/kernel/cpu/mcheck/mce-inject.c
Message-ID: <tip-6ac5c5310ca9d7dd3d7e677c2715b1f06a348330@git.kernel.org>
Git-Commit-ID: 6ac5c5310ca9d7dd3d7e677c2715b1f06a348330
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ac5c5310ca9d7dd3d7e677c2715b1f06a348330
Gitweb:     http://git.kernel.org/tip/6ac5c5310ca9d7dd3d7e677c2715b1f06a348330
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Tue, 3 Nov 2009 14:58:30 +1030
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 13:19:01 +0100

cpumask: Use modern cpumask style in arch/x86/kernel/cpu/mcheck/mce-inject.c

Note that there's no freeing the cpu var, since this module has
no unload function.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
LKML-Reference: <200911031458.30987.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 472763d..73734ba 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -74,7 +74,7 @@ static void raise_exception(struct mce *m, struct pt_regs *pregs)
 	m->finished = 0;
 }
 
-static cpumask_t mce_inject_cpumask;
+static cpumask_var_t mce_inject_cpumask;
 
 static int mce_raise_notify(struct notifier_block *self,
 			    unsigned long val, void *data)
@@ -82,9 +82,9 @@ static int mce_raise_notify(struct notifier_block *self,
 	struct die_args *args = (struct die_args *)data;
 	int cpu = smp_processor_id();
 	struct mce *m = &__get_cpu_var(injectm);
-	if (val != DIE_NMI_IPI || !cpu_isset(cpu, mce_inject_cpumask))
+	if (val != DIE_NMI_IPI || !cpumask_test_cpu(cpu, mce_inject_cpumask))
 		return NOTIFY_DONE;
-	cpu_clear(cpu, mce_inject_cpumask);
+	cpumask_clear_cpu(cpu, mce_inject_cpumask);
 	if (m->inject_flags & MCJ_EXCEPTION)
 		raise_exception(m, args->regs);
 	else if (m->status)
@@ -148,22 +148,22 @@ static void raise_mce(struct mce *m)
 		unsigned long start;
 		int cpu;
 		get_online_cpus();
-		mce_inject_cpumask = cpu_online_map;
-		cpu_clear(get_cpu(), mce_inject_cpumask);
+		cpumask_copy(mce_inject_cpumask, cpu_online_mask);
+		cpumask_clear_cpu(get_cpu(), mce_inject_cpumask);
 		for_each_online_cpu(cpu) {
 			struct mce *mcpu = &per_cpu(injectm, cpu);
 			if (!mcpu->finished ||
 			    MCJ_CTX(mcpu->inject_flags) != MCJ_CTX_RANDOM)
-				cpu_clear(cpu, mce_inject_cpumask);
+				cpumask_clear_cpu(cpu, mce_inject_cpumask);
 		}
-		if (!cpus_empty(mce_inject_cpumask))
-			apic->send_IPI_mask(&mce_inject_cpumask, NMI_VECTOR);
+		if (!cpumask_empty(mce_inject_cpumask))
+			apic->send_IPI_mask(mce_inject_cpumask, NMI_VECTOR);
 		start = jiffies;
-		while (!cpus_empty(mce_inject_cpumask)) {
+		while (!cpumask_empty(mce_inject_cpumask)) {
 			if (!time_before(jiffies, start + 2*HZ)) {
 				printk(KERN_ERR
 				"Timeout waiting for mce inject NMI %lx\n",
-					*cpus_addr(mce_inject_cpumask));
+					*cpumask_bits(mce_inject_cpumask));
 				break;
 			}
 			cpu_relax();
@@ -210,6 +210,8 @@ static ssize_t mce_write(struct file *filp, const char __user *ubuf,
 
 static int inject_init(void)
 {
+	if (!alloc_cpumask_var(&mce_inject_cpumask, GFP_KERNEL))
+		return -ENOMEM;
 	printk(KERN_INFO "Machine check injector initialized\n");
 	mce_chrdev_ops.write = mce_write;
 	register_die_notifier(&mce_raise_nb);
