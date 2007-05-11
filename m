Return-Path: <linux-kernel-owner+w=401wt.eu-S1031810AbXEKT6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031810AbXEKT6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031748AbXEKT5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:57:33 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4840 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966582AbXEKT5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:57:31 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 11 May 2007 12:57:29 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Charles Gagalac <charle97@yahoo.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bugme-new] [Bug 8462] New: applications under wine freezes
In-Reply-To: <Pine.LNX.4.64.0705101150340.18318@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0705111254010.21112@alien.or.mcafeemobile.com>
References: <421462.15161.qm@web60013.mail.yahoo.com>
 <Pine.LNX.4.64.0705101150340.18318@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Davide Libenzi wrote:

> On Thu, 10 May 2007, Charles Gagalac wrote:
> 
> > i just installed the windows version of firefox
> > 2.0.0.3 under wine and firefox also froze after a few
> > minutes of use.
> > 
> > also, wine version is wine-0.9.36.
> 
> Thank you Charles. Would you mind giving the patch below a try?

Charles, would you mind trying the patch below against -git13 on your 
machine. I tested it with wine and firefox on a 32 bit P4 with HT and it's 
working fine.
Andrew, do not even look at it. Comments are totally broken, and for sure 
does not apply over the latest tree after you pushed the other epoll bits.
I'll repost a polished version once it has been verfied.



- Davide




Index: linux-2.6.21/fs/eventpoll.c
===================================================================
--- linux-2.6.21.orig/fs/eventpoll.c	2007-05-10 11:47:10.000000000 -0700
+++ linux-2.6.21/fs/eventpoll.c	2007-05-11 12:18:20.000000000 -0700
@@ -27,7 +27,6 @@
 #include <linux/hash.h>
 #include <linux/spinlock.h>
 #include <linux/syscalls.h>
-#include <linux/rwsem.h>
 #include <linux/rbtree.h>
 #include <linux/wait.h>
 #include <linux/eventpoll.h>
@@ -39,7 +38,6 @@
 #include <asm/io.h>
 #include <asm/mman.h>
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 
 
 /*
@@ -47,7 +45,7 @@
  * There are three level of locking required by epoll :
  *
  * 1) epmutex (mutex)
- * 2) ep->sem (rw_semaphore)
+ * 2) ep->mtx (mutex)
  * 3) ep->lock (rw_lock)
  *
  * The acquire order is the one listed above, from 1 to 3.
@@ -58,19 +56,19 @@
  * a spinlock. During the event transfer loop (from kernel to
  * user space) we could end up sleeping due a copy_to_user(), so
  * we need a lock that will allow us to sleep. This lock is a
- * read-write semaphore (ep->sem). It is acquired on read during
- * the event transfer loop and in write during epoll_ctl(EPOLL_CTL_DEL)
- * and during eventpoll_release_file(). Then we also need a global
- * semaphore to serialize eventpoll_release_file() and ep_free().
- * This semaphore is acquired by ep_free() during the epoll file
+ * mutex (ep->mtx). It is acquired during the event transfer loop,
+ * during epoll_ctl(EPOLL_CTL_DEL) and during eventpoll_release_file().
+ * Then we also need a global mutex to serialize eventpoll_release_file()
+ * and ep_free().
+ * This mutex is acquired by ep_free() during the epoll file
  * cleanup path and it is also acquired by eventpoll_release_file()
  * if a file has been pushed inside an epoll set and it is then
- * close()d without a previous call toepoll_ctl(EPOLL_CTL_DEL).
- * It is possible to drop the "ep->sem" and to use the global
- * semaphore "epmutex" (together with "ep->lock") to have it working,
- * but having "ep->sem" will make the interface more scalable.
+ * close()d without a previous call to epoll_ctl(EPOLL_CTL_DEL).
+ * It is possible to drop the "ep->ntx" and to use the global
+ * mutex "epmutex" (together with "ep->lock") to have it working,
+ * but having "ep->mtx" will make the interface more scalable.
  * Events that require holding "epmutex" are very rare, while for
- * normal operations the epoll private "ep->sem" will guarantee
+ * normal operations the epoll private "ep->mtx" will guarantee
  * a greater scalability.
  */
 
@@ -106,6 +104,7 @@
 
 #define EP_MAX_EVENTS (INT_MAX / sizeof(struct epoll_event))
 
+#define EP_UNACTIVE_PTR ((void *) -1L)
 
 struct epoll_filefd {
 	struct file *file;
@@ -135,6 +134,44 @@
 };
 
 /*
+ * Each file descriptor added to the eventpoll interface will
+ * have an entry of this type linked to the "rbr" RB tree.
+ */
+struct epitem {
+	/* RB-Tree node used to link this structure to the eventpoll rb-tree */
+	struct rb_node rbn;
+
+	/* List header used to link this structure to the eventpoll ready list */
+	struct list_head rdllink;
+
+	/* The file descriptor information this item refers to */
+	struct epoll_filefd ffd;
+
+	/* Number of active wait queue attached to poll operations */
+	int nwait;
+
+	/* List containing poll wait queues */
+	struct list_head pwqlist;
+
+	/* The "container" of this item */
+	struct eventpoll *ep;
+
+	/* The structure that describe the interested events and the source fd */
+	struct epoll_event event;
+
+	/*
+	 * Used to keep track of the usage count of the structure. This avoids
+	 * that the structure will desappear from underneath our processing.
+	 */
+	atomic_t usecnt;
+
+	/* List header used to link this item to the "struct file" items list */
+	struct list_head fllink;
+
+	struct epitem *next;
+};
+
+/*
  * This structure is stored inside the "private_data" member of the file
  * structure and rapresent the main data sructure for the eventpoll
  * interface.
@@ -144,12 +181,10 @@
 	rwlock_t lock;
 
 	/*
-	 * This semaphore is used to ensure that files are not removed
-	 * while epoll is using them. This is read-held during the event
-	 * collection loop and it is write-held during the file cleanup
-	 * path, the epoll file exit code and the ctl operations.
+	 * This mutex is used to ensure that files are not removed
+	 * while epoll is using them.
 	 */
-	struct rw_semaphore sem;
+	struct mutex mtx;
 
 	/* Wait queue used by sys_epoll_wait() */
 	wait_queue_head_t wq;
@@ -162,6 +197,8 @@
 
 	/* RB-Tree root used to store monitored fd structs */
 	struct rb_root rbr;
+
+	struct epitem *ovflist;
 };
 
 /* Wait structure used by the poll hooks */
@@ -182,42 +219,6 @@
 	wait_queue_head_t *whead;
 };
 
-/*
- * Each file descriptor added to the eventpoll interface will
- * have an entry of this type linked to the "rbr" RB tree.
- */
-struct epitem {
-	/* RB-Tree node used to link this structure to the eventpoll rb-tree */
-	struct rb_node rbn;
-
-	/* List header used to link this structure to the eventpoll ready list */
-	struct list_head rdllink;
-
-	/* The file descriptor information this item refers to */
-	struct epoll_filefd ffd;
-
-	/* Number of active wait queue attached to poll operations */
-	int nwait;
-
-	/* List containing poll wait queues */
-	struct list_head pwqlist;
-
-	/* The "container" of this item */
-	struct eventpoll *ep;
-
-	/* The structure that describe the interested events and the source fd */
-	struct epoll_event event;
-
-	/*
-	 * Used to keep track of the usage count of the structure. This avoids
-	 * that the structure will desappear from underneath our processing.
-	 */
-	atomic_t usecnt;
-
-	/* List header used to link this item to the "struct file" items list */
-	struct list_head fllink;
-};
-
 /* Wrapper struct used by poll queueing */
 struct ep_pqueue {
 	poll_table pt;
@@ -248,11 +249,8 @@
 static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *key);
 static int ep_eventpoll_close(struct inode *inode, struct file *file);
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait);
-static int ep_send_events(struct eventpoll *ep, struct list_head *txlist,
-			  struct epoll_event __user *events, int maxevents);
-static int ep_events_transfer(struct eventpoll *ep,
-			      struct epoll_event __user *events,
-			      int maxevents);
+static int ep_send_events(struct eventpoll *ep, struct epoll_event __user *events,
+			  int maxevents);
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout);
 static int eventpollfs_delete_dentry(struct dentry *dentry);
@@ -262,7 +260,7 @@
 			      void *data, struct vfsmount *mnt);
 
 /*
- * This semaphore is used to serialize ep_free() and eventpoll_release_file().
+ * This mutex is used to serialize ep_free() and eventpoll_release_file().
  */
 static struct mutex epmutex;
 
@@ -445,9 +443,9 @@
 	 * We don't want to get "file->f_ep_lock" because it is not
 	 * necessary. It is not necessary because we're in the "struct file"
 	 * cleanup path, and this means that noone is using this file anymore.
-	 * The only hit might come from ep_free() but by holding the semaphore
+	 * The only hit might come from ep_free() but by holding the mutex
 	 * will correctly serialize the operation. We do need to acquire
-	 * "ep->sem" after "epmutex" because ep_remove() requires it when called
+	 * "ep->mtx" after "epmutex" because ep_remove() requires it when called
 	 * from anywhere but ep_free().
 	 */
 	mutex_lock(&epmutex);
@@ -457,9 +455,9 @@
 
 		ep = epi->ep;
 		list_del_init(&epi->fllink);
-		down_write(&ep->sem);
+		mutex_lock(&ep->mtx);
 		ep_remove(ep, epi);
-		up_write(&ep->sem);
+		mutex_unlock(&ep->mtx);
 	}
 
 	mutex_unlock(&epmutex);
@@ -568,7 +566,7 @@
 	 */
 	ep = file->private_data;
 
-	down_write(&ep->sem);
+	mutex_lock(&ep->mtx);
 
 	/* Try to lookup the file inside our RB tree */
 	epi = ep_find(ep, tfile, fd);
@@ -605,7 +603,7 @@
 	if (epi)
 		ep_release_epitem(epi);
 
-	up_write(&ep->sem);
+	mutex_unlock(&ep->mtx);
 
 eexit_3:
 	fput(tfile);
@@ -809,11 +807,12 @@
 		return -ENOMEM;
 
 	rwlock_init(&ep->lock);
-	init_rwsem(&ep->sem);
+	mutex_init(&ep->mtx);
 	init_waitqueue_head(&ep->wq);
 	init_waitqueue_head(&ep->poll_wait);
 	INIT_LIST_HEAD(&ep->rdllist);
 	ep->rbr = RB_ROOT;
+	ep->ovflist = EP_UNACTIVE_PTR;
 
 	*pep = ep;
 
@@ -835,7 +834,7 @@
 	/*
 	 * We need to lock this because we could be hit by
 	 * eventpoll_release_file() while we're freeing the "struct eventpoll".
-	 * We do not need to hold "ep->sem" here because the epoll file
+	 * We do not need to hold "ep->mtx" here because the epoll file
 	 * is on the way to be removed and no one has references to it
 	 * anymore. The only hit might come from eventpoll_release_file() but
 	 * holding "epmutex" is sufficent here.
@@ -854,10 +853,10 @@
 	/*
 	 * Walks through the whole tree by freeing each "struct epitem". At this
 	 * point we are sure no poll callbacks will be lingering around, and also by
-	 * write-holding "sem" we can be sure that no file cleanup code will hit
+	 * holding "epmutex" we can be sure that no file cleanup code will hit
 	 * us during this operation. So we can avoid the lock on "ep->lock".
 	 */
-	while ((rbp = rb_first(&ep->rbr)) != 0) {
+	while ((rbp = rb_first(&ep->rbr)) != NULL) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		ep_remove(ep, epi);
 	}
@@ -993,6 +992,7 @@
 	epi->event = *event;
 	atomic_set(&epi->usecnt, 1);
 	epi->nwait = 0;
+	epi->next = EP_UNACTIVE_PTR;
 
 	/* Initialize the poll table using the queue callback */
 	epq.epi = epi;
@@ -1273,7 +1273,15 @@
 	 * until the next EPOLL_CTL_MOD will be issued.
 	 */
 	if (!(epi->event.events & ~EP_PRIVATE_BITS))
-		goto is_disabled;
+		goto out_unlock;
+
+	if (unlikely(ep->ovflist != EP_UNACTIVE_PTR)) {
+		if (epi->next == EP_UNACTIVE_PTR) {
+			epi->next = ep->ovflist;
+			ep->ovflist = epi;
+		}
+		goto out_unlock;
+	}
 
 	/* If this file is already in the ready list we exit soon */
 	if (ep_is_linked(&epi->rdllink))
@@ -1292,7 +1300,7 @@
 	if (waitqueue_active(&ep->poll_wait))
 		pwake++;
 
-is_disabled:
+out_unlock:
 	write_unlock_irqrestore(&ep->lock, flags);
 
 	/* We have to call this outside the lock */
@@ -1341,31 +1349,48 @@
  * __copy_to_user() might sleep, and also f_op->poll() might reenable the IRQ
  * because of the way poll() is traditionally implemented in Linux.
  */
-static int ep_send_events(struct eventpoll *ep, struct list_head *txlist,
-			  struct epoll_event __user *events, int maxevents)
+static int ep_send_events(struct eventpoll *ep, struct epoll_event __user *events,
+			  int maxevents)
 {
 	int eventcnt, error = -EFAULT, pwake = 0;
 	unsigned int revents;
 	unsigned long flags;
-	struct epitem *epi;
-	struct list_head injlist;
+	struct epitem *epi, *nepi;
+	struct list_head txlist;
 
-	INIT_LIST_HEAD(&injlist);
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
+	 * empty list.
+	 */
+	write_lock_irqsave(&ep->lock, flags);
+	list_splice(&ep->rdllist, &txlist);
+	INIT_LIST_HEAD(&ep->rdllist);
+	ep->ovflist = NULL;
+	write_unlock_irqrestore(&ep->lock, flags);
 
 	/*
 	 * We can loop without lock because this is a task private list.
 	 * We just splice'd out the ep->rdllist in ep_collect_ready_items().
-	 * Items cannot vanish during the loop because we are holding "sem" in
+	 * Items cannot vanish during the loop because we are holding "mtx" in
 	 * read.
 	 */
-	for (eventcnt = 0; !list_empty(txlist) && eventcnt < maxevents;) {
-		epi = list_first_entry(txlist, struct epitem, rdllink);
-		prefetch(epi->rdllink.next);
+	for (eventcnt = 0; !list_empty(&txlist) && eventcnt < maxevents;) {
+		epi = list_first_entry(&txlist, struct epitem, rdllink);
+
+		list_del_init(&epi->rdllink);
 
 		/*
 		 * Get the ready file event set. We can safely use the file
-		 * because we are holding the "sem" in read and this will
-		 * guarantee that both the file and the item will not vanish.
+		 * because we are holding the "mtx" and this will guarantee
+		 * that both the file and the item will not vanish.
 		 */
 		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
 		revents &= epi->event.events;
@@ -1373,8 +1398,8 @@
 		/*
 		 * Is the event mask intersect the caller-requested one,
 		 * deliver the event to userspace. Again, we are holding
-		 * "sem" in read, so no operations coming from userspace
-		 * can change the item.
+		 * "mtx", so no operations coming from userspace can change
+		 * the item.
 		 */
 		if (revents) {
 			if (__put_user(revents,
@@ -1386,47 +1411,24 @@
 				epi->event.events &= EP_PRIVATE_BITS;
 			eventcnt++;
 		}
-
-		/*
-		 * This is tricky. We are holding the "sem" in read, and this
-		 * means that the operations that can change the "linked" status
-		 * of the epoll item (epi->rbn and epi->rdllink), cannot touch
-		 * them.  Also, since we are "linked" from a epi->rdllink POV
-		 * (the item is linked to our transmission list we just
-		 * spliced), the ep_poll_callback() cannot touch us either,
-		 * because of the check present in there. Another parallel
-		 * epoll_wait() will not get the same result set, since we
-		 * spliced the ready list before.  Note that list_del() still
-		 * shows the item as linked to the test in ep_poll_callback().
-		 */
-		list_del(&epi->rdllink);
 		if (!(epi->event.events & EPOLLET) &&
-				(revents & epi->event.events))
-			list_add_tail(&epi->rdllink, &injlist);
-		else {
-			/*
-			 * Be sure the item is totally detached before re-init
-			 * the list_head. After INIT_LIST_HEAD() is committed,
-			 * the ep_poll_callback() can requeue the item again,
-			 * but we don't care since we are already past it.
-			 */
-			smp_mb();
-			INIT_LIST_HEAD(&epi->rdllink);
-		}
+		    (revents & epi->event.events))
+			list_add_tail(&epi->rdllink, &ep->rdllist);
 	}
 	error = 0;
 
-	errxit:
+errxit:
 
-	/*
-	 * If the re-injection list or the txlist are not empty, re-splice
-	 * them to the ready list and do proper wakeups.
-	 */
-	if (!list_empty(&injlist) || !list_empty(txlist)) {
-		write_lock_irqsave(&ep->lock, flags);
+	write_lock_irqsave(&ep->lock, flags);
+	for (nepi = ep->ovflist; (epi = nepi) != NULL;
+	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
+		if (!ep_is_linked(&epi->rdllink))
+			list_add_tail(&epi->rdllink, &ep->rdllist);
+	}
+	ep->ovflist = EP_UNACTIVE_PTR;
+	list_splice(&txlist, &ep->rdllist);
 
-		list_splice(txlist, &ep->rdllist);
-		list_splice(&injlist, &ep->rdllist);
+	if (!list_empty(&ep->rdllist)) {
 		/*
 		 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
 		 * wait list.
@@ -1436,9 +1438,10 @@
 					 TASK_INTERRUPTIBLE);
 		if (waitqueue_active(&ep->poll_wait))
 			pwake++;
-
-		write_unlock_irqrestore(&ep->lock, flags);
 	}
+	write_unlock_irqrestore(&ep->lock, flags);
+
+	mutex_unlock(&ep->mtx);
 
 	/* We have to call this outside the lock */
 	if (pwake)
@@ -1447,43 +1450,6 @@
 	return eventcnt == 0 ? error: eventcnt;
 }
 
-
-/*
- * Perform the transfer of events to user space.
- */
-static int ep_events_transfer(struct eventpoll *ep,
-			      struct epoll_event __user *events, int maxevents)
-{
-	int eventcnt;
-	unsigned long flags;
-	struct list_head txlist;
-
-	INIT_LIST_HEAD(&txlist);
-
-	/*
-	 * We need to lock this because we could be hit by
-	 * eventpoll_release_file() and epoll_ctl(EPOLL_CTL_DEL).
-	 */
-	down_read(&ep->sem);
-
-	/*
-	 * Steal the ready list, and re-init the original one to the
-	 * empty list.
-	 */
-	write_lock_irqsave(&ep->lock, flags);
-	list_splice(&ep->rdllist, &txlist);
-	INIT_LIST_HEAD(&ep->rdllist);
-	write_unlock_irqrestore(&ep->lock, flags);
-
-	/* Build result set in userspace */
-	eventcnt = ep_send_events(ep, &txlist, events, maxevents);
-
-	up_read(&ep->sem);
-
-	return eventcnt;
-}
-
-
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
@@ -1547,7 +1513,7 @@
 	 * more luck.
 	 */
 	if (!res && eavail &&
-	    !(res = ep_events_transfer(ep, events, maxevents)) && jtimeout)
+	    !(res = ep_send_events(ep, events, maxevents)) && jtimeout)
 		goto retry;
 
 	return res;
