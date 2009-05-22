Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbZEVVJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbZEVVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbZEVVFC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:05:02 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:53609 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030AbZEVVE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:04:57 -0400
Message-Id: <1a4e959be14edc314d53d49da873c5b547dfc169.1243024967.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
References: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
Subject: [mISDN PATCH v2 18/19] Use kernel_{send,recv}msg instead of open coding
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Fri, 22 May 2009 23:04:57 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Reducing the number of direct users of sock_{recv,send}msg.
Modified version to match the latest context.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/mISDN/l1oip.h      |    2 +-
 drivers/isdn/mISDN/l1oip_core.c |   24 +++++++-----------------
 2 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/isdn/mISDN/l1oip.h b/drivers/isdn/mISDN/l1oip.h
index a23d575..bc26c89 100644
--- a/drivers/isdn/mISDN/l1oip.h
+++ b/drivers/isdn/mISDN/l1oip.h
@@ -76,7 +76,7 @@ struct l1oip {
 	struct sockaddr_in	sin_local;	/* local socket name */
 	struct sockaddr_in	sin_remote;	/* remote socket name */
 	struct msghdr		sendmsg;	/* ip message to send */
-	struct iovec		sendiov;	/* iov for message */
+	struct kvec		sendiov;	/* iov for message */
 
 	/* frame */
 	struct l1oip_chan	chan[128];	/* channel instances */
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index d9cf83b..990e6a7 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -279,7 +279,6 @@ l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
 	int multi = 0;
 	u8 frame[len+32];
 	struct socket *socket = NULL;
-	mm_segment_t oldfs;
 
 	if (debug & DEBUG_L1OIP_MSG)
 		printk(KERN_DEBUG "%s: sending data to socket (len = %d)\n",
@@ -352,10 +351,7 @@ l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
 			"= %d)\n", __func__, len);
 	hc->sendiov.iov_base = frame;
 	hc->sendiov.iov_len  = len;
-	oldfs = get_fs();
-	set_fs(KERNEL_DS);
-	len = sock_sendmsg(socket, &hc->sendmsg, len);
-	set_fs(oldfs);
+	len = kernel_sendmsg(socket, &hc->sendmsg, &hc->sendiov, 1, len);
 	/* give socket back */
 	hc->socket = socket; /* no locking required */
 
@@ -660,8 +656,6 @@ l1oip_socket_thread(void *data)
 	struct l1oip *hc = (struct l1oip *)data;
 	int ret = 0;
 	struct msghdr msg;
-	struct iovec iov;
-	mm_segment_t oldfs;
 	struct sockaddr_in sin_rx;
 	unsigned char *recvbuf;
 	size_t recvbuf_size = 1500;
@@ -718,16 +712,12 @@ l1oip_socket_thread(void *data)
 	msg.msg_namelen = sizeof(sin_rx);
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
-	msg.msg_iov = &iov;
-	msg.msg_iovlen = 1;
 
 	/* build send message */
 	hc->sendmsg.msg_name = &hc->sin_remote;
 	hc->sendmsg.msg_namelen = sizeof(hc->sin_remote);
 	hc->sendmsg.msg_control = NULL;
 	hc->sendmsg.msg_controllen = 0;
-	hc->sendmsg.msg_iov    = &hc->sendiov;
-	hc->sendmsg.msg_iovlen = 1;
 
 	/* give away socket */
 	spin_lock(&hc->socket_lock);
@@ -739,12 +729,12 @@ l1oip_socket_thread(void *data)
 		printk(KERN_DEBUG "%s: socket created and open\n",
 			__func__);
 	while (!signal_pending(current)) {
-		iov.iov_base = recvbuf;
-		iov.iov_len = recvbuf_size;
-		oldfs = get_fs();
-		set_fs(KERNEL_DS);
-		recvlen = sock_recvmsg(socket, &msg, recvbuf_size, 0);
-		set_fs(oldfs);
+		struct kvec iov = {
+			.iov_base = recvbuf,
+			.iov_len = sizeof(recvbuf),
+		};
+		recvlen = kernel_recvmsg(socket, &msg, &iov, 1,
+					 sizeof(recvbuf), 0);
 		if (recvlen > 0) {
 			l1oip_socket_parse(hc, &sin_rx, recvbuf, recvlen);
 		} else {
-- 
1.6.0.2

