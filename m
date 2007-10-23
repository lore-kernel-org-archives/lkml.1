Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbXJWMJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbXJWMJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 08:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXJWMJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 08:09:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbXJWMJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 08:09:07 -0400
Message-Id: <20071023120745.122724000@chello.nl>
References: <20071023120357.782284000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 23 Oct 2007 14:04:00 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Daniel Walker <dwalker@mvista.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 3/5] rt: plist_head_splice
Content-Disposition: inline; filename=rt-plist-mods.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

merge-sort two plists together

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/plist.h |    2 +
 lib/plist.c           |   68 ++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 68 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/plist.h
===================================================================
--- linux-2.6.orig/include/linux/plist.h
+++ linux-2.6/include/linux/plist.h
@@ -148,6 +148,8 @@ static inline void plist_node_init(struc
 extern void plist_add(struct plist_node *node, struct plist_head *head);
 extern void plist_del(struct plist_node *node, struct plist_head *head);
 
+extern void plist_head_splice(struct plist_head *src, struct plist_head *dst);
+
 /**
  * plist_for_each - iterate over the plist
  * @pos:	the type * to use as a loop counter
Index: linux-2.6/lib/plist.c
===================================================================
--- linux-2.6.orig/lib/plist.c
+++ linux-2.6/lib/plist.c
@@ -66,6 +66,30 @@ static void plist_check_head(struct plis
 # define plist_check_head(h)	do { } while (0)
 #endif
 
+static inline struct plist_node *prev_node(struct plist_node *iter)
+{
+	return list_entry(iter->plist.node_list.prev, struct plist_node,
+			plist.node_list);
+}
+
+static inline struct plist_node *next_node(struct plist_node *iter)
+{
+	return list_entry(iter->plist.node_list.next, struct plist_node,
+			plist.node_list);
+}
+
+static inline struct plist_node *prev_prio(struct plist_node *iter)
+{
+	return list_entry(iter->plist.prio_list.prev, struct plist_node,
+			plist.prio_list);
+}
+
+static inline struct plist_node *next_prio(struct plist_node *iter)
+{
+	return list_entry(iter->plist.prio_list.next, struct plist_node,
+			plist.prio_list);
+}
+
 /**
  * plist_add - add @node to @head
  *
@@ -83,8 +107,7 @@ void plist_add(struct plist_node *node, 
 		if (node->prio < iter->prio)
 			goto lt_prio;
 		else if (node->prio == iter->prio) {
-			iter = list_entry(iter->plist.prio_list.next,
-					struct plist_node, plist.prio_list);
+			iter = next_prio(iter);
 			goto eq_prio;
 		}
 	}
@@ -118,3 +141,44 @@ void plist_del(struct plist_node *node, 
 
 	plist_check_head(head);
 }
+
+void plist_head_splice(struct plist_head *src, struct plist_head *dst)
+{
+	struct plist_node *src_iter_first, *src_iter_last, *dst_iter;
+	struct plist_node *tail = container_of(dst, struct plist_node, plist);
+
+	dst_iter = next_prio(tail);
+
+	while (!plist_head_empty(src) && dst_iter != tail) {
+		src_iter_first = plist_first(src);
+
+		src_iter_last = next_prio(src_iter_first);
+		src_iter_last = prev_node(src_iter_last);
+
+		WARN_ON(src_iter_first->prio != src_iter_last->prio);
+		WARN_ON(list_empty(&src_iter_first->plist.prio_list));
+
+		while (src_iter_first->prio > dst_iter->prio) {
+			dst_iter = next_prio(dst_iter);
+			if (dst_iter == tail)
+				goto tail;
+		}
+
+		list_del_init(&src_iter_first->plist.prio_list);
+
+		if (src_iter_first->prio < dst_iter->prio) {
+			list_add_tail(&src_iter_first->plist.node_list,
+					&dst_iter->plist.node_list);
+		} else if (src_iter_first->prio == dst_iter->prio) {
+			dst_iter = next_prio(dst_iter);
+		} else BUG();
+
+		list_splice2_tail(&src_iter_first->plist.node_list,
+			       	  &src_iter_last->plist.node_list,
+				  &dst_iter->plist.node_list);
+	}
+
+tail:
+	list_splice_tail_init(&src->prio_list, &dst->prio_list);
+	list_splice_tail_init(&src->node_list, &dst->node_list);
+}

--

