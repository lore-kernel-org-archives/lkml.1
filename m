Return-Path: <linux-kernel-owner+w=401wt.eu-S932838AbZHVE7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbZHVE7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 00:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932302AbZHVE7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 00:59:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167AbZHVE7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 00:59:16 -0400
From: Josh Stone <jistone@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Josh Stone <jistone@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH v3 3/4] tracing: Move tracepoint callbacks into DEFINE
Date: Fri, 21 Aug 2009 21:58:44 -0700
Message-Id: <1250917125-6174-4-git-send-email-jistone@redhat.com>
In-Reply-To: <1250917125-6174-3-git-send-email-jistone@redhat.com>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com>
 <1250917125-6174-1-git-send-email-jistone@redhat.com>
 <1250917125-6174-2-git-send-email-jistone@redhat.com>
 <1250917125-6174-3-git-send-email-jistone@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not strictly correct for the tracepoint reg/unreg callbacks to
occur when a client is hooking up, because the actual tracepoint may no
be present yet.  This happens to be fine for syscall, since that's in
the core kernel, but it would cause problems for tracepoints defined in
a module that hasn't been loaded yet.  It also means the reg/unreg has
to be EXPORTed for any modules to use the tracepoint (as in SystemTap).

This patch removes DECLARE_TRACE_WITH_CALLBACK, and instead introduces
DEFINE_TRACE_FN which stores the callbacks in struct tracepoint.  The
callbacks are used now when the active state of the tracepoint changes
in set_tracepoint & disable_tracepoint.

This also introduces TRACE_EVENT_FN, so those events can also provide
callbacks if needed.

Signed-off-by: Josh Stone <jistone@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 arch/s390/kernel/ptrace.c    |   17 +++++++--------
 arch/x86/kernel/ptrace.c     |   17 +++++++--------
 include/linux/tracepoint.h   |   46 ++++++++++++++++-------------------------
 include/trace/define_trace.h |    5 ++++
 include/trace/ftrace.h       |    9 ++++++++
 include/trace/syscall.h      |   15 +++----------
 kernel/tracepoint.c          |    8 +++++++
 7 files changed, 60 insertions(+), 57 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index b6dcd72..e515c8b 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -51,8 +51,11 @@
 #include "compat_ptrace.h"
 #endif
 
-DEFINE_TRACE(syscall_enter);
-DEFINE_TRACE(syscall_exit);
+static void syscall_regfunc(void);
+static void syscall_unregfunc(void);
+
+DEFINE_TRACE_FN(syscall_enter, syscall_regfunc, syscall_unregfunc);
+DEFINE_TRACE_FN(syscall_exit, syscall_regfunc, syscall_unregfunc);
 
 enum s390_regset {
 	REGSET_GENERAL,
@@ -928,15 +931,14 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 
 #ifdef CONFIG_TRACEPOINTS
 
-static DEFINE_MUTEX(regfunc_mutex);
+/* NB: reg/unreg are called while guarded with the tracepoints_mutex */
 static int sys_tracepoint_refcount;
 
-void syscall_regfunc(void)
+static void syscall_regfunc(void)
 {
 	unsigned long flags;
 	struct task_struct *g, *t;
 
-	mutex_lock(&regfunc_mutex);
 	if (!sys_tracepoint_refcount) {
 		read_lock_irqsave(&tasklist_lock, flags);
 		do_each_thread(g, t) {
@@ -945,15 +947,13 @@ void syscall_regfunc(void)
 		read_unlock_irqrestore(&tasklist_lock, flags);
 	}
 	sys_tracepoint_refcount++;
-	mutex_unlock(&regfunc_mutex);
 }
 
-void syscall_unregfunc(void)
+static void syscall_unregfunc(void)
 {
 	unsigned long flags;
 	struct task_struct *g, *t;
 
-	mutex_lock(&regfunc_mutex);
 	sys_tracepoint_refcount--;
 	if (!sys_tracepoint_refcount) {
 		read_lock_irqsave(&tasklist_lock, flags);
@@ -962,6 +962,5 @@ void syscall_unregfunc(void)
 		} while_each_thread(g, t);
 		read_unlock_irqrestore(&tasklist_lock, flags);
 	}
-	mutex_unlock(&regfunc_mutex);
 }
 #endif
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index c2adbed..cef009a 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -37,8 +37,11 @@
 
 #include <trace/syscall.h>
 
-DEFINE_TRACE(syscall_enter);
-DEFINE_TRACE(syscall_exit);
+static void syscall_regfunc(void);
+static void syscall_unregfunc(void);
+
+DEFINE_TRACE_FN(syscall_enter, syscall_regfunc, syscall_unregfunc);
+DEFINE_TRACE_FN(syscall_exit, syscall_regfunc, syscall_unregfunc);
 
 #include "tls.h"
 
@@ -1552,15 +1555,14 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 
 #ifdef CONFIG_TRACEPOINTS
 
-static DEFINE_MUTEX(regfunc_mutex);
+/* NB: reg/unreg are called while guarded with the tracepoints_mutex */
 static int sys_tracepoint_refcount;
 
-void syscall_regfunc(void)
+static void syscall_regfunc(void)
 {
 	unsigned long flags;
 	struct task_struct *g, *t;
 
-	mutex_lock(&regfunc_mutex);
 	if (!sys_tracepoint_refcount) {
 		read_lock_irqsave(&tasklist_lock, flags);
 		do_each_thread(g, t) {
@@ -1569,15 +1571,13 @@ void syscall_regfunc(void)
 		read_unlock_irqrestore(&tasklist_lock, flags);
 	}
 	sys_tracepoint_refcount++;
-	mutex_unlock(&regfunc_mutex);
 }
 
-void syscall_unregfunc(void)
+static void syscall_unregfunc(void)
 {
 	unsigned long flags;
 	struct task_struct *g, *t;
 
-	mutex_lock(&regfunc_mutex);
 	sys_tracepoint_refcount--;
 	if (!sys_tracepoint_refcount) {
 		read_lock_irqsave(&tasklist_lock, flags);
@@ -1586,6 +1586,5 @@ void syscall_unregfunc(void)
 		} while_each_thread(g, t);
 		read_unlock_irqrestore(&tasklist_lock, flags);
 	}
-	mutex_unlock(&regfunc_mutex);
 }
 #endif
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 5984ed0..846a4ae 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -23,6 +23,8 @@ struct tracepoint;
 struct tracepoint {
 	const char *name;		/* Tracepoint name */
 	int state;			/* State. */
+	void (*regfunc)(void);
+	void (*unregfunc)(void);
 	void **funcs;
 } __attribute__((aligned(32)));		/*
 					 * Aligned on 32 bytes because it is
@@ -60,10 +62,8 @@ struct tracepoint {
  * Make sure the alignment of the structure in the __tracepoints section will
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
- * An optional set of (un)registration functions can be passed to perform any
- * additional (un)registration work.
  */
-#define DECLARE_TRACE_WITH_CALLBACK(name, proto, args, reg, unreg)	\
+#define DECLARE_TRACE(name, proto, args)				\
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
@@ -73,36 +73,23 @@ struct tracepoint {
 	}								\
 	static inline int register_trace_##name(void (*probe)(proto))	\
 	{								\
-		int ret;						\
-		void (*func)(void) = reg;				\
-									\
-		ret = tracepoint_probe_register(#name, (void *)probe);	\
-		if (func && !ret)					\
-			func();						\
-		return ret;						\
+		return tracepoint_probe_register(#name, (void *)probe);	\
 	}								\
 	static inline int unregister_trace_##name(void (*probe)(proto))	\
 	{								\
-		int ret;						\
-		void (*func)(void) = unreg;				\
-									\
-		ret = tracepoint_probe_unregister(#name, (void *)probe);\
-		if (func && !ret)					\
-			func();						\
-		return ret;						\
+		return tracepoint_probe_unregister(#name, (void *)probe);\
 	}
 
 
-#define DECLARE_TRACE(name, proto, args)				 \
-	DECLARE_TRACE_WITH_CALLBACK(name, TP_PROTO(proto), TP_ARGS(args),\
-					NULL, NULL);
-
-#define DEFINE_TRACE(name)						\
+#define DEFINE_TRACE_FN(name, reg, unreg)				\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
 	struct tracepoint __tracepoint_##name				\
 	__attribute__((section("__tracepoints"), aligned(32))) =	\
-		{ __tpstrtab_##name, 0, NULL }
+		{ __tpstrtab_##name, 0, reg, unreg, NULL }
+
+#define DEFINE_TRACE(name)						\
+	DEFINE_TRACE_FN(name, NULL, NULL);
 
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)				\
 	EXPORT_SYMBOL_GPL(__tracepoint_##name)
@@ -113,7 +100,7 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 	struct tracepoint *end);
 
 #else /* !CONFIG_TRACEPOINTS */
-#define DECLARE_TRACE_WITH_CALLBACK(name, proto, args, reg, unreg)	\
+#define DECLARE_TRACE(name, proto, args)				\
 	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
 	{ }								\
 	static inline void trace_##name(proto)				\
@@ -127,10 +114,7 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 		return -ENOSYS;						\
 	}
 
-#define DECLARE_TRACE(name, proto, args)				 \
-	DECLARE_TRACE_WITH_CALLBACK(name, TP_PROTO(proto), TP_ARGS(args),\
-					NULL, NULL);
-
+#define DEFINE_TRACE_FN(name, reg, unreg)
 #define DEFINE_TRACE(name)
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
 #define EXPORT_TRACEPOINT_SYMBOL(name)
@@ -282,10 +266,16 @@ static inline void tracepoint_synchronize_unregister(void)
  * can also by used by generic instrumentation like SystemTap), and
  * it is also used to expose a structured trace record in
  * /sys/kernel/debug/tracing/events/.
+ *
+ * A set of (un)registration functions can be passed to the variant
+ * TRACE_EVENT_FN to perform any (un)registration work.
  */
 
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+#define TRACE_EVENT_FN(name, proto, args, struct,		\
+		assign, print, reg, unreg)			\
+	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #endif
 
 #endif
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index f7a7ae1..2a96985 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -26,6 +26,11 @@
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
 	DEFINE_TRACE(name)
 
+#undef TRACE_EVENT_FN
+#define TRACE_EVENT_FN(name, proto, args, tstruct,		\
+		assign, print, reg, unreg)			\
+	DEFINE_TRACE_FN(name, reg, unreg)
+
 #undef DECLARE_TRACE
 #define DECLARE_TRACE(name, proto, args)	\
 	DEFINE_TRACE(name)
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1274002..3a0b44b 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -42,6 +42,15 @@
 	};							\
 	static struct ftrace_event_call event_##name
 
+/* Callbacks are meaningless to ftrace. */
+#undef TRACE_EVENT_FN
+#define TRACE_EVENT_FN(name, proto, args, tstruct,		\
+		assign, print, reg, unreg)			\
+	TRACE_EVENT(name, TP_PROTO(proto), TP_ARGS(args),	\
+		TP_STRUCT__entry(tstruct),			\
+		TP_fast_assign(assign),				\
+		TP_printk(print))
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 9661dd4..f3d8555 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -8,21 +8,14 @@
 #include <asm/ptrace.h>
 
 
-extern void syscall_regfunc(void);
-extern void syscall_unregfunc(void);
-
-DECLARE_TRACE_WITH_CALLBACK(syscall_enter,
+DECLARE_TRACE(syscall_enter,
 	TP_PROTO(struct pt_regs *regs, long id),
-	TP_ARGS(regs, id),
-	syscall_regfunc,
-	syscall_unregfunc
+	TP_ARGS(regs, id)
 );
 
-DECLARE_TRACE_WITH_CALLBACK(syscall_exit,
+DECLARE_TRACE(syscall_exit,
 	TP_PROTO(struct pt_regs *regs, long ret),
-	TP_ARGS(regs, ret),
-	syscall_regfunc,
-	syscall_unregfunc
+	TP_ARGS(regs, ret)
 );
 
 /*
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 2ce4d38..5375e0f 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -243,6 +243,11 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 {
 	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
 
+	if (elem->regfunc && !elem->state && active)
+		elem->regfunc();
+	else if (elem->unregfunc && elem->state && !active)
+		elem->unregfunc();
+
 	/*
 	 * rcu_assign_pointer has a smp_wmb() which makes sure that the new
 	 * probe callbacks array is consistent before setting a pointer to it.
@@ -262,6 +267,9 @@ static void set_tracepoint(struct tracepoint_entry **entry,
  */
 static void disable_tracepoint(struct tracepoint *elem)
 {
+	if (elem->unregfunc && elem->state)
+		elem->unregfunc();
+
 	elem->state = 0;
 	rcu_assign_pointer(elem->funcs, NULL);
 }
-- 
1.6.2.5

