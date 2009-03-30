Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbZC3Smo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbZC3Smo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbZC3SmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:42:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49780 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848AbZC3SmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:42:23 -0400
Message-Id: <20090330184213.308586162@goodmis.org>
References: <20090330184149.866994402@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 14:41:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] function-graph: allow unregistering twice
Content-Disposition: inline; filename=0001-function-graph-allow-unregistering-twice.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to permanent disabling of function graph tracer

There should be nothing to prevent a tracer from unregistering a
function graph callback more than once. This can simplify error paths.

But currently, the counter does not account for mulitple unregistering
of the function graph callback. If it happens, the function graph
tracer will be permanently disabled.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1752a63..f1ed080 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2719,6 +2719,9 @@ void unregister_ftrace_graph(void)
 {
 	mutex_lock(&ftrace_lock);
 
+	if (!unlikely(atomic_read(&ftrace_graph_active)))
+		goto out;
+
 	atomic_dec(&ftrace_graph_active);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch);
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
@@ -2726,6 +2729,7 @@ void unregister_ftrace_graph(void)
 	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 
+ out:
 	mutex_unlock(&ftrace_lock);
 }
 
-- 
1.6.2.1

-- 
