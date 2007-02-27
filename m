Return-Path: <linux-kernel-owner+w=401wt.eu-S1751379AbXB0CcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbXB0CcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 21:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbXB0CcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 21:32:10 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1452 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbXB0CcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 21:32:08 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 26 Feb 2007 18:32:04 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] epoll reduced (to 1) number of passes over the ready set
 ...
Message-ID: <Pine.LNX.4.64.0702261819250.4949@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Epoll is doing multiple passes over the ready set at the moment, because 
of the constraints over the f_op->poll() call. Looking at the code again, 
I noticed that we already hold the epoll semaphore in read, and this 
(together with other locking conditions that hold while doing an 
epoll_wait()) can lead to a smarter way to "ship" events to userspace (in 
a single pass). I added more (even) more comments to the code to explain 
the conditions why certain operations are safe.
This is a stress application that can be used to test the new code. It 
spwans multiple thread and call epoll_wait() and epoll_ctl() from many 
threads. Stress tested on my dual Opteron 254 w/out any problems.

http://www.xmailserver.org/totalmess.c

This is not a benchmark, just something that tries to stress and exploit 
possible problems with the new code.



- Davide



eventpoll.c |  174 ++++++++++++++++++++++--------------------------------------
1 file changed, 66 insertions(+), 108 deletions(-)




diff -Nru linux-2.6.20/fs/eventpoll.c linux-2.6.20.mod/fs/eventpoll.c
--- linux-2.6.20/fs/eventpoll.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20.mod/fs/eventpoll.c	2007-02-26 17:32:25.000000000 -0800
@@ -218,9 +218,6 @@
 	/* List header used to link this item to the "struct file" items list */
 	struct list_head fllink;
 
-	/* List header used to link the item to the transfer list */
-	struct list_head txlink;
-
 	/*
 	 * This is used during the collection/transfer of events to userspace
 	 * to pin items empty events set.
@@ -259,10 +256,9 @@
 static int ep_eventpoll_close(struct inode *inode, struct file *file);
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait);
 static int ep_collect_ready_items(struct eventpoll *ep,
-				  struct list_head *txlist, int maxevents);
+				  struct list_head *txlist);
 static int ep_send_events(struct eventpoll *ep, struct list_head *txlist,
-			  struct epoll_event __user *events);
-static void ep_reinject_items(struct eventpoll *ep, struct list_head *txlist);
+			  struct epoll_event __user *events, int maxevents);
 static int ep_events_transfer(struct eventpoll *ep,
 			      struct epoll_event __user *events,
 			      int maxevents);
@@ -355,17 +351,6 @@
 	return rb_parent(n) != n;
 }
 
-/*
- * Remove the item from the list and perform its initialization.
- * This is useful for us because we can test if the item is linked
- * using "ep_is_linked(p)".
- */
-static inline void ep_list_del(struct list_head *p)
-{
-	list_del(p);
-	INIT_LIST_HEAD(p);
-}
-
 /* Tells us if the item is currently linked */
 static inline int ep_is_linked(struct list_head *p)
 {
@@ -480,7 +465,7 @@
 		epi = list_entry(lsthead->next, struct epitem, fllink);
 
 		ep = epi->ep;
-		ep_list_del(&epi->fllink);
+		list_del_init(&epi->fllink);
 		down_write(&ep->sem);
 		ep_remove(ep, epi);
 		up_write(&ep->sem);
@@ -1011,7 +996,6 @@
 	ep_rb_initnode(&epi->rbn);
 	INIT_LIST_HEAD(&epi->rdllink);
 	INIT_LIST_HEAD(&epi->fllink);
-	INIT_LIST_HEAD(&epi->txlink);
 	INIT_LIST_HEAD(&epi->pwqlist);
 	epi->ep = ep;
 	ep_set_ffd(&epi->ffd, tfile, fd);
@@ -1080,7 +1064,7 @@
 	 */
 	write_lock_irqsave(&ep->lock, flags);
 	if (ep_is_linked(&epi->rdllink))
-		ep_list_del(&epi->rdllink);
+		list_del_init(&epi->rdllink);
 	write_unlock_irqrestore(&ep->lock, flags);
 
 	kmem_cache_free(epi_cache, epi);
@@ -1170,7 +1154,7 @@
 		while (!list_empty(lsthead)) {
 			pwq = list_entry(lsthead->next, struct eppoll_entry, llink);
 
-			ep_list_del(&pwq->llink);
+			list_del_init(&pwq->llink);
 			remove_wait_queue(pwq->whead, &pwq->wait);
 			kmem_cache_free(pwq_cache, pwq);
 		}
@@ -1213,7 +1197,7 @@
 	 * we want to remove it from this list to avoid stale events.
 	 */
 	if (ep_is_linked(&epi->rdllink))
-		ep_list_del(&epi->rdllink);
+		list_del_init(&epi->rdllink);
 
 	error = 0;
 eexit_1:
@@ -1248,7 +1232,7 @@
 	/* Remove the current item from the list of epoll hooks */
 	spin_lock(&file->f_ep_lock);
 	if (ep_is_linked(&epi->fllink))
-		ep_list_del(&epi->fllink);
+		list_del_init(&epi->fllink);
 	spin_unlock(&file->f_ep_lock);
 
 	/* We need to acquire the write IRQ lock before calling ep_unlink() */
@@ -1363,46 +1347,19 @@
 
 /*
  * Since we have to release the lock during the __copy_to_user() operation and
- * during the f_op->poll() call, we try to collect the maximum number of items
- * by reducing the irqlock/irqunlock switching rate.
+ * during the f_op->poll() call, we acquire the ready list into our temporary
+ * transmission list. List splice is O(1).
  */
-static int ep_collect_ready_items(struct eventpoll *ep, struct list_head *txlist, int maxevents)
+static int ep_collect_ready_items(struct eventpoll *ep, struct list_head *txlist)
 {
-	int nepi;
 	unsigned long flags;
-	struct list_head *lsthead = &ep->rdllist, *lnk;
-	struct epitem *epi;
 
 	write_lock_irqsave(&ep->lock, flags);
-
-	for (nepi = 0, lnk = lsthead->next; lnk != lsthead && nepi < maxevents;) {
-		epi = list_entry(lnk, struct epitem, rdllink);
-
-		lnk = lnk->next;
-
-		/* If this file is already in the ready list we exit soon */
-		if (!ep_is_linked(&epi->txlink)) {
-			/*
-			 * This is initialized in this way so that the default
-			 * behaviour of the reinjecting code will be to push back
-			 * the item inside the ready list.
-			 */
-			epi->revents = epi->event.events;
-
-			/* Link the ready item into the transfer list */
-			list_add(&epi->txlink, txlist);
-			nepi++;
-
-			/*
-			 * Unlink the item from the ready list.
-			 */
-			ep_list_del(&epi->rdllink);
-		}
-	}
-
+	list_splice(&ep->rdllist, txlist);
+	INIT_LIST_HEAD(&ep->rdllist);
 	write_unlock_irqrestore(&ep->lock, flags);
 
-	return nepi;
+	return 0;	
 }
 
 
@@ -1412,21 +1369,24 @@
  * because of the way poll() is traditionally implemented in Linux.
  */
 static int ep_send_events(struct eventpoll *ep, struct list_head *txlist,
-			  struct epoll_event __user *events)
+			  struct epoll_event __user *events, int maxevents)
 {
-	int eventcnt = 0;
+	int eventcnt, error = -EFAULT, pwake = 0;
 	unsigned int revents;
-	struct list_head *lnk;
+	unsigned long flags;
 	struct epitem *epi;
+	struct list_head injlist;
+
+	INIT_LIST_HEAD(&injlist);
 
 	/*
 	 * We can loop without lock because this is a task private list.
 	 * The test done during the collection loop will guarantee us that
 	 * another task will not try to collect this file. Also, items
-	 * cannot vanish during the loop because we are holding "sem".
+	 * cannot vanish during the loop because we are holding "sem" in read.
 	 */
-	list_for_each(lnk, txlist) {
-		epi = list_entry(lnk, struct epitem, txlink);
+	for (eventcnt = 0; !list_empty(txlist) && eventcnt < maxevents;) {
+		epi = list_entry(txlist->next, struct epitem, rdllink);
 
 		/*
 		 * Get the ready file event set. We can safely use the file
@@ -1442,56 +1402,56 @@
 		 */
 		epi->revents = revents & epi->event.events;
 
+		/*
+		 * Is the event mask intersect the caller-requested one,
+		 * deliver the event to userspace. Again, we are holding
+		 * "sem" in read, so no operations coming from userspace,
+		 * that change the item can happen.
+		 */
 		if (epi->revents) {
 			if (__put_user(epi->revents,
 				       &events[eventcnt].events) ||
 			    __put_user(epi->event.data,
 				       &events[eventcnt].data))
-				return -EFAULT;
+				goto errxit;
 			if (epi->event.events & EPOLLONESHOT)
 				epi->event.events &= EP_PRIVATE_BITS;
 			eventcnt++;
 		}
-	}
-	return eventcnt;
-}
-
-
-/*
- * Walk through the transfer list we collected with ep_collect_ready_items()
- * and, if 1) the item is still "alive" 2) its event set is not empty 3) it's
- * not already linked, links it to the ready list. Same as above, we are holding
- * "sem" so items cannot vanish underneath our nose.
- */
-static void ep_reinject_items(struct eventpoll *ep, struct list_head *txlist)
-{
-	int ricnt = 0, pwake = 0;
-	unsigned long flags;
-	struct epitem *epi;
-
-	write_lock_irqsave(&ep->lock, flags);
-
-	while (!list_empty(txlist)) {
-		epi = list_entry(txlist->next, struct epitem, txlink);
-
-		/* Unlink the current item from the transfer list */
-		ep_list_del(&epi->txlink);
 
 		/*
-		 * If the item is no more linked to the interest set, we don't
-		 * have to push it inside the ready list because the following
-		 * ep_release_epitem() is going to drop it. Also, if the current
-		 * item is set to have an Edge Triggered behaviour, we don't have
-		 * to push it back either.
+		 * This is tricky. We are holding the "sem" in read, and this
+		 * means that the operations that can change the "linked" status
+		 * of the epoll item (epi->rbn and epi->rdllink) cannot touch them.
+		 * Also, since we are "linked" from a epi->rdllink POV (the item
+		 * is linked to our transmission list, we just splice'd), the
+		 * ep_poll_callback() cannot touch us either, because of the check
+		 * present in there. Another parallel epoll_wait() will not
+		 * get the same result set, since we spliced the ready list before.
 		 */
-		if (ep_rb_linked(&epi->rbn) && !(epi->event.events & EPOLLET) &&
-		    (epi->revents & epi->event.events) && !ep_is_linked(&epi->rdllink)) {
-			list_add_tail(&epi->rdllink, &ep->rdllist);
-			ricnt++;
-		}
+		list_del(&epi->rdllink);
+		if (!(epi->event.events & EPOLLET) &&
+		    (epi->revents & epi->event.events))
+			list_add_tail(&epi->rdllink, &injlist);
+		else {
+			/*
+			 * Be sure the item is totally detached before re-init the
+			 * list_head. After INIT_LIST_HEAD() is committed, the
+			 * ep_poll_callback() can requeue the item again, but we
+			 * don't care since we are already past it.
+			 */
+			smp_mb();
+			INIT_LIST_HEAD(&epi->rdllink);
+		}		
 	}
+	error = 0;
 
-	if (ricnt) {
+	errxit:
+
+	write_lock_irqsave(&ep->lock, flags);
+	if (!list_empty(&injlist) || !list_empty(txlist)) {
+		list_splice(txlist, &ep->rdllist);
+		list_splice(&injlist, &ep->rdllist);
 		/*
 		 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
 		 * wait list.
@@ -1500,14 +1460,15 @@
 			__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
 					 TASK_INTERRUPTIBLE);
 		if (waitqueue_active(&ep->poll_wait))
-			pwake++;
+			pwake++;		
 	}
-
 	write_unlock_irqrestore(&ep->lock, flags);
 
 	/* We have to call this outside the lock */
 	if (pwake)
 		ep_poll_safewake(&psw, &ep->poll_wait);
+	
+	return eventcnt == 0 ? error: eventcnt;
 }
 
 
@@ -1517,7 +1478,7 @@
 static int ep_events_transfer(struct eventpoll *ep,
 			      struct epoll_event __user *events, int maxevents)
 {
-	int eventcnt = 0;
+	int eventcnt;
 	struct list_head txlist;
 
 	INIT_LIST_HEAD(&txlist);
@@ -1529,13 +1490,10 @@
 	down_read(&ep->sem);
 
 	/* Collect/extract ready items */
-	if (ep_collect_ready_items(ep, &txlist, maxevents) > 0) {
-		/* Build result set in userspace */
-		eventcnt = ep_send_events(ep, &txlist, events);
-
-		/* Reinject ready items into the ready list */
-		ep_reinject_items(ep, &txlist);
-	}
+	ep_collect_ready_items(ep, &txlist);
+	
+	/* Build result set in userspace */
+	eventcnt = ep_send_events(ep, &txlist, events, maxevents);
 
 	up_read(&ep->sem);
 
