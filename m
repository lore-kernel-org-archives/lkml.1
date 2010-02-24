Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab0BXUFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:05:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63074 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738Ab0BXUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:05:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: [PATCH 02/10] rcu: annotated list rcu code
Date: Wed, 24 Feb 2010 21:03:58 +0100
Message-Id: <1267041846-10469-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267041846-10469-1-git-send-email-arnd@arndb.de>
References: <1267041846-10469-1-git-send-email-arnd@arndb.de>
In-Reply-To: <20100223180127.GF6700@linux.vnet.ibm.com>
References: <20100223180127.GF6700@linux.vnet.ibm.com>
X-Provags-ID: V01U2FsdGVkX18lsJiWKijlccdHhX0kVcLtppK+/vMoi+wuDHV
 dHpRrGJePLRVth91cgIdI6/hHO8QzS8Ul5r5AnJFB4JTqxtsD2
 OoE4dsLzc0bGGZ+VHamlA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The listrcu implementation now defines new rcu_list_head,
rcu_hlist_head and rcu_hlist_entry structures that are
annotated with __rcu. Only these can now be passed into
rcu_list_for_each and related interfaces.

When not running sparse, the types are defined to the
original list_head etc in order to not break working
setups that are lacking annotation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/rculist.h |  152 ++++++++++++++++++++++++++++++++++------------
 1 files changed, 112 insertions(+), 40 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 1bf0f70..dfbc6ea 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -9,16 +9,67 @@
 #include <linux/list.h>
 #include <linux/rcupdate.h>
 
+#ifdef __CHECKER__
+struct rcu_list_head {
+	struct rcu_list_head __rcu *next;
+	struct rcu_list_head *prev;
+};
+#define LIST_HEAD_INIT_RCU(name) { (struct rcu_list_head __force __rcu *)&(name), &(name) }
+
+#define LIST_HEAD_RCU(name) \
+	struct rcu_list_head name = LIST_HEAD_INIT_RCU(name)
+
+static inline void INIT_LIST_HEAD_RCU(struct rcu_list_head *list)
+{
+	__rcu_assign_pointer(list->next, list);
+	list->prev = list;
+}
+
+struct rcu_hlist_head {
+	struct rcu_hlist_node __rcu *first;
+};
+
+struct rcu_hlist_node {
+	struct rcu_hlist_node __rcu *next, **pprev;
+};
+
+#define HLIST_HEAD_INIT_RCU { .first = (void __rcu __force *)NULL }
+#define HLIST_HEAD_RCU(name) struct rcu_hlist_head name = \
+		{  .first = (void __rcu __force *)NULL }
+#define INIT_HLIST_HEAD_RCU(ptr) ((ptr)->first = (void __rcu __force *)NULL)
+static inline void INIT_HLIST_NODE_RCU(struct rcu_hlist_node *h)
+{
+	__rcu_assign_pointer(h->next, NULL);
+	h->pprev = NULL;
+}
+
+#else /* !__CHECKER__ */
+
+#define rcu_list_head list_head
+#define LIST_HEAD_INIT_RCU LIST_HEAD_INIT
+#define LIST_HEAD_RCU LIST_HEAD
+#define INIT_LIST_HEAD_RCU INIT_LIST_HEAD
+
+#define rcu_hlist_head hlist_head
+#define rcu_hlist_node hlist_node
+#define HLIST_HEAD_INIT_RCU HLIST_HEAD_INIT
+#define HLIST_HEAD_RCU HLIST_HEAD
+#define INIT_HLIST_HEAD_RCU INIT_HLIST_HEAD
+#define INIT_HLIST_NODE_RCU INIT_HLIST_NODE
+
+#endif /* !__CHECKER__ */
+
+
 /*
  * Insert a new entry between two known consecutive entries.
  *
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
-static inline void __list_add_rcu(struct list_head *new,
-		struct list_head *prev, struct list_head *next)
+static inline void __list_add_rcu(struct rcu_list_head *new,
+		struct rcu_list_head *prev, struct rcu_list_head *next)
 {
-	new->next = next;
+	__rcu_assign_pointer(new->next, next);
 	new->prev = prev;
 	rcu_assign_pointer(prev->next, new);
 	next->prev = new;
@@ -40,9 +91,9 @@ static inline void __list_add_rcu(struct list_head *new,
  * the _rcu list-traversal primitives, such as
  * list_for_each_entry_rcu().
  */
-static inline void list_add_rcu(struct list_head *new, struct list_head *head)
+static inline void list_add_rcu(struct rcu_list_head *new, struct rcu_list_head *head)
 {
-	__list_add_rcu(new, head, head->next);
+	__list_add_rcu(new, head, __rcu_dereference(head->next));
 }
 
 /**
@@ -61,8 +112,8 @@ static inline void list_add_rcu(struct list_head *new, struct list_head *head)
  * the _rcu list-traversal primitives, such as
  * list_for_each_entry_rcu().
  */
-static inline void list_add_tail_rcu(struct list_head *new,
-					struct list_head *head)
+static inline void list_add_tail_rcu(struct rcu_list_head *new,
+					struct rcu_list_head *head)
 {
 	__list_add_rcu(new, head->prev, head);
 }
@@ -91,13 +142,29 @@ static inline void list_add_tail_rcu(struct list_head *new,
  * or call_rcu() must be used to defer freeing until an RCU
  * grace period has elapsed.
  */
-static inline void list_del_rcu(struct list_head *entry)
+static inline void __list_del_rcu(struct rcu_list_head *prev, struct rcu_list_head *next)
 {
-	__list_del(entry->prev, entry->next);
+	next->prev = prev;
+	__rcu_assign_pointer(prev->next, next);
+}
+
+static inline void list_del_rcu(struct rcu_list_head *entry)
+{
+	__list_del_rcu(entry->prev, __rcu_dereference(entry->next));
 	entry->prev = LIST_POISON2;
 }
 
 /**
+ * list_empty - tests whether a list is empty
+ * @head: the list to test.
+ */
+static inline int list_empty_rcu(const struct rcu_list_head *head)
+{
+	return rcu_dereference(head->next) == head;
+}
+
+
+/**
  * hlist_del_init_rcu - deletes entry from hash list with re-initialization
  * @n: the element to delete from the hash list.
  *
@@ -117,7 +184,7 @@ static inline void list_del_rcu(struct list_head *entry)
  * perfectly legal to run concurrently with the _rcu list-traversal
  * primitives, such as hlist_for_each_entry_rcu().
  */
-static inline void hlist_del_init_rcu(struct hlist_node *n)
+static inline void hlist_del_init_rcu(struct rcu_hlist_node *n)
 {
 	if (!hlist_unhashed(n)) {
 		__hlist_del(n);
@@ -133,13 +200,13 @@ static inline void hlist_del_init_rcu(struct hlist_node *n)
  * The @old entry will be replaced with the @new entry atomically.
  * Note: @old should not be empty.
  */
-static inline void list_replace_rcu(struct list_head *old,
-				struct list_head *new)
+static inline void list_replace_rcu(struct rcu_list_head *old,
+				struct rcu_list_head *new)
 {
 	new->next = old->next;
 	new->prev = old->prev;
-	rcu_assign_pointer(new->prev->next, new);
-	new->next->prev = new;
+	__rcu_assign_pointer(new->prev->next, new);
+	rcu_dereference(new->next)->prev = new;
 	old->prev = LIST_POISON2;
 }
 
@@ -160,13 +227,13 @@ static inline void list_replace_rcu(struct list_head *old,
  *	based on call_rcu() could be created.  But only if -really-
  *	needed -- there is no shortage of RCU API members.
  */
-static inline void list_splice_init_rcu(struct list_head *list,
-					struct list_head *head,
+static inline void list_splice_init_rcu(struct rcu_list_head *list,
+					struct rcu_list_head *head,
 					void (*sync)(void))
 {
-	struct list_head *first = list->next;
-	struct list_head *last = list->prev;
-	struct list_head *at = head->next;
+	struct rcu_list_head *first = __rcu_dereference(list->next);
+	struct rcu_list_head *last = list->prev;
+	struct rcu_list_head *at = __rcu_dereference(head->next);
 
 	if (list_empty(head))
 		return;
@@ -192,7 +259,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	 * this function.
 	 */
 
-	last->next = at;
+	__rcu_assign_pointer(last->next,at);
 	rcu_assign_pointer(head->next, first);
 	first->prev = head;
 	at->prev = last;
@@ -200,7 +267,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
 
 /**
  * list_entry_rcu - get the struct for this entry
- * @ptr:        the &struct list_head pointer.
+ * @ptr:        the &struct rcu_list_head pointer.
  * @type:       the type of the struct this is embedded in.
  * @member:     the name of the list_struct within the struct.
  *
@@ -241,13 +308,13 @@ static inline void list_splice_init_rcu(struct list_head *list,
  */
 #define list_for_each_entry_rcu(pos, head, member) \
 	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
-		prefetch(pos->member.next), &pos->member != (head); \
+		prefetch(__rcu_dereference(pos->member.next)), &pos->member != (head); \
 		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
 
 /**
  * list_for_each_continue_rcu
- * @pos:	the &struct list_head to use as a loop cursor.
+ * @pos:	the &struct rcu_list_head to use as a loop cursor.
  * @head:	the head for your list.
  *
  * Iterate over an rcu-protected list, continuing after current point.
@@ -294,9 +361,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * the _rcu list-traversal primitives, such as
  * hlist_for_each_entry().
  */
-static inline void hlist_del_rcu(struct hlist_node *n)
+static inline void hlist_del_rcu(struct rcu_hlist_node *n)
 {
-	__hlist_del(n);
+	__hlist_del((struct hlist_node *)n);
 	n->pprev = LIST_POISON2;
 }
 
@@ -307,16 +374,16 @@ static inline void hlist_del_rcu(struct hlist_node *n)
  *
  * The @old entry will be replaced with the @new entry atomically.
  */
-static inline void hlist_replace_rcu(struct hlist_node *old,
-					struct hlist_node *new)
+static inline void hlist_replace_rcu(struct rcu_hlist_node *old,
+					struct rcu_hlist_node *new)
 {
-	struct hlist_node *next = old->next;
+	struct rcu_hlist_node __rcu *next = old->next;
 
 	new->next = next;
 	new->pprev = old->pprev;
 	rcu_assign_pointer(*new->pprev, new);
 	if (next)
-		new->next->pprev = &new->next;
+		__rcu_dereference(new->next)->pprev = &new->next;
 	old->pprev = LIST_POISON2;
 }
 
@@ -339,12 +406,12 @@ static inline void hlist_replace_rcu(struct hlist_node *old,
  * problems on Alpha CPUs.  Regardless of the type of CPU, the
  * list-traversal primitive must be guarded by rcu_read_lock().
  */
-static inline void hlist_add_head_rcu(struct hlist_node *n,
-					struct hlist_head *h)
+static inline void hlist_add_head_rcu(struct rcu_hlist_node *n,
+					struct rcu_hlist_head *h)
 {
-	struct hlist_node *first = h->first;
+	struct rcu_hlist_node *first = __rcu_dereference(h->first);
 
-	n->next = first;
+	__rcu_assign_pointer(n->next, first);
 	n->pprev = &h->first;
 	rcu_assign_pointer(h->first, n);
 	if (first)
@@ -369,8 +436,8 @@ static inline void hlist_add_head_rcu(struct hlist_node *n,
  * hlist_for_each_entry_rcu(), used to prevent memory-consistency
  * problems on Alpha CPUs.
  */
-static inline void hlist_add_before_rcu(struct hlist_node *n,
-					struct hlist_node *next)
+static inline void hlist_add_before_rcu(struct rcu_hlist_node *n,
+					struct rcu_hlist_node *next)
 {
 	n->pprev = next->pprev;
 	n->next = next;
@@ -396,8 +463,8 @@ static inline void hlist_add_before_rcu(struct hlist_node *n,
  * hlist_for_each_entry_rcu(), used to prevent memory-consistency
  * problems on Alpha CPUs.
  */
-static inline void hlist_add_after_rcu(struct hlist_node *prev,
-				       struct hlist_node *n)
+static inline void hlist_add_after_rcu(struct rcu_hlist_node *prev,
+				       struct rcu_hlist_node *n)
 {
 	n->next = prev->next;
 	n->pprev = &prev->next;
@@ -406,12 +473,17 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
 		n->next->pprev = &n->next;
 }
 
+static inline int hlist_empty_rcu(const struct rcu_hlist_head *h)
+{
+	return !__rcu_dereference(h->first);
+}
+
 /**
  * hlist_for_each_entry_rcu - iterate over rcu list of given type
  * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the &struct rcu_hlist_node to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
+ * @member:	the name of the rcu_hlist_node within the struct.
  *
  * This list-traversal primitive may safely run concurrently with
  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
@@ -419,7 +491,7 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
  */
 #define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
 	for (pos = rcu_dereference((head)->first);			 \
-		pos && ({ prefetch(pos->next); 1; }) &&			 \
+		pos && ({ prefetch(__rcu_dereference(pos->next)); 1; }) &&			 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
 		pos = rcu_dereference(pos->next))
 
-- 
1.6.3.3

