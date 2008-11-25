Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbYKYVrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbYKYVrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbYKYVo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:44:57 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46122 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578AbYKYVoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:44:54 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 3/6] x86 chargeback accounting patch
To: "Darrick J. Wong" <djwong@us.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar.sarma@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Date: Tue, 25 Nov 2008 13:44:52 -0800
Message-ID: <20081125214452.22900.13683.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20081125214437.22900.82384.stgit@elm3a70.beaverton.ibm.com>
References: <20081125214437.22900.82384.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides scaled utime and stime CPU usage statistics to facilitate chargeback
accounting for CPU use on x86 architecture.  This code allows taskstat users to
get an idea of not just the wall clock time that a process used, but also how
much demand was put on the CPU to run quickly, similar to how the SPURR and
PURR registers are used in arch/powerpc/ to provide scaled utime and stime.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 arch/x86/Kconfig              |   12 ++++++++++
 arch/x86/include/asm/system.h |    4 +++
 arch/x86/kernel/time.c        |   48 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac22bb7..44e32b1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -206,6 +206,18 @@ menu "Processor type and features"
 
 source "kernel/time/Kconfig"
 
+config VIRT_CPU_ACCOUNTING
+	bool "Deterministic task and CPU time accounting"
+	default n
+	help
+	  Select this option to enable more accurate task and CPU time
+	  accounting.  This is done by reading a CPU counter on each
+	  kernel entry and exit and on transitions within the kernel
+	  between system, softirq and hardirq state, so there is a
+	  small performance impact.
+
+	  If in doubt, say N here.
+
 config SMP
 	bool "Symmetric multi-processing support"
 	---help---
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 787f5c2..3fabf5d 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -422,6 +422,10 @@ static inline void rdtsc_barrier(void)
 	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
 }
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+void account_system_vtime(struct task_struct *tsk);
+#endif
+
 #define U64_MAX	(u64)(~((u64)0))
 
 static inline u64 delta_perf(u64 now, u64 *old)
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 41ff323..727aa7b 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -2,6 +2,10 @@
 #include <linux/module.h>
 #include <linux/hardirq.h>
 
+/* Buffer to store old values of aperf/mperf */
+DEFINE_PER_CPU(u64, vcpu_acct_old_aperf);
+DEFINE_PER_CPU(u64, vcpu_acct_old_mperf);
+
 void get_intel_aperf_mperf_registers(u64 *aperf, u64 *mperf)
 {
 	union {
@@ -101,3 +105,47 @@ static inline int is_intel_cpu_with_aperf(void)
 	return has_aperf;
 }
 EXPORT_SYMBOL_GPL(is_intel_cpu_with_aperf);
+
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+void account_system_vtime(struct task_struct *tsk)
+{
+	/* if intel with aperf */
+	if (!is_intel_cpu_with_aperf())
+		return;
+
+	/* record aperf/mperf right now */
+	get_intel_aperf_mperf_registers(
+		&(per_cpu(vcpu_acct_old_aperf, smp_processor_id())),
+		&(per_cpu(vcpu_acct_old_mperf, smp_processor_id())));
+}
+EXPORT_SYMBOL_GPL(account_system_vtime);
+
+static inline cputime_t cputime_to_scaled(const cputime_t ct)
+{
+	u64 a, m, ad, md;
+
+	/* if not intel with aperf, scale is 1 */
+	if (!is_intel_cpu_with_aperf())
+		return ct;
+
+	/* calculate delta of aperf/mperf since a_s_v() above */
+	get_intel_aperf_mperf_registers(&a, &m);
+	ad = delta_perf(a, &(per_cpu(vcpu_acct_old_aperf, smp_processor_id())));
+	md = delta_perf(m, &(per_cpu(vcpu_acct_old_mperf, smp_processor_id())));
+
+	return scale_with_perf(ct, ad, md);
+}
+
+void account_process_tick(struct task_struct *p, int user_tick)
+{
+	cputime_t one_jiffy = jiffies_to_cputime(1);
+
+	if (user_tick) {
+		account_user_time(p, one_jiffy);
+		account_user_time_scaled(p, cputime_to_scaled(one_jiffy));
+	} else {
+		account_system_time(p, HARDIRQ_OFFSET, one_jiffy);
+		account_system_time_scaled(p, cputime_to_scaled(one_jiffy));
+	}
+}
+#endif

