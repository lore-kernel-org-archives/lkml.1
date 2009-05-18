Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbZERHmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbZERHmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZERHlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:41:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:49004 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276AbZERHld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:41:33 -0400
Date: Mon, 18 May 2009 07:40:48 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, vatsa@in.ibm.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, vatsa@in.ibm.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter, x86: speed up the scheduling fast-path
Message-ID: <tip-b68f1d2e7aa21029d73c7d453a8046e95d351740@git.kernel.org>
Git-Commit-ID: b68f1d2e7aa21029d73c7d453a8046e95d351740
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 18 May 2009 07:40:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b68f1d2e7aa21029d73c7d453a8046e95d351740
Gitweb:     http://git.kernel.org/tip/b68f1d2e7aa21029d73c7d453a8046e95d351740
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 17 May 2009 19:37:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 May 2009 09:37:09 +0200

perf_counter, x86: speed up the scheduling fast-path

We have to set up the LVT entry only at counter init time, not at
every switch-in time.

There's friction between NMI and non-NMI use here - we'll probably
remove the per counter configurability of it - but until then, dont
slow down things ...

[ Impact: micro-optimization ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 5bfd30a..c109819 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -285,6 +285,7 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 			return -EACCES;
 		hwc->nmi = 1;
 	}
+	perf_counters_lapic_init(hwc->nmi);
 
 	if (!hwc->irq_period)
 		hwc->irq_period = x86_pmu.max_period;
@@ -603,8 +604,6 @@ try_generic:
 		hwc->counter_base = x86_pmu.perfctr;
 	}
 
-	perf_counters_lapic_init(hwc->nmi);
-
 	x86_pmu.disable(hwc, idx);
 
 	cpuc->counters[idx] = counter;
@@ -1054,7 +1053,7 @@ void __init init_hw_perf_counters(void)
 
 	pr_info("... counter mask:    %016Lx\n", perf_counter_mask);
 
-	perf_counters_lapic_init(0);
+	perf_counters_lapic_init(1);
 	register_die_notifier(&perf_counter_nmi_notifier);
 }
 
