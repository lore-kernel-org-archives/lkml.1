Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbYAQUs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbYAQUs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbYAQUsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:48:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:39042 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbYAQUsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:48:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=AcniWieHjAO7xqL2O/azykVXUc2YsOHDfr3NmtrJsMWqYsHp0fd+UAP3PQpkkOKY+emnQUl3Qvc9mPSJ0yeZzBRtz71cncUD0HgbmwM7N1Bk/937wrIzkmqf0gkV5W/8j01biwvfTCH143bXBK+JYIaWm2QQtvb0URXdN/cyVrQ=
Message-ID: <478FBF19.1090009@gmail.com>
Date: Thu, 17 Jan 2008 21:48:25 +0100
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: paulmck@linux.vnet.ibm.com
Subject: [PATCH 2/2] rculist.h: use the rcu API
References: <478FBEA0.9090203@gmail.com>
In-Reply-To: <478FBEA0.9090203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

This patch makes almost all list mutation primitives use
rcu_assign_pointer().

The main point of this being readability improvement.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 include/linux/rculist.h |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 8056d38..038b64f 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -7,6 +7,7 @@
  * RCU-protected list version
  */
 #include <linux/list.h>
+#include <linux/rcupdate.h>
 
 /*
  * Insert a new entry between two known consecutive entries.
@@ -19,9 +20,8 @@ static inline void __list_add_rcu(struct list_head * new,
 {
 	new->next = next;
 	new->prev = prev;
-	smp_wmb();
+	rcu_assign_pointer(prev->next, new);
 	next->prev = new;
-	prev->next = new;
 }
 
 /**
@@ -110,9 +110,8 @@ static inline void list_replace_rcu(struct list_head *old,
 {
 	new->next = old->next;
 	new->prev = old->prev;
-	smp_wmb();
+	rcu_assign_pointer(new->prev->next, new);
 	new->next->prev = new;
-	new->prev->next = new;
 	old->prev = LIST_POISON2;
 }
 
@@ -166,8 +165,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	 */
 
 	last->next = at;
-	smp_wmb();
-	head->next = first;
+	rcu_assign_pointer(head->next, first);
 	first->prev = head;
 	at->prev = last;
 }
@@ -280,10 +278,9 @@ static inline void hlist_replace_rcu(struct hlist_node *old,
 
 	new->next = next;
 	new->pprev = old->pprev;
-	smp_wmb();
+	rcu_assign_pointer(*new->pprev, new);
 	if (next)
 		new->next->pprev = &new->next;
-	*new->pprev = new;
 	old->pprev = LIST_POISON2;
 }
 
@@ -310,12 +307,12 @@ static inline void hlist_add_head_rcu(struct hlist_node *n,
 					struct hlist_head *h)
 {
 	struct hlist_node *first = h->first;
+
 	n->next = first;
 	n->pprev = &h->first;
-	smp_wmb();
+	rcu_assign_pointer(h->first, n);
 	if (first)
 		first->pprev = &n->next;
-	h->first = n;
 }
 
 /**
@@ -341,9 +338,8 @@ static inline void hlist_add_before_rcu(struct hlist_node *n,
 {
 	n->pprev = next->pprev;
 	n->next = next;
-	smp_wmb();
+	rcu_assign_pointer(*(n->pprev), n);
 	next->pprev = &n->next;
-	*(n->pprev) = n;
 }
 
 /**
@@ -369,8 +365,7 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
 {
 	n->next = prev->next;
 	n->pprev = &prev->next;
-	smp_wmb();
-	prev->next = n;
+	rcu_assign_pointer(prev->next, n);
 	if (n->next)
 		n->next->pprev = &n->next;
 }
-- 
1.5.3.7

