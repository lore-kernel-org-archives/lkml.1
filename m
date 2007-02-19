Return-Path: <linux-kernel-owner+w=401wt.eu-S1750895AbXBSKhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895AbXBSKhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbXBSKhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:37:34 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:58353 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbXBSKhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:37:33 -0500
Message-ID: <45D97DF0.9070306@drzeus.cx>
Date: Mon, 19 Feb 2007 11:37:36 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hera.drzeus.cx-3968-1171881451-0001-2"
To: Petr Vandrovec <vandrove@vc.cvut.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NCPFS and brittle connections
References: <459D1794.2060009@drzeus.cx> <459D38DA.4030803@vc.cvut.cz> <459D55E3.4000905@drzeus.cx> <459E01B2.50309@vc.cvut.cz> <45B77AE4.2010605@drzeus.cx> <45B79C35.2090302@vc.cvut.cz> <45B7D750.1040501@drzeus.cx> <45B868D5.9070409@vc.cvut.cz> <45B8845E.8070008@drzeus.cx> <45C57695.7000707@vc.cvut.cz> <45C61540.7000008@drzeus.cx> <45C6A99C.5030607@vc.cvut.cz>
In-Reply-To: <45C6A99C.5030607@vc.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-3968-1171881451-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Sorry this took so long but I got occupied with other things and this
had to move down the pile a bit.

New patch which uses dedicated buffers for the currently active packet.
Also adds a new state RQ_ABANDONED which basically means "the caller no
longer cares about this request so the pointers are no longer valid". It
is used to determine if the global receive buffer should be copied to
the provided one upon completion.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org


--=_hera.drzeus.cx-3968-1171881451-0001-2
Content-Type: text/x-patch; name="ncpfs.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ncpfs.patch"

commit 166fb223f9507431fb97820549e3e41980987445
Author: Pierre Ossman <ossman@cendio.se>
Date:   Mon Feb 19 11:34:43 2007 +0100

    ncpfs: make sure server connection survives a kill
    
    Use internal buffers instead of the ones supplied by the caller
    so that a caller can be interrupted without having to abort the
    entire ncp connection.
    
    Signed-off-by: Pierre Ossman <ossman@cendio.se>

diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 14939dd..7285c94 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -576,6 +576,12 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 	server->packet = vmalloc(NCP_PACKET_SIZE);
 	if (server->packet == NULL)
 		goto out_nls;
+	server->txbuf = vmalloc(NCP_PACKET_SIZE);
+	if (server->txbuf == NULL)
+		goto out_packet;
+	server->rxbuf = vmalloc(NCP_PACKET_SIZE);
+	if (server->rxbuf == NULL)
+		goto out_txbuf;
 
 	sock->sk->sk_data_ready	  = ncp_tcp_data_ready;
 	sock->sk->sk_error_report = ncp_tcp_error_report;
@@ -597,7 +603,7 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 	error = ncp_connect(server);
 	ncp_unlock_server(server);
 	if (error < 0)
-		goto out_packet;
+		goto out_rxbuf;
 	DPRINTK("ncp_fill_super: NCP_SBP(sb) = %x\n", (int) NCP_SBP(sb));
 
 	error = -EMSGSIZE;	/* -EREMOTESIDEINCOMPATIBLE */
@@ -666,8 +672,12 @@ out_disconnect:
 	ncp_lock_server(server);
 	ncp_disconnect(server);
 	ncp_unlock_server(server);
-out_packet:
+out_rxbuf:
 	ncp_stop_tasks(server);
+	vfree(server->rxbuf);
+out_txbuf:
+	vfree(server->txbuf);
+out_packet:
 	vfree(server->packet);
 out_nls:
 #ifdef CONFIG_NCPFS_NLS
@@ -723,6 +733,8 @@ static void ncp_put_super(struct super_block *sb)
 
 	kfree(server->priv.data);
 	kfree(server->auth.object_name);
+	vfree(server->rxbuf);
+	vfree(server->txbuf);
 	vfree(server->packet);
 	sb->s_fs_info = NULL;
 	kfree(server);
diff --git a/fs/ncpfs/sock.c b/fs/ncpfs/sock.c
index e496d8b..e37df8d 100644
--- a/fs/ncpfs/sock.c
+++ b/fs/ncpfs/sock.c
@@ -14,6 +14,7 @@
 #include <linux/socket.h>
 #include <linux/fcntl.h>
 #include <linux/stat.h>
+#include <linux/string.h>
 #include <asm/uaccess.h>
 #include <linux/in.h>
 #include <linux/net.h>
@@ -55,10 +56,11 @@ static int _send(struct socket *sock, const void *buff, int len)
 struct ncp_request_reply {
 	struct list_head req;
 	wait_queue_head_t wq;
-	struct ncp_reply_header* reply_buf;
+	atomic_t refs;
+	unsigned char* reply_buf;
 	size_t datalen;
 	int result;
-	enum { RQ_DONE, RQ_INPROGRESS, RQ_QUEUED, RQ_IDLE } status;
+	enum { RQ_DONE, RQ_INPROGRESS, RQ_QUEUED, RQ_IDLE, RQ_ABANDONED } status;
 	struct kvec* tx_ciov;
 	size_t tx_totallen;
 	size_t tx_iovlen;
@@ -67,6 +69,32 @@ struct ncp_request_reply {
 	u_int32_t sign[6];
 };
 
+static inline struct ncp_request_reply* ncp_alloc_req(void)
+{
+	struct ncp_request_reply *req;
+
+	req = kmalloc(sizeof(struct ncp_request_reply), GFP_KERNEL);
+	if (!req)
+		return NULL;
+
+	init_waitqueue_head(&req->wq);
+	atomic_set(&req->refs, (1));
+	req->status = RQ_IDLE;
+
+	return req;
+}
+
+static void ncp_req_get(struct ncp_request_reply *req)
+{
+	atomic_inc(&req->refs);
+}
+
+static void ncp_req_put(struct ncp_request_reply *req)
+{
+	if (atomic_dec_and_test(&req->refs))
+		kfree(req);
+}
+
 void ncp_tcp_data_ready(struct sock *sk, int len)
 {
 	struct ncp_server *server = sk->sk_user_data;
@@ -101,14 +129,17 @@ void ncpdgram_timeout_call(unsigned long v)
 	schedule_work(&server->timeout_tq);
 }
 
-static inline void ncp_finish_request(struct ncp_request_reply *req, int result)
+static inline void ncp_finish_request(struct ncp_server *server, struct ncp_request_reply *req, int result)
 {
 	req->result = result;
+	if (req->status != RQ_ABANDONED)
+		memcpy(req->reply_buf, server->rxbuf, req->datalen);
 	req->status = RQ_DONE;
 	wake_up_all(&req->wq);
+	ncp_req_put(req);
 }
 
-static void __abort_ncp_connection(struct ncp_server *server, struct ncp_request_reply *aborted, int err)
+static void __abort_ncp_connection(struct ncp_server *server)
 {
 	struct ncp_request_reply *req;
 
@@ -118,31 +149,19 @@ static void __abort_ncp_connection(struct ncp_server *server, struct ncp_request
 		req = list_entry(server->tx.requests.next, struct ncp_request_reply, req);
 		
 		list_del_init(&req->req);
-		if (req == aborted) {
-			ncp_finish_request(req, err);
-		} else {
-			ncp_finish_request(req, -EIO);
-		}
+		ncp_finish_request(server, req, -EIO);
 	}
 	req = server->rcv.creq;
 	if (req) {
 		server->rcv.creq = NULL;
-		if (req == aborted) {
-			ncp_finish_request(req, err);
-		} else {
-			ncp_finish_request(req, -EIO);
-		}
+		ncp_finish_request(server, req, -EIO);
 		server->rcv.ptr = NULL;
 		server->rcv.state = 0;
 	}
 	req = server->tx.creq;
 	if (req) {
 		server->tx.creq = NULL;
-		if (req == aborted) {
-			ncp_finish_request(req, err);
-		} else {
-			ncp_finish_request(req, -EIO);
-		}
+		ncp_finish_request(server, req, -EIO);
 	}
 }
 
@@ -160,10 +179,12 @@ static inline void __ncp_abort_request(struct ncp_server *server, struct ncp_req
 			break;
 		case RQ_QUEUED:
 			list_del_init(&req->req);
-			ncp_finish_request(req, err);
+			ncp_finish_request(server, req, err);
 			break;
 		case RQ_INPROGRESS:
-			__abort_ncp_connection(server, req, err);
+			req->status = RQ_ABANDONED;
+			break;
+		case RQ_ABANDONED:
 			break;
 	}
 }
@@ -177,7 +198,7 @@ static inline void ncp_abort_request(struct ncp_server *server, struct ncp_reque
 
 static inline void __ncptcp_abort(struct ncp_server *server)
 {
-	__abort_ncp_connection(server, NULL, 0);
+	__abort_ncp_connection(server);
 }
 
 static int ncpdgram_send(struct socket *sock, struct ncp_request_reply *req)
@@ -294,6 +315,11 @@ static void ncptcp_start_request(struct ncp_server *server, struct ncp_request_r
 
 static inline void __ncp_start_request(struct ncp_server *server, struct ncp_request_reply *req)
 {
+	/* we copy the data so that we do not depend on the caller
+	   staying alive */
+	memcpy(server->txbuf, req->tx_iov[1].iov_base, req->tx_iov[1].iov_len);
+	req->tx_iov[1].iov_base = server->txbuf;
+
 	if (server->ncp_sock->type == SOCK_STREAM)
 		ncptcp_start_request(server, req);
 	else
@@ -308,6 +334,7 @@ static int ncp_add_request(struct ncp_server *server, struct ncp_request_reply *
 		printk(KERN_ERR "ncpfs: tcp: Server died\n");
 		return -EIO;
 	}
+	ncp_req_get(req);
 	if (server->tx.creq || server->rcv.creq) {
 		req->status = RQ_QUEUED;
 		list_add_tail(&req->req, &server->tx.requests);
@@ -409,7 +436,7 @@ void ncpdgram_rcv_proc(struct work_struct *work)
 					server->timeout_last = NCP_MAX_RPC_TIMEOUT;
 					mod_timer(&server->timeout_tm, jiffies + NCP_MAX_RPC_TIMEOUT);
 				} else if (reply.type == NCP_REPLY) {
-					result = _recv(sock, (void*)req->reply_buf, req->datalen, MSG_DONTWAIT);
+					result = _recv(sock, server->rxbuf, req->datalen, MSG_DONTWAIT);
 #ifdef CONFIG_NCPFS_PACKET_SIGNING
 					if (result >= 0 && server->sign_active && req->tx_type != NCP_DEALLOC_SLOT_REQUEST) {
 						if (result < 8 + 8) {
@@ -419,7 +446,7 @@ void ncpdgram_rcv_proc(struct work_struct *work)
 							
 							result -= 8;
 							hdrl = sock->sk->sk_family == AF_INET ? 8 : 6;
-							if (sign_verify_reply(server, ((char*)req->reply_buf) + hdrl, result - hdrl, cpu_to_le32(result), ((char*)req->reply_buf) + result)) {
+							if (sign_verify_reply(server, server->rxbuf + hdrl, result - hdrl, cpu_to_le32(result), server->rxbuf + result)) {
 								printk(KERN_INFO "ncpfs: Signature violation\n");
 								result = -EIO;
 							}
@@ -428,7 +455,7 @@ void ncpdgram_rcv_proc(struct work_struct *work)
 #endif
 					del_timer(&server->timeout_tm);
 				     	server->rcv.creq = NULL;
-					ncp_finish_request(req, result);
+					ncp_finish_request(server, req, result);
 					__ncp_next_request(server);
 					mutex_unlock(&server->rcv.creq_mutex);
 					continue;
@@ -478,12 +505,6 @@ void ncpdgram_timeout_proc(struct work_struct *work)
 	mutex_unlock(&server->rcv.creq_mutex);
 }
 
-static inline void ncp_init_req(struct ncp_request_reply* req)
-{
-	init_waitqueue_head(&req->wq);
-	req->status = RQ_IDLE;
-}
-
 static int do_tcp_rcv(struct ncp_server *server, void *buffer, size_t len)
 {
 	int result;
@@ -601,8 +622,8 @@ skipdata:;
 					goto skipdata;
 				}
 				req->datalen = datalen - 8;
-				req->reply_buf->type = NCP_REPLY;
-				server->rcv.ptr = (unsigned char*)(req->reply_buf) + 2;
+				((struct ncp_reply_header*)server->rxbuf)->type = NCP_REPLY;
+				server->rcv.ptr = server->rxbuf + 2;
 				server->rcv.len = datalen - 10;
 				server->rcv.state = 1;
 				break;
@@ -615,12 +636,12 @@ skipdata:;
 			case 1:
 				req = server->rcv.creq;
 				if (req->tx_type != NCP_ALLOC_SLOT_REQUEST) {
-					if (req->reply_buf->sequence != server->sequence) {
+					if (((struct ncp_reply_header*)server->rxbuf)->sequence != server->sequence) {
 						printk(KERN_ERR "ncpfs: tcp: Bad sequence number\n");
 						__ncp_abort_request(server, req, -EIO);
 						return -EIO;
 					}
-					if ((req->reply_buf->conn_low | (req->reply_buf->conn_high << 8)) != server->connection) {
+					if ((((struct ncp_reply_header*)server->rxbuf)->conn_low | (((struct ncp_reply_header*)server->rxbuf)->conn_high << 8)) != server->connection) {
 						printk(KERN_ERR "ncpfs: tcp: Connection number mismatch\n");
 						__ncp_abort_request(server, req, -EIO);
 						return -EIO;
@@ -628,14 +649,14 @@ skipdata:;
 				}
 #ifdef CONFIG_NCPFS_PACKET_SIGNING				
 				if (server->sign_active && req->tx_type != NCP_DEALLOC_SLOT_REQUEST) {
-					if (sign_verify_reply(server, (unsigned char*)(req->reply_buf) + 6, req->datalen - 6, cpu_to_be32(req->datalen + 16), &server->rcv.buf.type)) {
+					if (sign_verify_reply(server, server->rxbuf + 6, req->datalen - 6, cpu_to_be32(req->datalen + 16), &server->rcv.buf.type)) {
 						printk(KERN_ERR "ncpfs: tcp: Signature violation\n");
 						__ncp_abort_request(server, req, -EIO);
 						return -EIO;
 					}
 				}
 #endif				
-				ncp_finish_request(req, req->datalen);
+				ncp_finish_request(server, req, req->datalen);
 			nextreq:;
 				__ncp_next_request(server);
 			case 2:
@@ -645,7 +666,7 @@ skipdata:;
 				server->rcv.state = 0;
 				break;
 			case 3:
-				ncp_finish_request(server->rcv.creq, -EIO);
+				ncp_finish_request(server, server->rcv.creq, -EIO);
 				goto nextreq;
 			case 5:
 				info_server(server, 0, server->unexpected_packet.data, server->unexpected_packet.len);
@@ -675,28 +696,39 @@ void ncp_tcp_tx_proc(struct work_struct *work)
 }
 
 static int do_ncp_rpc_call(struct ncp_server *server, int size,
-		struct ncp_reply_header* reply_buf, int max_reply_size)
+		unsigned char* reply_buf, int max_reply_size)
 {
 	int result;
-	struct ncp_request_reply req;
-
-	ncp_init_req(&req);
-	req.reply_buf = reply_buf;
-	req.datalen = max_reply_size;
-	req.tx_iov[1].iov_base = server->packet;
-	req.tx_iov[1].iov_len = size;
-	req.tx_iovlen = 1;
-	req.tx_totallen = size;
-	req.tx_type = *(u_int16_t*)server->packet;
-
-	result = ncp_add_request(server, &req);
-	if (result < 0) {
-		return result;
-	}
-	if (wait_event_interruptible(req.wq, req.status == RQ_DONE)) {
-		ncp_abort_request(server, &req, -EIO);
+	struct ncp_request_reply *req;
+
+	req = ncp_alloc_req();
+	if (!req)
+		return -ENOMEM;
+
+	req->reply_buf = reply_buf;
+	req->datalen = max_reply_size;
+	req->tx_iov[1].iov_base = server->packet;
+	req->tx_iov[1].iov_len = size;
+	req->tx_iovlen = 1;
+	req->tx_totallen = size;
+	req->tx_type = *(u_int16_t*)server->packet;
+
+	result = ncp_add_request(server, req);
+	if (result < 0)
+		goto out;
+
+	if (wait_event_interruptible(req->wq, req->status == RQ_DONE)) {
+		ncp_abort_request(server, req, -EINTR);
+		result = -EINTR;
+		goto out;
 	}
-	return req.result;
+
+	result = req->result;
+
+out:
+	ncp_req_put(req);
+
+	return result;
 }
 
 /*
@@ -751,11 +783,6 @@ static int ncp_do_request(struct ncp_server *server, int size,
 
 	DDPRINTK("do_ncp_rpc_call returned %d\n", result);
 
-	if (result < 0) {
-		/* There was a problem with I/O, so the connections is
-		 * no longer usable. */
-		ncp_invalidate_conn(server);
-	}
 	return result;
 }
 
diff --git a/include/linux/ncp_fs_sb.h b/include/linux/ncp_fs_sb.h
index a503052..d5e7ffc 100644
--- a/include/linux/ncp_fs_sb.h
+++ b/include/linux/ncp_fs_sb.h
@@ -50,6 +50,8 @@ struct ncp_server {
 	int packet_size;
 	unsigned char *packet;	/* Here we prepare requests and
 				   receive replies */
+	unsigned char *txbuf;	/* Storage for current requres */
+	unsigned char *rxbuf;	/* Storage for reply to current request */
 
 	int lock;		/* To prevent mismatch in protocols. */
 	struct mutex mutex;

--=_hera.drzeus.cx-3968-1171881451-0001-2--
