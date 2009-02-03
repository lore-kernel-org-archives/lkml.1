Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbZBCQsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbZBCQsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbZBCQq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:46:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:55973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbZBCQqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:46:52 -0500
From: Thomas Renninger <trenn@suse.de>
To: davej@codemonkey.org.uk
Cc: mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH 4/7] CPUFREQ: powernow-k8: Get transition latency from ACPI _PSS table
Date: Tue,  3 Feb 2009 17:46:43 +0100
Message-Id: <1233679606-1971-5-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233679606-1971-1-git-send-email-trenn@suse.de>
References: <1233679606-1971-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Langsdorf <mark.langsdorf@amd.com>

At this time, the PowerNow! driver for K8 uses an experimentally
derived formula to calculate transition latency.  The value it
provides is orders of magnitude too large on modern systems.
This patch replaces the formula with ACPI _PSS latency values
for more accuracy and better performance.

I've tested it on two 2nd generation Opteron systems, a 3rd
generation Operton system, and a Turion X2 without seeing any
stability problems.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 5c28b37..fb039cd 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -939,10 +939,25 @@ static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data)
 	free_cpumask_var(data->acpi_data.shared_cpu_map);
 }
 
+static int get_transition_latency(struct powernow_k8_data *data)
+{
+	int max_latency = 0;
+	int i;
+	for (i = 0; i < data->acpi_data.state_count; i++) {
+		int cur_latency = data->acpi_data.states[i].transition_latency
+			+ data->acpi_data.states[i].bus_master_latency;
+		if (cur_latency > max_latency)
+			max_latency = cur_latency;
+	}
+	/* value in usecs, needs to be in nanoseconds */
+	return 1000 * max_latency;
+}
+
 #else
 static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data) { return -ENODEV; }
 static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data) { return; }
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index) { return; }
+static int get_transition_latency(struct powernow_k8_data *data) { return 0; }
 #endif /* CONFIG_X86_POWERNOW_K8_ACPI */
 
 /* Take a frequency, and issue the fid/vid transition command */
@@ -1173,7 +1188,13 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 		if (rc) {
 			goto err_out;
 		}
-	}
+		/* Take a crude guess here.
+		 * That guess was in microseconds, so multiply with 1000 */
+		pol->cpuinfo.transition_latency = (
+			 ((data->rvo + 8) * data->vstable * VST_UNITS_20US) +
+			 ((1 << data->irt) * 30)) * 1000;
+	} else /* ACPI _PSS objects available */
+		pol->cpuinfo.transition_latency = get_transition_latency(data);
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
@@ -1204,11 +1225,6 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 		cpumask_copy(pol->cpus, &per_cpu(cpu_core_map, pol->cpu));
 	data->available_cores = pol->cpus;
 
-	/* Take a crude guess here.
-	 * That guess was in microseconds, so multiply with 1000 */
-	pol->cpuinfo.transition_latency = (((data->rvo + 8) * data->vstable * VST_UNITS_20US)
-	    + (3 * (1 << data->irt) * 10)) * 1000;
-
 	if (cpu_family == CPU_HW_PSTATE)
 		pol->cur = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);
 	else
-- 
1.6.0.2

