Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZJYRyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZJYRyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 13:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZJYRym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 13:54:42 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:46624 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbZJYRxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 13:53:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=rnTAswr7fJPxeA4HktdocTH1AJMmvgkVPGuUYvvdQkcgrxFi7eJI5UbzrDetEFcnYl
         9JqrMmJ8Djancm05rrIdSqpMTP9HnejDo7s9kdmW13Bo1kyQcc7vLhvbh3Q5jIHbxVLv
         nRRzvMq5akCNkugHNgQJy+3VFLuX5Eqj9E3lM=
Message-Id: <20091025175325.603584293@gmail.com>
References: <20091025175057.270011110@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 25 Oct 2009 18:51:02 +0100
From: bart.hartgers@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bart Hartgers <bart.hartgers@gmail.com>
Subject: [PATCH 5/7] ark3116: (3rd try) Add cmset and break
Content-Disposition: inline; filename=0025_ark3116_break_cmset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
---
Index: linux-2.6.32-rc4/drivers/usb/serial/ark3116.c
===================================================================
--- linux-2.6.32-rc4.orig/drivers/usb/serial/ark3116.c	2009-10-18 16:20:17.000000000 +0200
+++ linux-2.6.32-rc4/drivers/usb/serial/ark3116.c	2009-10-18 16:20:20.000000000 +0200
@@ -570,6 +570,62 @@ static int ark3116_tiocmget(struct tty_s
 		(ctrl   & UART_MCR_OUT2 ? TIOCM_OUT2 : 0);
 }
 
+static int ark3116_tiocmset(struct tty_struct *tty, struct file *file,
+			unsigned set, unsigned clr)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct ark3116_private *priv = usb_get_serial_port_data(port);
+	unsigned setmask = 0;
+	unsigned clrmask = 0;
+
+	if (set & TIOCM_RTS)
+		setmask |= UART_MCR_RTS;
+	if (set & TIOCM_DTR)
+		setmask |= UART_MCR_DTR;
+	if (set & TIOCM_OUT1)
+		setmask |= UART_MCR_OUT1;
+	if (set & TIOCM_OUT2)
+		setmask |= UART_MCR_OUT2;
+	if (clr & TIOCM_RTS)
+		clrmask |= UART_MCR_RTS;
+	if (clr & TIOCM_DTR)
+		clrmask |= UART_MCR_DTR;
+	if (clr & TIOCM_OUT1)
+		clrmask |= UART_MCR_OUT1;
+	if (clr & TIOCM_OUT2)
+		clrmask |= UART_MCR_OUT2;
+
+	ark3116_atomic_set_clear(setmask, clrmask, &priv->mcr);
+
+	/* unfortunately, we need the mutex, to make sure that the value
+	 * in priv->mcr is actually the one that is in the hardware
+	 */
+
+	mutex_lock(&priv->lock);
+	ark3116_write_reg(port->serial, UART_MCR, atomic_read(&priv->mcr));
+	mutex_unlock(&priv->lock);
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
+	mutex_lock(&priv->lock);
+
+	if (break_state)
+		priv->lcr |= UART_LCR_SBC;
+	else
+		priv->lcr &= UART_LCR_SBC;
+
+	ark3116_write_reg(port->serial, UART_LCR, priv->lcr);
+
+	mutex_unlock(&priv->lock);
+}
+
 static struct usb_driver ark3116_driver = {
 	.name =		"ark3116",
 	.probe =	usb_serial_probe,
@@ -592,8 +648,10 @@ static struct usb_serial_driver ark3116_
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
