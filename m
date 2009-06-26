Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbZFZIzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbZFZIzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbZFZIzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:55:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53862 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbZFZIzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:55:05 -0400
Message-ID: <4A448D17.9010305@cn.fujitsu.com>
Date: Fri, 26 Jun 2009 16:55:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: fix stack tracer sysctl handling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This made my machine completely frozen:
  # echo 1 > /proc/sys/kernel/stack_tracer_enabled
  # echo 2 > /proc/sys/kernel/stack_tracer_enabled

The cause is register_ftrace_function() was called twice.

Also fix ftrace_enabled sysctl, though seems nothing bad happened
as I tested it.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c      |    4 ++--
 kernel/trace/trace_stack.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 673fc8b..4521c77 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3159,10 +3159,10 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 	ret  = proc_dointvec(table, write, file, buffer, lenp, ppos);
 
-	if (ret || !write || (last_ftrace_enabled == ftrace_enabled))
+	if (ret || !write || (last_ftrace_enabled == !!ftrace_enabled))
 		goto out;
 
-	last_ftrace_enabled = ftrace_enabled;
+	last_ftrace_enabled = !!ftrace_enabled;
 
 	if (ftrace_enabled) {
 
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 2d7aebd..e644af9 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -326,10 +326,10 @@ stack_trace_sysctl(struct ctl_table *table, int write,
 	ret = proc_dointvec(table, write, file, buffer, lenp, ppos);
 
 	if (ret || !write ||
-	    (last_stack_tracer_enabled == stack_tracer_enabled))
+	    (last_stack_tracer_enabled == !!stack_tracer_enabled))
 		goto out;
 
-	last_stack_tracer_enabled = stack_tracer_enabled;
+	last_stack_tracer_enabled = !!stack_tracer_enabled;
 
 	if (stack_tracer_enabled)
 		register_ftrace_function(&trace_ops);
-- 
1.5.4.rc3

