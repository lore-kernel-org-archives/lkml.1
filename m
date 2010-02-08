Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0BHUTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:19:24 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:37099 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0BHUNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:13:06 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH v2 17/41] CAPI: Fix racy capi_read
Date: Mon,  8 Feb 2010 21:12:21 +0100
Message-Id: <342ae07a02d368f2d76821f980c0118b55518f04.1265659935.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX1/Wnf16tfmIrDwkiPuAgPENBWJx6VzkDfNDHsAL
	Ka/Q5VhUM/g+dnzNo9muPCabx9r9rm4MrE0CsEhyj9KPzR4KC6
	XczRtFp4o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

capi_read still used interruptible_sleep_on, risking to miss a wakeup
this way. Convert it to wait_event_interruptible.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 drivers/isdn/capi/capi.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index f8f8660..8abec96 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -657,24 +657,19 @@ capi_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct capidev *cdev = (struct capidev *)file->private_data;
 	struct sk_buff *skb;
 	size_t copied;
+	int err;
 
 	if (!cdev->ap.applid)
 		return -ENODEV;
 
-	if ((skb = skb_dequeue(&cdev->recvqueue)) == NULL) {
-
+	skb = skb_dequeue(&cdev->recvqueue);
+	if (!skb) {
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
-
-		for (;;) {
-			interruptible_sleep_on(&cdev->recvwait);
-			if ((skb = skb_dequeue(&cdev->recvqueue)) != NULL)
-				break;
-			if (signal_pending(current))
-				break;
-		}
-		if (skb == NULL)
-			return -ERESTARTNOHAND;
+		err = wait_event_interruptible(cdev->recvwait,
+				(skb = skb_dequeue(&cdev->recvqueue)));
+		if (err)
+			return err;
 	}
 	if (skb->len > count) {
 		skb_queue_head(&cdev->recvqueue, skb);
-- 
1.6.0.2

