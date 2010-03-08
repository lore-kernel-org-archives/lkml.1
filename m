Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0CHNLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 08:11:09 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41582 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab0CHNLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 08:11:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=BEkqF6JouFXTeME5Wufk1jIEE2TAeRvMTcqr12dY0G89qbFUt7bSkbnEQIxUsGwZnB
         S5WCspJtNgpC6ahelj2QNMKUGx9A0FxZi46HMVecWVrqVUoKhjqNeNPXr9+EpgveaAhb
         TCzgwuSGnr9w2jh66McPWX45F+96b9yl7GORk=
From: Alessio Igor Bogani <abogani@texware.it>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johan Hovold <jhovold@gmail.com>, Alan Cox <alan@linux.intel.com>,
       Daniel Mack <daniel@caiaq.de>,
       "Mark J. Adamson" <mark.adamson@ftdichip.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] USB: ftdi_sio: Fix locking for change_speed() function
Date: Mon,  8 Mar 2010 14:10:03 +0100
Message-Id: <1268053803-7666-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change_speed() function set the baudrate of the device: so this function
should be serialized against multiple calls. Use the cfg_lock mutex to do this.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/usb/serial/ftdi_sio.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 6af0dfa..963a70f 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
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

