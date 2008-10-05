Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbYJEQSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbYJEQSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYJEQLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:11:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48505 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756877AbYJEQLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:11:40 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 38/76] tty: usb-serial krefs
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:11:38 +0100
Message-ID: <20081005161056.1997.12765.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kref in the USB serial drivers so that we don't free tty structures
from under the URB receive handlers as has historically been the case if
you were unlucky. This also gives us a framework for general tty drivers to
use tty_port objects and refcount.

Contains two err->dev_err changes merged together to fix clashes in the
-next tree.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_port.c               |   41 ++++++++++++++++++
 drivers/usb/serial/aircable.c         |   15 ++++--
 drivers/usb/serial/belkin_sa.c        |    3 +
 drivers/usb/serial/console.c          |    8 ++-
 drivers/usb/serial/cyberjack.c        |    3 +
 drivers/usb/serial/cypress_m8.c       |    5 +-
 drivers/usb/serial/digi_acceleport.c  |   19 ++++++--
 drivers/usb/serial/empeg.c            |    8 ++-
 drivers/usb/serial/ftdi_sio.c         |   19 +++++---
 drivers/usb/serial/garmin_gps.c       |    3 +
 drivers/usb/serial/generic.c          |    3 +
 drivers/usb/serial/io_edgeport.c      |   43 ++++++++++++------
 drivers/usb/serial/io_ti.c            |   26 ++++++++---
 drivers/usb/serial/ipaq.c             |    3 +
 drivers/usb/serial/ipw.c              |    3 +
 drivers/usb/serial/ir-usb.c           |    3 +
 drivers/usb/serial/iuu_phoenix.c      |    3 +
 drivers/usb/serial/keyspan.c          |   77 +++++++++++++++++----------------
 drivers/usb/serial/keyspan_pda.c      |   16 ++++---
 drivers/usb/serial/kl5kusb105.c       |    3 +
 drivers/usb/serial/kobil_sct.c        |    3 +
 drivers/usb/serial/mct_u232.c         |    6 ++-
 drivers/usb/serial/mos7720.c          |   36 ++-------------
 drivers/usb/serial/mos7840.c          |    7 ++-
 drivers/usb/serial/navman.c           |    3 +
 drivers/usb/serial/omninet.c          |   10 +++-
 drivers/usb/serial/option.c           |   18 +++++---
 drivers/usb/serial/oti6858.c          |    3 +
 drivers/usb/serial/pl2303.c           |    4 +-
 drivers/usb/serial/safe_serial.c      |   11 +++--
 drivers/usb/serial/sierra.c           |   16 ++++---
 drivers/usb/serial/spcp8x5.c          |    3 +
 drivers/usb/serial/ti_usb_3410_5052.c |   44 ++++++++++---------
 drivers/usb/serial/usb-serial.c       |   24 ++++++----
 drivers/usb/serial/visor.c            |   18 +++++---
 drivers/usb/serial/whiteheat.c        |    8 ++-
 include/linux/tty.h                   |    3 +
 37 files changed, 313 insertions(+), 208 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 6fadb19..553b0e9 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -23,6 +23,7 @@ void tty_port_init(struct tty_port *port)
 	init_waitqueue_head(&port->open_wait);
 	init_waitqueue_head(&port->close_wait);
 	mutex_init(&port->mutex);
+	spin_lock_init(&port->lock);
 	port->close_delay = (50 * HZ) / 100;
 	port->closing_wait = (3000 * HZ) / 100;
 }
@@ -53,3 +54,43 @@ void tty_port_free_xmit_buf(struct tty_port *port)
 EXPORT_SYMBOL(tty_port_free_xmit_buf);
 
 
+/**
+ *	tty_port_tty_get	-	get a tty reference
+ *	@port: tty port
+ *
+ *	Return a refcount protected tty instance or NULL if the port is not
+ *	associated with a tty (eg due to close or hangup)
+ */
+
+struct tty_struct *tty_port_tty_get(struct tty_port *port)
+{
+	unsigned long flags;
+	struct tty_struct *tty;
+
+	spin_lock_irqsave(&port->lock, flags);
+	tty = tty_kref_get(port->tty);
+	spin_unlock_irqrestore(&port->lock, flags);
+	return tty;
+}
+EXPORT_SYMBOL(tty_port_tty_get);
+
+/**
+ *	tty_port_tty_set	-	set the tty of a port
+ *	@port: tty port
+ *	@tty: the tty
+ *
+ *	Associate the port and tty pair. Manages any internal refcounts.
+ *	Pass NULL to deassociate a port
+ */
+
+void tty_port_tty_set(struct tty_port *port, struct tty_struct *tty)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	if (port->tty)
+		tty_kref_put(port->tty);
+	port->tty = tty;
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+EXPORT_SYMBOL(tty_port_tty_set);
diff --git a/drivers/usb/serial/aircable.c b/drivers/usb/serial/aircable.c
index 79ea98c..99fb7dc 100644
--- a/drivers/usb/serial/aircable.c
+++ b/drivers/usb/serial/aircable.c
@@ -272,7 +272,7 @@ static void aircable_read(struct work_struct *work)
 	 * 64 bytes, to ensure I do not get throttled.
 	 * Ask USB mailing list for better aproach.
 	 */
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 
 	if (!tty) {
 		schedule_work(&priv->rx_work);
@@ -283,12 +283,13 @@ static void aircable_read(struct work_struct *work)
 	count = min(64, serial_buf_data_avail(priv->rx_buf));
 
 	if (count <= 0)
-		return; /* We have finished sending everything. */
+		goto out; /* We have finished sending everything. */
 
 	tty_prepare_flip_string(tty, &data, count);
 	if (!data) {
-		err("%s- kzalloc(%d) failed.", __func__, count);
-		return;
+		dev_err(&port->dev, "%s- kzalloc(%d) failed.",
+							__func__, count);
+		goto out;
 	}
 
 	serial_buf_get(priv->rx_buf, data, count);
@@ -297,7 +298,8 @@ static void aircable_read(struct work_struct *work)
 
 	if (serial_buf_data_avail(priv->rx_buf))
 		schedule_work(&priv->rx_work);
-
+out:		
+	tty_kref_put(tty);
 	return;
 }
 /* End of private methods */
@@ -495,7 +497,7 @@ static void aircable_read_bulk_callback(struct urb *urb)
 	usb_serial_debug_data(debug, &port->dev, __func__,
 				urb->actual_length, urb->transfer_buffer);
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
 		if (urb->actual_length <= 2) {
 			/* This is an incomplete package */
@@ -527,6 +529,7 @@ static void aircable_read_bulk_callback(struct urb *urb)
 		}
 		aircable_read(&priv->rx_work);
 	}
+	tty_kref_put(tty);
 
 	/* Schedule the next read _if_ we are still open */
 	if (port->port.count) {
diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
index 2ebe06c..1913bc7 100644
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -322,7 +322,7 @@ static void belkin_sa_read_int_callback(struct urb *urb)
 	 * to look in to this before committing any code.
 	 */
 	if (priv->last_lsr & BELKIN_SA_LSR_ERR) {
-		tty = port->port.tty;
+		tty = tty_port_tty_get(&port->port);
 		/* Overrun Error */
 		if (priv->last_lsr & BELKIN_SA_LSR_OE) {
 		}
@@ -335,6 +335,7 @@ static void belkin_sa_read_int_callback(struct urb *urb)
 		/* Break Indicator */
 		if (priv->last_lsr & BELKIN_SA_LSR_BI) {
 		}
+		tty_kref_put(tty);
 	}
 #endif
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index e980766..5b20de1 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -117,7 +117,7 @@ static int usb_console_setup(struct console *co, char *options)
 	}
 
 	port = serial->port[0];
-	port->port.tty = NULL;
+	tty_port_tty_set(&port->port, NULL);
 
 	info->port = port;
 
@@ -143,7 +143,7 @@ static int usb_console_setup(struct console *co, char *options)
 			}
 			memset(&dummy, 0, sizeof(struct ktermios));
 			tty->termios = termios;
-			port->port.tty = tty;
+			tty_port_tty_set(&port->port, tty);
 		}
 
 		/* only call the device specific open if this
@@ -163,7 +163,7 @@ static int usb_console_setup(struct console *co, char *options)
 			tty_termios_encode_baud_rate(termios, baud, baud);
 			serial->type->set_termios(tty, port, &dummy);
 
-			port->port.tty = NULL;
+			tty_port_tty_set(&port->port, NULL);
 			kfree(termios);
 			kfree(tty);
 		}
@@ -176,7 +176,7 @@ out:
 	return retval;
 free_termios:
 	kfree(termios);
-	port->port.tty = NULL;
+	tty_port_tty_set(&port->port, NULL);
 free_tty:
 	kfree(tty);
 reset_open_count:
diff --git a/drivers/usb/serial/cyberjack.c b/drivers/usb/serial/cyberjack.c
index b4d7235..94ef36c 100644
--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -384,7 +384,7 @@ static void cyberjack_read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (!tty) {
 		dbg("%s - ignoring since device not open\n", __func__);
 		return;
@@ -394,6 +394,7 @@ static void cyberjack_read_bulk_callback(struct urb *urb)
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
+	tty_kref_put(tty);
 
 	spin_lock(&priv->lock);
 
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 22837a3..f3514a9 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -1286,7 +1286,7 @@ static void cypress_read_int_callback(struct urb *urb)
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (!tty) {
 		dbg("%s - bad tty pointer - exiting", __func__);
 		return;
@@ -1362,7 +1362,7 @@ static void cypress_read_int_callback(struct urb *urb)
 					data[i]);
 			tty_insert_flip_char(tty, data[i], tty_flag);
 		}
-		tty_flip_buffer_push(port->port.tty);
+		tty_flip_buffer_push(tty);
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -1371,6 +1371,7 @@ static void cypress_read_int_callback(struct urb *urb)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 continue_read:
+	tty_kref_put(tty);
 
 	/* Continue trying to always read... unless the port has closed. */
 
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 240aad1..5756ac6 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -604,7 +604,9 @@ static void digi_wakeup_write_lock(struct work_struct *work)
 
 static void digi_wakeup_write(struct usb_serial_port *port)
 {
-	tty_wakeup(port->port.tty);
+	struct tty_struct *tty = tty_port_tty_get(&port->port);
+	tty_wakeup(tty);
+	tty_kref_put(tty);
 }
 
 
@@ -1668,7 +1670,7 @@ static int digi_read_inb_callback(struct urb *urb)
 {
 
 	struct usb_serial_port *port = urb->context;
-	struct tty_struct *tty = port->port.tty;
+	struct tty_struct *tty;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	int opcode = ((unsigned char *)urb->transfer_buffer)[0];
 	int len = ((unsigned char *)urb->transfer_buffer)[1];
@@ -1692,6 +1694,7 @@ static int digi_read_inb_callback(struct urb *urb)
 		return -1;
 	}
 
+	tty = tty_port_tty_get(&port->port);
 	spin_lock(&priv->dp_port_lock);
 
 	/* check for throttle; if set, do not resubmit read urb */
@@ -1735,6 +1738,7 @@ static int digi_read_inb_callback(struct urb *urb)
 		}
 	}
 	spin_unlock(&priv->dp_port_lock);
+	tty_kref_put(tty);
 
 	if (opcode == DIGI_CMD_RECEIVE_DISABLE)
 		dbg("%s: got RECEIVE_DISABLE", __func__);
@@ -1760,6 +1764,7 @@ static int digi_read_oob_callback(struct urb *urb)
 
 	struct usb_serial_port *port = urb->context;
 	struct usb_serial *serial = port->serial;
+	struct tty_struct *tty;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	int opcode, line, status, val;
 	int i;
@@ -1787,10 +1792,11 @@ static int digi_read_oob_callback(struct urb *urb)
 		if (priv == NULL)
 			return -1;
 
+		tty = tty_port_tty_get(&port->port);
 		rts = 0;
 		if (port->port.count)
-			rts = port->port.tty->termios->c_cflag & CRTSCTS;
-
+			rts = tty->termios->c_cflag & CRTSCTS;
+		
 		if (opcode == DIGI_CMD_READ_INPUT_SIGNALS) {
 			spin_lock(&priv->dp_port_lock);
 			/* convert from digi flags to termiox flags */
@@ -1798,14 +1804,14 @@ static int digi_read_oob_callback(struct urb *urb)
 				priv->dp_modem_signals |= TIOCM_CTS;
 				/* port must be open to use tty struct */
 				if (rts) {
-					port->port.tty->hw_stopped = 0;
+					tty->hw_stopped = 0;
 					digi_wakeup_write(port);
 				}
 			} else {
 				priv->dp_modem_signals &= ~TIOCM_CTS;
 				/* port must be open to use tty struct */
 				if (rts)
-					port->port.tty->hw_stopped = 1;
+					tty->hw_stopped = 1;
 			}
 			if (val & DIGI_READ_INPUT_SIGNALS_DSR)
 				priv->dp_modem_signals |= TIOCM_DSR;
@@ -1830,6 +1836,7 @@ static int digi_read_oob_callback(struct urb *urb)
 		} else if (opcode == DIGI_CMD_IFLUSH_FIFO) {
 			wake_up_interruptible(&priv->dp_flush_wait);
 		}
+		tty_kref_put(tty);
 	}
 	return 0;
 
diff --git a/drivers/usb/serial/empeg.c b/drivers/usb/serial/empeg.c
index a6ab5b5..1072e84 100644
--- a/drivers/usb/serial/empeg.c
+++ b/drivers/usb/serial/empeg.c
@@ -33,9 +33,8 @@
  *	Moved MOD_DEC_USE_COUNT to end of empeg_close().
  *
  * (12/03/2000) gb
- *	Added port->port.tty->ldisc.set_termios(port->port.tty, NULL) to
- *	empeg_open(). This notifies the tty driver that the termios have
- *	changed.
+ *	Added tty->ldisc.set_termios(port, tty, NULL) to empeg_open().
+ *	This notifies the tty driver that the termios have changed.
  *
  * (11/13/2000) gb
  *	Moved tty->low_latency = 1 from empeg_read_bulk_callback() to
@@ -354,7 +353,7 @@ static void empeg_read_bulk_callback(struct urb *urb)
 
 	usb_serial_debug_data(debug, &port->dev, __func__,
 						urb->actual_length, data);
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 
 	if (urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length);
@@ -362,6 +361,7 @@ static void empeg_read_bulk_callback(struct urb *urb)
 		tty_flip_buffer_push(tty);
 		bytes_in += urb->actual_length;
 	}
+	tty_kref_put(tty);
 
 	/* Continue trying to always read  */
 	usb_fill_bulk_urb(
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 3dc93b5..70a3719 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1808,7 +1808,7 @@ static void ftdi_read_bulk_callback(struct urb *urb)
 	if (port->port.count <= 0)
 		return;
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (!tty) {
 		dbg("%s - bad tty pointer - exiting", __func__);
 		return;
@@ -1817,7 +1817,7 @@ static void ftdi_read_bulk_callback(struct urb *urb)
 	priv = usb_get_serial_port_data(port);
 	if (!priv) {
 		dbg("%s - bad port private data pointer - exiting", __func__);
-		return;
+		goto out;
 	}
 
 	if (urb != port->read_urb)
@@ -1827,7 +1827,7 @@ static void ftdi_read_bulk_callback(struct urb *urb)
 		/* This will happen at close every time so it is a dbg not an
 		   err */
 		dbg("(this is ok on close) nonzero read bulk status received: %d", status);
-		return;
+		goto out;
 	}
 
 	/* count data bytes, but not status bytes */
@@ -1838,7 +1838,8 @@ static void ftdi_read_bulk_callback(struct urb *urb)
 	spin_unlock_irqrestore(&priv->rx_lock, flags);
 
 	ftdi_process_read(&priv->rx_work.work);
-
+out:
+	tty_kref_put(tty);
 } /* ftdi_read_bulk_callback */
 
 
@@ -1863,7 +1864,7 @@ static void ftdi_process_read(struct work_struct *work)
 	if (port->port.count <= 0)
 		return;
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (!tty) {
 		dbg("%s - bad tty pointer - exiting", __func__);
 		return;
@@ -1872,13 +1873,13 @@ static void ftdi_process_read(struct work_struct *work)
 	priv = usb_get_serial_port_data(port);
 	if (!priv) {
 		dbg("%s - bad port private data pointer - exiting", __func__);
-		return;
+		goto out;
 	}
 
 	urb = port->read_urb;
 	if (!urb) {
 		dbg("%s - bad read_urb pointer - exiting", __func__);
-		return;
+		goto out;
 	}
 
 	data = urb->transfer_buffer;
@@ -2020,7 +2021,7 @@ static void ftdi_process_read(struct work_struct *work)
 			schedule_delayed_work(&priv->rx_work, 1);
 		else
 			dbg("%s - port is closed", __func__);
-		return;
+		goto out;
 	}
 
 	/* urb is completely processed */
@@ -2041,6 +2042,8 @@ static void ftdi_process_read(struct work_struct *work)
 			err("%s - failed resubmitting read urb, error %d",
 							__func__, result);
 	}
+out:
+	tty_kref_put(tty);
 } /* ftdi_process_read */
 
 
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index d953820..2ad0569 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -276,7 +276,7 @@ static inline int isAbortTrfCmnd(const unsigned char *buf)
 static void send_to_tty(struct usb_serial_port *port,
 			char *data, unsigned int actual_length)
 {
-	struct tty_struct *tty = port->port.tty;
+	struct tty_struct *tty = tty_port_tty_get(&port->port);
 
 	if (tty && actual_length) {
 
@@ -287,6 +287,7 @@ static void send_to_tty(struct usb_serial_port *port,
 		tty_insert_flip_string(tty, data, actual_length);
 		tty_flip_buffer_push(tty);
 	}
+	tty_kref_put(tty);
 }
 
 
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index fe84c88..814909f 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -330,7 +330,7 @@ static void resubmit_read_urb(struct usb_serial_port *port, gfp_t mem_flags)
 static void flush_and_resubmit_read_urb(struct usb_serial_port *port)
 {
 	struct urb *urb = port->read_urb;
-	struct tty_struct *tty = port->port.tty;
+	struct tty_struct *tty = tty_port_tty_get(&port->port);
 	int room;
 
 	/* Push data to tty */
@@ -341,6 +341,7 @@ static void flush_and_resubmit_read_urb(struct usb_serial_port *port)
 			tty_flip_buffer_push(tty);
 		}
 	}
+	tty_kref_put(tty);
 
 	resubmit_read_urb(port, GFP_ATOMIC);
 }
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index bfa508d..611f97f 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -600,6 +600,7 @@ static void edge_interrupt_callback(struct urb *urb)
 	struct edgeport_serial	*edge_serial = urb->context;
 	struct edgeport_port *edge_port;
 	struct usb_serial_port *port;
+	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	int length = urb->actual_length;
 	int bytes_avail;
@@ -675,9 +676,12 @@ static void edge_interrupt_callback(struct urb *urb)
 
 					/* tell the tty driver that something
 					   has changed */
-					if (edge_port->port->port.tty)
-						tty_wakeup(edge_port->port->port.tty);
-
+					tty = tty_port_tty_get(
+						&edge_port->port->port);
+					if (tty) {
+						tty_wakeup(tty);
+						tty_kref_put(tty);
+					}
 					/* Since we have more credit, check
 					   if more data can be sent */
 					send_more_port_data(edge_serial,
@@ -778,13 +782,14 @@ static void edge_bulk_out_data_callback(struct urb *urb)
 		    __func__, status);
 	}
 
-	tty = edge_port->port->port.tty;
+	tty = tty_port_tty_get(&edge_port->port->port);
 
 	if (tty && edge_port->open) {
 		/* let the tty driver wakeup if it has a special
 		   write_wakeup function */
 		tty_wakeup(tty);
 	}
+	tty_kref_put(tty);
 
 	/* Release the Write URB */
 	edge_port->write_in_progress = false;
@@ -826,11 +831,12 @@ static void edge_bulk_out_cmd_callback(struct urb *urb)
 	}
 
 	/* Get pointer to tty */
-	tty = edge_port->port->port.tty;
+	tty = tty_port_tty_get(&edge_port->port->port);
 
 	/* tell the tty driver that something has changed */
 	if (tty && edge_port->open)
 		tty_wakeup(tty);
+	tty_kref_put(tty);
 
 	/* we have completed the command */
 	edge_port->commandPending = false;
@@ -1932,11 +1938,13 @@ static void process_rcvd_data(struct edgeport_serial *edge_serial,
 							edge_serial->rxPort];
 				edge_port = usb_get_serial_port_data(port);
 				if (edge_port->open) {
-					tty = edge_port->port->port.tty;
+					tty = tty_port_tty_get(
+						&edge_port->port->port);
 					if (tty) {
 						dbg("%s - Sending %d bytes to TTY for port %d",
 							__func__, rxLen, edge_serial->rxPort);
 						edge_tty_recv(&edge_serial->serial->dev->dev, tty, buffer, rxLen);
+						tty_kref_put(tty);
 					}
 					edge_port->icount.rx += rxLen;
 				}
@@ -1971,6 +1979,7 @@ static void process_rcvd_status(struct edgeport_serial *edge_serial,
 {
 	struct usb_serial_port *port;
 	struct edgeport_port *edge_port;
+	struct tty_struct *tty;
 	__u8 code = edge_serial->rxStatusCode;
 
 	/* switch the port pointer to the one being currently talked about */
@@ -2020,10 +2029,12 @@ static void process_rcvd_status(struct edgeport_serial *edge_serial,
 
 		/* send the current line settings to the port so we are
 		   in sync with any further termios calls */
-		/* FIXME: locking on tty */
-		if (edge_port->port->port.tty)
-			change_port_settings(edge_port->port->port.tty,
-				edge_port, edge_port->port->port.tty->termios);
+		tty = tty_port_tty_get(&edge_port->port->port);
+		if (tty) {
+			change_port_settings(tty,
+				edge_port, tty->termios);
+			tty_kref_put(tty);
+		}
 
 		/* we have completed the open */
 		edge_port->openPending = false;
@@ -2163,10 +2174,14 @@ static void handle_new_lsr(struct edgeport_port *edge_port, __u8 lsrData,
 	}
 
 	/* Place LSR data byte into Rx buffer */
-	if (lsrData && edge_port->port->port.tty)
-		edge_tty_recv(&edge_port->port->dev,
-					edge_port->port->port.tty, &data, 1);
-
+	if (lsrData) {
+		struct tty_struct *tty =
+				tty_port_tty_get(&edge_port->port->port);
+		if (tty) {
+			edge_tty_recv(&edge_port->port->dev, tty, &data, 1);
+			tty_kref_put(tty);
+		}
+	}
 	/* update input line counters */
 	icount = &edge_port->icount;
 	if (newLsr & LSR_BREAK)
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index cb4c543..541dd8e 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -572,7 +572,7 @@ static void chase_port(struct edgeport_port *port, unsigned long timeout,
 								int flush)
 {
 	int baud_rate;
-	struct tty_struct *tty = port->port->port.tty;
+	struct tty_struct *tty = tty_port_tty_get(&port->port->port);
 	wait_queue_t wait;
 	unsigned long flags;
 
@@ -599,6 +599,7 @@ static void chase_port(struct edgeport_port *port, unsigned long timeout,
 	if (flush)
 		edge_buf_clear(port->ep_out_buf);
 	spin_unlock_irqrestore(&port->ep_lock, flags);
+	tty_kref_put(tty);
 
 	/* wait for data to drain from the device */
 	timeout += jiffies;
@@ -1554,7 +1555,7 @@ static void handle_new_msr(struct edgeport_port *edge_port, __u8 msr)
 	/* Save the new modem status */
 	edge_port->shadow_msr = msr & 0xf0;
 
-	tty = edge_port->port->port.tty;
+	tty = tty_port_tty_get(&edge_port->port->port);
 	/* handle CTS flow control */
 	if (tty && C_CRTSCTS(tty)) {
 		if (msr & EDGEPORT_MSR_CTS) {
@@ -1564,6 +1565,7 @@ static void handle_new_msr(struct edgeport_port *edge_port, __u8 msr)
 			tty->hw_stopped = 1;
 		}
 	}
+	tty_kref_put(tty);
 
 	return;
 }
@@ -1574,6 +1576,7 @@ static void handle_new_lsr(struct edgeport_port *edge_port, int lsr_data,
 	struct async_icount *icount;
 	__u8 new_lsr = (__u8)(lsr & (__u8)(LSR_OVER_ERR | LSR_PAR_ERR |
 						LSR_FRM_ERR | LSR_BREAK));
+	struct tty_struct *tty;
 
 	dbg("%s - %02x", __func__, new_lsr);
 
@@ -1587,8 +1590,13 @@ static void handle_new_lsr(struct edgeport_port *edge_port, int lsr_data,
 		new_lsr &= (__u8)(LSR_OVER_ERR | LSR_BREAK);
 
 	/* Place LSR data byte into Rx buffer */
-	if (lsr_data && edge_port->port->port.tty)
-		edge_tty_recv(&edge_port->port->dev, edge_port->port->port.tty, &data, 1);
+	if (lsr_data) {
+		tty = tty_port_tty_get(&edge_port->port->port);
+		if (tty) {
+			edge_tty_recv(&edge_port->port->dev, tty, &data, 1);
+			tty_kref_put(tty);
+		}
+	}
 
 	/* update input line counters */
 	icount = &edge_port->icount;
@@ -1749,7 +1757,7 @@ static void edge_bulk_in_callback(struct urb *urb)
 		++data;
 	}
 
-	tty = edge_port->port->port.tty;
+	tty = tty_port_tty_get(&edge_port->port->port);
 	if (tty && urb->actual_length) {
 		usb_serial_debug_data(debug, &edge_port->port->dev,
 					__func__, urb->actual_length, data);
@@ -1761,6 +1769,7 @@ static void edge_bulk_in_callback(struct urb *urb)
 							urb->actual_length);
 		edge_port->icount.rx += urb->actual_length;
 	}
+	tty_kref_put(tty);
 
 exit:
 	/* continue read unless stopped */
@@ -1796,6 +1805,7 @@ static void edge_bulk_out_callback(struct urb *urb)
 	struct usb_serial_port *port = urb->context;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	int status = urb->status;
+	struct tty_struct *tty;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -1818,7 +1828,9 @@ static void edge_bulk_out_callback(struct urb *urb)
 	}
 
 	/* send any buffered data */
-	edge_send(port->port.tty);
+	tty = tty_port_tty_get(&port->port);
+	edge_send(tty);
+	tty_kref_put(tty);
 }
 
 static int edge_open(struct tty_struct *tty,
@@ -1876,7 +1888,7 @@ static int edge_open(struct tty_struct *tty,
 
 	/* set up the port settings */
 	if (tty)
-		edge_set_termios(tty, port, port->port.tty->termios);
+		edge_set_termios(tty, port, tty->termios);
 
 	/* open up the port */
 
diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
index cd9a2e1..2affa9c 100644
--- a/drivers/usb/serial/ipaq.c
+++ b/drivers/usb/serial/ipaq.c
@@ -764,13 +764,14 @@ static void ipaq_read_bulk_callback(struct urb *urb)
 	usb_serial_debug_data(debug, &port->dev, __func__,
 						urb->actual_length, data);
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 		bytes_in += urb->actual_length;
 	}
+	tty_kref_put(tty);
 
 	/* Continue trying to always read  */
 	usb_fill_bulk_urb(port->read_urb, port->serial->dev,
diff --git a/drivers/usb/serial/ipw.c b/drivers/usb/serial/ipw.c
index a842025..480cac2 100644
--- a/drivers/usb/serial/ipw.c
+++ b/drivers/usb/serial/ipw.c
@@ -170,12 +170,13 @@ static void ipw_read_bulk_callback(struct urb *urb)
 	usb_serial_debug_data(debug, &port->dev, __func__,
 					urb->actual_length, data);
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
+	tty_kref_put(tty);
 
 	/* Continue trying to always read  */
 	usb_fill_bulk_urb(port->read_urb, port->serial->dev,
diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index e59155c..45d4043 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -465,11 +465,12 @@ static void ir_read_bulk_callback(struct urb *urb)
 			ir_baud = *data & 0x0f;
 		usb_serial_debug_data(debug, &port->dev, __func__,
 						urb->actual_length, data);
- 		tty = port->port.tty;
+		tty = tty_port_tty_get(&port->port);
 		if (tty_buffer_request_room(tty, urb->actual_length - 1)) {
 			tty_insert_flip_string(tty, data+1, urb->actual_length - 1);
 			tty_flip_buffer_push(tty);
 		}
+		tty_kref_put(tty);
 
 		/*
 		 * No break here.
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index ddff37f..53710aa 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -629,13 +629,14 @@ static void read_buf_callback(struct urb *urb)
 	}
 
 	dbg("%s - %i chars to write", __func__, urb->actual_length);
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (data == NULL)
 		dbg("%s - data is NULL !!!", __func__);
 	if (tty && urb->actual_length && data) {
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
+	tty_kref_put(tty);
 	iuu_led_activity_on(urb);
 }
 
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 704716f..15447af 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -430,7 +430,7 @@ static void	usa26_indat_callback(struct urb *urb)
 	}
 
 	port =  urb->context;
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
 		/* 0x80 bit is error flag */
 		if ((data[0] & 0x80) == 0) {
@@ -459,6 +459,7 @@ static void	usa26_indat_callback(struct urb *urb)
 		}
 		tty_flip_buffer_push(tty);
 	}
+	tty_kref_put(tty);
 
 	/* Resubmit urb so we continue receiving */
 	urb->dev = port->serial->dev;
@@ -513,6 +514,7 @@ static void	usa26_instat_callback(struct urb *urb)
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
 	struct keyspan_port_private	 	*p_priv;
+	struct tty_struct			*tty;
 	int old_dcd_state, err;
 	int status = urb->status;
 
@@ -553,12 +555,11 @@ static void	usa26_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->gpia_dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if (port->port.tty && !C_CLOCAL(port->port.tty)
-	    && old_dcd_state != p_priv->dcd_state) {
-		if (old_dcd_state)
-			tty_hangup(port->port.tty);
-		/*  else */
-		/*	wake_up_interruptible(&p_priv->open_wait); */
+	if (old_dcd_state != p_priv->dcd_state) {
+		tty = tty_port_tty_get(&port->port);
+		if (tty && !C_CLOCAL(tty))
+			tty_hangup(tty);
+		tty_kref_put(tty);
 	}
 
 	/* Resubmit urb so we continue receiving */
@@ -604,11 +605,12 @@ static void usa28_indat_callback(struct urb *urb)
 		p_priv = usb_get_serial_port_data(port);
 		data = urb->transfer_buffer;
 
-		tty = port->port.tty;
-		if (urb->actual_length) {
+		tty =tty_port_tty_get(&port->port);
+		if (tty && urb->actual_length) {
 			tty_insert_flip_string(tty, data, urb->actual_length);
 			tty_flip_buffer_push(tty);
 		}
+		tty_kref_put(tty);
 
 		/* Resubmit urb so we continue receiving */
 		urb->dev = port->serial->dev;
@@ -652,6 +654,7 @@ static void	usa28_instat_callback(struct urb *urb)
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
 	struct keyspan_port_private	 	*p_priv;
+	struct tty_struct			*tty;
 	int old_dcd_state;
 	int status = urb->status;
 
@@ -689,12 +692,11 @@ static void	usa28_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if (port->port.tty && !C_CLOCAL(port->port.tty)
-	    && old_dcd_state != p_priv->dcd_state) {
-		if (old_dcd_state)
-			tty_hangup(port->port.tty);
-		/*  else */
-		/*	wake_up_interruptible(&p_priv->open_wait); */
+	if( old_dcd_state != p_priv->dcd_state && old_dcd_state) {
+		tty = tty_port_tty_get(&port->port);
+		if (tty && !C_CLOCAL(tty)) 
+			tty_hangup(tty);
+		tty_kref_put(tty);
 	}
 
 		/* Resubmit urb so we continue receiving */
@@ -785,12 +787,11 @@ static void	usa49_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if (port->port.tty && !C_CLOCAL(port->port.tty)
-	    && old_dcd_state != p_priv->dcd_state) {
-		if (old_dcd_state)
-			tty_hangup(port->port.tty);
-		/*  else */
-		/*	wake_up_interruptible(&p_priv->open_wait); */
+	if (old_dcd_state != p_priv->dcd_state && old_dcd_state) {
+		struct tty_struct *tty = tty_port_tty_get(&port->port);
+		if (tty && !C_CLOCAL(tty))
+			tty_hangup(tty);
+		tty_kref_put(tty);
 	}
 
 	/* Resubmit urb so we continue receiving */
@@ -827,7 +828,7 @@ static void	usa49_indat_callback(struct urb *urb)
 	}
 
 	port =  urb->context;
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
 		/* 0x80 bit is error flag */
 		if ((data[0] & 0x80) == 0) {
@@ -850,6 +851,7 @@ static void	usa49_indat_callback(struct urb *urb)
 		}
 		tty_flip_buffer_push(tty);
 	}
+	tty_kref_put(tty);
 
 	/* Resubmit urb so we continue receiving */
 	urb->dev = port->serial->dev;
@@ -893,7 +895,7 @@ static void usa49wg_indat_callback(struct urb *urb)
 				return;
 			}
 			port = serial->port[data[i++]];
-			tty = port->port.tty;
+			tty = tty_port_tty_get(&port->port);
 			len = data[i++];
 
 			/* 0x80 bit is error flag */
@@ -927,6 +929,7 @@ static void usa49wg_indat_callback(struct urb *urb)
 			}
 			if (port->port.count)
 				tty_flip_buffer_push(tty);
+			tty_kref_put(tty);
 		}
 	}
 
@@ -967,8 +970,8 @@ static void usa90_indat_callback(struct urb *urb)
 	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 
-	tty = port->port.tty;
 	if (urb->actual_length) {
+		tty = tty_port_tty_get(&port->port);
 		/* if current mode is DMA, looks like usa28 format
 		   otherwise looks like usa26 data format */
 
@@ -1004,6 +1007,7 @@ static void usa90_indat_callback(struct urb *urb)
 			}
 		}
 		tty_flip_buffer_push(tty);
+		tty_kref_put(tty);
 	}
 
 	/* Resubmit urb so we continue receiving */
@@ -1025,6 +1029,7 @@ static void	usa90_instat_callback(struct urb *urb)
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
 	struct keyspan_port_private	 	*p_priv;
+	struct tty_struct			*tty;
 	int old_dcd_state, err;
 	int status = urb->status;
 
@@ -1053,12 +1058,11 @@ static void	usa90_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if (port->port.tty && !C_CLOCAL(port->port.tty)
-	    && old_dcd_state != p_priv->dcd_state) {
-		if (old_dcd_state)
-			tty_hangup(port->port.tty);
-		/*  else */
-		/*	wake_up_interruptible(&p_priv->open_wait); */
+	if (old_dcd_state != p_priv->dcd_state && old_dcd_state) {
+		tty = tty_port_tty_get(&port->port);
+		if (tty && !C_CLOCAL(tty))
+			tty_hangup(tty);
+		tty_kref_put(tty);
 	}
 
 	/* Resubmit urb so we continue receiving */
@@ -1130,12 +1134,11 @@ static void	usa67_instat_callback(struct urb *urb)
 	p_priv->cts_state = ((msg->hskia_cts) ? 1 : 0);
 	p_priv->dcd_state = ((msg->gpia_dcd) ? 1 : 0);
 
-	if (port->port.tty && !C_CLOCAL(port->port.tty)
-	    && old_dcd_state != p_priv->dcd_state) {
-		if (old_dcd_state)
-			tty_hangup(port->port.tty);
-		/*  else */
-		/*	wake_up_interruptible(&p_priv->open_wait); */
+	if (old_dcd_state != p_priv->dcd_state && old_dcd_state) {
+		struct tty_struct *tty = tty_port_tty_get(&port->port);
+		if (tty && !C_CLOCAL(tty))
+			tty_hangup(tty);
+		tty_kref_put(tty);
 	}
 
 	/* Resubmit urb so we continue receiving */
@@ -1332,7 +1335,7 @@ static void keyspan_close(struct tty_struct *tty,
 			stop_urb(p_priv->out_urbs[i]);
 		}
 	}
-	port->port.tty = NULL;
+	tty_port_tty_set(&port->port, NULL);
 }
 
 /* download the firmware to a pre-renumeration device */
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 040040a..99e9a14 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -172,8 +172,9 @@ static void keyspan_pda_wakeup_write(struct work_struct *work)
 	struct keyspan_pda_private *priv =
 		container_of(work, struct keyspan_pda_private, wakeup_work);
 	struct usb_serial_port *port = priv->port;
-
-	tty_wakeup(port->port.tty);
+	struct tty_struct *tty = tty_port_tty_get(&port->port);
+	tty_wakeup(tty);
+	tty_kref_put(tty);
 }
 
 static void keyspan_pda_request_unthrottle(struct work_struct *work)
@@ -205,7 +206,7 @@ static void keyspan_pda_request_unthrottle(struct work_struct *work)
 static void keyspan_pda_rx_interrupt(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
-	struct tty_struct *tty = port->port.tty;
+	struct tty_struct *tty = tty_port_tty_get(&port->port);
 	unsigned char *data = urb->transfer_buffer;
 	int retval;
 	int status = urb->status;
@@ -222,7 +223,7 @@ static void keyspan_pda_rx_interrupt(struct urb *urb)
 		/* this urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
 		    __func__, status);
-		return;
+		goto out;
 	default:
 		dbg("%s - nonzero urb status received: %d",
 		    __func__, status);
@@ -261,8 +262,11 @@ static void keyspan_pda_rx_interrupt(struct urb *urb)
 exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
-		err("%s - usb_submit_urb failed with result %d",
-		     __func__, retval);
+		dev_err(&port->dev,
+			"%s - usb_submit_urb failed with result %d",
+			__func__, retval);
+out:
+	tty_kref_put(tty);		     
 }
 
 
diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index b84dddc..ff3a07f 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -658,7 +658,7 @@ static void klsi_105_read_bulk_callback(struct urb *urb)
 	} else {
 		int bytes_sent = ((__u8 *) data)[0] +
 				 ((unsigned int) ((__u8 *) data)[1] << 8);
-		tty = port->port.tty;
+		tty = tty_port_tty_get(&port->port);
 		/* we should immediately resubmit the URB, before attempting
 		 * to pass the data on to the tty layer. But that needs locking
 		 * against re-entry an then mixed-up data because of
@@ -679,6 +679,7 @@ static void klsi_105_read_bulk_callback(struct urb *urb)
 		tty_buffer_request_room(tty, bytes_sent);
 		tty_insert_flip_string(tty, data + 2, bytes_sent);
 		tty_flip_buffer_push(tty);
+		tty_kref_put(tty);
 
 		/* again lockless, but debug info only */
 		priv->bytes_in += bytes_sent;
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index deba28e..cfcf37c 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -383,7 +383,7 @@ static void kobil_read_int_callback(struct urb *urb)
 		return;
 	}
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (urb->actual_length) {
 
 		/* BEGIN DEBUG */
@@ -405,6 +405,7 @@ static void kobil_read_int_callback(struct urb *urb)
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
+	tty_kref_put(tty);
 	/* someone sets the dev to 0 if the close method has been called */
 	port->interrupt_in_urb->dev = port->serial->dev;
 
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index 0ded8bd..9b2cef8 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -563,10 +563,11 @@ static void mct_u232_read_int_callback(struct urb *urb)
 	 * Work-a-round: handle the 'usual' bulk-in pipe here
 	 */
 	if (urb->transfer_buffer_length > 2) {
-		tty = port->port.tty;
+		tty = tty_port_tty_get(&port->port);
 		if (urb->actual_length) {
 			tty_insert_flip_string(tty, data, urb->actual_length);
 			tty_flip_buffer_push(tty);
+			tty_kref_put(tty);
 		}
 		goto exit;
 	}
@@ -591,7 +592,7 @@ static void mct_u232_read_int_callback(struct urb *urb)
 	 * to look in to this before committing any code.
 	 */
 	if (priv->last_lsr & MCT_U232_LSR_ERR) {
-		tty = port->port.tty;
+		tty = tty_port_tty_get(&port->port);
 		/* Overrun Error */
 		if (priv->last_lsr & MCT_U232_LSR_OE) {
 		}
@@ -604,6 +605,7 @@ static void mct_u232_read_int_callback(struct urb *urb)
 		/* Break Indicator */
 		if (priv->last_lsr & MCT_U232_LSR_BI) {
 		}
+		tty_kref_put(tty);
 	}
 #endif
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 7c4917d..7b538ca 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -216,12 +216,13 @@ static void mos7720_bulk_in_callback(struct urb *urb)
 
 	data = urb->transfer_buffer;
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
+	tty_kref_put(tty);
 
 	if (!port->read_urb) {
 		dbg("URB KILLED !!!");
@@ -262,10 +263,11 @@ static void mos7720_bulk_out_data_callback(struct urb *urb)
 
 	dbg("Entering .........");
 
-	tty = mos7720_port->port->port.tty;
+	tty = tty_port_tty_get(&mos7720_port->port->port);
 
 	if (tty && mos7720_port->open)
 		tty_wakeup(tty);
+	tty_kref_put(tty);
 }
 
 /*
@@ -1267,29 +1269,6 @@ static int get_lsr_info(struct tty_struct *tty,
 	return 0;
 }
 
-/*
- * get_number_bytes_avail - get number of bytes available
- *
- * Purpose: Let user call ioctl to get the count of number of bytes available.
- */
-static int get_number_bytes_avail(struct moschip_port *mos7720_port,
-				  unsigned int __user *value)
-{
-	unsigned int result = 0;
-	struct tty_struct *tty = mos7720_port->port->port.tty;
-
-	if (!tty)
-		return -ENOIOCTLCMD;
-
-	result = tty->read_cnt;
-
-	dbg("%s(%d) = %d", __func__,  mos7720_port->port->number, result);
-	if (copy_to_user(value, &result, sizeof(int)))
-		return -EFAULT;
-
-	return -ENOIOCTLCMD;
-}
-
 static int set_modem_info(struct moschip_port *mos7720_port, unsigned int cmd,
 			  unsigned int __user *value)
 {
@@ -1409,13 +1388,6 @@ static int mos7720_ioctl(struct tty_struct *tty, struct file *file,
 	dbg("%s - port %d, cmd = 0x%x", __func__, port->number, cmd);
 
 	switch (cmd) {
-	case TIOCINQ:
-		/* return number of bytes available */
-		dbg("%s (%d) TIOCINQ", __func__,  port->number);
-		return get_number_bytes_avail(mos7720_port,
-					      (unsigned int __user *)arg);
-		break;
-
 	case TIOCSERGETLSR:
 		dbg("%s (%d) TIOCSERGETLSR", __func__,  port->number);
 		return get_lsr_info(tty, mos7720_port,
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 09d8206..60543d7 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -709,12 +709,13 @@ static void mos7840_bulk_in_callback(struct urb *urb)
 	dbg("%s", "Entering ........... \n");
 
 	if (urb->actual_length) {
-		tty = mos7840_port->port->port.tty;
+		tty = tty_port_tty_get(&mos7840_port->port->port);
 		if (tty) {
 			tty_buffer_request_room(tty, urb->actual_length);
 			tty_insert_flip_string(tty, data, urb->actual_length);
 			dbg(" %s \n", data);
 			tty_flip_buffer_push(tty);
+			tty_kref_put(tty);
 		}
 		mos7840_port->icount.rx += urb->actual_length;
 		smp_wmb();
@@ -773,10 +774,10 @@ static void mos7840_bulk_out_data_callback(struct urb *urb)
 
 	dbg("%s \n", "Entering .........");
 
-	tty = mos7840_port->port->port.tty;
-
+	tty = tty_port_tty_get(&mos7840_port->port->port);
 	if (tty && mos7840_port->open)
 		tty_wakeup(tty);
+	tty_kref_put(tty);
 
 }
 
diff --git a/drivers/usb/serial/navman.c b/drivers/usb/serial/navman.c
index d673653..bcdcbb8 100644
--- a/drivers/usb/serial/navman.c
+++ b/drivers/usb/serial/navman.c
@@ -64,12 +64,13 @@ static void navman_read_int_callback(struct urb *urb)
 	usb_serial_debug_data(debug, &port->dev, __func__,
 			      urb->actual_length, data);
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
+	tty_kref_put(tty);
 
 exit:
 	result = usb_submit_urb(urb, GFP_ATOMIC);
diff --git a/drivers/usb/serial/omninet.c b/drivers/usb/serial/omninet.c
index ae8e227..c4d70b0 100644
--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -172,7 +172,7 @@ static int omninet_open(struct tty_struct *tty,
 	dbg("%s - port %d", __func__, port->number);
 
 	wport = serial->port[1];
-	wport->port.tty = tty;		/* FIXME */
+	tty_port_tty_set(&wport->port, tty);
 
 	/* Start reading from the device */
 	usb_fill_bulk_urb(port->read_urb, serial->dev,
@@ -229,9 +229,11 @@ static void omninet_read_bulk_callback(struct urb *urb)
 	}
 
 	if (urb->actual_length && header->oh_len) {
-		tty_insert_flip_string(port->port.tty,
-			data + OMNINET_DATAOFFSET, header->oh_len);
-		tty_flip_buffer_push(port->port.tty);
+		struct tty_struct *tty = tty_port_tty_get(&port->port);
+		tty_insert_flip_string(tty, data + OMNINET_DATAOFFSET,
+							header->oh_len);
+		tty_flip_buffer_push(tty);
+		tty_kref_put(tty);
 	}
 
 	/* Continue trying to always read  */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 73f8277..6b1727e 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -571,14 +571,14 @@ static void option_indat_callback(struct urb *urb)
 		dbg("%s: nonzero status: %d on endpoint %02x.",
 		    __func__, status, endpoint);
 	} else {
-		tty = port->port.tty;
+		tty = tty_port_tty_get(&port->port);
 		if (urb->actual_length) {
 			tty_buffer_request_room(tty, urb->actual_length);
 			tty_insert_flip_string(tty, data, urb->actual_length);
 			tty_flip_buffer_push(tty);
-		} else {
+		} else 
 			dbg("%s: empty read urb received", __func__);
-		}
+		tty_kref_put(tty);
 
 		/* Resubmit urb so we continue receiving */
 		if (port->port.count && status != -ESHUTDOWN) {
@@ -647,9 +647,13 @@ static void option_instat_callback(struct urb *urb)
 			portdata->dsr_state = ((signals & 0x02) ? 1 : 0);
 			portdata->ri_state = ((signals & 0x08) ? 1 : 0);
 
-			if (port->port.tty && !C_CLOCAL(port->port.tty) &&
-					old_dcd_state && !portdata->dcd_state)
-				tty_hangup(port->port.tty);
+			if (old_dcd_state && !portdata->dcd_state) {
+				struct tty_struct *tty =
+						tty_port_tty_get(&port->port);
+				if (tty && !C_CLOCAL(tty))
+					tty_hangup(tty);
+				tty_kref_put(tty);
+			}
 		} else {
 			dbg("%s: type %x req %x", __func__,
 				req_pkt->bRequestType, req_pkt->bRequest);
@@ -793,7 +797,7 @@ static void option_close(struct tty_struct *tty,
 		for (i = 0; i < N_OUT_URB; i++)
 			usb_kill_urb(portdata->out_urbs[i]);
 	}
-	port->port.tty = NULL;	/* FIXME */
+	tty_port_tty_set(&port->port, NULL);
 }
 
 /* Helper functions used by option_setup_urbs */
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index 81db571..057f72a 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -1002,11 +1002,12 @@ static void oti6858_read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (tty != NULL && urb->actual_length > 0) {
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
+	tty_kref_put(tty);
 
 	/* schedule the interrupt urb if we are still open */
 	if (port->port.count != 0) {
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 1ede144..ba74424 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -1057,7 +1057,7 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 		tty_flag = TTY_FRAME;
 	dbg("%s - tty_flag = %d", __func__, tty_flag);
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length + 1);
 		/* overrun is special, not associated with a char */
@@ -1067,7 +1067,7 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 			tty_insert_flip_char(tty, data[i], tty_flag);
 		tty_flip_buffer_push(tty);
 	}
-
+	tty_kref_put(tty);
 	/* Schedule the next read _if_ we are still open */
 	if (port->port.count) {
 		urb->dev = port->serial->dev;
diff --git a/drivers/usb/serial/safe_serial.c b/drivers/usb/serial/safe_serial.c
index def52d0..72903ac 100644
--- a/drivers/usb/serial/safe_serial.c
+++ b/drivers/usb/serial/safe_serial.c
@@ -217,6 +217,7 @@ static void safe_read_bulk_callback(struct urb *urb)
 	struct usb_serial_port *port =  urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned char length = urb->actual_length;
+	struct tty_struct *tty;
 	int result;
 	int status = urb->status;
 
@@ -242,6 +243,7 @@ static void safe_read_bulk_callback(struct urb *urb)
 		printk("\n");
 	}
 #endif
+	tty = tty_port_tty_get(&port->port);
 	if (safe) {
 		__u16 fcs;
 		fcs = fcs_compute10(data, length, CRC10_INITFCS);
@@ -250,9 +252,9 @@ static void safe_read_bulk_callback(struct urb *urb)
 			if (actual_length <= (length - 2)) {
 				info("%s - actual: %d", __func__,
 							actual_length);
-				tty_insert_flip_string(port->port.tty,
+				tty_insert_flip_string(tty,
 							data, actual_length);
-				tty_flip_buffer_push(port->port.tty);
+				tty_flip_buffer_push(tty);
 			} else {
 				err("%s - inconsistent lengths %d:%d",
 					__func__, actual_length, length);
@@ -261,9 +263,10 @@ static void safe_read_bulk_callback(struct urb *urb)
 			err("%s - bad CRC %x", __func__, fcs);
 		}
 	} else {
-		tty_insert_flip_string(port->port.tty, data, length);
-		tty_flip_buffer_push(port->port.tty);
+		tty_insert_flip_string(tty, data, length);
+		tty_flip_buffer_push(tty);
 	}
+	tty_kref_put(tty);
 
 	/* Continue trying to always read  */
 	usb_fill_bulk_urb(urb, port->serial->dev,
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index ea1a103..8b9eaf3 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -440,14 +440,14 @@ static void sierra_indat_callback(struct urb *urb)
 		dbg("%s: nonzero status: %d on endpoint %02x.",
 		    __func__, status, endpoint);
 	} else {
-		tty = port->port.tty;
 		if (urb->actual_length) {
+		tty = tty_port_tty_get(&port->port);
 			tty_buffer_request_room(tty, urb->actual_length);
 			tty_insert_flip_string(tty, data, urb->actual_length);
 			tty_flip_buffer_push(tty);
-		} else {
+			tty_kref_put(tty);
+		} else
 			dbg("%s: empty read urb received", __func__);
-		}
 
 		/* Resubmit urb so we continue receiving */
 		if (port->port.count && status != -ESHUTDOWN) {
@@ -485,6 +485,7 @@ static void sierra_instat_callback(struct urb *urb)
 			unsigned char signals = *((unsigned char *)
 					urb->transfer_buffer +
 					sizeof(struct usb_ctrlrequest));
+			struct tty_struct *tty;
 
 			dbg("%s: signal x%x", __func__, signals);
 
@@ -494,9 +495,11 @@ static void sierra_instat_callback(struct urb *urb)
 			portdata->dsr_state = ((signals & 0x02) ? 1 : 0);
 			portdata->ri_state = ((signals & 0x08) ? 1 : 0);
 
-			if (port->port.tty && !C_CLOCAL(port->port.tty) &&
+			tty = tty_port_tty_get(&port->port);
+			if (tty && !C_CLOCAL(tty) &&
 					old_dcd_state && !portdata->dcd_state)
-				tty_hangup(port->port.tty);
+				tty_hangup(tty);
+			tty_kref_put(tty);
 		} else {
 			dbg("%s: type %x req %x", __func__,
 				req_pkt->bRequestType, req_pkt->bRequest);
@@ -616,8 +619,7 @@ static void sierra_close(struct tty_struct *tty,
 	}
 
 	usb_kill_urb(port->interrupt_in_urb);
-
-	port->port.tty = NULL;	/* FIXME */
+	tty_port_tty_set(&port->port, NULL);
 }
 
 static int sierra_startup(struct usb_serial *serial)
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 283cf6b..1533d6e 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -755,7 +755,7 @@ static void spcp8x5_read_bulk_callback(struct urb *urb)
 		tty_flag = TTY_FRAME;
 	dev_dbg(&port->dev, "tty_flag = %d\n", tty_flag);
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length + 1);
 		/* overrun is special, not associated with a char */
@@ -765,6 +765,7 @@ static void spcp8x5_read_bulk_callback(struct urb *urb)
 			tty_insert_flip_char(tty, data[i], tty_flag);
 		tty_flip_buffer_push(tty);
 	}
+	tty_kref_put(tty);
 
 	/* Schedule the next read _if_ we are still open */
 	if (port->port.count) {
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 9a3e495..c90237d 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -179,7 +179,7 @@ static int ti_set_mcr(struct ti_port *tport, unsigned int mcr);
 static int ti_get_lsr(struct ti_port *tport);
 static int ti_get_serial_info(struct ti_port *tport,
 	struct serial_struct __user *ret_arg);
-static int ti_set_serial_info(struct ti_port *tport,
+static int ti_set_serial_info(struct tty_struct *tty, struct ti_port *tport,
 	struct serial_struct __user *new_arg);
 static void ti_handle_new_msr(struct ti_port *tport, __u8 msr);
 
@@ -857,8 +857,8 @@ static int ti_ioctl(struct tty_struct *tty, struct file *file,
 				(struct serial_struct __user *)arg);
 	case TIOCSSERIAL:
 		dbg("%s - (%d) TIOCSSERIAL", __func__, port->number);
-		return ti_set_serial_info(tport,
-					(struct serial_struct __user *)arg);
+		return ti_set_serial_info(tty, tport,
+				(struct serial_struct __user *)arg);
 	case TIOCMIWAIT:
 		dbg("%s - (%d) TIOCMIWAIT", __func__, port->number);
 		cprev = tport->tp_icount;
@@ -1211,6 +1211,7 @@ static void ti_bulk_in_callback(struct urb *urb)
 	struct device *dev = &urb->dev->dev;
 	int status = urb->status;
 	int retval = 0;
+	struct tty_struct *tty;
 
 	dbg("%s", __func__);
 
@@ -1239,20 +1240,22 @@ static void ti_bulk_in_callback(struct urb *urb)
 		return;
 	}
 
-	if (port->port.tty && urb->actual_length) {
+	tty = tty_port_tty_get(&port->port);
+	if (tty && urb->actual_length) {
 		usb_serial_debug_data(debug, dev, __func__,
 			urb->actual_length, urb->transfer_buffer);
 
 		if (!tport->tp_is_open)
 			dbg("%s - port closed, dropping data", __func__);
 		else
-			ti_recv(&urb->dev->dev, port->port.tty,
+			ti_recv(&urb->dev->dev, tty,
 						urb->transfer_buffer,
 						urb->actual_length);
 
 		spin_lock(&tport->tp_lock);
 		tport->tp_icount.rx += urb->actual_length;
 		spin_unlock(&tport->tp_lock);
+		tty_kref_put(tty);
 	}
 
 exit:
@@ -1330,7 +1333,7 @@ static void ti_send(struct ti_port *tport)
 {
 	int count, result;
 	struct usb_serial_port *port = tport->tp_port;
-	struct tty_struct *tty = port->port.tty;	/* FIXME */
+	struct tty_struct *tty = tty_port_tty_get(&port->port);	/* FIXME */
 	unsigned long flags;
 
 
@@ -1338,19 +1341,15 @@ static void ti_send(struct ti_port *tport)
 
 	spin_lock_irqsave(&tport->tp_lock, flags);
 
-	if (tport->tp_write_urb_in_use) {
-		spin_unlock_irqrestore(&tport->tp_lock, flags);
-		return;
-	}
+	if (tport->tp_write_urb_in_use)
+		goto unlock;
 
 	count = ti_buf_get(tport->tp_write_buf,
 				port->write_urb->transfer_buffer,
 				port->bulk_out_size);
 
-	if (count == 0) {
-		spin_unlock_irqrestore(&tport->tp_lock, flags);
-		return;
-	}
+	if (count == 0)
+		goto unlock;
 
 	tport->tp_write_urb_in_use = 1;
 
@@ -1380,7 +1379,13 @@ static void ti_send(struct ti_port *tport)
 	/* more room in the buffer for new writes, wakeup */
 	if (tty)
 		tty_wakeup(tty);
+	tty_kref_put(tty);
 	wake_up_interruptible(&tport->tp_write_wait);
+	return;
+unlock:
+	spin_unlock_irqrestore(&tport->tp_lock, flags);
+	tty_kref_put(tty);
+	return;
 }
 
 
@@ -1464,20 +1469,16 @@ static int ti_get_serial_info(struct ti_port *tport,
 }
 
 
-static int ti_set_serial_info(struct ti_port *tport,
+static int ti_set_serial_info(struct tty_struct *tty, struct ti_port *tport,
 	struct serial_struct __user *new_arg)
 {
-	struct usb_serial_port *port = tport->tp_port;
 	struct serial_struct new_serial;
 
 	if (copy_from_user(&new_serial, new_arg, sizeof(new_serial)))
 		return -EFAULT;
 
 	tport->tp_flags = new_serial.flags & TI_SET_SERIAL_FLAGS;
-	/* FIXME */
-	if (port->port.tty)
-		port->port.tty->low_latency =
-			(tport->tp_flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	tty->low_latency = (tport->tp_flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 	tport->tp_closing_wait = new_serial.closing_wait;
 
 	return 0;
@@ -1510,7 +1511,7 @@ static void ti_handle_new_msr(struct ti_port *tport, __u8 msr)
 	tport->tp_msr = msr & TI_MSR_MASK;
 
 	/* handle CTS flow control */
-	tty = tport->tp_port->port.tty;
+	tty = tty_port_tty_get(&tport->tp_port->port);
 	if (tty && C_CRTSCTS(tty)) {
 		if (msr & TI_MSR_CTS) {
 			tty->hw_stopped = 0;
@@ -1519,6 +1520,7 @@ static void ti_handle_new_msr(struct ti_port *tport, __u8 msr)
 			tty->hw_stopped = 1;
 		}
 	}
+	tty_kref_put(tty);
 }
 
 
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 4f7f9e3..e7d4246 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -214,7 +214,7 @@ static int serial_open (struct tty_struct *tty, struct file *filp)
 	/* set up our port structure making the tty driver
 	 * remember our port object, and us it */
 	tty->driver_data = port;
-	port->port.tty = tty;
+	tty_port_tty_set(&port->port, tty);
 
 	if (port->port.count == 1) {
 
@@ -246,7 +246,7 @@ bailout_module_put:
 bailout_mutex_unlock:
 	port->port.count = 0;
 	tty->driver_data = NULL;
-	port->port.tty = NULL;
+	tty_port_tty_set(&port->port, NULL);
 	mutex_unlock(&port->mutex);
 bailout_kref_put:
 	usb_serial_put(serial);
@@ -276,10 +276,11 @@ static void serial_close(struct tty_struct *tty, struct file *filp)
 		port->serial->type->close(tty, port, filp);
 
 	if (port->port.count == (port->console? 1 : 0)) {
-		if (port->port.tty) {
-			if (port->port.tty->driver_data)
-				port->port.tty->driver_data = NULL;
-			port->port.tty = NULL;
+		struct tty_struct *tty = tty_port_tty_get(&port->port);
+		if (tty) {
+			if (tty->driver_data)
+				tty->driver_data = NULL;
+			tty_port_tty_set(&port->port, NULL);
 		}
 	}
 
@@ -508,11 +509,12 @@ static void usb_serial_port_work(struct work_struct *work)
 	if (!port)
 		return;
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (!tty)
 		return;
 
 	tty_wakeup(tty);
+	tty_kref_put(tty);
 }
 
 static void port_release(struct device *dev)
@@ -819,6 +821,7 @@ int usb_serial_probe(struct usb_interface *interface,
 		port = kzalloc(sizeof(struct usb_serial_port), GFP_KERNEL);
 		if (!port)
 			goto probe_error;
+		tty_port_init(&port->port);
 		port->serial = serial;
 		spin_lock_init(&port->lock);
 		mutex_init(&port->mutex);
@@ -1040,8 +1043,11 @@ void usb_serial_disconnect(struct usb_interface *interface)
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		if (port) {
-			if (port->port.tty)
-				tty_hangup(port->port.tty);
+			struct tty_struct *tty = tty_port_tty_get(&port->port);
+			if (tty) {
+				tty_hangup(tty);
+				tty_kref_put(tty);
+			}
 			kill_traffic(port);
 		}
 	}
diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index cf8924f..a6d1c75 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -499,7 +499,7 @@ static void visor_read_bulk_callback(struct urb *urb)
 	int status = urb->status;
 	struct tty_struct *tty;
 	int result;
-	int available_room;
+	int available_room = 0;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -512,13 +512,17 @@ static void visor_read_bulk_callback(struct urb *urb)
 	usb_serial_debug_data(debug, &port->dev, __func__,
 						urb->actual_length, data);
 
-	tty = port->port.tty;
-	if (tty && urb->actual_length) {
-		available_room = tty_buffer_request_room(tty,
+	if (urb->actual_length) {
+		tty = tty_port_tty_get(&port->port);
+		if (tty) {
+			available_room = tty_buffer_request_room(tty,
 							urb->actual_length);
-		if (available_room) {
-			tty_insert_flip_string(tty, data, available_room);
-			tty_flip_buffer_push(tty);
+			if (available_room) {
+				tty_insert_flip_string(tty, data,
+							available_room);
+				tty_flip_buffer_push(tty);
+			}
+			tty_kref_put(tty);
 		}
 		spin_lock(&priv->lock);
 		priv->bytes_in += available_room;
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 3a9d143..11c8b97 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -1481,7 +1481,7 @@ static void rx_data_softint(struct work_struct *work)
 	struct whiteheat_private *info =
 		container_of(work, struct whiteheat_private, rx_work);
 	struct usb_serial_port *port = info->port;
-	struct tty_struct *tty = port->port.tty;
+	struct tty_struct *tty = tty_port_tty_get(&port->port);
 	struct whiteheat_urb_wrap *wrap;
 	struct urb *urb;
 	unsigned long flags;
@@ -1493,7 +1493,7 @@ static void rx_data_softint(struct work_struct *work)
 	spin_lock_irqsave(&info->lock, flags);
 	if (info->flags & THROTTLED) {
 		spin_unlock_irqrestore(&info->lock, flags);
-		return;
+		goto out;
 	}
 
 	list_for_each_safe(tmp, tmp2, &info->rx_urb_q) {
@@ -1513,7 +1513,7 @@ static void rx_data_softint(struct work_struct *work)
 				spin_unlock_irqrestore(&info->lock, flags);
 				tty_flip_buffer_push(tty);
 				schedule_work(&info->rx_work);
-				return;
+				goto out;
 			}
 			tty_insert_flip_string(tty, urb->transfer_buffer, len);
 			sent += len;
@@ -1536,6 +1536,8 @@ static void rx_data_softint(struct work_struct *work)
 
 	if (sent)
 		tty_flip_buffer_push(tty);
+out:
+	tty_kref_put(tty);
 }
 
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index b64d10b..c30ed8d 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -182,6 +182,7 @@ struct signal_struct;
 
 struct tty_port {
 	struct tty_struct	*tty;		/* Back pointer */
+	spinlock_t		lock;		/* Lock protecting tty field */
 	int			blocked_open;	/* Waiting to open */
 	int			count;		/* Usage count */
 	wait_queue_head_t	open_wait;	/* Open waiters */
@@ -405,6 +406,8 @@ extern int tty_write_lock(struct tty_struct *tty, int ndelay);
 extern void tty_port_init(struct tty_port *port);
 extern int tty_port_alloc_xmit_buf(struct tty_port *port);
 extern void tty_port_free_xmit_buf(struct tty_port *port);
+extern struct tty_struct *tty_port_tty_get(struct tty_port *port);
+extern void tty_port_tty_set(struct tty_port *port, struct tty_struct *tty);
 
 extern int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc);
 extern int tty_unregister_ldisc(int disc);

