Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbXLETu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbXLETu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbXLETlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:41:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbXLETku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:40:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/28] AF_RXRPC: Save the operation ID for debugging [try #2]
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 05 Dec 2007 19:40:31 +0000
Message-ID: <20071205194030.24617.91122.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
References: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save the operation ID to be used with a call that we're making for display
through /proc/net/rxrpc_calls.  This helps debugging stuck operations as we
then know what they are.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/fsclient.c       |   32 +++++++++++++++++++++++---------
 fs/afs/rxrpc.c          |    1 +
 fs/afs/vlclient.c       |    2 ++
 include/net/af_rxrpc.h  |    1 +
 net/rxrpc/af_rxrpc.c    |    3 +++
 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/ar-proc.c     |    7 ++++---
 7 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 04584c0..a468f2d 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -287,6 +287,7 @@ int afs_fs_fetch_file_status(struct afs_server *server,
 	call->reply2 = volsync;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
+	call->operation_ID = htonl(FSFETCHSTATUS);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -316,7 +317,7 @@ static int afs_deliver_fs_fetch_data(struct afs_call *call,
 	case 0:
 		call->offset = 0;
 		call->unmarshall++;
-		if (call->operation_ID != FSFETCHDATA64) {
+		if (call->operation_ID != htonl(FSFETCHDATA64)) {
 			call->unmarshall++;
 			goto no_msw;
 		}
@@ -464,7 +465,7 @@ static int afs_fs_fetch_data64(struct afs_server *server,
 	call->reply3 = buffer;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
-	call->operation_ID = FSFETCHDATA64;
+	call->operation_ID = htonl(FSFETCHDATA64);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -509,7 +510,7 @@ int afs_fs_fetch_data(struct afs_server *server,
 	call->reply3 = buffer;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
-	call->operation_ID = FSFETCHDATA;
+	call->operation_ID = htonl(FSFETCHDATA);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -577,6 +578,7 @@ int afs_fs_give_up_callbacks(struct afs_server *server,
 
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
+	call->operation_ID = htonl(FSGIVEUPCALLBACKS);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -683,10 +685,11 @@ int afs_fs_create(struct afs_server *server,
 	call->reply4 = newcb;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
+	call->operation_ID = htonl(S_ISDIR(mode) ? FSMAKEDIR : FSCREATEFILE);
 
 	/* marshall the parameters */
 	bp = call->request;
-	*bp++ = htonl(S_ISDIR(mode) ? FSMAKEDIR : FSCREATEFILE);
+	*bp++ = call->operation_ID;
 	*bp++ = htonl(vnode->fid.vid);
 	*bp++ = htonl(vnode->fid.vnode);
 	*bp++ = htonl(vnode->fid.unique);
@@ -772,10 +775,11 @@ int afs_fs_remove(struct afs_server *server,
 	call->reply = vnode;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
+	call->operation_ID = htonl(isdir ? FSREMOVEDIR : FSREMOVEFILE);
 
 	/* marshall the parameters */
 	bp = call->request;
-	*bp++ = htonl(isdir ? FSREMOVEDIR : FSREMOVEFILE);
+	*bp++ = call->operation_ID;
 	*bp++ = htonl(vnode->fid.vid);
 	*bp++ = htonl(vnode->fid.vnode);
 	*bp++ = htonl(vnode->fid.unique);
@@ -857,6 +861,7 @@ int afs_fs_link(struct afs_server *server,
 	call->reply2 = vnode;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
+	call->operation_ID = htonl(FSLINK);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -954,6 +959,7 @@ int afs_fs_symlink(struct afs_server *server,
 	call->reply3 = newstatus;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
+	call->operation_ID = htonl(FSSYMLINK);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -1062,6 +1068,7 @@ int afs_fs_rename(struct afs_server *server,
 	call->reply2 = new_dvnode;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
+	call->operation_ID = htonl(FSRENAME);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -1178,6 +1185,7 @@ static int afs_fs_store_data64(struct afs_server *server,
 	call->last_to = to;
 	call->send_pages = true;
 	call->store_version = vnode->status.data_version + 1;
+	call->operation_ID = htonl(FSSTOREDATA64);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -1255,6 +1263,7 @@ int afs_fs_store_data(struct afs_server *server, struct afs_writeback *wb,
 	call->last_to = to;
 	call->send_pages = true;
 	call->store_version = vnode->status.data_version + 1;
+	call->operation_ID = htonl(FSSTOREDATA);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -1303,7 +1312,8 @@ static int afs_deliver_fs_store_status(struct afs_call *call,
 
 	/* unmarshall the reply once we've received all of it */
 	store_version = NULL;
-	if (call->operation_ID == FSSTOREDATA)
+	if (call->operation_ID == htonl(FSSTOREDATA) ||
+	    call->operation_ID == htonl(FSSTOREDATA64))
 		store_version = &call->store_version;
 
 	bp = call->buffer;
@@ -1365,7 +1375,7 @@ static int afs_fs_setattr_size64(struct afs_server *server, struct key *key,
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
 	call->store_version = vnode->status.data_version + 1;
-	call->operation_ID = FSSTOREDATA;
+	call->operation_ID = htonl(FSSTOREDATA64);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -1416,7 +1426,7 @@ static int afs_fs_setattr_size(struct afs_server *server, struct key *key,
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
 	call->store_version = vnode->status.data_version + 1;
-	call->operation_ID = FSSTOREDATA;
+	call->operation_ID = htonl(FSSTOREDATA);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -1462,7 +1472,7 @@ int afs_fs_setattr(struct afs_server *server, struct key *key,
 	call->reply = vnode;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
-	call->operation_ID = FSSTORESTATUS;
+	call->operation_ID = htonl(FSSTORESTATUS);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -1742,6 +1752,7 @@ int afs_fs_get_volume_status(struct afs_server *server,
 	call->reply3 = tmpbuf;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
+	call->operation_ID = htonl(FSGETVOLUMESTATUS);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -1828,6 +1839,7 @@ int afs_fs_set_lock(struct afs_server *server,
 	call->reply = vnode;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
+	call->operation_ID = htonl(FSSETLOCK);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -1861,6 +1873,7 @@ int afs_fs_extend_lock(struct afs_server *server,
 	call->reply = vnode;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
+	call->operation_ID = htonl(FSEXTENDLOCK);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -1893,6 +1906,7 @@ int afs_fs_release_lock(struct afs_server *server,
 	call->reply = vnode;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
+	call->operation_ID = htonl(FSRELEASELOCK);
 
 	/* marshall the parameters */
 	bp = call->request;
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index bde3f19..348caf4 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -336,6 +336,7 @@ int afs_make_call(struct in_addr *addr, struct afs_call *call, gfp_t gfp,
 
 	/* create a call */
 	rxcall = rxrpc_kernel_begin_call(afs_socket, &srx, call->key,
+					 ntohl(call->operation_ID),
 					 (unsigned long) call, gfp);
 	call->key = NULL;
 	if (IS_ERR(rxcall)) {
diff --git a/fs/afs/vlclient.c b/fs/afs/vlclient.c
index 36c1306..60ddd4f 100644
--- a/fs/afs/vlclient.c
+++ b/fs/afs/vlclient.c
@@ -170,6 +170,7 @@ int afs_vl_get_entry_by_name(struct in_addr *addr,
 	call->reply = entry;
 	call->service_id = VL_SERVICE;
 	call->port = htons(AFS_VL_PORT);
+	call->operation_ID = htonl(VLGETENTRYBYNAME);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -206,6 +207,7 @@ int afs_vl_get_entry_by_id(struct in_addr *addr,
 	call->reply = entry;
 	call->service_id = VL_SERVICE;
 	call->port = htons(AFS_VL_PORT);
+	call->operation_ID = htonl(VLGETENTRYBYID);
 
 	/* marshall the parameters */
 	bp = call->request;
diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index 00c2eaa..7e99733 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -38,6 +38,7 @@ extern void rxrpc_kernel_intercept_rx_messages(struct socket *,
 extern struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *,
 						  struct sockaddr_rxrpc *,
 						  struct key *,
+						  u32,
 						  unsigned long,
 						  gfp_t);
 extern int rxrpc_kernel_send_data(struct rxrpc_call *, struct msghdr *,
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index d638945..bd59665 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -253,6 +253,7 @@ static struct rxrpc_transport *rxrpc_name_to_transport(struct socket *sock,
  * @sock: The socket on which to make the call
  * @srx: The address of the peer to contact (defaults to socket setting)
  * @key: The security context to use (defaults to socket setting)
+ * @operation_ID: The operation ID for this call (debugging only)
  * @user_call_ID: The ID to use
  *
  * Allow a kernel service to begin a call on the nominated socket.  This just
@@ -265,6 +266,7 @@ static struct rxrpc_transport *rxrpc_name_to_transport(struct socket *sock,
 struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
 					   struct sockaddr_rxrpc *srx,
 					   struct key *key,
+					   u32 operation_ID,
 					   unsigned long user_call_ID,
 					   gfp_t gfp)
 {
@@ -313,6 +315,7 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
 	call = rxrpc_get_client_call(rx, trans, bundle, user_call_ID, true,
 				     gfp);
 	rxrpc_put_bundle(trans, bundle);
+	call->op_id = operation_ID;
 out:
 	rxrpc_put_transport(trans);
 	release_sock(&rx->sk);
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 58aaf89..f362e7e 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -367,6 +367,7 @@ struct rxrpc_call {
 		RXRPC_CALL_DEAD,		/* - call is dead */
 	} state;
 	int			debug_id;	/* debug ID for printks */
+	u32			op_id;		/* operation ID (for debugging only) */
 	u8			channel;	/* connection channel occupied by this call */
 
 	/* transmission-phase ACK management */
diff --git a/net/rxrpc/ar-proc.c b/net/rxrpc/ar-proc.c
index 2e83ce3..521b826 100644
--- a/net/rxrpc/ar-proc.c
+++ b/net/rxrpc/ar-proc.c
@@ -53,8 +53,8 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	if (v == &rxrpc_calls) {
 		seq_puts(seq,
 			 "Proto Local                  Remote                "
-			 " SvID ConnID   CallID   End Use State    Abort   "
-			 " UserID\n");
+			 " SvID ConnID   CallID   OpID     End Use State   "
+			 " Abort    UserID\n");
 		return 0;
 	}
 
@@ -70,13 +70,14 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 		ntohs(trans->peer->srx.transport.sin.sin_port));
 
 	seq_printf(seq,
-		   "UDP   %-22.22s %-22.22s %4x %08x %08x %s %3u"
+		   "UDP   %-22.22s %-22.22s %4x %08x %08x %08x %s %3u"
 		   " %-8.8s %08x %lx\n",
 		   lbuff,
 		   rbuff,
 		   ntohs(call->conn->service_id),
 		   ntohl(call->conn->cid),
 		   ntohl(call->call_id),
+		   call->op_id,
 		   call->conn->in_clientflag ? "Svc" : "Clt",
 		   atomic_read(&call->usage),
 		   rxrpc_call_states[call->state],

