Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbZLKSmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbZLKSmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758751AbZLKSmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:42:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538AbZLKSmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:42:08 -0500
X-Authority-Analysis: v=1.0 c=1 a=qY3VkKIYxfYA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=j-baPurlkPwlJg604FMA:9 a=7tLuO0XP84qYnWHzJxYA:7 a=HRyV5GRZo0GEibRVFkrIqdr3Dd0A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091211184213.138039608@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 11 Dec 2009 13:40:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] [PATCH 2/2] tracing: Add stack trace to irqsoff tracer
References: <20091211184018.738768739@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Add-stack-trace-to-irqsoff-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The irqsoff and friends tracers help in finding causes of latency in the
kernel. The also work with the function tracer to show what was happening
when interrupts or preemption are disabled. But the function tracer has
a bit of an overhead and can cause exagerated readings.

Currently, when tracing with /proc/sys/kernel/ftrace_enabled = 0, where the
function tracer is disabled, the information that is provided can end up
being useless. For example, a 2 and a half millisecond latency only showed:

 # tracer: preemptirqsoff
 #
 # preemptirqsoff latency trace v1.1.5 on 2.6.32
 # --------------------------------------------------------------------
 # latency: 2463 us, #4/4, CPU#2 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
 #    -----------------
 #    | task: -4242 (uid:0 nice:0 policy:0 rt_prio:0)
 #    -----------------
 #  => started at: _spin_lock_irqsave
 #  => ended at:   remove_wait_queue
 #
 #
 #                  _------=> CPU#
 #                 / _-----=> irqs-off
 #                | / _----=> need-resched
 #                || / _---=> hardirq/softirq
 #                ||| / _--=> preempt-depth
 #                |||| /_--=> lock-depth
 #                |||||/     delay
 #  cmd     pid   |||||| time  |   caller
 #     \   /      ||||||   \   |   /
 hackbenc-4242    2d....    0us!: trace_hardirqs_off <-_spin_lock_irqsave
 hackbenc-4242    2...1. 2463us+: _spin_unlock_irqrestore <-remove_wait_queue
 hackbenc-4242    2...1. 2466us : trace_preempt_on <-remove_wait_queue

The above lets us know that hackbench with pid 2463 grabbed a spin lock
somewhere and enabled preemption at remove_wait_queue. This helps a little
but where this actually happened is not informative.

This patch adds the stack dump to the end of the irqsoff tracer. This provides
the following output:

 hackbenc-4242    2d....    0us!: trace_hardirqs_off <-_spin_lock_irqsave
 hackbenc-4242    2...1. 2463us+: _spin_unlock_irqrestore <-remove_wait_queue
 hackbenc-4242    2...1. 2466us : trace_preempt_on <-remove_wait_queue
 hackbenc-4242    2...1. 2467us : <stack trace>
  => sub_preempt_count
  => _spin_unlock_irqrestore
  => remove_wait_queue
  => free_poll_entry
  => poll_freewait
  => do_sys_poll
  => sys_poll
  => system_call_fastpath

Now we see that the culprit of this latency was the free_poll_entry code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_irqsoff.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 3aa7eaa..2974bc7 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -151,6 +151,8 @@ check_critical_timing(struct trace_array *tr,
 		goto out_unlock;
 
 	trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
+	/* Skip 5 functions to get to the irq/preempt enable function */
+	__trace_stack(tr, flags, 5, pc);
 
 	if (data->critical_sequence != max_sequence)
 		goto out_unlock;
-- 
1.6.5


