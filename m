Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYFUKfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYFUKfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 06:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYFUKfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 06:35:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52863 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752410AbYFUKez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 06:34:55 -0400
Date: Sat, 21 Jun 2008 11:17:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: (Resend of 23/70 plus reply [PATCH 00/70] tty updates proposed for
 2.6.27)
Message-ID: <20080621111709.7e8f7d44@lxorguk.ukuu.org.uk>
In-Reply-To: <20080621090910.GA12516@kroah.com>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
	<20080621090910.GA12516@kroah.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ah, thanks for resending these, as they are primarily USB changes, any
> objection for me to take these through my USB tree?

None at all. I've attached 23/70 which got eaten originally by a size
limit. 

Alan

usb_serial: API all change

From: Alan Cox <alan@redhat.com>

USB serial likes to use port->tty back pointers for the real work it does and
to do so without any actual locking. Unfortunately when you consider hangup
events, hangup/parallel reopen or even worse hangup followed by parallel close
events the tty->port and port->tty pointers are not guaranteed to be the same
as port->tty is the active tty while tty->port is the port the tty may or
may not still be attached to.

So rework the entire API to pass the tty struct. For console cases we need
to pass both for now. This shows up multiple drivers that immediately crash
with USB console some of which have been fixed in the process.

Longer term we need a proper tty as console abstraction
---

 drivers/usb/serial/Kconfig            |    8 
 drivers/usb/serial/aircable.c         |   19 
 drivers/usb/serial/airprime.c         |   16 
 drivers/usb/serial/ark3116.c          |   32 -
 drivers/usb/serial/belkin_sa.c        |   69 -
 drivers/usb/serial/ch341.c            |   10 
 drivers/usb/serial/console.c          |   34 -
 drivers/usb/serial/cp2101.c           |   73 +
 drivers/usb/serial/cyberjack.c        |   47 -
 drivers/usb/serial/cypress_m8.c       |  117 +-
 drivers/usb/serial/digi_acceleport.c  |  127 +-
 drivers/usb/serial/empeg.c            |   78 +
 drivers/usb/serial/ftdi_sio.c         |  213 ++--
 drivers/usb/serial/garmin_gps.c       |   58 -
 drivers/usb/serial/generic.c          |   39 -
 drivers/usb/serial/io_edgeport.c      |  175 +--
 drivers/usb/serial/io_fw_down3.h      |   11 
 drivers/usb/serial/io_ti.c            | 1924 +++++++++++++++------------------
 drivers/usb/serial/ipaq.c             |   48 -
 drivers/usb/serial/ipw.c              |   15 
 drivers/usb/serial/ir-usb.c           |   35 -
 drivers/usb/serial/iuu_phoenix.c      |   43 -
 drivers/usb/serial/keyspan.c          |  138 +-
 drivers/usb/serial/keyspan.h          |   39 -
 drivers/usb/serial/keyspan_pda.c      |   69 -
 drivers/usb/serial/kl5kusb105.c       |   74 +
 drivers/usb/serial/kobil_sct.c        |   80 +
 drivers/usb/serial/mct_u232.c         |  121 +-
 drivers/usb/serial/mos7720.c          |   87 +
 drivers/usb/serial/mos7840.c          |  165 +--
 drivers/usb/serial/navman.c           |   10 
 drivers/usb/serial/omninet.c          |   26 
 drivers/usb/serial/option.c           |  105 +-
 drivers/usb/serial/oti6858.c          |  119 +-
 drivers/usb/serial/pl2303.c           |   76 +
 drivers/usb/serial/safe_serial.c      |   14 
 drivers/usb/serial/sierra.c           |   93 --
 drivers/usb/serial/spcp8x5.c          |   69 +
 drivers/usb/serial/ti_fw_3410.h       |    4 
 drivers/usb/serial/ti_fw_5052.h       |    5 
 drivers/usb/serial/ti_usb_3410_5052.c |  214 ++--
 drivers/usb/serial/usb-serial.c       |   82 +
 drivers/usb/serial/visor.c            |   66 -
 drivers/usb/serial/whiteheat.c        |  102 +-
 include/linux/usb/serial.h            |   56 +
 45 files changed, 2330 insertions(+), 2675 deletions(-)


diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 9ba64cc..19bd00a 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -523,6 +523,14 @@ config USB_SERIAL_TI
 	  To compile this driver as a module, choose M here: the
 	  module will be called ti_usb_3410_5052.
 
+config USB_SERIAL_TI_FIRMWARE
+	bool "USB TI 3410/5052 Firmware"
+	depends on USB_SERIAL_TI
+	help
+	  say Y to include the firmware into the kernel for compatibility
+	  with older setups. Say N if you have the firmware files installed
+	  in /etc/firmware.
+
 config USB_SERIAL_CYBERJACK
 	tristate "USB REINER SCT cyberJack pinpad/e-com chipcard reader"
 	---help---
diff --git a/drivers/usb/serial/aircable.c b/drivers/usb/serial/aircable.c
index db6f97a..79ea98c 100644
--- a/drivers/usb/serial/aircable.c
+++ b/drivers/usb/serial/aircable.c
@@ -272,7 +272,7 @@ static void aircable_read(struct work_struct *work)
 	 * 64 bytes, to ensure I do not get throttled.
 	 * Ask USB mailing list for better aproach.
 	 */
-	tty = port->tty;
+	tty = port->port.tty;
 
 	if (!tty) {
 		schedule_work(&priv->rx_work);
@@ -378,13 +378,14 @@ static void aircable_shutdown(struct usb_serial *serial)
 	}
 }
 
-static int aircable_write_room(struct usb_serial_port *port)
+static int aircable_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct aircable_private *priv = usb_get_serial_port_data(port);
 	return serial_buf_data_avail(priv->tx_buf);
 }
 
-static int aircable_write(struct usb_serial_port *port,
+static int aircable_write(struct tty_struct *tty, struct usb_serial_port *port,
 			  const unsigned char *source, int count)
 {
 	struct aircable_private *priv = usb_get_serial_port_data(port);
@@ -466,7 +467,7 @@ static void aircable_read_bulk_callback(struct urb *urb)
 
 	if (status) {
 		dbg("%s - urb status = %d", __func__, status);
-		if (!port->open_count) {
+		if (!port->port.count) {
 			dbg("%s - port is closed, exiting.", __func__);
 			return;
 		}
@@ -494,7 +495,7 @@ static void aircable_read_bulk_callback(struct urb *urb)
 	usb_serial_debug_data(debug, &port->dev, __func__,
 				urb->actual_length, urb->transfer_buffer);
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (tty && urb->actual_length) {
 		if (urb->actual_length <= 2) {
 			/* This is an incomplete package */
@@ -528,7 +529,7 @@ static void aircable_read_bulk_callback(struct urb *urb)
 	}
 
 	/* Schedule the next read _if_ we are still open */
-	if (port->open_count) {
+	if (port->port.count) {
 		usb_fill_bulk_urb(port->read_urb, port->serial->dev,
 				  usb_rcvbulkpipe(port->serial->dev,
 					  port->bulk_in_endpointAddress),
@@ -547,8 +548,9 @@ static void aircable_read_bulk_callback(struct urb *urb)
 }
 
 /* Based on ftdi_sio.c throttle */
-static void aircable_throttle(struct usb_serial_port *port)
+static void aircable_throttle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct aircable_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 
@@ -560,8 +562,9 @@ static void aircable_throttle(struct usb_serial_port *port)
 }
 
 /* Based on ftdi_sio.c unthrottle */
-static void aircable_unthrottle(struct usb_serial_port *port)
+static void aircable_unthrottle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct aircable_private *priv = usb_get_serial_port_data(port);
 	int actually_throttled;
 	unsigned long flags;
diff --git a/drivers/usb/serial/airprime.c b/drivers/usb/serial/airprime.c
index 0798c14..42a390c 100644
--- a/drivers/usb/serial/airprime.c
+++ b/drivers/usb/serial/airprime.c
@@ -60,7 +60,7 @@ static int airprime_send_setup(struct usb_serial_port *port)
 
 	priv = usb_get_serial_port_data(port);
 
-	if (port->tty) {
+	if (port->port.tty) {
 		int val = 0;
 		if (priv->dtr_state)
 			val |= 0x01;
@@ -94,7 +94,7 @@ static void airprime_read_bulk_callback(struct urb *urb)
 	usb_serial_debug_data(debug, &port->dev, __func__,
 						urb->actual_length, data);
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (tty && urb->actual_length) {
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
@@ -130,7 +130,8 @@ static void airprime_write_bulk_callback(struct urb *urb)
 	usb_serial_port_softint(port);
 }
 
-static int airprime_open(struct usb_serial_port *port, struct file *filp)
+static int airprime_open(struct tty_struct *tty, struct usb_serial_port *port,
+					struct file *filp)
 {
 	struct airprime_private *priv = usb_get_serial_port_data(port);
 	struct usb_serial *serial = port->serial;
@@ -195,7 +196,7 @@ static int airprime_open(struct usb_serial_port *port, struct file *filp)
 
 	goto out;
 
- errout:
+errout:
 	/* some error happened, cancel any submitted urbs and clean up
 	   anything that got allocated successfully */
 
@@ -207,11 +208,12 @@ static int airprime_open(struct usb_serial_port *port, struct file *filp)
 		kfree(buffer);
 	}
 
- out:
+out:
 	return result;
 }
 
-static void airprime_close(struct usb_serial_port *port, struct file *filp)
+static void airprime_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct airprime_private *priv = usb_get_serial_port_data(port);
 	int i;
@@ -237,7 +239,7 @@ static void airprime_close(struct usb_serial_port *port, struct file *filp)
 	usb_set_serial_port_data(port, NULL);
 }
 
-static int airprime_write(struct usb_serial_port *port,
+static int airprime_write(struct tty_struct *tty, struct usb_serial_port *port,
 			  const unsigned char *buf, int count)
 {
 	struct airprime_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index 77895c8..aec6188 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -158,12 +158,13 @@ cleanup:
 	return -ENOMEM;
 }
 
-static void ark3116_set_termios(struct usb_serial_port *port,
+static void ark3116_set_termios(struct tty_struct *tty,
+				struct usb_serial_port *port,
 				struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
 	struct ark3116_private *priv = usb_get_serial_port_data(port);
-	struct ktermios *termios = port->tty->termios;
+	struct ktermios *termios = tty->termios;
 	unsigned int cflag = termios->c_cflag;
 	unsigned long flags;
 	int baud;
@@ -177,8 +178,8 @@ static void ark3116_set_termios(struct usb_serial_port *port,
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (!priv->termios_initialized) {
-		*(port->tty->termios) = tty_std_termios;
-		port->tty->termios->c_cflag = B9600 | CS8
+		*termios = tty_std_termios;
+		termios->c_cflag = B9600 | CS8
 					      | CREAD | HUPCL | CLOCAL;
 		termios->c_ispeed = 9600;
 		termios->c_ospeed = 9600;
@@ -192,7 +193,7 @@ static void ark3116_set_termios(struct usb_serial_port *port,
 	buf = kmalloc(1, GFP_KERNEL);
 	if (!buf) {
 		dbg("error kmalloc");
-		*port->tty->termios = *old_termios;
+		*termios = *old_termios;
 		return;
 	}
 
@@ -243,7 +244,7 @@ static void ark3116_set_termios(struct usb_serial_port *port,
 	}
 
 	/* set baudrate */
-	baud = tty_get_baud_rate(port->tty);
+	baud = tty_get_baud_rate(tty);
 
 	switch (baud) {
 	case 75:
@@ -262,11 +263,11 @@ static void ark3116_set_termios(struct usb_serial_port *port,
 	case 230400:
 	case 460800:
 		/* Report the resulting rate back to the caller */
-		tty_encode_baud_rate(port->tty, baud, baud);
+		tty_encode_baud_rate(tty, baud, baud);
 		break;
 	/* set 9600 as default (if given baudrate is invalid for example) */
 	default:
-		tty_encode_baud_rate(port->tty, 9600, 9600);
+		tty_encode_baud_rate(tty, 9600, 9600);
 	case 0:
 		baud = 9600;
 	}
@@ -317,7 +318,8 @@ static void ark3116_set_termios(struct usb_serial_port *port,
 	return;
 }
 
-static int ark3116_open(struct usb_serial_port *port, struct file *filp)
+static int ark3116_open(struct tty_struct *tty, struct usb_serial_port *port,
+					struct file *filp)
 {
 	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
@@ -332,7 +334,7 @@ static int ark3116_open(struct usb_serial_port *port, struct file *filp)
 		return -ENOMEM;
 	}
 
-	result = usb_serial_generic_open(port, filp);
+	result = usb_serial_generic_open(tty, port, filp);
 	if (result)
 		goto err_out;
 
@@ -362,8 +364,8 @@ static int ark3116_open(struct usb_serial_port *port, struct file *filp)
 	ARK3116_RCV(serial, 124, 0xFE, 0xC0, 0x0000, 0x0006, 0xFF, buf);
 
 	/* initialise termios */
-	if (port->tty)
-		ark3116_set_termios(port, &tmp_termios);
+	if (tty)
+		ark3116_set_termios(tty, port, &tmp_termios);
 
 err_out:
 	kfree(buf);
@@ -371,9 +373,10 @@ err_out:
 	return result;
 }
 
-static int ark3116_ioctl(struct usb_serial_port *port, struct file *file,
+static int ark3116_ioctl(struct tty_struct *tty, struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct serial_struct serstruct;
 	void __user *user_arg = (void __user *)arg;
 
@@ -403,8 +406,9 @@ static int ark3116_ioctl(struct usb_serial_port *port, struct file *file,
 	return -ENOIOCTLCMD;
 }
 
-static int ark3116_tiocmget(struct usb_serial_port *port, struct file *file)
+static int ark3116_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	char *buf;
 	char temp;
diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
index 0a322fc..1a76269 100644
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -89,14 +89,13 @@ static int debug;
 /* function prototypes for a Belkin USB Serial Adapter F5U103 */
 static int  belkin_sa_startup		(struct usb_serial *serial);
 static void belkin_sa_shutdown		(struct usb_serial *serial);
-static int  belkin_sa_open		(struct usb_serial_port *port, struct file *filp);
-static void belkin_sa_close		(struct usb_serial_port *port, struct file *filp);
+static int  belkin_sa_open		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static void belkin_sa_close		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
 static void belkin_sa_read_int_callback (struct urb *urb);
-static void belkin_sa_set_termios	(struct usb_serial_port *port, struct ktermios * old);
-static int  belkin_sa_ioctl		(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg);
-static void belkin_sa_break_ctl		(struct usb_serial_port *port, int break_state );
-static int  belkin_sa_tiocmget		(struct usb_serial_port *port, struct file *file);
-static int  belkin_sa_tiocmset		(struct usb_serial_port *port, struct file *file, unsigned int set, unsigned int clear);
+static void belkin_sa_set_termios	(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios * old);
+static void belkin_sa_break_ctl		(struct tty_struct *tty, int break_state );
+static int  belkin_sa_tiocmget		(struct tty_struct *tty, struct file *file);
+static int  belkin_sa_tiocmset		(struct tty_struct *tty, struct file *file, unsigned int set, unsigned int clear);
 
 
 static struct usb_device_id id_table_combined [] = {
@@ -132,7 +131,6 @@ static struct usb_serial_driver belkin_device = {
 	.open =			belkin_sa_open,
 	.close =		belkin_sa_close,
 	.read_int_callback =	belkin_sa_read_int_callback,	/* How we get the status info */
-	.ioctl =		belkin_sa_ioctl,
 	.set_termios =		belkin_sa_set_termios,
 	.break_ctl =		belkin_sa_break_ctl,
 	.tiocmget =		belkin_sa_tiocmget,
@@ -190,7 +188,7 @@ static int belkin_sa_startup (struct usb_serial *serial)
 }
 
 
-static void belkin_sa_shutdown (struct usb_serial *serial)
+static void belkin_sa_shutdown(struct usb_serial *serial)
 {
 	struct belkin_sa_private *priv;
 	int i;
@@ -206,7 +204,7 @@ static void belkin_sa_shutdown (struct usb_serial *serial)
 }
 
 
-static int  belkin_sa_open (struct usb_serial_port *port, struct file *filp)
+static int  belkin_sa_open(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp)
 {
 	int retval = 0;
 
@@ -235,7 +233,8 @@ exit:
 } /* belkin_sa_open */
 
 
-static void belkin_sa_close (struct usb_serial_port *port, struct file *filp)
+static void belkin_sa_close (struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	dbg("%s port %d", __func__, port->number);
 
@@ -246,7 +245,7 @@ static void belkin_sa_close (struct usb_serial_port *port, struct file *filp)
 } /* belkin_sa_close */
 
 
-static void belkin_sa_read_int_callback (struct urb *urb)
+static void belkin_sa_read_int_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct belkin_sa_private *priv;
@@ -311,7 +310,7 @@ static void belkin_sa_read_int_callback (struct urb *urb)
 	 * to look in to this before committing any code.
 	 */
 	if (priv->last_lsr & BELKIN_SA_LSR_ERR) {
-		tty = port->tty;
+		tty = port->port.tty;
 		/* Overrun Error */
 		if (priv->last_lsr & BELKIN_SA_LSR_OE) {
 		}
@@ -334,7 +333,8 @@ exit:
 		     __func__, retval);
 }
 
-static void belkin_sa_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
+static void belkin_sa_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
 	struct belkin_sa_private *priv = usb_get_serial_port_data(port);
@@ -347,7 +347,7 @@ static void belkin_sa_set_termios (struct usb_serial_port *port, struct ktermios
 	unsigned long control_state;
 	int bad_flow_control;
 	speed_t baud;
-	struct ktermios *termios = port->tty->termios;
+	struct ktermios *termios = tty->termios;
 	
 	iflag = termios->c_iflag;
 	cflag = termios->c_cflag;
@@ -377,7 +377,7 @@ static void belkin_sa_set_termios (struct usb_serial_port *port, struct ktermios
 		}
 	}
 
-	baud = tty_get_baud_rate(port->tty);
+	baud = tty_get_baud_rate(tty);
 	if (baud) {
 		urb_value = BELKIN_SA_BAUD(baud);
 		/* Clip to maximum speed */
@@ -387,7 +387,7 @@ static void belkin_sa_set_termios (struct usb_serial_port *port, struct ktermios
 		baud = BELKIN_SA_BAUD(urb_value);
 
 		/* Report the actual baud rate back to the caller */
-		tty_encode_baud_rate(port->tty, baud, baud);
+		tty_encode_baud_rate(tty, baud, baud);
 		if (BSA_USB_CMD(BELKIN_SA_SET_BAUDRATE_REQUEST, urb_value) < 0)
 			err("Set baudrate error");
 	} else {
@@ -463,8 +463,9 @@ static void belkin_sa_set_termios (struct usb_serial_port *port, struct ktermios
 } /* belkin_sa_set_termios */
 
 
-static void belkin_sa_break_ctl( struct usb_serial_port *port, int break_state )
+static void belkin_sa_break_ctl(struct tty_struct *tty, int break_state)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 
 	if (BSA_USB_CMD(BELKIN_SA_SET_BREAK_REQUEST, break_state ? 1 : 0) < 0)
@@ -472,8 +473,9 @@ static void belkin_sa_break_ctl( struct usb_serial_port *port, int break_state )
 }
 
 
-static int belkin_sa_tiocmget (struct usb_serial_port *port, struct file *file)
+static int belkin_sa_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct belkin_sa_private *priv = usb_get_serial_port_data(port);
 	unsigned long control_state;
 	unsigned long flags;
@@ -488,9 +490,10 @@ static int belkin_sa_tiocmget (struct usb_serial_port *port, struct file *file)
 }
 
 
-static int belkin_sa_tiocmset (struct usb_serial_port *port, struct file *file,
+static int belkin_sa_tiocmset(struct tty_struct *tty, struct file *file,
 			       unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	struct belkin_sa_private *priv = usb_get_serial_port_data(port);
 	unsigned long control_state;
@@ -540,29 +543,7 @@ exit:
 }
 
 
-static int belkin_sa_ioctl (struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg)
-{
-	switch (cmd) {
-	case TIOCMIWAIT:
-		/* wait for any of the 4 modem inputs (DCD,RI,DSR,CTS)*/
-		/* TODO */
-		return( 0 );
-
-	case TIOCGICOUNT:
-		/* return count of modemline transitions */
-		/* TODO */
-		return 0;
-
-	default:
-		dbg("belkin_sa_ioctl arg not supported - 0x%04x",cmd);
-		return(-ENOIOCTLCMD);
-		break;
-	}
-	return 0;
-} /* belkin_sa_ioctl */
-
-
-static int __init belkin_sa_init (void)
+static int __init belkin_sa_init(void)
 {
 	int retval;
 	retval = usb_serial_register(&belkin_device);
@@ -583,7 +564,7 @@ failed_usb_serial_register:
 static void __exit belkin_sa_exit (void)
 {
 	usb_deregister (&belkin_driver);
-	usb_serial_deregister (&belkin_device);
+	usb_serial_deregister(&belkin_device);
 }
 
 
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 1f7c86b..f61e3ca 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -232,7 +232,8 @@ error:	kfree(priv);
 }
 
 /* open this device, set default parameters */
-static int ch341_open(struct usb_serial_port *port, struct file *filp)
+static int ch341_open(struct tty_struct *tty, struct usb_serial_port *port,
+				struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
 	struct ch341_private *priv = usb_get_serial_port_data(serial->port[0]);
@@ -256,7 +257,7 @@ static int ch341_open(struct usb_serial_port *port, struct file *filp)
 	if (r)
 		goto out;
 
-	r = usb_serial_generic_open(port, filp);
+	r = usb_serial_generic_open(tty, port, filp);
 
 out:	return r;
 }
@@ -264,11 +265,10 @@ out:	return r;
 /* Old_termios contains the original termios settings and
  * tty->termios contains the new setting to be used.
  */
-static void ch341_set_termios(struct usb_serial_port *port,
-			      struct ktermios *old_termios)
+static void ch341_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct ch341_private *priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty = port->tty;
 	unsigned baud_rate;
 
 	dbg("ch341_set_termios()");
diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 201184c..940f5de 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -145,12 +145,12 @@ static int usb_console_setup(struct console *co, char *options)
 	}
 
 	port = serial->port[0];
-	port->tty = NULL;
+	port->port.tty = NULL;
 
 	info->port = port;
 	 
-	++port->open_count;
-	if (port->open_count == 1) {
+	++port->port.count;
+	if (port->port.count == 1) {
 		if (serial->type->set_termios) {
 			/*
 			 * allocate a fake tty so the driver can initialize
@@ -171,15 +171,15 @@ static int usb_console_setup(struct console *co, char *options)
 			}
 			memset(&dummy, 0, sizeof(struct ktermios));
 			tty->termios = termios;
-			port->tty = tty;
+			port->port.tty = tty;
 		}
 
 		/* only call the device specific open if this 
 		 * is the first time the port is opened */
 		if (serial->type->open)
-			retval = serial->type->open(port, NULL);
+			retval = serial->type->open(NULL, port, NULL);
 		else
-			retval = usb_serial_generic_open(port, NULL);
+			retval = usb_serial_generic_open(NULL, port, NULL);
 
 		if (retval) {
 			err("could not open USB console port");
@@ -188,9 +188,9 @@ static int usb_console_setup(struct console *co, char *options)
 
 		if (serial->type->set_termios) {
 			termios->c_cflag = cflag;
-			serial->type->set_termios(port, &dummy);
+			serial->type->set_termios(NULL, port, &dummy);
 
-			port->tty = NULL;
+			port->port.tty = NULL;
 			kfree(termios);
 			kfree(tty);
 		}
@@ -203,11 +203,11 @@ out:
 	return retval;
 free_termios:
 	kfree(termios);
-	port->tty = NULL;
+	port->port.tty = NULL;
 free_tty:
 	kfree(tty);
 reset_open_count:
-	port->open_count = 0;
+	port->port.count = 0;
 goto out;
 }
 
@@ -227,7 +227,7 @@ static void usb_console_write(struct console *co, const char *buf, unsigned coun
 
 	dbg("%s - port %d, %d byte(s)", __func__, port->number, count);
 
-	if (!port->open_count) {
+	if (!port->port.count) {
 		dbg ("%s - port not opened", __func__);
 		return;
 	}
@@ -245,17 +245,17 @@ static void usb_console_write(struct console *co, const char *buf, unsigned coun
 		}
 		/* pass on to the driver specific version of this function if it is available */
 		if (serial->type->write)
-			retval = serial->type->write(port, buf, i);
+			retval = serial->type->write(NULL, port, buf, i);
 		else
-			retval = usb_serial_generic_write(port, buf, i);
+			retval = usb_serial_generic_write(NULL, port, buf, i);
 		dbg("%s - return value : %d", __func__, retval);
 		if (lf) {
 			/* append CR after LF */
 			unsigned char cr = 13;
 			if (serial->type->write)
-				retval = serial->type->write(port, &cr, 1);
+				retval = serial->type->write(NULL, port, &cr, 1);
 			else
-				retval = usb_serial_generic_write(port, &cr, 1);
+				retval = usb_serial_generic_write(NULL, port, &cr, 1);
 			dbg("%s - return value : %d", __func__, retval);
 		}
 		buf += i;
@@ -306,8 +306,8 @@ void usb_serial_console_exit (void)
 {
 	if (usbcons_info.port) {
 		unregister_console(&usbcons);
-		if (usbcons_info.port->open_count)
-			usbcons_info.port->open_count--;
+		if (usbcons_info.port->port.count)
+			usbcons_info.port->port.count--;
 		usbcons_info.port = NULL;
 	}
 }
diff --git a/drivers/usb/serial/cp2101.c b/drivers/usb/serial/cp2101.c
index f5b57b1..908803e 100644
--- a/drivers/usb/serial/cp2101.c
+++ b/drivers/usb/serial/cp2101.c
@@ -37,15 +37,18 @@
 /*
  * Function Prototypes
  */
-static int cp2101_open(struct usb_serial_port*, struct file*);
-static void cp2101_cleanup(struct usb_serial_port*);
-static void cp2101_close(struct usb_serial_port*, struct file*);
-static void cp2101_get_termios(struct usb_serial_port*);
-static void cp2101_set_termios(struct usb_serial_port*, struct ktermios*);
-static int cp2101_tiocmget (struct usb_serial_port *, struct file *);
-static int cp2101_tiocmset (struct usb_serial_port *, struct file *,
+static int cp2101_open(struct tty_struct *, struct usb_serial_port *,
+							struct file *);
+static void cp2101_cleanup(struct usb_serial_port *);
+static void cp2101_close(struct tty_struct *, struct usb_serial_port *,
+							struct file*);
+static void cp2101_get_termios(struct tty_struct *);
+static void cp2101_set_termios(struct tty_struct *, struct usb_serial_port *,
+							struct ktermios*);
+static int cp2101_tiocmget (struct tty_struct *, struct file *);
+static int cp2101_tiocmset (struct tty_struct *, struct file *,
 		unsigned int, unsigned int);
-static void cp2101_break_ctl(struct usb_serial_port*, int);
+static void cp2101_break_ctl(struct tty_struct *, int);
 static int cp2101_startup (struct usb_serial *);
 static void cp2101_shutdown(struct usb_serial*);
 
@@ -182,7 +185,7 @@ static struct usb_serial_driver cp2101_device = {
  * 'data' is a pointer to a pre-allocated array of integers large
  * enough to hold 'size' bytes (with 4 bytes to each integer)
  */
-static int cp2101_get_config(struct usb_serial_port* port, u8 request,
+static int cp2101_get_config(struct usb_serial_port *port, u8 request,
 		unsigned int *data, int size)
 {
 	struct usb_serial *serial = port->serial;
@@ -228,7 +231,7 @@ static int cp2101_get_config(struct usb_serial_port* port, u8 request,
  * Values less than 16 bits wide are sent directly
  * 'size' is specified in bytes.
  */
-static int cp2101_set_config(struct usb_serial_port* port, u8 request,
+static int cp2101_set_config(struct usb_serial_port *port, u8 request,
 		unsigned int *data, int size)
 {
 	struct usb_serial *serial = port->serial;
@@ -283,13 +286,14 @@ static int cp2101_set_config(struct usb_serial_port* port, u8 request,
  * Convenience function for calling cp2101_set_config on single data values
  * without requiring an integer pointer
  */
-static inline int cp2101_set_config_single(struct usb_serial_port* port,
+static inline int cp2101_set_config_single(struct usb_serial_port *port,
 		u8 request, unsigned int data)
 {
 	return cp2101_set_config(port, request, &data, 2);
 }
 
-static int cp2101_open (struct usb_serial_port *port, struct file *filp)
+static int cp2101_open (struct tty_struct *tty, struct usb_serial_port *port,
+				struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
 	int result;
@@ -318,10 +322,10 @@ static int cp2101_open (struct usb_serial_port *port, struct file *filp)
 	}
 
 	/* Configure the termios structure */
-	cp2101_get_termios(port);
+	cp2101_get_termios(tty);
 
 	/* Set the DTR and RTS pins low */
-	cp2101_tiocmset(port, NULL, TIOCM_DTR | TIOCM_RTS, 0);
+	cp2101_tiocmset(tty, NULL, TIOCM_DTR | TIOCM_RTS, 0);
 
 	return 0;
 }
@@ -341,7 +345,8 @@ static void cp2101_cleanup (struct usb_serial_port *port)
 	}
 }
 
-static void cp2101_close (struct usb_serial_port *port, struct file * filp)
+static void cp2101_close(struct tty_struct *tty, struct usb_serial_port *port,
+					struct file * filp)
 {
 	dbg("%s - port %d", __func__, port->number);
 
@@ -362,18 +367,17 @@ static void cp2101_close (struct usb_serial_port *port, struct file * filp)
  * from the device, corrects any unsupported values, and configures the
  * termios structure to reflect the state of the device
  */
-static void cp2101_get_termios (struct usb_serial_port *port)
+static void cp2101_get_termios(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	unsigned int cflag, modem_ctl[4];
 	int baud;
 	int bits;
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (!port->tty || !port->tty->termios) {
-		dbg("%s - no tty structures", __func__);
+	if (!tty)
 		return;
-	}
 
 	cp2101_get_config(port, CP2101_BAUDRATE, &baud, 2);
 	/* Convert to baudrate */
@@ -382,8 +386,8 @@ static void cp2101_get_termios (struct usb_serial_port *port)
 
 	dbg("%s - baud rate = %d", __func__, baud);
 
-	tty_encode_baud_rate(port->tty, baud, baud);
-	cflag = port->tty->termios->c_cflag;
+	tty_encode_baud_rate(tty, baud, baud);
+	cflag = tty->termios->c_cflag;
 
 	cp2101_get_config(port, CP2101_BITS, &bits, 2);
 	cflag &= ~CSIZE;
@@ -491,11 +495,11 @@ static void cp2101_get_termios (struct usb_serial_port *port)
 		cflag &= ~CRTSCTS;
 	}
 
-	port->tty->termios->c_cflag = cflag;
+	tty->termios->c_cflag = cflag;
 }
 
-static void cp2101_set_termios (struct usb_serial_port *port,
-		struct ktermios *old_termios)
+static void cp2101_set_termios (struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	unsigned int cflag, old_cflag;
 	int baud=0, bits;
@@ -503,15 +507,13 @@ static void cp2101_set_termios (struct usb_serial_port *port,
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (!port->tty || !port->tty->termios) {
-		dbg("%s - no tty structures", __func__);
+	if (!tty)
 		return;
-	}
-	port->tty->termios->c_cflag &= ~CMSPAR;
 
-	cflag = port->tty->termios->c_cflag;
+	tty->termios->c_cflag &= ~CMSPAR;
+	cflag = tty->termios->c_cflag;
 	old_cflag = old_termios->c_cflag;
-	baud = tty_get_baud_rate(port->tty);
+	baud = tty_get_baud_rate(tty);
 
 	/* If the baud rate is to be updated*/
 	if (baud != tty_termios_baud_rate(old_termios)) {
@@ -554,7 +556,7 @@ static void cp2101_set_termios (struct usb_serial_port *port,
 		}
 	}
 	/* Report back the resulting baud rate */
-	tty_encode_baud_rate(port->tty, baud, baud);
+	tty_encode_baud_rate(tty, baud, baud);
 
 	/* If the number of data bits is to be updated */
 	if ((cflag & CSIZE) != (old_cflag & CSIZE)) {
@@ -651,9 +653,10 @@ static void cp2101_set_termios (struct usb_serial_port *port,
 
 }
 
-static int cp2101_tiocmset (struct usb_serial_port *port, struct file *file,
+static int cp2101_tiocmset(struct tty_struct *tty, struct file *file,
 		unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	int control = 0;
 
 	dbg("%s - port %d", __func__, port->number);
@@ -681,8 +684,9 @@ static int cp2101_tiocmset (struct usb_serial_port *port, struct file *file,
 
 }
 
-static int cp2101_tiocmget (struct usb_serial_port *port, struct file *file)
+static int cp2101_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	int control, result;
 
 	dbg("%s - port %d", __func__, port->number);
@@ -701,8 +705,9 @@ static int cp2101_tiocmget (struct usb_serial_port *port, struct file *file)
 	return result;
 }
 
-static void cp2101_break_ctl (struct usb_serial_port *port, int break_state)
+static void cp2101_break_ctl(struct tty_struct *tty, int break_state)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	int state;
 
 	dbg("%s - port %d", __func__, port->number);
diff --git a/drivers/usb/serial/cyberjack.c b/drivers/usb/serial/cyberjack.c
index c164e2c..546178e 100644
--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -57,15 +57,18 @@ static int debug;
 #define CYBERJACK_PRODUCT_ID	0x0100
 
 /* Function prototypes */
-static int cyberjack_startup (struct usb_serial *serial);
-static void cyberjack_shutdown (struct usb_serial *serial);
-static int  cyberjack_open (struct usb_serial_port *port, struct file *filp);
-static void cyberjack_close (struct usb_serial_port *port, struct file *filp);
-static int cyberjack_write (struct usb_serial_port *port, const unsigned char *buf, int count);
-static int cyberjack_write_room( struct usb_serial_port *port );
-static void cyberjack_read_int_callback (struct urb *urb);
-static void cyberjack_read_bulk_callback (struct urb *urb);
-static void cyberjack_write_bulk_callback (struct urb *urb);
+static int cyberjack_startup(struct usb_serial *serial);
+static void cyberjack_shutdown(struct usb_serial *serial);
+static int  cyberjack_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static void cyberjack_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static int cyberjack_write(struct tty_struct *tty,
+	struct usb_serial_port *port, const unsigned char *buf, int count);
+static int cyberjack_write_room( struct tty_struct *tty);
+static void cyberjack_read_int_callback(struct urb *urb);
+static void cyberjack_read_bulk_callback(struct urb *urb);
+static void cyberjack_write_bulk_callback(struct urb *urb);
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(CYBERJACK_VENDOR_ID, CYBERJACK_PRODUCT_ID) },
@@ -111,7 +114,7 @@ struct cyberjack_private {
 };
 
 /* do some startup allocations not currently performed by usb_serial_probe() */
-static int cyberjack_startup (struct usb_serial *serial)
+static int cyberjack_startup(struct usb_serial *serial)
 {
 	struct cyberjack_private *priv;
 	int i;
@@ -145,7 +148,7 @@ static int cyberjack_startup (struct usb_serial *serial)
 	return( 0 );
 }
 
-static void cyberjack_shutdown (struct usb_serial *serial)
+static void cyberjack_shutdown(struct usb_serial *serial)
 {
 	int i;
 	
@@ -159,7 +162,8 @@ static void cyberjack_shutdown (struct usb_serial *serial)
 	}
 }
 	
-static int  cyberjack_open (struct usb_serial_port *port, struct file *filp)
+static int  cyberjack_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct cyberjack_private *priv;
 	unsigned long flags;
@@ -174,7 +178,8 @@ static int  cyberjack_open (struct usb_serial_port *port, struct file *filp)
 	 * the data through, otherwise it is scheduled, and with high
 	 * data rates (like with OHCI) data can get lost.
 	 */
-	port->tty->low_latency = 1;
+	if (tty)
+		tty->low_latency = 1;
 
 	priv = usb_get_serial_port_data(port);
 	spin_lock_irqsave(&priv->lock, flags);
@@ -186,7 +191,8 @@ static int  cyberjack_open (struct usb_serial_port *port, struct file *filp)
 	return result;
 }
 
-static void cyberjack_close (struct usb_serial_port *port, struct file *filp)
+static void cyberjack_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	dbg("%s - port %d", __func__, port->number);
 
@@ -197,7 +203,8 @@ static void cyberjack_close (struct usb_serial_port *port, struct file *filp)
 	}
 }
 
-static int cyberjack_write (struct usb_serial_port *port, const unsigned char *buf, int count)
+static int cyberjack_write(struct tty_struct *tty,
+	struct usb_serial_port *port, const unsigned char *buf, int count)
 {
 	struct usb_serial *serial = port->serial;
 	struct cyberjack_private *priv = usb_get_serial_port_data(port);
@@ -292,13 +299,13 @@ static int cyberjack_write (struct usb_serial_port *port, const unsigned char *b
 	return (count);
 } 
 
-static int cyberjack_write_room( struct usb_serial_port *port )
+static int cyberjack_write_room(struct tty_struct *tty)
 {
 	/* FIXME: .... */
 	return CYBERJACK_LOCAL_BUF_SIZE;
 }
 
-static void cyberjack_read_int_callback( struct urb *urb )
+static void cyberjack_read_int_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct cyberjack_private *priv = usb_get_serial_port_data(port);
@@ -355,7 +362,7 @@ resubmit:
 	dbg("%s - usb_submit_urb(int urb)", __func__);
 }
 
-static void cyberjack_read_bulk_callback (struct urb *urb)
+static void cyberjack_read_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct cyberjack_private *priv = usb_get_serial_port_data(port);
@@ -374,7 +381,7 @@ static void cyberjack_read_bulk_callback (struct urb *urb)
 		return;
 	}
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (!tty) {
 		dbg("%s - ignoring since device not open\n", __func__);
 		return;
@@ -407,7 +414,7 @@ static void cyberjack_read_bulk_callback (struct urb *urb)
 	}
 }
 
-static void cyberjack_write_bulk_callback (struct urb *urb)
+static void cyberjack_write_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct cyberjack_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 0230d3c..6999d33 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -167,18 +167,18 @@ static int  cypress_earthmate_startup	(struct usb_serial *serial);
 static int  cypress_hidcom_startup	(struct usb_serial *serial);
 static int  cypress_ca42v2_startup	(struct usb_serial *serial);
 static void cypress_shutdown		(struct usb_serial *serial);
-static int  cypress_open		(struct usb_serial_port *port, struct file *filp);
-static void cypress_close		(struct usb_serial_port *port, struct file *filp);
-static int  cypress_write		(struct usb_serial_port *port, const unsigned char *buf, int count);
+static int  cypress_open		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static void cypress_close		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static int  cypress_write		(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count);
 static void cypress_send		(struct usb_serial_port *port);
-static int  cypress_write_room		(struct usb_serial_port *port);
-static int  cypress_ioctl		(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg);
-static void cypress_set_termios		(struct usb_serial_port *port, struct ktermios * old);
-static int  cypress_tiocmget		(struct usb_serial_port *port, struct file *file);
-static int  cypress_tiocmset		(struct usb_serial_port *port, struct file *file, unsigned int set, unsigned int clear);
-static int  cypress_chars_in_buffer	(struct usb_serial_port *port);
-static void cypress_throttle		(struct usb_serial_port *port);
-static void cypress_unthrottle		(struct usb_serial_port *port);
+static int  cypress_write_room		(struct tty_struct *tty);
+static int  cypress_ioctl		(struct tty_struct *tty, struct file * file, unsigned int cmd, unsigned long arg);
+static void cypress_set_termios		(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios * old);
+static int  cypress_tiocmget		(struct tty_struct *tty, struct file *file);
+static int  cypress_tiocmset		(struct tty_struct *tty, struct file *file, unsigned int set, unsigned int clear);
+static int  cypress_chars_in_buffer	(struct tty_struct *tty);
+static void cypress_throttle		(struct tty_struct *tty);
+static void cypress_unthrottle		(struct tty_struct *tty);
 static void cypress_set_dead		(struct usb_serial_port *port);
 static void cypress_read_int_callback	(struct urb *urb);
 static void cypress_write_int_callback	(struct urb *urb);
@@ -322,8 +322,10 @@ static int analyze_baud_rate(struct usb_serial_port *port, speed_t new_rate)
 
 
 /* This function can either set or retrieve the current serial line settings */
-static int cypress_serial_control (struct usb_serial_port *port, speed_t baud_rate, int data_bits, int stop_bits,
-				   int parity_enable, int parity_type, int reset, int cypress_request_type)
+static int cypress_serial_control (struct tty_struct *tty,
+	struct usb_serial_port *port, speed_t baud_rate, int data_bits,
+	int stop_bits, int parity_enable, int parity_type, int reset,
+	int cypress_request_type)
 {
 	int new_baudrate = 0, retval = 0, tries = 0;
 	struct cypress_private *priv;
@@ -395,7 +397,7 @@ static int cypress_serial_control (struct usb_serial_port *port, speed_t baud_ra
 				spin_unlock_irqrestore(&priv->lock, flags);
 				/* If we asked for a speed change encode it */
 				if (baud_rate)
-					tty_encode_baud_rate(port->tty,
+					tty_encode_baud_rate(tty,
 							new_baudrate, new_baudrate);
 			}
 		break;
@@ -611,7 +613,8 @@ static void cypress_shutdown (struct usb_serial *serial)
 }
 
 
-static int cypress_open (struct usb_serial_port *port, struct file *filp)
+static int cypress_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	struct usb_serial *serial = port->serial;
@@ -636,14 +639,15 @@ static int cypress_open (struct usb_serial_port *port, struct file *filp)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* setting to zero could cause data loss */
-	port->tty->low_latency = 1;
+	if (tty)
+		tty->low_latency = 1;
 
 	/* raise both lines and set termios */
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->line_control = CONTROL_DTR | CONTROL_RTS;
 	priv->cmd_ctrl = 1;
 	spin_unlock_irqrestore(&priv->lock, flags);
-	result = cypress_write(port, NULL, 0);
+	result = cypress_write(tty, port, NULL, 0);
 
 	if (result) {
 		dev_err(&port->dev, "%s - failed setting the control lines - error %d\n", __func__, result);
@@ -651,7 +655,8 @@ static int cypress_open (struct usb_serial_port *port, struct file *filp)
 	} else
 		dbg("%s - success setting the control lines", __func__);
 
-	cypress_set_termios(port, &priv->tmp_termios);
+	if (tty)
+		cypress_set_termios(tty, port, &priv->tmp_termios);
 
 	/* setup the port and start reading from the device */
 	if(!port->interrupt_in_urb){
@@ -674,7 +679,8 @@ static int cypress_open (struct usb_serial_port *port, struct file *filp)
 } /* cypress_open */
 
 
-static void cypress_close(struct usb_serial_port *port, struct file * filp)
+static void cypress_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file * filp)
 {
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	unsigned int c_cflag;
@@ -688,7 +694,7 @@ static void cypress_close(struct usb_serial_port *port, struct file * filp)
 	spin_lock_irq(&priv->lock);
 	timeout = CYPRESS_CLOSING_WAIT;
 	init_waitqueue_entry(&wait, current);
-	add_wait_queue(&port->tty->write_wait, &wait);
+	add_wait_queue(&tty->write_wait, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (cypress_buf_data_avail(priv->buf) == 0
@@ -701,7 +707,7 @@ static void cypress_close(struct usb_serial_port *port, struct file * filp)
 		spin_lock_irq(&priv->lock);
 	}
 	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&port->tty->write_wait, &wait);
+	remove_wait_queue(&tty->write_wait, &wait);
 	/* clear out any remaining data in the buffer */
 	cypress_buf_clear(priv->buf);
 	spin_unlock_irq(&priv->lock);
@@ -713,19 +719,21 @@ static void cypress_close(struct usb_serial_port *port, struct file * filp)
 		return;
 	}
 	/* wait for characters to drain from device */
-	bps = tty_get_baud_rate(port->tty);
-	if (bps > 1200)
-		timeout = max((HZ*2560)/bps,HZ/10);
-	else
-		timeout = 2*HZ;
-	schedule_timeout_interruptible(timeout);
+	if (tty) {
+		bps = tty_get_baud_rate(tty);
+		if (bps > 1200)
+			timeout = max((HZ*2560)/bps,HZ/10);
+		else
+			timeout = 2*HZ;
+		schedule_timeout_interruptible(timeout);
+	}
 
 	dbg("%s - stopping urbs", __func__);
 	usb_kill_urb (port->interrupt_in_urb);
 	usb_kill_urb (port->interrupt_out_urb);
 
-	if (port->tty) {
-		c_cflag = port->tty->termios->c_cflag;
+	if (tty) {
+		c_cflag = tty->termios->c_cflag;
 		if (c_cflag & HUPCL) {
 			/* drop dtr and rts */
 			priv = usb_get_serial_port_data(port);
@@ -733,7 +741,7 @@ static void cypress_close(struct usb_serial_port *port, struct file * filp)
 			priv->line_control = 0;
 			priv->cmd_ctrl = 1;
 			spin_unlock_irq(&priv->lock);
-			cypress_write(port, NULL, 0);
+			cypress_write(tty, port, NULL, 0);
 		}
 	}
 
@@ -744,7 +752,8 @@ static void cypress_close(struct usb_serial_port *port, struct file * filp)
 } /* cypress_close */
 
 
-static int cypress_write(struct usb_serial_port *port, const unsigned char *buf, int count)
+static int cypress_write(struct tty_struct *tty, struct usb_serial_port *port,
+					const unsigned char *buf, int count)
 {
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
@@ -878,8 +887,9 @@ send:
 
 
 /* returns how much space is available in the soft buffer */
-static int cypress_write_room(struct usb_serial_port *port)
+static int cypress_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	int room = 0;
 	unsigned long flags;
@@ -895,8 +905,9 @@ static int cypress_write_room(struct usb_serial_port *port)
 }
 
 
-static int cypress_tiocmget (struct usb_serial_port *port, struct file *file)
+static int cypress_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	__u8 status, control;
 	unsigned int result = 0;
@@ -922,9 +933,10 @@ static int cypress_tiocmget (struct usb_serial_port *port, struct file *file)
 }
 
 
-static int cypress_tiocmset (struct usb_serial_port *port, struct file *file,
+static int cypress_tiocmset(struct tty_struct *tty, struct file *file,
 			       unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	
@@ -942,12 +954,14 @@ static int cypress_tiocmset (struct usb_serial_port *port, struct file *file,
 	priv->cmd_ctrl = 1;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return cypress_write(port, NULL, 0);
+	return cypress_write(tty, port, NULL, 0);
 }
 
 
-static int cypress_ioctl (struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg)
+static int cypress_ioctl(struct tty_struct *tty, struct file * file,
+					unsigned int cmd, unsigned long arg)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 
 	dbg("%s - port %d, cmd 0x%.4x", __func__, port->number, cmd);
@@ -983,22 +997,18 @@ static int cypress_ioctl (struct usb_serial_port *port, struct file * file, unsi
 				}
 			}
 			return 0;
-			break;
 		default:
 			break;
 	}
-
 	dbg("%s - arg not supported - it was 0x%04x - check include/asm/ioctls.h", __func__, cmd);
-
 	return -ENOIOCTLCMD;
 } /* cypress_ioctl */
 
 
-static void cypress_set_termios (struct usb_serial_port *port,
-		struct ktermios *old_termios)
+static void cypress_set_termios(struct tty_struct *tty,
+	struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct cypress_private *priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	int data_bits, stop_bits, parity_type, parity_enable;
 	unsigned cflag, iflag;
 	unsigned long flags;
@@ -1007,8 +1017,6 @@ static void cypress_set_termios (struct usb_serial_port *port,
 
 	dbg("%s - port %d", __func__, port->number);
 
-	tty = port->tty;
-
 	spin_lock_irqsave(&priv->lock, flags);
 	if (!priv->termios_initialized) {
 		if (priv->chiptype == CT_EARTHMATE) {
@@ -1096,13 +1104,13 @@ static void cypress_set_termios (struct usb_serial_port *port,
 			"%d data_bits (+5)", __func__, stop_bits,
 			parity_enable, parity_type, data_bits);
 
-	cypress_serial_control(port, tty_get_baud_rate(tty), data_bits, stop_bits,
+	cypress_serial_control(tty, port, tty_get_baud_rate(tty), data_bits, stop_bits,
 			parity_enable, parity_type, 0, CYPRESS_SET_CONFIG);
 
 	/* we perform a CYPRESS_GET_CONFIG so that the current settings are
 	 * filled into the private structure this should confirm that all is
 	 * working if it returns what we just set */
-	cypress_serial_control(port, 0, 0, 0, 0, 0, 0, CYPRESS_GET_CONFIG);
+	cypress_serial_control(tty, port, 0, 0, 0, 0, 0, 0, CYPRESS_GET_CONFIG);
 
 	/* Here we can define custom tty settings for devices; the main tty
 	 * termios flag base comes from empeg.c */
@@ -1142,14 +1150,15 @@ static void cypress_set_termios (struct usb_serial_port *port,
 	/* if necessary, set lines */
 	if (linechange) {
 		priv->cmd_ctrl = 1;
-		cypress_write(port, NULL, 0);
+		cypress_write(tty, port, NULL, 0);
 	}
 } /* cypress_set_termios */
 
 
 /* returns amount of data still left in soft buffer */
-static int cypress_chars_in_buffer(struct usb_serial_port *port)
+static int cypress_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	int chars = 0;
 	unsigned long flags;
@@ -1165,8 +1174,9 @@ static int cypress_chars_in_buffer(struct usb_serial_port *port)
 }
 
 
-static void cypress_throttle (struct usb_serial_port *port)
+static void cypress_throttle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 
@@ -1178,8 +1188,9 @@ static void cypress_throttle (struct usb_serial_port *port)
 }
 
 
-static void cypress_unthrottle (struct usb_serial_port *port)
+static void cypress_unthrottle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	int actually_throttled, result;
 	unsigned long flags;
@@ -1251,7 +1262,7 @@ static void cypress_read_int_callback(struct urb *urb)
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (!tty) {
 		dbg("%s - bad tty pointer - exiting", __func__);
 		return;
@@ -1327,7 +1338,7 @@ static void cypress_read_int_callback(struct urb *urb)
 					data[i]);
 			tty_insert_flip_char(tty, data[i], tty_flag);
 		}
-		tty_flip_buffer_push(port->tty);
+		tty_flip_buffer_push(port->port.tty);
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -1339,7 +1350,7 @@ continue_read:
 
 	/* Continue trying to always read... unless the port has closed. */
 
-	if (port->open_count > 0 && priv->comm_is_ok) {
+	if (port->port.count > 0 && priv->comm_is_ok) {
 		usb_fill_int_urb(port->interrupt_in_urb, port->serial->dev,
 				usb_rcvintpipe(port->serial->dev,
 					port->interrupt_in_endpointAddress),
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 04a56f3..847848b 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -15,7 +15,7 @@
 *  Al Borchers (borchers@steinerpoint.com)
 * 
 * (12/03/2001) gkh
-*	switched to using port->open_count instead of private version.
+*	switched to using port->port.count instead of private version.
 *	Removed port->active
 *
 * (04/08/2001) gb
@@ -443,22 +443,23 @@ static int digi_set_modem_signals(struct usb_serial_port *port,
 	unsigned int modem_signals, int interruptible);
 static int digi_transmit_idle(struct usb_serial_port *port,
 	unsigned long timeout);
-static void digi_rx_throttle (struct usb_serial_port *port);
-static void digi_rx_unthrottle (struct usb_serial_port *port);
-static void digi_set_termios(struct usb_serial_port *port,
-	struct ktermios *old_termios);
-static void digi_break_ctl(struct usb_serial_port *port, int break_state);
-static int digi_ioctl(struct usb_serial_port *port, struct file *file,
-	unsigned int cmd, unsigned long arg);
-static int digi_tiocmget(struct usb_serial_port *port, struct file *file);
-static int digi_tiocmset(struct usb_serial_port *port, struct file *file,
+static void digi_rx_throttle (struct tty_struct *tty);
+static void digi_rx_unthrottle (struct tty_struct *tty);
+static void digi_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios);
+static void digi_break_ctl(struct tty_struct *tty, int break_state);
+static int digi_tiocmget(struct tty_struct *tty, struct file *file);
+static int digi_tiocmset(struct tty_struct *tty, struct file *file,
 	unsigned int set, unsigned int clear);
-static int digi_write(struct usb_serial_port *port, const unsigned char *buf, int count);
+static int digi_write(struct tty_struct *tty, struct usb_serial_port *port,
+	const unsigned char *buf, int count);
 static void digi_write_bulk_callback(struct urb *urb);
-static int digi_write_room(struct usb_serial_port *port);
-static int digi_chars_in_buffer(struct usb_serial_port *port);
-static int digi_open(struct usb_serial_port *port, struct file *filp);
-static void digi_close(struct usb_serial_port *port, struct file *filp);
+static int digi_write_room(struct tty_struct *tty);
+static int digi_chars_in_buffer(struct tty_struct *tty);
+static int digi_open(struct tty_struct *tty, struct usb_serial_port *port,
+	struct file *filp);
+static void digi_close(struct tty_struct *tty, struct usb_serial_port *port,
+	struct file *filp);
 static int digi_startup_device(struct usb_serial *serial);
 static int digi_startup(struct usb_serial *serial);
 static void digi_shutdown(struct usb_serial *serial);
@@ -518,7 +519,6 @@ static struct usb_serial_driver digi_acceleport_2_device = {
 	.chars_in_buffer =		digi_chars_in_buffer,
 	.throttle =			digi_rx_throttle,
 	.unthrottle =			digi_rx_unthrottle,
-	.ioctl =			digi_ioctl,
 	.set_termios =			digi_set_termios,
 	.break_ctl =			digi_break_ctl,
 	.tiocmget =			digi_tiocmget,
@@ -545,7 +545,6 @@ static struct usb_serial_driver digi_acceleport_4_device = {
 	.chars_in_buffer =		digi_chars_in_buffer,
 	.throttle =			digi_rx_throttle,
 	.unthrottle =			digi_rx_unthrottle,
-	.ioctl =			digi_ioctl,
 	.set_termios =			digi_set_termios,
 	.break_ctl =			digi_break_ctl,
 	.tiocmget =			digi_tiocmget,
@@ -605,7 +604,7 @@ static void digi_wakeup_write_lock(struct work_struct *work)
 
 static void digi_wakeup_write(struct usb_serial_port *port)
 {
-	tty_wakeup(port->tty);
+	tty_wakeup(port->port.tty);
 }
 
 
@@ -857,9 +856,10 @@ static int digi_transmit_idle(struct usb_serial_port *port,
 }
 
 
-static void digi_rx_throttle(struct usb_serial_port *port)
+static void digi_rx_throttle(struct tty_struct *tty)
 {
 	unsigned long flags;
+	struct usb_serial_port *port = tty->driver_data;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 
 
@@ -873,10 +873,11 @@ static void digi_rx_throttle(struct usb_serial_port *port)
 }
 
 
-static void digi_rx_unthrottle(struct usb_serial_port *port)
+static void digi_rx_unthrottle(struct tty_struct *tty)
 {
 	int ret = 0;
 	unsigned long flags;
+	struct usb_serial_port *port = tty->driver_data;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 
 	dbg("digi_rx_unthrottle: TOP: port=%d", priv->dp_port_num);
@@ -901,12 +902,10 @@ static void digi_rx_unthrottle(struct usb_serial_port *port)
 }
 
 
-static void digi_set_termios(struct usb_serial_port *port,
-					struct ktermios *old_termios)
+static void digi_set_termios(struct tty_struct *tty, 
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
-
 	struct digi_port *priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty = port->tty;
 	unsigned int iflag = tty->termios->c_iflag;
 	unsigned int cflag = tty->termios->c_cflag;
 	unsigned int old_iflag = old_termios->c_iflag;
@@ -1089,8 +1088,9 @@ static void digi_set_termios(struct usb_serial_port *port,
 }
 
 
-static void digi_break_ctl(struct usb_serial_port *port, int break_state)
+static void digi_break_ctl(struct tty_struct *tty, int break_state)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	unsigned char buf[4];
 
 	buf[0] = DIGI_CMD_BREAK_CONTROL;
@@ -1101,8 +1101,9 @@ static void digi_break_ctl(struct usb_serial_port *port, int break_state)
 }
 
 
-static int digi_tiocmget(struct usb_serial_port *port, struct file *file)
+static int digi_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	unsigned int val;
 	unsigned long flags;
@@ -1116,9 +1117,10 @@ static int digi_tiocmget(struct usb_serial_port *port, struct file *file)
 }
 
 
-static int digi_tiocmset(struct usb_serial_port *port, struct file *file,
+static int digi_tiocmset(struct tty_struct *tty, struct file *file,
 	unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	unsigned int val;
 	unsigned long flags;
@@ -1132,27 +1134,8 @@ static int digi_tiocmset(struct usb_serial_port *port, struct file *file,
 }
 
 
-static int digi_ioctl(struct usb_serial_port *port, struct file *file,
-	unsigned int cmd, unsigned long arg)
-{
-	struct digi_port *priv = usb_get_serial_port_data(port);
-	dbg("digi_ioctl: TOP: port=%d, cmd=0x%x", priv->dp_port_num, cmd);
-
-	switch (cmd) {
-	case TIOCMIWAIT:
-		/* wait for any of the 4 modem inputs (DCD,RI,DSR,CTS)*/
-		/* TODO */
-		return 0;
-	case TIOCGICOUNT:
-		/* return count of modemline transitions */
-		/* TODO */
-		return 0;
-	}
-	return -ENOIOCTLCMD;
-
-}
-
-static int digi_write(struct usb_serial_port *port, const unsigned char *buf, int count)
+static int digi_write(struct tty_struct *tty, struct usb_serial_port *port,
+					const unsigned char *buf, int count)
 {
 
 	int ret,data_len,new_len;
@@ -1262,7 +1245,7 @@ static void digi_write_bulk_callback(struct urb *urb)
 	/* try to send any buffered data on this port, if it is open */
 	spin_lock(&priv->dp_port_lock);
 	priv->dp_write_urb_in_use = 0;
-	if (port->open_count && port->write_urb->status != -EINPROGRESS
+	if (port->port.count && port->write_urb->status != -EINPROGRESS
 	    && priv->dp_out_buf_len > 0) {
 		*((unsigned char *)(port->write_urb->transfer_buffer))
 			= (unsigned char)DIGI_CMD_SEND_DATA;
@@ -1289,11 +1272,11 @@ static void digi_write_bulk_callback(struct urb *urb)
 			__func__, ret, priv->dp_port_num);
 }
 
-static int digi_write_room(struct usb_serial_port *port)
+static int digi_write_room(struct tty_struct *tty)
 {
-
-	int room;
+	struct usb_serial_port *port = tty->driver_data;
 	struct digi_port *priv = usb_get_serial_port_data(port);
+	int room;
 	unsigned long flags = 0;
 
 	spin_lock_irqsave(&priv->dp_port_lock, flags);
@@ -1309,12 +1292,11 @@ static int digi_write_room(struct usb_serial_port *port)
 
 }
 
-static int digi_chars_in_buffer(struct usb_serial_port *port)
+static int digi_chars_in_buffer(struct tty_struct *tty)
 {
-
+	struct usb_serial_port *port = tty->driver_data;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 
-
 	if (port->write_urb->status == -EINPROGRESS
 	    || priv->dp_write_urb_in_use) {
 		dbg("digi_chars_in_buffer: port=%d, chars=%d",
@@ -1330,7 +1312,8 @@ static int digi_chars_in_buffer(struct usb_serial_port *port)
 }
 
 
-static int digi_open(struct usb_serial_port *port, struct file *filp)
+static int digi_open(struct tty_struct *tty, struct usb_serial_port *port,
+				struct file *filp)
 {
 	int ret;
 	unsigned char buf[32];
@@ -1339,7 +1322,7 @@ static int digi_open(struct usb_serial_port *port, struct file *filp)
 	unsigned long flags = 0;
 
 	dbg("digi_open: TOP: port=%d, open_count=%d",
-		priv->dp_port_num, port->open_count);
+		priv->dp_port_num, port->port.count);
 
 	/* be sure the device is started up */
 	if (digi_startup_device(port->serial) != 0)
@@ -1381,9 +1364,11 @@ static int digi_open(struct usb_serial_port *port, struct file *filp)
 		dbg("digi_open: write oob failed, ret=%d", ret);
 
 	/* set termios settings */
-	not_termios.c_cflag = ~port->tty->termios->c_cflag;
-	not_termios.c_iflag = ~port->tty->termios->c_iflag;
-	digi_set_termios(port, &not_termios);
+	if (tty) {
+		not_termios.c_cflag = ~tty->termios->c_cflag;
+		not_termios.c_iflag = ~tty->termios->c_iflag;
+		digi_set_termios(tty, port, &not_termios);
+	}
 
 	/* set DTR and RTS */
 	digi_set_modem_signals(port, TIOCM_DTR|TIOCM_RTS, 1);
@@ -1392,16 +1377,16 @@ static int digi_open(struct usb_serial_port *port, struct file *filp)
 }
 
 
-static void digi_close(struct usb_serial_port *port, struct file *filp)
+static void digi_close(struct tty_struct *tty, struct usb_serial_port *port,
+				struct file *filp)
 {
 	DEFINE_WAIT(wait);
 	int ret;
 	unsigned char buf[32];
-	struct tty_struct *tty = port->tty;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 
 	dbg("digi_close: TOP: port=%d, open_count=%d",
-		priv->dp_port_num, port->open_count);
+		priv->dp_port_num, port->port.count);
 
 	mutex_lock(&port->serial->disc_mutex);
 	/* if disconnected, just clear flags */
@@ -1664,7 +1649,7 @@ static int digi_read_inb_callback(struct urb *urb)
 {
 
 	struct usb_serial_port *port = urb->context;
-	struct tty_struct *tty = port->tty;
+	struct tty_struct *tty = port->port.tty;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	int opcode = ((unsigned char *)urb->transfer_buffer)[0];
 	int len = ((unsigned char *)urb->transfer_buffer)[1];
@@ -1676,7 +1661,7 @@ static int digi_read_inb_callback(struct urb *urb)
 
 	/* do not process callbacks on closed ports */
 	/* but do continue the read chain */
-	if (port->open_count == 0)
+	if (port->port.count == 0)
 		return 0;
 
 	/* short/multiple packet check */
@@ -1786,17 +1771,17 @@ static int digi_read_oob_callback(struct urb *urb)
 			if (val & DIGI_READ_INPUT_SIGNALS_CTS) {
 				priv->dp_modem_signals |= TIOCM_CTS;
 				/* port must be open to use tty struct */
-				if (port->open_count
-					&& port->tty->termios->c_cflag & CRTSCTS) {
-					port->tty->hw_stopped = 0;
+				if (port->port.count
+					&& port->port.tty->termios->c_cflag & CRTSCTS) {
+					port->port.tty->hw_stopped = 0;
 					digi_wakeup_write(port);
 				}
 			} else {
 				priv->dp_modem_signals &= ~TIOCM_CTS;
 				/* port must be open to use tty struct */
-				if (port->open_count
-					&& port->tty->termios->c_cflag & CRTSCTS) {
-					port->tty->hw_stopped = 1;
+				if (port->port.count
+					&& port->port.tty->termios->c_cflag & CRTSCTS) {
+					port->port.tty->hw_stopped = 1;
 				}
 			}
 			if (val & DIGI_READ_INPUT_SIGNALS_DSR)
diff --git a/drivers/usb/serial/empeg.c b/drivers/usb/serial/empeg.c
index c5ec309..47ebdf5 100644
--- a/drivers/usb/serial/empeg.c
+++ b/drivers/usb/serial/empeg.c
@@ -31,7 +31,7 @@
  *	Moved MOD_DEC_USE_COUNT to end of empeg_close().
  * 
  * (12/03/2000) gb
- *	Added port->tty->ldisc.set_termios(port->tty, NULL) to empeg_open()
+ *	Added port->port.tty->ldisc.set_termios(port->port.tty, NULL) to empeg_open()
  *	This notifies the tty driver that the termios have changed.
  * 
  * (11/13/2000) gb
@@ -77,22 +77,18 @@ static int debug;
 #define EMPEG_PRODUCT_ID		0x0001
 
 /* function prototypes for an empeg-car player */
-static int  empeg_open			(struct usb_serial_port *port, struct file *filp);
-static void empeg_close			(struct usb_serial_port *port, struct file *filp);
-static int  empeg_write			(struct usb_serial_port *port,
+static int  empeg_open			(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static void empeg_close			(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static int  empeg_write			(struct tty_struct *tty, struct usb_serial_port *port,
 					const unsigned char *buf,
 					int count);
-static int  empeg_write_room		(struct usb_serial_port *port);
-static int  empeg_chars_in_buffer	(struct usb_serial_port *port);
-static void empeg_throttle		(struct usb_serial_port *port);
-static void empeg_unthrottle		(struct usb_serial_port *port);
+static int  empeg_write_room		(struct tty_struct *tty);
+static int  empeg_chars_in_buffer	(struct tty_struct *tty);
+static void empeg_throttle		(struct tty_struct *tty);
+static void empeg_unthrottle		(struct tty_struct *tty);
 static int  empeg_startup		(struct usb_serial *serial);
 static void empeg_shutdown		(struct usb_serial *serial);
-static int  empeg_ioctl			(struct usb_serial_port *port,
-					struct file * file,
-					unsigned int cmd,
-					unsigned long arg);
-static void empeg_set_termios		(struct usb_serial_port *port, struct ktermios *old_termios);
+static void empeg_set_termios		(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios *old_termios);
 static void empeg_write_bulk_callback	(struct urb *urb);
 static void empeg_read_bulk_callback	(struct urb *urb);
 
@@ -125,7 +121,6 @@ static struct usb_serial_driver empeg_device = {
 	.unthrottle =		empeg_unthrottle,
 	.attach =		empeg_startup,
 	.shutdown =		empeg_shutdown,
-	.ioctl =		empeg_ioctl,
 	.set_termios =		empeg_set_termios,
 	.write =		empeg_write,
 	.write_room =		empeg_write_room,
@@ -145,7 +140,8 @@ static int		bytes_out;
 /******************************************************************************
  * Empeg specific driver functions
  ******************************************************************************/
-static int empeg_open (struct usb_serial_port *port, struct file *filp)
+static int empeg_open(struct tty_struct *tty, struct usb_serial_port *port,
+				struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
 	int result = 0;
@@ -153,7 +149,7 @@ static int empeg_open (struct usb_serial_port *port, struct file *filp)
 	dbg("%s - port %d", __func__, port->number);
 
 	/* Force default termio settings */
-	empeg_set_termios (port, NULL) ;
+	empeg_set_termios (tty, port, NULL) ;
 
 	bytes_in = 0;
 	bytes_out = 0;
@@ -178,7 +174,8 @@ static int empeg_open (struct usb_serial_port *port, struct file *filp)
 }
 
 
-static void empeg_close (struct usb_serial_port *port, struct file * filp)
+static void empeg_close(struct tty_struct *tty, struct usb_serial_port *port,
+				struct file * filp)
 {
 	dbg("%s - port %d", __func__, port->number);
 
@@ -189,7 +186,7 @@ static void empeg_close (struct usb_serial_port *port, struct file * filp)
 }
 
 
-static int empeg_write (struct usb_serial_port *port, const unsigned char *buf, int count)
+static int empeg_write(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count)
 {
 	struct usb_serial *serial = port->serial;
 	struct urb *urb;
@@ -203,7 +200,6 @@ static int empeg_write (struct usb_serial_port *port, const unsigned char *buf,
 	dbg("%s - port %d", __func__, port->number);
 
 	while (count > 0) {
-
 		/* try to find a free urb in our list of them */
 		urb = NULL;
 
@@ -262,15 +258,14 @@ static int empeg_write (struct usb_serial_port *port, const unsigned char *buf,
 		bytes_out += transfer_size;
 
 	}
-
 exit:
 	return bytes_sent;
-
 } 
 
 
-static int empeg_write_room (struct usb_serial_port *port)
+static int empeg_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	unsigned long flags;
 	int i;
 	int room = 0;
@@ -278,25 +273,22 @@ static int empeg_write_room (struct usb_serial_port *port)
 	dbg("%s - port %d", __func__, port->number);
 
 	spin_lock_irqsave (&write_urb_pool_lock, flags);
-
 	/* tally up the number of bytes available */
 	for (i = 0; i < NUM_URBS; ++i) {
 		if (write_urb_pool[i]->status != -EINPROGRESS) {
 			room += URB_TRANSFER_BUFFER_SIZE;
 		}
 	} 
-
 	spin_unlock_irqrestore (&write_urb_pool_lock, flags);
-
 	dbg("%s - returns %d", __func__, room);
-
-	return (room);
+	return room;
 
 }
 
 
-static int empeg_chars_in_buffer (struct usb_serial_port *port)
+static int empeg_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	unsigned long flags;
 	int i;
 	int chars = 0;
@@ -356,7 +348,7 @@ static void empeg_read_bulk_callback (struct urb *urb)
 
 	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
 
-	tty = port->tty;
+	tty = port->port.tty;
 
 	if (urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length);
@@ -386,27 +378,24 @@ static void empeg_read_bulk_callback (struct urb *urb)
 }
 
 
-static void empeg_throttle (struct usb_serial_port *port)
+static void empeg_throttle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s - port %d", __func__, port->number);
 	usb_kill_urb(port->read_urb);
 }
 
 
-static void empeg_unthrottle (struct usb_serial_port *port)
+static void empeg_unthrottle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	int result;
-
 	dbg("%s - port %d", __func__, port->number);
 
 	port->read_urb->dev = port->serial->dev;
-
 	result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
-
 	if (result)
 		dev_err(&port->dev, "%s - failed submitting read urb, error %d\n", __func__, result);
-
-	return;
 }
 
 
@@ -436,17 +425,10 @@ static void empeg_shutdown (struct usb_serial *serial)
 }
 
 
-static int empeg_ioctl (struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg)
-{
-	dbg("%s - port %d, cmd 0x%.4x", __func__, port->number, cmd);
-
-	return -ENOIOCTLCMD;
-}
-
-
-static void empeg_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
+static void empeg_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
-	struct ktermios *termios = port->tty->termios;
+	struct ktermios *termios = tty->termios;
 	dbg("%s - port %d", __func__, port->number);
 
 	/*
@@ -491,8 +473,8 @@ static void empeg_set_termios (struct usb_serial_port *port, struct ktermios *ol
 	 * this is bad as it opens up the possibility of dropping bytes
 	 * on the floor.  We don't want to drop bytes on the floor. :)
 	 */
-	port->tty->low_latency = 1;
-	tty_encode_baud_rate(port->tty, 115200, 115200);
+	tty->low_latency = 1;
+	tty_encode_baud_rate(tty, 115200, 115200);
 }
 
 
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 5234e7a..cde50b0 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -681,21 +681,21 @@ static int  ftdi_sio_probe	(struct usb_serial *serial, const struct usb_device_i
 static void ftdi_shutdown		(struct usb_serial *serial);
 static int  ftdi_sio_port_probe	(struct usb_serial_port *port);
 static int  ftdi_sio_port_remove	(struct usb_serial_port *port);
-static int  ftdi_open			(struct usb_serial_port *port, struct file *filp);
-static void ftdi_close			(struct usb_serial_port *port, struct file *filp);
-static int  ftdi_write			(struct usb_serial_port *port, const unsigned char *buf, int count);
-static int  ftdi_write_room		(struct usb_serial_port *port);
-static int  ftdi_chars_in_buffer	(struct usb_serial_port *port);
+static int  ftdi_open			(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static void ftdi_close			(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static int  ftdi_write			(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count);
+static int  ftdi_write_room		(struct tty_struct *tty);
+static int  ftdi_chars_in_buffer	(struct tty_struct *tty);
 static void ftdi_write_bulk_callback	(struct urb *urb);
 static void ftdi_read_bulk_callback	(struct urb *urb);
 static void ftdi_process_read		(struct work_struct *work);
-static void ftdi_set_termios		(struct usb_serial_port *port, struct ktermios * old);
-static int  ftdi_tiocmget               (struct usb_serial_port *port, struct file *file);
-static int  ftdi_tiocmset		(struct usb_serial_port *port, struct file * file, unsigned int set, unsigned int clear);
-static int  ftdi_ioctl			(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg);
-static void ftdi_break_ctl		(struct usb_serial_port *port, int break_state );
-static void ftdi_throttle		(struct usb_serial_port *port);
-static void ftdi_unthrottle		(struct usb_serial_port *port);
+static void ftdi_set_termios		(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios * old);
+static int  ftdi_tiocmget               (struct tty_struct *tty, struct file *file);
+static int  ftdi_tiocmset		(struct tty_struct *tty, struct file * file, unsigned int set, unsigned int clear);
+static int  ftdi_ioctl			(struct tty_struct *tty, struct file * file, unsigned int cmd, unsigned long arg);
+static void ftdi_break_ctl		(struct tty_struct *tty, int break_state );
+static void ftdi_throttle		(struct tty_struct *tty);
+static void ftdi_unthrottle		(struct tty_struct *tty);
 
 static unsigned short int ftdi_232am_baud_base_to_divisor (int baud, int base);
 static unsigned short int ftdi_232am_baud_to_divisor (int baud);
@@ -842,42 +842,7 @@ static int update_mctrl(struct usb_serial_port *port, unsigned int set, unsigned
 }
 
 
-static __u32 get_ftdi_divisor(struct usb_serial_port * port);
-
-
-static int change_speed(struct usb_serial_port *port)
-{
-	struct ftdi_private *priv = usb_get_serial_port_data(port);
-	char *buf;
-        __u16 urb_value;
-	__u16 urb_index;
-	__u32 urb_index_value;
-	int rv;
-
-	buf = kmalloc(1, GFP_NOIO);
-	if (!buf)
-		return -ENOMEM;
-
-	urb_index_value = get_ftdi_divisor(port);
-	urb_value = (__u16)urb_index_value;
-	urb_index = (__u16)(urb_index_value >> 16);
-	if (priv->interface) {	/* FT2232C */
-		urb_index = (__u16)((urb_index << 8) | priv->interface);
-	}
-
-	rv = usb_control_msg(port->serial->dev,
-			    usb_sndctrlpipe(port->serial->dev, 0),
-			    FTDI_SIO_SET_BAUDRATE_REQUEST,
-			    FTDI_SIO_SET_BAUDRATE_REQUEST_TYPE,
-			    urb_value, urb_index,
-			    buf, 0, WDR_SHORT_TIMEOUT);
-
-	kfree(buf);
-	return rv;
-}
-
-
-static __u32 get_ftdi_divisor(struct usb_serial_port * port)
+static __u32 get_ftdi_divisor(struct tty_struct *tty, struct usb_serial_port *port)
 { /* get_ftdi_divisor */
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	__u32 div_value = 0;
@@ -909,7 +874,7 @@ static __u32 get_ftdi_divisor(struct usb_serial_port * port)
 
 	/* 1. Get the baud rate from the tty settings, this observes alt_speed hack */
 
-	baud = tty_get_baud_rate(port->tty);
+	baud = tty_get_baud_rate(tty);
 	dbg("%s - tty_get_baud_rate reports speed %d", __func__, baud);
 
 	/* 2. Observe async-compatible custom_divisor hack, update baudrate if needed */
@@ -975,10 +940,42 @@ static __u32 get_ftdi_divisor(struct usb_serial_port * port)
 			ftdi_chip_name[priv->chip_type]);
 	}
 
-	tty_encode_baud_rate(port->tty, baud, baud);
+	tty_encode_baud_rate(tty, baud, baud);
 	return(div_value);
 }
 
+static int change_speed(struct tty_struct *tty, struct usb_serial_port *port)
+{
+	struct ftdi_private *priv = usb_get_serial_port_data(port);
+	char *buf;
+        __u16 urb_value;
+	__u16 urb_index;
+	__u32 urb_index_value;
+	int rv;
+
+	buf = kmalloc(1, GFP_NOIO);
+	if (!buf)
+		return -ENOMEM;
+
+	urb_index_value = get_ftdi_divisor(tty, port);
+	urb_value = (__u16)urb_index_value;
+	urb_index = (__u16)(urb_index_value >> 16);
+	if (priv->interface) {	/* FT2232C */
+		urb_index = (__u16)((urb_index << 8) | priv->interface);
+	}
+
+	rv = usb_control_msg(port->serial->dev,
+			    usb_sndctrlpipe(port->serial->dev, 0),
+			    FTDI_SIO_SET_BAUDRATE_REQUEST,
+			    FTDI_SIO_SET_BAUDRATE_REQUEST_TYPE,
+			    urb_value, urb_index,
+			    buf, 0, WDR_SHORT_TIMEOUT);
+
+	kfree(buf);
+	return rv;
+}
+
+
 
 static int get_serial_info(struct usb_serial_port * port, struct serial_struct __user * retinfo)
 {
@@ -997,7 +994,8 @@ static int get_serial_info(struct usb_serial_port * port, struct serial_struct _
 } /* get_serial_info */
 
 
-static int set_serial_info(struct usb_serial_port * port, struct serial_struct __user * newinfo)
+static int set_serial_info(struct tty_struct *tty,
+	struct usb_serial_port * port, struct serial_struct __user * newinfo)
 { /* set_serial_info */
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	struct serial_struct new_serial;
@@ -1029,30 +1027,29 @@ static int set_serial_info(struct usb_serial_port * port, struct serial_struct _
 	               (new_serial.flags & ASYNC_FLAGS));
 	priv->custom_divisor = new_serial.custom_divisor;
 
-	port->tty->low_latency = (priv->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	tty->low_latency = (priv->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 check_and_exit:
 	if ((old_priv.flags & ASYNC_SPD_MASK) !=
 	     (priv->flags & ASYNC_SPD_MASK)) {
 		if ((priv->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
-			port->tty->alt_speed = 57600;
+			tty->alt_speed = 57600;
 		else if ((priv->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
-			port->tty->alt_speed = 115200;
+			tty->alt_speed = 115200;
 		else if ((priv->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
-			port->tty->alt_speed = 230400;
+			tty->alt_speed = 230400;
 		else if ((priv->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
-			port->tty->alt_speed = 460800;
+			tty->alt_speed = 460800;
 		else
-			port->tty->alt_speed = 0;
+			tty->alt_speed = 0;
 	}
 	if (((old_priv.flags & ASYNC_SPD_MASK) !=
 	     (priv->flags & ASYNC_SPD_MASK)) ||
 	    (((priv->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST) &&
 	     (old_priv.custom_divisor != priv->custom_divisor))) {
-		change_speed(port);
+		change_speed(tty, port);
 	}
-
-	return (0);
+	return 0;
 
 } /* set_serial_info */
 
@@ -1414,7 +1411,8 @@ static int ftdi_sio_port_remove(struct usb_serial_port *port)
 	return 0;
 }
 
-static int  ftdi_open (struct usb_serial_port *port, struct file *filp)
+static int ftdi_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 { /* ftdi_open */
 	struct usb_device *dev = port->serial->dev;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
@@ -1432,8 +1430,8 @@ static int  ftdi_open (struct usb_serial_port *port, struct file *filp)
 	priv->rx_bytes = 0;
 	spin_unlock_irqrestore(&priv->rx_lock, flags);
 
-	if (port->tty)
-		port->tty->low_latency = (priv->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	if (tty)
+		tty->low_latency = (priv->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	/* No error checking for this (will get errors later anyway) */
 	/* See ftdi_sio.h for description of what is reset */
@@ -1443,12 +1441,12 @@ static int  ftdi_open (struct usb_serial_port *port, struct file *filp)
 			priv->interface, buf, 0, WDR_TIMEOUT);
 
 	/* Termios defaults are set by usb_serial_init. We don't change
-	   port->tty->termios - this would loose speed settings, etc.
+	   tty->termios - this would loose speed settings, etc.
 	   This is same behaviour as serial.c/rs_open() - Kuba */
 
 	/* ftdi_set_termios  will send usb control messages */
-	if (port->tty)
-		ftdi_set_termios(port, port->tty->termios);
+	if (tty)
+		ftdi_set_termios(tty, port, tty->termios);
 
 	/* FIXME: Flow control might be enabled, so it should be checked -
 	   we have no control of defaults! */
@@ -1484,9 +1482,10 @@ static int  ftdi_open (struct usb_serial_port *port, struct file *filp)
  *
  */
 
-static void ftdi_close (struct usb_serial_port *port, struct file *filp)
+static void ftdi_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 { /* ftdi_close */
-	unsigned int c_cflag = port->tty->termios->c_cflag;
+	unsigned int c_cflag = tty->termios->c_cflag;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	char buf[1];
 
@@ -1526,7 +1525,7 @@ static void ftdi_close (struct usb_serial_port *port, struct file *filp)
  *
  * The new devices do not require this byte
  */
-static int ftdi_write (struct usb_serial_port *port,
+static int ftdi_write(struct tty_struct *tty, struct usb_serial_port *port,
 			   const unsigned char *buf, int count)
 { /* ftdi_write */
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
@@ -1685,8 +1684,9 @@ static void ftdi_write_bulk_callback (struct urb *urb)
 } /* ftdi_write_bulk_callback */
 
 
-static int ftdi_write_room( struct usb_serial_port *port )
+static int ftdi_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	int room;
 	unsigned long flags;
@@ -1706,11 +1706,11 @@ static int ftdi_write_room( struct usb_serial_port *port )
 	}
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 	return room;
-} /* ftdi_write_room */
-
+}
 
-static int ftdi_chars_in_buffer (struct usb_serial_port *port)
-{ /* ftdi_chars_in_buffer */
+static int ftdi_chars_in_buffer(struct tty_struct *tty)
+{
+	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	int buffered;
 	unsigned long flags;
@@ -1725,12 +1725,10 @@ static int ftdi_chars_in_buffer (struct usb_serial_port *port)
 		buffered = 0;
 	}
 	return buffered;
-} /* ftdi_chars_in_buffer */
-
-
+}
 
-static void ftdi_read_bulk_callback (struct urb *urb)
-{ /* ftdi_read_bulk_callback */
+static void ftdi_read_bulk_callback(struct urb *urb)
+{
 	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty;
 	struct ftdi_private *priv;
@@ -1746,10 +1744,10 @@ static void ftdi_read_bulk_callback (struct urb *urb)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (port->open_count <= 0)
+	if (port->port.count <= 0)
 		return;
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (!tty) {
 		dbg("%s - bad tty pointer - exiting",__func__);
 		return;
@@ -1802,10 +1800,10 @@ static void ftdi_process_read (struct work_struct *work)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (port->open_count <= 0)
+	if (port->port.count <= 0)
 		return;
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (!tty) {
 		dbg("%s - bad tty pointer - exiting",__func__);
 		return;
@@ -1953,7 +1951,7 @@ static void ftdi_process_read (struct work_struct *work)
 		}
 		spin_unlock_irqrestore(&priv->rx_lock, flags);
 		/* if the port is closed stop trying to read */
-		if (port->open_count > 0){
+		if (port->port.count > 0){
 			/* delay processing of remainder */
 			schedule_delayed_work(&priv->rx_work, 1);
 		} else {
@@ -1966,7 +1964,7 @@ static void ftdi_process_read (struct work_struct *work)
 	priv->rx_processed = 0;
 
 	/* if the port is closed stop trying to read */
-	if (port->open_count > 0){
+	if (port->port.count > 0){
 		/* Continue trying to always read  */
 		usb_fill_bulk_urb(port->read_urb, port->serial->dev,
 			      usb_rcvbulkpipe(port->serial->dev, port->bulk_in_endpointAddress),
@@ -1982,8 +1980,9 @@ static void ftdi_process_read (struct work_struct *work)
 } /* ftdi_process_read */
 
 
-static void ftdi_break_ctl( struct usb_serial_port *port, int break_state )
+static void ftdi_break_ctl(struct tty_struct *tty, int break_state)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	__u16 urb_value = 0;
 	char buf[1];
@@ -2017,11 +2016,12 @@ static void ftdi_break_ctl( struct usb_serial_port *port, int break_state )
  * WARNING: set_termios calls this with old_termios in kernel space
  */
 
-static void ftdi_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
+static void ftdi_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 { /* ftdi_termios */
 	struct usb_device *dev = port->serial->dev;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
-	struct ktermios *termios = port->tty->termios;
+	struct ktermios *termios = tty->termios;
 	unsigned int cflag = termios->c_cflag;
 	__u16 urb_value; /* will hold the new flags */
 	char buf[1]; /* Perhaps I should dynamically alloc this? */
@@ -2036,7 +2036,7 @@ static void ftdi_set_termios (struct usb_serial_port *port, struct ktermios *old
 	/* Force baud rate if this device requires it, unless it is set to B0. */
 	if (priv->force_baud && ((termios->c_cflag & CBAUD) != B0)) {
 		dbg("%s: forcing baud rate for this device", __func__);
-		tty_encode_baud_rate(port->tty, priv->force_baud,
+		tty_encode_baud_rate(tty, priv->force_baud,
 					priv->force_baud);
 	}
 
@@ -2103,7 +2103,7 @@ static void ftdi_set_termios (struct usb_serial_port *port, struct ktermios *old
 		clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	} else {
 		/* set the baudrate determined before */
-		if (change_speed(port)) {
+		if (change_speed(tty, port)) {
 			err("%s urb failed to set baudrate", __func__);
 		}
 		/* Ensure RTS and DTR are raised when baudrate changed from 0 */
@@ -2167,11 +2167,11 @@ static void ftdi_set_termios (struct usb_serial_port *port, struct ktermios *old
 
 	}
 	return;
-} /* ftdi_termios */
-
+}
 
-static int ftdi_tiocmget (struct usb_serial_port *port, struct file *file)
+static int ftdi_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	unsigned char buf[2];
 	int ret;
@@ -2220,15 +2220,18 @@ static int ftdi_tiocmget (struct usb_serial_port *port, struct file *file)
 		priv->last_dtr_rts;
 }
 
-static int ftdi_tiocmset(struct usb_serial_port *port, struct file * file, unsigned int set, unsigned int clear)
+static int ftdi_tiocmset(struct tty_struct *tty, struct file * file,
+			unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s TIOCMSET", __func__);
 	return update_mctrl(port, set, clear);
 }
 
 
-static int ftdi_ioctl (struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg)
+static int ftdi_ioctl(struct tty_struct *tty, struct file * file, unsigned int cmd, unsigned long arg)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 
 	dbg("%s cmd 0x%04x", __func__, cmd);
@@ -2240,7 +2243,7 @@ static int ftdi_ioctl (struct usb_serial_port *port, struct file * file, unsigne
 		return get_serial_info(port, (struct serial_struct __user *) arg);
 
 	case TIOCSSERIAL: /* sets serial port data */
-		return set_serial_info(port, (struct serial_struct __user *) arg);
+		return set_serial_info(tty, port, (struct serial_struct __user *) arg);
 
 	/*
 	 * Wait for any of the 4 modem inputs (DCD,RI,DSR,CTS) to change
@@ -2279,25 +2282,20 @@ static int ftdi_ioctl (struct usb_serial_port *port, struct file * file, unsigne
 				 */
 			}
 		}
-		return(0);
-		break;
+		return 0;
 	default:
 		break;
-
 	}
-
-
 	/* This is not necessarily an error - turns out the higher layers will do
 	 *  some ioctls itself (see comment above)
 	 */
 	dbg("%s arg not supported - it was 0x%04x - check /usr/include/asm/ioctls.h", __func__, cmd);
+	return -ENOIOCTLCMD;
+}
 
-	return(-ENOIOCTLCMD);
-} /* ftdi_ioctl */
-
-
-static void ftdi_throttle (struct usb_serial_port *port)
+static void ftdi_throttle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 
@@ -2309,8 +2307,9 @@ static void ftdi_throttle (struct usb_serial_port *port)
 }
 
 
-static void ftdi_unthrottle (struct usb_serial_port *port)
+static void ftdi_unthrottle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	int actually_throttled;
 	unsigned long flags;
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index 8ce5a56..06cfa43 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -275,7 +275,7 @@ static inline int isAbortTrfCmnd(const unsigned char *buf)
 static void send_to_tty(struct usb_serial_port *port,
 			char *data, unsigned int actual_length)
 {
-	struct tty_struct *tty = port->tty;
+	struct tty_struct *tty = port->port.tty;
 
 	if (tty && actual_length) {
 
@@ -970,7 +970,8 @@ static int garmin_init_session(struct usb_serial_port *port)
 
 
 
-static int garmin_open (struct usb_serial_port *port, struct file *filp)
+static int garmin_open (struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	unsigned long flags;
 	int status = 0;
@@ -983,8 +984,8 @@ static int garmin_open (struct usb_serial_port *port, struct file *filp)
 	 * through, otherwise it is scheduled, and with high data rates (like
 	 * with OHCI) data can get lost.
 	 */
-	if (port->tty)
-		port->tty->low_latency = 1;
+	if (tty)
+		tty->low_latency = 1;
 
 	spin_lock_irqsave(&garmin_data_p->lock, flags);
 	garmin_data_p->mode  = initial_mode;
@@ -998,17 +999,16 @@ static int garmin_open (struct usb_serial_port *port, struct file *filp)
 	usb_kill_urb (port->write_urb);
 	usb_kill_urb (port->read_urb);
 
-	if (garmin_data_p->state == STATE_RESET) {
+	if (garmin_data_p->state == STATE_RESET)
 		status = garmin_init_session(port);
-	}
 
 	garmin_data_p->state = STATE_ACTIVE;
-
 	return status;
 }
 
 
-static void garmin_close (struct usb_serial_port *port, struct file * filp)
+static void garmin_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file * filp)
 {
 	struct usb_serial *serial = port->serial;
 	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
@@ -1042,7 +1042,6 @@ static void garmin_close (struct usb_serial_port *port, struct file * filp)
 	mutex_unlock(&port->serial->disc_mutex);
 }
 
-
 static void garmin_write_bulk_callback (struct urb *urb)
 {
 	unsigned long flags;
@@ -1145,10 +1144,8 @@ static int garmin_write_bulk (struct usb_serial_port *port,
 	return count;
 }
 
-
-
-static int garmin_write (struct usb_serial_port *port,
-			 const unsigned char *buf, int count)
+static int garmin_write (struct tty_struct *tty, struct usb_serial_port *port,
+					 const unsigned char *buf, int count)
 {
 	int pktid, pktsiz, len;
 	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
@@ -1158,7 +1155,6 @@ static int garmin_write (struct usb_serial_port *port,
 
 	/* check for our private packets */
 	if (count >= GARMIN_PKTHDR_LENGTH) {
-
 		len = PRIVPKTSIZ;
 		if (count < len)
 			len = count;
@@ -1226,8 +1222,9 @@ static int garmin_write (struct usb_serial_port *port,
 }
 
 
-static int garmin_write_room (struct usb_serial_port *port)
+static int garmin_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	/*
 	 * Report back the bytes currently available in the output buffer.
 	 */
@@ -1236,20 +1233,6 @@ static int garmin_write_room (struct usb_serial_port *port)
 }
 
 
-static int garmin_chars_in_buffer (struct usb_serial_port *port)
-{
-	/*
-	 * Report back the number of bytes currently in our input buffer.
-	 * Will this lock up the driver - the buffer contains an incomplete
-	 * package which will not be written to the device until it
-	 * has been completed ?
-	 */
-	//struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
-	//return garmin_data_p->insize;
-	return 0;
-}
-
-
 static void garmin_read_process(struct garmin_data * garmin_data_p,
 				 unsigned char *data, unsigned data_length)
 {
@@ -1468,10 +1451,11 @@ static int garmin_flush_queue(struct garmin_data * garmin_data_p)
 }
 
 
-static void garmin_throttle (struct usb_serial_port *port)
+static void garmin_throttle(struct tty_struct *tty)
 {
-	unsigned long flags;
+	struct usb_serial_port *port = tty->driver_data;
 	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	unsigned long flags;
 
 	dbg("%s - port %d", __func__, port->number);
 	/* set flag, data received will be put into a queue
@@ -1482,10 +1466,11 @@ static void garmin_throttle (struct usb_serial_port *port)
 }
 
 
-static void garmin_unthrottle (struct usb_serial_port *port)
+static void garmin_unthrottle (struct tty_struct *tty)
 {
-	unsigned long flags;
+	struct usb_serial_port *port = tty->driver_data;
 	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
+	unsigned long flags;
 	int status;
 
 	dbg("%s - port %d", __func__, port->number);
@@ -1507,8 +1492,6 @@ static void garmin_unthrottle (struct usb_serial_port *port)
 	}
 }
 
-
-
 /*
  * The timer is currently only used to send queued packets to
  * the tty in cases where the protocol provides no own handshaking
@@ -1526,7 +1509,7 @@ static void timeout_handler(unsigned long data)
 
 
 
-static int garmin_attach (struct usb_serial *serial)
+static int garmin_attach(struct usb_serial *serial)
 {
 	int status = 0;
 	struct usb_serial_port *port = serial->port[0];
@@ -1556,7 +1539,7 @@ static int garmin_attach (struct usb_serial *serial)
 }
 
 
-static void garmin_shutdown (struct usb_serial *serial)
+static void garmin_shutdown(struct usb_serial *serial)
 {
 	struct usb_serial_port *port = serial->port[0];
 	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
@@ -1588,7 +1571,6 @@ static struct usb_serial_driver garmin_device = {
 	.shutdown            = garmin_shutdown,
 	.write               = garmin_write,
 	.write_room          = garmin_write_room,
-	.chars_in_buffer     = garmin_chars_in_buffer,
 	.write_bulk_callback = garmin_write_bulk_callback,
 	.read_bulk_callback  = garmin_read_bulk_callback,
 	.read_int_callback   = garmin_read_int_callback,
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 537f12a..5128018 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -112,7 +112,8 @@ void usb_serial_generic_deregister (void)
 #endif
 }
 
-int usb_serial_generic_open (struct usb_serial_port *port, struct file *filp)
+int usb_serial_generic_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
 	int result = 0;
@@ -123,8 +124,8 @@ int usb_serial_generic_open (struct usb_serial_port *port, struct file *filp)
 	/* force low_latency on so that our tty_push actually forces the data through, 
 	   otherwise it is scheduled, and with high data rates (like with OHCI) data
 	   can get lost. */
-	if (port->tty)
-		port->tty->low_latency = 1;
+	if (tty)
+		tty->low_latency = 1;
 
 	/* clear the throttle flags */
 	spin_lock_irqsave(&port->lock, flags);
@@ -152,7 +153,7 @@ int usb_serial_generic_open (struct usb_serial_port *port, struct file *filp)
 }
 EXPORT_SYMBOL_GPL(usb_serial_generic_open);
 
-static void generic_cleanup (struct usb_serial_port *port)
+static void generic_cleanup(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
 
@@ -182,7 +183,7 @@ int usb_serial_generic_resume(struct usb_serial *serial)
 #endif
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
-		if (port->open_count && port->read_urb) {
+		if (port->port.count && port->read_urb) {
 			r = usb_submit_urb(port->read_urb, GFP_NOIO);
 			if (r < 0)
 				c++;
@@ -192,13 +193,15 @@ int usb_serial_generic_resume(struct usb_serial *serial)
 	return c ? -EIO : 0;
 }
 
-void usb_serial_generic_close (struct usb_serial_port *port, struct file * filp)
+void usb_serial_generic_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file * filp)
 {
 	dbg("%s - port %d", __func__, port->number);
 	generic_cleanup (port);
 }
 
-int usb_serial_generic_write(struct usb_serial_port *port, const unsigned char *buf, int count)
+int usb_serial_generic_write(struct tty_struct *tty,
+	struct usb_serial_port *port, const unsigned char *buf, int count)
 {
 	struct usb_serial *serial = port->serial;
 	int result;
@@ -255,8 +258,9 @@ int usb_serial_generic_write(struct usb_serial_port *port, const unsigned char *
 	return 0;
 }
 
-int usb_serial_generic_write_room (struct usb_serial_port *port)
+int usb_serial_generic_write_room (struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	int room = 0;
 
@@ -272,8 +276,9 @@ int usb_serial_generic_write_room (struct usb_serial_port *port)
 	return room;
 }
 
-int usb_serial_generic_chars_in_buffer (struct usb_serial_port *port)
+int usb_serial_generic_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	int chars = 0;
 
@@ -286,7 +291,7 @@ int usb_serial_generic_chars_in_buffer (struct usb_serial_port *port)
 	}
 
 	dbg("%s - returns %d", __func__, chars);
-	return (chars);
+	return chars;
 }
 
 
@@ -311,10 +316,10 @@ static void resubmit_read_urb(struct usb_serial_port *port, gfp_t mem_flags)
 }
 
 /* Push data to tty layer and resubmit the bulk read URB */
-static void flush_and_resubmit_read_urb (struct usb_serial_port *port)
+static void flush_and_resubmit_read_urb(struct usb_serial_port *port)
 {
 	struct urb *urb = port->read_urb;
-	struct tty_struct *tty = port->tty;
+	struct tty_struct *tty = port->port.tty;
 	int room;
 
 	/* Push data to tty */
@@ -329,7 +334,7 @@ static void flush_and_resubmit_read_urb (struct usb_serial_port *port)
 	resubmit_read_urb(port, GFP_ATOMIC);
 }
 
-void usb_serial_generic_read_bulk_callback (struct urb *urb)
+void usb_serial_generic_read_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
@@ -357,7 +362,7 @@ void usb_serial_generic_read_bulk_callback (struct urb *urb)
 }
 EXPORT_SYMBOL_GPL(usb_serial_generic_read_bulk_callback);
 
-void usb_serial_generic_write_bulk_callback (struct urb *urb)
+void usb_serial_generic_write_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
@@ -374,8 +379,9 @@ void usb_serial_generic_write_bulk_callback (struct urb *urb)
 }
 EXPORT_SYMBOL_GPL(usb_serial_generic_write_bulk_callback);
 
-void usb_serial_generic_throttle (struct usb_serial_port *port)
+void usb_serial_generic_throttle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	unsigned long flags;
 
 	dbg("%s - port %d", __func__, port->number);
@@ -387,8 +393,9 @@ void usb_serial_generic_throttle (struct usb_serial_port *port)
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
-void usb_serial_generic_unthrottle (struct usb_serial_port *port)
+void usb_serial_generic_unthrottle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	int was_throttled;
 	unsigned long flags;
 
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 06b52f4..1d8d130 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -224,18 +224,18 @@ static void edge_bulk_out_data_callback	(struct urb *urb);
 static void edge_bulk_out_cmd_callback	(struct urb *urb);
 
 /* function prototypes for the usbserial callbacks */
-static int  edge_open			(struct usb_serial_port *port, struct file *filp);
-static void edge_close			(struct usb_serial_port *port, struct file *filp);
-static int  edge_write			(struct usb_serial_port *port, const unsigned char *buf, int count);
-static int  edge_write_room		(struct usb_serial_port *port);
-static int  edge_chars_in_buffer	(struct usb_serial_port *port);
-static void edge_throttle		(struct usb_serial_port *port);
-static void edge_unthrottle		(struct usb_serial_port *port);
-static void edge_set_termios		(struct usb_serial_port *port, struct ktermios *old_termios);
-static int  edge_ioctl			(struct usb_serial_port *port, struct file *file, unsigned int cmd, unsigned long arg);
-static void edge_break			(struct usb_serial_port *port, int break_state);
-static int  edge_tiocmget		(struct usb_serial_port *port, struct file *file);
-static int  edge_tiocmset		(struct usb_serial_port *port, struct file *file, unsigned int set, unsigned int clear);
+static int  edge_open			(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static void edge_close			(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static int  edge_write			(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count);
+static int  edge_write_room		(struct tty_struct *tty);
+static int  edge_chars_in_buffer	(struct tty_struct *tty);
+static void edge_throttle		(struct tty_struct *tty);
+static void edge_unthrottle		(struct tty_struct *tty);
+static void edge_set_termios		(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios *old_termios);
+static int  edge_ioctl			(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg);
+static void edge_break			(struct tty_struct *tty, int break_state);
+static int  edge_tiocmget		(struct tty_struct *tty, struct file *file);
+static int  edge_tiocmset		(struct tty_struct *tty, struct file *file, unsigned int set, unsigned int clear);
 static int  edge_startup		(struct usb_serial *serial);
 static void edge_shutdown		(struct usb_serial *serial);
 
@@ -251,7 +251,8 @@ static void handle_new_lsr		(struct edgeport_port *edge_port, __u8 lsrData, __u8
 static int  send_iosp_ext_cmd		(struct edgeport_port *edge_port, __u8 command, __u8 param);
 static int  calc_baud_rate_divisor	(int baud_rate, int *divisor);
 static int  send_cmd_write_baud_rate	(struct edgeport_port *edge_port, int baudRate);
-static void change_port_settings	(struct edgeport_port *edge_port, struct ktermios *old_termios);
+static void change_port_settings	(struct tty_struct *tty, struct edgeport_port *edge_port,
+					 struct ktermios *old_termios);
 static int  send_cmd_write_uart_register	(struct edgeport_port *edge_port, __u8 regNum, __u8 regValue);
 static int  write_cmd_usb		(struct edgeport_port *edge_port, unsigned char *buffer, int writeLength);
 static void send_more_port_data		(struct edgeport_serial *edge_serial, struct edgeport_port *edge_port);
@@ -662,8 +663,8 @@ static void edge_interrupt_callback (struct urb *urb)
 					dbg("%s - txcredits for port%d = %d", __func__, portNumber, edge_port->txCredits);
 
 					/* tell the tty driver that something has changed */
-					if (edge_port->port->tty)
-						tty_wakeup(edge_port->port->tty);
+					if (edge_port->port->port.tty)
+						tty_wakeup(edge_port->port->port.tty);
 
 					// Since we have more credit, check if more data can be sent
 					send_more_port_data(edge_serial, edge_port);
@@ -760,7 +761,7 @@ static void edge_bulk_out_data_callback (struct urb *urb)
 		    __func__, status);
 	}
 
-	tty = edge_port->port->tty;
+	tty = edge_port->port->port.tty;
 
 	if (tty && edge_port->open) {
 		/* let the tty driver wakeup if it has a special write_wakeup function */
@@ -804,7 +805,7 @@ static void edge_bulk_out_cmd_callback (struct urb *urb)
 	}
 
 	/* Get pointer to tty */
-	tty = edge_port->port->tty;
+	tty = edge_port->port->port.tty;
 
 	/* tell the tty driver that something has changed */
 	if (tty && edge_port->open)
@@ -826,7 +827,8 @@ static void edge_bulk_out_cmd_callback (struct urb *urb)
  *	If successful, we return 0
  *	Otherwise we return a negative error number.
  *****************************************************************************/
-static int edge_open (struct usb_serial_port *port, struct file * filp)
+static int edge_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file * filp)
 {
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	struct usb_serial *serial;
@@ -838,16 +840,15 @@ static int edge_open (struct usb_serial_port *port, struct file * filp)
 	if (edge_port == NULL)
 		return -ENODEV;
 
-	if (port->tty)
-		port->tty->low_latency = low_latency;
+	if (tty)
+		tty->low_latency = low_latency;
 
 	/* see if we've set up our endpoint info yet (can't set it up in edge_startup
 	   as the structures were not set up at that time.) */
 	serial = port->serial;
 	edge_serial = usb_get_serial_data(serial);
-	if (edge_serial == NULL) {
+	if (edge_serial == NULL)
 		return -ENODEV;
-	}
 	if (edge_serial->interrupt_in_buffer == NULL) {
 		struct usb_serial_port *port0 = serial->port[0];
 		
@@ -931,7 +932,7 @@ static int edge_open (struct usb_serial_port *port, struct file * filp)
 
 	if (!edge_port->txfifo.fifo) {
 		dbg("%s - no memory", __func__);
-		edge_close (port, filp);
+		edge_close (tty, port, filp);
 		return -ENOMEM;
 	}
 
@@ -941,7 +942,7 @@ static int edge_open (struct usb_serial_port *port, struct file * filp)
 
 	if (!edge_port->write_urb) {
 		dbg("%s - no memory", __func__);
-		edge_close (port, filp);
+		edge_close (tty, port, filp);
 		return -ENOMEM;
 	}
 
@@ -1061,7 +1062,8 @@ static void block_until_tx_empty (struct edgeport_port *edge_port)
  * edge_close
  *	this function is called by the tty driver when a port is closed
  *****************************************************************************/
-static void edge_close (struct usb_serial_port *port, struct file * filp)
+static void edge_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file * filp)
 {
 	struct edgeport_serial *edge_serial;
 	struct edgeport_port *edge_port;
@@ -1129,7 +1131,8 @@ static void edge_close (struct usb_serial_port *port, struct file * filp)
  *	If successful, we return the number of bytes written, otherwise we return
  *	a negative error number.
  *****************************************************************************/
-static int edge_write (struct usb_serial_port *port, const unsigned char *data, int count)
+static int edge_write(struct tty_struct *tty, struct usb_serial_port *port,
+					const unsigned char *data, int count)
 {
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	struct TxFifo *fifo;
@@ -1331,8 +1334,9 @@ exit_send:
  *	(the txCredits), 
  *	Otherwise we return a negative error number.
  *****************************************************************************/
-static int edge_write_room (struct usb_serial_port *port)
+static int edge_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	int room;
 	unsigned long flags;
@@ -1370,8 +1374,9 @@ static int edge_write_room (struct usb_serial_port *port)
  *	system, 
  *	Otherwise we return a negative error number.
  *****************************************************************************/
-static int edge_chars_in_buffer (struct usb_serial_port *port)
+static int edge_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	int num_chars;
 	unsigned long flags;
@@ -1404,10 +1409,10 @@ static int edge_chars_in_buffer (struct usb_serial_port *port)
  *	this function is called by the tty driver when it wants to stop the data
  *	being read from the port.
  *****************************************************************************/
-static void edge_throttle (struct usb_serial_port *port)
+static void edge_throttle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	int status;
 
 	dbg("%s - port %d", __func__, port->number);
@@ -1420,16 +1425,10 @@ static void edge_throttle (struct usb_serial_port *port)
 		return;
 	}
 
-	tty = port->tty;
-	if (!tty) {
-		dbg ("%s - no tty available", __func__);
-		return;
-	}
-
 	/* if we are implementing XON/XOFF, send the stop character */
 	if (I_IXOFF(tty)) {
 		unsigned char stop_char = STOP_CHAR(tty);
-		status = edge_write (port, &stop_char, 1);
+		status = edge_write (tty, port, &stop_char, 1);
 		if (status <= 0) {
 			return;
 		}
@@ -1453,10 +1452,10 @@ static void edge_throttle (struct usb_serial_port *port)
  *	this function is called by the tty driver when it wants to resume the data
  *	being read from the port (called after SerialThrottle is called)
  *****************************************************************************/
-static void edge_unthrottle (struct usb_serial_port *port)
+static void edge_unthrottle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	int status;
 
 	dbg("%s - port %d", __func__, port->number);
@@ -1469,31 +1468,18 @@ static void edge_unthrottle (struct usb_serial_port *port)
 		return;
 	}
 
-	tty = port->tty;
-	if (!tty) {
-		dbg ("%s - no tty available", __func__);
-		return;
-	}
-
 	/* if we are implementing XON/XOFF, send the start character */
 	if (I_IXOFF(tty)) {
 		unsigned char start_char = START_CHAR(tty);
-		status = edge_write (port, &start_char, 1);
-		if (status <= 0) {
+		status = edge_write(tty, port, &start_char, 1);
+		if (status <= 0)
 			return;
-		}
 	}
-
 	/* if we are implementing RTS/CTS, toggle that line */
 	if (tty->termios->c_cflag & CRTSCTS) {
 		edge_port->shadowMCR |= MCR_RTS;
-		status = send_cmd_write_uart_register(edge_port, MCR, edge_port->shadowMCR);
-		if (status != 0) {
-			return;
-		}
+		send_cmd_write_uart_register(edge_port, MCR, edge_port->shadowMCR);
 	}
-
-	return;
 }
 
 
@@ -1501,11 +1487,10 @@ static void edge_unthrottle (struct usb_serial_port *port)
  * SerialSetTermios
  *	this function is called by the tty driver when it wants to change the termios structure
  *****************************************************************************/
-static void edge_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
+static void edge_set_termios(struct tty_struct *tty,
+	struct usb_serial_port *port, struct ktermios *old_termios)
 {
-	/* FIXME: This function appears unused ?? */
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
-	struct tty_struct *tty = port->tty;
 	unsigned int cflag;
 
 	cflag = tty->termios->c_cflag;
@@ -1525,9 +1510,7 @@ static void edge_set_termios (struct usb_serial_port *port, struct ktermios *old
 	}
 
 	/* change the port settings to the new ones specified */
-	change_port_settings (edge_port, old_termios);
-
-	return;
+	change_port_settings(tty, edge_port, old_termios);
 }
 
 
@@ -1559,25 +1542,9 @@ static int get_lsr_info(struct edgeport_port *edge_port, unsigned int __user *va
 	return 0;
 }
 
-static int get_number_bytes_avail(struct edgeport_port *edge_port, unsigned int __user *value)
-{
-	unsigned int result = 0;
-	struct tty_struct *tty = edge_port->port->tty;
-
-	if (!tty)
-		return -ENOIOCTLCMD;
-
-	result = tty->read_cnt;
-
-	dbg("%s(%d) = %d", __func__,  edge_port->port->number, result);
-	if (copy_to_user(value, &result, sizeof(int)))
-		return -EFAULT;
-	//return 0;
-	return -ENOIOCTLCMD;
-}
-
-static int edge_tiocmset (struct usb_serial_port *port, struct file *file, unsigned int set, unsigned int clear)
+static int edge_tiocmset(struct tty_struct *tty, struct file *file, unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	unsigned int mcr;
 
@@ -1605,8 +1572,9 @@ static int edge_tiocmset (struct usb_serial_port *port, struct file *file, unsig
 	return 0;
 }
 
-static int edge_tiocmget(struct usb_serial_port *port, struct file *file)
+static int edge_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	unsigned int result = 0;
 	unsigned int msr;
@@ -1647,9 +1615,6 @@ static int get_serial_info(struct edgeport_port *edge_port, struct serial_struct
 	tmp.baud_base		= 9600;
 	tmp.close_delay		= 5*HZ;
 	tmp.closing_wait	= 30*HZ;
-//	tmp.custom_divisor	= state->custom_divisor;
-//	tmp.hub6		= state->hub6;
-//	tmp.io_type		= state->io_type;
 
 	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
 		return -EFAULT;
@@ -1662,8 +1627,10 @@ static int get_serial_info(struct edgeport_port *edge_port, struct serial_struct
  * SerialIoctl
  *	this function handles any ioctl calls to the driver
  *****************************************************************************/
-static int edge_ioctl (struct usb_serial_port *port, struct file *file, unsigned int cmd, unsigned long arg)
+static int edge_ioctl(struct tty_struct *tty, struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	DEFINE_WAIT(wait);
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	struct async_icount cnow;
@@ -1673,25 +1640,14 @@ static int edge_ioctl (struct usb_serial_port *port, struct file *file, unsigned
 	dbg("%s - port %d, cmd = 0x%x", __func__, port->number, cmd);
 
 	switch (cmd) {
-		// return number of bytes available
-		case TIOCINQ:
-			dbg("%s (%d) TIOCINQ", __func__,  port->number);
-			return get_number_bytes_avail(edge_port, (unsigned int __user *) arg);
-			break;
-
 		case TIOCSERGETLSR:
 			dbg("%s (%d) TIOCSERGETLSR", __func__,  port->number);
 			return get_lsr_info(edge_port, (unsigned int __user *) arg);
-			return 0;
 
 		case TIOCGSERIAL:
 			dbg("%s (%d) TIOCGSERIAL", __func__,  port->number);
 			return get_serial_info(edge_port, (struct serial_struct __user *) arg);
 
-		case TIOCSSERIAL:
-			dbg("%s (%d) TIOCSSERIAL", __func__,  port->number);
-			break;
-
 		case TIOCMIWAIT:
 			dbg("%s (%d) TIOCMIWAIT", __func__,  port->number);
 			cprev = edge_port->icount;
@@ -1746,8 +1702,9 @@ static int edge_ioctl (struct usb_serial_port *port, struct file *file, unsigned
  * SerialBreak
  *	this function sends a break to the port
  *****************************************************************************/
-static void edge_break (struct usb_serial_port *port, int break_state)
+static void edge_break (struct tty_struct *tty, int break_state)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	struct edgeport_serial *edge_serial = usb_get_serial_data(port->serial);
 	int status;
@@ -1889,7 +1846,7 @@ static void process_rcvd_data (struct edgeport_serial *edge_serial, unsigned cha
 					port = edge_serial->serial->port[edge_serial->rxPort];
 					edge_port = usb_get_serial_port_data(port);
 					if (edge_port->open) {
-						tty = edge_port->port->tty;
+						tty = edge_port->port->port.tty;
 						if (tty) {
 							dbg("%s - Sending %d bytes to TTY for port %d", __func__, rxLen, edge_serial->rxPort);
 							edge_tty_recv(&edge_serial->serial->dev->dev, tty, buffer, rxLen);
@@ -1964,8 +1921,9 @@ static void process_rcvd_status (struct edgeport_serial *edge_serial, __u8 byte2
 		handle_new_msr (edge_port, byte2);
 
 		/* send the current line settings to the port so we are in sync with any further termios calls */
-		if (edge_port->port->tty)
-			change_port_settings (edge_port, edge_port->port->tty->termios);
+		/* FIXME: locking on tty */
+		if (edge_port->port->port.tty)
+			change_port_settings(edge_port->port->port.tty, edge_port, edge_port->port->port.tty->termios);
 
 		/* we have completed the open */
 		edge_port->openPending = false;
@@ -2101,8 +2059,8 @@ static void handle_new_lsr(struct edgeport_port *edge_port, __u8 lsrData, __u8 l
 	}
 
 	/* Place LSR data byte into Rx buffer */
-	if (lsrData && edge_port->port->tty)
-		edge_tty_recv(&edge_port->port->dev, edge_port->port->tty, &data, 1);
+	if (lsrData && edge_port->port->port.tty)
+		edge_tty_recv(&edge_port->port->dev, edge_port->port->port.tty, &data, 1);
 
 	/* update input line counters */
 	icount = &edge_port->icount;
@@ -2496,13 +2454,11 @@ static int send_cmd_write_uart_register (struct edgeport_port *edge_port, __u8 r
  *	This routine is called to set the UART on the device to match the specified
  *	new settings.
  *****************************************************************************/
-#ifndef CMSPAR
-#define CMSPAR 0
-#endif
-static void change_port_settings (struct edgeport_port *edge_port, struct ktermios *old_termios)
+
+static void change_port_settings(struct tty_struct *tty,
+	struct edgeport_port *edge_port, struct ktermios *old_termios)
 {
 	struct edgeport_serial *edge_serial = usb_get_serial_data(edge_port->port->serial);
-	struct tty_struct *tty;
 	int baud;
 	unsigned cflag;
 	__u8 mask = 0xff;
@@ -2521,13 +2477,6 @@ static void change_port_settings (struct edgeport_port *edge_port, struct ktermi
 		return;
 	}
 
-	tty = edge_port->port->tty;
-	if ((!tty) ||
-	    (!tty->termios)) {
-		dbg("%s - no tty structures", __func__);
-		return;
-	}
-
 	cflag = tty->termios->c_cflag;
 
 	switch (cflag & CSIZE) {
diff --git a/drivers/usb/serial/io_fw_down3.h b/drivers/usb/serial/io_fw_down3.h
index 4496b06..e3b97eb 100644
--- a/drivers/usb/serial/io_fw_down3.h
+++ b/drivers/usb/serial/io_fw_down3.h
@@ -5,22 +5,22 @@
 //**************************************************************
 
 
-static int IMAGE_SIZE = 12938;
+static const int fw_size = 12938;
 
-struct EDGE_FIRMWARE_VERSION_INFO
+struct fw_revision
 {
 	unsigned char   MajorVersion;
 	unsigned char   MinorVersion;
 	unsigned short  BuildNumber;
 };
 
-static struct EDGE_FIRMWARE_VERSION_INFO IMAGE_VERSION_NAME =
+static const struct fw_revision fw_version =
 {
 	4, 80, 0		// Major, Minor, Build
 
 };
 
-static unsigned char IMAGE_ARRAY_NAME[] = 
+static const unsigned char fw_image[] = 
 {
 //  struct ImageHdr
 //  {
@@ -841,7 +841,4 @@ static unsigned char IMAGE_ARRAY_NAME[] =
 0x12, 0x1e, 0x14, 0x22, 0xc2, 0x08, 0x22,
 };
 
-#undef IMAGE_VERSION_NAME
-
-#undef IMAGE_ARRAY_NAME
 
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 05e4fa7..808e285 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -18,8 +18,8 @@
  *
  * Version history:
  *
- *	July 11, 2002 	Removed 4 port device structure since all TI UMP 
- *			chips have only 2 ports 
+ *	July 11, 2002 	Removed 4 port device structure since all TI UMP
+ *			chips have only 2 ports
  *			David Iacovelli (davidi@ionetworks.com)
  *
  */
@@ -37,7 +37,7 @@
 #include <linux/mutex.h>
 #include <linux/serial.h>
 #include <linux/ioctl.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
@@ -54,27 +54,25 @@
 
 
 /* firmware image code */
-#define IMAGE_VERSION_NAME	PagableOperationalCodeImageVersion
-#define IMAGE_ARRAY_NAME	PagableOperationalCodeImage
-#define IMAGE_SIZE		PagableOperationalCodeSize
-#include "io_fw_down3.h"	/* Define array OperationalCodeImage[] */
+#include "io_fw_down3.h"	/* Define array fw_image[] */
 
 #define EPROM_PAGE_SIZE		64
 
 
 struct edgeport_uart_buf_desc {
-	__u32 count;		// Number of bytes currently in buffer
+	__u32 count;		/* Number of bytes currently in buffer */
 };
 
 /* different hardware types */
 #define HARDWARE_TYPE_930	0
 #define HARDWARE_TYPE_TIUMP	1
 
-// IOCTL_PRIVATE_TI_GET_MODE Definitions
-#define	TI_MODE_CONFIGURING	0   // Device has not entered start device 
-#define	TI_MODE_BOOT		1   // Staying in boot mode
-#define TI_MODE_DOWNLOAD	2   // Made it to download mode
-#define TI_MODE_TRANSITIONING	3   // Currently in boot mode but transitioning to download mode
+/* IOCTL_PRIVATE_TI_GET_MODE Definitions */
+#define	TI_MODE_CONFIGURING	0   /* Device has not entered start device */
+#define	TI_MODE_BOOT		1   /* Staying in boot mode		   */
+#define TI_MODE_DOWNLOAD	2   /* Made it to download mode		   */
+#define TI_MODE_TRANSITIONING	3   /* Currently in boot mode but
+				       transitioning to download mode	   */
 
 /* read urb state */
 #define EDGE_READ_URB_RUNNING	0
@@ -88,10 +86,9 @@ struct edgeport_uart_buf_desc {
 
 
 /* Product information read from the Edgeport */
-struct product_info
-{
-	int	TiMode;			// Current TI Mode
-	__u8	hardware_type;		// Type of hardware
+struct product_info {
+	int	TiMode;			/* Current TI Mode  */
+	__u8	hardware_type;		/* Type of hardware */
 } __attribute__((packed));
 
 /* circular buffer */
@@ -122,7 +119,7 @@ struct edgeport_port {
 						   happen */
 	struct edgeport_serial	*edge_serial;
 	struct usb_serial_port	*port;
-	__u8 bUartMode;		/* Port type, 0: RS232, etc. */ 
+	__u8 bUartMode;		/* Port type, 0: RS232, etc. */
 	spinlock_t ep_lock;
 	int ep_read_urb_state;
 	int ep_write_urb_in_use;
@@ -131,8 +128,9 @@ struct edgeport_port {
 
 struct edgeport_serial {
 	struct product_info product_info;
-	u8 TI_I2C_Type;			// Type of I2C in UMP
-	u8 TiReadI2C;			// Set to TRUE if we have read the I2c in Boot Mode
+	u8 TI_I2C_Type;			/* Type of I2C in UMP */
+	u8 TiReadI2C;			/* Set to TRUE if we have read the
+					   I2c in Boot Mode */
 	struct mutex es_lock;
 	int num_ports_open;
 	struct usb_serial *serial;
@@ -220,7 +218,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ }
 };
 
-MODULE_DEVICE_TABLE (usb, id_table_combined);
+MODULE_DEVICE_TABLE(usb, id_table_combined);
 
 static struct usb_driver io_driver = {
 	.name =		"io_ti",
@@ -231,24 +229,25 @@ static struct usb_driver io_driver = {
 };
 
 
-static struct EDGE_FIRMWARE_VERSION_INFO OperationalCodeImageVersion;
+static struct fw_revision op_fw_version;
 
 static int debug;
 
-static int TIStayInBootMode = 0;
 static int low_latency = EDGE_LOW_LATENCY;
 static int closing_wait = EDGE_CLOSING_WAIT;
-static int ignore_cpu_rev = 0;
-static int default_uart_mode = 0;	/* RS232 */
+static int ignore_cpu_rev;
+static int default_uart_mode;		/* RS232 */
 
 
-static void edge_tty_recv(struct device *dev, struct tty_struct *tty, unsigned char *data, int length);
+static void edge_tty_recv(struct device *dev, struct tty_struct *tty,
+					unsigned char *data, int length);
 
 static void stop_read(struct edgeport_port *edge_port);
 static int restart_read(struct edgeport_port *edge_port);
 
-static void edge_set_termios (struct usb_serial_port *port, struct ktermios *old_termios);
-static void edge_send(struct usb_serial_port *port);
+static void edge_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios);
+static void edge_send(struct tty_struct *tty);
 
 /* sysfs attributes */
 static int edge_create_sysfs_attrs(struct usb_serial_port *port);
@@ -266,87 +265,57 @@ static unsigned int edge_buf_get(struct edge_buf *eb, char *buf,
 	unsigned int count);
 
 
-static int TIReadVendorRequestSync (struct usb_device *dev,
-				__u8		request,
-				__u16		value,
-				__u16		index,
-				u8 		*data,
-				int		size)
+static int ti_vread_sync(struct usb_device *dev, __u8 request,
+				__u16 value, __u16 index, u8 *data, int size)
 {
 	int status;
 
-	status = usb_control_msg (dev,
-				usb_rcvctrlpipe(dev, 0),
-				request,
-				(USB_TYPE_VENDOR | 
-				 USB_RECIP_DEVICE | 
-				 USB_DIR_IN),
-				value,
-				index,
-				data,
-				size,
-				1000);
+	status = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), request,
+			(USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN),
+			value, index, data, size, 1000);
 	if (status < 0)
 		return status;
 	if (status != size) {
-		dbg ("%s - wanted to write %d, but only wrote %d",
-		     __func__, size, status);
+		dbg("%s - wanted to write %d, but only wrote %d",
+					     __func__, size, status);
 		return -ECOMM;
 	}
 	return 0;
 }
 
-static int TISendVendorRequestSync (struct usb_device *dev,
-				__u8		request,
-				__u16		value,
-				__u16		index,
-				u8 		*data,
-				int		size)
+static int ti_vsend_sync(struct usb_device *dev, __u8 request,
+				__u16 value, __u16 index, u8 *data, int size)
 {
 	int status;
 
-	status = usb_control_msg (dev,
-				usb_sndctrlpipe(dev, 0),
-				request,
-				(USB_TYPE_VENDOR | 
-				 USB_RECIP_DEVICE | 
-				 USB_DIR_OUT),
-				value,
-				index,
-				data,
-				size,
-				1000);
+	status = usb_control_msg(dev, usb_sndctrlpipe(dev, 0), request,
+			(USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT),
+			value, index, data, size, 1000);
 	if (status < 0)
 		return status;
 	if (status != size) {
-		dbg ("%s - wanted to write %d, but only wrote %d",
+		dbg("%s - wanted to write %d, but only wrote %d",
 		     __func__, size, status);
 		return -ECOMM;
 	}
 	return 0;
 }
 
-static int TIWriteCommandSync (struct usb_device *dev, __u8 command,
+static int send_cmd(struct usb_device *dev, __u8 command,
 				__u8 moduleid, __u16 value, u8 *data,
 				int size)
 {
-	return TISendVendorRequestSync (dev,
-					  command,	  		// Request
-					  value,			// wValue 
-					  moduleid,			// wIndex
-					  data,				// TransferBuffer
-					  size);			// TransferBufferLength
-
+	return ti_vsend_sync(dev, command, value, moduleid, data, size);
 }
 
 /* clear tx/rx buffers and fifo in TI UMP */
-static int TIPurgeDataSync (struct usb_serial_port *port, __u16 mask)
+static int purge_port(struct usb_serial_port *port, __u16 mask)
 {
 	int port_number = port->number - port->serial->minor;
 
-	dbg ("%s - port %d, mask %x", __func__, port_number, mask);
+	dbg("%s - port %d, mask %x", __func__, port_number, mask);
 
-	return TIWriteCommandSync (port->serial->dev,
+	return send_cmd(port->serial->dev,
 					UMPC_PURGE_PORT,
 					(__u8)(UMPM_UART1_PORT + port_number),
 					mask,
@@ -355,92 +324,87 @@ static int TIPurgeDataSync (struct usb_serial_port *port, __u16 mask)
 }
 
 /**
- * TIReadDownloadMemory - Read edgeport memory from TI chip
+ * read_download_mem - Read edgeport memory from TI chip
  * @dev: usb device pointer
  * @start_address: Device CPU address at which to read
  * @length: Length of above data
  * @address_type: Can read both XDATA and I2C
  * @buffer: pointer to input data buffer
  */
-static int TIReadDownloadMemory(struct usb_device *dev, int start_address,
+static int read_download_mem(struct usb_device *dev, int start_address,
 				int length, __u8 address_type, __u8 *buffer)
 {
 	int status = 0;
 	__u8 read_length;
 	__be16 be_start_address;
-	
-	dbg ("%s - @ %x for %d", __func__, start_address, length);
+
+	dbg("%s - @ %x for %d", __func__, start_address, length);
 
 	/* Read in blocks of 64 bytes
 	 * (TI firmware can't handle more than 64 byte reads)
 	 */
 	while (length) {
 		if (length > 64)
-			read_length= 64;
+			read_length = 64;
 		else
 			read_length = (__u8)length;
 
 		if (read_length > 1) {
-			dbg ("%s - @ %x for %d", __func__,
+			dbg("%s - @ %x for %d", __func__,
 			     start_address, read_length);
 		}
-		be_start_address = cpu_to_be16 (start_address);
-		status = TIReadVendorRequestSync (dev,
-						  UMPC_MEMORY_READ,	// Request
-						  (__u16)address_type,	// wValue (Address type)
-						  (__force __u16)be_start_address,	// wIndex (Address to read)
-						  buffer,		// TransferBuffer
-						  read_length);	// TransferBufferLength
+		be_start_address = cpu_to_be16(start_address);
+		status = ti_vread_sync(dev, UMPC_MEMORY_READ,
+					(__u16)address_type,
+					(__force __u16)be_start_address,
+					buffer, read_length);
 
 		if (status) {
-			dbg ("%s - ERROR %x", __func__, status);
+			dbg("%s - ERROR %x", __func__, status);
 			return status;
 		}
 
-		if (read_length > 1) {
+		if (read_length > 1)
 			usb_serial_debug_data(debug, &dev->dev, __func__,
 					      read_length, buffer);
-		}
 
 		/* Update pointers/length */
 		start_address += read_length;
 		buffer += read_length;
 		length -= read_length;
 	}
-	
+
 	return status;
 }
 
-static int TIReadRam (struct usb_device *dev, int start_address, int length, __u8 *buffer)
+static int read_ram(struct usb_device *dev, int start_address,
+						int length, __u8 *buffer)
 {
-	return TIReadDownloadMemory (dev,
-				     start_address,
-				     length,
-				     DTK_ADDR_SPACE_XDATA,
-				     buffer);
+	return read_download_mem(dev, start_address, length,
+					DTK_ADDR_SPACE_XDATA, buffer);
 }
 
 /* Read edgeport memory to a given block */
-static int TIReadBootMemory (struct edgeport_serial *serial, int start_address, int length, __u8 * buffer)
+static int read_boot_mem(struct edgeport_serial *serial,
+				int start_address, int length, __u8 *buffer)
 {
 	int status = 0;
 	int i;
 
-	for (i=0; i< length; i++) {
-		status = TIReadVendorRequestSync (serial->serial->dev,
-					UMPC_MEMORY_READ,		// Request
-					serial->TI_I2C_Type,		// wValue (Address type)
-					(__u16)(start_address+i),	// wIndex
-					&buffer[i],			// TransferBuffer
-					0x01);				// TransferBufferLength
+	for (i = 0; i < length; i++) {
+		status = ti_vread_sync(serial->serial->dev,
+				UMPC_MEMORY_READ, serial->TI_I2C_Type,
+				(__u16)(start_address+i), &buffer[i], 0x01);
 		if (status) {
-			dbg ("%s - ERROR %x", __func__, status);
+			dbg("%s - ERROR %x", __func__, status);
 			return status;
 		}
 	}
 
-	dbg ("%s - start_address = %x, length = %d", __func__, start_address, length);
-	usb_serial_debug_data(debug, &serial->serial->dev->dev, __func__, length, buffer);
+	dbg("%s - start_address = %x, length = %d",
+					__func__, start_address, length);
+	usb_serial_debug_data(debug, &serial->serial->dev->dev,
+					__func__, length, buffer);
 
 	serial->TiReadI2C = 1;
 
@@ -448,7 +412,8 @@ static int TIReadBootMemory (struct edgeport_serial *serial, int start_address,
 }
 
 /* Write given block to TI EPROM memory */
-static int TIWriteBootMemory (struct edgeport_serial *serial, int start_address, int length, __u8 *buffer)
+static int write_boot_mem(struct edgeport_serial *serial,
+				int start_address, int length, __u8 *buffer)
 {
 	int status = 0;
 	int i;
@@ -456,57 +421,58 @@ static int TIWriteBootMemory (struct edgeport_serial *serial, int start_address,
 
 	/* Must do a read before write */
 	if (!serial->TiReadI2C) {
-		status = TIReadBootMemory(serial, 0, 1, &temp);
+		status = read_boot_mem(serial, 0, 1, &temp);
 		if (status)
 			return status;
 	}
 
-	for (i=0; i < length; ++i) {
-		status = TISendVendorRequestSync (serial->serial->dev,
-						UMPC_MEMORY_WRITE,		// Request
-						buffer[i],			// wValue
-						(__u16)(i+start_address),	// wIndex
-						NULL,				// TransferBuffer
-						0);				// TransferBufferLength
+	for (i = 0; i < length; ++i) {
+		status = ti_vsend_sync(serial->serial->dev,
+				UMPC_MEMORY_WRITE, buffer[i],
+				(__u16)(i + start_address), NULL, 0);
 		if (status)
 			return status;
 	}
 
-  	dbg ("%s - start_sddr = %x, length = %d", __func__, start_address, length);
-	usb_serial_debug_data(debug, &serial->serial->dev->dev, __func__, length, buffer);
+	dbg("%s - start_sddr = %x, length = %d",
+					__func__, start_address, length);
+	usb_serial_debug_data(debug, &serial->serial->dev->dev,
+					__func__, length, buffer);
 
 	return status;
 }
 
 
 /* Write edgeport I2C memory to TI chip	*/
-static int TIWriteDownloadI2C (struct edgeport_serial *serial, int start_address, int length, __u8 address_type, __u8 *buffer)
+static int write_i2c_mem(struct edgeport_serial *serial,
+		int start_address, int length, __u8 address_type, __u8 *buffer)
 {
 	int status = 0;
 	int write_length;
 	__be16 be_start_address;
 
 	/* We can only send a maximum of 1 aligned byte page at a time */
-	
+
 	/* calulate the number of bytes left in the first page */
-	write_length = EPROM_PAGE_SIZE - (start_address & (EPROM_PAGE_SIZE - 1));
+	write_length = EPROM_PAGE_SIZE -
+				(start_address & (EPROM_PAGE_SIZE - 1));
 
 	if (write_length > length)
 		write_length = length;
 
-	dbg ("%s - BytesInFirstPage Addr = %x, length = %d", __func__, start_address, write_length);
-	usb_serial_debug_data(debug, &serial->serial->dev->dev, __func__, write_length, buffer);
+	dbg("%s - BytesInFirstPage Addr = %x, length = %d",
+					__func__, start_address, write_length);
+	usb_serial_debug_data(debug, &serial->serial->dev->dev,
+						__func__, write_length, buffer);
 
 	/* Write first page */
-	be_start_address = cpu_to_be16 (start_address);
-	status = TISendVendorRequestSync (serial->serial->dev,
-					UMPC_MEMORY_WRITE,	// Request
-					(__u16)address_type,	// wValue
-					(__force __u16)be_start_address,	// wIndex
-					buffer,			// TransferBuffer
-					write_length);
+	be_start_address = cpu_to_be16(start_address);
+	status = ti_vsend_sync(serial->serial->dev,
+				UMPC_MEMORY_WRITE, (__u16)address_type,
+				(__force __u16)be_start_address,
+				buffer,	write_length);
 	if (status) {
-		dbg ("%s - ERROR %d", __func__, status);
+		dbg("%s - ERROR %d", __func__, status);
 		return status;
 	}
 
@@ -514,29 +480,31 @@ static int TIWriteDownloadI2C (struct edgeport_serial *serial, int start_address
 	start_address	+= write_length;
 	buffer		+= write_length;
 
-	/* We should be aligned now -- can write max page size bytes at a time */
+	/* We should be aligned now -- can write
+	   max page size bytes at a time */
 	while (length) {
 		if (length > EPROM_PAGE_SIZE)
 			write_length = EPROM_PAGE_SIZE;
 		else
 			write_length = length;
 
-		dbg ("%s - Page Write Addr = %x, length = %d", __func__, start_address, write_length);
-		usb_serial_debug_data(debug, &serial->serial->dev->dev, __func__, write_length, buffer);
+		dbg("%s - Page Write Addr = %x, length = %d",
+					__func__, start_address, write_length);
+		usb_serial_debug_data(debug, &serial->serial->dev->dev,
+					__func__, write_length, buffer);
 
 		/* Write next page */
-		be_start_address = cpu_to_be16 (start_address);
-		status = TISendVendorRequestSync (serial->serial->dev,
-						UMPC_MEMORY_WRITE,	// Request
-						(__u16)address_type,	// wValue
-						(__force __u16)be_start_address,	// wIndex
-						buffer,	  		// TransferBuffer
-						write_length);		// TransferBufferLength
+		be_start_address = cpu_to_be16(start_address);
+		status = ti_vsend_sync(serial->serial->dev, UMPC_MEMORY_WRITE,
+				(__u16)address_type,
+				(__force __u16)be_start_address,
+				buffer, write_length);
 		if (status) {
-			dev_err (&serial->serial->dev->dev, "%s - ERROR %d\n", __func__, status);
+			dev_err(&serial->serial->dev->dev, "%s - ERROR %d\n",
+					__func__, status);
 			return status;
 		}
-		
+
 		length		-= write_length;
 		start_address	+= write_length;
 		buffer		+= write_length;
@@ -545,25 +513,25 @@ static int TIWriteDownloadI2C (struct edgeport_serial *serial, int start_address
 }
 
 /* Examine the UMP DMA registers and LSR
- * 
+ *
  * Check the MSBit of the X and Y DMA byte count registers.
  * A zero in this bit indicates that the TX DMA buffers are empty
  * then check the TX Empty bit in the UART.
  */
-static int TIIsTxActive (struct edgeport_port *port)
+static int tx_active(struct edgeport_port *port)
 {
 	int status;
 	struct out_endpoint_desc_block *oedb;
 	__u8 *lsr;
 	int bytes_left = 0;
 
-	oedb = kmalloc (sizeof (* oedb), GFP_KERNEL);
+	oedb = kmalloc(sizeof(*oedb), GFP_KERNEL);
 	if (!oedb) {
-		dev_err (&port->port->dev, "%s - out of memory\n", __func__);
+		dev_err(&port->port->dev, "%s - out of memory\n", __func__);
 		return -ENOMEM;
 	}
 
-	lsr = kmalloc (1, GFP_KERNEL);	/* Sigh, that's right, just one byte,
+	lsr = kmalloc(1, GFP_KERNEL);	/* Sigh, that's right, just one byte,
 					   as not all platforms can do DMA
 					   from stack */
 	if (!lsr) {
@@ -571,51 +539,47 @@ static int TIIsTxActive (struct edgeport_port *port)
 		return -ENOMEM;
 	}
 	/* Read the DMA Count Registers */
-	status = TIReadRam (port->port->serial->dev,
-			    port->dma_address,
-			    sizeof( *oedb),
-			    (void *)oedb);
-
+	status = read_ram(port->port->serial->dev, port->dma_address,
+						sizeof(*oedb), (void *)oedb);
 	if (status)
 		goto exit_is_tx_active;
 
-	dbg ("%s - XByteCount    0x%X", __func__, oedb->XByteCount);
+	dbg("%s - XByteCount    0x%X", __func__, oedb->XByteCount);
 
 	/* and the LSR */
-	status = TIReadRam (port->port->serial->dev, 
-			    port->uart_base + UMPMEM_OFFS_UART_LSR,
-			    1,
-			    lsr);
+	status = read_ram(port->port->serial->dev,
+			port->uart_base + UMPMEM_OFFS_UART_LSR, 1, lsr);
 
 	if (status)
 		goto exit_is_tx_active;
-	dbg ("%s - LSR = 0x%X", __func__, *lsr);
-	
+	dbg("%s - LSR = 0x%X", __func__, *lsr);
+
 	/* If either buffer has data or we are transmitting then return TRUE */
-	if ((oedb->XByteCount & 0x80 ) != 0 )
+	if ((oedb->XByteCount & 0x80) != 0)
 		bytes_left += 64;
 
-	if ((*lsr & UMP_UART_LSR_TX_MASK ) == 0 )
+	if ((*lsr & UMP_UART_LSR_TX_MASK) == 0)
 		bytes_left += 1;
 
 	/* We return Not Active if we get any kind of error */
 exit_is_tx_active:
-	dbg ("%s - return %d", __func__, bytes_left );
+	dbg("%s - return %d", __func__, bytes_left);
 
 	kfree(lsr);
 	kfree(oedb);
 	return bytes_left;
 }
 
-static void TIChasePort(struct edgeport_port *port, unsigned long timeout, int flush)
+static void chase_port(struct edgeport_port *port, unsigned long timeout,
+								int flush)
 {
 	int baud_rate;
-	struct tty_struct *tty = port->port->tty;
+	struct tty_struct *tty = port->port->port.tty;
 	wait_queue_t wait;
 	unsigned long flags;
 
 	if (!timeout)
-		timeout = (HZ*EDGE_CLOSING_WAIT)/100;
+		timeout = (HZ * EDGE_CLOSING_WAIT)/100;
 
 	/* wait for data to drain from the buffer */
 	spin_lock_irqsave(&port->ep_lock, flags);
@@ -625,7 +589,8 @@ static void TIChasePort(struct edgeport_port *port, unsigned long timeout, int f
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (edge_buf_data_avail(port->ep_out_buf) == 0
 		|| timeout == 0 || signal_pending(current)
-		|| !usb_get_intfdata(port->port->serial->interface))  /* disconnect */
+		|| !usb_get_intfdata(port->port->serial->interface))
+			/* disconnect */
 			break;
 		spin_unlock_irqrestore(&port->ep_lock, flags);
 		timeout = schedule_timeout(timeout);
@@ -640,8 +605,9 @@ static void TIChasePort(struct edgeport_port *port, unsigned long timeout, int f
 	/* wait for data to drain from the device */
 	timeout += jiffies;
 	while ((long)(jiffies - timeout) < 0 && !signal_pending(current)
-	&& usb_get_intfdata(port->port->serial->interface)) {  /* not disconnected */
-		if (!TIIsTxActive(port))
+	&& usb_get_intfdata(port->port->serial->interface)) {
+		/* not disconnected */
+		if (!tx_active(port))
 			break;
 		msleep(10);
 	}
@@ -651,72 +617,72 @@ static void TIChasePort(struct edgeport_port *port, unsigned long timeout, int f
 		return;
 
 	/* wait one more character time, based on baud rate */
-	/* (TIIsTxActive doesn't seem to wait for the last byte) */
-	if ((baud_rate=port->baud_rate) == 0)
+	/* (tx_active doesn't seem to wait for the last byte) */
+	baud_rate = port->baud_rate;
+	if (baud_rate == 0)
 		baud_rate = 50;
 	msleep(max(1, DIV_ROUND_UP(10000, baud_rate)));
 }
 
-static int TIChooseConfiguration (struct usb_device *dev)
+static int choose_config(struct usb_device *dev)
 {
-	// There may be multiple configurations on this device, in which case
-	// we would need to read and parse all of them to find out which one
-	// we want. However, we just support one config at this point,
-	// configuration # 1, which is Config Descriptor 0.
+	/*
+	 * There may be multiple configurations on this device, in which case
+	 * we would need to read and parse all of them to find out which one
+	 * we want. However, we just support one config at this point,
+	 * configuration # 1, which is Config Descriptor 0.
+	 */
 
-	dbg ("%s - Number of Interfaces = %d", __func__, dev->config->desc.bNumInterfaces);
-	dbg ("%s - MAX Power            = %d", __func__, dev->config->desc.bMaxPower*2);
+	dbg("%s - Number of Interfaces = %d",
+				__func__, dev->config->desc.bNumInterfaces);
+	dbg("%s - MAX Power            = %d",
+				__func__, dev->config->desc.bMaxPower * 2);
 
 	if (dev->config->desc.bNumInterfaces != 1) {
-		dev_err (&dev->dev, "%s - bNumInterfaces is not 1, ERROR!\n", __func__);
+		dev_err(&dev->dev, "%s - bNumInterfaces is not 1, ERROR!\n",
+								__func__);
 		return -ENODEV;
 	}
 
 	return 0;
 }
 
-static int TIReadRom (struct edgeport_serial *serial, int start_address, int length, __u8 *buffer)
+static int read_rom(struct edgeport_serial *serial,
+				int start_address, int length, __u8 *buffer)
 {
 	int status;
 
 	if (serial->product_info.TiMode == TI_MODE_DOWNLOAD) {
-		status = TIReadDownloadMemory (serial->serial->dev,
+		status = read_download_mem(serial->serial->dev,
 					       start_address,
 					       length,
 					       serial->TI_I2C_Type,
 					       buffer);
 	} else {
-		status = TIReadBootMemory (serial,
-					   start_address,
-					   length,
-					   buffer);
+		status = read_boot_mem(serial, start_address, length,
+								buffer);
 	}
-
 	return status;
 }
 
-static int TIWriteRom (struct edgeport_serial *serial, int start_address, int length, __u8 *buffer)
+static int write_rom(struct edgeport_serial *serial, int start_address,
+						int length, __u8 *buffer)
 {
 	if (serial->product_info.TiMode == TI_MODE_BOOT)
-		return TIWriteBootMemory (serial,
-					  start_address,
-					  length,
-					  buffer);
+		return write_boot_mem(serial, start_address, length,
+								buffer);
 
 	if (serial->product_info.TiMode == TI_MODE_DOWNLOAD)
-		return TIWriteDownloadI2C (serial,
-					   start_address,
-					   length,
-					   serial->TI_I2C_Type,
-					   buffer);
-
+		return write_i2c_mem(serial, start_address, length,
+						serial->TI_I2C_Type, buffer);
 	return -EINVAL;
 }
 
 
 
 /* Read a descriptor header from I2C based on type */
-static int TIGetDescriptorAddress (struct edgeport_serial *serial, int desc_type, struct ti_i2c_desc *rom_desc)
+static int get_descriptor_addr(struct edgeport_serial *serial,
+				int desc_type, struct ti_i2c_desc *rom_desc)
 {
 	int start_address;
 	int status;
@@ -724,41 +690,42 @@ static int TIGetDescriptorAddress (struct edgeport_serial *serial, int desc_type
 	/* Search for requested descriptor in I2C */
 	start_address = 2;
 	do {
-		status = TIReadRom (serial,
+		status = read_rom(serial,
 				   start_address,
 				   sizeof(struct ti_i2c_desc),
-				   (__u8 *)rom_desc );
+				   (__u8 *)rom_desc);
 		if (status)
 			return 0;
 
 		if (rom_desc->Type == desc_type)
 			return start_address;
 
-		start_address = start_address + sizeof(struct ti_i2c_desc) +  rom_desc->Size;
+		start_address = start_address + sizeof(struct ti_i2c_desc)
+							+ rom_desc->Size;
 
 	} while ((start_address < TI_MAX_I2C_SIZE) && rom_desc->Type);
-	
+
 	return 0;
 }
 
 /* Validate descriptor checksum */
-static int ValidChecksum(struct ti_i2c_desc *rom_desc, __u8 *buffer)
+static int valid_csum(struct ti_i2c_desc *rom_desc, __u8 *buffer)
 {
 	__u16 i;
 	__u8 cs = 0;
 
-	for (i=0; i < rom_desc->Size; i++) {
+	for (i = 0; i < rom_desc->Size; i++)
 		cs = (__u8)(cs + buffer[i]);
-	}
+
 	if (cs != rom_desc->CheckSum) {
-		dbg ("%s - Mismatch %x - %x", __func__, rom_desc->CheckSum, cs);
+		dbg("%s - Mismatch %x - %x", __func__, rom_desc->CheckSum, cs);
 		return -EINVAL;
 	}
 	return 0;
 }
 
 /* Make sure that the I2C image is good */
-static int TiValidateI2cImage (struct edgeport_serial *serial)
+static int check_i2c_image(struct edgeport_serial *serial)
 {
 	struct device *dev = &serial->serial->dev->dev;
 	int status = 0;
@@ -767,120 +734,124 @@ static int TiValidateI2cImage (struct edgeport_serial *serial)
 	__u8 *buffer;
 	__u16 ttype;
 
-	rom_desc = kmalloc (sizeof (*rom_desc), GFP_KERNEL);
+	rom_desc = kmalloc(sizeof(*rom_desc), GFP_KERNEL);
 	if (!rom_desc) {
-		dev_err (dev, "%s - out of memory\n", __func__);
+		dev_err(dev, "%s - out of memory\n", __func__);
 		return -ENOMEM;
 	}
-	buffer = kmalloc (TI_MAX_I2C_SIZE, GFP_KERNEL);
+	buffer = kmalloc(TI_MAX_I2C_SIZE, GFP_KERNEL);
 	if (!buffer) {
-		dev_err (dev, "%s - out of memory when allocating buffer\n", __func__);
-		kfree (rom_desc);
+		dev_err(dev, "%s - out of memory when allocating buffer\n",
+								__func__);
+		kfree(rom_desc);
 		return -ENOMEM;
 	}
 
-	// Read the first byte (Signature0) must be 0x52 or 0x10
-	status = TIReadRom (serial, 0, 1, buffer);
+	/* Read the first byte (Signature0) must be 0x52 or 0x10 */
+	status = read_rom(serial, 0, 1, buffer);
 	if (status)
-		goto ExitTiValidateI2cImage; 
+		goto out;
 
 	if (*buffer != UMP5152 && *buffer != UMP3410) {
-		dev_err (dev, "%s - invalid buffer signature\n", __func__);
+		dev_err(dev, "%s - invalid buffer signature\n", __func__);
 		status = -ENODEV;
-		goto ExitTiValidateI2cImage;
+		goto out;
 	}
 
 	do {
-		// Validate the I2C
-		status = TIReadRom (serial,
+		/* Validate the I2C */
+		status = read_rom(serial,
 				start_address,
 				sizeof(struct ti_i2c_desc),
 				(__u8 *)rom_desc);
 		if (status)
 			break;
 
-		if ((start_address + sizeof(struct ti_i2c_desc) + rom_desc->Size) > TI_MAX_I2C_SIZE) {
+		if ((start_address + sizeof(struct ti_i2c_desc) +
+					rom_desc->Size) > TI_MAX_I2C_SIZE) {
 			status = -ENODEV;
-			dbg ("%s - structure too big, erroring out.", __func__);
+			dbg("%s - structure too big, erroring out.", __func__);
 			break;
 		}
 
-		dbg ("%s Type = 0x%x", __func__, rom_desc->Type);
+		dbg("%s Type = 0x%x", __func__, rom_desc->Type);
 
-		// Skip type 2 record
+		/* Skip type 2 record */
 		ttype = rom_desc->Type & 0x0f;
-		if ( ttype != I2C_DESC_TYPE_FIRMWARE_BASIC
-			&& ttype != I2C_DESC_TYPE_FIRMWARE_AUTO ) {
-			// Read the descriptor data
-			status = TIReadRom(serial,
-						start_address+sizeof(struct ti_i2c_desc),
-						rom_desc->Size,
-						buffer);
+		if (ttype != I2C_DESC_TYPE_FIRMWARE_BASIC
+			&& ttype != I2C_DESC_TYPE_FIRMWARE_AUTO) {
+			/* Read the descriptor data */
+			status = read_rom(serial, start_address +
+						sizeof(struct ti_i2c_desc),
+						rom_desc->Size, buffer);
 			if (status)
 				break;
 
-			status = ValidChecksum(rom_desc, buffer);
+			status = valid_csum(rom_desc, buffer);
 			if (status)
 				break;
 		}
-		start_address = start_address + sizeof(struct ti_i2c_desc) + rom_desc->Size;
+		start_address = start_address + sizeof(struct ti_i2c_desc) +
+								rom_desc->Size;
 
-	} while ((rom_desc->Type != I2C_DESC_TYPE_ION) && (start_address < TI_MAX_I2C_SIZE));
+	} while ((rom_desc->Type != I2C_DESC_TYPE_ION) &&
+				(start_address < TI_MAX_I2C_SIZE));
 
-	if ((rom_desc->Type != I2C_DESC_TYPE_ION) || (start_address > TI_MAX_I2C_SIZE))
+	if ((rom_desc->Type != I2C_DESC_TYPE_ION) ||
+				(start_address > TI_MAX_I2C_SIZE))
 		status = -ENODEV;
 
-ExitTiValidateI2cImage:	
-	kfree (buffer);
-	kfree (rom_desc);
+out:
+	kfree(buffer);
+	kfree(rom_desc);
 	return status;
 }
 
-static int TIReadManufDescriptor (struct edgeport_serial *serial, __u8 *buffer)
+static int get_manuf_info(struct edgeport_serial *serial, __u8 *buffer)
 {
 	int status;
 	int start_address;
 	struct ti_i2c_desc *rom_desc;
 	struct edge_ti_manuf_descriptor *desc;
 
-	rom_desc = kmalloc (sizeof (*rom_desc), GFP_KERNEL);
+	rom_desc = kmalloc(sizeof(*rom_desc), GFP_KERNEL);
 	if (!rom_desc) {
-		dev_err (&serial->serial->dev->dev, "%s - out of memory\n", __func__);
+		dev_err(&serial->serial->dev->dev, "%s - out of memory\n",
+								__func__);
 		return -ENOMEM;
 	}
-	start_address = TIGetDescriptorAddress (serial, I2C_DESC_TYPE_ION, rom_desc);
+	start_address = get_descriptor_addr(serial, I2C_DESC_TYPE_ION,
+								rom_desc);
 
 	if (!start_address) {
-		dbg ("%s - Edge Descriptor not found in I2C", __func__);
+		dbg("%s - Edge Descriptor not found in I2C", __func__);
 		status = -ENODEV;
 		goto exit;
 	}
 
-	// Read the descriptor data
-	status = TIReadRom (serial,
-				start_address+sizeof(struct ti_i2c_desc),
-				rom_desc->Size,
-				buffer);
+	/* Read the descriptor data */
+	status = read_rom(serial, start_address+sizeof(struct ti_i2c_desc),
+						rom_desc->Size, buffer);
 	if (status)
 		goto exit;
-	
-	status = ValidChecksum(rom_desc, buffer);
-	
+
+	status = valid_csum(rom_desc, buffer);
+
 	desc = (struct edge_ti_manuf_descriptor *)buffer;
-	dbg ( "%s - IonConfig      0x%x", __func__, desc->IonConfig 	);
-	dbg ( "%s - Version          %d", __func__, desc->Version	  	);
-	dbg ( "%s - Cpu/Board      0x%x", __func__, desc->CpuRev_BoardRev	);
-	dbg ( "%s - NumPorts         %d", __func__, desc->NumPorts  	);
-	dbg ( "%s - NumVirtualPorts  %d", __func__, desc->NumVirtualPorts	);
-	dbg ( "%s - TotalPorts       %d", __func__, desc->TotalPorts  	);
+	dbg("%s - IonConfig      0x%x", __func__, desc->IonConfig);
+	dbg("%s - Version          %d", __func__, desc->Version);
+	dbg("%s - Cpu/Board      0x%x", __func__, desc->CpuRev_BoardRev);
+	dbg("%s - NumPorts         %d", __func__, desc->NumPorts);
+	dbg("%s - NumVirtualPorts  %d", __func__, desc->NumVirtualPorts);
+	dbg("%s - TotalPorts       %d", __func__, desc->TotalPorts);
 
 exit:
-	kfree (rom_desc);
+	kfree(rom_desc);
 	return status;
 }
 
 /* Build firmware header used for firmware update */
-static int BuildI2CFirmwareHeader (__u8 *header, struct device *dev)
+static int build_i2c_fw_hdr(__u8 *header, struct device *dev)
 {
 	__u8 *buffer;
 	int buffer_size;
@@ -890,155 +861,155 @@ static int BuildI2CFirmwareHeader (__u8 *header, struct device *dev)
 	struct ti_i2c_image_header *img_header;
 	struct ti_i2c_firmware_rec *firmware_rec;
 
-	// In order to update the I2C firmware we must change the type 2 record to type 0xF2.
-	// This will force the UMP to come up in Boot Mode.  Then while in boot mode, the driver 
-	// will download the latest firmware (padded to 15.5k) into the UMP ram. 
-	// And finally when the device comes back up in download mode the driver will cause 
-	// the new firmware to be copied from the UMP Ram to I2C and the firmware will update
-	// the record type from 0xf2 to 0x02.
-	
-	// Allocate a 15.5k buffer + 2 bytes for version number (Firmware Record)
-	buffer_size = (((1024 * 16) - 512 )+ sizeof(struct ti_i2c_firmware_rec));
-
-	buffer = kmalloc (buffer_size, GFP_KERNEL);
+	/*
+	 * In order to update the I2C firmware we must change the type 2
+	 * record to type 0xF2. This will force the UMP to come up in Boot
+	 * Mode.  Then while in boot mode, the driver will download the latest
+	 * firmware (padded to 15.5k) into the UMP ram. Finally when the device
+	 * comes back up in download mode the driver will cause the new
+	 * firmware to be copied from the UMP Ram to I2C and the firmware
+	 * will update the record type from 0xf2 to 0x02.
+	 */
+
+	/* Allocate a 15.5k buffer + 2 bytes for version number
+	   (Firmware Record) */
+	buffer_size = (((1024 * 16) - 512) +
+				sizeof(struct ti_i2c_firmware_rec));
+
+	buffer = kmalloc(buffer_size, GFP_KERNEL);
 	if (!buffer) {
-		dev_err (dev, "%s - out of memory\n", __func__);
+		dev_err(dev, "%s - out of memory\n", __func__);
 		return -ENOMEM;
 	}
-	
-	// Set entire image of 0xffs
-	memset (buffer, 0xff, buffer_size);
 
-	// Copy version number into firmware record
+	/* Set entire image of 0xffs */
+	memset(buffer, 0xff, buffer_size);
+
+	/* Copy version number into firmware record */
 	firmware_rec = (struct ti_i2c_firmware_rec *)buffer;
 
-	firmware_rec->Ver_Major	= OperationalCodeImageVersion.MajorVersion;
-	firmware_rec->Ver_Minor	= OperationalCodeImageVersion.MinorVersion;
+	firmware_rec->Ver_Major	= op_fw_version.MajorVersion;
+	firmware_rec->Ver_Minor	= op_fw_version.MinorVersion;
 
-	// Pointer to fw_down memory image
-	img_header = (struct ti_i2c_image_header *)&PagableOperationalCodeImage[0];
+	/* Pointer to fw_down memory image */
+	img_header = (struct ti_i2c_image_header *)&fw_image[0];
 
-	memcpy (buffer + sizeof(struct ti_i2c_firmware_rec),
-		&PagableOperationalCodeImage[sizeof(struct ti_i2c_image_header)],
+	memcpy(buffer + sizeof(struct ti_i2c_firmware_rec),
+		&fw_image[sizeof(struct ti_i2c_image_header)],
 		le16_to_cpu(img_header->Length));
 
-	for (i=0; i < buffer_size; i++) {
+	for (i = 0; i < buffer_size; i++)
 		cs = (__u8)(cs + buffer[i]);
-	}
-
-	kfree (buffer);
+	kfree(buffer);
 
-	// Build new header
+	/* Build new header */
 	i2c_header =  (struct ti_i2c_desc *)header;
-	firmware_rec =  (struct ti_i2c_firmware_rec*)i2c_header->Data;
-	
+	firmware_rec =  (struct ti_i2c_firmware_rec *)i2c_header->Data;
+
 	i2c_header->Type	= I2C_DESC_TYPE_FIRMWARE_BLANK;
 	i2c_header->Size	= (__u16)buffer_size;
 	i2c_header->CheckSum	= cs;
-	firmware_rec->Ver_Major	= OperationalCodeImageVersion.MajorVersion;
-	firmware_rec->Ver_Minor	= OperationalCodeImageVersion.MinorVersion;
+	firmware_rec->Ver_Major	= op_fw_version.MajorVersion;
+	firmware_rec->Ver_Minor	= op_fw_version.MinorVersion;
 
 	return 0;
 }
 
 /* Try to figure out what type of I2c we have */
-static int TIGetI2cTypeInBootMode (struct edgeport_serial *serial)
+static int i2c_type_bootmode(struct edgeport_serial *serial)
 {
 	int status;
 	__u8 data;
-		
-	// Try to read type 2
-	status = TIReadVendorRequestSync (serial->serial->dev,
-					UMPC_MEMORY_READ,		// Request
-					DTK_ADDR_SPACE_I2C_TYPE_II,	// wValue (Address type)
-					0,		 		// wIndex
-					&data,				// TransferBuffer
-					0x01);				// TransferBufferLength
+
+	/* Try to read type 2 */
+	status = ti_vread_sync(serial->serial->dev, UMPC_MEMORY_READ,
+				DTK_ADDR_SPACE_I2C_TYPE_II, 0, &data, 0x01);
 	if (status)
-		dbg ("%s - read 2 status error = %d", __func__, status);
+		dbg("%s - read 2 status error = %d", __func__, status);
 	else
-		dbg ("%s - read 2 data = 0x%x", __func__, data);
+		dbg("%s - read 2 data = 0x%x", __func__, data);
 	if ((!status) && (data == UMP5152 || data == UMP3410)) {
-		dbg ("%s - ROM_TYPE_II", __func__);
+		dbg("%s - ROM_TYPE_II", __func__);
 		serial->TI_I2C_Type = DTK_ADDR_SPACE_I2C_TYPE_II;
 		return 0;
 	}
 
-	// Try to read type 3
-	status = TIReadVendorRequestSync (serial->serial->dev,
-					UMPC_MEMORY_READ,		// Request
-					DTK_ADDR_SPACE_I2C_TYPE_III,	// wValue (Address type)
-					0,				// wIndex
-					&data,				// TransferBuffer
-					0x01);				// TransferBufferLength
+	/* Try to read type 3 */
+	status = ti_vread_sync(serial->serial->dev, UMPC_MEMORY_READ,
+				DTK_ADDR_SPACE_I2C_TYPE_III, 0,	&data, 0x01);
 	if (status)
-		dbg ("%s - read 3 status error = %d", __func__, status);
+		dbg("%s - read 3 status error = %d", __func__, status);
 	else
-		dbg ("%s - read 2 data = 0x%x", __func__, data);
+		dbg("%s - read 2 data = 0x%x", __func__, data);
 	if ((!status) && (data == UMP5152 || data == UMP3410)) {
-		dbg ("%s - ROM_TYPE_III", __func__);
+		dbg("%s - ROM_TYPE_III", __func__);
 		serial->TI_I2C_Type = DTK_ADDR_SPACE_I2C_TYPE_III;
 		return 0;
 	}
 
-	dbg ("%s - Unknown", __func__);
+	dbg("%s - Unknown", __func__);
 	serial->TI_I2C_Type = DTK_ADDR_SPACE_I2C_TYPE_II;
 	return -ENODEV;
 }
 
-static int TISendBulkTransferSync (struct usb_serial *serial, void *buffer, int length, int *num_sent)
+static int bulk_xfer(struct usb_serial *serial, void *buffer,
+						int length, int *num_sent)
 {
 	int status;
 
-	status = usb_bulk_msg (serial->dev,
-				usb_sndbulkpipe(serial->dev,
-						serial->port[0]->bulk_out_endpointAddress),
-				buffer,
-				length,
-				num_sent,
-				1000);
+	status = usb_bulk_msg(serial->dev,
+			usb_sndbulkpipe(serial->dev,
+				serial->port[0]->bulk_out_endpointAddress),
+			buffer, length, num_sent, 1000);
 	return status;
 }
 
 /* Download given firmware image to the device (IN BOOT MODE) */
-static int TIDownloadCodeImage (struct edgeport_serial *serial, __u8 *image, int image_length)
+static int download_code(struct edgeport_serial *serial, __u8 *image,
+							int image_length)
 {
 	int status = 0;
 	int pos;
 	int transfer;
 	int done;
 
-	// Transfer firmware image
+	/* Transfer firmware image */
 	for (pos = 0; pos < image_length; ) {
-		// Read the next buffer from file
+		/* Read the next buffer from file */
 		transfer = image_length - pos;
 		if (transfer > EDGE_FW_BULK_MAX_PACKET_SIZE)
 			transfer = EDGE_FW_BULK_MAX_PACKET_SIZE;
 
-		// Transfer data
-		status = TISendBulkTransferSync (serial->serial, &image[pos], transfer, &done);
+		/* Transfer data */
+		status = bulk_xfer(serial->serial, &image[pos],
+							transfer, &done);
 		if (status)
 			break;
-		// Advance buffer pointer
+		/* Advance buffer pointer */
 		pos += done;
 	}
 
 	return status;
 }
 
-// FIXME!!!
-static int TIConfigureBootDevice (struct usb_device *dev)
+/* FIXME!!! */
+static int config_boot_dev(struct usb_device *dev)
 {
 	return 0;
 }
 
+static int ti_cpu_rev(struct edge_ti_manuf_descriptor *desc)
+{
+	return TI_GET_CPU_REVISION(desc->CpuRev_BoardRev);
+}
+
 /**
  * DownloadTIFirmware - Download run-time operating firmware to the TI5052
- * 
+ *
  * This routine downloads the main operating code into the TI5052, using the
  * boot code already burned into E2PROM or ROM.
  */
-static int TIDownloadFirmware (struct edgeport_serial *serial)
+static int download_fw(struct edgeport_serial *serial)
 {
 	struct device *dev = &serial->serial->dev->dev;
 	int status = 0;
@@ -1057,28 +1028,31 @@ static int TIDownloadFirmware (struct edgeport_serial *serial)
 	/* Default to type 2 i2c */
 	serial->TI_I2C_Type = DTK_ADDR_SPACE_I2C_TYPE_II;
 
-	status = TIChooseConfiguration (serial->serial->dev);
+	status = choose_config(serial->serial->dev);
 	if (status)
 		return status;
 
 	interface = &serial->serial->interface->cur_altsetting->desc;
 	if (!interface) {
-		dev_err (dev, "%s - no interface set, error!\n", __func__);
+		dev_err(dev, "%s - no interface set, error!\n", __func__);
 		return -ENODEV;
 	}
 
-	// Setup initial mode -- the default mode 0 is TI_MODE_CONFIGURING
-	// if we have more than one endpoint we are definitely in download mode
+	/*
+	 * Setup initial mode -- the default mode 0 is TI_MODE_CONFIGURING
+	 * if we have more than one endpoint we are definitely in download
+	 * mode
+	 */
 	if (interface->bNumEndpoints > 1)
 		serial->product_info.TiMode = TI_MODE_DOWNLOAD;
 	else
-		// Otherwise we will remain in configuring mode
+		/* Otherwise we will remain in configuring mode */
 		serial->product_info.TiMode = TI_MODE_CONFIGURING;
 
-	// Save Download Version Number
-	OperationalCodeImageVersion.MajorVersion = PagableOperationalCodeImageVersion.MajorVersion;
-	OperationalCodeImageVersion.MinorVersion = PagableOperationalCodeImageVersion.MinorVersion;
-	OperationalCodeImageVersion.BuildNumber	 = PagableOperationalCodeImageVersion.BuildNumber;
+	/* Save Download Version Number */
+	op_fw_version.MajorVersion = fw_version.MajorVersion;
+	op_fw_version.MinorVersion = fw_version.MinorVersion;
+	op_fw_version.BuildNumber	 = fw_version.BuildNumber;
 
 	/********************************************************************/
 	/* Download Mode */
@@ -1088,256 +1062,276 @@ static int TIDownloadFirmware (struct edgeport_serial *serial)
 
 		dbg("%s - RUNNING IN DOWNLOAD MODE", __func__);
 
-		status = TiValidateI2cImage (serial);
+		status = check_i2c_image(serial);
 		if (status) {
 			dbg("%s - DOWNLOAD MODE -- BAD I2C", __func__);
 			return status;
 		}
-		
+
 		/* Validate Hardware version number
 		 * Read Manufacturing Descriptor from TI Based Edgeport
 		 */
-		ti_manuf_desc = kmalloc (sizeof (*ti_manuf_desc), GFP_KERNEL);
+		ti_manuf_desc = kmalloc(sizeof(*ti_manuf_desc), GFP_KERNEL);
 		if (!ti_manuf_desc) {
-			dev_err (dev, "%s - out of memory.\n", __func__);
+			dev_err(dev, "%s - out of memory.\n", __func__);
 			return -ENOMEM;
 		}
-		status = TIReadManufDescriptor (serial, (__u8 *)ti_manuf_desc);
+		status = get_manuf_info(serial, (__u8 *)ti_manuf_desc);
 		if (status) {
-			kfree (ti_manuf_desc);
+			kfree(ti_manuf_desc);
 			return status;
 		}
 
-		// Check version number of ION descriptor
-		if (!ignore_cpu_rev && TI_GET_CPU_REVISION(ti_manuf_desc->CpuRev_BoardRev) < 2) {
-			dbg ( "%s - Wrong CPU Rev %d (Must be 2)", __func__,
-			     TI_GET_CPU_REVISION(ti_manuf_desc->CpuRev_BoardRev));
-			kfree (ti_manuf_desc);
-		   	return -EINVAL;
+		/* Check version number of ION descriptor */
+		if (!ignore_cpu_rev && ti_cpu_rev(ti_manuf_desc) < 2) {
+			dbg("%s - Wrong CPU Rev %d (Must be 2)",
+				__func__, ti_cpu_rev(ti_manuf_desc));
+			kfree(ti_manuf_desc);
+			return -EINVAL;
 		}
 
-		rom_desc = kmalloc (sizeof (*rom_desc), GFP_KERNEL);
+		rom_desc = kmalloc(sizeof(*rom_desc), GFP_KERNEL);
 		if (!rom_desc) {
-			dev_err (dev, "%s - out of memory.\n", __func__);
-			kfree (ti_manuf_desc);
+			dev_err(dev, "%s - out of memory.\n", __func__);
+			kfree(ti_manuf_desc);
 			return -ENOMEM;
 		}
 
-		// Search for type 2 record (firmware record)
-		if ((start_address = TIGetDescriptorAddress (serial, I2C_DESC_TYPE_FIRMWARE_BASIC, rom_desc)) != 0) {
+		/* Search for type 2 record (firmware record) */
+		start_address = get_descriptor_addr(serial,
+				I2C_DESC_TYPE_FIRMWARE_BASIC, rom_desc);
+		if (start_address != 0) {
 			struct ti_i2c_firmware_rec *firmware_version;
 			__u8 record;
 
-			dbg ("%s - Found Type FIRMWARE (Type 2) record", __func__);
+			dbg("%s - Found Type FIRMWARE (Type 2) record",
+								__func__);
 
-			firmware_version = kmalloc (sizeof (*firmware_version), GFP_KERNEL);
+			firmware_version = kmalloc(sizeof(*firmware_version),
+								GFP_KERNEL);
 			if (!firmware_version) {
-				dev_err (dev, "%s - out of memory.\n", __func__);
-				kfree (rom_desc);
-				kfree (ti_manuf_desc);
+				dev_err(dev, "%s - out of memory.\n",
+								__func__);
+				kfree(rom_desc);
+				kfree(ti_manuf_desc);
 				return -ENOMEM;
 			}
 
-			// Validate version number				
-			// Read the descriptor data
-			status = TIReadRom (serial,
-					start_address+sizeof(struct ti_i2c_desc),
+			/* Validate version number
+			 * Read the descriptor data
+			 */
+			status = read_rom(serial, start_address +
+					sizeof(struct ti_i2c_desc),
 					sizeof(struct ti_i2c_firmware_rec),
 					(__u8 *)firmware_version);
 			if (status) {
-				kfree (firmware_version);
-				kfree (rom_desc);
-				kfree (ti_manuf_desc);
+				kfree(firmware_version);
+				kfree(rom_desc);
+				kfree(ti_manuf_desc);
 				return status;
 			}
 
-			// Check version number of download with current version in I2c
-			download_cur_ver = (firmware_version->Ver_Major << 8) + 
+			/* Check version number of download with current
+			   version in I2c */
+			download_cur_ver = (firmware_version->Ver_Major << 8) +
 					   (firmware_version->Ver_Minor);
-			download_new_ver = (OperationalCodeImageVersion.MajorVersion << 8) +
-					   (OperationalCodeImageVersion.MinorVersion);
+			download_new_ver = (op_fw_version.MajorVersion << 8) +
+					   (op_fw_version.MinorVersion);
 
-			dbg ("%s - >>>Firmware Versions Device %d.%d  Driver %d.%d",
+			dbg("%s - >>>FW Versions Device %d.%d  Driver %d.%d",
 			     __func__,
 			     firmware_version->Ver_Major,
 			     firmware_version->Ver_Minor,
-			     OperationalCodeImageVersion.MajorVersion,
-			     OperationalCodeImageVersion.MinorVersion);
+			     op_fw_version.MajorVersion,
+			     op_fw_version.MinorVersion);
 
-			// Check if we have an old version in the I2C and update if necessary
+			/* Check if we have an old version in the I2C and
+			   update if necessary */
 			if (download_cur_ver != download_new_ver) {
-				dbg ("%s - Update I2C Download from %d.%d to %d.%d",
+				dbg("%s - Update I2C dld from %d.%d to %d.%d",
 				     __func__,
 				     firmware_version->Ver_Major,
 				     firmware_version->Ver_Minor,
-				     OperationalCodeImageVersion.MajorVersion,
-				     OperationalCodeImageVersion.MinorVersion);
-
-				// In order to update the I2C firmware we must change the type 2 record to type 0xF2.
-				// This will force the UMP to come up in Boot Mode.  Then while in boot mode, the driver 
-				// will download the latest firmware (padded to 15.5k) into the UMP ram. 
-				// And finally when the device comes back up in download mode the driver will cause 
-				// the new firmware to be copied from the UMP Ram to I2C and the firmware will update
-				// the record type from 0xf2 to 0x02.
+				     op_fw_version.MajorVersion,
+				     op_fw_version.MinorVersion);
+
+				/* In order to update the I2C firmware we must
+				 * change the type 2 record to type 0xF2. This
+				 * will force the UMP to come up in Boot Mode.
+				 * Then while in boot mode, the driver will
+				 * download the latest firmware (padded to
+				 * 15.5k) into the UMP ram. Finally when the
+				 * device comes back up in download mode the
+				 * driver will cause the new firmware to be
+				 * copied from the UMP Ram to I2C and the
+				 * firmware will update the record type from
+				 * 0xf2 to 0x02.
+				 */
 
 				record = I2C_DESC_TYPE_FIRMWARE_BLANK;
 
-				// Change the I2C Firmware record type to 0xf2 to trigger an update
-				status = TIWriteRom (serial,
-							start_address,
-							sizeof(record),
-							&record);
+				/* Change the I2C Firmware record type to
+				   0xf2 to trigger an update */
+				status = write_rom(serial, start_address,
+						sizeof(record),	&record);
 				if (status) {
-					kfree (firmware_version);
-					kfree (rom_desc);
-					kfree (ti_manuf_desc);
+					kfree(firmware_version);
+					kfree(rom_desc);
+					kfree(ti_manuf_desc);
 					return status;
 				}
 
-				// verify the write -- must do this in order for write to 
-				// complete before we do the hardware reset
-				status = TIReadRom (serial,
+				/* verify the write -- must do this in order
+				 * for write to complete before we do the
+				 * hardware reset
+				 */
+				status = read_rom(serial,
 							start_address,
 							sizeof(record),
 							&record);
 
 				if (status) {
-					kfree (firmware_version);
-					kfree (rom_desc);
-					kfree (ti_manuf_desc);
+					kfree(firmware_version);
+					kfree(rom_desc);
+					kfree(ti_manuf_desc);
 					return status;
 				}
 
 				if (record != I2C_DESC_TYPE_FIRMWARE_BLANK) {
-					dev_err (dev, "%s - error resetting device\n", __func__);
-					kfree (firmware_version);
-					kfree (rom_desc);
-					kfree (ti_manuf_desc);
+					dev_err(dev,
+					    "%s - error resetting device\n",
+						__func__);
+					kfree(firmware_version);
+					kfree(rom_desc);
+					kfree(ti_manuf_desc);
 					return -ENODEV;
 				}
 
-				dbg ("%s - HARDWARE RESET", __func__);
+				dbg("%s - HARDWARE RESET", __func__);
 
-				// Reset UMP -- Back to BOOT MODE
-				status = TISendVendorRequestSync (serial->serial->dev,
-								UMPC_HARDWARE_RESET,	// Request
-								0,			// wValue
-								0,			// wIndex
-								NULL,			// TransferBuffer
-								0);			// TransferBufferLength
+				/* Reset UMP -- Back to BOOT MODE */
+				status = ti_vsend_sync(serial->serial->dev,
+						UMPC_HARDWARE_RESET,
+						0, 0, NULL, 0);
 
-				dbg ( "%s - HARDWARE RESET return %d", __func__, status);
+				dbg("%s - HARDWARE RESET return %d",
+						__func__, status);
 
 				/* return an error on purpose. */
-				kfree (firmware_version);
-				kfree (rom_desc);
-				kfree (ti_manuf_desc);
+				kfree(firmware_version);
+				kfree(rom_desc);
+				kfree(ti_manuf_desc);
 				return -ENODEV;
 			}
-			kfree (firmware_version);
+			kfree(firmware_version);
 		}
-		// Search for type 0xF2 record (firmware blank record)
-		else if ((start_address = TIGetDescriptorAddress (serial, I2C_DESC_TYPE_FIRMWARE_BLANK, rom_desc)) != 0) {
-			#define HEADER_SIZE	(sizeof(struct ti_i2c_desc) + sizeof(struct ti_i2c_firmware_rec))
+		/* Search for type 0xF2 record (firmware blank record) */
+		else if ((start_address = get_descriptor_addr(serial, I2C_DESC_TYPE_FIRMWARE_BLANK, rom_desc)) != 0) {
+#define HEADER_SIZE	(sizeof(struct ti_i2c_desc) + \
+					sizeof(struct ti_i2c_firmware_rec))
 			__u8 *header;
 			__u8 *vheader;
 
-			header  = kmalloc (HEADER_SIZE, GFP_KERNEL);
+			header  = kmalloc(HEADER_SIZE, GFP_KERNEL);
 			if (!header) {
-				dev_err (dev, "%s - out of memory.\n", __func__);
-				kfree (rom_desc);
-				kfree (ti_manuf_desc);
+				dev_err(dev, "%s - out of memory.\n", __func__);
+				kfree(rom_desc);
+				kfree(ti_manuf_desc);
 				return -ENOMEM;
 			}
-				
-			vheader = kmalloc (HEADER_SIZE, GFP_KERNEL);
+
+			vheader = kmalloc(HEADER_SIZE, GFP_KERNEL);
 			if (!vheader) {
-				dev_err (dev, "%s - out of memory.\n", __func__);
-				kfree (header);
-				kfree (rom_desc);
-				kfree (ti_manuf_desc);
+				dev_err(dev, "%s - out of memory.\n", __func__);
+				kfree(header);
+				kfree(rom_desc);
+				kfree(ti_manuf_desc);
 				return -ENOMEM;
 			}
-			
-			dbg ("%s - Found Type BLANK FIRMWARE (Type F2) record", __func__);
-
-			// In order to update the I2C firmware we must change the type 2 record to type 0xF2.
-			// This will force the UMP to come up in Boot Mode.  Then while in boot mode, the driver 
-			// will download the latest firmware (padded to 15.5k) into the UMP ram. 
-			// And finally when the device comes back up in download mode the driver will cause 
-			// the new firmware to be copied from the UMP Ram to I2C and the firmware will update
-			// the record type from 0xf2 to 0x02.
-			status = BuildI2CFirmwareHeader(header, dev);
+
+			dbg("%s - Found Type BLANK FIRMWARE (Type F2) record",
+								__func__);
+
+			/*
+			 * In order to update the I2C firmware we must change
+			 * the type 2 record to type 0xF2. This will force the
+			 * UMP to come up in Boot Mode.  Then while in boot
+			 * mode, the driver will download the latest firmware
+			 * (padded to 15.5k) into the UMP ram. Finally when the
+			 * device comes back up in download mode the driver
+			 * will cause the new firmware to be copied from the
+			 * UMP Ram to I2C and the firmware will update the
+			 * record type from 0xf2 to 0x02.
+			 */
+			status = build_i2c_fw_hdr(header, dev);
 			if (status) {
-				kfree (vheader);
-				kfree (header);
-				kfree (rom_desc);
-				kfree (ti_manuf_desc);
+				kfree(vheader);
+				kfree(header);
+				kfree(rom_desc);
+				kfree(ti_manuf_desc);
 				return status;
 			}
 
-			// Update I2C with type 0xf2 record with correct size and checksum
-			status = TIWriteRom (serial,
+			/* Update I2C with type 0xf2 record with correct
+			   size and checksum */
+			status = write_rom(serial,
 						start_address,
 						HEADER_SIZE,
 						header);
 			if (status) {
-				kfree (vheader);
-				kfree (header);
-				kfree (rom_desc);
-				kfree (ti_manuf_desc);
+				kfree(vheader);
+				kfree(header);
+				kfree(rom_desc);
+				kfree(ti_manuf_desc);
 				return status;
 			}
 
-			// verify the write -- must do this in order for write to 
-			// complete before we do the hardware reset
-			status = TIReadRom (serial,
-						start_address,
-						HEADER_SIZE,
-						vheader);
+			/* verify the write -- must do this in order for
+			   write to complete before we do the hardware reset */
+			status = read_rom(serial, start_address,
+							HEADER_SIZE, vheader);
 
 			if (status) {
-				dbg ("%s - can't read header back", __func__);
-				kfree (vheader);
-				kfree (header);
-				kfree (rom_desc);
-				kfree (ti_manuf_desc);
+				dbg("%s - can't read header back", __func__);
+				kfree(vheader);
+				kfree(header);
+				kfree(rom_desc);
+				kfree(ti_manuf_desc);
 				return status;
 			}
 			if (memcmp(vheader, header, HEADER_SIZE)) {
-				dbg ("%s - write download record failed", __func__);
-				kfree (vheader);
-				kfree (header);
-				kfree (rom_desc);
-				kfree (ti_manuf_desc);
+				dbg("%s - write download record failed",
+								__func__);
+				kfree(vheader);
+				kfree(header);
+				kfree(rom_desc);
+				kfree(ti_manuf_desc);
 				return status;
 			}
 
-			kfree (vheader);
-			kfree (header);
+			kfree(vheader);
+			kfree(header);
 
-			dbg ("%s - Start firmware update", __func__);
+			dbg("%s - Start firmware update", __func__);
 
-			// Tell firmware to copy download image into I2C 
-			status = TISendVendorRequestSync (serial->serial->dev,
-						UMPC_COPY_DNLD_TO_I2C,	// Request
-						0,			// wValue 
-						0,			// wIndex
-						NULL,			// TransferBuffer
-						0);			// TransferBufferLength
+			/* Tell firmware to copy download image into I2C */
+			status = ti_vsend_sync(serial->serial->dev,
+					UMPC_COPY_DNLD_TO_I2C, 0, 0, NULL, 0);
 
-		  	dbg ("%s - Update complete 0x%x", __func__, status);
+			dbg("%s - Update complete 0x%x", __func__, status);
 			if (status) {
-				dev_err (dev, "%s - UMPC_COPY_DNLD_TO_I2C failed\n", __func__);
-				kfree (rom_desc);
-				kfree (ti_manuf_desc);
+				dev_err(dev,
+					"%s - UMPC_COPY_DNLD_TO_I2C failed\n",
+								__func__);
+				kfree(rom_desc);
+				kfree(ti_manuf_desc);
 				return status;
 			}
 		}
 
-		// The device is running the download code
-		kfree (rom_desc);
-		kfree (ti_manuf_desc);
+		/* The device is running the download code */
+		kfree(rom_desc);
+		kfree(ti_manuf_desc);
 		return 0;
 	}
 
@@ -1346,32 +1340,26 @@ static int TIDownloadFirmware (struct edgeport_serial *serial)
 	/********************************************************************/
 	dbg("%s - RUNNING IN BOOT MODE", __func__);
 
-	// Configure the TI device so we can use the BULK pipes for download
-	status = TIConfigureBootDevice (serial->serial->dev);
+	/* Configure the TI device so we can use the BULK pipes for download */
+	status = config_boot_dev(serial->serial->dev);
 	if (status)
 		return status;
 
-	if (le16_to_cpu(serial->serial->dev->descriptor.idVendor) != USB_VENDOR_ID_ION) {
-		dbg ("%s - VID = 0x%x", __func__,
+	if (le16_to_cpu(serial->serial->dev->descriptor.idVendor)
+							!= USB_VENDOR_ID_ION) {
+		dbg("%s - VID = 0x%x", __func__,
 		     le16_to_cpu(serial->serial->dev->descriptor.idVendor));
 		serial->TI_I2C_Type = DTK_ADDR_SPACE_I2C_TYPE_II;
-		goto StayInBootMode;
+		goto stayinbootmode;
 	}
 
-	// We have an ION device (I2c Must be programmed)
-	// Determine I2C image type
-	if (TIGetI2cTypeInBootMode(serial)) {
-		goto StayInBootMode;
-	}
+	/* We have an ION device (I2c Must be programmed)
+	   Determine I2C image type */
+	if (i2c_type_bootmode(serial))
+		goto stayinbootmode;
 
-	// Registry variable set?
-	if (TIStayInBootMode) {
-		dbg ("%s - TIStayInBootMode", __func__);
-		goto StayInBootMode;
-	}
-
-	// Check for ION Vendor ID and that the I2C is valid
-	if (!TiValidateI2cImage(serial)) {
+	/* Check for ION Vendor ID and that the I2C is valid */
+	if (!check_i2c_image(serial)) {
 		struct ti_i2c_image_header *header;
 		int i;
 		__u8 cs = 0;
@@ -1381,241 +1369,124 @@ static int TIDownloadFirmware (struct edgeport_serial *serial)
 		/* Validate Hardware version number
 		 * Read Manufacturing Descriptor from TI Based Edgeport
 		 */
-		ti_manuf_desc = kmalloc (sizeof (*ti_manuf_desc), GFP_KERNEL);
+		ti_manuf_desc = kmalloc(sizeof(*ti_manuf_desc), GFP_KERNEL);
 		if (!ti_manuf_desc) {
-			dev_err (dev, "%s - out of memory.\n", __func__);
+			dev_err(dev, "%s - out of memory.\n", __func__);
 			return -ENOMEM;
 		}
-		status = TIReadManufDescriptor (serial, (__u8 *)ti_manuf_desc);
+		status = get_manuf_info(serial, (__u8 *)ti_manuf_desc);
 		if (status) {
-			kfree (ti_manuf_desc);
-			goto StayInBootMode;
+			kfree(ti_manuf_desc);
+			goto stayinbootmode;
 		}
 
-		// Check for version 2
-		if (!ignore_cpu_rev && TI_GET_CPU_REVISION(ti_manuf_desc->CpuRev_BoardRev) < 2) {
-			dbg ("%s - Wrong CPU Rev %d (Must be 2)", __func__,
-			     TI_GET_CPU_REVISION(ti_manuf_desc->CpuRev_BoardRev));
-			kfree (ti_manuf_desc);
-			goto StayInBootMode;
+		/* Check for version 2 */
+		if (!ignore_cpu_rev && ti_cpu_rev(ti_manuf_desc) < 2) {
+			dbg("%s - Wrong CPU Rev %d (Must be 2)",
+					__func__, ti_cpu_rev(ti_manuf_desc));
+			kfree(ti_manuf_desc);
+			goto stayinbootmode;
 		}
 
-		kfree (ti_manuf_desc);
+		kfree(ti_manuf_desc);
 
-		// In order to update the I2C firmware we must change the type 2 record to type 0xF2.
-		// This will force the UMP to come up in Boot Mode.  Then while in boot mode, the driver 
-		// will download the latest firmware (padded to 15.5k) into the UMP ram. 
-		// And finally when the device comes back up in download mode the driver will cause 
-		// the new firmware to be copied from the UMP Ram to I2C and the firmware will update
-		// the record type from 0xf2 to 0x02.
-		
 		/*
+		 * In order to update the I2C firmware we must change the type
+		 * 2 record to type 0xF2. This will force the UMP to come up
+		 * in Boot Mode.  Then while in boot mode, the driver will
+		 * download the latest firmware (padded to 15.5k) into the
+		 * UMP ram. Finally when the device comes back up in download
+		 * mode the driver will cause the new firmware to be copied
+		 * from the UMP Ram to I2C and the firmware will update the
+		 * record type from 0xf2 to 0x02.
+		 *
 		 * Do we really have to copy the whole firmware image,
 		 * or could we do this in place!
 		 */
 
-		// Allocate a 15.5k buffer + 3 byte header
-		buffer_size = (((1024 * 16) - 512) + sizeof(struct ti_i2c_image_header));
-		buffer = kmalloc (buffer_size, GFP_KERNEL);
+		/* Allocate a 15.5k buffer + 3 byte header */
+		buffer_size = (((1024 * 16) - 512) +
+					sizeof(struct ti_i2c_image_header));
+		buffer = kmalloc(buffer_size, GFP_KERNEL);
 		if (!buffer) {
-			dev_err (dev, "%s - out of memory\n", __func__);
+			dev_err(dev, "%s - out of memory\n", __func__);
 			return -ENOMEM;
 		}
-		
-		// Initialize the buffer to 0xff (pad the buffer)
-		memset (buffer, 0xff, buffer_size);
 
-		memcpy (buffer, &PagableOperationalCodeImage[0], PagableOperationalCodeSize);
+		/* Initialize the buffer to 0xff (pad the buffer) */
+		memset(buffer, 0xff, buffer_size);
+		memcpy(buffer, &fw_image[0], fw_size);
 
-		for(i = sizeof(struct ti_i2c_image_header); i < buffer_size; i++) {
+		for (i = sizeof(struct ti_i2c_image_header);
+						i < buffer_size; i++)
 			cs = (__u8)(cs + buffer[i]);
-		}
-		
+
 		header = (struct ti_i2c_image_header *)buffer;
-		
-		// update length and checksum after padding
-		header->Length 	 = cpu_to_le16((__u16)(buffer_size - sizeof(struct ti_i2c_image_header)));
+
+		/* update length and checksum after padding */
+		header->Length 	 = cpu_to_le16((__u16)(buffer_size -
+					sizeof(struct ti_i2c_image_header)));
 		header->CheckSum = cs;
 
-		// Download the operational code 
-		dbg ("%s - Downloading operational code image (TI UMP)", __func__);
-		status = TIDownloadCodeImage (serial, buffer, buffer_size);
+		/* Download the operational code  */
+		dbg("%s - Downloading operational code image (TI UMP)",
+								__func__);
+		status = download_code(serial, buffer, buffer_size);
 
-		kfree (buffer);
+		kfree(buffer);
 
 		if (status) {
-	  		dbg ("%s - Error downloading operational code image", __func__);
+			dbg("%s - Error downloading operational code image",
+								__func__);
 			return status;
 		}
 
-		// Device will reboot
+		/* Device will reboot */
 		serial->product_info.TiMode = TI_MODE_TRANSITIONING;
 
-  		dbg ("%s - Download successful -- Device rebooting...", __func__);
+		dbg("%s - Download successful -- Device rebooting...",
+								__func__);
 
 		/* return an error on purpose */
 		return -ENODEV;
 	}
 
-StayInBootMode:
-	// Eprom is invalid or blank stay in boot mode
+stayinbootmode:
+	/* Eprom is invalid or blank stay in boot mode */
 	dbg("%s - STAYING IN BOOT MODE", __func__);
 	serial->product_info.TiMode = TI_MODE_BOOT;
 
 	return 0;
 }
 
-
-static int TISetDtr (struct edgeport_port *port)
-{
-	int port_number = port->port->number - port->port->serial->minor;
-
-	dbg ("%s", __func__);
-	port->shadow_mcr |= MCR_DTR;
-
-	return TIWriteCommandSync (port->port->serial->dev,
-				UMPC_SET_CLR_DTR,
-				(__u8)(UMPM_UART1_PORT + port_number),
-				1,	/* set */
-				NULL,
-				0);
-}
-
-static int TIClearDtr (struct edgeport_port *port)
+static int ti_do_config(struct edgeport_port *port, int feature, int on)
 {
 	int port_number = port->port->number - port->port->serial->minor;
-
-	dbg ("%s", __func__);
-	port->shadow_mcr &= ~MCR_DTR;
-
-	return TIWriteCommandSync (port->port->serial->dev,
-				UMPC_SET_CLR_DTR,
-				(__u8)(UMPM_UART1_PORT + port_number),
-				0,	/* clear */
-				NULL,
-				0);
+	on = !!on;	/* 1 or 0 not bitmask */
+	return send_cmd(port->port->serial->dev,
+			feature, (__u8)(UMPM_UART1_PORT + port_number),
+			on, NULL, 0);
 }
 
-static int TISetRts (struct edgeport_port *port)
-{
-	int port_number = port->port->number - port->port->serial->minor;
-
-	dbg ("%s", __func__);
-	port->shadow_mcr |= MCR_RTS;
-
-	return TIWriteCommandSync (port->port->serial->dev,
-				UMPC_SET_CLR_RTS,
-				(__u8)(UMPM_UART1_PORT + port_number),
-				1,	/* set */
-				NULL,
-				0);
-}
-
-static int TIClearRts (struct edgeport_port *port)
-{
-	int port_number = port->port->number - port->port->serial->minor;
-
-	dbg ("%s", __func__);
-	port->shadow_mcr &= ~MCR_RTS;
-
-	return TIWriteCommandSync (port->port->serial->dev,
-				UMPC_SET_CLR_RTS,
-				(__u8)(UMPM_UART1_PORT + port_number),
-				0,	/* clear */
-				NULL,
-				0);
-}
-
-static int TISetLoopBack (struct edgeport_port *port)
-{
-	int port_number = port->port->number - port->port->serial->minor;
-
-	dbg ("%s", __func__);
-
-	return TIWriteCommandSync (port->port->serial->dev,
-				UMPC_SET_CLR_LOOPBACK,
-				(__u8)(UMPM_UART1_PORT + port_number),
-				1,	/* set */
-				NULL,
-				0);
-}
-
-static int TIClearLoopBack (struct edgeport_port *port)
-{
-	int port_number = port->port->number - port->port->serial->minor;
-
-	dbg ("%s", __func__);
-
-	return TIWriteCommandSync (port->port->serial->dev,
-				UMPC_SET_CLR_LOOPBACK,
-				(__u8)(UMPM_UART1_PORT + port_number),
-				0,	/* clear */
-				NULL,
-				0);
-}
-
-static int TISetBreak (struct edgeport_port *port)
-{
-	int port_number = port->port->number - port->port->serial->minor;
-
-	dbg ("%s", __func__);
-
-	return TIWriteCommandSync (port->port->serial->dev,
-				UMPC_SET_CLR_BREAK,
-				(__u8)(UMPM_UART1_PORT + port_number),
-				1,	/* set */
-				NULL,
-				0);
-}
-
-static int TIClearBreak (struct edgeport_port *port)
-{
-	int port_number = port->port->number - port->port->serial->minor;
-
-	dbg ("%s", __func__);
-
-	return TIWriteCommandSync (port->port->serial->dev,
-				UMPC_SET_CLR_BREAK,
-				(__u8)(UMPM_UART1_PORT + port_number),
-				0,	/* clear */
-				NULL,
-				0);
-}
-
-static int TIRestoreMCR (struct edgeport_port *port, __u8 mcr)
+static int restore_mcr(struct edgeport_port *port, __u8 mcr)
 {
 	int status = 0;
 
-	dbg ("%s - %x", __func__, mcr);
-
-	if (mcr & MCR_DTR)
-		status = TISetDtr (port);
-	else
-		status = TIClearDtr (port);
+	dbg("%s - %x", __func__, mcr);
 
+	status = ti_do_config(port, UMPC_SET_CLR_DTR, mcr & MCR_DTR);
 	if (status)
 		return status;
-
-	if (mcr & MCR_RTS)
-		status = TISetRts (port);
-	else
-		status = TIClearRts (port);
-
+	status = ti_do_config(port, UMPC_SET_CLR_RTS, mcr & MCR_RTS);
 	if (status)
 		return status;
-
-	if (mcr & MCR_LOOPBACK)
-		status = TISetLoopBack (port);
-	else
-		status = TIClearLoopBack (port);
-
-	return status;
+	return ti_do_config(port, UMPC_SET_CLR_LOOPBACK, mcr & MCR_LOOPBACK);
 }
 
 
 
 /* Convert TI LSR to standard UART flags */
-static __u8 MapLineStatus (__u8 ti_lsr)
+static __u8 map_line_status(__u8 ti_lsr)
 {
 	__u8 lsr = 0;
 
@@ -1627,22 +1498,23 @@ static __u8 MapLineStatus (__u8 ti_lsr)
 	MAP_FLAG(UMP_UART_LSR_PE_MASK, LSR_PAR_ERR)	/* parity error */
 	MAP_FLAG(UMP_UART_LSR_FE_MASK, LSR_FRM_ERR)	/* framing error */
 	MAP_FLAG(UMP_UART_LSR_BR_MASK, LSR_BREAK)	/* break detected */
-	MAP_FLAG(UMP_UART_LSR_RX_MASK, LSR_RX_AVAIL)	/* receive data available */
-	MAP_FLAG(UMP_UART_LSR_TX_MASK, LSR_TX_EMPTY)	/* transmit holding register empty */
+	MAP_FLAG(UMP_UART_LSR_RX_MASK, LSR_RX_AVAIL)	/* rx data available */
+	MAP_FLAG(UMP_UART_LSR_TX_MASK, LSR_TX_EMPTY)	/* tx hold reg empty */
 
 #undef MAP_FLAG
 
 	return lsr;
 }
 
-static void handle_new_msr (struct edgeport_port *edge_port, __u8 msr)
+static void handle_new_msr(struct edgeport_port *edge_port, __u8 msr)
 {
 	struct async_icount *icount;
 	struct tty_struct *tty;
 
-	dbg ("%s - %02x", __func__, msr);
+	dbg("%s - %02x", __func__, msr);
 
-	if (msr & (EDGEPORT_MSR_DELTA_CTS | EDGEPORT_MSR_DELTA_DSR | EDGEPORT_MSR_DELTA_RI | EDGEPORT_MSR_DELTA_CD)) {
+	if (msr & (EDGEPORT_MSR_DELTA_CTS | EDGEPORT_MSR_DELTA_DSR |
+			EDGEPORT_MSR_DELTA_RI | EDGEPORT_MSR_DELTA_CD)) {
 		icount = &edge_port->icount;
 
 		/* update input line counters */
@@ -1654,13 +1526,13 @@ static void handle_new_msr (struct edgeport_port *edge_port, __u8 msr)
 			icount->dcd++;
 		if (msr & EDGEPORT_MSR_DELTA_RI)
 			icount->rng++;
-		wake_up_interruptible (&edge_port->delta_msr_wait);
+		wake_up_interruptible(&edge_port->delta_msr_wait);
 	}
 
 	/* Save the new modem status */
 	edge_port->shadow_msr = msr & 0xf0;
 
-	tty = edge_port->port->tty;
+	tty = edge_port->port->port.tty;
 	/* handle CTS flow control */
 	if (tty && C_CRTSCTS(tty)) {
 		if (msr & EDGEPORT_MSR_CTS) {
@@ -1674,26 +1546,28 @@ static void handle_new_msr (struct edgeport_port *edge_port, __u8 msr)
 	return;
 }
 
-static void handle_new_lsr (struct edgeport_port *edge_port, int lsr_data, __u8 lsr, __u8 data)
+static void handle_new_lsr(struct edgeport_port *edge_port, int lsr_data,
+							__u8 lsr, __u8 data)
 {
 	struct async_icount *icount;
-	__u8 new_lsr = (__u8)(lsr & (__u8)(LSR_OVER_ERR | LSR_PAR_ERR | LSR_FRM_ERR | LSR_BREAK));
+	__u8 new_lsr = (__u8)(lsr & (__u8)(LSR_OVER_ERR | LSR_PAR_ERR |
+						LSR_FRM_ERR | LSR_BREAK));
 
-	dbg ("%s - %02x", __func__, new_lsr);
+	dbg("%s - %02x", __func__, new_lsr);
 
 	edge_port->shadow_lsr = lsr;
 
-	if (new_lsr & LSR_BREAK) {
+	if (new_lsr & LSR_BREAK)
 		/*
 		 * Parity and Framing errors only count if they
 		 * occur exclusive of a break being received.
 		 */
 		new_lsr &= (__u8)(LSR_OVER_ERR | LSR_BREAK);
-	}
 
 	/* Place LSR data byte into Rx buffer */
-	if (lsr_data && edge_port->port->tty)
-		edge_tty_recv(&edge_port->port->dev, edge_port->port->tty, &data, 1);
+	if (lsr_data && edge_port->port->port.tty)
+		edge_tty_recv(&edge_port->port->dev, edge_port->port->port.tty,
+								&data, 1);
 
 	/* update input line counters */
 	icount = &edge_port->icount;
@@ -1708,7 +1582,7 @@ static void handle_new_lsr (struct edgeport_port *edge_port, int lsr_data, __u8
 }
 
 
-static void edge_interrupt_callback (struct urb *urb)
+static void edge_interrupt_callback(struct urb *urb)
 {
 	struct edgeport_serial *edge_serial = urb->context;
 	struct usb_serial_port *port;
@@ -1742,66 +1616,71 @@ static void edge_interrupt_callback (struct urb *urb)
 	}
 
 	if (!length) {
-		dbg ("%s - no data in urb", __func__);
+		dbg("%s - no data in urb", __func__);
 		goto exit;
 	}
-		
-	usb_serial_debug_data(debug, &edge_serial->serial->dev->dev, __func__, length, data);
-		
+
+	usb_serial_debug_data(debug, &edge_serial->serial->dev->dev,
+						__func__, length, data);
+
 	if (length != 2) {
-		dbg ("%s - expecting packet of size 2, got %d", __func__, length);
+		dbg("%s - expecting packet of size 2, got %d",
+							__func__, length);
 		goto exit;
 	}
 
-	port_number = TIUMP_GET_PORT_FROM_CODE (data[0]);
-	function    = TIUMP_GET_FUNC_FROM_CODE (data[0]);
-	dbg ("%s - port_number %d, function %d, info 0x%x",
+	port_number = TIUMP_GET_PORT_FROM_CODE(data[0]);
+	function    = TIUMP_GET_FUNC_FROM_CODE(data[0]);
+	dbg("%s - port_number %d, function %d, info 0x%x",
 	     __func__, port_number, function, data[1]);
 	port = edge_serial->serial->port[port_number];
 	edge_port = usb_get_serial_port_data(port);
 	if (!edge_port) {
-		dbg ("%s - edge_port not found", __func__);
+		dbg("%s - edge_port not found", __func__);
 		return;
 	}
 	switch (function) {
 	case TIUMP_INTERRUPT_CODE_LSR:
-		lsr = MapLineStatus(data[1]);
+		lsr = map_line_status(data[1]);
 		if (lsr & UMP_UART_LSR_DATA_MASK) {
-			/* Save the LSR event for bulk read completion routine */
-			dbg ("%s - LSR Event Port %u LSR Status = %02x",
+			/* Save the LSR event for bulk read
+			   completion routine */
+			dbg("%s - LSR Event Port %u LSR Status = %02x",
 			     __func__, port_number, lsr);
 			edge_port->lsr_event = 1;
 			edge_port->lsr_mask = lsr;
 		} else {
-			dbg ("%s - ===== Port %d LSR Status = %02x ======",
+			dbg("%s - ===== Port %d LSR Status = %02x ======",
 			     __func__, port_number, lsr);
-			handle_new_lsr (edge_port, 0, lsr, 0);
+			handle_new_lsr(edge_port, 0, lsr, 0);
 		}
 		break;
 
-	case TIUMP_INTERRUPT_CODE_MSR:	// MSR
+	case TIUMP_INTERRUPT_CODE_MSR:	/* MSR */
 		/* Copy MSR from UMP */
 		msr = data[1];
-		dbg ("%s - ===== Port %u MSR Status = %02x ======\n",
+		dbg("%s - ===== Port %u MSR Status = %02x ======\n",
 		     __func__, port_number, msr);
-		handle_new_msr (edge_port, msr);
+		handle_new_msr(edge_port, msr);
 		break;
 
 	default:
-		dev_err (&urb->dev->dev, "%s - Unknown Interrupt code from UMP %x\n",
-			 __func__, data[1]);
+		dev_err(&urb->dev->dev,
+			"%s - Unknown Interrupt code from UMP %x\n",
+			__func__, data[1]);
 		break;
-		
+
 	}
 
 exit:
-	retval = usb_submit_urb (urb, GFP_ATOMIC);
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
-		dev_err (&urb->dev->dev, "%s - usb_submit_urb failed with result %d\n",
+		dev_err(&urb->dev->dev,
+			"%s - usb_submit_urb failed with result %d\n",
 			 __func__, retval);
 }
 
-static void edge_bulk_in_callback (struct urb *urb)
+static void edge_bulk_in_callback(struct urb *urb)
 {
 	struct edgeport_port *edge_port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
@@ -1824,15 +1703,16 @@ static void edge_bulk_in_callback (struct urb *urb)
 		    __func__, status);
 		return;
 	default:
-		dev_err (&urb->dev->dev,"%s - nonzero read bulk status received: %d\n",
-		     __func__, status);
+		dev_err(&urb->dev->dev,
+			"%s - nonzero read bulk status received: %d\n",
+			     __func__, status);
 	}
 
 	if (status == -EPIPE)
 		goto exit;
 
 	if (status) {
-		dev_err(&urb->dev->dev,"%s - stopping read!\n", __func__);
+		dev_err(&urb->dev->dev, "%s - stopping read!\n", __func__);
 		return;
 	}
 
@@ -1840,23 +1720,24 @@ static void edge_bulk_in_callback (struct urb *urb)
 
 	if (edge_port->lsr_event) {
 		edge_port->lsr_event = 0;
-		dbg ("%s ===== Port %u LSR Status = %02x, Data = %02x ======",
+		dbg("%s ===== Port %u LSR Status = %02x, Data = %02x ======",
 		     __func__, port_number, edge_port->lsr_mask, *data);
-		handle_new_lsr (edge_port, 1, edge_port->lsr_mask, *data);
+		handle_new_lsr(edge_port, 1, edge_port->lsr_mask, *data);
 		/* Adjust buffer length/pointer */
 		--urb->actual_length;
 		++data;
 	}
 
-	tty = edge_port->port->tty;
+	tty = edge_port->port->port.tty;
 	if (tty && urb->actual_length) {
-		usb_serial_debug_data(debug, &edge_port->port->dev, __func__, urb->actual_length, data);
-
-		if (edge_port->close_pending) {
-			dbg ("%s - close is pending, dropping data on the floor.", __func__);
-		} else {
-			edge_tty_recv(&edge_port->port->dev, tty, data, urb->actual_length);
-		}
+		usb_serial_debug_data(debug, &edge_port->port->dev,
+					__func__, urb->actual_length, data);
+		if (edge_port->close_pending)
+			dbg("%s - close pending, dropping data on the floor",
+								__func__);
+		else
+			edge_tty_recv(&edge_port->port->dev, tty, data,
+							urb->actual_length);
 		edge_port->icount.rx += urb->actual_length;
 	}
 
@@ -1871,37 +1752,31 @@ exit:
 	}
 	spin_unlock(&edge_port->ep_lock);
 	if (retval)
-		dev_err (&urb->dev->dev, "%s - usb_submit_urb failed with result %d\n",
+		dev_err(&urb->dev->dev,
+			"%s - usb_submit_urb failed with result %d\n",
 			 __func__, retval);
 }
 
-static void edge_tty_recv(struct device *dev, struct tty_struct *tty, unsigned char *data, int length)
+static void edge_tty_recv(struct device *dev, struct tty_struct *tty,
+					unsigned char *data, int length)
 {
-	int cnt;
-
-	do {
-		cnt = tty_buffer_request_room(tty, length);
-		if (cnt < length) {
-			dev_err(dev, "%s - dropping data, %d bytes lost\n",
-				__func__, length - cnt);
-			if(cnt == 0)
-				break;
-		}
-		tty_insert_flip_string(tty, data, cnt);
-		data += cnt;
-		length -= cnt;
-	} while (length > 0);
+	int queued;
 
+	tty_buffer_request_room(tty, length);
+	queued = tty_insert_flip_string(tty, data, length);
+	if (queued < length)
+		dev_err(dev, "%s - dropping data, %d bytes lost\n",
+			__func__, length - queued);
 	tty_flip_buffer_push(tty);
 }
 
-static void edge_bulk_out_callback (struct urb *urb)
+static void edge_bulk_out_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	int status = urb->status;
 
-	dbg ("%s - port %d", __func__, port->number);
+	dbg("%s - port %d", __func__, port->number);
 
 	edge_port->ep_write_urb_in_use = 0;
 
@@ -1922,10 +1797,11 @@ static void edge_bulk_out_callback (struct urb *urb)
 	}
 
 	/* send any buffered data */
-	edge_send(port);
+	edge_send(port->port.tty);	/* FIXME: tty lifetime ? */
 }
 
-static int edge_open (struct usb_serial_port *port, struct file * filp)
+static int edge_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	struct edgeport_serial *edge_serial;
@@ -1941,122 +1817,125 @@ static int edge_open (struct usb_serial_port *port, struct file * filp)
 	if (edge_port == NULL)
 		return -ENODEV;
 
-	port->tty->low_latency = low_latency;
+	if (tty)
+		tty->low_latency = low_latency;
 
 	port_number = port->number - port->serial->minor;
 	switch (port_number) {
-		case 0:
-			edge_port->uart_base = UMPMEM_BASE_UART1;
-			edge_port->dma_address = UMPD_OEDB1_ADDRESS;
-			break;
-		case 1:
-			edge_port->uart_base = UMPMEM_BASE_UART2;
-			edge_port->dma_address = UMPD_OEDB2_ADDRESS;
-			break;
-		default:
-			dev_err (&port->dev, "Unknown port number!!!\n");
-			return -ENODEV;
+	case 0:
+		edge_port->uart_base = UMPMEM_BASE_UART1;
+		edge_port->dma_address = UMPD_OEDB1_ADDRESS;
+		break;
+	case 1:
+		edge_port->uart_base = UMPMEM_BASE_UART2;
+		edge_port->dma_address = UMPD_OEDB2_ADDRESS;
+		break;
+	default:
+		dev_err(&port->dev, "Unknown port number!!!\n");
+		return -ENODEV;
 	}
 
-	dbg ("%s - port_number = %d, uart_base = %04x, dma_address = %04x",
-	     __func__, port_number, edge_port->uart_base, edge_port->dma_address);
+	dbg("%s - port_number = %d, uart_base = %04x, dma_address = %04x",
+				__func__, port_number, edge_port->uart_base,
+				edge_port->dma_address);
 
 	dev = port->serial->dev;
 
-	memset (&(edge_port->icount), 0x00, sizeof(edge_port->icount));
-	init_waitqueue_head (&edge_port->delta_msr_wait);
+	memset(&(edge_port->icount), 0x00, sizeof(edge_port->icount));
+	init_waitqueue_head(&edge_port->delta_msr_wait);
 
 	/* turn off loopback */
-	status = TIClearLoopBack (edge_port);
+	status = ti_do_config(edge_port, UMPC_SET_CLR_LOOPBACK, 0);
 	if (status) {
-		dev_err(&port->dev,"%s - cannot send clear loopback command, %d\n",
+		dev_err(&port->dev,
+				"%s - cannot send clear loopback command, %d\n",
 			__func__, status);
 		return status;
 	}
-	
+
 	/* set up the port settings */
-	edge_set_termios (port, port->tty->termios);
+	if (tty)
+		edge_set_termios(tty, port, tty->termios);
 
 	/* open up the port */
 
 	/* milliseconds to timeout for DMA transfer */
 	transaction_timeout = 2;
 
-	edge_port->ump_read_timeout = max (20, ((transaction_timeout * 3) / 2) );
+	edge_port->ump_read_timeout =
+				max(20, ((transaction_timeout * 3) / 2));
 
-	// milliseconds to timeout for DMA transfer
-	open_settings = (u8)(UMP_DMA_MODE_CONTINOUS | 
-			     UMP_PIPE_TRANS_TIMEOUT_ENA | 
+	/* milliseconds to timeout for DMA transfer */
+	open_settings = (u8)(UMP_DMA_MODE_CONTINOUS |
+			     UMP_PIPE_TRANS_TIMEOUT_ENA |
 			     (transaction_timeout << 2));
 
-	dbg ("%s - Sending UMPC_OPEN_PORT", __func__);
+	dbg("%s - Sending UMPC_OPEN_PORT", __func__);
 
 	/* Tell TI to open and start the port */
-	status = TIWriteCommandSync (dev,
-					UMPC_OPEN_PORT,
-					(u8)(UMPM_UART1_PORT + port_number),
-					open_settings,
-					NULL,
-					0);
+	status = send_cmd(dev, UMPC_OPEN_PORT,
+		(u8)(UMPM_UART1_PORT + port_number), open_settings, NULL, 0);
 	if (status) {
-		dev_err(&port->dev,"%s - cannot send open command, %d\n", __func__, status);
+		dev_err(&port->dev, "%s - cannot send open command, %d\n",
+							__func__, status);
 		return status;
 	}
 
 	/* Start the DMA? */
-	status = TIWriteCommandSync (dev,
-					UMPC_START_PORT,
-					(u8)(UMPM_UART1_PORT + port_number),
-					0,
-					NULL,
-					0);
+	status = send_cmd(dev, UMPC_START_PORT,
+		(u8)(UMPM_UART1_PORT + port_number), 0, NULL, 0);
 	if (status) {
-		dev_err(&port->dev,"%s - cannot send start DMA command, %d\n", __func__, status);
+		dev_err(&port->dev, "%s - cannot send start DMA command, %d\n",
+							__func__, status);
 		return status;
 	}
 
 	/* Clear TX and RX buffers in UMP */
-	status = TIPurgeDataSync (port, UMP_PORT_DIR_OUT | UMP_PORT_DIR_IN);
+	status = purge_port(port, UMP_PORT_DIR_OUT | UMP_PORT_DIR_IN);
 	if (status) {
-		dev_err(&port->dev,"%s - cannot send clear buffers command, %d\n", __func__, status);
+		dev_err(&port->dev,
+			"%s - cannot send clear buffers command, %d\n",
+			__func__, status);
 		return status;
 	}
 
 	/* Read Initial MSR */
-	status = TIReadVendorRequestSync (dev,
-					UMPC_READ_MSR,	// Request
-					0,		// wValue
-					(__u16)(UMPM_UART1_PORT + port_number),	// wIndex (Address)
-					&edge_port->shadow_msr,			// TransferBuffer
-					1);					// TransferBufferLength
+	status = ti_vread_sync(dev, UMPC_READ_MSR, 0,
+				(__u16)(UMPM_UART1_PORT + port_number),
+				&edge_port->shadow_msr, 1);
 	if (status) {
- 		dev_err(&port->dev,"%s - cannot send read MSR command, %d\n", __func__, status);
+		dev_err(&port->dev, "%s - cannot send read MSR command, %d\n",
+							__func__, status);
 		return status;
 	}
 
-	dbg ("ShadowMSR 0x%X", edge_port->shadow_msr);
- 
+	dbg("ShadowMSR 0x%X", edge_port->shadow_msr);
+
 	/* Set Initial MCR */
 	edge_port->shadow_mcr = MCR_RTS | MCR_DTR;
-	dbg ("ShadowMCR 0x%X", edge_port->shadow_mcr);
+	dbg("ShadowMCR 0x%X", edge_port->shadow_mcr);
 
 	edge_serial = edge_port->edge_serial;
 	if (mutex_lock_interruptible(&edge_serial->es_lock))
 		return -ERESTARTSYS;
 	if (edge_serial->num_ports_open == 0) {
-		/* we are the first port to be opened, let's post the interrupt urb */
+		/* we are the first port to open, post the interrupt urb */
 		urb = edge_serial->serial->port[0]->interrupt_in_urb;
 		if (!urb) {
-			dev_err (&port->dev, "%s - no interrupt urb present, exiting\n", __func__);
+			dev_err(&port->dev,
+				"%s - no interrupt urb present, exiting\n",
+				__func__);
 			status = -EINVAL;
 			goto release_es_lock;
 		}
 		urb->complete = edge_interrupt_callback;
 		urb->context = edge_serial;
 		urb->dev = dev;
-		status = usb_submit_urb (urb, GFP_KERNEL);
+		status = usb_submit_urb(urb, GFP_KERNEL);
 		if (status) {
-			dev_err (&port->dev, "%s - usb_submit_urb failed with value %d\n", __func__, status);
+			dev_err(&port->dev,
+				"%s - usb_submit_urb failed with value %d\n",
+					__func__, status);
 			goto release_es_lock;
 		}
 	}
@@ -2065,13 +1944,14 @@ static int edge_open (struct usb_serial_port *port, struct file * filp)
 	 * reset the data toggle on the bulk endpoints to work around bug in
 	 * host controllers where things get out of sync some times
 	 */
-	usb_clear_halt (dev, port->write_urb->pipe);
-	usb_clear_halt (dev, port->read_urb->pipe);
+	usb_clear_halt(dev, port->write_urb->pipe);
+	usb_clear_halt(dev, port->read_urb->pipe);
 
 	/* start up our bulk read urb */
 	urb = port->read_urb;
 	if (!urb) {
-		dev_err (&port->dev, "%s - no read urb present, exiting\n", __func__);
+		dev_err(&port->dev, "%s - no read urb present, exiting\n",
+								__func__);
 		status = -EINVAL;
 		goto unlink_int_urb;
 	}
@@ -2079,9 +1959,11 @@ static int edge_open (struct usb_serial_port *port, struct file * filp)
 	urb->complete = edge_bulk_in_callback;
 	urb->context = edge_port;
 	urb->dev = dev;
-	status = usb_submit_urb (urb, GFP_KERNEL);
+	status = usb_submit_urb(urb, GFP_KERNEL);
 	if (status) {
-		dev_err (&port->dev, "%s - read bulk usb_submit_urb failed with value %d\n", __func__, status);
+		dev_err(&port->dev,
+			"%s - read bulk usb_submit_urb failed with value %d\n",
+				__func__, status);
 		goto unlink_int_urb;
 	}
 
@@ -2099,7 +1981,8 @@ release_es_lock:
 	return status;
 }
 
-static void edge_close (struct usb_serial_port *port, struct file *filp)
+static void edge_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct edgeport_serial *edge_serial;
 	struct edgeport_port *edge_port;
@@ -2107,18 +1990,18 @@ static void edge_close (struct usb_serial_port *port, struct file *filp)
 	int status;
 
 	dbg("%s - port %d", __func__, port->number);
-			 
+
 	edge_serial = usb_get_serial_data(port->serial);
 	edge_port = usb_get_serial_port_data(port);
-	if ((edge_serial == NULL) || (edge_port == NULL))
+	if (edge_serial == NULL || edge_port == NULL)
 		return;
-	
-	/* The bulkreadcompletion routine will check 
+
+	/* The bulkreadcompletion routine will check
 	 * this flag and dump add read data */
 	edge_port->close_pending = 1;
 
 	/* chase the port close and flush */
-	TIChasePort (edge_port, (HZ*closing_wait)/100, 1);
+	chase_port(edge_port, (HZ * closing_wait) / 100, 1);
 
 	usb_kill_urb(port->read_urb);
 	usb_kill_urb(port->write_urb);
@@ -2128,7 +2011,7 @@ static void edge_close (struct usb_serial_port *port, struct file *filp)
 	 * send a close port command to it */
 	dbg("%s - send umpc_close_port", __func__);
 	port_number = port->number - port->serial->minor;
-	status = TIWriteCommandSync (port->serial->dev,
+	status = send_cmd(port->serial->dev,
 				     UMPC_CLOSE_PORT,
 				     (__u8)(UMPM_UART1_PORT + port_number),
 				     0,
@@ -2147,7 +2030,8 @@ static void edge_close (struct usb_serial_port *port, struct file *filp)
 	dbg("%s - exited", __func__);
 }
 
-static int edge_write (struct usb_serial_port *port, const unsigned char *data, int count)
+static int edge_write(struct tty_struct *tty, struct usb_serial_port *port,
+				const unsigned char *data, int count)
 {
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	unsigned long flags;
@@ -2168,16 +2052,16 @@ static int edge_write (struct usb_serial_port *port, const unsigned char *data,
 	count = edge_buf_put(edge_port->ep_out_buf, data, count);
 	spin_unlock_irqrestore(&edge_port->ep_lock, flags);
 
-	edge_send(port);
+	edge_send(tty);
 
 	return count;
 }
 
-static void edge_send(struct usb_serial_port *port)
+static void edge_send(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	int count, result;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
-	struct tty_struct *tty = port->tty;
 	unsigned long flags;
 
 
@@ -2203,11 +2087,12 @@ static void edge_send(struct usb_serial_port *port)
 
 	spin_unlock_irqrestore(&edge_port->ep_lock, flags);
 
-	usb_serial_debug_data(debug, &port->dev, __func__, count, port->write_urb->transfer_buffer);
+	usb_serial_debug_data(debug, &port->dev, __func__, count,
+				port->write_urb->transfer_buffer);
 
 	/* set up our urb */
-	usb_fill_bulk_urb (port->write_urb, port->serial->dev,
-			   usb_sndbulkpipe (port->serial->dev,
+	usb_fill_bulk_urb(port->write_urb, port->serial->dev,
+			   usb_sndbulkpipe(port->serial->dev,
 					    port->bulk_out_endpointAddress),
 			   port->write_urb->transfer_buffer, count,
 			   edge_bulk_out_callback,
@@ -2216,23 +2101,23 @@ static void edge_send(struct usb_serial_port *port)
 	/* send the data out the bulk port */
 	result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
 	if (result) {
-		dev_err(&port->dev, "%s - failed submitting write urb, error %d\n", __func__, result);
+		dev_err(&port->dev,
+			"%s - failed submitting write urb, error %d\n",
+				__func__, result);
 		edge_port->ep_write_urb_in_use = 0;
-		// TODO: reschedule edge_send
-	} else {
+		/* TODO: reschedule edge_send */
+	} else
 		edge_port->icount.tx += count;
-	}
 
 	/* wakeup any process waiting for writes to complete */
 	/* there is now more room in the buffer for new writes */
-	if (tty) {
-		/* let the tty driver wakeup if it has a special write_wakeup function */
+	if (tty)
 		tty_wakeup(tty);
-	}
 }
 
-static int edge_write_room (struct usb_serial_port *port)
+static int edge_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	int room = 0;
 	unsigned long flags;
@@ -2240,9 +2125,9 @@ static int edge_write_room (struct usb_serial_port *port)
 	dbg("%s - port %d", __func__, port->number);
 
 	if (edge_port == NULL)
-		return -ENODEV;
+		return 0;
 	if (edge_port->close_pending == 1)
-		return -ENODEV;
+		return 0;
 
 	spin_lock_irqsave(&edge_port->ep_lock, flags);
 	room = edge_buf_space_avail(edge_port->ep_out_buf);
@@ -2252,8 +2137,9 @@ static int edge_write_room (struct usb_serial_port *port)
 	return room;
 }
 
-static int edge_chars_in_buffer (struct usb_serial_port *port)
+static int edge_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	int chars = 0;
 	unsigned long flags;
@@ -2261,22 +2147,22 @@ static int edge_chars_in_buffer (struct usb_serial_port *port)
 	dbg("%s - port %d", __func__, port->number);
 
 	if (edge_port == NULL)
-		return -ENODEV;
+		return 0;
 	if (edge_port->close_pending == 1)
-		return -ENODEV;
+		return 0;
 
 	spin_lock_irqsave(&edge_port->ep_lock, flags);
 	chars = edge_buf_data_avail(edge_port->ep_out_buf);
 	spin_unlock_irqrestore(&edge_port->ep_lock, flags);
 
-	dbg ("%s - returns %d", __func__, chars);
+	dbg("%s - returns %d", __func__, chars);
 	return chars;
 }
 
-static void edge_throttle (struct usb_serial_port *port)
+static void edge_throttle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	int status;
 
 	dbg("%s - port %d", __func__, port->number);
@@ -2284,19 +2170,14 @@ static void edge_throttle (struct usb_serial_port *port)
 	if (edge_port == NULL)
 		return;
 
-	tty = port->tty;
-	if (!tty) {
-		dbg ("%s - no tty available", __func__);
-		return;
-	}
-
 	/* if we are implementing XON/XOFF, send the stop character */
 	if (I_IXOFF(tty)) {
 		unsigned char stop_char = STOP_CHAR(tty);
-		status = edge_write (port, &stop_char, 1);
-		if (status <= 0) {
-			dev_err(&port->dev, "%s - failed to write stop character, %d\n", __func__, status);
-		}
+		status = edge_write(tty, port, &stop_char, 1);
+		if (status <= 0)
+			dev_err(&port->dev,
+				"%s - failed to write stop character, %d\n",
+							__func__, status);
 	}
 
 	/* if we are implementing RTS/CTS, stop reads */
@@ -2306,10 +2187,10 @@ static void edge_throttle (struct usb_serial_port *port)
 
 }
 
-static void edge_unthrottle (struct usb_serial_port *port)
+static void edge_unthrottle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	int status;
 
 	dbg("%s - port %d", __func__, port->number);
@@ -2317,27 +2198,23 @@ static void edge_unthrottle (struct usb_serial_port *port)
 	if (edge_port == NULL)
 		return;
 
-	tty = port->tty;
-	if (!tty) {
-		dbg ("%s - no tty available", __func__);
-		return;
-	}
-
 	/* if we are implementing XON/XOFF, send the start character */
 	if (I_IXOFF(tty)) {
 		unsigned char start_char = START_CHAR(tty);
-		status = edge_write (port, &start_char, 1);
-		if (status <= 0) {
-			dev_err(&port->dev, "%s - failed to write start character, %d\n", __func__, status);
-		}
+		status = edge_write(tty, port, &start_char, 1);
+		if (status <= 0)
+			dev_err(&port->dev,
+				"%s - failed to write start character, %d\n",
+							__func__, status);
 	}
-
 	/* if we are implementing RTS/CTS, restart reads */
 	/* are the Edgeport will assert the RTS line */
 	if (C_CRTSCTS(tty)) {
 		status = restart_read(edge_port);
 		if (status)
-			dev_err(&port->dev, "%s - read bulk usb_submit_urb failed with value %d\n", __func__, status);
+			dev_err(&port->dev,
+				"%s - read bulk usb_submit_urb failed: %d\n",
+							__func__, status);
 	}
 
 }
@@ -2378,22 +2255,25 @@ static int restart_read(struct edgeport_port *edge_port)
 	return status;
 }
 
-static void change_port_settings (struct edgeport_port *edge_port, struct ktermios *old_termios)
+static void change_port_settings(struct tty_struct *tty,
+		struct edgeport_port *edge_port, struct ktermios *old_termios)
 {
 	struct ump_uart_config *config;
-	struct tty_struct *tty;
 	int baud;
 	unsigned cflag;
 	int status;
-	int port_number = edge_port->port->number - edge_port->port->serial->minor;
+	int port_number = edge_port->port->number -
+					edge_port->port->serial->minor;
 
 	dbg("%s - port %d", __func__, edge_port->port->number);
 
-	tty = edge_port->port->tty;
+	tty = edge_port->port->port.tty;
 
-	config = kmalloc (sizeof (*config), GFP_KERNEL);
+	config = kmalloc(sizeof(*config), GFP_KERNEL);
 	if (!config) {
-		dev_err (&edge_port->port->dev, "%s - out of memory\n", __func__);
+		*tty->termios = *old_termios;
+		dev_err(&edge_port->port->dev, "%s - out of memory\n",
+								__func__);
 		return;
 	}
 
@@ -2407,22 +2287,22 @@ static void change_port_settings (struct edgeport_port *edge_port, struct ktermi
 	config->bUartMode = (__u8)(edge_port->bUartMode);
 
 	switch (cflag & CSIZE) {
-		case CS5:
-			    config->bDataBits = UMP_UART_CHAR5BITS;
-			    dbg ("%s - data bits = 5", __func__);
-			    break;
-		case CS6:
-			    config->bDataBits = UMP_UART_CHAR6BITS;
-			    dbg ("%s - data bits = 6", __func__);
-			    break;
-		case CS7:
-			    config->bDataBits = UMP_UART_CHAR7BITS;
-			    dbg ("%s - data bits = 7", __func__);
-			    break;
-		default:
-		case CS8:
-			    config->bDataBits = UMP_UART_CHAR8BITS;
-			    dbg ("%s - data bits = 8", __func__);
+	case CS5:
+		    config->bDataBits = UMP_UART_CHAR5BITS;
+		    dbg("%s - data bits = 5", __func__);
+		    break;
+	case CS6:
+		    config->bDataBits = UMP_UART_CHAR6BITS;
+		    dbg("%s - data bits = 6", __func__);
+		    break;
+	case CS7:
+		    config->bDataBits = UMP_UART_CHAR7BITS;
+		    dbg("%s - data bits = 7", __func__);
+		    break;
+	default:
+	case CS8:
+		    config->bDataBits = UMP_UART_CHAR8BITS;
+		    dbg("%s - data bits = 8", __func__);
 			    break;
 	}
 
@@ -2437,7 +2317,7 @@ static void change_port_settings (struct edgeport_port *edge_port, struct ktermi
 			dbg("%s - parity = even", __func__);
 		}
 	} else {
-		config->bParity = UMP_UART_NOPARITY; 	
+		config->bParity = UMP_UART_NOPARITY;
 		dbg("%s - parity = none", __func__);
 	}
 
@@ -2460,29 +2340,26 @@ static void change_port_settings (struct edgeport_port *edge_port, struct ktermi
 		restart_read(edge_port);
 	}
 
-	/* if we are implementing XON/XOFF, set the start and stop character in the device */
-	if (I_IXOFF(tty) || I_IXON(tty)) {
-		config->cXon  = START_CHAR(tty);
-		config->cXoff = STOP_CHAR(tty);
+	/* if we are implementing XON/XOFF, set the start and stop
+	   character in the device */
+	config->cXon  = START_CHAR(tty);
+	config->cXoff = STOP_CHAR(tty);
 
-		/* if we are implementing INBOUND XON/XOFF */
-		if (I_IXOFF(tty)) {
-			config->wFlags |= UMP_MASK_UART_FLAGS_IN_X;
-			dbg ("%s - INBOUND XON/XOFF is enabled, XON = %2x, XOFF = %2x",
-			     __func__, config->cXon, config->cXoff);
-		} else {
-			dbg ("%s - INBOUND XON/XOFF is disabled", __func__);
-		}
+	/* if we are implementing INBOUND XON/XOFF */
+	if (I_IXOFF(tty)) {
+		config->wFlags |= UMP_MASK_UART_FLAGS_IN_X;
+		dbg("%s - INBOUND XON/XOFF is enabled, XON = %2x, XOFF = %2x",
+		     __func__, config->cXon, config->cXoff);
+	} else
+		dbg("%s - INBOUND XON/XOFF is disabled", __func__);
 
-		/* if we are implementing OUTBOUND XON/XOFF */
-		if (I_IXON(tty)) {
-			config->wFlags |= UMP_MASK_UART_FLAGS_OUT_X;
-			dbg ("%s - OUTBOUND XON/XOFF is enabled, XON = %2x, XOFF = %2x",
-			     __func__, config->cXon, config->cXoff);
-		} else {
-			dbg ("%s - OUTBOUND XON/XOFF is disabled", __func__);
-		}
-	}
+	/* if we are implementing OUTBOUND XON/XOFF */
+	if (I_IXON(tty)) {
+		config->wFlags |= UMP_MASK_UART_FLAGS_OUT_X;
+		dbg("%s - OUTBOUND XON/XOFF is enabled, XON = %2x, XOFF = %2x",
+		     __func__, config->cXon, config->cXoff);
+	} else
+		dbg("%s - OUTBOUND XON/XOFF is disabled", __func__);
 
 	tty->termios->c_cflag &= ~CMSPAR;
 
@@ -2499,63 +2376,53 @@ static void change_port_settings (struct edgeport_port *edge_port, struct ktermi
 
 	/* FIXME: Recompute actual baud from divisor here */
 
-	dbg ("%s - baud rate = %d, wBaudRate = %d", __func__, baud, config->wBaudRate);
+	dbg("%s - baud rate = %d, wBaudRate = %d", __func__, baud,
+							config->wBaudRate);
 
-	dbg ("wBaudRate:   %d", (int)(461550L / config->wBaudRate));
-	dbg ("wFlags:    0x%x", config->wFlags);
-	dbg ("bDataBits:   %d", config->bDataBits);
-	dbg ("bParity:     %d", config->bParity);
-	dbg ("bStopBits:   %d", config->bStopBits);
-	dbg ("cXon:        %d", config->cXon);
-	dbg ("cXoff:       %d", config->cXoff);
-	dbg ("bUartMode:   %d", config->bUartMode);
+	dbg("wBaudRate:   %d", (int)(461550L / config->wBaudRate));
+	dbg("wFlags:    0x%x", config->wFlags);
+	dbg("bDataBits:   %d", config->bDataBits);
+	dbg("bParity:     %d", config->bParity);
+	dbg("bStopBits:   %d", config->bStopBits);
+	dbg("cXon:        %d", config->cXon);
+	dbg("cXoff:       %d", config->cXoff);
+	dbg("bUartMode:   %d", config->bUartMode);
 
 	/* move the word values into big endian mode */
-	cpu_to_be16s (&config->wFlags);
-	cpu_to_be16s (&config->wBaudRate);
+	cpu_to_be16s(&config->wFlags);
+	cpu_to_be16s(&config->wBaudRate);
 
-	status = TIWriteCommandSync (edge_port->port->serial->dev,
-				UMPC_SET_CONFIG,
+	status = send_cmd(edge_port->port->serial->dev, UMPC_SET_CONFIG,
 				(__u8)(UMPM_UART1_PORT + port_number),
-				0,
-				(__u8 *)config,
-				sizeof(*config));
-	if (status) {
-		dbg ("%s - error %d when trying to write config to device",
+				0, (__u8 *)config, sizeof(*config));
+	if (status)
+		dbg("%s - error %d when trying to write config to device",
 		     __func__, status);
-	}
-
-	kfree (config);
-	
+	kfree(config);
 	return;
 }
 
-static void edge_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
+static void edge_set_termios(struct tty_struct *tty, 
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
-	struct tty_struct *tty = port->tty;
-	unsigned int cflag;
-
-	cflag = tty->termios->c_cflag;
 
 	dbg("%s - clfag %08x iflag %08x", __func__,
 	    tty->termios->c_cflag, tty->termios->c_iflag);
 	dbg("%s - old clfag %08x old iflag %08x", __func__,
 	    old_termios->c_cflag, old_termios->c_iflag);
-
 	dbg("%s - port %d", __func__, port->number);
 
 	if (edge_port == NULL)
 		return;
-
 	/* change the port settings to the new ones specified */
-	change_port_settings (edge_port, old_termios);
-
-	return;
+	change_port_settings(tty, edge_port, old_termios);
 }
 
-static int edge_tiocmset (struct usb_serial_port *port, struct file *file, unsigned int set, unsigned int clear)
+static int edge_tiocmset(struct tty_struct *tty, struct file *file,
+					unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	unsigned int mcr;
 	unsigned long flags;
@@ -2581,13 +2448,13 @@ static int edge_tiocmset (struct usb_serial_port *port, struct file *file, unsig
 	edge_port->shadow_mcr = mcr;
 	spin_unlock_irqrestore(&edge_port->ep_lock, flags);
 
-	TIRestoreMCR (edge_port, mcr);
-
+	restore_mcr(edge_port, mcr);
 	return 0;
 }
 
-static int edge_tiocmget(struct usb_serial_port *port, struct file *file)
+static int edge_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	unsigned int result = 0;
 	unsigned int msr;
@@ -2614,7 +2481,8 @@ static int edge_tiocmget(struct usb_serial_port *port, struct file *file)
 	return result;
 }
 
-static int get_serial_info (struct edgeport_port *edge_port, struct serial_struct __user *retinfo)
+static int get_serial_info(struct edgeport_port *edge_port,
+				struct serial_struct __user *retinfo)
 {
 	struct serial_struct tmp;
 
@@ -2632,18 +2500,16 @@ static int get_serial_info (struct edgeport_port *edge_port, struct serial_struc
 	tmp.baud_base		= 9600;
 	tmp.close_delay		= 5*HZ;
 	tmp.closing_wait	= closing_wait;
-//	tmp.custom_divisor	= state->custom_divisor;
-//	tmp.hub6		= state->hub6;
-//	tmp.io_type		= state->io_type;
-
 
 	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
 		return -EFAULT;
 	return 0;
 }
 
-static int edge_ioctl (struct usb_serial_port *port, struct file *file, unsigned int cmd, unsigned long arg)
+static int edge_ioctl(struct tty_struct *tty, struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	struct async_icount cnow;
 	struct async_icount cprev;
@@ -2651,81 +2517,64 @@ static int edge_ioctl (struct usb_serial_port *port, struct file *file, unsigned
 	dbg("%s - port %d, cmd = 0x%x", __func__, port->number, cmd);
 
 	switch (cmd) {
-		case TIOCINQ:
-			dbg("%s - (%d) TIOCINQ", __func__, port->number);
-//			return get_number_bytes_avail(edge_port, (unsigned int *) arg);
-			break;
-
-		case TIOCSERGETLSR:
-			dbg("%s - (%d) TIOCSERGETLSR", __func__, port->number);
-//			return get_lsr_info(edge_port, (unsigned int *) arg);
-			break;
-
-		case TIOCGSERIAL:
-			dbg("%s - (%d) TIOCGSERIAL", __func__, port->number);
-			return get_serial_info(edge_port, (struct serial_struct __user *) arg);
-			break;
-
-		case TIOCSSERIAL:
-			dbg("%s - (%d) TIOCSSERIAL", __func__, port->number);
-			break;
-
-		case TIOCMIWAIT:
-			dbg("%s - (%d) TIOCMIWAIT", __func__, port->number);
-			cprev = edge_port->icount;
-			while (1) {
-				interruptible_sleep_on(&edge_port->delta_msr_wait);
-				/* see if a signal did it */
-				if (signal_pending(current))
-					return -ERESTARTSYS;
-				cnow = edge_port->icount;
-				if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
-				    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
-					return -EIO; /* no change => error */
-				if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
-				    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
-				    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
-				    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts)) ) {
-					return 0;
-				}
-				cprev = cnow;
+	case TIOCGSERIAL:
+		dbg("%s - (%d) TIOCGSERIAL", __func__, port->number);
+		return get_serial_info(edge_port,
+				(struct serial_struct __user *) arg);
+	case TIOCMIWAIT:
+		dbg("%s - (%d) TIOCMIWAIT", __func__, port->number);
+		cprev = edge_port->icount;
+		while (1) {
+			interruptible_sleep_on(&edge_port->delta_msr_wait);
+			/* see if a signal did it */
+			if (signal_pending(current))
+				return -ERESTARTSYS;
+			cnow = edge_port->icount;
+			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
+			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
+				return -EIO; /* no change => error */
+			if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
+			    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
+			    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
+			    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
+				return 0;
 			}
-			/* not reached */
-			break;
-
-		case TIOCGICOUNT:
-			dbg ("%s - (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,
-			     port->number, edge_port->icount.rx, edge_port->icount.tx);
-			if (copy_to_user((void __user *)arg, &edge_port->icount, sizeof(edge_port->icount)))
-				return -EFAULT;
-			return 0;
+			cprev = cnow;
+		}
+		/* not reached */
+		break;
+	case TIOCGICOUNT:
+		dbg("%s - (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,
+		     port->number, edge_port->icount.rx, edge_port->icount.tx);
+		if (copy_to_user((void __user *)arg, &edge_port->icount,
+				sizeof(edge_port->icount)))
+			return -EFAULT;
+		return 0;
 	}
-
 	return -ENOIOCTLCMD;
 }
 
-static void edge_break (struct usb_serial_port *port, int break_state)
+static void edge_break(struct tty_struct *tty, int on)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	int status;
+	int bv = 0;	/* Off */
 
-	dbg ("%s - state = %d", __func__, break_state);
+	dbg("%s - state = %d", __func__, on);
 
 	/* chase the port close */
-	TIChasePort (edge_port, 0, 0);
+	chase_port(edge_port, 0, 0);
 
-	if (break_state == -1) {
-		status = TISetBreak (edge_port);
-	} else {
-		status = TIClearBreak (edge_port);
-	}
-	if (status) {
-		dbg ("%s - error %d sending break set/clear command.",
+	if (on == -1)
+		bv = 1;	/* On */
+	status = ti_do_config(edge_port, UMPC_SET_CLR_BREAK, bv);
+	if (status)
+		dbg("%s - error %d sending break set/clear command.",
 		     __func__, status);
-	}
 }
 
-static int edge_startup (struct usb_serial *serial)
+static int edge_startup(struct usb_serial *serial)
 {
 	struct edgeport_serial *edge_serial;
 	struct edgeport_port *edge_port;
@@ -2745,9 +2594,9 @@ static int edge_startup (struct usb_serial *serial)
 	edge_serial->serial = serial;
 	usb_set_serial_data(serial, edge_serial);
 
-	status = TIDownloadFirmware (edge_serial);
+	status = download_fw(edge_serial);
 	if (status) {
-		kfree (edge_serial);
+		kfree(edge_serial);
 		return status;
 	}
 
@@ -2755,13 +2604,15 @@ static int edge_startup (struct usb_serial *serial)
 	for (i = 0; i < serial->num_ports; ++i) {
 		edge_port = kzalloc(sizeof(struct edgeport_port), GFP_KERNEL);
 		if (edge_port == NULL) {
-			dev_err(&serial->dev->dev, "%s - Out of memory\n", __func__);
+			dev_err(&serial->dev->dev, "%s - Out of memory\n",
+								__func__);
 			goto cleanup;
 		}
 		spin_lock_init(&edge_port->ep_lock);
 		edge_port->ep_out_buf = edge_buf_alloc(EDGE_OUT_BUF_SIZE);
 		if (edge_port->ep_out_buf == NULL) {
-			dev_err(&serial->dev->dev, "%s - Out of memory\n", __func__);
+			dev_err(&serial->dev->dev, "%s - Out of memory\n",
+								__func__);
 			kfree(edge_port);
 			goto cleanup;
 		}
@@ -2770,27 +2621,27 @@ static int edge_startup (struct usb_serial *serial)
 		usb_set_serial_port_data(serial->port[i], edge_port);
 		edge_port->bUartMode = default_uart_mode;
 	}
-	
+
 	return 0;
 
 cleanup:
-	for (--i; i>=0; --i) {
+	for (--i; i >= 0; --i) {
 		edge_port = usb_get_serial_port_data(serial->port[i]);
 		edge_buf_free(edge_port->ep_out_buf);
 		kfree(edge_port);
 		usb_set_serial_port_data(serial->port[i], NULL);
 	}
-	kfree (edge_serial);
+	kfree(edge_serial);
 	usb_set_serial_data(serial, NULL);
 	return -ENOMEM;
 }
 
-static void edge_shutdown (struct usb_serial *serial)
+static void edge_shutdown(struct usb_serial *serial)
 {
 	int i;
 	struct edgeport_port *edge_port;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	for (i = 0; i < serial->num_ports; ++i) {
 		edge_port = usb_get_serial_port_data(serial->port[i]);
@@ -2832,7 +2683,8 @@ static ssize_t store_uart_mode(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(uart_mode, S_IWUSR | S_IRUGO, show_uart_mode, store_uart_mode);
+static DEVICE_ATTR(uart_mode, S_IWUSR | S_IRUGO, show_uart_mode,
+							store_uart_mode);
 
 static int edge_create_sysfs_attrs(struct usb_serial_port *port)
 {
@@ -2902,9 +2754,9 @@ static void edge_buf_free(struct edge_buf *eb)
 
 static void edge_buf_clear(struct edge_buf *eb)
 {
-        if (eb != NULL)
-                eb->buf_get = eb->buf_put;
-                /* equivalent to a get of all data available */
+	if (eb != NULL)
+		eb->buf_get = eb->buf_put;
+	/* equivalent to a get of all data available */
 }
 
 
@@ -2917,10 +2769,9 @@ static void edge_buf_clear(struct edge_buf *eb)
 
 static unsigned int edge_buf_data_avail(struct edge_buf *eb)
 {
-	if (eb != NULL)
-		return ((eb->buf_size + eb->buf_put - eb->buf_get) % eb->buf_size);
-	else
+	if (eb == NULL)
 		return 0;
+	return ((eb->buf_size + eb->buf_put - eb->buf_get) % eb->buf_size);
 }
 
 
@@ -2933,10 +2784,9 @@ static unsigned int edge_buf_data_avail(struct edge_buf *eb)
 
 static unsigned int edge_buf_space_avail(struct edge_buf *eb)
 {
-	if (eb != NULL)
-		return ((eb->buf_size + eb->buf_get - eb->buf_put - 1) % eb->buf_size);
-	else
+	if (eb == NULL)
 		return 0;
+	return ((eb->buf_size + eb->buf_get - eb->buf_put - 1) % eb->buf_size);
 }
 
 
@@ -3093,7 +2943,7 @@ static int __init edgeport_init(void)
 	if (retval)
 		goto failed_2port_device_register;
 	retval = usb_register(&io_driver);
-	if (retval) 
+	if (retval)
 		goto failed_usb_register;
 	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
@@ -3105,11 +2955,11 @@ failed_1port_device_register:
 	return retval;
 }
 
-static void __exit edgeport_exit (void)
+static void __exit edgeport_exit(void)
 {
-	usb_deregister (&io_driver);
-	usb_serial_deregister (&edgeport_1port_device);
-	usb_serial_deregister (&edgeport_2port_device);
+	usb_deregister(&io_driver);
+	usb_serial_deregister(&edgeport_1port_device);
+	usb_serial_deregister(&edgeport_2port_device);
 }
 
 module_init(edgeport_init);
@@ -3130,8 +2980,8 @@ module_param(closing_wait, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(closing_wait, "Maximum wait for data to drain, in .01 secs");
 
 module_param(ignore_cpu_rev, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(ignore_cpu_rev, "Ignore the cpu revision when connecting to a device");
+MODULE_PARM_DESC(ignore_cpu_rev,
+			"Ignore the cpu revision when connecting to a device");
 
 module_param(default_uart_mode, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(default_uart_mode, "Default uart_mode, 0=RS232, ...");
-
diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
index ea924dc..437982a 100644
--- a/drivers/usb/serial/ipaq.c
+++ b/drivers/usb/serial/ipaq.c
@@ -74,19 +74,21 @@ static int connect_retries = KP_RETRIES;
 static int initial_wait;
 
 /* Function prototypes for an ipaq */
-static int  ipaq_open (struct usb_serial_port *port, struct file *filp);
-static void ipaq_close (struct usb_serial_port *port, struct file *filp);
-static int  ipaq_startup (struct usb_serial *serial);
-static void ipaq_shutdown (struct usb_serial *serial);
-static int ipaq_write(struct usb_serial_port *port, const unsigned char *buf,
-		       int count);
+static int  ipaq_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static void ipaq_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static int  ipaq_startup(struct usb_serial *serial);
+static void ipaq_shutdown(struct usb_serial *serial);
+static int ipaq_write(struct tty_struct *tty, struct usb_serial_port *port,
+			const unsigned char *buf, int count);
 static int ipaq_write_bulk(struct usb_serial_port *port, const unsigned char *buf,
-			   int count);
+			int count);
 static void ipaq_write_gather(struct usb_serial_port *port);
 static void ipaq_read_bulk_callback (struct urb *urb);
 static void ipaq_write_bulk_callback(struct urb *urb);
-static int ipaq_write_room(struct usb_serial_port *port);
-static int ipaq_chars_in_buffer(struct usb_serial_port *port);
+static int ipaq_write_room(struct tty_struct *tty);
+static int ipaq_chars_in_buffer(struct tty_struct *tty);
 static void ipaq_destroy_lists(struct usb_serial_port *port);
 
 
@@ -586,7 +588,8 @@ static spinlock_t	write_list_lock;
 static int		bytes_in;
 static int		bytes_out;
 
-static int ipaq_open(struct usb_serial_port *port, struct file *filp)
+static int ipaq_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial	*serial = port->serial;
 	struct ipaq_private	*priv;
@@ -632,10 +635,12 @@ static int ipaq_open(struct usb_serial_port *port, struct file *filp)
 	 * discipline instead of queueing.
 	 */
 
-	port->tty->low_latency = 1;
-	port->tty->raw = 1;
-	port->tty->real_raw = 1;
-
+	if (tty) {
+		tty->low_latency = 1;
+		/* FIXME: These two are bogus */
+		tty->raw = 1;
+		tty->real_raw = 1;
+	}
 	/*
 	 * Lose the small buffers usbserial provides. Make larger ones.
 	 */
@@ -708,7 +713,8 @@ error:
 }
 
 
-static void ipaq_close(struct usb_serial_port *port, struct file *filp)
+static void ipaq_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct ipaq_private	*priv = usb_get_serial_port_data(port);
 
@@ -745,7 +751,7 @@ static void ipaq_read_bulk_callback(struct urb *urb)
 
 	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (tty && urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
@@ -764,8 +770,8 @@ static void ipaq_read_bulk_callback(struct urb *urb)
 	return;
 }
 
-static int ipaq_write(struct usb_serial_port *port, const unsigned char *buf,
-		       int count)
+static int ipaq_write(struct tty_struct *tty, struct usb_serial_port *port,
+			const unsigned char *buf, int count)
 {
 	const unsigned char	*current_position = buf;
 	int			bytes_sent = 0;
@@ -899,16 +905,18 @@ static void ipaq_write_bulk_callback(struct urb *urb)
 	usb_serial_port_softint(port);
 }
 
-static int ipaq_write_room(struct usb_serial_port *port)
+static int ipaq_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ipaq_private	*priv = usb_get_serial_port_data(port);
 
 	dbg("%s - freelen %d", __func__, priv->free_len);
 	return priv->free_len;
 }
 
-static int ipaq_chars_in_buffer(struct usb_serial_port *port)
+static int ipaq_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ipaq_private	*priv = usb_get_serial_port_data(port);
 
 	dbg("%s - queuelen %d", __func__, priv->queue_len);
diff --git a/drivers/usb/serial/ipw.c b/drivers/usb/serial/ipw.c
index bc85ca5..a89ebfe 100644
--- a/drivers/usb/serial/ipw.c
+++ b/drivers/usb/serial/ipw.c
@@ -179,7 +179,7 @@ static void ipw_read_bulk_callback(struct urb *urb)
 
 	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (tty && urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
@@ -199,7 +199,8 @@ static void ipw_read_bulk_callback(struct urb *urb)
 	return;
 }
 
-static int ipw_open(struct usb_serial_port *port, struct file *filp)
+static int ipw_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_device *dev = port->serial->dev;
 	u8 buf_flow_static[16] = IPW_BYTES_FLOWINIT;
@@ -212,8 +213,8 @@ static int ipw_open(struct usb_serial_port *port, struct file *filp)
 	if (!buf_flow_init)
 		return -ENOMEM;
 
-	if (port->tty)
-		port->tty->low_latency = 1;
+	if (tty)
+		tty->low_latency = 1;
 
 	/* --1: Tell the modem to initialize (we think) From sniffs this is always the
 	 * first thing that gets sent to the modem during opening of the device */
@@ -301,7 +302,8 @@ static int ipw_open(struct usb_serial_port *port, struct file *filp)
 	return 0;
 }
 
-static void ipw_close(struct usb_serial_port *port, struct file * filp)
+static void ipw_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file * filp)
 {
 	struct usb_device *dev = port->serial->dev;
 	int result;
@@ -384,7 +386,8 @@ static void ipw_write_bulk_callback(struct urb *urb)
 	usb_serial_port_softint(port);
 }
 
-static int ipw_write(struct usb_serial_port *port, const unsigned char *buf, int count)
+static int ipw_write(struct tty_struct *tty, struct usb_serial_port *port,
+					const unsigned char *buf, int count)
 {
 	struct usb_device *dev = port->serial->dev;
 	int ret;
diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index 004d573..43dd970 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -106,12 +106,12 @@ static int buffer_size;
 static int xbof = -1;
 
 static int  ir_startup (struct usb_serial *serial);
-static int  ir_open (struct usb_serial_port *port, struct file *filep);
-static void ir_close (struct usb_serial_port *port, struct file *filep);
-static int  ir_write (struct usb_serial_port *port, const unsigned char *buf, int count);
+static int  ir_open(struct tty_struct *tty, struct usb_serial_port *port, struct file *filep);
+static void ir_close(struct tty_struct *tty, struct usb_serial_port *port, struct file *filep);
+static int  ir_write(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count);
 static void ir_write_bulk_callback (struct urb *urb);
 static void ir_read_bulk_callback (struct urb *urb);
-static void ir_set_termios (struct usb_serial_port *port, struct ktermios *old_termios);
+static void ir_set_termios(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios *old_termios);
 
 /* Not that this lot means you can only have one per system */
 static u8 ir_baud = 0;
@@ -276,7 +276,8 @@ static int ir_startup (struct usb_serial *serial)
 	return 0;		
 }
 
-static int ir_open (struct usb_serial_port *port, struct file *filp)
+static int ir_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	char *buffer;
 	int result = 0;
@@ -321,7 +322,8 @@ static int ir_open (struct usb_serial_port *port, struct file *filp)
 	return result;
 }
 
-static void ir_close (struct usb_serial_port *port, struct file * filp)
+static void ir_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file * filp)
 {
 	dbg("%s - port %d", __func__, port->number);
 			 
@@ -329,7 +331,8 @@ static void ir_close (struct usb_serial_port *port, struct file * filp)
 	usb_kill_urb(port->read_urb);
 }
 
-static int ir_write (struct usb_serial_port *port, const unsigned char *buf, int count)
+static int ir_write(struct tty_struct *tty, struct usb_serial_port *port,
+					const unsigned char *buf, int count)
 {
 	unsigned char *transfer_buffer;
 	int result;
@@ -337,11 +340,6 @@ static int ir_write (struct usb_serial_port *port, const unsigned char *buf, int
 
 	dbg("%s - port = %d, count = %d", __func__, port->number, count);
 
-	if (!port->tty) {
-		dev_err (&port->dev, "%s - no tty???\n", __func__);
-		return 0;
-	}
-
 	if (count == 0)
 		return 0;
 
@@ -425,7 +423,7 @@ static void ir_read_bulk_callback (struct urb *urb)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (!port->open_count) {
+	if (!port->port.count) {
 		dbg("%s - port closed.", __func__);
 		return;
 	}
@@ -448,7 +446,7 @@ static void ir_read_bulk_callback (struct urb *urb)
 				urb->actual_length,
 				data);
 
-			tty = port->tty;
+			tty = port->port.tty;
 
 			if (tty_buffer_request_room(tty, urb->actual_length - 1)) {
 				tty_insert_flip_string(tty, data+1, urb->actual_length - 1);
@@ -492,7 +490,8 @@ static void ir_read_bulk_callback (struct urb *urb)
 	return;
 }
 
-static void ir_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
+static void ir_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	unsigned char *transfer_buffer;
 	int result;
@@ -501,7 +500,7 @@ static void ir_set_termios (struct usb_serial_port *port, struct ktermios *old_t
 
 	dbg("%s - port %d", __func__, port->number);
 
-	baud = tty_get_baud_rate(port->tty);
+	baud = tty_get_baud_rate(tty);
 
 	/*
 	 * FIXME, we should compare the baud request against the
@@ -554,8 +553,8 @@ static void ir_set_termios (struct usb_serial_port *port, struct ktermios *old_t
 		dev_err(&port->dev, "%s - failed submitting write urb, error %d\n", __func__, result);
 
 	/* Only speed changes are supported */
-	tty_termios_copy_hw(port->tty->termios, old_termios);
-	tty_encode_baud_rate(port->tty, baud, baud);
+	tty_termios_copy_hw(tty->termios, old_termios);
+	tty_encode_baud_rate(tty, baud, baud);
 }
 
 
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index a01e987..d654148 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -144,9 +144,10 @@ static void iuu_shutdown(struct usb_serial *serial)
 	}
 }
 
-static int iuu_tiocmset(struct usb_serial_port *port, struct file *file,
+static int iuu_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct iuu_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 
@@ -171,8 +172,9 @@ static int iuu_tiocmset(struct usb_serial_port *port, struct file *file,
  * When no card , the reader respond with TIOCM_CD
  * This is known as CD autodetect mechanism
  */
-static int iuu_tiocmget(struct usb_serial_port *port, struct file *file)
+static int iuu_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct iuu_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	int rc;
@@ -630,7 +632,7 @@ static void read_buf_callback(struct urb *urb)
 	}
 
 	dbg("%s - %i chars to write", __func__, urb->actual_length);
-	tty = port->tty;
+	tty = port->port.tty;
 	if (data == NULL)
 		dbg("%s - data is NULL !!!", __func__);
 	if (tty && urb->actual_length && data) {
@@ -752,11 +754,10 @@ static void iuu_uart_read_callback(struct urb *urb)
 	/* if nothing to write call again rxcmd */
 	dbg("%s - rxcmd recall", __func__);
 	iuu_led_activity_off(urb);
-	return;
 }
 
-static int iuu_uart_write(struct usb_serial_port *port, const u8 *buf,
-			  int count)
+static int iuu_uart_write(struct tty_struct *tty, struct usb_serial_port *port,
+			  const u8 *buf, int count)
 {
 	struct iuu_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
@@ -948,7 +949,8 @@ static int set_control_lines(struct usb_device *dev, u8 value)
 	return 0;
 }
 
-static void iuu_close(struct usb_serial_port *port, struct file *filp)
+static void iuu_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	/* iuu_led (port,255,0,0,0); */
 	struct usb_serial *serial;
@@ -964,8 +966,8 @@ static void iuu_close(struct usb_serial_port *port, struct file *filp)
 
 	iuu_uart_off(port);
 	if (serial->dev) {
-		if (port->tty) {
-			c_cflag = port->tty->termios->c_cflag;
+		if (tty) {
+			c_cflag = tty->termios->c_cflag;
 			if (c_cflag & HUPCL) {
 				/* drop DTR and RTS */
 				priv = usb_get_serial_port_data(port);
@@ -989,7 +991,8 @@ static void iuu_close(struct usb_serial_port *port, struct file *filp)
 	}
 }
 
-static int iuu_open(struct usb_serial_port *port, struct file *filp)
+static int iuu_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
 	u8 *buf;
@@ -1036,15 +1039,17 @@ static int iuu_open(struct usb_serial_port *port, struct file *filp)
 
 	/* set the termios structure */
 	spin_lock_irqsave(&priv->lock, flags);
-	if (!priv->termios_initialized) {
-		*(port->tty->termios) = tty_std_termios;
-		port->tty->termios->c_cflag = CLOCAL | CREAD | CS8 | B9600
-						| TIOCM_CTS | CSTOPB | PARENB;
-		port->tty->termios->c_lflag = 0;
-		port->tty->termios->c_oflag = 0;
-		port->tty->termios->c_iflag = 0;
+	if (tty && !priv->termios_initialized) {
+		*(tty->termios) = tty_std_termios;
+		tty->termios->c_cflag = CLOCAL | CREAD | CS8 | B9600
+					| TIOCM_CTS | CSTOPB | PARENB;
+		tty->termios->c_ispeed = 9600;
+		tty->termios->c_ospeed = 9600;
+		tty->termios->c_lflag = 0;
+		tty->termios->c_oflag = 0;
+		tty->termios->c_iflag = 0;
 		priv->termios_initialized = 1;
-		port->tty->low_latency = 1;
+		tty->low_latency = 1;
 		priv->poll = 0;
 	 }
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -1148,7 +1153,7 @@ static int iuu_open(struct usb_serial_port *port, struct file *filp)
 	if (result) {
 		dev_err(&port->dev, "%s - failed submitting read urb,"
 			" error %d\n", __func__, result);
-		iuu_close(port, NULL);
+		iuu_close(tty, port, NULL);
 		return -EPROTO;
 	} else {
 		dbg("%s - rxcmd OK", __func__);
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 3df8a66..823ea97 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -242,20 +242,9 @@ static void __exit keyspan_exit (void)
 module_init(keyspan_init);
 module_exit(keyspan_exit);
 
-static void keyspan_rx_throttle (struct usb_serial_port *port)
-{
-	dbg("%s - port %d", __func__, port->number);
-}
-
-
-static void keyspan_rx_unthrottle (struct usb_serial_port *port)
-{
-	dbg("%s - port %d", __func__, port->number);
-}
-
-
-static void keyspan_break_ctl (struct usb_serial_port *port, int break_state)
+static void keyspan_break_ctl(struct tty_struct *tty, int break_state)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct keyspan_port_private 	*p_priv;
 
  	dbg("%s", __func__);
@@ -271,14 +260,13 @@ static void keyspan_break_ctl (struct usb_serial_port *port, int break_state)
 }
 
 
-static void keyspan_set_termios (struct usb_serial_port *port, 
-				     struct ktermios *old_termios)
+static void keyspan_set_termios (struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	int				baud_rate, device_port;
 	struct keyspan_port_private 	*p_priv;
 	const struct keyspan_device_details	*d_details;
 	unsigned int 			cflag;
-	struct tty_struct		*tty = port->tty;
 
 	dbg("%s", __func__);
 
@@ -310,12 +298,11 @@ static void keyspan_set_termios (struct usb_serial_port *port,
 	keyspan_send_setup(port, 0);
 }
 
-static int keyspan_tiocmget(struct usb_serial_port *port, struct file *file)
+static int keyspan_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
+	struct keyspan_port_private *p_priv = usb_get_serial_port_data(port);
 	unsigned int			value;
-	struct keyspan_port_private 	*p_priv;
-
-	p_priv = usb_get_serial_port_data(port);
 	
 	value = ((p_priv->rts_state) ? TIOCM_RTS : 0) |
 		((p_priv->dtr_state) ? TIOCM_DTR : 0) |
@@ -327,18 +314,16 @@ static int keyspan_tiocmget(struct usb_serial_port *port, struct file *file)
 	return value;
 }
 
-static int keyspan_tiocmset(struct usb_serial_port *port, struct file *file,
+static int keyspan_tiocmset(struct tty_struct *tty, struct file *file,
 			    unsigned int set, unsigned int clear)
 {
-	struct keyspan_port_private 	*p_priv;
-
-	p_priv = usb_get_serial_port_data(port);
+	struct usb_serial_port *port = tty->driver_data;
+	struct keyspan_port_private *p_priv = usb_get_serial_port_data(port);
 	
 	if (set & TIOCM_RTS)
 		p_priv->rts_state = 1;
 	if (set & TIOCM_DTR)
 		p_priv->dtr_state = 1;
-
 	if (clear & TIOCM_RTS)
 		p_priv->rts_state = 0;
 	if (clear & TIOCM_DTR)
@@ -347,16 +332,10 @@ static int keyspan_tiocmset(struct usb_serial_port *port, struct file *file,
 	return 0;
 }
 
-static int keyspan_ioctl(struct usb_serial_port *port, struct file *file,
-			     unsigned int cmd, unsigned long arg)
-{
-	return -ENOIOCTLCMD;
-}
-
-	/* Write function is similar for the four protocols used
-	   with only a minor change for usa90 (usa19hs) required */
-static int keyspan_write(struct usb_serial_port *port, 
-			 const unsigned char *buf, int count)
+/* Write function is similar for the four protocols used
+   with only a minor change for usa90 (usa19hs) required */
+static int keyspan_write(struct tty_struct *tty,
+	struct usb_serial_port *port, const unsigned char *buf, int count)
 {
 	struct keyspan_port_private 	*p_priv;
 	const struct keyspan_device_details	*d_details;
@@ -446,7 +425,7 @@ static void	usa26_indat_callback(struct urb *urb)
 	}
 
 	port =  urb->context;
-	tty = port->tty;
+	tty = port->port.tty;
 	if (tty && urb->actual_length) {
 		/* 0x80 bit is error flag */
 		if ((data[0] & 0x80) == 0) {
@@ -477,7 +456,7 @@ static void	usa26_indat_callback(struct urb *urb)
 				
 		/* Resubmit urb so we continue receiving */
 	urb->dev = port->serial->dev;
-	if (port->open_count)
+	if (port->port.count)
 		if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
 			dbg("%s - resubmit read urb failed. (%d)", __func__, err);
 		}
@@ -494,7 +473,7 @@ static void	usa2x_outdat_callback(struct urb *urb)
 	p_priv = usb_get_serial_port_data(port);
 	dbg ("%s - urb %d", __func__, urb == p_priv->out_urbs[1]);
 
-	if (port->open_count)
+	if (port->port.count)
 		usb_serial_port_softint(port);
 }
 
@@ -565,10 +544,10 @@ static void	usa26_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->gpia_dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if (port->tty && !C_CLOCAL(port->tty)
+	if (port->port.tty && !C_CLOCAL(port->port.tty)
 	    && old_dcd_state != p_priv->dcd_state) {
 		if (old_dcd_state)
-			tty_hangup(port->tty);
+			tty_hangup(port->port.tty);
 		/*  else */
 		/*	wake_up_interruptible(&p_priv->open_wait); */
 	}
@@ -617,7 +596,7 @@ static void usa28_indat_callback(struct urb *urb)
 		p_priv = usb_get_serial_port_data(port);
 		data = urb->transfer_buffer;
 
-		tty = port->tty;
+		tty = port->port.tty;
 		if (urb->actual_length) {
 			for (i = 0; i < urb->actual_length ; ++i) {
 				tty_insert_flip_char(tty, data[i], 0);
@@ -627,7 +606,7 @@ static void usa28_indat_callback(struct urb *urb)
 
 		/* Resubmit urb so we continue receiving */
 		urb->dev = port->serial->dev;
-		if (port->open_count)
+		if (port->port.count)
 			if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
 				dbg("%s - resubmit read urb failed. (%d)", __func__, err);
 			}
@@ -702,10 +681,10 @@ static void	usa28_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if (port->tty && !C_CLOCAL(port->tty)
+	if (port->port.tty && !C_CLOCAL(port->port.tty)
 	    && old_dcd_state != p_priv->dcd_state) {
 		if (old_dcd_state)
-			tty_hangup(port->tty);
+			tty_hangup(port->port.tty);
 		/*  else */
 		/*	wake_up_interruptible(&p_priv->open_wait); */
 	}
@@ -795,10 +774,10 @@ static void	usa49_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if (port->tty && !C_CLOCAL(port->tty)
+	if (port->port.tty && !C_CLOCAL(port->port.tty)
 	    && old_dcd_state != p_priv->dcd_state) {
 		if (old_dcd_state)
-			tty_hangup(port->tty);
+			tty_hangup(port->port.tty);
 		/*  else */
 		/*	wake_up_interruptible(&p_priv->open_wait); */
 	}
@@ -837,7 +816,7 @@ static void	usa49_indat_callback(struct urb *urb)
 	}
 
 	port =  urb->context;
-	tty = port->tty;
+	tty = port->port.tty;
 	if (tty && urb->actual_length) {
 		/* 0x80 bit is error flag */
 		if ((data[0] & 0x80) == 0) {
@@ -864,7 +843,7 @@ static void	usa49_indat_callback(struct urb *urb)
 				
 		/* Resubmit urb so we continue receiving */
 	urb->dev = port->serial->dev;
-	if (port->open_count)
+	if (port->port.count)
 		if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
 			dbg("%s - resubmit read urb failed. (%d)", __func__, err);
 		}
@@ -902,7 +881,7 @@ static void usa49wg_indat_callback(struct urb *urb)
 				return;
 			}
 			port = serial->port[data[i++]];
-			tty = port->tty;
+			tty = port->port.tty;
 			len = data[i++];
 
 			/* 0x80 bit is error flag */
@@ -910,7 +889,7 @@ static void usa49wg_indat_callback(struct urb *urb)
 				/* no error on any byte */
 				i++;
 				for (x = 1; x < len ; ++x)
-					if (port->open_count)
+					if (port->port.count)
 						tty_insert_flip_char(tty,
 								data[i++], 0);
 					else
@@ -928,13 +907,13 @@ static void usa49wg_indat_callback(struct urb *urb)
 					if (stat & RXERROR_PARITY)
 						flag |= TTY_PARITY;
 					/* XXX should handle break (0x10) */
-					if (port->open_count)
+					if (port->port.count)
 						tty_insert_flip_char(tty,
 							data[i+1], flag);
 					i += 2;
 				}
 			}
-			if (port->open_count)
+			if (port->port.count)
 				tty_flip_buffer_push(tty);
 		}
 	}
@@ -976,7 +955,7 @@ static void usa90_indat_callback(struct urb *urb)
 	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (urb->actual_length) {
 	
 		/* if current mode is DMA, looks like usa28 format
@@ -1019,7 +998,7 @@ static void usa90_indat_callback(struct urb *urb)
 				
 	/* Resubmit urb so we continue receiving */
 	urb->dev = port->serial->dev;
-	if (port->open_count)
+	if (port->port.count)
 		if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
 			dbg("%s - resubmit read urb failed. (%d)", __func__, err);
 		}
@@ -1062,10 +1041,10 @@ static void	usa90_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if (port->tty && !C_CLOCAL(port->tty)
+	if (port->port.tty && !C_CLOCAL(port->port.tty)
 	    && old_dcd_state != p_priv->dcd_state) {
 		if (old_dcd_state)
-			tty_hangup(port->tty);
+			tty_hangup(port->port.tty);
 		/*  else */
 		/*	wake_up_interruptible(&p_priv->open_wait); */
 	}
@@ -1137,10 +1116,10 @@ static void	usa67_instat_callback(struct urb *urb)
 	p_priv->cts_state = ((msg->hskia_cts) ? 1 : 0);
 	p_priv->dcd_state = ((msg->gpia_dcd) ? 1 : 0);
 
-	if (port->tty && !C_CLOCAL(port->tty)
+	if (port->port.tty && !C_CLOCAL(port->port.tty)
 	    && old_dcd_state != p_priv->dcd_state) {
 		if (old_dcd_state)
-			tty_hangup(port->tty);
+			tty_hangup(port->port.tty);
 		/*  else */
 		/*	wake_up_interruptible(&p_priv->open_wait); */
 	}
@@ -1175,8 +1154,9 @@ static void usa67_glocont_callback(struct urb *urb)
 	}
 }
 
-static int keyspan_write_room (struct usb_serial_port *port)
+static int keyspan_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct keyspan_port_private	*p_priv;
 	const struct keyspan_device_details	*d_details;
 	int				flip;
@@ -1208,13 +1188,8 @@ static int keyspan_write_room (struct usb_serial_port *port)
 }
 
 
-static int keyspan_chars_in_buffer (struct usb_serial_port *port)
-{
-	return 0;
-}
-
-
-static int keyspan_open (struct usb_serial_port *port, struct file *filp)
+static int keyspan_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct keyspan_port_private 	*p_priv;
 	struct keyspan_serial_private 	*s_priv;
@@ -1223,7 +1198,7 @@ static int keyspan_open (struct usb_serial_port *port, struct file *filp)
 	int				i, err;
 	int				baud_rate, device_port;
 	struct urb			*urb;
-	unsigned int			cflag;
+	unsigned int			cflag = 0;
 
 	s_priv = usb_get_serial_data(serial);
 	p_priv = usb_get_serial_port_data(port);
@@ -1269,19 +1244,19 @@ static int keyspan_open (struct usb_serial_port *port, struct file *filp)
 	/* get the terminal config for the setup message now so we don't
 	 * need to send 2 of them */
 
-	cflag = port->tty->termios->c_cflag;
 	device_port = port->number - port->serial->minor;
-
-	/* Baud rate calculation takes baud rate as an integer
-	   so other rates can be generated if desired. */
-	baud_rate = tty_get_baud_rate(port->tty);
-	/* If no match or invalid, leave as default */
-	if (baud_rate >= 0
-	    && d_details->calculate_baud_rate(baud_rate, d_details->baudclk,
-				NULL, NULL, NULL, device_port) == KEYSPAN_BAUD_RATE_OK) {
-		p_priv->baud = baud_rate;
+	if (tty) {
+		cflag = tty->termios->c_cflag;
+		/* Baud rate calculation takes baud rate as an integer
+		   so other rates can be generated if desired. */
+		baud_rate = tty_get_baud_rate(tty);
+		/* If no match or invalid, leave as default */
+		if (baud_rate >= 0
+		    && d_details->calculate_baud_rate(baud_rate, d_details->baudclk,
+					NULL, NULL, NULL, device_port) == KEYSPAN_BAUD_RATE_OK) {
+			p_priv->baud = baud_rate;
+		}
 	}
-
 	/* set CTS/RTS handshake etc. */
 	p_priv->cflag = cflag;
 	p_priv->flow_control = (cflag & CRTSCTS)? flow_cts: flow_none;
@@ -1299,7 +1274,8 @@ static inline void stop_urb(struct urb *urb)
 		usb_kill_urb(urb);
 }
 
-static void keyspan_close(struct usb_serial_port *port, struct file *filp)
+static void keyspan_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	int			i;
 	struct usb_serial	*serial = port->serial;
@@ -1336,7 +1312,7 @@ static void keyspan_close(struct usb_serial_port *port, struct file *filp)
 			stop_urb(p_priv->out_urbs[i]);
 		}
 	}
-	port->tty = NULL;
+	port->port.tty = NULL;
 }
 
 
@@ -2434,7 +2410,7 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 	}
 	/* Sending intermediate configs */
 	else {
-		if (port->open_count)
+		if (port->port.count)
 			msg.portEnabled = 1;
 		msg.txBreak = (p_priv->break_on);
 	}
diff --git a/drivers/usb/serial/keyspan.h b/drivers/usb/serial/keyspan.h
index 8d6ed02..7559950 100644
--- a/drivers/usb/serial/keyspan.h
+++ b/drivers/usb/serial/keyspan.h
@@ -35,17 +35,18 @@
 
 
 /* Function prototypes for Keyspan serial converter */
-static int  keyspan_open		(struct usb_serial_port *port,
+static int  keyspan_open		(struct tty_struct *tty,
+					 struct usb_serial_port *port,
 					 struct file *filp);
-static void keyspan_close		(struct usb_serial_port *port,
+static void keyspan_close		(struct tty_struct *tty,
+					 struct usb_serial_port *port,
 					 struct file *filp);
 static int  keyspan_startup		(struct usb_serial *serial);
 static void keyspan_shutdown		(struct usb_serial *serial);
-static void keyspan_rx_throttle		(struct usb_serial_port *port);
-static void keyspan_rx_unthrottle	(struct usb_serial_port *port);
-static int  keyspan_write_room		(struct usb_serial_port *port);
+static int  keyspan_write_room		(struct tty_struct *tty);
 
-static int  keyspan_write		(struct usb_serial_port *port,
+static int  keyspan_write		(struct tty_struct *tty,
+					 struct usb_serial_port *port,
 					 const unsigned char *buf,
 					 int count);
 
@@ -53,18 +54,14 @@ static void keyspan_send_setup		(struct usb_serial_port *port,
 					 int reset_port);
 
 
-static int  keyspan_chars_in_buffer 	(struct usb_serial_port *port);
-static int  keyspan_ioctl		(struct usb_serial_port *port,
-					 struct file *file,
-					 unsigned int cmd,
-					 unsigned long arg);
-static void keyspan_set_termios		(struct usb_serial_port *port,
+static void keyspan_set_termios		(struct tty_struct *tty,
+					 struct usb_serial_port *port,
 					 struct ktermios *old);
-static void keyspan_break_ctl		(struct usb_serial_port *port,
+static void keyspan_break_ctl		(struct tty_struct *tty,
 					 int break_state);
-static int  keyspan_tiocmget		(struct usb_serial_port *port,
+static int  keyspan_tiocmget		(struct tty_struct *tty,
 					 struct file *file);
-static int  keyspan_tiocmset		(struct usb_serial_port *port,
+static int  keyspan_tiocmset		(struct tty_struct *tty,
 					 struct file *file, unsigned int set,
 					 unsigned int clear);
 static int  keyspan_fake_startup	(struct usb_serial *serial);
@@ -652,10 +649,6 @@ static struct usb_serial_driver keyspan_1port_device = {
 	.close			= keyspan_close,
 	.write			= keyspan_write,
 	.write_room		= keyspan_write_room,
-	.chars_in_buffer	= keyspan_chars_in_buffer,
-	.throttle		= keyspan_rx_throttle,
-	.unthrottle		= keyspan_rx_unthrottle,
-	.ioctl			= keyspan_ioctl,
 	.set_termios		= keyspan_set_termios,
 	.break_ctl		= keyspan_break_ctl,
 	.tiocmget		= keyspan_tiocmget,
@@ -676,10 +669,6 @@ static struct usb_serial_driver keyspan_2port_device = {
 	.close			= keyspan_close,
 	.write			= keyspan_write,
 	.write_room		= keyspan_write_room,
-	.chars_in_buffer	= keyspan_chars_in_buffer,
-	.throttle		= keyspan_rx_throttle,
-	.unthrottle		= keyspan_rx_unthrottle,
-	.ioctl			= keyspan_ioctl,
 	.set_termios		= keyspan_set_termios,
 	.break_ctl		= keyspan_break_ctl,
 	.tiocmget		= keyspan_tiocmget,
@@ -700,10 +689,6 @@ static struct usb_serial_driver keyspan_4port_device = {
 	.close			= keyspan_close,
 	.write			= keyspan_write,
 	.write_room		= keyspan_write_room,
-	.chars_in_buffer	= keyspan_chars_in_buffer,
-	.throttle		= keyspan_rx_throttle,
-	.unthrottle		= keyspan_rx_unthrottle,
-	.ioctl			= keyspan_ioctl,
 	.set_termios		= keyspan_set_termios,
 	.break_ctl		= keyspan_break_ctl,
 	.tiocmget		= keyspan_tiocmget,
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index ff54203..a7538d7 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -183,7 +183,7 @@ static void keyspan_pda_wakeup_write(struct work_struct *work)
 		container_of(work, struct keyspan_pda_private, wakeup_work);
 	struct usb_serial_port *port = priv->port;
 
-	tty_wakeup(port->tty);
+	tty_wakeup(port->port.tty);
 }
 
 static void keyspan_pda_request_unthrottle(struct work_struct *work)
@@ -215,7 +215,7 @@ static void keyspan_pda_request_unthrottle(struct work_struct *work)
 static void keyspan_pda_rx_interrupt (struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
-       	struct tty_struct *tty = port->tty;
+       	struct tty_struct *tty = port->port.tty;
 	unsigned char *data = urb->transfer_buffer;
 	int i;
 	int retval;
@@ -278,7 +278,7 @@ exit:
 }
 
 
-static void keyspan_pda_rx_throttle (struct usb_serial_port *port)
+static void keyspan_pda_rx_throttle(struct tty_struct *tty)
 {
 	/* stop receiving characters. We just turn off the URB request, and
 	   let chars pile up in the device. If we're doing hardware
@@ -286,14 +286,15 @@ static void keyspan_pda_rx_throttle (struct usb_serial_port *port)
 	   fills up. If we're doing XON/XOFF, this would be a good time to
 	   send an XOFF, although it might make sense to foist that off
 	   upon the device too. */
-
+	struct usb_serial_port *port = tty->driver_data;
 	dbg("keyspan_pda_rx_throttle port %d", port->number);
 	usb_kill_urb(port->interrupt_in_urb);
 }
 
 
-static void keyspan_pda_rx_unthrottle (struct usb_serial_port *port)
+static void keyspan_pda_rx_unthrottle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	/* just restart the receive interrupt URB */
 	dbg("keyspan_pda_rx_unthrottle port %d", port->number);
 	port->interrupt_in_urb->dev = port->serial->dev;
@@ -342,8 +343,9 @@ static speed_t keyspan_pda_setbaud (struct usb_serial *serial, speed_t baud)
 }
 
 
-static void keyspan_pda_break_ctl (struct usb_serial_port *port, int break_state)
+static void keyspan_pda_break_ctl(struct tty_struct *tty, int break_state)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	int value;
 	int result;
@@ -366,8 +368,8 @@ static void keyspan_pda_break_ctl (struct usb_serial_port *port, int break_state
 }
 
 
-static void keyspan_pda_set_termios (struct usb_serial_port *port, 
-				     struct ktermios *old_termios)
+static void keyspan_pda_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
 	speed_t speed;
@@ -392,7 +394,7 @@ static void keyspan_pda_set_termios (struct usb_serial_port *port,
 
 	   For now, just do baud. */
 
-	speed = tty_get_baud_rate(port->tty);
+	speed = tty_get_baud_rate(tty);
 	speed = keyspan_pda_setbaud(serial, speed);
 
 	if (speed == 0) {
@@ -402,8 +404,8 @@ static void keyspan_pda_set_termios (struct usb_serial_port *port,
 	}
 	/* Only speed can change so copy the old h/w parameters
 	   then encode the new speed */
-	tty_termios_copy_hw(port->tty->termios, old_termios);
-	tty_encode_baud_rate(port->tty, speed, speed);
+	tty_termios_copy_hw(tty->termios, old_termios);
+	tty_encode_baud_rate(tty, speed, speed);
 }
 
 
@@ -437,8 +439,9 @@ static int keyspan_pda_set_modem_info(struct usb_serial *serial,
 	return rc;
 }
 
-static int keyspan_pda_tiocmget(struct usb_serial_port *port, struct file *file)
+static int keyspan_pda_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	int rc;
 	unsigned char status;
@@ -457,9 +460,10 @@ static int keyspan_pda_tiocmget(struct usb_serial_port *port, struct file *file)
 	return value;
 }
 
-static int keyspan_pda_tiocmset(struct usb_serial_port *port, struct file *file,
+static int keyspan_pda_tiocmset(struct tty_struct *tty, struct file *file,
 				unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	int rc;
 	unsigned char status;
@@ -481,23 +485,8 @@ static int keyspan_pda_tiocmset(struct usb_serial_port *port, struct file *file,
 	return rc;
 }
 
-static int keyspan_pda_ioctl(struct usb_serial_port *port, struct file *file,
-			     unsigned int cmd, unsigned long arg)
-{
-	switch (cmd) {
-	case TIOCMIWAIT:
-		/* wait for any of the 4 modem inputs (DCD,RI,DSR,CTS)*/
-		/* TODO */
-	case TIOCGICOUNT:
-		/* return count of modemline transitions */
-		return 0; /* TODO */
-	}
-	
-	return -ENOIOCTLCMD;
-}
-
-static int keyspan_pda_write(struct usb_serial_port *port, 
-			     const unsigned char *buf, int count)
+static int keyspan_pda_write(struct tty_struct *tty,
+	struct usb_serial_port *port, const unsigned char *buf, int count)
 {
 	struct usb_serial *serial = port->serial;
 	int request_unthrottle = 0;
@@ -619,22 +608,21 @@ static void keyspan_pda_write_bulk_callback (struct urb *urb)
 }
 
 
-static int keyspan_pda_write_room (struct usb_serial_port *port)
+static int keyspan_pda_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct keyspan_pda_private *priv;
-
 	priv = usb_get_serial_port_data(port);
-
 	/* used by n_tty.c for processing of tabs and such. Giving it our
 	   conservative guess is probably good enough, but needs testing by
 	   running a console through the device. */
-
 	return (priv->tx_room);
 }
 
 
-static int keyspan_pda_chars_in_buffer (struct usb_serial_port *port)
+static int keyspan_pda_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct keyspan_pda_private *priv;
 	unsigned long flags;
 	int ret = 0;
@@ -652,7 +640,8 @@ static int keyspan_pda_chars_in_buffer (struct usb_serial_port *port)
 }
 
 
-static int keyspan_pda_open (struct usb_serial_port *port, struct file *filp)
+static int keyspan_pda_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
 	unsigned char room;
@@ -684,7 +673,7 @@ static int keyspan_pda_open (struct usb_serial_port *port, struct file *filp)
 
 	/* the normal serial device seems to always turn on DTR and RTS here,
 	   so do the same */
-	if (port->tty->termios->c_cflag & CBAUD)
+	if (tty && (tty->termios->c_cflag & CBAUD))
 		keyspan_pda_set_modem_info(serial, (1<<7) | (1<<2) );
 	else
 		keyspan_pda_set_modem_info(serial, 0);
@@ -702,13 +691,14 @@ error:
 }
 
 
-static void keyspan_pda_close(struct usb_serial_port *port, struct file *filp)
+static void keyspan_pda_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
 
 	if (serial->dev) {
 		/* the normal serial device seems to always shut off DTR and RTS now */
-		if (port->tty->termios->c_cflag & HUPCL)
+		if (tty->termios->c_cflag & HUPCL)
 			keyspan_pda_set_modem_info(serial, 0);
 
 		/* shutdown our bulk reads and writes */
@@ -835,7 +825,6 @@ static struct usb_serial_driver keyspan_pda_device = {
 	.chars_in_buffer =	keyspan_pda_chars_in_buffer,
 	.throttle =		keyspan_pda_rx_throttle,
 	.unthrottle =		keyspan_pda_rx_unthrottle,
-	.ioctl =		keyspan_pda_ioctl,
 	.set_termios =		keyspan_pda_set_termios,
 	.break_ctl =		keyspan_pda_break_ctl,
 	.tiocmget =		keyspan_pda_tiocmget,
diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index f328948..4c27ccc 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -74,29 +74,33 @@ static int debug;
  */
 static int  klsi_105_startup	         (struct usb_serial *serial);
 static void klsi_105_shutdown	         (struct usb_serial *serial);
-static int  klsi_105_open	         (struct usb_serial_port *port,
+static int  klsi_105_open	         (struct tty_struct *tty,
+					  struct usb_serial_port *port,
 					  struct file *filp);
-static void klsi_105_close	         (struct usb_serial_port *port,
+static void klsi_105_close	         (struct tty_struct *tty,
+					  struct usb_serial_port *port,
 					  struct file *filp);
-static int  klsi_105_write	         (struct usb_serial_port *port,
+static int  klsi_105_write	         (struct tty_struct *tty,
+					  struct usb_serial_port *port,
 					  const unsigned char *buf,
 					  int count);
 static void klsi_105_write_bulk_callback (struct urb *urb);
-static int  klsi_105_chars_in_buffer     (struct usb_serial_port *port);
-static int  klsi_105_write_room          (struct usb_serial_port *port);
+static int  klsi_105_chars_in_buffer     (struct tty_struct *tty);
+static int  klsi_105_write_room          (struct tty_struct *tty);
 
 static void klsi_105_read_bulk_callback  (struct urb *urb);
-static void klsi_105_set_termios         (struct usb_serial_port *port,
+static void klsi_105_set_termios         (struct tty_struct *tty,
+					  struct usb_serial_port *port,
 					  struct ktermios *old);
-static void klsi_105_throttle		 (struct usb_serial_port *port);
-static void klsi_105_unthrottle		 (struct usb_serial_port *port);
+static void klsi_105_throttle		 (struct tty_struct *tty);
+static void klsi_105_unthrottle		 (struct tty_struct *tty);
 /*
-static void klsi_105_break_ctl	         (struct usb_serial_port *port,
+static void klsi_105_break_ctl	         (struct tty_struct *tty,
 					  int break_state );
  */
-static int  klsi_105_tiocmget	         (struct usb_serial_port *port,
+static int  klsi_105_tiocmget	         (struct tty_struct *tty,
 					  struct file *file);
-static int  klsi_105_tiocmset	         (struct usb_serial_port *port,
+static int  klsi_105_tiocmset	         (struct tty_struct *tty,
 					  struct file *file, unsigned int set,
 					  unsigned int clear);
 
@@ -361,7 +365,8 @@ static void klsi_105_shutdown (struct usb_serial *serial)
 	}
 } /* klsi_105_shutdown */
 
-static int  klsi_105_open (struct usb_serial_port *port, struct file *filp)
+static int  klsi_105_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
 	int retval = 0;
@@ -375,7 +380,7 @@ static int  klsi_105_open (struct usb_serial_port *port, struct file *filp)
 
 	/* force low_latency on so that our tty_push actually forces
 	 * the data through
-	 * port->tty->low_latency = 1; */
+	 * tty->low_latency = 1; */
 
 	/* Do a defined restart:
 	 * Set up sane default baud rate and send the 'READ_ON'
@@ -393,12 +398,12 @@ static int  klsi_105_open (struct usb_serial_port *port, struct file *filp)
 	
 	/* set up termios structure */
 	spin_lock_irqsave (&priv->lock, flags);
-	priv->termios.c_iflag = port->tty->termios->c_iflag;
-	priv->termios.c_oflag = port->tty->termios->c_oflag;
-	priv->termios.c_cflag = port->tty->termios->c_cflag;
-	priv->termios.c_lflag = port->tty->termios->c_lflag;
+	priv->termios.c_iflag = tty->termios->c_iflag;
+	priv->termios.c_oflag = tty->termios->c_oflag;
+	priv->termios.c_cflag = tty->termios->c_cflag;
+	priv->termios.c_lflag = tty->termios->c_lflag;
 	for (i=0; i<NCCS; i++)
-		priv->termios.c_cc[i] = port->tty->termios->c_cc[i];
+		priv->termios.c_cc[i] = tty->termios->c_cc[i];
 	priv->cfg.pktlen   = cfg.pktlen;
 	priv->cfg.baudrate = cfg.baudrate;
 	priv->cfg.databits = cfg.databits;
@@ -452,7 +457,8 @@ exit:
 } /* klsi_105_open */
 
 
-static void klsi_105_close (struct usb_serial_port *port, struct file *filp)
+static void klsi_105_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
 	int rc;
@@ -493,8 +499,8 @@ static void klsi_105_close (struct usb_serial_port *port, struct file *filp)
 #define KLSI_105_DATA_OFFSET	2   /* in the bulk urb data block */
 
 
-static int klsi_105_write (struct usb_serial_port *port,
-			   const unsigned char *buf, int count)
+static int klsi_105_write(struct tty_struct *tty,
+	struct usb_serial_port *port, const unsigned char *buf, int count)
 {
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
 	int result, size;
@@ -584,8 +590,9 @@ static void klsi_105_write_bulk_callback ( struct urb *urb)
 
 
 /* return number of characters currently in the writing process */
-static int klsi_105_chars_in_buffer (struct usb_serial_port *port)
+static int klsi_105_chars_in_buffer (struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	int chars = 0;
 	int i;
 	unsigned long flags;
@@ -605,8 +612,9 @@ static int klsi_105_chars_in_buffer (struct usb_serial_port *port)
 	return (chars);
 }
 
-static int klsi_105_write_room (struct usb_serial_port *port)
+static int klsi_105_write_room (struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	unsigned long flags;
 	int i;
 	int room = 0;
@@ -660,7 +668,7 @@ static void klsi_105_read_bulk_callback (struct urb *urb)
 	} else {
 		int bytes_sent = ((__u8 *) data)[0] +
 				 ((unsigned int) ((__u8 *) data)[1] << 8);
-		tty = port->tty;
+		tty = port->port.tty;
 		/* we should immediately resubmit the URB, before attempting
 		 * to pass the data on to the tty layer. But that needs locking
 		 * against re-entry an then mixed-up data because of
@@ -699,11 +707,11 @@ static void klsi_105_read_bulk_callback (struct urb *urb)
 } /* klsi_105_read_bulk_callback */
 
 
-static void klsi_105_set_termios (struct usb_serial_port *port,
+static void klsi_105_set_termios (struct tty_struct *tty,
+				  struct usb_serial_port *port,
 				  struct ktermios *old_termios)
 {
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty = port->tty;
 	unsigned int iflag = tty->termios->c_iflag;
 	unsigned int old_iflag = old_termios->c_iflag;
 	unsigned int cflag = tty->termios->c_cflag;
@@ -863,8 +871,9 @@ static void klsi_105_set_termios (struct usb_serial_port *port,
 
 
 #if 0
-static void mct_u232_break_ctl( struct usb_serial_port *port, int break_state )
+static void mct_u232_break_ctl( struct tty_struct *tty, int break_state )
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv = (struct mct_u232_private *)port->private;
 	unsigned char lcr = priv->last_lcr;
@@ -878,8 +887,9 @@ static void mct_u232_break_ctl( struct usb_serial_port *port, int break_state )
 } /* mct_u232_break_ctl */
 #endif
 
-static int klsi_105_tiocmget (struct usb_serial_port *port, struct file *file)
+static int klsi_105_tiocmget (struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	int rc;
@@ -900,7 +910,7 @@ static int klsi_105_tiocmget (struct usb_serial_port *port, struct file *file)
 	return (int)line_state;
 }
 
-static int klsi_105_tiocmset (struct usb_serial_port *port, struct file *file,
+static int klsi_105_tiocmset (struct tty_struct *tty, struct file *file,
 			      unsigned int set, unsigned int clear)
 {
 	int retval = -EINVAL;
@@ -929,14 +939,16 @@ static int klsi_105_tiocmset (struct usb_serial_port *port, struct file *file,
 	return retval;
 }
 
-static void klsi_105_throttle (struct usb_serial_port *port)
+static void klsi_105_throttle (struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s - port %d", __func__, port->number);
 	usb_kill_urb(port->read_urb);
 }
 
-static void klsi_105_unthrottle (struct usb_serial_port *port)
+static void klsi_105_unthrottle (struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	int result;
 
 	dbg("%s - port %d", __func__, port->number);
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 693f00d..40c67f0 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -70,19 +70,22 @@ static int debug;
 /* Function prototypes */
 static int  kobil_startup (struct usb_serial *serial);
 static void kobil_shutdown (struct usb_serial *serial);
-static int  kobil_open (struct usb_serial_port *port, struct file *filp);
-static void kobil_close (struct usb_serial_port *port, struct file *filp);
-static int  kobil_write (struct usb_serial_port *port, 
+static int  kobil_open (struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static void kobil_close (struct tty_struct *tty, struct usb_serial_port *port,
+			struct file *filp);
+static int  kobil_write (struct tty_struct *tty, struct usb_serial_port *port, 
 			 const unsigned char *buf, int count);
-static int  kobil_write_room(struct usb_serial_port *port);
-static int  kobil_ioctl(struct usb_serial_port *port, struct file *file,
+static int  kobil_write_room(struct tty_struct *tty);
+static int  kobil_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
-static int  kobil_tiocmget(struct usb_serial_port *port, struct file *file);
-static int  kobil_tiocmset(struct usb_serial_port *port, struct file *file,
+static int  kobil_tiocmget(struct tty_struct *tty, struct file *file);
+static int  kobil_tiocmset(struct tty_struct *tty, struct file *file,
 			   unsigned int set, unsigned int clear);
 static void kobil_read_int_callback( struct urb *urb );
 static void kobil_write_callback( struct urb *purb );
-static void kobil_set_termios(struct usb_serial_port *port, struct ktermios *old);
+static void kobil_set_termios(struct tty_struct *tty, 
+			struct usb_serial_port *port, struct ktermios *old);
 
 
 static struct usb_device_id id_table [] = {
@@ -201,8 +204,8 @@ static void kobil_shutdown (struct usb_serial *serial)
 	dbg("%s - port %d", __func__, serial->port[0]->number);
 
 	for (i=0; i < serial->num_ports; ++i) {
-		while (serial->port[i]->open_count > 0) {
-			kobil_close (serial->port[i], NULL);
+		while (serial->port[i]->port.count > 0) {
+			kobil_close (NULL, serial->port[i], NULL);
 		}
 		kfree(usb_get_serial_port_data(serial->port[i]));
 		usb_set_serial_port_data(serial->port[i], NULL);
@@ -210,7 +213,8 @@ static void kobil_shutdown (struct usb_serial *serial)
 }
 
 
-static int kobil_open (struct usb_serial_port *port, struct file *filp)
+static int kobil_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	int result = 0;
 	struct kobil_private *priv;
@@ -229,14 +233,15 @@ static int kobil_open (struct usb_serial_port *port, struct file *filp)
 	 * the data through, otherwise it is scheduled, and with high
 	 * data rates (like with OHCI) data can get lost.
 	 */
-	port->tty->low_latency = 1;
-
-	// without this, every push_tty_char is echoed :-(  
-	port->tty->termios->c_lflag = 0;
-	port->tty->termios->c_lflag &= ~(ISIG | ICANON | ECHO | IEXTEN | XCASE);
-	port->tty->termios->c_iflag = IGNBRK | IGNPAR | IXOFF;
-	port->tty->termios->c_oflag &= ~ONLCR; // do NOT translate CR to CR-NL (0x0A -> 0x0A 0x0D)
-	
+	if (tty) {
+		tty->low_latency = 1;
+
+		/* Default to echo off and other sane device settings */
+		tty->termios->c_lflag = 0;
+		tty->termios->c_lflag &= ~(ISIG | ICANON | ECHO | IEXTEN | XCASE);
+		tty->termios->c_iflag = IGNBRK | IGNPAR | IXOFF;
+		tty->termios->c_oflag &= ~ONLCR; // do NOT translate CR to CR-NL (0x0A -> 0x0A 0x0D)
+	}	
 	// allocate memory for transfer buffer
 	transfer_buffer = kzalloc(transfer_buffer_length, GFP_KERNEL);
 	if (! transfer_buffer) {
@@ -330,7 +335,8 @@ static int kobil_open (struct usb_serial_port *port, struct file *filp)
 }
 
 
-static void kobil_close (struct usb_serial_port *port, struct file *filp)
+static void kobil_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	dbg("%s - port %d", __func__, port->number);
 
@@ -360,7 +366,7 @@ static void kobil_read_int_callback(struct urb *urb)
 		return;
 	}
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (urb->actual_length) {
 
 		// BEGIN DEBUG
@@ -395,7 +401,7 @@ static void kobil_write_callback( struct urb *purb )
 }
 
 
-static int kobil_write (struct usb_serial_port *port, 
+static int kobil_write (struct tty_struct *tty, struct usb_serial_port *port, 
 			const unsigned char *buf, int count)
 {
 	int length = 0;
@@ -417,12 +423,9 @@ static int kobil_write (struct usb_serial_port *port,
 
 	// Copy data to buffer
 	memcpy (priv->buf + priv->filled, buf, count);
-
 	usb_serial_debug_data(debug, &port->dev, __func__, count, priv->buf + priv->filled);
-
 	priv->filled = priv->filled + count;
 
-
 	// only send complete block. TWIN, KAAN SIM and adapter K use the same protocol.
 	if ( ((priv->device_type != KOBIL_ADAPTER_B_PRODUCT_ID) && (priv->filled > 2) && (priv->filled >= (priv->buf[1] + 3))) || 
 	     ((priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID) && (priv->filled > 3) && (priv->filled >= (priv->buf[2] + 4))) ) {
@@ -478,15 +481,17 @@ static int kobil_write (struct usb_serial_port *port,
 }
 
 
-static int kobil_write_room (struct usb_serial_port *port)
+static int kobil_write_room (struct tty_struct *tty)
 {
 	//dbg("%s - port %d", __func__, port->number);
+	/* FIXME */
 	return 8;
 }
 
 
-static int kobil_tiocmget(struct usb_serial_port *port, struct file *file)
+static int kobil_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct kobil_private * priv;
 	int result;
 	unsigned char *transfer_buffer;
@@ -524,9 +529,10 @@ static int kobil_tiocmget(struct usb_serial_port *port, struct file *file)
 	return result;
 }
 
-static int  kobil_tiocmset(struct usb_serial_port *port, struct file *file,
+static int kobil_tiocmset(struct tty_struct *tty, struct file *file,
 			   unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct kobil_private * priv;
 	int result;
 	int dtr = 0;
@@ -590,12 +596,13 @@ static int  kobil_tiocmset(struct usb_serial_port *port, struct file *file,
 	return (result < 0) ? result : 0;
 }
 
-static void kobil_set_termios(struct usb_serial_port *port, struct ktermios *old)
+static void kobil_set_termios(struct tty_struct *tty,
+			struct usb_serial_port *port, struct ktermios *old)
 {
 	struct kobil_private * priv;
 	int result;
 	unsigned short urb_val = 0;
-	int c_cflag = port->tty->termios->c_cflag;
+	int c_cflag = tty->termios->c_cflag;
 	speed_t speed;
 	void * settings;
 
@@ -604,7 +611,7 @@ static void kobil_set_termios(struct usb_serial_port *port, struct ktermios *old
 		// This device doesn't support ioctl calls
 		return;
 
-	switch (speed = tty_get_baud_rate(port->tty)) {
+	switch (speed = tty_get_baud_rate(tty)) {
 		case 1200:
 			urb_val = SUSBCR_SBR_1200;
 			break;
@@ -634,8 +641,8 @@ static void kobil_set_termios(struct usb_serial_port *port, struct ktermios *old
 		urb_val |= SUSBCR_SPASB_NoParity;
 		strcat(settings, "No Parity");
 	}
-	port->tty->termios->c_cflag &= ~CMSPAR;
-	tty_encode_baud_rate(port->tty, speed, speed);
+	tty->termios->c_cflag &= ~CMSPAR;
+	tty_encode_baud_rate(tty, speed, speed);
 
 	result = usb_control_msg( port->serial->dev,
 				  usb_rcvctrlpipe(port->serial->dev, 0 ),
@@ -650,8 +657,9 @@ static void kobil_set_termios(struct usb_serial_port *port, struct ktermios *old
 	kfree(settings);
 }
 
-static int kobil_ioctl(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg)
+static int kobil_ioctl(struct tty_struct *tty, struct file * file, unsigned int cmd, unsigned long arg)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct kobil_private * priv = usb_get_serial_port_data(port);
 	unsigned char *transfer_buffer;
 	int transfer_buffer_length = 8;
@@ -662,7 +670,7 @@ static int kobil_ioctl(struct usb_serial_port *port, struct file * file, unsigne
 		return 0;
 
 	switch (cmd) {
-	case TCFLSH:   // 0x540B
+	case TCFLSH:
 		transfer_buffer = kmalloc(transfer_buffer_length, GFP_KERNEL);
 		if (! transfer_buffer)
 		 	return -ENOBUFS;
@@ -680,7 +688,7 @@ static int kobil_ioctl(struct usb_serial_port *port, struct file * file, unsigne
 		
 		dbg("%s - port %d Send reset_all_queues (FLUSH) URB returns: %i", __func__, port->number, result);
 		kfree(transfer_buffer);
-		return (result < 0) ? -EFAULT : 0;
+		return (result < 0) ? -EIO: 0;
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index 5fc2cef..7bce430 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -92,26 +92,25 @@ static int debug;
  */
 static int  mct_u232_startup	         (struct usb_serial *serial);
 static void mct_u232_shutdown	         (struct usb_serial *serial);
-static int  mct_u232_open	         (struct usb_serial_port *port,
+static int  mct_u232_open	         (struct tty_struct *tty,
+					  struct usb_serial_port *port,
 					  struct file *filp);
-static void mct_u232_close	         (struct usb_serial_port *port,
+static void mct_u232_close	         (struct tty_struct *tty,
+					  struct usb_serial_port *port,
 					  struct file *filp);
 static void mct_u232_read_int_callback   (struct urb *urb);
-static void mct_u232_set_termios         (struct usb_serial_port *port,
+static void mct_u232_set_termios         (struct tty_struct *tty,
+					  struct usb_serial_port *port,
 					  struct ktermios * old);
-static int  mct_u232_ioctl	         (struct usb_serial_port *port,
-					  struct file * file,
-					  unsigned int cmd,
-					  unsigned long arg);
-static void mct_u232_break_ctl	         (struct usb_serial_port *port,
+static void mct_u232_break_ctl	         (struct tty_struct *tty,
 					  int break_state );
-static int  mct_u232_tiocmget		 (struct usb_serial_port *port,
+static int  mct_u232_tiocmget		 (struct tty_struct *tty,
 					  struct file *file);
-static int  mct_u232_tiocmset		 (struct usb_serial_port *port,
+static int  mct_u232_tiocmset		 (struct tty_struct *tty,
 					  struct file *file, unsigned int set,
 					  unsigned int clear);
-static void mct_u232_throttle		 (struct usb_serial_port *port);
-static void mct_u232_unthrottle		 (struct usb_serial_port *port);
+static void mct_u232_throttle		 (struct tty_struct *tty);
+static void mct_u232_unthrottle		 (struct tty_struct *tty);
 
 
 /*
@@ -149,7 +148,6 @@ static struct usb_serial_driver mct_u232_device = {
 	.throttle =	     mct_u232_throttle,
 	.unthrottle =	     mct_u232_unthrottle,
 	.read_int_callback = mct_u232_read_int_callback,
-	.ioctl =	     mct_u232_ioctl,
 	.set_termios =	     mct_u232_set_termios,
 	.break_ctl =	     mct_u232_break_ctl,
 	.tiocmget =	     mct_u232_tiocmget,
@@ -224,8 +222,8 @@ static int mct_u232_calculate_baud_rate(struct usb_serial *serial, speed_t value
 	}
 }
 
-static int mct_u232_set_baud_rate(struct usb_serial *serial, struct usb_serial_port *port,
-				  speed_t value)
+static int mct_u232_set_baud_rate(struct tty_struct *tty,
+	struct usb_serial *serial, struct usb_serial_port *port, speed_t value)
 {
 	__le32 divisor;
         int rc;
@@ -243,7 +241,7 @@ static int mct_u232_set_baud_rate(struct usb_serial *serial, struct usb_serial_p
 	if (rc < 0)	/*FIXME: What value speed results */
 		err("Set BAUD RATE %d failed (error = %d)", value, rc);
 	else
-		tty_encode_baud_rate(port->tty, speed, speed);
+		tty_encode_baud_rate(tty, speed, speed);
 	dbg("set_baud_rate: value: 0x%x, divisor: 0x%x", value, divisor);
 
 	/* Mimic the MCT-supplied Windows driver (version 1.21P.0104), which
@@ -272,7 +270,7 @@ static int mct_u232_set_baud_rate(struct usb_serial *serial, struct usb_serial_p
 		err("Sending USB device request code %d failed (error = %d)", 
 		    MCT_U232_SET_UNKNOWN1_REQUEST, rc);
 
-	if (port && C_CRTSCTS(port->tty)) {
+	if (port && C_CRTSCTS(tty)) {
 	   cts_enable_byte = 1;
 	}
 
@@ -411,7 +409,8 @@ static void mct_u232_shutdown (struct usb_serial *serial)
 	}
 } /* mct_u232_shutdown */
 
-static int  mct_u232_open (struct usb_serial_port *port, struct file *filp)
+static int  mct_u232_open (struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
@@ -437,7 +436,7 @@ static int  mct_u232_open (struct usb_serial_port *port, struct file *filp)
 	 * either.
 	 */
 	spin_lock_irqsave(&priv->lock, flags);
-	if (port->tty->termios->c_cflag & CBAUD)
+	if (tty && (tty->termios->c_cflag & CBAUD))
 		priv->control_state = TIOCM_DTR | TIOCM_RTS;
 	else
 		priv->control_state = 0;
@@ -481,15 +480,16 @@ error:
 } /* mct_u232_open */
 
 
-static void mct_u232_close (struct usb_serial_port *port, struct file *filp)
+static void mct_u232_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	unsigned int c_cflag;
 	unsigned int control_state;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	dbg("%s port %d", __func__, port->number);
 
-   	if (port->tty) {
-		c_cflag = port->tty->termios->c_cflag;
+   	if (tty) {
+		c_cflag = tty->termios->c_cflag;
 		mutex_lock(&port->serial->disc_mutex);
 		if (c_cflag & HUPCL && !port->serial->disconnected) {
 			/* drop DTR and RTS */
@@ -553,7 +553,7 @@ static void mct_u232_read_int_callback (struct urb *urb)
 	 */
 	if (urb->transfer_buffer_length > 2) {
 		int i;
-		tty = port->tty;
+		tty = port->port.tty;
 		if (urb->actual_length) {
 			for (i = 0; i < urb->actual_length ; ++i) {
 				tty_insert_flip_char(tty, data[i], 0);
@@ -583,7 +583,7 @@ static void mct_u232_read_int_callback (struct urb *urb)
 	 * to look in to this before committing any code.
 	 */
 	if (priv->last_lsr & MCT_U232_LSR_ERR) {
-		tty = port->tty;
+		tty = port->port.tty;
 		/* Overrun Error */
 		if (priv->last_lsr & MCT_U232_LSR_OE) {
 		}
@@ -606,12 +606,13 @@ exit:
 		     __func__, retval);
 } /* mct_u232_read_int_callback */
 
-static void mct_u232_set_termios (struct usb_serial_port *port,
+static void mct_u232_set_termios (struct tty_struct *tty,
+				  struct usb_serial_port *port,
 				  struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
-	struct ktermios *termios = port->tty->termios;
+	struct ktermios *termios = tty->termios;
 	unsigned int cflag = termios->c_cflag;
 	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned long flags;
@@ -638,7 +639,7 @@ static void mct_u232_set_termios (struct usb_serial_port *port,
 		mct_u232_set_modem_ctrl(serial, control_state);
 	}
 
-	mct_u232_set_baud_rate(serial, port, tty_get_baud_rate(port->tty));
+	mct_u232_set_baud_rate(tty, serial, port, tty_get_baud_rate(tty));
 
 	if ((cflag & CBAUD) == B0 ) {
 		dbg("%s: baud is B0", __func__);
@@ -689,8 +690,9 @@ static void mct_u232_set_termios (struct usb_serial_port *port,
 	spin_unlock_irqrestore(&priv->lock, flags);
 } /* mct_u232_set_termios */
 
-static void mct_u232_break_ctl( struct usb_serial_port *port, int break_state )
+static void mct_u232_break_ctl(struct tty_struct *tty, int break_state)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	unsigned char lcr;
@@ -709,8 +711,9 @@ static void mct_u232_break_ctl( struct usb_serial_port *port, int break_state )
 } /* mct_u232_break_ctl */
 
 
-static int mct_u232_tiocmget (struct usb_serial_port *port, struct file *file)
+static int mct_u232_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	unsigned int control_state;
 	unsigned long flags;
@@ -724,9 +727,10 @@ static int mct_u232_tiocmget (struct usb_serial_port *port, struct file *file)
 	return control_state;
 }
 
-static int mct_u232_tiocmset (struct usb_serial_port *port, struct file *file,
+static int mct_u232_tiocmset(struct tty_struct *tty, struct file *file,
 			      unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	unsigned int control_state;
@@ -751,73 +755,46 @@ static int mct_u232_tiocmset (struct usb_serial_port *port, struct file *file,
 	return mct_u232_set_modem_ctrl(serial, control_state);
 }
 
-static int mct_u232_ioctl (struct usb_serial_port *port, struct file * file,
-			   unsigned int cmd, unsigned long arg)
-{
-	dbg("%scmd=0x%x", __func__, cmd);
-
-	/* Based on code from acm.c and others */
-	switch (cmd) {
-	case TIOCMIWAIT:
-		/* wait for any of the 4 modem inputs (DCD,RI,DSR,CTS)*/
-		/* TODO */
-		return( 0 );
-
-	case TIOCGICOUNT:
-		/* return count of modemline transitions */
-		/* TODO */
-		return 0;
-
-	default:
-		dbg("%s: arg not supported - 0x%04x", __func__,cmd);
-		return(-ENOIOCTLCMD);
-		break;
-	}
-	return 0;
-} /* mct_u232_ioctl */
-
-static void mct_u232_throttle (struct usb_serial_port *port)
+static void mct_u232_throttle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	unsigned int control_state;
-	struct tty_struct *tty;
 
-	tty = port->tty;
 	dbg("%s - port %d", __func__, port->number);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->rx_flags |= THROTTLED;
 	if (C_CRTSCTS(tty)) {
-	  priv->control_state &= ~TIOCM_RTS;
-	  control_state = priv->control_state;
-	  spin_unlock_irqrestore(&priv->lock, flags);
-	  (void) mct_u232_set_modem_ctrl(port->serial, control_state);
+		priv->control_state &= ~TIOCM_RTS;
+		control_state = priv->control_state;
+		spin_unlock_irqrestore(&priv->lock, flags);
+		(void) mct_u232_set_modem_ctrl(port->serial, control_state);
 	} else {
-	  spin_unlock_irqrestore(&priv->lock, flags);
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 }
 
 
-static void mct_u232_unthrottle (struct usb_serial_port *port)
+static void mct_u232_unthrottle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	unsigned int control_state;
-	struct tty_struct *tty;
 
 	dbg("%s - port %d", __func__, port->number);
 
-	tty = port->tty;
 	spin_lock_irqsave(&priv->lock, flags);
 	if ((priv->rx_flags & THROTTLED) && C_CRTSCTS(tty)) {
-	  priv->rx_flags &= ~THROTTLED;
-	  priv->control_state |= TIOCM_RTS;
-	  control_state = priv->control_state;
-	  spin_unlock_irqrestore(&priv->lock, flags);
-	  (void) mct_u232_set_modem_ctrl(port->serial, control_state);
+		priv->rx_flags &= ~THROTTLED;
+		priv->control_state |= TIOCM_RTS;
+		control_state = priv->control_state;
+		spin_unlock_irqrestore(&priv->lock, flags);
+		(void) mct_u232_set_modem_ctrl(port->serial, control_state);
 	} else {
-	  spin_unlock_irqrestore(&priv->lock, flags);
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 }
 
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 50f1fe2..d47f081 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -218,7 +218,7 @@ static void mos7720_bulk_in_callback(struct urb *urb)
 
 	data = urb->transfer_buffer;
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (tty && urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
@@ -264,7 +264,7 @@ static void mos7720_bulk_out_data_callback(struct urb *urb)
 
 	dbg("Entering .........");
 
-	tty = mos7720_port->port->tty;
+	tty = mos7720_port->port->port.tty;
 
 	if (tty && mos7720_port->open)
 		tty_wakeup(tty);
@@ -320,7 +320,8 @@ static int send_mos_cmd(struct usb_serial *serial, __u8 request, __u16 value,
 	return status;
 }
 
-static int mos7720_open(struct usb_serial_port *port, struct file * filp)
+static int mos7720_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file * filp)
 {
 	struct usb_serial *serial;
 	struct usb_serial_port *port0;
@@ -443,14 +444,12 @@ static int mos7720_open(struct usb_serial_port *port, struct file * filp)
 	data = 0x0c;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x01, &data);
 
-//Matrix
-
 	/* force low_latency on so that our tty_push actually forces *
 	 * the data through,otherwise it is scheduled, and with      *
 	 * high data rates (like with OHCI) data can get lost.       */
 
-	if (port->tty)
-		port->tty->low_latency = 1;
+	if (tty)
+		tty->low_latency = 1;
 
 	/* see if we've set up our endpoint info yet   *
 	 * (can't set it up in mos7720_startup as the  *
@@ -515,8 +514,9 @@ static int mos7720_open(struct usb_serial_port *port, struct file * filp)
  *	system,
  *	Otherwise we return a negative error number.
  */
-static int mos7720_chars_in_buffer(struct usb_serial_port *port)
+static int mos7720_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	int i;
 	int chars = 0;
 	struct moschip_port *mos7720_port;
@@ -537,7 +537,8 @@ static int mos7720_chars_in_buffer(struct usb_serial_port *port)
 	return chars;
 }
 
-static void mos7720_close(struct usb_serial_port *port, struct file *filp)
+static void mos7720_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial *serial;
 	struct moschip_port *mos7720_port;
@@ -588,8 +589,9 @@ static void mos7720_close(struct usb_serial_port *port, struct file *filp)
 	dbg("Leaving %s", __func__);
 }
 
-static void mos7720_break(struct usb_serial_port *port, int break_state)
+static void mos7720_break(struct tty_struct *tty, int break_state)
 {
+	struct usb_serial_port *port = tty->driver_data;
         unsigned char data;
 	struct usb_serial *serial;
 	struct moschip_port *mos7720_port;
@@ -621,8 +623,9 @@ static void mos7720_break(struct usb_serial_port *port, int break_state)
  *	If successful, we return the amount of room that we have for this port
  *	Otherwise we return a negative error number.
  */
-static int mos7720_write_room(struct usb_serial_port *port)
+static int mos7720_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct moschip_port *mos7720_port;
 	int room = 0;
 	int i;
@@ -645,8 +648,8 @@ static int mos7720_write_room(struct usb_serial_port *port)
 	return room;
 }
 
-static int mos7720_write(struct usb_serial_port *port,
-			 const unsigned char *data, int count)
+static int mos7720_write(struct tty_struct *tty, struct usb_serial_port *port,
+				 const unsigned char *data, int count)
 {
 	int status;
 	int i;
@@ -719,10 +722,10 @@ exit:
 	return bytes_sent;
 }
 
-static void mos7720_throttle(struct usb_serial_port *port)
+static void mos7720_throttle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct moschip_port *mos7720_port;
-	struct tty_struct *tty;
 	int status;
 
 	dbg("%s- port %d\n", __func__, port->number);
@@ -739,16 +742,10 @@ static void mos7720_throttle(struct usb_serial_port *port)
 
 	dbg("%s: Entering ..........", __func__);
 
-	tty = port->tty;
-	if (!tty) {
-		dbg("%s - no tty available", __func__);
-		return;
-	}
-
 	/* if we are implementing XON/XOFF, send the stop character */
 	if (I_IXOFF(tty)) {
 		unsigned char stop_char = STOP_CHAR(tty);
-		status = mos7720_write(port, &stop_char, 1);
+		status = mos7720_write(tty, port, &stop_char, 1);
 		if (status <= 0)
 			return;
 	}
@@ -764,11 +761,11 @@ static void mos7720_throttle(struct usb_serial_port *port)
 	}
 }
 
-static void mos7720_unthrottle(struct usb_serial_port *port)
+static void mos7720_unthrottle(struct tty_struct *tty)
 {
-	struct tty_struct *tty;
-	int status;
+	struct usb_serial_port *port = tty->driver_data;
 	struct moschip_port *mos7720_port = usb_get_serial_port_data(port);
+	int status;
 
 	if (mos7720_port == NULL)
 		return;
@@ -780,16 +777,10 @@ static void mos7720_unthrottle(struct usb_serial_port *port)
 
 	dbg("%s: Entering ..........", __func__);
 
-	tty = port->tty;
-	if (!tty) {
-		dbg("%s - no tty available", __func__);
-		return;
-	}
-
 	/* if we are implementing XON/XOFF, send the start character */
 	if (I_IXOFF(tty)) {
 		unsigned char start_char = START_CHAR(tty);
-		status = mos7720_write(port, &start_char, 1);
+		status = mos7720_write(tty, port, &start_char, 1);
 		if (status <= 0)
 			return;
 	}
@@ -1011,12 +1002,12 @@ static int send_cmd_write_baud_rate(struct moschip_port *mos7720_port,
  *	This routine is called to set the UART on the device to match
  *      the specified new settings.
  */
-static void change_port_settings(struct moschip_port *mos7720_port,
+static void change_port_settings(struct tty_struct *tty,
+				 struct moschip_port *mos7720_port,
 				 struct ktermios *old_termios)
 {
 	struct usb_serial_port *port;
 	struct usb_serial *serial;
-	struct tty_struct *tty;
 	int baud;
 	unsigned cflag;
 	unsigned iflag;
@@ -1042,8 +1033,6 @@ static void change_port_settings(struct moschip_port *mos7720_port,
 		return;
 	}
 
-	tty = mos7720_port->port->tty;
-
 	dbg("%s: Entering ..........", __func__);
 
 	lData = UART_LCR_WLEN8;
@@ -1198,14 +1187,13 @@ static void change_port_settings(struct moschip_port *mos7720_port,
  *	this function is called by the tty driver when it wants to change the
  *	termios structure.
  */
-static void mos7720_set_termios(struct usb_serial_port *port,
-				struct ktermios *old_termios)
+static void mos7720_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	int status;
 	unsigned int cflag;
 	struct usb_serial *serial;
 	struct moschip_port *mos7720_port;
-	struct tty_struct *tty;
 
 	serial = port->serial;
 
@@ -1214,9 +1202,6 @@ static void mos7720_set_termios(struct usb_serial_port *port,
 	if (mos7720_port == NULL)
 		return;
 
-	tty = port->tty;
-
-
 	if (!mos7720_port->open) {
 		dbg("%s - port not opened", __func__);
 		return;
@@ -1237,7 +1222,7 @@ static void mos7720_set_termios(struct usb_serial_port *port,
 	dbg("%s - port %d", __func__, port->number);
 
 	/* change the port settings to the new ones specified */
-	change_port_settings(mos7720_port, old_termios);
+	change_port_settings(tty, mos7720_port, old_termios);
 
 	if(!port->read_urb) {
 		dbg("%s","URB KILLED !!!!!\n");
@@ -1264,13 +1249,13 @@ static void mos7720_set_termios(struct usb_serial_port *port,
  * 	    transmit holding register is empty.  This functionality
  * 	    allows an RS485 driver to be written in user space.
  */
-static int get_lsr_info(struct moschip_port *mos7720_port,
+static int get_lsr_info(struct tty_struct *tty, struct moschip_port *mos7720_port,
 			unsigned int __user *value)
 {
 	int count;
 	unsigned int result = 0;
 
-	count = mos7720_chars_in_buffer(mos7720_port->port);
+	count = mos7720_chars_in_buffer(tty);
 	if (count == 0) {
 		dbg("%s -- Empty", __func__);
 		result = TIOCSER_TEMT;
@@ -1290,7 +1275,7 @@ static int get_number_bytes_avail(struct moschip_port *mos7720_port,
 				  unsigned int __user *value)
 {
 	unsigned int result = 0;
-	struct tty_struct *tty = mos7720_port->port->tty;
+	struct tty_struct *tty = mos7720_port->port->port.tty;
 
 	if (!tty)
 		return -ENOIOCTLCMD;
@@ -1407,9 +1392,10 @@ static int get_serial_info(struct moschip_port *mos7720_port,
 	return 0;
 }
 
-static int mos7720_ioctl(struct usb_serial_port *port, struct file *file,
+static int mos7720_ioctl(struct tty_struct *tty, struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct moschip_port *mos7720_port;
 	struct async_icount cnow;
 	struct async_icount cprev;
@@ -1431,9 +1417,10 @@ static int mos7720_ioctl(struct usb_serial_port *port, struct file *file,
 
 	case TIOCSERGETLSR:
 		dbg("%s (%d) TIOCSERGETLSR", __func__,  port->number);
-		return get_lsr_info(mos7720_port, (unsigned int __user *)arg);
+		return get_lsr_info(tty, mos7720_port, (unsigned int __user *)arg);
 		return 0;
 
+	/* FIXME: These should be using the mode methods */
 	case TIOCMBIS:
 	case TIOCMBIC:
 	case TIOCMSET:
@@ -1452,10 +1439,6 @@ static int mos7720_ioctl(struct usb_serial_port *port, struct file *file,
 		return get_serial_info(mos7720_port,
 				       (struct serial_struct __user *)arg);
 
-	case TIOCSSERIAL:
-		dbg("%s (%d) TIOCSSERIAL", __func__,  port->number);
-		break;
-
 	case TIOCMIWAIT:
 		dbg("%s (%d) TIOCMIWAIT", __func__,  port->number);
 		cprev = mos7720_port->icount;
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 78f2f6d..2b1fded 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -710,7 +710,7 @@ static void mos7840_bulk_in_callback(struct urb *urb)
 	dbg("%s", "Entering ........... \n");
 
 	if (urb->actual_length) {
-		tty = mos7840_port->port->tty;
+		tty = mos7840_port->port->port.tty;
 		if (tty) {
 			tty_buffer_request_room(tty, urb->actual_length);
 			tty_insert_flip_string(tty, data, urb->actual_length);
@@ -774,7 +774,7 @@ static void mos7840_bulk_out_data_callback(struct urb *urb)
 
 	dbg("%s \n", "Entering .........");
 
-	tty = mos7840_port->port->tty;
+	tty = mos7840_port->port->port.tty;
 
 	if (tty && mos7840_port->open)
 		tty_wakeup(tty);
@@ -804,7 +804,8 @@ static int mos7840_serial_probe(struct usb_serial *serial,
  *	Otherwise we return a negative error number.
  *****************************************************************************/
 
-static int mos7840_open(struct usb_serial_port *port, struct file *filp)
+static int mos7840_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	int response;
 	int j;
@@ -1008,8 +1009,8 @@ static int mos7840_open(struct usb_serial_port *port, struct file *filp)
 	 * the data through,otherwise it is scheduled, and with      *
 	 * high data rates (like with OHCI) data can get lost.       */
 
-	if (port->tty)
-		port->tty->low_latency = 1;
+	if (tty)
+		tty->low_latency = 1;
 /* Check to see if we've set up our endpoint info yet    *
      * (can't set it up in mos7840_startup as the structures *
      * were not set up at that time.)                        */
@@ -1104,11 +1105,12 @@ static int mos7840_open(struct usb_serial_port *port, struct file *filp)
  *	been written, but hasn't made it out the port yet)
  *	If successful, we return the number of bytes left to be written in the
  *	system,
- *	Otherwise we return a negative error number.
+ *	Otherwise we return zero.
  *****************************************************************************/
 
-static int mos7840_chars_in_buffer(struct usb_serial_port *port)
+static int mos7840_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	int i;
 	int chars = 0;
 	unsigned long flags;
@@ -1118,21 +1120,19 @@ static int mos7840_chars_in_buffer(struct usb_serial_port *port)
 
 	if (mos7840_port_paranoia_check(port, __func__)) {
 		dbg("%s", "Invalid port \n");
-		return -1;
+		return 0;
 	}
 
 	mos7840_port = mos7840_get_port_private(port);
 	if (mos7840_port == NULL) {
 		dbg("%s \n", "mos7840_break:leaving ...........");
-		return -1;
+		return 0;
 	}
 
 	spin_lock_irqsave(&mos7840_port->pool_lock,flags);
-	for (i = 0; i < NUM_URBS; ++i) {
-		if (mos7840_port->busy[i]) {
+	for (i = 0; i < NUM_URBS; ++i)
+		if (mos7840_port->busy[i])
 			chars += URB_TRANSFER_BUFFER_SIZE;
-		}
-	}
 	spin_unlock_irqrestore(&mos7840_port->pool_lock,flags);
 	dbg("%s - returns %d", __func__, chars);
 	return chars;
@@ -1149,7 +1149,8 @@ static int mos7840_chars_in_buffer(struct usb_serial_port *port)
  *		3. A timeout of 3 seconds without activity has expired
  *
  ************************************************************************/
-static void mos7840_block_until_tx_empty(struct moschip_port *mos7840_port)
+static void mos7840_block_until_tx_empty(struct tty_struct *tty,
+				struct moschip_port *mos7840_port)
 {
 	int timeout = HZ / 10;
 	int wait = 30;
@@ -1157,7 +1158,7 @@ static void mos7840_block_until_tx_empty(struct moschip_port *mos7840_port)
 
 	while (1) {
 
-		count = mos7840_chars_in_buffer(mos7840_port->port);
+		count = mos7840_chars_in_buffer(tty);
 
 		/* Check for Buffer status */
 		if (count <= 0) {
@@ -1185,7 +1186,8 @@ static void mos7840_block_until_tx_empty(struct moschip_port *mos7840_port)
  *	this function is called by the tty driver when a port is closed
  *****************************************************************************/
 
-static void mos7840_close(struct usb_serial_port *port, struct file *filp)
+static void mos7840_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial *serial;
 	struct moschip_port *mos7840_port;
@@ -1226,20 +1228,17 @@ static void mos7840_close(struct usb_serial_port *port, struct file *filp)
 		}
 	}
 
-	if (serial->dev) {
+	if (serial->dev)
 		/* flush and block until tx is empty */
-		mos7840_block_until_tx_empty(mos7840_port);
-	}
+		mos7840_block_until_tx_empty(tty, mos7840_port);
 
 	/* While closing port, shutdown all bulk read, write  *
 	 * and interrupt read if they exists                  */
 	if (serial->dev) {
-
 		if (mos7840_port->write_urb) {
 			dbg("%s", "Shutdown bulk write\n");
 			usb_kill_urb(mos7840_port->write_urb);
 		}
-
 		if (mos7840_port->read_urb) {
 			dbg("%s", "Shutdown bulk read\n");
 			usb_kill_urb(mos7840_port->read_urb);
@@ -1247,11 +1246,10 @@ static void mos7840_close(struct usb_serial_port *port, struct file *filp)
 		if ((&mos7840_port->control_urb)) {
 			dbg("%s", "Shutdown control read\n");
 			//      usb_kill_urb (mos7840_port->control_urb);
-
 		}
 	}
-//              if(mos7840_port->ctrl_buf != NULL)
-//                      kfree(mos7840_port->ctrl_buf);
+//      if(mos7840_port->ctrl_buf != NULL)
+//              kfree(mos7840_port->ctrl_buf);
 	port0->open_ports--;
 	dbg("mos7840_num_open_ports in close%d:in port%d\n",
 	    port0->open_ports, port->number);
@@ -1293,15 +1291,15 @@ static void mos7840_close(struct usb_serial_port *port, struct file *filp)
  *
  ************************************************************************/
 
-static void mos7840_block_until_chase_response(struct moschip_port
-					       *mos7840_port)
+static void mos7840_block_until_chase_response(struct tty_struct *tty,
+					struct moschip_port *mos7840_port)
 {
 	int timeout = 1 * HZ;
 	int wait = 10;
 	int count;
 
 	while (1) {
-		count = mos7840_chars_in_buffer(mos7840_port->port);
+		count = mos7840_chars_in_buffer(tty);
 
 		/* Check for Buffer status */
 		if (count <= 0) {
@@ -1328,8 +1326,9 @@ static void mos7840_block_until_chase_response(struct moschip_port
  * mos7840_break
  *	this function sends a break to the port
  *****************************************************************************/
-static void mos7840_break(struct usb_serial_port *port, int break_state)
+static void mos7840_break(struct tty_struct *tty, int break_state)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	unsigned char data;
 	struct usb_serial *serial;
 	struct moschip_port *mos7840_port;
@@ -1354,17 +1353,14 @@ static void mos7840_break(struct usb_serial_port *port, int break_state)
 		return;
 	}
 
-	if (serial->dev) {
-
+	if (serial->dev)
 		/* flush and block until tx is empty */
-		mos7840_block_until_chase_response(mos7840_port);
-	}
+		mos7840_block_until_chase_response(tty, mos7840_port);
 
-	if (break_state == -1) {
+	if (break_state == -1)
 		data = mos7840_port->shadowLCR | LCR_SET_BREAK;
-	} else {
+	else
 		data = mos7840_port->shadowLCR & ~LCR_SET_BREAK;
-	}
 
 	mos7840_port->shadowLCR = data;
 	dbg("mcs7840_break mos7840_port->shadowLCR is %x\n",
@@ -1383,8 +1379,9 @@ static void mos7840_break(struct usb_serial_port *port, int break_state)
  *	Otherwise we return a negative error number.
  *****************************************************************************/
 
-static int mos7840_write_room(struct usb_serial_port *port)
+static int mos7840_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	int i;
 	int room = 0;
 	unsigned long flags;
@@ -1426,7 +1423,7 @@ static int mos7840_write_room(struct usb_serial_port *port)
  *      return a negative error number.
  *****************************************************************************/
 
-static int mos7840_write(struct usb_serial_port *port,
+static int mos7840_write(struct tty_struct *tty, struct usb_serial_port *port,
 			 const unsigned char *data, int count)
 {
 	int status;
@@ -1555,8 +1552,7 @@ static int mos7840_write(struct usb_serial_port *port,
 	mos7840_port->icount.tx += transfer_size;
 	smp_wmb();
 	dbg("mos7840_port->icount.tx is %d:\n", mos7840_port->icount.tx);
-      exit:
-
+exit:
 	return bytes_sent;
 
 }
@@ -1567,10 +1563,10 @@ static int mos7840_write(struct usb_serial_port *port,
  *	being read from the port.
  *****************************************************************************/
 
-static void mos7840_throttle(struct usb_serial_port *port)
+static void mos7840_throttle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct moschip_port *mos7840_port;
-	struct tty_struct *tty;
 	int status;
 
 	if (mos7840_port_paranoia_check(port, __func__)) {
@@ -1592,32 +1588,21 @@ static void mos7840_throttle(struct usb_serial_port *port)
 
 	dbg("%s", "Entering .......... \n");
 
-	tty = port->tty;
-	if (!tty) {
-		dbg("%s - no tty available", __func__);
-		return;
-	}
-
 	/* if we are implementing XON/XOFF, send the stop character */
 	if (I_IXOFF(tty)) {
 		unsigned char stop_char = STOP_CHAR(tty);
-		status = mos7840_write(port, &stop_char, 1);
-		if (status <= 0) {
+		status = mos7840_write(tty, port, &stop_char, 1);
+		if (status <= 0)
 			return;
-		}
 	}
-
 	/* if we are implementing RTS/CTS, toggle that line */
 	if (tty->termios->c_cflag & CRTSCTS) {
 		mos7840_port->shadowMCR &= ~MCR_RTS;
 		status = 0;
-		status =
-		    mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER,
+		status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER,
 					 mos7840_port->shadowMCR);
-
-		if (status < 0) {
+		if (status < 0)
 			return;
-		}
 	}
 
 	return;
@@ -1628,9 +1613,9 @@ static void mos7840_throttle(struct usb_serial_port *port)
  *	this function is called by the tty driver when it wants to resume the data
  *	being read from the port (called after SerialThrottle is called)
  *****************************************************************************/
-static void mos7840_unthrottle(struct usb_serial_port *port)
+static void mos7840_unthrottle(struct tty_struct *tty)
 {
-	struct tty_struct *tty;
+	struct usb_serial_port *port = tty->driver_data;
 	int status;
 	struct moschip_port *mos7840_port = mos7840_get_port_private(port);
 
@@ -1649,38 +1634,28 @@ static void mos7840_unthrottle(struct usb_serial_port *port)
 
 	dbg("%s", "Entering .......... \n");
 
-	tty = port->tty;
-	if (!tty) {
-		dbg("%s - no tty available", __func__);
-		return;
-	}
-
 	/* if we are implementing XON/XOFF, send the start character */
 	if (I_IXOFF(tty)) {
 		unsigned char start_char = START_CHAR(tty);
-		status = mos7840_write(port, &start_char, 1);
-		if (status <= 0) {
+		status = mos7840_write(tty, port, &start_char, 1);
+		if (status <= 0)
 			return;
-		}
 	}
 
 	/* if we are implementing RTS/CTS, toggle that line */
 	if (tty->termios->c_cflag & CRTSCTS) {
 		mos7840_port->shadowMCR |= MCR_RTS;
 		status = 0;
-		status =
-		    mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER,
+		status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER,
 					 mos7840_port->shadowMCR);
-		if (status < 0) {
+		if (status < 0)
 			return;
-		}
 	}
-
-	return;
 }
 
-static int mos7840_tiocmget(struct usb_serial_port *port, struct file *file)
+static int mos7840_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct moschip_port *mos7840_port;
 	unsigned int result;
 	__u16 msr;
@@ -1708,9 +1683,10 @@ static int mos7840_tiocmget(struct usb_serial_port *port, struct file *file)
 	return result;
 }
 
-static int mos7840_tiocmset(struct usb_serial_port *port, struct file *file,
+static int mos7840_tiocmset(struct tty_struct *tty, struct file *file,
 			    unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct moschip_port *mos7840_port;
 	unsigned int mcr;
 	int status;
@@ -1949,10 +1925,9 @@ static int mos7840_send_cmd_write_baud_rate(struct moschip_port *mos7840_port,
  *      the specified new settings.
  *****************************************************************************/
 
-static void mos7840_change_port_settings(struct moschip_port *mos7840_port,
-					 struct ktermios *old_termios)
+static void mos7840_change_port_settings(struct tty_struct *tty,
+	struct moschip_port *mos7840_port, struct ktermios *old_termios)
 {
-	struct tty_struct *tty;
 	int baud;
 	unsigned cflag;
 	unsigned iflag;
@@ -1988,8 +1963,6 @@ static void mos7840_change_port_settings(struct moschip_port *mos7840_port,
 		return;
 	}
 
-	tty = mos7840_port->port->tty;
-
 	dbg("%s", "Entering .......... \n");
 
 	lData = LCR_BITS_8;
@@ -2131,14 +2104,14 @@ static void mos7840_change_port_settings(struct moschip_port *mos7840_port,
  *	the termios structure
  *****************************************************************************/
 
-static void mos7840_set_termios(struct usb_serial_port *port,
+static void mos7840_set_termios(struct tty_struct *tty,
+				struct usb_serial_port *port,
 				struct ktermios *old_termios)
 {
 	int status;
 	unsigned int cflag;
 	struct usb_serial *serial;
 	struct moschip_port *mos7840_port;
-	struct tty_struct *tty;
 	dbg("mos7840_set_termios: START\n");
 	if (mos7840_port_paranoia_check(port, __func__)) {
 		dbg("%s", "Invalid port \n");
@@ -2157,8 +2130,6 @@ static void mos7840_set_termios(struct usb_serial_port *port,
 	if (mos7840_port == NULL)
 		return;
 
-	tty = port->tty;
-
 	if (!mos7840_port->open) {
 		dbg("%s - port not opened", __func__);
 		return;
@@ -2176,7 +2147,7 @@ static void mos7840_set_termios(struct usb_serial_port *port,
 
 	/* change the port settings to the new ones specified */
 
-	mos7840_change_port_settings(mos7840_port, old_termios);
+	mos7840_change_port_settings(tty, mos7840_port, old_termios);
 
 	if (!mos7840_port->read_urb) {
 		dbg("%s", "URB KILLED !!!!!\n");
@@ -2205,13 +2176,13 @@ static void mos7840_set_termios(struct usb_serial_port *port,
  * 	    allows an RS485 driver to be written in user space.
  *****************************************************************************/
 
-static int mos7840_get_lsr_info(struct moschip_port *mos7840_port,
+static int mos7840_get_lsr_info(struct tty_struct *tty,
 				unsigned int __user *value)
 {
 	int count;
 	unsigned int result = 0;
 
-	count = mos7840_chars_in_buffer(mos7840_port->port);
+	count = mos7840_chars_in_buffer(tty);
 	if (count == 0) {
 		dbg("%s -- Empty", __func__);
 		result = TIOCSER_TEMT;
@@ -2227,6 +2198,8 @@ static int mos7840_get_lsr_info(struct moschip_port *mos7840_port,
  *      function to set modem info
  *****************************************************************************/
 
+/* FIXME: Should be using the model control hooks */
+
 static int mos7840_set_modem_info(struct moschip_port *mos7840_port,
 				  unsigned int cmd, unsigned int __user *value)
 {
@@ -2304,9 +2277,8 @@ static int mos7840_get_modem_info(struct moschip_port *mos7840_port,
 	__u16 msr;
 	unsigned int mcr = mos7840_port->shadowMCR;
 	int status = 0;
-	status =
-	    mos7840_get_uart_reg(mos7840_port->port, MODEM_STATUS_REGISTER,
-				 &msr);
+	status = mos7840_get_uart_reg(mos7840_port->port,
+						MODEM_STATUS_REGISTER, &msr);
 	result = ((mcr & MCR_DTR) ? TIOCM_DTR : 0)	/* 0x002 */
 	    |((mcr & MCR_RTS) ? TIOCM_RTS : 0)	/* 0x004 */
 	    |((msr & MOS7840_MSR_CTS) ? TIOCM_CTS : 0)	/* 0x020 */
@@ -2359,12 +2331,12 @@ static int mos7840_get_serial_info(struct moschip_port *mos7840_port,
  *	this function handles any ioctl calls to the driver
  *****************************************************************************/
 
-static int mos7840_ioctl(struct usb_serial_port *port, struct file *file,
+static int mos7840_ioctl(struct tty_struct *tty, struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	void __user *argp = (void __user *)arg;
 	struct moschip_port *mos7840_port;
-	struct tty_struct *tty;
 
 	struct async_icount cnow;
 	struct async_icount cprev;
@@ -2381,8 +2353,6 @@ static int mos7840_ioctl(struct usb_serial_port *port, struct file *file,
 	if (mos7840_port == NULL)
 		return -1;
 
-	tty = mos7840_port->port->tty;
-
 	dbg("%s - port %d, cmd = 0x%x", __func__, port->number, cmd);
 
 	switch (cmd) {
@@ -2390,9 +2360,10 @@ static int mos7840_ioctl(struct usb_serial_port *port, struct file *file,
 
 	case TIOCSERGETLSR:
 		dbg("%s (%d) TIOCSERGETLSR", __func__, port->number);
-		return mos7840_get_lsr_info(mos7840_port, argp);
+		return mos7840_get_lsr_info(tty, argp);
 		return 0;
 
+	/* FIXME: use the modem hooks and remove this */
 	case TIOCMBIS:
 	case TIOCMBIC:
 	case TIOCMSET:
@@ -2463,13 +2434,9 @@ static int mos7840_ioctl(struct usb_serial_port *port, struct file *file,
 		if (copy_to_user(argp, &icount, sizeof(icount)))
 			return -EFAULT;
 		return 0;
-
-	case TIOCEXBAUD:
-		return 0;
 	default:
 		break;
 	}
-
 	return -ENOIOCTLCMD;
 }
 
diff --git a/drivers/usb/serial/navman.c b/drivers/usb/serial/navman.c
index 43c8894..d673653 100644
--- a/drivers/usb/serial/navman.c
+++ b/drivers/usb/serial/navman.c
@@ -64,7 +64,7 @@ static void navman_read_int_callback(struct urb *urb)
 	usb_serial_debug_data(debug, &port->dev, __func__,
 			      urb->actual_length, data);
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (tty && urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
@@ -79,7 +79,8 @@ exit:
 			__func__, result);
 }
 
-static int navman_open(struct usb_serial_port *port, struct file *filp)
+static int navman_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	int result = 0;
 
@@ -96,14 +97,15 @@ static int navman_open(struct usb_serial_port *port, struct file *filp)
 	return result;
 }
 
-static void navman_close(struct usb_serial_port *port, struct file *filp)
+static void navman_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	dbg("%s - port %d", __func__, port->number);
 
 	usb_kill_urb(port->interrupt_in_urb);
 }
 
-static int navman_write(struct usb_serial_port *port,
+static int navman_write(struct tty_struct *tty, struct usb_serial_port *port,
 			const unsigned char *buf, int count)
 {
 	dbg("%s - port %d", __func__, port->number);
diff --git a/drivers/usb/serial/omninet.c b/drivers/usb/serial/omninet.c
index 7b7422f..5a2d045 100644
--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -61,12 +61,12 @@ static int debug;
 #define BT_IGNITIONPRO_ID	0x2000  /* This one seems to be a re-branded ZyXEL device */
 
 /* function prototypes */
-static int  omninet_open		(struct usb_serial_port *port, struct file *filp);
-static void omninet_close		(struct usb_serial_port *port, struct file *filp);
+static int  omninet_open		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static void omninet_close		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
 static void omninet_read_bulk_callback	(struct urb *urb);
 static void omninet_write_bulk_callback	(struct urb *urb);
-static int  omninet_write		(struct usb_serial_port *port, const unsigned char *buf, int count);
-static int  omninet_write_room		(struct usb_serial_port *port);
+static int  omninet_write		(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count);
+static int  omninet_write_room		(struct tty_struct *tty);
 static void omninet_shutdown		(struct usb_serial *serial);
 static int omninet_attach		(struct usb_serial *serial);
 
@@ -157,7 +157,8 @@ static int omninet_attach (struct usb_serial *serial)
 	return 0;
 }
 
-static int omninet_open (struct usb_serial_port *port, struct file *filp)
+static int omninet_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial	*serial = port->serial;
 	struct usb_serial_port	*wport;
@@ -166,7 +167,7 @@ static int omninet_open (struct usb_serial_port *port, struct file *filp)
 	dbg("%s - port %d", __func__, port->number);
 
 	wport = serial->port[1];
-	wport->tty = port->tty;
+	wport->port.tty = tty;		/* FIXME */
 
 	/* Start reading from the device */
 	usb_fill_bulk_urb(port->read_urb, serial->dev, 
@@ -181,7 +182,8 @@ static int omninet_open (struct usb_serial_port *port, struct file *filp)
 	return result;
 }
 
-static void omninet_close (struct usb_serial_port *port, struct file * filp)
+static void omninet_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file * filp)
 {
 	dbg("%s - port %d", __func__, port->number);
 	usb_kill_urb(port->read_urb);
@@ -221,9 +223,9 @@ static void omninet_read_bulk_callback (struct urb *urb)
 
 	if (urb->actual_length && header->oh_len) {
 		for (i = 0; i < header->oh_len; i++) {
-			 tty_insert_flip_char(port->tty, data[OMNINET_DATAOFFSET + i], 0);
+			 tty_insert_flip_char(port->port.tty, data[OMNINET_DATAOFFSET + i], 0);
 	  	}
-	  	tty_flip_buffer_push(port->tty);
+	  	tty_flip_buffer_push(port->port.tty);
 	}
 
 	/* Continue trying to always read  */
@@ -238,7 +240,8 @@ static void omninet_read_bulk_callback (struct urb *urb)
 	return;
 }
 
-static int omninet_write (struct usb_serial_port *port, const unsigned char *buf, int count)
+static int omninet_write(struct tty_struct *tty, struct usb_serial_port *port,
+					const unsigned char *buf, int count)
 {
 	struct usb_serial 	*serial	= port->serial;
 	struct usb_serial_port 	*wport	= serial->port[1];
@@ -290,8 +293,9 @@ static int omninet_write (struct usb_serial_port *port, const unsigned char *buf
 }
 
 
-static int omninet_write_room (struct usb_serial_port *port)
+static int omninet_write_room (struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial 	*serial = port->serial;
 	struct usb_serial_port 	*wport 	= serial->port[1];
 
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 43cfde8..0e60408 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -43,29 +43,23 @@
 #include <linux/usb/serial.h>
 
 /* Function prototypes */
-static int  option_open(struct usb_serial_port *port, struct file *filp);
-static void option_close(struct usb_serial_port *port, struct file *filp);
+static int  option_open(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static void option_close(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
 static int  option_startup(struct usb_serial *serial);
 static void option_shutdown(struct usb_serial *serial);
-static void option_rx_throttle(struct usb_serial_port *port);
-static void option_rx_unthrottle(struct usb_serial_port *port);
-static int  option_write_room(struct usb_serial_port *port);
+static int  option_write_room(struct tty_struct *tty);
 
 static void option_instat_callback(struct urb *urb);
 
-static int option_write(struct usb_serial_port *port,
+static int option_write(struct tty_struct *tty, struct usb_serial_port *port,
 			const unsigned char *buf, int count);
-
-static int  option_chars_in_buffer(struct usb_serial_port *port);
-static int  option_ioctl(struct usb_serial_port *port, struct file *file,
-			unsigned int cmd, unsigned long arg);
-static void option_set_termios(struct usb_serial_port *port,
-				struct ktermios *old);
-static void option_break_ctl(struct usb_serial_port *port, int break_state);
-static int  option_tiocmget(struct usb_serial_port *port, struct file *file);
-static int  option_tiocmset(struct usb_serial_port *port, struct file *file,
+static int  option_chars_in_buffer(struct tty_struct *tty);
+static void option_set_termios(struct tty_struct *tty,
+			struct usb_serial_port *port, struct ktermios *old);
+static int  option_tiocmget(struct tty_struct *tty, struct file *file);
+static int  option_tiocmset(struct tty_struct *tty, struct file *file,
 				unsigned int set, unsigned int clear);
-static int  option_send_setup(struct usb_serial_port *port);
+static int  option_send_setup(struct tty_struct *tty, struct usb_serial_port *port);
 
 /* Vendor and product IDs */
 #define OPTION_VENDOR_ID			0x0AF0
@@ -339,11 +333,7 @@ static struct usb_serial_driver option_1port_device = {
 	.write             = option_write,
 	.write_room        = option_write_room,
 	.chars_in_buffer   = option_chars_in_buffer,
-	.throttle          = option_rx_throttle,
-	.unthrottle        = option_rx_unthrottle,
-	.ioctl             = option_ioctl,
 	.set_termios       = option_set_termios,
-	.break_ctl         = option_break_ctl,
 	.tiocmget          = option_tiocmget,
 	.tiocmset          = option_tiocmset,
 	.attach            = option_startup,
@@ -414,33 +404,18 @@ static void __exit option_exit(void)
 module_init(option_init);
 module_exit(option_exit);
 
-static void option_rx_throttle(struct usb_serial_port *port)
-{
-	dbg("%s", __func__);
-}
-
-static void option_rx_unthrottle(struct usb_serial_port *port)
-{
-	dbg("%s", __func__);
-}
-
-static void option_break_ctl(struct usb_serial_port *port, int break_state)
-{
-	/* Unfortunately, I don't know how to send a break */
-	dbg("%s", __func__);
-}
-
-static void option_set_termios(struct usb_serial_port *port,
-			struct ktermios *old_termios)
+static void option_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	dbg("%s", __func__);
 	/* Doesn't support option setting */
-	tty_termios_copy_hw(port->tty->termios, old_termios);
-	option_send_setup(port);
+	tty_termios_copy_hw(tty->termios, old_termios);
+	option_send_setup(tty, port);
 }
 
-static int option_tiocmget(struct usb_serial_port *port, struct file *file)
+static int option_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	unsigned int value;
 	struct option_port_private *portdata;
 
@@ -456,9 +431,10 @@ static int option_tiocmget(struct usb_serial_port *port, struct file *file)
 	return value;
 }
 
-static int option_tiocmset(struct usb_serial_port *port, struct file *file,
+static int option_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct option_port_private *portdata;
 
 	portdata = usb_get_serial_port_data(port);
@@ -473,17 +449,11 @@ static int option_tiocmset(struct usb_serial_port *port, struct file *file,
 		portdata->rts_state = 0;
 	if (clear & TIOCM_DTR)
 		portdata->dtr_state = 0;
-	return option_send_setup(port);
-}
-
-static int option_ioctl(struct usb_serial_port *port, struct file *file,
-			unsigned int cmd, unsigned long arg)
-{
-	return -ENOIOCTLCMD;
+	return option_send_setup(tty, port);
 }
 
 /* Write */
-static int option_write(struct usb_serial_port *port,
+static int option_write(struct tty_struct *tty, struct usb_serial_port *port,
 			const unsigned char *buf, int count)
 {
 	struct option_port_private *portdata;
@@ -559,7 +529,7 @@ static void option_indat_callback(struct urb *urb)
 		dbg("%s: nonzero status: %d on endpoint %02x.",
 		    __func__, status, endpoint);
 	} else {
-		tty = port->tty;
+		tty = port->port.tty;
 		if (urb->actual_length) {
 			tty_buffer_request_room(tty, urb->actual_length);
 			tty_insert_flip_string(tty, data, urb->actual_length);
@@ -569,7 +539,7 @@ static void option_indat_callback(struct urb *urb)
 		}
 
 		/* Resubmit urb so we continue receiving */
-		if (port->open_count && status != -ESHUTDOWN) {
+		if (port->port.count && status != -ESHUTDOWN) {
 			err = usb_submit_urb(urb, GFP_ATOMIC);
 			if (err)
 				printk(KERN_ERR "%s: resubmit read urb failed. "
@@ -635,9 +605,9 @@ static void option_instat_callback(struct urb *urb)
 			portdata->dsr_state = ((signals & 0x02) ? 1 : 0);
 			portdata->ri_state = ((signals & 0x08) ? 1 : 0);
 
-			if (port->tty && !C_CLOCAL(port->tty) &&
+			if (port->port.tty && !C_CLOCAL(port->port.tty) &&
 					old_dcd_state && !portdata->dcd_state)
-				tty_hangup(port->tty);
+				tty_hangup(port->port.tty);
 		} else {
 			dbg("%s: type %x req %x", __func__,
 				req_pkt->bRequestType,req_pkt->bRequest);
@@ -655,8 +625,9 @@ static void option_instat_callback(struct urb *urb)
 	}
 }
 
-static int option_write_room(struct usb_serial_port *port)
+static int option_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct option_port_private *portdata;
 	int i;
 	int data_len = 0;
@@ -675,8 +646,9 @@ static int option_write_room(struct usb_serial_port *port)
 	return data_len;
 }
 
-static int option_chars_in_buffer(struct usb_serial_port *port)
+static int option_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct option_port_private *portdata;
 	int i;
 	int data_len = 0;
@@ -695,7 +667,8 @@ static int option_chars_in_buffer(struct usb_serial_port *port)
 	return data_len;
 }
 
-static int option_open(struct usb_serial_port *port, struct file *filp)
+static int option_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct option_port_private *portdata;
 	struct usb_serial *serial = port->serial;
@@ -745,14 +718,16 @@ static int option_open(struct usb_serial_port *port, struct file *filp)
 				usb_pipeout(urb->pipe), 0); */
 	}
 
-	port->tty->low_latency = 1;
+	if (tty)
+		tty->low_latency = 1;
 
-	option_send_setup(port);
+	option_send_setup(tty, port);
 
 	return (0);
 }
 
-static void option_close(struct usb_serial_port *port, struct file *filp)
+static void option_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	int i;
 	struct usb_serial *serial = port->serial;
@@ -767,7 +742,7 @@ static void option_close(struct usb_serial_port *port, struct file *filp)
 	if (serial->dev) {
 		mutex_lock(&serial->disc_mutex);
 		if (!serial->disconnected)
-			option_send_setup(port);
+			option_send_setup(tty, port);
 		mutex_unlock(&serial->disc_mutex);
 
 		/* Stop reading/writing urbs */
@@ -776,7 +751,7 @@ static void option_close(struct usb_serial_port *port, struct file *filp)
 		for (i = 0; i < N_OUT_URB; i++)
 			usb_kill_urb(portdata->out_urbs[i]);
 	}
-	port->tty = NULL;
+	port->port.tty = NULL;	/* FIXME */
 }
 
 /* Helper functions used by option_setup_urbs */
@@ -838,7 +813,8 @@ static void option_setup_urbs(struct usb_serial *serial)
  * This is exactly the same as SET_CONTROL_LINE_STATE from the PSTN
  * CDC.
 */
-static int option_send_setup(struct usb_serial_port *port)
+static int option_send_setup(struct tty_struct *tty,
+						struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
 	struct option_port_private *portdata;
@@ -847,7 +823,7 @@ static int option_send_setup(struct usb_serial_port *port)
 
 	portdata = usb_get_serial_port_data(port);
 
-	if (port->tty) {
+	if (tty) {
 		int val = 0;
 		if (portdata->dtr_state)
 			val |= 0x01;
@@ -858,7 +834,6 @@ static int option_send_setup(struct usb_serial_port *port)
 				usb_rcvctrlpipe(serial->dev, 0),
 				0x22,0x21,val,ifNum,NULL,0,USB_CTRL_SET_TIMEOUT);
 	}
-
 	return 0;
 }
 
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index a9625c1..069d276 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -140,22 +140,23 @@ struct oti6858_control_pkt {
 	  && ((a)->frame_fmt == (priv)->pending_setup.frame_fmt) )
 
 /* function prototypes */
-static int oti6858_open(struct usb_serial_port *port, struct file *filp);
-static void oti6858_close(struct usb_serial_port *port, struct file *filp);
-static void oti6858_set_termios(struct usb_serial_port *port,
-				struct ktermios *old);
-static int oti6858_ioctl(struct usb_serial_port *port, struct file *file,
+static int oti6858_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static void oti6858_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static void oti6858_set_termios(struct tty_struct *tty,
+			struct usb_serial_port *port, struct ktermios *old);
+static int oti6858_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 static void oti6858_read_int_callback(struct urb *urb);
 static void oti6858_read_bulk_callback(struct urb *urb);
 static void oti6858_write_bulk_callback(struct urb *urb);
-static int oti6858_write(struct usb_serial_port *port,
+static int oti6858_write(struct tty_struct *tty, struct usb_serial_port *port,
 			const unsigned char *buf, int count);
-static int oti6858_write_room(struct usb_serial_port *port);
-static void oti6858_break_ctl(struct usb_serial_port *port, int break_state);
-static int oti6858_chars_in_buffer(struct usb_serial_port *port);
-static int oti6858_tiocmget(struct usb_serial_port *port, struct file *file);
-static int oti6858_tiocmset(struct usb_serial_port *port, struct file *file,
+static int oti6858_write_room(struct tty_struct *tty);
+static int oti6858_chars_in_buffer(struct tty_struct *tty);
+static int oti6858_tiocmget(struct tty_struct *tty, struct file *file);
+static int oti6858_tiocmset(struct tty_struct *tty, struct file *file,
 				unsigned int set, unsigned int clear);
 static int oti6858_startup(struct usb_serial *serial);
 static void oti6858_shutdown(struct usb_serial *serial);
@@ -184,7 +185,6 @@ static struct usb_serial_driver oti6858_device = {
 	.close =		oti6858_close,
 	.write =		oti6858_write,
 	.ioctl =		oti6858_ioctl,
-	.break_ctl =		oti6858_break_ctl,
 	.set_termios =		oti6858_set_termios,
 	.tiocmget =		oti6858_tiocmget,
 	.tiocmset =		oti6858_tiocmset,
@@ -395,7 +395,7 @@ static int oti6858_startup(struct usb_serial *serial)
 	return -ENOMEM;
 }
 
-static int oti6858_write(struct usb_serial_port *port,
+static int oti6858_write(struct tty_struct *tty, struct usb_serial_port *port,
 			const unsigned char *buf, int count)
 {
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
@@ -413,8 +413,9 @@ static int oti6858_write(struct usb_serial_port *port,
 	return count;
 }
 
-static int oti6858_write_room(struct usb_serial_port *port)
+static int oti6858_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
 	int room = 0;
 	unsigned long flags;
@@ -428,8 +429,9 @@ static int oti6858_write_room(struct usb_serial_port *port)
 	return room;
 }
 
-static int oti6858_chars_in_buffer(struct usb_serial_port *port)
+static int oti6858_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
 	int chars = 0;
 	unsigned long flags;
@@ -443,8 +445,8 @@ static int oti6858_chars_in_buffer(struct usb_serial_port *port)
 	return chars;
 }
 
-static void oti6858_set_termios(struct usb_serial_port *port,
-				struct ktermios *old_termios)
+static void oti6858_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
@@ -455,22 +457,22 @@ static void oti6858_set_termios(struct usb_serial_port *port,
 
 	dbg("%s(port = %d)", __func__, port->number);
 
-	if (!port->tty || !port->tty->termios) {
+	if (!tty) {
 		dbg("%s(): no tty structures", __func__);
 		return;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (!priv->flags.termios_initialized) {
-		*(port->tty->termios) = tty_std_termios;
-		port->tty->termios->c_cflag = B38400 | CS8 | CREAD | HUPCL | CLOCAL;
+		*(tty->termios) = tty_std_termios;
+		tty->termios->c_cflag = B38400 | CS8 | CREAD | HUPCL | CLOCAL;
+		tty->termios->c_ispeed = 38400;
+		tty->termios->c_ospeed = 38400;
 		priv->flags.termios_initialized = 1;
-		port->tty->termios->c_ispeed = 38400;
-		port->tty->termios->c_ospeed = 38400;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	cflag = port->tty->termios->c_cflag;
+	cflag = tty->termios->c_cflag;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	divisor = priv->pending_setup.divisor;
@@ -500,7 +502,7 @@ static void oti6858_set_termios(struct usb_serial_port *port,
 	 * guarantee that any other baud rate will work (especially
 	 * the higher ones)
 	 */
-	br = tty_get_baud_rate(port->tty);
+	br = tty_get_baud_rate(tty);
 	if (br == 0) {
 		divisor = 0;
 	} else {
@@ -511,7 +513,7 @@ static void oti6858_set_termios(struct usb_serial_port *port,
 		new_divisor = (96000000 + 8 * br) / (16 * br);
 		real_br = 96000000 / (16 * new_divisor);
 		divisor = cpu_to_le16(new_divisor);
-		tty_encode_baud_rate(port->tty, real_br, real_br);
+		tty_encode_baud_rate(tty, real_br, real_br);
 	}
 
 	frame_fmt &= ~FMT_STOP_BITS_MASK;
@@ -564,7 +566,8 @@ static void oti6858_set_termios(struct usb_serial_port *port,
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static int oti6858_open(struct usb_serial_port *port, struct file *filp)
+static int oti6858_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
 	struct ktermios tmp_termios;
@@ -578,7 +581,7 @@ static int oti6858_open(struct usb_serial_port *port, struct file *filp)
 	usb_clear_halt(serial->dev, port->write_urb->pipe);
 	usb_clear_halt(serial->dev, port->read_urb->pipe);
 
-	if (port->open_count != 1)
+	if (port->port.count != 1)
 		return 0;
 
 	if ((buf = kmalloc(OTI6858_CTRL_PKT_SIZE, GFP_KERNEL)) == NULL) {
@@ -617,18 +620,19 @@ static int oti6858_open(struct usb_serial_port *port, struct file *filp)
 	if (result != 0) {
 		dev_err(&port->dev, "%s(): usb_submit_urb() failed"
 			       " with error %d\n", __func__, result);
-		oti6858_close(port, NULL);
+		oti6858_close(tty, port, NULL);
 		return -EPROTO;
 	}
 
 	/* setup termios */
-	if (port->tty)
-		oti6858_set_termios(port, &tmp_termios);
+	if (tty)
+		oti6858_set_termios(tty, port, &tmp_termios);
 
 	return 0;
 }
 
-static void oti6858_close(struct usb_serial_port *port, struct file *filp)
+static void oti6858_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
@@ -641,7 +645,7 @@ static void oti6858_close(struct usb_serial_port *port, struct file *filp)
 	spin_lock_irqsave(&priv->lock, flags);
 	timeout = 30 * HZ;	/* PL2303_CLOSING_WAIT */
 	init_waitqueue_entry(&wait, current);
-	add_wait_queue(&port->tty->write_wait, &wait);
+	add_wait_queue(&tty->write_wait, &wait);
 	dbg("%s(): entering wait loop", __func__);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -654,7 +658,7 @@ static void oti6858_close(struct usb_serial_port *port, struct file *filp)
 		spin_lock_irqsave(&priv->lock, flags);
 	}
 	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&port->tty->write_wait, &wait);
+	remove_wait_queue(&tty->write_wait, &wait);
 	dbg("%s(): after wait loop", __func__);
 
 	/* clear out any remaining data in the buffer */
@@ -669,7 +673,7 @@ static void oti6858_close(struct usb_serial_port *port, struct file *filp)
 	/* data is in the buffer to compute a delay */
 	/* that is not unnecessarily long) */
 	/* FIXME
-	bps = tty_get_baud_rate(port->tty);
+	bps = tty_get_baud_rate(tty);
 	if (bps > 1200)
 		timeout = max((HZ*2560)/bps,HZ/10);
 	else
@@ -690,7 +694,7 @@ static void oti6858_close(struct usb_serial_port *port, struct file *filp)
 	usb_kill_urb(port->interrupt_in_urb);
 
 	/*
-	if (port->tty && (port->tty->termios->c_cflag) & HUPCL) {
+	if (tty && (tty->termios->c_cflag) & HUPCL) {
 		// drop DTR and RTS
 		spin_lock_irqsave(&priv->lock, flags);
 		priv->pending_setup.control &= ~CONTROL_MASK;
@@ -699,9 +703,10 @@ static void oti6858_close(struct usb_serial_port *port, struct file *filp)
 	*/
 }
 
-static int oti6858_tiocmset(struct usb_serial_port *port, struct file *file,
+static int oti6858_tiocmset(struct tty_struct *tty, struct file *file,
 				unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	u8 control;
@@ -732,8 +737,9 @@ static int oti6858_tiocmset(struct usb_serial_port *port, struct file *file,
 	return 0;
 }
 
-static int oti6858_tiocmget(struct usb_serial_port *port, struct file *file)
+static int oti6858_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	unsigned pin_state;
@@ -802,26 +808,15 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	return 0;
 }
 
-static int oti6858_ioctl(struct usb_serial_port *port, struct file *file,
+static int oti6858_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
-	void __user *user_arg = (void __user *) arg;
-	unsigned int x;
+	struct usb_serial_port *port = tty->driver_data;
 
 	dbg("%s(port = %d, cmd = 0x%04x, arg = 0x%08lx)",
 				__func__, port->number, cmd, arg);
 
 	switch (cmd) {
-		case TIOCMBIS:
-			if (copy_from_user(&x, user_arg, sizeof(x)))
-				return -EFAULT;
-			return oti6858_tiocmset(port, NULL, x, 0);
-
-		case TIOCMBIC:
-			if (copy_from_user(&x, user_arg, sizeof(x)))
-				return -EFAULT;
-			return oti6858_tiocmset(port, NULL, 0, x);
-
 		case TIOCMIWAIT:
 			dbg("%s(): TIOCMIWAIT", __func__);
 			return wait_modem_info(port, arg);
@@ -834,24 +829,6 @@ static int oti6858_ioctl(struct usb_serial_port *port, struct file *file,
 	return -ENOIOCTLCMD;
 }
 
-static void oti6858_break_ctl(struct usb_serial_port *port, int break_state)
-{
-	int state;
-
-	dbg("%s(port = %d)", __func__, port->number);
-
-	state = (break_state == 0) ? 0 : 1;
-	dbg("%s(): turning break %s", __func__, state ? "on" : "off");
-
-	/* FIXME */
-/*
-	result = usb_control_msg (serial->dev, usb_sndctrlpipe (serial->dev, 0),
-				  BREAK_REQUEST, BREAK_REQUEST_TYPE, state,
-				  0, NULL, 0, 100);
-	if (result != 0)
-		dbg("%s(): error sending break", __func__);
- */
-}
 
 static void oti6858_shutdown(struct usb_serial *serial)
 {
@@ -1002,7 +979,7 @@ static void oti6858_read_bulk_callback(struct urb *urb)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (status != 0) {
-		if (!port->open_count) {
+		if (!port->port.count) {
 			dbg("%s(): port is closed, exiting", __func__);
 			return;
 		}
@@ -1020,14 +997,14 @@ static void oti6858_read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (tty != NULL && urb->actual_length > 0) {
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
 
 	// schedule the interrupt urb if we are still open */
-	if (port->open_count != 0) {
+	if (port->port.count != 0) {
 		port->interrupt_in_urb->dev = port->serial->dev;
 		result = usb_submit_urb(port->interrupt_in_urb, GFP_ATOMIC);
 		if (result != 0) {
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 103195a..8eec785 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -457,8 +457,8 @@ static void pl2303_send(struct usb_serial_port *port)
 	usb_serial_port_softint(port);
 }
 
-static int pl2303_write(struct usb_serial_port *port, const unsigned char *buf,
-			int count)
+static int pl2303_write(struct tty_struct *tty, struct usb_serial_port *port,
+				const unsigned char *buf, int count)
 {
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
@@ -477,8 +477,9 @@ static int pl2303_write(struct usb_serial_port *port, const unsigned char *buf,
 	return count;
 }
 
-static int pl2303_write_room(struct usb_serial_port *port)
+static int pl2303_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	int room = 0;
 	unsigned long flags;
@@ -493,8 +494,9 @@ static int pl2303_write_room(struct usb_serial_port *port)
 	return room;
 }
 
-static int pl2303_chars_in_buffer(struct usb_serial_port *port)
+static int pl2303_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	int chars = 0;
 	unsigned long flags;
@@ -509,8 +511,8 @@ static int pl2303_chars_in_buffer(struct usb_serial_port *port)
 	return chars;
 }
 
-static void pl2303_set_termios(struct usb_serial_port *port,
-			       struct ktermios *old_termios)
+static void pl2303_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
@@ -525,11 +527,10 @@ static void pl2303_set_termios(struct usb_serial_port *port,
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (!priv->termios_initialized) {
-		*(port->tty->termios) = tty_std_termios;
-		port->tty->termios->c_cflag = B9600 | CS8 | CREAD |
-					      HUPCL | CLOCAL;
-		port->tty->termios->c_ispeed = 9600;
-		port->tty->termios->c_ospeed = 9600;
+		*(tty->termios) = tty_std_termios;
+		tty->termios->c_cflag = B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+		tty->termios->c_ispeed = 9600;
+		tty->termios->c_ospeed = 9600;
 		priv->termios_initialized = 1;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -538,16 +539,16 @@ static void pl2303_set_termios(struct usb_serial_port *port,
 	   serial settings even to the same values as before. Thus
 	   we actually need to filter in this specific case */
 
-	if (!tty_termios_hw_change(port->tty->termios, old_termios))
+	if (!tty_termios_hw_change(tty->termios, old_termios))
 		return;
 
-	cflag = port->tty->termios->c_cflag;
+	cflag = tty->termios->c_cflag;
 
 	buf = kzalloc(7, GFP_KERNEL);
 	if (!buf) {
 		dev_err(&port->dev, "%s - out of memory.\n", __func__);
 		/* Report back no change occurred */
-		*port->tty->termios = *old_termios;
+		*tty->termios = *old_termios;
 		return;
 	}
 
@@ -568,7 +569,7 @@ static void pl2303_set_termios(struct usb_serial_port *port,
 		dbg("%s - data bits = %d", __func__, buf[6]);
 	}
 
-	baud = tty_get_baud_rate(port->tty);;
+	baud = tty_get_baud_rate(tty);
 	dbg("%s - baud = %d", __func__, baud);
 	if (baud) {
 		buf[0] = baud & 0xff;
@@ -645,12 +646,13 @@ static void pl2303_set_termios(struct usb_serial_port *port,
 
 	/* FIXME: Need to read back resulting baud rate */
 	if (baud)
-		tty_encode_baud_rate(port->tty, baud, baud);
+		tty_encode_baud_rate(tty, baud, baud);
 
 	kfree(buf);
 }
 
-static void pl2303_close(struct usb_serial_port *port, struct file *filp)
+static void pl2303_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
@@ -665,7 +667,7 @@ static void pl2303_close(struct usb_serial_port *port, struct file *filp)
 	spin_lock_irqsave(&priv->lock, flags);
 	timeout = PL2303_CLOSING_WAIT;
 	init_waitqueue_entry(&wait, current);
-	add_wait_queue(&port->tty->write_wait, &wait);
+	add_wait_queue(&tty->write_wait, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (pl2303_buf_data_avail(priv->buf) == 0 ||
@@ -677,7 +679,7 @@ static void pl2303_close(struct usb_serial_port *port, struct file *filp)
 		spin_lock_irqsave(&priv->lock, flags);
 	}
 	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&port->tty->write_wait, &wait);
+	remove_wait_queue(&tty->write_wait, &wait);
 	/* clear out any remaining data in the buffer */
 	pl2303_buf_clear(priv->buf);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -689,7 +691,7 @@ static void pl2303_close(struct usb_serial_port *port, struct file *filp)
 	/* for lower rates we should really know how much */
 	/* data is in the buffer to compute a delay */
 	/* that is not unnecessarily long) */
-	bps = tty_get_baud_rate(port->tty);
+	bps = tty_get_baud_rate(tty);
 	if (bps > 1200)
 		timeout = max((HZ*2560)/bps,HZ/10);
 	else
@@ -702,8 +704,8 @@ static void pl2303_close(struct usb_serial_port *port, struct file *filp)
 	usb_kill_urb(port->read_urb);
 	usb_kill_urb(port->interrupt_in_urb);
 
-	if (port->tty) {
-		c_cflag = port->tty->termios->c_cflag;
+	if (tty) {
+		c_cflag = tty->termios->c_cflag;
 		if (c_cflag & HUPCL) {
 			/* drop DTR and RTS */
 			spin_lock_irqsave(&priv->lock, flags);
@@ -714,7 +716,8 @@ static void pl2303_close(struct usb_serial_port *port, struct file *filp)
 	}
 }
 
-static int pl2303_open(struct usb_serial_port *port, struct file *filp)
+static int pl2303_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
@@ -733,9 +736,8 @@ static int pl2303_open(struct usb_serial_port *port, struct file *filp)
 	}
 
 	/* Setup termios */
-	if (port->tty) {
-		pl2303_set_termios(port, &tmp_termios);
-	}
+	if (tty)
+		pl2303_set_termios(tty, port, &tmp_termios);
 
 	//FIXME: need to assert RTS and DTR if CRTSCTS off
 
@@ -745,7 +747,7 @@ static int pl2303_open(struct usb_serial_port *port, struct file *filp)
 	if (result) {
 		dev_err(&port->dev, "%s - failed submitting read urb,"
 			" error %d\n", __func__, result);
-		pl2303_close(port, NULL);
+		pl2303_close(tty, port, NULL);
 		return -EPROTO;
 	}
 
@@ -755,15 +757,16 @@ static int pl2303_open(struct usb_serial_port *port, struct file *filp)
 	if (result) {
 		dev_err(&port->dev, "%s - failed submitting interrupt urb,"
 			" error %d\n", __func__, result);
-		pl2303_close(port, NULL);
+		pl2303_close(tty, port, NULL);
 		return -EPROTO;
 	}
 	return 0;
 }
 
-static int pl2303_tiocmset(struct usb_serial_port *port, struct file *file,
+static int pl2303_tiocmset(struct tty_struct *tty, struct file *file,
 			   unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	u8 control;
@@ -786,8 +789,9 @@ static int pl2303_tiocmset(struct usb_serial_port *port, struct file *file,
 	return set_control_lines(port->serial->dev, control);
 }
 
-static int pl2303_tiocmget(struct usb_serial_port *port, struct file *file)
+static int pl2303_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	unsigned int mcr;
@@ -852,9 +856,10 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	return 0;
 }
 
-static int pl2303_ioctl(struct usb_serial_port *port, struct file *file,
+static int pl2303_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s (%d) cmd = 0x%04x", __func__, port->number, cmd);
 
 	switch (cmd) {
@@ -870,8 +875,9 @@ static int pl2303_ioctl(struct usb_serial_port *port, struct file *file,
 	return -ENOIOCTLCMD;
 }
 
-static void pl2303_break_ctl(struct usb_serial_port *port, int break_state)
+static void pl2303_break_ctl(struct tty_struct *tty, int break_state)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	u16 state;
 	int result;
@@ -1000,7 +1006,7 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 
 	if (status) {
 		dbg("%s - urb status = %d", __func__, status);
-		if (!port->open_count) {
+		if (!port->port.count) {
 			dbg("%s - port is closed, exiting.", __func__);
 			return;
 		}
@@ -1043,7 +1049,7 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 		tty_flag = TTY_FRAME;
 	dbg("%s - tty_flag = %d", __func__, tty_flag);
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (tty && urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length + 1);
 		/* overrun is special, not associated with a char */
@@ -1055,7 +1061,7 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 	}
 
 	/* Schedule the next read _if_ we are still open */
-	if (port->open_count) {
+	if (port->port.count) {
 		urb->dev = port->serial->dev;
 		result = usb_submit_urb(urb, GFP_ATOMIC);
 		if (result)
diff --git a/drivers/usb/serial/safe_serial.c b/drivers/usb/serial/safe_serial.c
index 94bddf0..f823e4d 100644
--- a/drivers/usb/serial/safe_serial.c
+++ b/drivers/usb/serial/safe_serial.c
@@ -229,8 +229,8 @@ static void safe_read_bulk_callback (struct urb *urb)
 			int actual_length = data[length - 2] >> 2;
 			if (actual_length <= (length - 2)) {
 				info ("%s - actual: %d", __func__, actual_length);
-				tty_insert_flip_string(port->tty, data, actual_length);
-				tty_flip_buffer_push (port->tty);
+				tty_insert_flip_string(port->port.tty, data, actual_length);
+				tty_flip_buffer_push (port->port.tty);
 			} else {
 				err ("%s - inconsistent lengths %d:%d", __func__,
 				     actual_length, length);
@@ -239,8 +239,8 @@ static void safe_read_bulk_callback (struct urb *urb)
 			err ("%s - bad CRC %x", __func__, fcs);
 		}
 	} else {
-		tty_insert_flip_string(port->tty, data, length);
-		tty_flip_buffer_push (port->tty);
+		tty_insert_flip_string(port->port.tty, data, length);
+		tty_flip_buffer_push (port->port.tty);
 	}
 
 	/* Continue trying to always read  */
@@ -255,7 +255,8 @@ static void safe_read_bulk_callback (struct urb *urb)
 	}
 }
 
-static int safe_write (struct usb_serial_port *port, const unsigned char *buf, int count)
+static int safe_write(struct tty_struct *tty, struct usb_serial_port *port,
+					const unsigned char *buf, int count)
 {
 	unsigned char *data;
 	int result;
@@ -349,8 +350,9 @@ static int safe_write (struct usb_serial_port *port, const unsigned char *buf, i
 	return (count);
 }
 
-static int safe_write_room (struct usb_serial_port *port)
+static int safe_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	int room = 0;		/* Default: no room */
 	unsigned long flags;
 
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 29074c1..892020d 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -250,7 +250,8 @@ struct sierra_port_private {
 	int ri_state;
 };
 
-static int sierra_send_setup(struct usb_serial_port *port)
+static int sierra_send_setup(struct tty_struct *tty,
+						struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
 	struct sierra_port_private *portdata;
@@ -260,7 +261,7 @@ static int sierra_send_setup(struct usb_serial_port *port)
 
 	portdata = usb_get_serial_port_data(port);
 
-	if (port->tty) {
+	if (tty) {
 		int val = 0;
 		if (portdata->dtr_state)
 			val |= 0x01;
@@ -284,32 +285,17 @@ static int sierra_send_setup(struct usb_serial_port *port)
 	return 0;
 }
 
-static void sierra_rx_throttle(struct usb_serial_port *port)
+static void sierra_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	dbg("%s", __func__);
+	tty_termios_copy_hw(tty->termios, old_termios);
+	sierra_send_setup(tty, port);
 }
 
-static void sierra_rx_unthrottle(struct usb_serial_port *port)
-{
-	dbg("%s", __func__);
-}
-
-static void sierra_break_ctl(struct usb_serial_port *port, int break_state)
-{
-	/* Unfortunately, I don't know how to send a break */
-	dbg("%s", __func__);
-}
-
-static void sierra_set_termios(struct usb_serial_port *port,
-			struct ktermios *old_termios)
-{
-	dbg("%s", __func__);
-	tty_termios_copy_hw(port->tty->termios, old_termios);
-	sierra_send_setup(port);
-}
-
-static int sierra_tiocmget(struct usb_serial_port *port, struct file *file)
+static int sierra_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	unsigned int value;
 	struct sierra_port_private *portdata;
 
@@ -325,9 +311,10 @@ static int sierra_tiocmget(struct usb_serial_port *port, struct file *file)
 	return value;
 }
 
-static int sierra_tiocmset(struct usb_serial_port *port, struct file *file,
+static int sierra_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct sierra_port_private *portdata;
 
 	portdata = usb_get_serial_port_data(port);
@@ -341,13 +328,7 @@ static int sierra_tiocmset(struct usb_serial_port *port, struct file *file,
 		portdata->rts_state = 0;
 	if (clear & TIOCM_DTR)
 		portdata->dtr_state = 0;
-	return sierra_send_setup(port);
-}
-
-static int sierra_ioctl(struct usb_serial_port *port, struct file *file,
-			unsigned int cmd, unsigned long arg)
-{
-	return -ENOIOCTLCMD;
+	return sierra_send_setup(tty, port);
 }
 
 static void sierra_outdat_callback(struct urb *urb)
@@ -374,8 +355,8 @@ static void sierra_outdat_callback(struct urb *urb)
 }
 
 /* Write */
-static int sierra_write(struct usb_serial_port *port,
-			const unsigned char *buf, int count)
+static int sierra_write(struct tty_struct *tty, struct usb_serial_port *port,
+					const unsigned char *buf, int count)
 {
 	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
 	struct usb_serial *serial = port->serial;
@@ -463,7 +444,7 @@ static void sierra_indat_callback(struct urb *urb)
 		dbg("%s: nonzero status: %d on endpoint %02x.",
 		    __func__, status, endpoint);
 	} else {
-		tty = port->tty;
+		tty = port->port.tty;
 		if (urb->actual_length) {
 			tty_buffer_request_room(tty, urb->actual_length);
 			tty_insert_flip_string(tty, data, urb->actual_length);
@@ -473,7 +454,7 @@ static void sierra_indat_callback(struct urb *urb)
 		}
 
 		/* Resubmit urb so we continue receiving */
-		if (port->open_count && status != -ESHUTDOWN) {
+		if (port->port.count && status != -ESHUTDOWN) {
 			err = usb_submit_urb(urb, GFP_ATOMIC);
 			if (err)
 				dev_err(&port->dev, "resubmit read urb failed."
@@ -517,9 +498,9 @@ static void sierra_instat_callback(struct urb *urb)
 			portdata->dsr_state = ((signals & 0x02) ? 1 : 0);
 			portdata->ri_state = ((signals & 0x08) ? 1 : 0);
 
-			if (port->tty && !C_CLOCAL(port->tty) &&
+			if (port->port.tty && !C_CLOCAL(port->port.tty) &&
 					old_dcd_state && !portdata->dcd_state)
-				tty_hangup(port->tty);
+				tty_hangup(port->port.tty);
 		} else {
 			dbg("%s: type %x req %x", __func__,
 				req_pkt->bRequestType, req_pkt->bRequest);
@@ -537,8 +518,9 @@ static void sierra_instat_callback(struct urb *urb)
 	}
 }
 
-static int sierra_write_room(struct usb_serial_port *port)
+static int sierra_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
 	unsigned long flags;
 
@@ -557,22 +539,8 @@ static int sierra_write_room(struct usb_serial_port *port)
 	return 2048;
 }
 
-static int sierra_chars_in_buffer(struct usb_serial_port *port)
-{
-	dbg("%s - port %d", __func__, port->number);
-
-	/*
-	 * We can't really account for how much data we
-	 * have sent out, but hasn't made it through to the
-	 * device as we can't see the backend here, so just
-	 * tell the tty layer that everything is flushed.
-	 *
-	 * FIXME: should walk the outstanding urbs info
-	 */
-	return 0;
-}
-
-static int sierra_open(struct usb_serial_port *port, struct file *filp)
+static int sierra_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct sierra_port_private *portdata;
 	struct usb_serial *serial = port->serial;
@@ -612,9 +580,10 @@ static int sierra_open(struct usb_serial_port *port, struct file *filp)
 		}
 	}
 
-	port->tty->low_latency = 1;
+	if (tty)
+		tty->low_latency = 1;
 
-	sierra_send_setup(port);
+	sierra_send_setup(tty, port);
 
 	/* start up the interrupt endpoint if we have one */
 	if (port->interrupt_in_urb) {
@@ -626,7 +595,8 @@ static int sierra_open(struct usb_serial_port *port, struct file *filp)
 	return 0;
 }
 
-static void sierra_close(struct usb_serial_port *port, struct file *filp)
+static void sierra_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	int i;
 	struct usb_serial *serial = port->serial;
@@ -641,7 +611,7 @@ static void sierra_close(struct usb_serial_port *port, struct file *filp)
 	if (serial->dev) {
 		mutex_lock(&serial->disc_mutex);
 		if (!serial->disconnected)
-			sierra_send_setup(port);
+			sierra_send_setup(tty, port);
 		mutex_unlock(&serial->disc_mutex);
 
 		/* Stop reading/writing urbs */
@@ -651,7 +621,7 @@ static void sierra_close(struct usb_serial_port *port, struct file *filp)
 
 	usb_kill_urb(port->interrupt_in_urb);
 
-	port->tty = NULL;
+	port->port.tty = NULL;	/* FIXME */
 }
 
 static int sierra_startup(struct usb_serial *serial)
@@ -754,12 +724,7 @@ static struct usb_serial_driver sierra_device = {
 	.close             = sierra_close,
 	.write             = sierra_write,
 	.write_room        = sierra_write_room,
-	.chars_in_buffer   = sierra_chars_in_buffer,
-	.throttle          = sierra_rx_throttle,
-	.unthrottle        = sierra_rx_unthrottle,
-	.ioctl             = sierra_ioctl,
 	.set_termios       = sierra_set_termios,
-	.break_ctl         = sierra_break_ctl,
 	.tiocmget          = sierra_tiocmget,
 	.tiocmset          = sierra_tiocmset,
 	.attach            = sierra_startup,
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 55b2570..58495f5 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -448,7 +448,8 @@ static void spcp8x5_set_workMode(struct usb_device *dev, u16 value,
 
 /* close the serial port. We should wait for data sending to device 1st and
  * then kill all urb. */
-static void spcp8x5_close(struct usb_serial_port *port, struct file *filp)
+static void spcp8x5_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
@@ -464,7 +465,7 @@ static void spcp8x5_close(struct usb_serial_port *port, struct file *filp)
 	spin_lock_irqsave(&priv->lock, flags);
 	timeout = SPCP8x5_CLOSING_WAIT;
 	init_waitqueue_entry(&wait, current);
-	add_wait_queue(&port->tty->write_wait, &wait);
+	add_wait_queue(&tty->write_wait, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (ringbuf_avail_data(priv->buf) == 0 ||
@@ -475,7 +476,7 @@ static void spcp8x5_close(struct usb_serial_port *port, struct file *filp)
 		spin_lock_irqsave(&priv->lock, flags);
 	}
 	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&port->tty->write_wait, &wait);
+	remove_wait_queue(&tty->write_wait, &wait);
 
 	/* clear out any remaining data in the buffer */
 	clear_ringbuf(priv->buf);
@@ -486,7 +487,7 @@ static void spcp8x5_close(struct usb_serial_port *port, struct file *filp)
 	 * flow control for data rates of 1200 bps or more, for lower rates we
 	 * should really know how much data is in the buffer to compute a delay
 	 * that is not unnecessarily long) */
-	bps = tty_get_baud_rate(port->tty);
+	bps = tty_get_baud_rate(tty);
 	if (bps > 1200)
 		timeout = max((HZ*2560) / bps, HZ/10);
 	else
@@ -495,8 +496,8 @@ static void spcp8x5_close(struct usb_serial_port *port, struct file *filp)
 	schedule_timeout(timeout);
 
 	/* clear control lines */
-	if (port->tty) {
-		c_cflag = port->tty->termios->c_cflag;
+	if (tty) {
+		c_cflag = tty->termios->c_cflag;
 		if (c_cflag & HUPCL) {
 			spin_lock_irqsave(&priv->lock, flags);
 			priv->line_control = 0;
@@ -518,14 +519,14 @@ static void spcp8x5_close(struct usb_serial_port *port, struct file *filp)
 }
 
 /* set the serial param for transfer. we should check if we really need to
- * transfer. then if be set flow contorl we should do this too. */
-static void spcp8x5_set_termios(struct usb_serial_port *port,
-				struct ktermios *old_termios)
+ * transfer. if we set flow control we should do this too. */
+static void spcp8x5_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
-	unsigned int cflag = port->tty->termios->c_cflag;
+	unsigned int cflag = tty->termios->c_cflag;
 	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned short uartdata;
 	unsigned char buf[2] = {0, 0};
@@ -533,21 +534,19 @@ static void spcp8x5_set_termios(struct usb_serial_port *port,
 	int i;
 	u8 control;
 
-	if ((!port->tty) || (!port->tty->termios))
-		return;
-
 	/* for the 1st time call this function */
 	spin_lock_irqsave(&priv->lock, flags);
 	if (!priv->termios_initialized) {
-		*(port->tty->termios) = tty_std_termios;
-		port->tty->termios->c_cflag = B115200 | CS8 | CREAD |
-					      HUPCL | CLOCAL;
+		*(tty->termios) = tty_std_termios;
+		tty->termios->c_cflag = B115200 | CS8 | CREAD | HUPCL | CLOCAL;
+		tty->termios->c_ispeed = 115200;
+		tty->termios->c_ospeed = 115200;
 		priv->termios_initialized = 1;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* check that they really want us to change something */
-	if (!tty_termios_hw_change(port->tty->termios, old_termios))
+	if (!tty_termios_hw_change(tty->termios, old_termios))
 		return;
 
 	/* set DTR/RTS active */
@@ -567,7 +566,7 @@ static void spcp8x5_set_termios(struct usb_serial_port *port,
 	}
 
 	/* Set Baud Rate */
-	baud = tty_get_baud_rate(port->tty);;
+	baud = tty_get_baud_rate(tty);;
 	switch (baud) {
 	case 300:	buf[0] = 0x00;	break;
 	case 600:	buf[0] = 0x01;	break;
@@ -643,7 +642,8 @@ static void spcp8x5_set_termios(struct usb_serial_port *port,
 
 /* open the serial port. do some usb system call. set termios and get the line
  * status of the device. then submit the read urb */
-static int spcp8x5_open(struct usb_serial_port *port, struct file *filp)
+static int spcp8x5_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
@@ -665,7 +665,7 @@ static int spcp8x5_open(struct usb_serial_port *port, struct file *filp)
 		return ret;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (port->tty->termios->c_cflag & CBAUD)
+	if (tty && (tty->termios->c_cflag & CBAUD))
 		priv->line_control = MCR_DTR | MCR_RTS;
 	else
 		priv->line_control = 0;
@@ -674,8 +674,8 @@ static int spcp8x5_open(struct usb_serial_port *port, struct file *filp)
 	spcp8x5_set_ctrlLine(serial->dev, priv->line_control , priv->type);
 
 	/* Setup termios */
-	if (port->tty)
-		spcp8x5_set_termios(port, &tmp_termios);
+	if (tty)
+		spcp8x5_set_termios(tty, port, &tmp_termios);
 
 	spcp8x5_get_msr(serial->dev, &status, priv->type);
 
@@ -690,7 +690,7 @@ static int spcp8x5_open(struct usb_serial_port *port, struct file *filp)
 	port->read_urb->dev = serial->dev;
 	ret = usb_submit_urb(port->read_urb, GFP_KERNEL);
 	if (ret) {
-		spcp8x5_close(port, NULL);
+		spcp8x5_close(tty, port, NULL);
 		return -EPROTO;
 	}
 	return 0;
@@ -717,7 +717,7 @@ static void spcp8x5_read_bulk_callback(struct urb *urb)
 
 	/* check the urb status */
 	if (urb->status) {
-		if (!port->open_count)
+		if (!port->port.count)
 			return;
 		if (urb->status == -EPROTO) {
 			/* spcp8x5 mysteriously fails with -EPROTO */
@@ -755,7 +755,7 @@ static void spcp8x5_read_bulk_callback(struct urb *urb)
 		tty_flag = TTY_FRAME;
 	dev_dbg(&port->dev, "tty_flag = %d\n", tty_flag);
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (tty && urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length + 1);
 		/* overrun is special, not associated with a char */
@@ -767,7 +767,7 @@ static void spcp8x5_read_bulk_callback(struct urb *urb)
 	}
 
 	/* Schedule the next read _if_ we are still open */
-	if (port->open_count) {
+	if (port->port.count) {
 		urb->dev = port->serial->dev;
 		result = usb_submit_urb(urb , GFP_ATOMIC);
 		if (result)
@@ -866,7 +866,7 @@ static void spcp8x5_write_bulk_callback(struct urb *urb)
 }
 
 /* write data to ring buffer. and then start the write transfer */
-static int spcp8x5_write(struct usb_serial_port *port,
+static int spcp8x5_write(struct tty_struct *tty, struct usb_serial_port *port,
 			 const unsigned char *buf, int count)
 {
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
@@ -925,9 +925,10 @@ static int spcp8x5_wait_modem_info(struct usb_serial_port *port,
 	return 0;
 }
 
-static int spcp8x5_ioctl(struct usb_serial_port *port, struct file *file,
+static int spcp8x5_ioctl(struct tty_struct *tty, struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s (%d) cmd = 0x%04x", __func__, port->number, cmd);
 
 	switch (cmd) {
@@ -943,9 +944,10 @@ static int spcp8x5_ioctl(struct usb_serial_port *port, struct file *file,
 	return -ENOIOCTLCMD;
 }
 
-static int spcp8x5_tiocmset(struct usb_serial_port *port, struct file *file,
+static int spcp8x5_tiocmset(struct tty_struct *tty, struct file *file,
 			    unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	u8 control;
@@ -965,8 +967,9 @@ static int spcp8x5_tiocmset(struct usb_serial_port *port, struct file *file,
 	return spcp8x5_set_ctrlLine(port->serial->dev, control , priv->type);
 }
 
-static int spcp8x5_tiocmget(struct usb_serial_port *port, struct file *file)
+static int spcp8x5_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	unsigned int mcr;
@@ -989,8 +992,9 @@ static int spcp8x5_tiocmget(struct usb_serial_port *port, struct file *file)
 }
 
 /* get the avail space room in ring buffer */
-static int spcp8x5_write_room(struct usb_serial_port *port)
+static int spcp8x5_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	int room = 0;
 	unsigned long flags;
@@ -1003,8 +1007,9 @@ static int spcp8x5_write_room(struct usb_serial_port *port)
 }
 
 /* get the number of avail data in write ring buffer */
-static int spcp8x5_chars_in_buffer(struct usb_serial_port *port)
+static int spcp8x5_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	int chars = 0;
 	unsigned long flags;
diff --git a/drivers/usb/serial/ti_fw_3410.h b/drivers/usb/serial/ti_fw_3410.h
index 71e8857..2a63c79 100644
--- a/drivers/usb/serial/ti_fw_3410.h
+++ b/drivers/usb/serial/ti_fw_3410.h
@@ -882,4 +882,8 @@ static unsigned char ti_fw_3410[] = {
 0x00,0x00,
 };
 
+static struct firmware fw_3410 = {
+	sizeof(ti_fw_3410),
+	ti_fw_3410
+};	
 #endif /* ifndef _TI_FW_3410_H_ */
diff --git a/drivers/usb/serial/ti_fw_5052.h b/drivers/usb/serial/ti_fw_5052.h
index 6ccf40a..cff2fdd 100644
--- a/drivers/usb/serial/ti_fw_5052.h
+++ b/drivers/usb/serial/ti_fw_5052.h
@@ -882,4 +882,9 @@ static unsigned char ti_fw_5052[] = {
 0x00,
 };
 
+static struct firmware fw_5052 = {
+	sizeof(ti_fw_5052),
+	ti_fw_5052
+};	
+
 #endif /* ifndef _TI_FW_5052_H_ */
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index a1c8aef..9f03dcd 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -70,6 +70,7 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/firmware.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/tty.h>
@@ -86,9 +87,14 @@
 #include <linux/usb/serial.h>
 
 #include "ti_usb_3410_5052.h"
+
+#ifdef CONFIG_USB_SERIAL_TI_FIRMWARE
+/* Keep compatibility option for a while so we don't break systems
+   as we kick the firmware out into user space. In time this will
+   go away */
 #include "ti_fw_3410.h"		/* firmware image for 3410 */
 #include "ti_fw_5052.h"		/* firmware image for 5052 */
-
+#endif
 
 /* Defines */
 
@@ -151,21 +157,23 @@ struct ti_device {
 
 static int ti_startup(struct usb_serial *serial);
 static void ti_shutdown(struct usb_serial *serial);
-static int ti_open(struct usb_serial_port *port, struct file *file);
-static void ti_close(struct usb_serial_port *port, struct file *file);
-static int ti_write(struct usb_serial_port *port, const unsigned char *data,
-	int count);
-static int ti_write_room(struct usb_serial_port *port);
-static int ti_chars_in_buffer(struct usb_serial_port *port);
-static void ti_throttle(struct usb_serial_port *port);
-static void ti_unthrottle(struct usb_serial_port *port);
-static int ti_ioctl(struct usb_serial_port *port, struct file *file, unsigned int cmd, unsigned long arg);
-static void ti_set_termios(struct usb_serial_port *port,
+static int ti_open(struct tty_struct *tty, struct usb_serial_port *port,
+				struct file *file);
+static void ti_close(struct tty_struct *tty, struct usb_serial_port *port,
+				struct file *file);
+static int ti_write(struct tty_struct *tty, struct usb_serial_port *port,
+				const unsigned char *data, int count);
+static int ti_write_room(struct tty_struct *tty);
+static int ti_chars_in_buffer(struct tty_struct *tty);
+static void ti_throttle(struct tty_struct *tty);
+static void ti_unthrottle(struct tty_struct *tty);
+static int ti_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg);
+static void ti_set_termios(struct tty_struct *tty, struct usb_serial_port *port,
 	struct ktermios *old_termios);
-static int ti_tiocmget(struct usb_serial_port *port, struct file *file);
-static int ti_tiocmset(struct usb_serial_port *port, struct file *file,
+static int ti_tiocmget(struct tty_struct *tty, struct file *file);
+static int ti_tiocmset(struct tty_struct *tty, struct file *file,
 	unsigned int set, unsigned int clear);
-static void ti_break(struct usb_serial_port *port, int break_state);
+static void ti_break(struct tty_struct *tty, int break_state);
 static void ti_interrupt_callback(struct urb *urb);
 static void ti_bulk_in_callback(struct urb *urb);
 static void ti_bulk_out_callback(struct urb *urb);
@@ -194,8 +202,7 @@ static int ti_command_in_sync(struct ti_device *tdev, __u8 command,
 static int ti_write_byte(struct ti_device *tdev, unsigned long addr,
 	__u8 mask, __u8 byte);
 
-static int ti_download_firmware(struct ti_device *tdev,
-	unsigned char *firmware, unsigned int firmware_size);
+static int ti_download_firmware(struct ti_device *tdev, int type);
 
 /* circular buffer */
 static struct circ_buf *ti_buf_alloc(void);
@@ -429,13 +436,10 @@ static int ti_startup(struct usb_serial *serial)
 
 	/* if we have only 1 configuration, download firmware */
 	if (dev->descriptor.bNumConfigurations == 1) {
-
 		if (tdev->td_is_3410)
-			status = ti_download_firmware(tdev, ti_fw_3410,
-				sizeof(ti_fw_3410));
+			status = ti_download_firmware(tdev, 3410);
 		else
-			status = ti_download_firmware(tdev, ti_fw_5052,
-				sizeof(ti_fw_5052));
+			status = ti_download_firmware(tdev, 5052);
 		if (status)
 			goto free_tdev;
 
@@ -520,7 +524,8 @@ static void ti_shutdown(struct usb_serial *serial)
 }
 
 
-static int ti_open(struct usb_serial_port *port, struct file *file)
+static int ti_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *file)
 {
 	struct ti_port *tport = usb_get_serial_port_data(port);
 	struct ti_device *tdev;
@@ -544,9 +549,9 @@ static int ti_open(struct usb_serial_port *port, struct file *file)
 	if (mutex_lock_interruptible(&tdev->td_open_close_lock))
 		return -ERESTARTSYS;
 
-	if (port->tty)
-		port->tty->low_latency = 
-			(tport->tp_flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	if (tty)
+		tty->low_latency =
+				(tport->tp_flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	port_number = port->number - port->serial->minor;
 
@@ -574,7 +579,8 @@ static int ti_open(struct usb_serial_port *port, struct file *file)
 		}
 	}
 
-	ti_set_termios(port, port->tty->termios);
+	if (tty)
+		ti_set_termios(tty, port, tty->termios);
 
 	dbg("%s - sending TI_OPEN_PORT", __func__);
 	status = ti_command_out_sync(tdev, TI_OPEN_PORT,
@@ -611,7 +617,8 @@ static int ti_open(struct usb_serial_port *port, struct file *file)
 	usb_clear_halt(dev, port->write_urb->pipe);
 	usb_clear_halt(dev, port->read_urb->pipe);
 
-	ti_set_termios(port, port->tty->termios);
+	if (tty)
+		ti_set_termios(tty, port, tty->termios);
 
 	dbg("%s - sending TI_OPEN_PORT (2)", __func__);
 	status = ti_command_out_sync(tdev, TI_OPEN_PORT,
@@ -662,7 +669,8 @@ release_lock:
 }
 
 
-static void ti_close(struct usb_serial_port *port, struct file *file)
+static void ti_close(struct tty_struct *tty, struct usb_serial_port *port,
+							struct file *file)
 {
 	struct ti_device *tdev;
 	struct ti_port *tport;
@@ -708,8 +716,8 @@ static void ti_close(struct usb_serial_port *port, struct file *file)
 }
 
 
-static int ti_write(struct usb_serial_port *port, const unsigned char *data,
-	int count)
+static int ti_write(struct tty_struct *tty, struct usb_serial_port *port,
+			const unsigned char *data, int count)
 {
 	struct ti_port *tport = usb_get_serial_port_data(port);
 	unsigned long flags;
@@ -734,8 +742,9 @@ static int ti_write(struct usb_serial_port *port, const unsigned char *data,
 }
 
 
-static int ti_write_room(struct usb_serial_port *port)
+static int ti_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ti_port *tport = usb_get_serial_port_data(port);
 	int room = 0;
 	unsigned long flags;
@@ -754,8 +763,9 @@ static int ti_write_room(struct usb_serial_port *port)
 }
 
 
-static int ti_chars_in_buffer(struct usb_serial_port *port)
+static int ti_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ti_port *tport = usb_get_serial_port_data(port);
 	int chars = 0;
 	unsigned long flags;
@@ -774,32 +784,26 @@ static int ti_chars_in_buffer(struct usb_serial_port *port)
 }
 
 
-static void ti_throttle(struct usb_serial_port *port)
+static void ti_throttle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ti_port *tport = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 
 	dbg("%s - port %d", __func__, port->number);
 
 	if (tport == NULL)
 		return;
 
-	tty = port->tty;
-	if (!tty) {
-		dbg("%s - no tty", __func__);
-		return;
-	}
-
 	if (I_IXOFF(tty) || C_CRTSCTS(tty))
 		ti_stop_read(tport, tty);
 
 }
 
 
-static void ti_unthrottle(struct usb_serial_port *port)
+static void ti_unthrottle(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ti_port *tport = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	int status;
 
 	dbg("%s - port %d", __func__, port->number);
@@ -807,12 +811,6 @@ static void ti_unthrottle(struct usb_serial_port *port)
 	if (tport == NULL)
 		return;
 
-	tty = port->tty;
-	if (!tty) {
-		dbg("%s - no tty", __func__);
-		return;
-	}
-
 	if (I_IXOFF(tty) || C_CRTSCTS(tty)) {
 		status = ti_restart_read(tport, tty);
 		if (status)
@@ -821,9 +819,10 @@ static void ti_unthrottle(struct usb_serial_port *port)
 }
 
 
-static int ti_ioctl(struct usb_serial_port *port, struct file *file,
+static int ti_ioctl(struct tty_struct *tty, struct file *file,
 	unsigned int cmd, unsigned long arg)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ti_port *tport = usb_get_serial_port_data(port);
 	struct async_icount cnow;
 	struct async_icount cprev;
@@ -876,11 +875,10 @@ static int ti_ioctl(struct usb_serial_port *port, struct file *file,
 }
 
 
-static void ti_set_termios(struct usb_serial_port *port,
-	struct ktermios *old_termios)
+static void ti_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct ti_port *tport = usb_get_serial_port_data(port);
-	struct tty_struct *tty = port->tty;
 	struct ti_uart_config *config;
 	tcflag_t cflag,iflag;
 	int baud;
@@ -1009,8 +1007,9 @@ static void ti_set_termios(struct usb_serial_port *port,
 }
 
 
-static int ti_tiocmget(struct usb_serial_port *port, struct file *file)
+static int ti_tiocmget(struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ti_port *tport = usb_get_serial_port_data(port);
 	unsigned int result;
 	unsigned int msr;
@@ -1041,9 +1040,10 @@ static int ti_tiocmget(struct usb_serial_port *port, struct file *file)
 }
 
 
-static int ti_tiocmset(struct usb_serial_port *port, struct file *file,
+static int ti_tiocmset(struct tty_struct *tty, struct file *file,
 	unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ti_port *tport = usb_get_serial_port_data(port);
 	unsigned int mcr;
 	unsigned long flags;
@@ -1075,8 +1075,9 @@ static int ti_tiocmset(struct usb_serial_port *port, struct file *file,
 }
 
 
-static void ti_break(struct usb_serial_port *port, int break_state)
+static void ti_break(struct tty_struct *tty, int break_state)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct ti_port *tport = usb_get_serial_port_data(port);
 	int status;
 
@@ -1214,14 +1215,14 @@ static void ti_bulk_in_callback(struct urb *urb)
 		return;
 	}
 
-	if (port->tty && urb->actual_length) {
+	if (port->port.tty && urb->actual_length) {
 		usb_serial_debug_data(debug, dev, __func__,
 			urb->actual_length, urb->transfer_buffer);
 
 		if (!tport->tp_is_open)
 			dbg("%s - port closed, dropping data", __func__);
 		else
-			ti_recv(&urb->dev->dev, port->tty, urb->transfer_buffer,
+			ti_recv(&urb->dev->dev, port->port.tty, urb->transfer_buffer,
 				urb->actual_length);
 
 		spin_lock(&tport->tp_lock);
@@ -1303,7 +1304,7 @@ static void ti_send(struct ti_port *tport)
 {
 	int count, result;
 	struct usb_serial_port *port = tport->tp_port;
-	struct tty_struct *tty = port->tty;
+	struct tty_struct *tty = port->port.tty;	/* FIXME */
 	unsigned long flags;
 
 
@@ -1443,8 +1444,9 @@ static int ti_set_serial_info(struct ti_port *tport,
 		return -EFAULT;
 
 	tport->tp_flags = new_serial.flags & TI_SET_SERIAL_FLAGS;
-	if (port->tty)
-		port->tty->low_latency =
+	/* FIXME */
+	if (port->port.tty)
+		port->port.tty->low_latency =
 			(tport->tp_flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 	tport->tp_closing_wait = new_serial.closing_wait;
 
@@ -1478,7 +1480,7 @@ static void ti_handle_new_msr(struct ti_port *tport, __u8 msr)
 	tport->tp_msr = msr & TI_MSR_MASK;
 
 	/* handle CTS flow control */
-	tty = tport->tp_port->tty;
+	tty = tport->tp_port->port.tty;
 	if (tty && C_CRTSCTS(tty)) {
 		if (msr & TI_MSR_CTS) {
 			tty->hw_stopped = 0;
@@ -1656,50 +1658,82 @@ static int ti_write_byte(struct ti_device *tdev, unsigned long addr,
 	return status;
 }
 
-
-static int ti_download_firmware(struct ti_device *tdev,
-	unsigned char *firmware, unsigned int firmware_size)
+static int ti_do_download(struct usb_device *dev, int pipe,
+						u8 *buffer, int size)
 {
-	int status = 0;
-	int buffer_size;
 	int pos;
-	int len;
+	u8 cs = 0;
 	int done;
-	__u8 cs = 0;
-	__u8 *buffer;
-	struct usb_device *dev = tdev->td_serial->dev;
 	struct ti_firmware_header *header;
-	unsigned int pipe = usb_sndbulkpipe(dev,
-		tdev->td_serial->port[0]->bulk_out_endpointAddress);
-
-
-	buffer_size = TI_FIRMWARE_BUF_SIZE + sizeof(struct ti_firmware_header);
-	buffer = kmalloc(buffer_size, GFP_KERNEL);
-	if (!buffer) {
-		dev_err(&dev->dev, "%s - out of memory\n", __func__);
-		return -ENOMEM;
-	}
-
-	memcpy(buffer, firmware, firmware_size);
-	memset(buffer+firmware_size, 0xff, buffer_size-firmware_size);
-
-	for(pos = sizeof(struct ti_firmware_header); pos < buffer_size; pos++)
+	int status;
+	int len;
+	
+	for(pos = sizeof(struct ti_firmware_header); pos < size; pos++)
 		cs = (__u8)(cs + buffer[pos]);
 
 	header = (struct ti_firmware_header *)buffer;
-	header->wLength = cpu_to_le16((__u16)(buffer_size - sizeof(struct ti_firmware_header)));
+	header->wLength = cpu_to_le16((__u16)(size 
+					- sizeof(struct ti_firmware_header)));
 	header->bCheckSum = cs;
 
 	dbg("%s - downloading firmware", __func__);
-	for (pos = 0; pos < buffer_size; pos += done) {
-		len = min(buffer_size - pos, TI_DOWNLOAD_MAX_PACKET_SIZE);
-		status = usb_bulk_msg(dev, pipe, buffer+pos, len, &done, 1000);
+	for (pos = 0; pos < size; pos += done) {
+		len = min(size - pos, TI_DOWNLOAD_MAX_PACKET_SIZE);
+		status = usb_bulk_msg(dev, pipe, buffer + pos, len,
+								&done, 1000);
 		if (status)
 			break;
 	}
+	return status;
+}
 
-	kfree(buffer);
 
+static int ti_download_firmware(struct ti_device *tdev, int type)
+{
+	int status = -ENOMEM;
+	int buffer_size;
+	__u8 *buffer;
+	struct usb_device *dev = tdev->td_serial->dev;
+	unsigned int pipe = usb_sndbulkpipe(dev,
+		tdev->td_serial->port[0]->bulk_out_endpointAddress);
+	const struct firmware *fw_p;
+
+#ifdef CONFIG_USB_SERIAL_TI_FIRMWARE
+	switch (type) {
+	case 3410:
+		fw_p = &fw_3410;
+		break;
+	case 5052:
+		fw_p = &fw_5052;
+		break;
+	default:
+		return -EINVAL;
+	}
+#else
+	char buf[32];
+	sprintf(buf, "ti_usb-%d.bin", type);
+
+	if (request_firmware(&fw_p, buf, &dev->dev)) {
+		dev_err(&dev->dev, "%s - firmware not found\n", __func__);
+		return -ENOENT;
+	}
+	if (fw_p->size > TI_FIRMWARE_BUF_SIZE) {
+		dev_err(&dev->dev, "%s - firmware too large\n", __func__);
+		return -ENOENT;
+	}
+#endif
+
+	buffer_size = TI_FIRMWARE_BUF_SIZE + sizeof(struct ti_firmware_header);
+	buffer = kmalloc(buffer_size, GFP_KERNEL);
+	if (buffer) {
+		memcpy(buffer, fw_p->data, fw_p->size);
+		memset(buffer + fw_p->size, 0xff, buffer_size - fw_p->size);
+		ti_do_download(dev, pipe, buffer, fw_p->size);
+		kfree(buffer);
+	}
+#ifdef CONFIG_USB_SERIAL_TI_FIRMWARE	
+	release_firmware(fw_p);
+#endif	
 	if (status) {
 		dev_err(&dev->dev, "%s - error downloading firmware, %d\n", __func__, status);
 		return status;
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 0cb0d77..6a1146a 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -143,7 +143,7 @@ static void destroy_serial(struct kref *kref)
 	return_serial(serial);
 
 	for (i = 0; i < serial->num_ports; ++i)
-		serial->port[i]->open_count = 0;
+		serial->port[i]->port.count = 0;
 
 	/* the ports are cleaned up and released in port_release() */
 	for (i = 0; i < serial->num_ports; ++i)
@@ -208,14 +208,14 @@ static int serial_open (struct tty_struct *tty, struct file * filp)
 		goto bailout_kref_put;
 	}
 	 
-	++port->open_count;
+	++port->port.count;
 
 	/* set up our port structure making the tty driver
 	 * remember our port object, and us it */
 	tty->driver_data = port;
-	port->tty = tty;
+	port->port.tty = tty;
 
-	if (port->open_count == 1) {
+	if (port->port.count == 1) {
 
 		/* lock this module before we call it
 		 * this may fail, which means we must bail out,
@@ -230,7 +230,7 @@ static int serial_open (struct tty_struct *tty, struct file * filp)
 			goto bailout_module_put;
 		/* only call the device specific open if this 
 		 * is the first time the port is opened */
-		retval = serial->type->open(port, filp);
+		retval = serial->type->open(tty, port, filp);
 		if (retval)
 			goto bailout_interface_put;
 	}
@@ -243,9 +243,9 @@ bailout_interface_put:
 bailout_module_put:
 	module_put(serial->type->driver.owner);
 bailout_mutex_unlock:
-	port->open_count = 0;
+	port->port.count = 0;
 	tty->driver_data = NULL;
-	port->tty = NULL;
+	port->port.tty = NULL;
 	mutex_unlock(&port->mutex);
 bailout_kref_put:
 	usb_serial_put(serial);
@@ -263,26 +263,26 @@ static void serial_close(struct tty_struct *tty, struct file * filp)
 
 	mutex_lock(&port->mutex);
 
-	if (port->open_count == 0) {
+	if (port->port.count == 0) {
 		mutex_unlock(&port->mutex);
 		return;
 	}
 
-	--port->open_count;
-	if (port->open_count == 0)
+	--port->port.count;
+	if (port->port.count == 0)
 		/* only call the device specific close if this 
 		 * port is being closed by the last owner */
-		port->serial->type->close(port, filp);
+		port->serial->type->close(tty, port, filp);
 
-	if (port->open_count == (port->console? 1 : 0)) {
-		if (port->tty) {
-			if (port->tty->driver_data)
-				port->tty->driver_data = NULL;
-			port->tty = NULL;
+	if (port->port.count == (port->console? 1 : 0)) {
+		if (port->port.tty) {
+			if (port->port.tty->driver_data)
+				port->port.tty->driver_data = NULL;
+			port->port.tty = NULL;
 		}
 	}
 
-	if (port->open_count == 0) {
+	if (port->port.count == 0) {
 		usb_autopm_put_interface(port->serial->interface);
 		module_put(port->serial->type->driver.owner);
 	}
@@ -301,12 +301,12 @@ static int serial_write (struct tty_struct * tty, const unsigned char *buf, int
 
 	dbg("%s - port %d, %d byte(s)", __func__, port->number, count);
 
-	/* open_count is managed under the mutex lock for the tty so cannot
+	/* count is managed under the mutex lock for the tty so cannot
            drop to zero until after the last close completes */
-	WARN_ON(!port->open_count);
+	WARN_ON(!port->port.count);
 
 	/* pass on to the driver specific version of this function */
-	retval = port->serial->type->write(port, buf, count);
+	retval = port->serial->type->write(tty, port, buf, count);
 
 exit:
 	return retval;
@@ -316,9 +316,9 @@ static int serial_write_room (struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s - port %d", __func__, port->number);
-	WARN_ON(!port->open_count);
+	WARN_ON(!port->port.count);
 	/* pass on to the driver specific version of this function */
-	return port->serial->type->write_room(port);
+	return port->serial->type->write_room(tty);
 }
 
 static int serial_chars_in_buffer (struct tty_struct *tty) 
@@ -326,9 +326,9 @@ static int serial_chars_in_buffer (struct tty_struct *tty)
 	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s = port %d", __func__, port->number);
 
-	WARN_ON(!port->open_count);
+	WARN_ON(!port->port.count);
 	/* pass on to the driver specific version of this function */
-	return port->serial->type->chars_in_buffer(port);
+	return port->serial->type->chars_in_buffer(tty);
 }
 
 static void serial_throttle (struct tty_struct * tty)
@@ -336,10 +336,10 @@ static void serial_throttle (struct tty_struct * tty)
 	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s - port %d", __func__, port->number);
 
-	WARN_ON(!port->open_count);
+	WARN_ON(!port->port.count);
 	/* pass on to the driver specific version of this function */
 	if (port->serial->type->throttle)
-		port->serial->type->throttle(port);
+		port->serial->type->throttle(tty);
 }
 
 static void serial_unthrottle (struct tty_struct * tty)
@@ -347,10 +347,10 @@ static void serial_unthrottle (struct tty_struct * tty)
 	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s - port %d", __func__, port->number);
 
-	WARN_ON(!port->open_count);
+	WARN_ON(!port->port.count);
 	/* pass on to the driver specific version of this function */
 	if (port->serial->type->unthrottle)
-		port->serial->type->unthrottle(port);
+		port->serial->type->unthrottle(tty);
 }
 
 static int serial_ioctl (struct tty_struct *tty, struct file * file, unsigned int cmd, unsigned long arg)
@@ -360,12 +360,12 @@ static int serial_ioctl (struct tty_struct *tty, struct file * file, unsigned in
 
 	dbg("%s - port %d, cmd 0x%.4x", __func__, port->number, cmd);
 
-	WARN_ON(!port->open_count);
+	WARN_ON(!port->port.count);
 
 	/* pass on to the driver specific version of this function if it is available */
 	if (port->serial->type->ioctl) {
 		lock_kernel();
-		retval = port->serial->type->ioctl(port, file, cmd, arg);
+		retval = port->serial->type->ioctl(tty, file, cmd, arg);
 		unlock_kernel();
 	}
 	else
@@ -378,10 +378,10 @@ static void serial_set_termios (struct tty_struct *tty, struct ktermios * old)
 	struct usb_serial_port *port = tty->driver_data;
 	dbg("%s - port %d", __func__, port->number);
 
-	WARN_ON(!port->open_count);
+	WARN_ON(!port->port.count);
 	/* pass on to the driver specific version of this function if it is available */
 	if (port->serial->type->set_termios)
-		port->serial->type->set_termios(port, old);
+		port->serial->type->set_termios(tty, port, old);
 	else
 		tty_termios_copy_hw(tty->termios, old);
 }
@@ -392,11 +392,11 @@ static void serial_break (struct tty_struct *tty, int break_state)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	WARN_ON(!port->open_count);
+	WARN_ON(!port->port.count);
 	/* pass on to the driver specific version of this function if it is available */
 	if (port->serial->type->break_ctl) {
 		lock_kernel();
-		port->serial->type->break_ctl(port, break_state);
+		port->serial->type->break_ctl(tty, break_state);
 		unlock_kernel();
 	}
 }
@@ -454,9 +454,9 @@ static int serial_tiocmget (struct tty_struct *tty, struct file *file)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	WARN_ON(!port->open_count);
+	WARN_ON(!port->port.count);
 	if (port->serial->type->tiocmget)
-		return port->serial->type->tiocmget(port, file);
+		return port->serial->type->tiocmget(tty, file);
 	return -EINVAL;
 }
 
@@ -467,9 +467,9 @@ static int serial_tiocmset (struct tty_struct *tty, struct file *file,
 
 	dbg("%s - port %d", __func__, port->number);
 
-	WARN_ON(!port->open_count);
+	WARN_ON(!port->port.count);
 	if (port->serial->type->tiocmset)
-		return port->serial->type->tiocmset(port, file, set, clear);
+		return port->serial->type->tiocmset(tty, file, set, clear);
 	return -EINVAL;
 }
 
@@ -494,7 +494,7 @@ static void usb_serial_port_work(struct work_struct *work)
 	if (!port)
 		return;
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (!tty)
 		return;
 
@@ -1007,8 +1007,8 @@ void usb_serial_disconnect(struct usb_interface *interface)
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		if (port) {
-			if (port->tty)
-				tty_hangup(port->tty);
+			if (port->port.tty)
+				tty_hangup(port->port.tty);
 			kill_traffic(port);
 		}
 	}
diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index 5fc2012..373a3c7 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -35,17 +35,15 @@
 #define DRIVER_DESC "USB HandSpring Visor / Palm OS driver"
 
 /* function prototypes for a handspring visor */
-static int  visor_open		(struct usb_serial_port *port, struct file *filp);
-static void visor_close		(struct usb_serial_port *port, struct file *filp);
-static int  visor_write		(struct usb_serial_port *port, const unsigned char *buf, int count);
-static int  visor_write_room		(struct usb_serial_port *port);
-static int  visor_chars_in_buffer	(struct usb_serial_port *port);
-static void visor_throttle	(struct usb_serial_port *port);
-static void visor_unthrottle	(struct usb_serial_port *port);
+static int  visor_open		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static void visor_close		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static int  visor_write		(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count);
+static int  visor_write_room	(struct tty_struct *tty);
+static void visor_throttle	(struct tty_struct *tty);
+static void visor_unthrottle	(struct tty_struct *tty);
 static int  visor_probe		(struct usb_serial *serial, const struct usb_device_id *id);
 static int  visor_calc_num_ports(struct usb_serial *serial);
 static void visor_shutdown	(struct usb_serial *serial);
-static int  visor_ioctl		(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg);
 static void visor_write_bulk_callback	(struct urb *urb);
 static void visor_read_bulk_callback	(struct urb *urb);
 static void visor_read_int_callback	(struct urb *urb);
@@ -198,10 +196,8 @@ static struct usb_serial_driver handspring_device = {
 	.probe =		visor_probe,
 	.calc_num_ports =	visor_calc_num_ports,
 	.shutdown =		visor_shutdown,
-	.ioctl =		visor_ioctl,
 	.write =		visor_write,
 	.write_room =		visor_write_room,
-	.chars_in_buffer =	visor_chars_in_buffer,
 	.write_bulk_callback =	visor_write_bulk_callback,
 	.read_bulk_callback =	visor_read_bulk_callback,
 	.read_int_callback =	visor_read_int_callback,
@@ -225,10 +221,8 @@ static struct usb_serial_driver clie_5_device = {
 	.probe =		visor_probe,
 	.calc_num_ports =	visor_calc_num_ports,
 	.shutdown =		visor_shutdown,
-	.ioctl =		visor_ioctl,
 	.write =		visor_write,
 	.write_room =		visor_write_room,
-	.chars_in_buffer =	visor_chars_in_buffer,
 	.write_bulk_callback =	visor_write_bulk_callback,
 	.read_bulk_callback =	visor_read_bulk_callback,
 	.read_int_callback =	visor_read_int_callback,
@@ -249,10 +243,8 @@ static struct usb_serial_driver clie_3_5_device = {
 	.throttle =		visor_throttle,
 	.unthrottle =		visor_unthrottle,
 	.attach =		clie_3_5_startup,
-	.ioctl =		visor_ioctl,
 	.write =		visor_write,
 	.write_room =		visor_write_room,
-	.chars_in_buffer =	visor_chars_in_buffer,
 	.write_bulk_callback =	visor_write_bulk_callback,
 	.read_bulk_callback =	visor_read_bulk_callback,
 };
@@ -274,7 +266,7 @@ static int stats;
 /******************************************************************************
  * Handspring Visor specific driver functions
  ******************************************************************************/
-static int visor_open (struct usb_serial_port *port, struct file *filp)
+static int visor_open (struct tty_struct *tty, struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
 	struct visor_private *priv = usb_get_serial_port_data(port);
@@ -300,8 +292,8 @@ static int visor_open (struct usb_serial_port *port, struct file *filp)
 	 * through, otherwise it is scheduled, and with high data rates (like
 	 * with OHCI) data can get lost.
 	 */
-	if (port->tty)
-		port->tty->low_latency = 1;
+	if (tty)
+		tty->low_latency = 1;
 
 	/* Start reading from the device */
 	usb_fill_bulk_urb (port->read_urb, serial->dev,
@@ -329,7 +321,8 @@ exit:
 }
 
 
-static void visor_close (struct usb_serial_port *port, struct file * filp)
+static void visor_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file * filp)
 {
 	struct visor_private *priv = usb_get_serial_port_data(port);
 	unsigned char *transfer_buffer;
@@ -361,7 +354,8 @@ static void visor_close (struct usb_serial_port *port, struct file * filp)
 }
 
 
-static int visor_write (struct usb_serial_port *port, const unsigned char *buf, int count)
+static int visor_write(struct tty_struct *tty, struct usb_serial_port *port,
+					const unsigned char *buf, int count)
 {
 	struct visor_private *priv = usb_get_serial_port_data(port);
 	struct usb_serial *serial = port->serial;
@@ -435,8 +429,9 @@ error_no_buffer:
 }
 
 
-static int visor_write_room (struct usb_serial_port *port)
+static int visor_write_room (struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct visor_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 
@@ -460,22 +455,6 @@ static int visor_write_room (struct usb_serial_port *port)
 }
 
 
-static int visor_chars_in_buffer (struct usb_serial_port *port)
-{
-	dbg("%s - port %d", __func__, port->number);
-
-	/* 
-	 * We can't really account for how much data we
-	 * have sent out, but hasn't made it through to the
-	 * device, so just tell the tty layer that everything
-	 * is flushed.
-	 *
-	 * FIXME: Should walk outstanding_urbs
-	 */
-	return 0;
-}
-
-
 static void visor_write_bulk_callback (struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
@@ -520,7 +499,7 @@ static void visor_read_bulk_callback (struct urb *urb)
 
 	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (tty && urb->actual_length) {
 		available_room = tty_buffer_request_room(tty, urb->actual_length);
 		if (available_room) {
@@ -591,8 +570,9 @@ exit:
 			__func__, result);
 }
 
-static void visor_throttle (struct usb_serial_port *port)
+static void visor_throttle (struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct visor_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 
@@ -603,8 +583,9 @@ static void visor_throttle (struct usb_serial_port *port)
 }
 
 
-static void visor_unthrottle (struct usb_serial_port *port)
+static void visor_unthrottle (struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct visor_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	int result;
@@ -922,13 +903,6 @@ static void visor_shutdown (struct usb_serial *serial)
 	}
 }
 
-static int visor_ioctl (struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg)
-{
-	dbg("%s - port %d, cmd 0x%.4x", __func__, port->number, cmd);
-
-	return -ENOIOCTLCMD;
-}
-
 static int __init visor_init (void)
 {
 	int i, retval;
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index f07e8a4..fdadf39 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -141,18 +141,18 @@ static int  whiteheat_firmware_attach	(struct usb_serial *serial);
 /* function prototypes for the Connect Tech WhiteHEAT serial converter */
 static int  whiteheat_attach		(struct usb_serial *serial);
 static void whiteheat_shutdown		(struct usb_serial *serial);
-static int  whiteheat_open		(struct usb_serial_port *port, struct file *filp);
-static void whiteheat_close		(struct usb_serial_port *port, struct file *filp);
-static int  whiteheat_write		(struct usb_serial_port *port, const unsigned char *buf, int count);
-static int  whiteheat_write_room	(struct usb_serial_port *port);
-static int  whiteheat_ioctl		(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg);
-static void whiteheat_set_termios	(struct usb_serial_port *port, struct ktermios * old);
-static int  whiteheat_tiocmget		(struct usb_serial_port *port, struct file *file);
-static int  whiteheat_tiocmset		(struct usb_serial_port *port, struct file *file, unsigned int set, unsigned int clear);
-static void whiteheat_break_ctl		(struct usb_serial_port *port, int break_state);
-static int  whiteheat_chars_in_buffer	(struct usb_serial_port *port);
-static void whiteheat_throttle		(struct usb_serial_port *port);
-static void whiteheat_unthrottle	(struct usb_serial_port *port);
+static int  whiteheat_open		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static void whiteheat_close		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static int  whiteheat_write		(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count);
+static int  whiteheat_write_room	(struct tty_struct *tty);
+static int  whiteheat_ioctl		(struct tty_struct *tty, struct file * file, unsigned int cmd, unsigned long arg);
+static void whiteheat_set_termios	(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios * old);
+static int  whiteheat_tiocmget		(struct tty_struct *tty, struct file *file);
+static int  whiteheat_tiocmset		(struct tty_struct *tty, struct file *file, unsigned int set, unsigned int clear);
+static void whiteheat_break_ctl		(struct tty_struct *tty, int break_state);
+static int  whiteheat_chars_in_buffer	(struct tty_struct *tty);
+static void whiteheat_throttle		(struct tty_struct *tty);
+static void whiteheat_unthrottle	(struct tty_struct *tty);
 static void whiteheat_read_callback	(struct urb *urb);
 static void whiteheat_write_callback	(struct urb *urb);
 
@@ -245,7 +245,7 @@ static void rx_data_softint(struct work_struct *work);
 static int firm_send_command(struct usb_serial_port *port, __u8 command, __u8 *data, __u8 datasize);
 static int firm_open(struct usb_serial_port *port);
 static int firm_close(struct usb_serial_port *port);
-static int firm_setup_port(struct usb_serial_port *port);
+static int firm_setup_port(struct tty_struct *tty);
 static int firm_set_rts(struct usb_serial_port *port, __u8 onoff);
 static int firm_set_dtr(struct usb_serial_port *port, __u8 onoff);
 static int firm_set_break(struct usb_serial_port *port, __u8 onoff);
@@ -593,7 +593,8 @@ static void whiteheat_shutdown (struct usb_serial *serial)
 }
 
 
-static int whiteheat_open (struct usb_serial_port *port, struct file *filp)
+static int whiteheat_open (struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	int		retval = 0;
 	struct ktermios	old_term;
@@ -604,7 +605,8 @@ static int whiteheat_open (struct usb_serial_port *port, struct file *filp)
 	if (retval)
 		goto exit;
 
-	port->tty->low_latency = 1;
+	if (tty)
+		tty->low_latency = 1;
 
 	/* send an open port command */
 	retval = firm_open(port);
@@ -620,9 +622,11 @@ static int whiteheat_open (struct usb_serial_port *port, struct file *filp)
 		goto exit;
 	}
 
-	old_term.c_cflag = ~port->tty->termios->c_cflag;
-	old_term.c_iflag = ~port->tty->termios->c_iflag;
-	whiteheat_set_termios(port, &old_term);
+	if (tty) {
+		old_term.c_cflag = ~tty->termios->c_cflag;
+		old_term.c_iflag = ~tty->termios->c_iflag;
+		whiteheat_set_termios(tty, port, &old_term);
+	}
 
 	/* Work around HCD bugs */
 	usb_clear_halt(port->serial->dev, port->read_urb->pipe);
@@ -643,7 +647,8 @@ exit:
 }
 
 
-static void whiteheat_close(struct usb_serial_port *port, struct file * filp)
+static void whiteheat_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file * filp)
 {
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
 	struct whiteheat_urb_wrap *wrap;
@@ -661,7 +666,7 @@ static void whiteheat_close(struct usb_serial_port *port, struct file * filp)
 	}
 	mutex_unlock(&port->serial->disc_mutex);
 
-	port->tty->closing = 1;
+	tty->closing = 1;
 
 /*
  * Not currently in use; tty_wait_until_sent() calls
@@ -669,12 +674,12 @@ static void whiteheat_close(struct usb_serial_port *port, struct file * filp)
  * acquisition. This should be fixed at some point. Greg's been
  * notified.
 	if ((filp->f_flags & (O_NDELAY | O_NONBLOCK)) == 0) {
-		tty_wait_until_sent(port->tty, CLOSING_DELAY);
+		tty_wait_until_sent(tty, CLOSING_DELAY);
 	}
 */
 
-	tty_driver_flush_buffer(port->tty);
-	tty_ldisc_flush(port->tty);
+	tty_driver_flush_buffer(tty);
+	tty_ldisc_flush(tty);
 
 	firm_report_tx_done(port);
 
@@ -708,11 +713,12 @@ static void whiteheat_close(struct usb_serial_port *port, struct file * filp)
 
 	stop_command_port(port->serial);
 
-	port->tty->closing = 0;
+	tty->closing = 0;
 }
 
 
-static int whiteheat_write(struct usb_serial_port *port, const unsigned char *buf, int count)
+static int whiteheat_write(struct tty_struct *tty,
+	struct usb_serial_port *port, const unsigned char *buf, int count)
 {
 	struct usb_serial *serial = port->serial;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
@@ -771,8 +777,9 @@ static int whiteheat_write(struct usb_serial_port *port, const unsigned char *bu
 }
 
 
-static int whiteheat_write_room(struct usb_serial_port *port)
+static int whiteheat_write_room(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
 	struct list_head *tmp;
 	int room = 0;
@@ -791,8 +798,9 @@ static int whiteheat_write_room(struct usb_serial_port *port)
 }
 
 
-static int whiteheat_tiocmget (struct usb_serial_port *port, struct file *file)
+static int whiteheat_tiocmget (struct tty_struct *tty, struct file *file)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
 	unsigned int modem_signals = 0;
 
@@ -808,9 +816,10 @@ static int whiteheat_tiocmget (struct usb_serial_port *port, struct file *file)
 }
 
 
-static int whiteheat_tiocmset (struct usb_serial_port *port, struct file *file,
+static int whiteheat_tiocmset (struct tty_struct *tty, struct file *file,
 			       unsigned int set, unsigned int clear)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
 
 	dbg("%s - port %d", __func__, port->number);
@@ -831,8 +840,9 @@ static int whiteheat_tiocmset (struct usb_serial_port *port, struct file *file,
 }
 
 
-static int whiteheat_ioctl (struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg)
+static int whiteheat_ioctl (struct tty_struct *tty, struct file * file, unsigned int cmd, unsigned long arg)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct serial_struct serstruct;
 	void __user *user_arg = (void __user *)arg;
 
@@ -876,20 +886,21 @@ static int whiteheat_ioctl (struct usb_serial_port *port, struct file * file, un
 }
 
 
-static void whiteheat_set_termios(struct usb_serial_port *port, struct ktermios *old_termios)
+static void whiteheat_set_termios(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios *old_termios)
 {
-	dbg("%s -port %d", __func__, port->number);
-	firm_setup_port(port);
+	firm_setup_port(tty);
 }
 
 
-static void whiteheat_break_ctl(struct usb_serial_port *port, int break_state) {
+static void whiteheat_break_ctl(struct tty_struct *tty, int break_state) {
+	struct usb_serial_port *port = tty->driver_data;
 	firm_set_break(port, break_state);
 }
 
 
-static int whiteheat_chars_in_buffer(struct usb_serial_port *port)
+static int whiteheat_chars_in_buffer(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
 	struct list_head *tmp;
 	struct whiteheat_urb_wrap *wrap;
@@ -910,8 +921,9 @@ static int whiteheat_chars_in_buffer(struct usb_serial_port *port)
 }
 
 
-static void whiteheat_throttle (struct usb_serial_port *port)
+static void whiteheat_throttle (struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
 	unsigned long flags;
 
@@ -925,8 +937,9 @@ static void whiteheat_throttle (struct usb_serial_port *port)
 }
 
 
-static void whiteheat_unthrottle (struct usb_serial_port *port)
+static void whiteheat_unthrottle (struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
 	int actually_throttled;
 	unsigned long flags;
@@ -1164,9 +1177,10 @@ static int firm_close(struct usb_serial_port *port) {
 }
 
 
-static int firm_setup_port(struct usb_serial_port *port) {
+static int firm_setup_port(struct tty_struct *tty) {
+	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_port_settings port_settings;
-	unsigned int cflag = port->tty->termios->c_cflag;
+	unsigned int cflag = tty->termios->c_cflag;
 
 	port_settings.port = port->number + 1;
 
@@ -1215,22 +1229,22 @@ static int firm_setup_port(struct usb_serial_port *port) {
 	    (port_settings.hflow & WHITEHEAT_HFLOW_DTR) ? "DTR" : "");
 	
 	/* determine software flow control */
-	if (I_IXOFF(port->tty))
+	if (I_IXOFF(tty))
 		port_settings.sflow = WHITEHEAT_SFLOW_RXTX;
 	else
 		port_settings.sflow = WHITEHEAT_SFLOW_NONE;
 	dbg("%s - software flow control = %c", __func__, port_settings.sflow);
 	
-	port_settings.xon = START_CHAR(port->tty);
-	port_settings.xoff = STOP_CHAR(port->tty);
+	port_settings.xon = START_CHAR(tty);
+	port_settings.xoff = STOP_CHAR(tty);
 	dbg("%s - XON = %2x, XOFF = %2x", __func__, port_settings.xon, port_settings.xoff);
 
 	/* get the baud rate wanted */
-	port_settings.baud = tty_get_baud_rate(port->tty);
+	port_settings.baud = tty_get_baud_rate(tty);
 	dbg("%s - baud rate = %d", __func__, port_settings.baud);
 
 	/* fixme: should set validated settings */
-	tty_encode_baud_rate(port->tty, port_settings.baud, port_settings.baud);
+	tty_encode_baud_rate(tty, port_settings.baud, port_settings.baud);
 	/* handle any settings that aren't specified in the tty structure */
 	port_settings.lloop = 0;
 	
@@ -1406,7 +1420,7 @@ static void rx_data_softint(struct work_struct *work)
 	struct whiteheat_private *info =
 		container_of(work, struct whiteheat_private, rx_work);
 	struct usb_serial_port *port = info->port;
-	struct tty_struct *tty = port->tty;
+	struct tty_struct *tty = port->port.tty;
 	struct whiteheat_urb_wrap *wrap;
 	struct urb *urb;
 	unsigned long flags;
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 8f891cb..09a3e6a 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -62,7 +62,7 @@
  */
 struct usb_serial_port {
 	struct usb_serial	*serial;
-	struct tty_struct	*tty;
+	struct tty_port		port;
 	spinlock_t		lock;
 	struct mutex            mutex;
 	unsigned char		number;
@@ -89,7 +89,6 @@ struct usb_serial_port {
 
 	wait_queue_head_t	write_wait;
 	struct work_struct	work;
-	int			open_count;
 	char			throttled;
 	char			throttle_req;
 	char			console;
@@ -217,22 +216,27 @@ struct usb_serial_driver {
 	int (*resume)(struct usb_serial *serial);
 
 	/* serial function calls */
-	int  (*open)(struct usb_serial_port *port, struct file *filp);
-	void (*close)(struct usb_serial_port *port, struct file *filp);
-	int  (*write)(struct usb_serial_port *port, const unsigned char *buf,
-		      int count);
-	int  (*write_room)(struct usb_serial_port *port);
-	int  (*ioctl)(struct usb_serial_port *port, struct file *file,
+	/* Called by console with tty = NULL and by tty */
+	int  (*open)(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+	void (*close)(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+	int  (*write)(struct tty_struct *tty, struct usb_serial_port *port,
+			const unsigned char *buf, int count);
+	/* Called only by the tty layer */
+	int  (*write_room)(struct tty_struct *tty);
+	int  (*ioctl)(struct tty_struct *tty, struct file *file,
 		      unsigned int cmd, unsigned long arg);
-	void (*set_termios)(struct usb_serial_port *port, struct ktermios *old);
-	void (*break_ctl)(struct usb_serial_port *port, int break_state);
-	int  (*chars_in_buffer)(struct usb_serial_port *port);
-	void (*throttle)(struct usb_serial_port *port);
-	void (*unthrottle)(struct usb_serial_port *port);
-	int  (*tiocmget)(struct usb_serial_port *port, struct file *file);
-	int  (*tiocmset)(struct usb_serial_port *port, struct file *file,
+	void (*set_termios)(struct tty_struct *tty,
+			struct usb_serial_port *port, struct ktermios *old);
+	void (*break_ctl)(struct tty_struct *tty, int break_state);
+	int  (*chars_in_buffer)(struct tty_struct *tty);
+	void (*throttle)(struct tty_struct *tty);
+	void (*unthrottle)(struct tty_struct *tty);
+	int  (*tiocmget)(struct tty_struct *tty, struct file *file);
+	int  (*tiocmset)(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear);
-
+	/* USB events */
 	void (*read_int_callback)(struct urb *urb);
 	void (*write_int_callback)(struct urb *urb);
 	void (*read_bulk_callback)(struct urb *urb);
@@ -270,19 +274,19 @@ static inline void usb_serial_console_disconnect(struct usb_serial *serial) {}
 /* Functions needed by other parts of the usbserial core */
 extern struct usb_serial *usb_serial_get_by_index(unsigned int minor);
 extern void usb_serial_put(struct usb_serial *serial);
-extern int usb_serial_generic_open(struct usb_serial_port *port,
-				   struct file *filp);
-extern int usb_serial_generic_write(struct usb_serial_port *port,
-				    const unsigned char *buf, int count);
-extern void usb_serial_generic_close(struct usb_serial_port *port,
-				     struct file *filp);
+extern int usb_serial_generic_open(struct tty_struct *tty,
+		struct usb_serial_port *port, struct file *filp);
+extern int usb_serial_generic_write(struct tty_struct *tty,
+	struct usb_serial_port *port, const unsigned char *buf, int count);
+extern void usb_serial_generic_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
 extern int usb_serial_generic_resume(struct usb_serial *serial);
-extern int usb_serial_generic_write_room(struct usb_serial_port *port);
-extern int usb_serial_generic_chars_in_buffer(struct usb_serial_port *port);
+extern int usb_serial_generic_write_room(struct tty_struct *tty);
+extern int usb_serial_generic_chars_in_buffer(struct tty_struct *tty);
 extern void usb_serial_generic_read_bulk_callback(struct urb *urb);
 extern void usb_serial_generic_write_bulk_callback(struct urb *urb);
-extern void usb_serial_generic_throttle(struct usb_serial_port *port);
-extern void usb_serial_generic_unthrottle(struct usb_serial_port *port);
+extern void usb_serial_generic_throttle(struct tty_struct *tty);
+extern void usb_serial_generic_unthrottle(struct tty_struct *tty);
 extern void usb_serial_generic_shutdown(struct usb_serial *serial);
 extern int usb_serial_generic_register(int debug);
 extern void usb_serial_generic_deregister(void);
