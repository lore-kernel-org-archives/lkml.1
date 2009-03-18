Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbZCRDel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbZCRDel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757475AbZCRDc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:32:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbZCRDcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:32:52 -0400
Message-Id: <20090318033249.684068109@goodmis.org>
References: <20090318031423.981603258@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Mar 2009 23:14:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] tracing: make sched_switch stop/start light weight
Content-Disposition: inline; filename=0004-tracing-make-sched_switch-stop-start-light-weight.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The stopping and starting of a tracer should be light weight and
be able to be called in all contexts. The sched_switch grabbed
mutexes in the start/stop functions. This patch changes it to a
simple variable, on/off.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_sched_switch.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 77132c2..de35f20 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -18,6 +18,7 @@ static struct trace_array	*ctx_trace;
 static int __read_mostly	tracer_enabled;
 static int			sched_ref;
 static DEFINE_MUTEX(sched_register_mutex);
+static int			sched_stopped;
 
 static void
 probe_sched_switch(struct rq *__rq, struct task_struct *prev,
@@ -28,7 +29,7 @@ probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 	int cpu;
 	int pc;
 
-	if (!sched_ref)
+	if (!sched_ref || sched_stopped)
 		return;
 
 	tracing_record_cmdline(prev);
@@ -193,6 +194,7 @@ static void stop_sched_trace(struct trace_array *tr)
 static int sched_switch_trace_init(struct trace_array *tr)
 {
 	ctx_trace = tr;
+	tracing_reset_online_cpus(tr);
 	tracing_start_sched_switch_record();
 	return 0;
 }
@@ -205,13 +207,12 @@ static void sched_switch_trace_reset(struct trace_array *tr)
 
 static void sched_switch_trace_start(struct trace_array *tr)
 {
-	tracing_reset_online_cpus(tr);
-	tracing_start_sched_switch();
+	sched_stopped = 0;
 }
 
 static void sched_switch_trace_stop(struct trace_array *tr)
 {
-	tracing_stop_sched_switch();
+	sched_stopped = 1;
 }
 
 static struct tracer sched_switch_trace __read_mostly =
-- 
1.6.2

-- 
