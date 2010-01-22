Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753Ab0AVOzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab0AVOzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178Ab0AVOz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:55:28 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:3693 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab0AVOzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:55:22 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zzab9bh936eMzz1202hzzz32i6bh87h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWNLFH-02-1L7-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@googlemail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 03/12] perf/core, x86: remove duplicate perf_event_mask variable
Date: Fri, 22 Jan 2010 15:21:58 +0100
Message-ID: <1264170127-17402-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
References: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 14:54:55.0314 (UTC) FILETIME=[DC017320:01CA9B72]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same information is stored also in x86_pmu.intel_ctrl. This patch
removes perf_event_mask and instead uses x86_pmu.intel_ctrl directly.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c3f920a..4291f86 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -27,8 +27,6 @@
 #include <asm/stacktrace.h>
 #include <asm/nmi.h>
 
-static u64 perf_event_mask __read_mostly;
-
 /* The maximal number of PEBS events: */
 #define MAX_PEBS_EVENTS	4
 
@@ -2197,7 +2195,7 @@ void __init init_hw_perf_events(void)
 		     x86_pmu.num_counters, X86_PMC_MAX_GENERIC);
 		x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
 	}
-	perf_event_mask = (1 << x86_pmu.num_counters) - 1;
+	x86_pmu.intel_ctrl = (1 << x86_pmu.num_counters) - 1;
 	perf_max_events = x86_pmu.num_counters;
 
 	if (x86_pmu.num_counters_fixed > X86_PMC_MAX_FIXED) {
@@ -2206,9 +2204,8 @@ void __init init_hw_perf_events(void)
 		x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
 	}
 
-	perf_event_mask |=
+	x86_pmu.intel_ctrl |=
 		((1LL << x86_pmu.num_counters_fixed)-1) << X86_PMC_IDX_FIXED;
-	x86_pmu.intel_ctrl = perf_event_mask;
 
 	perf_events_lapic_init();
 	register_die_notifier(&perf_event_nmi_notifier);
@@ -2219,7 +2216,7 @@ void __init init_hw_perf_events(void)
 	pr_info("... value mask:             %016Lx\n", x86_pmu.cntval_mask);
 	pr_info("... max period:             %016Lx\n", x86_pmu.max_period);
 	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_counters_fixed);
-	pr_info("... event mask:             %016Lx\n", perf_event_mask);
+	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
 }
 
 static inline void x86_pmu_read(struct perf_event *event)
-- 
1.6.6


