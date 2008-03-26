Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbYCZBkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbYCZBkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 21:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbYCZBi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 21:38:28 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43820 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752578AbYCZBiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 21:38:15 -0400
Message-Id: <20080326013812.324977000@polaris-admin.engr.sgi.com>
References: <20080326013811.569646000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Mar 2008 18:38:15 -0700
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: [PATCH 04/12] cpumask: pass cpumask by reference to acpi-cpufreq
Content-Disposition: inline; filename=check_freqs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass cpumask_t variables by reference in acpi-cpufreq functions.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Cc: Len Brown <len.brown@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux.trees.git.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux.trees.git/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -211,22 +211,22 @@ static void drv_write(struct drv_cmd *cm
 	return;
 }
 
-static u32 get_cur_val(cpumask_t mask)
+static u32 get_cur_val(const cpumask_t *mask)
 {
 	struct acpi_processor_performance *perf;
 	struct drv_cmd cmd;
 
-	if (unlikely(cpus_empty(mask)))
+	if (unlikely(cpus_empty(*mask)))
 		return 0;
 
-	switch (per_cpu(drv_data, first_cpu(mask))->cpu_feature) {
+	switch (per_cpu(drv_data, first_cpu(*mask))->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
 		cmd.addr.msr.reg = MSR_IA32_PERF_STATUS;
 		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;
-		perf = per_cpu(drv_data, first_cpu(mask))->acpi_data;
+		perf = per_cpu(drv_data, first_cpu(*mask))->acpi_data;
 		cmd.addr.io.port = perf->control_register.address;
 		cmd.addr.io.bit_width = perf->control_register.bit_width;
 		break;
@@ -234,7 +234,7 @@ static u32 get_cur_val(cpumask_t mask)
 		return 0;
 	}
 
-	cmd.mask = mask;
+	cmd.mask = *mask;
 
 	drv_read(&cmd);
 
@@ -347,13 +347,13 @@ static unsigned int get_cur_freq_on_cpu(
 		return 0;
 	}
 
-	freq = extract_freq(get_cur_val(cpumask_of_cpu(cpu)), data);
+	freq = extract_freq(get_cur_val(&cpumask_of_cpu(cpu)), data);
 	dprintk("cur freq = %u\n", freq);
 
 	return freq;
 }
 
-static unsigned int check_freqs(cpumask_t mask, unsigned int freq,
+static unsigned int check_freqs(const cpumask_t *mask, unsigned int freq,
 				struct acpi_cpufreq_data *data)
 {
 	unsigned int cur_freq;
@@ -449,7 +449,7 @@ static int acpi_cpufreq_target(struct cp
 	drv_write(&cmd);
 
 	if (acpi_pstate_strict) {
-		if (!check_freqs(cmd.mask, freqs.new, data)) {
+		if (!check_freqs(&cmd.mask, freqs.new, data)) {
 			dprintk("acpi_cpufreq_target failed (%d)\n",
 				policy->cpu);
 			return -EAGAIN;

-- 
