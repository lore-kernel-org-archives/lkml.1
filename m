Return-Path: <linux-kernel-owner+w=401wt.eu-S1763587AbYFNAV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763587AbYFNAV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760906AbYFNAO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:14:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761938AbYFNAO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:14:27 -0400
Date: Fri, 13 Jun 2008 17:11:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, James Chapman <jchapman@katalix.com>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 29/47] l2tp: Fix possible oops if transmitting or receiving
	when tunnel goes down
Message-ID: <20080614001140.GC24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="l2tp-fix-possible-oops-if-transmitting-or-receiving-when-tunnel-goes-down.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: James Chapman <jchapman@katalix.com>

[ upstream commit: 24b95685ffcdb3dc28f64b9e8af6ea3e8360fbc5 ]

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
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/pppol2tp.c |  101 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 78 insertions(+), 23 deletions(-)

--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -240,12 +240,15 @@ static inline struct pppol2tp_session *p
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
 
@@ -256,12 +259,15 @@ static inline struct pppol2tp_tunnel *pp
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
@@ -745,10 +753,13 @@ static int pppol2tp_udp_encap_recv(struc
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
@@ -858,7 +869,7 @@ static int pppol2tp_sendmsg(struct kiocb
 
 	tunnel = pppol2tp_sock_to_tunnel(session->tunnel_sock);
 	if (tunnel == NULL)
-		goto error;
+		goto error_put_sess;
 
 	/* What header length is configured for this session? */
 	hdr_len = pppol2tp_l2tp_header_len(session);
@@ -870,7 +881,7 @@ static int pppol2tp_sendmsg(struct kiocb
 			   sizeof(ppph) + total_len,
 			   0, GFP_KERNEL);
 	if (!skb)
-		goto error;
+		goto error_put_sess_tun;
 
 	/* Reserve space for headers. */
 	skb_reserve(skb, NET_SKB_PAD);
@@ -900,7 +911,7 @@ static int pppol2tp_sendmsg(struct kiocb
 	error = memcpy_fromiovec(skb->data, m->msg_iov, total_len);
 	if (error < 0) {
 		kfree_skb(skb);
-		goto error;
+		goto error_put_sess_tun;
 	}
 	skb_put(skb, total_len);
 
@@ -947,10 +958,33 @@ static int pppol2tp_sendmsg(struct kiocb
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
@@ -993,10 +1027,10 @@ static int pppol2tp_xmit(struct ppp_chan
 
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
@@ -1009,7 +1043,7 @@ static int pppol2tp_xmit(struct ppp_chan
 		sizeof(struct udphdr) + hdr_len + sizeof(ppph);
 	old_headroom = skb_headroom(skb);
 	if (skb_cow_head(skb, headroom))
-		goto abort;
+		goto abort_put_sess_tun;
 
 	new_headroom = skb_headroom(skb);
 	skb_orphan(skb);
@@ -1069,7 +1103,7 @@ static int pppol2tp_xmit(struct ppp_chan
 	/* Get routing info from the tunnel socket */
 	dst_release(skb->dst);
 	skb->dst = dst_clone(__sk_dst_get(sk_tun));
-	skb->sk = sk_tun;
+	pppol2tp_skb_set_owner_w(skb, sk_tun);
 
 	/* Queue the packet to IP for output */
 	len = skb->len;
@@ -1086,8 +1120,14 @@ static int pppol2tp_xmit(struct ppp_chan
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
@@ -1191,7 +1231,7 @@ static void pppol2tp_tunnel_destruct(str
 {
 	struct pppol2tp_tunnel *tunnel;
 
-	tunnel = pppol2tp_sock_to_tunnel(sk);
+	tunnel = sk->sk_user_data;
 	if (tunnel == NULL)
 		goto end;
 
@@ -1230,10 +1270,12 @@ static void pppol2tp_session_destruct(st
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
@@ -1611,7 +1653,7 @@ static int pppol2tp_connect(struct socke
 
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
 
@@ -1671,6 +1715,7 @@ static int pppol2tp_getname(struct socke
 	*usockaddr_len = len;
 
 	error = 0;
+	sock_put(sock->sk);
 
 end:
 	return error;
@@ -1909,14 +1954,17 @@ static int pppol2tp_ioctl(struct socket 
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
@@ -2062,14 +2110,17 @@ static int pppol2tp_setsockopt(struct so
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
@@ -2184,20 +2235,24 @@ static int pppol2tp_getsockopt(struct so
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
