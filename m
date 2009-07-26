Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429AbZGZISk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbZGZISk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZGZISi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:18:38 -0400
Received: from www.tglx.de ([62.245.132.106]:57757 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbZGZISf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:18:35 -0400
Message-Id: <20090726081553.328151390@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:17:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [Patch RFC 01/37] semaphore: Add DEFINE_SEMAPHORE, semaphore_init,
	semaphore_init_locked
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=semaphore-add-define-semaphore.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The full cleanup of init_MUTEX[_LOCKED] and DECLARE_MUTEX has not been
done. Some of the users are real semaphores and we should name them as
such instead of confusing everyone with "MUTEX".

Provide the infrastructure to get finally rid of init_MUTEX[_LOCKED]
and DECLARE_MUTEX.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/semaphore.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux-2.6-tip/include/linux/semaphore.h
===================================================================
--- linux-2.6-tip.orig/include/linux/semaphore.h
+++ linux-2.6-tip/include/linux/semaphore.h
@@ -26,6 +26,9 @@ struct semaphore {
 	.wait_list	= LIST_HEAD_INIT((name).wait_list),		\
 }
 
+#define DEFINE_SEMAPHORE(name)	\
+	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
+
 #define DECLARE_MUTEX(name)	\
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
 
@@ -36,6 +39,20 @@ static inline void sema_init(struct sema
 	lockdep_init_map(&sem->lock.dep_map, "semaphore->lock", &__key, 0);
 }
 
+static inline void semaphore_init(struct semanphore *sem)
+{
+	sema_init(sem, 1);
+}
+
+/*
+ * semaphore_init_locked() is mostly a sign for a mutex which is
+ * abused as completion.
+ */
+static inline void __deprecated semaphore_init_locked(struct semanphore *sem)
+{
+	sema_init(sem, 0);
+}
+
 #define init_MUTEX(sem)		sema_init(sem, 1)
 #define init_MUTEX_LOCKED(sem)	sema_init(sem, 0)
 


