Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbZA1UFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbZA1UFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZA1UFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:05:04 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:25160 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZA1UFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:05:03 -0500
X-BigFish: VPS-3(zz1fa4Lzzzzz32i6bh65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KE76FQ-01-QTR-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: cpufreq@vger.kernel.org, lkml@vger.kernel.org
Subject: [PATCH] Determine latency from ACPI
Date: Tue, 27 Jan 2009 14:03:47 -0600
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200901271403.47731.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 28 Jan 2009 20:04:47.0678 (UTC) FILETIME=[AB9ECDE0:01C98183]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this time, the PowerNow! driver for K8 uses an experimentally 
derived formula to calculate transition latency.  The value it
provides is orders of magnitude too large on modern systems.
This patch replaces the formula with ACPI _PSS latency values
for more accuracy and better performance.

I've tested it on two 2nd generation Opteron systems, a 3rd
generation Operton system, and a Turion X2 without seeing any
stability problems.

-Mark Langsdorf
Operating System Research Center
AMD

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -931,10 +931,25 @@ static void powernow_k8_cpu_exit_acpi(st
 		acpi_processor_unregister_performance(&data->acpi_data, data->cpu);
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
@@ -1167,7 +1182,13 @@ static int __cpuinit powernowk8_cpu_init
 			kfree(data);
 			return -ENODEV;
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
@@ -1197,11 +1218,6 @@ static int __cpuinit powernowk8_cpu_init
 	else
 		pol->cpus = per_cpu(cpu_core_map, pol->cpu);
 	data->available_cores = &(pol->cpus);
-
-	/* Take a crude guess here.
-	 * That guess was in microseconds, so multiply with 1000 */
-	pol->cpuinfo.transition_latency = (((data->rvo + 8) * data->vstable * VST_UNITS_20US)
-	    + (3 * (1 << data->irt) * 10)) * 1000;
 
 	if (cpu_family == CPU_HW_PSTATE)
 		pol->cur = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);

