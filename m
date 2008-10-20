Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYJTHiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYJTHiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYJTHg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:36:56 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:49598 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbYJTHgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:36:53 -0400
Message-Id: <20081020073648.682014372@nttdata.co.jp>
References: <20081020073423.024299308@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Mon, 20 Oct 2008 16:34:26 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #11 (linux-next) 03/11] Singly linked list implementation.
X-OriginalArrivalTime: 20 Oct 2008 07:36:51.0082 (UTC) FILETIME=[9DC6AEA0:01C93286]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/list1.h |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

--- /dev/null
+++ linux-next/include/linux/list1.h
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

