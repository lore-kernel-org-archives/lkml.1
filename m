Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZHGIbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZHGIbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbZHGIbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:31:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:48936 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757153AbZHGIbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:31:35 -0400
Date: Fri, 7 Aug 2009 08:31:05 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <19067.53473.239250.278692@cargo.ozlabs.ibm.com>
References: <19067.53473.239250.278692@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/urgent] perf_counter/powerpc: Avoid oops on cpus without perf_counter hardware support
Message-ID: <tip-e136499a084c0b921dd0c7a338e4454be158d9f9@git.kernel.org>
Git-Commit-ID: e136499a084c0b921dd0c7a338e4454be158d9f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 07 Aug 2009 08:31:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e136499a084c0b921dd0c7a338e4454be158d9f9
Gitweb:     http://git.kernel.org/tip/e136499a084c0b921dd0c7a338e4454be158d9f9
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Fri, 7 Aug 2009 16:59:45 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Aug 2009 10:29:16 +0200

perf_counter/powerpc: Avoid oops on cpus without perf_counter hardware support

If we have the powerpc perf_counter backend compiled in, but
the cpu we are running on is one where we don't support the
PMU, we currently oops in hw_perf_group_sched_in if we try to
use any counters, because ppmu is NULL in that case, and we
unconditionally dereference ppmu.

This fixes the problem by adding a check if ppmu is NULL at the
beginning of hw_perf_group_sched_in, and also at the beginning
of the other functions that get called from the perf_counter
core, i.e. hw_perf_disable, hw_perf_enable, and
hw_perf_counter_setup.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: benh@kernel.crashing.org
LKML-Reference: <19067.53473.239250.278692@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
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
