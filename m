Return-Path: <linux-kernel-owner+w=401wt.eu-S1761070AbXIUOwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761070AbXIUOwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759959AbXIUOt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:49:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759098AbXIUOtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:49:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/22] AF_RXRPC: Save the operation ID for debugging
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 21 Sep 2007 15:48:51 +0100
Message-ID: <20070921144851.8323.40332.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
References: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Save the operation ID to be used with a call that we're making for display
through /proc/net/rxrpc_calls.  This helps debugging stuck operations as we
then know what they are.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/net/af_rxrpc.h  |    1 +
 net/rxrpc/af_rxrpc.c    |    3 +++
 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/ar-proc.c     |    7 ++++---
 4 files changed, 9 insertions(+), 3 deletions(-)

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
index c58fa0d..621c1dd 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -251,6 +251,7 @@ static struct rxrpc_transport *rxrpc_name_to_transport(struct socket *sock,
  * @sock: The socket on which to make the call
  * @srx: The address of the peer to contact (defaults to socket setting)
  * @key: The security context to use (defaults to socket setting)
+ * @operation_ID: The operation ID for this call (debugging only)
  * @user_call_ID: The ID to use
  *
  * Allow a kernel service to begin a call on the nominated socket.  This just
@@ -263,6 +264,7 @@ static struct rxrpc_transport *rxrpc_name_to_transport(struct socket *sock,
 struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
 					   struct sockaddr_rxrpc *srx,
 					   struct key *key,
+					   u32 operation_ID,
 					   unsigned long user_call_ID,
 					   gfp_t gfp)
 {
@@ -311,6 +313,7 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
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

