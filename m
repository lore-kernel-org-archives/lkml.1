Return-Path: <linux-kernel-owner+w=401wt.eu-S1423010AbXBBExQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423010AbXBBExQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 23:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423013AbXBBExQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 23:53:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:37254 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423010AbXBBExP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 23:53:15 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Fri, 2 Feb 2007 15:52:47 +1100
Message-Id: <1070202045247.24710@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [RESEND] [PATCH 012 of 14] knfsd: SUNRPC: Support IPv6 addresses in svc_tcp_accept
References: <20070202154949.24444.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, missed a cast in a dprintk that I could remove (and a '&' that
had to go too).
NeilBrown


### Comments for Changeset

From: Chuck Lever <chuck.lever@oracle.com>
Modify svc_tcp_accept to support connecting on IPv6 sockets.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./net/sunrpc/svcsock.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff .prev/net/sunrpc/svcsock.c ./net/sunrpc/svcsock.c
--- .prev/net/sunrpc/svcsock.c	2007-02-02 15:48:21.000000000 +1100
+++ ./net/sunrpc/svcsock.c	2007-02-02 15:48:39.000000000 +1100
@@ -949,7 +949,8 @@ static inline int svc_port_is_privileged
 static void
 svc_tcp_accept(struct svc_sock *svsk)
 {
-	struct sockaddr_in sin;
+	struct sockaddr_storage addr;
+	struct sockaddr	*sin = (struct sockaddr *) &addr;
 	struct svc_serv	*serv = svsk->sk_server;
 	struct socket	*sock = svsk->sk_sock;
 	struct socket	*newsock;
@@ -976,8 +977,7 @@ svc_tcp_accept(struct svc_sock *svsk)
 	set_bit(SK_CONN, &svsk->sk_flags);
 	svc_sock_enqueue(svsk);
 
-	slen = sizeof(sin);
-	err = kernel_getpeername(newsock, (struct sockaddr *) &sin, &slen);
+	err = kernel_getpeername(newsock, sin, &slen);
 	if (err < 0) {
 		if (net_ratelimit())
 			printk(KERN_WARNING "%s: peername failed (err %d)!\n",
@@ -989,16 +989,14 @@ svc_tcp_accept(struct svc_sock *svsk)
 	 * hosts here, but when we get encryption, the IP of the host won't
 	 * tell us anything.  For now just warn about unpriv connections.
 	 */
-	if (!svc_port_is_privileged((struct sockaddr *) &sin)) {
+	if (!svc_port_is_privileged(sin)) {
 		dprintk(KERN_WARNING
 			"%s: connect from unprivileged port: %s\n",
 			serv->sv_name,
-			__svc_print_addr((struct sockaddr *) &sin, buf,
-								sizeof(buf)));
+			__svc_print_addr(sin, buf, sizeof(buf)));
 	}
 	dprintk("%s: connect from %s\n", serv->sv_name,
-		__svc_print_addr((struct sockaddr *) &sin, buf,
-				 sizeof(buf)));
+		__svc_print_addr(sin, buf, sizeof(buf)));
 
 	/* make sure that a write doesn't block forever when
 	 * low on memory
@@ -1008,7 +1006,7 @@ svc_tcp_accept(struct svc_sock *svsk)
 	if (!(newsvsk = svc_setup_socket(serv, newsock, &err,
 				 (SVC_SOCK_ANONYMOUS | SVC_SOCK_TEMPORARY))))
 		goto failed;
-	memcpy(&newsvsk->sk_remote, &sin, slen);
+	memcpy(&newsvsk->sk_remote, sin, slen);
 	newsvsk->sk_remotelen = slen;
 
 	svc_sock_received(newsvsk);
