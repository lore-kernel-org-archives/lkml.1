Return-Path: <linux-kernel-owner+w=401wt.eu-S933095AbXBLHiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbXBLHiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933087AbXBLHii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:38:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933096AbXBLHiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:16 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Alexey Dobriyan <adobriyan@openvz.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [21/39] i386: rdmsr_on_cpu, wrmsr_on_cpu 
Message-Id: <20070212073808.BD9CA13D01@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alexey Dobriyan <adobriyan@openvz.org>
There was OpenVZ specific bug rendering some cpufreq drivers unusable
on SMP. In short, when cpufreq code thinks it confined itself to
needed cpu by means of set_cpus_allowed() to execute rdmsr, some
"virtual cpu" feature can migrate process to anywhere. This triggers
bugons and does wrong things in general.

This got fixed by introducing rdmsr_on_cpu and wrmsr_on_cpu executing
rdmsr and wrmsr on given physical cpu by means of
smp_call_function_single().

AK: link it into 64bit kernel too because cpufreq drivers use it.

 arch/i386/kernel/cpu/cpufreq/p4-clockmod.c |   30 ++----------
 arch/i386/lib/Makefile                     |    2
 arch/i386/kernel/cpu/cpufreq/p4-clockmod.c |   30 ++----------
 arch/i386/lib/Makefile                     |    2 
 arch/i386/lib/msr-on-cpu.c                 |   70 +++++++++++++++++++++++++++++
 arch/x86_64/lib/Makefile                   |    4 +
 include/asm-i386/msr.h                     |    3 +
 5 files changed, 84 insertions(+), 25 deletions(-)

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/lib/Makefile
===================================================================
--- linux.orig/arch/i386/lib/Makefile
+++ linux/arch/i386/lib/Makefile
@@ -7,3 +7,5 @@ lib-y = checksum.o delay.o usercopy.o ge
 	bitops.o semaphore.o
 
 lib-$(CONFIG_X86_USE_3DNOW) += mmx.o
+
+obj-y = msr-on-cpu.o
Index: linux/arch/i386/lib/msr-on-cpu.c
===================================================================
--- /dev/null
+++ linux/arch/i386/lib/msr-on-cpu.c
@@ -0,0 +1,70 @@
+#include <linux/module.h>
+#include <linux/preempt.h>
+#include <linux/smp.h>
+#include <asm/msr.h>
+
+#ifdef CONFIG_SMP
+struct msr_info {
+	u32 msr_no;
+	u32 l, h;
+};
+
+static void __rdmsr_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	rdmsr(rv->msr_no, rv->l, rv->h);
+}
+
+void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	preempt_disable();
+	if (smp_processor_id() == cpu)
+		rdmsr(msr_no, *l, *h);
+	else {
+		struct msr_info rv;
+
+		rv.msr_no = msr_no;
+		smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
+		*l = rv.l;
+		*h = rv.h;
+	}
+	preempt_enable();
+}
+
+static void __wrmsr_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	wrmsr(rv->msr_no, rv->l, rv->h);
+}
+
+void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	preempt_disable();
+	if (smp_processor_id() == cpu)
+		wrmsr(msr_no, l, h);
+	else {
+		struct msr_info rv;
+
+		rv.msr_no = msr_no;
+		rv.l = l;
+		rv.h = h;
+		smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
+	}
+	preempt_enable();
+}
+#else
+void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	rdmsr(msr_no, *l, *h);
+}
+
+void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	wrmsr(msr_no, l, h);
+}
+#endif
+
+EXPORT_SYMBOL(rdmsr_on_cpu);
+EXPORT_SYMBOL(wrmsr_on_cpu);
Index: linux/include/asm-i386/msr.h
===================================================================
--- linux.orig/include/asm-i386/msr.h
+++ linux/include/asm-i386/msr.h
@@ -83,6 +83,9 @@ static inline void wrmsrl (unsigned long
 			  : "c" (counter))
 #endif	/* !CONFIG_PARAVIRT */
 
+void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
+void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+
 /* symbolic names for some interesting MSRs */
 /* Intel defined MSRs. */
 #define MSR_IA32_P5_MC_ADDR		0
Index: linux/arch/i386/kernel/cpu/cpufreq/p4-clockmod.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/cpufreq/p4-clockmod.c
+++ linux/arch/i386/kernel/cpu/cpufreq/p4-clockmod.c
@@ -62,7 +62,7 @@ static int cpufreq_p4_setdc(unsigned int
 	if (!cpu_online(cpu) || (newstate > DC_DISABLE) || (newstate == DC_RESV))
 		return -EINVAL;
 
-	rdmsr(MSR_IA32_THERM_STATUS, l, h);
+	rdmsr_on_cpu(cpu, MSR_IA32_THERM_STATUS, &l, &h);
 
 	if (l & 0x01)
 		dprintk("CPU#%d currently thermal throttled\n", cpu);
@@ -70,10 +70,10 @@ static int cpufreq_p4_setdc(unsigned int
 	if (has_N44_O17_errata[cpu] && (newstate == DC_25PT || newstate == DC_DFLT))
 		newstate = DC_38PT;
 
-	rdmsr(MSR_IA32_THERM_CONTROL, l, h);
+	rdmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL, &l, &h);
 	if (newstate == DC_DISABLE) {
 		dprintk("CPU#%d disabling modulation\n", cpu);
-		wrmsr(MSR_IA32_THERM_CONTROL, l & ~(1<<4), h);
+		wrmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL, l & ~(1<<4), h);
 	} else {
 		dprintk("CPU#%d setting duty cycle to %d%%\n",
 			cpu, ((125 * newstate) / 10));
@@ -84,7 +84,7 @@ static int cpufreq_p4_setdc(unsigned int
 		 */
 		l = (l & ~14);
 		l = l | (1<<4) | ((newstate & 0x7)<<1);
-		wrmsr(MSR_IA32_THERM_CONTROL, l, h);
+		wrmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL, l, h);
 	}
 
 	return 0;
@@ -111,7 +111,6 @@ static int cpufreq_p4_target(struct cpuf
 {
 	unsigned int    newstate = DC_RESV;
 	struct cpufreq_freqs freqs;
-	cpumask_t cpus_allowed;
 	int i;
 
 	if (cpufreq_frequency_table_target(policy, &p4clockmod_table[0], target_freq, relation, &newstate))
@@ -132,17 +131,8 @@ static int cpufreq_p4_target(struct cpuf
 	/* run on each logical CPU, see section 13.15.3 of IA32 Intel Architecture Software
 	 * Developer's Manual, Volume 3
 	 */
-	cpus_allowed = current->cpus_allowed;
-
-	for_each_cpu_mask(i, policy->cpus) {
-		cpumask_t this_cpu = cpumask_of_cpu(i);
-
-		set_cpus_allowed(current, this_cpu);
-		BUG_ON(smp_processor_id() != i);
-
+	for_each_cpu_mask(i, policy->cpus)
 		cpufreq_p4_setdc(i, p4clockmod_table[newstate].index);
-	}
-	set_cpus_allowed(current, cpus_allowed);
 
 	/* notifiers */
 	for_each_cpu_mask(i, policy->cpus) {
@@ -256,17 +246,9 @@ static int cpufreq_p4_cpu_exit(struct cp
 
 static unsigned int cpufreq_p4_get(unsigned int cpu)
 {
-	cpumask_t cpus_allowed;
 	u32 l, h;
 
-	cpus_allowed = current->cpus_allowed;
-
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
-	BUG_ON(smp_processor_id() != cpu);
-
-	rdmsr(MSR_IA32_THERM_CONTROL, l, h);
-
-	set_cpus_allowed(current, cpus_allowed);
+	rdmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL, &l, &h);
 
 	if (l & 0x10) {
 		l = l >> 1;
Index: linux/arch/x86_64/lib/Makefile
===================================================================
--- linux.orig/arch/x86_64/lib/Makefile
+++ linux/arch/x86_64/lib/Makefile
@@ -4,10 +4,12 @@
 
 CFLAGS_csum-partial.o := -funroll-loops
 
-obj-y := io.o iomap_copy.o
+obj-y := io.o iomap_copy.o msr-on-cpu.o
 
 lib-y := csum-partial.o csum-copy.o csum-wrappers.o delay.o \
 	usercopy.o getuser.o putuser.o  \
 	thunk.o clear_page.o copy_page.o bitstr.o bitops.o
 lib-y += memcpy.o memmove.o memset.o copy_user.o rwlock.o copy_user_nocache.o
 lib-y += memcpy_uncached_read.o
+
+msr-on-cpu-y += ../../i386/lib/msr-on-cpu.o
