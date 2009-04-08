Return-Path: <linux-kernel-owner+w=401wt.eu-S1762311AbZDHKnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762311AbZDHKnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761298AbZDHKnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:43:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:56233 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761366AbZDHKnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:43:15 -0400
Date: Wed, 8 Apr 2009 10:42:42 GMT
From: Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <18908.31930.1024.228867@cargo.ozlabs.ibm.com>
References: <18908.31930.1024.228867@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: powerpc: set sample enable bit for marked instruction events
Message-ID: <tip-f708223d49ac39f5af1643985056206c98033f5b@git.kernel.org>
Git-Commit-ID: f708223d49ac39f5af1643985056206c98033f5b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 10:42:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f708223d49ac39f5af1643985056206c98033f5b
Gitweb:     http://git.kernel.org/tip/f708223d49ac39f5af1643985056206c98033f5b
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Wed, 8 Apr 2009 20:30:18 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 12:39:28 +0200

perf_counter: powerpc: set sample enable bit for marked instruction events

Impact: enable access to hardware feature

POWER processors have the ability to "mark" a subset of the instructions
and provide more detailed information on what happens to the marked
instructions as they flow through the pipeline.  This marking is
enabled by the "sample enable" bit in MMCRA, and there are
synchronization requirements around setting and clearing the bit.

This adds logic to the processor-specific back-ends so that they know
which events relate to marked instructions and set the sampling enable
bit if any event that we want to put on the PMU is a marked instruction
event.  It also adds logic to the generic powerpc code to do the
necessary synchronization if that bit is set.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <18908.31930.1024.228867@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |   28 +++++++--
 arch/powerpc/kernel/power5+-pmu.c  |  103 +++++++++++++++++++++++++++++-
 arch/powerpc/kernel/power5-pmu.c   |   96 +++++++++++++++++++++++++++-
 arch/powerpc/kernel/power6-pmu.c   |  126 +++++++++++++++++++++++++++++++++++-
 arch/powerpc/kernel/ppc970-pmu.c   |   72 ++++++++++++++++++++-
 5 files changed, 413 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 0e56513..0697ade 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -307,6 +307,15 @@ u64 hw_perf_save_disable(void)
 		}
 
 		/*
+		 * Disable instruction sampling if it was enabled
+		 */
+		if (cpuhw->mmcr[2] & MMCRA_SAMPLE_ENABLE) {
+			mtspr(SPRN_MMCRA,
+			      cpuhw->mmcr[2] & ~MMCRA_SAMPLE_ENABLE);
+			mb();
+		}
+
+		/*
 		 * Set the 'freeze counters' bit.
 		 * The barrier is to make sure the mtspr has been
 		 * executed and the PMU has frozen the counters
@@ -347,12 +356,11 @@ void hw_perf_restore(u64 disable)
 	 * (possibly updated for removal of counters).
 	 */
 	if (!cpuhw->n_added) {
-		mtspr(SPRN_MMCRA, cpuhw->mmcr[2]);
+		mtspr(SPRN_MMCRA, cpuhw->mmcr[2] & ~MMCRA_SAMPLE_ENABLE);
 		mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
-		mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
 		if (cpuhw->n_counters == 0)
 			get_lppaca()->pmcregs_in_use = 0;
-		goto out;
+		goto out_enable;
 	}
 
 	/*
@@ -385,7 +393,7 @@ void hw_perf_restore(u64 disable)
 	 * Then unfreeze the counters.
 	 */
 	get_lppaca()->pmcregs_in_use = 1;
-	mtspr(SPRN_MMCRA, cpuhw->mmcr[2]);
+	mtspr(SPRN_MMCRA, cpuhw->mmcr[2] & ~MMCRA_SAMPLE_ENABLE);
 	mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
 	mtspr(SPRN_MMCR0, (cpuhw->mmcr[0] & ~(MMCR0_PMC1CE | MMCR0_PMCjCE))
 				| MMCR0_FC);
@@ -421,10 +429,20 @@ void hw_perf_restore(u64 disable)
 		write_pmc(counter->hw.idx, val);
 		perf_counter_update_userpage(counter);
 	}
-	mb();
 	cpuhw->mmcr[0] |= MMCR0_PMXE | MMCR0_FCECE;
+
+ out_enable:
+	mb();
 	mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
 
+	/*
+	 * Enable instruction sampling if necessary
+	 */
+	if (cpuhw->mmcr[2] & MMCRA_SAMPLE_ENABLE) {
+		mb();
+		mtspr(SPRN_MMCRA, cpuhw->mmcr[2]);
+	}
+
  out:
 	local_irq_restore(flags);
 }
diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
index cec21ea..1222c8e 100644
--- a/arch/powerpc/kernel/power5+-pmu.c
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -1,5 +1,5 @@
 /*
- * Performance counter support for POWER5 (not POWER5++) processors.
+ * Performance counter support for POWER5+/++ (not POWER5) processors.
  *
  * Copyright 2009 Paul Mackerras, IBM Corporation.
  *
@@ -281,10 +281,107 @@ static int power5p_get_alternatives(unsigned int event, unsigned int alt[])
 	return nalt;
 }
 
+/*
+ * Map of which direct events on which PMCs are marked instruction events.
+ * Indexed by PMCSEL value, bit i (LE) set if PMC i is a marked event.
+ * Bit 0 is set if it is marked for all PMCs.
+ * The 0x80 bit indicates a byte decode PMCSEL value.
+ */
+static unsigned char direct_event_is_marked[0x28] = {
+	0,	/* 00 */
+	0x1f,	/* 01 PM_IOPS_CMPL */
+	0x2,	/* 02 PM_MRK_GRP_DISP */
+	0xe,	/* 03 PM_MRK_ST_CMPL, PM_MRK_ST_GPS, PM_MRK_ST_CMPL_INT */
+	0,	/* 04 */
+	0x1c,	/* 05 PM_MRK_BRU_FIN, PM_MRK_INST_FIN, PM_MRK_CRU_FIN */
+	0x80,	/* 06 */
+	0x80,	/* 07 */
+	0, 0, 0,/* 08 - 0a */
+	0x18,	/* 0b PM_THRESH_TIMEO, PM_MRK_GRP_TIMEO */
+	0,	/* 0c */
+	0x80,	/* 0d */
+	0x80,	/* 0e */
+	0,	/* 0f */
+	0,	/* 10 */
+	0x14,	/* 11 PM_MRK_GRP_BR_REDIR, PM_MRK_GRP_IC_MISS */
+	0,	/* 12 */
+	0x10,	/* 13 PM_MRK_GRP_CMPL */
+	0x1f,	/* 14 PM_GRP_MRK, PM_MRK_{FXU,FPU,LSU}_FIN */
+	0x2,	/* 15 PM_MRK_GRP_ISSUED */
+	0x80,	/* 16 */
+	0x80,	/* 17 */
+	0, 0, 0, 0, 0,
+	0x80,	/* 1d */
+	0x80,	/* 1e */
+	0,	/* 1f */
+	0x80,	/* 20 */
+	0x80,	/* 21 */
+	0x80,	/* 22 */
+	0x80,	/* 23 */
+	0x80,	/* 24 */
+	0x80,	/* 25 */
+	0x80,	/* 26 */
+	0x80,	/* 27 */
+};
+
+/*
+ * Returns 1 if event counts things relating to marked instructions
+ * and thus needs the MMCRA_SAMPLE_ENABLE bit set, or 0 if not.
+ */
+static int power5p_marked_instr_event(unsigned int event)
+{
+	int pmc, psel;
+	int bit, byte, unit;
+	u32 mask;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	psel = event & PM_PMCSEL_MSK;
+	if (pmc >= 5)
+		return 0;
+
+	bit = -1;
+	if (psel < sizeof(direct_event_is_marked)) {
+		if (direct_event_is_marked[psel] & (1 << pmc))
+			return 1;
+		if (direct_event_is_marked[psel] & 0x80)
+			bit = 4;
+		else if (psel == 0x08)
+			bit = pmc - 1;
+		else if (psel == 0x10)
+			bit = 4 - pmc;
+		else if (psel == 0x1b && (pmc == 1 || pmc == 3))
+			bit = 4;
+	} else if ((psel & 0x48) == 0x40) {
+		bit = psel & 7;
+	} else if (psel == 0x28) {
+		bit = pmc - 1;
+	} else if (pmc == 3 && (psel == 0x2e || psel == 0x2f)) {
+		bit = 4;
+	}
+
+	if (!(event & PM_BUSEVENT_MSK) || bit == -1)
+		return 0;
+
+	byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
+	unit = (event >> PM_UNIT_SH) & PM_UNIT_MSK;
+	if (unit == PM_LSU0) {
+		/* byte 1 bits 0-7, byte 2 bits 0,2-4,6 */
+		mask = 0x5dff00;
+	} else if (unit == PM_LSU1 && byte >= 4) {
+		byte -= 4;
+		/* byte 5 bits 6-7, byte 6 bits 0,4, byte 7 bits 0-4,6 */
+		mask = 0x5f11c000;
+	} else
+		return 0;
+
+	return (mask >> (byte * 8 + bit)) & 1;
+}
+
 static int power5p_compute_mmcr(unsigned int event[], int n_ev,
 				unsigned int hwc[], u64 mmcr[])
 {
 	u64 mmcr1 = 0;
+	u64 mmcra = 0;
 	unsigned int pmc, unit, byte, psel;
 	unsigned int ttm;
 	int i, isbus, bit, grsel;
@@ -404,6 +501,8 @@ static int power5p_compute_mmcr(unsigned int event[], int n_ev,
 			grsel = (event[i] >> PM_GRS_SH) & PM_GRS_MSK;
 			mmcr1 |= (u64)grsel << grsel_shift[bit];
 		}
+		if (power5p_marked_instr_event(event[i]))
+			mmcra |= MMCRA_SAMPLE_ENABLE;
 		if ((psel & 0x58) == 0x40 && (byte & 1) != ((pmc >> 1) & 1))
 			/* select alternate byte lane */
 			psel |= 0x10;
@@ -419,7 +518,7 @@ static int power5p_compute_mmcr(unsigned int event[], int n_ev,
 	if (pmc_inuse & 0x3e)
 		mmcr[0] |= MMCR0_PMCjCE;
 	mmcr[1] = mmcr1;
-	mmcr[2] = 0;
+	mmcr[2] = mmcra;
 	return 0;
 }
 
diff --git a/arch/powerpc/kernel/power5-pmu.c b/arch/powerpc/kernel/power5-pmu.c
index 379ed10..116c4bb 100644
--- a/arch/powerpc/kernel/power5-pmu.c
+++ b/arch/powerpc/kernel/power5-pmu.c
@@ -290,10 +290,102 @@ static int power5_get_alternatives(unsigned int event, unsigned int alt[])
 	return nalt;
 }
 
+/*
+ * Map of which direct events on which PMCs are marked instruction events.
+ * Indexed by PMCSEL value, bit i (LE) set if PMC i is a marked event.
+ * Bit 0 is set if it is marked for all PMCs.
+ * The 0x80 bit indicates a byte decode PMCSEL value.
+ */
+static unsigned char direct_event_is_marked[0x28] = {
+	0,	/* 00 */
+	0x1f,	/* 01 PM_IOPS_CMPL */
+	0x2,	/* 02 PM_MRK_GRP_DISP */
+	0xe,	/* 03 PM_MRK_ST_CMPL, PM_MRK_ST_GPS, PM_MRK_ST_CMPL_INT */
+	0,	/* 04 */
+	0x1c,	/* 05 PM_MRK_BRU_FIN, PM_MRK_INST_FIN, PM_MRK_CRU_FIN */
+	0x80,	/* 06 */
+	0x80,	/* 07 */
+	0, 0, 0,/* 08 - 0a */
+	0x18,	/* 0b PM_THRESH_TIMEO, PM_MRK_GRP_TIMEO */
+	0,	/* 0c */
+	0x80,	/* 0d */
+	0x80,	/* 0e */
+	0,	/* 0f */
+	0,	/* 10 */
+	0x14,	/* 11 PM_MRK_GRP_BR_REDIR, PM_MRK_GRP_IC_MISS */
+	0,	/* 12 */
+	0x10,	/* 13 PM_MRK_GRP_CMPL */
+	0x1f,	/* 14 PM_GRP_MRK, PM_MRK_{FXU,FPU,LSU}_FIN */
+	0x2,	/* 15 PM_MRK_GRP_ISSUED */
+	0x80,	/* 16 */
+	0x80,	/* 17 */
+	0, 0, 0, 0, 0,
+	0x80,	/* 1d */
+	0x80,	/* 1e */
+	0,	/* 1f */
+	0x80,	/* 20 */
+	0x80,	/* 21 */
+	0x80,	/* 22 */
+	0x80,	/* 23 */
+	0x80,	/* 24 */
+	0x80,	/* 25 */
+	0x80,	/* 26 */
+	0x80,	/* 27 */
+};
+
+/*
+ * Returns 1 if event counts things relating to marked instructions
+ * and thus needs the MMCRA_SAMPLE_ENABLE bit set, or 0 if not.
+ */
+static int power5_marked_instr_event(unsigned int event)
+{
+	int pmc, psel;
+	int bit, byte, unit;
+	u32 mask;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	psel = event & PM_PMCSEL_MSK;
+	if (pmc >= 5)
+		return 0;
+
+	bit = -1;
+	if (psel < sizeof(direct_event_is_marked)) {
+		if (direct_event_is_marked[psel] & (1 << pmc))
+			return 1;
+		if (direct_event_is_marked[psel] & 0x80)
+			bit = 4;
+		else if (psel == 0x08)
+			bit = pmc - 1;
+		else if (psel == 0x10)
+			bit = 4 - pmc;
+		else if (psel == 0x1b && (pmc == 1 || pmc == 3))
+			bit = 4;
+	} else if ((psel & 0x58) == 0x40)
+		bit = psel & 7;
+
+	if (!(event & PM_BUSEVENT_MSK))
+		return 0;
+
+	byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
+	unit = (event >> PM_UNIT_SH) & PM_UNIT_MSK;
+	if (unit == PM_LSU0) {
+		/* byte 1 bits 0-7, byte 2 bits 0,2-4,6 */
+		mask = 0x5dff00;
+	} else if (unit == PM_LSU1 && byte >= 4) {
+		byte -= 4;
+		/* byte 4 bits 1,3,5,7, byte 5 bits 6-7, byte 7 bits 0-4,6 */
+		mask = 0x5f00c0aa;
+	} else
+		return 0;
+
+	return (mask >> (byte * 8 + bit)) & 1;
+}
+
 static int power5_compute_mmcr(unsigned int event[], int n_ev,
 			       unsigned int hwc[], u64 mmcr[])
 {
 	u64 mmcr1 = 0;
+	u64 mmcra = 0;
 	unsigned int pmc, unit, byte, psel;
 	unsigned int ttm, grp;
 	int i, isbus, bit, grsel;
@@ -430,6 +522,8 @@ static int power5_compute_mmcr(unsigned int event[], int n_ev,
 			grsel = (event[i] >> PM_GRS_SH) & PM_GRS_MSK;
 			mmcr1 |= (u64)grsel << grsel_shift[bit];
 		}
+		if (power5_marked_instr_event(event[i]))
+			mmcra |= MMCRA_SAMPLE_ENABLE;
 		if (pmc <= 3)
 			mmcr1 |= psel << MMCR1_PMCSEL_SH(pmc);
 		hwc[i] = pmc;
@@ -442,7 +536,7 @@ static int power5_compute_mmcr(unsigned int event[], int n_ev,
 	if (pmc_inuse & 0x3e)
 		mmcr[0] |= MMCR0_PMCjCE;
 	mmcr[1] = mmcr1;
-	mmcr[2] = 0;
+	mmcr[2] = mmcra;
 	return 0;
 }
 
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
index b1f61f3..fce1fc2 100644
--- a/arch/powerpc/kernel/power6-pmu.c
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -49,12 +49,134 @@
 #define MMCR1_PMCSEL_MSK	0xff
 
 /*
+ * Map of which direct events on which PMCs are marked instruction events.
+ * Indexed by PMCSEL value >> 1.
+ * Bottom 4 bits are a map of which PMCs are interesting,
+ * top 4 bits say what sort of event:
+ *   0 = direct marked event,
+ *   1 = byte decode event,
+ *   4 = add/and event (PMC1 -> bits 0 & 4),
+ *   5 = add/and event (PMC1 -> bits 1 & 5),
+ *   6 = add/and event (PMC1 -> bits 2 & 6),
+ *   7 = add/and event (PMC1 -> bits 3 & 7).
+ */
+static unsigned char direct_event_is_marked[0x60 >> 1] = {
+	0,	/* 00 */
+	0,	/* 02 */
+	0,	/* 04 */
+	0x07,	/* 06 PM_MRK_ST_CMPL, PM_MRK_ST_GPS, PM_MRK_ST_CMPL_INT */
+	0x04,	/* 08 PM_MRK_DFU_FIN */
+	0x06,	/* 0a PM_MRK_IFU_FIN, PM_MRK_INST_FIN */
+	0,	/* 0c */
+	0,	/* 0e */
+	0x02,	/* 10 PM_MRK_INST_DISP */
+	0x08,	/* 12 PM_MRK_LSU_DERAT_MISS */
+	0,	/* 14 */
+	0,	/* 16 */
+	0x0c,	/* 18 PM_THRESH_TIMEO, PM_MRK_INST_FIN */
+	0x0f,	/* 1a PM_MRK_INST_DISP, PM_MRK_{FXU,FPU,LSU}_FIN */
+	0x01,	/* 1c PM_MRK_INST_ISSUED */
+	0,	/* 1e */
+	0,	/* 20 */
+	0,	/* 22 */
+	0,	/* 24 */
+	0,	/* 26 */
+	0x15,	/* 28 PM_MRK_DATA_FROM_L2MISS, PM_MRK_DATA_FROM_L3MISS */
+	0,	/* 2a */
+	0,	/* 2c */
+	0,	/* 2e */
+	0x4f,	/* 30 */
+	0x7f,	/* 32 */
+	0x4f,	/* 34 */
+	0x5f,	/* 36 */
+	0x6f,	/* 38 */
+	0x4f,	/* 3a */
+	0,	/* 3c */
+	0x08,	/* 3e PM_MRK_INST_TIMEO */
+	0x1f,	/* 40 */
+	0x1f,	/* 42 */
+	0x1f,	/* 44 */
+	0x1f,	/* 46 */
+	0x1f,	/* 48 */
+	0x1f,	/* 4a */
+	0x1f,	/* 4c */
+	0x1f,	/* 4e */
+	0,	/* 50 */
+	0x05,	/* 52 PM_MRK_BR_TAKEN, PM_MRK_BR_MPRED */
+	0x1c,	/* 54 PM_MRK_PTEG_FROM_L3MISS, PM_MRK_PTEG_FROM_L2MISS */
+	0x02,	/* 56 PM_MRK_LD_MISS_L1 */
+	0,	/* 58 */
+	0,	/* 5a */
+	0,	/* 5c */
+	0,	/* 5e */
+};
+
+/*
+ * Masks showing for each unit which bits are marked events.
+ * These masks are in LE order, i.e. 0x00000001 is byte 0, bit 0.
+ */
+static u32 marked_bus_events[16] = {
+	0x01000000,	/* direct events set 1: byte 3 bit 0 */
+	0x00010000,	/* direct events set 2: byte 2 bit 0 */
+	0, 0, 0, 0,	/* IDU, IFU, nest: nothing */
+	0x00000088,	/* VMX set 1: byte 0 bits 3, 7 */
+	0x000000c0,	/* VMX set 2: byte 0 bits 4-7 */
+	0x04010000,	/* LSU set 1: byte 2 bit 0, byte 3 bit 2 */
+	0xff010000u,	/* LSU set 2: byte 2 bit 0, all of byte 3 */
+	0,		/* LSU set 3 */
+	0x00000010,	/* VMX set 3: byte 0 bit 4 */
+	0,		/* BFP set 1 */
+	0x00000022,	/* BFP set 2: byte 0 bits 1, 5 */
+	0, 0
+};
+	
+/*
+ * Returns 1 if event counts things relating to marked instructions
+ * and thus needs the MMCRA_SAMPLE_ENABLE bit set, or 0 if not.
+ */
+static int power6_marked_instr_event(unsigned int event)
+{
+	int pmc, psel, ptype;
+	int bit, byte, unit;
+	u32 mask;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	psel = (event & PM_PMCSEL_MSK) >> 1;	/* drop edge/level bit */
+	if (pmc >= 5)
+		return 0;
+
+	bit = -1;
+	if (psel < sizeof(direct_event_is_marked)) {
+		ptype = direct_event_is_marked[psel];
+		if (pmc == 0 || !(ptype & (1 << (pmc - 1))))
+			return 0;
+		ptype >>= 4;
+		if (ptype == 0)
+			return 1;
+		if (ptype == 1)
+			bit = 0;
+		else
+			bit = ptype ^ (pmc - 1);
+	} else if ((psel & 0x48) == 0x40)
+		bit = psel & 7;
+
+	if (!(event & PM_BUSEVENT_MSK) || bit == -1)
+		return 0;
+
+	byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
+	unit = (event >> PM_UNIT_SH) & PM_UNIT_MSK;
+	mask = marked_bus_events[unit];
+	return (mask >> (byte * 8 + bit)) & 1;
+}
+
+/*
  * Assign PMC numbers and compute MMCR1 value for a set of events
  */
 static int p6_compute_mmcr(unsigned int event[], int n_ev,
 			   unsigned int hwc[], u64 mmcr[])
 {
 	u64 mmcr1 = 0;
+	u64 mmcra = 0;
 	int i;
 	unsigned int pmc, ev, b, u, s, psel;
 	unsigned int ttmset = 0;
@@ -116,6 +238,8 @@ static int p6_compute_mmcr(unsigned int event[], int n_ev,
 			if (ev & PM_LLAV)
 				mmcr1 |= MMCR1_PMC1_LLA_VALUE >> pmc;
 		}
+		if (power6_marked_instr_event(event[i]))
+			mmcra |= MMCRA_SAMPLE_ENABLE;
 		mmcr1 |= (u64)psel << MMCR1_PMCSEL_SH(pmc);
 	}
 	mmcr[0] = 0;
@@ -124,7 +248,7 @@ static int p6_compute_mmcr(unsigned int event[], int n_ev,
 	if (pmc_inuse & 0xe)
 		mmcr[0] |= MMCR0_PMCjCE;
 	mmcr[1] = mmcr1;
-	mmcr[2] = 0;
+	mmcr[2] = mmcra;
 	return 0;
 }
 
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index c325658..aed8ccd 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -19,6 +19,8 @@
 #define PM_PMC_MSK	0xf
 #define PM_UNIT_SH	8	/* TTMMUX number and setting - unit select */
 #define PM_UNIT_MSK	0xf
+#define PM_SPCSEL_SH	6
+#define PM_SPCSEL_MSK	3
 #define PM_BYTE_SH	4	/* Byte number of event bus to use */
 #define PM_BYTE_MSK	3
 #define PM_PMCSEL_MSK	0xf
@@ -88,8 +90,11 @@ static short mmcr1_adder_bits[8] = {
  * Layout of constraint bits:
  * 6666555555555544444444443333333333222222222211111111110000000000
  * 3210987654321098765432109876543210987654321098765432109876543210
- *                 <><>[  >[  >[  ><  ><  ><  ><  ><><><><><><><><>
- *                 T0T1 UC  PS1 PS2 B0  B1  B2  B3 P1P2P3P4P5P6P7P8
+ *               <><><>[  >[  >[  ><  ><  ><  ><  ><><><><><><><><>
+ *               SPT0T1 UC  PS1 PS2 B0  B1  B2  B3 P1P2P3P4P5P6P7P8
+ *
+ * SP - SPCSEL constraint
+ *     48-49: SPCSEL value 0x3_0000_0000_0000
  *
  * T0 - TTM0 constraint
  *     46-47: TTM0SEL value (0=FPU, 2=IFU, 3=VPU) 0xC000_0000_0000
@@ -126,6 +131,57 @@ static short mmcr1_adder_bits[8] = {
  *     0-13: Count of events needing PMC2..PMC8
  */
 
+static unsigned char direct_marked_event[8] = {
+	(1<<2) | (1<<3),	/* PMC1: PM_MRK_GRP_DISP, PM_MRK_ST_CMPL */
+	(1<<3) | (1<<5),	/* PMC2: PM_THRESH_TIMEO, PM_MRK_BRU_FIN */
+	(1<<3) | (1<<5),	/* PMC3: PM_MRK_ST_CMPL_INT, PM_MRK_VMX_FIN */
+	(1<<4) | (1<<5),	/* PMC4: PM_MRK_GRP_CMPL, PM_MRK_CRU_FIN */
+	(1<<4) | (1<<5),	/* PMC5: PM_GRP_MRK, PM_MRK_GRP_TIMEO */
+	(1<<3) | (1<<4) | (1<<5),
+		/* PMC6: PM_MRK_ST_STS, PM_MRK_FXU_FIN, PM_MRK_GRP_ISSUED */
+	(1<<4) | (1<<5),	/* PMC7: PM_MRK_FPU_FIN, PM_MRK_INST_FIN */
+	(1<<4)			/* PMC8: PM_MRK_LSU_FIN */
+};
+
+/*
+ * Returns 1 if event counts things relating to marked instructions
+ * and thus needs the MMCRA_SAMPLE_ENABLE bit set, or 0 if not.
+ */
+static int p970_marked_instr_event(unsigned int event)
+{
+	int pmc, psel, unit, byte, bit;
+	unsigned int mask;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	psel = event & PM_PMCSEL_MSK;
+	if (pmc) {
+		if (direct_marked_event[pmc - 1] & (1 << psel))
+			return 1;
+		if (psel == 0)		/* add events */
+			bit = (pmc <= 4)? pmc - 1: 8 - pmc;
+		else if (psel == 7 || psel == 13)	/* decode events */
+			bit = 4;
+		else
+			return 0;
+	} else
+		bit = psel;
+
+	byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
+	unit = (event >> PM_UNIT_SH) & PM_UNIT_MSK;
+	mask = 0;
+	switch (unit) {
+	case PM_VPU:
+		mask = 0x4c;		/* byte 0 bits 2,3,6 */
+	case PM_LSU0:
+		/* byte 2 bits 0,2,3,4,6; all of byte 1 */
+		mask = 0x085dff00;
+	case PM_LSU1L:
+		mask = 0x50 << 24;	/* byte 3 bits 4,6 */
+		break;
+	}
+	return (mask >> (byte * 8 + bit)) & 1;
+}
+
 /* Masks and values for using events from the various units */
 static u64 unit_cons[PM_LASTUNIT+1][2] = {
 	[PM_FPU] =   { 0xc80000000000ull, 0x040000000000ull },
@@ -138,7 +194,7 @@ static u64 unit_cons[PM_LASTUNIT+1][2] = {
 
 static int p970_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
 {
-	int pmc, byte, unit, sh;
+	int pmc, byte, unit, sh, spcsel;
 	u64 mask = 0, value = 0;
 	int grp = -1;
 
@@ -177,6 +233,11 @@ static int p970_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
 		mask  |= 0x800000000ull;
 		value |= 0x100000000ull;
 	}
+	spcsel = (event >> PM_SPCSEL_SH) & PM_SPCSEL_MSK;
+	if (spcsel) {
+		mask  |= 3ull << 48;
+		value |= (u64)spcsel << 48;
+	}
 	*maskp = mask;
 	*valp = value;
 	return 0;
@@ -209,6 +270,7 @@ static int p970_compute_mmcr(unsigned int event[], int n_ev,
 	unsigned char ttmuse[2];
 	unsigned char pmcsel[8];
 	int i;
+	int spcsel;
 
 	if (n_ev > 8)
 		return -1;
@@ -316,6 +378,10 @@ static int p970_compute_mmcr(unsigned int event[], int n_ev,
 		}
 		pmcsel[pmc] = psel;
 		hwc[i] = pmc;
+		spcsel = (event[i] >> PM_SPCSEL_SH) & PM_SPCSEL_MSK;
+		mmcr1 |= spcsel;
+		if (p970_marked_instr_event(event[i]))
+			mmcra |= MMCRA_SAMPLE_ENABLE;
 	}
 	for (pmc = 0; pmc < 2; ++pmc)
 		mmcr0 |= pmcsel[pmc] << (MMCR0_PMC1SEL_SH - 7 * pmc);
