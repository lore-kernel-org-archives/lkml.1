Return-Path: <linux-kernel-owner+w=401wt.eu-S1763261AbZEOOqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763261AbZEOOqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbZEOOpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:45:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:55988 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762706AbZEOOpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:45:11 -0400
Date: Fri, 15 May 2009 14:44:31 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <18955.37028.48861.555309@drongo.ozlabs.ibm.com>
References: <18955.37028.48861.555309@drongo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: powerpc: supply more precise information on counter overflow events
Message-ID: <tip-0bbd0d4be8d5d3676c126e06e3c75c16def00441@git.kernel.org>
Git-Commit-ID: 0bbd0d4be8d5d3676c126e06e3c75c16def00441
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 14:44:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bbd0d4be8d5d3676c126e06e3c75c16def00441
Gitweb:     http://git.kernel.org/tip/0bbd0d4be8d5d3676c126e06e3c75c16def00441
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Thu, 14 May 2009 13:31:48 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 16:38:57 +0200

perf_counter: powerpc: supply more precise information on counter overflow events

This uses values from the MMCRA, SIAR and SDAR registers on
powerpc to supply more precise information for overflow events,
including a data address when PERF_RECORD_ADDR is specified.

Since POWER6 uses different bit positions in MMCRA from earlier
processors, this converts the struct power_pmu limited_pmc5_6
field, which only had 0/1 values, into a flags field and
defines bit values for its previous use (PPMU_LIMITED_PMC5_6)
and a new flag (PPMU_ALT_SIPR) to indicate that the processor
uses the POWER6 bit positions rather than the earlier
positions.  It also adds definitions in reg.h for the new and
old positions of the bit that indicates that the SIAR and SDAR
values come from the same instruction.

For the data address, the SDAR value is supplied if we are not
doing instruction sampling.  In that case there is no guarantee
that the address given in the PERF_RECORD_ADDR subrecord will
correspond to the instruction whose address is given in the
PERF_RECORD_IP subrecord.

If instruction sampling is enabled (e.g. because this counter
is counting a marked instruction event), then we only supply
the SDAR value for the PERF_RECORD_ADDR subrecord if it
corresponds to the instruction whose address is in the
PERF_RECORD_IP subrecord.  Otherwise we supply 0.

[ Impact: support more PMU hardware features on PowerPC ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <18955.37028.48861.555309@drongo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/include/asm/perf_counter.h |   14 +++++-
 arch/powerpc/include/asm/reg.h          |    2 +
 arch/powerpc/kernel/perf_counter.c      |   84 +++++++++++++++++++++++++++++--
 arch/powerpc/kernel/power5+-pmu.c       |    2 +-
 arch/powerpc/kernel/power6-pmu.c        |    2 +-
 5 files changed, 97 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
index ceea76a..1c60f0c 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -30,7 +30,7 @@ struct power_pmu {
 				    u64 alt[]);
 	void	(*disable_pmc)(unsigned int pmc, u64 mmcr[]);
 	int	(*limited_pmc_event)(u64 event);
-	int	limited_pmc5_6;	/* PMC5 and PMC6 have limited function */
+	u32	flags;
 	int	n_generic;
 	int	*generic_events;
 };
@@ -38,12 +38,24 @@ struct power_pmu {
 extern struct power_pmu *ppmu;
 
 /*
+ * Values for power_pmu.flags
+ */
+#define PPMU_LIMITED_PMC5_6	1	/* PMC5/6 have limited function */
+#define PPMU_ALT_SIPR		2	/* uses alternate posn for SIPR/HV */
+
+/*
  * Values for flags to get_alternatives()
  */
 #define PPMU_LIMITED_PMC_OK	1	/* can put this on a limited PMC */
 #define PPMU_LIMITED_PMC_REQD	2	/* have to put this on a limited PMC */
 #define PPMU_ONLY_COUNT_RUN	4	/* only counting in run state */
 
+struct pt_regs;
+extern unsigned long perf_misc_flags(struct pt_regs *regs);
+#define perf_misc_flags(regs)	perf_misc_flags(regs)
+
+extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
+
 /*
  * The power_pmu.get_constraint function returns a 64-bit value and
  * a 64-bit mask that express the constraints between this event and
diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index e8018d5..fb359b0 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -492,11 +492,13 @@
 #define   MMCR0_FCHV	0x00000001UL /* freeze conditions in hypervisor mode */
 #define SPRN_MMCR1	798
 #define SPRN_MMCRA	0x312
+#define   MMCRA_SDSYNC	0x80000000UL /* SDAR synced with SIAR */
 #define   MMCRA_SIHV	0x10000000UL /* state of MSR HV when SIAR set */
 #define   MMCRA_SIPR	0x08000000UL /* state of MSR PR when SIAR set */
 #define   MMCRA_SLOT	0x07000000UL /* SLOT bits (37-39) */
 #define   MMCRA_SLOT_SHIFT	24
 #define   MMCRA_SAMPLE_ENABLE 0x00000001UL /* enable sampling */
+#define   POWER6_MMCRA_SDSYNC 0x0000080000000000ULL	/* SDAR/SIAR synced */
 #define   POWER6_MMCRA_SIHV   0x0000040000000000ULL
 #define   POWER6_MMCRA_SIPR   0x0000020000000000ULL
 #define   POWER6_MMCRA_THRM	0x00000020UL
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 8d4cafc..6baae5a 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -17,6 +17,7 @@
 #include <asm/pmc.h>
 #include <asm/machdep.h>
 #include <asm/firmware.h>
+#include <asm/ptrace.h>
 
 struct cpu_hw_counters {
 	int n_counters;
@@ -310,7 +311,8 @@ static void power_pmu_read(struct perf_counter *counter)
  */
 static int is_limited_pmc(int pmcnum)
 {
-	return ppmu->limited_pmc5_6 && (pmcnum == 5 || pmcnum == 6);
+	return (ppmu->flags & PPMU_LIMITED_PMC5_6)
+		&& (pmcnum == 5 || pmcnum == 6);
 }
 
 static void freeze_limited_counters(struct cpu_hw_counters *cpuhw,
@@ -860,7 +862,7 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 	 * If this machine has limited counters, check whether this
 	 * event could go on a limited counter.
 	 */
-	if (ppmu->limited_pmc5_6) {
+	if (ppmu->flags & PPMU_LIMITED_PMC5_6) {
 		if (can_go_on_limited_pmc(counter, ev, flags)) {
 			flags |= PPMU_LIMITED_PMC_OK;
 		} else if (ppmu->limited_pmc_event(ev)) {
@@ -933,6 +935,7 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	u64 period = counter->hw.irq_period;
 	s64 prev, delta, left;
 	int record = 0;
+	u64 addr, mmcra, sdsync;
 
 	/* we don't have to worry about interrupts here */
 	prev = atomic64_read(&counter->hw.prev_count);
@@ -963,8 +966,76 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	/*
 	 * Finally record data if requested.
 	 */
-	if (record)
-		perf_counter_overflow(counter, nmi, regs, 0);
+	if (record) {
+		addr = 0;
+		if (counter->hw_event.record_type & PERF_RECORD_ADDR) {
+			/*
+			 * The user wants a data address recorded.
+			 * If we're not doing instruction sampling,
+			 * give them the SDAR (sampled data address).
+			 * If we are doing instruction sampling, then only
+			 * give them the SDAR if it corresponds to the
+			 * instruction pointed to by SIAR; this is indicated
+			 * by the [POWER6_]MMCRA_SDSYNC bit in MMCRA.
+			 */
+			mmcra = regs->dsisr;
+			sdsync = (ppmu->flags & PPMU_ALT_SIPR) ?
+				POWER6_MMCRA_SDSYNC : MMCRA_SDSYNC;
+			if (!(mmcra & MMCRA_SAMPLE_ENABLE) || (mmcra & sdsync))
+				addr = mfspr(SPRN_SDAR);
+		}
+		perf_counter_overflow(counter, nmi, regs, addr);
+	}
+}
+
+/*
+ * Called from generic code to get the misc flags (i.e. processor mode)
+ * for an event.
+ */
+unsigned long perf_misc_flags(struct pt_regs *regs)
+{
+	unsigned long mmcra;
+
+	if (TRAP(regs) != 0xf00) {
+		/* not a PMU interrupt */
+		return user_mode(regs) ? PERF_EVENT_MISC_USER :
+			PERF_EVENT_MISC_KERNEL;
+	}
+
+	mmcra = regs->dsisr;
+	if (ppmu->flags & PPMU_ALT_SIPR) {
+		if (mmcra & POWER6_MMCRA_SIHV)
+			return PERF_EVENT_MISC_HYPERVISOR;
+		return (mmcra & POWER6_MMCRA_SIPR) ? PERF_EVENT_MISC_USER :
+			PERF_EVENT_MISC_KERNEL;
+	}
+	if (mmcra & MMCRA_SIHV)
+		return PERF_EVENT_MISC_HYPERVISOR;
+	return (mmcra & MMCRA_SIPR) ? PERF_EVENT_MISC_USER :
+			PERF_EVENT_MISC_KERNEL;
+}
+
+/*
+ * Called from generic code to get the instruction pointer
+ * for an event.
+ */
+unsigned long perf_instruction_pointer(struct pt_regs *regs)
+{
+	unsigned long mmcra;
+	unsigned long ip;
+	unsigned long slot;
+
+	if (TRAP(regs) != 0xf00)
+		return regs->nip;	/* not a PMU interrupt */
+
+	ip = mfspr(SPRN_SIAR);
+	mmcra = regs->dsisr;
+	if ((mmcra & MMCRA_SAMPLE_ENABLE) && !(ppmu->flags & PPMU_ALT_SIPR)) {
+		slot = (mmcra & MMCRA_SLOT) >> MMCRA_SLOT_SHIFT;
+		if (slot > 1)
+			ip += 4 * (slot - 1);
+	}
+	return ip;
 }
 
 /*
@@ -984,6 +1055,11 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 					mfspr(SPRN_PMC6));
 
 	/*
+	 * Overload regs->dsisr to store MMCRA so we only need to read it once.
+	 */
+	regs->dsisr = mfspr(SPRN_MMCRA);
+
+	/*
 	 * If interrupts were soft-disabled when this PMU interrupt
 	 * occurred, treat it as an NMI.
 	 */
diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
index 3ac0654..c6cdfc1 100644
--- a/arch/powerpc/kernel/power5+-pmu.c
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -625,6 +625,6 @@ struct power_pmu power5p_pmu = {
 	.disable_pmc = power5p_disable_pmc,
 	.n_generic = ARRAY_SIZE(power5p_generic_events),
 	.generic_events = power5p_generic_events,
-	.limited_pmc5_6 = 1,
+	.flags = PPMU_LIMITED_PMC5_6,
 	.limited_pmc_event = power5p_limited_pmc_event,
 };
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
index ab7c615..cd4fbe0 100644
--- a/arch/powerpc/kernel/power6-pmu.c
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -485,6 +485,6 @@ struct power_pmu power6_pmu = {
 	.disable_pmc = p6_disable_pmc,
 	.n_generic = ARRAY_SIZE(power6_generic_events),
 	.generic_events = power6_generic_events,
-	.limited_pmc5_6 = 1,
+	.flags = PPMU_LIMITED_PMC5_6 | PPMU_ALT_SIPR,
 	.limited_pmc_event = p6_limited_pmc_event,
 };
