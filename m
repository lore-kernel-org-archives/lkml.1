Return-Path: <linux-kernel-owner+w=401wt.eu-S1751738AbYJaMIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbYJaMIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 08:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYJaMIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 08:08:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:45598 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYJaMIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 08:08:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=HKO5+GpO6Mywd5qHaSmnLmwokpt7fvMBRpjJ6fwj8psGVvTz4OxeDO7CmXoRNow1fi
         Tcp/oJU+P70cz4akRDkBIk6bn34RsG+0D8PdPMmGnqN5j+2tQ0mvZfKVoMLOdbsvJAGU
         H0ImRBokOPAUkFRgyii9e3u8RBKzcbgypFflU=
Message-ID: <490AF53C.2020604@gmail.com>
Date: Fri, 31 Oct 2008 13:08:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][RESEND] tracing/ftrace: Fix a race condition in sched_switch
 tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(depends on Tracing/fastboot: Enable boot tracing only during initcalls)
---
This patch fixes a race condition in the sched_switch tracer.
If several tasks (IE: concurrent initcalls) are playing with 
tracing_start_cmdline_record() and tracing_stop_cmdline_record(),
the following situation could happen:


_ Task A and B are using the same tracepoint probe. Task A holds it. Task B is
sleeping and doesn't hold it.
_ Task A frees the sched tracer, then sched_ref is decremented to 0.
_ Task A is preempted and hadn't yet unregistered its tracepoint probe,
then B runs.
_ B increments sched_ref, sees it's 1 and then guess it has to register its probe. 
But it has not been freed by task A.
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
