Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbZLXLoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbZLXLoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 06:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbZLXLnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 06:43:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49851 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390AbZLXLnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 06:43:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=isIzKsLyCwZ6JY5/QTiFitiC7PrgWmW7PITZrZoGl+IRwu4iARiXHEFE0fkrpg+n8L
         Kb8zzMKL4aBExtwcv8DKHnjqfX14YE11Mtdl8TqrhqICcILYnGeWR011TF1EAG0vwoIz
         9rscDcmSburZdB1ilfZB4phoUOBsCdgOJh/jU=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matti Aarnio <matti.aarnio@zmailer.org>,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3/5] USB: ftdi_sio: fix DMA buffers on stack
Date: Thu, 24 Dec 2009 12:42:09 +0100
Message-Id: <1261654931-31543-4-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6.rc4
In-Reply-To: <1261654931-31543-1-git-send-email-jhovold@gmail.com>
References: <1261654931-31543-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove unnecessary buffer allocations for zero-length transfers.

Reported-by: Matti Aarnio <matti.aarnio@zmailer.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c |   69 ++++++++++++++++-------------------------
 1 files changed, 27 insertions(+), 42 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 6d191fb..4b3f115 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -916,7 +916,6 @@ static int update_mctrl(struct usb_serial_port *port, unsigned int set,
 							unsigned int clear)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
-	char *buf;
 	unsigned urb_value;
 	int rv;
 
@@ -925,10 +924,6 @@ static int update_mctrl(struct usb_serial_port *port, unsigned int set,
 		return 0;	/* no change */
 	}
 
-	buf = kmalloc(1, GFP_NOIO);
-	if (!buf)
-		return -ENOMEM;
-
 	clear &= ~set;	/* 'set' takes precedence over 'clear' */
 	urb_value = 0;
 	if (clear & TIOCM_DTR)
@@ -944,9 +939,7 @@ static int update_mctrl(struct usb_serial_port *port, unsigned int set,
 			       FTDI_SIO_SET_MODEM_CTRL_REQUEST,
 			       FTDI_SIO_SET_MODEM_CTRL_REQUEST_TYPE,
 			       urb_value, priv->interface,
-			       buf, 0, WDR_TIMEOUT);
-
-	kfree(buf);
+			       NULL, 0, WDR_TIMEOUT);
 	if (rv < 0) {
 		dbg("%s Error from MODEM_CTRL urb: DTR %s, RTS %s",
 				__func__,
@@ -1105,16 +1098,11 @@ static __u32 get_ftdi_divisor(struct tty_struct *tty,
 static int change_speed(struct tty_struct *tty, struct usb_serial_port *port)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
-	char *buf;
 	__u16 urb_value;
 	__u16 urb_index;
 	__u32 urb_index_value;
 	int rv;
 
-	buf = kmalloc(1, GFP_NOIO);
-	if (!buf)
-		return -ENOMEM;
-
 	urb_index_value = get_ftdi_divisor(tty, port);
 	urb_value = (__u16)urb_index_value;
 	urb_index = (__u16)(urb_index_value >> 16);
@@ -1127,9 +1115,7 @@ static int change_speed(struct tty_struct *tty, struct usb_serial_port *port)
 			    FTDI_SIO_SET_BAUDRATE_REQUEST,
 			    FTDI_SIO_SET_BAUDRATE_REQUEST_TYPE,
 			    urb_value, urb_index,
-			    buf, 0, WDR_SHORT_TIMEOUT);
-
-	kfree(buf);
+			    NULL, 0, WDR_SHORT_TIMEOUT);
 	return rv;
 }
 
@@ -1137,7 +1123,6 @@ static int write_latency_timer(struct usb_serial_port *port)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	struct usb_device *udev = port->serial->dev;
-	char buf[1];
 	int rv = 0;
 	int l = priv->latency;
 
@@ -1151,8 +1136,7 @@ static int write_latency_timer(struct usb_serial_port *port)
 			     FTDI_SIO_SET_LATENCY_TIMER_REQUEST,
 			     FTDI_SIO_SET_LATENCY_TIMER_REQUEST_TYPE,
 			     l, priv->interface,
-			     buf, 0, WDR_TIMEOUT);
-
+			     NULL, 0, WDR_TIMEOUT);
 	if (rv < 0)
 		dev_err(&port->dev, "Unable to write latency timer: %i\n", rv);
 	return rv;
@@ -1426,7 +1410,6 @@ static ssize_t store_event_char(struct device *dev,
 	struct usb_serial_port *port = to_usb_serial_port(dev);
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	struct usb_device *udev = port->serial->dev;
-	char buf[1];
 	int v = simple_strtoul(valbuf, NULL, 10);
 	int rv = 0;
 
@@ -1437,8 +1420,7 @@ static ssize_t store_event_char(struct device *dev,
 			     FTDI_SIO_SET_EVENT_CHAR_REQUEST,
 			     FTDI_SIO_SET_EVENT_CHAR_REQUEST_TYPE,
 			     v, priv->interface,
-			     buf, 0, WDR_TIMEOUT);
-
+			     NULL, 0, WDR_TIMEOUT);
 	if (rv < 0) {
 		dbg("Unable to write event character: %i", rv);
 		return -EIO;
@@ -1617,7 +1599,6 @@ static int ftdi_NDI_device_setup(struct usb_serial *serial)
 	struct usb_device *udev = serial->dev;
 	int latency = ndi_latency_timer;
 	int rv = 0;
-	char buf[1];
 
 	if (latency == 0)
 		latency = 1;
@@ -1630,7 +1611,7 @@ static int ftdi_NDI_device_setup(struct usb_serial *serial)
 	rv = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				FTDI_SIO_SET_LATENCY_TIMER_REQUEST,
 				FTDI_SIO_SET_LATENCY_TIMER_REQUEST_TYPE,
-				latency, 0, buf, 0, WDR_TIMEOUT);
+				latency, 0, NULL, 0, WDR_TIMEOUT);
 	return 0;
 }
 
@@ -1718,9 +1699,7 @@ static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
 	struct usb_device *dev = port->serial->dev;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
-
 	int result = 0;
-	char buf[1]; /* Needed for the usb_control_msg I think */
 
 	dbg("%s", __func__);
 
@@ -1735,7 +1714,7 @@ static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
 	usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 			FTDI_SIO_RESET_REQUEST, FTDI_SIO_RESET_REQUEST_TYPE,
 			FTDI_SIO_RESET_SIO,
-			priv->interface, buf, 0, WDR_TIMEOUT);
+			priv->interface, NULL, 0, WDR_TIMEOUT);
 
 	/* Termios defaults are set by usb_serial_init. We don't change
 	   port->tty->termios - this would lose speed settings, etc.
@@ -1763,7 +1742,6 @@ static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
 static void ftdi_dtr_rts(struct usb_serial_port *port, int on)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
-	char buf[1];
 
 	mutex_lock(&port->serial->disc_mutex);
 	if (!port->serial->disconnected) {
@@ -1772,7 +1750,7 @@ static void ftdi_dtr_rts(struct usb_serial_port *port, int on)
 			    usb_sndctrlpipe(port->serial->dev, 0),
 			    FTDI_SIO_SET_FLOW_CTRL_REQUEST,
 			    FTDI_SIO_SET_FLOW_CTRL_REQUEST_TYPE,
-			    0, priv->interface, buf, 0,
+			    0, priv->interface, NULL, 0,
 			    WDR_TIMEOUT) < 0) {
 			    dev_err(&port->dev, "error from flowcontrol urb\n");
 		}
@@ -2141,7 +2119,6 @@ static void ftdi_break_ctl(struct tty_struct *tty, int break_state)
 	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	__u16 urb_value = 0;
-	char buf[1];
 
 	/* break_state = -1 to turn on break, and 0 to turn off break */
 	/* see drivers/char/tty_io.c to see it used */
@@ -2157,7 +2134,7 @@ static void ftdi_break_ctl(struct tty_struct *tty, int break_state)
 			FTDI_SIO_SET_DATA_REQUEST,
 			FTDI_SIO_SET_DATA_REQUEST_TYPE,
 			urb_value , priv->interface,
-			buf, 0, WDR_TIMEOUT) < 0) {
+			NULL, 0, WDR_TIMEOUT) < 0) {
 		dev_err(&port->dev, "%s FAILED to enable/disable break state "
 			"(state was %d)\n", __func__, break_state);
 	}
@@ -2181,7 +2158,6 @@ static void ftdi_set_termios(struct tty_struct *tty,
 	struct ktermios *termios = tty->termios;
 	unsigned int cflag = termios->c_cflag;
 	__u16 urb_value; /* will hold the new flags */
-	char buf[1]; /* Perhaps I should dynamically alloc this? */
 
 	/* Added for xon/xoff support */
 	unsigned int iflag = termios->c_iflag;
@@ -2247,7 +2223,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 			    FTDI_SIO_SET_DATA_REQUEST,
 			    FTDI_SIO_SET_DATA_REQUEST_TYPE,
 			    urb_value , priv->interface,
-			    buf, 0, WDR_SHORT_TIMEOUT) < 0) {
+			    NULL, 0, WDR_SHORT_TIMEOUT) < 0) {
 		dev_err(&port->dev, "%s FAILED to set "
 			"databits/stopbits/parity\n", __func__);
 	}
@@ -2259,7 +2235,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 				    FTDI_SIO_SET_FLOW_CTRL_REQUEST,
 				    FTDI_SIO_SET_FLOW_CTRL_REQUEST_TYPE,
 				    0, priv->interface,
-				    buf, 0, WDR_TIMEOUT) < 0) {
+				    NULL, 0, WDR_TIMEOUT) < 0) {
 			dev_err(&port->dev,
 				"%s error from disable flowcontrol urb\n",
 				__func__);
@@ -2285,7 +2261,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 				    FTDI_SIO_SET_FLOW_CTRL_REQUEST,
 				    FTDI_SIO_SET_FLOW_CTRL_REQUEST_TYPE,
 				    0 , (FTDI_SIO_RTS_CTS_HS | priv->interface),
-				    buf, 0, WDR_TIMEOUT) < 0) {
+				    NULL, 0, WDR_TIMEOUT) < 0) {
 			dev_err(&port->dev,
 				"urb failed to set to rts/cts flow control\n");
 		}
@@ -2317,7 +2293,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 					    FTDI_SIO_SET_FLOW_CTRL_REQUEST_TYPE,
 					    urb_value , (FTDI_SIO_XON_XOFF_HS
 							 | priv->interface),
-					    buf, 0, WDR_TIMEOUT) < 0) {
+					    NULL, 0, WDR_TIMEOUT) < 0) {
 				dev_err(&port->dev, "urb failed to set to "
 					"xon/xoff flow control\n");
 			}
@@ -2331,7 +2307,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 					    FTDI_SIO_SET_FLOW_CTRL_REQUEST,
 					    FTDI_SIO_SET_FLOW_CTRL_REQUEST_TYPE,
 					    0, priv->interface,
-					    buf, 0, WDR_TIMEOUT) < 0) {
+					    NULL, 0, WDR_TIMEOUT) < 0) {
 				dev_err(&port->dev,
 					"urb failed to clear flow control\n");
 			}
@@ -2345,10 +2321,15 @@ static int ftdi_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
-	unsigned char buf[2];
+	unsigned char *buf;
 	int ret;
 
 	dbg("%s TIOCMGET", __func__);
+
+	buf = kmalloc(2, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	switch (priv->chip_type) {
 	case SIO:
 		/* Request the status from the device */
@@ -2359,7 +2340,7 @@ static int ftdi_tiocmget(struct tty_struct *tty, struct file *file)
 			   0, 0,
 			   buf, 1, WDR_TIMEOUT);
 		if (ret < 0)
-			return ret;
+			goto out;
 		break;
 	case FT8U232AM:
 	case FT232BM:
@@ -2377,17 +2358,21 @@ static int ftdi_tiocmget(struct tty_struct *tty, struct file *file)
 				   0, priv->interface,
 				   buf, 2, WDR_TIMEOUT);
 		if (ret < 0)
-			return ret;
+			goto out;
 		break;
 	default:
-		return -EFAULT;
+		ret = -EFAULT;
+		goto out;
 	}
 
-	return  (buf[0] & FTDI_SIO_DSR_MASK ? TIOCM_DSR : 0) |
+	ret = (buf[0] & FTDI_SIO_DSR_MASK ? TIOCM_DSR : 0) |
 		(buf[0] & FTDI_SIO_CTS_MASK ? TIOCM_CTS : 0) |
 		(buf[0]  & FTDI_SIO_RI_MASK  ? TIOCM_RI  : 0) |
 		(buf[0]  & FTDI_SIO_RLSD_MASK ? TIOCM_CD  : 0) |
 		priv->last_dtr_rts;
+out:
+	kfree(buf);
+	return ret;
 }
 
 static int ftdi_tiocmset(struct tty_struct *tty, struct file *file,
-- 
1.6.6.rc4

