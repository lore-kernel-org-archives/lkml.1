Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbZE0WgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbZE0WgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbZE0Wf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:35:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:57595 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759338AbZE0WfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:35:25 -0400
Date: Wed, 27 May 2009 22:34:59 GMT
From: tip-bot for Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, zhaolei@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       zhaolei@cn.fujitsu.com, tglx@linutronix.de
In-Reply-To: <4A14FDFE.2080402@cn.fujitsu.com>
References: <4A14FDFE.2080402@cn.fujitsu.com>
Subject: [tip:tracing/core] ftrace: Add task_comm support for trace_event
Message-ID: <tip-b11c53e12f94a46b50bccc7a1a953d7ca1d54a31@git.kernel.org>
Git-Commit-ID: b11c53e12f94a46b50bccc7a1a953d7ca1d54a31
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 22:34:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b11c53e12f94a46b50bccc7a1a953d7ca1d54a31
Gitweb:     http://git.kernel.org/tip/b11c53e12f94a46b50bccc7a1a953d7ca1d54a31
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Mon, 25 May 2009 18:11:59 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 26 May 2009 03:03:21 +0200

ftrace: Add task_comm support for trace_event

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
