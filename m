Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYHZIyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYHZIyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYHZIwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:52:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:46732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbYHZIwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:52:23 -0400
From: Tejun Heo <tj@kernel.org>
To: ericvh@gmail.com, rminnich@sandia.gov,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] 9p-trans_fd: use single poller
Date: Tue, 26 Aug 2008 17:50:56 +0900
Message-Id: <1219740656-26458-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219740656-26458-1-git-send-email-tj@kernel.org>
References: <1219740656-26458-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 Aug 2008 08:52:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trans_fd used pool of upto 100 pollers to monitor the r/w fds.  The
approach makes sense in userspace back when the only available
interfaces were poll(2) and select(2).  As each event monitor -
trigger - handling iteration took O(n) where `n' is the number of
watched fds, it makes sense to spread them to many pollers such that
the `n' can be divided by the number of pollers.  However, this
doesn't make any sense in kernel because persistent edge triggered
event monitoring is how the whole thing is implemented in the kernel
in the first place.

This patch converts trans_fd to use single poller which watches all
the fds instead of the poll of pollers approach.  All the fds are
registered for monitoring on creation and only the fds with pending
events are scanned when something happens much like how epoll is
implemented.

This change makes trans_fd fd monitoring more efficient and simpler.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 net/9p/trans_fd.c |  252 ++++++++++++++++++-----------------------------------
 1 files changed, 86 insertions(+), 166 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 0b4eb5f..6866131 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -44,7 +44,6 @@
 #define P9_PORT 564
 #define MAX_SOCK_BUF (64*1024)
 #define ERREQFLUSH	1
-#define SCHED_TIMEOUT	10
 #define MAXPOLLWADDR	2
 
 /**
@@ -135,17 +134,16 @@ struct p9_req {
 	struct list_head req_list;
 };
 
-struct p9_mux_poll_task {
-	struct task_struct *task;
-	struct list_head mux_list;
-	int muxnum;
+struct p9_poll_wait {
+	struct p9_conn *conn;
+	wait_queue_t wait;
+	wait_queue_head_t *wait_addr;
 };
 
 /**
  * struct p9_conn - fd mux connection state information
  * @lock: protects mux_list (?)
  * @mux_list: list link for mux to manage multiple connections (?)
- * @poll_task: task polling on this connection
  * @msize: maximum size for connection (dup)
  * @extended: 9p2000.u flag (dup)
  * @trans: reference to transport instance for this connection
@@ -171,7 +169,6 @@ struct p9_mux_poll_task {
 struct p9_conn {
 	spinlock_t lock; /* protect lock structure */
 	struct list_head mux_list;
-	struct p9_mux_poll_task *poll_task;
 	int msize;
 	unsigned char extended;
 	struct p9_trans *trans;
@@ -185,8 +182,8 @@ struct p9_conn {
 	int wpos;
 	int wsize;
 	char *wbuf;
-	wait_queue_t poll_wait[MAXPOLLWADDR];
-	wait_queue_head_t *poll_waddr[MAXPOLLWADDR];
+	struct list_head poll_pending_link;
+	struct p9_poll_wait poll_wait[MAXPOLLWADDR];
 	poll_table pt;
 	struct work_struct rq;
 	struct work_struct wq;
@@ -220,12 +217,10 @@ static void p9_pollwait(struct file *filp, wait_queue_head_t *wait_address,
 static int p9_fd_write(struct p9_trans *trans, void *v, int len);
 static int p9_fd_read(struct p9_trans *trans, void *v, int len);
 
-static DEFINE_MUTEX(p9_mux_task_lock);
+static DEFINE_SPINLOCK(p9_poll_lock);
+static LIST_HEAD(p9_poll_pending_list);
 static struct workqueue_struct *p9_mux_wq;
-
-static int p9_mux_num;
-static int p9_mux_poll_task_num;
-static struct p9_mux_poll_task p9_mux_poll_tasks[100];
+static struct task_struct *p9_poll_task;
 
 static void p9_conn_destroy(struct p9_conn *);
 static unsigned int p9_fd_poll(struct p9_trans *trans,
@@ -255,130 +250,23 @@ static void p9_mux_put_tag(struct p9_conn *m, u16 tag)
 		p9_idpool_put(tag, m->tagpool);
 }
 
-/**
- * p9_mux_calc_poll_procs - calculates the number of polling procs
- * @muxnum: number of mounts
- *
- * Calculation is based on the number of mounted v9fs filesystems.
- * The current implementation returns sqrt of the number of mounts.
- */
-
-static int p9_mux_calc_poll_procs(int muxnum)
-{
-	int n;
-
-	if (p9_mux_poll_task_num)
-		n = muxnum / p9_mux_poll_task_num +
-		    (muxnum % p9_mux_poll_task_num ? 1 : 0);
-	else
-		n = 1;
-
-	if (n > ARRAY_SIZE(p9_mux_poll_tasks))
-		n = ARRAY_SIZE(p9_mux_poll_tasks);
-
-	return n;
-}
-
-static int p9_mux_poll_start(struct p9_conn *m)
+static void p9_mux_poll_stop(struct p9_conn *m)
 {
-	int i, n;
-	struct p9_mux_poll_task *vpt, *vptlast;
-	struct task_struct *pproc;
-
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p muxnum %d procnum %d\n", m, p9_mux_num,
-		p9_mux_poll_task_num);
-	mutex_lock(&p9_mux_task_lock);
-
-	n = p9_mux_calc_poll_procs(p9_mux_num + 1);
-	if (n > p9_mux_poll_task_num) {
-		for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++) {
-			if (p9_mux_poll_tasks[i].task == NULL) {
-				vpt = &p9_mux_poll_tasks[i];
-				P9_DPRINTK(P9_DEBUG_MUX, "create proc %p\n",
-									vpt);
-				pproc = kthread_create(p9_poll_proc, vpt,
-								"v9fs-poll");
-
-				if (!IS_ERR(pproc)) {
-					vpt->task = pproc;
-					INIT_LIST_HEAD(&vpt->mux_list);
-					vpt->muxnum = 0;
-					p9_mux_poll_task_num++;
-					wake_up_process(vpt->task);
-				}
-				break;
-			}
-		}
-
-		if (i >= ARRAY_SIZE(p9_mux_poll_tasks))
-			P9_DPRINTK(P9_DEBUG_ERROR,
-					"warning: no free poll slots\n");
-	}
+	unsigned long flags;
+	int i;
 
-	n = (p9_mux_num + 1) / p9_mux_poll_task_num +
-	    ((p9_mux_num + 1) % p9_mux_poll_task_num ? 1 : 0);
-
-	vptlast = NULL;
-	for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++) {
-		vpt = &p9_mux_poll_tasks[i];
-		if (vpt->task != NULL) {
-			vptlast = vpt;
-			if (vpt->muxnum < n) {
-				P9_DPRINTK(P9_DEBUG_MUX, "put in proc %d\n", i);
-				list_add(&m->mux_list, &vpt->mux_list);
-				vpt->muxnum++;
-				m->poll_task = vpt;
-				memset(&m->poll_waddr, 0,
-							sizeof(m->poll_waddr));
-				init_poll_funcptr(&m->pt, p9_pollwait);
-				break;
-			}
-		}
-	}
+	for (i = 0; i < ARRAY_SIZE(m->poll_wait); i++) {
+		struct p9_poll_wait *pwait = &m->poll_wait[i];
 
-	if (i >= ARRAY_SIZE(p9_mux_poll_tasks)) {
-		if (vptlast == NULL) {
-			mutex_unlock(&p9_mux_task_lock);
-			return -ENOMEM;
+		if (pwait->wait_addr) {
+			remove_wait_queue(pwait->wait_addr, &pwait->wait);
+			pwait->wait_addr = NULL;
 		}
-
-		P9_DPRINTK(P9_DEBUG_MUX, "put in proc %d\n", i);
-		list_add(&m->mux_list, &vptlast->mux_list);
-		vptlast->muxnum++;
-		m->poll_task = vptlast;
-		memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
-		init_poll_funcptr(&m->pt, p9_pollwait);
 	}
 
-	p9_mux_num++;
-	mutex_unlock(&p9_mux_task_lock);
-
-	return 0;
-}
-
-static void p9_mux_poll_stop(struct p9_conn *m)
-{
-	int i;
-	struct p9_mux_poll_task *vpt;
-
-	mutex_lock(&p9_mux_task_lock);
-	vpt = m->poll_task;
-	list_del(&m->mux_list);
-	for (i = 0; i < ARRAY_SIZE(m->poll_waddr); i++) {
-		if (m->poll_waddr[i] != NULL) {
-			remove_wait_queue(m->poll_waddr[i], &m->poll_wait[i]);
-			m->poll_waddr[i] = NULL;
-		}
-	}
-	vpt->muxnum--;
-	if (!vpt->muxnum) {
-		P9_DPRINTK(P9_DEBUG_MUX, "destroy proc %p\n", vpt);
-		kthread_stop(vpt->task);
-		vpt->task = NULL;
-		p9_mux_poll_task_num--;
-	}
-	p9_mux_num--;
-	mutex_unlock(&p9_mux_task_lock);
+	spin_lock_irqsave(&p9_poll_lock, flags);
+	list_del_init(&m->poll_pending_link);
+	spin_unlock_irqrestore(&p9_poll_lock, flags);
 }
 
 /**
@@ -414,11 +302,8 @@ static struct p9_conn *p9_conn_create(struct p9_trans *trans)
 	INIT_LIST_HEAD(&m->unsent_req_list);
 	INIT_WORK(&m->rq, p9_read_work);
 	INIT_WORK(&m->wq, p9_write_work);
-	n = p9_mux_poll_start(m);
-	if (n) {
-		kfree(m);
-		return ERR_PTR(n);
-	}
+	INIT_LIST_HEAD(&m->poll_pending_link);
+	init_poll_funcptr(&m->pt, p9_pollwait);
 
 	n = p9_fd_poll(trans, &m->pt);
 	if (n & POLLIN) {
@@ -431,11 +316,12 @@ static struct p9_conn *p9_conn_create(struct p9_trans *trans)
 		set_bit(Wpending, &m->wsched);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(m->poll_waddr); i++) {
-		if (IS_ERR(m->poll_waddr[i])) {
+	for (i = 0; i < ARRAY_SIZE(m->poll_wait); i++) {
+		if (IS_ERR(m->poll_wait[i].wait_addr)) {
 			p9_mux_poll_stop(m);
 			kfree(m);
-			return (void *)m->poll_waddr;	/* the error code */
+			/* return the error code */
+			return (void *)m->poll_wait[i].wait_addr;
 		}
 	}
 
@@ -464,6 +350,23 @@ static void p9_conn_destroy(struct p9_conn *m)
 	kfree(m);
 }
 
+static int p9_pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	struct p9_poll_wait *pwait =
+		container_of(wait, struct p9_poll_wait, wait);
+	struct p9_conn *m = pwait->conn;
+	unsigned long flags;
+	DECLARE_WAITQUEUE(dummy_wait, p9_poll_task);
+
+	spin_lock_irqsave(&p9_poll_lock, flags);
+	if (list_empty(&m->poll_pending_link))
+		list_add_tail(&m->poll_pending_link, &p9_poll_pending_list);
+	spin_unlock_irqrestore(&p9_poll_lock, flags);
+
+	/* perform the default wake up operation */
+	return default_wake_function(&dummy_wait, mode, sync, key);
+}
+
 /**
  * p9_pollwait - add poll task to the wait queue
  * @filp: file pointer being polled
@@ -476,29 +379,32 @@ static void p9_conn_destroy(struct p9_conn *m)
 static void
 p9_pollwait(struct file *filp, wait_queue_head_t *wait_address, poll_table *p)
 {
+	struct p9_conn *m = container_of(p, struct p9_conn, pt);
+	struct p9_poll_wait *pwait = NULL;
 	int i;
-	struct p9_conn *m;
 
-	m = container_of(p, struct p9_conn, pt);
-	for (i = 0; i < ARRAY_SIZE(m->poll_waddr); i++)
-		if (m->poll_waddr[i] == NULL)
+	for (i = 0; i < ARRAY_SIZE(m->poll_wait); i++) {
+		if (m->poll_wait[i].wait_addr == NULL) {
+			pwait = &m->poll_wait[i];
 			break;
+		}
+	}
 
-	if (i >= ARRAY_SIZE(m->poll_waddr)) {
+	if (!pwait) {
 		P9_DPRINTK(P9_DEBUG_ERROR, "not enough wait_address slots\n");
 		return;
 	}
 
-	m->poll_waddr[i] = wait_address;
-
 	if (!wait_address) {
 		P9_DPRINTK(P9_DEBUG_ERROR, "no wait_address\n");
-		m->poll_waddr[i] = ERR_PTR(-EIO);
+		pwait->wait_addr = ERR_PTR(-EIO);
 		return;
 	}
 
-	init_waitqueue_entry(&m->poll_wait[i], m->poll_task->task);
-	add_wait_queue(wait_address, &m->poll_wait[i]);
+	pwait->conn = m;
+	pwait->wait_addr = wait_address;
+	init_waitqueue_func_entry(&pwait->wait, p9_pollwake);
+	add_wait_queue(wait_address, &pwait->wait);
 }
 
 /**
@@ -553,23 +459,34 @@ static void p9_poll_mux(struct p9_conn *m)
 
 static int p9_poll_proc(void *a)
 {
-	struct p9_conn *m, *mtmp;
-	struct p9_mux_poll_task *vpt;
+	unsigned long flags;
 
-	vpt = a;
-	P9_DPRINTK(P9_DEBUG_MUX, "start %p %p\n", current, vpt);
-	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
+	P9_DPRINTK(P9_DEBUG_MUX, "start %p\n", current);
+ repeat:
+	spin_lock_irqsave(&p9_poll_lock, flags);
+	while (!list_empty(&p9_poll_pending_list)) {
+		struct p9_conn *conn = list_first_entry(&p9_poll_pending_list,
+							struct p9_conn,
+							poll_pending_link);
+		list_del_init(&conn->poll_pending_link);
+		spin_unlock_irqrestore(&p9_poll_lock, flags);
 
-		list_for_each_entry_safe(m, mtmp, &vpt->mux_list, mux_list) {
-			p9_poll_mux(m);
-		}
+		p9_poll_mux(conn);
 
-		P9_DPRINTK(P9_DEBUG_MUX, "sleeping...\n");
-		schedule_timeout(SCHED_TIMEOUT * HZ);
+		spin_lock_irqsave(&p9_poll_lock, flags);
 	}
+	spin_unlock_irqrestore(&p9_poll_lock, flags);
 
+	set_current_state(TASK_INTERRUPTIBLE);
+	if (list_empty(&p9_poll_pending_list)) {
+		P9_DPRINTK(P9_DEBUG_MUX, "sleeping...\n");
+		schedule();
+	}
 	__set_current_state(TASK_RUNNING);
+
+	if (!kthread_should_stop())
+		goto repeat;
+
 	P9_DPRINTK(P9_DEBUG_MUX, "finish\n");
 	return 0;
 }
@@ -1600,17 +1517,19 @@ static struct p9_trans_module p9_fd_trans = {
 
 int p9_trans_fd_init(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++)
-		p9_mux_poll_tasks[i].task = NULL;
-
 	p9_mux_wq = create_workqueue("v9fs");
 	if (!p9_mux_wq) {
 		printk(KERN_WARNING "v9fs: mux: creating workqueue failed\n");
 		return -ENOMEM;
 	}
 
+	p9_poll_task = kthread_run(p9_poll_proc, NULL, "v9fs-poll");
+	if (IS_ERR(p9_poll_task)) {
+		destroy_workqueue(p9_mux_wq);
+		printk(KERN_WARNING "v9fs: mux: creating poll task failed\n");
+		return PTR_ERR(p9_poll_task);
+	}
+
 	v9fs_register_trans(&p9_tcp_trans);
 	v9fs_register_trans(&p9_unix_trans);
 	v9fs_register_trans(&p9_fd_trans);
@@ -1620,6 +1539,7 @@ int p9_trans_fd_init(void)
 
 void p9_trans_fd_exit(void)
 {
+	kthread_stop(p9_poll_task);
 	v9fs_unregister_trans(&p9_tcp_trans);
 	v9fs_unregister_trans(&p9_unix_trans);
 	v9fs_unregister_trans(&p9_fd_trans);
-- 
1.5.4.5

