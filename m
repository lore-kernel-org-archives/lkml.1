Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZLaPty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZLaPty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZLaPtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:49:52 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41339 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbZLaPtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:49:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bY+AscoDei109zsJ+uNwFMaBFSJ8TQWtCM/kHZ9HW6bFmjRHreyXQDEeMnIB01CyUK
         wSdH9BuX40ZLqQoNl8b2IJvZHwn0s0kooq9NOlfMVf66RhcLmbJ6hS7lmOavwggLMB75
         eEnt+9Lf33q/twqWIsC1VrjcnOgxD9Qt5L+LY=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 09/13] USB: mos7720: fix DMA buffers on stack and clean up send_mos_cmd
Date: Thu, 31 Dec 2009 16:48:05 +0100
Message-Id: <1262274489-12447-10-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change data-argument type from (void *) to (u8 *) to prevent endianess
problems.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/mos7720.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 763e32a..e081dc0 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -275,13 +275,11 @@ static void mos7720_bulk_out_data_callback(struct urb *urb)
  *	this function will be used for sending command to device
  */
 static int send_mos_cmd(struct usb_serial *serial, __u8 request, __u16 value,
-			__u16 index, void *data)
+			__u16 index, u8 *data)
 {
 	int status;
-	unsigned int pipe;
+	u8 *buf;
 	u16 product = le16_to_cpu(serial->dev->descriptor.idProduct);
-	__u8 requesttype;
-	__u16 size = 0x0000;
 
 	if (value < MOS_MAX_PORT) {
 		if (product == MOSCHIP_DEVICE_ID_7715)
@@ -298,21 +296,23 @@ static int send_mos_cmd(struct usb_serial *serial, __u8 request, __u16 value,
 	}
 
 	if (request == MOS_WRITE) {
-		request = (__u8)MOS_WRITE;
-		requesttype = (__u8)0x40;
-		value  = value + (__u16)*((unsigned char *)data);
-		data = NULL;
-		pipe = usb_sndctrlpipe(serial->dev, 0);
+		value = value + *data;
+		status = usb_control_msg(serial->dev,
+				usb_sndctrlpipe(serial->dev, 0), MOS_WRITE,
+				0x40, value, index, NULL, 0, MOS_WDR_TIMEOUT);
 	} else {
-		request = (__u8)MOS_READ;
-		requesttype = (__u8)0xC0;
-		size = 0x01;
-		pipe = usb_rcvctrlpipe(serial->dev, 0);
+		buf = kmalloc(1, GFP_KERNEL);
+		if (!buf) {
+			status = -ENOMEM;
+			goto out;
+		}
+		status = usb_control_msg(serial->dev,
+				usb_rcvctrlpipe(serial->dev, 0), MOS_READ,
+				0xc0, value, index, buf, 1, MOS_WDR_TIMEOUT);
+		*data = *buf;
+		kfree(buf);
 	}
-
-	status = usb_control_msg(serial->dev, pipe, request, requesttype,
-				 value, index, data, size, MOS_WDR_TIMEOUT);
-
+out:
 	if (status < 0)
 		dbg("Command Write failed Value %x index %x\n", value, index);
 
-- 
1.6.6

