Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZI1Pie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZI1Pie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 11:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbZI1Pid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 11:38:33 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:47200 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZI1Pid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 11:38:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aHDeEh8RLSRvfMCYE0p8ApQVfbnNbpTqETRxOr9MmuUZxhP62ttk8rQNor+IO3WD0I
         7u3rxMRNYuBaX4+hleDbntmZiPHSgPqoxhKq+r8yiijHEd1HkCtJ77x1cha68KnUFu74
         O+ViuYQtP+RkRBZjdUjtkyOINF3ph39UHVRjQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] tracing: Pushdown the bkl tracepoints calls
Date: Mon, 28 Sep 2009 17:38:35 +0200
Message-Id: <1254152315-10324-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull this patch from

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

It should fix the crash you have reported few days ago.

Thanks.

---
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 28 Sep 2009 17:12:49 +0200
Subject: [PATCH] tracing: Pushdown the bkl tracepoints calls

Currently we are calling the bkl tracepoint callbacks just before the
bkl lock/unlock operations, ie the tracepoint call is not inside a
lock_kernel() function but inside a lock_kernel() macro. Hence the
bkl trace event header must be included from smp_lock.h. This raises
some nasty circular header dependencies:

linux/smp_lock.h -> trace/events/bkl.h -> trace/define_trace.h
-> trace/ftrace.h -> linux/ftrace_event.h -> linux/hardirq.h
-> linux/smp_lock.h

This results in incomplete event declarations, spurious event
definitions and other kind of funny behaviours.

This is hardly fixable without ugly workarounds. So instead, we push
the file name, line number and function name as lock_kernel()
parameters, so that we only deal with the trace event header from
lib/kernel_lock.c

This adds two parameters to lock_kernel() and unlock_kernel() but
it should be fine wrt to performances because this pair dos not seem
to be called in fast paths.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/smp_lock.h |   28 +++++++++++++++-------------
 lib/kernel_lock.c        |   15 +++++++++++----
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index d48cc77..2ea1dd1 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -3,7 +3,6 @@
 
 #ifdef CONFIG_LOCK_KERNEL
 #include <linux/sched.h>
-#include <trace/events/bkl.h>
 
 #define kernel_locked()		(current->lock_depth >= 0)
 
@@ -25,18 +24,21 @@ static inline int reacquire_kernel_lock(struct task_struct *task)
 	return 0;
 }
 
-extern void __lockfunc _lock_kernel(void)	__acquires(kernel_lock);
-extern void __lockfunc _unlock_kernel(void)	__releases(kernel_lock);
+extern void __lockfunc
+_lock_kernel(const char *func, const char *file, int line)
+__acquires(kernel_lock);
 
-#define lock_kernel()	{					\
-	trace_lock_kernel(__func__, __FILE__, __LINE__);	\
-	_lock_kernel();						\
-}
+extern void __lockfunc
+_unlock_kernel(const char *func, const char *file, int line)
+__releases(kernel_lock);
 
-#define unlock_kernel()	{					\
-	trace_unlock_kernel(__func__, __FILE__, __LINE__);	\
-	_unlock_kernel();					\
-}
+#define lock_kernel() do {					\
+	_lock_kernel(__func__, __FILE__, __LINE__);		\
+} while (0)
+
+#define unlock_kernel()	do {					\
+	_unlock_kernel(__func__, __FILE__, __LINE__);		\
+} while (0)
 
 /*
  * Various legacy drivers don't really need the BKL in a specific
@@ -52,8 +54,8 @@ static inline void cycle_kernel_lock(void)
 
 #else
 
-#define lock_kernel()	   trace_lock_kernel(__func__, __FILE__, __LINE__);
-#define unlock_kernel()    trace_unlock_kernel(__func__, __FILE__, __LINE__);
+#define lock_kernel()
+#define unlock_kernel()
 #define release_kernel_lock(task)		do { } while(0)
 #define cycle_kernel_lock()			do { } while(0)
 #define reacquire_kernel_lock(task)		0
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index 5c10b2e..4ebfa5a 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -8,9 +8,11 @@
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/semaphore.h>
-#define CREATE_TRACE_POINTS
 #include <linux/smp_lock.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/bkl.h>
+
 /*
  * The 'big kernel lock'
  *
@@ -114,19 +116,24 @@ static inline void __unlock_kernel(void)
  * This cannot happen asynchronously, so we only need to
  * worry about other CPU's.
  */
-void __lockfunc _lock_kernel(void)
+void __lockfunc _lock_kernel(const char *func, const char *file, int line)
 {
-	int depth = current->lock_depth+1;
+	int depth = current->lock_depth + 1;
+
+	trace_lock_kernel(func, file, line);
+
 	if (likely(!depth))
 		__lock_kernel();
 	current->lock_depth = depth;
 }
 
-void __lockfunc _unlock_kernel(void)
+void __lockfunc _unlock_kernel(const char *func, const char *file, int line)
 {
 	BUG_ON(current->lock_depth < 0);
 	if (likely(--current->lock_depth < 0))
 		__unlock_kernel();
+
+	trace_unlock_kernel(func, file, line);
 }
 
 EXPORT_SYMBOL(_lock_kernel);
-- 
1.6.2.3



