Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZL1WD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZL1WD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZL1WDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:03:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:59322 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbZL1WDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:03:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oqGPtCYdakOVnIhy3awUafM5YY69X5lxCUvCmmZsy0Ksl8/w97Sz6Mb1+oj3MjwmXS
         C9p05ZIKq45Y6oGz+SSJouTPikm0NnQ70iRfZlKgru9FvB9h/APHaujXyo+qpqfO4M1M
         HhX4QFlG0RntnjDO3dPluz2+DRRtOGJRudWAo=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 12/14] USB: oti6858: fix DMA buffer on stack
Date: Mon, 28 Dec 2009 23:01:56 +0100
Message-Id: <1262037718-31424-13-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/oti6858.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index c644e26..2ae97e7 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -302,7 +302,7 @@ void send_data(struct work_struct *work)
 	struct usb_serial_port *port = priv->port;
 	int count = 0, result;
 	unsigned long flags;
-	unsigned char allow;
+	u8 *allow;
 
 	dbg("%s(port = %d)", __func__, port->number);
 
@@ -321,13 +321,20 @@ void send_data(struct work_struct *work)
 		count = port->bulk_out_size;
 
 	if (count != 0) {
+		allow = kmalloc(1, GFP_KERNEL);
+		if (!allow) {
+			dev_err(&port->dev, "%s(): kmalloc failed\n",
+					__func__);
+			return;
+		}
 		result = usb_control_msg(port->serial->dev,
 				usb_rcvctrlpipe(port->serial->dev, 0),
 				OTI6858_REQ_T_CHECK_TXBUFF,
 				OTI6858_REQ_CHECK_TXBUFF,
-				count, 0, &allow, 1, 100);
-		if (result != 1 || allow != 0)
+				count, 0, allow, 1, 100);
+		if (result != 1 || *allow != 0)
 			count = 0;
+		kfree(allow);
 	}
 
 	if (count == 0) {
-- 
1.6.6

