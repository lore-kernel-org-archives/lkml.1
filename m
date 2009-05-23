Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZEWQb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZEWQb4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 12:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbZEWQbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 12:31:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:42754 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbZEWQbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 12:31:44 -0400
Message-Id: <20090523163012.476197912@chello.nl>
References: <20090523162854.599719825@chello.nl>
User-Agent: quilt/0.46-1
Date: Sat, 23 May 2009 18:28:55 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/7] perf_counter: fix dynamic irq_period logging
Content-Disposition: inline; filename=perf_counter-fix-dyn-period.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call perf_adjust_freq() from perf_counter_task_tick() which is is called
under the rq->lock causing lock recursion. However, it's no longer required
to be called under the rq->lock, so remove it from under it.

Also, fix up some related comments.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    1 +
 kernel/perf_counter.c        |    3 ++-
 kernel/sched.c               |    3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -260,6 +260,7 @@ enum perf_event_type {
 	/*
 	 * struct {
 	 * 	struct perf_event_header	header;
+	 * 	u64				time;
 	 * 	u64				irq_period;
 	 * };
 	 */
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -2559,7 +2559,8 @@ void perf_counter_munmap(unsigned long a
 }
 
 /*
- *
+ * Log irq_period changes so that analyzing tools can re-normalize the
+ * event flow.
  */
 
 static void perf_log_period(struct perf_counter *counter, u64 period)
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -5113,9 +5113,10 @@ void scheduler_tick(void)
 	update_rq_clock(rq);
 	update_cpu_load(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
-	perf_counter_task_tick(curr, cpu);
 	spin_unlock(&rq->lock);
 
+	perf_counter_task_tick(curr, cpu);
+
 #ifdef CONFIG_SMP
 	rq->idle_at_tick = idle_cpu(cpu);
 	trigger_load_balance(rq, cpu);

-- 

