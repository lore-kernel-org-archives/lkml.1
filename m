Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZCXN4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZCXN4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZCXN4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:56:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbZCXN4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:56:12 -0400
Message-Id: <20090324135610.248663698@goodmis.org>
References: <20090324135422.026619569@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 09:54:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] function-graph: prevent more than one tracer registering
Content-Disposition: inline; filename=0002-function-graph-prevent-more-than-one-tracer-registe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: prevent crash due to multiple function graph tracers

The function graph tracer can currently only handle a single tracer
being registered. If another tracer registers with the function
graph tracer it can crash the system.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7847806..c81a759 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2643,6 +2643,12 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 
 	mutex_lock(&ftrace_lock);
 
+	/* we currently allow only one tracer registered at a time */
+	if (atomic_read(&ftrace_graph_active)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ftrace_suspend_notifier.notifier_call = ftrace_suspend_notifier_call;
 	register_pm_notifier(&ftrace_suspend_notifier);
 
-- 
1.6.2

-- 
