Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZICNXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZICNXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbZICNX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:23:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37074 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbZICNXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:23:21 -0400
Message-Id: <20090903132213.261132239@chello.nl>
References: <20090903132145.482814810@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 03 Sep 2009 15:21:57 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 12/14] x86: sched: provide arch implementations using aperf/mperf
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
---
 arch/x86/kernel/cpu/Makefile |    2 -
 arch/x86/kernel/cpu/sched.c  |   58 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h        |    4 ++
 3 files changed, 63 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/Makefile
+++ linux-2.6/arch/x86/kernel/cpu/Makefile
@@ -13,7 +13,7 @@ CFLAGS_common.o		:= $(nostackp)
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o
+obj-y			+= vmware.o hypervisor.o sched.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
Index: linux-2.6/arch/x86/kernel/cpu/sched.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/kernel/cpu/sched.c
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
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1012,6 +1012,10 @@ partition_sched_domains(int ndoms_new, s
 }
 #endif	/* !CONFIG_SMP */
 
+
+unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
+unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
+
 struct io_context;			/* See blkdev.h */
 
 

-- 

