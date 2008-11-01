Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYKANle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYKANle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 09:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYKANl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 09:41:27 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:49208 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbYKANl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 09:41:26 -0400
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
 120 seconds"
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Max Kellermann <mk@cm4all.com>, linux-kernel@vger.kernel.org,
       gcosta@redhat.com, Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1225539927.2221.3.camel@localhost.localdomain>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
Content-Type: multipart/mixed; boundary="=-3pr1lFDSoeJTNBXXkTRF"
Date: Sat, 01 Nov 2008 09:41:18 -0400
Message-Id: <1225546878.4390.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, MISSING_SUBJECT=0.001,NO_RECEIVED=-0.001, uiobl=NO, uiouri=NO)
X-UiO-Scanned: F5180486F56E73FAC874322D0D22265009D90703
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 162 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3pr1lFDSoeJTNBXXkTRF
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2008-11-01 at 11:45 +0000, Ian Campbell wrote:
> On Mon, 2008-10-20 at 07:27 +0100, Ian Campbell wrote:
> > So far I have bisected down to this range and am currently testing
> > acee478 which has been up for >4days.
> 
> Another update. It has now bisected down to a small range 
> 
> 7272dcd31d56580dee7693c21e369fd167e137fe SUNRPC: xprt_autoclose() should not call xprt_disconnect()
> e06799f958bf7f9f8fae15f0c6f519953fb0257c SUNRPC: Use shutdown() instead of close() when disconnecting a TCP socket
> ef80367071dce7d2533e79ae8f3c84ec42708dc8 SUNRPC: TCP clear XPRT_CLOSE_WAIT when the socket is closed for writes
> 3b948ae5be5e22532584113e2e02029519bbad8f SUNRPC: Allow the client to detect if the TCP connection is closed
> 67a391d72ca7efb387c30ec761a487e50a3ff085 SUNRPC: Fix TCP rebinding logic
> 66af1e558538137080615e7ad6d1f2f80862de01 SUNRPC: Fix a race in xs_tcp_state_change()
> 
> I'm currently testing 3b948ae5be5e22532584113e2e02029519bbad8f.
> 
> 7272dcd31d56580dee7693c21e369fd167e137fe repro'd in half a day while
> ef818a28fac9bd214e676986d8301db0582b92a9 (parent of
> 66af1e558538137080615e7ad6d1f2f80862de01) survived for 7 days.
> 
> Ian.

Have you tested with the TCP RST fix yet? It has been merged into
mainline, so it should be in the latest 2.6.28-git, but I've attached it
so you can apply it to your test kernel...

Cheers
  Trond


--=-3pr1lFDSoeJTNBXXkTRF
Content-Disposition: attachment; filename="linux-2.6.27-001-respond_promptly_to_socket_errors.dif"
Content-Type: application/x-dif; name="linux-2.6.27-001-respond_promptly_to_socket_errors.dif"
Content-Transfer-Encoding: 7bit

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Mon, 27 Oct 2008 09:31:36 -0400
SUNRPC: Respond promptly to server TCP resets

If the server sends us an RST error while we're in the TCP_ESTABLISHED
state, then that will not result in a state change, and so the RPC client
ends up hanging forever (see
http://bugzilla.kernel.org/show_bug.cgi?id=11154)

We can intercept the reset by setting up an sk->sk_error_report callback,
which will then allow us to initiate a proper shutdown and retry...

We also make sure that if the send request receives an ECONNRESET, then we
shutdown too...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 net/sunrpc/xprtsock.c |   58 +++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 48 insertions(+), 10 deletions(-)


diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 9a288d5..0a50361 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -249,6 +249,7 @@ struct sock_xprt {
 	void			(*old_data_ready)(struct sock *, int);
 	void			(*old_state_change)(struct sock *);
 	void			(*old_write_space)(struct sock *);
+	void			(*old_error_report)(struct sock *);
 };
 
 /*
@@ -698,8 +699,9 @@ static int xs_tcp_send_request(struct rpc_task *task)
 	case -EAGAIN:
 		xs_nospace(task);
 		break;
-	case -ECONNREFUSED:
 	case -ECONNRESET:
+		xs_tcp_shutdown(xprt);
+	case -ECONNREFUSED:
 	case -ENOTCONN:
 	case -EPIPE:
 		status = -ENOTCONN;
@@ -742,6 +744,22 @@ out_release:
 	xprt_release_xprt(xprt, task);
 }
 
+static void xs_save_old_callbacks(struct sock_xprt *transport, struct sock *sk)
+{
+	transport->old_data_ready = sk->sk_data_ready;
+	transport->old_state_change = sk->sk_state_change;
+	transport->old_write_space = sk->sk_write_space;
+	transport->old_error_report = sk->sk_error_report;
+}
+
+static void xs_restore_old_callbacks(struct sock_xprt *transport, struct sock *sk)
+{
+	sk->sk_data_ready = transport->old_data_ready;
+	sk->sk_state_change = transport->old_state_change;
+	sk->sk_write_space = transport->old_write_space;
+	sk->sk_error_report = transport->old_error_report;
+}
+
 /**
  * xs_close - close a socket
  * @xprt: transport
@@ -765,9 +783,8 @@ static void xs_close(struct rpc_xprt *xprt)
 	transport->sock = NULL;
 
 	sk->sk_user_data = NULL;
-	sk->sk_data_ready = transport->old_data_ready;
-	sk->sk_state_change = transport->old_state_change;
-	sk->sk_write_space = transport->old_write_space;
+
+	xs_restore_old_callbacks(transport, sk);
 	write_unlock_bh(&sk->sk_callback_lock);
 
 	sk->sk_no_check = 0;
@@ -1180,6 +1197,28 @@ static void xs_tcp_state_change(struct sock *sk)
 }
 
 /**
+ * xs_tcp_error_report - callback mainly for catching RST events
+ * @sk: socket
+ */
+static void xs_tcp_error_report(struct sock *sk)
+{
+	struct rpc_xprt *xprt;
+
+	read_lock(&sk->sk_callback_lock);
+	if (sk->sk_err != ECONNRESET || sk->sk_state != TCP_ESTABLISHED)
+		goto out;
+	if (!(xprt = xprt_from_sock(sk)))
+		goto out;
+	dprintk("RPC:       %s client %p...\n"
+			"RPC:       error %d\n",
+			__func__, xprt, sk->sk_err);
+
+	xprt_force_disconnect(xprt);
+out:
+	read_unlock(&sk->sk_callback_lock);
+}
+
+/**
  * xs_udp_write_space - callback invoked when socket buffer space
  *                             becomes available
  * @sk: socket whose state has changed
@@ -1454,10 +1493,9 @@ static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 
 		write_lock_bh(&sk->sk_callback_lock);
 
+		xs_save_old_callbacks(transport, sk);
+
 		sk->sk_user_data = xprt;
-		transport->old_data_ready = sk->sk_data_ready;
-		transport->old_state_change = sk->sk_state_change;
-		transport->old_write_space = sk->sk_write_space;
 		sk->sk_data_ready = xs_udp_data_ready;
 		sk->sk_write_space = xs_udp_write_space;
 		sk->sk_no_check = UDP_CSUM_NORCV;
@@ -1589,13 +1627,13 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 
 		write_lock_bh(&sk->sk_callback_lock);
 
+		xs_save_old_callbacks(transport, sk);
+
 		sk->sk_user_data = xprt;
-		transport->old_data_ready = sk->sk_data_ready;
-		transport->old_state_change = sk->sk_state_change;
-		transport->old_write_space = sk->sk_write_space;
 		sk->sk_data_ready = xs_tcp_data_ready;
 		sk->sk_state_change = xs_tcp_state_change;
 		sk->sk_write_space = xs_tcp_write_space;
+		sk->sk_error_report = xs_tcp_error_report;
 		sk->sk_allocation = GFP_ATOMIC;
 
 		/* socket options */

--=-3pr1lFDSoeJTNBXXkTRF--

