Return-Path: <linux-kernel-owner+w=401wt.eu-S1763255AbYFTUZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763255AbYFTUZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760890AbYFTUTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:19:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35187 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759403AbYFTUTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:19:23 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 29/70] tty-usb-console: Fix termios
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:01:58 +0100
Message-ID: <20080620200155.1479.64964.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Setting CFLAG bits is all well and good but you must sort out ispeed and
ospeed properly.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/console.c |   37 +++++--------------------------------
 1 files changed, 5 insertions(+), 32 deletions(-)


diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 9a4cd0a..7b74238 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -81,39 +81,11 @@ static int usb_console_setup(struct console *co, char *options)
 		if (*s)
 			doflow = (*s++ == 'r');
 	}
+	
+	/* Sane default */
+	if (baud == 0)
+		baud = 9600;
 
-	/* build a cflag setting */
-	switch (baud) {
-	case 1200:
-		cflag |= B1200;
-		break;
-	case 2400:
-		cflag |= B2400;
-		break;
-	case 4800:
-		cflag |= B4800;
-		break;
-	case 19200:
-		cflag |= B19200;
-		break;
-	case 38400:
-		cflag |= B38400;
-		break;
-	case 57600:
-		cflag |= B57600;
-		break;
-	case 115200:
-		cflag |= B115200;
-		break;
-	case 9600:
-	default:
-		cflag |= B9600;
-		/*
-		 * Set this to a sane value to prevent a divide error
-		 */
-		baud  = 9600;
-		break;
-	}
 	switch (bits) {
 	case 7:
 		cflag |= CS7;
@@ -188,6 +160,7 @@ static int usb_console_setup(struct console *co, char *options)
 
 		if (serial->type->set_termios) {
 			termios->c_cflag = cflag;
+			tty_termios_encode_baud_rate(termios, baud, baud);
 			serial->type->set_termios(NULL, port, &dummy);
 
 			port->port.tty = NULL;

