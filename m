Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZADVSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZADVSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZADVSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:18:12 -0500
Received: from vuizook.err.no ([85.19.221.46]:39546 "EHLO vuizook.err.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbZADVSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:18:10 -0500
From: Tollef Fog Heen <tfheen@err.no>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, werner@cornelius-consult.de,
       frank@kingswood-consulting.co.uk
Subject: [PATCH] Winchiphead 340/1: full baud rate and status/control line support
References: <87iqovs740.fsf@qurzaw.linpro.no>
Mail-Copies-To: never
Date: Sun, 04 Jan 2009 22:18:02 +0100
In-Reply-To: <87iqovs740.fsf@qurzaw.linpro.no> (Tollef Fog Heen's message of
	"Sun, 04 Jan 2009 11:22:55 +0100")
Message-ID: <87vdsu93ed.fsf@qurzaw.linpro.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patch against current git (3c92ec8ae91ecf59d88c798301833d7cf83f2179)

From: Tollef Fog Heen <tfheen@err.no>

* Implement support for all baud rates rather than just a hard coded set.
* Make it possible to control status and control lines
* Grab a bunch of #defines from FreeBSD to reduce the number of magic
  numbers in the file

Signed-off-by: Tollef Fog Heen <tfheen@err.no>
---

 Documentation/usb/usb-serial.txt |    2
 drivers/usb/serial/ch341.c       |  501 ++++++++++++++++++++++++++++++++-------
 2 files changed, 419 insertions(+), 84 deletions(-)

diff --git a/Documentation/usb/usb-serial.txt b/Documentation/usb/usb-serial.txt
index ff2c1ff..201ec84 100644
--- a/Documentation/usb/usb-serial.txt
+++ b/Documentation/usb/usb-serial.txt
@@ -434,6 +434,8 @@ Winchiphead CH341 Driver
   The manufacturer's website: http://www.winchiphead.com/.
   For any questions or problems with this driver, please contact
   frank@kingswood-consulting.co.uk.
+  Extensions for universal baudrate settings and modem status/control have
+  been added by werner <at> cornelius-consult.de.
 
 
 Generic Serial driver
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index f61e3ca..a661941 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -1,5 +1,7 @@
 /*
  * Copyright 2007, Frank A Kingswood <frank@kingswood-consulting.co.uk>
+ * Copyright 2007, Werner Cornelius <werner <at> cornelius-consult.de>
+ * Copyright 2008, 2009, Tollef Fog Heen <tfheen@err.no>
  *
  * ch341.c implements a serial port driver for the Winchiphead CH341.
  *
@@ -11,6 +13,9 @@
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version
  * 2 as published by the Free Software Foundation.
+ *
+ * Also see http://fxr.watson.org/fxr/source/dev/usb/uchcom.c (or
+ * freebsd:/src/sys/dev/usb/uchcom.c)
  */
 
 #include <linux/kernel.h>
@@ -19,11 +24,81 @@
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/mutex.h>
 #include <linux/serial.h>
 
 #define DEFAULT_BAUD_RATE 2400
 #define DEFAULT_TIMEOUT   1000
 
+/* flags for IO-Bits */
+#define CH341_BIT_RTS (1 << 6)
+#define CH341_BIT_DTR (1 << 5)
+
+#define CH341_REQ_GET_VERSION  0x5F
+#define CH341_REQ_READ_REG     0x95
+#define CH341_REQ_WRITE_REG    0x9A
+#define CH341_REQ_RESET        0xA1
+#define CH341_REQ_SET_DTRRTS   0xA4
+
+#define CH341_REG_STAT1        0x06
+#define CH341_REG_STAT2        0x07
+#define CH341_REG_BPS_PRE      0x12
+#define CH341_REG_BPS_DIV      0x13
+#define CH341_REG_BPS_MOD      0x14
+#define CH341_REG_BPS_PAD      0x0F
+#define CH341_REG_BREAK1       0x05
+#define CH341_REG_BREAK2       0x18
+#define CH341_REG_LCR1         0x18
+#define CH341_REG_LCR2         0x25
+
+#define CH341_VER_20           0x20
+
+#define CH341_BPS_MOD_BASE     20000000
+#define CH341_BPS_MOD_BASE_OFS 1100
+
+#define CH341_BRK1_MASK        0x01
+#define CH341_BRK2_MASK        0x40
+
+#define CH341_LCR1_MASK        0xAF
+#define CH341_LCR2_MASK        0x07
+#define CH341_LCR1_PARENB      0x80
+#define CH341_LCR2_PAREVEN     0x07
+#define CH341_LCR2_PARODD      0x06
+#define CH341_LCR2_PARMARK     0x05
+#define CH341_LCR2_PARSPACE    0x04
+
+#define CH341_INTR_STAT1       0x02
+#define CH341_INTR_STAT2       0x03
+#define CH341_INTR_LEAST       4
+
+#define CH341_REGISTERS(a,b) ((a << 8) | b)
+
+/******************************/
+/* interrupt pipe definitions */
+/******************************/
+/* always 4 interrupt bytes */
+/* first irq byte normally 0x08 */
+/* second irq byte base 0x7d + below */
+/* third irq byte base 0x94 + below */
+/* fourth irq byte normally 0xee */
+
+/* second interrupt byte */
+#define CH341_MULT_STAT 0x04 /* multiple status since last interrupt event */
+
+/* status returned in third interrupt answer byte, inverted in data
+   from irq */
+#define CH341_BIT_CTS 0x01
+#define CH341_BIT_DSR 0x02
+#define CH341_BIT_RI  0x04
+#define CH341_BIT_DCD 0x08
+#define CH341_BITS_MODEM_STAT 0x0f /* all bits */
+
+/*******************************/
+/* baudrate calculation factor */
+/*******************************/
+#define CH341_BAUDBASE_FACTOR 1532620800
+#define CH341_BAUDBASE_DIVMAX 3
+
 static int debug;
 
 static struct usb_device_id id_table [] = {
@@ -34,9 +109,15 @@ static struct usb_device_id id_table [] = {
 MODULE_DEVICE_TABLE(usb, id_table);
 
 struct ch341_private {
-	unsigned baud_rate;
-	u8 dtr;
-	u8 rts;
+	spinlock_t lock; /* access lock */
+	wait_queue_head_t delta_msr_wait; /* wait queue for modem status */
+	int delta_msr_cond;
+	unsigned baud_rate; /* set baud rate */
+	struct mutex handshake_lock;
+	u8 line_control; /* set line control value RTS/DTR */
+	u8 line_status; /* active status of modem control inputs */
+	u8 multi_status_change; /* status changed multiple since last call */
+	struct usb_serial *serial;
 };
 
 static int ch341_control_out(struct usb_device *dev, u8 request,
@@ -68,61 +149,71 @@ static int ch341_control_in(struct usb_device *dev,
 }
 
 static int ch341_set_baudrate(struct usb_device *dev,
+			      struct tty_struct *tty,
 			      struct ch341_private *priv)
 {
 	short a, b;
 	int r;
+	unsigned long factor;
+	unsigned baud_rate;
+	short divisor;
 
 	dbg("ch341_set_baudrate(%d)", priv->baud_rate);
-	switch (priv->baud_rate) {
-	case 2400:
-		a = 0xd901;
-		b = 0x0038;
-		break;
-	case 4800:
-		a = 0x6402;
-		b = 0x001f;
-		break;
-	case 9600:
-		a = 0xb202;
-		b = 0x0013;
-		break;
-	case 19200:
-		a = 0xd902;
-		b = 0x000d;
-		break;
-	case 38400:
-		a = 0x6403;
-		b = 0x000a;
-		break;
-	case 115200:
-		a = 0xcc03;
-		b = 0x0008;
-		break;
-	default:
-		return -EINVAL;
+
+	if (priv->baud_rate > CH341_BAUDBASE_FACTOR)
+		priv->baud_rate = CH341_BAUDBASE_FACTOR;
+	else if (priv->baud_rate < 50) { /* Slowest we can go */
+		priv->baud_rate = 50;
+	}
+	baud_rate = priv->baud_rate;
+
+	if (tty)
+		tty_encode_baud_rate(tty, baud_rate, baud_rate);
+
+	if (baud_rate == 307200 ||
+	    baud_rate == 921600) {
+		divisor = 7;
+		factor = (baud_rate == 307200 ? 0xD9 : 0xF3 );
+	} else {
+		factor = (CH341_BAUDBASE_FACTOR / baud_rate);
+		divisor = CH341_BAUDBASE_DIVMAX;
+		while ((factor > 0xfff0) && divisor) {
+			factor >>= 3;
+			divisor--;
+		}
 	}
 
-	r = ch341_control_out(dev, 0x9a, 0x1312, a);
+	factor = 0x10000 - factor;
+	a = (factor & 0xff00) | divisor;
+	b = CH341_BPS_MOD_BASE / baud_rate + CH341_BPS_MOD_BASE_OFS;
+	b += b/2;
+	b /= 0x100;
+	b++;
+
+	r = ch341_control_out(dev, CH341_REQ_WRITE_REG, 
+			      CH341_REGISTERS(CH341_REG_BPS_DIV, 
+					      CH341_REG_BPS_PRE),
+			      a);
 	if (!r)
-		r = ch341_control_out(dev, 0x9a, 0x0f2c, b);
-
+		r = ch341_control_out(dev, CH341_REQ_WRITE_REG,
+				      CH341_REGISTERS(CH341_REG_BPS_PAD, 
+						      CH341_REG_BPS_MOD),
+				      b);
 	return r;
 }
 
-static int ch341_set_handshake(struct usb_device *dev,
-			       struct ch341_private *priv)
+static int ch341_set_handshake(struct usb_device *dev, u8 control)
 {
-	dbg("ch341_set_handshake(%d,%d)", priv->dtr, priv->rts);
-	return ch341_control_out(dev, 0xa4,
-		~((priv->dtr?1<<5:0)|(priv->rts?1<<6:0)), 0);
+	dbg("ch341_set_handshake(0x%02x)", control);
+	return ch341_control_out(dev, CH341_REQ_SET_DTRRTS, ~control, 0);
 }
 
-static int ch341_get_status(struct usb_device *dev)
+static int ch341_get_status(struct usb_device *dev, struct ch341_private *priv)
 {
 	char *buffer;
 	int r;
 	const unsigned size = 8;
+	unsigned long flags;
 
 	dbg("ch341_get_status()");
 
@@ -130,14 +221,21 @@ static int ch341_get_status(struct usb_device *dev)
 	if (!buffer)
 		return -ENOMEM;
 
-	r = ch341_control_in(dev, 0x95, 0x0706, 0, buffer, size);
+	r = ch341_control_in(dev, CH341_REQ_READ_REG, 
+			     CH341_REGISTERS(CH341_REG_STAT2, CH341_REG_STAT1),
+			     0, buffer, size);
 	if (r < 0)
 		goto out;
 
-	/* Not having the datasheet for the CH341, we ignore the bytes returned
-	 * from the device. Return error if the device did not respond in time.
-	 */
-	r = 0;
+	/* setup the private status if available */
+	if (r == 2) {
+		r = 0;
+		spin_lock_irqsave(&priv->lock, flags);
+		priv->line_status = (~(*buffer)) & CH341_BITS_MODEM_STAT;
+		priv->multi_status_change = 0;
+		spin_unlock_irqrestore(&priv->lock, flags);
+	} else
+		r = -EPROTO;
 
 out:	kfree(buffer);
 	return r;
@@ -158,46 +256,52 @@ static int ch341_configure(struct usb_device *dev, struct ch341_private *priv)
 		return -ENOMEM;
 
 	/* expect two bytes 0x27 0x00 */
-	r = ch341_control_in(dev, 0x5f, 0, 0, buffer, size);
+	r = ch341_control_in(dev, CH341_REQ_GET_VERSION, 0, 0, buffer, size);
 	if (r < 0)
 		goto out;
 
-	r = ch341_control_out(dev, 0xa1, 0, 0);
+	r = ch341_control_out(dev, CH341_REQ_RESET, 0, 0);
 	if (r < 0)
 		goto out;
 
-	r = ch341_set_baudrate(dev, priv);
+	r = ch341_set_baudrate(dev, NULL, priv);
 	if (r < 0)
 		goto out;
 
 	/* expect two bytes 0x56 0x00 */
-	r = ch341_control_in(dev, 0x95, 0x2518, 0, buffer, size);
+	r = ch341_control_in(dev, CH341_REQ_READ_REG,
+			     CH341_REGISTERS(CH341_REG_LCR2, CH341_REG_LCR1),
+			     0, buffer, size);
 	if (r < 0)
 		goto out;
 
-	r = ch341_control_out(dev, 0x9a, 0x2518, 0x0050);
+	r = ch341_control_out(dev, CH341_REQ_WRITE_REG,
+			      CH341_REGISTERS(CH341_REG_LCR2, CH341_REG_LCR1),
+			      0x0050);
 	if (r < 0)
 		goto out;
 
 	/* expect 0xff 0xee */
-	r = ch341_get_status(dev);
+	r = ch341_get_status(dev, priv);
 	if (r < 0)
 		goto out;
 
-	r = ch341_control_out(dev, 0xa1, 0x501f, 0xd90a);
+	r = ch341_control_out(dev, CH341_REQ_RESET, 0x501f, 0xd90a);
 	if (r < 0)
 		goto out;
 
-	r = ch341_set_baudrate(dev, priv);
+	r = ch341_set_baudrate(dev, NULL, priv);
 	if (r < 0)
 		goto out;
 
-	r = ch341_set_handshake(dev, priv);
+	mutex_lock(&priv->handshake_lock);
+	r = ch341_set_handshake(dev, priv->line_control);
+	mutex_unlock(&priv->handshake_lock);
 	if (r < 0)
 		goto out;
 
 	/* expect 0x9f 0xee */
-	r = ch341_get_status(dev);
+	r = ch341_get_status(dev, priv);
 
 out:	kfree(buffer);
 	return r;
@@ -216,21 +320,54 @@ static int ch341_attach(struct usb_serial *serial)
 	if (!priv)
 		return -ENOMEM;
 
+	spin_lock_init(&priv->lock);
+	init_waitqueue_head(&priv->delta_msr_wait);
 	priv->baud_rate = DEFAULT_BAUD_RATE;
-	priv->dtr = 1;
-	priv->rts = 1;
+	priv->line_control = CH341_BIT_RTS | CH341_BIT_DTR;
+	mutex_init(&priv-> handshake_lock);
+
+	priv->serial = serial;
 
 	r = ch341_configure(serial->dev, priv);
 	if (r < 0)
 		goto error;
 
 	usb_set_serial_port_data(serial->port[0], priv);
+
 	return 0;
 
 error:	kfree(priv);
 	return r;
 }
 
+static void ch341_close(struct tty_struct *tty, struct usb_serial_port *port,
+			struct file *filp)
+{
+	struct ch341_private *priv = usb_get_serial_port_data(port);
+	unsigned long flags;
+
+	dbg("%s - port %d", __func__, port->number);
+
+	/* shutdown our urbs */
+	dbg("%s - shutting down urbs", __func__);
+	usb_kill_urb(port->write_urb);
+	usb_kill_urb(port->read_urb);
+	usb_kill_urb(port->interrupt_in_urb);
+
+	if (C_HUPCL(tty)) {
+		/* drop DTR and RTS */
+		spin_lock_irqsave(&priv->lock, flags);
+		priv->line_control = 0;
+		spin_unlock_irqrestore(&priv->lock, flags);
+		mutex_lock(&priv->handshake_lock);
+		ch341_set_handshake(port->serial->dev, 0);
+		mutex_unlock(&priv->handshake_lock);
+	}
+	wake_up_interruptible(&priv->delta_msr_wait);
+	priv->delta_msr_cond = 1;
+}
+
+
 /* open this device, set default parameters */
 static int ch341_open(struct tty_struct *tty, struct usb_serial_port *port,
 				struct file *filp)
@@ -242,21 +379,34 @@ static int ch341_open(struct tty_struct *tty, struct usb_serial_port *port,
 	dbg("ch341_open()");
 
 	priv->baud_rate = DEFAULT_BAUD_RATE;
-	priv->dtr = 1;
-	priv->rts = 1;
+
+	if (tty && C_CLOCAL(tty))
+		priv->line_control = CH341_BIT_RTS | CH341_BIT_DTR;
+	else
+		priv->line_control = 0;
 
 	r = ch341_configure(serial->dev, priv);
 	if (r)
 		goto out;
 
-	r = ch341_set_handshake(serial->dev, priv);
+	mutex_lock(&priv->handshake_lock);
+	r = ch341_set_handshake(serial->dev, priv->line_control);
+	mutex_unlock(&priv->handshake_lock);
 	if (r)
 		goto out;
 
-	r = ch341_set_baudrate(serial->dev, priv);
+	r = ch341_set_baudrate(serial->dev, tty, priv);
 	if (r)
 		goto out;
 
+	dbg("%s - submitting interrupt urb", __func__);
+	port->interrupt_in_urb->dev = serial->dev;
+	r = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
+	if (r) {
+		dev_err(&port->dev, "%s - failed submitting interrupt urb,"
+			" error %d\n", __func__, r);
+		return -EPROTO;
+	}
 	r = usb_serial_generic_open(tty, port, filp);
 
 out:	return r;
@@ -270,38 +420,210 @@ static void ch341_set_termios(struct tty_struct *tty,
 {
 	struct ch341_private *priv = usb_get_serial_port_data(port);
 	unsigned baud_rate;
+	unsigned long flags;
 
 	dbg("ch341_set_termios()");
 
 	baud_rate = tty_get_baud_rate(tty);
 
-	switch (baud_rate) {
-	case 2400:
-	case 4800:
-	case 9600:
-	case 19200:
-	case 38400:
-	case 115200:
-		priv->baud_rate = baud_rate;
-		break;
-	default:
-		dbg("Rate %d not supported, using %d",
-			baud_rate, DEFAULT_BAUD_RATE);
-		priv->baud_rate = DEFAULT_BAUD_RATE;
+	priv->baud_rate = baud_rate;
+
+	if (baud_rate) {
+		spin_lock_irqsave(&priv->lock, flags);
+		priv->line_control |= (CH341_BIT_DTR | CH341_BIT_RTS);
+		spin_unlock_irqrestore(&priv->lock, flags);
+		ch341_set_baudrate(port->serial->dev, tty, priv);
+	} else {
+		spin_lock_irqsave(&priv->lock, flags);
+		priv->line_control &= ~(CH341_BIT_DTR | CH341_BIT_RTS);
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
-	ch341_set_baudrate(port->serial->dev, priv);
+	mutex_lock(&priv->handshake_lock);
+	ch341_set_handshake(port->serial->dev, priv->line_control);
+	mutex_unlock(&priv->handshake_lock);
 
 	/* Unimplemented:
 	 * (cflag & CSIZE) : data bits [5, 8]
 	 * (cflag & PARENB) : parity {NONE, EVEN, ODD}
 	 * (cflag & CSTOPB) : stop bits [1, 2]
 	 */
+	tty->termios->c_cflag &= ~(CSIZE | PARENB | CSTOPB);
+}
+
+static int ch341_tiocmset(struct tty_struct *tty, struct file *file,
+			  unsigned int set, unsigned int clear)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct ch341_private *priv = usb_get_serial_port_data(port);
+	unsigned long flags;
+	u8 control;
+	int r;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (set & TIOCM_RTS)
+		priv->line_control |= CH341_BIT_RTS;
+	if (set & TIOCM_DTR)
+		priv->line_control |= CH341_BIT_DTR;
+	if (clear & TIOCM_RTS)
+		priv->line_control &= ~CH341_BIT_RTS;
+	if (clear & TIOCM_DTR)
+		priv->line_control &= ~CH341_BIT_DTR;
+	control = priv->line_control;
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	mutex_lock(&priv->handshake_lock);
+	r = ch341_set_handshake(port->serial->dev, control);
+	mutex_unlock(&priv->handshake_lock);
+
+	return r;
+}
+
+static void ch341_read_int_callback(struct urb *urb)
+{
+	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	unsigned char *data = urb->transfer_buffer;
+	unsigned int actual_length = urb->actual_length;
+	int status;
+
+	dbg("%s (%d)", __func__, port->number);
+
+	switch (urb->status) {
+	case 0:
+		/* success */
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		/* this urb is terminated, clean up */
+		dbg("%s - urb shutting down with status: %d", __func__,
+		    urb->status);
+		return;
+	default:
+		dbg("%s - nonzero urb status received: %d", __func__,
+		    urb->status);
+		goto exit;
+	}
+
+	usb_serial_debug_data(debug, &port->dev, __func__,
+			      urb->actual_length, urb->transfer_buffer);
+
+	if (actual_length >= 4) {
+		struct ch341_private *priv = usb_get_serial_port_data(port);
+		unsigned long flags;
+
+		spin_lock_irqsave(&priv->lock, flags);
+		priv->line_status = (~(data[2])) & CH341_BITS_MODEM_STAT;
+		if ((data[1] & CH341_MULT_STAT))
+			priv->multi_status_change = 1;
+		spin_unlock_irqrestore(&priv->lock, flags);
+		wake_up_interruptible(&priv->delta_msr_wait);
+		priv->delta_msr_cond = 1;
+	}
+
+exit:
+	status = usb_submit_urb(urb, GFP_ATOMIC);
+	if (status)
+		dev_err(&urb->dev->dev,
+			"%s - usb_submit_urb failed with result %d\n",
+			__func__, status);
+}
+
+static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
+{
+	struct ch341_private *priv = usb_get_serial_port_data(port);
+	unsigned long flags;
+	u8 prevstatus;
+	u8 status;
+	u8 changed;
+	u8 multi_change = 0;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	prevstatus = priv->line_status;
+	priv->multi_status_change = 0;
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	while (!multi_change) {
+		priv->delta_msr_cond = 0;
+		wait_event_interruptible(priv->delta_msr_wait,
+					 (priv->delta_msr_cond == 1));
+		/* see if a signal did it */
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+
+		spin_lock_irqsave(&priv->lock, flags);
+		status = priv->line_status;
+		multi_change = priv->multi_status_change;
+		spin_unlock_irqrestore(&priv->lock, flags);
+
+		changed = prevstatus ^ status;
+
+		if (((arg & TIOCM_RNG) && (changed & CH341_BIT_RI)) ||
+		    ((arg & TIOCM_DSR) && (changed & CH341_BIT_DSR)) ||
+		    ((arg & TIOCM_CD)  && (changed & CH341_BIT_DCD)) ||
+		    ((arg & TIOCM_CTS) && (changed & CH341_BIT_CTS))) {
+			return 0;
+		}
+		prevstatus = status;
+	}
+
+	return 0;
+}
+
+static int ch341_ioctl(struct tty_struct *tty, struct file *file,
+			unsigned int cmd, unsigned long arg)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	dbg("%s (%d) cmd = 0x%04x", __func__, port->number, cmd);
+
+	switch (cmd) {
+	case TIOCMIWAIT:
+		dbg("%s (%d) TIOCMIWAIT", __func__,  port->number);
+		return wait_modem_info(port, arg);
+
+	default:
+		dbg("%s not supported = 0x%04x", __func__, cmd);
+		break;
+	}
+
+	return -ENOIOCTLCMD;
+}
+
+static int ch341_tiocmget(struct tty_struct *tty, struct file *file)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct ch341_private *priv = usb_get_serial_port_data(port);
+	unsigned long flags;
+	u8 mcr;
+	u8 status;
+	unsigned int result;
+
+	dbg("%s (%d)", __func__, port->number);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	mcr = priv->line_control;
+	status = priv->line_status;
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	result = ((mcr & CH341_BIT_DTR)		? TIOCM_DTR : 0)
+		  | ((mcr & CH341_BIT_RTS)	? TIOCM_RTS : 0)
+		  | ((status & CH341_BIT_CTS)	? TIOCM_CTS : 0)
+		  | ((status & CH341_BIT_DSR)	? TIOCM_DSR : 0)
+		  | ((status & CH341_BIT_RI)	? TIOCM_RI  : 0)
+		  | ((status & CH341_BIT_DCD)	? TIOCM_CD  : 0);
+
+	dbg("%s - result = %x", __func__, result);
+
+	return result;
+}
+
+static void ch341_shutdown(struct usb_serial *serial)
+{
+	struct ch341_private *priv = usb_get_serial_port_data(serial->port[0]);
+
+	dbg("%s", __func__);
 
-	 /* Copy back the old hardware settings */
-	 tty_termios_copy_hw(tty->termios, old_termios);
-	 /* And re-encode with the new baud */
-	 tty_encode_baud_rate(tty, baud_rate, baud_rate);
+	kfree(priv);
 }
 
 static struct usb_driver ch341_driver = {
@@ -317,12 +639,23 @@ static struct usb_serial_driver ch341_device = {
 		.owner	= THIS_MODULE,
 		.name	= "ch341-uart",
 	},
-	.id_table         = id_table,
-	.usb_driver       = &ch341_driver,
-	.num_ports        = 1,
-	.open             = ch341_open,
-	.set_termios      = ch341_set_termios,
-	.attach           = ch341_attach,
+	.id_table          = id_table,
+	.usb_driver        = &ch341_driver,
+	/*
+	.num_interrupt_in  = 1,
+	.num_bulk_in       = 1,
+	.num_bulk_out      = 1,
+	*/
+	.num_ports         = 1,
+	.open              = ch341_open,
+	.close             = ch341_close,
+	.ioctl             = ch341_ioctl,
+	.set_termios       = ch341_set_termios,
+	.tiocmget          = ch341_tiocmget,
+	.tiocmset          = ch341_tiocmset,
+	.read_int_callback = ch341_read_int_callback,
+	.attach            = ch341_attach,
+	.shutdown          = ch341_shutdown,
 };
 
 static int __init ch341_init(void)

-- 
Tollef Fog Heen
UNIX is user friendly, it's just picky about who its friends are
