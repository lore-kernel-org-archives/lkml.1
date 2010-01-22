Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456Ab0AVP7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0AVP7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435Ab0AVP73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:59:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:38252 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab0AVP72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:59:28 -0500
Message-Id: <20100122155536.056430539@chello.nl>
References: <20100122155044.391857484@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jan 2010 16:50:54 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@google.com, fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/10] perf_event: Optimize the fast path a little more
Content-Disposition: inline; filename=perf-opt-num.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove num from the fast path and save a few ops.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1248,9 +1248,9 @@ static inline int is_x86_event(struct pe
 
 static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
-	int i, j, w, num, wmax;
 	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	int i, j, w, wmax, num = 0;
 	struct hw_perf_event *hwc;
 
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
@@ -1263,7 +1263,7 @@ static int x86_schedule_events(struct cp
 	/*
 	 * fastpath, try to reuse previous register
 	 */
-	for (i = 0, num = n; i < n; i++, num--) {
+	for (i = 0; i < n; i++) {
 		hwc = &cpuc->event_list[i]->hw;
 		c = constraints[i];
 
@@ -1291,7 +1291,7 @@ static int x86_schedule_events(struct cp
 		if (assign)
 			assign[i] = hwc->idx;
 	}
-	if (!num)
+	if (i == n)
 		goto done;
 
 	/*

-- 

