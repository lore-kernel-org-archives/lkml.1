Return-Path: <linux-kernel-owner+w=401wt.eu-S935721AbYEBS2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935721AbYEBS2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbYEBS2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:28:04 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43855 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbYEBS2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:28:02 -0400
Date: Fri, 2 May 2008 12:27:46 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: [PATCH] Extend list debugging to cover hlists
Message-ID: <20080502182745.GL14976@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We've seen a couple of recent reports which point to corrupt hlists.
The DEBUG_LIST config option only checks regular lists, but it's not hard
to cover hlists too.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/include/linux/list.h b/include/linux/list.h
index 08cf4f6..a325d9f 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -714,10 +714,17 @@ static inline int hlist_empty(const struct hlist_head *h)
 	return !h->first;
 }
 
+#ifdef CONFIG_DEBUG_LIST
+extern void hlist_check(struct hlist_node *n);
+#else
+#define hlist_check(n)		do { } while (0)
+#endif
+
 static inline void __hlist_del(struct hlist_node *n)
 {
 	struct hlist_node *next = n->next;
 	struct hlist_node **pprev = n->pprev;
+	hlist_check(n);
 	*pprev = next;
 	if (next)
 		next->pprev = pprev;
@@ -775,6 +782,7 @@ static inline void hlist_replace_rcu(struct hlist_node *old,
 {
 	struct hlist_node *next = old->next;
 
+	hlist_check(old);
 	new->next = next;
 	new->pprev = old->pprev;
 	smp_wmb();
@@ -830,6 +838,7 @@ static inline void hlist_add_head_rcu(struct hlist_node *n,
 static inline void hlist_add_before(struct hlist_node *n,
 					struct hlist_node *next)
 {
+	hlist_check(next);
 	n->pprev = next->pprev;
 	n->next = next;
 	next->pprev = &n->next;
@@ -839,6 +848,7 @@ static inline void hlist_add_before(struct hlist_node *n,
 static inline void hlist_add_after(struct hlist_node *n,
 					struct hlist_node *next)
 {
+	hlist_check(next);
 	next->next = n->next;
 	n->next = next;
 	next->pprev = &n->next;
@@ -868,6 +878,7 @@ static inline void hlist_add_after(struct hlist_node *n,
 static inline void hlist_add_before_rcu(struct hlist_node *n,
 					struct hlist_node *next)
 {
+	hlist_check(next);
 	n->pprev = next->pprev;
 	n->next = next;
 	smp_wmb();
@@ -896,6 +907,7 @@ static inline void hlist_add_before_rcu(struct hlist_node *n,
 static inline void hlist_add_after_rcu(struct hlist_node *prev,
 				       struct hlist_node *n)
 {
+	hlist_check(prev);
 	n->next = prev->next;
 	n->pprev = &prev->next;
 	smp_wmb();
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 4350ba9..00b56bf 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -1,5 +1,8 @@
 /*
  * Copyright 2006, Red Hat, Inc., Dave Jones
+ * Copyright 2008 Intel Corporation
+ * Author: Matthew Wilcox <willy@linux.intel.com>
+ *
  * Released under the General Public License (GPL).
  *
  * This file contains the linked list implementations for
@@ -76,3 +79,18 @@ void list_del(struct list_head *entry)
 	entry->prev = LIST_POISON2;
 }
 EXPORT_SYMBOL(list_del);
+
+void hlist_check(struct hlist_node *n)
+{
+	if (unlikely(*n->pprev != n)) {
+		printk(KERN_ERR "hlist corruption. *pprev should be %p, "
+				"but was %p\n", n, *n->pprev);
+		BUG();
+	}
+	if (unlikely(n->next != NULL && n->next->pprev != &n->next)) {
+		printk(KERN_ERR "hlist corruption. n->next->pprev should be"
+				"%p, but was %p\n", &n->next, n->next->pprev);
+		BUG();
+	}
+}
+EXPORT_SYMBOL(hlist_check);

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
