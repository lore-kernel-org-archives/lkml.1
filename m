Return-Path: <linux-kernel-owner+w=401wt.eu-S933985AbYBTU6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985AbYBTU6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYBTU52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:57:28 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36581 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752318AbYBTU51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:57:27 -0500
Date: Wed, 20 Feb 2008 20:47:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] usb-serial: Prepare for BKL push down
Message-ID: <20080220204756.1aa67aee@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take the lock in usb-serial instead. As it relies on the BKL internally
we can't push it any deeper yet.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/usb/serial/usb-serial.c linux-2.6.25-rc2-mm1/drivers/usb/serial/usb-serial.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/usb/serial/usb-serial.c	2008-02-19 11:03:01.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/usb/serial/usb-serial.c	2008-02-20 11:53:06.000000000 +0000
@@ -401,11 +401,13 @@
 	struct usb_serial_port *port = tty->driver_data;
 	int retval = -ENODEV;
 
+	lock_kernel();
 	if (!port)
 		goto exit;
 
 	dbg("%s - port %d, cmd 0x%.4x", __FUNCTION__, port->number, cmd);
 
+	/* Caution - port->open_count is BKL protected */
 	if (!port->open_count) {
 		dbg ("%s - port not open", __FUNCTION__);
 		goto exit;
@@ -416,8 +418,8 @@
 		retval = port->serial->type->ioctl(port, file, cmd, arg);
 	else
 		retval = -ENOIOCTLCMD;
-
 exit:
+	unlock_kernel();
 	return retval;
 }
 
@@ -446,19 +448,24 @@
 {
 	struct usb_serial_port *port = tty->driver_data;
 
-	if (!port)
+	lock_kernel();
+	if (!port) {
+		unlock_kernel();
 		return;
+	}
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
 	if (!port->open_count) {
 		dbg("%s - port not open", __FUNCTION__);
+		unlock_kernel();
 		return;
 	}
 
 	/* pass on to the driver specific version of this function if it is available */
 	if (port->serial->type->break_ctl)
 		port->serial->type->break_ctl(port, break_state);
+	unlock_kernel();
 }
 
 static int serial_read_proc (char *page, char **start, off_t off, int count, int *eof, void *data)
