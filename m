Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZBPHKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZBPHKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbZBPHKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:10:05 -0500
Received: from ozlabs.org ([203.10.76.45]:37800 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbZBPHKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:10:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] cpumask bugfixes (re-xmit)
Date: Mon, 16 Feb 2009 17:39:58 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902161739.58576.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Just the vital ones: the other two are speculative problems we can argue about
 separately).

The following changes since commit d2f8d7ee1a9b4650b4e43325b321801264f7c37a:
  Linus Torvalds (1):
        Linux 2.6.29-rc5

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Rusty Russell (2):
      cpumask: fix powernow-k8: partial revert of 2fdf66b491ac706657946442789ec644cc317e1a
      cpumask: Use cpu_*_mask accessors code: alpha

 arch/alpha/kernel/process.c               |    8 ++++----
 arch/alpha/kernel/smp.c                   |   12 ++++++------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   12 +++++++-----
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index f238370..8d0097f 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -93,8 +93,8 @@ common_shutdown_1(void *generic_ptr)
 	if (cpuid != boot_cpuid) {
 		flags |= 0x00040000UL; /* "remain halted" */
 		*pflags = flags;
-		cpu_clear(cpuid, cpu_present_map);
-		cpu_clear(cpuid, cpu_possible_map);
+		set_cpu_present(cpuid, false);
+		set_cpu_possible(cpuid, false);
 		halt();
 	}
 #endif
@@ -120,8 +120,8 @@ common_shutdown_1(void *generic_ptr)
 
 #ifdef CONFIG_SMP
 	/* Wait for the secondaries to halt. */
-	cpu_clear(boot_cpuid, cpu_present_map);
-	cpu_clear(boot_cpuid, cpu_possible_map);
+	set_cpu_present(boot_cpuid, false);
+	set_cpu_possible(boot_cpuid, false);
 	while (cpus_weight(cpu_present_map))
 		barrier();
 #endif
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 00f1dc3..b1fe567 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -120,12 +120,12 @@ void __cpuinit
 smp_callin(void)
 {
 	int cpuid = hard_smp_processor_id();
-	cpumask_t mask = cpu_online_map;
 
-	if (cpu_test_and_set(cpuid, mask)) {
+	if (cpu_online(cpuid)) {
 		printk("??, cpu 0x%x already present??\n", cpuid);
 		BUG();
 	}
+	set_cpu_online(cpuid, true);
 
 	/* Turn on machine checks.  */
 	wrmces(7);
@@ -436,8 +436,8 @@ setup_smp(void)
 				((char *)cpubase + i*hwrpb->processor_size);
 			if ((cpu->flags & 0x1cc) == 0x1cc) {
 				smp_num_probed++;
-				cpu_set(i, cpu_possible_map);
-				cpu_set(i, cpu_present_map);
+				set_cpu_possible(i, true);
+				set_cpu_present(i, true);
 				cpu->pal_revision = boot_cpu_palrev;
 			}
 
@@ -470,8 +470,8 @@ smp_prepare_cpus(unsigned int max_cpus)
 
 	/* Nothing to do on a UP box, or when told not to.  */
 	if (smp_num_probed == 1 || max_cpus == 0) {
-		cpu_possible_map = cpumask_of_cpu(boot_cpuid);
-		cpu_present_map = cpumask_of_cpu(boot_cpuid);
+		init_cpu_possible(cpumask_of(boot_cpuid));
+		init_cpu_present(cpumask_of(boot_cpuid));
 		printk(KERN_INFO "SMP mode deactivated.\n");
 		return;
 	}
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index fb039cd..6428aa1 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1157,8 +1157,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	data->cpu = pol->cpu;
 	data->currpstate = HW_PSTATE_INVALID;
 
-	rc = powernow_k8_cpu_init_acpi(data);
-	if (rc) {
+	if (powernow_k8_cpu_init_acpi(data)) {
 		/*
 		 * Use the PSB BIOS structure. This is only availabe on
 		 * an UP version, and is deprecated by AMD.
@@ -1176,17 +1175,20 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 			       "ACPI maintainers and complain to your BIOS "
 			       "vendor.\n");
 #endif
-			goto err_out;
+			kfree(data);
+			return -ENODEV;
 		}
 		if (pol->cpu != 0) {
 			printk(KERN_ERR FW_BUG PFX "No ACPI _PSS objects for "
 			       "CPU other than CPU0. Complain to your BIOS "
 			       "vendor.\n");
-			goto err_out;
+			kfree(data);
+			return -ENODEV;
 		}
 		rc = find_psb_table(data);
 		if (rc) {
-			goto err_out;
+			kfree(data);
+			return -ENODEV;
 		}
 		/* Take a crude guess here.
 		 * That guess was in microseconds, so multiply with 1000 */
