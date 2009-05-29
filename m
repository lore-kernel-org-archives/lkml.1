Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZE2JBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZE2JBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZE2JBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:01:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:59572 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbZE2JBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:01:05 -0400
Date: Fri, 29 May 2009 09:00:34 GMT
From: tip-bot for Yong Wang <yong.y.wang@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yong.y.wang@linux.intel.com, yong.y.wang@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yong.y.wang@linux.intel.com, yong.y.wang@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090529052835.GA13657@ywang-moblin2.bj.intel.com>
References: <20090529052835.GA13657@ywang-moblin2.bj.intel.com>
Subject: [tip:perfcounters/core] perf_counter/x86: Always use NMI for performance-monitoring interrupt
Message-ID: <tip-c323d95fa4dbe0b6bf6d59e24a0b7db067dd08a7@git.kernel.org>
Git-Commit-ID: c323d95fa4dbe0b6bf6d59e24a0b7db067dd08a7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 09:00:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c323d95fa4dbe0b6bf6d59e24a0b7db067dd08a7
Gitweb:     http://git.kernel.org/tip/c323d95fa4dbe0b6bf6d59e24a0b7db067dd08a7
Author:     Yong Wang <yong.y.wang@linux.intel.com>
AuthorDate: Fri, 29 May 2009 13:28:35 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 09:04:58 +0200

perf_counter/x86: Always use NMI for performance-monitoring interrupt

Always use NMI for performance-monitoring interrupt as there could be
racy situations if we switch between irq and nmi mode frequently.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
LKML-Reference: <20090529052835.GA13657@ywang-moblin2.bj.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/perf_counter.h |    4 ++--
 arch/x86/kernel/apic/apic.c         |    2 +-
 arch/x86/kernel/cpu/perf_counter.c  |   19 +++++--------------
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
index 89b63b5..60df2ef 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1135,7 +1135,7 @@ void __cpuinit setup_local_APIC(void)
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
 
