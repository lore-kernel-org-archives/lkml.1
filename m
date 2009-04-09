Return-Path: <linux-kernel-owner+w=401wt.eu-S1760729AbZDIEnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729AbZDIEnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZDIEnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:43:08 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:37854 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZDIEnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:43:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18909.31952.873098.336615@cargo.ozlabs.ibm.com>
Date: Thu, 9 Apr 2009 14:42:56 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: powerpc: add nmi_enter/nmi_exit calls
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: powerpc bug fix

Now that the core is using in_nmi() (added in e30e08f6, "perf_counter:
fix NMI race in task clock"), we need the powerpc perf_counter_interrupt
to call nmi_enter() and nmi_exit() in those cases where the interrupt
happens when interrupts are soft-disabled.  If interrupts were
soft-enabled, we can treat it as a regular interrupt and do
irq_enter/irq_exit around the whole routine.  This lets us get rid
of the test_perf_counter_pending() call at the end of
perf_counter_interrupt, thus simplifying things a little.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/perf_counter.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index c9d019f..bd76d0f 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -714,7 +714,7 @@ hw_perf_counter_init(struct perf_counter *counter)
  * here so there is no possibility of being interrupted.
  */
 static void record_and_restart(struct perf_counter *counter, long val,
-			       struct pt_regs *regs)
+			       struct pt_regs *regs, int nmi)
 {
 	s64 prev, delta, left;
 	int record = 0;
@@ -749,7 +749,7 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	 * Finally record data if requested.
 	 */
 	if (record)
-		perf_counter_overflow(counter, 1, regs, 0);
+		perf_counter_overflow(counter, nmi, regs, 0);
 }
 
 /*
@@ -762,6 +762,17 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 	struct perf_counter *counter;
 	long val;
 	int found = 0;
+	int nmi;
+
+	/*
+	 * If interrupts were soft-disabled when this PMU interrupt
+	 * occurred, treat it as an NMI.
+	 */
+	nmi = !regs->softe;
+	if (nmi)
+		nmi_enter();
+	else
+		irq_enter();
 
 	for (i = 0; i < cpuhw->n_counters; ++i) {
 		counter = cpuhw->counter[i];
@@ -769,7 +780,7 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 		if ((int)val < 0) {
 			/* counter has overflowed */
 			found = 1;
-			record_and_restart(counter, val, regs);
+			record_and_restart(counter, val, regs, nmi);
 		}
 	}
 
@@ -796,18 +807,10 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 	 */
 	mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
 
-	/*
-	 * If we need a wakeup, check whether interrupts were soft-enabled
-	 * when we took the interrupt.  If they were, we can wake stuff up
-	 * immediately; otherwise we'll have do the wakeup when interrupts
-	 * get soft-enabled.
-	 */
-	if (test_perf_counter_pending() && regs->softe) {
-		irq_enter();
-		clear_perf_counter_pending();
-		perf_counter_do_pending();
+	if (nmi)
+		nmi_exit();
+	else
 		irq_exit();
-	}
 }
 
 void hw_perf_counter_setup(int cpu)
-- 
1.5.6.3

