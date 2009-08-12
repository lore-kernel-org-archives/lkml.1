Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbZHLMTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbZHLMTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZHLMTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:19:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:54971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbZHLMS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:18:58 -0400
Date: Wed, 12 Aug 2009 12:18:19 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu, js@sig21.net
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu, js@sig21.net
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter, x86: Fix/improve apic fallback
Message-ID: <tip-04da8a43da804723a550f00dd158fd5b5e25ae35@git.kernel.org>
Git-Commit-ID: 04da8a43da804723a550f00dd158fd5b5e25ae35
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 12 Aug 2009 12:18:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04da8a43da804723a550f00dd158fd5b5e25ae35
Gitweb:     http://git.kernel.org/tip/04da8a43da804723a550f00dd158fd5b5e25ae35
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 11 Aug 2009 10:40:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 12 Aug 2009 14:12:49 +0200

perf_counter, x86: Fix/improve apic fallback

Johannes Stezenbach reported that his Pentium-M based
laptop does not have the local APIC enabled by default,
and hence perfcounters do not get initialized.

Add a fallback for this case: allow non-sampled counters
and return with an error on sampled counters. This allows
'perf stat' to work out of box - and allows 'perf top'
and 'perf record' to fall back on a hrtimer based sampling
method.

( Passing 'lapic' on the boot line will allow hardware
  sampling to occur - but if the APIC is disabled
  permanently by the hardware then this fallback still
  allows more systems to use perfcounters. )

Also decouple perfcounter support from X86_LOCAL_APIC.

-v2: fix typo breaking counters on all other systems ...

Reported-by: Johannes Stezenbach <js@sig21.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig                   |    2 +-
 arch/x86/kernel/cpu/perf_counter.c |   34 ++++++++++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 738bdc6..13ffa5d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -24,6 +24,7 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_PERF_COUNTERS if (!M386 && !M486)
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
@@ -742,7 +743,6 @@ config X86_UP_IOAPIC
 config X86_LOCAL_APIC
 	def_bool y
 	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC
-	select HAVE_PERF_COUNTERS if (!M386 && !M486)
 
 config X86_IO_APIC
 	def_bool y
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index fffc126..900332b 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -55,6 +55,7 @@ struct x86_pmu {
 	int		num_counters_fixed;
 	int		counter_bits;
 	u64		counter_mask;
+	int		apic;
 	u64		max_period;
 	u64		intel_ctrl;
 };
@@ -613,6 +614,7 @@ static DEFINE_MUTEX(pmc_reserve_mutex);
 
 static bool reserve_pmc_hardware(void)
 {
+#ifdef CONFIG_X86_LOCAL_APIC
 	int i;
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
@@ -627,9 +629,11 @@ static bool reserve_pmc_hardware(void)
 		if (!reserve_evntsel_nmi(x86_pmu.eventsel + i))
 			goto eventsel_fail;
 	}
+#endif
 
 	return true;
 
+#ifdef CONFIG_X86_LOCAL_APIC
 eventsel_fail:
 	for (i--; i >= 0; i--)
 		release_evntsel_nmi(x86_pmu.eventsel + i);
@@ -644,10 +648,12 @@ perfctr_fail:
 		enable_lapic_nmi_watchdog();
 
 	return false;
+#endif
 }
 
 static void release_pmc_hardware(void)
 {
+#ifdef CONFIG_X86_LOCAL_APIC
 	int i;
 
 	for (i = 0; i < x86_pmu.num_counters; i++) {
@@ -657,6 +663,7 @@ static void release_pmc_hardware(void)
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		enable_lapic_nmi_watchdog();
+#endif
 }
 
 static void hw_perf_counter_destroy(struct perf_counter *counter)
@@ -748,6 +755,15 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 		hwc->sample_period = x86_pmu.max_period;
 		hwc->last_period = hwc->sample_period;
 		atomic64_set(&hwc->period_left, hwc->sample_period);
+	} else {
+		/*
+		 * If we have a PMU initialized but no APIC
+		 * interrupts, we cannot sample hardware
+		 * counters (user-space has to fall back and
+		 * sample via a hrtimer based software counter):
+		 */
+		if (!x86_pmu.apic)
+			return -EOPNOTSUPP;
 	}
 
 	counter->destroy = hw_perf_counter_destroy;
@@ -1449,18 +1465,22 @@ void smp_perf_pending_interrupt(struct pt_regs *regs)
 
 void set_perf_counter_pending(void)
 {
+#ifdef CONFIG_X86_LOCAL_APIC
 	apic->send_IPI_self(LOCAL_PENDING_VECTOR);
+#endif
 }
 
 void perf_counters_lapic_init(void)
 {
-	if (!x86_pmu_initialized())
+#ifdef CONFIG_X86_LOCAL_APIC
+	if (!x86_pmu.apic || !x86_pmu_initialized())
 		return;
 
 	/*
 	 * Always use NMI for PMU
 	 */
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
+#endif
 }
 
 static int __kprobes
@@ -1484,7 +1504,9 @@ perf_counter_nmi_handler(struct notifier_block *self,
 
 	regs = args->regs;
 
+#ifdef CONFIG_X86_LOCAL_APIC
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
+#endif
 	/*
 	 * Can't rely on the handled return value to say it was our NMI, two
 	 * counters could trigger 'simultaneously' raising two back-to-back NMIs.
@@ -1515,6 +1537,7 @@ static struct x86_pmu p6_pmu = {
 	.event_map		= p6_pmu_event_map,
 	.raw_event		= p6_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(p6_perfmon_event_map),
+	.apic			= 1,
 	.max_period		= (1ULL << 31) - 1,
 	.version		= 0,
 	.num_counters		= 2,
@@ -1541,6 +1564,7 @@ static struct x86_pmu intel_pmu = {
 	.event_map		= intel_pmu_event_map,
 	.raw_event		= intel_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
+	.apic			= 1,
 	/*
 	 * Intel PMCs cannot be accessed sanely above 32 bit width,
 	 * so we install an artificial 1<<31 period regardless of
@@ -1564,6 +1588,7 @@ static struct x86_pmu amd_pmu = {
 	.num_counters		= 4,
 	.counter_bits		= 48,
 	.counter_mask		= (1ULL << 48) - 1,
+	.apic			= 1,
 	/* use highest bit to detect overflow */
 	.max_period		= (1ULL << 47) - 1,
 };
@@ -1589,13 +1614,14 @@ static int p6_pmu_init(void)
 		return -ENODEV;
 	}
 
+	x86_pmu = p6_pmu;
+
 	if (!cpu_has_apic) {
 		pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
-		return -ENODEV;
+		pr_info("no hardware sampling interrupt available.\n");
+		x86_pmu.apic = 0;
 	}
 
-	x86_pmu				= p6_pmu;
-
 	return 0;
 }
 
