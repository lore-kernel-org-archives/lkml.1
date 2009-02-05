Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbZBEUYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbZBEUYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbZBEUXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:23:43 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:33458 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbZBEUXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:23:42 -0500
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Date: Thu, 05 Feb 2009 12:23:39 -0800
Subject: [patch 2/6] epoll keyed wakeups v3 - introduce new *_poll() wakeup macros
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.21761.1233865420.2>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new wakeup macros that allow passing an event
mask to the wakeup targets. They exactly mimic their non-_poll()
counterpart, with the added event mask passing capability.
I did add only the ones currently requested, avoiding the _nr() and
_all() for the moment.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 include/linux/wait.h |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

Index: linux-2.6.mod/include/linux/wait.h
===================================================================
--- linux-2.6.mod.orig/include/linux/wait.h	2009-02-03 13:44:00.000000000 -0800
+++ linux-2.6.mod/include/linux/wait.h	2009-02-03 13:44:01.000000000 -0800
@@ -156,21 +156,17 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define wake_up_interruptible_all(x)	__wake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
 #define wake_up_interruptible_sync(x)	__wake_up_sync((x), TASK_INTERRUPTIBLE, 1)
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 /*
- * macro to avoid include hell
+ * Wakeup macros to be used to report events to the targets.
  */
-#define wake_up_nested(x, s)						\
-do {									\
-	unsigned long flags;						\
-									\
-	spin_lock_irqsave_nested(&(x)->lock, flags, (s));		\
-	wake_up_locked(x); 						\
-	spin_unlock_irqrestore(&(x)->lock, flags);			\
-} while (0)
-#else
-#define wake_up_nested(x, s)		wake_up(x)
-#endif
+#define wake_up_poll(x, m)				\
+	__wake_up(x, TASK_NORMAL, 1, (void *) (m))
+#define wake_up_locked_poll(x, m)				\
+	__wake_up_locked_key((x), TASK_NORMAL, (void *) (m))
+#define wake_up_interruptible_poll(x, m)			\
+	__wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
+#define wake_up_interruptible_sync_poll(x, m)				\
+	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
 
 #define __wait_event(wq, condition) 					\
 do {									\

