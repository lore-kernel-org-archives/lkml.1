Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbZL1WDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbZL1WDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZL1WDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:03:24 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60134 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbZL1WDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:03:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=yIJcy/oHVHg5ZVjYLkWWxBJQGGGtMu2AuHSa6uadpw8uKkLzz9dFNpTwn96OzL6uWU
         /6pLJzPdYkqdt8yQ7DmBm6DofnTMyj5+CFZzU98apr1/q8Gl22BC/cUKHCvmBmRpEbXl
         sAtI8zLwOWsRrtQTO4suSgw81fqXljAUUmSyg=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 14/14] USB: kobil_sct: clean up kobil_set_termios
Date: Mon, 28 Dec 2009 23:01:58 +0100
Message-Id: <1262037718-31424-15-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill string that is allocated and generated using speed and parity
settings but is never used (and never has been).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/kobil_sct.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 45ea694..f917c5b 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -624,7 +624,6 @@ static void kobil_set_termios(struct tty_struct *tty,
 	unsigned short urb_val = 0;
 	int c_cflag = tty->termios->c_cflag;
 	speed_t speed;
-	void *settings;
 
 	priv = usb_get_serial_port_data(port);
 	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID ||
@@ -647,25 +646,13 @@ static void kobil_set_termios(struct tty_struct *tty,
 	}
 	urb_val |= (c_cflag & CSTOPB) ? SUSBCR_SPASB_2StopBits :
 							SUSBCR_SPASB_1StopBit;
-
-	settings = kzalloc(50, GFP_KERNEL);
-	if (!settings)
-		return;
-
-	sprintf(settings, "%d ", speed);
-
 	if (c_cflag & PARENB) {
-		if  (c_cflag & PARODD) {
+		if  (c_cflag & PARODD)
 			urb_val |= SUSBCR_SPASB_OddParity;
-			strcat(settings, "Odd Parity");
-		} else {
+		else
 			urb_val |= SUSBCR_SPASB_EvenParity;
-			strcat(settings, "Even Parity");
-		}
-	} else {
+	} else
 		urb_val |= SUSBCR_SPASB_NoParity;
-		strcat(settings, "No Parity");
-	}
 	tty->termios->c_cflag &= ~CMSPAR;
 	tty_encode_baud_rate(tty, speed, speed);
 
@@ -675,11 +662,10 @@ static void kobil_set_termios(struct tty_struct *tty,
 		  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
 		  urb_val,
 		  0,
-		  settings,
+		  NULL,
 		  0,
 		  KOBIL_TIMEOUT
 		);
-	kfree(settings);
 }
 
 static int kobil_ioctl(struct tty_struct *tty, struct file *file,
-- 
1.6.6

