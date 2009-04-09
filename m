Return-Path: <linux-kernel-owner+w=401wt.eu-S1761394AbZDIF6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761394AbZDIF6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759509AbZDIF6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:58:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:60758 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069AbZDIF6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:58:07 -0400
Date: Thu, 9 Apr 2009 05:57:32 GMT
From: Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <18909.31952.873098.336615@cargo.ozlabs.ibm.com>
References: <18909.31952.873098.336615@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: powerpc: add nmi_enter/nmi_exit calls
Message-ID: <tip-ca8f2d7f019a8547f39ddb9ed0144932f12807f2@git.kernel.org>
Git-Commit-ID: ca8f2d7f019a8547f39ddb9ed0144932f12807f2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 05:57:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca8f2d7f019a8547f39ddb9ed0144932f12807f2
Gitweb:     http://git.kernel.org/tip/ca8f2d7f019a8547f39ddb9ed0144932f12807f2
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Thu, 9 Apr 2009 14:42:56 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 07:56:08 +0200

perf_counter: powerpc: add nmi_enter/nmi_exit calls

Impact: fix potential deadlocks on powerpc

Now that the core is using in_nmi() (added in e30e08f6, "perf_counter:
fix NMI race in task clock"), we need the powerpc perf_counter_interrupt
to call nmi_enter() and nmi_exit() in those cases where the interrupt
happens when interrupts are soft-disabled.

If interrupts were soft-enabled, we can treat it as a regular interrupt
and do irq_enter/irq_exit around the whole routine. This lets us get rid
of the test_perf_counter_pending() call at the end of
perf_counter_interrupt, thus simplifying things a little.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <18909.31952.873098.336615@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
