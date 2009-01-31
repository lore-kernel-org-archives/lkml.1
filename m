Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbZAaD0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbZAaD0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZAaDZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:25:21 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:34916 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZAaDZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:25:18 -0500
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Date: Fri, 30 Jan 2009 19:25:14 -0800
Subject: [patch 3/7] epoll keyed wakeups - introduce key-aware wakeup macros
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.16376.1233372317.3>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch introduces new kwake_* macros that accepts an
extra key parameter to be specified in the wakeup.
I chose to add an initial 'k' to the original names, instead of adding
a whole "_key", since the name of some of those macros is becoming
awfully long. No problem in using the "_key" naming, if others feel it.
Comments?



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 include/linux/wait.h |   41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

Index: linux-2.6.mod/include/linux/wait.h
===================================================================
--- linux-2.6.mod.orig/include/linux/wait.h	2009-01-30 12:11:42.000000000 -0800
+++ linux-2.6.mod/include/linux/wait.h	2009-01-30 12:11:44.000000000 -0800
@@ -144,31 +144,48 @@ int out_of_line_wait_on_bit(void *, int,
 int out_of_line_wait_on_bit_lock(void *, int, int (*)(void *), unsigned);
 wait_queue_head_t *bit_waitqueue(void *, int);
 
-#define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
-#define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
-#define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
-#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, NULL)
-
-#define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
-#define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
-#define wake_up_interruptible_all(x)	__wake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
-#define wake_up_interruptible_sync(x)	__wake_up_sync((x), TASK_INTERRUPTIBLE, 1, \
-						       NULL)
+#define kwake_up(x, k)			__wake_up(x, TASK_NORMAL, 1, (void *) (k))
+#define kwake_up_nr(x, nr, k)		__wake_up(x, TASK_NORMAL, nr, (void *) (k))
+#define kwake_up_all(x, k)		__wake_up(x, TASK_NORMAL, 0, (void *) (k))
+#define kwake_up_locked(x, k)		__wake_up_locked((x), TASK_NORMAL, \
+						(void *) (k))
+
+#define kwake_up_interruptible(x, k)	__wake_up(x, TASK_INTERRUPTIBLE, 1, \
+						(void *) (k))
+#define kwake_up_interruptible_nr(x, nr, k)	__wake_up(x, TASK_INTERRUPTIBLE, nr, \
+						(void *) (k))
+#define kwake_up_interruptible_all(x, k)	__wake_up(x, TASK_INTERRUPTIBLE, 0, \
+						(void *) (k))
+#define kwake_up_interruptible_sync(x, k)	__wake_up_sync((x), TASK_INTERRUPTIBLE, \
+						1, (void *) (k))
+
+#define wake_up(x)			kwake_up(x, NULL)
+#define wake_up_nr(x, nr)		kwake_up_nr(x, nr, NULL)
+#define wake_up_all(x)			kwake_up_all(x, NULL)
+#define wake_up_locked(x)		kwake_up_locked(x, NULL)
+
+#define wake_up_interruptible(x)	kwake_up_interruptible(x, NULL)
+#define wake_up_interruptible_nr(x, nr)	kwake_up_interruptible_nr(x, nr, NULL)
+#define wake_up_interruptible_all(x)	kwake_up_interruptible_all(x, NULL)
+#define wake_up_interruptible_sync(x)	kwake_up_interruptible_sync(x, NULL)
+
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 /*
  * macro to avoid include hell
  */
-#define wake_up_nested(x, s)						\
+#define kwake_up_nested(x, s, k)					\
 do {									\
 	unsigned long flags;						\
 									\
 	spin_lock_irqsave_nested(&(x)->lock, flags, (s));		\
-	wake_up_locked(x); 						\
+	kwake_up_locked(x, k); 						\
 	spin_unlock_irqrestore(&(x)->lock, flags);			\
 } while (0)
+#define wake_up_nested(x, s)		kwake_up_nested(x, s, NULL)
 #else
 #define wake_up_nested(x, s)		wake_up(x)
+#define kwake_up_nested(x, k, s)	kwake_up(x, k)
 #endif
 
 #define __wait_event(wq, condition) 					\

