Return-Path: <linux-kernel-owner+w=401wt.eu-S1759704AbYGKBAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704AbYGKBAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbYGKA7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:59:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbYGKA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:59:52 -0400
Message-Id: <20080711005950.252598349@goodmis.org>
References: <20080711005808.316194101@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 20:58:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/8] ftrace: move sched_switch enable after markers
Content-Disposition: inline; filename=ftrace-sched-enable-marker-last.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have two markers now that are enabled on sched_switch. One that records
the context switching and the other that records task wake ups. Currently
we enable the tracing first and then set the markers. This causes some
confusing traces:

# tracer: sched_switch
#
#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
#              | |      |          |         |
       trace-cmd-3973  [00]   115.834817:   3973:120:R   +     3:  0:S
       trace-cmd-3973  [01]   115.834910:   3973:120:R   +     6:  0:S
       trace-cmd-3973  [02]   115.834910:   3973:120:R   +     9:  0:S
       trace-cmd-3973  [03]   115.834910:   3973:120:R   +    12:  0:S
       trace-cmd-3973  [02]   115.834910:   3973:120:R   +     9:  0:S
          <idle>-0     [02]   115.834910:      0:140:R ==>  3973:120:R


Here we see that trace-cmd with PID 3973 wakes up task 9 but the next line
shows the idle task doing a context switch to task 3973.

Enabling the tracing to _after_ the markers are set creates a much saner
output:

# tracer: sched_switch
#
#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
#              | |      |          |         |
          <idle>-0     [02]  7922.634225:      0:140:R ==>  4790:120:R
       trace-cmd-4789  [03]  7922.634225:      0:140:R   +  4790:120:R


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_sched_switch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-tip.git/kernel/trace/trace_sched_switch.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_sched_switch.c	2008-06-30 20:56:38.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_sched_switch.c	2008-06-30 20:57:09.000000000 -0400
@@ -227,14 +227,14 @@ void tracing_stop_cmdline_record(void)
 static void start_sched_trace(struct trace_array *tr)
 {
 	sched_switch_reset(tr);
-	tracer_enabled = 1;
 	tracing_start_cmdline_record();
+	tracer_enabled = 1;
 }
 
 static void stop_sched_trace(struct trace_array *tr)
 {
-	tracing_stop_cmdline_record();
 	tracer_enabled = 0;
+	tracing_stop_cmdline_record();
 }
 
 static void sched_switch_trace_init(struct trace_array *tr)

-- 
