Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbZDKG01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbZDKG01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 02:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZDKG0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 02:26:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755075AbZDKG0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 02:26:13 -0400
Message-Id: <200904110617.n3B6HJ7W026502@imap1.linux-foundation.org>
Subject: [patch for 2.6.30 2/2] arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: avoid cross-CPU interrupts
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, davej@redhat.com, efault@gmx.de,
       len.brown@intel.com, mingo@elte.hu, rusty@rustcorp.com.au,
       tglx@linutronix.de, venkatesh.pallipadi@intel.com, yakui.zhao@intel.com,
       yanmin_zhang@linux.intel.com
From: akpm@linux-foundation.org
Date: Fri, 10 Apr 2009 23:17:18 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

In drv_read(), check to see whether we can run the rdmsr() on the current
CPU.  If so, do that.  So smp_call_function_single() can avoid the IPI.

Arguably, cpumask_any() should do this.

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

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts
+++ a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -197,9 +197,22 @@ static void do_drv_write(void *_cmd)
 
 static void drv_read(struct drv_cmd *cmd)
 {
-	cmd->val = 0;
+	int target_cpu;		/* The CPU on which to perform thr rdmsr() */
+	int this_cpu;
+
+	/*
+	 * If the current CPU is in cmd->mask then run the rdmsr() on this
+	 * CPU to avoid the cross-cpu interrupt.
+	 */
+	this_cpu = get_cpu();
+	if (cpu_isset(this_cpu, *(cmd->mask)))
+		target_cpu = this_cpu;
+	else
+		target_cpu = cpumask_any(cmd->mask);
 
-	smp_call_function_single(cpumask_any(cmd->mask), do_drv_read, cmd, 1);
+	cmd->val = 0;
+	smp_call_function_single(target_cpu, do_drv_read, cmd, 1);
+	put_cpu();
 }
 
 static void drv_write(struct drv_cmd *cmd)
_
