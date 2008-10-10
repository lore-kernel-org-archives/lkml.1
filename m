Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYJJLfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYJJLfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYJJLfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:35:05 -0400
Received: from perso1.free.fr ([212.27.63.203]:33565 "EHLO perso1.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbYJJLfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:35:04 -0400
XPARM: thesermon.free.fr
XPARAM2: 193.50.29.42
Subject: [PATCH 3/6] tracing/ftrace: Fix a race condition in sched_switch tracer
From: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 10 Oct 2008 13:35:10
To: Ingo Molnar <mingo@elte.hu>
Message-Id: <20081010113510.A07A9D1BD59@perso1.free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a race condition in the sched_switch tracer.
If several tasks (IE: concurrent initcalls) are playing with 
tracing_start_cmdline_record() and tracing_stop_cmdline_record(),
the following situation could happen:


_ Task A and B are using the same tracepoint probe. Task A holds it. Task B is
sleeping and doesn't hold it.
_ Task A frees the sched tracer, then sched_ref is decremented to 0.
_ Task A is preempted and hadn't yet unregistered its tracepoint probe,
then B runs.
_ B increments sched_ref, sees it's 1 and then guess it has to register its probe. But it has not been freed by task A.
_ A lot of bad things can happen after that... 

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_sched_switch.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index b8f56be..59de514 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -17,6 +17,7 @@
 static struct trace_array	*ctx_trace;
 static int __read_mostly	tracer_enabled;
 static atomic_t			sched_ref;
+static DEFINE_MUTEX(tracepoint_mutex);
 
 static void
 probe_sched_switch(struct rq *__rq, struct task_struct *prev,
@@ -125,18 +126,22 @@ static void tracing_start_sched_switch(void)
 {
 	long ref;
 
+	mutex_lock(&tracepoint_mutex);
 	ref = atomic_inc_return(&sched_ref);
 	if (ref == 1)
 		tracing_sched_register();
+	mutex_unlock(&tracepoint_mutex);
 }
 
 static void tracing_stop_sched_switch(void)
 {
 	long ref;
 
+	mutex_lock(&tracepoint_mutex);
 	ref = atomic_dec_and_test(&sched_ref);
 	if (ref)
 		tracing_sched_unregister();
+	mutex_unlock(&tracepoint_mutex);
 }
 
 void tracing_start_cmdline_record(void)

