Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab0CJNM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:12:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:59148 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab0CJNMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:12:54 -0500
Date: Wed, 10 Mar 2010 13:12:22 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Avoid double disable on throttle vs ioctl(PERF_IOC_DISABLE)
Message-ID: <tip-71e2d2828046133ed985696a02e2e1499ca0bfb8@git.kernel.org>
Git-Commit-ID: 71e2d2828046133ed985696a02e2e1499ca0bfb8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:12:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71e2d2828046133ed985696a02e2e1499ca0bfb8
Gitweb:     http://git.kernel.org/tip/71e2d2828046133ed985696a02e2e1499ca0bfb8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 8 Mar 2010 17:51:33 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:22:31 +0100

perf, x86: Avoid double disable on throttle vs ioctl(PERF_IOC_DISABLE)

Calling ioctl(PERF_EVENT_IOC_DISABLE) on a thottled counter would result
in a double disable, cure this by using x86_pmu_{start,stop} for
throttle/unthrottle and teach x86_pmu_stop() to check ->active_mask.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |   20 ++++++--------------
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9757b96..b68c4fb 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -983,14 +983,8 @@ static int x86_pmu_start(struct perf_event *event)
 
 static void x86_pmu_unthrottle(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct hw_perf_event *hwc = &event->hw;
-
-	if (WARN_ON_ONCE(hwc->idx >= X86_PMC_IDX_MAX ||
-				cpuc->events[hwc->idx] != event))
-		return;
-
-	x86_pmu.enable(event);
+	int ret = x86_pmu_start(event);
+	WARN_ON_ONCE(ret);
 }
 
 void perf_event_print_debug(void)
@@ -1050,11 +1044,9 @@ static void x86_pmu_stop(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
-	/*
-	 * Must be done before we disable, otherwise the nmi handler
-	 * could reenable again:
-	 */
-	__clear_bit(idx, cpuc->active_mask);
+	if (!__test_and_clear_bit(idx, cpuc->active_mask))
+		return;
+
 	x86_pmu.disable(event);
 
 	/*
@@ -1123,7 +1115,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 			continue;
 
 		if (perf_event_overflow(event, 1, &data, regs))
-			x86_pmu.disable(event);
+			x86_pmu_stop(event);
 	}
 
 	if (handled)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index d87421c..84bfde6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -774,7 +774,7 @@ again:
 		data.period = event->hw.last_period;
 
 		if (perf_event_overflow(event, 1, &data, regs))
-			intel_pmu_disable_event(event);
+			x86_pmu_stop(event);
 	}
 
 	intel_pmu_ack_status(ack);
