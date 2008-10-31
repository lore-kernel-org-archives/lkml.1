Return-Path: <linux-kernel-owner+w=401wt.eu-S1751871AbYJaM3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbYJaM3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 08:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbYJaM3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 08:29:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:50239 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYJaM3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 08:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=cb/aw09HQzxFFlankjsOehJiHpcVuUlK+ScoGfVjkGcpyaMIgjHMygppBYlOOsCNjL
         63JGq1izLNPu02KJN619R3YA9UiU3PjLDxpjuM5BudUb8hNGjLld8G7XSW3eD8hyALkS
         djYTyIZ7jumYpyGl4Td31dido/rl0Chn7ba1w=
Message-ID: <490AFA0A.3080708@gmail.com>
Date: Fri, 31 Oct 2008 13:28:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][RESEND] tracing/ftrace: Types and naming corrections for
 sched tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(depends on tracing/fastboot: Use sched switch tracer from boot tracer)
---
This patch applies some corrections suggested by Steven Rostedt.

Change the type of shed_ref into int since it is used
into a Mutex, we don't need it anymore as an atomic
variable in the sched_switch tracer.
Also change the name of the register mutex.


Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_sched_switch.c |   30 +++++++++++++-----------------
 1 files changed, 13 insertions(+), 17 deletions(-)
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 9d7bdac..969953b 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -16,8 +16,8 @@
 
 static struct trace_array	*ctx_trace;
 static int __read_mostly	tracer_enabled;
-static atomic_t			sched_ref;
-static DEFINE_MUTEX(tracepoint_mutex);
+static int			sched_ref;
+static DEFINE_MUTEX(sched_register_mutex);
 
 static void
 probe_sched_switch(struct rq *__rq, struct task_struct *prev,
@@ -28,7 +28,7 @@ probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 	int cpu;
 	int pc;
 
-	if (!atomic_read(&sched_ref))
+	if (!sched_ref)
 		return;
 
 	tracing_record_cmdline(prev);
@@ -124,26 +124,22 @@ static void tracing_sched_unregister(void)
 
 static void tracing_start_sched_switch(void)
 {
-	long ref;
-
-	mutex_lock(&tracepoint_mutex);
-	tracer_enabled = 1;
-	ref = atomic_inc_return(&sched_ref);
-	if (ref == 1)
+	mutex_lock(&sched_register_mutex);
+	if (!(sched_ref++)) {
+		tracer_enabled = 1;
 		tracing_sched_register();
-	mutex_unlock(&tracepoint_mutex);
+	}
+	mutex_unlock(&sched_register_mutex);
 }
 
 static void tracing_stop_sched_switch(void)
 {
-	long ref;
-
-	mutex_lock(&tracepoint_mutex);
-	tracer_enabled = 0;
-	ref = atomic_dec_and_test(&sched_ref);
-	if (ref)
+	mutex_lock(&sched_register_mutex);
+	if (!(--sched_ref)) {
 		tracing_sched_unregister();
-	mutex_unlock(&tracepoint_mutex);
+		tracer_enabled = 0;
+	}
+	mutex_unlock(&sched_register_mutex);
 }
 
 void tracing_start_cmdline_record(void)
