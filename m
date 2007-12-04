Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbXLDPPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbXLDPPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbXLDPPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:15:24 -0500
Received: from mx1.riseup.net ([204.13.164.18]:45761 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbXLDPPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:15:23 -0500
Date: Tue, 4 Dec 2007 16:15:40 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de, linux-usb-users@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Edgeport USB Serial Converter: convert es_sem to mutex
Message-ID: <20071204151540.GG6729@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Edgeport USB Serial Converter: convert semaphore es_sem to the
mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com> 

--

diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index b867090..f7fdf1c 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -34,6 +34,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/serial.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
@@ -133,7 +134,7 @@ struct edgeport_serial {
 	struct product_info product_info;
 	u8 TI_I2C_Type;			// Type of I2C in UMP
 	u8 TiReadI2C;			// Set to TRUE if we have read the I2c in Boot Mode
-	struct semaphore es_sem;
+	struct mutex es_lock;
 	int num_ports_open;
 	struct usb_serial *serial;
 };
@@ -2044,7 +2045,7 @@ static int edge_open (struct usb_serial_port *port, struct file * filp)
 	dbg ("ShadowMCR 0x%X", edge_port->shadow_mcr);
 
 	edge_serial = edge_port->edge_serial;
-	if (down_interruptible(&edge_serial->es_sem))
+	if (mutex_lock_interruptible(&edge_serial->es_lock))
 		return -ERESTARTSYS;
 	if (edge_serial->num_ports_open == 0) {
 		/* we are the first port to be opened, let's post the interrupt urb */
@@ -2052,7 +2053,7 @@ static int edge_open (struct usb_serial_port *port, struct file * filp)
 		if (!urb) {
 			dev_err (&port->dev, "%s - no interrupt urb present, exiting\n", __FUNCTION__);
 			status = -EINVAL;
-			goto up_es_sem;
+			goto release_es_lock;
 		}
 		urb->complete = edge_interrupt_callback;
 		urb->context = edge_serial;
@@ -2060,7 +2061,7 @@ static int edge_open (struct usb_serial_port *port, struct file * filp)
 		status = usb_submit_urb (urb, GFP_KERNEL);
 		if (status) {
 			dev_err (&port->dev, "%s - usb_submit_urb failed with value %d\n", __FUNCTION__, status);
-			goto up_es_sem;
+			goto release_es_lock;
 		}
 	}
 
@@ -2092,13 +2093,13 @@ static int edge_open (struct usb_serial_port *port, struct file * filp)
 
 	dbg("%s - exited", __FUNCTION__);
 
-	goto up_es_sem;
+	goto release_es_lock;
 
 unlink_int_urb:
 	if (edge_port->edge_serial->num_ports_open == 0)
 		usb_kill_urb(port->serial->port[0]->interrupt_in_urb);
-up_es_sem:
-	up(&edge_serial->es_sem);
+release_es_lock:
+	mutex_unlock(&edge_serial->es_lock);
 	return status;
 }
 
@@ -2137,14 +2138,14 @@ static void edge_close (struct usb_serial_port *port, struct file *filp)
 				     0,
 				     NULL,
 				     0);
-	down(&edge_serial->es_sem);
+	mutex_lock(&edge_serial->es_lock);
 	--edge_port->edge_serial->num_ports_open;
 	if (edge_port->edge_serial->num_ports_open <= 0) {
 		/* last port is now closed, let's shut down our interrupt urb */
 		usb_kill_urb(port->serial->port[0]->interrupt_in_urb);
 		edge_port->edge_serial->num_ports_open = 0;
 	}
-	up(&edge_serial->es_sem);
+	mutex_unlock(&edge_serial->es_lock);
 	edge_port->close_pending = 0;
 
 	dbg("%s - exited", __FUNCTION__);
@@ -2743,7 +2744,7 @@ static int edge_startup (struct usb_serial *serial)
 		dev_err(&serial->dev->dev, "%s - Out of memory\n", __FUNCTION__);
 		return -ENOMEM;
 	}
-	sema_init(&edge_serial->es_sem, 1);
+	mutex_init(&edge_serial->es_lock);
 	edge_serial->serial = serial;
 	usb_set_serial_data(serial, edge_serial);
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             "The only important thing Windows does better
            than Debian is implementing the win32 platform"
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
