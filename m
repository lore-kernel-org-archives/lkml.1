Return-Path: <linux-kernel-owner+w=401wt.eu-S934564AbXHWWmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934564AbXHWWmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933254AbXHWWam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:30:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33376 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956AbXHWWal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:30:41 -0400
Date: Thu, 23 Aug 2007 15:29:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 17/28] TCP: Do not autobind ports for TCP sockets
Message-ID: <20070823222911.GC18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tcp-do-not-autobind-ports-for-tcp-sockets.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Miller <davem@davemloft.net>

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

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -281,7 +281,7 @@ extern int			tcp_v4_remember_stamp(struc
 
 extern int		    	tcp_v4_tw_remember_stamp(struct inet_timewait_sock *tw);
 
-extern int			tcp_sendmsg(struct kiocb *iocb, struct sock *sk,
+extern int			tcp_sendmsg(struct kiocb *iocb, struct socket *sock,
 					    struct msghdr *msg, size_t size);
 extern ssize_t			tcp_sendpage(struct socket *sock, struct page *page, int offset, size_t size, int flags);
 
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -831,7 +831,7 @@ const struct proto_ops inet_stream_ops =
 	.shutdown	   = inet_shutdown,
 	.setsockopt	   = sock_common_setsockopt,
 	.getsockopt	   = sock_common_getsockopt,
-	.sendmsg	   = inet_sendmsg,
+	.sendmsg	   = tcp_sendmsg,
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = tcp_sendpage,
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
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
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2434,7 +2434,6 @@ struct proto tcp_prot = {
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
-	.sendmsg		= tcp_sendmsg,
 	.recvmsg		= tcp_recvmsg,
 	.backlog_rcv		= tcp_v4_do_rcv,
 	.hash			= tcp_v4_hash,
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -487,7 +487,7 @@ const struct proto_ops inet6_stream_ops 
 	.shutdown	   = inet_shutdown,		/* ok		*/
 	.setsockopt	   = sock_common_setsockopt,	/* ok		*/
 	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
-	.sendmsg	   = inet_sendmsg,		/* ok		*/
+	.sendmsg	   = tcp_sendmsg,		/* ok		*/
 	.recvmsg	   = sock_common_recvmsg,	/* ok		*/
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = tcp_sendpage,
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2135,7 +2135,6 @@ struct proto tcpv6_prot = {
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
-	.sendmsg		= tcp_sendmsg,
 	.recvmsg		= tcp_recvmsg,
 	.backlog_rcv		= tcp_v6_do_rcv,
 	.hash			= tcp_v6_hash,

-- 
