Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbZEZG2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbZEZG2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 02:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZEZG2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 02:28:09 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:47166 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbZEZG2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 02:28:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18971.35823.643362.446774@cargo.ozlabs.ibm.com>
Date: Tue, 26 May 2009 16:27:59 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] perf_counter: powerpc: Implement interrupt throttling
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements interrupt throttling on powerpc.  Since we don't have
individual count enable/disable or interrupt enable/disable controls
per counter, this simply sets the hardware counter to 0, meaning that
it will not interrupt again until it has counted 2^31 counts, which
will take at least 2^30 cycles assuming a maximum of 2 counts per
cycle.  Also, we set counter->hw.period_left to the maximum possible
value (2^63 - 1), so we won't report overflows for this counter for
the forseeable future.

The unthrottle operation restores counter->hw.period_left and the
hardware counter so that we will once again report a counter overflow
after counter->hw.irq_period counts.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/perf_counter.c |   48 +++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index fe21b24..f96d55f 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -740,10 +740,37 @@ static void power_pmu_disable(struct perf_counter *counter)
 	local_irq_restore(flags);
 }
 
+/*
+ * Re-enable interrupts on a counter after they were throttled
+ * because they were coming too fast.
+ */
+static void power_pmu_unthrottle(struct perf_counter *counter)
+{
+	s64 val, left;
+	unsigned long flags;
+
+	if (!counter->hw.idx || !counter->hw.irq_period)
+		return;
+	local_irq_save(flags);
+	perf_disable();
+	power_pmu_read(counter);
+	left = counter->hw.irq_period;
+	val = 0;
+	if (left < 0x80000000L)
+		val = 0x80000000L - left;
+	write_pmc(counter->hw.idx, val);
+	atomic64_set(&counter->hw.prev_count, val);
+	atomic64_set(&counter->hw.period_left, left);
+	perf_counter_update_userpage(counter);
+	perf_enable();
+	local_irq_restore(flags);
+}
+
 struct pmu power_pmu = {
 	.enable		= power_pmu_enable,
 	.disable	= power_pmu_disable,
 	.read		= power_pmu_read,
+	.unthrottle	= power_pmu_unthrottle,
 };
 
 /*
@@ -957,10 +984,6 @@ static void record_and_restart(struct perf_counter *counter, long val,
 		if (left < 0x80000000L)
 			val = 0x80000000L - left;
 	}
-	write_pmc(counter->hw.idx, val);
-	atomic64_set(&counter->hw.prev_count, val);
-	atomic64_set(&counter->hw.period_left, left);
-	perf_counter_update_userpage(counter);
 
 	/*
 	 * Finally record data if requested.
@@ -983,8 +1006,23 @@ static void record_and_restart(struct perf_counter *counter, long val,
 			if (!(mmcra & MMCRA_SAMPLE_ENABLE) || (mmcra & sdsync))
 				addr = mfspr(SPRN_SDAR);
 		}
-		perf_counter_overflow(counter, nmi, regs, addr);
+		if (perf_counter_overflow(counter, nmi, regs, addr)) {
+			/*
+			 * Interrupts are coming too fast - throttle them
+			 * by setting the counter to 0, so it will be
+			 * at least 2^30 cycles until the next interrupt
+			 * (assuming each counter counts at most 2 counts
+			 * per cycle).
+			 */
+			val = 0;
+			left = ~0ULL >> 1;
+		}
 	}
+
+	write_pmc(counter->hw.idx, val);
+	atomic64_set(&counter->hw.prev_count, val);
+	atomic64_set(&counter->hw.period_left, left);
+	perf_counter_update_userpage(counter);
 }
 
 /*
