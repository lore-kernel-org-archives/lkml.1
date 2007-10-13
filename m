Return-Path: <linux-kernel-owner+w=401wt.eu-S1761307AbXJMOoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307AbXJMOoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbXJMOmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:10 -0400
Received: from 1wt.eu ([62.212.114.60]:2922 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbXJMOmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:08 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143450.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:32 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 10/35] TCP: Do not autobind ports for TCP sockets
Content-Disposition: inline; filename=0038-TCP-Do-not-autobind-ports-for-TCP-sockets.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[TCP]: Invoke tcp_sendmsg() directly, do not use inet_sendmsg().

As discovered by Evegniy Polyakov, if we try to sendmsg after
a connection reset, we can do incredibly stupid things.

The core issue is that inet_sendmsg() tries to autobind the
socket, but we should never do that for TCP.  Instead we should
just go straight into TCP's sendmsg() code which will do all
of the necessary state and pending socket error checks.

TCP's sendpage already directly vectors to tcp_sendpage(), so this
merely brings sendmsg() in line with that.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/tcp.h   |    2 +-
 net/ipv4/af_inet.c  |    2 +-
 net/ipv4/tcp.c      |    3 ++-
 net/ipv4/tcp_ipv4.c |    1 -
 net/ipv6/af_inet6.c |    2 +-
 net/ipv6/tcp_ipv6.c |    1 -
 6 files changed, 5 insertions(+), 6 deletions(-)

Index: 2.6/include/net/tcp.h
===================================================================
--- 2.6.orig/include/net/tcp.h
+++ 2.6/include/net/tcp.h
@@ -273,7 +273,7 @@ extern int			tcp_v4_remember_stamp(struc
 
 extern int		    	tcp_v4_tw_remember_stamp(struct inet_timewait_sock *tw);
 
-extern int			tcp_sendmsg(struct kiocb *iocb, struct sock *sk,
+extern int			tcp_sendmsg(struct kiocb *iocb, struct socket *sock,
 					    struct msghdr *msg, size_t size);
 extern ssize_t			tcp_sendpage(struct socket *sock, struct page *page, int offset, size_t size, int flags);
 
Index: 2.6/net/ipv4/af_inet.c
===================================================================
--- 2.6.orig/net/ipv4/af_inet.c
+++ 2.6/net/ipv4/af_inet.c
@@ -803,7 +803,7 @@ const struct proto_ops inet_stream_ops =
 	.shutdown	   = inet_shutdown,
 	.setsockopt	   = sock_common_setsockopt,
 	.getsockopt	   = sock_common_getsockopt,
-	.sendmsg	   = inet_sendmsg,
+	.sendmsg	   = tcp_sendmsg,
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = tcp_sendpage,
Index: 2.6/net/ipv4/tcp.c
===================================================================
--- 2.6.orig/net/ipv4/tcp.c
+++ 2.6/net/ipv4/tcp.c
@@ -658,9 +658,10 @@ static inline int select_size(struct soc
 	return tmp;
 }
 
-int tcp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
+int tcp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *msg,
 		size_t size)
 {
+	struct sock *sk = sock->sk;
 	struct iovec *iov;
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb;
Index: 2.6/net/ipv4/tcp_ipv4.c
===================================================================
--- 2.6.orig/net/ipv4/tcp_ipv4.c
+++ 2.6/net/ipv4/tcp_ipv4.c
@@ -2427,7 +2427,6 @@ struct proto tcp_prot = {
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
-	.sendmsg		= tcp_sendmsg,
 	.recvmsg		= tcp_recvmsg,
 	.backlog_rcv		= tcp_v4_do_rcv,
 	.hash			= tcp_v4_hash,
Index: 2.6/net/ipv6/af_inet6.c
===================================================================
--- 2.6.orig/net/ipv6/af_inet6.c
+++ 2.6/net/ipv6/af_inet6.c
@@ -473,7 +473,7 @@ const struct proto_ops inet6_stream_ops 
 	.shutdown	   = inet_shutdown,		/* ok		*/
 	.setsockopt	   = sock_common_setsockopt,	/* ok		*/
 	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
-	.sendmsg	   = inet_sendmsg,		/* ok		*/
+	.sendmsg	   = tcp_sendmsg,		/* ok		*/
 	.recvmsg	   = sock_common_recvmsg,	/* ok		*/
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = tcp_sendpage,
Index: 2.6/net/ipv6/tcp_ipv6.c
===================================================================
--- 2.6.orig/net/ipv6/tcp_ipv6.c
+++ 2.6/net/ipv6/tcp_ipv6.c
@@ -2127,7 +2127,6 @@ struct proto tcpv6_prot = {
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
-	.sendmsg		= tcp_sendmsg,
 	.recvmsg		= tcp_recvmsg,
 	.backlog_rcv		= tcp_v6_do_rcv,
 	.hash			= tcp_v6_hash,

-- 
