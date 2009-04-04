Return-Path: <linux-kernel-owner+w=401wt.eu-S937232AbZDDAa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937232AbZDDAa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936731AbZDDA2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:28:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936617AbZDDA2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:28:11 -0400
Message-Id: <20090404002808.027821767@goodmis.org>
References: <20090404002703.627460459@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 20:27:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 01/10] tracing: remove CALLER_ADDR2 from wakeup tracer
Content-Disposition: inline; filename=0001-tracing-remove-CALLER_ADDR2-from-wakeup-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Maneesh Soni was getting a crash when running the wakeup tracer.
We debugged it down to the recording of the function with the
CALLER_ADDR2 macro.  This is used to get the location of the caller
to schedule.

But the problem comes when schedule is called by assmebly. In the case
that Maneesh had, retint_careful would call schedule. But retint_careful
does not set up a proper frame pointer. CALLER_ADDR2 is defined as
__builtin_return_address(2). This produces the following assembly in
the wakeup tracer code.

   mov    0x0(%rbp),%rcx  <--- get the frame pointer of the caller
   mov    %r14d,%r8d
   mov    0xf2de8e(%rip),%rdi

   mov    0x8(%rcx),%rsi  <-- this is __builtin_return_address(1)
   mov    0x28(%rdi,%rax,8),%rbx

   mov    (%rcx),%rax  <-- get the frame pointer of the caller's caller
   mov    %r12,%rcx
   mov    0x8(%rax),%rdx <-- this is __builtin_return_address(2)

At the reading of 0x8(%rax) Maneesh's machine would take a fault.
The reason is that retint_careful did not set up the return address
and the content of %rax here was zero.

To verify this, I sent Maneesh a patch to create a frame pointer
in retint_careful. He ran the test again but this time he would take
the same type of fault from sysret_careful. The retint_careful was no
longer an issue, but there are other callers that still have issues.

Instead of adding frame pointers for all callers to schedule (in possibly
all archs), it is much safer to simply not use CALLER_ADDR2. This
loses out on knowing what called schedule, but the function tracer
will help there if needed.

Reported-by: Maneesh Soni <maneesh@in.ibm.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_sched_wakeup.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 3c5ad6b..5bc00e8 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -154,7 +154,7 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	if (unlikely(!tracer_enabled || next != wakeup_task))
 		goto out_unlock;
 
-	trace_function(wakeup_trace, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
+	trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
 	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
 
 	/*
@@ -257,6 +257,12 @@ probe_wakeup(struct rq *rq, struct task_struct *p, int success)
 	data = wakeup_trace->data[wakeup_cpu];
 	data->preempt_timestamp = ftrace_now(cpu);
 	tracing_sched_wakeup_trace(wakeup_trace, p, current, flags, pc);
+
+	/*
+	 * We must be careful in using CALLER_ADDR2. But since wake_up
+	 * is not called by an assembly function  (where as schedule is)
+	 * it should be safe to use it here.
+	 */
 	trace_function(wakeup_trace, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
 
 out_locked:
-- 
1.6.2.1

-- 
