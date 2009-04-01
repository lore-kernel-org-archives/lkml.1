Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbZDAKPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbZDAKPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbZDAKON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:14:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:39996 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655AbZDAKOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:14:09 -0400
Date: Wed, 1 Apr 2009 10:13:36 GMT
From: Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090330171023.627912475@chello.nl>
References: <20090330171023.627912475@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: powerpc: only reserve PMU hardware when we need it
Message-ID: <tip-59d98a0eb7662a468f99d37cae0b1e3c7b4ce80b@git.kernel.org>
Git-Commit-ID: 59d98a0eb7662a468f99d37cae0b1e3c7b4ce80b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 10:13:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59d98a0eb7662a468f99d37cae0b1e3c7b4ce80b
Gitweb:     http://git.kernel.org/tip/59d98a0eb7662a468f99d37cae0b1e3c7b4ce80b
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 30 Mar 2009 19:07:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 11:33:34 +0200

perf_counter: powerpc: only reserve PMU hardware when we need it

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
LKML-Reference: <20090330171023.627912475@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |   47 ++++++++++++++++++++++++++++++++----
 1 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index cde720f..560dd1e 100644
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
 
@@ -769,11 +811,6 @@ static int init_perf_counters(void)
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
