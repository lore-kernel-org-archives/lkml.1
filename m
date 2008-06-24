Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbYFXF6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbYFXF6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYFXF6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:58:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbYFXF6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:58:35 -0400
Date: Tue, 24 Jun 2008 01:58:34 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
cc: davem@davemloft.net
Subject: [5/10 PATCH] inline __wake_up
In-Reply-To: <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
Message-ID: <Pine.LNX.4.64.0806240158090.27784@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
 <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inline __wake_up and __wake_up_locked.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc7-devel/include/linux/wait.h
===================================================================
--- linux-2.6.26-rc7-devel.orig/include/linux/wait.h	2008-06-24 07:37:25.000000000 +0200
+++ linux-2.6.26-rc7-devel/include/linux/wait.h	2008-06-24 07:37:31.000000000 +0200
@@ -177,8 +177,7 @@
  	list_del(&old->task_list);
  }

-void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
-extern void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
+void __wake_up_common(wait_queue_head_t *q, unsigned int mode, int nr_exclusive, int sync, void *key);
  extern void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
  int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
  int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
@@ -186,6 +185,31 @@
  int out_of_line_wait_on_bit_lock(void *, int, int (*)(void *), unsigned);
  wait_queue_head_t *bit_waitqueue(void *, int);

+/**
+ * __wake_up - wake up threads blocked on a waitqueue.
+ * @q: the waitqueue
+ * @mode: which threads
+ * @nr_exclusive: how many wake-one or wake-many threads to wake up
+ * @key: is directly passed to the wakeup function
+ */
+static __always_inline void __wake_up(wait_queue_head_t *q, unsigned int mode,
+			     int nr_exclusive, void *key)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+	__wake_up_common(q, mode, nr_exclusive, 0, key);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+
+/*
+ * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
+ */
+static __always_inline void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
+{
+	__wake_up_common(q, mode, 1, 0, NULL);
+}
+
  static __always_inline void __wake_up_bit(wait_queue_head_t *wq, void *word, int bit)
  {
  	struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
Index: linux-2.6.26-rc7-devel/kernel/sched.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/kernel/sched.c	2008-06-24 07:28:11.000000000 +0200
+++ linux-2.6.26-rc7-devel/kernel/sched.c	2008-06-24 07:37:31.000000000 +0200
@@ -4284,8 +4284,8 @@
   * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
   * zero in this (rare) case, and we handle it by continuing to scan the queue.
   */
-static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
-			     int nr_exclusive, int sync, void *key)
+void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
+		      int nr_exclusive, int sync, void *key)
  {
  	wait_queue_t *curr, *next;

@@ -4297,32 +4297,7 @@
  			break;
  	}
  }
-
-/**
- * __wake_up - wake up threads blocked on a waitqueue.
- * @q: the waitqueue
- * @mode: which threads
- * @nr_exclusive: how many wake-one or wake-many threads to wake up
- * @key: is directly passed to the wakeup function
- */
-void __wake_up(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, void *key)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, 0, key);
-	spin_unlock_irqrestore(&q->lock, flags);
-}
-EXPORT_SYMBOL(__wake_up);
-
-/*
- * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
- */
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
-{
-	__wake_up_common(q, mode, 1, 0, NULL);
-}
+EXPORT_SYMBOL(__wake_up_common);

  /**
   * __wake_up_sync - wake up threads blocked on a waitqueue.

