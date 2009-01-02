Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbZABL7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbZABL7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 06:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbZABL7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 06:59:24 -0500
Received: from sing.entic.net ([208.64.63.147]:60442 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301AbZABL7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 06:59:23 -0500
Message-Id: <200901021159.n02BxDLg024728@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
To: linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org
Cc: laijs@cn.fujitsu.com
Date: Fri, 2 Jan 2009 12:25:58 +0100
Subject: [RFC, PATCH] kernel/rcu: add kfree_rcu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the idea from Lai Jiangshan:

There are 23 instances where the rcu callback just does

	kfree(containerof(rcu_member,struct whatever_struct,head));

The 23 instances exist because there are 23 'struct whatever_struct' with
their individual rcu_member.

The attached patch creates a generic kfree_rcu function that removes the need
for these 23 helpers: The offset from the container struct to the rcu member
is calculated at compile time and stored in head->func instead of the
function pointer.


Effect on .text: (x86_64)
+23 bytes in rcutree.c
- 9 bytes in ipc/sem.c

Depending on the number of call_rcu instances in the .config, adding
kfree_rcu should save between 100 and 200 bytes in .text.

What do you think?
Is the interface ok? Incorrect use should generate compile time errors.
Is it ok to use IS_ERR(p)?
And: How many seperate patches should I create?
I would propose 24 patches: one with the interface, 23 that
replace the individual callbacks.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/rcupdate.h |   33 +++++++++++++++++++++++++++++++++
 ipc/sem.c                |   10 ++--------
 kernel/rcuclassic.c      |    2 +-
 kernel/rcupreempt.c      |    2 +-
 kernel/rcutree.c         |    2 +-
 5 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 1168fbc..d120014 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -269,6 +269,29 @@ extern void call_rcu(struct rcu_head *head,
 extern void call_rcu_bh(struct rcu_head *head,
 			void (*func)(struct rcu_head *head));
 
+/**
+ * kfree_rcu - kfree after a grace period
+ * @ptr: pointer to kfree
+ * @rcu_member: name of the struct rcu_head member.
+ *
+ * Many rcu callbacks just call kfree() on the base structure. This helper
+ * function calls kfree internally. The rcu_head structure must be embedded
+ * in the to be freed structure.
+ */
+
+static inline void __kfree_rcu(void *prcu, unsigned long offset)
+{
+	void (*pfnc)(struct rcu_head *head) = (void (*)(struct rcu_head *head))offset;
+
+	BUILD_BUG_ON(!__builtin_constant_p(-offset));
+	BUILD_BUG_ON(!IS_ERR(pfnc));
+
+	call_rcu(prcu, pfnc);
+}
+
+#define kfree_rcu(pobj, entry) \
+	__kfree_rcu(&((pobj)->entry), -offsetof(typeof(*(pobj)), entry))
+
 /* Exported common interfaces */
 extern void synchronize_rcu(void);
 extern void rcu_barrier(void);
@@ -279,4 +302,14 @@ extern void rcu_barrier_sched(void);
 extern void rcu_init(void);
 extern int rcu_needs_cpu(int cpu);
 
+/* helper functions */
+static inline void rcu_docallback(struct rcu_head *head)
+{
+	if (IS_ERR(head->func)) {
+		kfree(((char *)head) + (unsigned long)head->func);
+	} else {
+		head->func(head);
+	}
+}
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/ipc/sem.c b/ipc/sem.c
index 0821224..4a68cf2 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -504,12 +504,6 @@ static int count_semzcnt (struct sem_array * sma, ushort semnum)
 	return semzcnt;
 }
 
-static void free_un(struct rcu_head *head)
-{
-	struct sem_undo *un = container_of(head, struct sem_undo, rcu);
-	kfree(un);
-}
-
 /* Free a semaphore set. freeary() is called with sem_ids.rw_mutex locked
  * as a writer and the spinlock for this semaphore set hold. sem_ids.rw_mutex
  * remains locked on exit.
@@ -528,7 +522,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 		un->semid = -1;
 		list_del_rcu(&un->list_proc);
 		spin_unlock(&un->ulp->lock);
-		call_rcu(&un->rcu, free_un);
+		kfree_rcu(un, rcu);
 	}
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
@@ -1347,7 +1341,7 @@ void exit_sem(struct task_struct *tsk)
 		update_queue(sma);
 		sem_unlock(sma);
 
-		call_rcu(&un->rcu, free_un);
+		kfree_rcu(un, rcu);
 	}
 	kfree(ulp);
 }
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index e503a00..b2f97d2 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -336,7 +336,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
 	while (list) {
 		next = list->next;
 		prefetch(next);
-		list->func(list);
+		rcu_docallback(list);
 		list = next;
 		if (++count >= rdp->blimit)
 			break;
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 0498265..8440dac 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1110,7 +1110,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 	spin_unlock_irqrestore(&rdp->lock, flags);
 	while (list) {
 		next = list->next;
-		list->func(list);
+		rcu_docallback(list);
 		list = next;
 		RCU_TRACE_ME(rcupreempt_trace_invoke);
 	}
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a342b03..29c88ce 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -901,7 +901,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
 	while (list) {
 		next = list->next;
 		prefetch(next);
-		list->func(list);
+		rcu_docallback(list);
 		list = next;
 		if (++count >= rdp->blimit)
 			break;
-- 
1.6.0.6

