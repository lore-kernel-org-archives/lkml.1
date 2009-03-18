Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZCREYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZCREYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 00:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZCREWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 00:22:25 -0400
Received: from ozlabs.org ([203.10.76.45]:59286 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbZCREWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 00:22:21 -0400
CC: linux-kernel@vger.kernel.org
To: Len Brown <len.brown@intel.com>, Dave Jones <davej@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 18 Mar 2009 10:40:24 +1030
Subject: [PATCH 3/9] use smp_call_function_single() in arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: cpufreq@vger.kernel.org
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20090318042218.D9342DDF4A@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Attempting to rid us of the problematic work_on_cpu().  Just use
smp_call_function_single() here.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu
+++ a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -150,7 +150,8 @@ struct drv_cmd {
 	u32 val;
 };
 
-static long do_drv_read(void *_cmd)
+/* Called via smp_call_function_single(), on the target CPU */
+static void do_drv_read(void *_cmd)
 {
 	struct drv_cmd *cmd = _cmd;
 	u32 h;
@@ -167,10 +168,10 @@ static long do_drv_read(void *_cmd)
 	default:
 		break;
 	}
-	return 0;
 }
 
-static long do_drv_write(void *_cmd)
+/* Called via smp_call_function_single(), on the target CPU */
+static void do_drv_write(void *_cmd)
 {
 	struct drv_cmd *cmd = _cmd;
 	u32 lo, hi;
@@ -189,23 +190,21 @@ static long do_drv_write(void *_cmd)
 	default:
 		break;
 	}
-	return 0;
 }
 
 static void drv_read(struct drv_cmd *cmd)
 {
 	cmd->val = 0;
 
-	work_on_cpu(cpumask_any(cmd->mask), do_drv_read, cmd);
+	smp_call_function_single(cpumask_any(cmd->mask), do_drv_read, cmd, 1);
 }
 
 static void drv_write(struct drv_cmd *cmd)
 {
-	unsigned int i;
+	unsigned int cpu;
 
-	for_each_cpu(i, cmd->mask) {
-		work_on_cpu(i, do_drv_write, cmd);
-	}
+	for_each_cpu(cpu, cmd->mask)
+		smp_call_function_single(cpu, do_drv_write, cmd, 1);
 }
 
 static u32 get_cur_val(const struct cpumask *mask)
@@ -250,7 +249,8 @@ struct perf_cur {
 };
 
 
-static long read_measured_perf_ctrs(void *_cur)
+/* Called via smp_call_function_single(), on the target CPU */
+static void read_measured_perf_ctrs(void *_cur)
 {
 	struct perf_cur *cur = _cur;
 
@@ -259,8 +259,6 @@ static long read_measured_perf_ctrs(void
 
 	wrmsr(MSR_IA32_APERF, 0, 0);
 	wrmsr(MSR_IA32_MPERF, 0, 0);
-
-	return 0;
 }
 
 /*
@@ -283,7 +281,7 @@ static unsigned int get_measured_perf(st
 	unsigned int perf_percent;
 	unsigned int retval;
 
-	if (!work_on_cpu(cpu, read_measured_perf_ctrs, &cur))
+	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &cur, 1))
 		return 0;
 
 #ifdef __i386__
_

