Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbXI3XHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbXI3XHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbXI3XFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:05:35 -0400
Received: from 70-56-134-241.albq.qwest.net ([70.56.134.241]:57198 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753116AbXI3XFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:05:14 -0400
Date: Sun, 30 Sep 2007 16:42:33 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ericvh@gmail.com
Subject: [RFC][PATCH 5/6] 9p: 9P server TCP socket connection support
Message-ID: <20070930224233.GE25590@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides support for in-kernel 9P2000 servers.

Support for 9P servers listening on TCP sockets.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
---
 net/9p/srv/socksrv.c |  252 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 252 insertions(+), 0 deletions(-)
 create mode 100644 net/9p/srv/socksrv.c

diff --git a/net/9p/srv/socksrv.c b/net/9p/srv/socksrv.c
new file mode 100644
index 0000000..c304b91
--- /dev/null
+++ b/net/9p/srv/socksrv.c
@@ -0,0 +1,252 @@
+/*
+ * net/9p/srv/socksrv.c
+ *
+ * 9P Socket Server
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
+#include <linux/net.h>
+#include <linux/in.h>
+#include <linux/parser.h>
+#include <net/tcp.h>
+#include <net/sock.h>
+#include <net/9p/9p.h>
+#include <net/9p/transport.h>
+#include <net/9p/srv.h>
+#include "srvimpl.h"
+
+struct p9srv_socksrv {
+	struct sockaddr_in	saddr;
+	struct socket		*sock;
+	struct p9srv		*srv;
+	struct work_struct	wq;
+};
+
+void (*p9srv_socksrv_dr_save)(struct sock *sock, int count);
+
+static void p9srv_socksrv_start(struct p9srv *);
+static void p9srv_socksrv_stop(struct p9srv *);
+static void p9srv_socksrv_destroy(struct p9srv *);
+static void p9srv_socksrv_data_ready(struct sock *sock, int count);
+static void p9srv_socksrv_accept(struct work_struct *work);
+
+struct p9srv *p9srv_socksrv_create(int port)
+{
+	int n, err;
+	struct p9srv_socksrv *ss;
+	struct p9srv *srv;
+
+	srv = NULL;
+	ss = kmalloc(sizeof(struct p9srv_socksrv), GFP_KERNEL);
+	if (!ss)
+		return ERR_PTR(-ENOMEM);
+
+	ss->sock = NULL;
+	err = sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &ss->sock);
+	if (!ss->sock) {
+		P9_DPRINTK(P9SRV_DEBUG_SRV, "cannot create socket %d\n", err);
+		goto error;
+	}
+
+	n = 1;
+	ss->saddr.sin_family = AF_INET;
+	memset(&ss->saddr.sin_zero, 0, sizeof(ss->saddr.sin_zero));
+	ss->saddr.sin_addr.s_addr = htonl(INADDR_ANY);
+	ss->saddr.sin_port = htons(port);
+	err = ss->sock->ops->bind(ss->sock, (struct sockaddr *) &ss->saddr,
+		sizeof(ss->saddr));
+	if (err < 0) {
+		P9_DPRINTK(P9SRV_DEBUG_SRV, "cannot create bind %d\n", err);
+		goto error;
+	}
+
+	err = kernel_setsockopt(ss->sock, SOL_SOCKET, SO_REUSEADDR, (char *) &n,
+		sizeof(n));
+	if (err < 0) {
+		P9_DPRINTK(P9SRV_DEBUG_SRV, "cannot create setsockopt\n");
+		goto error;
+	}
+
+	srv = p9srv_srv_create();
+	if (!srv) {
+		err = PTR_ERR(srv);
+		srv = NULL;
+		goto error;
+	}
+
+	ss->srv = srv;
+	INIT_WORK(&ss->wq, p9srv_socksrv_accept);
+	srv->srvaux = ss;
+	srv->start = p9srv_socksrv_start;
+	srv->stop = p9srv_socksrv_stop;
+	srv->destroy = p9srv_socksrv_destroy;
+
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "server %p on port %d created\n",
+		srv, port);
+	return srv;
+
+error:
+	if (ss->sock)
+		sock_release(ss->sock);
+
+	if (srv)
+		p9srv_srv_destroy(srv);
+
+	kfree(ss);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(p9srv_socksrv_create);
+
+static void p9srv_socksrv_start(struct p9srv *srv)
+{
+	int err;
+	struct p9srv_socksrv *ss;
+
+	ss = srv->srvaux;
+	err = ss->sock->ops->listen(ss->sock, 5);
+	if (err < 0) {
+		P9_DPRINTK(P9SRV_DEBUG_SRV, "cannot listen %d\n", err);
+		return;
+	}
+
+	p9srv_socksrv_dr_save = ss->sock->sk->sk_data_ready;
+	ss->sock->sk->sk_data_ready = p9srv_socksrv_data_ready;
+	ss->sock->sk->sk_user_data = srv;
+}
+
+static void p9srv_socksrv_stop(struct p9srv *srv)
+{
+	struct p9srv_socksrv *ss;
+
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "srv %p\n", srv);
+	ss = srv->srvaux;
+	if (ss->sock) {
+		ss->sock->ops->shutdown(ss->sock, 2);
+		sock_release(ss->sock);
+		ss->sock = NULL;
+	}
+
+	ss->sock = NULL;
+}
+
+static void p9srv_socksrv_destroy(struct p9srv *srv)
+{
+	struct p9srv_socksrv *ss;
+
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "srv %p\n", srv);
+	ss = srv->srvaux;
+	if (ss->sock) {
+		ss->sock->ops->shutdown(ss->sock, 2);
+		sock_release(ss->sock);
+		ss->sock = NULL;
+	}
+
+	kfree(ss);
+}
+
+static void p9srv_socksrv_data_ready(struct sock *sock, int count)
+{
+	struct p9srv *srv;
+	struct p9srv_socksrv *ss;
+
+	srv = sock->sk_user_data;
+	if (!srv) {
+		(*p9srv_socksrv_dr_save)(sock, count);
+		return;
+	}
+
+	ss = srv->srvaux;
+	queue_work(p9srv_wq, &ss->wq);
+}
+
+static void p9srv_socksrv_accept(struct work_struct *work)
+{
+	int err, fd;
+	struct p9srv *srv;
+	struct p9srv_socksrv *ss;
+	struct socket *sock;
+	struct p9_trans *trans;
+	struct p9srv_conn *conn;
+	struct p9_trans_module *tmod;
+	substring_t tname;
+	char buf[64];
+
+	ss = container_of(work, struct p9srv_socksrv, wq);
+	srv = ss->srv;
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "srv %p\n", srv);
+
+	tname.from = "fd";
+	tname.to = tname.from + strlen(tname.from);
+	tmod = v9fs_match_trans(&tname);
+	if (!tmod) {
+		P9_EPRINTK(KERN_ERR,
+			"p9srv_socksrv_accept: fd transport not registered\n");
+		return;
+	}
+
+	err = sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
+	if (!sock) {
+		P9_EPRINTK(KERN_ERR,
+			"p9srv_socksrv_accept: cannot create socket %d\n", err);
+		return;
+	}
+
+	sock->type = ss->sock->type;
+	sock->ops = ss->sock->ops;
+	err = ss->sock->ops->accept(ss->sock, sock, 0);
+	if (err) {
+		P9_EPRINTK(KERN_ERR,
+			"p9srv_socksrv_accept: cannot accept %d\n", err);
+		return;
+	}
+
+	sock->sk->sk_data_ready = p9srv_socksrv_dr_save;
+	sock->sk->sk_user_data = NULL;
+	sock->sk->sk_allocation = GFP_NOIO;
+
+	fd = sock_map_fd(sock);
+	if (fd < 0) {
+		P9_EPRINTK(KERN_ERR,
+			"p9srv_socksrv_accept: cannot map fd %d\n", fd);
+		return;
+	}
+
+	snprintf(buf, sizeof(buf), "rfdno=%d,wfdno=%d", fd, fd);
+	trans = (*tmod->create)(NULL, buf);
+	if (IS_ERR(trans)) {
+		P9_EPRINTK(KERN_ERR,
+			"p9srv_socksrv_accept: cannot create trans %ld\n",
+			PTR_ERR(trans));
+		return;
+	}
+
+	conn = p9srv_conn_create(srv, trans);
+	if (IS_ERR(conn)) {
+		P9_EPRINTK(KERN_ERR,
+			"p9srv_socksrv_accept: cannot create conn %ld\n",
+			PTR_ERR(conn));
+		return;
+	}
+}
-- 
1.5.2.4

