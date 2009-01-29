Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbZA2E6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbZA2E6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZA2E6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:58:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:41191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbZA2E6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:58:10 -0500
Message-ID: <498136FC.2020206@kernel.org>
Date: Wed, 28 Jan 2009 20:56:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Dave Jones" <davej@redhat.com>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: [PATCH] x86/powernow: fix cpus_allowed brokage when acpi=off
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix current->cpus_allowed overwriting.

on one AMD Fam10h SMP system:
when checking numactl output, when acpi=off
found output is not right.

# numactl --show
policy: default
preferred node: current
physcpubind: 5 7 10 11 12 13
cpubind: 1 2 3
nodebind: 1 2 3
membind: 0 1 2 3

it turns out in powernowk8_cpu_init there is path ( ACPI is off or _PSS is not there)
it will try to overwrite current->cpus_allowed with uninitialized oldmask.

caused by
| commit 2fdf66b491ac706657946442789ec644cc317e1a
| Author: Rusty Russell <rusty@rustcorp.com.au>
| Date:   Wed Dec 31 18:08:47 2008 -0800
|
|    cpumask: convert shared_cpu_map in acpi_processor* structs to cpumask_var_t


need to get oldmask early.
also remove some wrong warning when acpi is disabled.
and don't call exit_acpi if _PSS is not found.

with patch get numactl correct.

# numactl --show
policy: default
preferred node: current
physcpubind: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
cpubind: 0 1 2 3
nodebind: 0 1 2 3
membind: 0 1 2 3

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1124,6 +1124,7 @@ static int powernowk8_verify(struct cpuf
 static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
+	int k8_cpu_acpi_inited = 0;
 	cpumask_t oldmask;
 	int rc;
 
@@ -1141,14 +1142,19 @@ static int __cpuinit powernowk8_cpu_init
 
 	data->cpu = pol->cpu;
 	data->currpstate = HW_PSTATE_INVALID;
+	oldmask = current->cpus_allowed;
 
 	rc = powernow_k8_cpu_init_acpi(data);
-	if (rc) {
+	if (!rc) {
+		k8_cpu_acpi_inited = 1;
+	} else {
 		/*
 		 * Use the PSB BIOS structure. This is only availabe on
 		 * an UP version, and is deprecated by AMD.
 		 */
 		if (num_online_cpus() != 1) {
+			if (acpi_disabled)
+				goto err_out;
 #ifndef CONFIG_ACPI_PROCESSOR
 			printk(KERN_ERR PFX "ACPI Processor support is required "
 			       "for SMP systems but is absent. Please load the "
@@ -1164,6 +1170,8 @@ static int __cpuinit powernowk8_cpu_init
 			goto err_out;
 		}
 		if (pol->cpu != 0) {
+			if (acpi_disabled)
+				goto err_out;
 			printk(KERN_ERR FW_BUG PFX "No ACPI _PSS objects for "
 			       "CPU other than CPU0. Complain to your BIOS "
 			       "vendor.\n");
@@ -1176,7 +1184,6 @@ static int __cpuinit powernowk8_cpu_init
 	}
 
 	/* only run on specific CPU from here on */
-	oldmask = current->cpus_allowed;
 	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
@@ -1218,7 +1225,8 @@ static int __cpuinit powernowk8_cpu_init
 	/* min/max the cpu is capable of */
 	if (cpufreq_frequency_table_cpuinfo(pol, data->powernow_table)) {
 		printk(KERN_ERR FW_BUG PFX "invalid powernow_table\n");
-		powernow_k8_cpu_exit_acpi(data);
+		if (k8_cpu_acpi_inited)
+			powernow_k8_cpu_exit_acpi(data);
 		kfree(data->powernow_table);
 		kfree(data);
 		return -EINVAL;
@@ -1238,7 +1246,8 @@ static int __cpuinit powernowk8_cpu_init
 
 err_out:
 	set_cpus_allowed_ptr(current, &oldmask);
-	powernow_k8_cpu_exit_acpi(data);
+	if (k8_cpu_acpi_inited)
+		powernow_k8_cpu_exit_acpi(data);
 
 	kfree(data);
 	return -ENODEV;
