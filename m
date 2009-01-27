Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbZA0UzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbZA0UzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZA0Uyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:54:51 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:44227 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZA0Uyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:54:50 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Jan 2009 12:54:38 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [patch 1/2] epoll fix own poll()
Message-ID: <alpine.DEB.1.10.0901271251310.20262@alien.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The follwing patch fixes a bug inside the epoll's f_op->poll() code, that
returns POLLIN even though there are no actual ready monitored fds.
The bug shows up if you add an epoll fd inside another fd container (poll,
select, epoll).
The problem is that callback-based wake ups used by epoll, does not carry
(patches will follow, to fix this) any information about the events
that actually happened. So the callback code, since it can't call the file*
->poll() inside the callback, chains the file* into a ready-list. So, suppose
you added an fd with EPOLLOUT only, and some data shows up on the fd, the
file* mapped by the fd will be added into the ready-list (via wakeup
callback). During normal epoll_wait() use, this condition is sorted out
at the time we're actually able to call the file*'s f_op->poll().
Inside the old epoll's f_op->poll() though, only a quick check
!list_empty(ready-list) was performed, and this could have led to reporting
POLLIN even though no ready fds would show up at a following epoll_wait().
In order to correctly report the ready status for an epoll fd, the ready-list
must be checked to see if any really available fd+event would be ready in
a following epoll_wait().
Operation (calling f_op->poll() from inside f_op->poll()) that, like wake ups,
must be handled with care because of the fact that epoll fds can be added
to other epoll fds.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventpoll.c |  510 +++++++++++++++++++++++++++++++++------------------------
 1 file changed, 304 insertions(+), 206 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2009-01-26 23:13:23.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2009-01-26 23:13:28.000000000 -0800
@@ -1,6 +1,6 @@
 /*
- *  fs/eventpoll.c (Efficent event polling implementation)
- *  Copyright (C) 2001,...,2007	 Davide Libenzi
+ *  fs/eventpoll.c (Efficient event retrieval implementation)
+ *  Copyright (C) 2001,...,2009	 Davide Libenzi
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -92,8 +92,8 @@
 /* Epoll private bits inside the event mask */
 #define EP_PRIVATE_BITS (EPOLLONESHOT | EPOLLET)
 
-/* Maximum number of poll wake up nests we are allowing */
-#define EP_MAX_POLLWAKE_NESTS 4
+/* Maximum number of nesting allowed inside epoll sets */
+#define EP_MAX_NESTS 4
 
 /* Maximum msec timeout value storeable in a long int */
 #define EP_MAX_MSTIMEO min(1000ULL * MAX_SCHEDULE_TIMEOUT / HZ, (LONG_MAX - 999ULL) / HZ)
@@ -110,24 +110,21 @@
 };
 
 /*
- * Node that is linked into the "wake_task_list" member of the "struct poll_safewake".
- * It is used to keep track on all tasks that are currently inside the wake_up() code
- * to 1) short-circuit the one coming from the same task and same wait queue head
- * (loop) 2) allow a maximum number of epoll descriptors inclusion nesting
- * 3) let go the ones coming from other tasks.
+ * Structure used to track possible nested calls, for too deep recursions
+ * and loop cycles.
  */
-struct wake_task_node {
+struct nested_call_node {
 	struct list_head llink;
 	struct task_struct *task;
-	wait_queue_head_t *wq;
+	void *cookie;
 };
 
 /*
- * This is used to implement the safe poll wake up avoiding to reenter
- * the poll callback from inside wake_up().
+ * This structure is used as collector for nested calls, to check for
+ * maximum recursion dept and loop cycles.
  */
-struct poll_safewake {
-	struct list_head wake_task_list;
+struct nested_calls {
+	struct list_head tasks_call_list;
 	spinlock_t lock;
 };
 
@@ -231,6 +228,12 @@
 	struct epitem *epi;
 };
 
+/* Used by the ep_send_events() function as callback private data */
+struct ep_send_events_data {
+	int maxevents;
+	struct epoll_event __user *events;
+};
+
 /*
  * Configuration options available inside /proc/sys/fs/epoll/
  */
@@ -244,8 +247,11 @@
  */
 static DEFINE_MUTEX(epmutex);
 
-/* Safe wake up implementation */
-static struct poll_safewake psw;
+/* Used for safe wake up implementation */
+static struct nested_calls poll_safewake_ncalls;
+
+/* Used to call file's f_op->poll() under the nested calls boundaries */
+static struct nested_calls poll_readywalk_ncalls;
 
 /* Slab cache used to allocate "struct epitem" */
 static struct kmem_cache *epi_cache __read_mostly;
@@ -322,64 +328,96 @@
 }
 
 /* Initialize the poll safe wake up structure */
-static void ep_poll_safewake_init(struct poll_safewake *psw)
+static void ep_nested_calls_init(struct nested_calls *ncalls)
 {
-
-	INIT_LIST_HEAD(&psw->wake_task_list);
-	spin_lock_init(&psw->lock);
+	INIT_LIST_HEAD(&ncalls->tasks_call_list);
+	spin_lock_init(&ncalls->lock);
 }
 
-/*
- * Perform a safe wake up of the poll wait list. The problem is that
- * with the new callback'd wake up system, it is possible that the
- * poll callback is reentered from inside the call to wake_up() done
- * on the poll wait queue head. The rule is that we cannot reenter the
- * wake up code from the same task more than EP_MAX_POLLWAKE_NESTS times,
- * and we cannot reenter the same wait queue head at all. This will
- * enable to have a hierarchy of epoll file descriptor of no more than
- * EP_MAX_POLLWAKE_NESTS deep. We need the irq version of the spin lock
- * because this one gets called by the poll callback, that in turn is called
- * from inside a wake_up(), that might be called from irq context.
+/**
+ * ep_call_nested - Perform a bound (possibly) nested call, by checking
+ *                  that the recursion limit is not exceeded, and that
+ *                  the same nested call (by the meaning of same cookie) is
+ *                  no re-entered.
+ *
+ * @ncalls: Pointer to the nested_calls structure to be used for this call.
+ * @max_nests: Maximum number of allowed nesting calls.
+ * @nproc: Nested call core function pointer.
+ * @priv: Opaque data to be passed to the @nproc callback.
+ * @cookie: Cookie to be used to identify this nested call.
+ *
+ * Returns: Returns the code returned by the @nproc callback, or -1 if
+ *          the maximum recursion limit has been exceeded.
  */
-static void ep_poll_safewake(struct poll_safewake *psw, wait_queue_head_t *wq)
+static int ep_call_nested(struct nested_calls *ncalls, int max_nests,
+			  int (*nproc)(void *, void *, int), void *priv,
+			  void *cookie)
 {
-	int wake_nests = 0;
+	int error, call_nests = 0;
 	unsigned long flags;
 	struct task_struct *this_task = current;
-	struct list_head *lsthead = &psw->wake_task_list;
-	struct wake_task_node *tncur;
-	struct wake_task_node tnode;
+	struct list_head *lsthead = &ncalls->tasks_call_list;
+	struct nested_call_node *tncur;
+	struct nested_call_node tnode;
 
-	spin_lock_irqsave(&psw->lock, flags);
+	spin_lock_irqsave(&ncalls->lock, flags);
 
-	/* Try to see if the current task is already inside this wakeup call */
+	/*
+	 * Try to see if the current task is already inside this wakeup call.
+	 * We use a list here, since the population inside this set is always
+	 * very much limited.
+	 */
 	list_for_each_entry(tncur, lsthead, llink) {
-
-		if (tncur->wq == wq ||
-		    (tncur->task == this_task && ++wake_nests > EP_MAX_POLLWAKE_NESTS)) {
+		if (tncur->task == this_task &&
+		    (tncur->cookie == cookie || ++call_nests > max_nests)) {
 			/*
 			 * Ops ... loop detected or maximum nest level reached.
 			 * We abort this wake by breaking the cycle itself.
 			 */
-			spin_unlock_irqrestore(&psw->lock, flags);
-			return;
+			spin_unlock_irqrestore(&ncalls->lock, flags);
+
+			return -1;
 		}
 	}
 
-	/* Add the current task to the list */
+	/* Add the current task and cookie to the list */
 	tnode.task = this_task;
-	tnode.wq = wq;
+	tnode.cookie = cookie;
 	list_add(&tnode.llink, lsthead);
 
-	spin_unlock_irqrestore(&psw->lock, flags);
+	spin_unlock_irqrestore(&ncalls->lock, flags);
 
-	/* Do really wake up now */
-	wake_up_nested(wq, 1 + wake_nests);
+	/* Call the nested function */
+	error = (*nproc)(priv, cookie, call_nests);
 
 	/* Remove the current task from the list */
-	spin_lock_irqsave(&psw->lock, flags);
+	spin_lock_irqsave(&ncalls->lock, flags);
 	list_del(&tnode.llink);
-	spin_unlock_irqrestore(&psw->lock, flags);
+	spin_unlock_irqrestore(&ncalls->lock, flags);
+
+	return error;
+}
+
+static int ep_poll_wakeup_proc(void *priv, void *cookie, int call_nests)
+{
+	wake_up_nested((wait_queue_head_t *) cookie, 1 + call_nests);
+	return 0;
+}
+
+/*
+ * Perform a safe wake up of the poll wait list. The problem is that
+ * with the new callback'd wake up system, it is possible that the
+ * poll callback is reentered from inside the call to wake_up() done
+ * on the poll wait queue head. The rule is that we cannot reenter the
+ * wake up code from the same task more than EP_MAX_NESTS times,
+ * and we cannot reenter the same wait queue head at all. This will
+ * enable to have a hierarchy of epoll file descriptor of no more than
+ * EP_MAX_NESTS deep.
+ */
+static void ep_poll_safewake(wait_queue_head_t *wq)
+{
+	ep_call_nested(&poll_safewake_ncalls, EP_MAX_NESTS,
+		       ep_poll_wakeup_proc, NULL, wq);
 }
 
 /*
@@ -407,6 +445,104 @@
 	}
 }
 
+/**
+ * ep_scan_ready_list - Scans the ready list in a way that makes possible for
+ *                      the scan code, to call f_op->poll(). Also allows for
+ *                      O(NumReady) performance.
+ *
+ * @ep: Pointer to the epoll private data structure.
+ * @sproc: Pointer to the scan callback.
+ * @priv: Private opaque data passed to the @sproc callback.
+ *
+ * Returns: The same integer error code returned by the @sproc callback.
+ */
+static int ep_scan_ready_list(struct eventpoll *ep,
+			      int (*sproc)(struct eventpoll *,
+					   struct list_head *, void *),
+			      void *priv)
+{
+	int error, pwake = 0;
+	unsigned long flags;
+	struct epitem *epi, *nepi;
+	struct list_head txlist;
+
+	INIT_LIST_HEAD(&txlist);
+
+	/*
+	 * We need to lock this because we could be hit by
+	 * eventpoll_release_file() and epoll_ctl(EPOLL_CTL_DEL).
+	 */
+	mutex_lock(&ep->mtx);
+
+	/*
+	 * Steal the ready list, and re-init the original one to the
+	 * empty list. Also, set ep->ovflist to NULL so that events
+	 * happening while looping w/out locks, are not lost. We cannot
+	 * have the poll callback to queue directly on ep->rdllist,
+	 * because we want the "sproc" callback to be able to do it
+	 * in a lockless way.
+	 */
+	spin_lock_irqsave(&ep->lock, flags);
+	list_splice(&ep->rdllist, &txlist);
+	INIT_LIST_HEAD(&ep->rdllist);
+	ep->ovflist = NULL;
+	spin_unlock_irqrestore(&ep->lock, flags);
+
+	/*
+	 * Now call the callback function.
+	 */
+	error = (*sproc)(ep, &txlist, priv);
+
+	spin_lock_irqsave(&ep->lock, flags);
+	/*
+	 * During the time we spent inside the "sproc" callback, some
+	 * other events might have been queued by the poll callback.
+	 * We re-insert them inside the main ready-list here.
+	 */
+	for (nepi = ep->ovflist; (epi = nepi) != NULL;
+	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
+		/*
+		 * We need to check if the item is already in the list.
+		 * During the "sproc" callback execution time, items are
+		 * queued into ->ovflist but the "txlist" might already
+		 * contain them, and the list_splice() below takes care of them.
+		 */
+		if (!ep_is_linked(&epi->rdllink))
+			list_add_tail(&epi->rdllink, &ep->rdllist);
+	}
+	/*
+	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
+	 * releasing the lock, events will be queued in the normal way inside
+	 * ep->rdllist.
+	 */
+	ep->ovflist = EP_UNACTIVE_PTR;
+
+	/*
+	 * Quickly re-inject items left on "txlist".
+	 */
+	list_splice(&txlist, &ep->rdllist);
+
+	if (!list_empty(&ep->rdllist)) {
+		/*
+		 * Wake up (if active) both the eventpoll wait list and the ->poll()
+		 * wait list (delayed after we release the lock).
+		 */
+		if (waitqueue_active(&ep->wq))
+			wake_up_locked(&ep->wq);
+		if (waitqueue_active(&ep->poll_wait))
+			pwake++;
+	}
+	spin_unlock_irqrestore(&ep->lock, flags);
+
+	mutex_unlock(&ep->mtx);
+
+	/* We have to call this outside the lock */
+	if (pwake)
+		ep_poll_safewake(&ep->poll_wait);
+
+	return error;
+}
+
 /*
  * Removes a "struct epitem" from the eventpoll RB tree and deallocates
  * all the associated resources. Must be called with "mtx" held.
@@ -457,7 +593,7 @@
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
-		ep_poll_safewake(&psw, &ep->poll_wait);
+		ep_poll_safewake(&ep->poll_wait);
 
 	/*
 	 * We need to lock this because we could be hit by
@@ -507,22 +643,49 @@
 	return 0;
 }
 
+static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head, void *priv)
+{
+	struct epitem *epi, *tmp;
+
+	list_for_each_entry_safe(epi, tmp, head, rdllink) {
+		if (epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+		    epi->event.events)
+			return POLLIN | POLLRDNORM;
+		else
+			/*
+			 * Item has been dropped into the ready list by the poll
+			 * callback, but it's not actually ready, as far as
+			 * caller requested events goes. We can remove it here.
+			 */
+			list_del_init(&epi->rdllink);
+	}
+
+	return 0;
+}
+
+static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
+{
+	return ep_scan_ready_list(priv, ep_read_events_proc, NULL);
+}
+
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
 {
-	unsigned int pollflags = 0;
-	unsigned long flags;
+	int pollflags;
 	struct eventpoll *ep = file->private_data;
 
 	/* Insert inside our poll wait queue */
 	poll_wait(file, &ep->poll_wait, wait);
 
-	/* Check our condition */
-	spin_lock_irqsave(&ep->lock, flags);
-	if (!list_empty(&ep->rdllist))
-		pollflags = POLLIN | POLLRDNORM;
-	spin_unlock_irqrestore(&ep->lock, flags);
+	/*
+	 * Proceed to find out if wanted events are really available inside
+	 * the ready list. This need to be done under ep_call_nested()
+	 * supervision, since the call to f_op->poll() done on listed files
+	 * could re-enter here.
+	 */
+	pollflags = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
+				   ep_poll_readyevents_proc, ep, ep);
 
-	return pollflags;
+	return pollflags != -1 ? pollflags: 0;
 }
 
 /* File callbacks that implement the eventpoll file behaviour */
@@ -552,7 +715,7 @@
 	 * We don't want to get "file->f_ep_lock" because it is not
 	 * necessary. It is not necessary because we're in the "struct file"
 	 * cleanup path, and this means that noone is using this file anymore.
-	 * So, for example, epoll_ctl() cannot hit here sicne if we reach this
+	 * So, for example, epoll_ctl() cannot hit here since if we reach this
 	 * point, the file counter already went to zero and fget() would fail.
 	 * The only hit might come from ep_free() but by holding the mutex
 	 * will correctly serialize the operation. We do need to acquire
@@ -683,12 +846,9 @@
 	}
 
 	/* If this file is already in the ready list we exit soon */
-	if (ep_is_linked(&epi->rdllink))
-		goto is_linked;
-
-	list_add_tail(&epi->rdllink, &ep->rdllist);
+	if (!ep_is_linked(&epi->rdllink))
+		list_add_tail(&epi->rdllink, &ep->rdllist);
 
-is_linked:
 	/*
 	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
 	 * wait list.
@@ -703,7 +863,7 @@
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(&psw, &ep->poll_wait);
+		ep_poll_safewake(&ep->poll_wait);
 
 	return 1;
 }
@@ -725,10 +885,9 @@
 		add_wait_queue(whead, &pwq->wait);
 		list_add_tail(&pwq->llink, &epi->pwqlist);
 		epi->nwait++;
-	} else {
+	} else
 		/* We have to signal that an error occurred */
 		epi->nwait = -1;
-	}
 }
 
 static void ep_rbtree_insert(struct eventpoll *ep, struct epitem *epi)
@@ -830,7 +989,7 @@
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(&psw, &ep->poll_wait);
+		ep_poll_safewake(&ep->poll_wait);
 
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_insert(%p, %p, %d)\n",
 		     current, ep, tfile, fd));
@@ -904,137 +1063,74 @@
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(&psw, &ep->poll_wait);
+		ep_poll_safewake(&ep->poll_wait);
 
 	return 0;
 }
 
-static int ep_send_events(struct eventpoll *ep, struct epoll_event __user *events,
-			  int maxevents)
+static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head, void *priv)
 {
-	int eventcnt, error = -EFAULT, pwake = 0;
-	unsigned int revents;
-	unsigned long flags;
-	struct epitem *epi, *nepi;
-	struct list_head txlist;
-
-	INIT_LIST_HEAD(&txlist);
-
-	/*
-	 * We need to lock this because we could be hit by
-	 * eventpoll_release_file() and epoll_ctl(EPOLL_CTL_DEL).
-	 */
-	mutex_lock(&ep->mtx);
-
-	/*
-	 * Steal the ready list, and re-init the original one to the
-	 * empty list. Also, set ep->ovflist to NULL so that events
-	 * happening while looping w/out locks, are not lost. We cannot
-	 * have the poll callback to queue directly on ep->rdllist,
-	 * because we are doing it in the loop below, in a lockless way.
-	 */
-	spin_lock_irqsave(&ep->lock, flags);
-	list_splice(&ep->rdllist, &txlist);
-	INIT_LIST_HEAD(&ep->rdllist);
-	ep->ovflist = NULL;
-	spin_unlock_irqrestore(&ep->lock, flags);
+	struct ep_send_events_data *esed = priv;
+	int eventcnt;
+  	unsigned int revents;
+	struct epitem *epi;
+	struct epoll_event __user *uevent;
 
-	/*
-	 * We can loop without lock because this is a task private list.
-	 * We just splice'd out the ep->rdllist in ep_collect_ready_items().
-	 * Items cannot vanish during the loop because we are holding "mtx".
-	 */
-	for (eventcnt = 0; !list_empty(&txlist) && eventcnt < maxevents;) {
-		epi = list_first_entry(&txlist, struct epitem, rdllink);
+  	/*
+	 * We can loop without lock because we are passed a task private list.
+	 * Items cannot vanish during the loop because ep_scan_ready_list() is
+	 * holding "mtx" during this call.
+  	 */
+	for (eventcnt = 0, uevent = esed->events;
+	     !list_empty(head) && eventcnt < esed->maxevents;) {
+		epi = list_first_entry(head, struct epitem, rdllink);
 
 		list_del_init(&epi->rdllink);
 
-		/*
-		 * Get the ready file event set. We can safely use the file
-		 * because we are holding the "mtx" and this will guarantee
-		 * that both the file and the item will not vanish.
-		 */
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
-		revents &= epi->event.events;
+  		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+  			epi->event.events;
 
-		/*
-		 * Is the event mask intersect the caller-requested one,
-		 * deliver the event to userspace. Again, we are holding
-		 * "mtx", so no operations coming from userspace can change
-		 * the item.
-		 */
-		if (revents) {
-			if (__put_user(revents,
-				       &events[eventcnt].events) ||
-			    __put_user(epi->event.data,
-				       &events[eventcnt].data))
-				goto errxit;
-			if (epi->event.events & EPOLLONESHOT)
-				epi->event.events &= EP_PRIVATE_BITS;
-			eventcnt++;
-		}
-		/*
-		 * At this point, noone can insert into ep->rdllist besides
-		 * us. The epoll_ctl() callers are locked out by us holding
-		 * "mtx" and the poll callback will queue them in ep->ovflist.
-		 */
-		if (!(epi->event.events & EPOLLET) &&
-		    (revents & epi->event.events))
-			list_add_tail(&epi->rdllink, &ep->rdllist);
-	}
-	error = 0;
-
-errxit:
+  		/*
+		 * If the event mask intersect the caller-requested one,
+		 * deliver the event to userspace. Again, ep_scan_ready_list()
+		 * is holding "mtx", so no operations coming from userspace
+		 * can change the item.
+  		 */
+  		if (revents) {
+			if (__put_user(revents, &uevent->events) ||
+			    __put_user(epi->event.data, &uevent->data))
+				return eventcnt ? eventcnt: -EFAULT;
+  			eventcnt++;
+			uevent++;
+  			if (epi->event.events & EPOLLONESHOT)
+  				epi->event.events &= EP_PRIVATE_BITS;
+  			else if (!(epi->event.events & EPOLLET))
+  				/*
+				 * If this file has been added with Level Trigger
+				 * mode, we need to insert back inside the ready
+				 * list, so that the next call to epoll_wait()
+				 * will check again the events availability.
+  				 * At this point, noone can insert into ep->rdllist
+  				 * besides us. The epoll_ctl() callers are locked
+				 * out by ep_scan_ready_list() holding "mtx" and
+				 * the poll callback will queue them in ep->ovflist.
+  				 */
+  				list_add_tail(&epi->rdllink, &ep->rdllist);
+  		}
+  	}
 
-	spin_lock_irqsave(&ep->lock, flags);
-	/*
-	 * During the time we spent in the loop above, some other events
-	 * might have been queued by the poll callback. We re-insert them
-	 * inside the main ready-list here.
-	 */
-	for (nepi = ep->ovflist; (epi = nepi) != NULL;
-	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
-		/*
-		 * If the above loop quit with errors, the epoll item might still
-		 * be linked to "txlist", and the list_splice() done below will
-		 * take care of those cases.
-		 */
-		if (!ep_is_linked(&epi->rdllink))
-			list_add_tail(&epi->rdllink, &ep->rdllist);
-	}
-	/*
-	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
-	 * releasing the lock, events will be queued in the normal way inside
-	 * ep->rdllist.
-	 */
-	ep->ovflist = EP_UNACTIVE_PTR;
-
-	/*
-	 * In case of error in the event-send loop, or in case the number of
-	 * ready events exceeds the userspace limit, we need to splice the
-	 * "txlist" back inside ep->rdllist.
-	 */
-	list_splice(&txlist, &ep->rdllist);
-
-	if (!list_empty(&ep->rdllist)) {
-		/*
-		 * Wake up (if active) both the eventpoll wait list and the ->poll()
-		 * wait list (delayed after we release the lock).
-		 */
-		if (waitqueue_active(&ep->wq))
-			wake_up_locked(&ep->wq);
-		if (waitqueue_active(&ep->poll_wait))
-			pwake++;
-	}
-	spin_unlock_irqrestore(&ep->lock, flags);
+	return eventcnt;
+}
 
-	mutex_unlock(&ep->mtx);
+static int ep_send_events(struct eventpoll *ep, struct epoll_event __user *events,
+			  int maxevents)
+{
+	struct ep_send_events_data esed;
 
-	/* We have to call this outside the lock */
-	if (pwake)
-		ep_poll_safewake(&psw, &ep->poll_wait);
+	esed.maxevents = maxevents;
+	esed.events = events;
 
-	return eventcnt == 0 ? error: eventcnt;
+	return ep_scan_ready_list(ep, ep_send_events_proc, &esed);
 }
 
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
@@ -1046,7 +1142,7 @@
 	wait_queue_t wait;
 
 	/*
-	 * Calculate the timeout by checking for the "infinite" value ( -1 )
+	 * Calculate the timeout by checking for the "infinite" value (-1)
 	 * and the overflow condition. The passed timeout is in milliseconds,
 	 * that why (t * HZ) / 1000.
 	 */
@@ -1089,9 +1185,8 @@
 
 		set_current_state(TASK_RUNNING);
 	}
-
 	/* Is it worth to try to dig for events ? */
-	eavail = !list_empty(&ep->rdllist);
+	eavail = !list_empty(&ep->rdllist) || ep->ovflist != EP_UNACTIVE_PTR;
 
 	spin_unlock_irqrestore(&ep->lock, flags);
 
@@ -1112,42 +1207,42 @@
  */
 SYSCALL_DEFINE1(epoll_create1, int, flags)
 {
-	int error, fd = -1;
-	struct eventpoll *ep;
+	int error;
+	struct eventpoll *ep = NULL;
 
 	/* Check the EPOLL_* constant for consistency.  */
 	BUILD_BUG_ON(EPOLL_CLOEXEC != O_CLOEXEC);
 
-	if (flags & ~EPOLL_CLOEXEC)
-		return -EINVAL;
-
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d)\n",
 		     current, flags));
 
+	error = -EINVAL;
+	if (flags & ~EPOLL_CLOEXEC)
+		goto error_return;
+
 	/*
-	 * Create the internal data structure ( "struct eventpoll" ).
+	 * Create the internal data structure ("struct eventpoll").
 	 */
 	error = ep_alloc(&ep);
-	if (error < 0) {
-		fd = error;
+	if (error < 0)
 		goto error_return;
-	}
 
 	/*
 	 * Creates all the items needed to setup an eventpoll file. That is,
 	 * a file structure and a free file descriptor.
 	 */
-	fd = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
-			      flags & O_CLOEXEC);
-	if (fd < 0)
+	error = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
+				 flags & O_CLOEXEC);
+	if (error < 0)
 		ep_free(ep);
-	atomic_inc(&ep->user->epoll_devs);
+	else
+		atomic_inc(&ep->user->epoll_devs);
 
 error_return:
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
-		     current, flags, fd));
+		     current, flags, error));
 
-	return fd;
+	return error;
 }
 
 SYSCALL_DEFINE1(epoll_create, int, size)
@@ -1371,7 +1466,10 @@
 		EP_ITEM_COST;
 
 	/* Initialize the structure used to perform safe poll wait head wake ups */
-	ep_poll_safewake_init(&psw);
+	ep_nested_calls_init(&poll_safewake_ncalls);
+
+	/* Initialize the structure used to perform file's f_op->poll() calls */
+	ep_nested_calls_init(&poll_readywalk_ncalls);
 
 	/* Allocates slab cache used to allocate "struct epitem" items */
 	epi_cache = kmem_cache_create("eventpoll_epi", sizeof(struct epitem),

