Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYKTLhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYKTLhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbYKTLgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:36:20 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54932 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbYKTLgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:36:14 -0500
Message-Id: <20081120112732.119069758@I-love.SAKURA.ne.jp>
References: <20081120112543.799450455@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 20:25:46 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #13 (mmotm 2008-11-19-02-19) 03/11] Singly linked list implementation.
Content-Disposition: inline; filename=introduce-write-once-read-many-linked-list.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new list structure named "list1".

TOMOYO wants to use "write once read many" list.
Since only two operations

 (1) Append an entry to the tail of the list.
 (2) Read all entries starting from the head of the list.

are needed for that purpose, this list doesn't have pointer to previous
element.

While "hlist" is defined as

 struct hlist_head {
 	struct hlist_node *first;
 };

 struct hlist_node {
 	struct hlist_node *next, **pprev;
 };

I don't use "hlist_node" because I don't need pointer to previous element.

By ommiting pointer to previous element, the reader becomes read lock free,
which is good thing for implementing "write once read many" list.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/list1.h |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

--- /dev/null
+++ linux-2.6.28-rc5-mm1/include/linux/list1.h
@@ -0,0 +1,81 @@
+#ifndef _LINUX_LIST1_H
+#define _LINUX_LIST1_H
+
+#include <linux/list.h>
+#include <linux/rcupdate.h>
+
+/*
+ * Singly linked list implementation.
+ *
+ * This list supports only two operations.
+ * (1) Append an entry to the tail of the list.
+ * (2) Read all entries starting from the head of the list.
+ *
+ * This list is designed for holding "write once, read many" entries.
+ * This list requires no locks for read operation.
+ * This list doesn't support "remove an entry from the list" operation.
+ */
+
+/* To reduce memory usage, this list doesn't use "->prev" pointer. */
+struct list1_head {
+	struct list1_head *next;
+};
+
+#define LIST1_HEAD_INIT(name) { &(name) }
+#define LIST1_HEAD(name) struct list1_head name = LIST1_HEAD_INIT(name)
+
+static inline void INIT_LIST1_HEAD(struct list1_head *list)
+{
+	list->next = list;
+}
+
+/* Reuse list_entry because it doesn't use "->prev" pointer. */
+#define list1_entry list_entry
+
+/* Reuse list_for_each_rcu because it doesn't use "->prev" pointer. */
+#define list1_for_each list_for_each_rcu
+/* Reuse list_for_each_entry_rcu because it doesn't use "->prev" pointer. */
+#define list1_for_each_entry list_for_each_entry_rcu
+
+/**
+ * list1_for_each_cookie - iterate over a list with cookie.
+ * @pos:        the &struct list1_head to use as a loop cursor.
+ * @cookie:     the &struct list1_head to use as a cookie.
+ * @head:       the head for your list.
+ *
+ * Same with list_for_each_rcu() except that this primitive uses @cookie
+ * so that we can continue iteration.
+ * @cookie must be NULL when iteration starts, and @cookie will become
+ * NULL when iteration finishes.
+ *
+ * Since list elements are never removed, we don't need to get a lock
+ * or a reference count.
+ */
+#define list1_for_each_cookie(pos, cookie, head)                      \
+	for (({ if (!cookie)                                          \
+				     cookie = head; }),               \
+	     pos = rcu_dereference((cookie)->next);                   \
+	     prefetch(pos->next), pos != (head) || ((cookie) = NULL); \
+	     (cookie) = pos, pos = rcu_dereference(pos->next))
+
+/**
+ * list1_add_tail - add a new entry to list1 list.
+ * @new: new entry to be added.
+ * @head: list head to add it before.
+ *
+ * Same with list_add_tail_rcu() without "->prev" pointer.
+ *
+ * Caller must hold a lock for protecting @head.
+ */
+static inline void list1_add_tail(struct list1_head *new,
+				  struct list1_head *head)
+{
+	struct list1_head *prev = head;
+
+	new->next = head;
+	while (prev->next != head)
+		prev = prev->next;
+	rcu_assign_pointer(prev->next, new);
+}
+
+#endif

-- 
