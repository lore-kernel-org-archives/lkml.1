Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816Ab0A2JaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab0A2JaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808Ab0A2JaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:30:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:57491 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab0A2JaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:30:00 -0500
Date: Fri, 29 Jan 2010 09:28:50 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100122155536.056430539@chello.nl>
References: <20100122155536.056430539@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: x86: Optimize the fast path a little more
Message-ID: <tip-c933c1a603d5bf700ddce79216c1be0ec3bc0e6c@git.kernel.org>
Git-Commit-ID: c933c1a603d5bf700ddce79216c1be0ec3bc0e6c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:28:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c933c1a603d5bf700ddce79216c1be0ec3bc0e6c
Gitweb:     http://git.kernel.org/tip/c933c1a603d5bf700ddce79216c1be0ec3bc0e6c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 22 Jan 2010 16:40:12 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:42 +0100

perf_event: x86: Optimize the fast path a little more

Remove num from the fast path and save a few ops.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100122155536.056430539@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2c22ce4..33c889f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1245,9 +1245,9 @@ static inline int is_x86_event(struct perf_event *event)
 
 static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
-	int i, j, w, num, wmax;
 	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	int i, j, w, wmax, num = 0;
 	struct hw_perf_event *hwc;
 
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
@@ -1260,7 +1260,7 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	/*
 	 * fastpath, try to reuse previous register
 	 */
-	for (i = 0, num = n; i < n; i++, num--) {
+	for (i = 0; i < n; i++) {
 		hwc = &cpuc->event_list[i]->hw;
 		c = constraints[i];
 
@@ -1288,7 +1288,7 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 		if (assign)
 			assign[i] = hwc->idx;
 	}
-	if (!num)
+	if (i == n)
 		goto done;
 
 	/*
