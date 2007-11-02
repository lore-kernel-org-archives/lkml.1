Return-Path: <linux-kernel-owner+w=401wt.eu-S1759740AbXKBRIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740AbXKBRIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760171AbXKBRIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:08:21 -0400
Received: from 71-33-33-68.albq.qwest.net ([71.33.33.68]:45754 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760151AbXKBRIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:08:18 -0400
Date: Fri, 2 Nov 2007 11:08:17 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/10] 9p: tcp listener implementation
Message-ID: <20071102170817.GJ16063@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a TCP listener for the trans_fd transport. The listener
allows the in-kernel servers to listen on a TCP port for client connections.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
 net/9p/mux.c |  269 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 265 insertions(+), 4 deletions(-)

diff --git a/net/9p/mux.c b/net/9p/mux.c
index ace135a..ad2e9a4 100644
--- a/net/9p/mux.c
+++ b/net/9p/mux.c
@@ -64,6 +64,7 @@ struct p9_trans_fd {
 	struct file *rd;	/* read descriptor */
 	struct file *wr;	/* write descriptor */
 	u32 msize;
+	int client;		/* non-zero if client transport */
 	struct list_head trans_list;
 	struct p9fd_poll_task *poll_task;
 	wait_queue_head_t equeue;
@@ -90,6 +91,7 @@ enum {
 	Rpending = 2,		/* can read */
 	Wworksched = 4,		/* write work scheduled or running */
 	Wpending = 8,		/* can write */
+	Destroy = 9,
 };
 
 
@@ -112,6 +114,15 @@ enum {
 	Flushed,
 };
 
+struct p9fd_tcp_listener {
+	struct sockaddr_in		saddr;
+	struct socket			*sock;
+	struct p9_trans_listener	listener;
+	struct work_struct		wq;
+	void				(*dr_save)(struct sock *, int);
+	u32				msize;
+};
+
 enum {
 	/* Options that take integer arguments */
 	Opt_port, Opt_rfdno, Opt_wfdno, Opt_msize,
@@ -145,6 +156,10 @@ static struct p9_trans *p9fd_create_unix_client(const char *devname,
 		char *options);
 static struct p9_trans *p9fd_create_fd_client(const char *devname,
 		char *options);
+static struct p9_trans_listener *p9fd_listener_create(char *);
+static void p9fd_trans_listener_destroy(struct p9_trans_listener *);
+static void p9fd_tcp_data_ready(struct sock *sock, int count);
+static void p9fd_tcp_accept(struct work_struct *work);
 
 static DEFINE_MUTEX(p9fd_task_lock);
 static struct workqueue_struct *p9fd_wq;
@@ -158,6 +173,7 @@ static struct p9_trans_module p9_tcp_trans = {
 	.maxsize = MAX_SOCK_BUF,
 	.def = 1,
 	.create_client = p9fd_create_tcp_client,
+	.create_listener = p9fd_listener_create,
 };
 
 static struct p9_trans_module p9_unix_trans = {
@@ -292,8 +308,9 @@ static void p9fd_poll_stop(struct p9_trans_fd *trans)
  * @rfd - read file descriptor
  * @wfd - write file descriptor
  * @msize - maximum message size
+ * @client - nonzero if client transport
  */
-struct p9_trans *p9fd_trans_create(int rfd, int wfd, u32 msize)
+struct p9_trans *p9fd_trans_create(int rfd, int wfd, u32 msize, int client)
 {
 	int i, n, err;
 	struct p9_trans *trans;
@@ -317,6 +334,7 @@ struct p9_trans *p9fd_trans_create(int rfd, int wfd, u32 msize)
 	spin_lock_init(&ts->lock);
 	ts->trans = trans;
 	ts->msize = msize;
+	ts->client = client;
 	ts->rd = fget(rfd);
 	ts->wr = fget(wfd);
 	if (!ts->rd || !ts->wr) {
@@ -386,6 +404,9 @@ void p9fd_trans_destroy(struct p9_trans *trans)
 	struct p9_trans_fd *ts;
 
 	ts = trans->priv;
+	if (test_and_set_bit(Destroy, &ts->wsched))
+		return;
+
 	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p prev %p next %p\n", ts,
 		ts->trans_list.prev, ts->trans_list.next);
 	p9fd_trans_shutdown(ts, -ECONNRESET);
@@ -426,6 +447,9 @@ static void p9fd_trans_shutdown(struct p9_trans_fd *ts, int err)
 		(*fdreq->req->cb)(trans, fdreq->req);
 		kfree(fdreq);
 	}
+
+	if (!ts->client && !test_bit(Destroy, &ts->wsched))
+		(*trans->request)(trans, NULL);
 }
 
 /**
@@ -540,7 +564,11 @@ static void p9fd_fill_wbuf(struct p9_trans_fd *ts)
 		req = list_first_entry(&ts->unsent_req_list,
 			struct p9fd_trans_req, req_list);
 
-		tc = req->req->tc;
+		if (ts->client)
+			tc = req->req->tc;
+		else
+			tc = req->req->rc;
+
 		P9_DPRINTK(P9_DEBUG_TRANS, "tag %d size %d\n", tc->tag,
 			tc->size);
 		if (tc->size + ts->wsize > ts->msize) {
@@ -710,6 +738,9 @@ void p9fd_client_request(struct p9_trans *trans, struct p9_trans_req *req)
 	struct p9_trans_fd *ts;
 	struct p9fd_trans_req *fdreq;
 
+	if (trans->err)
+		return;
+
 	ts = trans->priv;
 	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p tag %d\n", ts, req->tag);
 	fdreq = p9fd_req_create(ts, req);
@@ -810,6 +841,94 @@ int p9fd_client_rcvd(struct p9_trans_fd *ts, u16 tag, int start, int count)
 	return 0;
 }
 
+int p9fd_server_sent(struct p9_trans_fd *ts, struct p9fd_trans_req *fdreq)
+{
+	struct p9_trans_req *req;
+
+	req = fdreq->req;
+	kfree(req->tc);
+	kfree(req->rc);
+	kfree(req);
+	kfree(fdreq);
+	return 0;
+}
+
+/* called when the server is ready with the response */
+void p9fd_server_respond(struct p9_trans *trans, struct p9_trans_req *req)
+{
+	int n;
+	struct p9_trans_fd *ts;
+	struct p9fd_trans_req *fdreq;
+ 
+	ts = trans->priv;
+	fdreq = req->cba;
+
+	spin_lock(&ts->lock);
+	list_move_tail(&fdreq->req_list, &ts->unsent_req_list);
+	spin_unlock(&ts->lock);
+
+	if (test_and_clear_bit(Wpending, &ts->wsched))
+		n = POLLOUT;
+	else
+		n = p9fd_poll(ts, NULL);
+
+	if (n & POLLOUT && !test_and_set_bit(Wworksched, &ts->wsched)) {
+		P9_DPRINTK(P9_DEBUG_TRANS, "schedule write work %p\n", ts);
+		queue_work(p9fd_wq, &ts->wq);
+	}
+}
+ 
+int p9fd_server_rcvd(struct p9_trans_fd *ts, u16 tag, int start, int count)
+{
+	int n;
+	struct p9_trans_req *req;
+	struct p9fd_trans_req *fdreq;
+
+	req = kmalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	fdreq = p9fd_req_create(ts, req);
+	if (IS_ERR(fdreq)) {
+		kfree(req);
+		return PTR_ERR(fdreq);
+	}
+
+	req->tag = tag;
+	req->err = 0;
+	req->tc = p9_fcall_alloc(count);
+	n = p9_fcall_put(req->tc, ts->rbuf + start, count);
+	if (n < 0)
+		goto error;
+
+	n = p9_deserialize_fcall(req->tc, ts->trans->dotu);
+	if (n < 0)
+		goto error;
+
+	req->rc = NULL;
+	req->cb = p9fd_server_respond;
+	req->cba = fdreq;
+
+	spin_lock(&ts->lock);
+	list_add_tail(&fdreq->req_list, &ts->req_list);
+	spin_unlock(&ts->lock);
+
+	(*ts->trans->request)(ts->trans, req);
+	return n;
+
+error:
+	kfree(req->tc);
+	kfree(req);
+	kfree(fdreq);
+
+	return n;
+}
+ 
+int p9fd_server_cancel(struct p9_trans *trans, struct p9_trans_req *req)
+{
+	return -ENOENT;
+}
+
 static struct p9fd_trans_req *p9fd_req_create(struct p9_trans_fd *trans,
 					struct p9_trans_req *req)
 {
@@ -982,7 +1101,7 @@ static struct p9_trans *p9fd_socket_open(struct socket *csocket, int msize)
 		return ERR_PTR(fd);
 	}
 
-	trans = p9fd_trans_create(fd, fd, msize);
+	trans = p9fd_trans_create(fd, fd, msize, 1);
 	if (IS_ERR(trans)) {
 		P9_EPRINTK(KERN_ERR, "p9_socket_open: failed to open fd\n");
 		sockfd_put(csocket);
@@ -1109,7 +1228,7 @@ static struct p9_trans *p9fd_create_fd_client(const char *name, char *args)
 		return ERR_PTR(-ENOPROTOOPT);
 	}
 
-	trans = p9fd_trans_create(opts.rfd, opts.wfd, opts.msize);
+	trans = p9fd_trans_create(opts.rfd, opts.wfd, opts.msize, 1);
 	if (IS_ERR(trans))
 		return trans;
 
@@ -1123,6 +1242,148 @@ static struct p9_trans *p9fd_create_fd_client(const char *name, char *args)
 	return trans;
 }
 
+static struct p9_trans_listener *p9fd_listener_create(char *options)
+{
+	int n, err;
+	struct p9fd_tcp_listener *ls;
+	struct p9_fd_opts opts;
+
+	P9_DPRINTK(P9_DEBUG_TRANS, "options '%s'\n", options);
+	parse_opts(options, &opts);
+	ls = kmalloc(sizeof(*ls), GFP_KERNEL);
+	if (!ls)
+		return ERR_PTR(-ENOMEM);
+
+	ls->listener.err = 0;
+	ls->listener.aux = NULL;
+	ls->listener.taux = ls;
+	ls->listener.newtrans = NULL;
+	ls->listener.destroy = p9fd_trans_listener_destroy;
+	INIT_WORK(&ls->wq, p9fd_tcp_accept);
+	ls->sock = NULL;
+	ls->msize = opts.msize;
+	err = sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &ls->sock);
+	if (!ls->sock) {
+		P9_DPRINTK(P9_DEBUG_TRANS, "cannot create socket %d\n", err);
+		goto error;
+	}
+
+	ls->saddr.sin_family = AF_INET;
+	memset(&ls->saddr.sin_zero, 0, sizeof(ls->saddr.sin_zero));
+	ls->saddr.sin_addr.s_addr = htonl(INADDR_ANY);
+	ls->saddr.sin_port = htons(opts.port);
+	err = ls->sock->ops->bind(ls->sock, (struct sockaddr *) &ls->saddr,
+		sizeof(ls->saddr));
+	if (err < 0) {
+		P9_DPRINTK(P9_DEBUG_TRANS, "cannot create bind %d\n", err);
+		goto error;
+	}
+
+	n = 1;
+	err = kernel_setsockopt(ls->sock, SOL_SOCKET, SO_REUSEADDR,
+		(char *) &n, sizeof(n));
+	if (err < 0) {
+		P9_DPRINTK(P9_DEBUG_TRANS, "cannot create setsockopt\n");
+		goto error;
+	}
+
+	err = ls->sock->ops->listen(ls->sock, 5);
+	if (err < 0) {
+		P9_DPRINTK(P9_DEBUG_TRANS, "cannot listen %d\n", err);
+		goto error;
+	}
+
+	ls->dr_save = ls->sock->sk->sk_data_ready;
+	ls->sock->sk->sk_data_ready = p9fd_tcp_data_ready;
+	ls->sock->sk->sk_user_data = ls;
+
+	return &ls->listener;
+
+error:
+	if (ls->sock)
+		sock_release(ls->sock);
+
+	kfree(ls);
+	return ERR_PTR(err);
+}
+
+static void p9fd_trans_listener_destroy(struct p9_trans_listener *lis)
+{
+	struct p9fd_tcp_listener *ls;
+
+	ls = container_of(lis, struct p9fd_tcp_listener, listener);
+	if (ls->sock) {
+		ls->sock->ops->shutdown(ls->sock, 2);
+		sock_release(ls->sock);
+		ls->sock = NULL;
+	}
+
+	kfree(ls);
+}
+
+static void p9fd_tcp_data_ready(struct sock *sock, int count)
+{
+	struct p9fd_tcp_listener *ls;
+
+	ls = sock->sk_user_data;
+	BUG_ON(ls == NULL);
+	queue_work(p9fd_wq, &ls->wq);
+}
+
+static void p9fd_tcp_accept(struct work_struct *work)
+{
+	int err, fd;
+	struct p9fd_tcp_listener *ls;
+	struct socket *sock;
+	struct p9_trans *trans;
+	struct p9_trans_fd *ts;
+
+	ls = container_of(work, struct p9fd_tcp_listener, wq);
+	err = sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
+	if (!sock) {
+		P9_DPRINTK(P9_DEBUG_TRANS, "cannot create socket %d\n", err);
+		goto error;
+	}
+
+	sock->type = ls->sock->type;
+	sock->ops = ls->sock->ops;
+	err = ls->sock->ops->accept(ls->sock, sock, 0);
+	if (err) {
+		P9_DPRINTK(P9_DEBUG_TRANS, "cannot accept %d\n", err);
+		goto error;
+	}
+
+	sock->sk->sk_data_ready = ls->dr_save;
+	sock->sk->sk_user_data = NULL;
+	sock->sk->sk_allocation = GFP_NOIO;
+
+	fd = sock_map_fd(sock);
+	if (fd < 0) {
+		err = fd;
+		P9_DPRINTK(P9_DEBUG_TRANS, "cannot map fd %d\n", err);
+		goto error;
+	}
+
+	trans = p9fd_trans_create(fd, fd, ls->msize, 0);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		P9_DPRINTK(P9_DEBUG_TRANS, "cannot create trans %d\n", err);
+		goto error;
+	}
+
+	trans->request = NULL;
+	trans->cancel = p9fd_server_cancel;
+	trans->destroy = p9fd_trans_destroy;
+	ts = trans->priv;
+	ts->sent = p9fd_server_sent;
+	ts->rcvd = p9fd_server_rcvd;
+	(*ls->listener.newtrans)(&ls->listener, trans);
+
+error:
+	ls->listener.err = err;
+	(*ls->listener.newtrans)(&ls->listener, NULL);
+}
+
 static int __init p9_trans_fd_init(void)
 {
 	int i;
