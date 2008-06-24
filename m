Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbYFXF6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbYFXF6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYFXF54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:57:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYFXF5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:57:55 -0400
Date: Tue, 24 Jun 2008 01:57:52 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
cc: davem@davemloft.net
Subject: [4/10 PATCH] inline __wake_up_bit
In-Reply-To: <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
Message-ID: <Pine.LNX.4.64.0806240157060.27784@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
 <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make __wake_up_bit inlines. This requires to move task state definitions from
sched.h to wait.h

This patch has the worst size-increase impact, increasing total kernel size
by 0.2%.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc7-devel/include/linux/wait.h
===================================================================
--- linux-2.6.26-rc7-devel.orig/include/linux/wait.h	2008-06-24 07:37:20.000000000 +0200
+++ linux-2.6.26-rc7-devel/include/linux/wait.h	2008-06-24 07:37:25.000000000 +0200
@@ -25,6 +25,42 @@
  #include <asm/system.h>
  #include <asm/current.h>

+/*
+ * Task state bitmask. NOTE! These bits are also
+ * encoded in fs/proc/array.c: get_task_state().
+ *
+ * We have two separate sets of flags: task->state
+ * is about runnability, while task->exit_state are
+ * about the task exiting. Confusing, but this way
+ * modifying one set can't modify the other one by
+ * mistake.
+ */
+#define TASK_RUNNING		0
+#define TASK_INTERRUPTIBLE	1
+#define TASK_UNINTERRUPTIBLE	2
+#define __TASK_STOPPED		4
+#define __TASK_TRACED		8
+/* in tsk->exit_state */
+#define EXIT_ZOMBIE		16
+#define EXIT_DEAD		32
+/* in tsk->state again */
+#define TASK_DEAD		64
+#define TASK_WAKEKILL		128
+
+/* Convenience macros for the sake of set_task_state */
+#define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
+#define TASK_STOPPED		(TASK_WAKEKILL | __TASK_STOPPED)
+#define TASK_TRACED		(TASK_WAKEKILL | __TASK_TRACED)
+
+/* Convenience macros for the sake of wake_up */
+#define TASK_NORMAL		(TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE)
+#define TASK_ALL		(TASK_NORMAL | __TASK_STOPPED | __TASK_TRACED)
+
+/* get_task_state() */
+#define TASK_REPORT		(TASK_RUNNING | TASK_INTERRUPTIBLE | \
+				 TASK_UNINTERRUPTIBLE | __TASK_STOPPED | \
+				 __TASK_TRACED)
+
  typedef struct __wait_queue wait_queue_t;
  typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int sync, void *key);
  int default_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
@@ -144,13 +180,19 @@
  void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
  extern void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
  extern void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
-void __wake_up_bit(wait_queue_head_t *, void *, int);
  int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
  int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
  int out_of_line_wait_on_bit(void *, int, int (*)(void *), unsigned);
  int out_of_line_wait_on_bit_lock(void *, int, int (*)(void *), unsigned);
  wait_queue_head_t *bit_waitqueue(void *, int);

+static __always_inline void __wake_up_bit(wait_queue_head_t *wq, void *word, int bit)
+{
+	struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
+	if (waitqueue_active(wq))
+		__wake_up(wq, TASK_NORMAL, 1, &key);
+}
+
  /**
   * wake_up_bit - wake up a waiter on a bit
   * @word: the word being waited on, a kernel virtual address
Index: linux-2.6.26-rc7-devel/kernel/wait.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/kernel/wait.c	2008-06-24 07:37:20.000000000 +0200
+++ linux-2.6.26-rc7-devel/kernel/wait.c	2008-06-24 07:37:25.000000000 +0200
@@ -211,14 +211,6 @@
  }
  EXPORT_SYMBOL(out_of_line_wait_on_bit_lock);

-void __wake_up_bit(wait_queue_head_t *wq, void *word, int bit)
-{
-	struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
-	if (waitqueue_active(wq))
-		__wake_up(wq, TASK_NORMAL, 1, &key);
-}
-EXPORT_SYMBOL(__wake_up_bit);
-
  wait_queue_head_t *bit_waitqueue(void *word, int bit)
  {
  	const int shift = BITS_PER_LONG == 32 ? 5 : 6;
Index: linux-2.6.26-rc7-devel/include/linux/sched.h
===================================================================
--- linux-2.6.26-rc7-devel.orig/include/linux/sched.h	2008-06-24 07:28:12.000000000 +0200
+++ linux-2.6.26-rc7-devel/include/linux/sched.h	2008-06-24 07:37:26.000000000 +0200
@@ -160,42 +160,6 @@

  extern unsigned long long time_sync_thresh;

-/*
- * Task state bitmask. NOTE! These bits are also
- * encoded in fs/proc/array.c: get_task_state().
- *
- * We have two separate sets of flags: task->state
- * is about runnability, while task->exit_state are
- * about the task exiting. Confusing, but this way
- * modifying one set can't modify the other one by
- * mistake.
- */
-#define TASK_RUNNING		0
-#define TASK_INTERRUPTIBLE	1
-#define TASK_UNINTERRUPTIBLE	2
-#define __TASK_STOPPED		4
-#define __TASK_TRACED		8
-/* in tsk->exit_state */
-#define EXIT_ZOMBIE		16
-#define EXIT_DEAD		32
-/* in tsk->state again */
-#define TASK_DEAD		64
-#define TASK_WAKEKILL		128
-
-/* Convenience macros for the sake of set_task_state */
-#define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
-#define TASK_STOPPED		(TASK_WAKEKILL | __TASK_STOPPED)
-#define TASK_TRACED		(TASK_WAKEKILL | __TASK_TRACED)
-
-/* Convenience macros for the sake of wake_up */
-#define TASK_NORMAL		(TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE)
-#define TASK_ALL		(TASK_NORMAL | __TASK_STOPPED | __TASK_TRACED)
-
-/* get_task_state() */
-#define TASK_REPORT		(TASK_RUNNING | TASK_INTERRUPTIBLE | \
-				 TASK_UNINTERRUPTIBLE | __TASK_STOPPED | \
-				 __TASK_TRACED)
-
  #define task_is_traced(task)	((task->state & __TASK_TRACED) != 0)
  #define task_is_stopped(task)	((task->state & __TASK_STOPPED) != 0)
  #define task_is_stopped_or_traced(task)	\
@@ -2026,6 +1990,19 @@
  	return signal_pending(p) && __fatal_signal_pending(p);
  }

+static __always_inline int signal_pending_state(long state, struct task_struct *p)
+{
+	if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
+		return 0;
+	if (!signal_pending(p))
+		return 0;
+
+	if (state & (__TASK_STOPPED | __TASK_TRACED))
+		return 0;
+
+	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
+}
+
  static inline int need_resched(void)
  {
  	return unlikely(test_thread_flag(TIF_NEED_RESCHED));

