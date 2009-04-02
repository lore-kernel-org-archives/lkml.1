Return-Path: <linux-kernel-owner+w=401wt.eu-S932759AbZDBXiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbZDBXiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932593AbZDBXhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:37:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:21475 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbZDBXhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Mhoew9QCC9Q8QXpAvF5KWkb7TrCgFQB5/JrV0M3BJHBl4Uqmnv5lYcBmfBqxwMz8nx
         IGnsJhpz3/F19DwToSf/PoP8tGwr4dMzSJvyGO1sRkX322iwl2cVU9x3A7lWZOMZsZ9x
         ADVe9+rIUOMq+fLZLrQ6FayhyH/e9jMajaV6Q=
Date: Thu, 2 Apr 2009 17:37:07 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] net/9p: handle correctly interrupted 9P requests
Message-ID: <20090402233707.GB7842@mallorn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the 9p code crashes when a operation is interrupted, i.e. for
example when the user presses ^C while reading from a file.

This patch fixes the code that is responsible for interruption and flushing
of 9P operations.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 4012e07..e268122 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -98,7 +98,6 @@ enum p9_req_status_t {
 struct p9_req_t {
 	int status;
 	int t_err;
-	u16 flush_tag;
 	wait_queue_head_t *wq;
 	struct p9_fcall *tc;
 	struct p9_fcall *rc;
diff --git a/net/9p/client.c b/net/9p/client.c
index c079df6..f5634b5 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -203,7 +203,6 @@ static struct p9_req_t *p9_tag_alloc(struct p9_client *c, u16 tag)
 	p9pdu_reset(req->tc);
 	p9pdu_reset(req->rc);
 
-	req->flush_tag = 0;
 	req->tc->tag = tag-1;
 	req->status = REQ_STATUS_ALLOC;
 
@@ -324,35 +323,9 @@ static void p9_free_req(struct p9_client *c, struct p9_req_t *r)
  */
 void p9_client_cb(struct p9_client *c, struct p9_req_t *req)
 {
-	struct p9_req_t *other_req;
-	unsigned long flags;
-
 	P9_DPRINTK(P9_DEBUG_MUX, " tag %d\n", req->tc->tag);
-
-	if (req->status == REQ_STATUS_ERROR)
-		wake_up(req->wq);
-
-	if (req->flush_tag) { 			/* flush receive path */
-		P9_DPRINTK(P9_DEBUG_9P, "<<< RFLUSH %d\n", req->tc->tag);
-		spin_lock_irqsave(&c->lock, flags);
-		other_req = p9_tag_lookup(c, req->flush_tag);
-		if (other_req->status != REQ_STATUS_FLSH) /* stale flush */
-			spin_unlock_irqrestore(&c->lock, flags);
-		else {
-			other_req->status = REQ_STATUS_FLSHD;
-			spin_unlock_irqrestore(&c->lock, flags);
-			wake_up(other_req->wq);
-		}
-		p9_free_req(c, req);
-	} else { 				/* normal receive path */
-		P9_DPRINTK(P9_DEBUG_MUX, "normal: tag %d\n", req->tc->tag);
-		spin_lock_irqsave(&c->lock, flags);
-		if (req->status != REQ_STATUS_FLSHD)
-			req->status = REQ_STATUS_RCVD;
-		spin_unlock_irqrestore(&c->lock, flags);
-		wake_up(req->wq);
-		P9_DPRINTK(P9_DEBUG_MUX, "wakeup: %d\n", req->tc->tag);
-	}
+	wake_up(req->wq);
+	P9_DPRINTK(P9_DEBUG_MUX, "wakeup: %d\n", req->tc->tag);
 }
 EXPORT_SYMBOL(p9_client_cb);
 
@@ -486,9 +459,15 @@ static int p9_client_flush(struct p9_client *c, struct p9_req_t *oldreq)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	req->flush_tag = oldtag;
 
-	/* we don't free anything here because RPC isn't complete */
+	/* if we haven't received a response for oldreq,
+	   remove it from the list. */
+	spin_lock(&c->lock);
+	if (oldreq->status==REQ_STATUS_FLSH)
+		list_del(&oldreq->req_list);
+	spin_unlock(&c->lock);
+
+	p9_free_req(c, req);
 	return 0;
 }
 
@@ -509,7 +488,6 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	struct p9_req_t *req;
 	unsigned long flags;
 	int sigpending;
-	int flushed = 0;
 
 	P9_DPRINTK(P9_DEBUG_MUX, "client %p op %d\n", c, type);
 
@@ -546,42 +524,28 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 		goto reterr;
 	}
 
-	/* if it was a flush we just transmitted, return our tag */
-	if (type == P9_TFLUSH)
-		return req;
-again:
 	P9_DPRINTK(P9_DEBUG_MUX, "wait %p tag: %d\n", req->wq, tag);
 	err = wait_event_interruptible(*req->wq,
 						req->status >= REQ_STATUS_RCVD);
-	P9_DPRINTK(P9_DEBUG_MUX, "wait %p tag: %d returned %d (flushed=%d)\n",
-						req->wq, tag, err, flushed);
+	P9_DPRINTK(P9_DEBUG_MUX, "wait %p tag: %d returned %d\n",
+						req->wq, tag, err);
 
 	if (req->status == REQ_STATUS_ERROR) {
 		P9_DPRINTK(P9_DEBUG_ERROR, "req_status error %d\n", req->t_err);
 		err = req->t_err;
-	} else if (err == -ERESTARTSYS && flushed) {
-		P9_DPRINTK(P9_DEBUG_MUX, "flushed - going again\n");
-		goto again;
-	} else if (req->status == REQ_STATUS_FLSHD) {
-		P9_DPRINTK(P9_DEBUG_MUX, "flushed - erestartsys\n");
-		err = -ERESTARTSYS;
 	}
 
-	if ((err == -ERESTARTSYS) && (c->status == Connected) && (!flushed)) {
-		P9_DPRINTK(P9_DEBUG_MUX, "flushing\n");
-		spin_lock_irqsave(&c->lock, flags);
-		if (req->status == REQ_STATUS_SENT)
-			req->status = REQ_STATUS_FLSH;
-		spin_unlock_irqrestore(&c->lock, flags);
+	if ((err == -ERESTARTSYS) && (c->status == Connected)) {
+		P9_DPRINTK(P9_DEBUG_MUX, "flushing\n");	   
 		sigpending = 1;
-		flushed = 1;
 		clear_thread_flag(TIF_SIGPENDING);
 
-		if (c->trans_mod->cancel(c, req)) {
-			err = p9_client_flush(c, req);
-			if (err == 0)
-				goto again;
-		}
+		if (c->trans_mod->cancel(c, req))
+			p9_client_flush(c, req);
+
+		/* if we received the response anyway, don't signal error */
+		if (req->status == REQ_STATUS_RCVD)
+			err = 0;
 	}
 
 	if (sigpending) {
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index c613ed0..a2a1814 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -213,8 +213,8 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 	spin_unlock_irqrestore(&m->client->lock, flags);
 
 	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
-		list_del(&req->req_list);
 		P9_DPRINTK(P9_DEBUG_ERROR, "call back req %p\n", req);
+		list_del(&req->req_list);
 		p9_client_cb(m->client, req);
 	}
 }
@@ -336,7 +336,8 @@ static void p9_read_work(struct work_struct *work)
 			"mux %p pkt: size: %d bytes tag: %d\n", m, n, tag);
 
 		m->req = p9_tag_lookup(m->client, tag);
-		if (!m->req) {
+		if (!m->req || (m->req->status != REQ_STATUS_SENT &&
+					m->req->status != REQ_STATUS_FLSH)) {
 			P9_DPRINTK(P9_DEBUG_ERROR, "Unexpected packet tag %d\n",
 								 tag);
 			err = -EIO;
@@ -361,10 +362,11 @@ static void p9_read_work(struct work_struct *work)
 	if ((m->req) && (m->rpos == m->rsize)) { /* packet is read in */
 		P9_DPRINTK(P9_DEBUG_TRANS, "got new packet\n");
 		spin_lock(&m->client->lock);
+		if (m->req->status != REQ_STATUS_ERROR)
+			m->req->status = REQ_STATUS_RCVD;
 		list_del(&m->req->req_list);
 		spin_unlock(&m->client->lock);
 		p9_client_cb(m->client, m->req);
-
 		m->rbuf = NULL;
 		m->rpos = 0;
 		m->rsize = 0;
@@ -454,6 +456,7 @@ static void p9_write_work(struct work_struct *work)
 		req = list_entry(m->unsent_req_list.next, struct p9_req_t,
 			       req_list);
 		req->status = REQ_STATUS_SENT;
+		P9_DPRINTK(P9_DEBUG_TRANS, "move req %p\n", req);
 		list_move_tail(&req->req_list, &m->req_list);
 
 		m->wbuf = req->tc->sdata;
@@ -683,12 +686,13 @@ static int p9_fd_cancel(struct p9_client *client, struct p9_req_t *req)
 	P9_DPRINTK(P9_DEBUG_TRANS, "client %p req %p\n", client, req);
 
 	spin_lock(&client->lock);
-	list_del(&req->req_list);
 
 	if (req->status == REQ_STATUS_UNSENT) {
+		list_del(&req->req_list);
 		req->status = REQ_STATUS_FLSHD;
 		ret = 0;
-	}
+	} else if (req->status == REQ_STATUS_SENT)
+		req->status = REQ_STATUS_FLSH;
 
 	spin_unlock(&client->lock);
 
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 7fa0eb2..ac49900 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -295,6 +295,7 @@ handle_recv(struct p9_client *client, struct p9_trans_rdma *rdma,
 		goto err_out;
 
 	req->rc = c->rc;
+	req->status = REQ_STATUS_RCVD;
 	p9_client_cb(client, req);
 
 	return;
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 2d7781e..bb8579a 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -134,6 +134,7 @@ static void req_done(struct virtqueue *vq)
 		P9_DPRINTK(P9_DEBUG_TRANS, ": rc %p\n", rc);
 		P9_DPRINTK(P9_DEBUG_TRANS, ": lookup tag %d\n", rc->tag);
 		req = p9_tag_lookup(chan->client, rc->tag);
+		req->status = REQ_STATUS_RCVD;
 		p9_client_cb(chan->client, req);
 	}
 }
