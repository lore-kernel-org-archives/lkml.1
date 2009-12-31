Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbZLaPtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbZLaPtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZLaPtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:49:07 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:55540 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZLaPtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:49:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Kz8GUutr33NEShGWlVrAcv/tMOJwo2d8nowtOgzQMt79TtdjJA0tsN7dIXKGqGjRvl
         w2ZQYYf/vaYm69bMf7fYkhe+jf0gYf97FEa8VWSBpvw6XFBPl9j3ZvY6jfgz/C8oOywC
         4zQgYxYRAs+C9lS9gW7OWKzpwSZTGHOQ3h8/w=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 10/13] USB: mos7840: fix DMA buffers on stack and endianess bugs
Date: Thu, 31 Dec 2009 16:48:06 +0100
Message-Id: <1262274489-12447-11-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/mos7840.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 2cfe245..04bef4b 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -283,12 +283,19 @@ static int mos7840_get_reg_sync(struct usb_serial_port *port, __u16 reg,
 {
 	struct usb_device *dev = port->serial->dev;
 	int ret = 0;
+	u8 *buf;
+
+	buf = kmalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), MCS_RDREQ,
-			      MCS_RD_RTYPE, 0, reg, val, VENDOR_READ_LENGTH,
+			      MCS_RD_RTYPE, 0, reg, buf, VENDOR_READ_LENGTH,
 			      MOS_WDR_TIMEOUT);
+	*val = buf[0];
 	dbg("mos7840_get_reg_sync offset is %x, return val %x", reg, *val);
-	*val = (*val) & 0x00ff;
+
+	kfree(buf);
 	return ret;
 }
 
@@ -341,6 +348,11 @@ static int mos7840_get_uart_reg(struct usb_serial_port *port, __u16 reg,
 	struct usb_device *dev = port->serial->dev;
 	int ret = 0;
 	__u16 Wval;
+	u8 *buf;
+
+	buf = kmalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	/* dbg("application number is %4x",
 	    (((__u16)port->number - (__u16)(port->serial->minor))+1)<<8); */
@@ -364,9 +376,11 @@ static int mos7840_get_uart_reg(struct usb_serial_port *port, __u16 reg,
 		}
 	}
 	ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), MCS_RDREQ,
-			      MCS_RD_RTYPE, Wval, reg, val, VENDOR_READ_LENGTH,
+			      MCS_RD_RTYPE, Wval, reg, buf, VENDOR_READ_LENGTH,
 			      MOS_WDR_TIMEOUT);
-	*val = (*val) & 0x00ff;
+	*val = buf[0];
+
+	kfree(buf);
 	return ret;
 }
 
-- 
1.6.6

