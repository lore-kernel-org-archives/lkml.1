Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYKXQxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYKXQxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYKXQxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:53:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57965 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752473AbYKXQxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:53:36 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] hso: net driver using tty without locking
To: linux-kernel@vger.kernel.org, d.barrow@option.com
Date: Mon, 24 Nov 2008 16:53:43 +0000
Message-ID: <20081124165253.30899.39749.stgit@localhost.localdomain>
In-Reply-To: <20081124165119.30899.7515.stgit@localhost.localdomain>
References: <20081124165119.30899.7515.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Checking tty == NULL doesn't help us unless we have a clear semantic for
the locking of the tty object in the driver. Use the tty kref objects so that
we can take references to the tty in the USB event handling paths.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/net/usb/hso.c |   54 ++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 42 insertions(+), 12 deletions(-)


diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 8e90891..4398289 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1011,7 +1011,7 @@ static void _hso_serial_set_termios(struct tty_struct *tty,
 	struct hso_serial *serial = get_serial_by_tty(tty);
 	struct ktermios *termios;
 
-	if ((!tty) || (!tty->termios) || (!serial)) {
+	if (!serial) {
 		printk(KERN_ERR "%s: no tty structures", __func__);
 		return;
 	}
@@ -1053,14 +1053,14 @@ static void _hso_serial_set_termios(struct tty_struct *tty,
 	termios->c_cflag |= CS8;	/* character size 8 bits */
 
 	/* baud rate 115200 */
-	tty_encode_baud_rate(serial->tty, 115200, 115200);
+	tty_encode_baud_rate(tty, 115200, 115200);
 
 	/*
 	 * Force low_latency on; otherwise the pushes are scheduled;
 	 * this is bad as it opens up the possibility of dropping bytes
 	 * on the floor.  We don't want to drop bytes on the floor. :)
 	 */
-	serial->tty->low_latency = 1;
+	tty->low_latency = 1;
 	return;
 }
 
@@ -1224,6 +1224,7 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 
 	/* sanity check */
 	if (serial == NULL || serial->magic != HSO_SERIAL_MAGIC) {
+		WARN_ON(1);
 		tty->driver_data = NULL;
 		D1("Failed to open port");
 		return -ENODEV;
@@ -1238,8 +1239,10 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 	kref_get(&serial->parent->ref);
 
 	/* setup */
+	spin_lock_irq(&serial->serial_lock);
 	tty->driver_data = serial;
-	serial->tty = tty;
+	serial->tty = tty_kref_get(tty);
+	spin_unlock_irq(&serial->serial_lock);
 
 	/* check for port already opened, if not set the termios */
 	serial->open_count++;
@@ -1281,6 +1284,10 @@ static void hso_serial_close(struct tty_struct *tty, struct file *filp)
 
 	D1("Closing serial port");
 
+	/* Open failed, no close cleanup required */
+	if (serial == NULL)
+		return;
+
 	mutex_lock(&serial->parent->mutex);
 	usb_gone = serial->parent->usb_gone;
 
@@ -1293,10 +1300,13 @@ static void hso_serial_close(struct tty_struct *tty, struct file *filp)
 	kref_put(&serial->parent->ref, hso_serial_ref_free);
 	if (serial->open_count <= 0) {
 		serial->open_count = 0;
-		if (serial->tty) {
+		spin_lock_irq(&serial->serial_lock);
+		if (serial->tty == tty) {
 			serial->tty->driver_data = NULL;
 			serial->tty = NULL;
+			tty_kref_put(tty);
 		}
+		spin_unlock_irq(&serial->serial_lock);
 		if (!usb_gone)
 			hso_stop_serial_device(serial->parent);
 		tasklet_kill(&serial->unthrottle_tasklet);
@@ -1649,6 +1659,7 @@ static void hso_std_serial_write_bulk_callback(struct urb *urb)
 {
 	struct hso_serial *serial = urb->context;
 	int status = urb->status;
+	struct tty_struct *tty;
 
 	/* sanity check */
 	if (!serial) {
@@ -1658,14 +1669,18 @@ static void hso_std_serial_write_bulk_callback(struct urb *urb)
 
 	spin_lock(&serial->serial_lock);
 	serial->tx_urb_used = 0;
+	tty = tty_kref_get(serial->tty);
 	spin_unlock(&serial->serial_lock);
 	if (status) {
 		log_usb_status(status, __func__);
+		tty_kref_put(tty);
 		return;
 	}
 	hso_put_activity(serial->parent);
-	if (serial->tty)
-		tty_wakeup(serial->tty);
+	if (tty) {
+		tty_wakeup(tty);
+		tty_kref_put(tty);
+	}
 	hso_kick_transmit(serial);
 
 	D1(" ");
@@ -1702,6 +1717,7 @@ static void ctrl_callback(struct urb *urb)
 	struct hso_serial *serial = urb->context;
 	struct usb_ctrlrequest *req;
 	int status = urb->status;
+	struct tty_struct *tty;
 
 	/* sanity check */
 	if (!serial)
@@ -1709,9 +1725,11 @@ static void ctrl_callback(struct urb *urb)
 
 	spin_lock(&serial->serial_lock);
 	serial->tx_urb_used = 0;
+	tty = tty_kref_get(serial->tty);
 	spin_unlock(&serial->serial_lock);
 	if (status) {
 		log_usb_status(status, __func__);
+		tty_kref_put(tty);
 		return;
 	}
 
@@ -1730,25 +1748,31 @@ static void ctrl_callback(struct urb *urb)
 		spin_unlock(&serial->serial_lock);
 	} else {
 		hso_put_activity(serial->parent);
-		if (serial->tty)
-			tty_wakeup(serial->tty);
+		if (tty)
+			tty_wakeup(tty);
 		/* response to a write command */
 		hso_kick_transmit(serial);
 	}
+	tty_kref_put(tty);
 }
 
 /* handle RX data for serial port */
 static int put_rxbuf_data(struct urb *urb, struct hso_serial *serial)
 {
-	struct tty_struct *tty = serial->tty;
+	struct tty_struct *tty;
 	int write_length_remaining = 0;
 	int curr_write_len;
+
 	/* Sanity check */
 	if (urb == NULL || serial == NULL) {
 		D1("serial = NULL");
 		return -2;
 	}
 
+	spin_lock(&serial->serial_lock);
+	tty = tty_kref_get(serial->tty);
+	spin_unlock(&serial->serial_lock);
+
 	/* Push data to tty */
 	if (tty) {
 		write_length_remaining = urb->actual_length -
@@ -1770,6 +1794,7 @@ static int put_rxbuf_data(struct urb *urb, struct hso_serial *serial)
 		serial->curr_rx_urb_offset = 0;
 		serial->rx_urb_filled[hso_urb_to_index(serial, urb)] = 0;
 	}
+	tty_kref_put(tty);
 	return write_length_remaining;
 }
 
@@ -2779,15 +2804,20 @@ static void hso_serial_ref_free(struct kref *ref)
 static void hso_free_interface(struct usb_interface *interface)
 {
 	struct hso_serial *hso_dev;
+	struct tty_struct *tty;
 	int i;
 
 	for (i = 0; i < HSO_SERIAL_TTY_MINORS; i++) {
 		if (serial_table[i]
 		    && (serial_table[i]->interface == interface)) {
 			hso_dev = dev2ser(serial_table[i]);
-			if (hso_dev->tty)
-				tty_hangup(hso_dev->tty);
+			spin_lock_irq(&hso_dev->serial_lock);
+			tty = tty_kref_get(hso_dev->tty);
+			spin_unlock_irq(&hso_dev->serial_lock);
+			if (tty)
+				tty_hangup(tty);
 			mutex_lock(&hso_dev->parent->mutex);
+			tty_kref_put(tty);
 			hso_dev->parent->usb_gone = 1;
 			mutex_unlock(&hso_dev->parent->mutex);
 			kref_put(&serial_table[i]->ref, hso_serial_ref_free);

