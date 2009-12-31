Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZLaPtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZLaPtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZLaPtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:49:11 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:39953 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbZLaPtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:49:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=n0qYTU1E8B0kyF/SRWo3qrkpH6l4FtOm/YogtxsuXXNRLafkIv5/BMwIZ1FErqqV76
         7oz11HMQkWoCJ/r/+bFVus92IITLrce4W14a4Omyt8g9ggz/WND6js06XfOlcM6q1ZlD
         R53Gs2BPEWtA/SD50x+fLyHOF6k5fTBBa6UjU=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 12/13] USB: visor: fix DMA buffers on stack
Date: Thu, 31 Dec 2009 16:48:08 +0100
Message-Id: <1262274489-12447-13-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/visor.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index ad1f923..178e4d9 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -807,10 +807,14 @@ static int clie_3_5_startup(struct usb_serial *serial)
 {
 	struct device *dev = &serial->dev->dev;
 	int result;
-	u8 data;
+	u8 *data;
 
 	dbg("%s", __func__);
 
+	data = kmalloc(1, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	/*
 	 * Note that PEG-300 series devices expect the following two calls.
 	 */
@@ -818,36 +822,42 @@ static int clie_3_5_startup(struct usb_serial *serial)
 	/* get the config number */
 	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 				  USB_REQ_GET_CONFIGURATION, USB_DIR_IN,
-				  0, 0, &data, 1, 3000);
+				  0, 0, data, 1, 3000);
 	if (result < 0) {
 		dev_err(dev, "%s: get config number failed: %d\n",
 							__func__, result);
-		return result;
+		goto out;
 	}
 	if (result != 1) {
 		dev_err(dev, "%s: get config number bad return length: %d\n",
 							__func__, result);
-		return -EIO;
+		result = -EIO;
+		goto out;
 	}
 
 	/* get the interface number */
 	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 				  USB_REQ_GET_INTERFACE,
 				  USB_DIR_IN | USB_RECIP_INTERFACE,
-				  0, 0, &data, 1, 3000);
+				  0, 0, data, 1, 3000);
 	if (result < 0) {
 		dev_err(dev, "%s: get interface number failed: %d\n",
 							__func__, result);
-		return result;
+		goto out;
 	}
 	if (result != 1) {
 		dev_err(dev,
 			"%s: get interface number bad return length: %d\n",
 							__func__, result);
-		return -EIO;
+		result = -EIO;
+		goto out;
 	}
 
-	return generic_startup(serial);
+	result = generic_startup(serial);
+out:
+	kfree(data);
+
+	return result;
 }
 
 static int treo_attach(struct usb_serial *serial)
-- 
1.6.6

