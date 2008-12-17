Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753996AbYLQPLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYLQPLe (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 10:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYLQPLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 10:11:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33234 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbYLQPLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 10:11:23 -0500
Date: Wed, 17 Dec 2008 10:11:21 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: [PATCH] trace: better use of stack_trace_enabled for boot up code
In-Reply-To: <20081216202738.cbbbd92c.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0812170946380.20484@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812162311430.25356@gandalf.stny.rr.com> <20081216202738.cbbbd92c.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (1):
      trace: better use of stack_trace_enabled for boot up code

----
 kernel/trace/trace_stack.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)
---------------------------
commit 965ef53e1eb54de09aeec0af83d4635e9e9c9f73
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Dec 17 09:43:00 2008 -0500

    trace: better use of stack_trace_enabled for boot up code
    
    Impact: clean up
    
    Andrew Morton suggested to use the stack_tracer_enabled variable
    to decide whether or not to start stack tracing on bootup.
    This lets us remove the start_stack_trace variable.
    
    Reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 4842c96..d0871bc 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -308,7 +308,7 @@ stack_trace_sysctl(struct ctl_table *table, int write,
 
 	mutex_lock(&stack_sysctl_mutex);
 
-	ret  = proc_dointvec(table, write, file, buffer, lenp, ppos);
+	ret = proc_dointvec(table, write, file, buffer, lenp, ppos);
 
 	if (ret || !write ||
 	    (last_stack_tracer_enabled == stack_tracer_enabled))
@@ -326,11 +326,10 @@ stack_trace_sysctl(struct ctl_table *table, int write,
 	return ret;
 }
 
-static int start_stack_trace __initdata;
-
 static __init int enable_stacktrace(char *str)
 {
-	start_stack_trace = 1;
+	stack_tracer_enabled = 1;
+	last_stack_tracer_enabled = 1;
 	return 1;
 }
 __setup("stacktrace", enable_stacktrace);
@@ -352,10 +351,8 @@ static __init int stack_trace_init(void)
 	if (!entry)
 		pr_warning("Could not create debugfs 'stack_trace' entry\n");
 
-	if (start_stack_trace) {
+	if (stack_tracer_enabled)
 		register_ftrace_function(&trace_ops);
-		stack_tracer_enabled = 1;
-	}
 
 	return 0;
 }


