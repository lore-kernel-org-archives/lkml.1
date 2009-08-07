Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbZHGHHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbZHGHHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZHGHHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:07:21 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50993 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbZHGHHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:07:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19067.53473.239250.278692@cargo.ozlabs.ibm.com>
Date: Fri, 7 Aug 2009 16:59:45 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: [PATCH] perf_counter/powerpc: Avoid oops on cpus without perf_counter hardware support
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have the powerpc perf_counter backend compiled in, but the cpu
we are running on is one where we don't support the PMU, we currently
oops in hw_perf_group_sched_in if we try to use any counters, because
ppmu is NULL in that case, and we unconditionally dereference ppmu.

This fixes the problem by adding a check if ppmu is NULL at the
beginning of hw_perf_group_sched_in, and also at the beginning of the
other functions that get called from the perf_counter core, i.e.
hw_perf_disable, hw_perf_enable, and hw_perf_counter_setup.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This also needs to go in 2.6.31.

 arch/powerpc/kernel/perf_counter.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 809fdf9..70e1f57 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -518,6 +518,8 @@ void hw_perf_disable(void)
 	struct cpu_hw_counters *cpuhw;
 	unsigned long flags;
 
+	if (!ppmu)
+		return;
 	local_irq_save(flags);
 	cpuhw = &__get_cpu_var(cpu_hw_counters);
 
@@ -572,6 +574,8 @@ void hw_perf_enable(void)
 	int n_lim;
 	int idx;
 
+	if (!ppmu)
+		return;
 	local_irq_save(flags);
 	cpuhw = &__get_cpu_var(cpu_hw_counters);
 	if (!cpuhw->disabled) {
@@ -737,6 +741,8 @@ int hw_perf_group_sched_in(struct perf_counter *group_leader,
 	long i, n, n0;
 	struct perf_counter *sub;
 
+	if (!ppmu)
+		return 0;
 	cpuhw = &__get_cpu_var(cpu_hw_counters);
 	n0 = cpuhw->n_counters;
 	n = collect_events(group_leader, ppmu->n_counter - n0,
@@ -1281,6 +1287,8 @@ void hw_perf_counter_setup(int cpu)
 {
 	struct cpu_hw_counters *cpuhw = &per_cpu(cpu_hw_counters, cpu);
 
+	if (!ppmu)
+		return;
 	memset(cpuhw, 0, sizeof(*cpuhw));
 	cpuhw->mmcr[0] = MMCR0_FC;
 }
-- 
1.6.0.4

