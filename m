Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbZEYBHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbZEYBHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 21:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZEYBG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 21:06:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54530 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZEYBG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 21:06:59 -0400
Message-ID: <4A19EE68.1050907@cn.fujitsu.com>
Date: Mon, 25 May 2009 09:03:36 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: create events only when configed
References: <4A167307.7020905@cn.fujitsu.com> <20090524210542.GD6471@nowhere>
In-Reply-To: <20090524210542.GD6471@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Fri, May 22, 2009 at 05:40:23PM +0800, Lai Jiangshan wrote:
>> There some unneeded events in debugfs/tracing/ftrace/ when the
>> corresponding CONFIG_XXXX=n.
>>
>> And when CONFIG_ENABLE_EVENT_TRACING=n, various events
>> are still created.
>>
>> Now when CONFIG_ENABLE_EVENT_TRACING=n, various events are
>> not created, trace_export.c is compiled only for creating
>> TRACEPOINTs.

I'm sorry for this incorrect changelog.
The TRACEPOINTs are not defined in trace_export.c.

>>
>> [Impact:] cleanup
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> 
> Looks good.
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> 

Thanx, changelog is rewrote

Frome: Lai Jiangshan <laijs@cn.fujitsu.com>

There some unneeded events in debugfs/tracing/ftrace/ when the
corresponding CONFIG_XXXX=n.

And when CONFIG_ENABLE_EVENT_TRACING=n, various events
are still created.

Now when CONFIG_ENABLE_EVENT_TRACING=n, various events are
not created. And TRACEPOINTs are created.

[Impact:] cleanup

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index f7a7ae1..e4e0e7a 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -52,7 +52,7 @@
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#ifdef CONFIG_EVENT_TRACING
+#ifdef CONFIG_ENABLE_EVENT_TRACING
 #include <trace/ftrace.h>
 #endif
 
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index 5e32e37..5c9813e 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -13,6 +13,7 @@ TRACE_EVENT_FORMAT(function, TRACE_FN, ftrace_entry, ignore,
 	TP_RAW_FMT(" %lx <-- %lx")
 );
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
 TRACE_EVENT_FORMAT(funcgraph_entry, TRACE_GRAPH_ENT,
 		   ftrace_graph_ent_entry, ignore,
 	TRACE_STRUCT(
@@ -30,6 +31,7 @@ TRACE_EVENT_FORMAT(funcgraph_exit, TRACE_GRAPH_RET,
 	),
 	TP_RAW_FMT("<-- %lx (%d)")
 );
+#endif
 
 TRACE_EVENT_FORMAT(wakeup, TRACE_WAKE, ctx_switch_entry, ignore,
 	TRACE_STRUCT(
@@ -66,6 +68,7 @@ TRACE_EVENT_FORMAT_NOFILTER(special, TRACE_SPECIAL, special_entry, ignore,
 	TP_RAW_FMT("(%08lx) (%08lx) (%08lx)")
 );
 
+#ifdef CONFIG_STACKTRACE
 /*
  * Stack-trace entry:
  */
@@ -101,6 +104,7 @@ TRACE_EVENT_FORMAT(user_stack, TRACE_USER_STACK, userstack_entry, ignore,
 	TP_RAW_FMT("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
 		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n")
 );
+#endif
 
 TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
 	TRACE_STRUCT(
@@ -119,6 +123,7 @@ TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
 	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
 );
 
+#ifdef CONFIG_BRANCH_TRACER
 TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned int, line, line)
@@ -130,7 +135,9 @@ TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
 	),
 	TP_RAW_FMT("%u:%s:%s (%u)")
 );
+#endif
 
+#ifdef CONFIG_HW_BRANCH_TRACER
 TRACE_EVENT_FORMAT(hw_branch, TRACE_HW_BRANCHES, hw_branch_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(u64, from, from)
@@ -138,7 +145,9 @@ TRACE_EVENT_FORMAT(hw_branch, TRACE_HW_BRANCHES, hw_branch_entry, ignore,
 	),
 	TP_RAW_FMT("from: %llx to: %llx")
 );
+#endif
 
+#ifdef CONFIG_POWER_TRACER
 TRACE_EVENT_FORMAT(power, TRACE_POWER, trace_power, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD_SIGN(ktime_t, state_data.stamp, stamp, 1)
@@ -148,7 +157,9 @@ TRACE_EVENT_FORMAT(power, TRACE_POWER, trace_power, ignore,
 	),
 	TP_RAW_FMT("%llx->%llx type:%u state:%u")
 );
+#endif
 
+#ifdef CONFIG_KMEMTRACE
 TRACE_EVENT_FORMAT(kmem_alloc, TRACE_KMEM_ALLOC, kmemtrace_alloc_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(enum kmemtrace_type_id, type_id, type_id)
@@ -171,5 +182,6 @@ TRACE_EVENT_FORMAT(kmem_free, TRACE_KMEM_FREE, kmemtrace_free_entry, ignore,
 	),
 	TP_RAW_FMT("type:%u call_site:%lx ptr:%p")
 );
+#endif
 
 #undef TRACE_SYSTEM

