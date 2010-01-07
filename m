Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917Ab0AVXYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0AVXYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270Ab0AVXYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:24:18 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:60623 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab0AVXYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:24:04 -0500
Message-Id: <3be6c33ad163b72ee4e6821eae582a6fb50003e9.1264201407.git.jan.kiszka@web.de>
In-Reply-To: <cover.1264201406.git.jan.kiszka@web.de>
References: <cover.1264201406.git.jan.kiszka@web.de>
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org
Date: Thu, 7 Jan 2010 20:38:28 +0100
Subject: [PATCH 17/31] CAPI: Fix racy capi_read
X-Provags-ID: V01U2FsdGVkX18WbhZ4Xjc1DTm09C3PtMh8VfIKZsteLc0nns8J
	k9wN5AP+hEH5HqVcsBbsUegwnIdtNkG+esXA35KA2m/fCX9Zt2
	7hKE1mV74=
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
index b71b8b1..90a20fa 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -656,24 +656,19 @@ capi_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
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

