Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZISVnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZISVnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbZISVnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:43:39 -0400
Received: from kroah.org ([198.145.64.141]:40526 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbZISVn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:43:28 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 58/79] tty: USB serial termios bits
Date: Sat, 19 Sep 2009 14:37:03 -0700
Message-Id: <1253396244-7885-58-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Various drivers have hacks to mangle termios structures. This stems from
the fact there is no nice setup hook for configuring the termios settings
when the port is created

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_io.c            |    1 +
 drivers/usb/serial/ark3116.c     |   46 +++++++++----------------------------
 drivers/usb/serial/cypress_m8.c  |   12 ++-------
 drivers/usb/serial/empeg.c       |   12 ++-------
 drivers/usb/serial/iuu_phoenix.c |   31 +++++++++++--------------
 drivers/usb/serial/kobil_sct.c   |   22 +++++++++---------
 drivers/usb/serial/oti6858.c     |   21 ++++++++---------
 drivers/usb/serial/spcp8x5.c     |   21 ++++++++---------
 drivers/usb/serial/usb-serial.c  |   38 ++++++++++++++++++++++++++++++-
 drivers/usb/serial/whiteheat.c   |    6 ++--
 include/linux/usb/serial.h       |    3 ++
 11 files changed, 106 insertions(+), 107 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 385cca7..05f443c 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1184,6 +1184,7 @@ int tty_init_termios(struct tty_struct *tty)
 	tty->termios->c_ospeed = tty_termios_baud_rate(tty->termios);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(tty_init_termios);
 
 /**
  *	tty_driver_install_tty() - install a tty entry in the driver
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index 7ddde4d..5d25d3e 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -35,11 +35,6 @@ static struct usb_device_id id_table [] = {
 };
 MODULE_DEVICE_TABLE(usb, id_table);
 
-struct ark3116_private {
-	spinlock_t lock;
-	u8 termios_initialized;
-};
-
 static inline void ARK3116_SND(struct usb_serial *serial, int seq,
 			       __u8 request, __u8 requesttype,
 			       __u16 value, __u16 index)
@@ -82,22 +77,11 @@ static inline void ARK3116_RCV_QUIET(struct usb_serial *serial,
 static int ark3116_attach(struct usb_serial *serial)
 {
 	char *buf;
-	struct ark3116_private *priv;
-	int i;
-
-	for (i = 0; i < serial->num_ports; ++i) {
-		priv = kzalloc(sizeof(struct ark3116_private), GFP_KERNEL);
-		if (!priv)
-			goto cleanup;
-		spin_lock_init(&priv->lock);
-
-		usb_set_serial_port_data(serial->port[i], priv);
-	}
 
 	buf = kmalloc(1, GFP_KERNEL);
 	if (!buf) {
 		dbg("error kmalloc -> out of mem?");
-		goto cleanup;
+		return -ENOMEM;
 	}
 
 	/* 3 */
@@ -149,13 +133,16 @@ static int ark3116_attach(struct usb_serial *serial)
 
 	kfree(buf);
 	return 0;
+}
 
-cleanup:
-	for (--i; i >= 0; --i) {
-		kfree(usb_get_serial_port_data(serial->port[i]));
-		usb_set_serial_port_data(serial->port[i], NULL);
-	}
-	return -ENOMEM;
+static void ark3116_init_termios(struct tty_struct *tty)
+{
+	struct ktermios *termios = tty->termios;
+	*termios = tty_std_termios;
+	termios->c_cflag = B9600 | CS8
+				      | CREAD | HUPCL | CLOCAL;
+	termios->c_ispeed = 9600;
+	termios->c_ospeed = 9600;
 }
 
 static void ark3116_set_termios(struct tty_struct *tty,
@@ -163,10 +150,8 @@ static void ark3116_set_termios(struct tty_struct *tty,
 				struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
-	struct ark3116_private *priv = usb_get_serial_port_data(port);
 	struct ktermios *termios = tty->termios;
 	unsigned int cflag = termios->c_cflag;
-	unsigned long flags;
 	int baud;
 	int ark3116_baud;
 	char *buf;
@@ -176,16 +161,6 @@ static void ark3116_set_termios(struct tty_struct *tty,
 
 	dbg("%s - port %d", __func__, port->number);
 
-	spin_lock_irqsave(&priv->lock, flags);
-	if (!priv->termios_initialized) {
-		*termios = tty_std_termios;
-		termios->c_cflag = B9600 | CS8
-					      | CREAD | HUPCL | CLOCAL;
-		termios->c_ispeed = 9600;
-		termios->c_ospeed = 9600;
-		priv->termios_initialized = 1;
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
 
 	cflag = termios->c_cflag;
 	termios->c_cflag &= ~(CMSPAR|CRTSCTS);
@@ -454,6 +429,7 @@ static struct usb_serial_driver ark3116_device = {
 	.num_ports =		1,
 	.attach =		ark3116_attach,
 	.set_termios =		ark3116_set_termios,
+	.init_termios =		ark3116_init_termios,
 	.ioctl =		ark3116_ioctl,
 	.tiocmget =		ark3116_tiocmget,
 	.open =			ark3116_open,
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index df1adb9..e0a8b71 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -657,15 +657,7 @@ static int cypress_open(struct tty_struct *tty, struct usb_serial_port *port)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Set termios */
-	result = cypress_write(tty, port, NULL, 0);
-
-	if (result) {
-		dev_err(&port->dev,
-			"%s - failed setting the control lines - error %d\n",
-							__func__, result);
-		return result;
-	} else
-		dbg("%s - success setting the control lines", __func__);
+	cypress_send(port);
 
 	if (tty)
 		cypress_set_termios(tty, port, &priv->tmp_termios);
@@ -1003,6 +995,8 @@ static void cypress_set_termios(struct tty_struct *tty,
 	dbg("%s - port %d", __func__, port->number);
 
 	spin_lock_irqsave(&priv->lock, flags);
+	/* We can't clean this one up as we don't know the device type
+	   early enough */
 	if (!priv->termios_initialized) {
 		if (priv->chiptype == CT_EARTHMATE) {
 			*(tty->termios) = tty_std_termios;
diff --git a/drivers/usb/serial/empeg.c b/drivers/usb/serial/empeg.c
index da559a7..33c9e9c 100644
--- a/drivers/usb/serial/empeg.c
+++ b/drivers/usb/serial/empeg.c
@@ -89,8 +89,7 @@ static int  empeg_chars_in_buffer(struct tty_struct *tty);
 static void empeg_throttle(struct tty_struct *tty);
 static void empeg_unthrottle(struct tty_struct *tty);
 static int  empeg_startup(struct usb_serial *serial);
-static void empeg_set_termios(struct tty_struct *tty,
-		struct usb_serial_port *port, struct ktermios *old_termios);
+static void empeg_init_termios(struct tty_struct *tty);
 static void empeg_write_bulk_callback(struct urb *urb);
 static void empeg_read_bulk_callback(struct urb *urb);
 
@@ -122,7 +121,7 @@ static struct usb_serial_driver empeg_device = {
 	.throttle =		empeg_throttle,
 	.unthrottle =		empeg_unthrottle,
 	.attach =		empeg_startup,
-	.set_termios =		empeg_set_termios,
+	.init_termios =		empeg_init_termios,
 	.write =		empeg_write,
 	.write_room =		empeg_write_room,
 	.chars_in_buffer =	empeg_chars_in_buffer,
@@ -148,9 +147,6 @@ static int empeg_open(struct tty_struct *tty,struct usb_serial_port *port)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	/* Force default termio settings */
-	empeg_set_termios(tty, port, NULL);
-
 	bytes_in = 0;
 	bytes_out = 0;
 
@@ -423,11 +419,9 @@ static int  empeg_startup(struct usb_serial *serial)
 }
 
 
-static void empeg_set_termios(struct tty_struct *tty,
-		struct usb_serial_port *port, struct ktermios *old_termios)
+static void empeg_init_termios(struct tty_struct *tty)
 {
 	struct ktermios *termios = tty->termios;
-	dbg("%s - port %d", __func__, port->number);
 
 	/*
 	 * The empeg-car player wants these particular tty settings.
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index f3f9be0..6138c1c 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -71,7 +71,6 @@ struct iuu_private {
 	spinlock_t lock;	/* store irq state */
 	wait_queue_head_t delta_msr_wait;
 	u8 line_status;
-	u8 termios_initialized;
 	int tiostatus;		/* store IUART SIGNAL for tiocmget call */
 	u8 reset;		/* if 1 reset is needed */
 	int poll;		/* number of poll */
@@ -1018,13 +1017,24 @@ static void iuu_close(struct usb_serial_port *port)
 	}
 }
 
+static void iuu_init_termios(struct tty_struct *tty)
+{
+	*(tty->termios) = tty_std_termios;
+	tty->termios->c_cflag = CLOCAL | CREAD | CS8 | B9600
+				| TIOCM_CTS | CSTOPB | PARENB;
+	tty->termios->c_ispeed = 9600;
+	tty->termios->c_ospeed = 9600;
+	tty->termios->c_lflag = 0;
+	tty->termios->c_oflag = 0;
+	tty->termios->c_iflag = 0;
+}
+
 static int iuu_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
 	u8 *buf;
 	int result;
 	u32 actual;
-	unsigned long flags;
 	struct iuu_private *priv = usb_get_serial_port_data(port);
 
 	dbg("%s -  port %d", __func__, port->number);
@@ -1063,21 +1073,7 @@ static int iuu_open(struct tty_struct *tty, struct usb_serial_port *port)
 			  port->bulk_in_buffer, 512,
 			  NULL, NULL);
 
-	/* set the termios structure */
-	spin_lock_irqsave(&priv->lock, flags);
-	if (tty && !priv->termios_initialized) {
-		*(tty->termios) = tty_std_termios;
-		tty->termios->c_cflag = CLOCAL | CREAD | CS8 | B9600
-					| TIOCM_CTS | CSTOPB | PARENB;
-		tty->termios->c_ispeed = 9600;
-		tty->termios->c_ospeed = 9600;
-		tty->termios->c_lflag = 0;
-		tty->termios->c_oflag = 0;
-		tty->termios->c_iflag = 0;
-		priv->termios_initialized = 1;
-		priv->poll = 0;
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
+	priv->poll = 0;
 
 	/* initialize writebuf */
 #define FISH(a, b, c, d) do { \
@@ -1200,6 +1196,7 @@ static struct usb_serial_driver iuu_device = {
 	.tiocmget = iuu_tiocmget,
 	.tiocmset = iuu_tiocmset,
 	.set_termios = iuu_set_termios,
+	.init_termios = iuu_init_termios,
 	.attach = iuu_startup,
 	.release = iuu_release,
 };
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 9790157..45ea694 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -84,7 +84,7 @@ static void kobil_read_int_callback(struct urb *urb);
 static void kobil_write_callback(struct urb *purb);
 static void kobil_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
-
+static void kobil_init_termios(struct tty_struct *tty);
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(KOBIL_VENDOR_ID, KOBIL_ADAPTER_B_PRODUCT_ID) },
@@ -119,6 +119,7 @@ static struct usb_serial_driver kobil_device = {
 	.release =		kobil_release,
 	.ioctl =		kobil_ioctl,
 	.set_termios =		kobil_set_termios,
+	.init_termios =		kobil_init_termios,
 	.tiocmget =		kobil_tiocmget,
 	.tiocmset =		kobil_tiocmset,
 	.open =			kobil_open,
@@ -209,6 +210,15 @@ static void kobil_release(struct usb_serial *serial)
 		kfree(usb_get_serial_port_data(serial->port[i]));
 }
 
+static void kobil_init_termios(struct tty_struct *tty)
+{
+	/* Default to echo off and other sane device settings */
+	tty->termios->c_lflag = 0;
+	tty->termios->c_lflag &= ~(ISIG | ICANON | ECHO | IEXTEN | XCASE);
+	tty->termios->c_iflag = IGNBRK | IGNPAR | IXOFF;
+	/* do NOT translate CR to CR-NL (0x0A -> 0x0A 0x0D) */
+	tty->termios->c_oflag &= ~ONLCR;
+}
 
 static int kobil_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
@@ -224,16 +234,6 @@ static int kobil_open(struct tty_struct *tty, struct usb_serial_port *port)
 	/* someone sets the dev to 0 if the close method has been called */
 	port->interrupt_in_urb->dev = port->serial->dev;
 
-	if (tty) {
-
-		/* Default to echo off and other sane device settings */
-		tty->termios->c_lflag = 0;
-		tty->termios->c_lflag &= ~(ISIG | ICANON | ECHO | IEXTEN |
-								 XCASE);
-		tty->termios->c_iflag = IGNBRK | IGNPAR | IXOFF;
-		/* do NOT translate CR to CR-NL (0x0A -> 0x0A 0x0D) */
-		tty->termios->c_oflag &= ~ONLCR;
-	}
 	/* allocate memory for transfer buffer */
 	transfer_buffer = kzalloc(transfer_buffer_length, GFP_KERNEL);
 	if (!transfer_buffer)
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index e90f88a..0f4a70c 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -145,6 +145,7 @@ static int oti6858_open(struct tty_struct *tty, struct usb_serial_port *port);
 static void oti6858_close(struct usb_serial_port *port);
 static void oti6858_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
+static void oti6858_init_termios(struct tty_struct *tty);
 static int oti6858_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 static void oti6858_read_int_callback(struct urb *urb);
@@ -185,6 +186,7 @@ static struct usb_serial_driver oti6858_device = {
 	.write =		oti6858_write,
 	.ioctl =		oti6858_ioctl,
 	.set_termios =		oti6858_set_termios,
+	.init_termios = 	oti6858_init_termios,
 	.tiocmget =		oti6858_tiocmget,
 	.tiocmset =		oti6858_tiocmset,
 	.read_bulk_callback =	oti6858_read_bulk_callback,
@@ -205,7 +207,6 @@ struct oti6858_private {
 	struct {
 		u8 read_urb_in_use;
 		u8 write_urb_in_use;
-		u8 termios_initialized;
 	} flags;
 	struct delayed_work delayed_write_work;
 
@@ -446,6 +447,14 @@ static int oti6858_chars_in_buffer(struct tty_struct *tty)
 	return chars;
 }
 
+static void oti6858_init_termios(struct tty_struct *tty)
+{
+	*(tty->termios) = tty_std_termios;
+	tty->termios->c_cflag = B38400 | CS8 | CREAD | HUPCL | CLOCAL;
+	tty->termios->c_ispeed = 38400;
+	tty->termios->c_ospeed = 38400;
+}
+
 static void oti6858_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
@@ -463,16 +472,6 @@ static void oti6858_set_termios(struct tty_struct *tty,
 		return;
 	}
 
-	spin_lock_irqsave(&priv->lock, flags);
-	if (!priv->flags.termios_initialized) {
-		*(tty->termios) = tty_std_termios;
-		tty->termios->c_cflag = B38400 | CS8 | CREAD | HUPCL | CLOCAL;
-		tty->termios->c_ispeed = 38400;
-		tty->termios->c_ospeed = 38400;
-		priv->flags.termios_initialized = 1;
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	cflag = tty->termios->c_cflag;
 
 	spin_lock_irqsave(&priv->lock, flags);
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 8b312a0..61e7c40 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -299,7 +299,6 @@ struct spcp8x5_private {
 	wait_queue_head_t	delta_msr_wait;
 	u8 			line_control;
 	u8 			line_status;
-	u8 			termios_initialized;
 };
 
 /* desc : when device plug in,this function would be called.
@@ -498,6 +497,15 @@ static void spcp8x5_close(struct usb_serial_port *port)
 		dev_dbg(&port->dev, "usb_unlink_urb(read_urb) = %d\n", result);
 }
 
+static void spcp8x5_init_termios(struct tty_struct *tty)
+{
+	/* for the 1st time call this function */
+	*(tty->termios) = tty_std_termios;
+	tty->termios->c_cflag = B115200 | CS8 | CREAD | HUPCL | CLOCAL;
+	tty->termios->c_ispeed = 115200;
+	tty->termios->c_ospeed = 115200;
+}
+
 /* set the serial param for transfer. we should check if we really need to
  * transfer. if we set flow control we should do this too. */
 static void spcp8x5_set_termios(struct tty_struct *tty,
@@ -514,16 +522,6 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 	int i;
 	u8 control;
 
-	/* for the 1st time call this function */
-	spin_lock_irqsave(&priv->lock, flags);
-	if (!priv->termios_initialized) {
-		*(tty->termios) = tty_std_termios;
-		tty->termios->c_cflag = B115200 | CS8 | CREAD | HUPCL | CLOCAL;
-		tty->termios->c_ispeed = 115200;
-		tty->termios->c_ospeed = 115200;
-		priv->termios_initialized = 1;
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* check that they really want us to change something */
 	if (!tty_termios_hw_change(tty->termios, old_termios))
@@ -1008,6 +1006,7 @@ static struct usb_serial_driver spcp8x5_device = {
 	.carrier_raised		= spcp8x5_carrier_raised,
 	.write 			= spcp8x5_write,
 	.set_termios 		= spcp8x5_set_termios,
+	.init_termios		= spcp8x5_init_termios,
 	.ioctl 			= spcp8x5_ioctl,
 	.tiocmget 		= spcp8x5_tiocmget,
 	.tiocmset 		= spcp8x5_tiocmset,
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 3dda684..80c1f4d 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -721,6 +721,41 @@ static const struct tty_port_operations serial_port_ops = {
 	.dtr_rts = serial_dtr_rts,
 };
 
+/**
+ *	serial_install		-	install tty
+ *	@driver: the driver (USB in our case)
+ *	@tty: the tty being created
+ *
+ *	Create the termios objects for this tty. We use the default USB
+ *	serial ones but permit them to be overriddenby serial->type->termios.
+ *	This lets us remove all the ugly hackery
+ */
+
+static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	int idx = tty->index;
+	struct usb_serial *serial;
+	int retval;
+
+	/* If the termios setup has yet to be done */
+	if (tty->driver->termios[idx] == NULL) {
+		/* perform the standard setup */
+		retval = tty_init_termios(tty);
+		if (retval)
+			return retval;
+		/* allow the driver to update it */
+		serial = usb_serial_get_by_index(tty->index);
+		if (serial->type->init_termios)
+			serial->type->init_termios(tty);
+		usb_serial_put(serial);
+	}
+	/* Final install (we use the default method) */
+	tty_driver_kref_get(driver);
+	tty->count++;
+	driver->ttys[idx] = tty;
+	return 0;
+}
+
 int usb_serial_probe(struct usb_interface *interface,
 			       const struct usb_device_id *id)
 {
@@ -1228,7 +1263,8 @@ static const struct tty_operations serial_ops = {
 	.chars_in_buffer =	serial_chars_in_buffer,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
-	.shutdown =		serial_do_free,
+	.shutdown = 		serial_do_free,
+	.install = 		serial_install,
 	.proc_fops =		&serial_proc_fops,
 };
 
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 81f2ae5..62424ee 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -259,7 +259,7 @@ static int firm_send_command(struct usb_serial_port *port, __u8 command,
 						__u8 *data, __u8 datasize);
 static int firm_open(struct usb_serial_port *port);
 static int firm_close(struct usb_serial_port *port);
-static int firm_setup_port(struct tty_struct *tty);
+static void firm_setup_port(struct tty_struct *tty);
 static int firm_set_rts(struct usb_serial_port *port, __u8 onoff);
 static int firm_set_dtr(struct usb_serial_port *port, __u8 onoff);
 static int firm_set_break(struct usb_serial_port *port, __u8 onoff);
@@ -1210,7 +1210,7 @@ static int firm_close(struct usb_serial_port *port)
 }
 
 
-static int firm_setup_port(struct tty_struct *tty)
+static void firm_setup_port(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_port_settings port_settings;
@@ -1285,7 +1285,7 @@ static int firm_setup_port(struct tty_struct *tty)
 	port_settings.lloop = 0;
 
 	/* now send the message to the device */
-	return firm_send_command(port, WHITEHEAT_SETUP_PORT,
+	firm_send_command(port, WHITEHEAT_SETUP_PORT,
 			(__u8 *)&port_settings, sizeof(port_settings));
 }
 
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 1cbaf4a..7b85e32 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -260,6 +260,9 @@ struct usb_serial_driver {
 	   be an attached tty at this point */
 	void (*dtr_rts)(struct usb_serial_port *port, int on);
 	int  (*carrier_raised)(struct usb_serial_port *port);
+	/* Called by the usb serial hooks to allow the user to rework the
+	   termios state */
+	void (*init_termios)(struct tty_struct *tty);
 	/* USB events */
 	void (*read_int_callback)(struct urb *urb);
 	void (*write_int_callback)(struct urb *urb);
-- 
1.6.4.2

