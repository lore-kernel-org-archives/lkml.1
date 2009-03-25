Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbZCYXOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbZCYXOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZCYXOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:14:37 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:39987 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZCYXOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:14:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18890.47828.65363.467702@cargo.ozlabs.ibm.com>
Date: Thu, 26 Mar 2009 10:14:28 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: powerpc: only reserve PMU hardware when we need it
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
Ingo, please pull this from the master branch of my perfcounters.git
repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

IMO it's important to have this one in before perf_counters goes into
Linus' tree.

 arch/powerpc/kernel/perf_counter.c |   49 +++++++++++++++++++++++++++++++----
 1 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index df007fe..1efd252 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -41,6 +41,8 @@ struct power_pmu *ppmu;
  */
 static unsigned int freeze_counters_kernel = MMCR0_FCS;
 
+static void perf_counter_interrupt(struct pt_regs *regs);
+
 void perf_counter_print_debug(void)
 {
 }
@@ -594,6 +596,24 @@ struct hw_perf_counter_ops power_perf_ops = {
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
@@ -601,6 +621,7 @@ hw_perf_counter_init(struct perf_counter *counter)
 	struct perf_counter *ctrs[MAX_HWCOUNTERS];
 	unsigned int events[MAX_HWCOUNTERS];
 	int n;
+	int err;
 
 	if (!ppmu)
 		return NULL;
@@ -646,6 +667,27 @@ hw_perf_counter_init(struct perf_counter *counter)
 
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
 
@@ -720,7 +762,7 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 	struct cpu_hw_counters *cpuhw = &__get_cpu_var(cpu_hw_counters);
 	struct perf_counter *counter;
 	long val;
-	int need_wakeup = 0, found = 0;
+	int found = 0;
 
 	for (i = 0; i < cpuhw->n_counters; ++i) {
 		counter = cpuhw->counter[i];
@@ -787,11 +829,6 @@ static int init_perf_counters(void)
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
1.5.6.3

