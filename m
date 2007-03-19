Return-Path: <linux-kernel-owner+w=401wt.eu-S1751330AbXCSJdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbXCSJdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbXCSJdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:33:40 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34863 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751330AbXCSJdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:33:39 -0400
Date: Mon, 19 Mar 2007 10:33:42 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Neil Brown <neilb@suse.de>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6.21 patch] net/sunrpc/svcsock.c: fix a check
Message-ID: <20070319093341.GS752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of kernel_recvmsg() should be assigned to "err", not 
compared with the random value of a never initialized "err"
(and the "< 0" check wrongly always returned false since == comparisons 
never have a result < 0).

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc3-mm2/net/sunrpc/svcsock.c.old	2007-03-19 09:44:40.000000000 +0100
+++ linux-2.6.21-rc3-mm2/net/sunrpc/svcsock.c	2007-03-19 09:45:18.000000000 +0100
@@ -779,8 +779,8 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 	}
 
 	clear_bit(SK_DATA, &svsk->sk_flags);
-	while ((err == kernel_recvmsg(svsk->sk_sock, &msg, NULL,
-				      0, 0, MSG_PEEK | MSG_DONTWAIT)) < 0 ||
+	while ((err = kernel_recvmsg(svsk->sk_sock, &msg, NULL,
+				     0, 0, MSG_PEEK | MSG_DONTWAIT)) < 0 ||
 	       (skb = skb_recv_datagram(svsk->sk_sk, 0, 1, &err)) == NULL) {
 		if (err == -EAGAIN) {
 			svc_sock_received(svsk);

