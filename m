Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbZBCQsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbZBCQsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZBCQq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:46:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:55971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbZBCQqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:46:52 -0500
From: Thomas Renninger <trenn@suse.de>
To: davej@codemonkey.org.uk
Cc: mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH 5/7] CPUFREQ: powernow-k8: Always compile powernow-k8 driver with ACPI support
Date: Tue,  3 Feb 2009 17:46:44 +0100
Message-Id: <1233679606-1971-6-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233679606-1971-1-git-send-email-trenn@suse.de>
References: <1233679606-1971-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powernow-k8 driver should always try to get cpufreq info from ACPI.
Otherwise it will not be able to detect the transition latency correctly
which results in ondemand governor taking a wrong sampling rate which will
then result in sever performance loss.

Let the user not shoot himself in the foot and always compile in ACPI
support for powernow-k8.

This also fixes a wrong message if ACPI_PROCESSOR is compiled as a module and
#ifndef CONFIG_ACPI_PROCESSOR
path is chosen.

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/kernel/cpu/cpufreq/Kconfig       |   19 ++-----------------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   17 -----------------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    5 +----
 3 files changed, 3 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/Kconfig b/arch/x86/kernel/cpu/cpufreq/Kconfig
index efae3b2..b63b0db 100644
--- a/arch/x86/kernel/cpu/cpufreq/Kconfig
+++ b/arch/x86/kernel/cpu/cpufreq/Kconfig
@@ -87,30 +87,15 @@ config X86_POWERNOW_K7_ACPI
 config X86_POWERNOW_K8
 	tristate "AMD Opteron/Athlon64 PowerNow!"
 	select CPU_FREQ_TABLE
+	depends on ACPI && ACPI_PROCESSOR
 	help
-	  This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processors.
+	  This adds the CPUFreq driver for K8/K10 Opteron/Athlon64 processors.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called powernow-k8.
 
 	  For details, take a look at <file:Documentation/cpu-freq/>.
 
-	  If in doubt, say N.
-
-config X86_POWERNOW_K8_ACPI
-	bool
-	prompt "ACPI Support" if X86_32
-	depends on ACPI && X86_POWERNOW_K8 && ACPI_PROCESSOR
-	depends on !(X86_POWERNOW_K8 = y && ACPI_PROCESSOR = m)
-	default y
-	help
-	  This provides access to the K8s Processor Performance States via ACPI.
-	  This driver is probably required for CPUFreq to work with multi-socket and
-	  SMP systems.  It is not required on at least some single-socket yet
-	  multi-core systems, even if SMP is enabled.
-
-	  It is safe to say Y here.
-
 config X86_GX_SUSPMOD
 	tristate "Cyrix MediaGX/NatSemi Geode Suspend Modulation"
 	depends on X86_32 && PCI
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index fb039cd..9accffb 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -38,11 +38,9 @@
 #include <asm/io.h>
 #include <asm/delay.h>
 
-#ifdef CONFIG_X86_POWERNOW_K8_ACPI
 #include <linux/acpi.h>
 #include <linux/mutex.h>
 #include <acpi/processor.h>
-#endif
 
 #define PFX "powernow-k8: "
 #define VERSION "version 2.20.00"
@@ -749,7 +747,6 @@ static int find_psb_table(struct powernow_k8_data *data)
 	return -ENODEV;
 }
 
-#ifdef CONFIG_X86_POWERNOW_K8_ACPI
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index)
 {
 	if (!data->acpi_data.state_count || (cpu_family == CPU_HW_PSTATE))
@@ -953,13 +950,6 @@ static int get_transition_latency(struct powernow_k8_data *data)
 	return 1000 * max_latency;
 }
 
-#else
-static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data) { return -ENODEV; }
-static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data) { return; }
-static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index) { return; }
-static int get_transition_latency(struct powernow_k8_data *data) { return 0; }
-#endif /* CONFIG_X86_POWERNOW_K8_ACPI */
-
 /* Take a frequency, and issue the fid/vid transition command */
 static int transition_frequency_fidvid(struct powernow_k8_data *data, unsigned int index)
 {
@@ -1164,18 +1154,11 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 		 * an UP version, and is deprecated by AMD.
 		 */
 		if (num_online_cpus() != 1) {
-#ifndef CONFIG_ACPI_PROCESSOR
-			printk(KERN_ERR PFX "ACPI Processor support is required "
-			       "for SMP systems but is absent. Please load the "
-			       "ACPI Processor module before starting this "
-			       "driver.\n");
-#else
 			printk(KERN_ERR FW_BUG PFX "Your BIOS does not provide"
 			       " ACPI _PSS objects in a way that Linux "
 			       "understands. Please report this to the Linux "
 			       "ACPI maintainers and complain to your BIOS "
 			       "vendor.\n");
-#endif
 			goto err_out;
 		}
 		if (pol->cpu != 0) {
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
index 8ecc75b..6c6698f 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -45,11 +45,10 @@ struct powernow_k8_data {
 	 * frequency is in kHz */
 	struct cpufreq_frequency_table  *powernow_table;
 
-#ifdef CONFIG_X86_POWERNOW_K8_ACPI
 	/* the acpi table needs to be kept. it's only available if ACPI was
 	 * used to determine valid frequency/vid/fid states */
 	struct acpi_processor_performance acpi_data;
-#endif
+
 	/* we need to keep track of associated cores, but let cpufreq
 	 * handle hotplug events - so just point at cpufreq pol->cpus
 	 * structure */
@@ -222,10 +221,8 @@ static int core_frequency_transition(struct powernow_k8_data *data, u32 reqfid);
 
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index);
 
-#ifdef CONFIG_X86_POWERNOW_K8_ACPI
 static int fill_powernow_table_pstate(struct powernow_k8_data *data, struct cpufreq_frequency_table *powernow_table);
 static int fill_powernow_table_fidvid(struct powernow_k8_data *data, struct cpufreq_frequency_table *powernow_table);
-#endif
 
 #ifdef CONFIG_SMP
 static inline void define_siblings(int cpu, cpumask_t cpu_sharedcore_mask[])
-- 
1.6.0.2

