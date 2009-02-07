Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbZBGHqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbZBGHqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 02:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbZBGHqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 02:46:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:43811 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbZBGHqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 02:46:18 -0500
Message-ID: <498D3C01.1050307@kernel.org>
Date: Fri, 06 Feb 2009 23:45:05 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] cpumask: fix powernow-k8: partial revert of 2fdf66b491ac706657946442789ec644cc317e1a
References: <200902071809.39175.rusty@rustcorp.com.au>
In-Reply-To: <200902071809.39175.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Impact: fix powernow-k8 when acpi=off (or other error).
> 
> There was a spurious change introduced into powernow-k8 in this patch:
> the cause if that we try to "restore" the cpus_allowed we never saved.
> 
> See lkml "[PATCH] x86/powernow: fix cpus_allowed brokage when
> acpi=off" from Yinghai for the bug report.
> 

and

[PATCH] x86/powernow: dont emit warning when acpi=off

Impact: cleanup

remove some wrong warning when acpi is disabled.
and don't call exit_acpi if _PSS is not found.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   53 ++++++++++++++++--------------
 1 file changed, 29 insertions(+), 24 deletions(-)

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
 
@@ -1142,39 +1143,41 @@ static int __cpuinit powernowk8_cpu_init
 	data->cpu = pol->cpu;
 	data->currpstate = HW_PSTATE_INVALID;
 
-	if (powernow_k8_cpu_init_acpi(data)) {
+	if (!powernow_k8_cpu_init_acpi(data)) {
+		 k8_cpu_acpi_inited = 1;
+	} else {
 		/*
 		 * Use the PSB BIOS structure. This is only availabe on
 		 * an UP version, and is deprecated by AMD.
 		 */
 		if (num_online_cpus() != 1) {
+			if (!acpi_disabled) {
 #ifndef CONFIG_ACPI_PROCESSOR
-			printk(KERN_ERR PFX "ACPI Processor support is required "
-			       "for SMP systems but is absent. Please load the "
-			       "ACPI Processor module before starting this "
-			       "driver.\n");
+				printk(KERN_ERR PFX "ACPI Processor support is required "
+				       "for SMP systems but is absent. Please load the "
+				       "ACPI Processor module before starting this "
+				       "driver.\n");
 #else
-			printk(KERN_ERR FW_BUG PFX "Your BIOS does not provide"
-			       " ACPI _PSS objects in a way that Linux "
-			       "understands. Please report this to the Linux "
-			       "ACPI maintainers and complain to your BIOS "
-			       "vendor.\n");
+				printk(KERN_ERR FW_BUG PFX "Your BIOS does not provide"
+				       " ACPI _PSS objects in a way that Linux "
+				       "understands. Please report this to the Linux "
+				       "ACPI maintainers and complain to your BIOS "
+				       "vendor.\n");
 #endif
-			kfree(data);
-			return -ENODEV;
+			}
+			goto early_out;
 		}
 		if (pol->cpu != 0) {
-			printk(KERN_ERR FW_BUG PFX "No ACPI _PSS objects for "
-			       "CPU other than CPU0. Complain to your BIOS "
-			       "vendor.\n");
-			kfree(data);
-			return -ENODEV;
+			if (!acpi_disabled) {
+				printk(KERN_ERR FW_BUG PFX "No ACPI _PSS objects for "
+				       "CPU other than CPU0. Complain to your BIOS "
+				       "vendor.\n");
+			}
+			goto early_out;
 		}
 		rc = find_psb_table(data);
-		if (rc) {
-			kfree(data);
-			return -ENODEV;
-		}
+		if (rc)
+			goto early_out;
 	}
 
 	/* only run on specific CPU from here on */
@@ -1220,7 +1223,8 @@ static int __cpuinit powernowk8_cpu_init
 	/* min/max the cpu is capable of */
 	if (cpufreq_frequency_table_cpuinfo(pol, data->powernow_table)) {
 		printk(KERN_ERR FW_BUG PFX "invalid powernow_table\n");
-		powernow_k8_cpu_exit_acpi(data);
+		if (k8_cpu_acpi_inited)
+			powernow_k8_cpu_exit_acpi(data);
 		kfree(data->powernow_table);
 		kfree(data);
 		return -EINVAL;
@@ -1240,8 +1244,9 @@ static int __cpuinit powernowk8_cpu_init
 
 err_out:
 	set_cpus_allowed_ptr(current, &oldmask);
-	powernow_k8_cpu_exit_acpi(data);
-
+	if (k8_cpu_acpi_inited)
+		powernow_k8_cpu_exit_acpi(data);
+early_out:
 	kfree(data);
 	return -ENODEV;
 }
