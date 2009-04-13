Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZDMAI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZDMAI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 20:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZDMAGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 20:06:34 -0400
Received: from ozlabs.org ([203.10.76.45]:39052 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbZDMAGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 20:06:31 -0400
CC: linux-kernel@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 13 Apr 2009 09:30:02 +0930
Subject: [PATCH 1/7] use smp_call_function_single() in arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20090413000630.21C09DE12A@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Impact: fix sysbench(oltp)+mysql 10% regression with 2.6.30-rc1

Mike says:
   It's kondemand, do_dbs_timer() is queueing work 9-14 times/sec/cpu.

Tested-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (use rdmsr_on_cpu)
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -153,7 +153,8 @@ struct drv_cmd {
 	u32 val;
 };
 
-static long do_drv_read(void *_cmd)
+/* Called via smp_call_function_single(), on the target CPU */
+static void do_drv_read(void *_cmd)
 {
 	struct drv_cmd *cmd = _cmd;
 	u32 h;
@@ -170,10 +171,10 @@ static long do_drv_read(void *_cmd)
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
@@ -192,23 +193,21 @@ static long do_drv_write(void *_cmd)
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
@@ -253,14 +252,13 @@ struct perf_pair {
 };
 
 
-static long read_measured_perf_ctrs(void *_cur)
+/* Called via smp_call_function_single(), on the target CPU */
+static void read_measured_perf_ctrs(void *_cur)
 {
 	struct perf_pair *cur = _cur;
 
 	rdmsr(MSR_IA32_APERF, cur->aperf.split.lo, cur->aperf.split.hi);
 	rdmsr(MSR_IA32_MPERF, cur->mperf.split.lo, cur->mperf.split.hi);
-
-	return 0;
 }
 
 /*
@@ -283,7 +281,7 @@ static unsigned int get_measured_perf(st
 	unsigned int perf_percent;
 	unsigned int retval;
 
-	if (!work_on_cpu(cpu, read_measured_perf_ctrs, &readin))
+	if (!smp_call_function_single(cpu, read_measured_perf_ctrs, &readin, 1))
 		return 0;
 
 	cur.aperf.whole = readin.aperf.whole -

