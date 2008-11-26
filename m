Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbYKZBFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbYKZBFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 20:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYKZBFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 20:05:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYKZBFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 20:05:12 -0500
Message-Id: <20081126010510.689844401@goodmis.org>
References: <20081126010400.273569313@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 25 Nov 2008 20:04:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ftrace: let function tracing and function return run together
Content-Disposition: inline; filename=0002-ftrace-let-function-tracing-and-function-return-run.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Impact: feature

This patch enables function tracing and function return to run together.
I've tested this by enabling the stack tracer and return tracer, where
both the function entry and function return are used together with
dynamic ftrace.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 03223b5..5c5e25c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -53,9 +53,6 @@ static int ftrace_pid_trace = -1;
 /* Quick disabling of function tracer. */
 int function_trace_stop;
 
-/* By default, current tracing type is normal tracing. */
-enum ftrace_tracing_type_t ftrace_tracing_type = FTRACE_TYPE_ENTER;
-
 /*
  * ftrace_disabled is set when an anomaly is discovered.
  * ftrace_disabled is much stronger than ftrace_enabled.
@@ -1575,15 +1572,9 @@ int register_ftrace_function(struct ftrace_ops *ops)
 
 	mutex_lock(&ftrace_sysctl_lock);
 
-	if (ftrace_tracing_type == FTRACE_TYPE_RETURN) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	ret = __register_ftrace_function(ops);
 	ftrace_startup(0);
 
-out:
 	mutex_unlock(&ftrace_sysctl_lock);
 	return ret;
 }
@@ -1728,21 +1719,12 @@ int register_ftrace_return(trace_function_return_t func)
 
 	mutex_lock(&ftrace_sysctl_lock);
 
-	/*
-	 * Don't launch return tracing if normal function
-	 * tracing is already running.
-	 */
-	if (ftrace_trace_function != ftrace_stub) {
-		ret = -EBUSY;
-		goto out;
-	}
 	atomic_inc(&ftrace_retfunc_active);
 	ret = start_return_tracing();
 	if (ret) {
 		atomic_dec(&ftrace_retfunc_active);
 		goto out;
 	}
-	ftrace_tracing_type = FTRACE_TYPE_RETURN;
 	ftrace_startup(FTRACE_START_FUNC_RET);
 	ftrace_function_return = func;
 
@@ -1758,8 +1740,6 @@ void unregister_ftrace_return(void)
 	atomic_dec(&ftrace_retfunc_active);
 	ftrace_function_return = (trace_function_return_t)ftrace_stub;
 	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
-	/* Restore normal tracing type */
-	ftrace_tracing_type = FTRACE_TYPE_ENTER;
 
 	mutex_unlock(&ftrace_sysctl_lock);
 }
-- 
1.5.6.5

-- 
