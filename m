Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYLPHHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYLPHHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYLPHHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:07:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:39836 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYLPHHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:07:08 -0500
Subject: sched: trace: update trace_sched_wakeup()
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Dec 2008 08:07:03 +0100
Message-Id: <1229411223.14605.48.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add the information needed to distinguish 'real' wakeups from 'false'
wakeups.

---
 include/trace/sched.h             |    4 ++--
 kernel/sched.c                    |    2 +-
 kernel/trace/trace_sched_switch.c |    2 +-
 kernel/trace/trace_sched_wakeup.c |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/trace/sched.h b/include/trace/sched.h
index 9b2854a..a0861d2 100644
--- a/include/trace/sched.h
+++ b/include/trace/sched.h
@@ -17,8 +17,8 @@ DECLARE_TRACE(sched_wait_task,
 		TPARGS(rq, p));
 
 DECLARE_TRACE(sched_wakeup,
-	TPPROTO(struct rq *rq, struct task_struct *p),
-		TPARGS(rq, p));
+	TPPROTO(struct rq *rq, struct task_struct *p, int success),
+		TPARGS(rq, p, success));
 
 DECLARE_TRACE(sched_wakeup_new,
 	TPPROTO(struct rq *rq, struct task_struct *p),
diff --git a/kernel/sched.c b/kernel/sched.c
index 0eff15b..953ded9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2329,7 +2329,7 @@ out_activate:
 	success = 1;
 
 out_running:
-	trace_sched_wakeup(rq, p);
+	trace_sched_wakeup(rq, p, success);
 	check_preempt_curr(rq, p, sync);
 
 	p->state = TASK_RUNNING;
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 8633905..d4db564 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -49,7 +49,7 @@ probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 }
 
 static void
-probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee)
+probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 0067b49..43586b6 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -211,7 +211,7 @@ static void wakeup_reset(struct trace_array *tr)
 }
 
 static void
-probe_wakeup(struct rq *rq, struct task_struct *p)
+probe_wakeup(struct rq *rq, struct task_struct *p, int success)
 {
 	int cpu = smp_processor_id();
 	unsigned long flags;

