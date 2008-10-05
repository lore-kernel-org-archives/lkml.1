Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbYJEQdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbYJEQdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759301AbYJEQYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:24:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34331 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758541AbYJEQYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:24:15 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 69/76] hso: net driver using tty without locking
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:24:15 +0100
Message-ID: <20081005162404.1997.12446.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking tty == NULL doesn't help us unless we have a clear semantic for
the locking of the tty object in the driver. Use the tty kref objects so that
we can take references to the tty in the USB event handling paths.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/net/usb/hso.c |   46 +++++++++++++++++++++++++++++++++++-----------
 1 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 6e42b5a..b764802 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1028,14 +1028,14 @@ static void _hso_serial_set_termios(struct tty_struct *tty,
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
 
@@ -1061,8 +1061,10 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 	kref_get(&serial->parent->ref);
 
 	/* setup */
+	spin_lock_irq(&serial->serial_lock);
 	tty->driver_data = serial;
-	serial->tty = tty;
+	serial->tty = tty_kref_get(tty);
+	spin_unlock_irq(&serial->serial_lock);
 
 	/* check for port allready opened, if not set the termios */
 	serial->open_count++;
@@ -1111,10 +1113,13 @@ static void hso_serial_close(struct tty_struct *tty, struct file *filp)
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
 	}
@@ -1457,6 +1462,7 @@ static void hso_std_serial_write_bulk_callback(struct urb *urb)
 {
 	struct hso_serial *serial = urb->context;
 	int status = urb->status;
+	struct tty_struct *tty;
 
 	/* sanity check */
 	if (!serial) {
@@ -1466,14 +1472,18 @@ static void hso_std_serial_write_bulk_callback(struct urb *urb)
 
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
@@ -1510,6 +1520,7 @@ static void ctrl_callback(struct urb *urb)
 	struct hso_serial *serial = urb->context;
 	struct usb_ctrlrequest *req;
 	int status = urb->status;
+	struct tty_struct *tty;
 
 	/* sanity check */
 	if (!serial)
@@ -1517,9 +1528,11 @@ static void ctrl_callback(struct urb *urb)
 
 	spin_lock(&serial->serial_lock);
 	serial->tx_urb_used = 0;
+	tty = tty_kref_get(serial->tty);
 	spin_unlock(&serial->serial_lock);
 	if (status) {
 		log_usb_status(status, __func__);
+		tty_kref_put(tty);
 		return;
 	}
 
@@ -1544,17 +1557,18 @@ static void ctrl_callback(struct urb *urb)
 			clear_bit(HSO_SERIAL_FLAG_RX_SENT, &serial->flags);
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
 static void put_rxbuf_data(struct urb *urb, struct hso_serial *serial)
 {
-	struct tty_struct *tty = serial->tty;
+	struct tty_struct *tty;
 
 	/* Sanity check */
 	if (urb == NULL || serial == NULL) {
@@ -1562,6 +1576,10 @@ static void put_rxbuf_data(struct urb *urb, struct hso_serial *serial)
 		return;
 	}
 
+	spin_lock(&serial->serial_lock);
+	tty = tty_kref_get(serial->tty);
+	spin_unlock(&serial->serial_lock);
+
 	/* Push data to tty */
 	if (tty && urb->actual_length) {
 		D1("data to push to tty");
@@ -1569,6 +1587,7 @@ static void put_rxbuf_data(struct urb *urb, struct hso_serial *serial)
 				       urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
+	tty_kref_put(tty);
 }
 
 /* read callback for Diag and CS port */
@@ -2635,15 +2654,20 @@ static void hso_serial_ref_free(struct kref *ref)
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

