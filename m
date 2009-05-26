Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbZEZCGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbZEZCGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 22:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZEZCFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 22:05:00 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:55492 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZEZCE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 22:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uHbK7/rkwqYdAvdxCnekIFwu8pogKv+xzue85Mh3Aty+fWlHZ7IqIsefr9QCwuEbG9
         KHpI3Us2AaZAkkCI14P+iW4yYFkzDb90ChJFBvPRhHiS3LVVhEoz0CrKnoj56VFGZv8M
         8CADIFFpSJJQLvJGhTIY4TAlDe9i0urzdP/Pg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/5] ftrace: Add task_comm support for trace_event
Date: Tue, 26 May 2009 04:04:49 +0200
Message-Id: <1243303490-8019-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243303490-8019-1-git-send-email-fweisbec@gmail.com>
References: <1243303490-8019-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

If we enable a trace event alone without any tracer running (such as
function tracer, sched switch tracer, etc...) it can't output enough
task command information.

We need to use the tracing_{start/stop}_cmdline_record() helpers
which are designed to keep track of cmdlines for any tasks that
were scheduled during the tracing.

Before this patch:
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

After this patch:
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

Changelog:
v1->v2: Update Kconfig to select CONTEXT_SWITCH_TRACER in
        ENABLE_EVENT_TRACING
v2->v3: v2 can solve problem that was caused by config EVENT_TRACING
        alone, but when CONFIG_FTRACE is off and CONFIG_TRACING is
        selected by other config, compile fail happened again.
        This version solves it.

[ Impact: fix incomplete output of event tracing ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A14FDFE.2080402@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/Kconfig        |    9 +++++++--
 kernel/trace/trace_events.c |    6 ++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index f61be30..a508b9d 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -49,6 +49,11 @@ config FTRACE_NMI_ENTER
        default y
 
 config EVENT_TRACING
+	select CONTEXT_SWITCH_TRACER
+	bool
+
+config CONTEXT_SWITCH_TRACER
+	select MARKERS
 	bool
 
 config TRACING
@@ -176,10 +181,10 @@ config SCHED_TRACER
 	  This tracer tracks the latency of the highest priority task
 	  to be scheduled in, starting from the point it has woken up.
 
-config CONTEXT_SWITCH_TRACER
+config ENABLE_CONTEXT_SWITCH_TRACER
 	bool "Trace process context switches"
 	select TRACING
-	select MARKERS
+	select CONTEXT_SWITCH_TRACER
 	help
 	  This tracer gets called from the context switch and records
 	  all switching of tasks.
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
1.6.2.3

