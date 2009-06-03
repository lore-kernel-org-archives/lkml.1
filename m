Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbZFCJkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbZFCJkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZFCJkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:40:41 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:40308 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZFCJkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:40:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18982.17684.138182.954599@cargo.ozlabs.ibm.com>
Date: Wed, 3 Jun 2009 19:40:36 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] perf_counter: powerpc: Fix race causing "oops trying to read PMC0" errors
In-Reply-To: <18982.17586.666132.90983@cargo.ozlabs.ibm.com>
References: <18982.17586.666132.90983@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using interrupting counters and limited (non-interrupting) counters
at the same time, it's possible that we get an interrupt in write_mmcr0()
after writing MMCR0 but before we have set up the counters using limited
PMCs.  What happens then is that we get into perf_counter_interrupt()
with counter->hw.idx = 0 for the limited counters, leading to the "oops
trying to read PMC0" error message being printed.

This fixes the problem by making perf_counter_interrupt() robust against
counter->hw.idx being zero (the counter is just ignored in that case)
and also by changing write_mmcr0() to write MMCR0 initially with the
counter overflow interrupt enable bits masked (set to 0).  If the MMCR0
value requested by the caller has either of those bits set, we write
MMCR0 again with the requested value of those bits after setting up the
limited counters properly.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/perf_counter.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index ea54686..4cc4ac5 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -372,16 +372,28 @@ static void write_mmcr0(struct cpu_hw_counters *cpuhw, unsigned long mmcr0)
 
 	/*
 	 * Write MMCR0, then read PMC5 and PMC6 immediately.
+	 * To ensure we don't get a performance monitor interrupt
+	 * between writing MMCR0 and freezing/thawing the limited
+	 * counters, we first write MMCR0 with the counter overflow
+	 * interrupt enable bits turned off.
 	 */
 	asm volatile("mtspr %3,%2; mfspr %0,%4; mfspr %1,%5"
 		     : "=&r" (pmc5), "=&r" (pmc6)
-		     : "r" (mmcr0), "i" (SPRN_MMCR0),
+		     : "r" (mmcr0 & ~(MMCR0_PMC1CE | MMCR0_PMCjCE)),
+		       "i" (SPRN_MMCR0),
 		       "i" (SPRN_PMC5), "i" (SPRN_PMC6));
 
 	if (mmcr0 & MMCR0_FC)
 		freeze_limited_counters(cpuhw, pmc5, pmc6);
 	else
 		thaw_limited_counters(cpuhw, pmc5, pmc6);
+
+	/*
+	 * Write the full MMCR0 including the counter overflow interrupt
+	 * enable bits, if necessary.
+	 */
+	if (mmcr0 & (MMCR0_PMC1CE | MMCR0_PMCjCE))
+		mtspr(SPRN_MMCR0, mmcr0);
 }
 
 /*
@@ -1108,7 +1120,7 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 
 	for (i = 0; i < cpuhw->n_counters; ++i) {
 		counter = cpuhw->counter[i];
-		if (is_limited_pmc(counter->hw.idx))
+		if (!counter->hw.idx || is_limited_pmc(counter->hw.idx))
 			continue;
 		val = read_pmc(counter->hw.idx);
 		if ((int)val < 0) {
-- 
1.6.0.4

