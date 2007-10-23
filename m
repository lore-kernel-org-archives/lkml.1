Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbXJWMK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbXJWMK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 08:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXJWMJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 08:09:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbXJWMJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 08:09:09 -0400
Message-Id: <20071023120744.879638000@chello.nl>
References: <20071023120357.782284000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 23 Oct 2007 14:03:59 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Daniel Walker <dwalker@mvista.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 2/5] rt: list_splice2
Content-Disposition: inline; filename=rt-list-mods.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce list_splice2{,_tail}() which will splice a sub-list denoted
by two list items instead of the full list.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 drivers/usb/host/ehci-q.c |    2 -
 include/linux/list.h      |   66 ++++++++++++++++++++++++++++++++++++++++------
 lib/lock_list.c           |    2 -
 3 files changed, 60 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/list.h
===================================================================
--- linux-2.6.orig/include/linux/list.h
+++ linux-2.6/include/linux/list.h
@@ -320,17 +320,17 @@ static inline int list_empty_careful(con
 }
 
 static inline void __list_splice(struct list_head *list,
-				 struct list_head *head)
+				 struct list_head *prev,
+				 struct list_head *next)
 {
 	struct list_head *first = list->next;
 	struct list_head *last = list->prev;
-	struct list_head *at = head->next;
 
-	first->prev = head;
-	head->next = first;
+	first->prev = prev;
+	prev->next = first;
 
-	last->next = at;
-	at->prev = last;
+	last->next = next;
+	next->prev = last;
 }
 
 /**
@@ -341,7 +341,13 @@ static inline void __list_splice(struct 
 static inline void list_splice(struct list_head *list, struct list_head *head)
 {
 	if (!list_empty(list))
-		__list_splice(list, head);
+		__list_splice(list, head, head->next);
+}
+
+static inline void list_splice_tail(struct list_head *list, struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice(list, head->prev, head);
 }
 
 /**
@@ -355,11 +361,55 @@ static inline void list_splice_init(stru
 				    struct list_head *head)
 {
 	if (!list_empty(list)) {
-		__list_splice(list, head);
+		__list_splice(list, head, head->next);
+		INIT_LIST_HEAD(list);
+	}
+}
+
+static inline void list_splice_tail_init(struct list_head *list,
+					 struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice(list, head->prev, head);
 		INIT_LIST_HEAD(list);
 	}
 }
 
+static inline void __list_splice2(struct list_head *first,
+	       			struct list_head *last,
+				struct list_head *prev,
+				struct list_head *next)
+{
+	first->prev->next = last->next;
+	last->next->prev = first->prev;
+
+	first->prev = prev;
+	prev->next = first;
+
+	last->next = next;
+	next->prev = last;
+}
+
+/**
+ * list_splice2 - join [first, last] to head
+ * @first: list item
+ * @last: list item further on the same list
+ * @head: the place to add it on another list
+ */
+static inline void list_splice2(struct list_head *first,
+				struct list_head *last,
+				struct list_head *head)
+{
+	__list_splice2(first, last, head, head->next);
+}
+
+static inline void list_splice2_tail(struct list_head *first,
+				     struct list_head *last,
+				     struct list_head *head)
+{
+	__list_splice2(first, last, head->prev, head);
+}
+
 /**
  * list_splice_init_rcu - splice an RCU-protected list into an existing list.
  * @list:	the RCU-protected list to splice
Index: linux-2.6/drivers/usb/host/ehci-q.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ehci-q.c
+++ linux-2.6/drivers/usb/host/ehci-q.c
@@ -887,7 +887,7 @@ static struct ehci_qh *qh_append_tds (
 
 			list_del (&qtd->qtd_list);
 			list_add (&dummy->qtd_list, qtd_list);
-			__list_splice (qtd_list, qh->qtd_list.prev);
+			list_splice_tail (qtd_list, &qh->qtd_list);
 
 			ehci_qtd_init(ehci, qtd, qtd->qtd_dma);
 			qh->dummy = qtd;
Index: linux-2.6/lib/lock_list.c
===================================================================
--- linux-2.6.orig/lib/lock_list.c
+++ linux-2.6/lib/lock_list.c
@@ -128,7 +128,7 @@ void lock_list_splice_init(struct lock_l
 	lock = __lock_list_reverse(list);
 	if (!list_empty(&list->head)) {
 		spin_lock_nested(&head->lock, LOCK_LIST_NESTING_NEXT);
-		__list_splice(&list->head, &head->head);
+		__list_splice(&list->head, &head->head, head->head.next);
 		INIT_LIST_HEAD(&list->head);
 		spin_unlock(&head->lock);
 	}

--

