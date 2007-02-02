Return-Path: <linux-kernel-owner+w=401wt.eu-S1422946AbXBBEn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422946AbXBBEn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 23:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965384AbXBBEku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 23:40:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422903AbXBBEkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 23:40:19 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Fri, 2 Feb 2007 15:39:52 +1100
Message-Id: <1070202043952.18971@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 003 of 14] knfsd: SUNRPC: aplit svc_sock_enqueue out of svc_setup_socket.
References: <20070202153531.18622.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Rather than calling svc_sock_enqueue at the end of svc_setup_socket,
we now call it (via svc_sock_recieved) after calling svc_setup_socket
at each call site.

We do this because a subsequent patch will insert some code between
the two calls at one call site.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./net/sunrpc/svcsock.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff .prev/net/sunrpc/svcsock.c ./net/sunrpc/svcsock.c
--- .prev/net/sunrpc/svcsock.c	2007-02-02 15:15:11.000000000 +1100
+++ ./net/sunrpc/svcsock.c	2007-02-02 15:18:37.000000000 +1100
@@ -925,7 +925,7 @@ svc_tcp_accept(struct svc_sock *svsk)
 	if (!(newsvsk = svc_setup_socket(serv, newsock, &err,
 				 (SVC_SOCK_ANONYMOUS | SVC_SOCK_TEMPORARY))))
 		goto failed;
-
+	svc_sock_received(newsvsk);
 
 	/* make sure that we don't have too many active connections.
 	 * If we have, something must be dropped.
@@ -1532,8 +1532,6 @@ static struct svc_sock *svc_setup_socket
 	dprintk("svc: svc_setup_socket created %p (inet %p)\n",
 				svsk, svsk->sk_sk);
 
-	clear_bit(SK_BUSY, &svsk->sk_flags);
-	svc_sock_enqueue(svsk);
 	return svsk;
 }
 
@@ -1557,8 +1555,10 @@ int svc_addsock(struct svc_serv *serv,
 		err = -EISCONN;
 	else {
 		svsk = svc_setup_socket(serv, so, &err, SVC_SOCK_DEFAULTS);
-		if (svsk)
+		if (svsk) {
+			svc_sock_received(svsk);
 			err = 0;
+		}
 	}
 	if (err) {
 		sockfd_put(so);
@@ -1609,8 +1609,10 @@ static int svc_create_socket(struct svc_
 			goto bummer;
 	}
 
-	if ((svsk = svc_setup_socket(serv, sock, &error, flags)) != NULL)
+	if ((svsk = svc_setup_socket(serv, sock, &error, flags)) != NULL) {
+		svc_sock_received(svsk);
 		return ntohs(inet_sk(svsk->sk_sk)->sport);
+	}
 
 bummer:
 	dprintk("svc: svc_create_socket error = %d\n", -error);
