Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbZLaPt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbZLaPt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZLaPtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:49:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33387 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZLaPtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:49:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sxJauSegkOXBJ6GB+C/ewciotKlYrVSRzN8PkOVsb255xzH3YndYez1ctnakznLn/C
         mGUZmyOykSzQQ9rPzzMH6L3a1Cw3q1dy8g9MMGASWC2YHafB1a8WbyCdPNb7GKzs8xpa
         7Uo40gckrb9qNEl+aSk3eU66anNUt0ZewmNg8=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 13/13] USB: kobil_sct: clean up kobil_set_termios
Date: Thu, 31 Dec 2009 16:48:09 +0100
Message-Id: <1262274489-12447-14-git-send-email-jhovold@gmail.com>
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

