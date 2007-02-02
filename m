Return-Path: <linux-kernel-owner+w=401wt.eu-S1422903AbXBBEnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422903AbXBBEnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 23:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965408AbXBBEkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 23:40:51 -0500
Received: from ns2.suse.de ([195.135.220.15]:51842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422932AbXBBEkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 23:40:24 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Fri, 2 Feb 2007 15:39:57 +1100
Message-Id: <1070202043957.18991@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 004 of 14] knfsd: SUNRPC: Cache remote peer's address in svc_sock.
References: <20070202153531.18622.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Chuck Lever <chuck.lever@oracle.com>
The remote peer's address won't change after the socket has been
accepted.  We don't need to call ->getname on every incoming request.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/sunrpc/svcsock.h |    3 +++
 ./net/sunrpc/svcsock.c           |   14 ++++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff .prev/include/linux/sunrpc/svcsock.h ./include/linux/sunrpc/svcsock.h
--- .prev/include/linux/sunrpc/svcsock.h	2007-02-02 15:17:11.000000000 +1100
+++ ./include/linux/sunrpc/svcsock.h	2007-02-02 15:21:28.000000000 +1100
@@ -57,6 +57,9 @@ struct svc_sock {
 
 	/* cache of various info for TCP sockets */
 	void			*sk_info_authunix;
+
+	struct sockaddr_storage	sk_remote;	/* remote peer's address */
+	int			sk_remotelen;	/* length of address */
 };
 
 /*

diff .prev/net/sunrpc/svcsock.c ./net/sunrpc/svcsock.c
--- .prev/net/sunrpc/svcsock.c	2007-02-02 15:18:37.000000000 +1100
+++ ./net/sunrpc/svcsock.c	2007-02-02 15:21:55.000000000 +1100
@@ -560,12 +560,13 @@ svc_recv_available(struct svc_sock *svsk
 static int
 svc_recvfrom(struct svc_rqst *rqstp, struct kvec *iov, int nr, int buflen)
 {
+	struct svc_sock *svsk = rqstp->rq_sock;
 	struct msghdr	msg;
 	struct socket	*sock;
-	int		len, alen;
+	int		len;
 
 	rqstp->rq_addrlen = sizeof(rqstp->rq_addr);
-	sock = rqstp->rq_sock->sk_sock;
+	sock = svsk->sk_sock;
 
 	msg.msg_name    = &rqstp->rq_addr;
 	msg.msg_namelen = sizeof(rqstp->rq_addr);
@@ -577,11 +578,9 @@ svc_recvfrom(struct svc_rqst *rqstp, str
 	len = kernel_recvmsg(sock, &msg, iov, nr, buflen, MSG_DONTWAIT);
 
 	/* sock_recvmsg doesn't fill in the name/namelen, so we must..
-	 * possibly we should cache this in the svc_sock structure
-	 * at accept time. FIXME
 	 */
-	alen = sizeof(rqstp->rq_addr);
-	kernel_getpeername(sock, (struct sockaddr *)&rqstp->rq_addr, &alen);
+	memcpy(&rqstp->rq_addr, &svsk->sk_remote, svsk->sk_remotelen);
+	rqstp->rq_addrlen = svsk->sk_remotelen;
 
 	dprintk("svc: socket %p recvfrom(%p, %Zu) = %d\n",
 		rqstp->rq_sock, iov[0].iov_base, iov[0].iov_len, len);
@@ -925,6 +924,9 @@ svc_tcp_accept(struct svc_sock *svsk)
 	if (!(newsvsk = svc_setup_socket(serv, newsock, &err,
 				 (SVC_SOCK_ANONYMOUS | SVC_SOCK_TEMPORARY))))
 		goto failed;
+	memcpy(&newsvsk->sk_remote, &sin, slen);
+	newsvsk->sk_remotelen = slen;
+
 	svc_sock_received(newsvsk);
 
 	/* make sure that we don't have too many active connections.
