Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbZDNXoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbZDNXoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 19:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZDNXoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 19:44:12 -0400
Received: from gw.goop.org ([64.81.55.164]:54958 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbZDNXoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 19:44:12 -0400
Message-ID: <49E51FC1.8090306@goop.org>
Date: Tue, 14 Apr 2009 16:44:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/8] tracing: create automated trace defines
References: <20090414172337.280621613@goodmis.org> <20090414172640.796858018@goodmis.org>
In-Reply-To: <20090414172640.796858018@goodmis.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about something like this:

>From f7fa71c046bc383706bf58503c4b75e05e252152 Mon Sep 17 00:00:00 2001
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Tue, 14 Apr 2009 16:41:18 -0700
Subject: [PATCH] tracing: move __DO_TRACE out of line

Mainly simplify linux/tracepoint.h's include dependencies (removes
rcupdate.h), but it can't help with icache locality, since it
definitely moves the code out of line, rather than relying on gcc
to do it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 4353f3f..1052e33 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -15,7 +15,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/rcupdate.h>
 
 struct module;
 struct tracepoint;
@@ -42,19 +41,20 @@ struct tracepoint {
  * it_func[0] is never NULL because there is at least one element in the array
  * when the array itself is non NULL.
  */
-#define __DO_TRACE(tp, proto, args)					\
-	do {								\
+#define DEFINE_DO_TRACE(name, proto, args)				\
+	void __do_trace_##name(struct tracepoint *tp, TP_PROTO(proto))	\
+	{								\
 		void **it_func;						\
 									\
 		rcu_read_lock_sched_notrace();				\
-		it_func = rcu_dereference((tp)->funcs);			\
+		it_func = rcu_dereference(tp->funcs);			\
 		if (it_func) {						\
 			do {						\
 				((void(*)(proto))(*it_func))(args);	\
 			} while (*(++it_func));				\
 		}							\
 		rcu_read_unlock_sched_notrace();			\
-	} while (0)
+	}
 
 /*
  * Make sure the alignment of the structure in the __tracepoints section will
@@ -63,11 +63,13 @@ struct tracepoint {
  */
 #define DECLARE_TRACE(name, proto, args)				\
 	extern struct tracepoint __tracepoint_##name;			\
+	extern void __do_trace_##name(struct tracepoint *tp,		\
+				      TP_PROTO(proto));			\
 	static inline void trace_##name(proto)				\
 	{								\
 		if (unlikely(__tracepoint_##name.state))		\
-			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(proto), TP_ARGS(args));	\
+			__do_trace_##name(&__tracepoint_##name,		\
+					  TP_ARGS(args));		\
 	}								\
 	static inline int register_trace_##name(void (*probe)(proto))	\
 	{								\
@@ -151,10 +153,7 @@ extern int tracepoint_get_iter_range(struct tracepoint **tracepoint,
  * probe unregistration and the end of module exit to make sure there is no
  * caller executing a probe when it is freed.
  */
-static inline void tracepoint_synchronize_unregister(void)
-{
-	synchronize_sched();
-}
+extern void tracepoint_synchronize_unregister(void);
 
 #define PARAMS(args...) args
 
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 980eb66..1a0502e 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -24,14 +24,17 @@
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
+	DEFINE_DO_TRACE(name, TP_PROTO(proto), TP_ARGS(args))	\
 	DEFINE_TRACE(name)
 
 #undef TRACE_FORMAT
-#define TRACE_FORMAT(name, proto, args, print)	\
+#define TRACE_FORMAT(name, proto, args, print)			\
+	DEFINE_DO_TRACE(name, TP_PROTO(proto), TP_ARGS(args))	\
 	DEFINE_TRACE(name)
 
 #undef DECLARE_TRACE
-#define DECLARE_TRACE(name, proto, args)	\
+#define DECLARE_TRACE(name, proto, args)			\
+	DEFINE_DO_TRACE(name, TP_PROTO(proto), TP_ARGS(args))	\
 	DEFINE_TRACE(name)
 
 #undef TRACE_INCLUDE
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 1ef5d3a..6ac1f48 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -545,6 +545,12 @@ void tracepoint_iter_reset(struct tracepoint_iter *iter)
 }
 EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
 
+void tracepoint_synchronize_unregister(void)
+{
+	synchronize_sched();
+}
+EXPORT_SYMBOL_GPL(tracepoint_synchronize_unregister);
+
 #ifdef CONFIG_MODULES
 
 int tracepoint_module_notify(struct notifier_block *self,


