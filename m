Return-Path: <linux-kernel-owner+w=401wt.eu-S1759791AbZIQDIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791AbZIQDIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933441AbZIQDIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:08:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:54807 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbZIQDIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:08:17 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/3] usb console,usb-serial: fix regression use of serial->console
Date: Wed, 16 Sep 2009 22:08:06 -0500
Message-Id: <1253156887-31597-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1253156887-31597-2-git-send-email-jason.wessel@windriver.com>
References: <1253156887-31597-1-git-send-email-jason.wessel@windriver.com>
 <1253156887-31597-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 17 Sep 2009 03:08:16.0401 (UTC) FILETIME=[19D28010:01CA3744]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the 2.6.32 development usb serial tty interface was changed.
This change caused the usb serial driver to crash when used as a
system console.

The open and close of the raw hardware has to be protected by the
serial->console variable so either the console code does the open and
close or the higher level tty based driver executes the open and
close.

* In serial_open() the raw open must be protected by serial->console
* In serial_down() the test_and_clear_bit must be executed before
  leaving the function if the device is a serial console
* serial_release() should no longer protect for the console condition
  due to the 2.6.32 interface changes.  The actual low level close
  protection is accounted for in serial_down()

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>

---
 drivers/usb/serial/usb-serial.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index ff75a35..3d35ed2 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -267,10 +267,14 @@ static int serial_open(struct tty_struct *tty, struct file *filp)
 		if (mutex_lock_interruptible(&port->mutex))
 			return -ERESTARTSYS;
 		mutex_lock(&serial->disc_mutex);
-		if (serial->disconnected)
+		if (serial->disconnected) {
 			retval = -ENODEV;
-		else
-			retval = port->serial->type->open(tty, port);
+		} else {
+			if (port->console)
+				retval = 0;
+			else
+				retval = port->serial->type->open(tty, port);
+		}
 		mutex_unlock(&serial->disc_mutex);
 		mutex_unlock(&port->mutex);
 		if (retval)
@@ -294,6 +298,12 @@ static void serial_down(struct usb_serial_port *port)
 {
 	struct usb_serial_driver *drv = port->serial->type;
 
+	/* Don't call the close method if the hardware hasn't been
+	 * initialized.
+	 */
+	if (!test_and_clear_bit(ASYNCB_INITIALIZED, &port->port.flags))
+		return;
+
 	/*
 	 * The console is magical.  Do not hang up the console hardware
 	 * or there will be tears.
@@ -301,12 +311,6 @@ static void serial_down(struct usb_serial_port *port)
 	if (port->console)
 		return;
 
-	/* Don't call the close method if the hardware hasn't been
-	 * initialized.
-	 */
-	if (!test_and_clear_bit(ASYNCB_INITIALIZED, &port->port.flags))
-		return;
-
 	mutex_lock(&port->mutex);
 	if (drv->close)
 		drv->close(port);
@@ -353,12 +357,6 @@ static void serial_release(struct tty_struct *tty)
 	struct usb_serial *serial;
 	struct module *owner;
 
-	/* The console is magical.  Do not hang up the console hardware
-	 * or there will be tears.
-	 */
-	if (port->console)
-		return;
-
 	dbg("%s - port %d", __func__, port->number);
 
 	/* Standard shutdown processing */
-- 
1.6.4.rc1

