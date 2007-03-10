Return-Path: <linux-kernel-owner+w=401wt.eu-S933523AbXCJHYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523AbXCJHYx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 02:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933519AbXCJHYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 02:24:50 -0500
Received: from mail16.syd.optusnet.com.au ([211.29.132.197]:58680 "EHLO
	mail16.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933518AbXCJHYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 02:24:49 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][RSDL-mm 1/6] lists: add list splice tail
Date: Sat, 10 Mar 2007 18:25:43 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1914
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703101825.44003.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Con Kolivas <kernel@kolivas.org>

Add a list_splice_tail variant of list_splice.

Patch-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

Index: linux-2.6.21-rc3-mm2/include/linux/list.h
===================================================================
--- linux-2.6.21-rc3-mm2.orig/include/linux/list.h	2007-03-08 22:03:18.000000000 +1100
+++ linux-2.6.21-rc3-mm2/include/linux/list.h	2007-03-10 13:41:56.000000000 +1100
@@ -333,6 +333,20 @@ static inline void __list_splice(struct 
 	at->prev = last;
 }
 
+static inline void __list_splice_tail(struct list_head *list,
+				      struct list_head *head)
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+	struct list_head *at = head->prev;
+
+	first->prev = at;
+	at->next = first;
+
+	last->next = head;
+	head->prev = last;
+}
+
 /**
  * list_splice - join two lists
  * @list: the new list to add.
@@ -345,6 +359,18 @@ static inline void list_splice(struct li
 }
 
 /**
+ * list_splice_tail - join two lists at one's tail
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ */
+static inline void list_splice_tail(struct list_head *list,
+				    struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice_tail(list, head);
+}
+
+/**
  * list_splice_init - join two lists and reinitialise the emptied list.
  * @list: the new list to add.
  * @head: the place to add it in the first list.
@@ -417,6 +443,22 @@ static inline void list_splice_init_rcu(
 }
 
 /**
+ * list_splice_tail_init - join 2 lists at one's tail & reinitialise emptied
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ *
+ * The list at @list is reinitialised
+ */
+static inline void list_splice_tail_init(struct list_head *list,
+					 struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice_tail(list, head);
+		INIT_LIST_HEAD(list);
+	}
+}
+
+/**
  * list_entry - get the struct for this entry
  * @ptr:	the &struct list_head pointer.
  * @type:	the type of the struct this is embedded in.

-- 
-ck
