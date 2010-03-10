Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab0CJNYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:24:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:53627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230Ab0CJNYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:24:37 -0500
Date: Wed, 10 Mar 2010 13:23:58 GMT
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
Subject: [tip:perf/pebs] perf, x86: Don't reset the LBR as frequently
Message-ID: <tip-b83a46e7da4a948cc852ba7805dfb1a392dec861@git.kernel.org>
Git-Commit-ID: b83a46e7da4a948cc852ba7805dfb1a392dec861
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:23:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b83a46e7da4a948cc852ba7805dfb1a392dec861
Gitweb:     http://git.kernel.org/tip/b83a46e7da4a948cc852ba7805dfb1a392dec861
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 8 Mar 2010 13:51:12 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:38 +0100

perf, x86: Don't reset the LBR as frequently

If we reset the LBR on each first counter, simple counter rotation which
first deschedules all counters and then reschedules the new ones will
lead to LBR reset, even though we're still in the same task context.

Reduce this by not flushing on the first counter but only flushing on
different task contexts.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 0145f99..f278136 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -72,12 +72,11 @@ static void intel_pmu_lbr_enable(struct perf_event *event)
 	WARN_ON_ONCE(cpuc->enabled);
 
 	/*
-	 * Reset the LBR stack if this is the first LBR user or
-	 * we changed task context so as to avoid data leaks.
+	 * Reset the LBR stack if we changed task context to
+	 * avoid data leaks.
 	 */
 
-	if (!cpuc->lbr_users ||
-	    (event->ctx->task && cpuc->lbr_context != event->ctx)) {
+	if (event->ctx->task && cpuc->lbr_context != event->ctx) {
 		intel_pmu_lbr_reset();
 		cpuc->lbr_context = event->ctx;
 	}
@@ -93,7 +92,7 @@ static void intel_pmu_lbr_disable(struct perf_event *event)
 		return;
 
 	cpuc->lbr_users--;
-	BUG_ON(cpuc->lbr_users < 0);
+	WARN_ON_ONCE(cpuc->lbr_users < 0);
 
 	if (cpuc->enabled && !cpuc->lbr_users)
 		__intel_pmu_lbr_disable();
