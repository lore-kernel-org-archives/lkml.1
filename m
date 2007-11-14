Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbXKNWRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbXKNWRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbXKNWRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:17:43 -0500
Received: from flatline.sindominio.net ([82.144.4.26]:42584 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbXKNWRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:17:41 -0500
Date: Wed, 14 Nov 2007 23:17:30 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] TI 3410/5052 USB Serial: convert td_open_close_lock to
	mutex
Message-ID: <20071114221730.GL30483@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TI 3410/5052 USB Serial: convert semaphore td_open_close_lock to the
mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 1f01494..995fdf3 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -80,6 +80,7 @@
 #include <linux/ioctl.h>
 #include <linux/serial.h>
 #include <linux/circ_buf.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 #include <linux/usb.h>
@@ -139,7 +140,7 @@ struct ti_port {
 };
 
 struct ti_device {
-	struct semaphore	td_open_close_sem;
+	struct mutex		td_open_close_lock;
 	int			td_open_port_count;
 	struct usb_serial	*td_serial;
 	int			td_is_3410;
@@ -424,7 +425,7 @@ static int ti_startup(struct usb_serial *serial)
 		dev_err(&dev->dev, "%s - out of memory\n", __FUNCTION__);
 		return -ENOMEM;
 	}
-	sema_init(&tdev->td_open_close_sem, 1);
+	mutex_init(&tdev->td_open_close_lock);
 	tdev->td_serial = serial;
 	usb_set_serial_data(serial, tdev);
 
@@ -547,7 +548,7 @@ static int ti_open(struct usb_serial_port *port, struct file *file)
 	tdev = tport->tp_tdev;
 
 	/* only one open on any port on a device at a time */
-	if (down_interruptible(&tdev->td_open_close_sem))
+	if (mutex_lock_interruptible(&tdev->td_open_close_lock))
 		return -ERESTARTSYS;
 
 	if (port->tty)
@@ -568,7 +569,7 @@ static int ti_open(struct usb_serial_port *port, struct file *file)
 		if (!urb) {
 			dev_err(&port->dev, "%s - no interrupt urb\n", __FUNCTION__);
 			status = -EINVAL;
-			goto up_sem;
+			goto release_lock;
 		}
 		urb->complete = ti_interrupt_callback;
 		urb->context = tdev;
@@ -576,7 +577,7 @@ static int ti_open(struct usb_serial_port *port, struct file *file)
 		status = usb_submit_urb(urb, GFP_KERNEL);
 		if (status) {
 			dev_err(&port->dev, "%s - submit interrupt urb failed, %d\n", __FUNCTION__, status);
-			goto up_sem;
+			goto release_lock;
 		}
 	}
 
@@ -656,13 +657,13 @@ static int ti_open(struct usb_serial_port *port, struct file *file)
 	tport->tp_is_open = 1;
 	++tdev->td_open_port_count;
 
-	goto up_sem;
+	goto release_lock;
 
 unlink_int_urb:
 	if (tdev->td_open_port_count == 0)
 		usb_kill_urb(port->serial->port[0]->interrupt_in_urb);
-up_sem:
-	up(&tdev->td_open_close_sem);
+release_lock:
+	mutex_unlock(&tdev->td_open_close_lock);
 	dbg("%s - exit %d", __FUNCTION__, status);
 	return status;
 }
@@ -674,7 +675,7 @@ static void ti_close(struct usb_serial_port *port, struct file *file)
 	struct ti_port *tport;
 	int port_number;
 	int status;
-	int do_up;
+	int do_unlock;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 			 
@@ -699,16 +700,16 @@ static void ti_close(struct usb_serial_port *port, struct file *file)
 	if (status)
 		dev_err(&port->dev, "%s - cannot send close port command, %d\n" , __FUNCTION__, status);
 
-	/* if down is interrupted, continue anyway */
-	do_up = !down_interruptible(&tdev->td_open_close_sem);
+	/* if mutex_lock is interrupted, continue anyway */
+	do_unlock = !mutex_lock_interruptible(&tdev->td_open_close_lock);
 	--tport->tp_tdev->td_open_port_count;
 	if (tport->tp_tdev->td_open_port_count <= 0) {
 		/* last port is closed, shut down interrupt urb */
 		usb_kill_urb(port->serial->port[0]->interrupt_in_urb);
 		tport->tp_tdev->td_open_port_count = 0;
 	}
-	if (do_up)
-		up(&tdev->td_open_close_sem);
+	if (do_unlock)
+		mutex_unlock(&tdev->td_open_close_lock);
 
 	dbg("%s - exit", __FUNCTION__);
 }


-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

     La libertad es como la mañana. Hay quienes esperan dormidos a que
   llegue, pero hay quienes desvelan y caminan la noche para alcanzarla
                        (Subcomandante Marcos)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
