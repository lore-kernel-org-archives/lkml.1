Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbXKBREo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbXKBREo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbXKBREd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:04:33 -0400
Received: from 71-33-33-68.albq.qwest.net ([71.33.33.68]:45965 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754625AbXKBREb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:04:31 -0400
Date: Fri, 2 Nov 2007 11:04:29 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/10] 9p: in-kernel server basic support
Message-ID: <20071102170429.GG16063@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the basic functionality required for implementing
in-kernel 9P file servers.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
 include/net/9p/9p.h  |    2 +
 include/net/9p/srv.h |  169 +++++++
 net/9p/Kconfig       |    5 +
 net/9p/Makefile      |    4 +
 net/9p/fcprint.c     |    2 +
 net/9p/srv.c         | 1283 ++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 1465 insertions(+), 0 deletions(-)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index f7bd839..a913cdb 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -65,6 +65,7 @@ do { \
 
 /* Message Types */
 enum {
+	P9_FIRST = 100,
 	P9_TVERSION = 100,
 	P9_RVERSION,
 	P9_TAUTH = 102,
@@ -93,6 +94,7 @@ enum {
 	P9_RSTAT,
 	P9_TWSTAT = 126,
 	P9_RWSTAT,
+	P9_LAST,
 };
 
 /* open modes */
diff --git a/include/net/9p/srv.h b/include/net/9p/srv.h
new file mode 100644
index 0000000..72d011e
--- /dev/null
+++ b/include/net/9p/srv.h
@@ -0,0 +1,169 @@
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
+	struct list_head	conn_list;	/* all connections for srv */
+	struct list_head	req_list;	/* requests not yet worked on */
+	struct list_head	workreq_list;	/* requests being worked on */
+};
+
+struct p9srv_conn {
+	struct p9srv		*srv;
+	struct p9_trans		*trans;
+	int			msize;
+	int			dotu;	/* 9P2000.u */
+
+	/* implementation specific */
+	unsigned long		status;
+	struct p9srv_fidpool	*fidpool;
+	struct list_head	conn_list;
+	atomic_t		reset_wcount;
+	wait_queue_head_t	reset_wqueue;
+};
+
+enum {
+	/* connection status values */
+	Reset = 1,		/* resetting */
+	Destroy = 2,		/* destroying */
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
+	struct p9_trans_req	*req;
+	struct list_head	flush_req_list;
+	struct list_head	req_list;
+	struct work_struct	pq;
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
+#endif
diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index bafc50c..8a3ff32 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -23,6 +23,11 @@ config NET_9P_FD
 	  file descriptors.  TCP/IP is the default transport for 9p,
 	  so if you are going to use 9p, you'll likely want this.
 
+config NET_9P_SRV
+	tristate "9P server support"
+	depends on NET_9P
+	help
+	  Say Y if you want the 9P server support
 config NET_9P_VIRTIO
 	depends on NET_9P && EXPERIMENTAL && VIRTIO
 	tristate "9P Virtio Transport (Experimental)"
diff --git a/net/9p/Makefile b/net/9p/Makefile
index 87c0fa5..106a596 100644
--- a/net/9p/Makefile
+++ b/net/9p/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_NET_9P) := 9pnet.o
 obj-$(CONFIG_NET_9P_FD) += 9pnet_fd.o
+obj-$(CONFIG_NET_9P_SRV) += 9psrv.o
 obj-$(CONFIG_NET_9P_VIRTIO) += 9pnet_virtio.o
 
 9pnet-objs := \
@@ -10,6 +11,9 @@ obj-$(CONFIG_NET_9P_VIRTIO) += 9pnet_virtio.o
 	fcprint.o \
 	util.o \
 
+9psrv-objs := \
+	srv.o \
+
 9pnet_fd-objs := \
 	mux.o \
 
diff --git a/net/9p/fcprint.c b/net/9p/fcprint.c
index b1ae8ec..3c5cd83 100644
--- a/net/9p/fcprint.c
+++ b/net/9p/fcprint.c
@@ -347,8 +347,10 @@ p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 
 	return ret;
 }
+EXPORT_SYMBOL(p9_printfcall);
 
 #else
+
 int
 p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 {
diff --git a/net/9p/srv.c b/net/9p/srv.c
new file mode 100644
index 0000000..b35f090
--- /dev/null
+++ b/net/9p/srv.c
@@ -0,0 +1,1283 @@
+/*
+ * net/9p/srv.c
+ *
+ * 9P Server Support
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
+#include <linux/hash.h>
+#include <net/9p/9p.h>
+#include <net/9p/transport.h>
+#include <net/9p/srv.h>
+
+struct p9srv_fidpool {
+	spinlock_t		lock;	/* covers all fidpool operations */
+	struct hlist_head	hash[FID_HTABLE_SIZE];
+};
+
+enum {
+	/* p9srv_req status */
+	Respond = 1,
+	Flush,
+	Flushwork,
+};
+
+struct workqueue_struct *p9srv_wq;
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
+static void p9srv_srv_ref(struct p9srv *srv);
+static void p9srv_srv_unref(struct p9srv *srv);
+static void p9srv_conn_reset(struct p9srv_conn *conn, struct p9srv_req *vreq);
+static void p9srv_conn_respond(struct p9srv_req *req);
+static struct p9srv_fidpool *p9srv_fidpool_create(void);
+static void p9srv_fidpool_destroy(struct p9srv_fidpool *fp);
+static void p9srv_fidpool_reset(struct p9srv_fidpool *fp);
+struct p9srv_fid *p9srv_fid_create(struct p9srv_fidpool *fp, u32 fid);
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
+static void p9srv_conn_request(struct p9_trans *, struct p9_trans_req *req);
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
+		P9_DPRINTK(P9SRV_DEBUG_SRV, "destroy %p\n", srv);
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
+	req = container_of(work, struct p9srv_req, pq);
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "req %p tag %d\n", req, req->tag);
+	srv = req->conn->srv;
+	spin_lock(&srv->lock);
+	list_move_tail(&req->req_list, &srv->workreq_list);
+	if (test_bit(Flush, &req->status) || test_bit(Flushwork, &req->status)) {
+		P9_DPRINTK(P9SRV_DEBUG_SRV, "req %p tag %d flushed\n", req, req->tag);
+		spin_unlock(&srv->lock);
+		p9srv_respond(req, NULL);
+		return;
+	}
+
+	spin_unlock(&srv->lock);
+	tc = req->tcall;
+	if (tc->id < P9_FIRST || tc->id > P9_LAST ||
+		!p9srv_fcall[(tc->id - P9_FIRST)/2] || tc->id%2 == 1) {
+
+		p9srv_respond_error(req, "unsupported message", EIO);
+		return;
+	}
+
+	(*p9srv_fcall[(tc->id - P9_FIRST) / 2])(req);
+}
+
+void p9srv_respond(struct p9srv_req *req, struct p9_fcall *rc)
+{
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_req *freq, *rtmp;
+
+	conn = req->conn;
+	srv = conn->srv;
+	P9_DPRINTK(P9SRV_DEBUG_REQ, "srv %p conn %p req %p\n", srv, conn, req);
+
+	if (test_and_set_bit(Respond, &req->status)) {
+		kfree(rc);
+		if (rc != req->rcall)
+			kfree(req->rcall);
+		return;
+	}
+
+	spin_lock(&srv->lock);
+	list_del(&req->req_list);
+	list_for_each_entry(freq, &req->flush_req_list, flush_req_list) {
+		list_del(&freq->req_list);
+	}
+	spin_unlock(&srv->lock);
+
+	if (test_bit(Flush, &req->status) && rc == NULL)
+		goto flush;
+
+	p9_set_tag(rc, req->tag);
+	if (req->rcall != rc)
+		kfree(req->rcall);
+
+	req->rcall = rc;
+	if (req->tcall->id >= P9_FIRST && req->tcall->id < P9_LAST &&
+			p9srv_fcall_post[(req->tcall->id - P9_FIRST) / 2])
+		(*p9srv_fcall_post[(req->tcall->id - P9_FIRST) / 2])(req);
+
+	p9srv_fid_decref(req->fid);
+	p9srv_fid_decref(req->newfid);
+	p9srv_fid_decref(req->afid);
+	req->fid = NULL;
+	req->newfid = NULL;
+	req->afid = NULL;
+
+	p9srv_req_ref(req);
+	p9srv_conn_respond(req);
+
+flush:
+	list_for_each_entry_safe(freq, rtmp, &req->flush_req_list, flush_req_list) {
+		p9_set_tag(freq->rcall, freq->tag);
+		p9srv_conn_respond(freq);
+	}
+	p9srv_req_unref(req);
+}
+EXPORT_SYMBOL(p9srv_respond);
+
+void p9srv_respond_error(struct p9srv_req *req, char *ename, int ecode)
+{
+	P9_DPRINTK(P9SRV_DEBUG_REQ, "req %p ename %s ecode %d\n",
+		req, ename, ecode);
+	p9_create_rerror(req->rcall, ename, ecode, req->conn->dotu);
+	p9srv_respond(req, req->rcall);
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
+	req->req = NULL;
+	INIT_LIST_HEAD(&req->flush_req_list);
+	INIT_LIST_HEAD(&req->req_list);
+	INIT_WORK(&req->pq, p9srv_preq_work);
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
+	struct p9_fcall *tc;
+
+	conn = req->conn;
+	srv = conn->srv;
+	tc = req->tcall;
+	msize = tc->params.tversion.msize;
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p\n", req);
+	if (msize < P9_IOHDRSZ + 1) {
+		p9srv_respond_error(req, "msize too small", EIO);
+		return;
+	}
+
+	version = &tc->params.tversion.version;
+	if ((version->len != 8 || memcmp(version->str, "9P2000.u", 8)) &&
+		(version->len != 6 || memcmp(version->str, "9P2000", 6))) {
+
+		p9srv_respond_error(req, "unsupported protocol version", EIO);
+		return;
+	}
+
+	p9srv_conn_reset(conn, req);
+	p9_create_rversion(req->rcall, conn->msize,
+		conn->dotu?"9P2000.u":"9P2000");
+	p9srv_respond(req, req->rcall);
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
+/* if 0 returned, the flush request needs to be queued for response */
+static int p9srv_flush_req(struct p9srv_req *freq)
+{
+	int oldtag;
+	struct p9srv *srv;
+	struct p9srv_conn *conn;
+	struct p9srv_req *req;
+
+	conn = freq->conn;
+	srv = conn->srv;
+	oldtag = freq->tcall->params.tflush.oldtag;
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "req %p tag %d oldtag %d\n", freq,
+		freq->tag, oldtag);
+	p9_create_rflush(freq->rcall);
+	if (oldtag == freq->tag)
+		return 0;
+
+	spin_lock(&srv->lock);
+	/* if the server didn't start working on the request, mark it as
+	   being flushed, but don't call srv->flush */
+	list_for_each_entry(req, &srv->req_list, req_list) {
+		if (req->conn == conn && req->tag == oldtag) {
+			P9_DPRINTK(P9SRV_DEBUG_FCALL, "found in pending oldtag %d\n", oldtag);
+			list_add_tail(&freq->flush_req_list,
+				&req->flush_req_list);
+			set_bit(Flush, &req->status);
+			spin_unlock(&srv->lock);
+			return 1;
+		}
+	}
+
+	list_for_each_entry(req, &srv->workreq_list, req_list) {
+		if (req->conn == conn && req->tag == oldtag) {
+			P9_DPRINTK(P9SRV_DEBUG_FCALL, "found in working oldtag %d\n", oldtag);
+			list_add_tail(&freq->flush_req_list,
+				&req->flush_req_list);
+
+
+			if (test_and_set_bit(Flushwork, &req->status)) {
+				spin_unlock(&srv->lock);
+				return 1;
+			}
+
+			p9srv_req_ref(req);
+			spin_unlock(&srv->lock);
+			if (srv->flush && (*srv->flush)(req)) {
+				/* if srv->flush returns non-zero, the
+				   fs is not planning to respond to the
+				   request. So we queue it once more
+				   and the Flushwork status will do the right
+				   thing */
+
+				queue_work(p9srv_wq, &req->pq);
+			}
+
+			p9srv_req_unref(req);
+			return 1;
+		}
+	}
+	spin_unlock(&srv->lock);
+
+	P9_DPRINTK(P9SRV_DEBUG_FCALL, "not found oldtag %d\n", oldtag);
+	return 0;
+}
+
+static void p9srv_flush(struct p9srv_req *req)
+{
+	p9_create_rflush(req->rcall);
+	p9srv_respond(req, req->rcall);
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
+	if (fid->type & P9_QTDIR && tc->params.tread.offset != 0 &&
+				tc->params.tread.offset != fid->diroffset) {
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
+struct p9srv_fidpool *p9srv_fidpool_create(void)
+{
+	int i;
+	struct p9srv_fidpool *fp;
+
+	fp = kmalloc(sizeof(struct p9srv_fidpool), GFP_KERNEL);
+	if (!fp)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&fp->lock);
+	for (i = 0; i < FID_HTABLE_SIZE; i++)
+		INIT_HLIST_HEAD(&fp->hash[i]);
+
+	P9_DPRINTK(P9SRV_DEBUG_FID, "fidpool %p\n", fp);
+	return fp;
+}
+
+void p9srv_fidpool_destroy(struct p9srv_fidpool *fp)
+{
+	int i;
+
+	P9_DPRINTK(P9SRV_DEBUG_FID, "fidpool %p\n", fp);
+	for (i = 0; i < FID_HTABLE_SIZE; i++)
+		BUG_ON(!hlist_empty(&fp->hash[i]));
+
+	kfree(fp);
+}
+
+void p9srv_fidpool_reset(struct p9srv_fidpool *fp)
+{
+	int i;
+	struct p9srv_fid *cfid;
+	struct hlist_node *hn, *htmp;
+	HLIST_HEAD(hh);
+
+	P9_DPRINTK(P9SRV_DEBUG_FID, "fidpool %p\n", fp);
+	spin_lock(&fp->lock);
+	for (i = 0; i < FID_HTABLE_SIZE; i++) {
+		hlist_for_each_entry_safe(cfid, hn, htmp, &fp->hash[i],
+								fid_list) {
+			hlist_del(hn);
+			hlist_add_head(hn, &hh);
+		}
+	}
+	spin_unlock(&fp->lock);
+
+	hlist_for_each_entry_safe(cfid, hn, htmp, &hh, fid_list) {
+		atomic_set(&cfid->refcount, 1);
+		p9srv_fid_decref(cfid);
+	}
+}
+
+struct p9srv_fid *p9srv_fid_create(struct p9srv_fidpool *fp, u32 fid)
+{
+	unsigned long hash;
+	struct p9srv_fid *cfid, *nfid;
+	struct hlist_node *hn;
+
+	P9_DPRINTK(P9SRV_DEBUG_FID, "fidpool %p fid %d\n", fp, fid);
+	hash = hash_long(fid, FID_HTABLE_BITS);
+	nfid = kmalloc(sizeof(struct p9srv_fid), GFP_KERNEL);
+	if (!nfid)
+		return ERR_PTR(-ENOMEM);
+
+	nfid->fid = fid;
+	atomic_set(&nfid->refcount, 0);
+	nfid->conn = NULL;
+	nfid->aux = NULL;
+	nfid->omode = ~0;
+	nfid->type = 0;
+	nfid->diroffset = 0;
+	nfid->uid = ~0;
+	nfid->fidpool = fp;
+	INIT_HLIST_NODE(&nfid->fid_list);
+	spin_lock(&fp->lock);
+	hlist_for_each_entry(cfid, hn, &fp->hash[hash], fid_list) {
+		if (cfid->fid == fid) {
+			spin_unlock(&fp->lock);
+			kfree(nfid);
+			return ERR_PTR(-EEXIST);
+		}
+	}
+
+	hlist_add_head(&nfid->fid_list, &fp->hash[hash]);
+	spin_unlock(&fp->lock);
+	p9srv_fid_incref(nfid);
+	return nfid;
+}
+
+struct p9srv_fid *p9srv_fid_find(struct p9srv_fidpool *fp, u32 fid)
+{
+	unsigned long hash;
+	struct p9srv_fid *cfid;
+	struct hlist_node *hn;
+
+	hash = hash_long(fid, FID_HTABLE_BITS);
+	spin_lock(&fp->lock);
+	hlist_for_each_entry(cfid, hn, &fp->hash[hash], fid_list) {
+		if (cfid->fid == fid) {
+			spin_unlock(&fp->lock);
+			p9srv_fid_incref(cfid);
+			return cfid;
+		}
+	}
+	spin_unlock(&fp->lock);
+
+	return NULL;
+}
+EXPORT_SYMBOL(p9srv_fid_find);
+
+void p9srv_fid_incref(struct p9srv_fid *fid)
+{
+	if (fid)
+		atomic_inc(&fid->refcount);
+
+	P9_DPRINTK(P9SRV_DEBUG_FID, "fidpool %p fid %d count %d\n",
+		fid->fidpool, fid->fid, atomic_read(&fid->refcount));
+}
+EXPORT_SYMBOL(p9srv_fid_incref);
+
+void p9srv_fid_decref(struct p9srv_fid *fid)
+{
+	int n;
+
+	if (!fid)
+		return;
+
+	n = atomic_dec_and_test(&fid->refcount);
+	P9_DPRINTK(P9SRV_DEBUG_FID, "fidpool %p fid %d count %d \n",
+		fid->fidpool, fid->fid, atomic_read(&fid->refcount));
+	if (n) {
+		P9_DPRINTK(P9SRV_DEBUG_FID, "destroy fidpool %p fid %d\n",
+			fid->fidpool, fid->fid);
+		spin_lock(&fid->fidpool->lock);
+		hlist_del(&fid->fid_list);
+		spin_unlock(&fid->fidpool->lock);
+		if (fid->conn && fid->conn->srv && fid->conn->srv->fiddestroy)
+			(*fid->conn->srv->fiddestroy)(fid);
+		kfree(fid);
+	}
+}
+EXPORT_SYMBOL(p9srv_fid_decref);
+
+struct p9srv_conn *p9srv_conn_create(struct p9srv *srv,
+	struct p9_trans *trans)
+{
+	int err;
+	struct p9srv_conn *conn;
+
+	conn = kmalloc(sizeof(struct p9srv_conn), GFP_KERNEL);
+	if (!conn)
+		return ERR_PTR(-ENOMEM);
+
+	trans->aux = conn;
+	conn->srv = srv;
+	conn->trans = trans;
+	conn->msize = srv->msize;
+	conn->dotu = srv->dotu;
+	conn->status = 0;
+	INIT_LIST_HEAD(&conn->conn_list);
+	atomic_set(&conn->reset_wcount, 0);
+	init_waitqueue_head(&conn->reset_wqueue);
+	conn->fidpool = p9srv_fidpool_create();
+	if (!conn->fidpool) {
+		err = PTR_ERR(conn->fidpool);
+		kfree(conn);
+		return ERR_PTR(err);
+	}
+
+	spin_lock(&srv->lock);
+	list_add_tail(&conn->conn_list, &srv->conn_list);
+	spin_unlock(&srv->lock);
+
+	if (srv->connopen)
+		(*srv->connopen)(conn);
+
+	p9srv_srv_ref(conn->srv);
+	trans->request = p9srv_conn_request;
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
+	(*conn->trans->destroy)(conn->trans);
+	conn->trans = NULL;
+	list_del(&conn->conn_list);
+	if (conn->srv->connclose)
+		(*conn->srv->connclose)(conn);
+
+	p9srv_fidpool_destroy(conn->fidpool);
+	p9srv_srv_unref(conn->srv);
+	P9_DPRINTK(P9SRV_DEBUG_CONN, "end conn %p\n", conn);
+	kfree(conn);
+}
+EXPORT_SYMBOL(p9srv_conn_destroy);
+
+void p9srv_conn_reset(struct p9srv_conn *conn, struct p9srv_req *vreq)
+{
+	int i, n;
+	struct p9_str *version;
+	struct p9srv *srv;
+	struct p9srv_req *req, *rptr;
+	struct p9srv_req *wreqs[16];
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
+	p9srv_fidpool_reset(conn->fidpool);
+	if (vreq) {
+		conn->msize = vreq->tcall->params.tversion.msize;
+		if (srv->msize < conn->msize)
+			conn->msize = srv->msize;
+
+		conn->dotu = srv->dotu;
+		version = &vreq->tcall->params.tversion.version;
+		if (version->len != 8 || memcmp(version->str, "9P2000.u", 8) != 0)
+			conn->dotu = 0;
+	}
+
+	clear_bit(Reset, &conn->status);
+}
+
+static void p9srv_conn_request(struct p9_trans *trans, struct p9_trans_req *treq)
+{
+	struct p9srv_conn *conn;
+	struct p9srv_req *req;
+
+	conn = trans->aux;
+	if (trans->err) {
+		P9_DPRINTK(P9SRV_DEBUG_CONN, "transport error %d\n", trans->err);
+		p9srv_conn_destroy(conn);
+		return;
+	}
+
+#ifdef CONFIG_NET_9P_DEBUG
+	if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
+		char buf[150];
+
+		p9_printfcall(buf, sizeof(buf), treq->tc, conn->dotu);
+		printk(KERN_NOTICE ">}> %s\n", buf);
+	}
+#endif
+
+	req = p9srv_req_create();
+	req->conn = conn;
+	req->tag = treq->tag;
+	req->tcall = treq->tc;
+	req->rcall = treq->rc;
+	if (!req->rcall)
+		req->rcall = p9_fcall_alloc(conn->msize);
+
+	req->tag = treq->tag;
+	req->req = treq;
+	spin_lock(&conn->srv->lock);
+	list_add_tail(&req->req_list, &conn->srv->req_list);
+	spin_unlock(&conn->srv->lock);
+	if (req->tcall->id != P9_TFLUSH || !p9srv_flush_req(req))
+		queue_work(p9srv_wq, &req->pq);
+}
+
+void p9srv_conn_respond(struct p9srv_req *req)
+{
+	struct p9_trans_req *treq;
+
+	treq = req->req;
+	if (treq->rc != req->rcall) {
+		kfree(treq->rc);
+		treq->rc = req->rcall;
+	}
+
+#ifdef CONFIG_NET_9P_DEBUG
+	if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
+		char buf[150];
+
+		p9_printfcall(buf, sizeof(buf), treq->rc, req->conn->dotu);
+		printk(KERN_NOTICE "<{< %s\n", buf);
+	}
+#endif
+
+	(*treq->cb)(req->conn->trans, treq);
+	p9srv_req_unref(req);
+}
+
+static int __init p9srv_init(void)
+{
+	p9srv_wq = create_workqueue("9psrv");
+	if (!p9srv_wq) {
+		printk(KERN_WARNING "9psrv: creating workqueue failed\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void __exit p9srv_exit(void)
+{
+	destroy_workqueue(p9srv_wq);
+	p9srv_wq = NULL;
+}
+
+module_init(p9srv_init)
+module_exit(p9srv_exit)
+
+MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
+MODULE_LICENSE("GPL");
