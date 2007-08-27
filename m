Return-Path: <linux-kernel-owner+w=401wt.eu-S933676AbXH0VjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbXH0VjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932261AbXH0V3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:29:07 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58857 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764581AbXH0V3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:29:04 -0400
Date: Mon, 27 Aug 2007 23:29:00 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] ark3116.c: fix check-after-use
Message-ID: <20070827212900.GC26410@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that we'd have already oops'ed if one of 
these was NULL.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 14 Aug 2007

--- linux-2.6.23-rc1-mm2/drivers/usb/serial/ark3116.c.old	2007-08-08 15:00:03.000000000 +0200
+++ linux-2.6.23-rc1-mm2/drivers/usb/serial/ark3116.c	2007-08-08 15:00:24.000000000 +0200
@@ -159,37 +159,32 @@
 static void ark3116_set_termios(struct usb_serial_port *port,
 				struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
 	struct ark3116_private *priv = usb_get_serial_port_data(port);
 	unsigned int cflag = port->tty->termios->c_cflag;
 	unsigned long flags;
 	int baud;
 	int ark3116_baud;
 	char *buf;
 	char config;
 
 	config = 0;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
-	if (!port->tty || !port->tty->termios) {
-		dbg("%s - no tty structures", __FUNCTION__);
-		return;
-	}
-
 	spin_lock_irqsave(&priv->lock, flags);
 	if (!priv->termios_initialized) {
 		*(port->tty->termios) = tty_std_termios;
 		port->tty->termios->c_cflag = B9600 | CS8
 					      | CREAD | HUPCL | CLOCAL;
 		priv->termios_initialized = 1;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	cflag = port->tty->termios->c_cflag;
 
 	buf = kmalloc(1, GFP_KERNEL);
 	if (!buf) {
 		dbg("error kmalloc");
 		return;
 	}
