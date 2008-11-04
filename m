Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYKDP3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYKDP3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYKDP3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:29:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37395 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752985AbYKDP3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:29:24 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty: Fix close races in USB serial
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Nov 2008 15:29:24 +0000
Message-ID: <20081104152916.30344.68193.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

USB serial has always had races where the tty port usage count can hit zero
during a receive event. The internal locking is a mutex so we can't use
that in the IRQ handlers.

With krefs we can tackle this differently but we still need to be careful.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/usb-serial.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 794b5ff..aafa684 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -269,15 +269,19 @@ static void serial_close(struct tty_struct *tty, struct file *filp)
 		return;
 	}
 
-	--port->port.count;
-	if (port->port.count == 0)
+	if (port->port.count == 1)
 		/* only call the device specific close if this
-		 * port is being closed by the last owner */
+		 * port is being closed by the last owner. Ensure we do
+		 * this before we drop the port count. The call is protected
+		 * by the port mutex
+		 */
 		port->serial->type->close(tty, port, filp);
 
-	if (port->port.count == (port->console? 1 : 0)) {
+	if (port->port.count == (port->console ? 2 : 1)) {
 		struct tty_struct *tty = tty_port_tty_get(&port->port);
 		if (tty) {
+			/* We must do this before we drop the port count to
+			   zero. */
 			if (tty->driver_data)
 				tty->driver_data = NULL;
 			tty_port_tty_set(&port->port, NULL);
@@ -285,13 +289,14 @@ static void serial_close(struct tty_struct *tty, struct file *filp)
 		}
 	}
 
-	if (port->port.count == 0) {
+	if (port->port.count == 1) {
 		mutex_lock(&port->serial->disc_mutex);
 		if (!port->serial->disconnected)
 			usb_autopm_put_interface(port->serial->interface);
 		mutex_unlock(&port->serial->disc_mutex);
 		module_put(port->serial->type->driver.owner);
 	}
+	--port->port.count;
 
 	mutex_unlock(&port->mutex);
 	usb_serial_put(port->serial);

