Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbYKNXC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbYKNXC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYKNXAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:23 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52190 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbYKNXAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:19 -0500
Message-Id: <20081114224949.433180622@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:47 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 14/16] Tracepoints : add DECLARE_TRACE() and DEFINE_TRACE()
Content-Disposition: inline; filename=tracepoints-add-define.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DEFINE_TRACE() to tracepoints to let them declare the tracepoint structure
in a single spot for all the kernel. It helps reducing memory consumption,
especially when declaring a lot of tracepoints, e.g. for kmalloc tracing.

*API CHANGE WARNING* : now, DECLARE_TRACE() must be used in headers for
tracepoint declarations rather than DEFINE_TRACE(). This is the sane way to do
it. The name previously used was misleading.

Updates scheduler instrumentation to follow this API change.

Impact: API *CHANGE*. Must update all tracepoint users.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 Documentation/tracepoints.txt           |    7 +++++-
 include/asm-generic/vmlinux.lds.h       |    1 
 include/linux/tracepoint.h              |   35 ++++++++++++++++++++++----------
 include/trace/sched.h                   |   24 ++++++++++-----------
 kernel/exit.c                           |    4 +++
 kernel/fork.c                           |    2 +
 kernel/kthread.c                        |    3 ++
 kernel/sched.c                          |    6 +++++
 kernel/signal.c                         |    2 +
 samples/tracepoints/tp-samples-trace.h  |    4 +--
 samples/tracepoints/tracepoint-sample.c |    3 ++
 11 files changed, 66 insertions(+), 25 deletions(-)

Index: linux.trees.git/include/linux/tracepoint.h
===================================================================
--- linux.trees.git.orig/include/linux/tracepoint.h	2008-11-14 17:40:39.000000000 -0500
+++ linux.trees.git/include/linux/tracepoint.h	2008-11-14 17:40:54.000000000 -0500
@@ -24,8 +24,12 @@ struct tracepoint {
 	const char *name;		/* Tracepoint name */
 	int state;			/* State. */
 	void **funcs;
-} __attribute__((aligned(8)));
-
+} __attribute__((aligned(32)));		/*
+					 * Aligned on 32 bytes because it is
+					 * globally visible and gcc happily
+					 * align these on the structure size.
+					 * Keep in sync with vmlinux.lds.h.
+					 */
 
 #define TPPROTO(args...)	args
 #define TPARGS(args...)		args
@@ -55,15 +59,10 @@ struct tracepoint {
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  */
-#define DEFINE_TRACE(name, proto, args)					\
+#define DECLARE_TRACE(name, proto, args)				\
+	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		static const char __tpstrtab_##name[]			\
-		__attribute__((section("__tracepoints_strings")))	\
-		= #name;						\
-		static struct tracepoint __tracepoint_##name		\
-		__attribute__((section("__tracepoints"), aligned(8))) =	\
-		{ __tpstrtab_##name, 0, NULL };				\
 		if (unlikely(__tracepoint_##name.state))		\
 			__DO_TRACE(&__tracepoint_##name,		\
 				TPPROTO(proto), TPARGS(args));		\
@@ -77,11 +76,23 @@ struct tracepoint {
 		return tracepoint_probe_unregister(#name, (void *)probe);\
 	}
 
+#define DEFINE_TRACE(name)						\
+	static const char __tpstrtab_##name[]				\
+	__attribute__((section("__tracepoints_strings"))) = #name;	\
+	struct tracepoint __tracepoint_##name				\
+	__attribute__((section("__tracepoints"), aligned(32))) =	\
+		{ __tpstrtab_##name, 0, NULL }
+
+#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)				\
+	EXPORT_SYMBOL_GPL(__tracepoint_##name)
+#define EXPORT_TRACEPOINT_SYMBOL(name)					\
+	EXPORT_SYMBOL(__tracepoint_##name)
+
 extern void tracepoint_update_probe_range(struct tracepoint *begin,
 	struct tracepoint *end);
 
 #else /* !CONFIG_TRACEPOINTS */
-#define DEFINE_TRACE(name, proto, args)			\
+#define DECLARE_TRACE(name, proto, args)				\
 	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
 	{ }								\
 	static inline void trace_##name(proto)				\
@@ -95,6 +106,10 @@ extern void tracepoint_update_probe_rang
 		return -ENOSYS;						\
 	}
 
+#define DEFINE_TRACE(name)
+#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
+#define EXPORT_TRACEPOINT_SYMBOL(name)
+
 static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	struct tracepoint *end)
 { }
Index: linux.trees.git/Documentation/tracepoints.txt
===================================================================
--- linux.trees.git.orig/Documentation/tracepoints.txt	2008-11-14 17:37:14.000000000 -0500
+++ linux.trees.git/Documentation/tracepoints.txt	2008-11-14 17:40:54.000000000 -0500
@@ -42,7 +42,7 @@ In include/trace/subsys.h :
 
 #include <linux/tracepoint.h>
 
-DEFINE_TRACE(subsys_eventname,
+DECLARE_TRACE(subsys_eventname,
 	TPPTOTO(int firstarg, struct task_struct *p),
 	TPARGS(firstarg, p));
 
@@ -50,6 +50,8 @@ In subsys/file.c (where the tracing stat
 
 #include <trace/subsys.h>
 
+DEFINE_TRACE(subsys_eventname);
+
 void somefct(void)
 {
 	...
@@ -86,6 +88,9 @@ to limit collisions. Tracepoint names ar
 considered as being the same whether they are in the core kernel image or in
 modules.
 
+If the tracepoint has to be used in kernel modules, an
+EXPORT_TRACEPOINT_SYMBOL_GPL() or EXPORT_TRACEPOINT_SYMBOL() can be used to
+export the defined tracepoints.
 
 * Probe / tracepoint example
 
Index: linux.trees.git/samples/tracepoints/tracepoint-sample.c
===================================================================
--- linux.trees.git.orig/samples/tracepoints/tracepoint-sample.c	2008-11-14 17:37:14.000000000 -0500
+++ linux.trees.git/samples/tracepoints/tracepoint-sample.c	2008-11-14 17:40:54.000000000 -0500
@@ -13,6 +13,9 @@
 #include <linux/proc_fs.h>
 #include "tp-samples-trace.h"
 
+DEFINE_TRACE(subsys_event);
+DEFINE_TRACE(subsys_eventb);
+
 struct proc_dir_entry *pentry_example;
 
 static int my_open(struct inode *inode, struct file *file)
Index: linux.trees.git/samples/tracepoints/tp-samples-trace.h
===================================================================
--- linux.trees.git.orig/samples/tracepoints/tp-samples-trace.h	2008-11-14 17:37:14.000000000 -0500
+++ linux.trees.git/samples/tracepoints/tp-samples-trace.h	2008-11-14 17:40:54.000000000 -0500
@@ -4,10 +4,10 @@
 #include <linux/proc_fs.h>	/* for struct inode and struct file */
 #include <linux/tracepoint.h>
 
-DEFINE_TRACE(subsys_event,
+DECLARE_TRACE(subsys_event,
 	TPPROTO(struct inode *inode, struct file *file),
 	TPARGS(inode, file));
-DEFINE_TRACE(subsys_eventb,
+DECLARE_TRACE(subsys_eventb,
 	TPPROTO(void),
 	TPARGS());
 #endif
Index: linux.trees.git/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux.trees.git.orig/include/asm-generic/vmlinux.lds.h	2008-11-14 17:38:29.000000000 -0500
+++ linux.trees.git/include/asm-generic/vmlinux.lds.h	2008-11-14 17:40:54.000000000 -0500
@@ -71,6 +71,7 @@
 	VMLINUX_SYMBOL(__start___markers) = .;				\
 	*(__markers)							\
 	VMLINUX_SYMBOL(__stop___markers) = .;				\
+	. = ALIGN(32);							\
 	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
 	*(__tracepoints)						\
 	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
Index: linux.trees.git/include/trace/sched.h
===================================================================
--- linux.trees.git.orig/include/trace/sched.h	2008-11-14 17:37:14.000000000 -0500
+++ linux.trees.git/include/trace/sched.h	2008-11-14 17:40:54.000000000 -0500
@@ -4,52 +4,52 @@
 #include <linux/sched.h>
 #include <linux/tracepoint.h>
 
-DEFINE_TRACE(sched_kthread_stop,
+DECLARE_TRACE(sched_kthread_stop,
 	TPPROTO(struct task_struct *t),
 		TPARGS(t));
 
-DEFINE_TRACE(sched_kthread_stop_ret,
+DECLARE_TRACE(sched_kthread_stop_ret,
 	TPPROTO(int ret),
 		TPARGS(ret));
 
-DEFINE_TRACE(sched_wait_task,
+DECLARE_TRACE(sched_wait_task,
 	TPPROTO(struct rq *rq, struct task_struct *p),
 		TPARGS(rq, p));
 
-DEFINE_TRACE(sched_wakeup,
+DECLARE_TRACE(sched_wakeup,
 	TPPROTO(struct rq *rq, struct task_struct *p),
 		TPARGS(rq, p));
 
-DEFINE_TRACE(sched_wakeup_new,
+DECLARE_TRACE(sched_wakeup_new,
 	TPPROTO(struct rq *rq, struct task_struct *p),
 		TPARGS(rq, p));
 
-DEFINE_TRACE(sched_switch,
+DECLARE_TRACE(sched_switch,
 	TPPROTO(struct rq *rq, struct task_struct *prev,
 		struct task_struct *next),
 		TPARGS(rq, prev, next));
 
-DEFINE_TRACE(sched_migrate_task,
+DECLARE_TRACE(sched_migrate_task,
 	TPPROTO(struct rq *rq, struct task_struct *p, int dest_cpu),
 		TPARGS(rq, p, dest_cpu));
 
-DEFINE_TRACE(sched_process_free,
+DECLARE_TRACE(sched_process_free,
 	TPPROTO(struct task_struct *p),
 		TPARGS(p));
 
-DEFINE_TRACE(sched_process_exit,
+DECLARE_TRACE(sched_process_exit,
 	TPPROTO(struct task_struct *p),
 		TPARGS(p));
 
-DEFINE_TRACE(sched_process_wait,
+DECLARE_TRACE(sched_process_wait,
 	TPPROTO(struct pid *pid),
 		TPARGS(pid));
 
-DEFINE_TRACE(sched_process_fork,
+DECLARE_TRACE(sched_process_fork,
 	TPPROTO(struct task_struct *parent, struct task_struct *child),
 		TPARGS(parent, child));
 
-DEFINE_TRACE(sched_signal_send,
+DECLARE_TRACE(sched_signal_send,
 	TPPROTO(int sig, struct task_struct *p),
 		TPARGS(sig, p));
 
Index: linux.trees.git/kernel/sched.c
===================================================================
--- linux.trees.git.orig/kernel/sched.c	2008-11-14 17:38:29.000000000 -0500
+++ linux.trees.git/kernel/sched.c	2008-11-14 17:40:54.000000000 -0500
@@ -118,6 +118,12 @@
  */
 #define RUNTIME_INF	((u64)~0ULL)
 
+DEFINE_TRACE(sched_wait_task);
+DEFINE_TRACE(sched_wakeup);
+DEFINE_TRACE(sched_wakeup_new);
+DEFINE_TRACE(sched_switch);
+DEFINE_TRACE(sched_migrate_task);
+
 #ifdef CONFIG_SMP
 /*
  * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
Index: linux.trees.git/kernel/exit.c
===================================================================
--- linux.trees.git.orig/kernel/exit.c	2008-11-14 17:38:29.000000000 -0500
+++ linux.trees.git/kernel/exit.c	2008-11-14 17:40:54.000000000 -0500
@@ -54,6 +54,10 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
+DEFINE_TRACE(sched_process_free);
+DEFINE_TRACE(sched_process_exit);
+DEFINE_TRACE(sched_process_wait);
+
 static void exit_mm(struct task_struct * tsk);
 
 static inline int task_detached(struct task_struct *p)
Index: linux.trees.git/kernel/fork.c
===================================================================
--- linux.trees.git.orig/kernel/fork.c	2008-11-14 17:38:29.000000000 -0500
+++ linux.trees.git/kernel/fork.c	2008-11-14 17:40:54.000000000 -0500
@@ -80,6 +80,8 @@ DEFINE_PER_CPU(unsigned long, process_co
 
 __cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
 
+DEFINE_TRACE(sched_process_fork);
+
 int nr_processes(void)
 {
 	int cpu;
Index: linux.trees.git/kernel/kthread.c
===================================================================
--- linux.trees.git.orig/kernel/kthread.c	2008-11-14 17:37:14.000000000 -0500
+++ linux.trees.git/kernel/kthread.c	2008-11-14 17:40:54.000000000 -0500
@@ -21,6 +21,9 @@ static DEFINE_SPINLOCK(kthread_create_lo
 static LIST_HEAD(kthread_create_list);
 struct task_struct *kthreadd_task;
 
+DEFINE_TRACE(sched_kthread_stop);
+DEFINE_TRACE(sched_kthread_stop_ret);
+
 struct kthread_create_info
 {
 	/* Information passed to kthread() from kthreadd. */
Index: linux.trees.git/kernel/signal.c
===================================================================
--- linux.trees.git.orig/kernel/signal.c	2008-11-14 17:37:13.000000000 -0500
+++ linux.trees.git/kernel/signal.c	2008-11-14 17:40:54.000000000 -0500
@@ -41,6 +41,8 @@
 
 static struct kmem_cache *sigqueue_cachep;
 
+DEFINE_TRACE(sched_signal_send);
+
 static void __user *sig_handler(struct task_struct *t, int sig)
 {
 	return t->sighand->action[sig - 1].sa.sa_handler;

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
