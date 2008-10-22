Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYJVRbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYJVRbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYJVRbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:31:33 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:22652 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbYJVRbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=CeUHMaWeiqMraGRigShSJrJFIZTYodOZMf08CFWzvzoWK0sNIIs5TkHcmNrMGhlihF
         GvW14thSFfzfCUh7HBks0S2ggx5VcTPFPA/uspzN5TkeazkJZRnhbKRvFhM7Of9LqQmR
         5K8xdX2ReBpTt0R3BRJfhd5z6TGuwhLhyp7ao=
Message-ID: <48FF636F.6090804@gmail.com>
Date: Wed, 22 Oct 2008 19:31:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] tracing/ftrace: Types and naming corrections for sched
 tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/kernel/trace/trace_sched_switch.c
b/kernel/trace/trace_sched_switch.c
index 9d7bdac..969953b 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -16,8 +16,8 @@

 static struct trace_array	*ctx_trace;
 static int __read_mostly	tracer_enabled;
-static atomic_t		sched_ref;
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
-	 tracer_enabled = 1;
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
