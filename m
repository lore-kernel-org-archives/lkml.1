Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbZL1WDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbZL1WDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZL1WC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:02:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:47692 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZL1WCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:02:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nw5FcEXOe/jw4MjK5sOPeElFzUwexEsaJoa+JyVozum5/dr0TQyrkwnM9tGdoXkBwy
         zgf8xrlvMAG8Dj4ORz2h8hNZT8CDzrYENEWxSZP+A+1ILrzNehOyaUbWW90yJVcdKb6L
         +ZtSVVEFfIV5TnbrqX4r/h32EKVeCR3Z8i5XE=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 09/14] USB: mct_u232: fix DMA buffers on stack
Date: Mon, 28 Dec 2009 23:01:53 +0100
Message-Id: <1262037718-31424-10-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/mct_u232.c |   67 +++++++++++++++++++++++++++++++++--------
 1 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index cd009cb..67e86b0 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -231,19 +231,25 @@ static int mct_u232_calculate_baud_rate(struct usb_serial *serial,
 static int mct_u232_set_baud_rate(struct tty_struct *tty,
 	struct usb_serial *serial, struct usb_serial_port *port, speed_t value)
 {
+	u8 *buf;
 	__le32 divisor;
 	int rc;
-	unsigned char zero_byte = 0;
-	unsigned char cts_enable_byte = 0;
 	speed_t speed;
 
+	buf = kmalloc(4, GFP_KERNEL);
+	if (!buf) {
+		dev_err(&port->dev, "%s - memory allocation failed\n",
+				__func__);
+		return -ENOMEM;
+	}
+
 	divisor = cpu_to_le32(mct_u232_calculate_baud_rate(serial, value,
 								&speed));
-
+	*(u32 *)buf = divisor;
 	rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 				MCT_U232_SET_BAUD_RATE_REQUEST,
 				MCT_U232_SET_REQUEST_TYPE,
-				0, 0, &divisor, MCT_U232_SET_BAUD_RATE_SIZE,
+				0, 0, buf, MCT_U232_SET_BAUD_RATE_SIZE,
 				WDR_TIMEOUT);
 	if (rc < 0)	/*FIXME: What value speed results */
 		dev_err(&port->dev, "Set BAUD RATE %d failed (error = %d)\n",
@@ -268,11 +274,11 @@ static int mct_u232_set_baud_rate(struct tty_struct *tty,
 	   value of 1 is used by this driver), data will not be transmitted to
 	   a device which is not asserting 'CTS'.
 	*/
-
+	buf[0] = 0;
 	rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 				MCT_U232_SET_UNKNOWN1_REQUEST,
 				MCT_U232_SET_REQUEST_TYPE,
-				0, 0, &zero_byte, MCT_U232_SET_UNKNOWN1_SIZE,
+				0, 0, buf, MCT_U232_SET_UNKNOWN1_SIZE,
 				WDR_TIMEOUT);
 	if (rc < 0)
 		dev_err(&port->dev, "Sending USB device request code %d "
@@ -280,76 +286,111 @@ static int mct_u232_set_baud_rate(struct tty_struct *tty,
 			rc);
 
 	if (port && C_CRTSCTS(tty))
-	   cts_enable_byte = 1;
+		buf[0] = 1;
+	else
+		buf[0] = 0;
 
 	dbg("set_baud_rate: send second control message, data = %02X",
-							cts_enable_byte);
+							buf[0]);
 	rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 			MCT_U232_SET_CTS_REQUEST,
 			MCT_U232_SET_REQUEST_TYPE,
-			0, 0, &cts_enable_byte, MCT_U232_SET_CTS_SIZE,
+			0, 0, buf, MCT_U232_SET_CTS_SIZE,
 			WDR_TIMEOUT);
 	if (rc < 0)
 		dev_err(&port->dev, "Sending USB device request code %d "
 			"failed (error = %d)\n", MCT_U232_SET_CTS_REQUEST, rc);
 
+	kfree(buf);
 	return rc;
 } /* mct_u232_set_baud_rate */
 
 static int mct_u232_set_line_ctrl(struct usb_serial *serial, unsigned char lcr)
 {
 	int rc;
+	u8 *buf;
+
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf) {
+		dev_err(&serial->dev->dev,
+			"%s - memory allocation failed\n", __func__);
+		return -ENOMEM;
+	}
+	buf[0] = lcr;
 	rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 			MCT_U232_SET_LINE_CTRL_REQUEST,
 			MCT_U232_SET_REQUEST_TYPE,
-			0, 0, &lcr, MCT_U232_SET_LINE_CTRL_SIZE,
+			0, 0, buf, MCT_U232_SET_LINE_CTRL_SIZE,
 			WDR_TIMEOUT);
 	if (rc < 0)
 		dev_err(&serial->dev->dev,
 			"Set LINE CTRL 0x%x failed (error = %d)\n", lcr, rc);
 	dbg("set_line_ctrl: 0x%x", lcr);
+	kfree(buf);
 	return rc;
 } /* mct_u232_set_line_ctrl */
 
 static int mct_u232_set_modem_ctrl(struct usb_serial *serial,
 				   unsigned int control_state)
 {
+	u8 *buf;
 	int rc;
 	unsigned char mcr = MCT_U232_MCR_NONE;
 
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf) {
+		dev_err(&serial->dev->dev,
+			"%s - memory allocation failed\n", __func__);
+		return -ENOMEM;
+	}
+
 	if (control_state & TIOCM_DTR)
 		mcr |= MCT_U232_MCR_DTR;
 	if (control_state & TIOCM_RTS)
 		mcr |= MCT_U232_MCR_RTS;
 
+	buf[0] = mcr;
 	rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 			MCT_U232_SET_MODEM_CTRL_REQUEST,
 			MCT_U232_SET_REQUEST_TYPE,
-			0, 0, &mcr, MCT_U232_SET_MODEM_CTRL_SIZE,
+			0, 0, buf, MCT_U232_SET_MODEM_CTRL_SIZE,
 			WDR_TIMEOUT);
 	if (rc < 0)
 		dev_err(&serial->dev->dev,
 			"Set MODEM CTRL 0x%x failed (error = %d)\n", mcr, rc);
 	dbg("set_modem_ctrl: state=0x%x ==> mcr=0x%x", control_state, mcr);
 
+	kfree(buf);
 	return rc;
 } /* mct_u232_set_modem_ctrl */
 
 static int mct_u232_get_modem_stat(struct usb_serial *serial,
 						unsigned char *msr)
 {
+	u8 *buf;
 	int rc;
+
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf) {
+		dev_err(&serial->dev->dev,
+			"%s - memory allocation failed\n", __func__);
+		*msr = 0;
+		return -ENOMEM;
+	}
+
 	rc = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 			MCT_U232_GET_MODEM_STAT_REQUEST,
 			MCT_U232_GET_REQUEST_TYPE,
-			0, 0, msr, MCT_U232_GET_MODEM_STAT_SIZE,
+			0, 0, buf, MCT_U232_GET_MODEM_STAT_SIZE,
 			WDR_TIMEOUT);
 	if (rc < 0) {
 		dev_err(&serial->dev->dev,
 			"Get MODEM STATus failed (error = %d)\n", rc);
 		*msr = 0;
-	}
+	} else
+		*msr = buf[0];
 	dbg("get_modem_stat: 0x%x", *msr);
+	kfree(buf);
 	return rc;
 } /* mct_u232_get_modem_stat */
 
-- 
1.6.6

