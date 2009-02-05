Return-Path: <linux-kernel-owner+w=401wt.eu-S1761122AbZBEUYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761122AbZBEUYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbZBEUXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:23:42 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:33454 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbZBEUXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:23:41 -0500
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Date: Thu, 05 Feb 2009 12:23:39 -0800
Subject: [patch 1/6] epoll keyed wakeups v3 - add __wake_up_locked_key() and __wake_up_sync_key()
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.21761.1233865419.1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing revolutionary here. Just using the available "key" that our
wakeup core already support.  The __wake_up_locked_key() was no brainer,
since both __wake_up_locked() and __wake_up_locked_key() are thin
wrappers around __wake_up_common().
The __wake_up_sync() function had a body, so the choice was between
borrowing the body for __wake_up_sync_key() and calling it from
__wake_up_sync(), or make an inline and calling it from both. I chose
the former since in most archs it all resolves to "mov $0, REG; jmp ADDR".



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 include/linux/wait.h |    7 +++++--
 kernel/sched.c       |   23 +++++++++++++++++++----
 2 files changed, 24 insertions(+), 6 deletions(-)

Index: linux-2.6.mod/include/linux/wait.h
===================================================================
--- linux-2.6.mod.orig/include/linux/wait.h	2009-02-03 13:43:52.000000000 -0800
+++ linux-2.6.mod/include/linux/wait.h	2009-02-03 13:44:00.000000000 -0800
@@ -133,8 +133,11 @@ static inline void __remove_wait_queue(w
 }
 
 void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
-extern void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
-extern void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
+void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
+void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr,
+			void *key);
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
+void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
 int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
 int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
Index: linux-2.6.mod/kernel/sched.c
===================================================================
--- linux-2.6.mod.orig/kernel/sched.c	2009-02-03 13:43:52.000000000 -0800
+++ linux-2.6.mod/kernel/sched.c	2009-02-03 13:44:00.000000000 -0800
@@ -4727,11 +4727,17 @@ void __wake_up_locked(wait_queue_head_t 
 	__wake_up_common(q, mode, 1, 0, NULL);
 }
 
+void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
+{
+	__wake_up_common(q, mode, 1, 0, key);
+}
+
 /**
- * __wake_up_sync - wake up threads blocked on a waitqueue.
+ * __wake_up_sync_key - wake up threads blocked on a waitqueue.
  * @q: the waitqueue
  * @mode: which threads
  * @nr_exclusive: how many wake-one or wake-many threads to wake up
+ * @key: opaque value to be passed to wakeup targets
  *
  * The sync wakeup differs that the waker knows that it will schedule
  * away soon, so while the target thread will be woken up, it will not
@@ -4740,8 +4746,8 @@ void __wake_up_locked(wait_queue_head_t 
  *
  * On UP it can prevent extra preemption.
  */
-void
-__wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
+void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, void *key)
 {
 	unsigned long flags;
 	int sync = 1;
@@ -4753,9 +4759,18 @@ __wake_up_sync(wait_queue_head_t *q, uns
 		sync = 0;
 
 	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, sync, NULL);
+	__wake_up_common(q, mode, nr_exclusive, sync, key);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
+EXPORT_SYMBOL_GPL(__wake_up_sync_key);
+
+/*
+ * __wake_up_sync - see __wake_up_sync_key()
+ */
+void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
+{
+	__wake_up_sync_key(q, mode, nr_exclusive, NULL);
+}
 EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
 /**

