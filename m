Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbZAaDZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbZAaDZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZAaDZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:25:19 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:34903 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZAaDZR (ORCPT
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
Subject: [patch 1/7] epoll keyed wakeups - make __wake_up_locked accept a key parameter
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.16376.1233372315.1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch adds an extra "key" parameter to __wake_up_locked().
This allows the caller of this function (and all related macros) to
specify a key to be passed to the wakeup callbacks.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 include/linux/wait.h |    4 ++--
 kernel/sched.c       |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.mod/include/linux/wait.h
===================================================================
--- linux-2.6.mod.orig/include/linux/wait.h	2009-01-30 12:11:32.000000000 -0800
+++ linux-2.6.mod/include/linux/wait.h	2009-01-30 12:11:40.000000000 -0800
@@ -133,7 +133,7 @@ static inline void __remove_wait_queue(w
 }
 
 void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
-extern void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
+extern void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, void *key);
 extern void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
 int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
@@ -146,7 +146,7 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
 #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
-#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL)
+#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, NULL)
 
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
Index: linux-2.6.mod/kernel/sched.c
===================================================================
--- linux-2.6.mod.orig/kernel/sched.c	2009-01-30 12:11:32.000000000 -0800
+++ linux-2.6.mod/kernel/sched.c	2009-01-30 12:11:40.000000000 -0800
@@ -4722,9 +4722,9 @@ EXPORT_SYMBOL(__wake_up);
 /*
  * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
  */
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, void *key)
 {
-	__wake_up_common(q, mode, 1, 0, NULL);
+	__wake_up_common(q, mode, 1, 0, key);
 }
 
 /**

