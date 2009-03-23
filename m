Return-Path: <linux-kernel-owner+w=401wt.eu-S1759782AbZCWU5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782AbZCWU5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbZCWU5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:57:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:49063 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbZCWU5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:57:04 -0400
Date: Mon, 23 Mar 2009 20:56:31 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090323172417.152096433@chello.nl>
References: <20090323172417.152096433@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: avoid recursion
Message-ID: <tip-4d0ec5f64b60057b395f2d314189ccde71d2d0bd@git.kernel.org>
Git-Commit-ID: 4d0ec5f64b60057b395f2d314189ccde71d2d0bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 20:56:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d0ec5f64b60057b395f2d314189ccde71d2d0bd
Gitweb:     http://git.kernel.org/tip/4d0ec5f64b60057b395f2d314189ccde71d2d0bd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 23 Mar 2009 18:22:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 21:45:09 +0100

perf_counter: avoid recursion

Tracepoint events like lock_acquire and software counters like
pagefaults can recurse into the perf counter code again, avoid that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090323172417.152096433@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    7 +++++++
 kernel/perf_counter.c        |   26 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 56099e5..18dc17d 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
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
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ca14fc4..ce34bff 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/vmstat.h>
 #include <linux/rculist.h>
+#include <linux/hardirq.h>
 
 #include <asm/irq_regs.h>
 
@@ -1532,10 +1533,31 @@ static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
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
@@ -1543,6 +1565,10 @@ static void __perf_swcounter_event(enum perf_event_types type, u32 event,
 				nr, nmi, regs);
 	}
 
+	barrier();
+	(*recursion)--;
+
+out:
 	put_cpu_var(perf_cpu_context);
 }
 
