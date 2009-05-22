Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbZEVVHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbZEVVHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757964AbZEVVEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:04:53 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:50315 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007AbZEVVEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:04:50 -0400
Message-Id: <1e53a92a9ef856e74b4ce63c7dbf0be1c3161ec5.1243024967.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
References: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
Subject: [mISDN PATCH v2 11/19] Add allocation of recvbuf[1500] at run time to reduce stack size
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Fri, 22 May 2009 23:04:51 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

Before: 1656 bytes on i386, now 164.
Modified by Andreas Eversberg <andreas@eversberg.eu>

Signed-off-by: Frank Seidel <frank@f-seidel.de>
Signed-off-by: Andreas Eversberg <andreas@eversberg.eu>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/mISDN/l1oip_core.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index abe5749..ea3c3aa 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -663,18 +663,28 @@ l1oip_socket_thread(void *data)
 	struct iovec iov;
 	mm_segment_t oldfs;
 	struct sockaddr_in sin_rx;
-	unsigned char recvbuf[1500];
+	unsigned char *recvbuf;
+	size_t recvbuf_size = 1500;
 	int recvlen;
 	struct socket *socket = NULL;
 	DECLARE_COMPLETION(wait);
 
+	/* allocate buffer memory */
+	recvbuf = kmalloc(recvbuf_size, GFP_KERNEL);
+	if (!recvbuf) {
+		printk(KERN_ERR "%s: Failed to alloc recvbuf.\n", __func__);
+		ret = -ENOMEM;
+		goto fail;
+	}
+
 	/* make daemon */
 	allow_signal(SIGTERM);
 
 	/* create socket */
 	if (sock_create(PF_INET, SOCK_DGRAM, IPPROTO_UDP, &socket)) {
 		printk(KERN_ERR "%s: Failed to create socket.\n", __func__);
-		return -EIO;
+		ret = -EIO;
+		goto fail;
 	}
 
 	/* set incoming address */
@@ -730,10 +740,10 @@ l1oip_socket_thread(void *data)
 			__func__);
 	while (!signal_pending(current)) {
 		iov.iov_base = recvbuf;
-		iov.iov_len = sizeof(recvbuf);
+		iov.iov_len = recvbuf_size;
 		oldfs = get_fs();
 		set_fs(KERNEL_DS);
-		recvlen = sock_recvmsg(socket, &msg, sizeof(recvbuf), 0);
+		recvlen = sock_recvmsg(socket, &msg, recvbuf_size, 0);
 		set_fs(oldfs);
 		if (recvlen > 0) {
 			l1oip_socket_parse(hc, &sin_rx, recvbuf, recvlen);
@@ -760,6 +770,9 @@ l1oip_socket_thread(void *data)
 			__func__);
 
 fail:
+	/* free recvbuf */
+	kfree(recvbuf);
+
 	/* close socket */
 	if (socket)
 		sock_release(socket);
-- 
1.6.0.2

