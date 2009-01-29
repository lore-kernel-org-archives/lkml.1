Return-Path: <linux-kernel-owner+w=401wt.eu-S1759141AbZA2Vxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141AbZA2Vxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZA2Vx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:53:28 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:58087 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbZA2Vx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:53:26 -0500
X-BigFish: VPS-1(zz1fa4Lzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KE964J-02-4U5-01
Content-Disposition: inline
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][retry 1] Determine latency from ACPI
Date: Thu, 29 Jan 2009 15:55:25 -0600
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-ID: <200901291555.25594.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 29 Jan 2009 21:53:19.0573 (UTC) FILETIME=[FF6CE050:01C9825B]
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

Resent this patch to merge with Yinghai Lu's
"x86/powernow: fix cpus_allowed brokage when acpi=off".

-Mark Langsdorf
Operating System Research Center
AMD

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -939,10 +939,25 @@ static void powernow_k8_cpu_exit_acpi(st
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
@@ -1145,8 +1160,9 @@ static int __cpuinit powernowk8_cpu_init
 	oldmask = current->cpus_allowed;
 
 	rc = powernow_k8_cpu_init_acpi(data);
-	if (!rc) {
+	if (!rc) { /* ACPI _PSS objects available */
 		k8_cpu_acpi_inited = 1;
+		pol->cpuinfo.transition_latency = get_transition_latency(data);
 	} else {
 		/*
 		 * Use the PSB BIOS structure. This is only availabe on
@@ -1181,6 +1197,11 @@ static int __cpuinit powernowk8_cpu_init
 		if (rc) {
 			goto err_out;
 		}
+		/* Take a crude guess here.
+		 * That guess was in microseconds, so multiply with 1000 */
+		pol->cpuinfo.transition_latency = (
+			 ((data->rvo + 8) * data->vstable * VST_UNITS_20US) +
+			 ((1 << data->irt) * 30)) * 1000;
 	}
 
 	/* only run on specific CPU from here on */
@@ -1210,11 +1231,6 @@ static int __cpuinit powernowk8_cpu_init
 	else
 		cpumask_copy(pol->cpus, &per_cpu(cpu_core_map, pol->cpu));
 	data->available_cores = pol->cpus;
-
-	/* Take a crude guess here.
-	 * That guess was in microseconds, so multiply with 1000 */
-	pol->cpuinfo.transition_latency = (((data->rvo + 8) * data->vstable * VST_UNITS_20US)
-	    + (3 * (1 << data->irt) * 10)) * 1000;
 
 	if (cpu_family == CPU_HW_PSTATE)
 		pol->cur = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);


