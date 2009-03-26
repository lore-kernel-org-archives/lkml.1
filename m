Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbZCZOlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbZCZOlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbZCZOkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:40:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057AbZCZOkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:40:51 -0400
Date: Thu, 26 Mar 2009 10:40:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][GIT PULL] tracing/wakeup: move access to wakeup_cpu into
 spinlock
In-Reply-To: <alpine.DEB.2.00.0903260949340.17665@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903261032070.17665@gandalf.stny.rr.com>
References: <20090326122806.GA4188@in.ibm.com> <20090326132739.GB5960@nowhere> <alpine.DEB.2.00.0903260949340.17665@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I believe this is the fix for the oops that Maneesh saw. What he explains 
he did sounds like it would trigger the race. Reading the trace output
resets wakeup_task to NULL and wakeup_cpu to -1. And he hit the bug by 
just reading the trace in a while loop.

Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-1


Steven Rostedt (1):
      tracing/wakeup: move access to wakeup_cpu into spinlock

----
 kernel/trace/trace_sched_wakeup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)
---------------------------
commit 8ac070ca952d14c57e3d772e203fd117161cc596
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Mar 26 10:25:24 2009 -0400

    tracing/wakeup: move access to wakeup_cpu into spinlock
    
    Impact: fix for race condition
    
    The code had the following outside the lock:
    
            if (next != wakeup_task)
                    return;
    
            pc = preempt_count();
    
            /* The task we are waiting for is waking up */
            data = wakeup_trace->data[wakeup_cpu];
    
    On initialization, wakeup_task is NULL and wakeup_cpu -1. This code
    is not under a lock. If wakeup_task is set on another CPU as that
    task is waking up, we can see the wakeup_task before wakeup_cpu is
    set. If we read wakeup_cpu while it is still -1 then we will have
    a bad data pointer.
    
    This patch moves the reading of wakeup_cpu within the protection of
    the spinlock used to protect the writing of wakeup_cpu and wakeup_task.
    
    Reported-by: Maneesh Soni <maneesh@in.ibm.com>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 3c5ad6b..9e4ce4c 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -138,9 +138,6 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 
 	pc = preempt_count();
 
-	/* The task we are waiting for is waking up */
-	data = wakeup_trace->data[wakeup_cpu];
-
 	/* disable local data, not wakeup_cpu data */
 	cpu = raw_smp_processor_id();
 	disabled = atomic_inc_return(&wakeup_trace->data[cpu]->disabled);
@@ -154,6 +151,9 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	if (unlikely(!tracer_enabled || next != wakeup_task))
 		goto out_unlock;
 
+	/* The task we are waiting for is waking up */
+	data = wakeup_trace->data[wakeup_cpu];
+
 	trace_function(wakeup_trace, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
 	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
 


