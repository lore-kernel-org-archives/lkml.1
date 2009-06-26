Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbZFZSw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbZFZSw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbZFZSwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:52:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:49181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZFZSwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:52:17 -0400
Date: Fri, 26 Jun 2009 18:51:31 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A448D17.9010305@cn.fujitsu.com>
References: <4A448D17.9010305@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: Fix stack tracer sysctl handling
Message-ID: <tip-a32c7765e2796395aec49f699bd25c407155e9c5@git.kernel.org>
Git-Commit-ID: a32c7765e2796395aec49f699bd25c407155e9c5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 26 Jun 2009 18:51:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a32c7765e2796395aec49f699bd25c407155e9c5
Gitweb:     http://git.kernel.org/tip/a32c7765e2796395aec49f699bd25c407155e9c5
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 26 Jun 2009 16:55:51 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Jun 2009 20:48:39 +0200

tracing: Fix stack tracer sysctl handling

This made my machine completely frozen:

  # echo 1 > /proc/sys/kernel/stack_tracer_enabled
  # echo 2 > /proc/sys/kernel/stack_tracer_enabled

The cause is register_ftrace_function() was called twice.

Also fix ftrace_enabled sysctl, though seems nothing bad happened
as I tested it.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A448D17.9010305@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c      |    4 ++--
 kernel/trace/trace_stack.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f3716bf..bce9e01 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3160,10 +3160,10 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
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
