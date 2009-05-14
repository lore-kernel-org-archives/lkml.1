Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbZENWoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbZENWoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbZENWmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:01 -0400
Received: from kroah.org ([198.145.64.141]:51470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103AbZENWl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:41:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:21 2009
Message-Id: <20090514223521.148009855@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:32:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 06/51] usb-serial: ftdi_sio: fix reference counting of ftdi_private
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-ftdi_sio-fix-reference-counting-of-ftdi_private.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit c45d63202fbaccef7ef7946c03f27f72c809b1cc upstream.

This patch (as1238) adds proper reference counting for ftdi_sio's
private data structure.  Without it, the driver will free the
structure while it is still in use if the user unplugs the serial
device before closing the device file.

The patch also replaces a slightly dangerous
cancel_delayed_work/flush_scheduled_work pair with
cancel_delayed_work_sync, which is always safer.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Daniel Mack <daniel@caiaq.de>
Tested-by: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -56,6 +56,7 @@ static __u16 vendor = FTDI_VID;
 static __u16 product;
 
 struct ftdi_private {
+	struct kref kref;
 	ftdi_chip_type_t chip_type;
 				/* type of device, either SIO or FT8U232AM */
 	int baud_base;		/* baud base clock for divisor setting */
@@ -1352,6 +1353,7 @@ static int ftdi_sio_port_probe(struct us
 		return -ENOMEM;
 	}
 
+	kref_init(&priv->kref);
 	spin_lock_init(&priv->rx_lock);
 	spin_lock_init(&priv->tx_lock);
 	init_waitqueue_head(&priv->delta_msr_wait);
@@ -1468,6 +1470,13 @@ static void ftdi_shutdown(struct usb_ser
 	dbg("%s", __func__);
 }
 
+static void ftdi_sio_priv_release(struct kref *k)
+{
+	struct ftdi_private *priv = container_of(k, struct ftdi_private, kref);
+
+	kfree(priv);
+}
+
 static int ftdi_sio_port_remove(struct usb_serial_port *port)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
@@ -1482,7 +1491,7 @@ static int ftdi_sio_port_remove(struct u
 
 	if (priv) {
 		usb_set_serial_port_data(port, NULL);
-		kfree(priv);
+		kref_put(&priv->kref, ftdi_sio_priv_release);
 	}
 
 	return 0;
@@ -1547,7 +1556,8 @@ static int ftdi_open(struct tty_struct *
 		dev_err(&port->dev,
 			"%s - failed submitting read urb, error %d\n",
 			__func__, result);
-
+	else
+		kref_get(&priv->kref);
 
 	return result;
 } /* ftdi_open */
@@ -1589,11 +1599,11 @@ static void ftdi_close(struct tty_struct
 	mutex_unlock(&port->serial->disc_mutex);
 
 	/* cancel any scheduled reading */
-	cancel_delayed_work(&priv->rx_work);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&priv->rx_work);
 
 	/* shutdown our bulk read */
 	usb_kill_urb(port->read_urb);
+	kref_put(&priv->kref, ftdi_sio_priv_release);
 } /* ftdi_close */
 
 


