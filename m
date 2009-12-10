Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbZLJI1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbZLJI1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbZLJI13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:27:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41286 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331AbZLJI12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:27:28 -0500
Date: Thu, 10 Dec 2009 09:27:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf sched: Add max delay time snapshot
Message-ID: <20091210082719.GA6834@elte.hu>
References: <1260391208-6808-1-git-send-regression-fweisbec@gmail.com>
 <4B206A18.2030607@cn.fujitsu.com>
 <20091210072351.GF16874@elte.hu>
 <4B20AE32.1090602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B20AE32.1090602@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> 
> 
> Ingo Molnar wrote:
> > * Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> > 
> >> Frederic Weisbecker wrote:
> >>
> >>> When we have a maximum latency reported for a task, we need a 
> >>> convenient way to find the matching location to the raw traces or to 
> >>> perf sched map that shows where the task has been eventually 
> >>> scheduled in. This gives a pointer to retrieve the events that 
> >>> occured during this max latency.
> >> Then, we can cooperate with ftrace's data to know what the cpu is 
> >> doing at that time.
> > 
> > What do you mean by mixing it with ftrace data? These events ought to be 
> > a full replacement for the sched and wakeup tracers. In the long run we 
> > want a single stream of events and phase out most of the pretty-printing 
> > ftrace plugins.
> 
> Hi Ingo,
> 
> I think sometimes perf tool cooperate with ftrace can do more useful 
> things, take this case for example:
> 
> By 'perf sched latency' we can get the schedule latency time, if the 
> time is abnormal, then we can run this command and enable function 
> tracer.
> 
> After running, 'perf sched latency' can show us the timestamps when 
> the maximum latency(the worst case) occurs, then we can find what the 
> cpu is doing at this timestamps by reading function tracer's output.

Actually, i think the natural solution here is not any ugly interaction 
between two largely disjunct sets of APIs, but a new feature: to turn 
the function tracer into an event.

That would allow perf sched to also record function traces if so 
desired. And it would also allow a whole lot of other things - mixing 
function tracer events and other events.

As a starter we could create a new function tracer event. A crude 
prototype hack is attached below - via that it should already be 
possible to 'count' function calls via:

  perf stat -a --repeat 3 -e context-switches sleep 1

( obviously the real patch would introduce PERF_COUNT_SW_FUNCTION_CALLS, 
  but you get the point. )

	Ingo

---
 include/trace/events/function.h |   33 +++++++++++++++++++++++++++++++++
 kernel/trace/ftrace.c           |   15 +++++++++++++++
 2 files changed, 48 insertions(+)

Index: linux/include/trace/events/function.h
===================================================================
--- /dev/null
+++ linux/include/trace/events/function.h
@@ -0,0 +1,33 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM function
+
+#if !defined(_TRACE_FUNCTION_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_FUNCTION_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(function_call,
+
+	TP_PROTO(unsigned long ip, unsigned long parent_ip),
+
+	TP_ARGS(ip, parent_ip),
+
+	TP_STRUCT__entry(
+		__field(	u64,		ip		)
+		__field(	u64,		parent_ip	)
+	),
+
+	TP_fast_assign(
+		__entry->ip		= ip;
+		__entry->parent_ip	= parent_ip;
+	),
+
+	TP_printk("IP: %016Lx, parent IP: %016Lx",
+		__entry->ip,
+		__entry->parent_ip)
+);
+
+#endif /* _TRACE_FUNCTION_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
Index: linux/kernel/trace/ftrace.c
===================================================================
--- linux.orig/kernel/trace/ftrace.c
+++ linux/kernel/trace/ftrace.c
@@ -2769,9 +2769,24 @@ void __init ftrace_init(void)
 
 #else
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/function.h>
+
+static void perf_ftrace_func(unsigned long ip, unsigned long parent_ip)
+{
+	struct pt_regs *regs = task_pt_regs(current);
+
+	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, regs, 0);
+}
+
 static int __init ftrace_nodyn_init(void)
 {
 	ftrace_enabled = 1;
+
+	printk("enabling function tracer test\n");
+
+	ftrace_trace_function = perf_ftrace_func;
+
 	return 0;
 }
 device_initcall(ftrace_nodyn_init);
