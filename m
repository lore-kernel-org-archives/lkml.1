Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbXEGAgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbXEGAgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 20:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbXEGAgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 20:36:17 -0400
Received: from mx1.suse.de ([195.135.220.2]:43432 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbXEGAgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 20:36:08 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 7 May 2007 10:35:45 +1000
Message-Id: <1070507003545.24158@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 005 of 8] knfsd: Simplify a 'while' condition in svcsock.c
References: <20070507103211.23855.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This while loop has an overly complex condition, which performs a
couple of assignments.  This hurts readability.

We don't really need a loop at all.  We can just return -EAGAIN and
(providing we set SK_DATA), the function will be called again.

So discard the loop, make the complex conditional become a few clear
function calls, and hopefully improve readability.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./net/sunrpc/svcsock.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff .prev/net/sunrpc/svcsock.c ./net/sunrpc/svcsock.c
--- .prev/net/sunrpc/svcsock.c	2007-05-07 10:30:16.000000000 +1000
+++ ./net/sunrpc/svcsock.c	2007-05-07 10:31:04.000000000 +1000
@@ -788,15 +788,20 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 	}
 
 	clear_bit(SK_DATA, &svsk->sk_flags);
-	while ((err = kernel_recvmsg(svsk->sk_sock, &msg, NULL,
-				     0, 0, MSG_PEEK | MSG_DONTWAIT)) < 0 ||
-	       (skb = skb_recv_datagram(svsk->sk_sk, 0, 1, &err)) == NULL) {
-		if (err == -EAGAIN) {
-			svc_sock_received(svsk);
-			return err;
+	skb = NULL;
+	err = kernel_recvmsg(svsk->sk_sock, &msg, NULL,
+			     0, 0, MSG_PEEK | MSG_DONTWAIT);
+	if (err >= 0)
+		skb = skb_recv_datagram(svsk->sk_sk, 0, 1, &err);
+
+	if (skb == NULL) {
+		if (err != -EAGAIN) {
+			/* possibly an icmp error */
+			dprintk("svc: recvfrom returned error %d\n", -err);
+			set_bit(SK_DATA, &svsk->sk_flags);
 		}
-		/* possibly an icmp error */
-		dprintk("svc: recvfrom returned error %d\n", -err);
+		svc_sock_received(svsk);
+		return -EAGAIN;
 	}
 	rqstp->rq_addrlen = sizeof(rqstp->rq_addr);
 	if (skb->tstamp.tv64 == 0) {
