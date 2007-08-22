Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbXHVJBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbXHVJBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbXHVIxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:25 -0400
Received: from 1wt.eu ([62.212.114.60]:2060 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559AbXHVIxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:23 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084027.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:20 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 36/58] acpi-cpufreq: Proper ReadModifyWrite of PERF_CTL MSR
Content-Disposition: inline; filename=0036-acpi-cpufreq-Proper-ReadModifyWrite-of-PERF_CTL-MSR.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[CPUFREQ] acpi-cpufreq: Proper ReadModifyWrite of PERF_CTL MSR

During recent acpi-cpufreq changes, writing to PERF_CTL msr
changed from RMW of entire 64 bit to RMW of low 32 bit and clearing of
upper 32 bit. Fix it back to do a proper RMW of the MSR.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
index 10baa35..18c8b67 100644
--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -167,11 +167,13 @@ static void do_drv_read(struct drv_cmd *cmd)
 
 static void do_drv_write(struct drv_cmd *cmd)
 {
-	u32 h = 0;
+	u32 lo, hi;
 
 	switch (cmd->type) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
-		wrmsr(cmd->addr.msr.reg, cmd->val, h);
+		rdmsr(cmd->addr.msr.reg, lo, hi);
+		lo = (lo & ~INTEL_MSR_RANGE) | (cmd->val & INTEL_MSR_RANGE);
+		wrmsr(cmd->addr.msr.reg, lo, hi);
 		break;
 	case SYSTEM_IO_CAPABLE:
 		acpi_os_write_port((acpi_io_address)cmd->addr.io.port,
@@ -372,7 +374,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 	struct cpufreq_freqs freqs;
 	cpumask_t online_policy_cpus;
 	struct drv_cmd cmd;
-	unsigned int msr;
 	unsigned int next_state = 0; /* Index into freq_table */
 	unsigned int next_perf_state = 0; /* Index into perf table */
 	unsigned int i;
@@ -417,11 +418,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
 		cmd.addr.msr.reg = MSR_IA32_PERF_CTL;
-		msr =
-		    (u32) perf->states[next_perf_state].
-		    control & INTEL_MSR_RANGE;
-		cmd.val = get_cur_val(online_policy_cpus);
-		cmd.val = (cmd.val & ~INTEL_MSR_RANGE) | msr;
+		cmd.val = (u32) perf->states[next_perf_state].control;
 		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;
-- 
1.5.2.5

-- 
