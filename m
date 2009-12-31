Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbZLaPtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbZLaPtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZLaPs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:48:58 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34761 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZLaPsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:48:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=n07X4IpzfpfgEu42aU6ABUEhfz4a6uHahLfPbNZYdahSx8lRZavAJ4OdGOXHCklpep
         WxB8JB18jafkBDBXtouRF16cMoe3hWTzBsHKtUls2nXBmwPuvn29AhIuC6QklfH4mOfr
         +KI+pEuRwze0LMwa9iJkJ61Uwoo5m7recDX2s=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>, Lonnie Mendez <dignome@gmail.com>
Subject: [PATCH 04/13] USB: cypress_m8: fix DMA buffer on stack
Date: Thu, 31 Dec 2009 16:48:00 +0100
Message-Id: <1262274489-12447-5-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Lonnie Mendez <dignome@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/cypress_m8.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 60c2002..1ce1a3a 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -344,7 +344,8 @@ static int cypress_serial_control(struct tty_struct *tty,
 {
 	int new_baudrate = 0, retval = 0, tries = 0;
 	struct cypress_private *priv;
-	__u8 feature_buffer[5];
+	u8 *feature_buffer;
+	const unsigned int feature_len = 5;
 	unsigned long flags;
 
 	dbg("%s", __func__);
@@ -354,6 +355,10 @@ static int cypress_serial_control(struct tty_struct *tty,
 	if (!priv->comm_is_ok)
 		return -ENODEV;
 
+	feature_buffer = kcalloc(feature_len, sizeof(u8), GFP_KERNEL);
+	if (!feature_buffer)
+		return -ENOMEM;
+
 	switch (cypress_request_type) {
 	case CYPRESS_SET_CONFIG:
 		/* 0 means 'Hang up' so doesn't change the true bit rate */
@@ -370,7 +375,6 @@ static int cypress_serial_control(struct tty_struct *tty,
 		dbg("%s - baud rate is being sent as %d",
 					__func__, new_baudrate);
 
-		memset(feature_buffer, 0, sizeof(feature_buffer));
 		/* fill the feature_buffer with new configuration */
 		*((u_int32_t *)feature_buffer) = new_baudrate;
 		feature_buffer[4] |= data_bits;   /* assign data bits in 2 bit space ( max 3 ) */
@@ -394,15 +398,15 @@ static int cypress_serial_control(struct tty_struct *tty,
 					HID_REQ_SET_REPORT,
 					USB_DIR_OUT | USB_RECIP_INTERFACE | USB_TYPE_CLASS,
 					0x0300, 0, feature_buffer,
-					sizeof(feature_buffer), 500);
+					feature_len, 500);
 
 			if (tries++ >= 3)
 				break;
 
-		} while (retval != sizeof(feature_buffer) &&
+		} while (retval != feature_len &&
 			 retval != -ENODEV);
 
-		if (retval != sizeof(feature_buffer)) {
+		if (retval != feature_len) {
 			dev_err(&port->dev, "%s - failed sending serial "
 				"line settings - %d\n", __func__, retval);
 			cypress_set_dead(port);
@@ -422,30 +426,28 @@ static int cypress_serial_control(struct tty_struct *tty,
 			/* Not implemented for this device,
 			   and if we try to do it we're likely
 			   to crash the hardware. */
-			return -ENOTTY;
+			retval = -ENOTTY;
+			goto out;
 		}
 		dbg("%s - retreiving serial line settings", __func__);
-		/* set initial values in feature buffer */
-		memset(feature_buffer, 0, sizeof(feature_buffer));
-
 		do {
 			retval = usb_control_msg(port->serial->dev,
 					usb_rcvctrlpipe(port->serial->dev, 0),
 					HID_REQ_GET_REPORT,
 					USB_DIR_IN | USB_RECIP_INTERFACE | USB_TYPE_CLASS,
 					0x0300, 0, feature_buffer,
-					sizeof(feature_buffer), 500);
+					feature_len, 500);
 
 			if (tries++ >= 3)
 				break;
-		} while (retval != sizeof(feature_buffer)
+		} while (retval != feature_len
 						&& retval != -ENODEV);
 
-		if (retval != sizeof(feature_buffer)) {
+		if (retval != feature_len) {
 			dev_err(&port->dev, "%s - failed to retrieve serial "
 				"line settings - %d\n", __func__, retval);
 			cypress_set_dead(port);
-			return retval;
+			goto out;
 		} else {
 			spin_lock_irqsave(&priv->lock, flags);
 			/* store the config in one byte, and later
@@ -458,7 +460,8 @@ static int cypress_serial_control(struct tty_struct *tty,
 	spin_lock_irqsave(&priv->lock, flags);
 	++priv->cmd_count;
 	spin_unlock_irqrestore(&priv->lock, flags);
-
+out:
+	kfree(feature_buffer);
 	return retval;
 } /* cypress_serial_control */
 
-- 
1.6.6

