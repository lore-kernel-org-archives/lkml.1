Return-Path: <linux-kernel-owner+w=401wt.eu-S1422961AbXBBEmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422961AbXBBEmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 23:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422946AbXBBEl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 23:41:26 -0500
Received: from ns2.suse.de ([195.135.220.15]:51892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965439AbXBBElL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 23:41:11 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Fri, 2 Feb 2007 15:40:44 +1100
Message-Id: <1070202044044.19169@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 013 of 14] knfsd: SUNRPC: support IPv6 addresses in RPC server's UDP receive path.
References: <20070202153531.18622.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Chuck Lever <chuck.lever@oracle.com>
Add support for IPv6 addresses in the RPC server's UDP receive path.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/sunrpc/svc.h |    5 +++
 ./net/sunrpc/svcsock.c       |   55 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 50 insertions(+), 10 deletions(-)

diff .prev/include/linux/sunrpc/svc.h ./include/linux/sunrpc/svc.h
--- .prev/include/linux/sunrpc/svc.h	2007-02-02 15:22:32.000000000 +1100
+++ ./include/linux/sunrpc/svc.h	2007-02-02 15:22:58.000000000 +1100
@@ -270,6 +270,11 @@ static inline struct sockaddr_in *svc_ad
 	return (struct sockaddr_in *) &rqst->rq_addr;
 }
 
+static inline struct sockaddr_in6 *svc_addr_in6(struct svc_rqst *rqst)
+{
+	return (struct sockaddr_in6 *) &rqst->rq_addr;
+}
+
 static inline struct sockaddr *svc_addr(struct svc_rqst *rqst)
 {
 	return (struct sockaddr *) &rqst->rq_addr;

diff .prev/net/sunrpc/svcsock.c ./net/sunrpc/svcsock.c
--- .prev/net/sunrpc/svcsock.c	2007-02-02 15:22:40.000000000 +1100
+++ ./net/sunrpc/svcsock.c	2007-02-02 15:22:58.000000000 +1100
@@ -715,13 +715,55 @@ svc_write_space(struct sock *sk)
 	}
 }
 
+static void svc_udp_get_sender_address(struct svc_rqst *rqstp,
+					struct sk_buff *skb)
+{
+	switch (rqstp->rq_sock->sk_sk->sk_family) {
+	case AF_INET:
+		/* this seems to come from net/ipv4/udp.c:udp_recvmsg */
+		do {
+			struct sockaddr_in *sin = svc_addr_in(rqstp);
+
+			sin->sin_family = AF_INET;
+			sin->sin_port = skb->h.uh->source;
+			sin->sin_addr.s_addr = skb->nh.iph->saddr;
+			rqstp->rq_addrlen = sizeof(struct sockaddr_in);
+			/* Remember which interface received this request */
+			rqstp->rq_daddr.addr.s_addr = skb->nh.iph->daddr;
+		} while (0);
+		break;
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	case AF_INET6:
+		/* this is derived from net/ipv6/udp.c:udpv6_recvmesg */
+		do {
+			struct sockaddr_in6 *sin6 = svc_addr_in6(rqstp);
+
+			sin6->sin6_family = AF_INET6;
+			sin6->sin6_port = skb->h.uh->source;
+			sin6->sin6_flowinfo = 0;
+			sin6->sin6_scope_id = 0;
+			if (ipv6_addr_type(&sin6->sin6_addr) &
+							IPV6_ADDR_LINKLOCAL)
+				sin6->sin6_scope_id = IP6CB(skb)->iif;
+			ipv6_addr_copy(&sin6->sin6_addr,
+							&skb->nh.ipv6h->saddr);
+			rqstp->rq_addrlen = sizeof(struct sockaddr_in);
+			/* Remember which interface received this request */
+			ipv6_addr_copy(&rqstp->rq_daddr.addr6,
+							&skb->nh.ipv6h->saddr);
+		} while (0);
+		break;
+#endif
+	}
+	return;
+}
+
 /*
  * Receive a datagram from a UDP socket.
  */
 static int
 svc_udp_recvfrom(struct svc_rqst *rqstp)
 {
-	struct sockaddr_in *sin = svc_addr_in(rqstp);
 	struct svc_sock	*svsk = rqstp->rq_sock;
 	struct svc_serv	*serv = svsk->sk_server;
 	struct sk_buff	*skb;
@@ -774,16 +816,9 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 	len  = skb->len - sizeof(struct udphdr);
 	rqstp->rq_arg.len = len;
 
-	rqstp->rq_prot        = IPPROTO_UDP;
-
-	/* Get sender address */
-	sin->sin_family = AF_INET;
-	sin->sin_port = skb->h.uh->source;
-	sin->sin_addr.s_addr = skb->nh.iph->saddr;
-	rqstp->rq_addrlen = sizeof(struct sockaddr_in);
+	rqstp->rq_prot = IPPROTO_UDP;
 
-	/* Remember which interface received this request */
-	rqstp->rq_daddr.addr.s_addr = skb->nh.iph->daddr;
+	svc_udp_get_sender_address(rqstp, skb);
 
 	if (skb_is_nonlinear(skb)) {
 		/* we have to copy */
