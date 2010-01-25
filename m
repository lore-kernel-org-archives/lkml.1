Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838Ab0AYPS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0AYPS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 10:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089Ab0AYPS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 10:18:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:42915 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab0AYPS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:18:57 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
       x86@kernel.org, mingo@redhat.com, fweisbec@gmail.com,
       dan.j.williams@intel.com, borislav.petkov@amd.com, ying.huang@intel.com,
       lenb@kernel.org, neilb@suse.de, cl@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 5/8] percpu: add __percpu sparse annotations to x86
Date: Tue, 26 Jan 2010 00:22:12 +0900
Message-Id: <1264432935-10453-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1264432935-10453-1-git-send-email-tj@kernel.org>
References: <1264432935-10453-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 25 Jan 2010 15:17:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __percpu sparse annotations to x86.

These annotations are to make sparse consider percpu variables to be
in a different address space and warn if accessed without going
through percpu accessors.  This patch doesn't affect normal builds.

In arch/x86/kernel/cpu/common.c, per_cpu(exception_stacks, cpu) is
replaced with &per_cpu(exception_stacks[0], cpu) which is equivalent
except that it allows per_cpu() macro to correctly drop percpu
designation during sparse pass.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/include/asm/msr.h                 |   12 +++++++-----
 arch/x86/kernel/acpi/cstate.c              |    2 +-
 arch/x86/kernel/cpu/common.c               |    2 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
 arch/x86/lib/msr-smp.c                     |    8 +++++---
 arch/x86/lib/msr.c                         |    6 +++---
 6 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index c5bc4c2..74882a5 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -30,7 +30,7 @@ struct msr {
 struct msr_info {
 	u32 msr_no;
 	struct msr reg;
-	struct msr *msrs;
+	struct msr __percpu *msrs;
 	int err;
 };
 
@@ -256,14 +256,16 @@ do {                                                            \
 
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
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index 2e837f5..62b0693 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -61,7 +61,7 @@ struct cstate_entry {
 		unsigned int ecx;
 	} states[ACPI_PROCESSOR_MAX_POWER];
 };
-static struct cstate_entry *cpu_cstate_entry;	/* per CPU ptr */
+static struct cstate_entry __percpu *cpu_cstate_entry;	/* per CPU ptr */
 
 static short mwait_supported[ACPI_PROCESSOR_MAX_POWER];
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4868e4a..486cb06 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1146,7 +1146,7 @@ void __cpuinit cpu_init(void)
 	 * set up and load the per-CPU TSS
 	 */
 	if (!oist->ist[0]) {
-		char *estacks = per_cpu(exception_stacks, cpu);
+		char *estacks = &per_cpu(exception_stacks[0], cpu);
 
 		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
 			estacks += exception_stack_sizes[v];
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 1b1920f..61cfd75 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -73,7 +73,7 @@ static DEFINE_PER_CPU(struct acpi_cpufreq_data *, acfreq_data);
 static DEFINE_PER_CPU(struct aperfmperf, acfreq_old_perf);
 
 /* acpi_perf_data is a pointer to percpu data. */
-static struct acpi_processor_performance *acpi_perf_data;
+static struct acpi_processor_performance __percpu *acpi_perf_data;
 
 static struct cpufreq_driver acpi_cpufreq_driver;
 
diff --git a/arch/x86/lib/msr-smp.c b/arch/x86/lib/msr-smp.c
index a6b1b86..b6a355f 100644
--- a/arch/x86/lib/msr-smp.c
+++ b/arch/x86/lib/msr-smp.c
@@ -64,7 +64,7 @@ int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 EXPORT_SYMBOL(wrmsr_on_cpu);
 
 static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
-			    struct msr *msrs,
+			    struct msr __percpu *msrs,
 			    void (*msr_func) (void *info))
 {
 	struct msr_info rv;
@@ -91,7 +91,8 @@ static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
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
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 8f8eebd..42c994c 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
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
-- 
1.6.4.2

