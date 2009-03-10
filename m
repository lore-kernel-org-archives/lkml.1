Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZCJE66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZCJE66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 00:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZCJE6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 00:58:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZCJE6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 00:58:13 -0400
Message-Id: <20090310045811.084130677@goodmis.org>
References: <20090310045710.286915983@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 00:57:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/7] tracing: use generic __stringify
Content-Disposition: inline; filename=0003-tracing-use-generic-__stringify.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

This removes the custom made STR(x) macros in the tracer and uses
the generic __stringify macro instead.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/events.c               |    4 +---
 kernel/trace/trace_events_stage_3.h |    4 ++--
 kernel/trace/trace_selftest.c       |    6 ++----
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/events.c b/kernel/trace/events.c
index f2509cb..9fc918d 100644
--- a/kernel/trace/events.c
+++ b/kernel/trace/events.c
@@ -2,9 +2,7 @@
  * This is the place to register all trace points as events.
  */
 
-/* someday this needs to go in a generic header */
-#define __STR(x) #x
-#define STR(x) __STR(x)
+#include <linux/stringify.h>
 
 #include <trace/trace_events.h>
 
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 557ca52..41b82b9 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -139,7 +139,7 @@ static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name 			= #call,				\
-	.system			= STR(TRACE_SYSTEM),			\
+	.system			= __stringify(TRACE_SYSTEM),		\
 	.regfunc		= ftrace_reg_event_##call,		\
 	.unregfunc		= ftrace_unreg_event_##call,		\
 }
@@ -225,7 +225,7 @@ static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name 			= #call,				\
-	.system			= STR(TRACE_SYSTEM),			\
+	.system			= __stringify(TRACE_SYSTEM),		\
 	.regfunc		= ftrace_reg_event_##call,		\
 	.unregfunc		= ftrace_unreg_event_##call,		\
 	.raw_init		= ftrace_raw_init_event_##call,		\
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 7238646..f907a2b 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -1,5 +1,6 @@
 /* Include in trace.c */
 
+#include <linux/stringify.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
 
@@ -100,9 +101,6 @@ static inline void warn_failed_init_tracer(struct tracer *trace, int init_ret)
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
-#define __STR(x) #x
-#define STR(x) __STR(x)
-
 /* Test dynamic code modification and ftrace filters */
 int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 					   struct trace_array *tr,
@@ -130,7 +128,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	 * start of the function names. We simply put a '*' to
 	 * accommodate them.
 	 */
-	func_name = "*" STR(DYN_FTRACE_TEST_NAME);
+	func_name = "*" __stringify(DYN_FTRACE_TEST_NAME);
 
 	/* filter only on our function */
 	ftrace_set_filter(func_name, strlen(func_name), 1);
-- 
1.6.1.3

-- 
