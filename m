Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZISVpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZISVpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbZISVpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:45:19 -0400
Received: from kroah.org ([198.145.64.141]:52780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbZISVpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:45:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 75/79] usb-serial: fix termios initialization logic
Date: Sat, 19 Sep 2009 14:37:20 -0700
Message-Id: <1253396244-7885-75-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1288) fixes the initialization logic in
serial_install().  A new tty always needs to have a termios
initialized no matter what, not just in the case where the lower
driver will override the termios settings.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/usb-serial.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 7d207d9..1bc0a24 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -210,22 +210,21 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 	if (!try_module_get(serial->type->driver.owner))
 		goto error_module_get;
 
+	/* perform the standard setup */
+	retval = tty_init_termios(tty);
+	if (retval)
+		goto error_init_termios;
+
 	retval = usb_autopm_get_interface(serial->interface);
 	if (retval)
 		goto error_get_interface;
 
-	/* If the termios setup has yet to be done */
-	if (tty->driver->termios[idx] == NULL) {
-		/* perform the standard setup */
-		retval = tty_init_termios(tty);
-		if (retval)
-			goto error_init_termios;
-		/* allow the driver to update it */
-		if (serial->type->init_termios)
-			serial->type->init_termios(tty);
-	}
 	mutex_unlock(&serial->disc_mutex);
 
+	/* allow the driver to update the settings */
+	if (serial->type->init_termios)
+		serial->type->init_termios(tty);
+
 	tty->driver_data = port;
 
 	/* Final install (we use the default method) */
@@ -234,9 +233,8 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 	driver->ttys[idx] = tty;
 	return retval;
 
- error_init_termios:
-	usb_autopm_put_interface(serial->interface);
  error_get_interface:
+ error_init_termios:
 	module_put(serial->type->driver.owner);
  error_module_get:
  error_no_port:
-- 
1.6.4.2

