Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbXI3XHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbXI3XHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbXI3XFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:05:38 -0400
Received: from 70-56-134-241.albq.qwest.net ([70.56.134.241]:57199 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753103AbXI3XFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:05:15 -0400
Date: Sun, 30 Sep 2007 16:40:33 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ericvh@gmail.com
Subject: [RFC][PATCH 3/6] 9p: 9P server connection code
Message-ID: <20070930224033.GC25590@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides support for in-kernel 9P2000 servers.

This patch add the 9P server connection code.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
---
 net/9p/srv/conn.c |  743 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 743 insertions(+), 0 deletions(-)
 create mode 100644 net/9p/srv/conn.c

diff --git a/net/9p/srv/conn.c b/net/9p/srv/conn.c
new file mode 100644
index 0000000..335ee17
--- /dev/null
+++ b/net/9p/srv/conn.c
@@ -0,0 +1,743 @@
+/*
+ * net/9p/srv/conn.c
+ *
+ * Server connection
+ *
+ *  Copyright (C) 2007 by Latchesar Ionkov <lucho@ionkov.net>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/kthread.h>
+#include <linux/parser.h>
+#include <net/9p/9p.h>
+#include <net/9p/transport.h>
+#include <net/9p/srv.h>
+#include "srvimpl.h"
+
+#define SCHED_TIMEOUT	10
+
+struct p9srv_poll_task {
+	struct task_struct *task;
+	struct list_head conn_list;
+	int connum;
+};
+
+static DEFINE_MUTEX(p9srv_task_lock);
+struct workqueue_struct *p9srv_wq;
+
+static int p9srv_num;
+static int p9srv_poll_task_num;
+static struct p9srv_poll_task p9srv_poll_tasks[100];
+
+static int p9srv_calc_poll_procs(int);
+static int p9srv_poll_start(struct p9srv_conn *c);
+static void p9srv_poll_stop(struct p9srv_conn *c);
+static void p9srv_pollwait(struct file *, wait_queue_head_t *, poll_table *);
+static void p9srv_poll_conn(struct p9srv_conn *c);
+static int p9srv_poll_proc(void *a);
+static void p9srv_read_work(struct work_struct *work);
+static void p9srv_write_work(struct work_struct *work);
+
+int p9srv_conn_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(p9srv_poll_tasks); i++)
+		p9srv_poll_tasks[i].task = NULL;
+
+	p9srv_wq = create_workqueue("9psrv");
+	if (!p9srv_wq) {
+		printk(KERN_WARNING "9psrv: creating workqueue failed\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void p9srv_conn_exit(void)
+{
+	destroy_workqueue(p9srv_wq);
+	p9srv_wq = NULL;
+}
+
+struct p9srv_conn *p9srv_conn_create(struct p9srv *srv,
+	struct p9_trans *trans)
+{
+	int i, n, err;
+	struct p9srv_conn *conn;
+
+	conn = kmalloc(sizeof(struct p9srv_conn), GFP_KERNEL);
+	if (!conn)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&conn->lock);
+	conn->srv = srv;
+	conn->trans = trans;
+	conn->msize = srv->msize;
+	conn->dotu = srv->dotu;
+	conn->status = 0;
+	INIT_WORK(&conn->rq, p9srv_read_work);
+	INIT_WORK(&conn->wq, p9srv_write_work);
+	INIT_LIST_HEAD(&conn->conn_list);
+	INIT_LIST_HEAD(&conn->vpt_conn_list);
+	INIT_LIST_HEAD(&conn->oreq_list);
+	conn->opos = 0;
+	conn->osize = 0;
+	conn->obuf = NULL;
+	conn->icall = NULL;
+	conn->ipos = 0;
+	conn->ibuf = 0;
+	conn->poll_task = NULL;
+	memset(&conn->poll_wait, 0, sizeof(conn->poll_wait));
+	memset(&conn->poll_waddr, 0, sizeof(conn->poll_waddr));
+	conn->fidpool = p9srv_fidpool_create();
+	if (!conn->fidpool) {
+		err = PTR_ERR(conn->fidpool);
+		kfree(conn);
+		return ERR_PTR(err);
+	}
+
+	err = p9srv_poll_start(conn);
+	if (err) {
+		p9srv_fidpool_destroy(conn->fidpool);
+		kfree(conn);
+		return ERR_PTR(err);
+	}
+
+	n = trans->poll(trans, &conn->pt);
+	if (n & POLLIN)
+		set_bit(Rpending, &conn->status);
+
+	if (n & POLLOUT)
+		set_bit(Wpending, &conn->status);
+
+	for (i = 0; i < ARRAY_SIZE(conn->poll_waddr); i++) {
+		if (IS_ERR(conn->poll_waddr[i])) {
+			p9srv_poll_stop(conn);
+			err = PTR_ERR(conn->poll_waddr[i]);
+			p9srv_fidpool_destroy(conn->fidpool);
+			kfree(conn);
+			return ERR_PTR(err);
+		}
+	}
+
+	spin_lock(&srv->lock);
+	list_add_tail(&conn->conn_list, &srv->conn_list);
+	spin_unlock(&srv->lock);
+
+	if (test_bit(Rpending, &conn->status) &&
+				!test_and_set_bit(Rworksched, &conn->status))
+		queue_work(p9srv_wq, &conn->rq);
+
+	if (srv->connopen)
+		(*srv->connopen)(conn);
+
+	p9srv_srv_ref(conn->srv);
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p\n", conn);
+	return conn;
+}
+EXPORT_SYMBOL(p9srv_conn_create);
+
+void p9srv_conn_destroy(struct p9srv_conn *conn)
+{
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "start conn %p\n", conn);
+	if (!test_and_set_bit(Destroy, &conn->status))
+		p9srv_conn_reset(conn, NULL);
+
+	if (test_bit(Wworksched, &conn->status) ||
+		test_bit(Rworksched, &conn->status))
+		return;
+
+	p9srv_poll_stop(conn);
+	conn->trans = NULL;
+	list_del(&conn->conn_list);
+	if (conn->srv->connclose)
+		(*conn->srv->connclose)(conn);
+
+	p9srv_srv_unref(conn->srv);
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "end conn %p\n", conn);
+	kfree(conn);
+}
+EXPORT_SYMBOL(p9srv_conn_destroy);
+
+void p9srv_conn_reset(struct p9srv_conn *conn, struct p9srv_req *vreq)
+{
+	int i, n;
+	struct p9srv *srv;
+	struct p9srv_req *req, *rptr;
+	struct p9srv_req *wreqs[16];
+	struct p9_str *version;
+	LIST_HEAD(req_list);
+
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p\n", conn);
+	srv = conn->srv;
+	if (test_and_set_bit(Reset, &conn->status))
+		return;
+
+	atomic_set(&conn->reset_wcount, 0);
+	spin_lock(&srv->lock);
+	/* remove all requests the server didn't work on yet */
+	list_for_each_entry_safe(req, rptr, &srv->req_list, req_list) {
+		if (req->conn == conn)
+			list_move(&req->req_list, &req_list);
+	}
+
+again:
+	/* flush the work requests (ARRAY_SIZE(wreqs) at a time) */
+	n = 0;
+	list_for_each_entry(req, &srv->workreq_list, req_list) {
+		if (req->conn == conn && req != vreq &&
+			!test_and_set_bit(Flush, &req->status)) {
+
+			wreqs[n++] = req;
+			p9srv_req_ref(req);
+			if (n >= ARRAY_SIZE(wreqs))
+				break;
+		}
+	}
+	spin_unlock(&srv->lock);
+
+	atomic_add(n, &conn->reset_wcount);
+	for (i = 0; i < n; i++) {
+		if (srv->flush)
+			if ((*srv->flush)(wreqs[i]))
+				p9srv_respond(wreqs[i], NULL);
+
+		p9srv_req_unref(req);
+	}
+
+	if (n >= ARRAY_SIZE(wreqs)) {
+		spin_lock(&srv->lock);
+		goto again;
+	}
+
+	list_for_each_entry_safe(req, rptr, &req_list, req_list) {
+		list_del(&req_list);
+		p9srv_req_unref(req);
+	}
+
+	/* wait for all workreqs to finish */
+	wait_event_interruptible(conn->reset_wqueue,
+		!atomic_read(&conn->reset_wcount));
+	BUG_ON(!list_empty(&conn->oreq_list));
+	p9srv_fidpool_reset(conn->fidpool);
+	kfree(conn->icall);
+	conn->icall = NULL;
+	conn->ipos = 0;
+	conn->ibuf = NULL;
+	conn->obuf = NULL;
+	conn->opos = 0;
+	conn->osize = 0;
+	if (vreq) {
+		conn->msize = vreq->tcall->params.tversion.msize;
+		if (srv->msize < conn->msize)
+			conn->msize = srv->msize;
+
+		conn->dotu = srv->dotu;
+		version = &vreq->tcall->params.tversion.version;
+		if (version->len != 8 || memcmp(version->str, "9P2000.u", 8))
+			conn->dotu = 0;
+	}
+
+	clear_bit(Reset, &conn->status);
+}
+
+void p9srv_conn_try_send(struct p9srv_conn *conn)
+{
+	int n;
+	struct p9srv_req *req, *rptr;
+	LIST_HEAD(req_list);
+
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p\n", conn);
+	if (test_bit(Reset, &conn->status)) {
+		P9_DPRINTK(P9SRV_DEBUG_CONN, "resetting conn %p\n", conn);
+		n = 0;
+		spin_lock(&conn->lock);
+		list_for_each_entry_safe(req, rptr, &conn->oreq_list,
+								req_list) {
+			list_move(&req_list, &req->req_list);
+			n++;
+		}
+		spin_unlock(&conn->lock);
+
+		list_for_each_entry_safe(req, rptr, &req_list, req_list) {
+			list_del(&req->req_list);
+			p9srv_req_unref(req);
+			n++;
+		}
+
+		if (!atomic_sub_and_test(n, &conn->reset_wcount))
+			wake_up(&conn->reset_wqueue);
+
+		return;
+	}
+
+	if (test_and_clear_bit(Wpending, &conn->status))
+		n = POLLOUT;
+	else
+		n = conn->trans->poll(conn->trans, NULL);
+
+	if (n&POLLOUT && !test_and_set_bit(Wworksched, &conn->status)) {
+		P9_DPRINTK(P9SRV_DEBUG_CONN, "queue write work %p\n", conn);
+		queue_work(p9srv_wq, &conn->wq);
+	}
+}
+
+/**
+ * p9srv_calc_poll_procs - calculates the number of polling procs
+ * based on the number of 9p server connections.
+ *
+ * The current implementation returns sqrt of the number of mounts.
+ */
+static int p9srv_calc_poll_procs(int muxnum)
+{
+	int n;
+
+	if (p9srv_poll_task_num)
+		n = muxnum / p9srv_poll_task_num +
+		    (muxnum % p9srv_poll_task_num ? 1 : 0);
+	else
+		n = 1;
+
+	if (n > ARRAY_SIZE(p9srv_poll_tasks))
+		n = ARRAY_SIZE(p9srv_poll_tasks);
+
+	return n;
+}
+
+static int p9srv_poll_start(struct p9srv_conn *c)
+{
+	int i, n;
+	struct p9srv_poll_task *vpt, *vptlast;
+	struct task_struct *pp;
+
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p connum %d procnum %d\n", c,
+		p9srv_num, p9srv_poll_task_num);
+
+	mutex_lock(&p9srv_task_lock);
+	n = p9srv_calc_poll_procs(p9srv_num + 1);
+	if (n > p9srv_poll_task_num) {
+		for (i = 0; i < ARRAY_SIZE(p9srv_poll_tasks); i++)
+			if (p9srv_poll_tasks[i].task == NULL)
+				break;
+
+		if (i < ARRAY_SIZE(p9srv_poll_tasks)) {
+			vpt = &p9srv_poll_tasks[i];
+			P9_DPRINTK(P9SRV_DEBUG_CONN, "create proc %p\n", vpt);
+			pp = kthread_create(p9srv_poll_proc, vpt, "p9srv-poll");
+
+			if (!IS_ERR(pp)) {
+				vpt->task = pp;
+				INIT_LIST_HEAD(&vpt->conn_list);
+				vpt->connum = 0;
+				p9srv_poll_task_num++;
+				wake_up_process(vpt->task);
+			}
+		} else
+			P9_DPRINTK(P9_DEBUG_ERROR,
+					"warning: no free poll slots\n");
+	}
+
+	n = (p9srv_num + 1) / p9srv_poll_task_num +
+	    ((p9srv_num + 1) % p9srv_poll_task_num ? 1 : 0);
+
+	vptlast = NULL;
+	for (i = 0; i < ARRAY_SIZE(p9srv_poll_tasks); i++) {
+		vpt = &p9srv_poll_tasks[i];
+		if (vpt->task != NULL) {
+			vptlast = vpt;
+			if (vpt->connum < n)
+				break;
+		}
+	}
+
+	if (vptlast == NULL)
+		return -ENOMEM;
+
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "put conn %p in proc %d\n", c, i);
+	list_add(&c->vpt_conn_list, &vptlast->conn_list);
+	vptlast->connum++;
+	c->poll_task = vptlast;
+	memset(&c->poll_waddr, 0, sizeof(c->poll_waddr));
+	init_poll_funcptr(&c->pt, p9srv_pollwait);
+	p9srv_num++;
+	mutex_unlock(&p9srv_task_lock);
+
+	return 0;
+}
+
+static void p9srv_poll_stop(struct p9srv_conn *c)
+{
+	int i;
+	struct p9srv_poll_task *vpt;
+
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p\n", c);
+	mutex_lock(&p9srv_task_lock);
+	vpt = c->poll_task;
+	list_del(&c->vpt_conn_list);
+	for (i = 0; i < ARRAY_SIZE(c->poll_waddr); i++) {
+		if (c->poll_waddr[i] != NULL) {
+			remove_wait_queue(c->poll_waddr[i], &c->poll_wait[i]);
+			c->poll_waddr[i] = NULL;
+		}
+	}
+	vpt->connum--;
+	if (!vpt->connum) {
+		P9_DPRINTK(P9SRV_DEBUG_CONN, "destroy proc %p\n", vpt);
+		kthread_stop(vpt->task);
+		vpt->task = NULL;
+		p9srv_poll_task_num--;
+	}
+	p9srv_num--;
+	mutex_unlock(&p9srv_task_lock);
+}
+
+/**
+ * p9srv_pollwait - called by files poll operation to add v9fs-poll task
+ * 	to files wait queue
+ */
+static void p9srv_pollwait(struct file *filp, wait_queue_head_t *wait_address,
+	      poll_table * p)
+{
+	int i;
+	struct p9srv_conn *c;
+
+	c = container_of(p, struct p9srv_conn, pt);
+	for (i = 0; i < ARRAY_SIZE(c->poll_waddr); i++)
+		if (c->poll_waddr[i] == NULL)
+			break;
+
+	if (i >= ARRAY_SIZE(c->poll_waddr)) {
+		P9_DPRINTK(P9_DEBUG_ERROR, "not enough wait_address slots\n");
+		return;
+	}
+
+	c->poll_waddr[i] = wait_address;
+
+	if (!wait_address) {
+		P9_DPRINTK(P9_DEBUG_ERROR, "no wait_address\n");
+		c->poll_waddr[i] = ERR_PTR(-EIO);
+		return;
+	}
+
+	init_waitqueue_entry(&c->poll_wait[i], c->poll_task->task);
+	add_wait_queue(wait_address, &c->poll_wait[i]);
+}
+
+/**
+ * p9srv_poll_conn - polls a mux and schedules read or write works if necessary
+ */
+static void p9srv_poll_conn(struct p9srv_conn *c)
+{
+	int n;
+
+	if (test_bit(Destroy, &c->status))
+		return;
+
+	n = c->trans->poll(c->trans, NULL);
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p poll %d\n", c, n);
+	if (n < 0 || n & (POLLERR | POLLHUP | POLLNVAL)) {
+		P9_DPRINTK(P9SRV_DEBUG_CONN, "error conn %p err %d\n", c, n);
+		if (n >= 0)
+			n = -ECONNRESET;
+		p9srv_conn_destroy(c);
+		return;
+	}
+
+	if (n & POLLIN) {
+		set_bit(Rpending, &c->status);
+		P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p can read\n", c);
+		if (!test_and_set_bit(Rworksched, &c->status)) {
+			P9_DPRINTK(P9SRV_DEBUG_CONN, "queue read work %p\n", c);
+			queue_work(p9srv_wq, &c->rq);
+		}
+	}
+
+	if (n & POLLOUT) {
+		set_bit(Wpending, &c->status);
+		P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p can write\n", c);
+		if ((c->osize || !list_empty(&c->oreq_list))
+		    && !test_and_set_bit(Wworksched, &c->status)) {
+			P9_DPRINTK(P9SRV_DEBUG_CONN,
+				"queue write work %p\n", c);
+			queue_work(p9srv_wq, &c->wq);
+		}
+	}
+}
+
+/**
+ * p9_poll_proc - polls all v9fs transports for new events and queues
+ * 	the appropriate work to the work queue
+ */
+static int p9srv_poll_proc(void *a)
+{
+	struct p9srv_conn *c, *ctmp;
+	struct p9srv_poll_task *vpt;
+
+	vpt = a;
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "start %p %p\n", current, vpt);
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		list_for_each_entry_safe(c, ctmp, &vpt->conn_list,
+							vpt_conn_list) {
+			p9srv_poll_conn(c);
+		}
+
+		P9_DPRINTK(P9SRV_DEBUG_CONN, "sleeping...\n");
+		schedule_timeout(SCHED_TIMEOUT * HZ);
+	}
+
+	__set_current_state(TASK_RUNNING);
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "finish\n");
+	return 0;
+}
+
+/**
+ * p9_read_work - called when there is some data to be read from a transport
+ */
+static void p9srv_read_work(struct work_struct *work)
+{
+	int n, err;
+	struct p9srv_conn *conn;
+	struct p9srv_req *req;
+	struct p9_fcall *rcall;
+	char *rbuf;
+
+	conn = container_of(work, struct p9srv_conn, rq);
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p\n", conn);
+	if (test_bit(Destroy, &conn->status)) {
+		clear_bit(Rworksched, &conn->status);
+		p9srv_conn_destroy(conn);
+		return;
+	}
+
+	rcall = NULL;
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "start conn %p\n", conn);
+	if (!conn->icall) {
+		conn->icall = kmalloc(sizeof(struct p9_fcall) + conn->msize,
+			GFP_KERNEL);
+		if (!conn->icall) {
+			err = -ENOMEM;
+			goto error;
+		}
+
+		conn->icall->sdata = (char *) conn->icall +
+			sizeof(struct p9_fcall);
+		conn->ibuf = conn->icall->sdata;
+		conn->ipos = 0;
+	}
+
+	clear_bit(Rpending, &conn->status);
+	err = conn->trans->read(conn->trans, conn->ibuf + conn->ipos,
+		conn->msize - conn->ipos);
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p got %d bytes\n", conn, err);
+	if (err == -EAGAIN) {
+		clear_bit(Rworksched, &conn->status);
+		return;
+	}
+
+	if (err <= 0)
+		goto error;
+
+	conn->ipos += err;
+	while (conn->ipos > 4) {
+		n = le32_to_cpu(*(__le32 *) conn->ibuf);
+		if (n >= conn->msize) {
+			P9_DPRINTK(P9_DEBUG_ERROR,
+				"requested packet size too big: %d\n", n);
+			err = -EIO;
+			goto error;
+		}
+
+		if (conn->ipos < n)
+			break;
+
+		err = p9_deserialize_fcall(conn->ibuf, n, conn->icall,
+			conn->dotu);
+		if (err < 0)
+			goto error;
+
+#ifdef CONFIG_NET_9P_DEBUG
+		if (conn->srv->debuglevel > 0) {
+			char buf[150];
+
+			p9_printfcall(buf, sizeof(buf), conn->icall,
+				conn->dotu);
+			printk(KERN_NOTICE ">]> %s\n", buf);
+		}
+#endif
+
+		rcall = conn->icall;
+		rbuf = conn->ibuf;
+		if (conn->ipos > n) {
+			conn->icall = kmalloc(sizeof(struct p9_fcall) +
+				conn->msize, GFP_KERNEL);
+			if (!conn->icall) {
+				err = -ENOMEM;
+				goto error;
+			}
+
+			conn->icall->sdata = (char *) conn->icall +
+				sizeof(struct p9_fcall);
+			conn->ibuf = conn->icall->sdata;
+			memmove(conn->ibuf, rbuf + n, conn->ipos - n);
+			conn->ipos -= n;
+		} else {
+			conn->icall = NULL;
+			conn->ibuf = NULL;
+			conn->ipos = 0;
+		}
+
+		P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p fcall id %d tag %d\n",
+			conn, rcall->id, rcall->tag);
+
+		req = p9srv_req_create();
+		if (!req) {
+			err = -ENOMEM;
+			goto error;
+		}
+
+		req->conn = conn;
+		req->tcall = rcall;
+		req->tag = rcall->tag;
+		spin_lock(&conn->srv->lock);
+		list_add_tail(&req->req_list, &conn->srv->req_list);
+		spin_unlock(&conn->srv->lock);
+		if (!test_and_set_bit(Worksched, &conn->srv->status)) {
+			P9_DPRINTK(P9SRV_DEBUG_CONN, "queue req work\n");
+			queue_work(p9srv_wq, &conn->srv->pq);
+		}
+	}
+
+	if (test_and_clear_bit(Rpending, &conn->status))
+		n = POLLIN;
+	else
+		n = conn->trans->poll(conn->trans, NULL);
+
+	if (n & POLLIN) {
+		P9_DPRINTK(P9SRV_DEBUG_CONN, "schedule read work %p\n", conn);
+		queue_work(p9srv_wq, &conn->rq);
+	} else
+		clear_bit(Rworksched, &conn->status);
+
+	return;
+
+error:
+	clear_bit(Rworksched, &conn->status);
+	p9srv_conn_destroy(conn);
+}
+
+/**
+ * p9_write_work - called when a transport can send some data
+ */
+static void p9srv_write_work(struct work_struct *work)
+{
+	int n, err;
+	struct p9srv_conn *conn;
+	struct p9srv_req *req;
+
+	conn = container_of(work, struct p9srv_conn, wq);
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p\n", conn);
+	if (test_bit(Destroy, &conn->status)) {
+		clear_bit(Wworksched, &conn->status);
+		p9srv_conn_destroy(conn);
+		return;
+	}
+
+	if (!conn->osize) {
+		if (list_empty(&conn->oreq_list)) {
+			clear_bit(Wworksched, &conn->status);
+			return;
+		}
+
+		spin_lock(&conn->lock);
+		req = list_entry(conn->oreq_list.next, struct p9srv_req,
+			       req_list);
+
+		P9_DPRINTK(P9SRV_DEBUG_CONN, "next req %p tag %d size %d\n",
+			req, req->tag, req->rcall->size);
+		conn->obuf = req->rcall->sdata;
+		conn->osize = req->rcall->size;
+		conn->opos = 0;
+		spin_unlock(&conn->lock);
+
+#ifdef CONFIG_NET_9P_DEBUG
+		if (conn->srv->debuglevel > 0) {
+			char buf[150];
+
+			p9_printfcall(buf, sizeof(buf), req->rcall, conn->dotu);
+			printk(KERN_NOTICE "<[< %s\n", buf);
+		}
+#endif
+	}
+
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p pos %d size %d\n", conn,
+		conn->opos, conn->osize);
+	clear_bit(Wpending, &conn->status);
+	err = conn->trans->write(conn->trans, conn->obuf + conn->opos,
+		conn->osize - conn->opos);
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "conn %p sent %d bytes\n", conn, err);
+	if (err == -EAGAIN) {
+		clear_bit(Wworksched, &conn->status);
+		return;
+	}
+
+	if (err < 0)
+		goto error;
+	else if (err == 0) {
+		err = -EREMOTEIO;
+		goto error;
+	}
+
+	conn->opos += err;
+	if (conn->opos == conn->osize) {
+		conn->opos = 0;
+		conn->osize = 0;
+		spin_lock(&conn->lock);
+		req = list_first_entry(&conn->oreq_list, struct p9srv_req,
+			req_list);
+		list_del(&req->req_list);
+		spin_unlock(&conn->lock);
+		p9srv_req_unref(req);
+
+		if (!list_empty(&conn->oreq_list)) {
+			if (test_and_clear_bit(Wpending, &conn->status))
+				n = POLLOUT;
+			else
+				n = conn->trans->poll(conn->trans, NULL);
+
+			if (n & POLLOUT) {
+				P9_DPRINTK(P9SRV_DEBUG_CONN,
+					"schedule write work %p\n", conn);
+				queue_work(p9srv_wq, &conn->wq);
+			} else
+				clear_bit(Wworksched, &conn->status);
+		} else
+			clear_bit(Wworksched, &conn->status);
+	}
+
+	return;
+
+error:
+	p9srv_conn_destroy(conn);
+}
-- 
1.5.2.4

