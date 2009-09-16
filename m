Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbZIPKX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbZIPKX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbZIPKX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:23:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:46607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbZIPKXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:23:55 -0400
Date: Wed, 16 Sep 2009 10:23:22 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] x86: sched: Provide arch implementations using aperf/mperf
Message-ID: <tip-47fe38fcff0517e67d395c039d2e26d2de688a60@git.kernel.org>
Git-Commit-ID: 47fe38fcff0517e67d395c039d2e26d2de688a60
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:23:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47fe38fcff0517e67d395c039d2e26d2de688a60
Gitweb:     http://git.kernel.org/tip/47fe38fcff0517e67d395c039d2e26d2de688a60
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 2 Sep 2009 13:49:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:51:27 +0200

x86: sched: Provide arch implementations using aperf/mperf

APERF/MPERF support for cpu_power.

APERF/MPERF is arch defined to be a relative scale of work capacity
per logical cpu, this is assumed to include SMT and Turbo mode.

APERF/MPERF are specified to both reset to 0 when either counter
wraps, which is highly inconvenient, since that'll give a blimp
when that happens. The manual specifies writing 0 to the counters
after each read, but that's 1) too expensive, and 2) destroys the
possibility of sharing these counters with other users, so we live
with the blimp - the other existing user does too.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/Makefile |    2 +-
 arch/x86/kernel/cpu/sched.c  |   55 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h        |    4 +++
 3 files changed, 60 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index c1f253d..8dd3063 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -13,7 +13,7 @@ CFLAGS_common.o		:= $(nostackp)
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o
+obj-y			+= vmware.o hypervisor.o sched.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
diff --git a/arch/x86/kernel/cpu/sched.c b/arch/x86/kernel/cpu/sched.c
new file mode 100644
index 0000000..6c00a8f
--- /dev/null
+++ b/arch/x86/kernel/cpu/sched.c
@@ -0,0 +1,55 @@
+#include <linux/sched.h>
+#include <linux/math64.h>
+#include <linux/percpu.h>
+#include <linux/irqflags.h>
+
+#include <asm/cpufeature.h>
+#include <asm/processor.h>
+
+#ifdef CONFIG_SMP
+
+static DEFINE_PER_CPU(struct aperfmperf, old_perf);
+
+static unsigned long scale_aperfmperf(void)
+{
+	struct aperfmperf val, *old = &__get_cpu_var(old_perf);
+	unsigned long ratio, flags;
+
+	local_irq_save(flags);
+	get_aperfmperf(&val);
+	local_irq_restore(flags);
+
+	ratio = calc_aperfmperf_ratio(old, &val);
+	*old = val;
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
+
+#endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c30bf3d..fc4c0f9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -992,6 +992,9 @@ static inline int test_sd_parent(struct sched_domain *sd, int flag)
 	return 0;
 }
 
+unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
+unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
+
 #else /* CONFIG_SMP */
 
 struct sched_domain_attr;
@@ -1003,6 +1006,7 @@ partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
 }
 #endif	/* !CONFIG_SMP */
 
+
 struct io_context;			/* See blkdev.h */
 
 
