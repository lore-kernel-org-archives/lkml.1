Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801Ab0AVQCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab0AVQCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179Ab0AVQCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:02:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:38266 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab0AVP7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:59:34 -0500
Message-Id: <20100122155535.963944926@chello.nl>
References: <20100122155044.391857484@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jan 2010 16:50:53 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@google.com, fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/10] perf_event: x86: Optimize constraint weight computation
Content-Disposition: inline; filename=perf-opt-weight.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a weight member to the constraint structure and avoid recomputing
the weight at runtime.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -23,6 +23,7 @@
 #include <linux/uaccess.h>
 #include <linux/highmem.h>
 #include <linux/cpu.h>
+#include <linux/bitops.h>
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
@@ -76,6 +77,7 @@ struct event_constraint {
 	};
 	int	code;
 	int	cmask;
+	int	weight;
 };
 
 struct cpu_hw_events {
@@ -96,6 +98,7 @@ struct cpu_hw_events {
 	{ .idxmsk64[0] = (n) },		\
 	.code = (c),			\
 	.cmask = (m),			\
+	.weight = HWEIGHT64((u64)(n)),	\
 }
 
 #define INTEL_EVENT_CONSTRAINT(c, n)	\
@@ -1245,8 +1248,7 @@ static inline int is_x86_event(struct pe
 
 static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
-	int i, j , w, num;
-	int weight, wmax;
+	int i, j, w, num, wmax;
 	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	struct hw_perf_event *hwc;
@@ -1323,8 +1325,7 @@ static int x86_schedule_events(struct cp
 			c = constraints[i];
 			hwc = &cpuc->event_list[i]->hw;
 
-			weight = bitmap_weight(c->idxmsk, X86_PMC_IDX_MAX);
-			if (weight != w)
+			if (c->weight != w)
 				continue;
 
 			for_each_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {

-- 

