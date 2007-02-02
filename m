Return-Path: <linux-kernel-owner+w=401wt.eu-S1422964AbXBBEnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422964AbXBBEnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 23:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422903AbXBBElY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 23:41:24 -0500
Received: from ns2.suse.de ([195.135.220.15]:51901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965434AbXBBElS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 23:41:18 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Fri, 2 Feb 2007 15:40:49 +1100
Message-Id: <1070202044049.19193@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 014 of 14] knfsd: SUNRPC: fix up svc_create_socket() to take a sockaddr struct + length
References: <20070202153531.18622.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Chuck Lever <chuck.lever@oracle.com>

Replace existing svc_create_socket() API to allow callers to pass addresses
larger than a sockaddr_in.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./net/sunrpc/svcsock.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff .prev/net/sunrpc/svcsock.c ./net/sunrpc/svcsock.c
--- .prev/net/sunrpc/svcsock.c	2007-02-02 15:22:58.000000000 +1100
+++ ./net/sunrpc/svcsock.c	2007-02-02 15:22:59.000000000 +1100
@@ -1691,7 +1691,7 @@ EXPORT_SYMBOL_GPL(svc_addsock);
  * Create socket for RPC service.
  */
 static int svc_create_socket(struct svc_serv *serv, int protocol,
-				struct sockaddr_in *sin, int flags)
+				struct sockaddr *sin, int len, int flags)
 {
 	struct svc_sock	*svsk;
 	struct socket	*sock;
@@ -1701,8 +1701,7 @@ static int svc_create_socket(struct svc_
 
 	dprintk("svc: svc_create_socket(%s, %d, %s)\n",
 			serv->sv_program->pg_name, protocol,
-			__svc_print_addr((struct sockaddr *) sin, buf,
-								sizeof(buf)));
+			__svc_print_addr(sin, buf, sizeof(buf)));
 
 	if (protocol != IPPROTO_UDP && protocol != IPPROTO_TCP) {
 		printk(KERN_WARNING "svc: only UDP and TCP "
@@ -1711,15 +1710,15 @@ static int svc_create_socket(struct svc_
 	}
 	type = (protocol == IPPROTO_UDP)? SOCK_DGRAM : SOCK_STREAM;
 
-	if ((error = sock_create_kern(PF_INET, type, protocol, &sock)) < 0)
+	error = sock_create_kern(sin->sa_family, type, protocol, &sock);
+	if (error < 0)
 		return error;
 
 	svc_reclassify_socket(sock);
 
 	if (type == SOCK_STREAM)
-		sock->sk->sk_reuse = 1; /* allow address reuse */
-	error = kernel_bind(sock, (struct sockaddr *) sin,
-					sizeof(*sin));
+		sock->sk->sk_reuse = 1;		/* allow address reuse */
+	error = kernel_bind(sock, sin, len);
 	if (error < 0)
 		goto bummer;
 
@@ -1799,7 +1798,8 @@ int svc_makesock(struct svc_serv *serv, 
 	};
 
 	dprintk("svc: creating socket proto = %d\n", protocol);
-	return svc_create_socket(serv, protocol, &sin, flags);
+	return svc_create_socket(serv, protocol, (struct sockaddr *) &sin,
+							sizeof(sin), flags);
 }
 
 /*
