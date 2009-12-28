Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459AbZL1WEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbZL1WEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZL1WDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:03:00 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61514 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZL1WC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:02:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QW84mO4rrVHkLo3+ZmwFyuhnwTb2MruOtyguiQYpHsVBLiAEU1S2L4yziQ6GADQMQ4
         EIW7k7N88dY4N+oTFAptWgPIZIT81GcqsjIQcs6AMyR+vh1ZtEcm4HL9kUP7f4J1OSVt
         ldyeA+vKggMurzWqSNAfsLq55mCoB8GWP7KCM=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 10/14] USB: mos7720: fix DMA buffers on stack and clean up send_mos_cmd
Date: Mon, 28 Dec 2009 23:01:54 +0100
Message-Id: <1262037718-31424-11-git-send-email-jhovold@gmail.com>
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

