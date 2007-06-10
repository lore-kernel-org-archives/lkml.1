Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbXFJFLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbXFJFLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 01:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbXFJFLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 01:11:43 -0400
Received: from ozlabs.org ([203.10.76.45]:57371 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbXFJFLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 01:11:42 -0400
Subject: [PATCH RFC] struct list_node
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 10 Jun 2007 15:11:30 +1000
Message-Id: <1181452290.16428.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current list.h has the same type for list elements and list heads
even though most code and coders treat them as distinct.

I've had a version of list.h (for userspace work) for about a year
which uses a different type for nodes and it works very well: code is
clearer, and mistakes like list_add() argument reversal are detected.
Code which really wants to treat a list node as a head can append ".h".

To avoid a massive flag day, this patch uses gcc's "cast to union" to
allow either list_head or list_node in various places.

Notes:
1) A new function in_list() is introduced, equivalent to "list_empty(&e)"
   but for nodes.
2) The duplicated kerneldoc in list_debug.c is excised.
3) The more obscure list functions have yet to be converted.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r bea2b8147985 include/linux/list.h
--- a/include/linux/list.h	Thu Jun 07 22:50:36 2007 +1000
+++ b/include/linux/list.h	Sun Jun 10 14:56:56 2007 +1000
@@ -22,6 +22,26 @@ struct list_head {
 	struct list_head *next, *prev;
 };
 
+/* A list node is the same as the head of the list, but it's useful to
+ * think of them as a separate type. */
+struct list_node {
+	struct list_head h;
+};
+
+/* This allows us to support old style list_head as well as list_node. */
+union list_head_or_node {
+	struct list_head *_h;
+	struct list_node *_n;
+};
+union list_head_or_node_const {
+	struct list_head *_h;
+	struct list_node *_n;
+	const struct list_head *_ch;
+	const struct list_node *_cn;
+};
+#define __lh(n) (((union list_head_or_node)(n))._h)
+#define __clh(n) (((union list_head_or_node_const)(n))._h)
+
 #define LIST_HEAD_INIT(name) { &(name), &(name) }
 
 #define LIST_HEAD(name) \
@@ -63,15 +83,15 @@ extern void __list_add(struct list_head 
  * Insert a new entry after the specified head.
  * This is good for implementing stacks.
  */
+#define list_add(new, head) list_add_lh(__lh(new), head)
 #ifndef CONFIG_DEBUG_LIST
-static inline void list_add(struct list_head *new, struct list_head *head)
+static inline void list_add_lh(struct list_head *new, struct list_head *head)
 {
 	__list_add(new, head, head->next);
 }
 #else
-extern void list_add(struct list_head *new, struct list_head *head);
+extern void list_add_lh(struct list_head *new, struct list_head *head);
 #endif
-
 
 /**
  * list_add_tail - add a new entry
@@ -81,7 +101,9 @@ extern void list_add(struct list_head *n
  * Insert a new entry before the specified head.
  * This is useful for implementing queues.
  */
-static inline void list_add_tail(struct list_head *new, struct list_head *head)
+#define list_add_tail(new, head) list_add_tail_lh(__lh(new), head)
+static inline void list_add_tail_lh(struct list_head *new,
+				    struct list_head *head)
 {
 	__list_add(new, head->prev, head);
 }
@@ -118,7 +140,9 @@ static inline void __list_add_rcu(struct
  * the _rcu list-traversal primitives, such as
  * list_for_each_entry_rcu().
  */
-static inline void list_add_rcu(struct list_head *new, struct list_head *head)
+#define list_add_rcu(new, head) list_add_rcu_lh(__lh(new), (head))
+static inline void list_add_rcu_lh(struct list_head *new,
+				   struct list_head *head)
 {
 	__list_add_rcu(new, head, head->next);
 }
@@ -139,7 +163,8 @@ static inline void list_add_rcu(struct l
  * the _rcu list-traversal primitives, such as
  * list_for_each_entry_rcu().
  */
-static inline void list_add_tail_rcu(struct list_head *new,
+#define list_add_tail_rcu(new, head) list_add_tail_rcu_lh(__lh(new), (head))
+static inline void list_add_tail_rcu_lh(struct list_head *new,
 					struct list_head *head)
 {
 	__list_add_rcu(new, head->prev, head);
@@ -164,15 +189,16 @@ static inline void __list_del(struct lis
  * Note: list_empty() on entry does not return true after this, the entry is
  * in an undefined state.
  */
+#define list_del(entry) list_del_lh(__lh(entry))
 #ifndef CONFIG_DEBUG_LIST
-static inline void list_del(struct list_head *entry)
+static inline void list_del_lh(struct list_head *entry)
 {
 	__list_del(entry->prev, entry->next);
 	entry->next = LIST_POISON1;
 	entry->prev = LIST_POISON2;
 }
 #else
-extern void list_del(struct list_head *entry);
+extern void list_del_lh(struct list_head *entry);
 #endif
 
 /**
@@ -199,7 +225,8 @@ extern void list_del(struct list_head *e
  * or call_rcu() must be used to defer freeing until an RCU
  * grace period has elapsed.
  */
-static inline void list_del_rcu(struct list_head *entry)
+#define list_del_rcu(e) list_del_rcu_lh(__lh(e))
+static inline void list_del_rcu_lh(struct list_head *entry)
 {
 	__list_del(entry->prev, entry->next);
 	entry->prev = LIST_POISON2;
@@ -251,7 +278,8 @@ static inline void list_replace_rcu(stru
  * list_del_init - deletes entry from list and reinitialize it.
  * @entry: the element to delete from the list.
  */
-static inline void list_del_init(struct list_head *entry)
+#define list_del_init(e) list_del_init_lh(__lh(e))
+static inline void list_del_init_lh(struct list_head *entry)
 {
 	__list_del(entry->prev, entry->next);
 	INIT_LIST_HEAD(entry);
@@ -259,10 +287,12 @@ static inline void list_del_init(struct 
 
 /**
  * list_move - delete from one list and add as another's head
- * @list: the entry to move
+ * @e: the entry to move
  * @head: the head that will precede our entry
  */
-static inline void list_move(struct list_head *list, struct list_head *head)
+#define list_move(e, head) list_move_lh(__lh(e), (head))
+static inline void list_move_lh(struct list_head *list,
+				struct list_head *head)
 {
 	__list_del(list->prev, list->next);
 	list_add(list, head);
@@ -270,11 +300,12 @@ static inline void list_move(struct list
 
 /**
  * list_move_tail - delete from one list and add as another's tail
- * @list: the entry to move
+ * @e: the entry to move
  * @head: the head that will follow our entry
  */
-static inline void list_move_tail(struct list_head *list,
-				  struct list_head *head)
+#define list_move_tail(e, head) list_move_tail_lh(__lh(e), (head))
+static inline void list_move_tail_lh(struct list_head *list,
+				     struct list_head *head)
 {
 	__list_del(list->prev, list->next);
 	list_add_tail(list, head);
@@ -282,11 +313,12 @@ static inline void list_move_tail(struct
 
 /**
  * list_is_last - tests whether @list is the last entry in list @head
- * @list: the entry to test
+ * @e: the entry to test
  * @head: the head of the list
  */
-static inline int list_is_last(const struct list_head *list,
-				const struct list_head *head)
+#define list_is_last(e, head) list_is_last_lh(__clh(e), (head))
+static inline int list_is_last_lh(const struct list_head *list,
+				  const struct list_head *head)
 {
 	return list->next == head;
 }
@@ -298,6 +330,17 @@ static inline int list_empty(const struc
 static inline int list_empty(const struct list_head *head)
 {
 	return head->next == head;
+}
+
+/**
+ * in_list - tests whether element is in a list.
+ * @entry: the entry to test
+ *
+ * Returns false if the list elem was deleted from list (except __list_del)
+ */
+static inline int in_list(const struct list_node *entry)
+{
+	return entry->h.next == &entry->h;
 }
 
 /**
@@ -418,12 +461,13 @@ static inline void list_splice_init_rcu(
 
 /**
  * list_entry - get the struct for this entry
- * @ptr:	the &struct list_head pointer.
+ * @ptr:	the &struct list_node pointer.
  * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_entry(ptr, type, member) \
-	container_of(ptr, type, member)
+ * @member:	the name of the list_node within the struct.
+ */
+#define list_entry(ptr, type, member) ({				\
+	const typeof(((type *)0)->member) *__mptr = (void *)(ptr);	\
+	(type *)( (char *)__mptr - offsetof(type,member) );})
 
 /**
  * list_first_entry - get the first element from a list
@@ -481,12 +525,12 @@ static inline void list_splice_init_rcu(
  * list_for_each_entry	-	iterate over list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @member:	the name of the list_node within the struct.
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_entry((head)->next, typeof(*pos), member);	\
-	     prefetch(pos->member.next), &pos->member != (head); 	\
-	     pos = list_entry(pos->member.next, typeof(*pos), member))
+	     prefetch(__clh(&pos->member)->next), __clh(&pos->member) != (head); \
+	     pos = list_entry(__clh(&pos->member)->next, typeof(*pos), member))
 
 /**
  * list_for_each_entry_reverse - iterate backwards over list of given type.
diff -r bea2b8147985 lib/list_debug.c
--- a/lib/list_debug.c	Thu Jun 07 22:50:36 2007 +1000
+++ b/lib/list_debug.c	Sun Jun 10 14:28:57 2007 +1000
@@ -39,27 +39,13 @@ void __list_add(struct list_head *new,
 }
 EXPORT_SYMBOL(__list_add);
 
-/**
- * list_add - add a new entry
- * @new: new entry to be added
- * @head: list head to add it after
- *
- * Insert a new entry after the specified head.
- * This is good for implementing stacks.
- */
-void list_add(struct list_head *new, struct list_head *head)
+void list_add_lh(struct list_head *new, struct list_head *head)
 {
 	__list_add(new, head, head->next);
 }
-EXPORT_SYMBOL(list_add);
+EXPORT_SYMBOL(list_add_lh);
 
-/**
- * list_del - deletes entry from list.
- * @entry: the element to delete from the list.
- * Note: list_empty on entry does not return true after this, the entry is
- * in an undefined state.
- */
-void list_del(struct list_head *entry)
+void list_del_lh(struct list_head *entry)
 {
 	if (unlikely(entry->prev->next != entry)) {
 		printk(KERN_ERR "list_del corruption. prev->next should be %p, "
@@ -75,4 +61,4 @@ void list_del(struct list_head *entry)
 	entry->next = LIST_POISON1;
 	entry->prev = LIST_POISON2;
 }
-EXPORT_SYMBOL(list_del);
+EXPORT_SYMBOL(list_del_lh);


