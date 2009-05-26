Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZEZH6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZEZH6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 03:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZEZH6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 03:58:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:59090 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbZEZH6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 03:58:09 -0400
Date: Tue, 26 May 2009 07:57:32 GMT
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
Subject: [tip:perfcounters/core] perf_counter, x86: Fix APIC NMI programming
Message-ID: <tip-79202ba9ff8cf570a75596f42e011167734d1c4b@git.kernel.org>
Git-Commit-ID: 79202ba9ff8cf570a75596f42e011167734d1c4b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 07:57:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79202ba9ff8cf570a75596f42e011167734d1c4b
Gitweb:     http://git.kernel.org/tip/79202ba9ff8cf570a75596f42e011167734d1c4b
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 08:10:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 09:49:28 +0200

perf_counter, x86: Fix APIC NMI programming

My Nehalem box locks up in certain situations (with an
always-asserted NMI causing a lockup) if the PMU LVT
entry is programmed between NMI and IRQ mode with a
high frequency.

Standardize exlusively on NMIs instead.

[ Impact: fix lockup ]

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
 arch/x86/kernel/cpu/perf_counter.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 189bf9d..ece3813 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -285,14 +285,10 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
 
 	/*
-	 * If privileged enough, allow NMI events:
+	 * Use NMI events all the time:
 	 */
-	hwc->nmi = 0;
-	if (hw_event->nmi) {
-		if (sysctl_perf_counter_priv && !capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		hwc->nmi = 1;
-	}
+	hwc->nmi	= 1;
+	hw_event->nmi	= 1;
 
 	if (!hwc->irq_period)
 		hwc->irq_period = x86_pmu.max_period;
@@ -553,9 +549,6 @@ fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 	if (!x86_pmu.num_counters_fixed)
 		return -1;
 
-	if (unlikely(hwc->nmi))
-		return -1;
-
 	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
 
 	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_INSTRUCTIONS)))
@@ -806,9 +799,6 @@ static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
 		counter = cpuc->counters[idx];
 		hwc = &counter->hw;
 
-		if (counter->hw_event.nmi != nmi)
-			continue;
-
 		val = x86_perf_counter_update(counter, hwc, idx);
 		if (val & (1ULL << (x86_pmu.counter_bits - 1)))
 			continue;
