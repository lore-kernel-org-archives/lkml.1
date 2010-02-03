Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab0BCJOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:14:47 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57321 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab0BCJOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:14:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X3RzLa9rGuzAPXgCalA239nkk/tBRdFTJU9uNxqzwop/GrFIMqnE+dis+3jb6FifFi
         1CaRglGN8y/w/ISLBXSKIBGY05bZaoBahDhWO+fs4Qi3TQU0IPK0e7xpfrOe1pOPRlA8
         4JKjdslIox9yuWp68usAP/RfRmANf+OU+chxc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 02/11] tracing: Introduce TRACE_EVENT_INJECT
Date: Wed,  3 Feb 2010 10:14:26 +0100
Message-Id: <1265188475-23509-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TRACE_EVENT_INJECT macro is the same as TRACE_EVENT but takes one
more parameter that defines an "inject" callback to be called when
the event is enabled.

This is useful when we need to catch up with events that have
already occured but that are required for the user.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/ftrace_event.h |    1 +
 include/linux/tracepoint.h   |    3 +++
 include/trace/define_trace.h |    6 ++++++
 include/trace/ftrace.h       |   31 ++++++++++++++++++++++++++++++-
 kernel/trace/trace_events.c  |    3 +++
 5 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index cd95919..026d39b 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -126,6 +126,7 @@ struct ftrace_event_call {
 	int			(*show_format)(struct ftrace_event_call *,
 					       struct trace_seq *);
 	int			(*define_fields)(struct ftrace_event_call *);
+	void			(*inject)(void);
 	struct list_head	fields;
 	int			filter_active;
 	struct event_filter	*filter;
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index f59604e..f114aec 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -291,5 +291,8 @@ static inline void tracepoint_synchronize_unregister(void)
 #define TRACE_EVENT_FN(name, proto, args, struct,		\
 		assign, print, reg, unreg)			\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+#define TRACE_EVENT_INJECT(name, proto, args, struct,		\
+		assign, print, inject)				\
+	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
 #endif /* ifdef TRACE_EVENT (see note above) */
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 5acfb1e..41f7ce3 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -31,6 +31,11 @@
 		assign, print, reg, unreg)			\
 	DEFINE_TRACE_FN(name, reg, unreg)
 
+#undef TRACE_EVENT_INJECT
+#define TRACE_EVENT_INJECT(name, proto, args, tstruct,		\
+		assign, print, inject)				\
+	DEFINE_TRACE(name)
+
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args) \
 	DEFINE_TRACE(name)
@@ -71,6 +76,7 @@
 
 #undef TRACE_EVENT
 #undef TRACE_EVENT_FN
+#undef TRACE_EVENT_INJECT
 #undef DECLARE_EVENT_CLASS
 #undef DEFINE_EVENT
 #undef DEFINE_EVENT_PRINT
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index f2c09e4..869da37 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -37,6 +37,26 @@
 			     PARAMS(print));		       \
 	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args));
 
+/*
+ * TRACE_EVENT_INJECT creates an event that has an injector callback
+ * to call when the trace event is enabled, usually to trigger
+ * automatically some necessary initial traces.
+ */
+#undef TRACE_EVENT_INJECT
+#define TRACE_EVENT_INJECT(name, proto, args, tstruct,			\
+		assign, print, inject)					\
+		DECLARE_EVENT_CLASS(name,				\
+			     PARAMS(proto),				\
+			     PARAMS(args),		       		\
+			     PARAMS(tstruct),		       		\
+			     PARAMS(assign),		       		\
+			     PARAMS(print));		       		\
+	DEFINE_EVENT_INJECT(name, name, PARAMS(proto), PARAMS(args), inject);
+
+#undef DEFINE_EVENT_INJECT
+#define DEFINE_EVENT_INJECT(template, name, proto, args, inject)	\
+	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args));
+
 
 #undef __field
 #define __field(type, item)		type	item;
@@ -726,7 +746,11 @@ static struct trace_event ftrace_event_type_##call = {			\
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)
 
 #undef DEFINE_EVENT
-#define DEFINE_EVENT(template, call, proto, args)			\
+#define DEFINE_EVENT(template, call, proto, args)	\
+	DEFINE_EVENT_INJECT(template, call, PARAMS(proto), PARAMS(proto), NULL)
+
+#undef DEFINE_EVENT_INJECT
+#define DEFINE_EVENT_INJECT(template, call, proto, args, injector)	\
 									\
 static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
@@ -739,6 +763,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.show_format		= ftrace_format_##template,		\
 	.define_fields		= ftrace_define_fields_##template,	\
+	.inject			= injector,				\
 	_TRACE_PROFILE_INIT(call)					\
 }
 
@@ -877,6 +902,10 @@ ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
 			       __count, irq_flags);			\
 }
 
+#undef DEFINE_EVENT_INJECT
+#define DEFINE_EVENT_INJECT(template, call, proto, args, inject)	\
+	DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args))
+
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)		\
 static void ftrace_profile_##call(proto)			\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 189b09b..5c75cc7 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -142,6 +142,9 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 				break;
 			}
 			call->enabled = 1;
+
+			if (call->inject)
+				call->inject();
 		}
 		break;
 	}
-- 
1.6.2.3

