Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbZJ1Jwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbZJ1Jwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZJ1Jwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:52:34 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35231 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZJ1JvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=mEfu4gZoFBmF7zqtvU0xphz7rcNasVF/AqAor+WeQq1LVOqDpqNyPWyo2A7TfPl/5J
         xjOcvcExQ6LlO6r1NzV5XqkiHAoCIQFFIND+aBT1JeErPTigZxhh4Um2S3U0zd6Ho/XF
         jkYHYwkaBiK6c5J7kM6LyZIudevjm2Eoocpjg=
Message-Id: <20091028095105.871324219@gmail.com>
References: <20091028094324.010816897@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 28 Oct 2009 10:43:27 +0100
From: bart.hartgers@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>, Mike McCormack <mikem@ring3k.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bart Hartgers <bart.hartgers@gmail.com>
Subject: [PATCH 3/6] ark3116: (v2) Replace cmget
Content-Disposition: inline; filename=0020_ark3116_cmget.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
---
Index: linux-2.6.32-rc4/drivers/usb/serial/ark3116.c
===================================================================
--- linux-2.6.32-rc4.orig/drivers/usb/serial/ark3116.c	2009-10-28 10:19:42.000000000 +0100
+++ linux-2.6.32-rc4/drivers/usb/serial/ark3116.c	2009-10-28 10:19:44.000000000 +0100
@@ -528,32 +528,27 @@ static int ark3116_ioctl(struct tty_stru
 static int ark3116_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct usb_serial *serial = port->serial;
-	char *buf;
-	char temp;
-
-	/* seems like serial port status info (RTS, CTS, ...) is stored
-	 * in reg(?) 0x0006
-	 * pcb connection point 11 = GND -> sets bit4 of response
-	 * pcb connection point  7 = GND -> sets bit6 of response
-	 */
-
-	buf = kmalloc(1, GFP_KERNEL);
-	if (!buf) {
-		dbg("error kmalloc");
-		return -ENOMEM;
-	}
-
-	/* read register */
-	ARK3116_RCV_QUIET(serial, 0xFE, 0xC0, 0x0000, 0x0006, buf);
-	temp = buf[0];
-	kfree(buf);
-
-	/* i do not really know if bit4=CTS and bit6=DSR... just a
-	 * quick guess!
-	 */
-	return (temp & (1<<4) ? TIOCM_CTS : 0)
-	       | (temp & (1<<6) ? TIOCM_DSR : 0);
+	struct ark3116_private *priv = usb_get_serial_port_data(port);
+	__u32 status;
+	__u32 ctrl;
+	unsigned long flags;
+
+	mutex_lock(&priv->hw_lock);
+	ctrl = priv->mcr;
+	mutex_unlock(&priv->hw_lock);
+
+	spin_lock_irqsave(&priv->status_lock, flags);
+	status = priv->msr;
+	spin_unlock_irqrestore(&priv->status_lock, flags);
+
+	return  (status & UART_MSR_DSR  ? TIOCM_DSR  : 0) |
+		(status & UART_MSR_CTS  ? TIOCM_CTS  : 0) |
+		(status & UART_MSR_RI   ? TIOCM_RI   : 0) |
+		(status & UART_MSR_DCD  ? TIOCM_CD   : 0) |
+		(ctrl   & UART_MCR_DTR  ? TIOCM_DTR  : 0) |
+		(ctrl   & UART_MCR_RTS  ? TIOCM_RTS  : 0) |
+		(ctrl   & UART_MCR_OUT1 ? TIOCM_OUT1 : 0) |
+		(ctrl   & UART_MCR_OUT2 ? TIOCM_OUT2 : 0);
 }
 
 static struct usb_driver ark3116_driver = {

-- 
