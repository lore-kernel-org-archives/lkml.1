Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab0CJNX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:23:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:53554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227Ab0CJNX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:23:26 -0500
Date: Wed, 10 Mar 2010 13:22:35 GMT
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
Subject: [tip:perf/pebs] perf, x86: Fix PEBS enable/disable vs cpuc->enabled
Message-ID: <tip-4807e3d5dc7bb7057dd6ca3abb09f3da2eb8c323@git.kernel.org>
Git-Commit-ID: 4807e3d5dc7bb7057dd6ca3abb09f3da2eb8c323
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:22:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4807e3d5dc7bb7057dd6ca3abb09f3da2eb8c323
Gitweb:     http://git.kernel.org/tip/4807e3d5dc7bb7057dd6ca3abb09f3da2eb8c323
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 6 Mar 2010 13:47:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:36 +0100

perf, x86: Fix PEBS enable/disable vs cpuc->enabled

We should never call ->enable with the pmu enabled, and we _can_ have
->disable called with the pmu enabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 66c6962..9ad0e67 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -338,7 +338,7 @@ static void intel_pmu_pebs_enable(struct perf_event *event)
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 
 	val |= 1ULL << hwc->idx;
-	wrmsrl(MSR_IA32_PEBS_ENABLE, val);
+	WARN_ON_ONCE(cpuc->enabled);
 
 	if (x86_pmu.intel_cap.pebs_trap)
 		intel_pmu_lbr_enable(event);
@@ -351,7 +351,8 @@ static void intel_pmu_pebs_disable(struct perf_event *event)
 	u64 val = cpuc->pebs_enabled;
 
 	val &= ~(1ULL << hwc->idx);
-	wrmsrl(MSR_IA32_PEBS_ENABLE, val);
+	if (cpuc->enabled)
+		wrmsrl(MSR_IA32_PEBS_ENABLE, val);
 
 	hwc->config |= ARCH_PERFMON_EVENTSEL_INT;
 
