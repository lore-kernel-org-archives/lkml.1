Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZEZMOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZEZMOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbZEZMOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:14:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:51275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325AbZEZMOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:14:03 -0400
Date: Tue, 26 May 2009 12:13:26 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Add our private copy of list.h
Message-ID: <tip-040e6034124c504d536736ce08e4643e640cd7c2@git.kernel.org>
Git-Commit-ID: 040e6034124c504d536736ce08e4643e640cd7c2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 12:13:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  040e6034124c504d536736ce08e4643e640cd7c2
Gitweb:     http://git.kernel.org/tip/040e6034124c504d536736ce08e4643e640cd7c2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 18 May 2009 16:25:31 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 13:52:55 +0200

perf_counter: Add our private copy of list.h

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 .../perf_counter/util}/list.h                      |  238 ++++++--------------
 1 files changed, 73 insertions(+), 165 deletions(-)

diff --git a/include/linux/list.h b/Documentation/perf_counter/util/list.h
similarity index 74%
copy from include/linux/list.h
copy to Documentation/perf_counter/util/list.h
index 969f6e9..e2548e8 100644
--- a/include/linux/list.h
+++ b/Documentation/perf_counter/util/list.h
@@ -1,10 +1,33 @@
 #ifndef _LINUX_LIST_H
 #define _LINUX_LIST_H
+/*
+  Copyright (C) Cast of dozens, comes from the Linux kernel
+
+  This program is free software; you can redistribute it and/or modify it
+  under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+*/
+
+#include <stddef.h>
+
+/*
+ * These are non-NULL pointers that will result in page faults
+ * under normal circumstances, used to verify that nobody uses
+ * non-initialized list entries.
+ */
+#define LIST_POISON1 ((void *)0x00100100)
+#define LIST_POISON2 ((void *)0x00200200)
 
-#include <linux/stddef.h>
-#include <linux/poison.h>
-#include <linux/prefetch.h>
-#include <asm/system.h>
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({			\
+        const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+        (type *)( (char *)__mptr - offsetof(type,member) );})
 
 /*
  * Simple doubly linked list implementation.
@@ -37,7 +60,6 @@ static inline void INIT_LIST_HEAD(struct list_head *list)
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
-#ifndef CONFIG_DEBUG_LIST
 static inline void __list_add(struct list_head *new,
 			      struct list_head *prev,
 			      struct list_head *next)
@@ -47,11 +69,6 @@ static inline void __list_add(struct list_head *new,
 	new->prev = prev;
 	prev->next = new;
 }
-#else
-extern void __list_add(struct list_head *new,
-			      struct list_head *prev,
-			      struct list_head *next);
-#endif
 
 /**
  * list_add - add a new entry
@@ -66,7 +83,6 @@ static inline void list_add(struct list_head *new, struct list_head *head)
 	__list_add(new, head, head->next);
 }
 
-
 /**
  * list_add_tail - add a new entry
  * @new: new entry to be added
@@ -96,26 +112,35 @@ static inline void __list_del(struct list_head * prev, struct list_head * next)
 /**
  * list_del - deletes entry from list.
  * @entry: the element to delete from the list.
- * Note: list_empty() on entry does not return true after this, the entry is
+ * Note: list_empty on entry does not return true after this, the entry is
  * in an undefined state.
  */
-#ifndef CONFIG_DEBUG_LIST
 static inline void list_del(struct list_head *entry)
 {
 	__list_del(entry->prev, entry->next);
 	entry->next = LIST_POISON1;
 	entry->prev = LIST_POISON2;
 }
-#else
-extern void list_del(struct list_head *entry);
-#endif
+
+/**
+ * list_del_range - deletes range of entries from list.
+ * @beging: first element in the range to delete from the list.
+ * @beging: first element in the range to delete from the list.
+ * Note: list_empty on the range of entries does not return true after this,
+ * the entries is in an undefined state.
+ */
+static inline void list_del_range(struct list_head *begin,
+				  struct list_head *end)
+{
+	begin->prev->next = end->next;
+	end->next->prev = begin->prev;
+}
 
 /**
  * list_replace - replace old entry by new one
  * @old : the element to be replaced
  * @new : the new element to insert
- *
- * If @old was empty, it will be overwritten.
+ * Note: if 'old' was empty, it will be overwritten.
  */
 static inline void list_replace(struct list_head *old,
 				struct list_head *new)
@@ -150,8 +175,8 @@ static inline void list_del_init(struct list_head *entry)
  */
 static inline void list_move(struct list_head *list, struct list_head *head)
 {
-	__list_del(list->prev, list->next);
-	list_add(list, head);
+        __list_del(list->prev, list->next);
+        list_add(list, head);
 }
 
 /**
@@ -162,8 +187,8 @@ static inline void list_move(struct list_head *list, struct list_head *head)
 static inline void list_move_tail(struct list_head *list,
 				  struct list_head *head)
 {
-	__list_del(list->prev, list->next);
-	list_add_tail(list, head);
+        __list_del(list->prev, list->next);
+        list_add_tail(list, head);
 }
 
 /**
@@ -205,91 +230,29 @@ static inline int list_empty_careful(const struct list_head *head)
 	return (next == head) && (next == head->prev);
 }
 
-/**
- * list_is_singular - tests whether a list has just one entry.
- * @head: the list to test.
- */
-static inline int list_is_singular(const struct list_head *head)
-{
-	return !list_empty(head) && (head->next == head->prev);
-}
-
-static inline void __list_cut_position(struct list_head *list,
-		struct list_head *head, struct list_head *entry)
-{
-	struct list_head *new_first = entry->next;
-	list->next = head->next;
-	list->next->prev = list;
-	list->prev = entry;
-	entry->next = list;
-	head->next = new_first;
-	new_first->prev = head;
-}
-
-/**
- * list_cut_position - cut a list into two
- * @list: a new list to add all removed entries
- * @head: a list with entries
- * @entry: an entry within head, could be the head itself
- *	and if so we won't cut the list
- *
- * This helper moves the initial part of @head, up to and
- * including @entry, from @head to @list. You should
- * pass on @entry an element you know is on @head. @list
- * should be an empty list or a list you do not care about
- * losing its data.
- *
- */
-static inline void list_cut_position(struct list_head *list,
-		struct list_head *head, struct list_head *entry)
-{
-	if (list_empty(head))
-		return;
-	if (list_is_singular(head) &&
-		(head->next != entry && head != entry))
-		return;
-	if (entry == head)
-		INIT_LIST_HEAD(list);
-	else
-		__list_cut_position(list, head, entry);
-}
-
-static inline void __list_splice(const struct list_head *list,
-				 struct list_head *prev,
-				 struct list_head *next)
+static inline void __list_splice(struct list_head *list,
+				 struct list_head *head)
 {
 	struct list_head *first = list->next;
 	struct list_head *last = list->prev;
+	struct list_head *at = head->next;
 
-	first->prev = prev;
-	prev->next = first;
-
-	last->next = next;
-	next->prev = last;
-}
+	first->prev = head;
+	head->next = first;
 
-/**
- * list_splice - join two lists, this is designed for stacks
- * @list: the new list to add.
- * @head: the place to add it in the first list.
- */
-static inline void list_splice(const struct list_head *list,
-				struct list_head *head)
-{
-	if (!list_empty(list))
-		__list_splice(list, head, head->next);
+	last->next = at;
+	at->prev = last;
 }
 
 /**
- * list_splice_tail - join two lists, each list being a queue
+ * list_splice - join two lists
  * @list: the new list to add.
  * @head: the place to add it in the first list.
  */
-static inline void list_splice_tail(struct list_head *list,
-				struct list_head *head)
+static inline void list_splice(struct list_head *list, struct list_head *head)
 {
 	if (!list_empty(list))
-		__list_splice(list, head->prev, head);
+		__list_splice(list, head);
 }
 
 /**
@@ -303,24 +266,7 @@ static inline void list_splice_init(struct list_head *list,
 				    struct list_head *head)
 {
 	if (!list_empty(list)) {
-		__list_splice(list, head, head->next);
-		INIT_LIST_HEAD(list);
-	}
-}
-
-/**
- * list_splice_tail_init - join two lists and reinitialise the emptied list
- * @list: the new list to add.
- * @head: the place to add it in the first list.
- *
- * Each of the lists is a queue.
- * The list at @list is reinitialised
- */
-static inline void list_splice_tail_init(struct list_head *list,
-					 struct list_head *head)
-{
-	if (!list_empty(list)) {
-		__list_splice(list, head->prev, head);
+		__list_splice(list, head);
 		INIT_LIST_HEAD(list);
 	}
 }
@@ -336,9 +282,9 @@ static inline void list_splice_tail_init(struct list_head *list,
 
 /**
  * list_first_entry - get the first element from a list
- * @ptr:	the list head to take the element from.
- * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
+ * @ptr:       the list head to take the element from.
+ * @type:      the type of the struct this is embedded in.
+ * @member:    the name of the list_struct within the struct.
  *
  * Note, that list is expected to be not empty.
  */
@@ -351,7 +297,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @head:	the head for your list.
  */
 #define list_for_each(pos, head) \
-	for (pos = (head)->next; prefetch(pos->next), pos != (head); \
+	for (pos = (head)->next; pos != (head); \
         	pos = pos->next)
 
 /**
@@ -373,7 +319,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @head:	the head for your list.
  */
 #define list_for_each_prev(pos, head) \
-	for (pos = (head)->prev; prefetch(pos->prev), pos != (head); \
+	for (pos = (head)->prev; pos != (head); \
         	pos = pos->prev)
 
 /**
@@ -387,17 +333,6 @@ static inline void list_splice_tail_init(struct list_head *list,
 		pos = n, n = pos->next)
 
 /**
- * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
- * @pos:	the &struct list_head to use as a loop cursor.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
- */
-#define list_for_each_prev_safe(pos, n, head) \
-	for (pos = (head)->prev, n = pos->prev; \
-	     prefetch(pos->prev), pos != (head); \
-	     pos = n, n = pos->prev)
-
-/**
  * list_for_each_entry	-	iterate over list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
@@ -405,7 +340,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_entry((head)->next, typeof(*pos), member);	\
-	     prefetch(pos->member.next), &pos->member != (head); 	\
+	     &pos->member != (head); 	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
@@ -416,16 +351,16 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
 	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
-	     prefetch(pos->member.prev), &pos->member != (head); 	\
+	     &pos->member != (head); 	\
 	     pos = list_entry(pos->member.prev, typeof(*pos), member))
 
 /**
- * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue()
+ * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue
  * @pos:	the type * to use as a start point
  * @head:	the head of the list
  * @member:	the name of the list_struct within the struct.
  *
- * Prepares a pos entry for use as a start point in list_for_each_entry_continue().
+ * Prepares a pos entry for use as a start point in list_for_each_entry_continue.
  */
 #define list_prepare_entry(pos, head, member) \
 	((pos) ? : list_entry(head, typeof(*pos), member))
@@ -441,24 +376,10 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry_continue(pos, head, member) 		\
 	for (pos = list_entry(pos->member.next, typeof(*pos), member);	\
-	     prefetch(pos->member.next), &pos->member != (head);	\
+	     &pos->member != (head);	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
- * list_for_each_entry_continue_reverse - iterate backwards from the given point
- * @pos:	the type * to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * Start to iterate over list of given type backwards, continuing after
- * the current position.
- */
-#define list_for_each_entry_continue_reverse(pos, head, member)		\
-	for (pos = list_entry(pos->member.prev, typeof(*pos), member);	\
-	     prefetch(pos->member.prev), &pos->member != (head);	\
-	     pos = list_entry(pos->member.prev, typeof(*pos), member))
-
-/**
  * list_for_each_entry_from - iterate over list of given type from the current point
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
@@ -467,7 +388,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * Iterate over list of given type, continuing from current position.
  */
 #define list_for_each_entry_from(pos, head, member) 			\
-	for (; prefetch(pos->member.next), &pos->member != (head);	\
+	for (; &pos->member != (head);	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
@@ -619,23 +540,10 @@ static inline void hlist_add_after(struct hlist_node *n,
 		next->next->pprev  = &next->next;
 }
 
-/*
- * Move a list from one list head to another. Fixup the pprev
- * reference of the first entry if it exists.
- */
-static inline void hlist_move_list(struct hlist_head *old,
-				   struct hlist_head *new)
-{
-	new->first = old->first;
-	if (new->first)
-		new->first->pprev = &new->first;
-	old->first = NULL;
-}
-
 #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
 
 #define hlist_for_each(pos, head) \
-	for (pos = (head)->first; pos && ({ prefetch(pos->next); 1; }); \
+	for (pos = (head)->first; pos; \
 	     pos = pos->next)
 
 #define hlist_for_each_safe(pos, n, head) \
@@ -651,7 +559,7 @@ static inline void hlist_move_list(struct hlist_head *old,
  */
 #define hlist_for_each_entry(tpos, pos, head, member)			 \
 	for (pos = (head)->first;					 \
-	     pos && ({ prefetch(pos->next); 1;}) &&			 \
+	     pos && 			 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = pos->next)
 
@@ -663,7 +571,7 @@ static inline void hlist_move_list(struct hlist_head *old,
  */
 #define hlist_for_each_entry_continue(tpos, pos, member)		 \
 	for (pos = (pos)->next;						 \
-	     pos && ({ prefetch(pos->next); 1;}) &&			 \
+	     pos && 			 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = pos->next)
 
@@ -674,7 +582,7 @@ static inline void hlist_move_list(struct hlist_head *old,
  * @member:	the name of the hlist_node within the struct.
  */
 #define hlist_for_each_entry_from(tpos, pos, member)			 \
-	for (; pos && ({ prefetch(pos->next); 1;}) &&			 \
+	for (; pos && 			 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = pos->next)
 
