Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbYKDGLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbYKDGLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbYKDGJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:09:52 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:46048 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbYKDGJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:09:49 -0500
Message-Id: <20081104060946.631576722@nttdata.co.jp>
References: <20081104060847.086543472@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Tue, 04 Nov 2008 15:08:50 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Toshiharu Harada <haradats@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #12 (2.6.28-rc2-mm1) 03/11] Singly linked list implementation.
X-OriginalArrivalTime: 04 Nov 2008 06:09:47.0785 (UTC) FILETIME=[F0A50F90:01C93E43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/list1.h |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

--- /dev/null
+++ linux-2.6.28-rc2-mm1/include/linux/list1.h
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

