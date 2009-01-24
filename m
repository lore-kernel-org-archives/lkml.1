Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbZAXV7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbZAXV7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 16:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbZAXV7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 16:59:06 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:40165 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZAXV7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 16:59:03 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 24 Jan 2009 13:58:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unexpected cascaded epoll behavior - my mistake or kernel bug
In-Reply-To: <200901230109.55706.pisa@cmp.felk.cvut.cz>
Message-ID: <alpine.DEB.1.10.0901241355120.9071@alien.or.mcafeemobile.com>
References: <200901230109.55706.pisa@cmp.felk.cvut.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-333381400-1232834341=:9071"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-333381400-1232834341=:9071
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Fri, 23 Jan 2009, Pavel Pisa wrote:

> Hello Davide and all others,
> 
> I have got to implementing yet another event library and I experience
> something strange when level triggered epoll_wait() monitors another
> level triggered epoll set. Top level epoll_wait() return information
> about one event pending. The event points correctly to the monitored
> second level epoll fd, but epoll_wait() on this fd with 0 or small timeout
> returns zero/no events and top level epoll reporting is not reset at this
> point so program enters busy loop. If there are events, they are processed
> correctly. More interresting is, that the ill behavior is prevented if I
> change number of debug writes into unrelated fd or if the application
> is slowed down by strace to standard output. The strace to the
> file does not (fortunatelly) hide ill behavior to the strange behavior
> of my code or kernel can be documented in attached straces. The both
> traces documents the busy loop cause for case, where there is created
> epoll set with fd #3, that set monitors fd #0. When character arrives
> at fd #0, the new epoll fd set with fd #4 is created ad fd #3 is added
> into this new top level fd set.
> 
> epoll_create(8)                         = 3
> epoll_ctl(3, EPOLL_CTL_ADD, 0, {EPOLLIN, {u32=6353264, u64=6353264}}) = 0
> epoll_wait(3, {{EPOLLIN, {u32=6353264, u64=6353264}}}, 8, 20000) = 1
> read(0, "E"..., 1)                      = 1
> ...
> epoll_create(8)                         = 4
> epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=6353664, u64=6353664}}) = 0
> epoll_wait(4, {{EPOLLIN, {u32=6353664, u64=6353664}}}, 8, 19998) = 1
> epoll_wait(3, {{EPOLLIN, {u32=6353264, u64=6353264}}}, 8, 0) = 1
> read(0, "\n"..., 1)                     = 1
> epoll_wait(4, {{EPOLLIN, {u32=6353664, u64=6353664}}}, 8, 19998) = 1
> epoll_wait(3, {}, 8, 0)                 = 0
> epoll_wait(4, {{EPOLLIN, {u32=6353664, u64=6353664}}}, 8, 19998) = 1
> epoll_wait(3, {}, 8, 0)                 = 0
> 
> You may ask, why that terrible clam starts to writting new event library code
> and why he needs to cascade event handling mechanisms. I try to defend myself
> a little. If you do not like beat me, you can skip next section

Pavel, can you give the patch below a spin? It's working fine in my two 
boxes, but it'd be great if you could confirm it too.
Attached there's also a simple test program to check epoll behavior, 
especially the one related to recursion.




- Davide


---
 fs/eventpoll.c |  495 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 296 insertions(+), 199 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2009-01-24 10:06:52.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2009-01-24 13:07:54.000000000 -0800
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
@@ -322,64 +328,95 @@
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
+			return -1;
 		}
 	}
 
 	/* Add the current task to the list */
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
@@ -407,6 +444,104 @@
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
@@ -457,7 +592,7 @@
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
-		ep_poll_safewake(&psw, &ep->poll_wait);
+		ep_poll_safewake(&ep->poll_wait);
 
 	/*
 	 * We need to lock this because we could be hit by
@@ -507,22 +642,44 @@
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
@@ -703,7 +860,7 @@
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(&psw, &ep->poll_wait);
+		ep_poll_safewake(&ep->poll_wait);
 
 	return 1;
 }
@@ -830,7 +987,7 @@
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(&psw, &ep->poll_wait);
+		ep_poll_safewake(&ep->poll_wait);
 
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_insert(%p, %p, %d)\n",
 		     current, ep, tfile, fd));
@@ -904,137 +1061,74 @@
 
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
-
-	/*
-	 * We can loop without lock because this is a task private list.
-	 * We just splice'd out the ep->rdllist in ep_collect_ready_items().
-	 * Items cannot vanish during the loop because we are holding "mtx".
-	 */
-	for (eventcnt = 0; !list_empty(&txlist) && eventcnt < maxevents;) {
-		epi = list_first_entry(&txlist, struct epitem, rdllink);
-
-		list_del_init(&epi->rdllink);
-
-		/*
-		 * Get the ready file event set. We can safely use the file
-		 * because we are holding the "mtx" and this will guarantee
-		 * that both the file and the item will not vanish.
-		 */
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
-		revents &= epi->event.events;
-
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
-
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
+	struct ep_send_events_data *esed = priv;
+	int eventcnt;
+  	unsigned int revents;
+	struct epitem *epi;
+	struct epoll_event __user *uevent;
 
-	/*
-	 * In case of error in the event-send loop, or in case the number of
-	 * ready events exceeds the userspace limit, we need to splice the
-	 * "txlist" back inside ep->rdllist.
-	 */
-	list_splice(&txlist, &ep->rdllist);
+  	/*
+	 * We can loop without lock because we are passed a task private list.
+	 * Items cannot vanish during the loop because ep_scan_ready_list() is
+	 * holding "mtx" during this call.
+  	 */
+	for (eventcnt = 0, uevent = esed->events;
+	     !list_empty(head) && eventcnt < esed->maxevents;) {
+		epi = list_first_entry(head, struct epitem, rdllink);
+
+		list_del_init(head);
+
+  		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+  			epi->event.events;
+
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
@@ -1046,7 +1140,7 @@
 	wait_queue_t wait;
 
 	/*
-	 * Calculate the timeout by checking for the "infinite" value ( -1 )
+	 * Calculate the timeout by checking for the "infinite" value (-1)
 	 * and the overflow condition. The passed timeout is in milliseconds,
 	 * that why (t * HZ) / 1000.
 	 */
@@ -1112,42 +1206,42 @@
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
@@ -1371,7 +1465,10 @@
 		EP_ITEM_COST;
 
 	/* Initialize the structure used to perform safe poll wait head wake ups */
-	ep_poll_safewake_init(&psw);
+	ep_nested_calls_init(&poll_safewake_ncalls);
+
+	/* Initialize the structure used to perform file's f_op->poll() calls */
+	ep_nested_calls_init(&poll_readywalk_ncalls);
 
 	/* Allocates slab cache used to allocate "struct epitem" items */
 	epi_cache = kmem_cache_create("eventpoll_epi", sizeof(struct epitem),
--1795850513-333381400-1232834341=:9071
Content-Type: TEXT/x-csrc; name=epoll_test.c
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=epoll_test.c

LyoNCiAqICBlcG9sbF90ZXN0IGJ5IERhdmlkZSBMaWJlbnppIChTaW1wbGUg
Y29kZSB0byB0ZXN0IGVwb2xsIGludGVybmFscykNCiAqICBDb3B5cmlnaHQg
KEMpIDIwMDggIERhdmlkZSBMaWJlbnppDQogKg0KICogIFRoaXMgcHJvZ3Jh
bSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBh
bmQvb3IgbW9kaWZ5DQogKiAgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBH
TlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkNCiAq
ICB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lv
biAyIG9mIHRoZSBMaWNlbnNlLCBvcg0KICogIChhdCB5b3VyIG9wdGlvbikg
YW55IGxhdGVyIHZlcnNpb24uDQogKg0KICogIFRoaXMgcHJvZ3JhbSBpcyBk
aXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVs
LA0KICogIGJ1dCBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVu
IHRoZSBpbXBsaWVkIHdhcnJhbnR5IG9mDQogKiAgTUVSQ0hBTlRBQklMSVRZ
IG9yIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRo
ZQ0KICogIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRl
dGFpbHMuDQogKg0KICogIFlvdSBzaG91bGQgaGF2ZSByZWNlaXZlZCBhIGNv
cHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlDQogKiAgYWxv
bmcgd2l0aCB0aGlzIHByb2dyYW07IGlmIG5vdCwgd3JpdGUgdG8gdGhlIEZy
ZWUgU29mdHdhcmUNCiAqICBGb3VuZGF0aW9uLCBJbmMuLCA1OSBUZW1wbGUg
UGxhY2UsIFN1aXRlIDMzMCwgQm9zdG9uLCBNQSAgMDIxMTEtMTMwNyAgVVNB
DQogKg0KICogIERhdmlkZSBMaWJlbnppIDxkYXZpZGVsQHhtYWlsc2VydmVy
Lm9yZz4NCiAqDQogKi8NCg0KI2luY2x1ZGUgPHN5cy90eXBlcy5oPg0KI2lu
Y2x1ZGUgPHVuaXN0ZC5oPg0KI2luY2x1ZGUgPHN0ZGlvLmg+DQojaW5jbHVk
ZSA8c3RkbGliLmg+DQojaW5jbHVkZSA8c3RyaW5nLmg+DQojaW5jbHVkZSA8
ZXJybm8uaD4NCiNpbmNsdWRlIDxzaWduYWwuaD4NCiNpbmNsdWRlIDxsaW1p
dHMuaD4NCiNpbmNsdWRlIDxwb2xsLmg+DQojaW5jbHVkZSA8c3lzL2Vwb2xs
Lmg+DQojaW5jbHVkZSA8c3lzL3dhaXQuaD4NCg0KI2RlZmluZSBFUFdBSVRf
VElNRU8JKDEgKiAxMDAwKQ0KI2lmbmRlZiBQT0xMUkRIVVANCiNkZWZpbmUg
UE9MTFJESFVQIDB4MjAwMA0KI2VuZGlmDQoNCiNkZWZpbmUgRVBPTExfTUFY
X0NIQUlOCTEwMEwNCg0KI2RlZmluZSBFUE9MTF9URl9MT09QICgxIDw8IDAp
DQoNCnN0cnVjdCBlcG9sbF90ZXN0X2NmZyB7DQoJbG9uZyBzaXplOw0KCWxv
bmcgZmxhZ3M7DQp9Ow0KDQpzdGF0aWMgaW50IHhlcG9sbF9jcmVhdGUoaW50
IG4pIHsNCglpbnQgZXBmZDsNCg0KCWlmICgoZXBmZCA9IGVwb2xsX2NyZWF0
ZShuKSkgPT0gLTEpIHsNCgkJcGVycm9yKCJlcG9sbF9jcmVhdGUiKTsNCgkJ
ZXhpdCgyKTsNCgl9DQoNCglyZXR1cm4gZXBmZDsNCn0NCg0Kc3RhdGljIHZv
aWQgeGVwb2xsX2N0bChpbnQgZXBmZCwgaW50IGNtZCwgaW50IGZkLCBzdHJ1
Y3QgZXBvbGxfZXZlbnQgKmV2dCkgew0KCWlmIChlcG9sbF9jdGwoZXBmZCwg
Y21kLCBmZCwgZXZ0KSA8IDApIHsNCgkJcGVycm9yKCJlcG9sbF9jdGwiKTsN
CgkJZXhpdCgzKTsNCgl9DQp9DQoNCnN0YXRpYyB2b2lkIHhwaXBlKGludCAq
ZmRzKSB7DQoJaWYgKHBpcGUoZmRzKSkgew0KCQlwZXJyb3IoInBpcGUiKTsN
CgkJZXhpdCg0KTsNCgl9DQp9DQoNCnN0YXRpYyBwaWRfdCB4Zm9yayh2b2lk
KSB7DQoJcGlkX3QgcGlkOw0KDQoJaWYgKChwaWQgPSBmb3JrKCkpID09IChw
aWRfdCkgLTEpIHsNCgkJcGVycm9yKCJwaXBlIik7DQoJCWV4aXQoNSk7DQoJ
fQ0KDQoJcmV0dXJuIHBpZDsNCn0NCg0Kc3RhdGljIGludCBydW5fZm9ya2Vk
X3Byb2MoaW50ICgqcHJvYykodm9pZCAqKSwgdm9pZCAqZGF0YSkgew0KCWlu
dCBzdGF0dXM7DQoJcGlkX3QgcGlkOw0KDQoJaWYgKChwaWQgPSB4Zm9yaygp
KSA9PSAwKQ0KCQlleGl0KCgqcHJvYykoZGF0YSkpOw0KCWlmICh3YWl0cGlk
KHBpZCwgJnN0YXR1cywgMCkgIT0gcGlkKSB7DQoJCXBlcnJvcigid2FpdHBp
ZCIpOw0KCQlyZXR1cm4gLTE7DQoJfQ0KDQoJcmV0dXJuIFdJRkVYSVRFRChz
dGF0dXMpID8gV0VYSVRTVEFUVVMoc3RhdHVzKTogLTI7DQp9DQoNCnN0YXRp
YyBpbnQgY2hlY2tfZXZlbnRzKGludCBmZCwgaW50IHRpbWVvKSB7DQoJc3Ry
dWN0IHBvbGxmZCBwZmQ7DQoNCglmcHJpbnRmKHN0ZG91dCwgIkNoZWNraW5n
IGV2ZW50cyBmb3IgZmQgJWRcbiIsIGZkKTsNCgltZW1zZXQoJnBmZCwgMCwg
c2l6ZW9mKHBmZCkpOw0KCXBmZC5mZCA9IGZkOw0KCXBmZC5ldmVudHMgPSBQ
T0xMSU4gfCBQT0xMT1VUOw0KCWlmIChwb2xsKCZwZmQsIDEsIHRpbWVvKSA8
IDApIHsNCgkJcGVycm9yKCJwb2xsKCkiKTsNCgkJcmV0dXJuIDA7DQoJfQ0K
CWlmIChwZmQucmV2ZW50cyAmIFBPTExJTikNCgkJZnByaW50ZihzdGRvdXQs
ICJcdFBPTExJTlxuIik7DQoJaWYgKHBmZC5yZXZlbnRzICYgUE9MTE9VVCkN
CgkJZnByaW50ZihzdGRvdXQsICJcdFBPTExPVVRcbiIpOw0KCWlmIChwZmQu
cmV2ZW50cyAmIFBPTExFUlIpDQoJCWZwcmludGYoc3Rkb3V0LCAiXHRQT0xM
RVJSXG4iKTsNCglpZiAocGZkLnJldmVudHMgJiBQT0xMSFVQKQ0KCQlmcHJp
bnRmKHN0ZG91dCwgIlx0UE9MTEhVUFxuIik7DQoJaWYgKHBmZC5yZXZlbnRz
ICYgUE9MTFJESFVQKQ0KCQlmcHJpbnRmKHN0ZG91dCwgIlx0UE9MTFJESFVQ
XG4iKTsNCg0KCXJldHVybiBwZmQucmV2ZW50czsNCn0NCg0Kc3RhdGljIGlu
dCBlcG9sbF90ZXN0X3R0eSh2b2lkICpkYXRhKSB7DQoJaW50IGVwZmQsIGlm
ZCA9IGZpbGVubyhzdGRpbiksIHJlczsNCglzdHJ1Y3QgZXBvbGxfZXZlbnQg
ZXZ0Ow0KDQoJaWYgKGNoZWNrX2V2ZW50cyhpZmQsIDApICE9IFBPTExPVVQp
IHsNCgkJZnByaW50ZihzdGRlcnIsICJTb21ldGhpbmcgaXMgY29va2luZyBv
biBTVERJTiAoJWQpXG4iLCBpZmQpOw0KCQlyZXR1cm4gMTsNCgl9DQoJZXBm
ZCA9IHhlcG9sbF9jcmVhdGUoMSk7DQoJZnByaW50ZihzdGRvdXQsICJDcmVh
dGVkIGVwb2xsIGZkICglZClcbiIsIGVwZmQpOw0KCW1lbXNldCgmZXZ0LCAw
LCBzaXplb2YoZXZ0KSk7DQoJZXZ0LmV2ZW50cyA9IEVQT0xMSU47DQoJeGVw
b2xsX2N0bChlcGZkLCBFUE9MTF9DVExfQURELCBpZmQsICZldnQpOw0KCWlm
IChjaGVja19ldmVudHMoZXBmZCwgMCkgJiBQT0xMSU4pIHsNCgkJcmVzID0g
ZXBvbGxfd2FpdChlcGZkLCAmZXZ0LCAxLCAwKTsNCgkJaWYgKHJlcyA9PSAw
KSB7DQoJCQlmcHJpbnRmKHN0ZGVyciwgIkVwb2xsIGZkICglZCkgaXMgcmVh
ZHkgd2hlbiBpdCBzaG91bGRuJ3QhXG4iLA0KCQkJCWVwZmQpOw0KCQkJcmV0
dXJuIDI7DQoJCX0NCgl9DQoNCglyZXR1cm4gMDsNCn0NCg0Kc3RhdGljIGlu
dCBlcG9sbF93YWtldXBfY2hhaW4odm9pZCAqZGF0YSkgew0KCXN0cnVjdCBl
cG9sbF90ZXN0X2NmZyAqdGNmZyA9IGRhdGE7DQoJaW50IGksIHJlcywgZXBm
ZCwgYmZkLCBuZmQsIHBmZHNbMl07DQoJcGlkX3QgcGlkOw0KCXN0cnVjdCBl
cG9sbF9ldmVudCBldnQ7DQoNCgltZW1zZXQoJmV2dCwgMCwgc2l6ZW9mKGV2
dCkpOw0KCWV2dC5ldmVudHMgPSBFUE9MTElOOw0KDQoJZXBmZCA9IGJmZCA9
IHhlcG9sbF9jcmVhdGUoMSk7DQoNCglmb3IgKGkgPSAwOyBpIDwgdGNmZy0+
c2l6ZTsgaSsrKSB7DQoJCW5mZCA9IHhlcG9sbF9jcmVhdGUoMSk7DQoJCXhl
cG9sbF9jdGwoYmZkLCBFUE9MTF9DVExfQURELCBuZmQsICZldnQpOw0KCQli
ZmQgPSBuZmQ7DQoJfQ0KDQoJaWYgKHRjZmctPmZsYWdzICYgRVBPTExfVEZf
TE9PUCkNCgkJeGVwb2xsX2N0bChiZmQsIEVQT0xMX0NUTF9BREQsIGVwZmQs
ICZldnQpOw0KDQoJeHBpcGUocGZkcyk7DQoJeGVwb2xsX2N0bChiZmQsIEVQ
T0xMX0NUTF9BREQsIHBmZHNbMF0sICZldnQpOw0KDQoJLyoNCgkgKiBUaGUg
cGlwZSB3cml0ZSBtdXN0IGNvbWUgYWZ0ZXIgdGhlIHBvbGwoMikgY2FsbCBp
bnNpZGUNCgkgKiBjaGVja19ldmVudHMoKS4gVGhpcyB0ZXN0cyB0aGUgbmVz
dGVkIHdha2V1cCBjb2RlIGluDQoJICogZnMvZXZlbnRwb2xsLmM6ZXBfcG9s
bF9zYWZld2FrZSgpDQoJICogQnkgaGF2aW5nIHRoZSBjaGVja19ldmVudHMo
KSAoaGVuY2UgcG9sbCgyKSkgaGFwcGVucyBmaXJzdCwNCgkgKiB3ZSBoYXZl
IHBvbGwgd2FpdCBxdWV1ZSBmaWxsZWQgdXAsIGFuZCB0aGUgd3JpdGUoMikg
aW4gdGhlDQoJICogY2hpbGQgd2lsbCB0cmlnZ2VyIHRoZSB3YWtldXAgY2hh
aW4uDQoJICovDQoJaWYgKChwaWQgPSB4Zm9yaygpKSA9PSAwKSB7DQoJCXNs
ZWVwKDEpOw0KCQl3cml0ZShwZmRzWzFdLCAidyIsIDEpOw0KCQlleGl0KDAp
Ow0KCX0NCg0KCXJlcyA9IGNoZWNrX2V2ZW50cyhlcGZkLCAyMDAwKSAmIFBP
TExJTjsNCg0KCWlmICh3YWl0cGlkKHBpZCwgTlVMTCwgMCkgIT0gcGlkKSB7
DQoJCXBlcnJvcigid2FpdHBpZCIpOw0KCQlyZXR1cm4gLTE7DQoJfQ0KDQoJ
cmV0dXJuIHJlczsNCn0NCg0Kc3RhdGljIGludCBlcG9sbF9wb2xsX2NoYWlu
KHZvaWQgKmRhdGEpIHsNCglzdHJ1Y3QgZXBvbGxfdGVzdF9jZmcgKnRjZmcg
PSBkYXRhOw0KCWludCBpLCByZXMsIGVwZmQsIGJmZCwgbmZkLCBwZmRzWzJd
Ow0KCXBpZF90IHBpZDsNCglzdHJ1Y3QgZXBvbGxfZXZlbnQgZXZ0Ow0KDQoJ
bWVtc2V0KCZldnQsIDAsIHNpemVvZihldnQpKTsNCglldnQuZXZlbnRzID0g
RVBPTExJTjsNCg0KCWVwZmQgPSBiZmQgPSB4ZXBvbGxfY3JlYXRlKDEpOw0K
DQoJZm9yIChpID0gMDsgaSA8IHRjZmctPnNpemU7IGkrKykgew0KCQluZmQg
PSB4ZXBvbGxfY3JlYXRlKDEpOw0KCQl4ZXBvbGxfY3RsKGJmZCwgRVBPTExf
Q1RMX0FERCwgbmZkLCAmZXZ0KTsNCgkJYmZkID0gbmZkOw0KCX0NCg0KCWlm
ICh0Y2ZnLT5mbGFncyAmIEVQT0xMX1RGX0xPT1ApDQoJCXhlcG9sbF9jdGwo
YmZkLCBFUE9MTF9DVExfQURELCBlcGZkLCAmZXZ0KTsNCg0KCXhwaXBlKHBm
ZHMpOw0KCXhlcG9sbF9jdGwoYmZkLCBFUE9MTF9DVExfQURELCBwZmRzWzBd
LCAmZXZ0KTsNCg0KCS8qDQoJICogVGhlIHBpcGUgd3JpdGUgbXVzaCBjb21l
IGJlZm9yZSB0aGUgcG9sbCgyKSBjYWxsIGluc2lkZQ0KCSAqIGNoZWNrX2V2
ZW50cygpLiBUaGlzIHRlc3RzIHRoZSBuZXN0ZWQgZl9vcC0+cG9sbCBjYWxs
cyBjb2RlIGluDQoJICogZnMvZXZlbnRwb2xsLmM6ZXBfZXZlbnRwb2xsX3Bv
bGwoKQ0KCSAqIEJ5IGhhdmluZyB0aGUgcGlwZSB3cml0ZSgyKSBoYXBwZW4g
Zmlyc3QsIHdlIG1ha2UgdGhlIGtlcm5lbA0KCSAqIGVwb2xsIGNvZGUgdG8g
bG9hZCB0aGUgcmVhZHkgbGlzdHMsIGFuZCB0aGUgZm9sbG93aW5nIHBvbGwo
MikNCgkgKiBkb25lIGluc2lkZSBjaGVja19ldmVudHMoKSB3aWxsIHRlc3Qg
bmVzdGVkIHBvbGwgY29kZSBpbg0KCSAqIGVwX2V2ZW50cG9sbF9wb2xsKCku
DQoJICovDQoJaWYgKChwaWQgPSB4Zm9yaygpKSA9PSAwKSB7DQoJCXdyaXRl
KHBmZHNbMV0sICJ3IiwgMSk7DQoJCWV4aXQoMCk7DQoJfQ0KCXNsZWVwKDEp
Ow0KCXJlcyA9IGNoZWNrX2V2ZW50cyhlcGZkLCAxMDAwKSAmIFBPTExJTjsN
Cg0KCWlmICh3YWl0cGlkKHBpZCwgTlVMTCwgMCkgIT0gcGlkKSB7DQoJCXBl
cnJvcigid2FpdHBpZCIpOw0KCQlyZXR1cm4gLTE7DQoJfQ0KDQoJcmV0dXJu
IHJlczsNCn0NCg0KaW50IG1haW4oaW50IGFjLCBjaGFyICoqYXYpIHsNCglp
bnQgZXJyb3I7DQoJc3RydWN0IGVwb2xsX3Rlc3RfY2ZnIHRjZmc7DQoNCglm
cHJpbnRmKHN0ZG91dCwgIlxuKioqKioqKioqKiBUZXN0aW5nIFRUWSBldmVu
dHNcbiIpOw0KCWVycm9yID0gcnVuX2ZvcmtlZF9wcm9jKGVwb2xsX3Rlc3Rf
dHR5LCBOVUxMKTsNCglmcHJpbnRmKHN0ZG91dCwgZXJyb3IgPT0gMCA/DQoJ
CSIqKioqKioqKioqIE9LXG4iOiAiKioqKioqKioqKiBGQUlMICglZClcbiIs
IGVycm9yKTsNCg0KCXRjZmcuc2l6ZSA9IDM7DQoJdGNmZy5mbGFncyA9IDA7
DQoJZnByaW50ZihzdGRvdXQsICJcbioqKioqKioqKiogVGVzdGluZyBzaG9y
dCB3YWtldXAgY2hhaW5cbiIpOw0KCWVycm9yID0gcnVuX2ZvcmtlZF9wcm9j
KGVwb2xsX3dha2V1cF9jaGFpbiwgJnRjZmcpOw0KCWZwcmludGYoc3Rkb3V0
LCBlcnJvciA9PSBQT0xMSU4gPw0KCQkiKioqKioqKioqKiBPS1xuIjogIioq
KioqKioqKiogRkFJTCAoJWQpXG4iLCBlcnJvcik7DQoNCgl0Y2ZnLnNpemUg
PSBFUE9MTF9NQVhfQ0hBSU47DQoJdGNmZy5mbGFncyA9IDA7DQoJZnByaW50
ZihzdGRvdXQsICJcbioqKioqKioqKiogVGVzdGluZyBsb25nIHdha2V1cCBj
aGFpbiAoSE9MRCBPTilcbiIpOw0KCWVycm9yID0gcnVuX2ZvcmtlZF9wcm9j
KGVwb2xsX3dha2V1cF9jaGFpbiwgJnRjZmcpOw0KCWZwcmludGYoc3Rkb3V0
LCBlcnJvciA9PSAwID8NCgkJIioqKioqKioqKiogT0tcbiI6ICIqKioqKioq
KioqIEZBSUwgKCVkKVxuIiwgZXJyb3IpOw0KDQoJdGNmZy5zaXplID0gMzsN
Cgl0Y2ZnLmZsYWdzID0gMDsNCglmcHJpbnRmKHN0ZG91dCwgIlxuKioqKioq
KioqKiBUZXN0aW5nIHNob3J0IHBvbGwgY2hhaW5cbiIpOw0KCWVycm9yID0g
cnVuX2ZvcmtlZF9wcm9jKGVwb2xsX3BvbGxfY2hhaW4sICZ0Y2ZnKTsNCglm
cHJpbnRmKHN0ZG91dCwgZXJyb3IgPT0gUE9MTElOID8NCgkJIioqKioqKioq
KiogT0tcbiI6ICIqKioqKioqKioqIEZBSUwgKCVkKVxuIiwgZXJyb3IpOw0K
DQoJdGNmZy5zaXplID0gRVBPTExfTUFYX0NIQUlOOw0KCXRjZmcuZmxhZ3Mg
PSAwOw0KCWZwcmludGYoc3Rkb3V0LCAiXG4qKioqKioqKioqIFRlc3Rpbmcg
bG9uZyBwb2xsIGNoYWluIChIT0xEIE9OKVxuIik7DQoJZXJyb3IgPSBydW5f
Zm9ya2VkX3Byb2MoZXBvbGxfcG9sbF9jaGFpbiwgJnRjZmcpOw0KCWZwcmlu
dGYoc3Rkb3V0LCBlcnJvciA9PSAwID8NCgkJIioqKioqKioqKiogT0tcbiI6
ICIqKioqKioqKioqIEZBSUwgKCVkKVxuIiwgZXJyb3IpOw0KDQoJdGNmZy5z
aXplID0gMzsNCgl0Y2ZnLmZsYWdzID0gRVBPTExfVEZfTE9PUDsNCglmcHJp
bnRmKHN0ZG91dCwgIlxuKioqKioqKioqKiBUZXN0aW5nIGxvb3B5IHdha2V1
cCBjaGFpbiAoSE9MRCBPTilcbiIpOw0KCWVycm9yID0gcnVuX2ZvcmtlZF9w
cm9jKGVwb2xsX3dha2V1cF9jaGFpbiwgJnRjZmcpOw0KCWZwcmludGYoc3Rk
b3V0LCBlcnJvciA9PSAwID8NCgkJIioqKioqKioqKiogT0tcbiI6ICIqKioq
KioqKioqIEZBSUwgKCVkKVxuIiwgZXJyb3IpOw0KDQoJdGNmZy5zaXplID0g
MzsNCgl0Y2ZnLmZsYWdzID0gRVBPTExfVEZfTE9PUDsNCglmcHJpbnRmKHN0
ZG91dCwgIlxuKioqKioqKioqKiBUZXN0aW5nIGxvb3B5IHBvbGwgY2hhaW4g
KEhPTEQgT04pXG4iKTsNCgllcnJvciA9IHJ1bl9mb3JrZWRfcHJvYyhlcG9s
bF9wb2xsX2NoYWluLCAmdGNmZyk7DQoJZnByaW50ZihzdGRvdXQsIGVycm9y
ID09IDAgPw0KCQkiKioqKioqKioqKiBPS1xuIjogIioqKioqKioqKiogRkFJ
TCAoJWQpXG4iLCBlcnJvcik7DQoNCg0KCXJldHVybiAwOw0KfQ0KDQo=

--1795850513-333381400-1232834341=:9071--
