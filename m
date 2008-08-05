Return-Path: <linux-kernel-owner+w=401wt.eu-S1760563AbYHEJDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563AbYHEJDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbYHEJD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:03:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:43617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYHEJDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:03:25 -0400
Subject: Re: [PATCH 1/4] list.h: Add list_splice_tail() and
	list_splice_tail_init()
From: Peter Zijlstra <peterz@infradead.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
In-Reply-To: <1217890080-12073-1-git-send-email-lrodriguez@atheros.com>
References: <1217890080-12073-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 11:03:15 +0200
Message-Id: <1217926995.3589.116.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 15:48 -0700, Luis R. Rodriguez wrote:
> If you are using linked lists for queues list_splice() will not do what
> you would expect even if you use the elements passed reversed. We need
> to handle these differently. We add list_splice_tail() and
> list_splice_tail_init()

In the -rt tree we have this:

---
    rt: list_splice2
    
    Introduce list_splice2{,_tail}() which will splice a sub-list denoted
    by two list items instead of the full list.
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 318e8a2..dace60c 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -283,7 +283,7 @@ static dma_cookie_t ioat1_tx_submit(struct dma_async_tx_descriptor *tx)
 	/* write address into NextDescriptor field of last desc in chain */
 	to_ioat_desc(ioat_chan->used_desc.prev)->hw->next =
 							first->async_tx.phys;
-	__list_splice(&new_chain, ioat_chan->used_desc.prev);
+	list_splice_tail(&new_chain, &ioat_chan->used_desc);
 
 	ioat_chan->dmacount += desc_count;
 	ioat_chan->pending += desc_count;
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index b85b541..3c541d8 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -932,7 +932,7 @@ static struct ehci_qh *qh_append_tds (
 
 			list_del (&qtd->qtd_list);
 			list_add (&dummy->qtd_list, qtd_list);
-			__list_splice (qtd_list, qh->qtd_list.prev);
+			list_splice_tail (qtd_list, &qh->qtd_list);
 
 			ehci_qtd_init(ehci, qtd, qtd->qtd_dma);
 			qh->dummy = qtd;
diff --git a/include/linux/list.h b/include/linux/list.h
index 08cf4f6..468e001 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -327,17 +327,17 @@ static inline int list_is_singular(const struct list_head *head)
 }
 
 static inline void __list_splice(const struct list_head *list,
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
@@ -349,7 +349,13 @@ static inline void list_splice(const struct list_head *list,
 				struct list_head *head)
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
@@ -363,11 +369,55 @@ static inline void list_splice_init(struct list_head *list,
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
diff --git a/lib/lock_list.c b/lib/lock_list.c
index d4bd571..586c01e 100644
--- a/lib/lock_list.c
+++ b/lib/lock_list.c
@@ -128,7 +128,7 @@ void lock_list_splice_init(struct lock_list_head *list,
 	lock = __lock_list_reverse(list);
 	if (!list_empty(&list->head)) {
 		spin_lock_nested(&head->lock, LOCK_LIST_NESTING_NEXT);
-		__list_splice(&list->head, &head->head);
+		__list_splice(&list->head, &head->head, head->head.next);
 		INIT_LIST_HEAD(&list->head);
 		spin_unlock(&head->lock);
 	}




