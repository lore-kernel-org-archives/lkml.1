Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZDKG0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZDKG0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 02:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbZDKG0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 02:26:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763AbZDKG0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 02:26:15 -0400
Message-Id: <200904110617.n3B6HHi4026499@imap1.linux-foundation.org>
Subject: [patch for 2.6.30 1/2] arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: avoid using work_on_cpu()
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, davej@redhat.com, efault@gmx.de,
       len.brown@intel.com, mingo@elte.hu, rusty@rustcorp.com.au,
       tglx@linutronix.de, venkatesh.pallipadi@intel.com, yakui.zhao@intel.com,
       yanmin_zhang@linux.intel.com
From: akpm@linux-foundation.org
Date: Fri, 10 Apr 2009 23:17:17 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Atttempting to rid us of the problematic work_on_cpu().  Just use
smp_call_fuction_single() here.

This repairs a 10% sysbench(oltp)+mysql regression which Mike reported,
due to 

commit 6b44003e5ca66a3fffeb5bc90f40ada2c4340896
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Thu Apr 9 09:50:37 2009 -0600

    work_on_cpu(): rewrite it to create a kernel thread on demand

It seems that the kernel calls these acpi-cpufreq functions at a quite
high frequency.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Mike Galbraith <efault@gmx.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   25 ++++++++-----------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu
+++ a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
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
@@ -252,15 +251,13 @@ struct perf_pair {
 	} aperf, mperf;
 };
 
-
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
@@ -283,7 +280,7 @@ static unsigned int get_measured_perf(st
 	unsigned int perf_percent;
 	unsigned int retval;
 
-	if (!work_on_cpu(cpu, read_measured_perf_ctrs, &readin))
+	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &cur, 1))
 		return 0;
 
 	cur.aperf.whole = readin.aperf.whole -
_
