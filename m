Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbZEMGW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbZEMGW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 02:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbZEMGWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 02:22:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:52831 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZEMGWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 02:22:19 -0400
Date: Wed, 13 May 2009 06:21:47 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: fix print debug irq disable
Message-ID: <tip-5bb9efe33ea4001a17ab98186a40a134a3061d67@git.kernel.org>
Git-Commit-ID: 5bb9efe33ea4001a17ab98186a40a134a3061d67
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 13 May 2009 06:21:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5bb9efe33ea4001a17ab98186a40a134a3061d67
Gitweb:     http://git.kernel.org/tip/5bb9efe33ea4001a17ab98186a40a134a3061d67
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 13 May 2009 08:12:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 May 2009 08:17:37 +0200

perf_counter: fix print debug irq disable

inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
bash/15802 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (sysrq_key_table_lock){?.....},

Don't unconditionally enable interrupts in the perf_counter_print_debug()
path.

[ Impact: fix potential deadlock pointed out by lockdep ]

LKML-Reference: <new-submission>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


---
 arch/x86/kernel/cpu/perf_counter.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index da27419..f7772ff 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -621,12 +621,13 @@ void perf_counter_print_debug(void)
 {
 	u64 ctrl, status, overflow, pmc_ctrl, pmc_count, prev_left, fixed;
 	struct cpu_hw_counters *cpuc;
+	unsigned long flags;
 	int cpu, idx;
 
 	if (!x86_pmu.num_counters)
 		return;
 
-	local_irq_disable();
+	local_irq_save(flags);
 
 	cpu = smp_processor_id();
 	cpuc = &per_cpu(cpu_hw_counters, cpu);
@@ -664,7 +665,7 @@ void perf_counter_print_debug(void)
 		pr_info("CPU#%d: fixed-PMC%d count: %016llx\n",
 			cpu, idx, pmc_count);
 	}
-	local_irq_enable();
+	local_irq_restore(flags);
 }
 
 static void x86_pmu_disable(struct perf_counter *counter)
