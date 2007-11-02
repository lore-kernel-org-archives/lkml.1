Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbXKBQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbXKBQ7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 12:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXKBQ7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 12:59:08 -0400
Received: from 71-33-33-68.albq.qwest.net ([71.33.33.68]:42666 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753843AbXKBQ7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 12:59:02 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2007 12:59:00 EDT
Date: Fri, 2 Nov 2007 10:59:00 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/10] 9p: socket and fd transport changes
Message-ID: <20071102165900.GD16063@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ports the socket/file descriptor transport to the new transport
interface.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
 net/9p/Kconfig    |   18 +-
 net/9p/Makefile   |    2 +-
 net/9p/mux.c      | 1545 ++++++++++++++++++++++++++++-------------------------
 net/9p/trans_fd.c |  473 ----------------
 4 files changed, 832 insertions(+), 1206 deletions(-)

diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index d70cb87..bafc50c 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -13,15 +13,15 @@ menuconfig NET_9P
 
 	  If unsure, say N.
 
-#config NET_9P_FD
-#	depends on NET_9P
-#	default y if NET_9P
-#	tristate "9P File Descriptor Transports (Experimental)"
-#	help
-#	  This builds support for file descriptor transports for 9p
-#	  which includes support for TCP/IP, named pipes, or passed
-#	  file descriptors.  TCP/IP is the default transport for 9p,
-#	  so if you are going to use 9p, you'll likely want this.
+config NET_9P_FD
+	depends on NET_9P
+	default y if NET_9P
+	tristate "9P File Descriptor Transports (Experimental)"
+	help
+	  This builds support for file descriptor transports for 9p
+	  which includes support for TCP/IP, named pipes, or passed
+	  file descriptors.  TCP/IP is the default transport for 9p,
+	  so if you are going to use 9p, you'll likely want this.
 
 config NET_9P_VIRTIO
 	depends on NET_9P && EXPERIMENTAL && VIRTIO
diff --git a/net/9p/Makefile b/net/9p/Makefile
index 8a10511..87c0fa5 100644
--- a/net/9p/Makefile
+++ b/net/9p/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_NET_9P_VIRTIO) += 9pnet_virtio.o
 	util.o \
 
 9pnet_fd-objs := \
-	trans_fd.o \
+	mux.o \
 
 9pnet_virtio-objs := \
 	trans_virtio.o \
diff --git a/net/9p/mux.c b/net/9p/mux.c
index f140147..d0622ab 100644
--- a/net/9p/mux.c
+++ b/net/9p/mux.c
@@ -1,10 +1,12 @@
 /*
- * net/9p/mux.c
+ * net/9p/trans_fd.c
  *
- * Protocol Multiplexer
+ * File Descriptor/Socket Transport
  *
- *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
- *  Copyright (C) 2004-2005 by Latchesar Ionkov <lucho@ionkov.net>
+ *  Copyright (C) 2006 by Russ Cox <rsc@swtch.com>
+ *  Copyright (C) 2004-2007 by Latchesar Ionkov <lucho@ionkov.net>
+ *  Copyright (C) 2004-2007 by Eric Van Hensbergen <ericvh@gmail.com>
+ *  Copyright (C) 1997-2002 by Ron Minnich <rminnich@sarnoff.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2
@@ -30,55 +32,43 @@
 #include <linux/kthread.h>
 #include <linux/idr.h>
 #include <linux/mutex.h>
-#include <net/9p/9p.h>
+#include <linux/in.h>
+#include <linux/net.h>
+#include <linux/ipv6.h>
+#include <linux/inet.h>
+#include <linux/un.h>
+#include <linux/file.h>
 #include <linux/parser.h>
+#include <net/9p/9p.h>
 #include <net/9p/transport.h>
-#include <net/9p/conn.h>
 
+#define P9_PORT 564
+#define MAX_SOCK_BUF (64*1024)
 #define ERREQFLUSH	1
 #define SCHED_TIMEOUT	10
 #define MAXPOLLWADDR	2
 
-enum {
-	Rworksched = 1,		/* read work scheduled or running */
-	Rpending = 2,		/* can read */
-	Wworksched = 4,		/* write work scheduled or running */
-	Wpending = 8,		/* can write */
-};
-
-enum {
-	None,
-	Flushing,
-	Flushed,
-};
-
 struct p9_mux_poll_task;
+struct p9fd_trans_req;
 
-struct p9_req {
-	spinlock_t lock; /* protect request structure */
-	int tag;
-	struct p9_fcall *tcall;
-	struct p9_fcall *rcall;
-	int err;
-	p9_conn_req_callback cb;
-	void *cba;
-	int flush;
-	struct list_head req_list;
+struct p9_fd_opts {
+	int rfd;
+	int wfd;
+	u16 port;
+	u32 msize;
 };
 
-struct p9_conn {
-	spinlock_t lock; /* protect lock structure */
-	struct list_head mux_list;
-	struct p9_mux_poll_task *poll_task;
-	int msize;
-	unsigned char *extended;
+struct p9_trans_fd {
+	spinlock_t lock;	/* protect lock structure */
 	struct p9_trans *trans;
-	struct p9_idpool *tagpool;
-	int err;
+	struct file *rd;	/* read descriptor */
+	struct file *wr;	/* write descriptor */
+	u32 msize;
+	struct list_head trans_list;
+	struct p9fd_poll_task *poll_task;
 	wait_queue_head_t equeue;
 	struct list_head req_list;
 	struct list_head unsent_req_list;
-	struct p9_fcall *rcall;
 	int rpos;
 	char *rbuf;
 	int wpos;
@@ -90,969 +80,1078 @@ struct p9_conn {
 	struct work_struct rq;
 	struct work_struct wq;
 	unsigned long wsched;
+	int (*sent)(struct p9_trans_fd *, struct p9fd_trans_req *);
+	int (*rcvd)(struct p9_trans_fd *, u16 tag, int pos, int size);
 };
 
-struct p9_mux_poll_task {
-	struct task_struct *task;
-	struct list_head mux_list;
-	int muxnum;
+enum {
+	/* p9_trans_fd wsched values */
+	Rworksched = 1,		/* read work scheduled or running */
+	Rpending = 2,		/* can read */
+	Wworksched = 4,		/* write work scheduled or running */
+	Wpending = 8,		/* can write */
 };
 
-struct p9_mux_rpc {
-	struct p9_conn *m;
-	int err;
-	struct p9_fcall *tcall;
-	struct p9_fcall *rcall;
-	wait_queue_head_t wqueue;
-};
 
-static int p9_poll_proc(void *);
-static void p9_read_work(struct work_struct *work);
-static void p9_write_work(struct work_struct *work);
-static void p9_pollwait(struct file *filp, wait_queue_head_t *wait_address,
-			  poll_table * p);
-static u16 p9_mux_get_tag(struct p9_conn *);
-static void p9_mux_put_tag(struct p9_conn *, u16);
+struct p9fd_poll_task {
+	struct task_struct *task;
+	struct list_head trans_list;
+	int transnum;
+};
 
-static DEFINE_MUTEX(p9_mux_task_lock);
-static struct workqueue_struct *p9_mux_wq;
+struct p9fd_trans_req {
+	spinlock_t lock; /* protect request structure */
+	struct p9_trans_req *req;
+	struct list_head req_list;
+};
 
-static int p9_mux_num;
-static int p9_mux_poll_task_num;
-static struct p9_mux_poll_task p9_mux_poll_tasks[100];
+enum {
+	/* p9fd_trans_req status values */
+	None,
+	Flushing,
+	Flushed,
+};
 
-int p9_mux_global_init(void)
-{
-	int i;
+enum {
+	/* Options that take integer arguments */
+	Opt_port, Opt_rfdno, Opt_wfdno, Opt_msize,
+};
 
-	for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++)
-		p9_mux_poll_tasks[i].task = NULL;
+static match_table_t tokens = {
+	{Opt_port, "port=%u"},
+	{Opt_rfdno, "rfdno=%u"},
+	{Opt_wfdno, "wfdno=%u"},
+	{Opt_wfdno, "msize=%u"},
+};
 
-	p9_mux_wq = create_workqueue("v9fs");
-	if (!p9_mux_wq) {
-		printk(KERN_WARNING "v9fs: mux: creating workqueue failed\n");
-		return -ENOMEM;
-	}
+static int p9fd_poll_proc(void *);
+static void p9fd_read_work(struct work_struct *work);
+static void p9fd_write_work(struct work_struct *work);
+static void p9fd_pollwait(struct file *filp, wait_queue_head_t *wait_address,
+			  poll_table * p);
+static void p9fd_read_work(struct work_struct *work);
+static void p9fd_write_work(struct work_struct *work);
+static int p9fd_read(struct p9_trans_fd *trans, void *v, int len);
+static int p9fd_write(struct p9_trans_fd *trans, void *v, int len);
+static unsigned int p9fd_poll(struct p9_trans_fd *trans,
+	struct poll_table_struct *pt);
+static struct p9fd_trans_req *p9fd_req_create(struct p9_trans_fd *trans,
+					struct p9_trans_req *req);
+static void p9fd_trans_shutdown(struct p9_trans_fd *ts, int err);
+
+static struct p9_trans *p9fd_create_tcp_client(const char *devname,
+		char *options);
+static struct p9_trans *p9fd_create_unix_client(const char *devname,
+		char *options);
+static struct p9_trans *p9fd_create_fd_client(const char *devname,
+		char *options);
+
+static DEFINE_MUTEX(p9fd_task_lock);
+static struct workqueue_struct *p9fd_wq;
+
+static int p9fd_num;
+static int p9fd_poll_task_num;
+static struct p9fd_poll_task p9fd_poll_tasks[100];
+
+static struct p9_trans_module p9_tcp_trans = {
+	.name = "tcp",
+	.maxsize = MAX_SOCK_BUF,
+	.def = 1,
+	.create = p9fd_create_tcp_client,
+};
 
-	return 0;
-}
+static struct p9_trans_module p9_unix_trans = {
+	.name = "unix",
+	.maxsize = MAX_SOCK_BUF,
+	.def = 0,
+	.create = p9fd_create_unix_client,
+};
 
-void p9_mux_global_exit(void)
-{
-	destroy_workqueue(p9_mux_wq);
-}
+static struct p9_trans_module p9_fd_trans = {
+	.name = "fd",
+	.maxsize = MAX_SOCK_BUF,
+	.def = 0,
+	.create = p9fd_create_fd_client,
+};
 
 /**
- * p9_mux_calc_poll_procs - calculates the number of polling procs
- * based on the number of mounted v9fs filesystems.
+ * p9fd_calc_poll_procs - calculates the number of polling procs
+ * based on the number of fd transports.
  *
- * The current implementation returns sqrt of the number of mounts.
+ * The current implementation returns sqrt of the number of the transports.
  */
-static int p9_mux_calc_poll_procs(int muxnum)
+static int p9fd_calc_poll_procs(int muxnum)
 {
 	int n;
 
-	if (p9_mux_poll_task_num)
-		n = muxnum / p9_mux_poll_task_num +
-		    (muxnum % p9_mux_poll_task_num ? 1 : 0);
+	if (p9fd_poll_task_num)
+		n = muxnum / p9fd_poll_task_num +
+		    (muxnum % p9fd_poll_task_num ? 1 : 0);
 	else
 		n = 1;
 
-	if (n > ARRAY_SIZE(p9_mux_poll_tasks))
-		n = ARRAY_SIZE(p9_mux_poll_tasks);
+	if (n > ARRAY_SIZE(p9fd_poll_tasks))
+		n = ARRAY_SIZE(p9fd_poll_tasks);
 
 	return n;
 }
 
-static int p9_mux_poll_start(struct p9_conn *m)
+static int p9fd_poll_start(struct p9_trans_fd *trans)
 {
 	int i, n;
-	struct p9_mux_poll_task *vpt, *vptlast;
+	struct p9fd_poll_task *vpt, *vptlast;
 	struct task_struct *pproc;
 
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
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p num %d procnum %d\n", trans,
+		p9fd_num, p9fd_poll_task_num);
+
+	vpt = NULL;
+	mutex_lock(&p9fd_task_lock);
+	n = p9fd_calc_poll_procs(p9fd_num + 1);
+	if (n > p9fd_poll_task_num) {
+		for (i = 0; i < ARRAY_SIZE(p9fd_poll_tasks); i++)
+			if (p9fd_poll_tasks[i].task == NULL)
 				break;
-			}
-		}
 
-		if (i >= ARRAY_SIZE(p9_mux_poll_tasks))
+		if (i < ARRAY_SIZE(p9fd_poll_tasks)) {
+			vpt = &p9fd_poll_tasks[i];
+			P9_DPRINTK(P9_DEBUG_TRANS, "create proc %p\n", vpt);
+			pproc = kthread_create(p9fd_poll_proc, vpt, "9pfd-poll");
+
+			if (!IS_ERR(pproc)) {
+				vpt->task = pproc;
+				INIT_LIST_HEAD(&vpt->trans_list);
+				vpt->transnum = 0;
+				p9fd_poll_task_num++;
+				wake_up_process(vpt->task);
+			}
+		} else
 			P9_DPRINTK(P9_DEBUG_ERROR,
 					"warning: no free poll slots\n");
 	}
 
-	n = (p9_mux_num + 1) / p9_mux_poll_task_num +
-	    ((p9_mux_num + 1) % p9_mux_poll_task_num ? 1 : 0);
+	n = (p9fd_num + 1) / p9fd_poll_task_num +
+	    ((p9fd_num + 1) % p9fd_poll_task_num ? 1 : 0);
 
 	vptlast = NULL;
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
+	for (i = 0; i < ARRAY_SIZE(p9fd_poll_tasks); i++) {
+		if (p9fd_poll_tasks[i].task != NULL) {
+			vpt = &p9fd_poll_tasks[i];
+			if (vpt->transnum < n)
 				break;
-			}
 		}
 	}
 
-	if (i >= ARRAY_SIZE(p9_mux_poll_tasks)) {
-		if (vptlast == NULL)
-			return -ENOMEM;
-
-		P9_DPRINTK(P9_DEBUG_MUX, "put in proc %d\n", i);
-		list_add(&m->mux_list, &vptlast->mux_list);
-		vptlast->muxnum++;
-		m->poll_task = vptlast;
-		memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
-		init_poll_funcptr(&m->pt, p9_pollwait);
+	if (!vpt) {
+		mutex_unlock(&p9fd_task_lock);
+		return -ENOMEM;
 	}
 
-	p9_mux_num++;
-	mutex_unlock(&p9_mux_task_lock);
+	P9_DPRINTK(P9_DEBUG_TRANS, "put in proc %d\n", i);
+	list_add(&trans->trans_list, &vpt->trans_list);
+	vpt->transnum++;
+	trans->poll_task = vpt;
+	memset(&trans->poll_waddr, 0, sizeof(trans->poll_waddr));
+	init_poll_funcptr(&trans->pt, p9fd_pollwait);
+	p9fd_num++;
+	mutex_unlock(&p9fd_task_lock);
 
 	return 0;
 }
 
-static void p9_mux_poll_stop(struct p9_conn *m)
+static void p9fd_poll_stop(struct p9_trans_fd *trans)
 {
 	int i;
-	struct p9_mux_poll_task *vpt;
-
-	mutex_lock(&p9_mux_task_lock);
-	vpt = m->poll_task;
-	list_del(&m->mux_list);
-	for (i = 0; i < ARRAY_SIZE(m->poll_waddr); i++) {
-		if (m->poll_waddr[i] != NULL) {
-			remove_wait_queue(m->poll_waddr[i], &m->poll_wait[i]);
-			m->poll_waddr[i] = NULL;
+	struct p9fd_poll_task *vpt;
+
+	mutex_lock(&p9fd_task_lock);
+	vpt = trans->poll_task;
+	list_del(&trans->trans_list);
+	for (i = 0; i < ARRAY_SIZE(trans->poll_waddr); i++) {
+		if (trans->poll_waddr[i] != NULL) {
+			remove_wait_queue(trans->poll_waddr[i],
+				&trans->poll_wait[i]);
+			trans->poll_waddr[i] = NULL;
 		}
 	}
-	vpt->muxnum--;
-	if (!vpt->muxnum) {
-		P9_DPRINTK(P9_DEBUG_MUX, "destroy proc %p\n", vpt);
+	vpt->transnum--;
+	if (!vpt->transnum) {
+		P9_DPRINTK(P9_DEBUG_TRANS, "destroy proc %p\n", vpt);
 		kthread_stop(vpt->task);
 		vpt->task = NULL;
-		p9_mux_poll_task_num--;
+		p9fd_poll_task_num--;
 	}
-	p9_mux_num--;
-	mutex_unlock(&p9_mux_task_lock);
+	p9fd_num--;
+	mutex_unlock(&p9fd_task_lock);
 }
 
 /**
- * p9_conn_create - allocate and initialize the per-session mux data
+ * p9fd_trans_create - allocate and initialize a fd transport.
  * Creates the polling task if this is the first session.
  *
- * @trans - transport structure
+ * @rfd - read file descriptor
+ * @wfd - write file descriptor
  * @msize - maximum message size
- * @extended - pointer to the extended flag
  */
-struct p9_conn *p9_conn_create(struct p9_trans *trans, int msize,
-				    unsigned char *extended)
+struct p9_trans *p9fd_trans_create(int rfd, int wfd, u32 msize)
 {
-	int i, n;
-	struct p9_conn *m, *mtmp;
+	int i, n, err;
+	struct p9_trans *trans;
+	struct p9_trans_fd *ts;
 
-	P9_DPRINTK(P9_DEBUG_MUX, "transport %p msize %d\n", trans, msize);
-	m = kmalloc(sizeof(struct p9_conn), GFP_KERNEL);
-	if (!m)
+	trans = kzalloc(sizeof(struct p9_trans), GFP_KERNEL);
+	if (!trans)
 		return ERR_PTR(-ENOMEM);
 
-	spin_lock_init(&m->lock);
-	INIT_LIST_HEAD(&m->mux_list);
-	m->msize = msize;
-	m->extended = extended;
-	m->trans = trans;
-	m->tagpool = p9_idpool_create();
-	if (IS_ERR(m->tagpool)) {
-		mtmp = ERR_PTR(-ENOMEM);
-		kfree(m);
-		return mtmp;
+	ts = kzalloc(sizeof(struct p9_trans_fd) + 2 * msize, GFP_KERNEL);
+	if (!ts) {
+		kfree(trans);
+		return ERR_PTR(-ENOMEM);
 	}
 
-	m->err = 0;
-	init_waitqueue_head(&m->equeue);
-	INIT_LIST_HEAD(&m->req_list);
-	INIT_LIST_HEAD(&m->unsent_req_list);
-	m->rcall = NULL;
-	m->rpos = 0;
-	m->rbuf = NULL;
-	m->wpos = m->wsize = 0;
-	m->wbuf = NULL;
-	INIT_WORK(&m->rq, p9_read_work);
-	INIT_WORK(&m->wq, p9_write_work);
-	m->wsched = 0;
-	memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
-	m->poll_task = NULL;
-	n = p9_mux_poll_start(m);
-	if (n) {
-		kfree(m);
-		return ERR_PTR(n);
+	trans->err = 0;
+	trans->priv = ts;
+	trans->msize = msize;
+	trans->dotu = 1;
+
+	spin_lock_init(&ts->lock);
+	ts->trans = trans;
+	ts->msize = msize;
+	ts->rd = fget(rfd);
+	ts->wr = fget(wfd);
+	if (!ts->rd || !ts->wr) {
+		err = -EIO;
+		goto error;
 	}
 
-	n = trans->poll(trans, &m->pt);
+	ts->rd->f_flags |= O_NONBLOCK;
+	ts->wr->f_flags |= O_NONBLOCK;
+	INIT_LIST_HEAD(&ts->trans_list);
+	init_waitqueue_head(&ts->equeue);
+	INIT_LIST_HEAD(&ts->req_list);
+	INIT_LIST_HEAD(&ts->unsent_req_list);
+	ts->rbuf = (u8 *) ts + sizeof(*ts);
+	ts->wbuf = ts->rbuf + msize;
+	ts->rpos = 0;
+	ts->wpos = 0;
+	ts->wsize = 0;
+	INIT_WORK(&ts->rq, p9fd_read_work);
+	INIT_WORK(&ts->wq, p9fd_write_work);
+	ts->wsched = 0;
+	memset(&ts->poll_waddr, 0, sizeof(ts->poll_waddr));
+	ts->poll_task = NULL;
+	err = p9fd_poll_start(ts);
+	if (err)
+		goto error;
+
+	n = p9fd_poll(ts, &ts->pt);
 	if (n & POLLIN) {
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can read\n", m);
-		set_bit(Rpending, &m->wsched);
+		P9_DPRINTK(P9_DEBUG_TRANS, "trans %p can read\n", ts);
+		set_bit(Rpending, &ts->wsched);
 	}
 
 	if (n & POLLOUT) {
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can write\n", m);
-		set_bit(Wpending, &m->wsched);
+		P9_DPRINTK(P9_DEBUG_TRANS, "trans %p can write\n", ts);
+		set_bit(Wpending, &ts->wsched);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(m->poll_waddr); i++) {
-		if (IS_ERR(m->poll_waddr[i])) {
-			p9_mux_poll_stop(m);
-			mtmp = (void *)m->poll_waddr;	/* the error code */
-			kfree(m);
-			m = mtmp;
-			break;
+	for (i = 0; i < ARRAY_SIZE(ts->poll_waddr); i++) {
+		if (IS_ERR(ts->poll_waddr[i])) {
+			err = PTR_ERR(ts->poll_waddr[i]);
+			p9fd_poll_stop(ts);
+			goto error;
 		}
 	}
 
-	return m;
+	return trans;
+
+error:
+	if (ts->rd)
+		fput(ts->rd);
+
+	if (ts->wr)
+		fput(ts->wr);
+
+	kfree(ts);
+	kfree(trans);
+	return ERR_PTR(err);
 }
-EXPORT_SYMBOL(p9_conn_create);
+EXPORT_SYMBOL(p9fd_trans_create);
 
 /**
- * p9_mux_destroy - cancels all pending requests and frees mux resources
+ * p9fd_destroy - cancels all pending requests and frees trans resources
  */
-void p9_conn_destroy(struct p9_conn *m)
+void p9fd_trans_destroy(struct p9_trans *trans)
+{
+	struct p9_trans_fd *ts;
+
+	ts = trans->priv;
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p prev %p next %p\n", ts,
+		ts->trans_list.prev, ts->trans_list.next);
+	p9fd_trans_shutdown(ts, -ECONNRESET);
+	p9fd_poll_stop(ts);
+	fput(ts->rd);
+	fput(ts->wr);
+	kfree(ts);
+	trans->priv = NULL;
+}
+EXPORT_SYMBOL(p9fd_trans_destroy);
+
+static void p9fd_trans_shutdown(struct p9_trans_fd *ts, int err)
 {
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p prev %p next %p\n", m,
-		m->mux_list.prev, m->mux_list.next);
-	p9_conn_cancel(m, -ECONNRESET);
-
-	if (!list_empty(&m->req_list)) {
-		/* wait until all processes waiting on this session exit */
-		P9_DPRINTK(P9_DEBUG_MUX,
-			"mux %p waiting for empty request queue\n", m);
-		wait_event_timeout(m->equeue, (list_empty(&m->req_list)), 5000);
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p request queue empty: %d\n", m,
-			list_empty(&m->req_list));
+	struct p9_trans *trans;
+	struct p9fd_trans_req *fdreq, *fdtmp;
+	LIST_HEAD(req_list);
+
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p err %d\n", ts, err);
+	BUG_ON(err == 0);
+	trans = ts->trans;
+	trans->err = err;
+
+	spin_lock(&ts->lock);
+	list_for_each_entry_safe(fdreq, fdtmp, &ts->unsent_req_list, req_list) {
+		list_move_tail(&fdreq->req_list, &req_list);
+	}
+	list_for_each_entry_safe(fdreq, fdtmp, &ts->req_list, req_list) {
+		list_move_tail(&fdreq->req_list, &req_list);
 	}
+	spin_unlock(&ts->lock);
 
-	p9_mux_poll_stop(m);
-	m->trans = NULL;
-	p9_idpool_destroy(m->tagpool);
-	kfree(m);
+	list_for_each_entry_safe(fdreq, fdtmp, &req_list, req_list) {
+		list_del(&fdreq->req_list);
+
+		if (!fdreq->req->err)
+			fdreq->req->err = err;
+
+		(*fdreq->req->cb)(trans, fdreq->req);
+		kfree(fdreq);
+	}
 }
-EXPORT_SYMBOL(p9_conn_destroy);
 
 /**
- * p9_pollwait - called by files poll operation to add v9fs-poll task
+ * p9fd_pollwait - called by files poll operation to add 9pfd-poll task
  * 	to files wait queue
  */
 static void
-p9_pollwait(struct file *filp, wait_queue_head_t *wait_address,
-	      poll_table * p)
+p9fd_pollwait(struct file *filp, wait_queue_head_t *wait_address,
+	poll_table * p)
 {
 	int i;
-	struct p9_conn *m;
+	struct p9_trans_fd *ts;
 
-	m = container_of(p, struct p9_conn, pt);
-	for (i = 0; i < ARRAY_SIZE(m->poll_waddr); i++)
-		if (m->poll_waddr[i] == NULL)
+	ts = container_of(p, struct p9_trans_fd, pt);
+	for (i = 0; i < ARRAY_SIZE(ts->poll_waddr); i++)
+		if (ts->poll_waddr[i] == NULL)
 			break;
 
-	if (i >= ARRAY_SIZE(m->poll_waddr)) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "not enough wait_address slots\n");
-		return;
-	}
-
-	m->poll_waddr[i] = wait_address;
+	BUG_ON(i >= ARRAY_SIZE(ts->poll_waddr));
+	ts->poll_waddr[i] = wait_address;
 
 	if (!wait_address) {
 		P9_DPRINTK(P9_DEBUG_ERROR, "no wait_address\n");
-		m->poll_waddr[i] = ERR_PTR(-EIO);
+		ts->poll_waddr[i] = ERR_PTR(-EIO);
 		return;
 	}
 
-	init_waitqueue_entry(&m->poll_wait[i], m->poll_task->task);
-	add_wait_queue(wait_address, &m->poll_wait[i]);
+	init_waitqueue_entry(&ts->poll_wait[i], ts->poll_task->task);
+	add_wait_queue(wait_address, &ts->poll_wait[i]);
 }
 
 /**
- * p9_poll_mux - polls a mux and schedules read or write works if necessary
+ * p9fd_poll_trans - polls a mux and schedules read or write works if necessary
  */
-static void p9_poll_mux(struct p9_conn *m)
+static void p9fd_poll_trans(struct p9_trans_fd *ts)
 {
 	int n;
 
-	if (m->err < 0)
+	if (ts->trans->err < 0)
 		return;
 
-	n = m->trans->poll(m->trans, NULL);
+	n = p9fd_poll(ts, NULL);
 	if (n < 0 || n & (POLLERR | POLLHUP | POLLNVAL)) {
-		P9_DPRINTK(P9_DEBUG_MUX, "error mux %p err %d\n", m, n);
+		P9_DPRINTK(P9_DEBUG_TRANS, "error trans %p err %d\n", ts, n);
 		if (n >= 0)
 			n = -ECONNRESET;
-		p9_conn_cancel(m, n);
+		p9fd_trans_shutdown(ts, n);
 	}
 
 	if (n & POLLIN) {
-		set_bit(Rpending, &m->wsched);
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can read\n", m);
-		if (!test_and_set_bit(Rworksched, &m->wsched)) {
-			P9_DPRINTK(P9_DEBUG_MUX, "schedule read work %p\n", m);
-			queue_work(p9_mux_wq, &m->rq);
+		set_bit(Rpending, &ts->wsched);
+		P9_DPRINTK(P9_DEBUG_TRANS, "trans %p can read\n", ts);
+		if (!test_and_set_bit(Rworksched, &ts->wsched)) {
+			P9_DPRINTK(P9_DEBUG_TRANS, "schedule read work %p\n", ts);
+			queue_work(p9fd_wq, &ts->rq);
 		}
 	}
 
 	if (n & POLLOUT) {
-		set_bit(Wpending, &m->wsched);
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can write\n", m);
-		if ((m->wsize || !list_empty(&m->unsent_req_list))
-		    && !test_and_set_bit(Wworksched, &m->wsched)) {
-			P9_DPRINTK(P9_DEBUG_MUX, "schedule write work %p\n", m);
-			queue_work(p9_mux_wq, &m->wq);
+		set_bit(Wpending, &ts->wsched);
+		P9_DPRINTK(P9_DEBUG_TRANS, "trans %p can write\n", ts);
+		if ((ts->wsize || !list_empty(&ts->unsent_req_list))
+		    && !test_and_set_bit(Wworksched, &ts->wsched)) {
+			P9_DPRINTK(P9_DEBUG_TRANS, "schedule write work %p\n", ts);
+			queue_work(p9fd_wq, &ts->wq);
 		}
 	}
 }
 
 /**
- * p9_poll_proc - polls all v9fs transports for new events and queues
+ * p9fd_poll_proc - polls all fd transports for new events and queues
  * 	the appropriate work to the work queue
  */
-static int p9_poll_proc(void *a)
+static int p9fd_poll_proc(void *a)
 {
-	struct p9_conn *m, *mtmp;
-	struct p9_mux_poll_task *vpt;
+	struct p9_trans_fd *ts, *ttmp;
+	struct p9fd_poll_task *vpt;
 
 	vpt = a;
-	P9_DPRINTK(P9_DEBUG_MUX, "start %p %p\n", current, vpt);
+	P9_DPRINTK(P9_DEBUG_TRANS, "start %p %p\n", current, vpt);
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
-		list_for_each_entry_safe(m, mtmp, &vpt->mux_list, mux_list) {
-			p9_poll_mux(m);
+		list_for_each_entry_safe(ts, ttmp, &vpt->trans_list,
+								trans_list) {
+			p9fd_poll_trans(ts);
 		}
 
-		P9_DPRINTK(P9_DEBUG_MUX, "sleeping...\n");
+		P9_DPRINTK(P9_DEBUG_TRANS, "sleeping...\n");
 		schedule_timeout(SCHED_TIMEOUT * HZ);
 	}
 
 	__set_current_state(TASK_RUNNING);
-	P9_DPRINTK(P9_DEBUG_MUX, "finish\n");
+	P9_DPRINTK(P9_DEBUG_TRANS, "finish\n");
 	return 0;
 }
 
+static void p9fd_fill_wbuf(struct p9_trans_fd *ts)
+{
+	int n;
+	struct p9fd_trans_req *req;
+	struct p9_fcall *tc;
+
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p wsize %d\n", ts, ts->wsize);
+	while (ts->wsize < ts->msize) {
+		spin_lock(&ts->lock);
+		if (list_empty(&ts->unsent_req_list)) {
+			spin_unlock(&ts->lock);
+			return;
+		}
+
+		req = list_first_entry(&ts->unsent_req_list,
+			struct p9fd_trans_req, req_list);
+
+		tc = req->req->tc;
+		P9_DPRINTK(P9_DEBUG_TRANS, "tag %d size %d\n", tc->tag,
+			tc->size);
+		if (tc->size + ts->wsize > ts->msize) {
+			spin_unlock(&ts->lock);
+			break;
+		}
+
+		list_del(&req->req_list);
+		spin_unlock(&ts->lock);
+
+		n = p9_fcall_get(ts->wbuf + ts->wsize,
+					ts->msize - ts->wsize, tc);
+		if (n < 0) {
+			p9fd_trans_shutdown(ts, n);
+			return;
+		}
+
+		ts->wsize += n;
+		(*ts->sent)(ts, req);
+	}
+}
+
 /**
- * p9_write_work - called when a transport can send some data
+ * p9fd_write_work - called when a transport can send some data
  */
-static void p9_write_work(struct work_struct *work)
+static void p9fd_write_work(struct work_struct *work)
 {
 	int n, err;
-	struct p9_conn *m;
-	struct p9_req *req;
+	struct p9_trans_fd *ts;
 
-	m = container_of(work, struct p9_conn, wq);
-
-	if (m->err < 0) {
-		clear_bit(Wworksched, &m->wsched);
+	ts = container_of(work, struct p9_trans_fd, wq);
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p\n", ts);
+	if (ts->trans->err < 0) {
+		clear_bit(Wworksched, &ts->wsched);
 		return;
 	}
 
-	if (!m->wsize) {
-		if (list_empty(&m->unsent_req_list)) {
-			clear_bit(Wworksched, &m->wsched);
-			return;
-		}
-
-		spin_lock(&m->lock);
-again:
-		req = list_entry(m->unsent_req_list.next, struct p9_req,
-			       req_list);
-		list_move_tail(&req->req_list, &m->req_list);
-		if (req->err == ERREQFLUSH)
-			goto again;
-
-		m->wbuf = req->tcall->sdata;
-		m->wsize = req->tcall->size;
-		m->wpos = 0;
-		spin_unlock(&m->lock);
+	p9fd_fill_wbuf(ts);
+	if (ts->wpos == ts->wsize) {
+		clear_bit(Wworksched, &ts->wsched);
+		return;
 	}
 
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p pos %d size %d\n", m, m->wpos,
-								m->wsize);
-	clear_bit(Wpending, &m->wsched);
-	err = m->trans->write(m->trans, m->wbuf + m->wpos, m->wsize - m->wpos);
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p sent %d bytes\n", m, err);
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p pos %d size %d\n", ts, ts->wpos,
+		ts->wsize);
+
+	clear_bit(Wpending, &ts->wsched);
+	err = p9fd_write(ts, ts->wbuf + ts->wpos, ts->wsize - ts->wpos);
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p sent %d bytes\n", ts, err);
 	if (err == -EAGAIN) {
-		clear_bit(Wworksched, &m->wsched);
+		clear_bit(Wworksched, &ts->wsched);
 		return;
 	}
 
-	if (err < 0)
-		goto error;
-	else if (err == 0) {
-		err = -EREMOTEIO;
+	if (err <= 0)
 		goto error;
-	}
 
-	m->wpos += err;
-	if (m->wpos == m->wsize)
-		m->wpos = m->wsize = 0;
+	ts->wpos += err;
+	if (ts->wpos == ts->wsize) {
+		ts->wpos = 0;
+		ts->wsize = 0;
+	}
 
-	if (m->wsize == 0 && !list_empty(&m->unsent_req_list)) {
-		if (test_and_clear_bit(Wpending, &m->wsched))
+	p9fd_fill_wbuf(ts);
+	if (ts->wsize > 0) {
+		if (test_and_clear_bit(Wpending, &ts->wsched))
 			n = POLLOUT;
 		else
-			n = m->trans->poll(m->trans, NULL);
+			n = p9fd_poll(ts, NULL);
 
 		if (n & POLLOUT) {
-			P9_DPRINTK(P9_DEBUG_MUX, "schedule write work %p\n", m);
-			queue_work(p9_mux_wq, &m->wq);
+			P9_DPRINTK(P9_DEBUG_TRANS, "schedule write work %p\n", ts);
+			queue_work(p9fd_wq, &ts->wq);
 		} else
-			clear_bit(Wworksched, &m->wsched);
+			clear_bit(Wworksched, &ts->wsched);
 	} else
-		clear_bit(Wworksched, &m->wsched);
+		clear_bit(Wworksched, &ts->wsched);
 
 	return;
 
 error:
-	p9_conn_cancel(m, err);
-	clear_bit(Wworksched, &m->wsched);
-}
-
-static void process_request(struct p9_conn *m, struct p9_req *req)
-{
-	int ecode;
-	struct p9_str *ename;
-
-	if (!req->err && req->rcall->id == P9_RERROR) {
-		ecode = req->rcall->params.rerror.errno;
-		ename = &req->rcall->params.rerror.error;
-
-		P9_DPRINTK(P9_DEBUG_MUX, "Rerror %.*s\n", ename->len,
-								ename->str);
-
-		if (*m->extended)
-			req->err = -ecode;
-
-		if (!req->err) {
-			req->err = p9_errstr2errno(ename->str, ename->len);
-
-			if (!req->err) {	/* string match failed */
-				PRINT_FCALL_ERROR("unknown error", req->rcall);
-			}
-
-			if (!req->err)
-				req->err = -ESERVERFAULT;
-		}
-	} else if (req->tcall && req->rcall->id != req->tcall->id + 1) {
-		P9_DPRINTK(P9_DEBUG_ERROR,
-				"fcall mismatch: expected %d, got %d\n",
-				req->tcall->id + 1, req->rcall->id);
-		if (!req->err)
-			req->err = -EIO;
-	}
+	if (!err)
+		err = -EREMOTEIO;
+	p9fd_trans_shutdown(ts, err);
+	clear_bit(Wworksched, &ts->wsched);
 }
 
 /**
- * p9_read_work - called when there is some data to be read from a transport
+ * p9fd_read_work - called when there is some data to be read from a transport
  */
-static void p9_read_work(struct work_struct *work)
+static void p9fd_read_work(struct work_struct *work)
 {
-	int n, err;
-	struct p9_conn *m;
-	struct p9_req *req, *rptr, *rreq;
-	struct p9_fcall *rcall;
-	char *rbuf;
-
-	m = container_of(work, struct p9_conn, rq);
+	int i, n, err, tag;
+	struct p9_trans_fd *ts;
+	struct p9_trans *trans;
 
-	if (m->err < 0)
+	ts = container_of(work, struct p9_trans_fd, rq);
+	trans = ts->trans;
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p msize %d trans->msize %d\n",
+		ts, ts->msize, trans->msize);
+	if (trans->err < 0)
 		return;
 
-	rcall = NULL;
-	P9_DPRINTK(P9_DEBUG_MUX, "start mux %p pos %d\n", m, m->rpos);
-
-	if (!m->rcall) {
-		m->rcall =
-		    kmalloc(sizeof(struct p9_fcall) + m->msize, GFP_KERNEL);
-		if (!m->rcall) {
-			err = -ENOMEM;
-			goto error;
-		}
-
-		m->rbuf = (char *)m->rcall + sizeof(struct p9_fcall);
-		m->rpos = 0;
-	}
-
-	clear_bit(Rpending, &m->wsched);
-	err = m->trans->read(m->trans, m->rbuf + m->rpos, m->msize - m->rpos);
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p got %d bytes\n", m, err);
+	P9_DPRINTK(P9_DEBUG_TRANS, "start trans %p pos %d\n", ts, ts->rpos);
+	clear_bit(Rpending, &ts->wsched);
+	err = p9fd_read(ts, ts->rbuf + ts->rpos, ts->msize - ts->rpos);
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p got %d bytes\n", ts, err);
 	if (err == -EAGAIN) {
-		clear_bit(Rworksched, &m->wsched);
+		clear_bit(Rworksched, &ts->wsched);
 		return;
 	}
 
 	if (err <= 0)
 		goto error;
 
-	m->rpos += err;
-	while (m->rpos > 4) {
-		n = le32_to_cpu(*(__le32 *) m->rbuf);
-		if (n >= m->msize) {
+	ts->rpos += err;
+	i = 0;
+	while (ts->rpos - i > 0) {
+		n = le32_to_cpu(*(__le32 *) (ts->rbuf + i));
+		if (n >= trans->msize) {
 			P9_DPRINTK(P9_DEBUG_ERROR,
-				"requested packet size too big: %d\n", n);
+				"requested packet size too big: %d %d\n", n,
+				trans->msize);
 			err = -EIO;
 			goto error;
 		}
 
-		if (m->rpos < n)
+		if ((ts->rpos - i) < n)
 			break;
 
-		err =
-		    p9_deserialize_fcall(m->rbuf, n, m->rcall, *m->extended);
-		if (err < 0) {
+		tag = le16_to_cpu(*(__le16 *) (ts->rbuf + i + 5));
+		err = (*ts->rcvd)(ts, tag, i, n);
+		if (err < 0)
 			goto error;
-		}
 
-#ifdef CONFIG_NET_9P_DEBUG
-		if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
-			char buf[150];
+		i += n;
+	}
 
-			p9_printfcall(buf, sizeof(buf), m->rcall,
-				*m->extended);
-			printk(KERN_NOTICE ">>> %p %s\n", m, buf);
-		}
-#endif
-
-		rcall = m->rcall;
-		rbuf = m->rbuf;
-		if (m->rpos > n) {
-			m->rcall = kmalloc(sizeof(struct p9_fcall) + m->msize,
-					   GFP_KERNEL);
-			if (!m->rcall) {
-				err = -ENOMEM;
-				goto error;
-			}
+	if (i < ts->rpos)
+		memmove(ts->rbuf, ts->rbuf + i, ts->rpos - i);
 
-			m->rbuf = (char *)m->rcall + sizeof(struct p9_fcall);
-			memmove(m->rbuf, rbuf + n, m->rpos - n);
-			m->rpos -= n;
-		} else {
-			m->rcall = NULL;
-			m->rbuf = NULL;
-			m->rpos = 0;
-		}
+	ts->rpos -= i;
+	if (test_and_clear_bit(Rpending, &ts->wsched))
+		n = POLLIN;
+	else
+		n = p9fd_poll(ts, NULL);
 
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p fcall id %d tag %d\n", m,
-							rcall->id, rcall->tag);
+	if (n & POLLIN) {
+		P9_DPRINTK(P9_DEBUG_TRANS, "schedule read work %p\n", ts);
+		queue_work(p9fd_wq, &ts->rq);
+	} else
+		clear_bit(Rworksched, &ts->wsched);
 
-		req = NULL;
-		spin_lock(&m->lock);
-		list_for_each_entry_safe(rreq, rptr, &m->req_list, req_list) {
-			if (rreq->tag == rcall->tag) {
-				req = rreq;
-				if (req->flush != Flushing)
-					list_del(&req->req_list);
-				break;
-			}
-		}
-		spin_unlock(&m->lock);
+	return;
 
-		if (req) {
-			req->rcall = rcall;
-			process_request(m, req);
+error:
+	if (!err)
+		err = -EREMOTEIO;
 
-			if (req->flush != Flushing) {
-				if (req->cb)
-					(*req->cb) (req, req->cba);
-				else
-					kfree(req->rcall);
+	p9fd_trans_shutdown(ts, err);
+	clear_bit(Rworksched, &ts->wsched);
+}
 
-				wake_up(&m->equeue);
-			}
-		} else {
-			if (err >= 0 && rcall->id != P9_RFLUSH)
-				P9_DPRINTK(P9_DEBUG_ERROR,
-				  "unexpected response mux %p id %d tag %d\n",
-				  m, rcall->id, rcall->tag);
-			kfree(rcall);
-		}
+void p9fd_client_request(struct p9_trans *trans, struct p9_trans_req *req)
+{
+	int n;
+	struct p9_trans_fd *ts;
+	struct p9fd_trans_req *fdreq;
+
+	ts = trans->priv;
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p tag %d\n", ts, req->tag);
+	fdreq = p9fd_req_create(ts, req);
+	if (IS_ERR(fdreq)) {
+		p9fd_trans_shutdown(ts, PTR_ERR(fdreq));
+		return;
 	}
 
-	if (!list_empty(&m->req_list)) {
-		if (test_and_clear_bit(Rpending, &m->wsched))
-			n = POLLIN;
-		else
-			n = m->trans->poll(m->trans, NULL);
+	spin_lock(&ts->lock);
+	list_add_tail(&fdreq->req_list, &ts->unsent_req_list);
+	spin_unlock(&ts->lock);
 
-		if (n & POLLIN) {
-			P9_DPRINTK(P9_DEBUG_MUX, "schedule read work %p\n", m);
-			queue_work(p9_mux_wq, &m->rq);
-		} else
-			clear_bit(Rworksched, &m->wsched);
-	} else
-		clear_bit(Rworksched, &m->wsched);
+	if (test_and_clear_bit(Wpending, &ts->wsched))
+		n = POLLOUT;
+	else
+		n = p9fd_poll(ts, NULL);
 
-	return;
+	if (n & POLLOUT && !test_and_set_bit(Wworksched, &ts->wsched)) {
+		P9_DPRINTK(P9_DEBUG_TRANS, "schedule write work %p\n", ts);
+		queue_work(p9fd_wq, &ts->wq);
+	}
+}
 
-error:
-	p9_conn_cancel(m, err);
-	clear_bit(Rworksched, &m->wsched);
+int p9fd_client_cancel(struct p9_trans *trans, struct p9_trans_req *req)
+{
+	struct p9_trans_fd *ts;
+	struct p9fd_trans_req *fdreq;
+
+	ts = trans->priv;
+	spin_lock(&ts->lock);
+	list_for_each_entry(fdreq, &ts->unsent_req_list, req_list) {
+		if (req == fdreq->req) {
+			list_del(&fdreq->req_list);
+			spin_unlock(&ts->lock);
+			if (!req->err)
+				req->err = -EINTR;
+
+			(*req->cb)(trans, req);
+			kfree(fdreq);
+			return 0;
+		}
+	}
+
+	return -ENOENT;
 }
 
-/**
- * p9_send_request - send 9P request
- * The function can sleep until the request is scheduled for sending.
- * The function can be interrupted. Return from the function is not
- * a guarantee that the request is sent successfully. Can return errors
- * that can be retrieved by PTR_ERR macros.
- *
- * @m: mux data
- * @tc: request to be sent
- * @cb: callback function to call when response is received
- * @cba: parameter to pass to the callback function
- */
-static struct p9_req *p9_send_request(struct p9_conn *m,
-					  struct p9_fcall *tc,
-					  p9_conn_req_callback cb, void *cba)
+int p9fd_client_sent(struct p9_trans_fd *ts, struct p9fd_trans_req *fdreq)
+{
+	P9_DPRINTK(P9_DEBUG_TRANS, "tag %d\n", fdreq->req->tag);
+	spin_lock(&ts->lock);
+	list_add_tail(&fdreq->req_list, &ts->req_list);
+	spin_unlock(&ts->lock);
+	return 0;
+}
+
+int p9fd_client_rcvd(struct p9_trans_fd *ts, u16 tag, int start, int count)
 {
 	int n;
-	struct p9_req *req;
+	struct p9fd_trans_req *fdr, *fdreq;
+	struct p9_trans_req *req;
+	struct p9_fcall *rc;
+
+	spin_lock(&ts->lock);
+	fdreq = NULL;
+	list_for_each_entry(fdr, &ts->req_list, req_list) {
+		if (fdr->req->tag == tag) {
+			list_del(&fdr->req_list);
+			fdreq = fdr;
+			break;
+		}
+	}
+	spin_unlock(&ts->lock);
 
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p task %p tcall %p id %d\n", m, current,
-		tc, tc->id);
-	if (m->err < 0)
-		return ERR_PTR(m->err);
+	if (!fdreq) {
+		P9_DPRINTK(P9_DEBUG_ERROR, "req not found: tag %d\n", tag);
+		return 0;
+	}
 
-	req = kmalloc(sizeof(struct p9_req), GFP_KERNEL);
-	if (!req)
-		return ERR_PTR(-ENOMEM);
+	req = fdreq->req;
+	kfree(fdreq);
+	if (!req->rc) {
+		rc = p9_fcall_alloc(count);
+		if (IS_ERR(rc))
+			return PTR_ERR(rc);
+		req->rc = rc;
+	}
 
-	if (tc->id == P9_TVERSION)
-		n = P9_NOTAG;
-	else
-		n = p9_mux_get_tag(m);
+	n = p9_fcall_put(req->rc, ts->rbuf + start, count);
+	if (n < 0)
+		return n;
 
+	n = p9_deserialize_fcall(req->rc, ts->trans->dotu);
 	if (n < 0)
-		return ERR_PTR(-ENOMEM);
+		return n;
 
-	p9_set_tag(tc, n);
+	(*req->cb)(ts->trans, req);
 
-#ifdef CONFIG_NET_9P_DEBUG
-	if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
-		char buf[150];
+	return 0;
+}
 
-		p9_printfcall(buf, sizeof(buf), tc, *m->extended);
-		printk(KERN_NOTICE "<<< %p %s\n", m, buf);
-	}
-#endif
-
-	spin_lock_init(&req->lock);
-	req->tag = n;
-	req->tcall = tc;
-	req->rcall = NULL;
-	req->err = 0;
-	req->cb = cb;
-	req->cba = cba;
-	req->flush = None;
-
-	spin_lock(&m->lock);
-	list_add_tail(&req->req_list, &m->unsent_req_list);
-	spin_unlock(&m->lock);
-
-	if (test_and_clear_bit(Wpending, &m->wsched))
-		n = POLLOUT;
-	else
-		n = m->trans->poll(m->trans, NULL);
+static struct p9fd_trans_req *p9fd_req_create(struct p9_trans_fd *trans,
+					struct p9_trans_req *req)
+{
+	struct p9fd_trans_req *fdreq;
 
-	if (n & POLLOUT && !test_and_set_bit(Wworksched, &m->wsched))
-		queue_work(p9_mux_wq, &m->wq);
+	fdreq = kmalloc(sizeof(*fdreq), GFP_KERNEL);
+	if (!fdreq)
+		return ERR_PTR(-ENOMEM);
 
-	return req;
-}
+	spin_lock_init(&fdreq->lock);
+	fdreq->req = req;
+	INIT_LIST_HEAD(&fdreq->req_list);
 
-static void p9_mux_free_request(struct p9_conn *m, struct p9_req *req)
-{
-	p9_mux_put_tag(m, req->tag);
-	kfree(req);
+	return fdreq;
 }
 
-static void p9_mux_flush_cb(struct p9_req *freq, void *a)
+/**
+ * parse_options - parse mount options into session structure
+ * @options: options string passed from mount
+ * @v9ses: existing v9fs session information
+ *
+ */
+
+static void parse_opts(char *options, struct p9_fd_opts *opts)
 {
-	p9_conn_req_callback cb;
-	int tag;
-	struct p9_conn *m;
-	struct p9_req *req, *rreq, *rptr;
-
-	m = a;
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p tc %p rc %p err %d oldtag %d\n", m,
-		freq->tcall, freq->rcall, freq->err,
-		freq->tcall->params.tflush.oldtag);
-
-	spin_lock(&m->lock);
-	cb = NULL;
-	tag = freq->tcall->params.tflush.oldtag;
-	req = NULL;
-	list_for_each_entry_safe(rreq, rptr, &m->req_list, req_list) {
-		if (rreq->tag == tag) {
-			req = rreq;
-			list_del(&req->req_list);
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int option;
+	int ret;
+
+	opts->port = P9_PORT;
+	opts->rfd = ~0;
+	opts->wfd = ~0;
+	opts->msize = MAX_SOCK_BUF;
+
+	if (!options)
+		return;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+		token = match_token(p, tokens, args);
+		ret = match_int(&args[0], &option);
+		if (ret < 0) {
+			P9_DPRINTK(P9_DEBUG_ERROR,
+			 "integer field, but no integer?\n");
+			continue;
+		}
+		switch (token) {
+		case Opt_port:
+			opts->port = option;
+			break;
+		case Opt_rfdno:
+			opts->rfd = option;
 			break;
+		case Opt_wfdno:
+			opts->wfd = option;
+			break;
+		case Opt_msize:
+			opts->msize = option;
+			break;
+		default:
+			continue;
 		}
 	}
-	spin_unlock(&m->lock);
+}
 
-	if (req) {
-		spin_lock(&req->lock);
-		req->flush = Flushed;
-		spin_unlock(&req->lock);
+/**
+ * p9fd_read- read from a fd
+ * @trans: session information
+ * @v: buffer to receive data into
+ * @len: size of receive buffer
+ *
+ */
+static int p9fd_read(struct p9_trans_fd *trans, void *v, int len)
+{
+	int ret;
 
-		if (req->cb)
-			(*req->cb) (req, req->cba);
-		else
-			kfree(req->rcall);
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p len %d\n", trans, len);
+	if (trans->trans->err)
+		return trans->trans->err;
 
-		wake_up(&m->equeue);
-	}
+	ret = kernel_read(trans->rd, trans->rd->f_pos, v, len);
+	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
+		trans->trans->err = ret;
 
-	kfree(freq->tcall);
-	kfree(freq->rcall);
-	p9_mux_free_request(m, freq);
+	return ret;
 }
 
-static int
-p9_mux_flush_request(struct p9_conn *m, struct p9_req *req)
+/**
+ * p9fd_write - write to a fd
+ * @trans: session information
+ * @v: buffer to send data from
+ * @len: size of send buffer
+ *
+ */
+static int p9fd_write(struct p9_trans_fd *trans, void *v, int len)
 {
-	struct p9_fcall *fc;
-	struct p9_req *rreq, *rptr;
+	int ret;
+	mm_segment_t oldfs;
 
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p req %p tag %d\n", m, req, req->tag);
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p len %d\n", trans, len);
+	if (trans->trans->err)
+		return trans->trans->err;
 
-	/* if a response was received for a request, do nothing */
-	spin_lock(&req->lock);
-	if (req->rcall || req->err) {
-		spin_unlock(&req->lock);
-		P9_DPRINTK(P9_DEBUG_MUX,
-			"mux %p req %p response already received\n", m, req);
-		return 0;
+	oldfs = get_fs();
+	set_fs(get_ds());
+	/* The cast to a user pointer is valid due to the set_fs() */
+	ret = vfs_write(trans->wr, (void __user *)v, len, &trans->wr->f_pos);
+	set_fs(oldfs);
+
+	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
+		trans->trans->err = ret;
+
+	return ret;
+}
+
+static unsigned int p9fd_poll(struct p9_trans_fd *ts,
+	struct poll_table_struct *pt)
+{
+	int ret, n;
+	struct p9_trans *trans;
+	mm_segment_t oldfs;
+
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p\n", ts);
+	trans = ts->trans;
+	if (trans->err)
+		return trans->err;
+
+	if (!ts->rd->f_op || !ts->rd->f_op->poll)
+		return -EIO;
+
+	if (!ts->wr->f_op || !ts->wr->f_op->poll)
+		return -EIO;
+
+	oldfs = get_fs();
+	set_fs(get_ds());
+
+	ret = ts->rd->f_op->poll(ts->rd, pt);
+	if (ret < 0) {
+		trans->err = ret;
+		goto end;
 	}
 
-	req->flush = Flushing;
-	spin_unlock(&req->lock);
-
-	spin_lock(&m->lock);
-	/* if the request is not sent yet, just remove it from the list */
-	list_for_each_entry_safe(rreq, rptr, &m->unsent_req_list, req_list) {
-		if (rreq->tag == req->tag) {
-			P9_DPRINTK(P9_DEBUG_MUX,
-			   "mux %p req %p request is not sent yet\n", m, req);
-			list_del(&rreq->req_list);
-			req->flush = Flushed;
-			spin_unlock(&m->lock);
-			if (req->cb)
-				(*req->cb) (req, req->cba);
-			return 0;
+	if (ts->rd != ts->wr) {
+		n = ts->wr->f_op->poll(ts->wr, pt);
+		if (n < 0) {
+			ret = n;
+			trans->err = ret;
+			goto end;
 		}
+		ret = (ret & ~POLLOUT) | (n & ~POLLIN);
 	}
-	spin_unlock(&m->lock);
 
-	clear_thread_flag(TIF_SIGPENDING);
-	fc = p9_create_tflush(req->tag);
-	p9_send_request(m, fc, p9_mux_flush_cb, m);
-	return 1;
+end:
+	set_fs(oldfs);
+	return ret;
 }
 
-static void
-p9_conn_rpc_cb(struct p9_req *req, void *a)
+static struct p9_trans *p9fd_socket_open(struct socket *csocket, int msize)
 {
-	struct p9_mux_rpc *r;
+	int fd;
+	struct p9_trans *trans;
 
-	P9_DPRINTK(P9_DEBUG_MUX, "req %p r %p\n", req, a);
-	r = a;
-	r->rcall = req->rcall;
-	r->err = req->err;
+	csocket->sk->sk_allocation = GFP_NOIO;
+	fd = sock_map_fd(csocket);
+	if (fd < 0) {
+		P9_EPRINTK(KERN_ERR, "p9_socket_open: failed to map fd\n");
+		return ERR_PTR(fd);
+	}
 
-	if (req->flush != None && !req->err)
-		r->err = -ERESTARTSYS;
+	trans = p9fd_trans_create(fd, fd, msize);
+	if (IS_ERR(trans)) {
+		P9_EPRINTK(KERN_ERR, "p9_socket_open: failed to open fd\n");
+		sockfd_put(csocket);
+		return trans;
+	}
 
-	wake_up(&r->wqueue);
+	return trans;
 }
 
-/**
- * p9_mux_rpc - sends 9P request and waits until a response is available.
- *	The function can be interrupted.
- * @m: mux data
- * @tc: request to be sent
- * @rc: pointer where a pointer to the response is stored
- */
-int
-p9_conn_rpc(struct p9_conn *m, struct p9_fcall *tc,
-	     struct p9_fcall **rc)
+static struct p9_trans *p9fd_create_tcp_client(const char *addr, char *args)
 {
-	int err, sigpending;
-	unsigned long flags;
-	struct p9_req *req;
-	struct p9_mux_rpc r;
-
-	r.err = 0;
-	r.tcall = tc;
-	r.rcall = NULL;
-	r.m = m;
-	init_waitqueue_head(&r.wqueue);
-
-	if (rc)
-		*rc = NULL;
-
-	sigpending = 0;
-	if (signal_pending(current)) {
-		sigpending = 1;
-		clear_thread_flag(TIF_SIGPENDING);
+	int err;
+	struct p9_trans *trans;
+	struct p9_trans_fd *ts;
+	struct socket *csocket;
+	struct sockaddr_in sin_server;
+	struct p9_fd_opts opts;
+
+	parse_opts(args, &opts);
+	csocket = NULL;
+	sin_server.sin_family = AF_INET;
+	sin_server.sin_addr.s_addr = in_aton(addr);
+	sin_server.sin_port = htons(opts.port);
+	sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &csocket);
+	if (!csocket) {
+		P9_EPRINTK(KERN_ERR, "p9_trans_tcp: problem creating socket\n");
+		err = -EIO;
+		goto error;
 	}
 
-	req = p9_send_request(m, tc, p9_conn_rpc_cb, &r);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
-		P9_DPRINTK(P9_DEBUG_MUX, "error %d\n", err);
-		return err;
+	P9_DPRINTK(P9_DEBUG_TRANS, "name '%s' port %d\n", addr, opts.port);
+	err = csocket->ops->connect(csocket, (struct sockaddr *) &sin_server,
+				    sizeof(struct sockaddr_in), 0);
+	if (err < 0) {
+		P9_EPRINTK(KERN_ERR,
+			"p9_trans_tcp: problem connecting socket to %s\n",
+			addr);
+		goto error;
 	}
 
-	err = wait_event_interruptible(r.wqueue, r.rcall != NULL || r.err < 0);
-	if (r.err < 0)
-		err = r.err;
-
-	if (err == -ERESTARTSYS && m->trans->status == Connected
-							&& m->err == 0) {
-		if (p9_mux_flush_request(m, req)) {
-			/* wait until we get response of the flush message */
-			do {
-				clear_thread_flag(TIF_SIGPENDING);
-				err = wait_event_interruptible(r.wqueue,
-					r.rcall || r.err);
-			} while (!r.rcall && !r.err && err == -ERESTARTSYS &&
-				m->trans->status == Connected && !m->err);
-
-			err = -ERESTARTSYS;
-		}
-		sigpending = 1;
+	trans = p9fd_socket_open(csocket, opts.msize);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto error;
 	}
 
-	if (sigpending) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
-	}
+	trans->request = p9fd_client_request;
+	trans->cancel = p9fd_client_cancel;
+	trans->destroy = p9fd_trans_destroy;
+	ts = trans->priv;
+	ts->sent = p9fd_client_sent;
+	ts->rcvd = p9fd_client_rcvd;
 
-	if (rc)
-		*rc = r.rcall;
-	else
-		kfree(r.rcall);
+	return trans;
 
-	p9_mux_free_request(m, req);
-	if (err > 0)
-		err = -EIO;
+error:
+	if (csocket)
+		sock_release(csocket);
 
-	return err;
+	return ERR_PTR(err);
 }
-EXPORT_SYMBOL(p9_conn_rpc);
 
-#ifdef P9_NONBLOCK
-/**
- * p9_conn_rpcnb - sends 9P request without waiting for response.
- * @m: mux data
- * @tc: request to be sent
- * @cb: callback function to be called when response arrives
- * @cba: value to pass to the callback function
- */
-int p9_conn_rpcnb(struct p9_conn *m, struct p9_fcall *tc,
-		   p9_conn_req_callback cb, void *a)
+static struct p9_trans *p9fd_create_unix_client(const char *addr, char *args)
 {
 	int err;
-	struct p9_req *req;
+	struct socket *csocket;
+	struct sockaddr_un sun_server;
+	struct p9_trans *trans;
+	struct p9_trans_fd *ts;
+	struct p9_fd_opts opts;
+
+	csocket = NULL;
+	parse_opts(args, &opts);
+	if (strlen(addr) > UNIX_PATH_MAX) {
+		P9_EPRINTK(KERN_ERR, "p9_trans_unix: address too long: %s\n",
+			addr);
+		err = -ENAMETOOLONG;
+		goto error;
+	}
 
-	req = p9_send_request(m, tc, cb, a);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
-		P9_DPRINTK(P9_DEBUG_MUX, "error %d\n", err);
-		return PTR_ERR(req);
+	sun_server.sun_family = PF_UNIX;
+	strcpy(sun_server.sun_path, addr);
+	sock_create_kern(PF_UNIX, SOCK_STREAM, 0, &csocket);
+	err = csocket->ops->connect(csocket, (struct sockaddr *)&sun_server,
+			sizeof(struct sockaddr_un) - 1, 0);
+	if (err < 0) {
+		P9_EPRINTK(KERN_ERR,
+			"p9_trans_unix: problem connecting socket: %s: %d\n",
+			addr, err);
+		goto error;
 	}
 
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p tc %p tag %d\n", m, tc, req->tag);
-	return 0;
+	trans = p9fd_socket_open(csocket, opts.msize);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto error;
+	}
+
+	trans->request = p9fd_client_request;
+	trans->cancel = p9fd_client_cancel;
+	trans->destroy = p9fd_trans_destroy;
+	ts = trans->priv;
+	ts->sent = p9fd_client_sent;
+	ts->rcvd = p9fd_client_rcvd;
+
+	return trans;
+
+error:
+	if (csocket)
+		sock_release(csocket);
+
+	return ERR_PTR(err);
 }
-EXPORT_SYMBOL(p9_conn_rpcnb);
-#endif /* P9_NONBLOCK */
 
-/**
- * p9_conn_cancel - cancel all pending requests with error
- * @m: mux data
- * @err: error code
- */
-void p9_conn_cancel(struct p9_conn *m, int err)
+static struct p9_trans *p9fd_create_fd_client(const char *name, char *args)
 {
-	struct p9_req *req, *rtmp;
-	LIST_HEAD(cancel_list);
-
-	P9_DPRINTK(P9_DEBUG_ERROR, "mux %p err %d\n", m, err);
-	m->err = err;
-	spin_lock(&m->lock);
-	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
-		list_move(&req->req_list, &cancel_list);
-	}
-	list_for_each_entry_safe(req, rtmp, &m->unsent_req_list, req_list) {
-		list_move(&req->req_list, &cancel_list);
+	struct p9_fd_opts opts;
+	struct p9_trans *trans;
+	struct p9_trans_fd *ts;
+
+	parse_opts(args, &opts);
+	if (opts.rfd == ~0 || opts.wfd == ~0) {
+		printk(KERN_ERR "v9fs: Insufficient options for proto=fd\n");
+		return ERR_PTR(-ENOPROTOOPT);
 	}
-	spin_unlock(&m->lock);
 
-	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
-		list_del(&req->req_list);
-		if (!req->err)
-			req->err = err;
+	trans = p9fd_trans_create(opts.rfd, opts.wfd, opts.msize);
+	if (IS_ERR(trans))
+		return trans;
 
-		if (req->cb)
-			(*req->cb) (req, req->cba);
-		else
-			kfree(req->rcall);
-	}
+	trans->request = p9fd_client_request;
+	trans->cancel = p9fd_client_cancel;
+	trans->destroy = p9fd_trans_destroy;
+	ts = trans->priv;
+	ts->sent = p9fd_client_sent;
+	ts->rcvd = p9fd_client_rcvd;
 
-	wake_up(&m->equeue);
+	return trans;
 }
-EXPORT_SYMBOL(p9_conn_cancel);
 
-static u16 p9_mux_get_tag(struct p9_conn *m)
+static int __init p9_trans_fd_init(void)
 {
-	int tag;
+	int i;
 
-	tag = p9_idpool_get(m->tagpool);
-	if (tag < 0)
-		return P9_NOTAG;
-	else
-		return (u16) tag;
+	for (i = 0; i < ARRAY_SIZE(p9fd_poll_tasks); i++)
+		p9fd_poll_tasks[i].task = NULL;
+
+	p9fd_wq = create_workqueue("9pfd");
+	if (!p9fd_wq) {
+		printk(KERN_WARNING "v9fs: creating 9pfd workqueue failed\n");
+		return -ENOMEM;
+	}
+
+	v9fs_register_trans(&p9_tcp_trans);
+	v9fs_register_trans(&p9_unix_trans);
+	v9fs_register_trans(&p9_fd_trans);
+
+	return 0;
 }
 
-static void p9_mux_put_tag(struct p9_conn *m, u16 tag)
-{
-	if (tag != P9_NOTAG && p9_idpool_check(tag, m->tagpool))
-		p9_idpool_put(tag, m->tagpool);
+static void __exit p9_trans_fd_exit(void) {
+	destroy_workqueue(p9fd_wq);
+	printk(KERN_ERR "Removal of 9p transports not implemented\n");
+	BUG();
 }
+
+module_init(p9_trans_fd_init);
+module_exit(p9_trans_fd_exit);
+
+MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
+MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
+MODULE_LICENSE("GPL");
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
deleted file mode 100644
index 62332ed..0000000
--- a/net/9p/trans_fd.c
+++ /dev/null
@@ -1,473 +0,0 @@
-/*
- * linux/fs/9p/trans_fd.c
- *
- * Fd transport layer.  Includes deprecated socket layer.
- *
- *  Copyright (C) 2006 by Russ Cox <rsc@swtch.com>
- *  Copyright (C) 2004-2005 by Latchesar Ionkov <lucho@ionkov.net>
- *  Copyright (C) 2004-2007 by Eric Van Hensbergen <ericvh@gmail.com>
- *  Copyright (C) 1997-2002 by Ron Minnich <rminnich@sarnoff.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to:
- *  Free Software Foundation
- *  51 Franklin Street, Fifth Floor
- *  Boston, MA  02111-1301  USA
- *
- */
-
-#include <linux/in.h>
-#include <linux/module.h>
-#include <linux/net.h>
-#include <linux/ipv6.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/un.h>
-#include <linux/uaccess.h>
-#include <linux/inet.h>
-#include <linux/idr.h>
-#include <linux/file.h>
-#include <linux/parser.h>
-#include <net/9p/9p.h>
-#include <net/9p/transport.h>
-
-#define P9_PORT 564
-#define MAX_SOCK_BUF (64*1024)
-
-
-struct p9_fd_opts {
-	int rfd;
-	int wfd;
-	u16 port;
-};
-
-struct p9_trans_fd {
-	struct file *rd;
-	struct file *wr;
-};
-
-/*
-  * Option Parsing (code inspired by NFS code)
-  *  - a little lazy - parse all fd-transport options
-  */
-
-enum {
-	/* Options that take integer arguments */
-	Opt_port, Opt_rfdno, Opt_wfdno, Opt_err,
-};
-
-static match_table_t tokens = {
-	{Opt_port, "port=%u"},
-	{Opt_rfdno, "rfdno=%u"},
-	{Opt_wfdno, "wfdno=%u"},
-	{Opt_err, NULL},
-};
-
-/**
- * v9fs_parse_options - parse mount options into session structure
- * @options: options string passed from mount
- * @v9ses: existing v9fs session information
- *
- */
-
-static void parse_opts(char *options, struct p9_fd_opts *opts)
-{
-	char *p;
-	substring_t args[MAX_OPT_ARGS];
-	int option;
-	int ret;
-
-	opts->port = P9_PORT;
-	opts->rfd = ~0;
-	opts->wfd = ~0;
-
-	if (!options)
-		return;
-
-	while ((p = strsep(&options, ",")) != NULL) {
-		int token;
-		if (!*p)
-			continue;
-		token = match_token(p, tokens, args);
-		ret = match_int(&args[0], &option);
-		if (ret < 0) {
-			P9_DPRINTK(P9_DEBUG_ERROR,
-			 "integer field, but no integer?\n");
-			continue;
-		}
-		switch (token) {
-		case Opt_port:
-			opts->port = option;
-			break;
-		case Opt_rfdno:
-			opts->rfd = option;
-			break;
-		case Opt_wfdno:
-			opts->wfd = option;
-			break;
-		default:
-			continue;
-		}
-	}
-}
-
-static int p9_fd_open(struct p9_trans *trans, int rfd, int wfd)
-{
-	struct p9_trans_fd *ts = kmalloc(sizeof(struct p9_trans_fd),
-					   GFP_KERNEL);
-	if (!ts)
-		return -ENOMEM;
-
-	ts->rd = fget(rfd);
-	ts->wr = fget(wfd);
-	if (!ts->rd || !ts->wr) {
-		if (ts->rd)
-			fput(ts->rd);
-		if (ts->wr)
-			fput(ts->wr);
-		kfree(ts);
-		return -EIO;
-	}
-
-	trans->priv = ts;
-	trans->status = Connected;
-
-	return 0;
-}
-
-static int p9_socket_open(struct p9_trans *trans, struct socket *csocket)
-{
-	int fd, ret;
-
-	csocket->sk->sk_allocation = GFP_NOIO;
-	fd = sock_map_fd(csocket);
-	if (fd < 0) {
-		P9_EPRINTK(KERN_ERR, "p9_socket_open: failed to map fd\n");
-		return fd;
-	}
-
-	ret = p9_fd_open(trans, fd, fd);
-	if (ret < 0) {
-		P9_EPRINTK(KERN_ERR, "p9_socket_open: failed to open fd\n");
-		sockfd_put(csocket);
-		return ret;
-	}
-
-	((struct p9_trans_fd *)trans->priv)->rd->f_flags |= O_NONBLOCK;
-
-	return 0;
-}
-
-/**
- * p9_fd_read- read from a fd
- * @v9ses: session information
- * @v: buffer to receive data into
- * @len: size of receive buffer
- *
- */
-static int p9_fd_read(struct p9_trans *trans, void *v, int len)
-{
-	int ret;
-	struct p9_trans_fd *ts = NULL;
-
-	if (trans && trans->status != Disconnected)
-		ts = trans->priv;
-
-	if (!ts)
-		return -EREMOTEIO;
-
-	if (!(ts->rd->f_flags & O_NONBLOCK))
-		P9_DPRINTK(P9_DEBUG_ERROR, "blocking read ...\n");
-
-	ret = kernel_read(ts->rd, ts->rd->f_pos, v, len);
-	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
-		trans->status = Disconnected;
-	return ret;
-}
-
-/**
- * p9_fd_write - write to a socket
- * @v9ses: session information
- * @v: buffer to send data from
- * @len: size of send buffer
- *
- */
-static int p9_fd_write(struct p9_trans *trans, void *v, int len)
-{
-	int ret;
-	mm_segment_t oldfs;
-	struct p9_trans_fd *ts = NULL;
-
-	if (trans && trans->status != Disconnected)
-		ts = trans->priv;
-
-	if (!ts)
-		return -EREMOTEIO;
-
-	if (!(ts->wr->f_flags & O_NONBLOCK))
-		P9_DPRINTK(P9_DEBUG_ERROR, "blocking write ...\n");
-
-	oldfs = get_fs();
-	set_fs(get_ds());
-	/* The cast to a user pointer is valid due to the set_fs() */
-	ret = vfs_write(ts->wr, (void __user *)v, len, &ts->wr->f_pos);
-	set_fs(oldfs);
-
-	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
-		trans->status = Disconnected;
-	return ret;
-}
-
-static unsigned int
-p9_fd_poll(struct p9_trans *trans, struct poll_table_struct *pt)
-{
-	int ret, n;
-	struct p9_trans_fd *ts = NULL;
-	mm_segment_t oldfs;
-
-	if (trans && trans->status == Connected)
-		ts = trans->priv;
-
-	if (!ts)
-		return -EREMOTEIO;
-
-	if (!ts->rd->f_op || !ts->rd->f_op->poll)
-		return -EIO;
-
-	if (!ts->wr->f_op || !ts->wr->f_op->poll)
-		return -EIO;
-
-	oldfs = get_fs();
-	set_fs(get_ds());
-
-	ret = ts->rd->f_op->poll(ts->rd, pt);
-	if (ret < 0)
-		goto end;
-
-	if (ts->rd != ts->wr) {
-		n = ts->wr->f_op->poll(ts->wr, pt);
-		if (n < 0) {
-			ret = n;
-			goto end;
-		}
-		ret = (ret & ~POLLOUT) | (n & ~POLLIN);
-	}
-
-end:
-	set_fs(oldfs);
-	return ret;
-}
-
-/**
- * p9_sock_close - shutdown socket
- * @trans: private socket structure
- *
- */
-static void p9_fd_close(struct p9_trans *trans)
-{
-	struct p9_trans_fd *ts;
-
-	if (!trans)
-		return;
-
-	ts = xchg(&trans->priv, NULL);
-
-	if (!ts)
-		return;
-
-	trans->status = Disconnected;
-	if (ts->rd)
-		fput(ts->rd);
-	if (ts->wr)
-		fput(ts->wr);
-	kfree(ts);
-}
-
-static struct p9_trans *p9_trans_create_tcp(const char *addr, char *args)
-{
-	int err;
-	struct p9_trans *trans;
-	struct socket *csocket;
-	struct sockaddr_in sin_server;
-	struct p9_fd_opts opts;
-
-	parse_opts(args, &opts);
-
-	csocket = NULL;
-	trans = kmalloc(sizeof(struct p9_trans), GFP_KERNEL);
-	if (!trans)
-		return ERR_PTR(-ENOMEM);
-
-	trans->write = p9_fd_write;
-	trans->read = p9_fd_read;
-	trans->close = p9_fd_close;
-	trans->poll = p9_fd_poll;
-
-	sin_server.sin_family = AF_INET;
-	sin_server.sin_addr.s_addr = in_aton(addr);
-	sin_server.sin_port = htons(opts.port);
-	sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &csocket);
-
-	if (!csocket) {
-		P9_EPRINTK(KERN_ERR, "p9_trans_tcp: problem creating socket\n");
-		err = -EIO;
-		goto error;
-	}
-
-	err = csocket->ops->connect(csocket,
-				    (struct sockaddr *)&sin_server,
-				    sizeof(struct sockaddr_in), 0);
-	if (err < 0) {
-		P9_EPRINTK(KERN_ERR,
-			"p9_trans_tcp: problem connecting socket to %s\n",
-			addr);
-		goto error;
-	}
-
-	err = p9_socket_open(trans, csocket);
-	if (err < 0)
-		goto error;
-
-	return trans;
-
-error:
-	if (csocket)
-		sock_release(csocket);
-
-	kfree(trans);
-	return ERR_PTR(err);
-}
-
-static struct p9_trans *p9_trans_create_unix(const char *addr, char *args)
-{
-	int err;
-	struct socket *csocket;
-	struct sockaddr_un sun_server;
-	struct p9_trans *trans;
-
-	csocket = NULL;
-	trans = kmalloc(sizeof(struct p9_trans), GFP_KERNEL);
-	if (!trans)
-		return ERR_PTR(-ENOMEM);
-
-	trans->write = p9_fd_write;
-	trans->read = p9_fd_read;
-	trans->close = p9_fd_close;
-	trans->poll = p9_fd_poll;
-
-	if (strlen(addr) > UNIX_PATH_MAX) {
-		P9_EPRINTK(KERN_ERR, "p9_trans_unix: address too long: %s\n",
-			addr);
-		err = -ENAMETOOLONG;
-		goto error;
-	}
-
-	sun_server.sun_family = PF_UNIX;
-	strcpy(sun_server.sun_path, addr);
-	sock_create_kern(PF_UNIX, SOCK_STREAM, 0, &csocket);
-	err = csocket->ops->connect(csocket, (struct sockaddr *)&sun_server,
-			sizeof(struct sockaddr_un) - 1, 0);
-	if (err < 0) {
-		P9_EPRINTK(KERN_ERR,
-			"p9_trans_unix: problem connecting socket: %s: %d\n",
-			addr, err);
-		goto error;
-	}
-
-	err = p9_socket_open(trans, csocket);
-	if (err < 0)
-		goto error;
-
-	return trans;
-
-error:
-	if (csocket)
-		sock_release(csocket);
-
-	kfree(trans);
-	return ERR_PTR(err);
-}
-
-static struct p9_trans *p9_trans_create_fd(const char *name, char *args)
-{
-	int err;
-	struct p9_trans *trans;
-	struct p9_fd_opts opts;
-
-	parse_opts(args, &opts);
-
-	if (opts.rfd == ~0 || opts.wfd == ~0) {
-		printk(KERN_ERR "v9fs: Insufficient options for proto=fd\n");
-		return ERR_PTR(-ENOPROTOOPT);
-	}
-
-	trans = kmalloc(sizeof(struct p9_trans), GFP_KERNEL);
-	if (!trans)
-		return ERR_PTR(-ENOMEM);
-
-	trans->write = p9_fd_write;
-	trans->read = p9_fd_read;
-	trans->close = p9_fd_close;
-	trans->poll = p9_fd_poll;
-
-	err = p9_fd_open(trans, opts.rfd, opts.wfd);
-	if (err < 0)
-		goto error;
-
-	return trans;
-
-error:
-	kfree(trans);
-	return ERR_PTR(err);
-}
-
-static struct p9_trans_module p9_tcp_trans = {
-	.name = "tcp",
-	.maxsize = MAX_SOCK_BUF,
-	.def = 1,
-	.create = p9_trans_create_tcp,
-};
-
-static struct p9_trans_module p9_unix_trans = {
-	.name = "unix",
-	.maxsize = MAX_SOCK_BUF,
-	.def = 0,
-	.create = p9_trans_create_unix,
-};
-
-static struct p9_trans_module p9_fd_trans = {
-	.name = "fd",
-	.maxsize = MAX_SOCK_BUF,
-	.def = 0,
-	.create = p9_trans_create_fd,
-};
-
-static int __init p9_trans_fd_init(void)
-{
-	v9fs_register_trans(&p9_tcp_trans);
-	v9fs_register_trans(&p9_unix_trans);
-	v9fs_register_trans(&p9_fd_trans);
-
-	return 1;
-}
-
-static void __exit p9_trans_fd_exit(void) {
-	printk(KERN_ERR "Removal of 9p transports not implemented\n");
-	BUG();
-}
-
-module_init(p9_trans_fd_init);
-module_exit(p9_trans_fd_exit);
-
-MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
-MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
-MODULE_LICENSE("GPL");
