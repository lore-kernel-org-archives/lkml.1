Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbXA1PxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbXA1PxX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXA1PxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:53:22 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:39581 "EHLO
	amsfep12-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752448AbXA1PxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:53:22 -0500
Subject: [Fwd: [PATCH 2/7] lock_list: a fine grain locked double linked
	list]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 28 Jan 2007 16:53:17 +0100
Message-Id: <1169999597.10987.33.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since it seems to be lost in cyberspace....

-------- Forwarded Message --------
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Subject: [PATCH 2/7] lock_list: a fine grain locked double linked list
Date: Sun, 28 Jan 2007 12:51:20 +0100

plain text document attachment (lock_list.patch)
Provide a simple fine grain locked double link list.

It is build upon the regular double linked list primitives, spinlocks and RCU.

Locking is peculiar in that edges are locked, this avoid the circular lock
dependancy created by the fact that the regular linked lists are circular.

Item deletion requires that both surrounding elements are locked, however since
the locking rules dictate that we lock elements in a single direction we have
to lock the previous element while it might be deleted under us. Hence the
requirement that all elements are RCU freed.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/lock_list.h |   75 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/Makefile              |    2 -
 lib/lock_list.c           |   70 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 146 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/lock_list.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/linux/lock_list.h	2007-01-27 21:07:02.000000000 +0100
@@ -0,0 +1,75 @@
+/*
+ * Copyright (C) 2006, Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ * Licenced under the GPLv2.
+ *
+ * Simple fine grain locked double linked list.
+ */
+#ifndef _LINUX_LOCK_LIST_H
+#define _LINUX_LOCK_LIST_H
+
+#ifdef __KERNEL__
+
+#include <linux/list.h>
+#include <linux/rcupdate.h>
+#include <linux/spinlock.h>
+
+struct lock_list_head {
+	union {
+		struct list_head head;
+		struct {
+			struct lock_list_head *next, *prev;
+		};
+	};
+	spinlock_t lock;
+};
+
+enum {
+	LOCK_LIST_NESTING_PREV = 1,
+	LOCK_LIST_NESTING_CUR,
+	LOCK_LIST_NESTING_NEXT,
+};
+
+static inline void INIT_LOCK_LIST_HEAD(struct lock_list_head *list)
+{
+	INIT_LIST_HEAD(&list->head);
+	spin_lock_init(&list->lock);
+}
+
+/*
+ * Passed pointers are assumed stable by external means (refcount, rcu)
+ */
+extern void __lock_list_add(struct lock_list_head *new,
+			    struct lock_list_head *list);
+
+static inline void lock_list_add(struct lock_list_head *new,
+			    struct lock_list_head *list)
+{
+	spin_lock(&new->lock);
+	__lock_list_add(new, list);
+	spin_unlock(&new->lock);
+}
+
+extern void lock_list_del_init(struct lock_list_head *entry);
+
+struct lock_list_head *lock_list_next_entry(struct lock_list_head *list,
+					    struct lock_list_head *entry);
+
+static inline
+struct lock_list_head *lock_list_first_entry(struct lock_list_head *list)
+{
+	spin_lock(&list->lock);
+	return lock_list_next_entry(list, list);
+}
+
+#define lock_list_for_each_entry(pos, list, member)			\
+	for (pos = list_entry(lock_list_first_entry(list), 		\
+			      typeof(*pos), member); 			\
+	     pos;							\
+	     pos = list_entry(lock_list_next_entry(list, &pos->member),	\
+			      typeof(*pos), member))
+
+#define lock_list_for_each_entry_stop(pos, member)			\
+	spin_unlock(&(pos->member.lock))
+
+#endif /* __KERNEL__ */
+#endif /* _LINUX_LOCK_LIST_H */
Index: linux-2.6/lib/Makefile
===================================================================
--- linux-2.6.orig/lib/Makefile	2007-01-13 21:04:12.000000000 +0100
+++ linux-2.6/lib/Makefile	2007-01-27 21:05:59.000000000 +0100
@@ -2,7 +2,7 @@
 # Makefile for some libs needed in the kernel.
 #
 
-lib-y := ctype.o string.o vsprintf.o cmdline.o \
+lib-y := ctype.o string.o vsprintf.o cmdline.o lock_list.o \
 	 bust_spinlocks.o rbtree.o radix-tree.o dump_stack.o \
 	 idr.o div64.o int_sqrt.o bitmap.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o
Index: linux-2.6/lib/lock_list.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/lib/lock_list.c	2007-01-27 21:07:36.000000000 +0100
@@ -0,0 +1,70 @@
+/*
+ * Copyright (C) 2006, Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ * Licenced under the GPLv2.
+ *
+ * Simple fine grain locked double linked list.
+ *
+ * Locking order is from prev -> next.
+ * Edges are locked not nodes; that is, cur->lock protects:
+ *  - cur->next,
+ *  - cur->next->prev.
+ *
+ * Passed pointers are assumed to be stable by external means such as
+ * refcounts or RCU. The individual list entries are assumed to be RCU
+ * freed (requirement of __lock_list_del).
+ */
+
+#include <linux/lock_list.h>
+
+void __lock_list_add(struct lock_list_head *new, struct lock_list_head *list)
+{
+	struct lock_list_head *next;
+
+	spin_lock_nested(&list->lock, LOCK_LIST_NESTING_PREV);
+	next = list->next;
+	__list_add(&new->head, &list->head, &next->head);
+	spin_unlock(&list->lock);
+}
+
+void lock_list_del_init(struct lock_list_head *entry)
+{
+	struct lock_list_head *prev, *next;
+
+	rcu_read_lock();
+again:
+	prev = entry->prev;
+	if (prev == entry)
+		goto out;
+	spin_lock_nested(&prev->lock, LOCK_LIST_NESTING_PREV);
+	if (unlikely(entry->prev != prev)) {
+		/*
+		 * we lost
+		 */
+		spin_unlock(&prev->lock);
+		goto again;
+	}
+	spin_lock_nested(&entry->lock, LOCK_LIST_NESTING_CUR);
+	next = entry->next;
+	__list_del(&prev->head, &next->head);
+	INIT_LIST_HEAD(&entry->head);
+	spin_unlock(&entry->lock);
+	spin_unlock(&prev->lock);
+out:
+	rcu_read_unlock();
+}
+
+struct lock_list_head *lock_list_next_entry(struct lock_list_head *list,
+					    struct lock_list_head *entry)
+{
+	struct lock_list_head *next = entry->next;
+	if (likely(next != list)) {
+		lock_set_subclass(&entry->lock.dep_map,
+				  LOCK_LIST_NESTING_CUR, _THIS_IP_);
+		spin_lock_nested(&next->lock, LOCK_LIST_NESTING_NEXT);
+		BUG_ON(entry->next != next);
+	} else
+		next = NULL;
+	spin_unlock(&entry->lock);
+	return next;
+}
+

--


