Return-Path: <linux-kernel-owner+w=401wt.eu-S1761249AbYFHJFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249AbYFHJFD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 05:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbYFHJEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 05:04:53 -0400
Received: from 1wt.eu ([62.212.114.60]:1563 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbYFHJEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 05:04:52 -0400
Date: Sun, 8 Jun 2008 11:03:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, James Chapman <jchapman@katalix.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Missing patch from stable [7/7]
Message-ID: <20080608090319.GG6439@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch from mainline seems suitable for -stable, but was not proposed
for inclusion. I think we should include it for next review unless the
author disagrees.

Thanks,
Willy
--

>From 24b95685ffcdb3dc28f64b9e8af6ea3e8360fbc5 Mon Sep 17 00:00:00 2001
From: James Chapman <jchapman@katalix.com>
Date: Wed, 4 Jun 2008 15:54:07 -0700
Subject: l2tp: Fix possible oops if transmitting or receiving when tunnel goes down

Some problems have been experienced in the field which cause an oops
in the pppol2tp driver if L2TP tunnels fail while passing data.

The pppol2tp driver uses private data that is referenced via the
sk->sk_user_data of its UDP and PPPoL2TP sockets. This patch makes
sure that the driver uses sock_hold() when it holds a reference to the
sk pointer. This affects its sendmsg(), recvmsg(), getname(),
[gs]etsockopt() and ioctl() handlers.

Tested by ISP where problem was seen. System has been up 10 days with
no oops since running this patch. Without the patch, an oops would
occur every 1-2 days.

Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/pppol2tp.c |  101 +++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 78 insertions(+), 23 deletions(-)

diff --git a/drivers/net/pppol2tp.c b/drivers/net/pppol2tp.c
index 04c7e5b..70cfdb4 100644
--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -240,12 +240,15 @@ static inline struct pppol2tp_session *pppol2tp_sock_to_session(struct sock *sk)
 	if (sk == NULL)
 		return NULL;
 
+	sock_hold(sk);
 	session = (struct pppol2tp_session *)(sk->sk_user_data);
-	if (session == NULL)
-		return NULL;
+	if (session == NULL) {
+		sock_put(sk);
+		goto out;
+	}
 
 	BUG_ON(session->magic != L2TP_SESSION_MAGIC);
-
+out:
 	return session;
 }
 
@@ -256,12 +259,15 @@ static inline struct pppol2tp_tunnel *pppol2tp_sock_to_tunnel(struct sock *sk)
 	if (sk == NULL)
 		return NULL;
 
+	sock_hold(sk);
 	tunnel = (struct pppol2tp_tunnel *)(sk->sk_user_data);
-	if (tunnel == NULL)
-		return NULL;
+	if (tunnel == NULL) {
+		sock_put(sk);
+		goto out;
+	}
 
 	BUG_ON(tunnel->magic != L2TP_TUNNEL_MAGIC);
-
+out:
 	return tunnel;
 }
 
@@ -716,12 +722,14 @@ discard:
 	session->stats.rx_errors++;
 	kfree_skb(skb);
 	sock_put(session->sock);
+	sock_put(sock);
 
 	return 0;
 
 error:
 	/* Put UDP header back */
 	__skb_push(skb, sizeof(struct udphdr));
+	sock_put(sock);
 
 no_tunnel:
 	return 1;
@@ -745,10 +753,13 @@ static int pppol2tp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	       "%s: received %d bytes\n", tunnel->name, skb->len);
 
 	if (pppol2tp_recv_core(sk, skb))
-		goto pass_up;
+		goto pass_up_put;
 
+	sock_put(sk);
 	return 0;
 
+pass_up_put:
+	sock_put(sk);
 pass_up:
 	return 1;
 }
@@ -858,7 +869,7 @@ static int pppol2tp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msgh
 
 	tunnel = pppol2tp_sock_to_tunnel(session->tunnel_sock);
 	if (tunnel == NULL)
-		goto error;
+		goto error_put_sess;
 
 	/* What header length is configured for this session? */
 	hdr_len = pppol2tp_l2tp_header_len(session);
@@ -870,7 +881,7 @@ static int pppol2tp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msgh
 			   sizeof(ppph) + total_len,
 			   0, GFP_KERNEL);
 	if (!skb)
-		goto error;
+		goto error_put_sess_tun;
 
 	/* Reserve space for headers. */
 	skb_reserve(skb, NET_SKB_PAD);
@@ -900,7 +911,7 @@ static int pppol2tp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msgh
 	error = memcpy_fromiovec(skb->data, m->msg_iov, total_len);
 	if (error < 0) {
 		kfree_skb(skb);
-		goto error;
+		goto error_put_sess_tun;
 	}
 	skb_put(skb, total_len);
 
@@ -947,10 +958,33 @@ static int pppol2tp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msgh
 		session->stats.tx_errors++;
 	}
 
+	return error;
+
+error_put_sess_tun:
+	sock_put(session->tunnel_sock);
+error_put_sess:
+	sock_put(sk);
 error:
 	return error;
 }
 
+/* Automatically called when the skb is freed.
+ */
+static void pppol2tp_sock_wfree(struct sk_buff *skb)
+{
+	sock_put(skb->sk);
+}
+
+/* For data skbs that we transmit, we associate with the tunnel socket
+ * but don't do accounting.
+ */
+static inline void pppol2tp_skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
+{
+	sock_hold(sk);
+	skb->sk = sk;
+	skb->destructor = pppol2tp_sock_wfree;
+}
+
 /* Transmit function called by generic PPP driver.  Sends PPP frame
  * over PPPoL2TP socket.
  *
@@ -993,10 +1027,10 @@ static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 
 	sk_tun = session->tunnel_sock;
 	if (sk_tun == NULL)
-		goto abort;
+		goto abort_put_sess;
 	tunnel = pppol2tp_sock_to_tunnel(sk_tun);
 	if (tunnel == NULL)
-		goto abort;
+		goto abort_put_sess;
 
 	/* What header length is configured for this session? */
 	hdr_len = pppol2tp_l2tp_header_len(session);
@@ -1009,7 +1043,7 @@ static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 		sizeof(struct udphdr) + hdr_len + sizeof(ppph);
 	old_headroom = skb_headroom(skb);
 	if (skb_cow_head(skb, headroom))
-		goto abort;
+		goto abort_put_sess_tun;
 
 	new_headroom = skb_headroom(skb);
 	skb_orphan(skb);
@@ -1069,7 +1103,7 @@ static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	/* Get routing info from the tunnel socket */
 	dst_release(skb->dst);
 	skb->dst = dst_clone(__sk_dst_get(sk_tun));
-	skb->sk = sk_tun;
+	pppol2tp_skb_set_owner_w(skb, sk_tun);
 
 	/* Queue the packet to IP for output */
 	len = skb->len;
@@ -1086,8 +1120,14 @@ static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 		session->stats.tx_errors++;
 	}
 
+	sock_put(sk_tun);
+	sock_put(sk);
 	return 1;
 
+abort_put_sess_tun:
+	sock_put(sk_tun);
+abort_put_sess:
+	sock_put(sk);
 abort:
 	/* Free the original skb */
 	kfree_skb(skb);
@@ -1191,7 +1231,7 @@ static void pppol2tp_tunnel_destruct(struct sock *sk)
 {
 	struct pppol2tp_tunnel *tunnel;
 
-	tunnel = pppol2tp_sock_to_tunnel(sk);
+	tunnel = sk->sk_user_data;
 	if (tunnel == NULL)
 		goto end;
 
@@ -1230,10 +1270,12 @@ static void pppol2tp_session_destruct(struct sock *sk)
 	if (sk->sk_user_data != NULL) {
 		struct pppol2tp_tunnel *tunnel;
 
-		session = pppol2tp_sock_to_session(sk);
+		session = sk->sk_user_data;
 		if (session == NULL)
 			goto out;
 
+		BUG_ON(session->magic != L2TP_SESSION_MAGIC);
+
 		/* Don't use pppol2tp_sock_to_tunnel() here to
 		 * get the tunnel context because the tunnel
 		 * socket might have already been closed (its
@@ -1611,7 +1653,7 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 
 	error = ppp_register_channel(&po->chan);
 	if (error)
-		goto end;
+		goto end_put_tun;
 
 	/* This is how we get the session context from the socket. */
 	sk->sk_user_data = session;
@@ -1631,6 +1673,8 @@ out_no_ppp:
 	PRINTK(session->debug, PPPOL2TP_MSG_CONTROL, KERN_INFO,
 	       "%s: created\n", session->name);
 
+end_put_tun:
+	sock_put(tunnel_sock);
 end:
 	release_sock(sk);
 
@@ -1678,6 +1722,7 @@ static int pppol2tp_getname(struct socket *sock, struct sockaddr *uaddr,
 	*usockaddr_len = len;
 
 	error = 0;
+	sock_put(sock->sk);
 
 end:
 	return error;
@@ -1916,14 +1961,17 @@ static int pppol2tp_ioctl(struct socket *sock, unsigned int cmd,
 		err = -EBADF;
 		tunnel = pppol2tp_sock_to_tunnel(session->tunnel_sock);
 		if (tunnel == NULL)
-			goto end;
+			goto end_put_sess;
 
 		err = pppol2tp_tunnel_ioctl(tunnel, cmd, arg);
-		goto end;
+		sock_put(session->tunnel_sock);
+		goto end_put_sess;
 	}
 
 	err = pppol2tp_session_ioctl(session, cmd, arg);
 
+end_put_sess:
+	sock_put(sk);
 end:
 	return err;
 }
@@ -2069,14 +2117,17 @@ static int pppol2tp_setsockopt(struct socket *sock, int level, int optname,
 		err = -EBADF;
 		tunnel = pppol2tp_sock_to_tunnel(session->tunnel_sock);
 		if (tunnel == NULL)
-			goto end;
+			goto end_put_sess;
 
 		err = pppol2tp_tunnel_setsockopt(sk, tunnel, optname, val);
+		sock_put(session->tunnel_sock);
 	} else
 		err = pppol2tp_session_setsockopt(sk, session, optname, val);
 
 	err = 0;
 
+end_put_sess:
+	sock_put(sk);
 end:
 	return err;
 }
@@ -2191,20 +2242,24 @@ static int pppol2tp_getsockopt(struct socket *sock, int level,
 		err = -EBADF;
 		tunnel = pppol2tp_sock_to_tunnel(session->tunnel_sock);
 		if (tunnel == NULL)
-			goto end;
+			goto end_put_sess;
 
 		err = pppol2tp_tunnel_getsockopt(sk, tunnel, optname, &val);
+		sock_put(session->tunnel_sock);
 	} else
 		err = pppol2tp_session_getsockopt(sk, session, optname, &val);
 
 	err = -EFAULT;
 	if (put_user(len, (int __user *) optlen))
-		goto end;
+		goto end_put_sess;
 
 	if (copy_to_user((void __user *) optval, &val, len))
-		goto end;
+		goto end_put_sess;
 
 	err = 0;
+
+end_put_sess:
+	sock_put(sk);
 end:
 	return err;
 }
-- 
1.5.3.8

