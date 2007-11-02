Return-Path: <linux-kernel-owner+w=401wt.eu-S1761351AbXKBRQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761351AbXKBRQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757439AbXKBRQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:16:11 -0400
Received: from 71-33-33-68.albq.qwest.net ([71.33.33.68]:56109 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754328AbXKBRQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:16:02 -0400
Date: Fri, 2 Nov 2007 10:55:27 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/10] 9p: new transport interface
Message-ID: <20071102165527.GB16063@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current transport interface is tied too closely to the socket/file
descriptor operations. It expects only a single message to be transmitted at
any given time. It also depends on the vfs poll mechanism for notification
when data can be sent/received.

This patch modifies the transport interface making it more suitable for
implementing various 9P transports.
 
Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
 fs/9p/v9fs.c               |    1 -
 include/net/9p/9p.h        |    1 +
 include/net/9p/client.h    |   13 ++-
 include/net/9p/conn.h      |   57 --------
 include/net/9p/transport.h |   37 ++++--
 net/9p/Kconfig             |   18 ++--
 net/9p/Makefile            |    1 -
 net/9p/client.c            |  333 ++++++++++++++++++++++++++++++++++++++++----
 net/9p/conv.c              |   16 ++-
 net/9p/mod.c               |   12 +--
 10 files changed, 368 insertions(+), 121 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 873802d..eeca7c7 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -31,7 +31,6 @@
 #include <linux/idr.h>
 #include <net/9p/9p.h>
 #include <net/9p/transport.h>
-#include <net/9p/conn.h>
 #include <net/9p/client.h>
 #include "v9fs.h"
 #include "v9fs_vfs.h"
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 9ace484..86fee63 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -383,6 +383,7 @@ int p9_deserialize_stat(void *buf, u32 buflen, struct p9_stat *stat,
 	int dotu);
 int p9_deserialize_fcall(void *buf, u32 buflen, struct p9_fcall *fc, int dotu);
 void p9_set_tag(struct p9_fcall *fc, u16 tag);
+struct p9_fcall *p9_fcall_alloc(u32 size);
 struct p9_fcall *p9_create_tversion(u32 msize, char *version);
 struct p9_fcall *p9_create_tattach(u32 fid, u32 afid, char *uname,
 	char *aname, u32 n_uname, int dotu);
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 9b9221a..5efb57a 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -25,14 +25,14 @@
 #ifndef NET_9P_CLIENT_H
 #define NET_9P_CLIENT_H
 
+struct p9_trans_req;
 struct p9_client {
 	spinlock_t lock; /* protect client structure */
 	int msize;
 	unsigned char dotu;
 	struct p9_trans *trans;
-	struct p9_conn *conn;
-
 	struct p9_idpool *fidpool;
+	struct p9_idpool *tagpool;
 	struct list_head fidlist;
 };
 
@@ -78,4 +78,13 @@ struct p9_stat *p9_client_stat(struct p9_fid *fid);
 int p9_client_wstat(struct p9_fid *fid, struct p9_wstat *wst);
 struct p9_stat *p9_client_dirread(struct p9_fid *fid, u64 offset);
 
+void p9_client_req_incref(struct p9_trans_req *req);
+void p9_client_req_decref(struct p9_trans_req *req);
+struct p9_trans_req *p9_client_rpcnb(struct p9_client *clnt,
+	struct p9_fcall *tc, struct p9_fcall *rc,
+	void (*cb)(struct p9_trans_req *), void *cba);
+void p9_client_flush_req(struct p9_trans_req *req);
+int p9_client_rpc(struct p9_client *clnt, struct p9_fcall *tc,
+	struct p9_fcall **prc);
+
 #endif /* NET_9P_CLIENT_H */
diff --git a/include/net/9p/conn.h b/include/net/9p/conn.h
deleted file mode 100644
index 756d878..0000000
--- a/include/net/9p/conn.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/*
- * include/net/9p/conn.h
- *
- * Connection Definitions
- *
- *  Copyright (C) 2005 by Latchesar Ionkov <lucho@ionkov.net>
- *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
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
-#ifndef NET_9P_CONN_H
-#define NET_9P_CONN_H
-
-#undef P9_NONBLOCK
-
-struct p9_conn;
-struct p9_req;
-
-/**
- * p9_mux_req_callback - callback function that is called when the
- * response of a request is received. The callback is called from
- * a workqueue and shouldn't block.
- *
- * @req - request
- * @a - the pointer that was specified when the request was send to be
- *      passed to the callback
- */
-typedef void (*p9_conn_req_callback)(struct p9_req *req, void *a);
-
-struct p9_conn *p9_conn_create(struct p9_trans *trans, int msize,
-							unsigned char *dotu);
-void p9_conn_destroy(struct p9_conn *);
-int p9_conn_rpc(struct p9_conn *m, struct p9_fcall *tc, struct p9_fcall **rc);
-
-#ifdef P9_NONBLOCK
-int p9_conn_rpcnb(struct p9_conn *m, struct p9_fcall *tc,
-	p9_conn_req_callback cb, void *a);
-#endif /* P9_NONBLOCK */
-
-void p9_conn_cancel(struct p9_conn *m, int err);
-
-#endif /* NET_9P_CONN_H */
diff --git a/include/net/9p/transport.h b/include/net/9p/transport.h
index 9dd4a05..b8eecc9 100644
--- a/include/net/9p/transport.h
+++ b/include/net/9p/transport.h
@@ -26,19 +26,36 @@
 #ifndef NET_9P_TRANSPORT_H
 #define NET_9P_TRANSPORT_H
 
-enum p9_trans_status {
-	Connected,
-	Disconnected,
-	Hung,
+struct p9_trans;
+
+struct p9_trans_req {
+	u16			tag;
+	int			err;
+	struct p9_fcall		*tc;
+	struct p9_fcall		*rc;
+	void			(*cb)(struct p9_trans *, struct p9_trans_req *);
+	void			*cba;
+
+	void			*aux;	/* transport specific */
+	struct list_head	req_list;
 };
 
 struct p9_trans {
-	enum p9_trans_status status;
-	void *priv;
-	int (*write) (struct p9_trans *, void *, int);
-	int (*read) (struct p9_trans *, void *, int);
-	void (*close) (struct p9_trans *);
-	unsigned int (*poll)(struct p9_trans *, struct poll_table_struct *);
+	int err;	/* 0 == connected */
+	u32 msize;
+	int dotu;	/* 9P2000.u */
+	void *aux;
+	void *priv;	/* transport specific */
+
+	/* The function schedules sending the data from the 'tc'
+	   over the transport. If the 'rc' is set, the response is
+	   read in it and the 'cb' is called.
+	*/
+	void (*request)(struct p9_trans *trans, struct p9_trans_req *req);
+
+	/* If the request is not sent down the wire, don't send it. */
+	int (*cancel)(struct p9_trans *trans, struct p9_trans_req *req);
+	void (*destroy)(struct p9_trans *trans);
 };
 
 struct p9_trans_module {
diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index eecbf12..2af8e97 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -13,15 +13,15 @@ menuconfig NET_9P
 
 	  If unsure, say N.
 
-config NET_9P_FD
-	depends on NET_9P
-	default y if NET_9P
-	tristate "9P File Descriptor Transports (Experimental)"
-	help
-	  This builds support for file descriptor transports for 9p
-	  which includes support for TCP/IP, named pipes, or passed
-	  file descriptors.  TCP/IP is the default transport for 9p,
-	  so if you are going to use 9p, you'll likely want this.
+#config NET_9P_FD
+#	depends on NET_9P
+#	default y if NET_9P
+#	tristate "9P File Descriptor Transports (Experimental)"
+#	help
+#	  This builds support for file descriptor transports for 9p
+#	  which includes support for TCP/IP, named pipes, or passed
+#	  file descriptors.  TCP/IP is the default transport for 9p,
+#	  so if you are going to use 9p, you'll likely want this.
 
 config NET_9P_DEBUG
 	bool "Debug information"
diff --git a/net/9p/Makefile b/net/9p/Makefile
index 5059bc0..258a7d3 100644
--- a/net/9p/Makefile
+++ b/net/9p/Makefile
@@ -3,7 +3,6 @@ obj-$(CONFIG_NET_9P_FD) += 9pnet_fd.o
 
 9pnet-objs := \
 	mod.o \
-	mux.o \
 	client.o \
 	conv.o \
 	error.o \
diff --git a/net/9p/client.c b/net/9p/client.c
index af91993..63d266d 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -32,9 +32,24 @@
 #include <net/9p/9p.h>
 #include <linux/parser.h>
 #include <net/9p/transport.h>
-#include <net/9p/conn.h>
 #include <net/9p/client.h>
 
+#define ERRFLUSH	1
+
+struct p9_client_req {
+	unsigned long		status;
+	atomic_t		refcount;
+	struct p9_client	*clnt;
+	void			(*cb)(struct p9_trans_req *);
+	struct p9_trans_req	req;
+};
+
+enum {
+	/* request status */
+	Respond = 1,
+	Flushed = 2,
+};
+
 static struct p9_fid *p9_fid_create(struct p9_client *clnt);
 static void p9_fid_destroy(struct p9_fid *fid);
 static struct p9_stat *p9_clone_stat(struct p9_stat *st, int dotu);
@@ -50,6 +65,8 @@ struct p9_client *p9_client_create(struct p9_trans *trans, int msize,
 	err = 0;
 	tc = NULL;
 	rc = NULL;
+	trans->msize = msize;
+	trans->dotu = dotu;
 	clnt = kmalloc(sizeof(struct p9_client), GFP_KERNEL);
 	if (!clnt)
 		return ERR_PTR(-ENOMEM);
@@ -61,6 +78,7 @@ struct p9_client *p9_client_create(struct p9_trans *trans, int msize,
 	clnt->msize = msize;
 	clnt->dotu = dotu;
 	INIT_LIST_HEAD(&clnt->fidlist);
+	clnt->tagpool = NULL;
 	clnt->fidpool = p9_idpool_create();
 	if (!clnt->fidpool) {
 		err = PTR_ERR(clnt->fidpool);
@@ -68,10 +86,10 @@ struct p9_client *p9_client_create(struct p9_trans *trans, int msize,
 		goto error;
 	}
 
-	clnt->conn = p9_conn_create(clnt->trans, clnt->msize, &clnt->dotu);
-	if (IS_ERR(clnt->conn)) {
-		err = PTR_ERR(clnt->conn);
-		clnt->conn = NULL;
+	clnt->tagpool = p9_idpool_create();
+	if (!clnt->tagpool) {
+		err = PTR_ERR(clnt->tagpool);
+		clnt->tagpool = NULL;
 		goto error;
 	}
 
@@ -82,7 +100,7 @@ struct p9_client *p9_client_create(struct p9_trans *trans, int msize,
 		goto error;
 	}
 
-	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	err = p9_client_rpc(clnt, tc, &rc);
 	if (err)
 		goto error;
 
@@ -100,6 +118,8 @@ struct p9_client *p9_client_create(struct p9_trans *trans, int msize,
 	if (n < clnt->msize)
 		clnt->msize = n;
 
+	trans->dotu = clnt->dotu;
+	trans->msize = clnt->msize;
 	kfree(tc);
 	kfree(rc);
 	return clnt;
@@ -117,13 +137,8 @@ void p9_client_destroy(struct p9_client *clnt)
 	struct p9_fid *fid, *fidptr;
 
 	P9_DPRINTK(P9_DEBUG_9P, "clnt %p\n", clnt);
-	if (clnt->conn) {
-		p9_conn_destroy(clnt->conn);
-		clnt->conn = NULL;
-	}
-
 	if (clnt->trans) {
-		clnt->trans->close(clnt->trans);
+		(*clnt->trans->destroy)(clnt->trans);
 		kfree(clnt->trans);
 		clnt->trans = NULL;
 	}
@@ -134,6 +149,9 @@ void p9_client_destroy(struct p9_client *clnt)
 	if (clnt->fidpool)
 		p9_idpool_destroy(clnt->fidpool);
 
+	if (clnt->tagpool)
+		p9_idpool_destroy(clnt->tagpool);
+
 	kfree(clnt);
 }
 EXPORT_SYMBOL(p9_client_destroy);
@@ -141,8 +159,7 @@ EXPORT_SYMBOL(p9_client_destroy);
 void p9_client_disconnect(struct p9_client *clnt)
 {
 	P9_DPRINTK(P9_DEBUG_9P, "clnt %p\n", clnt);
-	clnt->trans->status = Disconnected;
-	p9_conn_cancel(clnt->conn, -EIO);
+	clnt->trans->err = -EIO;
 }
 EXPORT_SYMBOL(p9_client_disconnect);
 
@@ -174,7 +191,7 @@ struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
 		goto error;
 	}
 
-	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	err = p9_client_rpc(clnt, tc, &rc);
 	if (err)
 		goto error;
 
@@ -219,7 +236,7 @@ struct p9_fid *p9_client_auth(struct p9_client *clnt, char *uname,
 		goto error;
 	}
 
-	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	err = p9_client_rpc(clnt, tc, &rc);
 	if (err)
 		goto error;
 
@@ -270,7 +287,7 @@ struct p9_fid *p9_client_walk(struct p9_fid *oldfid, int nwname, char **wnames,
 		goto error;
 	}
 
-	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	err = p9_client_rpc(clnt, tc, &rc);
 	if (err) {
 		if (rc && rc->id == P9_RWALK)
 			goto clunk_fid;
@@ -305,7 +322,7 @@ clunk_fid:
 		goto error;
 	}
 
-	p9_conn_rpc(clnt->conn, tc, &rc);
+	p9_client_rpc(clnt, tc, &rc);
 
 error:
 	kfree(tc);
@@ -339,7 +356,7 @@ int p9_client_open(struct p9_fid *fid, int mode)
 		goto done;
 	}
 
-	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	err = p9_client_rpc(clnt, tc, &rc);
 	if (err)
 		goto done;
 
@@ -378,7 +395,7 @@ int p9_client_fcreate(struct p9_fid *fid, char *name, u32 perm, int mode,
 		goto done;
 	}
 
-	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	err = p9_client_rpc(clnt, tc, &rc);
 	if (err)
 		goto done;
 
@@ -411,7 +428,7 @@ int p9_client_clunk(struct p9_fid *fid)
 		goto done;
 	}
 
-	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	err = p9_client_rpc(clnt, tc, &rc);
 	if (err)
 		goto done;
 
@@ -443,7 +460,7 @@ int p9_client_remove(struct p9_fid *fid)
 		goto done;
 	}
 
-	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	err = p9_client_rpc(clnt, tc, &rc);
 	if (err)
 		goto done;
 
@@ -485,7 +502,7 @@ int p9_client_read(struct p9_fid *fid, char *data, u64 offset, u32 count)
 			goto error;
 		}
 
-		err = p9_conn_rpc(clnt->conn, tc, &rc);
+		err = p9_client_rpc(clnt, tc, &rc);
 		if (err)
 			goto error;
 
@@ -542,7 +559,7 @@ int p9_client_write(struct p9_fid *fid, char *data, u64 offset, u32 count)
 			goto error;
 		}
 
-		err = p9_conn_rpc(clnt->conn, tc, &rc);
+		err = p9_client_rpc(clnt, tc, &rc);
 		if (err)
 			goto error;
 
@@ -596,7 +613,7 @@ p9_client_uread(struct p9_fid *fid, char __user *data, u64 offset, u32 count)
 			goto error;
 		}
 
-		err = p9_conn_rpc(clnt->conn, tc, &rc);
+		err = p9_client_rpc(clnt, tc, &rc);
 		if (err)
 			goto error;
 
@@ -660,7 +677,7 @@ p9_client_uwrite(struct p9_fid *fid, const char __user *data, u64 offset,
 			goto error;
 		}
 
-		err = p9_conn_rpc(clnt->conn, tc, &rc);
+		err = p9_client_rpc(clnt, tc, &rc);
 		if (err)
 			goto error;
 
@@ -731,7 +748,7 @@ struct p9_stat *p9_client_stat(struct p9_fid *fid)
 		goto error;
 	}
 
-	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	err = p9_client_rpc(clnt, tc, &rc);
 	if (err)
 		goto error;
 
@@ -773,7 +790,7 @@ int p9_client_wstat(struct p9_fid *fid, struct p9_wstat *wst)
 		goto done;
 	}
 
-	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	err = p9_client_rpc(clnt, tc, &rc);
 
 done:
 	kfree(tc);
@@ -830,7 +847,7 @@ struct p9_stat *p9_client_dirread(struct p9_fid *fid, u64 offset)
 				goto error;
 			}
 
-			err = p9_conn_rpc(clnt->conn, tc, &rc);
+			err = p9_client_rpc(clnt, tc, &rc);
 			if (err)
 				goto error;
 
@@ -966,3 +983,261 @@ static void p9_fid_destroy(struct p9_fid *fid)
 	kfree(fid->rdir_fcall);
 	kfree(fid);
 }
+
+static struct p9_trans_req *p9_client_req_create(struct p9_client *clnt,
+	struct p9_fcall *tc, struct p9_fcall *rc,
+	void (*cb)(struct p9_trans_req *))
+{
+	int err, tag;
+	struct p9_client_req *creq;
+
+	creq = kmalloc(sizeof(*creq), GFP_KERNEL);
+	if (!creq)
+		return ERR_PTR(-ENOMEM);
+
+	if (tc->id != P9_TVERSION)
+		tag = p9_idpool_get(clnt->tagpool);
+	else
+		tag = P9_NOTAG;
+
+	if (tag < 0) {
+		kfree(creq);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	creq->clnt = clnt;
+	creq->status = 0;
+	atomic_set(&creq->refcount, 1);
+	creq->cb = cb;
+	creq->req.tag = tag;
+	creq->req.err = 0;
+	creq->req.tc = tc;
+	p9_set_tag(tc, tag);
+
+	if (rc)
+		creq->req.rc = rc;
+	else
+		creq->req.rc = p9_fcall_alloc(clnt->msize);
+
+	if (IS_ERR(creq->req.rc)) {
+		err = PTR_ERR(creq->req.rc);
+		if (tag != P9_NOTAG)
+			p9_idpool_put(tag, clnt->tagpool);
+		kfree(creq);
+		return ERR_PTR(err);
+	}
+
+	creq->req.cb = NULL;
+	creq->req.cba = NULL;
+	creq->req.aux = NULL;
+	INIT_LIST_HEAD(&creq->req.req_list);
+
+	return &creq->req;
+}
+
+void p9_client_req_incref(struct p9_trans_req *req)
+{
+	struct p9_client_req *creq;
+
+	creq = container_of(req, struct p9_client_req, req);
+	atomic_inc(&creq->refcount);
+}
+EXPORT_SYMBOL(p9_client_req_incref);
+
+void p9_client_req_decref(struct p9_trans_req *req)
+{
+	struct p9_client_req *creq;
+
+	creq = container_of(req, struct p9_client_req, req);
+	if (!atomic_dec_and_test(&creq->refcount))
+		return;
+
+	kfree(creq);
+}
+EXPORT_SYMBOL(p9_client_req_decref);
+
+static void p9_client_rpcnb_cb(struct p9_trans *trans, struct p9_trans_req *req)
+{
+	struct p9_str *ename;
+	struct p9_client_req *creq;
+	struct p9_client *clnt;
+
+	p9_client_req_incref(req);
+	creq = container_of(req, struct p9_client_req, req);
+	clnt = creq->clnt;
+
+	if (test_and_set_bit(Respond, &creq->status))
+		return;
+
+#ifdef CONFIG_NET_9P_DEBUG
+	if (!req->err && req->rc &&
+			(p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
+		char buf[150];
+
+		p9_printfcall(buf, sizeof(buf), req->rc, clnt->dotu);
+		printk(KERN_NOTICE "<<< %s\n", buf);
+	}
+#endif
+
+	if (req->rc && req->rc->id == P9_RERROR && !req->err) {
+		if (clnt->dotu)
+			req->err = -req->rc->params.rerror.errno;
+
+		if (!req->err) {
+			ename = &req->rc->params.rerror.error;
+			req->err = p9_errstr2errno(ename->str, ename->len);
+
+			if (!req->err) {
+				P9_DPRINTK(P9_DEBUG_ERROR, "unknown err: %.*s",
+					ename->len, ename->str);
+
+				req->err = -ESERVERFAULT;
+			}
+		}
+	} else if (req->rc && req->rc->id != req->tc->id + 1) {
+		P9_DPRINTK(P9_DEBUG_ERROR,
+			"fcall mismatch: expected %d got %d\n",
+			req->tc->id + 1, req->rc->id);
+
+		req->err = -EIO;
+	}
+
+	(*creq->cb)(req);
+	if (req->tag != P9_NOTAG)
+		p9_idpool_put(req->tag, clnt->tagpool);
+
+	p9_client_req_decref(req);
+}
+
+struct p9_trans_req *p9_client_rpcnb(struct p9_client *clnt,
+	struct p9_fcall *tc, struct p9_fcall *rc,
+	void (*cb)(struct p9_trans_req *), void *cba)
+{
+	struct p9_trans_req *req;
+
+	req = p9_client_req_create(clnt, tc, rc, cb);
+	if (IS_ERR(req))
+		return req;
+
+	req->cb = p9_client_rpcnb_cb;
+	req->cba = cba;
+
+#ifdef CONFIG_NET_9P_DEBUG
+		if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
+			char buf[150];
+
+			p9_printfcall(buf, sizeof(buf), tc, clnt->dotu);
+			printk(KERN_NOTICE ">>> %s\n", buf);
+		}
+#endif
+
+	(*clnt->trans->request)(clnt->trans, req);
+	if (clnt->trans->err < 0) {
+		p9_client_req_decref(req);
+		req = ERR_PTR(clnt->trans->err);
+	}
+
+	return req;
+}
+EXPORT_SYMBOL(p9_client_rpcnb);
+
+static void p9_client_flush_cb(struct p9_trans_req *freq)
+{
+	struct p9_trans_req *req;
+	struct p9_client_req *creq;
+
+	req = freq->cba;
+	creq = container_of(req, struct p9_client_req, req);
+	P9_DPRINTK(P9_DEBUG_9P, "tag %d status %02lx\n", req->tag, creq->status);
+	req->err = ERRFLUSH;
+	(*req->cb)(creq->clnt->trans, req);
+	p9_client_req_decref(req);
+	p9_client_req_decref(freq);
+}
+
+void p9_client_flush_req(struct p9_trans_req *req)
+{
+	struct p9_fcall *tc;
+	struct p9_client_req *creq;
+
+	creq = container_of(req, struct p9_client_req, req);
+	if (test_and_set_bit(Flushed, &creq->status))
+		return;
+
+	p9_client_req_incref(req);
+	tc = p9_create_tflush(req->tag);
+	p9_client_rpcnb(creq->clnt, tc, NULL, p9_client_flush_cb, req);
+}
+EXPORT_SYMBOL(p9_client_flush_req);
+
+static void p9_client_rpc_cb(struct p9_trans_req *req)
+{
+	wait_queue_head_t *wqueue;
+
+	wqueue = req->cba;
+	wake_up(wqueue);
+}
+
+int p9_client_rpc(struct p9_client *clnt, struct p9_fcall *tc,
+	struct p9_fcall **prc)
+{
+	int err, sigpending, flushed;
+	unsigned long flags;
+	struct p9_trans_req *req;
+	struct p9_client_req *creq;
+	struct p9_fcall *rc;
+	wait_queue_head_t wqueue;
+
+	flushed = 0;
+	if (signal_pending(current)) {
+		sigpending = 1;
+		clear_thread_flag(TIF_SIGPENDING);
+	} else
+		sigpending = 0;
+
+	init_waitqueue_head(&wqueue);
+
+	if (prc && *prc)
+		rc = *prc;
+	else
+		rc = NULL;
+
+	req = p9_client_rpcnb(clnt, tc, rc, p9_client_rpc_cb, &wqueue);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	creq = container_of(req, struct p9_client_req, req);
+
+again:
+	err = wait_event_interruptible(wqueue,
+		test_bit(Respond, &creq->status) || req->err != 0);
+
+	if (req->err < 0)
+		err = req->err;
+	else if (req->err == ERRFLUSH)
+		err = -ERESTARTSYS;
+
+	if (err == -ERESTARTSYS && !clnt->trans->err && !req->err &&
+								!flushed) {
+		sigpending = 1;
+		flushed = 1;
+		clear_thread_flag(TIF_SIGPENDING);
+		p9_client_flush_req(req);
+		goto again;
+	}
+
+	if (sigpending) {
+		spin_lock_irqsave(&current->sighand->siglock, flags);
+		recalc_sigpending();
+		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+	}
+
+	if (prc)
+		*prc = req->rc;
+	else
+		kfree(req->rc);
+
+	p9_client_req_decref(req);
+	return err;
+}
+EXPORT_SYMBOL(p9_client_rpc);
diff --git a/net/9p/conv.c b/net/9p/conv.c
index aa2aa98..3627753 100644
--- a/net/9p/conv.c
+++ b/net/9p/conv.c
@@ -130,7 +130,7 @@ static char *buf_put_stringn(struct cbuf *buf, const char *s, u16 slen)
 
 static inline void buf_put_string(struct cbuf *buf, const char *s)
 {
-	buf_put_stringn(buf, s, strlen(s));
+	buf_put_stringn(buf, s, s?strlen(s):0);
 }
 
 static u8 buf_get_int8(struct cbuf *buf)
@@ -496,6 +496,20 @@ p9_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
 	}
 }
 
+struct p9_fcall *p9_fcall_alloc(u32 size)
+{
+	struct p9_fcall *fc;
+
+	fc = kmalloc(sizeof(struct p9_fcall) + size, GFP_KERNEL);
+	if (!fc)
+		return ERR_PTR(-ENOMEM);
+
+	fc->size = size;
+	fc->sdata = (char *)fc + sizeof(*fc);
+	return fc;
+}
+EXPORT_SYMBOL(p9_fcall_alloc);
+
 static struct p9_fcall *
 p9_create_common(struct cbuf *bufp, u32 size, u8 id)
 {
diff --git a/net/9p/mod.c b/net/9p/mod.c
index 623556a..ac07787 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -49,9 +49,6 @@ static struct subsys_attribute p9_debug_attr = __ATTR(debuglevel, 0644,
 decl_subsys_name(p9, 9p, NULL, NULL);
 EXPORT_SYMBOL(p9_subsys);
 
-extern int p9_mux_global_init(void);
-extern void p9_mux_global_exit(void);
-
 /*
  * Dynamic Transport Registration Routines
  *
@@ -154,13 +151,7 @@ static int __init init_p9(void)
 #endif
 
 	printk(KERN_INFO "Installing 9P2000 support\n");
-	ret = p9_mux_global_init();
-	if (ret) {
-		printk(KERN_WARNING "9p: starting mux failed\n");
-		return ret;
-	}
-
-	return ret;
+	return 0;
 }
 
 /**
@@ -170,7 +161,6 @@ static int __init init_p9(void)
 
 static void __exit exit_p9(void)
 {
-	p9_mux_global_exit();
 	subsystem_unregister(&p9_subsys);
 }
 
