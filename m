Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbZDQGgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbZDQGgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZDQGfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:35:46 -0400
Received: from gw.goop.org ([64.81.55.164]:36612 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752033AbZDQGfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:35:44 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: mathieu.desnoyers@polymtl.ca
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 1/4] tracing: move __DO_TRACE out of line
Date: Thu, 16 Apr 2009 23:35:36 -0700
Message-Id: <1239950139-1119-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239950139-1119-1-git-send-email-jeremy@goop.org>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Mainly simplify linux/tracepoint.h's include dependencies (removes
rcupdate.h), but it can't help with icache locality, since it
definitely moves the code out of line, rather than relying on gcc
to do it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/linux/tracepoint.h   |   21 ++++++++++-----------
 include/trace/define_trace.h |    7 +++++--
 kernel/tracepoint.c          |    6 ++++++
 3 files changed, 21 insertions(+), 13 deletions(-)

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
index 1886941..fa46100 100644
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
-- 
1.6.0.6

