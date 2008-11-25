Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYKYVrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYKYVrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYKYVov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:44:51 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43499 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755551AbYKYVot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:44:49 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/6] Centralize access to APERF and MPERF MSRs on Intel CPUs
To: "Darrick J. Wong" <djwong@us.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar.sarma@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Date: Tue, 25 Nov 2008 13:44:47 -0800
Message-ID: <20081125214447.22900.22395.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20081125214437.22900.82384.stgit@elm3a70.beaverton.ibm.com>
References: <20081125214437.22900.82384.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides helper functions to detect and to access the APERF
and MPERF MSRs on certain Intel CPUs.  These two registers are useful
for determining the measured performance over a period of time while
the CPU is in C0 state.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 arch/x86/include/asm/system.h |   19 ++++++++
 arch/x86/kernel/Makefile      |    2 -
 arch/x86/kernel/time.c        |  103 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 2ed3f0f..787f5c2 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -422,4 +422,23 @@ static inline void rdtsc_barrier(void)
 	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
 }
 
+#define U64_MAX	(u64)(~((u64)0))
+
+static inline u64 delta_perf(u64 now, u64 *old)
+{
+	u64 delta;
+
+	if (now > *old)
+		delta = now - *old;
+	else
+		delta = now + (U64_MAX - *old);
+
+	*old = now;
+	return delta;
+}
+
+void get_intel_aperf_mperf_registers(u64 *aperf, u64 *mperf);
+u64 scale_with_perf(u64 input, u64 aperf, u64 mperf);
+#define CPUID_6_ECX_APERFMPERF_CAPABILITY	(0x1)
+
 #endif /* _ASM_X86_SYSTEM_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index e489ff9..7c20f6f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -25,7 +25,7 @@ CFLAGS_tsc.o		:= $(nostackp)
 
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
-obj-y			+= time_$(BITS).o ioport.o ldt.o
+obj-y			+= time_$(BITS).o ioport.o ldt.o time.o
 obj-y			+= setup.o i8259.o irqinit_$(BITS).o setup_percpu.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
new file mode 100644
index 0000000..41ff323
--- /dev/null
+++ b/arch/x86/kernel/time.c
@@ -0,0 +1,103 @@
+#include <linux/kernel_stat.h>
+#include <linux/module.h>
+#include <linux/hardirq.h>
+
+void get_intel_aperf_mperf_registers(u64 *aperf, u64 *mperf)
+{
+	union {
+		struct {
+			u32 lo;
+			u32 hi;
+		} split;
+		u64 whole;
+	} aperf_cur, mperf_cur;
+	unsigned long flags;
+
+	/* Read current values of APERF and MPERF MSRs*/
+	local_irq_save(flags);
+	rdmsr(MSR_IA32_MPERF, mperf_cur.split.lo, mperf_cur.split.hi);
+	rdmsr(MSR_IA32_APERF, aperf_cur.split.lo, aperf_cur.split.hi);
+	local_irq_restore(flags);
+
+	*mperf = mperf_cur.whole;
+	*aperf = aperf_cur.whole;
+}
+EXPORT_SYMBOL_GPL(get_intel_aperf_mperf_registers);
+
+u64 scale_with_perf(u64 input, u64 aperf, u64 mperf)
+{
+	union {
+		struct {
+			u32 lo;
+			u32 hi;
+		} split;
+		u64 whole;
+	} aperf_cur, mperf_cur;
+
+	aperf_cur.whole = aperf;
+	mperf_cur.whole = mperf;
+
+#ifdef __i386__
+	/*
+	 * We dont want to do 64 bit divide with 32 bit kernel
+	 * Get an approximate value. Return failure in case we cannot get
+	 * an approximate value.
+	 */
+	if (unlikely(aperf_cur.split.hi || mperf_cur.split.hi)) {
+		int shift_count;
+		u32 h;
+
+		h = max_t(u32, aperf_cur.split.hi, mperf_cur.split.hi);
+		shift_count = fls(h);
+
+		aperf_cur.whole >>= shift_count;
+		mperf_cur.whole >>= shift_count;
+	}
+
+	if (((unsigned long)(-1) / 100) < aperf_cur.split.lo) {
+		int shift_count = 7;
+		aperf_cur.split.lo >>= shift_count;
+		mperf_cur.split.lo >>= shift_count;
+	}
+
+	if (aperf_cur.split.lo && mperf_cur.split.lo)
+		return (aperf_cur.split.lo * input) / mperf_cur.split.lo;
+#else
+	if (unlikely(((unsigned long)(-1) / 100) < aperf_cur.whole)) {
+		int shift_count = 7;
+		aperf_cur.whole >>= shift_count;
+		mperf_cur.whole >>= shift_count;
+	}
+
+	if (aperf_cur.whole && mperf_cur.whole)
+		return (aperf_cur.whole * input) / mperf_cur.whole;
+#endif
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scale_with_perf);
+
+static inline int is_intel_cpu_with_aperf(void)
+{
+	struct cpuinfo_x86 *c;
+	static int has_aperf = -1;
+
+	if (has_aperf >= 0)
+		return has_aperf;
+
+	/* If cpuid_level = 0, it might not have been set yet */
+	c = &cpu_data(smp_processor_id());
+	if (!c->x86_vendor && !c->cpuid_level)
+		return 0;
+
+	/* Check for APERF/MPERF support in hardware */
+	has_aperf = 0;
+	if (c->x86_vendor == X86_VENDOR_INTEL && c->cpuid_level >= 6) {
+		unsigned int ecx;
+		ecx = cpuid_ecx(6);
+		if (ecx & CPUID_6_ECX_APERFMPERF_CAPABILITY)
+			has_aperf = 1;
+	}
+
+	return has_aperf;
+}
+EXPORT_SYMBOL_GPL(is_intel_cpu_with_aperf);

