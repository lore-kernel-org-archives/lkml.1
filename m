Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbZJFPRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbZJFPRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbZJFPRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:17:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35837 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757700AbZJFPRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:17:21 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 4/5] usb_serial: Kill port mutex
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Tue, 06 Oct 2009 16:06:46 +0100
Message-ID: <20091006150641.9431.67880.stgit@localhost.localdomain>
In-Reply-To: <20091006145413.9431.47083.stgit@localhost.localdomain>
References: <20091006145413.9431.47083.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty port has a port mutex used for all the port related locking so we
don't need the one in the USB serial layer any more.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/serial/opticon.c    |    4 ++--
 drivers/usb/serial/usb-serial.c |    1 -
 include/linux/usb/serial.h      |    3 ---
 3 files changed, 2 insertions(+), 6 deletions(-)


diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 1085a57..c3a9ce2 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -498,12 +498,12 @@ static int opticon_resume(struct usb_interface *intf)
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
index e189338..421ef1f 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -896,7 +896,6 @@ int usb_serial_probe(struct usb_interface *interface,
 		spin_lock_init(&port->lock);
 		/* Keep this for private driver use for the moment but
 		   should probably go away */
-		mutex_init(&port->mutex);
 		INIT_WORK(&port->work, usb_serial_port_work);
 		serial->port[i] = port;
 		port->dev.parent = &interface->dev;
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index c17eb64..ad24c8c 100644
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

