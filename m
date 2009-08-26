Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbZHZTsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbZHZTsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZHZTsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:48:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51101 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZHZTsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:48:45 -0400
Date: Wed, 26 Aug 2009 15:48:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
In-Reply-To: <20090826181758.GA30248@Krystal>
Message-ID: <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com>
References: <1251197235.7538.1142.camel@twins> <1251211963.7538.1164.camel@twins> <4A94D3A8.1090902@cn.fujitsu.com> <1251269207.7538.1217.camel@twins> <1251270092.7538.1226.camel@twins> <4A94DFF4.5030301@cn.fujitsu.com> <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com>
 <20090826164624.GA21456@Krystal> <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com> <20090826180114.GA29130@Krystal> <20090826181758.GA30248@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, 26 Aug 2009, Mathieu Desnoyers wrote:

> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > 
> > > This patch solves the problem that Li originally reported. If something 
> > > registers a trace point belonging to a module, then it ups the ref count 
> > > of the module. This prevents a process from registering a probe to a 
> > > tracepoint belonging to a module and then having the module disappear.
> > > 
> > > Doing the example with perf in Li's original post, now errors on the 
> > > rmmod, with "ERROR: Module trace_events_sample is in use".
> > > 
> > > Mathieu, can I have your acked-by on this?
> > > 
> > 
> > Sorry, it looks buggy.

Well, it is not that buggy. It would only prevent modules from unloading 
if another tracepoint with the same name and parameters had a probe 
registered. More of a too big of a tent deal.

> > 
> > It does not deal with the fact that tracepoints with the same name and
> > arguments can be present in more than one module, or in a combination of
> > kernel core and modules.
> > 
> > The struct tracepoint_entry is specific to a a tracepoint name, used for
> > registration, but is eventually tied to all tracepoint instrumentation
> > instances for this tracepoint name.
> > 

Anyway, this prevents your tracepoints from doing the odd things of 
loading a probe before it exists. Well you can, but then you prevent the 
unload of the module that registered it. Fine, I chucked out that patch.

> 
> Looking at the original post:
> http://lkml.org/lkml/2009/8/24/5
> 
> the problem seems to be caused by the fact that the
> trace_event_profile.c keeps some knowledge of modules in internal data
> structures, but does not get notified of module unloads. Why don't we
> fix that instead ?
> 
> A quick glance at it seems to indicate that it lazily discovers new
> modules when the tracepoints are hit. Using module load/unload notifiers
> would be more appropriate. Or maybe adding a notifier call to
> tracepoint.c, calling notification callbacks for probe modules which
> need to know when the connected tracepoints are changing
> (when they are connected/disconnected) would probably be even more
> appropriate. As a result, it would remove the dynamic verification cost
> implied by lazy data structure lookup and check each time the probe is
> fired.

Peter is correct that he should not need to worry about modules, he 
doesn't build kernels with them ;-)

Here's another patch that moves the module ref count administration to the 
trace events themselves. This should satisfy both you and Peter.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1b1f742..3f7c5dc 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -390,6 +390,20 @@ static inline int ftrace_get_offsets_##call(				\
  *
  */
 
+#ifdef MODULE
+# define event_trace_up_ref()					\
+	do {							\
+		if (!try_module_get(THIS_MODULE)) {		\
+			atomic_dec(&event_call->profile_count);	\
+			return -1;				\
+		}						\
+	} while (0)
+# define event_trace_down_ref() module_put(THIS_MODULE)
+#else
+# define event_trace_up_ref() do { } while (0)
+# define event_trace_down_ref() do { } while (0)
+#endif
+		
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
 									\
@@ -399,16 +413,20 @@ static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
 {									\
 	int ret = 0;							\
 									\
-	if (!atomic_inc_return(&event_call->profile_count))		\
+	if (!atomic_inc_return(&event_call->profile_count)) {		\
+		event_trace_up_ref();					\
 		ret = register_trace_##call(ftrace_profile_##call);	\
+	}								\
 									\
 	return ret;							\
 }									\
 									\
 static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
 {									\
-	if (atomic_add_negative(-1, &event_call->profile_count))	\
+	if (atomic_add_negative(-1, &event_call->profile_count)) {	\
 		unregister_trace_##call(ftrace_profile_##call);		\
+		event_trace_down_ref();					\
+	}								\
 }
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
