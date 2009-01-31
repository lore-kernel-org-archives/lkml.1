Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZAaD0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZAaD0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZAaDZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:25:20 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:34908 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZAaDZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:25:17 -0500
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Date: Fri, 30 Jan 2009 19:25:14 -0800
Subject: [patch 2/7] epoll keyed wakeups - make __wake_up_sync accept a key parameter
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.16376.1233372316.2>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch adds an extra "key" parameter to __wake_up_sync().
This allows the caller of this function (and all related macros) to
specify a key to be passed to the wakeup callbacks.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 include/linux/wait.h |    6 ++++--
 kernel/sched.c       |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6.mod/include/linux/wait.h
===================================================================
--- linux-2.6.mod.orig/include/linux/wait.h	2009-01-30 12:11:40.000000000 -0800
+++ linux-2.6.mod/include/linux/wait.h	2009-01-30 12:11:42.000000000 -0800
@@ -134,7 +134,8 @@ static inline void __remove_wait_queue(w
 
 void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 extern void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, void *key);
-extern void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
+extern void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr,
+			   void *key);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
 int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
 int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
@@ -151,7 +152,8 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
 #define wake_up_interruptible_all(x)	__wake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
-#define wake_up_interruptible_sync(x)	__wake_up_sync((x), TASK_INTERRUPTIBLE, 1)
+#define wake_up_interruptible_sync(x)	__wake_up_sync((x), TASK_INTERRUPTIBLE, 1, \
+						       NULL)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 /*
Index: linux-2.6.mod/kernel/sched.c
===================================================================
--- linux-2.6.mod.orig/kernel/sched.c	2009-01-30 12:11:40.000000000 -0800
+++ linux-2.6.mod/kernel/sched.c	2009-01-30 12:11:42.000000000 -0800
@@ -4732,6 +4732,7 @@ void __wake_up_locked(wait_queue_head_t 
  * @q: the waitqueue
  * @mode: which threads
  * @nr_exclusive: how many wake-one or wake-many threads to wake up
+ * @key: is directly passed to the wakeup function
  *
  * The sync wakeup differs that the waker knows that it will schedule
  * away soon, so while the target thread will be woken up, it will not
@@ -4741,7 +4742,8 @@ void __wake_up_locked(wait_queue_head_t 
  * On UP it can prevent extra preemption.
  */
 void
-__wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
+__wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive,
+	       void *key)
 {
 	unsigned long flags;
 	int sync = 1;
@@ -4753,7 +4755,7 @@ __wake_up_sync(wait_queue_head_t *q, uns
 		sync = 0;
 
 	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, sync, NULL);
+	__wake_up_common(q, mode, nr_exclusive, sync, key);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */

