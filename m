Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYINOz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYINOz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYINOzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:55:14 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:39480 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbYINOzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:55:13 -0400
Message-ID: <48CD25C3.8050008@euromail.se>
Date: Sun, 14 Sep 2008 16:54:59 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: akpm@osdl.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] input: bcm5974: Switch back to normal mode when closing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.33.63
X-Scan-Result: No virus found in message 1Ket0J-0007br-6V.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Ket0J-0007br-6V fc25e4d6ecb94207ca4cbc87c02210fc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Staying in multi-touch mode after closing the device sometimes makes the keyboard drop keys or
repeat keys irratically. The conjecture is that some internal buffer starts to overflow,
resulting in undefined behavior. Switching back to normal mode when closing the device makes the
problem go away.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 18f4d7f..2998a6a 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -351,8 +351,9 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 #define BCM5974_WELLSPRING_MODE_REQUEST_VALUE		0x300
 #define BCM5974_WELLSPRING_MODE_REQUEST_INDEX		0
 #define BCM5974_WELLSPRING_MODE_VENDOR_VALUE		0x01
+#define BCM5974_WELLSPRING_MODE_NORMAL_VALUE		0x08

-static int bcm5974_wellspring_mode(struct bcm5974 *dev)
+static int bcm5974_wellspring_mode(struct bcm5974 *dev, bool on)
 {
 	char *data = kmalloc(8, GFP_KERNEL);
 	int retval = 0, size;
@@ -377,7 +378,9 @@ static int bcm5974_wellspring_mode(struct bcm5974 *dev)
 	}

 	/* apply the mode switch */
-	data[0] = BCM5974_WELLSPRING_MODE_VENDOR_VALUE;
+	data[0] = on ?
+		BCM5974_WELLSPRING_MODE_VENDOR_VALUE :
+		BCM5974_WELLSPRING_MODE_NORMAL_VALUE;

 	/* write configuration */
 	size = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
@@ -392,7 +395,8 @@ static int bcm5974_wellspring_mode(struct bcm5974 *dev)
 		goto out;
 	}

-	dprintk(2, "bcm5974: switched to wellspring mode.\n");
+	dprintk(2, "bcm5974: switched to %s mode.\n",
+		on ? "wellspring" : "normal");

  out:
 	kfree(data);
@@ -481,7 +485,7 @@ exit:
  */
 static int bcm5974_start_traffic(struct bcm5974 *dev)
 {
-	if (bcm5974_wellspring_mode(dev)) {
+	if (bcm5974_wellspring_mode(dev, true)) {
 		dprintk(1, "bcm5974: mode switch failed\n");
 		goto error;
 	}
@@ -504,6 +508,7 @@ static void bcm5974_pause_traffic(struct bcm5974 *dev)
 {
 	usb_kill_urb(dev->tp_urb);
 	usb_kill_urb(dev->bt_urb);
+	bcm5974_wellspring_mode(dev, false);
 }

 /*
-- 
1.5.4.3

