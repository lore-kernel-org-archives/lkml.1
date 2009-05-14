Return-Path: <linux-kernel-owner+w=401wt.eu-S1762632AbZENDaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762632AbZENDaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 23:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbZEND3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 23:29:53 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:51981 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbZEND3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 23:29:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18955.36874.472452.353104@drongo.ozlabs.ibm.com>
Date: Thu, 14 May 2009 13:29:14 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] perf_counter: powerpc: use u64 for event codes internally
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the perf_counter API allows 63-bit raw event codes, internally
in the powerpc back-end we had been using 32-bit event codes.  This
expands them to 64 bits so that we can add bits for specifying threshold
start/stop events and instruction sampling modes later.

This also corrects the return value of can_go_on_limited_pmc; we were
returning an event code rather than just a 0/1 value in some circumstances.
That didn't particularly matter while event codes were 32-bit, but now
that event codes are 64-bit it might, so this fixes it.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/include/asm/perf_counter.h |   10 +++++-----
 arch/powerpc/kernel/perf_counter.c      |   26 ++++++++++++--------------
 arch/powerpc/kernel/power4-pmu.c        |    9 ++++-----
 arch/powerpc/kernel/power5+-pmu.c       |   14 +++++++-------
 arch/powerpc/kernel/power5-pmu.c        |   16 ++++++++--------
 arch/powerpc/kernel/power6-pmu.c        |   16 ++++++++--------
 arch/powerpc/kernel/ppc970-pmu.c        |    9 ++++-----
 7 files changed, 48 insertions(+), 52 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
index 56d66c3..ceea76a 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -23,13 +23,13 @@ struct power_pmu {
 	int	max_alternatives;
 	u64	add_fields;
 	u64	test_adder;
-	int	(*compute_mmcr)(unsigned int events[], int n_ev,
+	int	(*compute_mmcr)(u64 events[], int n_ev,
 				unsigned int hwc[], u64 mmcr[]);
-	int	(*get_constraint)(unsigned int event, u64 *mskp, u64 *valp);
-	int	(*get_alternatives)(unsigned int event, unsigned int flags,
-				    unsigned int alt[]);
+	int	(*get_constraint)(u64 event, u64 *mskp, u64 *valp);
+	int	(*get_alternatives)(u64 event, unsigned int flags,
+				    u64 alt[]);
 	void	(*disable_pmc)(unsigned int pmc, u64 mmcr[]);
-	int	(*limited_pmc_event)(unsigned int event);
+	int	(*limited_pmc_event)(u64 event);
 	int	limited_pmc5_6;	/* PMC5 and PMC6 have limited function */
 	int	n_generic;
 	int	*generic_events;
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 15cdc8e..91de115 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -26,7 +26,7 @@ struct cpu_hw_counters {
 	int n_limited;
 	u8  pmcs_enabled;
 	struct perf_counter *counter[MAX_HWCOUNTERS];
-	unsigned int events[MAX_HWCOUNTERS];
+	u64 events[MAX_HWCOUNTERS];
 	unsigned int flags[MAX_HWCOUNTERS];
 	u64 mmcr[3];
 	struct perf_counter *limited_counter[MAX_LIMITED_HWCOUNTERS];
@@ -131,11 +131,11 @@ static void write_pmc(int idx, unsigned long val)
  * and see if any combination of alternative codes is feasible.
  * The feasible set is returned in event[].
  */
-static int power_check_constraints(unsigned int event[], unsigned int cflags[],
+static int power_check_constraints(u64 event[], unsigned int cflags[],
 				   int n_ev)
 {
 	u64 mask, value, nv;
-	unsigned int alternatives[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	u64 alternatives[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
 	u64 amasks[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
 	u64 avalues[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
 	u64 smasks[MAX_HWCOUNTERS], svalues[MAX_HWCOUNTERS];
@@ -562,7 +562,7 @@ void hw_perf_restore(u64 disable)
 }
 
 static int collect_events(struct perf_counter *group, int max_count,
-			  struct perf_counter *ctrs[], unsigned int *events,
+			  struct perf_counter *ctrs[], u64 *events,
 			  unsigned int *flags)
 {
 	int n = 0;
@@ -752,11 +752,11 @@ struct pmu power_pmu = {
  * that a limited PMC can count, doesn't require interrupts, and
  * doesn't exclude any processor mode.
  */
-static int can_go_on_limited_pmc(struct perf_counter *counter, unsigned int ev,
+static int can_go_on_limited_pmc(struct perf_counter *counter, u64 ev,
 				 unsigned int flags)
 {
 	int n;
-	unsigned int alt[MAX_EVENT_ALTERNATIVES];
+	u64 alt[MAX_EVENT_ALTERNATIVES];
 
 	if (counter->hw_event.exclude_user
 	    || counter->hw_event.exclude_kernel
@@ -776,10 +776,8 @@ static int can_go_on_limited_pmc(struct perf_counter *counter, unsigned int ev,
 
 	flags |= PPMU_LIMITED_PMC_OK | PPMU_LIMITED_PMC_REQD;
 	n = ppmu->get_alternatives(ev, flags, alt);
-	if (n)
-		return alt[0];
 
-	return 0;
+	return n > 0;
 }
 
 /*
@@ -787,10 +785,9 @@ static int can_go_on_limited_pmc(struct perf_counter *counter, unsigned int ev,
  * and return the event code, or 0 if there is no such alternative.
  * (Note: event code 0 is "don't count" on all machines.)
  */
-static unsigned long normal_pmc_alternative(unsigned long ev,
-					    unsigned long flags)
+static u64 normal_pmc_alternative(u64 ev, unsigned long flags)
 {
-	unsigned int alt[MAX_EVENT_ALTERNATIVES];
+	u64 alt[MAX_EVENT_ALTERNATIVES];
 	int n;
 
 	flags &= ~(PPMU_LIMITED_PMC_OK | PPMU_LIMITED_PMC_REQD);
@@ -820,9 +817,10 @@ static void hw_perf_counter_destroy(struct perf_counter *counter)
 
 const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 {
-	unsigned long ev, flags;
+	u64 ev;
+	unsigned long flags;
 	struct perf_counter *ctrs[MAX_HWCOUNTERS];
-	unsigned int events[MAX_HWCOUNTERS];
+	u64 events[MAX_HWCOUNTERS];
 	unsigned int cflags[MAX_HWCOUNTERS];
 	int n;
 	int err;
diff --git a/arch/powerpc/kernel/power4-pmu.c b/arch/powerpc/kernel/power4-pmu.c
index 744a275..836fa11 100644
--- a/arch/powerpc/kernel/power4-pmu.c
+++ b/arch/powerpc/kernel/power4-pmu.c
@@ -213,7 +213,7 @@ static unsigned char direct_marked_event[8] = {
  * Returns 1 if event counts things relating to marked instructions
  * and thus needs the MMCRA_SAMPLE_ENABLE bit set, or 0 if not.
  */
-static int p4_marked_instr_event(unsigned int event)
+static int p4_marked_instr_event(u64 event)
 {
 	int pmc, psel, unit, byte, bit;
 	unsigned int mask;
@@ -249,7 +249,7 @@ static int p4_marked_instr_event(unsigned int event)
 	return (mask >> (byte * 8 + bit)) & 1;
 }
 
-static int p4_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
+static int p4_get_constraint(u64 event, u64 *maskp, u64 *valp)
 {
 	int pmc, byte, unit, lower, sh;
 	u64 mask = 0, value = 0;
@@ -320,8 +320,7 @@ static unsigned int ppc_inst_cmpl[] = {
 	0x1001, 0x4001, 0x6001, 0x7001, 0x8001
 };
 
-static int p4_get_alternatives(unsigned int event, unsigned int flags,
-			       unsigned int alt[])
+static int p4_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 {
 	int i, j, na;
 
@@ -353,7 +352,7 @@ static int p4_get_alternatives(unsigned int event, unsigned int flags,
 	return na;
 }
 
-static int p4_compute_mmcr(unsigned int event[], int n_ev,
+static int p4_compute_mmcr(u64 event[], int n_ev,
 			   unsigned int hwc[], u64 mmcr[])
 {
 	u64 mmcr0 = 0, mmcr1 = 0, mmcra = 0;
diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
index 8154eaa..3ac0654 100644
--- a/arch/powerpc/kernel/power5+-pmu.c
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -135,7 +135,7 @@ static u64 unit_cons[PM_LASTUNIT+1][2] = {
 	[PM_GRS] =   { 0x0e00000000ull, 0x0c40000000ull },
 };
 
-static int power5p_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
+static int power5p_get_constraint(u64 event, u64 *maskp, u64 *valp)
 {
 	int pmc, byte, unit, sh;
 	int bit, fmask;
@@ -188,7 +188,7 @@ static int power5p_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
 	return 0;
 }
 
-static int power5p_limited_pmc_event(unsigned int event)
+static int power5p_limited_pmc_event(u64 event)
 {
 	int pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
 
@@ -273,11 +273,11 @@ static int find_alternative_bdecode(unsigned int event)
 	return -1;
 }
 
-static int power5p_get_alternatives(unsigned int event, unsigned int flags,
-				    unsigned int alt[])
+static int power5p_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 {
-	int i, j, ae, nalt = 1;
+	int i, j, nalt = 1;
 	int nlim;
+	u64 ae;
 
 	alt[0] = event;
 	nalt = 1;
@@ -402,7 +402,7 @@ static unsigned char direct_event_is_marked[0x28] = {
  * Returns 1 if event counts things relating to marked instructions
  * and thus needs the MMCRA_SAMPLE_ENABLE bit set, or 0 if not.
  */
-static int power5p_marked_instr_event(unsigned int event)
+static int power5p_marked_instr_event(u64 event)
 {
 	int pmc, psel;
 	int bit, byte, unit;
@@ -451,7 +451,7 @@ static int power5p_marked_instr_event(unsigned int event)
 	return (mask >> (byte * 8 + bit)) & 1;
 }
 
-static int power5p_compute_mmcr(unsigned int event[], int n_ev,
+static int power5p_compute_mmcr(u64 event[], int n_ev,
 				unsigned int hwc[], u64 mmcr[])
 {
 	u64 mmcr1 = 0;
diff --git a/arch/powerpc/kernel/power5-pmu.c b/arch/powerpc/kernel/power5-pmu.c
index 6e667dc..d534496 100644
--- a/arch/powerpc/kernel/power5-pmu.c
+++ b/arch/powerpc/kernel/power5-pmu.c
@@ -139,7 +139,7 @@ static u64 unit_cons[PM_LASTUNIT+1][2] = {
 	[PM_GRS] =   { 0x30002000000000ull, 0x30000400000000ull },
 };
 
-static int power5_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
+static int power5_get_constraint(u64 event, u64 *maskp, u64 *valp)
 {
 	int pmc, byte, unit, sh;
 	int bit, fmask;
@@ -224,7 +224,7 @@ static const unsigned int event_alternatives[][MAX_ALT] = {
  * Scan the alternatives table for a match and return the
  * index into the alternatives table if found, else -1.
  */
-static int find_alternative(unsigned int event)
+static int find_alternative(u64 event)
 {
 	int i, j;
 
@@ -250,7 +250,7 @@ static const unsigned char bytedecode_alternatives[4][4] = {
  * PMCSEL values on other counters.  This returns the alternative
  * event code for those that do, or -1 otherwise.
  */
-static int find_alternative_bdecode(unsigned int event)
+static u64 find_alternative_bdecode(u64 event)
 {
 	int pmc, altpmc, pp, j;
 
@@ -269,10 +269,10 @@ static int find_alternative_bdecode(unsigned int event)
 	return -1;
 }
 
-static int power5_get_alternatives(unsigned int event, unsigned int flags,
-				   unsigned int alt[])
+static int power5_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 {
-	int i, j, ae, nalt = 1;
+	int i, j, nalt = 1;
+	u64 ae;
 
 	alt[0] = event;
 	nalt = 1;
@@ -338,7 +338,7 @@ static unsigned char direct_event_is_marked[0x28] = {
  * Returns 1 if event counts things relating to marked instructions
  * and thus needs the MMCRA_SAMPLE_ENABLE bit set, or 0 if not.
  */
-static int power5_marked_instr_event(unsigned int event)
+static int power5_marked_instr_event(u64 event)
 {
 	int pmc, psel;
 	int bit, byte, unit;
@@ -382,7 +382,7 @@ static int power5_marked_instr_event(unsigned int event)
 	return (mask >> (byte * 8 + bit)) & 1;
 }
 
-static int power5_compute_mmcr(unsigned int event[], int n_ev,
+static int power5_compute_mmcr(u64 event[], int n_ev,
 			       unsigned int hwc[], u64 mmcr[])
 {
 	u64 mmcr1 = 0;
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
index d44049f..ab7c615 100644
--- a/arch/powerpc/kernel/power6-pmu.c
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -134,7 +134,7 @@ static u32 marked_bus_events[16] = {
  * Returns 1 if event counts things relating to marked instructions
  * and thus needs the MMCRA_SAMPLE_ENABLE bit set, or 0 if not.
  */
-static int power6_marked_instr_event(unsigned int event)
+static int power6_marked_instr_event(u64 event)
 {
 	int pmc, psel, ptype;
 	int bit, byte, unit;
@@ -172,7 +172,7 @@ static int power6_marked_instr_event(unsigned int event)
 /*
  * Assign PMC numbers and compute MMCR1 value for a set of events
  */
-static int p6_compute_mmcr(unsigned int event[], int n_ev,
+static int p6_compute_mmcr(u64 event[], int n_ev,
 			   unsigned int hwc[], u64 mmcr[])
 {
 	u64 mmcr1 = 0;
@@ -265,7 +265,7 @@ static int p6_compute_mmcr(unsigned int event[], int n_ev,
  *	20-23, 24-27, 28-31 ditto for bytes 1, 2, 3
  *	32-34	select field: nest (subunit) event selector
  */
-static int p6_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
+static int p6_get_constraint(u64 event, u64 *maskp, u64 *valp)
 {
 	int pmc, byte, sh, subunit;
 	u64 mask = 0, value = 0;
@@ -298,7 +298,7 @@ static int p6_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
 	return 0;
 }
 
-static int p6_limited_pmc_event(unsigned int event)
+static int p6_limited_pmc_event(u64 event)
 {
 	int pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
 
@@ -337,7 +337,7 @@ static const unsigned int event_alternatives[][MAX_ALT] = {
  * This could be made more efficient with a binary search on
  * a presorted list, if necessary
  */
-static int find_alternatives_list(unsigned int event)
+static int find_alternatives_list(u64 event)
 {
 	int i, j;
 	unsigned int alt;
@@ -356,12 +356,12 @@ static int find_alternatives_list(unsigned int event)
 	return -1;
 }
 
-static int p6_get_alternatives(unsigned int event, unsigned int flags,
-			       unsigned int alt[])
+static int p6_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 {
 	int i, j, nlim;
-	unsigned int aevent, psel, pmc;
+	unsigned int psel, pmc;
 	unsigned int nalt = 1;
+	u64 aevent;
 
 	alt[0] = event;
 	nlim = p6_limited_pmc_event(event);
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index af2d188..eed47c4 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -147,7 +147,7 @@ static unsigned char direct_marked_event[8] = {
  * Returns 1 if event counts things relating to marked instructions
  * and thus needs the MMCRA_SAMPLE_ENABLE bit set, or 0 if not.
  */
-static int p970_marked_instr_event(unsigned int event)
+static int p970_marked_instr_event(u64 event)
 {
 	int pmc, psel, unit, byte, bit;
 	unsigned int mask;
@@ -192,7 +192,7 @@ static u64 unit_cons[PM_LASTUNIT+1][2] = {
 	[PM_STS] =   { 0x380000000000ull, 0x310000000000ull },
 };
 
-static int p970_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
+static int p970_get_constraint(u64 event, u64 *maskp, u64 *valp)
 {
 	int pmc, byte, unit, sh, spcsel;
 	u64 mask = 0, value = 0;
@@ -243,8 +243,7 @@ static int p970_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
 	return 0;
 }
 
-static int p970_get_alternatives(unsigned int event, unsigned int flags,
-				 unsigned int alt[])
+static int p970_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 {
 	alt[0] = event;
 
@@ -257,7 +256,7 @@ static int p970_get_alternatives(unsigned int event, unsigned int flags,
 	return 1;
 }
 
-static int p970_compute_mmcr(unsigned int event[], int n_ev,
+static int p970_compute_mmcr(u64 event[], int n_ev,
 			     unsigned int hwc[], u64 mmcr[])
 {
 	u64 mmcr0 = 0, mmcr1 = 0, mmcra = 0;
-- 
1.5.5.rc3.7.gba13

