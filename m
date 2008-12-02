Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYLBB1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYLBB1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 20:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYLBB10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 20:27:26 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:45937 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbYLBB1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 20:27:25 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 1 Dec 2008 17:27:23 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, ltt-dev@lists.casi.polymtl.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [ltt-dev] [PATCH] Poll : introduce poll_wait_exclusive() new
 function
In-Reply-To: <20081128131311.GC10401@Krystal>
Message-ID: <alpine.DEB.1.10.0812011711280.27086@alien.or.mcafeemobile.com>
References: <20081124205512.26C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081124121659.GA18987@Krystal> <20081125194700.26EB.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.1.10.0811251316590.32523@alien.or.mcafeemobile.com> <20081126111511.GE14826@Krystal>
 <alpine.DEB.1.10.0811261559180.11771@alien.or.mcafeemobile.com> <20081128131311.GC10401@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008, Mathieu Desnoyers wrote:

> Nope, sorry, I don't own any machine with such huge amount of CPUs,
> therefore I can't afford to test that scalability level.

OK, but maybe before trying to push a performance-based patch, some 
pseudo-real numbers should be given ;)



> You say that "You've got at least the spinlock protecting the queue
> where these threads are focusing", you assume we stay limited to the
> current implementation inability to scale correctly. We could think of a
> scheme with :
> 
> - Per cpu waiters. Waiters are added to their own CPU waiting list.
> - Per cpu wakeups, where the wakeup will try to wake up a waiter on the
>   local CPU first.
> 
> If there happens to be no waiters for a local CPU wakeup, the wakeup
> would then be broadcasted to other CPUs, which involves proper locking
> which I think could be done pretty efficiently so we don't hurt the "add
> waiter" fastpath.
> 
> By doing this, we could end up not even taking a global spinlock in the
> add waiter/wakeup fastpaths. So then we would have fixed both the
> thundering herd problem _and_ the global spinlock issue altogether.
> 
> Any thought ?

That looks fine, but before waving the Thundering Herd flag some 
performance numbers should be given IMO, considerng also that this is a 
rather particular use of the poll subsystem.
Eventually, isn't something like the patch below better than adding custom 
case names to poll_wait() ALA poll_wait_LONGNAMESFOLLOW()?
That way you can pass your own queueing function:

	poll_wait_qfunc(file, head, pt, add_wait_queue_exclusive);



- Davide



---
 fs/eventpoll.c       |    7 +++++--
 fs/select.c          |   28 +++++++++++++---------------
 include/linux/poll.h |   18 +++++++++++++++---
 3 files changed, 33 insertions(+), 20 deletions(-)

Index: linux-2.6.mod/fs/select.c
===================================================================
--- linux-2.6.mod.orig/fs/select.c	2008-12-01 16:27:15.000000000 -0800
+++ linux-2.6.mod/fs/select.c	2008-12-01 16:47:53.000000000 -0800
@@ -103,19 +103,6 @@
  * as all select/poll functions have to call it to add an entry to the
  * poll table.
  */
-static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
-		       poll_table *p);
-
-void poll_initwait(struct poll_wqueues *pwq)
-{
-	init_poll_funcptr(&pwq->pt, __pollwait);
-	pwq->error = 0;
-	pwq->table = NULL;
-	pwq->inline_index = 0;
-}
-
-EXPORT_SYMBOL(poll_initwait);
-
 static void free_poll_entry(struct poll_table_entry *entry)
 {
 	remove_wait_queue(entry->wait_address, &entry->wait);
@@ -173,7 +160,8 @@
 
 /* Add a new entry */
 static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
-				poll_table *p)
+		       poll_table *p, void (*qfunc)(wait_queue_head_t *,
+						     wait_queue_t *))
 {
 	struct poll_table_entry *entry = poll_get_entry(p);
 	if (!entry)
@@ -182,9 +170,19 @@
 	entry->filp = filp;
 	entry->wait_address = wait_address;
 	init_waitqueue_entry(&entry->wait, current);
-	add_wait_queue(wait_address, &entry->wait);
+	(*qfunc)(wait_address, &entry->wait);
 }
 
+void poll_initwait(struct poll_wqueues *pwq)
+{
+	init_poll_funcptr(&pwq->pt, __pollwait);
+	pwq->error = 0;
+	pwq->table = NULL;
+	pwq->inline_index = 0;
+}
+
+EXPORT_SYMBOL(poll_initwait);
+
 /**
  * poll_select_set_timeout - helper function to setup the timeout value
  * @to:		pointer to timespec variable for the final timeout
Index: linux-2.6.mod/include/linux/poll.h
===================================================================
--- linux-2.6.mod.orig/include/linux/poll.h	2008-12-01 16:27:15.000000000 -0800
+++ linux-2.6.mod/include/linux/poll.h	2008-12-01 16:55:11.000000000 -0800
@@ -28,16 +28,28 @@
 /* 
  * structures and helpers for f_op->poll implementations
  */
-typedef void (*poll_queue_proc)(struct file *, wait_queue_head_t *, struct poll_table_struct *);
+typedef void (*poll_queue_proc)(struct file *, wait_queue_head_t *,
+				struct poll_table_struct *,
+				void (*)(wait_queue_head_t *, wait_queue_t *));
 
 typedef struct poll_table_struct {
 	poll_queue_proc qproc;
 } poll_table;
 
-static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
+static inline void poll_wait_qfunc(struct file *filp,
+				   wait_queue_head_t *wait_address,
+				   poll_table *p,
+				   void (*qfunc)(wait_queue_head_t *,
+						 wait_queue_t *))
 {
 	if (p && wait_address)
-		p->qproc(filp, wait_address, p);
+		p->qproc(filp, wait_address, p, qfunc);
+}
+
+static inline void poll_wait(struct file *filp, wait_queue_head_t *wait_address,
+			     poll_table *p)
+{
+	poll_wait_qfunc(filp, wait_address, p, add_wait_queue);
 }
 
 static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc qproc)
Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2008-12-01 16:27:15.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2008-12-01 16:39:02.000000000 -0800
@@ -655,7 +655,10 @@
  * target file wakeup lists.
  */
 static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
-				 poll_table *pt)
+				 poll_table *pt,
+				 void (*qfunc)(wait_queue_head_t *,
+					       wait_queue_t *))
+
 {
 	struct epitem *epi = ep_item_from_epqueue(pt);
 	struct eppoll_entry *pwq;
@@ -664,7 +667,7 @@
 		init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
 		pwq->whead = whead;
 		pwq->base = epi;
-		add_wait_queue(whead, &pwq->wait);
+		(*qfunc)(whead, &pwq->wait);
 		list_add_tail(&pwq->llink, &epi->pwqlist);
 		epi->nwait++;
 	} else {
