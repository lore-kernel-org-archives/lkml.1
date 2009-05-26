Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbZEZHqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbZEZHqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 03:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZEZHqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 03:46:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:38892 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZEZHqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 03:46:23 -0400
Date: Tue, 26 May 2009 07:45:38 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <18971.35823.643362.446774@cargo.ozlabs.ibm.com>
References: <18971.35823.643362.446774@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: powerpc: Implement interrupt throttling
Message-ID: <tip-8a7b8cb91f26a671f22cedc7fd54508667f2d9b9@git.kernel.org>
Git-Commit-ID: 8a7b8cb91f26a671f22cedc7fd54508667f2d9b9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 07:45:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a7b8cb91f26a671f22cedc7fd54508667f2d9b9
Gitweb:     http://git.kernel.org/tip/8a7b8cb91f26a671f22cedc7fd54508667f2d9b9
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Tue, 26 May 2009 16:27:59 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 09:43:59 +0200

perf_counter: powerpc: Implement interrupt throttling

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

[ Impact: new perfcounters robustness feature on PowerPC ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <18971.35823.643362.446774@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |   48 ++++++++++++++++++++++++++++++++---
 1 files changed, 43 insertions(+), 5 deletions(-)

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
