Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbXI3XGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbXI3XGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbXI3XFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:05:30 -0400
Received: from 70-56-134-241.albq.qwest.net ([70.56.134.241]:57196 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752871AbXI3XFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:05:13 -0400
Date: Sun, 30 Sep 2007 16:39:33 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ericvh@gmail.com
Subject: [RFC][PATCH 2/6] 9p: 9P server interface and common srv code
Message-ID: <20070930223933.GB25590@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides support for in-kernel 9P2000 servers.

This patch adds the header file that defines the 9P server interface as well
as the code for the common support functions for the server.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
---
 include/net/9p/srv.h |  208 ++++++++++++
 net/9p/srv/srv.c     |  891 ++++++++++++++++++++++++++++++++++++++++++++++++++
 net/9p/srv/srvimpl.h |   46 +++
 3 files changed, 1145 insertions(+), 0 deletions(-)
 create mode 100644 include/net/9p/srv.h
 create mode 100644 net/9p/srv/srv.c
 create mode 100644 net/9p/srv/srvimpl.h

diff --git a/include/net/9p/srv.h b/include/net/9p/srv.h
new file mode 100644
index 0000000..36635c6
--- /dev/null
+++ b/include/net/9p/srv.h
@@ -0,0 +1,208 @@
+/*
+ * include/net/9p/srv.h
+ *
+ * 9P server definitions.
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
+#ifndef NET_9PSRV_H
+#define NET_9PSRV_H
+
+#define P9SRV_DEBUG_SRV		(1<<16)
+#define P9SRV_DEBUG_CONN	(1<<17)
+#define P9SRV_DEBUG_FID		(1<<18)
+#define P9SRV_DEBUG_REQ		(1<<19)
+#define P9SRV_DEBUG_FCALL	(1<<20)
+#define P9SRV_DEBUG_FS		(1<<21)
+
+#define MAXPOLLWADDR	2
+
+struct p9srv;
+struct p9srv_fid;
+struct p9srv_fidpool;
+struct p9srv_conn;
+struct p9srv_req;
+
+struct p9srv {
+	int			msize;
+	int			dotu;		/* 9P2000.u */
+	void			*srvaux;
+	void			*treeaux;
+	int			debuglevel;
+	void			(*start)(struct p9srv *);
+	void			(*stop)(struct p9srv *);
+	void			(*destroy)(struct p9srv *);
+	void			(*connopen)(struct p9srv_conn *);
+	void			(*connclose)(struct p9srv_conn *);
+	void			(*fiddestroy)(struct p9srv_fid *);
+	void			(*reqdestroy)(struct p9srv_req *);
+
+	/* 9P message handlers */
+	void			(*attach)(struct p9srv_req *);
+	void			(*auth)(struct p9srv_req *);
+	int			(*flush)(struct p9srv_req *);
+	void			(*walk)(struct p9srv_req *);
+	void			(*open)(struct p9srv_req *);
+	void			(*create)(struct p9srv_req *);
+	void			(*read)(struct p9srv_req *);
+	void			(*write)(struct p9srv_req *);
+	void			(*clunk)(struct p9srv_req *);
+	void			(*remove)(struct p9srv_req *);
+	void			(*stat)(struct p9srv_req *);
+	void			(*wstat)(struct p9srv_req *);
+
+	/* implementation specific */
+	atomic_t		refcount;
+	spinlock_t		lock;		/* covers all srv fields */
+	unsigned long		status;
+	struct list_head	conn_list;	/* all connections for srv */
+	struct list_head	req_list;	/* requests not yet worked on */
+	struct list_head	workreq_list;	/* requests being worked on */
+	struct work_struct	pq;		/* process request */
+};
+
+enum {
+	/* connection status values */
+	Worksched = 1,		/* work scheduled or running */
+};
+
+struct p9srv_conn {
+	struct p9srv		*srv;
+	struct p9_trans		*trans;
+	int			msize;
+	int			dotu;	/* 9P2000.u */
+
+	/* implementation specific */
+	spinlock_t		lock;		/* covers all conn fields */
+	unsigned long		status;
+	struct p9srv_fidpool	*fidpool;
+	struct work_struct	rq;
+	struct work_struct	wq;
+	struct list_head	conn_list;	/* all srv connections */
+	struct list_head	vpt_conn_list;	/* all connections for vpt */
+
+	/* outgoing data */
+	struct list_head	oreq_list;
+	char			*obuf;		/* outgoing data */
+	int			opos;		/* next byte in obuf */
+	int			osize;		/* obuf size */
+
+	/* incoming data */
+	struct p9_fcall		*icall;
+	int			ipos;		/*next byte in ibuf */
+	char			*ibuf;		/* icall->pkt */
+
+	/* connection & polling threads management */
+	struct p9srv_poll_task	*poll_task;
+	wait_queue_t		poll_wait[MAXPOLLWADDR];
+	wait_queue_head_t	*poll_waddr[MAXPOLLWADDR];
+	poll_table		pt;
+
+	/* connection reset */
+	atomic_t		reset_wcount;
+	wait_queue_head_t	reset_wqueue;
+};
+
+enum {
+	/* connection status values */
+	Rworksched = 1,		/* read work scheduled or running */
+	Rpending = 2,		/* can read */
+	Wworksched = 3,		/* write work scheduled or running */
+	Wpending = 4,		/* can write */
+	Reset = 5,		/* resetting */
+	Destroy = 6,		/* destroying */
+};
+
+struct p9srv_fid {
+	u32			fid;
+	atomic_t		refcount;
+	struct p9srv_conn	*conn;
+	void			*aux;
+	u16			omode;
+	u8			type;
+	u32			diroffset;
+	u32			uid;
+
+	/* implementation specific */
+	struct p9srv_fidpool	*fidpool;
+	struct hlist_node	fid_list;
+};
+
+#define FID_HTABLE_BITS		5
+#define FID_HTABLE_SIZE		(1 << FID_HTABLE_BITS)
+
+struct p9srv_req {
+	int			tag;
+	void			*aux;
+	struct p9_fcall		*tcall;
+	struct p9_fcall		*rcall;
+	struct p9srv_fid	*fid;
+	struct p9srv_fid	*afid;		/* Tauth, Tattach */
+	struct p9srv_fid	*newfid;	/* Twalk */
+
+	/* implementation specific */
+	long			status;
+	atomic_t		refcount;
+	struct p9srv_conn	*conn;
+	struct list_head	flush_req_list;
+	struct list_head	req_list;
+};
+
+enum {
+	/* p9srv_req status */
+	Respond = 1,
+	Flush,
+};
+
+extern char *Eunknownfid;
+extern char *Enomem;
+extern char *Enoauth;
+extern char *Enotimpl;
+extern char *Einuse;
+extern char *Ebadusefid;
+extern char *Enotdir;
+extern char *Etoomanywnames;
+extern char *Eperm;
+extern char *Etoolarge;
+extern char *Ebadoffset;
+extern char *Edirchange;
+extern char *Enotfound;
+extern char *Eopen;
+extern char *Eexist;
+extern char *Enotempty;
+
+
+struct p9srv *p9srv_srv_create(void);
+void p9srv_srv_stop(struct p9srv *srv);
+void p9srv_srv_destroy(struct p9srv *srv);
+void p9srv_srv_start(struct p9srv *srv);
+void p9srv_respond(struct p9srv_req *req, struct p9_fcall *rc);
+void p9srv_respond_error(struct p9srv_req *req, char *ename, int ecode);
+struct p9srv_req *p9srv_req_create(void);
+void p9srv_req_ref(struct p9srv_req *req);
+void p9srv_req_unref(struct p9srv_req *req);
+struct p9srv_conn *p9srv_conn_create(struct p9srv *srv, struct p9_trans *trans);
+void p9srv_conn_destroy(struct p9srv_conn *conn);
+struct p9srv_fid *p9srv_fid_find(struct p9srv_fidpool *fp, u32 fid);
+void p9srv_fid_incref(struct p9srv_fid *fid);
+void p9srv_fid_decref(struct p9srv_fid *fid);
+
+struct p9srv *p9srv_socksrv_create(int port);
+#endif
diff --git a/net/9p/srv/srv.c b/net/9p/srv/srv.c
new file mode 100644
index 0000000..651024b
--- /dev/null
+++ b/net/9p/srv/srv.c
@@ -0,0 +1,891 @@
+/*
+ * net/9p/srv/srv.c
+ *
+ * 9P Server
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
+#include <linux/parser.h>
+#include <net/9p/9p.h>
+#include <net/9p/transport.h>
+#include <net/9p/srv.h>
+#include "srvimpl.h"
+
+char *Eunknownfid = "unknown fid";
+EXPORT_SYMBOL(Eunknownfid);
+char *Enomem = "no memory";
+EXPORT_SYMBOL(Enomem);
+char *Enoauth = "no authentication required";
+EXPORT_SYMBOL(Enoauth);
+char *Enotimpl = "not implemented";
+EXPORT_SYMBOL(Enotimpl);
+char *Einuse = "fid already exists";
+EXPORT_SYMBOL(Einuse);
+char *Ebadusefid = "bad use of fid";
+EXPORT_SYMBOL(Ebadusefid);
+char *Enotdir = "not a directory";
+EXPORT_SYMBOL(Enotdir);
+char *Etoomanywnames = "too many wnames";
+EXPORT_SYMBOL(Etoomanywnames);
+char *Eperm = "permission denied";
+EXPORT_SYMBOL(Eperm);
+char *Etoolarge = "i/o count too large";
+EXPORT_SYMBOL(Etoolarge);
+char *Ebadoffset = "bad offset in directory read";
+EXPORT_SYMBOL(Ebadoffset);
+char *Edirchange = "cannot convert between files and directories";
+EXPORT_SYMBOL(Edirchange);
+char *Enotfound = "file not found";
+EXPORT_SYMBOL(Enotfound);
+char *Eopen = "file alread exclusively opened";
+EXPORT_SYMBOL(Eopen);
+char *Eexist = "file or directory already exists";
+EXPORT_SYMBOL(Eexist);
+char *Enotempty = "directory not empty";
+EXPORT_SYMBOL(Enotempty);
+
+static void p9srv_version(struct p9srv_req *);
+static void p9srv_auth(struct p9srv_req *);
+static void p9srv_attach(struct p9srv_req *);
+static void p9srv_attach_post(struct p9srv_req *req);
+static void p9srv_flush(struct p9srv_req *);
+static void p9srv_walk(struct p9srv_req *);
+static void p9srv_walk_post(struct p9srv_req *);
+static void p9srv_open(struct p9srv_req *);
+static void p9srv_open_post(struct p9srv_req *);
+static void p9srv_create(struct p9srv_req *);
+static void p9srv_create_post(struct p9srv_req *);
+static void p9srv_read(struct p9srv_req *);
+static void p9srv_read_post(struct p9srv_req *);
+static void p9srv_write(struct p9srv_req *);
+static void p9srv_clunk(struct p9srv_req *);
+static void p9srv_clunk_post(struct p9srv_req *);
+static void p9srv_remove(struct p9srv_req *);
+static void p9srv_remove_post(struct p9srv_req *);
+static void p9srv_stat(struct p9srv_req *);
+static void p9srv_wstat(struct p9srv_req *);
+static void p9srv_preq_work(struct work_struct *work);
+
+static void (*p9srv_fcall[])(struct p9srv_req *) = {
+	p9srv_version,		/* Tversion */
+	p9srv_auth,		/* Tauth */
+	p9srv_attach,		/* Tattach */
+	NULL,			/* Terror */
+	p9srv_flush,		/* Tflush */
+	p9srv_walk,		/* Twalk */
+	p9srv_open,		/* Topen */
+	p9srv_create,		/* Tcreate */
+	p9srv_read,		/* Tread */
+	p9srv_write,		/* Twrite */
+	p9srv_clunk,		/* Tclunk */
+	p9srv_remove,		/* Tremove */
+	p9srv_stat,		/* Tstat */
+	p9srv_wstat,		/* Twstat */
+};
+
+static void (*p9srv_fcall_post[])(struct p9srv_req *) = {
+	NULL,			/* Tversion */
+	NULL,			/* Tauth */
+	p9srv_attach_post,	/* Tattach */
+	NULL,			/* Terror */
+	NULL,			/* Tflush */
+	p9srv_walk_post,	/* Twalk */
+	p9srv_open_post,	/* Topen */
+	p9srv_create_post,	/* Tcreate */
+	p9srv_read_post,	/* Tread */
+	NULL,			/* Twrite */
+	p9srv_clunk_post,	/* Tclunk */
+	p9srv_remove_post,	/* Tremove */
+	NULL,			/* Tstat */
+	NULL,			/* Twstat */
+};
+
+struct p9srv *p9srv_srv_create(void)
+{
+	struct p9srv *srv;
+
+	srv = kmalloc(sizeof(struct p9srv), GFP_KERNEL);
+	if (!srv) {
+		P9_DPRINTK(P9SRV_DEBUG_SRV, "failed\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	memset(srv, 0, sizeof(struct p9srv));
+	spin_lock_init(&srv->lock);
+	atomic_set(&srv->refcount, 1);
+	INIT_LIST_HEAD(&srv->conn_list);
+	INIT_LIST_HEAD(&srv->req_list);
+	INIT_LIST_HEAD(&srv->workreq_list);
+	INIT_WORK(&srv->pq, p9srv_preq_work);
+
+	/* the values below may be overwritten by the creator */
+	srv->msize = 65536 + P9_IOHDRSZ;
+	srv->dotu = 1;
+	srv->debuglevel = 0;
+
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "srv %p\n", srv);
+	return srv;
+}
+EXPORT_SYMBOL(p9srv_srv_create);
+
+void p9srv_srv_destroy(struct p9srv *srv)
+{
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "%p\n", srv);
+	p9srv_srv_unref(srv);
+}
+EXPORT_SYMBOL(p9srv_srv_destroy);
+
+void p9srv_srv_ref(struct p9srv *srv)
+{
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "%p\n", srv);
+	atomic_inc(&srv->refcount);
+}
+
+void p9srv_srv_unref(struct p9srv *srv)
+{
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "%p\n", srv);
+	if (atomic_dec_and_test(&srv->refcount)) {
+		BUG_ON(!list_empty(&srv->conn_list));
+		BUG_ON(!list_empty(&srv->req_list));
+		BUG_ON(!list_empty(&srv->workreq_list));
+
+		if (srv->destroy)
+			(*srv->destroy)(srv);
+
+		kfree(srv);
+	}
+}
+
+void p9srv_srv_start(struct p9srv *srv)
+{
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "%p\n", srv);
+	if (srv->start)
+		(*srv->start)(srv);
+}
+EXPORT_SYMBOL(p9srv_srv_start);
+
+void p9srv_srv_stop(struct p9srv *srv)
+{
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "%p\n", srv);
+	if (srv->stop)
+		(*srv->stop)(srv);
+	p9srv_srv_unref(srv);
+}
+EXPORT_SYMBOL(p9srv_srv_stop);
+
+/**
+ * p9_preq_work - process a single request
+ */
+static void p9srv_preq_work(struct work_struct *work)
+{
+	struct p9srv *srv;
+	struct p9srv_req *req;
+	struct p9_fcall *tc;
+
+	srv = container_of(work, struct p9srv, pq);
+	P9_DPRINTK(P9SRV_DEBUG_REQ, "%p\n", srv);
+	spin_lock(&srv->lock);
+	while (!list_empty(&srv->req_list)) {
+		req = list_first_entry(&srv->req_list, struct p9srv_req,
+			req_list);
+		list_move_tail(&req->req_list, &srv->workreq_list);
+		spin_unlock(&srv->lock);
+
+		P9_DPRINTK(P9SRV_DEBUG_REQ, "req %p tag %d\n", req, req->tag);
+		tc = req->tcall;
+		if (tc->id < P9_FIRST || tc->id > P9_LAST ||
+			!p9srv_fcall[(tc->id - P9_FIRST)/2] || tc->id%2 == 1) {
+
+			p9srv_respond_error(req, "unsupported message", EIO);
+			return;
+		}
+
+		(*p9srv_fcall[(tc->id - P9_FIRST) / 2])(req);
+		spin_lock(&srv->lock);
+	}
+
+	clear_bit(Worksched, &srv->status);
+	spin_unlock(&srv->lock);
+}
+
+void p9srv_respond(struct p9srv_req *req, struct p9_fcall *rc)
+{
+	int empty;
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_req *freq, *rptr;
+
+	conn = req->conn;
+	srv = conn->srv;
+	P9_DPRINTK(P9SRV_DEBUG_REQ, "srv %p conn %p req %p\n", srv, conn, req);
+
+	if (test_and_set_bit(Respond, &req->status)) {
+		kfree(rc);
+		return;
+	}
+
+	p9_set_tag(rc, req->tag);
+	req->rcall = rc;
+	if (p9srv_fcall_post[(req->tcall->id - P9_FIRST) / 2])
+		(*p9srv_fcall_post[(req->tcall->id - P9_FIRST) / 2])(req);
+
+	p9srv_fid_decref(req->fid);
+	p9srv_fid_decref(req->newfid);
+	p9srv_fid_decref(req->afid);
+	req->fid = NULL;
+	req->newfid = NULL;
+	req->afid = NULL;
+
+	spin_lock(&srv->lock);
+	spin_lock(&conn->lock);
+	empty = list_empty(&conn->oreq_list);
+
+	/* move the request and all requests that flush it to oreq_list */
+	list_move_tail(&req->req_list, &conn->oreq_list);
+	list_for_each_entry_safe(freq, rptr, &req->flush_req_list,
+							flush_req_list) {
+		list_move_tail(&freq->req_list, &conn->oreq_list);
+	}
+	spin_unlock(&conn->lock);
+	spin_unlock(&srv->lock);
+
+	if (empty)
+		p9srv_conn_try_send(conn);
+}
+EXPORT_SYMBOL(p9srv_respond);
+
+void p9srv_respond_error(struct p9srv_req *req, char *ename, int ecode)
+{
+	struct p9_fcall *rc;
+
+	P9_DPRINTK(P9SRV_DEBUG_REQ, "req %p ename %s ecode %d\n",
+		req, ename, ecode);
+	rc = p9_create_rerror(ename, ecode, req->conn->dotu);
+	p9srv_respond(req, rc);
+}
+EXPORT_SYMBOL(p9srv_respond_error);
+
+struct p9srv_req *p9srv_req_create(void)
+{
+	struct p9srv_req *req;
+
+	req = kmalloc(sizeof(struct p9srv_req), GFP_KERNEL);
+	if (!req)
+		return ERR_PTR(-ENOMEM);
+
+	req->tag = P9_NOTAG;
+	req->aux = NULL;
+	req->tcall = NULL;
+	req->rcall = NULL;
+	req->status = 0;
+	atomic_set(&req->refcount, 1);
+	req->conn = NULL;
+	INIT_LIST_HEAD(&req->flush_req_list);
+	INIT_LIST_HEAD(&req->req_list);
+	req->fid = NULL;
+	req->afid = NULL;
+	req->newfid = NULL;
+	P9_DPRINTK(P9SRV_DEBUG_REQ, "req %p\n", req);
+
+	return req;
+}
+
+void p9srv_req_ref(struct p9srv_req *req)
+{
+	atomic_inc(&req->refcount);
+	P9_DPRINTK(P9SRV_DEBUG_REQ, "req %p count %d\n", req,
+		atomic_read(&req->refcount));
+}
+EXPORT_SYMBOL(p9srv_req_ref);
+
+void p9srv_req_unref(struct p9srv_req *req)
+{
+	int n;
+
+	n = atomic_dec_and_test(&req->refcount);
+	P9_DPRINTK(P9SRV_DEBUG_REQ, "req %p count %d\n", req,
+		atomic_read(&req->refcount));
+	if (n) {
+		P9_DPRINTK(P9SRV_DEBUG_REQ, "destroy req %p\n", req);
+		if (req->conn && req->conn->srv && req->conn->srv->reqdestroy)
+			(*req->conn->srv->reqdestroy)(req);
+
+		kfree(req->tcall);
+		kfree(req->rcall);
+		kfree(req);
+	}
+}
+EXPORT_SYMBOL(p9srv_req_unref);
+
+static void p9srv_version(struct p9srv_req *req)
+{
+	int msize;
+	struct p9_str *version;
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9_fcall *tc, *rc;
+
+	conn = req->conn;
+	srv = conn->srv;
+	tc = req->tcall;
+	msize = tc->params.tversion.msize;
+	version = &tc->params.tversion.version;
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	if (msize < P9_IOHDRSZ + 1) {
+		p9srv_respond_error(req, "msize too small", EIO);
+		return;
+	}
+
+	if ((version->len != 8 || memcmp(version->str, "9P2000.u", 8)) &&
+		(version->len != 6 || memcmp(version->str, "9P2000", 6))) {
+
+		p9srv_respond_error(req, "unsupported protocol version", EIO);
+		return;
+	}
+
+	p9srv_conn_reset(conn, req);
+	rc = p9_create_rversion(conn->msize, conn->dotu?"9P2000.u":"9P2000");
+	p9srv_respond(req, rc);
+}
+
+static void p9srv_auth(struct p9srv_req *req)
+{
+	struct p9srv *srv;
+	struct p9_fcall *tc;
+	struct p9srv_fid *afid;
+
+	srv = req->conn->srv;
+	tc = req->tcall;
+
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	afid = p9srv_fid_create(req->conn->fidpool, tc->params.tauth.afid);
+	if (IS_ERR(afid)) {
+		p9srv_respond_error(req, Ebadusefid, PTR_ERR(afid));
+		return;
+	}
+
+	afid->conn = req->conn;
+	afid->type = P9_QTAUTH;
+	req->afid = afid;
+	if (*srv->auth)
+		(*srv->auth)(req);
+	else
+		p9srv_respond_error(req, "authentication not required", EIO);
+}
+
+static void p9srv_attach(struct p9srv_req *req)
+{
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_fid *afid, *fid;
+	struct p9_fcall *tc;
+
+	conn = req->conn;
+	srv = conn->srv;
+	tc = req->tcall;
+	afid = NULL;
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	if (tc->params.tattach.afid != P9_NOFID) {
+		afid = p9srv_fid_find(conn->fidpool, tc->params.tattach.afid);
+		if (IS_ERR(afid)) {
+			p9srv_respond_error(req, Eunknownfid, PTR_ERR(afid));
+			return;
+		}
+
+		req->afid = afid;
+		if (!(afid->type & P9_QTAUTH)) {
+			p9srv_respond_error(req, Ebadusefid, EIO);
+			return;
+		}
+	}
+
+	fid = p9srv_fid_create(conn->fidpool, tc->params.tattach.fid);
+	if (IS_ERR(fid)) {
+		p9srv_respond_error(req, Ebadusefid, PTR_ERR(fid));
+		return;
+	}
+	fid->conn = req->conn;
+	req->fid = fid;
+	if (*srv->attach)
+		(*srv->attach)(req);
+	else
+		p9srv_respond_error(req, Enotimpl, EIO);
+}
+
+static void p9srv_attach_post(struct p9srv_req *req)
+{
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	if (req->rcall && req->rcall->id == P9_RATTACH) {
+		req->fid->type = req->rcall->params.rattach.qid.type;
+		p9srv_fid_incref(req->fid);
+	}
+}
+
+void p9srv_flush(struct p9srv_req *freq)
+{
+	int oldtag;
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_req *req;
+	struct p9_fcall *rc;
+
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", freq);
+	conn = freq->conn;
+	srv = conn->srv;
+	oldtag = freq->tcall->params.tflush.oldtag;
+	rc = p9_create_rflush();
+	if (oldtag == freq->tag)
+		goto respond;
+
+	spin_lock(&srv->lock);
+	/* if the server didn't start working on the request, send the
+	   Rflush immediately */
+	list_for_each_entry(req, &srv->req_list, req_list) {
+		if (req->conn == conn && req->tag == oldtag) {
+			list_del(&req->req_list);
+			spin_unlock(&srv->lock);
+			p9srv_req_unref(req);
+			goto respond;
+		}
+	}
+
+	list_for_each_entry(req, &srv->workreq_list, req_list) {
+		if (req->conn == conn && req->tag == oldtag) {
+			list_add_tail(&freq->flush_req_list,
+				&req->flush_req_list);
+			if (test_and_set_bit(Flush, &req->status)) {
+				spin_unlock(&srv->lock);
+			} else {
+				p9srv_req_ref(req);
+				spin_unlock(&srv->lock);
+				if (srv->flush)
+					if ((*srv->flush)(req))
+						p9srv_respond(req, NULL);
+				p9srv_req_unref(req);
+			}
+
+			return;
+		}
+	}
+	spin_unlock(&srv->lock);
+
+	/* if no request with oldtag is found, we need to send Rflush */
+respond:
+	p9srv_respond(freq, rc);
+}
+
+static void p9srv_walk(struct p9srv_req *req)
+{
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_fid *fid, *nfid;
+	struct p9_fcall *tc;
+
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	conn = req->conn;
+	srv = conn->srv;
+	tc = req->tcall;
+	fid = p9srv_fid_find(conn->fidpool, tc->params.twalk.fid);
+	if (IS_ERR(fid)) {
+		p9srv_respond_error(req, Eunknownfid, PTR_ERR(fid));
+		return;
+	}
+
+	req->fid = fid;
+	if (!(fid->type & P9_QTDIR) && tc->params.twalk.nwname > 0) {
+		p9srv_respond_error(req, Enotdir, ENOTDIR);
+		return;
+	}
+
+	if (fid->omode != (u16) ~0) {
+		p9srv_respond_error(req, Ebadusefid, EIO);
+		return;
+	}
+
+	if (tc->params.twalk.nwname > P9_MAXWELEM) {
+		p9srv_respond_error(req, Etoomanywnames, EIO);
+		return;
+	}
+
+	if (tc->params.twalk.newfid != tc->params.twalk.fid) {
+		nfid = p9srv_fid_create(conn->fidpool, tc->params.twalk.newfid);
+		if (IS_ERR(nfid)) {
+			p9srv_respond_error(req, Ebadusefid, PTR_ERR(nfid));
+			return;
+		}
+		nfid->conn = req->conn;
+		nfid->uid = fid->uid;
+		nfid->type = fid->type;
+	} else {
+		nfid = fid;
+		p9srv_fid_incref(fid);
+	}
+	req->newfid = nfid;
+
+	if (srv->walk)
+		(*srv->walk)(req);
+	else
+		p9srv_respond_error(req, Enotimpl, EIO);
+}
+
+static void p9srv_walk_post(struct p9srv_req *req)
+{
+	int n;
+	struct p9_fcall *rc;
+
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	if (req->rcall && req->rcall->id == P9_RWALK && req->newfid) {
+		rc = req->rcall;
+		n = rc->params.rwalk.nwqid;
+		if (n > 0)
+			req->newfid->type = rc->params.rwalk.wqids[n - 1].type;
+
+		if (req->fid != req->newfid)
+			p9srv_fid_incref(req->newfid);
+	}
+}
+
+static void p9srv_open(struct p9srv_req *req)
+{
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_fid *fid;
+	struct p9_fcall *tc;
+
+	conn = req->conn;
+	srv = conn->srv;
+	tc = req->tcall;
+
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	fid = p9srv_fid_find(conn->fidpool, tc->params.topen.fid);
+	if (IS_ERR(fid)) {
+		p9srv_respond_error(req, Eunknownfid, PTR_ERR(fid));
+		return;
+	}
+	req->fid = fid;
+
+	if (fid->omode != (u16) ~0) {
+		p9srv_respond_error(req, Ebadusefid, EIO);
+		return;
+	}
+
+	if (fid->type & P9_QTDIR && tc->params.topen.mode != P9_OREAD) {
+		p9srv_respond_error(req, Eperm, EPERM);
+		return;
+	}
+
+	if (srv->open)
+		(*srv->open)(req);
+	else
+		p9srv_respond_error(req, Enotimpl, EIO);
+}
+
+static void p9srv_open_post(struct p9srv_req *req)
+{
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	if (req->rcall && req->rcall->id == P9_ROPEN && req->fid)
+		req->fid->omode = req->tcall->params.topen.mode;
+}
+
+static void p9srv_create(struct p9srv_req *req)
+{
+	int perm;
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_fid *fid;
+	struct p9_fcall *tc;
+
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	conn = req->conn;
+	srv = conn->srv;
+	tc = req->tcall;
+	fid = p9srv_fid_find(conn->fidpool, tc->params.tcreate.fid);
+	if (IS_ERR(fid)) {
+		p9srv_respond_error(req, Eunknownfid, PTR_ERR(fid));
+		return;
+	}
+	req->fid = fid;
+
+	if (fid->omode != (u16) ~0) {
+		p9srv_respond_error(req, Ebadusefid, EIO);
+		return;
+	}
+
+	if (!(fid->type & P9_QTDIR)) {
+		p9srv_respond_error(req, Enotdir, ENOTDIR);
+		return;
+	}
+
+	perm = tc->params.tcreate.perm;
+	if ((perm & P9_DMDIR) && (tc->params.tcreate.mode != P9_OREAD)) {
+		p9srv_respond_error(req, Eperm, EPERM);
+		return;
+	}
+
+	if (perm & (P9_DMNAMEDPIPE | P9_DMSYMLINK | P9_DMLINK | P9_DMDEVICE |
+		P9_DMSOCKET) && !conn->dotu) {
+
+		p9srv_respond_error(req, Eperm, EPERM);
+		return;
+	}
+
+	if (srv->create)
+		(*srv->create)(req);
+	else
+		p9srv_respond_error(req, Enotimpl, EIO);
+}
+
+static void p9srv_create_post(struct p9srv_req *req)
+{
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	if (req->rcall && req->rcall->id == P9_RCREATE && req->fid) {
+		req->fid->omode = req->tcall->params.tcreate.mode;
+		req->fid->type = req->rcall->params.rcreate.qid.type;
+	}
+}
+
+static void p9srv_read(struct p9srv_req *req)
+{
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_fid *fid;
+	struct p9_fcall *tc;
+
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	conn = req->conn;
+	srv = conn->srv;
+	tc = req->tcall;
+	fid = p9srv_fid_find(conn->fidpool, tc->params.tread.fid);
+	if (IS_ERR(fid)) {
+		p9srv_respond_error(req, Eunknownfid, PTR_ERR(fid));
+		return;
+	}
+	req->fid = fid;
+
+	if ((fid->omode == (u16) ~0) || ((fid->omode & 3) == P9_OWRITE)) {
+		p9srv_respond_error(req, Ebadusefid, EIO);
+		return;
+	}
+
+	if (fid->type & P9_QTDIR && tc->params.tread.offset != fid->diroffset) {
+		p9srv_respond_error(req, Ebadoffset, EIO);
+		return;
+	}
+
+	if (tc->params.tread.count + P9_IOHDRSZ > conn->msize) {
+		p9srv_respond_error(req, Etoolarge, EIO);
+		return;
+	}
+
+	if (srv->read)
+		(*srv->read)(req);
+	else
+		p9srv_respond_error(req, Enotimpl, EIO);
+}
+
+static void p9srv_read_post(struct p9srv_req *req)
+{
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	if (req->fid && req->rcall && req->rcall->id == P9_RREAD &&
+					req->fid->type & P9_QTDIR)
+		req->fid->diroffset = req->tcall->params.tread.offset +
+			req->rcall->params.rread.count;
+}
+
+static void p9srv_write(struct p9srv_req *req)
+{
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_fid *fid;
+	struct p9_fcall *tc;
+
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	conn = req->conn;
+	srv = conn->srv;
+	tc = req->tcall;
+	fid = p9srv_fid_find(conn->fidpool, tc->params.twrite.fid);
+	if (IS_ERR(fid)) {
+		p9srv_respond_error(req, Eunknownfid, PTR_ERR(fid));
+		return;
+	}
+	req->fid = fid;
+
+	if ((fid->omode == (u16) ~0) || ((fid->omode & 3) == P9_OREAD)) {
+		p9srv_respond_error(req, Ebadusefid, EIO);
+		return;
+	}
+
+	if (tc->params.twrite.count + P9_IOHDRSZ > conn->msize) {
+		p9srv_respond_error(req, Etoolarge, EIO);
+		return;
+	}
+
+	if (srv->write)
+		(*srv->write)(req);
+	else
+		p9srv_respond_error(req, Enotimpl, EIO);
+}
+
+static void p9srv_clunk(struct p9srv_req *req)
+{
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_fid *fid;
+	struct p9_fcall *tc;
+
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	conn = req->conn;
+	srv = conn->srv;
+	tc = req->tcall;
+	fid = p9srv_fid_find(conn->fidpool, tc->params.tclunk.fid);
+	if (IS_ERR(fid)) {
+		p9srv_respond_error(req, Eunknownfid, PTR_ERR(fid));
+		return;
+	}
+	req->fid = fid;
+
+	if (srv->clunk)
+		(*srv->clunk)(req);
+	else
+		p9srv_respond_error(req, Enotimpl, EIO);
+}
+
+static void p9srv_clunk_post(struct p9srv_req *req)
+{
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	if (req->rcall && req->rcall->id == P9_RCLUNK && req->fid)
+		p9srv_fid_decref(req->fid);
+}
+
+static void p9srv_remove(struct p9srv_req *req)
+{
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_fid *fid;
+	struct p9_fcall *tc;
+
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	conn = req->conn;
+	srv = conn->srv;
+	tc = req->tcall;
+	fid = p9srv_fid_find(conn->fidpool, tc->params.tclunk.fid);
+	if (IS_ERR(fid)) {
+		p9srv_respond_error(req, Eunknownfid, PTR_ERR(fid));
+		return;
+	}
+	req->fid = fid;
+
+	if (srv->remove)
+		(*srv->remove)(req);
+	else
+		p9srv_respond_error(req, Enotimpl, EIO);
+}
+
+static void p9srv_remove_post(struct p9srv_req *req)
+{
+	/* we need to clunk the fid no matter error or not */
+	if (req->fid)
+		p9srv_fid_decref(req->fid);
+}
+
+static void p9srv_stat(struct p9srv_req *req)
+{
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_fid *fid;
+	struct p9_fcall *tc;
+
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	conn = req->conn;
+	srv = conn->srv;
+	tc = req->tcall;
+	fid = p9srv_fid_find(conn->fidpool, tc->params.tstat.fid);
+	if (IS_ERR(fid)) {
+		p9srv_respond_error(req, Eunknownfid, PTR_ERR(fid));
+		return;
+	}
+	req->fid = fid;
+
+	if (srv->stat)
+		(*srv->stat)(req);
+	else
+		p9srv_respond_error(req, Enotimpl, EIO);
+}
+
+static void p9srv_wstat(struct p9srv_req *req)
+{
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_fid *fid;
+	struct p9_fcall *tc;
+	struct p9_stat *stat;
+
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	conn = req->conn;
+	srv = conn->srv;
+	tc = req->tcall;
+	stat = &tc->params.twstat.stat;
+	fid = p9srv_fid_find(conn->fidpool, tc->params.twstat.fid);
+	if (IS_ERR(fid)) {
+		p9srv_respond_error(req, Eunknownfid, PTR_ERR(fid));
+		return;
+	}
+	req->fid = fid;
+
+	if ((stat->type != (u16) ~0) || (stat->dev != (u32) ~0) ||
+				(stat->qid.version != (u32) ~0) ||
+				(stat->qid.path != (u64) ~0)) {
+		p9srv_respond_error(req, Eperm, EPERM);
+		return;
+	}
+
+	if (stat->mode != (u32) ~0 && ((fid->type & P9_QTDIR &&
+		!(stat->mode & P9_DMDIR)) ||
+		(!(fid->type & P9_QTDIR) && (stat->mode & P9_DMDIR)))) {
+
+		p9srv_respond_error(req, Edirchange, EPERM);
+		return;
+	}
+
+	if (srv->wstat)
+		(*srv->wstat)(req);
+	else
+		p9srv_respond_error(req, Enotimpl, EIO);
+}
+
+static int __init p9srv_init(void)
+{
+	return p9srv_conn_init();
+}
+
+static void __exit p9srv_exit(void)
+{
+	p9srv_conn_exit();
+}
+
+module_init(p9srv_init)
+module_exit(p9srv_exit)
+
+MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
+MODULE_LICENSE("GPL");
diff --git a/net/9p/srv/srvimpl.h b/net/9p/srv/srvimpl.h
new file mode 100644
index 0000000..5276440
--- /dev/null
+++ b/net/9p/srv/srvimpl.h
@@ -0,0 +1,46 @@
+/*
+ * net/9p/srv/srvimpl.h
+ *
+ * Internal server definitions
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
+struct p9srv_fidpool {
+	spinlock_t		lock;	/* covers all fidpool operations */
+	struct hlist_head	hash[FID_HTABLE_SIZE];
+};
+
+extern struct workqueue_struct *p9srv_wq;
+
+/* srv.c */
+void p9srv_srv_ref(struct p9srv *srv);
+void p9srv_srv_unref(struct p9srv *srv);
+
+/* conn.c */
+int p9srv_conn_init(void);
+void p9srv_conn_exit(void);
+void p9srv_conn_reset(struct p9srv_conn *conn, struct p9srv_req *vreq);
+void p9srv_conn_try_send(struct p9srv_conn *conn);
+
+/* fid.c */
+struct p9srv_fidpool *p9srv_fidpool_create(void);
+void p9srv_fidpool_destroy(struct p9srv_fidpool *fp);
+void p9srv_fidpool_reset(struct p9srv_fidpool *fp);
+struct p9srv_fid *p9srv_fid_create(struct p9srv_fidpool *fp, u32 fid);
-- 
1.5.2.4

