Return-Path: <linux-kernel-owner+w=401wt.eu-S935372AbXHPLeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935372AbXHPLeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbXHPLeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:34:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55471 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbXHPLeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:34:06 -0400
Subject: Re: [BUG -rt] circular locking deadlock
From: Peter Zijlstra <peterz@infradead.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1187249979.6114.65.camel@twins>
References: <1187228393.6062.31.camel@localhost.localdomain>
	 <1187249979.6114.65.camel@twins>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 13:33:41 +0200
Message-Id: <1187264021.6114.82.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-16 at 09:39 +0200, Peter Zijlstra wrote:
> On Wed, 2007-08-15 at 18:39 -0700, john stultz wrote:
> > Hey Ingo, Thomas,
> > 
> > I was playing with the latency tracer on 2.6.23-rc2-rt2 while a "make
> > -j8" was going on in the background and the box hung with this on the
> > console:
> 
> Hmm, this would have been me :-/
> 
> I'll go play...


Could you give this a spin...

(not sure on the added rmbs, but they can't hurt)

---
Fix a deadlock in the fine grain locked list primitives.

Delete and splice use a double lock, which normally locks in the
prev->cur order. For delete this is deadlock free provided one will
never delete the list head - which is exactly what splice attempts.

In order to solve this, use the reverse locking order for splice - which
then assumes that the list passes is indeed the list head (no fancy
dummy item headless lists here).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 lib/lock_list.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 60 insertions(+), 6 deletions(-)

Index: linux-2.6/lib/lock_list.c
===================================================================
--- linux-2.6.orig/lib/lock_list.c
+++ linux-2.6/lib/lock_list.c
@@ -11,7 +11,7 @@
  *
  * Passed pointers are assumed to be stable by external means such as
  * refcounts or RCU. The individual list entries are assumed to be RCU
- * freed (requirement of __lock_list_del).
+ * freed (requirement of __lock_list).
  */
 
 #include <linux/lock_list.h>
@@ -19,12 +19,9 @@
 void lock_list_add(struct lock_list_head *new,
 		   struct lock_list_head *list)
 {
-	struct lock_list_head *next;
-
 	spin_lock(&new->lock);
 	spin_lock_nested(&list->lock, LOCK_LIST_NESTING_PREV);
-	next = list->next;
-	__list_add(&new->head, &list->head, &next->head);
+	__list_add(&new->head, &list->head, &list->next->head);
 	spin_unlock(&list->lock);
 	spin_unlock(&new->lock);
 }
@@ -35,6 +32,13 @@ static spinlock_t *__lock_list(struct lo
 	spinlock_t *lock = NULL;
 
 again:
+	/*
+	 * all modifications are done under spinlocks
+	 * but this read is not, the unlock acks as a wmb
+	 * for modifications.
+	 */
+	smp_rmb();
+
 	prev = entry->prev;
 	if (prev == entry)
 		goto one;
@@ -52,6 +56,56 @@ one:
 	return lock;
 }
 
+/*
+ * deadlock galore...
+ *
+ * when using __lock_list to lock the list head we get this:
+ *
+ *     lock H      2               1
+ *     lock 1      a       b
+ *     lock 2              A       B
+ *
+ *     list: ..-> [H] <-> [1] <-> [2] <-..
+ *
+ * obvious dead-lock, to solve this we must use a reverse order
+ * when trying to acquire a double lock on the head:
+ *
+ *     lock H r    1               2
+ *     lock 1      a       b
+ *     lock 2              A       B
+ *
+ *     list: ..-> [H] <-> [1] <-> [2] <-..
+ */
+static spinlock_t *__lock_list_reverse(struct lock_list_head *entry)
+{
+	struct lock_list_head *prev;
+	spinlock_t *lock = NULL;
+
+	spin_lock(&entry->lock);
+again:
+	/*
+	 * all modifications are done under spinlocks
+	 * but this read is not, the unlock acks as a wmb
+	 * for modifications.
+	 */
+	smp_rmb();
+	prev = entry->prev;
+	if (prev == entry)
+		goto done;
+
+	spin_lock_nested(&prev->lock, LOCK_LIST_NESTING_PREV);
+	if (unlikely(entry->prev != prev)) {
+		/*
+		 * we lost
+		 */
+		spin_unlock(&prev->lock);
+		goto again;
+	}
+	lock = &prev->lock;
+done:
+	return lock;
+}
+
 void lock_list_del_init(struct lock_list_head *entry)
 {
 	spinlock_t *lock;
@@ -71,7 +125,7 @@ void lock_list_splice_init(struct lock_l
 	spinlock_t *lock;
 
 	rcu_read_lock();
-	lock = __lock_list(list);
+	lock = __lock_list_reverse(list);
 	if (!list_empty(&list->head)) {
 		spin_lock_nested(&head->lock, LOCK_LIST_NESTING_NEXT);
 		__list_splice(&list->head, &head->head);


