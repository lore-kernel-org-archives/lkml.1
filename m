Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab0BPQmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:42:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41592 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0BPQmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:42:10 -0500
X-Authority-Analysis: v=1.0 c=1 a=tSXP00O30wgA:10 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=lAAhZFBDmaJ15ZhOu8kA:9 a=mBKlYUeRRWfMCRKhz_AA:7 a=ZrW2ZZTmbwTl2nFvvls-Kl-bOyUA:4 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100216164207.618736078@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 16 Feb 2010 11:41:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/3] tracing: Add notrace to TRACE_EVENT implementation functions
References: <20100216164122.891864374@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Add-notrace-to-TRACE_EVENT-implementation-fu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The functions used to implement the TRACE_EVENT macro show up in
function tracing. This is considered a distraction, and these should
not be displayed. For example:

     <idle>-0     [000]    57.202149: task_of <-update_stats_wait_end
     <idle>-0     [000]    57.202149: ftrace_raw_event_sched_stat_wait <-update_stats_wait_end
     <idle>-0     [000]    57.202150: ftrace_raw_event_id_sched_stat_template <-ftrace_raw_event_sched_stat_wait
     <idle>-0     [000]    57.202150: sched_stat_wait: comm=sshd pid=2735 delay=19207 [ns]

The "ftrace_raw_event_*" traces are just the utility functions used
by TRACE_EVENT tracepoints.

Cc: Thomas Gleixner <tglx@linutronix.de>
Requested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index df65b99..09fd9af 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -199,7 +199,7 @@
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
-static enum print_line_t						\
+static notrace enum print_line_t					\
 ftrace_raw_output_id_##call(int event_id, const char *name,		\
 			    struct trace_iterator *iter, int flags)	\
 {									\
@@ -232,7 +232,7 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)			\
-static enum print_line_t						\
+static notrace enum print_line_t					\
 ftrace_raw_output_##name(struct trace_iterator *iter, int flags)	\
 {									\
 	return ftrace_raw_output_id_##template(event_##name.id,		\
@@ -241,7 +241,7 @@ ftrace_raw_output_##name(struct trace_iterator *iter, int flags)	\
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
-static enum print_line_t						\
+static notrace enum print_line_t					\
 ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 {									\
 	struct trace_seq *s = &iter->seq;				\
@@ -307,7 +307,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
-static int								\
+static int notrace							\
 ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
 	struct ftrace_raw_##call field;					\
@@ -355,7 +355,7 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
-static inline int ftrace_get_offsets_##call(				\
+static inline notrace int ftrace_get_offsets_##call(			\
 	struct ftrace_data_offsets_##call *__data_offsets, proto)       \
 {									\
 	int __data_size = 0;						\
@@ -402,12 +402,14 @@ static inline int ftrace_get_offsets_##call(				\
 									\
 static void ftrace_profile_##name(proto);				\
 									\
-static int ftrace_profile_enable_##name(struct ftrace_event_call *unused)\
+static notrace int							\
+ftrace_profile_enable_##name(struct ftrace_event_call *unused)		\
 {									\
 	return register_trace_##name(ftrace_profile_##name);		\
 }									\
 									\
-static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
+static notrace void							\
+ftrace_profile_disable_##name(struct ftrace_event_call *unused)		\
 {									\
 	unregister_trace_##name(ftrace_profile_##name);			\
 }
@@ -541,7 +543,8 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 									\
-static void ftrace_raw_event_id_##call(struct ftrace_event_call *event_call, \
+static notrace void							\
+ftrace_raw_event_id_##call(struct ftrace_event_call *event_call,	\
 				       proto)				\
 {									\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
@@ -578,17 +581,19 @@ static void ftrace_raw_event_id_##call(struct ftrace_event_call *event_call, \
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
 									\
-static void ftrace_raw_event_##call(proto)				\
+static notrace void ftrace_raw_event_##call(proto)			\
 {									\
 	ftrace_raw_event_id_##template(&event_##call, args);		\
 }									\
 									\
-static int ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)\
+static notrace int							\
+ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)		\
 {									\
 	return register_trace_##call(ftrace_raw_event_##call);		\
 }									\
 									\
-static void ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)\
+static notrace void							\
+ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)		\
 {									\
 	unregister_trace_##call(ftrace_raw_event_##call);		\
 }									\
@@ -750,7 +755,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
-static void								\
+static notrace void							\
 ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
 			    proto)					\
 {									\
@@ -820,7 +825,7 @@ end_recursion:								\
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)		\
-static void ftrace_profile_##call(proto)			\
+static notrace void ftrace_profile_##call(proto)		\
 {								\
 	struct ftrace_event_call *event_call = &event_##call;	\
 								\
-- 
1.6.5


