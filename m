Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZESOrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZESOrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZESOq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:46:56 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:59354 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbZESOq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:46:56 -0400
Message-Id: <4fbc055498a370fbe918ac50bcea70b7fd83bad3.1242739648.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
Subject: [PATCH 17/19] Fix skb leak in error cases
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Tue, 19 May 2009 15:58:34 +0200
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

