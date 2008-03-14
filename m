Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbYCNVUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbYCNVUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbYCNVUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:20:09 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:50327 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbYCNVUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:20:08 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, lenb@kernel.org,
       dhowells@redhat.com, peterz@infradead.org, mingo@elte.hu,
       harvey.harrison@gmail.com
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 4/6] Introduce down_killable()
Date: Fri, 14 Mar 2008 16:44:51 -0400
Message-Id: <1205527493-5740-4-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205527493-5740-3-git-send-email-matthew@wil.cx>
References: <20080314204248.GV613@parisc-linux.org>
 <1205527493-5740-1-git-send-email-matthew@wil.cx>
 <1205527493-5740-2-git-send-email-matthew@wil.cx>
 <1205527493-5740-3-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

down_killable() is the functional counterpart of mutex_lock_killable.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/linux/semaphore.h |    6 ++++++
 kernel/semaphore.c        |   22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index b3c691b..88f2a28 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -62,6 +62,12 @@ extern void down(struct semaphore *sem);
 extern int __must_check down_interruptible(struct semaphore *sem);
 
 /*
+ * As down_interruptible(), except the sleep may only be interrupted by
+ * signals which are fatal to this process.
+ */
+extern int __must_check down_killable(struct semaphore *sem);
+
+/*
  * As down(), except this function will not sleep.  It will return 0 if it
  * acquired the semaphore and 1 if the semaphore was contended.  This
  * function may be called from any context, including interrupt and softirq.
diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index d5a7270..2da2aed 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -34,6 +34,7 @@
 
 static noinline void __down(struct semaphore *sem);
 static noinline int __down_interruptible(struct semaphore *sem);
+static noinline int __down_killable(struct semaphore *sem);
 static noinline void __up(struct semaphore *sem);
 
 void down(struct semaphore *sem)
@@ -61,6 +62,20 @@ int down_interruptible(struct semaphore *sem)
 }
 EXPORT_SYMBOL(down_interruptible);
 
+int down_killable(struct semaphore *sem)
+{
+	unsigned long flags;
+	int result = 0;
+
+	spin_lock_irqsave(&sem->lock, flags);
+	if (unlikely(sem->count-- <= 0))
+		result = __down_killable(sem);
+	spin_unlock_irqrestore(&sem->lock, flags);
+
+	return result;
+}
+EXPORT_SYMBOL(down_killable);
+
 /**
  * down_trylock - try to acquire the semaphore, without waiting
  * @sem: the semaphore to be acquired
@@ -143,6 +158,8 @@ static inline int __sched __down_common(struct semaphore *sem, long state)
 	for (;;) {
 		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
 			goto interrupted;
+		if (state == TASK_KILLABLE && fatal_signal_pending(task))
+			goto interrupted;
 		__set_task_state(task, state);
 		spin_unlock_irq(&sem->lock);
 		schedule();
@@ -178,6 +195,11 @@ static noinline int __sched __down_interruptible(struct semaphore *sem)
 	return __down_common(sem, TASK_INTERRUPTIBLE);
 }
 
+static noinline int __sched __down_killable(struct semaphore *sem)
+{
+	return __down_common(sem, TASK_KILLABLE);
+}
+
 static noinline void __sched __up(struct semaphore *sem)
 {
 	if (unlikely(list_empty(&sem->wait_list)))
-- 
1.5.4.3

