Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0CJNW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:22:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:57607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375Ab0CJNWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:22:54 -0500
Date: Wed, 10 Mar 2010 13:22:02 GMT
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
Subject: [tip:perf/pebs] perf, x86: Avoid double disable on throttle vs ioctl(PERF_IOC_DISABLE)
Message-ID: <tip-cc7f00820b2f3be656569c41158d9323e425bcfe@git.kernel.org>
Git-Commit-ID: cc7f00820b2f3be656569c41158d9323e425bcfe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:22:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc7f00820b2f3be656569c41158d9323e425bcfe
Gitweb:     http://git.kernel.org/tip/cc7f00820b2f3be656569c41158d9323e425bcfe
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 8 Mar 2010 17:51:33 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:36 +0100

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
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index e7ac517..a7401e4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -461,7 +461,6 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 }
 
 static int intel_pmu_save_and_restart(struct perf_event *event);
-static void intel_pmu_disable_event(struct perf_event *event);
 
 static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 {
@@ -528,7 +527,7 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
 	if (perf_event_overflow(event, 1, &data, &regs))
-		intel_pmu_disable_event(event);
+		x86_pmu_stop(event);
 
 out:
 	intel_pmu_pebs_enable_all();
@@ -603,7 +602,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 			regs.flags &= ~PERF_EFLAGS_EXACT;
 
 		if (perf_event_overflow(event, 1, &data, &regs))
-			intel_pmu_disable_event(event);
+			x86_pmu_stop(event);
 	}
 out:
 	intel_pmu_pebs_enable_all();
