Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab0CJNXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:23:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:53565 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab0CJNXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:23:35 -0500
Date: Wed, 10 Mar 2010 13:22:52 GMT
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
Subject: [tip:perf/pebs] perf, x86: Fix LBR enable/disable vs cpuc->enabled
Message-ID: <tip-2df202bf7520eaffcbfb07e45dfa3cfb0aeee2c0@git.kernel.org>
Git-Commit-ID: 2df202bf7520eaffcbfb07e45dfa3cfb0aeee2c0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:22:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2df202bf7520eaffcbfb07e45dfa3cfb0aeee2c0
Gitweb:     http://git.kernel.org/tip/2df202bf7520eaffcbfb07e45dfa3cfb0aeee2c0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 6 Mar 2010 13:48:54 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:37 +0100

perf, x86: Fix LBR enable/disable vs cpuc->enabled

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
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index dcec765..0145f99 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -69,7 +69,7 @@ static void intel_pmu_lbr_enable(struct perf_event *event)
 	if (!x86_pmu.lbr_nr)
 		return;
 
-	WARN_ON(cpuc->enabled);
+	WARN_ON_ONCE(cpuc->enabled);
 
 	/*
 	 * Reset the LBR stack if this is the first LBR user or
@@ -93,9 +93,10 @@ static void intel_pmu_lbr_disable(struct perf_event *event)
 		return;
 
 	cpuc->lbr_users--;
-
 	BUG_ON(cpuc->lbr_users < 0);
-	WARN_ON(cpuc->enabled);
+
+	if (cpuc->enabled && !cpuc->lbr_users)
+		__intel_pmu_lbr_disable();
 }
 
 static void intel_pmu_lbr_enable_all(void)
