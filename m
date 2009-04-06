Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbZDFPlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbZDFPlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbZDFPge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:36:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57004 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756995AbZDFPgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:36:33 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 25/27] symbol: Remove various bits of left over junk
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:35:25 +0100
Message-ID: <20090406163517.12934.81586.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are various bits of code here that are unfinished and instead of
being harmless either confuse or spew stuff into the logs at higher than
debug level. They can and should go away.

Also remove the bogus use of tty->lowlatency. We fixed the need for this hack
long ago (with the flip buffer rewrite) but people keep copying it into drivers.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/usb/serial/symbolserial.c |   67 -------------------------------------
 1 files changed, 0 insertions(+), 67 deletions(-)


diff --git a/drivers/usb/serial/symbolserial.c b/drivers/usb/serial/symbolserial.c
index 8b3cbc8..69879e4 100644
--- a/drivers/usb/serial/symbolserial.c
+++ b/drivers/usb/serial/symbolserial.c
@@ -139,14 +139,6 @@ static int symbol_open(struct tty_struct *tty, struct usb_serial_port *port,
 	priv->port = port;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/*
-	 * Force low_latency on so that our tty_push actually forces the data
-	 * through, otherwise it is scheduled, and with high data rates (like
-	 * with OHCI) data can get lost.
-	 */
-	if (tty)
-		tty->low_latency = 1;
-
 	/* Start reading from the device */
 	usb_fill_int_urb(priv->int_urb, priv->udev,
 			 usb_rcvintpipe(priv->udev, priv->int_address),
@@ -205,62 +197,6 @@ static void symbol_unthrottle(struct tty_struct *tty)
 							__func__, result);
 }
 
-static int symbol_ioctl(struct tty_struct *tty, struct file *file,
-			unsigned int cmd, unsigned long arg)
-{
-	struct usb_serial_port *port = tty->driver_data;
-	struct device *dev = &port->dev;
-
-	/*
-	 * Right now we need to figure out what commands
-	 * most userspace tools want to see for this driver,
-	 * so just log the things.
-	 */
-	switch (cmd) {
-	case TIOCSERGETLSR:
-		dev_info(dev, "%s: TIOCSERGETLSR\n", __func__);
-		break;
-
-	case TIOCGSERIAL:
-		dev_info(dev, "%s: TIOCGSERIAL\n", __func__);
-		break;
-
-	case TIOCMIWAIT:
-		dev_info(dev, "%s: TIOCMIWAIT\n", __func__);
-		break;
-
-	case TIOCGICOUNT:
-		dev_info(dev, "%s: TIOCGICOUNT\n", __func__);
-		break;
-	default:
-		dev_info(dev, "%s: unknown (%d)\n", __func__, cmd);
-	}
-	return -ENOIOCTLCMD;
-}
-
-static int symbol_tiocmget(struct tty_struct *tty, struct file *file)
-{
-	struct usb_serial_port *port = tty->driver_data;
-	struct device *dev = &port->dev;
-
-	/* TODO */
-	/* probably just need to shadow whatever was sent to us here */
-	dev_info(dev, "%s\n", __func__);
-	return 0;
-}
-
-static int symbol_tiocmset(struct tty_struct *tty, struct file *file,
-			   unsigned int set, unsigned int clear)
-{
-	struct usb_serial_port *port = tty->driver_data;
-	struct device *dev = &port->dev;
-
-	/* TODO */
-	/* probably just need to shadow whatever was sent to us here */
-	dev_info(dev, "%s\n", __func__);
-	return 0;
-}
-
 static int symbol_startup(struct usb_serial *serial)
 {
 	struct symbol_private *priv;
@@ -367,9 +303,6 @@ static struct usb_serial_driver symbol_device = {
 	.shutdown =		symbol_shutdown,
 	.throttle = 		symbol_throttle,
 	.unthrottle =		symbol_unthrottle,
-	.ioctl = 		symbol_ioctl,
-	.tiocmget = 		symbol_tiocmget,
-	.tiocmset = 		symbol_tiocmset,
 };
 
 static int __init symbol_init(void)

