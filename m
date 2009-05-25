Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbZEYTyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbZEYTyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZEYTyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:54:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:42879 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbZEYTyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:54:05 -0400
Date: Mon, 25 May 2009 19:52:14 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090525153931.703093461@chello.nl>
References: <20090525153931.703093461@chello.nl>
Subject: [tip:perfcounters/core] Revert "perf_counter, x86: speed up the scheduling fast-path"
Message-ID: <tip-53b441a565bf4036ab49c8ea04c5ad06ace7dd6b@git.kernel.org>
Git-Commit-ID: 53b441a565bf4036ab49c8ea04c5ad06ace7dd6b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 19:52:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53b441a565bf4036ab49c8ea04c5ad06ace7dd6b
Gitweb:     http://git.kernel.org/tip/53b441a565bf4036ab49c8ea04c5ad06ace7dd6b
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 25 May 2009 21:41:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 21:41:28 +0200

Revert "perf_counter, x86: speed up the scheduling fast-path"

This reverts commit b68f1d2e7aa21029d73c7d453a8046e95d351740.

It is causing problems (stuck/stuttering profiling) - when mixed
NMI and non-NMI counters are used.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090525153931.703093461@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index c4b543d..189bf9d 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -293,7 +293,6 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 			return -EACCES;
 		hwc->nmi = 1;
 	}
-	perf_counters_lapic_init(hwc->nmi);
 
 	if (!hwc->irq_period)
 		hwc->irq_period = x86_pmu.max_period;
@@ -612,6 +611,8 @@ try_generic:
 		hwc->counter_base = x86_pmu.perfctr;
 	}
 
+	perf_counters_lapic_init(hwc->nmi);
+
 	x86_pmu.disable(hwc, idx);
 
 	cpuc->counters[idx] = counter;
@@ -1037,7 +1038,7 @@ void __init init_hw_perf_counters(void)
 
 	pr_info("... counter mask:    %016Lx\n", perf_counter_mask);
 
-	perf_counters_lapic_init(1);
+	perf_counters_lapic_init(0);
 	register_die_notifier(&perf_counter_nmi_notifier);
 }
 
