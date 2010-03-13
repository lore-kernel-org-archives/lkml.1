Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab0CMRff (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 12:35:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:2700 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab0CMRfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 12:35:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=r8XAhcJpBcw47lHef8BSuxHrE/rYwod0aBqSBMcgkf2PxFPx2nM4iApvX45I7xPLoB
         V5kdq5RU00LgBMEvl4vqddbkhwUyBZRjzz03pYpTker7Ui2p7tQ6FA+ULjwa+MC2Picu
         NtExnmQiCIB3AVMmOnvdAwWZj7pn3pW/6U9Kc=
From: Alessio Igor Bogani <abogani@texware.it>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johan Hovold <jhovold@gmail.com>, Alan Cox <alan@linux.intel.com>,
       Daniel Mack <daniel@caiaq.de>, Mark Adamson <mark.adamson@ftdichip.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] USB: ftdi_sio: Fix locking for change_speed() function
Date: Sat, 13 Mar 2010 18:35:14 +0100
Message-Id: <1268501714-5464-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change_speed() function should be serialized against multiple calls.
Use the cfg_lock mutex to do this.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/usb/serial/ftdi_sio.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 6af0dfa..830f423 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -91,7 +91,7 @@ struct ftdi_private {
 	unsigned long tx_outstanding_bytes;
 	unsigned long tx_outstanding_urbs;
 	unsigned short max_packet_size;
-	struct mutex cfg_lock; /* Avoid mess by parallel calls of config ioctl() */
+	struct mutex cfg_lock; /* Avoid mess by parallel calls of config ioctl() and change_speed() */
 };
 
 /* struct ftdi_sio_quirk is used by devices requiring special attention. */
@@ -1272,8 +1272,8 @@ check_and_exit:
 	     (priv->flags & ASYNC_SPD_MASK)) ||
 	    (((priv->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST) &&
 	     (old_priv.custom_divisor != priv->custom_divisor))) {
-		mutex_unlock(&priv->cfg_lock);
 		change_speed(tty, port);
+		mutex_unlock(&priv->cfg_lock);
 	}
 	else
 		mutex_unlock(&priv->cfg_lock);
@@ -2264,9 +2264,11 @@ static void ftdi_set_termios(struct tty_struct *tty,
 		clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	} else {
 		/* set the baudrate determined before */
+		mutex_lock(&priv->cfg_lock);
 		if (change_speed(tty, port))
 			dev_err(&port->dev, "%s urb failed to set baudrate\n",
 				__func__);
+		mutex_unlock(&priv->cfg_lock);
 		/* Ensure RTS and DTR are raised when baudrate changed from 0 */
 		if (!old_termios || (old_termios->c_cflag & CBAUD) == B0)
 			set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
-- 
1.6.3.3

