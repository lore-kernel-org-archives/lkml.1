Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbZE2FpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbZE2FpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 01:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZE2FpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 01:45:05 -0400
Received: from mga10.intel.com ([192.55.52.92]:41274 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751554AbZE2FpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 01:45:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,269,1241420400"; 
   d="scan'208";a="461454406"
Date: Fri, 29 May 2009 13:28:35 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] perf_counter/x86: Always use NMI for
	performance-monitoring interrupt
Message-ID: <20090529052835.GA13657@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always use NMI for performance-monitoring interrupt as there could be
racy situations if we switch between irq and nmi mode frequently.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>

---
 include/asm/perf_counter.h |    4 ++--
 kernel/apic/apic.c         |    2 +-
 kernel/cpu/perf_counter.c  |   19 +++++--------------
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/perf_counter.h b/arch/x86/include/asm/perf_counter.h
index d08dd52..876ed97 100644
--- a/arch/x86/include/asm/perf_counter.h
+++ b/arch/x86/include/asm/perf_counter.h
@@ -91,10 +91,10 @@ extern void set_perf_counter_pending(void);
 
 #ifdef CONFIG_PERF_COUNTERS
 extern void init_hw_perf_counters(void);
-extern void perf_counters_lapic_init(int nmi);
+extern void perf_counters_lapic_init(void);
 #else
 static inline void init_hw_perf_counters(void)		{ }
-static inline void perf_counters_lapic_init(int nmi)	{ }
+static inline void perf_counters_lapic_init(void)	{ }
 #endif
 
 #endif /* _ASM_X86_PERF_COUNTER_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 749fae9..622d11a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1189,7 +1189,7 @@ void __cpuinit setup_local_APIC(void)
 		apic_write(APIC_ESR, 0);
 	}
 #endif
-	perf_counters_lapic_init(0);
+	perf_counters_lapic_init();
 
 	preempt_disable();
 
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 2eeaa99..316b0c9 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -604,7 +604,7 @@ try_generic:
 		hwc->counter_base = x86_pmu.perfctr;
 	}
 
-	perf_counters_lapic_init(hwc->nmi);
+	perf_counters_lapic_init();
 
 	x86_pmu.disable(hwc, idx);
 
@@ -863,24 +863,15 @@ void set_perf_counter_pending(void)
 	apic->send_IPI_self(LOCAL_PENDING_VECTOR);
 }
 
-void perf_counters_lapic_init(int nmi)
+void perf_counters_lapic_init(void)
 {
-	u32 apic_val;
-
 	if (!x86_pmu_initialized())
 		return;
 
 	/*
-	 * Enable the performance counter vector in the APIC LVT:
+	 * Always use NMI for PMU
 	 */
-	apic_val = apic_read(APIC_LVTERR);
-
-	apic_write(APIC_LVTERR, apic_val | APIC_LVT_MASKED);
-	if (nmi)
-		apic_write(APIC_LVTPC, APIC_DM_NMI);
-	else
-		apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
-	apic_write(APIC_LVTERR, apic_val);
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
 
 static int __kprobes
@@ -1054,7 +1045,7 @@ void __init init_hw_perf_counters(void)
 
 	pr_info("... counter mask:    %016Lx\n", perf_counter_mask);
 
-	perf_counters_lapic_init(0);
+	perf_counters_lapic_init();
 	register_die_notifier(&perf_counter_nmi_notifier);
 }
 
