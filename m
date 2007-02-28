Return-Path: <linux-kernel-owner+w=401wt.eu-S1751183AbXB1UXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbXB1UXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXB1UXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:23:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44332 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbXB1UXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:23:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Problem with freezable workqueues
Date: Wed, 28 Feb 2007 21:25:52 +0100
User-Agent: KMail/1.9.5
Cc: vatsa@in.ibm.com, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <200702272251.28844.rjw@sisk.pl> <200702282043.24779.rjw@sisk.pl> <20070228200853.GA122@tv-sign.ru>
In-Reply-To: <20070228200853.GA122@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702282125.53318.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 21:08, Oleg Nesterov wrote:
> On 02/28, Rafael J. Wysocki wrote:
> >
> > On Wednesday, 28 February 2007 20:32, Oleg Nesterov wrote:
> > > 
> > > I am sorry, I lost track of this problem. As for 2.6.21, create_freezeable_workqueue
> > > doesn't work and conflict with suspend. Why can't we remove it from XFS as you
> > > suggested before?
> > 
> > Yes, we can (preparing a patch).  I was just curious. :-)
> 
> OK, thanks.
> 
> We can (I think) do pretty much the same with some additional complications
> in worker_thread() (check !cpu_online() after try_to_freeze() and break).

Okay, but I've just finished the patch that removes the freezability of
workqueues (appended), so can we please do this in a separate one?

Rafael

---
Since freezable workqueues are broken in 2.6.21-rc
(cf. http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755,
http://marc.theaimsgroup.com/?l=linux-kernel&m=117261312523921&w=2)
it's better to remove them altogether for 2.6.21 and change the only user of
them (XFS) accordingly.

---
 fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
 include/linux/workqueue.h  |    8 +++-----
 kernel/workqueue.c         |   21 +++++++--------------
 3 files changed, 12 insertions(+), 21 deletions(-)

Index: linux-2.6.21-rc2/kernel/workqueue.c
===================================================================
--- linux-2.6.21-rc2.orig/kernel/workqueue.c
+++ linux-2.6.21-rc2/kernel/workqueue.c
@@ -59,7 +59,6 @@ struct cpu_workqueue_struct {
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
 
-	int freezeable;		/* Freeze the thread during suspend */
 } ____cacheline_aligned;
 
 /*
@@ -352,8 +351,7 @@ static int worker_thread(void *__cwq)
 	struct k_sigaction sa;
 	sigset_t blocked;
 
-	if (!cwq->freezeable)
-		current->flags |= PF_NOFREEZE;
+	current->flags |= PF_NOFREEZE;
 
 	set_user_nice(current, -5);
 
@@ -376,9 +374,6 @@ static int worker_thread(void *__cwq)
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
-		if (cwq->freezeable)
-			try_to_freeze();
-
 		add_wait_queue(&cwq->more_work, &wait);
 		if (list_empty(&cwq->worklist))
 			schedule();
@@ -454,8 +449,8 @@ void fastcall flush_workqueue(struct wor
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
-static struct task_struct *create_workqueue_thread(struct workqueue_struct *wq,
-						   int cpu, int freezeable)
+static struct task_struct
+*create_workqueue_thread(struct workqueue_struct *wq, int cpu)
 {
 	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 	struct task_struct *p;
@@ -465,7 +460,6 @@ static struct task_struct *create_workqu
 	cwq->thread = NULL;
 	cwq->insert_sequence = 0;
 	cwq->remove_sequence = 0;
-	cwq->freezeable = freezeable;
 	INIT_LIST_HEAD(&cwq->worklist);
 	init_waitqueue_head(&cwq->more_work);
 	init_waitqueue_head(&cwq->work_done);
@@ -480,8 +474,7 @@ static struct task_struct *create_workqu
 	return p;
 }
 
-struct workqueue_struct *__create_workqueue(const char *name,
-					    int singlethread, int freezeable)
+struct workqueue_struct *__create_workqueue(const char *name, int singlethread)
 {
 	int cpu, destroy = 0;
 	struct workqueue_struct *wq;
@@ -501,7 +494,7 @@ struct workqueue_struct *__create_workqu
 	mutex_lock(&workqueue_mutex);
 	if (singlethread) {
 		INIT_LIST_HEAD(&wq->list);
-		p = create_workqueue_thread(wq, singlethread_cpu, freezeable);
+		p = create_workqueue_thread(wq, singlethread_cpu);
 		if (!p)
 			destroy = 1;
 		else
@@ -509,7 +502,7 @@ struct workqueue_struct *__create_workqu
 	} else {
 		list_add(&wq->list, &workqueues);
 		for_each_online_cpu(cpu) {
-			p = create_workqueue_thread(wq, cpu, freezeable);
+			p = create_workqueue_thread(wq, cpu);
 			if (p) {
 				kthread_bind(p, cpu);
 				wake_up_process(p);
@@ -760,7 +753,7 @@ static int __devinit workqueue_cpu_callb
 		mutex_lock(&workqueue_mutex);
 		/* Create a new workqueue thread for it. */
 		list_for_each_entry(wq, &workqueues, list) {
-			if (!create_workqueue_thread(wq, hotcpu, 0)) {
+			if (!create_workqueue_thread(wq, hotcpu)) {
 				printk("workqueue for %i failed\n", hotcpu);
 				return NOTIFY_BAD;
 			}
Index: linux-2.6.21-rc2/include/linux/workqueue.h
===================================================================
--- linux-2.6.21-rc2.orig/include/linux/workqueue.h
+++ linux-2.6.21-rc2/include/linux/workqueue.h
@@ -159,11 +159,9 @@ struct execute_work {
 
 
 extern struct workqueue_struct *__create_workqueue(const char *name,
-						    int singlethread,
-						    int freezeable);
-#define create_workqueue(name) __create_workqueue((name), 0, 0)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 0, 1)
-#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
+						    int singlethread);
+#define create_workqueue(name) __create_workqueue((name), 0)
+#define create_singlethread_workqueue(name) __create_workqueue((name), 1)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
Index: linux-2.6.21-rc2/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.21-rc2.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6.21-rc2/fs/xfs/linux-2.6/xfs_buf.c
@@ -1829,11 +1829,11 @@ xfs_buf_init(void)
 	if (!xfs_buf_zone)
 		goto out_free_trace_buf;
 
-	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
+	xfslogd_workqueue = create_workqueue("xfslogd");
 	if (!xfslogd_workqueue)
 		goto out_free_buf_zone;
 
-	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
+	xfsdatad_workqueue = create_workqueue("xfsdatad");
 	if (!xfsdatad_workqueue)
 		goto out_destroy_xfslogd_workqueue;
 

