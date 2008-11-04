Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYKDEWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYKDEWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 23:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbYKDEWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 23:22:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33052 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbYKDEWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 23:22:06 -0500
Message-Id: <20081104042203.123673140@goodmis.org>
References: <20081104041554.605521183@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 03 Nov 2008 23:15:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] ftrace: ftrace_preempt_disable
Content-Disposition: inline; filename=ftrace-preempt-disable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parts of the tracer needs to be careful about schedule recursion.
If the NEED_RESCHED flag is set, a preempt_enable will call schedule.
Inside the schedule function, the NEED_RESCHED flag is cleared.

The problem arises when a trace happens in the schedule function but before
NEED_RESCHED is cleared. The race is as follows:

schedule()
  >> tracer called

    trace_function()
       preempt_disable()
       [ record trace ]
       preempt_enable()  <<- here's the issue.

         [check NEED_RESCHED]
          schedule()
          [ Repeat the above, over and over again ]

The naive approach is simply to use preempt_enable_no_schedule instead.
The problem with that approach is that, although we solve the schedule
recursion issue, we now might lose a preemption check when not in the
schedule function.

  trace_function()
    preempt_disable()
    [ record trace ]
    [Interrupt comes in and sets NEED_RESCHED]
    preempt_enable_no_resched()
    [continue without scheduling]

The way ftrace handles this problem is with the following approach:

	int resched;

	resched = need_resched();
	preempt_disable_notrace();
	[record trace]
	if (resched)
		preempt_enable_no_sched_notrace();
	else
		preempt_enable_notrace();

This may seem like the opposite of what we want. If resched is set
then we call the "no_sched" version??  The reason we do this is because
if NEED_RESCHED is set before we disable preemption, there's two reasons
for that:

  1) we are in an atomic code path
  2) we are already on our way to the schedule function, and maybe even
     in the schedule function, but have yet to clear the flag.

Both the above cases we do not want to schedule.

This solution has already been implemented within the ftrace infrastructure.
But the problem is that it has been implemented several times. This patch
encapsulates this code to two nice functions.

  resched = ftrace_preempt_disable();
  [ record trace]
  ftrace_preempt_enable(resched);

This way the tracers do not need to worry about getting it right.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.h |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

Index: linux-tip.git/kernel/trace/trace.h
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.h	2008-11-03 18:09:05.000000000 -0500
+++ linux-tip.git/kernel/trace/trace.h	2008-11-03 18:27:38.000000000 -0500
@@ -419,4 +419,52 @@ enum trace_iterator_flags {
 
 extern struct tracer nop_trace;
 
+/**
+ * ftrace_preempt_disable - disable preemption scheduler safe
+ *
+ * When tracing can happen inside the scheduler, there exists
+ * cases that the tracing might happen before the need_resched
+ * flag is checked. If this happens and the tracer calls
+ * preempt_enable (after a disable), a schedule might take place
+ * causing an infinite recursion.
+ *
+ * To prevent this, we read the need_recshed flag before
+ * disabling preemption. When we want to enable preemption we
+ * check the flag, if it is set, then we call preempt_enable_no_resched.
+ * Otherwise, we call preempt_enable.
+ *
+ * The rational for doing the above is that if need resched is set
+ * and we have yet to reschedule, we are either in an atomic location
+ * (where we do not need to check for scheduling) or we are inside
+ * the scheduler and do not want to resched.
+ */
+static inline int ftrace_preempt_disable(void)
+{
+	int resched;
+
+	resched = need_resched();
+	preempt_disable_notrace();
+
+	return resched;
+}
+
+/**
+ * ftrace_preempt_enable - enable preemption scheduler safe
+ * @resched: the return value from ftrace_preempt_disable
+ *
+ * This is a scheduler safe way to enable preemption and not miss
+ * any preemption checks. The disabled saved the state of preemption.
+ * If resched is set, then we were either inside an atomic or
+ * are inside the scheduler (we would have already scheduled
+ * otherwise). In this case, we do not want to call normal
+ * preempt_enable, but preempt_enable_no_resched instead.
+ */
+static inline void ftrace_preempt_enable(int resched)
+{
+	if (resched)
+		preempt_enable_no_resched_notrace();
+	else
+		preempt_enable_notrace();
+}
+
 #endif /* _LINUX_KERNEL_TRACE_H */

-- 
