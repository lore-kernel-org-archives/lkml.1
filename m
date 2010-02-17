Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897Ab0BQBkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 20:40:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:42634 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933803Ab0BQBkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 20:40:11 -0500
Message-ID: <4B7B4ABB.2030006@kernel.org>
Date: Wed, 17 Feb 2010 10:47:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH x86/core] percpu: add __percpu sparse annotations to x86
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Feb 2010 01:39:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __percpu sparse annotations to x86.

These annotations are to make sparse consider percpu variables to be
in a different address space and warn if accessed without going
through percpu accessors.  This patch doesn't affect normal builds.

In arch/x86/kernel/cpu/common.c, per_cpu(exception_stacks, cpu) will
trigger sprious noderef related warnings from sparse.  Changing it to
&per_cpu(exception_stacks[0], cpu) will work around the problem but
deemed to ugly by the maintainer.  Leave it alone until better
solution can be found.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
---
Can you please include this into x86 branch?  Thanks.

 arch/x86/include/asm/msr.h                 |   12 +++++++-----
 arch/x86/kernel/acpi/cstate.c              |    2 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
 arch/x86/lib/msr-smp.c                     |    8 +++++---
 arch/x86/lib/msr.c                         |    6 +++---
 5 files changed, 17 insertions(+), 13 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/msr.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/msr.h
+++ linux-2.6-tip/arch/x86/include/asm/msr.h
@@ -30,7 +30,7 @@ struct msr {
 struct msr_info {
 	u32 msr_no;
 	struct msr reg;
-	struct msr *msrs;
+	struct msr __percpu *msrs;
 	int err;
 };
 
@@ -256,14 +256,16 @@ do {
 
 #define write_rdtscp_aux(val) wrmsr(MSR_TSC_AUX, (val), 0)
 
-struct msr *msrs_alloc(void);
-void msrs_free(struct msr *msrs);
+struct msr __percpu *msrs_alloc(void);
+void msrs_free(struct msr __percpu *msrs);
 
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
-void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
-void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
+void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
+		   struct msr __percpu *msrs);
+void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
+		   struct msr __percpu *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8]);
Index: linux-2.6-tip/arch/x86/kernel/acpi/cstate.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/acpi/cstate.c
+++ linux-2.6-tip/arch/x86/kernel/acpi/cstate.c
@@ -61,7 +61,7 @@ struct cstate_entry {
 		unsigned int ecx;
 	} states[ACPI_PROCESSOR_MAX_POWER];
 };
-static struct cstate_entry *cpu_cstate_entry;	/* per CPU ptr */
+static struct cstate_entry __percpu *cpu_cstate_entry;	/* per CPU ptr */
 
 static short mwait_supported[ACPI_PROCESSOR_MAX_POWER];
 
Index: linux-2.6-tip/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6-tip/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -73,7 +73,7 @@ static DEFINE_PER_CPU(struct acpi_cpufre
 static DEFINE_PER_CPU(struct aperfmperf, acfreq_old_perf);
 
 /* acpi_perf_data is a pointer to percpu data. */
-static struct acpi_processor_performance *acpi_perf_data;
+static struct acpi_processor_performance __percpu *acpi_perf_data;
 
 static struct cpufreq_driver acpi_cpufreq_driver;
 
Index: linux-2.6-tip/arch/x86/lib/msr-smp.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/lib/msr-smp.c
+++ linux-2.6-tip/arch/x86/lib/msr-smp.c
@@ -64,7 +64,7 @@ int wrmsr_on_cpu(unsigned int cpu, u32 m
 EXPORT_SYMBOL(wrmsr_on_cpu);
 
 static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
-			    struct msr *msrs,
+			    struct msr __percpu *msrs,
 			    void (*msr_func) (void *info))
 {
 	struct msr_info rv;
@@ -91,7 +91,8 @@ static void __rwmsr_on_cpus(const struct
  * @msrs:       array of MSR values
  *
  */
-void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
+void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
+		   struct msr __percpu *msrs)
 {
 	__rwmsr_on_cpus(mask, msr_no, msrs, __rdmsr_on_cpu);
 }
@@ -105,7 +106,8 @@ EXPORT_SYMBOL(rdmsr_on_cpus);
  * @msrs:       array of MSR values
  *
  */
-void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
+void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
+		   struct msr __percpu *msrs)
 {
 	__rwmsr_on_cpus(mask, msr_no, msrs, __wrmsr_on_cpu);
 }
Index: linux-2.6-tip/arch/x86/lib/msr.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/lib/msr.c
+++ linux-2.6-tip/arch/x86/lib/msr.c
@@ -2,9 +2,9 @@
 #include <linux/preempt.h>
 #include <asm/msr.h>
 
-struct msr *msrs_alloc(void)
+struct msr __percpu *msrs_alloc(void)
 {
-	struct msr *msrs = NULL;
+	struct msr __percpu *msrs = NULL;
 
 	msrs = alloc_percpu(struct msr);
 	if (!msrs) {
@@ -16,7 +16,7 @@ struct msr *msrs_alloc(void)
 }
 EXPORT_SYMBOL(msrs_alloc);
 
-void msrs_free(struct msr *msrs)
+void msrs_free(struct msr __percpu *msrs)
 {
 	free_percpu(msrs);
 }
