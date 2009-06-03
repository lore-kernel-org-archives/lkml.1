Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbZFCJwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbZFCJwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbZFCJwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:52:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:60268 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbZFCJwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:52:16 -0400
Date: Wed, 3 Jun 2009 09:51:41 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, eranian@googlemail.com,
       jkacur@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, eranian@googlemail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <18982.17684.138182.954599@cargo.ozlabs.ibm.com>
References: <18982.17684.138182.954599@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: powerpc: Fix race causing "oops trying to read PMC0" errors
Message-ID: <tip-dcd945e0d8a6d654e3e1de51faea9f98f1504aa5@git.kernel.org>
Git-Commit-ID: dcd945e0d8a6d654e3e1de51faea9f98f1504aa5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 09:51:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dcd945e0d8a6d654e3e1de51faea9f98f1504aa5
Gitweb:     http://git.kernel.org/tip/dcd945e0d8a6d654e3e1de51faea9f98f1504aa5
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Wed, 3 Jun 2009 19:40:36 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 11:49:53 +0200

perf_counter: powerpc: Fix race causing "oops trying to read PMC0" errors

When using interrupting counters and limited (non-interrupting)
counters at the same time, it's possible that we get an
interrupt in write_mmcr0() after writing MMCR0 but before we
have set up the counters using limited PMCs.  What happens then
is that we get into perf_counter_interrupt() with
counter->hw.idx = 0 for the limited counters, leading to the
"oops trying to read PMC0" error message being printed.

This fixes the problem by making perf_counter_interrupt()
robust against counter->hw.idx being zero (the counter is just
ignored in that case) and also by changing write_mmcr0() to
write MMCR0 initially with the counter overflow interrupt
enable bits masked (set to 0).  If the MMCR0 value requested by
the caller has either of those bits set, we write MMCR0 again
with the requested value of those bits after setting up the
limited counters properly.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
Cc: Stephane Eranian <eranian@googlemail.com>
LKML-Reference: <18982.17684.138182.954599@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
