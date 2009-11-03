Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZKCE2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZKCE2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbZKCE22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:28:28 -0500
Received: from ozlabs.org ([203.10.76.45]:39494 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941AbZKCE21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:28:27 -0500
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
       Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911031458.30987.rusty@rustcorp.com.au>
Date: Tue, 3 Nov 2009 14:58:30 +1030
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 11/14] cpumask: use modern cpumask style in arch/x86/kernel/cpu/mcheck/mce-inject.c
Cc: x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note that there's no freeing the cpu var, since this module has no
unload function.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -74,7 +74,7 @@ static void raise_exception(struct mce *
 	m->finished = 0;
 }
 
-static cpumask_t mce_inject_cpumask;
+static cpumask_var_t mce_inject_cpumask;
 
 static int mce_raise_notify(struct notifier_block *self,
 			    unsigned long val, void *data)
@@ -82,9 +82,9 @@ static int mce_raise_notify(struct notif
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
@@ -210,6 +210,8 @@ static ssize_t mce_write(struct file *fi
 
 static int inject_init(void)
 {
+	if (!alloc_cpumask_var(&mce_inject_cpumask, GFP_KERNEL))
+		return -ENOMEM;
 	printk(KERN_INFO "Machine check injector initialized\n");
 	mce_chrdev_ops.write = mce_write;
 	register_die_notifier(&mce_raise_nb);

