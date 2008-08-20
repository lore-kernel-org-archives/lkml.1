Return-Path: <linux-kernel-owner+w=401wt.eu-S1760924AbYHTRDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbYHTRDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759874AbYHTRCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:02:15 -0400
Received: from ns2.suse.de ([195.135.220.15]:56290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744AbYHTRCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:02:08 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org
Cc: ak@linux.intel.com, len.brown@intel.com, arjan@linux.intel.com,
       bjorn.helgaas@hp.com, linux-acpi@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH 3/3] acpi-cpufreq: Make use of firmware bug report interface
Date: Wed, 20 Aug 2008 19:02:06 +0200
Message-Id: <1219251726-24746-4-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219251726-24746-1-git-send-email-trenn@suse.de>
References: <1219251726-24746-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance check for processor cpufreq support, but missing or wrong ACPI
cpufreq package information. This often happens if the BIOS is older
as the CPU. Users should be told to update the BIOS then.

Not sure whether the check will show false negatives, e.g. some old
Pentium M (Banias/Dothan) worked with static compiled-in cpufreq tables.
-> needs review.
Best probably is to check whether a _PPC function exists in the processor
object, but this must be done in drivers/acpi/processor_*.c.
This should always be an indicator for an too old BIOS.

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index dd097b8..1288142 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -26,6 +26,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/firmware_error.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/smp.h>
@@ -67,6 +68,8 @@ struct acpi_cpufreq_data {
 	unsigned int cpu_feature;
 };
 
+#define PFX "acpi-cpufreq: "
+
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
 
 /* acpi_perf_data is a pointer to percpu data. */
@@ -354,7 +357,12 @@ static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 		/*
 		 * The dreaded BIOS frequency change behind our back.
 		 * Force set the frequency on next target call.
+		 * Dell tends to do this on their laptops and it is evil.
 		 */
+		FW_PRINT_WARN(FW_WARN, PFX " BIOS must not change frequency "
+			      "on _PPC changes, let OS do this");
+
+		
 		data->resume = 1;
 	}
 
@@ -587,8 +595,14 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		acpi_cpufreq_driver.flags |= CPUFREQ_CONST_LOOPS;
 
 	result = acpi_processor_register_performance(data->acpi_data, cpu);
-	if (result)
+	if (result) {
+		if (cpu_has(c, X86_FEATURE_EST)) {
+			FW_PRINT_CRIT(FW_ERR, PFX "Speedstep supported, but "
+				      "invalid ACPI CPU information, BIOS "
+				      "update needed");
+		}
 		goto err_free;
+	}
 
 	perf = data->acpi_data;
 	policy->shared_type = perf->shared_type;
-- 
1.5.4.5

