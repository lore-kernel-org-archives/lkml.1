Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbZEZH67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbZEZH67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 03:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbZEZH6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 03:58:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:59116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbZEZH6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 03:58:30 -0400
Date: Tue, 26 May 2009 07:57:44 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter, x86: Make NMI lockups more robust
Message-ID: <tip-aaba98018b8295dfa2119345d17f833d74448cd0@git.kernel.org>
Git-Commit-ID: aaba98018b8295dfa2119345d17f833d74448cd0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 07:57:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aaba98018b8295dfa2119345d17f833d74448cd0
Gitweb:     http://git.kernel.org/tip/aaba98018b8295dfa2119345d17f833d74448cd0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 08:10:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 09:52:03 +0200

perf_counter, x86: Make NMI lockups more robust

We have a debug check that detects stuck NMIs and returns with
the PMU disabled in the global ctrl MSR - but i managed to trigger
a situation where this was not enough to deassert the NMI.

So clear/reset the full PMU and keep the disable count balanced when
exiting from here. This way the box produces a debug warning but
stays up and is more debuggable.

[ Impact: in case of PMU related bugs, recover more gracefully ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index ece3813..2eeaa99 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -724,6 +724,30 @@ static void intel_pmu_save_and_restart(struct perf_counter *counter)
 		intel_pmu_enable_counter(hwc, idx);
 }
 
+static void intel_pmu_reset(void)
+{
+	unsigned long flags;
+	int idx;
+
+	if (!x86_pmu.num_counters)
+		return;
+
+	local_irq_save(flags);
+
+	printk("clearing PMU state on CPU#%d\n", smp_processor_id());
+
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		checking_wrmsrl(x86_pmu.eventsel + idx, 0ull);
+		checking_wrmsrl(x86_pmu.perfctr  + idx, 0ull);
+	}
+	for (idx = 0; idx < x86_pmu.num_counters_fixed; idx++) {
+		checking_wrmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, 0ull);
+	}
+
+	local_irq_restore(flags);
+}
+
+
 /*
  * This handler is triggered by the local APIC, so the APIC IRQ handling
  * rules apply:
@@ -750,6 +774,8 @@ again:
 	if (++loops > 100) {
 		WARN_ONCE(1, "perfcounters: irq loop stuck!\n");
 		perf_counter_print_debug();
+		intel_pmu_reset();
+		perf_enable();
 		return 1;
 	}
 
