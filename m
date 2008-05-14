Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbYENV1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbYENV1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYENV1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:27:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:35533 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYENV1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:27:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=nbis9Ko9NFI6vO8qJZ72DoZMAd9EonhctDeqUpgit+7ILEG0Hz6F/5tV7ONL4dif2Kdy+EI/GVHxdxa3R3/OJ/4/8J0CSg/l3Cr0j1N+7UHdFVBHdf/lhmABZqaq8vlExG9evvd7hqOvNBcAi1pHs1Xbey0D9AHEazWNXL1bZvs=
Message-ID: <482B58FA.30000@gmail.com>
Date: Wed, 14 May 2008 23:26:18 +0200
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: paulmck@linux.vnet.ibm.com, Josh Triplett <josh@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] rculist.h: use the rcu API
References: <482B5887.9050804@gmail.com>
In-Reply-To: <482B5887.9050804@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
index e673c26..52cee71 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -5,6 +5,7 @@
  * RCU-protected list version
  */
 #include <linux/list.h>
+#include <linux/rcupdate.h>
 
 /*
  * Insert a new entry between two known consecutive entries.
@@ -17,9 +18,8 @@ static inline void __list_add_rcu(struct list_head *new,
 {
 	new->next = next;
 	new->prev = prev;
-	smp_wmb();
+	rcu_assign_pointer(prev->next, new);
 	next->prev = new;
-	prev->next = new;
 }
 
 /**
@@ -108,9 +108,8 @@ static inline void list_replace_rcu(struct list_head *old,
 {
 	new->next = old->next;
 	new->prev = old->prev;
-	smp_wmb();
+	rcu_assign_pointer(new->prev->next, new);
 	new->next->prev = new;
-	new->prev->next = new;
 	old->prev = LIST_POISON2;
 }
 
@@ -164,8 +163,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	 */
 
 	last->next = at;
-	smp_wmb();
-	head->next = first;
+	rcu_assign_pointer(head->next, first);
 	first->prev = head;
 	at->prev = last;
 }
@@ -260,10 +258,9 @@ static inline void hlist_replace_rcu(struct hlist_node *old,
 
 	new->next = next;
 	new->pprev = old->pprev;
-	smp_wmb();
+	rcu_assign_pointer(*new->pprev, new);
 	if (next)
 		new->next->pprev = &new->next;
-	*new->pprev = new;
 	old->pprev = LIST_POISON2;
 }
 
@@ -290,12 +287,12 @@ static inline void hlist_add_head_rcu(struct hlist_node *n,
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
@@ -321,9 +318,8 @@ static inline void hlist_add_before_rcu(struct hlist_node *n,
 {
 	n->pprev = next->pprev;
 	n->next = next;
-	smp_wmb();
+	rcu_assign_pointer(*(n->pprev), n);
 	next->pprev = &n->next;
-	*(n->pprev) = n;
 }
 
 /**
@@ -349,8 +345,7 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
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
1.5.5.GIT

