Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZJ1JwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZJ1JwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZJ1JwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:52:01 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:43455 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbZJ1JvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:51:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=mmziwBeXUtHwsRHps/73NDAJdlC1+CfKbN/ECWr6kavThBEqsxADGZKiAtIhkeUY7V
         rKr7dIShKFsZLYqbTvuC9H3JpEBx4hyfygeTmgrgrs2de0GXz6XJx+MSGkAlBMOlHzXC
         m0CY2YZWVfevBYb+BVPtoUp3jTcD8rGCiOYbw=
Message-Id: <20091028095108.305735076@gmail.com>
References: <20091028094324.010816897@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 28 Oct 2009 10:43:28 +0100
From: bart.hartgers@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>, Mike McCormack <mikem@ring3k.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bart Hartgers <bart.hartgers@gmail.com>
Subject: [PATCH 4/6] ark3116: (v2) Add cmset and break
Content-Disposition: inline; filename=0025_ark3116_break_cmset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
---
Index: linux-2.6.32-rc4/drivers/usb/serial/ark3116.c
===================================================================
--- linux-2.6.32-rc4.orig/drivers/usb/serial/ark3116.c	2009-10-28 10:19:44.000000000 +0100
+++ linux-2.6.32-rc4/drivers/usb/serial/ark3116.c	2009-10-28 10:19:45.000000000 +0100
@@ -551,6 +551,60 @@ static int ark3116_tiocmget(struct tty_s
 		(ctrl   & UART_MCR_OUT2 ? TIOCM_OUT2 : 0);
 }
 
+static int ark3116_tiocmset(struct tty_struct *tty, struct file *file,
+			unsigned set, unsigned clr)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct ark3116_private *priv = usb_get_serial_port_data(port);
+
+	/* we need to take the mutex here, to make sure that the value
+	 * in priv->mcr is actually the one that is in the hardware
+	 */
+
+	mutex_lock(&priv->hw_lock);
+
+	if (set & TIOCM_RTS)
+		priv->mcr |= UART_MCR_RTS;
+	if (set & TIOCM_DTR)
+		priv->mcr |= UART_MCR_DTR;
+	if (set & TIOCM_OUT1)
+		priv->mcr |= UART_MCR_OUT1;
+	if (set & TIOCM_OUT2)
+		priv->mcr |= UART_MCR_OUT2;
+	if (clr & TIOCM_RTS)
+		priv->mcr &= ~UART_MCR_RTS;
+	if (clr & TIOCM_DTR)
+		priv->mcr &= ~UART_MCR_DTR;
+	if (clr & TIOCM_OUT1)
+		priv->mcr &= ~UART_MCR_OUT1;
+	if (clr & TIOCM_OUT2)
+		priv->mcr &= ~UART_MCR_OUT2;
+
+	ark3116_write_reg(port->serial, UART_MCR, priv->mcr);
+
+	mutex_unlock(&priv->hw_lock);
+
+	return 0;
+}
+
+static void ark3116_break_ctl(struct tty_struct *tty, int break_state)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct ark3116_private *priv = usb_get_serial_port_data(port);
+
+	/* LCR is also used for other things: protect access */
+	mutex_lock(&priv->hw_lock);
+
+	if (break_state)
+		priv->lcr |= UART_LCR_SBC;
+	else
+		priv->lcr &= ~UART_LCR_SBC;
+
+	ark3116_write_reg(port->serial, UART_LCR, priv->lcr);
+
+	mutex_unlock(&priv->hw_lock);
+}
+
 static struct usb_driver ark3116_driver = {
 	.name =		"ark3116",
 	.probe =	usb_serial_probe,
@@ -573,8 +627,10 @@ static struct usb_serial_driver ark3116_
 	.init_termios =		ark3116_init_termios,
 	.ioctl =		ark3116_ioctl,
 	.tiocmget =		ark3116_tiocmget,
+	.tiocmset =		ark3116_tiocmset,
 	.open =			ark3116_open,
 	.close =		ark3116_close,
+	.break_ctl = 		ark3116_break_ctl,
 };
 
 static int __init ark3116_init(void)

-- 
