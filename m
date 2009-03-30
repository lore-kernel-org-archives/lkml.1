Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbZC3RQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbZC3RQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZC3RLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:11:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52296 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZC3RLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:11:24 -0400
Message-Id: <20090330171023.627912475@chello.nl>
References: <20090330170701.856843742@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 19:07:07 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/15] perf_counter: powerpc: only reserve PMU hardware when we need it
Content-Disposition: inline; filename=paulus-perf_counter-powerpc-only_reserve_PMU_hardware_when_we_need_it.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>

Impact: cooperate with oprofile

At present, on PowerPC, if you have perf_counters compiled in, oprofile
doesn't work.  There is code to allow the PMU to be shared between
competing subsystems, such as perf_counters and oprofile, but currently
the perf_counter subsystem reserves the PMU for itself at boot time,
and never releases it.

This makes perf_counter play nicely with oprofile.  Now we keep a count
of how many perf_counter instances are counting hardware events, and
reserve the PMU when that count becomes non-zero, and release the PMU
when that count becomes zero.  This means that it is possible to have
perf_counters compiled in and still use oprofile, as long as there are
no hardware perf_counters active.  This also means that if oprofile is
active, sys_perf_counter_open will fail if the hw_event specifies a
hardware event.

To avoid races with other tasks creating and destroying perf_counters,
we use a mutex.  We use atomic_inc_not_zero and atomic_add_unless to
avoid having to take the mutex unless there is a possibility of the
count going between 0 and 1.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

 arch/powerpc/kernel/perf_counter.c |   47 +++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_counter.c
+++ linux-2.6/arch/powerpc/kernel/perf_counter.c
@@ -41,6 +41,8 @@ struct power_pmu *ppmu;
  */
 static unsigned int freeze_counters_kernel = MMCR0_FCS;
 
+static void perf_counter_interrupt(struct pt_regs *regs);
+
 void perf_counter_print_debug(void)
 {
 }
@@ -594,6 +596,24 @@ struct hw_perf_counter_ops power_perf_op
 	.read = power_perf_read
 };
 
+/* Number of perf_counters counting hardware events */
+static atomic_t num_counters;
+/* Used to avoid races in calling reserve/release_pmc_hardware */
+static DEFINE_MUTEX(pmc_reserve_mutex);
+
+/*
+ * Release the PMU if this is the last perf_counter.
+ */
+static void hw_perf_counter_destroy(struct perf_counter *counter)
+{
+	if (!atomic_add_unless(&num_counters, -1, 1)) {
+		mutex_lock(&pmc_reserve_mutex);
+		if (atomic_dec_return(&num_counters) == 0)
+			release_pmc_hardware();
+		mutex_unlock(&pmc_reserve_mutex);
+	}
+}
+
 const struct hw_perf_counter_ops *
 hw_perf_counter_init(struct perf_counter *counter)
 {
@@ -601,6 +621,7 @@ hw_perf_counter_init(struct perf_counter
 	struct perf_counter *ctrs[MAX_HWCOUNTERS];
 	unsigned int events[MAX_HWCOUNTERS];
 	int n;
+	int err;
 
 	if (!ppmu)
 		return NULL;
@@ -646,6 +667,27 @@ hw_perf_counter_init(struct perf_counter
 
 	counter->hw.config = events[n];
 	atomic64_set(&counter->hw.period_left, counter->hw_event.irq_period);
+
+	/*
+	 * See if we need to reserve the PMU.
+	 * If no counters are currently in use, then we have to take a
+	 * mutex to ensure that we don't race with another task doing
+	 * reserve_pmc_hardware or release_pmc_hardware.
+	 */
+	err = 0;
+	if (!atomic_inc_not_zero(&num_counters)) {
+		mutex_lock(&pmc_reserve_mutex);
+		if (atomic_read(&num_counters) == 0 &&
+		    reserve_pmc_hardware(perf_counter_interrupt))
+			err = -EBUSY;
+		else
+			atomic_inc(&num_counters);
+		mutex_unlock(&pmc_reserve_mutex);
+	}
+	counter->destroy = hw_perf_counter_destroy;
+
+	if (err)
+		return NULL;
 	return &power_perf_ops;
 }
 
@@ -756,11 +798,6 @@ static int init_perf_counters(void)
 {
 	unsigned long pvr;
 
-	if (reserve_pmc_hardware(perf_counter_interrupt)) {
-		printk(KERN_ERR "Couldn't init performance monitor subsystem\n");
-		return -EBUSY;
-	}
-
 	/* XXX should get this from cputable */
 	pvr = mfspr(SPRN_PVR);
 	switch (PVR_VER(pvr)) {

-- 

