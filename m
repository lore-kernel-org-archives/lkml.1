Return-Path: <linux-kernel-owner+w=401wt.eu-S933976AbZLKXbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976AbZLKXbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934481AbZLKX3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:36 -0500
Received: from kroah.org ([198.145.64.141]:50461 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933853AbZLKX3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:00 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/58] usb_serial: Kill port mutex
Date: Fri, 11 Dec 2009 15:28:00 -0800
Message-Id: <1260574122-10676-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The tty port has a port mutex used for all the port related locking so we
don't need the one in the USB serial layer any more.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/opticon.c    |    4 ++--
 drivers/usb/serial/usb-serial.c |    1 -
 include/linux/usb/serial.h      |    3 ---
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 80f59b6..c03fdc0 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -501,12 +501,12 @@ static int opticon_resume(struct usb_interface *intf)
 	struct usb_serial_port *port = serial->port[0];
 	int result;
 
-	mutex_lock(&port->mutex);
+	mutex_lock(&port->port.mutex);
 	if (port->port.count)
 		result = usb_submit_urb(priv->bulk_read_urb, GFP_NOIO);
 	else
 		result = 0;
-	mutex_unlock(&port->mutex);
+	mutex_unlock(&port->port.mutex);
 	return result;
 }
 
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 829a466..4543f35 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -897,7 +897,6 @@ int usb_serial_probe(struct usb_interface *interface,
 		spin_lock_init(&port->lock);
 		/* Keep this for private driver use for the moment but
 		   should probably go away */
-		mutex_init(&port->mutex);
 		INIT_WORK(&port->work, usb_serial_port_work);
 		serial->port[i] = port;
 		port->dev.parent = &interface->dev;
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index ce911eb..acf6e45 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -39,8 +39,6 @@ enum port_dev_state {
  * @serial: pointer back to the struct usb_serial owner of this port.
  * @port: pointer to the corresponding tty_port for this port.
  * @lock: spinlock to grab when updating portions of this structure.
- * @mutex: mutex used to synchronize serial_open() and serial_close()
- *	access for this port.
  * @number: the number of the port (the minor number).
  * @interrupt_in_buffer: pointer to the interrupt in buffer for this port.
  * @interrupt_in_urb: pointer to the interrupt in struct urb for this port.
@@ -77,7 +75,6 @@ struct usb_serial_port {
 	struct usb_serial	*serial;
 	struct tty_port		port;
 	spinlock_t		lock;
-	struct mutex            mutex;
 	unsigned char		number;
 
 	unsigned char		*interrupt_in_buffer;
-- 
1.6.5.5

