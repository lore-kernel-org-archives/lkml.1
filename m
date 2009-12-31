Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbZLaPuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbZLaPuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbZLaPul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:50:41 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55413 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZLaPs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:48:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DR0CQqEXxC0IA1Nbavl7G3cTH/JMo56k3ZZ/DSCCC87UFBnbelufjHUTFZGbFouu25
         Khi1dMQGcAiNyKy3v39CSrir0o2hdDyj3ezvfYVWVgxZhLTQQNntITT8hgiFlg2viiV5
         5o1QNJPcDiT5cH55wzE1W22vmkdiDGXKZAogI=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>, Oliver Neukum <oliver@neukum.name>
Subject: [PATCH 08/13] USB: kl5kusb105: fix DMA buffers on stack
Date: Thu, 31 Dec 2009 16:48:04 +0100
Message-Id: <1262274489-12447-9-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Oliver Neukum <oliver@neukum.name>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/kl5kusb105.c |   63 +++++++++++++++++++++++++++-----------
 1 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index 3a78738..731964b 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -212,10 +212,19 @@ static int klsi_105_get_line_state(struct usb_serial_port *port,
 				   unsigned long *line_state_p)
 {
 	int rc;
-	__u8 status_buf[KLSI_STATUSBUF_LEN] = { -1, -1};
+	u8 *status_buf;
 	__u16 status;
 
 	dev_info(&port->serial->dev->dev, "sending SIO Poll request\n");
+
+	status_buf = kmalloc(KLSI_STATUSBUF_LEN, GFP_KERNEL);
+	if (!status_buf) {
+		dev_err(&port->dev, "%s - out of memory for status buffer.\n",
+				__func__);
+		return -ENOMEM;
+	}
+	status_buf[0] = 0xff;
+	status_buf[1] = 0xff;
 	rc = usb_control_msg(port->serial->dev,
 			     usb_rcvctrlpipe(port->serial->dev, 0),
 			     KL5KUSB105A_SIO_POLL,
@@ -236,6 +245,8 @@ static int klsi_105_get_line_state(struct usb_serial_port *port,
 
 		*line_state_p = klsi_105_status2linestate(status);
 	}
+
+	kfree(status_buf);
 	return rc;
 }
 
@@ -364,7 +375,7 @@ static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port)
 	int rc;
 	int i;
 	unsigned long line_state;
-	struct klsi_105_port_settings cfg;
+	struct klsi_105_port_settings *cfg;
 	unsigned long flags;
 
 	dbg("%s port %d", __func__, port->number);
@@ -376,12 +387,18 @@ static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port)
 	 * Then read the modem line control and store values in
 	 * priv->line_state.
 	 */
-	cfg.pktlen   = 5;
-	cfg.baudrate = kl5kusb105a_sio_b9600;
-	cfg.databits = kl5kusb105a_dtb_8;
-	cfg.unknown1 = 0;
-	cfg.unknown2 = 1;
-	klsi_105_chg_port_settings(port, &cfg);
+	cfg = kmalloc(sizeof(*cfg), GFP_KERNEL);
+	if (!cfg) {
+		dev_err(&port->dev, "%s - out of memory for config buffer.\n",
+				__func__);
+		return -ENOMEM;
+	}
+	cfg->pktlen   = 5;
+	cfg->baudrate = kl5kusb105a_sio_b9600;
+	cfg->databits = kl5kusb105a_dtb_8;
+	cfg->unknown1 = 0;
+	cfg->unknown2 = 1;
+	klsi_105_chg_port_settings(port, cfg);
 
 	/* set up termios structure */
 	spin_lock_irqsave(&priv->lock, flags);
@@ -391,11 +408,11 @@ static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port)
 	priv->termios.c_lflag = tty->termios->c_lflag;
 	for (i = 0; i < NCCS; i++)
 		priv->termios.c_cc[i] = tty->termios->c_cc[i];
-	priv->cfg.pktlen   = cfg.pktlen;
-	priv->cfg.baudrate = cfg.baudrate;
-	priv->cfg.databits = cfg.databits;
-	priv->cfg.unknown1 = cfg.unknown1;
-	priv->cfg.unknown2 = cfg.unknown2;
+	priv->cfg.pktlen   = cfg->pktlen;
+	priv->cfg.baudrate = cfg->baudrate;
+	priv->cfg.databits = cfg->databits;
+	priv->cfg.unknown1 = cfg->unknown1;
+	priv->cfg.unknown2 = cfg->unknown2;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* READ_ON and urb submission */
@@ -441,6 +458,7 @@ static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port)
 		retval = rc;
 
 exit:
+	kfree(cfg);
 	return retval;
 } /* klsi_105_open */
 
@@ -714,10 +732,17 @@ static void klsi_105_set_termios(struct tty_struct *tty,
 	unsigned int old_iflag = old_termios->c_iflag;
 	unsigned int cflag = tty->termios->c_cflag;
 	unsigned int old_cflag = old_termios->c_cflag;
-	struct klsi_105_port_settings cfg;
+	struct klsi_105_port_settings *cfg;
 	unsigned long flags;
 	speed_t baud;
 
+	cfg = kmalloc(sizeof(*cfg), GFP_KERNEL);
+	if (!cfg) {
+		dev_err(&port->dev, "%s - out of memory for config buffer.\n",
+				__func__);
+		return;
+	}
+
 	/* lock while we are modifying the settings */
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -793,11 +818,11 @@ static void klsi_105_set_termios(struct tty_struct *tty,
 		case CS5:
 			dbg("%s - 5 bits/byte not supported", __func__);
 			spin_unlock_irqrestore(&priv->lock, flags);
-			return ;
+			goto err;
 		case CS6:
 			dbg("%s - 6 bits/byte not supported", __func__);
 			spin_unlock_irqrestore(&priv->lock, flags);
-			return ;
+			goto err;
 		case CS7:
 			priv->cfg.databits = kl5kusb105a_dtb_7;
 			break;
@@ -856,11 +881,13 @@ static void klsi_105_set_termios(struct tty_struct *tty,
 #endif
 		;
 	}
-	memcpy(&cfg, &priv->cfg, sizeof(cfg));
+	memcpy(cfg, &priv->cfg, sizeof(*cfg));
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* now commit changes to device */
-	klsi_105_chg_port_settings(port, &cfg);
+	klsi_105_chg_port_settings(port, cfg);
+err:
+	kfree(cfg);
 } /* klsi_105_set_termios */
 
 
-- 
1.6.6

