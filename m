Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbZCOP0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbZCOP0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 11:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZCOP0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 11:26:12 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:60471 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZCOP0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 11:26:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xb+50YtztPLn4TgUHudolzRxtmFjRKg6y3bbGG52Js+OpZ25IbxZ8eqsyOvioBPB0u
         IbIpjXzvnPJztS/HT01sPlaMDA0tINy4T+ZqmJOWSm0XwXvJmLu8NgauohVL0aNkf7z4
         pDjYhfLOYjsdt0bltg4uDDRDvdCv32iU4VmK4=
Date: Mon, 16 Mar 2009 00:25:02 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 2/2] list: DEBUG_LIST for hlist
Message-ID: <20090315152501.GB29167@localhost.localdomain>
References: <20090315152336.GA29167@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20090315152336.GA29167@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sanity checks in hlist manipulation when CONFIG_DEBUG_LIST is enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 include/linux/list.h |   18 ++++++++++++++++++
 lib/list_debug.c     |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

Index: 2.6/include/linux/list.h
===================================================================
--- 2.6.orig/include/linux/list.h
+++ 2.6/include/linux/list.h
@@ -564,6 +564,12 @@ static inline int hlist_empty(const stru
 	return !h->first;
 }
 
+#ifdef CONFIG_DEBUG_LIST
+
+extern void __hlist_del(struct hlist_node *n);
+
+#else
+
 static inline void __hlist_del(struct hlist_node *n)
 {
 	struct hlist_node *next = n->next;
@@ -573,6 +579,8 @@ static inline void __hlist_del(struct hl
 		next->pprev = pprev;
 }
 
+#endif
+
 static inline void hlist_del(struct hlist_node *n)
 {
 	__hlist_del(n);
@@ -592,6 +600,14 @@ static inline void hlist_del_init(struct
  * This is only for internal hlist manipulation where we know
  * the pprev/next entries already!
  */
+
+#ifdef CONFIG_DEBUG_LIST
+
+extern void __hlist_add(struct hlist_node *new,
+			struct hlist_node **pprev, struct hlist_node *next);
+
+#else
+
 static inline void __hlist_add(struct hlist_node *new,
 			struct hlist_node **pprev, struct hlist_node *next)
 {
@@ -602,6 +618,8 @@ static inline void __hlist_add(struct hl
 	new->pprev = pprev;
 }
 
+#endif
+
 static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
 {
 	__hlist_add(n, &h->first, h->first);
Index: 2.6/lib/list_debug.c
===================================================================
--- 2.6.orig/lib/list_debug.c
+++ 2.6/lib/list_debug.c
@@ -54,3 +54,41 @@ void list_del(struct list_head *entry)
 	entry->prev = LIST_POISON2;
 }
 EXPORT_SYMBOL(list_del);
+
+void __hlist_del(struct hlist_node *n)
+{
+	struct hlist_node *next = n->next;
+	struct hlist_node **pprev = n->pprev;
+
+	WARN(next && next->pprev != &n->next,
+		"hlist_del corruption. next->pprev should be %p, but was %p\n",
+		&n->next, next->pprev);
+	WARN(*pprev != n,
+		"hlist_del corruption. *pprev should be %p, but was %p\n",
+		n, *pprev);
+
+	*pprev = next;
+	if (next)
+		next->pprev = pprev;
+}
+EXPORT_SYMBOL(__hlist_del);
+
+void __hlist_add(struct hlist_node *new,
+			struct hlist_node **pprev, struct hlist_node *next)
+{
+	WARN(next && next->pprev != pprev,
+		"hlist_add corruption. next->pprev should be pprev (%p), "
+		"but was %p. (next=%p).\n",
+		pprev, next->pprev, next);
+	WARN(*pprev != next,
+		"hlist_add corruption. *pprev should be next (%p), "
+		"but was %p. (pprev=%p).\n",
+		next, *pprev, pprev);
+
+	new->next = next;
+	if (next)
+		next->pprev = &new->next;
+	*pprev = new;
+	new->pprev = pprev;
+}
+EXPORT_SYMBOL(__hlist_add);
