Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbZEUOTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbZEUOTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZEUOTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:19:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49543 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbZEUOTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:19:14 -0400
Message-Id: <20090521141914.208848802@goodmis.org>
References: <20090521141813.123165156@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 21 May 2009 10:18:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/2] ftrace: Add task_comm support for trace_event
Content-Disposition: inline; filename=0001-ftrace-Add-task_comm-support-for-trace_event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

If we use trace_event alone(without function trace, .etc),
it can't output enough task command information.

Before patch:
 # echo 1 > debugfs/tracing/events/sched/sched_switch/enable
 # cat debugfs/tracing/trace
 # tracer: nop
 #
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
            <...>-2289  [000] 526276.724790: sched_switch: task bash:2289 [120] ==> sshd:2287 [120]
            <...>-2287  [000] 526276.725231: sched_switch: task sshd:2287 [120] ==> bash:2289 [120]
            <...>-2289  [000] 526276.725452: sched_switch: task bash:2289 [120] ==> sshd:2287 [120]
            <...>-2287  [000] 526276.727181: sched_switch: task sshd:2287 [120] ==> swapper:0 [140]
           <idle>-0     [000] 526277.032734: sched_switch: task swapper:0 [140] ==> events/0:5 [115]
            <...>-5     [000] 526277.032782: sched_switch: task events/0:5 [115] ==> swapper:0 [140]
 ...

After patch:
 # tracer: nop
 #
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
             bash-2269  [000] 527347.989229: sched_switch: task bash:2269 [120] ==> sshd:2267 [120]
             sshd-2267  [000] 527347.990960: sched_switch: task sshd:2267 [120] ==> bash:2269 [120]
             bash-2269  [000] 527347.991143: sched_switch: task bash:2269 [120] ==> sshd:2267 [120]
             sshd-2267  [000] 527347.992959: sched_switch: task sshd:2267 [120] ==> swapper:0 [140]
           <idle>-0     [000] 527348.531989: sched_switch: task swapper:0 [140] ==> events/0:5 [115]
         events/0-5     [000] 527348.532115: sched_switch: task events/0:5 [115] ==> swapper:0 [140]
 ...

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
LKML-Reference: <4A14FDFE.2080402@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 9e91c4a..9b246eb 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -85,6 +85,7 @@ static void ftrace_clear_events(void)
 
 		if (call->enabled) {
 			call->enabled = 0;
+			tracing_stop_cmdline_record();
 			call->unregfunc();
 		}
 	}
@@ -99,12 +100,14 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 	case 0:
 		if (call->enabled) {
 			call->enabled = 0;
+			tracing_stop_cmdline_record();
 			call->unregfunc();
 		}
 		break;
 	case 1:
 		if (!call->enabled) {
 			call->enabled = 1;
+			tracing_start_cmdline_record();
 			call->regfunc();
 		}
 		break;
@@ -1058,6 +1061,7 @@ static void trace_module_remove_events(struct module *mod)
 			found = true;
 			if (call->enabled) {
 				call->enabled = 0;
+				tracing_stop_cmdline_record();
 				call->unregfunc();
 			}
 			if (call->event)
@@ -1262,11 +1266,13 @@ static __init void event_trace_self_tests(void)
 		}
 
 		call->enabled = 1;
+		tracing_start_cmdline_record();
 		call->regfunc();
 
 		event_test_stuff();
 
 		call->unregfunc();
+		tracing_stop_cmdline_record();
 		call->enabled = 0;
 
 		pr_cont("OK\n");
-- 
1.6.2.4

-- 
