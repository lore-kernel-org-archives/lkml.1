Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbZIXTto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbZIXTto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZIXTtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:49:42 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:54837 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbZIXTtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YlNFD1iB8GZlQGs+uAiyzHbnBoFqon8AMlYDhOuF8XBuafz2WA5Fv2fCt4V3qK1fQM
         tjI44+gTKBcwtc8HdO5Clb4+g6Emwuyumltai5PIAxmJR4qwt3kCWWqVbQIGsvtZzji5
         M3jwY1XOT121IsAjqjSNl8M71RetlvsE4qJVs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/5 v2] tracing/bkl: Add bkl ftrace events
Date: Thu, 24 Sep 2009 21:49:31 +0200
Message-Id: <1253821775-8618-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two events lock_kernel and unlock_kernel() to trace the bkl uses.
This opens the door for userspace tools to perform statistics about
the callsites that use it, dependencies with other locks (by pairing
the trace with lock events), use with recursivity and so on...

The {__reacquire,release}_kernel_lock() events are not traced because
these are called from schedule, thus the sched events are sufficient
to trace them.

Example of a trace:

hald-addon-stor-4152  [000]   165.875501: unlock_kernel: depth: 0, fs/block_dev.c:1358 __blkdev_put()
hald-addon-stor-4152  [000]   167.832974: lock_kernel: depth: 0, fs/block_dev.c:1167 __blkdev_get()

How to get the callsites that acquire it recursively:

cd /debug/tracing/events/bkl
echo "lock_depth > 0" > filter

firefox-4951  [001]   206.276967: unlock_kernel: depth: 1, fs/reiserfs/super.c:575 reiserfs_dirty_inode()

You can also filter by file and/or line.

v2: Use of FILTER_PTR_STRING attribute for files and lines fields to
    make them traceable.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/smp_lock.h   |   19 +++++++++++---
 include/trace/events/bkl.h |   61 ++++++++++++++++++++++++++++++++++++++++++++
 lib/kernel_lock.c          |   11 ++++---
 3 files changed, 82 insertions(+), 9 deletions(-)
 create mode 100644 include/trace/events/bkl.h

diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index 813be59..d48cc77 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -3,6 +3,7 @@
 
 #ifdef CONFIG_LOCK_KERNEL
 #include <linux/sched.h>
+#include <trace/events/bkl.h>
 
 #define kernel_locked()		(current->lock_depth >= 0)
 
@@ -24,8 +25,18 @@ static inline int reacquire_kernel_lock(struct task_struct *task)
 	return 0;
 }
 
-extern void __lockfunc lock_kernel(void)	__acquires(kernel_lock);
-extern void __lockfunc unlock_kernel(void)	__releases(kernel_lock);
+extern void __lockfunc _lock_kernel(void)	__acquires(kernel_lock);
+extern void __lockfunc _unlock_kernel(void)	__releases(kernel_lock);
+
+#define lock_kernel()	{					\
+	trace_lock_kernel(__func__, __FILE__, __LINE__);	\
+	_lock_kernel();						\
+}
+
+#define unlock_kernel()	{					\
+	trace_unlock_kernel(__func__, __FILE__, __LINE__);	\
+	_unlock_kernel();					\
+}
 
 /*
  * Various legacy drivers don't really need the BKL in a specific
@@ -41,8 +52,8 @@ static inline void cycle_kernel_lock(void)
 
 #else
 
-#define lock_kernel()				do { } while(0)
-#define unlock_kernel()				do { } while(0)
+#define lock_kernel()	   trace_lock_kernel(__func__, __FILE__, __LINE__);
+#define unlock_kernel()    trace_unlock_kernel(__func__, __FILE__, __LINE__);
 #define release_kernel_lock(task)		do { } while(0)
 #define cycle_kernel_lock()			do { } while(0)
 #define reacquire_kernel_lock(task)		0
diff --git a/include/trace/events/bkl.h b/include/trace/events/bkl.h
new file mode 100644
index 0000000..8abd620
--- /dev/null
+++ b/include/trace/events/bkl.h
@@ -0,0 +1,61 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM bkl
+
+#if !defined(_TRACE_BKL_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_BKL_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(lock_kernel,
+
+	TP_PROTO(const char *func, const char *file, int line),
+
+	TP_ARGS(func, file, line),
+
+	TP_STRUCT__entry(
+		__field(	int,		lock_depth		)
+		__field_ext(	const char *,	func, FILTER_PTR_STRING	)
+		__field_ext(	const char *,	file, FILTER_PTR_STRING	)
+		__field(	int,		line			)
+	),
+
+	TP_fast_assign(
+		/* We want to record the lock_depth after lock is acquired */
+		__entry->lock_depth = current->lock_depth + 1;
+		__entry->func = func;
+		__entry->file = file;
+		__entry->line = line;
+	),
+
+	TP_printk("depth: %d, %s:%d %s()", __entry->lock_depth,
+		  __entry->file, __entry->line, __entry->func)
+);
+
+TRACE_EVENT(unlock_kernel,
+
+	TP_PROTO(const char *func, const char *file, int line),
+
+	TP_ARGS(func, file, line),
+
+	TP_STRUCT__entry(
+		__field(int,		lock_depth)
+		__field(const char *,	func)
+		__field(const char *,	file)
+		__field(int,		line)
+	),
+
+	TP_fast_assign(
+		__entry->lock_depth = current->lock_depth;
+		__entry->func = func;
+		__entry->file = file;
+		__entry->line = line;
+	),
+
+	TP_printk("depth: %d, %s:%d %s()", __entry->lock_depth,
+		  __entry->file, __entry->line, __entry->func)
+);
+
+#endif /* _TRACE_BKL_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index 39f1029..5c10b2e 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -5,10 +5,11 @@
  * relegated to obsolescence, but used by various less
  * important (or lazy) subsystems.
  */
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/semaphore.h>
+#define CREATE_TRACE_POINTS
+#include <linux/smp_lock.h>
 
 /*
  * The 'big kernel lock'
@@ -113,7 +114,7 @@ static inline void __unlock_kernel(void)
  * This cannot happen asynchronously, so we only need to
  * worry about other CPU's.
  */
-void __lockfunc lock_kernel(void)
+void __lockfunc _lock_kernel(void)
 {
 	int depth = current->lock_depth+1;
 	if (likely(!depth))
@@ -121,13 +122,13 @@ void __lockfunc lock_kernel(void)
 	current->lock_depth = depth;
 }
 
-void __lockfunc unlock_kernel(void)
+void __lockfunc _unlock_kernel(void)
 {
 	BUG_ON(current->lock_depth < 0);
 	if (likely(--current->lock_depth < 0))
 		__unlock_kernel();
 }
 
-EXPORT_SYMBOL(lock_kernel);
-EXPORT_SYMBOL(unlock_kernel);
+EXPORT_SYMBOL(_lock_kernel);
+EXPORT_SYMBOL(_unlock_kernel);
 
-- 
1.6.2.3

