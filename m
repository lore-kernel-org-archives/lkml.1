Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbYLCUlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbYLCUlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762885AbYLCUic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:38:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39712 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461AbYLCUia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:38:30 -0500
Message-Id: <20081203203829.158592001@goodmis.org>
References: <20081203203656.776893226@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Dec 2008 15:36:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Eric Biederman <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] ftrace: use task struct trace flag to filter on pid
Content-Disposition: inline; filename=0002-ftrace-use-task-struct-trace-flag-to-filter-on-pid.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

Use the new task struct trace flags to determine if a process should be
traced or not.

Note: this moves the searching of the pid to the slow path of setting
the pid field. This needs to be converted to the pid name space.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b17a303..c5049f5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -47,7 +47,7 @@
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
 
-/* ftrace_pid_trace >= 0 will only trace threads with this pid */
+/* set when tracing only a pid */
 static int ftrace_pid_trace = -1;
 
 /* Quick disabling of function tracer. */
@@ -90,7 +90,7 @@ static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
 
 static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip)
 {
-	if (current->pid != ftrace_pid_trace)
+	if (!test_tsk_trace_trace(current))
 		return;
 
 	ftrace_pid_function(ip, parent_ip);
@@ -1714,11 +1714,33 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
 		ftrace_pid_trace = -1;
 
 	} else {
+		struct task_struct *p;
+		int found = 0;
 
 		if (ftrace_pid_trace == val)
 			goto out;
 
-		ftrace_pid_trace = val;
+		/*
+		 * Find the task that matches this pid.
+		 * TODO: use pid namespaces instead.
+		 */
+		rcu_read_lock();
+		for_each_process(p) {
+			if (p->pid == val) {
+				found = 1;
+				set_tsk_trace_trace(p);
+			} else if (test_tsk_trace_trace(p))
+				clear_tsk_trace_trace(p);
+		}
+		rcu_read_unlock();
+
+		if (found)
+			ftrace_pid_trace = val;
+		else {
+			if (ftrace_pid_trace < 0)
+				goto out;
+			ftrace_pid_trace = -1;
+		}
 	}
 
 	/* update the function call */
-- 
1.5.6.5

-- 
