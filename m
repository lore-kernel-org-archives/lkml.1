Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZJVMla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZJVMla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbZJVMlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:41:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39918 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbZJVMlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:41:17 -0400
Message-Id: <20091022124112.184099152@spinlock.in.ibm.com>
References: <20091022123743.506956796@spinlock.in.ibm.com>
User-Agent: quilt/0.44-1
Date: Thu, 22 Oct 2009 18:07:55 +0530
From: dino@in.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [patch -rt 12/17] x86: sched: provide arch implementations using aperf/mperf 
Content-Disposition: inline; filename=sched-lb-11.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APERF/MPERF support for cpu_power.

APERF/MPERF is arch defined to be a relative scale of work capacity
per logical cpu, this is assumed to include SMT and Turbo mode.

APERF/MPERF are specified to both reset to 0 when either counter
wraps, which is highly inconvenient, since that'll give a blimp when
that happens. The manual specifies writing 0 to the counters after
each read, but that's 1) too expensive, and 2) destroys the
possibility of sharing these counters with other users, so we live
with the blimp - the other existing user does too.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
---
 arch/x86/kernel/cpu/Makefile |    2 -
 arch/x86/kernel/cpu/sched.c  |   58 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h        |    4 ++
 3 files changed, 63 insertions(+), 1 deletion(-)

Index: linux-2.6.31.4-rt14-lb1/arch/x86/kernel/cpu/Makefile
===================================================================
--- linux-2.6.31.4-rt14-lb1.orig/arch/x86/kernel/cpu/Makefile	2009-10-21 10:47:15.000000000 -0400
+++ linux-2.6.31.4-rt14-lb1/arch/x86/kernel/cpu/Makefile	2009-10-21 10:49:00.000000000 -0400
@@ -13,7 +13,7 @@
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o
+obj-y			+= vmware.o hypervisor.o sched.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
Index: linux-2.6.31.4-rt14-lb1/arch/x86/kernel/cpu/sched.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.31.4-rt14-lb1/arch/x86/kernel/cpu/sched.c	2009-10-21 10:49:00.000000000 -0400
@@ -0,0 +1,58 @@
+#include <linux/sched.h>
+#include <linux/math64.h>
+#include <linux/percpu.h>
+#include <linux/irqflags.h>
+
+#include <asm/cpufeature.h>
+#include <asm/processor.h>
+
+static DEFINE_PER_CPU(struct aperfmperf, old_aperfmperf);
+
+static unsigned long scale_aperfmperf(void)
+{
+	struct aperfmperf cur, val, *old = &__get_cpu_var(old_aperfmperf);
+	unsigned long ratio = SCHED_LOAD_SCALE;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	get_aperfmperf(&val);
+	local_irq_restore(flags);
+
+	cur = val;
+	cur.aperf -= old->aperf;
+	cur.mperf -= old->mperf;
+	*old = val;
+
+	cur.mperf >>= SCHED_LOAD_SHIFT;
+	if (cur.mperf)
+		ratio = div_u64(cur.aperf, cur.mperf);
+
+	return ratio;
+}
+
+unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu)
+{
+	/*
+	 * do aperf/mperf on the cpu level because it includes things
+	 * like turbo mode, which are relevant to full cores.
+	 */
+	if (boot_cpu_has(X86_FEATURE_APERFMPERF))
+		return scale_aperfmperf();
+
+	/*
+	 * maybe have something cpufreq here
+	 */
+
+	return default_scale_freq_power(sd, cpu);
+}
+
+unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
+{
+	/*
+	 * aperf/mperf already includes the smt gain
+	 */
+	if (boot_cpu_has(X86_FEATURE_APERFMPERF))
+		return SCHED_LOAD_SCALE;
+
+	return default_scale_smt_power(sd, cpu);
+}
Index: linux-2.6.31.4-rt14-lb1/include/linux/sched.h
===================================================================
--- linux-2.6.31.4-rt14-lb1.orig/include/linux/sched.h	2009-10-21 10:47:15.000000000 -0400
+++ linux-2.6.31.4-rt14-lb1/include/linux/sched.h	2009-10-21 10:49:00.000000000 -0400
@@ -1047,6 +1047,10 @@
 }
 #endif	/* !CONFIG_SMP */
 
+
+unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
+unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
+
 struct io_context;			/* See blkdev.h */
 
 

--
