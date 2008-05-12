Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYELD3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYELD3K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 23:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYELD2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 23:28:55 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:48569 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753682AbYELD2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 23:28:54 -0400
To: mingo@elte.hu
Cc: Pavel Roskin <proski@gnu.org>, Pekka Paalanen <pq@iki.fi>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ftrace/sysprof: Don't trace the user stack if we are a kernel thread.
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 12 May 2008 05:28:50 +0200
Message-ID: <ye8tzh4dwul.fsf@camel09.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check that current->mm is non-NULL before attempting to trace the user
stack.

Also take depth of the kernel stack into account when comparing
against sample_max_depth.
---
 kernel/trace/trace_sysprof.c |   56 ++++++++++++++++++++++++------------------
 1 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index fe23d6d..4862000 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -95,13 +95,12 @@ const static struct stacktrace_ops backtrace_ops = {
 	.address		= backtrace_address,
 };
 
-static struct pt_regs *
+static int
 trace_kernel(struct pt_regs *regs, struct trace_array *tr,
 	     struct trace_array_cpu *data)
 {
 	struct backtrace_info info;
 	unsigned long bp;
-	char *user_stack;
 	char *stack;
 
 	info.tr = tr;
@@ -119,10 +118,7 @@ trace_kernel(struct pt_regs *regs, struct trace_array *tr,
 
 	dump_trace(NULL, regs, (void *)stack, bp, &backtrace_ops, &info);
 
-	/* Now trace the user stack */
-	user_stack = ((char *)current->thread.sp0 - sizeof(struct pt_regs));
-
-	return (struct pt_regs *)user_stack;
+	return info.pos;
 }
 
 static void timer_notify(struct pt_regs *regs, int cpu)
@@ -150,32 +146,44 @@ static void timer_notify(struct pt_regs *regs, int cpu)
 	__trace_special(tr, data, 0, 0, current->pid);
 
 	if (!is_user)
-		regs = trace_kernel(regs, tr, data);
-
-	fp = (void __user *)regs->bp;
-
-	__trace_special(tr, data, 2, regs->ip, 0);
-
-	for (i = 0; i < sample_max_depth; i++) {
-		frame.next_fp = 0;
-		frame.return_address = 0;
-		if (!copy_stack_frame(fp, &frame))
-			break;
-		if ((unsigned long)fp < regs->sp)
-			break;
+		i = trace_kernel(regs, tr, data);
+	else
+		i = 0;
 
-		__trace_special(tr, data, 2, frame.return_address,
-			      (unsigned long)fp);
-		fp = frame.next_fp;
+	/*
+	 * Trace user stack if we are not a kernel thread
+	 */
+	if (current->mm && i < sample_max_depth) {
+		regs = (struct pt_regs *)current->thread.sp0 - 1;
+
+		fp = (void __user *)regs->bp;
+	    
+		__trace_special(tr, data, 2, regs->ip, 0);
+
+		while (i < sample_max_depth) {
+			frame.next_fp = 0;
+			frame.return_address = 0;
+			if (!copy_stack_frame(fp, &frame))
+				break;
+			if ((unsigned long)fp < regs->sp)
+				break;
+			
+			__trace_special(tr, data, 2, frame.return_address,
+					(unsigned long)fp);
+			fp = frame.next_fp;
+
+			i++;
+		}
+		
 	}
 
-	__trace_special(tr, data, 3, current->pid, i);
-
 	/*
 	 * Special trace entry if we overflow the max depth:
 	 */
 	if (i == sample_max_depth)
 		__trace_special(tr, data, -1, -1, -1);
+	
+	__trace_special(tr, data, 3, current->pid, i);
 }
 
 static enum hrtimer_restart stack_trace_timer_fn(struct hrtimer *hrtimer)
-- 
1.5.4.5

