Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbZEVVH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbZEVVH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758093AbZEVVEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:04:53 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:43238 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010AbZEVVEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:04:51 -0400
Message-Id: <234a21433b574ede7ef52c07369c2adbfe111877.1243024967.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
References: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
Subject: [mISDN PATCH v2 12/19] Fix skb leak in error cases
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Fri, 22 May 2009 23:04:52 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the channel receive function returns an error the skb must be freed.

Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/mISDN/socket.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index 530f689..2a2c30a 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -209,7 +209,7 @@ mISDN_sock_sendmsg(struct kiocb *iocb, struct socket *sock,
 
 	if (memcpy_fromiovec(skb_put(skb, len), msg->msg_iov, len)) {
 		err = -EFAULT;
-		goto drop;
+		goto done;
 	}
 
 	memcpy(mISDN_HEAD_P(skb), skb->data, MISDN_HEADER_LEN);
@@ -230,19 +230,21 @@ mISDN_sock_sendmsg(struct kiocb *iocb, struct socket *sock,
 		     __func__, mISDN_HEAD_ID(skb));
 
 	err = -ENODEV;
-	if (!_pms(sk)->ch.peer ||
-	    (err = _pms(sk)->ch.recv(_pms(sk)->ch.peer, skb)))
-		goto drop;
-
-	err = len;
+	if (!_pms(sk)->ch.peer)
+		goto done;
+	err = _pms(sk)->ch.recv(_pms(sk)->ch.peer, skb);
+	if (err)
+		goto done;
+	else {
+		skb = NULL;
+		err = len;
+	}
 
 done:
+	if (skb)
+		kfree_skb(skb);
 	release_sock(sk);
 	return err;
-
-drop:
-	kfree_skb(skb);
-	goto done;
 }
 
 static int
-- 
1.6.0.2

