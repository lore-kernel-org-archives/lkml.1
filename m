Return-Path: <linux-kernel-owner+w=401wt.eu-S1762880AbZCXQZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762880AbZCXQZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762835AbZCXQX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:23:57 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40280 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762845AbZCXQXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:23:54 -0400
Message-Id: <20090324160148.554127249@polymtl.ca>
References: <20090324155625.420966314@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 11:56:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 5/9] LTTng instrumentation scheduler fix task migration
Content-Disposition: inline; filename=lttng-instrumentation-scheduler-fixup-task-migration.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 24 Mar 2009 16:22:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler migration only needs to pass the task struct pointer and the
destination CPU. The source CPU can be found by using task_cpu(p) in the probe.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Jason Baron <jbaron@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
---
 include/trace/sched.h |    4 ++--
 kernel/sched.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/include/trace/sched.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/sched.h	2009-01-30 10:42:51.000000000 -0500
+++ linux-2.6-lttng/include/trace/sched.h	2009-01-30 10:43:19.000000000 -0500
@@ -30,8 +30,8 @@ DECLARE_TRACE(sched_switch,
 		TPARGS(rq, prev, next));
 
 DECLARE_TRACE(sched_migrate_task,
-	TPPROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
-		TPARGS(p, orig_cpu, dest_cpu));
+	TPPROTO(struct task_struct *p, int dest_cpu),
+		TPARGS(p, dest_cpu));
 
 DECLARE_TRACE(sched_process_free,
 	TPPROTO(struct task_struct *p),
Index: linux-2.6-lttng/kernel/sched.c
===================================================================
--- linux-2.6-lttng.orig/kernel/sched.c	2009-01-30 10:43:07.000000000 -0500
+++ linux-2.6-lttng/kernel/sched.c	2009-01-30 10:43:38.000000000 -0500
@@ -1876,7 +1876,7 @@ void set_task_cpu(struct task_struct *p,
 
 	clock_offset = old_rq->clock - new_rq->clock;
 
-	trace_sched_migrate_task(p, task_cpu(p), new_cpu);
+	trace_sched_migrate_task(p, new_cpu);
 
 #ifdef CONFIG_SCHEDSTATS
 	if (p->se.wait_start)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
