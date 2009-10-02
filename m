Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbZJBBoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbZJBBoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbZJBBob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:44:31 -0400
Received: from kroah.org ([198.145.64.141]:33393 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820AbZJBBdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:22 2009
Message-Id: <20091002012422.398569832@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [097/136] usb-serial: fix termios initialization logic
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-fix-termios-initialization-logic.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 7e29bb4b779f4f35385e6f21994758845bf14d23 upstream.

This patch (as1288) fixes the initialization logic in
serial_install().  A new tty always needs to have a termios
initialized no matter what, not just in the case where the lower
driver will override the termios settings.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -210,22 +210,21 @@ static int serial_install(struct tty_dri
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
@@ -234,9 +233,8 @@ static int serial_install(struct tty_dri
 	driver->ttys[idx] = tty;
 	return retval;
 
- error_init_termios:
-	usb_autopm_put_interface(serial->interface);
  error_get_interface:
+ error_init_termios:
 	module_put(serial->type->driver.owner);
  error_module_get:
  error_no_port:


