Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbZCWRZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbZCWRZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbZCWRZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:25:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35503 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbZCWRZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:25:10 -0400
Message-Id: <20090323172417.152096433@chello.nl>
References: <20090323172205.389341032@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 23 Mar 2009 18:22:07 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/7] perf_counter: avoid recursion
Content-Disposition: inline; filename=perf_counter-recursion.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracepoint events like lock_acquire and software counters like
pagefaults can recurse into the perf counter code again, avoid that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    7 +++++++
 kernel/perf_counter.c        |   26 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -328,6 +328,13 @@ struct perf_cpu_context {
 	int				active_oncpu;
 	int				max_pertask;
 	int				exclusive;
+
+	/*
+	 * Recursion avoidance:
+	 *
+	 * task, softirq, irq, nmi context
+	 */
+	int			recursion[4];
 };
 
 /*
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/vmstat.h>
 #include <linux/rculist.h>
+#include <linux/hardirq.h>
 
 #include <asm/irq_regs.h>
 
@@ -1532,10 +1533,31 @@ static void perf_swcounter_ctx_event(str
 	rcu_read_unlock();
 }
 
+static int *perf_swcounter_recursion_context(struct perf_cpu_context *cpuctx)
+{
+	if (in_nmi())
+		return &cpuctx->recursion[3];
+
+	if (in_irq())
+		return &cpuctx->recursion[2];
+
+	if (in_softirq())
+		return &cpuctx->recursion[1];
+
+	return &cpuctx->recursion[0];
+}
+
 static void __perf_swcounter_event(enum perf_event_types type, u32 event,
 				   u64 nr, int nmi, struct pt_regs *regs)
 {
 	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
+	int *recursion = perf_swcounter_recursion_context(cpuctx);
+
+	if (*recursion)
+		goto out;
+
+	(*recursion)++;
+	barrier();
 
 	perf_swcounter_ctx_event(&cpuctx->ctx, type, event, nr, nmi, regs);
 	if (cpuctx->task_ctx) {
@@ -1543,6 +1565,10 @@ static void __perf_swcounter_event(enum 
 				nr, nmi, regs);
 	}
 
+	barrier();
+	(*recursion)--;
+
+out:
 	put_cpu_var(perf_cpu_context);
 }
 

-- 

