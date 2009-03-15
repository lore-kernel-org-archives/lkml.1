Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZCOPY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZCOPY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 11:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZCOPYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 11:24:49 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:64025 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbZCOPYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 11:24:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=C6N6IBC3kbQxcYzQoT92u/XRNHrS27rEaAopiSzV9faXFWfffXg3pUH8Kb1MPys2R1
         uGRzf/FhFgO6Rd8OWBYLlEyazQjMZL1ds3iQyAGNqXpWYVW1U8iEW0iJadQ4ERXDen6C
         8RL3Kk3qq9aFJ+VFk8Eeakr1+dK5qjUXP9jeg=
Date: Mon, 16 Mar 2009 00:23:37 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 1/2] list: unify hlist_add functions
Message-ID: <20090315152336.GA29167@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify hlist_add_head(), hlist_add_before(), and hlist_add_after().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 include/linux/list.h |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

Index: 2.6/include/linux/list.h
===================================================================
--- 2.6.orig/include/linux/list.h
+++ 2.6/include/linux/list.h
@@ -588,35 +588,36 @@ static inline void hlist_del_init(struct
 	}
 }
 
+/*
+ * This is only for internal hlist manipulation where we know
+ * the pprev/next entries already!
+ */
+static inline void __hlist_add(struct hlist_node *new,
+			struct hlist_node **pprev, struct hlist_node *next)
+{
+	new->next = next;
+	if (next)
+		next->pprev = &new->next;
+	*pprev = new;
+	new->pprev = pprev;
+}
+
 static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
 {
-	struct hlist_node *first = h->first;
-	n->next = first;
-	if (first)
-		first->pprev = &n->next;
-	h->first = n;
-	n->pprev = &h->first;
+	__hlist_add(n, &h->first, h->first);
 }
 
 /* next must be != NULL */
 static inline void hlist_add_before(struct hlist_node *n,
 					struct hlist_node *next)
 {
-	n->pprev = next->pprev;
-	n->next = next;
-	next->pprev = &n->next;
-	*(n->pprev) = n;
+	__hlist_add(n, next->pprev, next);
 }
 
 static inline void hlist_add_after(struct hlist_node *n,
 					struct hlist_node *next)
 {
-	next->next = n->next;
-	n->next = next;
-	next->pprev = &n->next;
-
-	if(next->next)
-		next->next->pprev  = &next->next;
+	__hlist_add(next, &n->next, n->next);
 }
 
 /*
