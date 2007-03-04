Return-Path: <linux-kernel-owner+w=401wt.eu-S1751442AbXCDHC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbXCDHC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 02:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbXCDHC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 02:02:27 -0500
Received: from mail31.syd.optusnet.com.au ([211.29.132.102]:48519 "EHLO
	mail31.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbXCDHC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 02:02:26 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: [PATCH] [RSDL 1/6] lists: add list splice tail
Date: Sun, 4 Mar 2007 18:02:13 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2843
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703041802.13991.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a list_splice_tail variant of list_splice.

Patch-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 include/linux/list.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

Index: linux-2.6.20-rsdl/include/linux/list.h
===================================================================
--- linux-2.6.20-rsdl.orig/include/linux/list.h	2007-03-04 17:30:25.000000000 +1100
+++ linux-2.6.20-rsdl/include/linux/list.h	2007-03-04 17:30:30.000000000 +1100
@@ -332,6 +332,20 @@ static inline void __list_splice(struct 
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
@@ -344,6 +358,18 @@ static inline void list_splice(struct li
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
@@ -360,6 +386,22 @@ static inline void list_splice_init(stru
 }
 
 /**
+ * list_splice_init - join two lists at one's tail and reinitialise emptied
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
