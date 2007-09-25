Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbXIYPao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbXIYPao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbXIYPag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:30:36 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:62790 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbXIYPaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:30:35 -0400
Date: Tue, 25 Sep 2007 11:29:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, mingo@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RT] Don't let -rt rw_semaphors do _non_owner locks
In-Reply-To: <20070925144257.1acedd24@twins>
Message-ID: <Pine.LNX.4.58.0709251126190.3961@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0709241700290.13164@gandalf.stny.rr.com>
 <20070925144257.1acedd24@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Tue, 25 Sep 2007, Peter Zijlstra wrote:

> How about teaching {up,down}_read_non_owner() to barf on rw_semaphore
> in -rt?
>

Sure thing!

This patch prevents rw_semaphore in PREEMPT_RT from performing
down_read_non_owner and up_read_non_owner. If this must be used, then
either convert to a completion or use compat_rw_semaphore.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.23-rc4-rt1/include/linux/rt_lock.h
===================================================================
--- linux-2.6.23-rc4-rt1.orig/include/linux/rt_lock.h	2007-09-25 09:38:56.000000000 -0400
+++ linux-2.6.23-rc4-rt1/include/linux/rt_lock.h	2007-09-25 09:42:19.000000000 -0400
@@ -248,25 +248,20 @@ do {							\
 	__rt_rwsem_init((sem), #sem, &__key);		\
 } while (0)

+extern void __dont_do_this_in_rt(struct rw_semaphore *rwsem);
+
+#define rt_down_read_non_owner(rwsem)	__dont_do_this_in_rt(rwsem)
+#define rt_up_read_non_owner(rwsem)	__dont_do_this_in_rt(rwsem)
+
 extern void fastcall rt_down_write(struct rw_semaphore *rwsem);
 extern void fastcall
 rt_down_read_nested(struct rw_semaphore *rwsem, int subclass);
 extern void fastcall
 rt_down_write_nested(struct rw_semaphore *rwsem, int subclass);
 extern void fastcall rt_down_read(struct rw_semaphore *rwsem);
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern void fastcall rt_down_read_non_owner(struct rw_semaphore *rwsem);
-#else
-# define rt_down_read_non_owner(rwsem)		rt_down_read(rwsem)
-#endif
 extern int fastcall rt_down_write_trylock(struct rw_semaphore *rwsem);
 extern int fastcall rt_down_read_trylock(struct rw_semaphore *rwsem);
 extern void fastcall rt_up_read(struct rw_semaphore *rwsem);
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern void fastcall rt_up_read_non_owner(struct rw_semaphore *rwsem);
-#else
-# define rt_up_read_non_owner(rwsem)	rt_up_read(rwsem)
-#endif
 extern void fastcall rt_up_write(struct rw_semaphore *rwsem);
 extern void fastcall rt_downgrade_write(struct rw_semaphore *rwsem);

Index: linux-2.6.23-rc4-rt1/kernel/rt.c
===================================================================
--- linux-2.6.23-rc4-rt1.orig/kernel/rt.c	2007-09-25 09:38:56.000000000 -0400
+++ linux-2.6.23-rc4-rt1/kernel/rt.c	2007-09-25 09:41:50.000000000 -0400
@@ -324,25 +324,6 @@ void fastcall rt_up_read(struct rw_semap
 }
 EXPORT_SYMBOL(rt_up_read);

-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-void fastcall rt_up_read_non_owner(struct rw_semaphore *rwsem)
-{
-	unsigned long flags;
-	/*
-	 * Read locks within the self-held write lock succeed.
-	 */
-	spin_lock_irqsave(&rwsem->lock.wait_lock, flags);
-	if (rt_mutex_real_owner(&rwsem->lock) == current && rwsem->read_depth) {
-		spin_unlock_irqrestore(&rwsem->lock.wait_lock, flags);
-		rwsem->read_depth--;
-		return;
-	}
-	spin_unlock_irqrestore(&rwsem->lock.wait_lock, flags);
-	rt_mutex_unlock(&rwsem->lock);
-}
-EXPORT_SYMBOL(rt_up_read_non_owner);
-#endif
-
 /*
  * downgrade a write lock into a read lock
  * - just wake up any readers at the front of the queue
@@ -433,32 +414,6 @@ void fastcall rt_down_read_nested(struct
 }
 EXPORT_SYMBOL(rt_down_read_nested);

-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-
-/*
- * Same as rt_down_read() but no lockdep calls:
- */
-void fastcall rt_down_read_non_owner(struct rw_semaphore *rwsem)
-{
-	unsigned long flags;
-	/*
-	 * Read locks within the write lock succeed.
-	 */
-	spin_lock_irqsave(&rwsem->lock.wait_lock, flags);
-
-	if (rt_mutex_real_owner(&rwsem->lock) == current) {
-		spin_unlock_irqrestore(&rwsem->lock.wait_lock, flags);
-		rwsem->read_depth++;
-		return;
-	}
-	spin_unlock_irqrestore(&rwsem->lock.wait_lock, flags);
-	rt_mutex_lock(&rwsem->lock);
-}
-EXPORT_SYMBOL(rt_down_read_non_owner);
-
-#endif
-
 void fastcall __rt_rwsem_init(struct rw_semaphore *rwsem, char *name,
 			      struct lock_class_key *key)
 {
