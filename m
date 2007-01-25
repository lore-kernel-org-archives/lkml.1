Return-Path: <linux-kernel-owner+w=401wt.eu-S965754AbXAYKUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965754AbXAYKUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 05:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965755AbXAYKUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 05:20:17 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41069 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965754AbXAYKUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 05:20:15 -0500
Message-ID: <45B8845E.8070008@drzeus.cx>
Date: Thu, 25 Jan 2007 11:20:14 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Petr Vandrovec <vandrove@vc.cvut.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NCPFS and brittle connections
References: <459D1794.2060009@drzeus.cx> <459D38DA.4030803@vc.cvut.cz> <459D55E3.4000905@drzeus.cx> <459E01B2.50309@vc.cvut.cz> <45B77AE4.2010605@drzeus.cx> <45B79C35.2090302@vc.cvut.cz> <45B7D750.1040501@drzeus.cx> <45B868D5.9070409@vc.cvut.cz>
In-Reply-To: <45B868D5.9070409@vc.cvut.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok... how about this baby instead. I've replaced the stack allocated
request structure by one allocated with kmalloc() and reference counted
using an atomic_t. I couldn't see anything else that was associated to
the process, so I believe this should suffice.

(This is just a RFC. Once I get an ok from you I'll put together a more
proper patch mail)

diff --git a/fs/ncpfs/sock.c b/fs/ncpfs/sock.c
index e496d8b..fc6e02d 100644
--- a/fs/ncpfs/sock.c
+++ b/fs/ncpfs/sock.c
@@ -55,6 +55,7 @@ static int _send(struct socket *sock, const void
*buff, int len)
 struct ncp_request_reply {
        struct list_head req;
        wait_queue_head_t wq;
+       atomic_t refs;
        struct ncp_reply_header* reply_buf;
        size_t datalen;
        int result;
@@ -67,6 +68,32 @@ struct ncp_request_reply {
        u_int32_t sign[6];
 };
 
+static inline struct ncp_request_reply* ncp_alloc_req(void)
+{
+       struct ncp_request_reply *req;
+
+       req = kmalloc(sizeof(struct ncp_request_reply), GFP_KERNEL);
+       if (!req)
+               return NULL;
+
+       init_waitqueue_head(&req->wq);
+       atomic_set(&req->refs, (1));
+       req->status = RQ_IDLE;
+
+       return req;
+}
+
+static void ncp_req_get(struct ncp_request_reply *req)
+{
+       atomic_inc(&req->refs);
+}
+
+static void ncp_req_put(struct ncp_request_reply *req)
+{
+       if (atomic_dec_and_test(&req->refs))
+               kfree(req);
+}
+
 void ncp_tcp_data_ready(struct sock *sk, int len)
 {
        struct ncp_server *server = sk->sk_user_data;
@@ -106,6 +133,7 @@ static inline void ncp_finish_request(struct
ncp_request_reply *req, int result)
        req->result = result;
        req->status = RQ_DONE;
        wake_up_all(&req->wq);
+       ncp_req_put(req);
 }
 
 static void __abort_ncp_connection(struct ncp_server *server, struct
ncp_request_reply *aborted, int err)
@@ -308,6 +336,7 @@ static int ncp_add_request(struct ncp_server
*server, struct ncp_request_reply *
                printk(KERN_ERR "ncpfs: tcp: Server died\n");
                return -EIO;
        }
+       ncp_req_get(req);
        if (server->tx.creq || server->rcv.creq) {
                req->status = RQ_QUEUED;
                list_add_tail(&req->req, &server->tx.requests);
@@ -478,12 +507,6 @@ void ncpdgram_timeout_proc(struct work_struct *work)
        mutex_unlock(&server->rcv.creq_mutex);
 }
 
-static inline void ncp_init_req(struct ncp_request_reply* req)
-{
-       init_waitqueue_head(&req->wq);
-       req->status = RQ_IDLE;
-}
-
 static int do_tcp_rcv(struct ncp_server *server, void *buffer, size_t len)
 {
        int result;
@@ -678,25 +701,32 @@ static int do_ncp_rpc_call(struct ncp_server
*server, int size,
                struct ncp_reply_header* reply_buf, int max_reply_size)
 {
        int result;
-       struct ncp_request_reply req;
-
-       ncp_init_req(&req);
-       req.reply_buf = reply_buf;
-       req.datalen = max_reply_size;
-       req.tx_iov[1].iov_base = server->packet;
-       req.tx_iov[1].iov_len = size;
-       req.tx_iovlen = 1;
-       req.tx_totallen = size;
-       req.tx_type = *(u_int16_t*)server->packet;
-
-       result = ncp_add_request(server, &req);
+       struct ncp_request_reply *req;
+
+       req = ncp_alloc_req();
+       if (!req)
+               return -ENOMEM;
+
+       req->reply_buf = reply_buf;
+       req->datalen = max_reply_size;
+       req->tx_iov[1].iov_base = server->packet;
+       req->tx_iov[1].iov_len = size;
+       req->tx_iovlen = 1;
+       req->tx_totallen = size;
+       req->tx_type = *(u_int16_t*)server->packet;
+
+       result = ncp_add_request(server, req);
        if (result < 0) {
                return result;
        }
-       if (wait_event_interruptible(req.wq, req.status == RQ_DONE)) {
-               ncp_abort_request(server, &req, -EIO);
-       }
-       return req.result;
+       if (wait_event_interruptible(req->wq, req->status == RQ_DONE))
+               result = -EINTR;
+       else
+               result = req->result;
+
+       ncp_req_put(req);
+
+       return result;
 }
 
 /*
@@ -751,11 +781,6 @@ static int ncp_do_request(struct ncp_server
*server, int size,
 
        DDPRINTK("do_ncp_rpc_call returned %d\n", result);
 
-       if (result < 0) {
-               /* There was a problem with I/O, so the connections is
-                * no longer usable. */
-               ncp_invalidate_conn(server);
-       }
        return result;
 }

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

