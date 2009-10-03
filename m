Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZJCM2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZJCM2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 08:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZJCM2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 08:28:50 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:58358 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbZJCM2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 08:28:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k1WPclRK7nWvACcG/jDMM8mpw2WXcAKoDVbbuEu27d+XhoB/3QBAlkBU5+XYenj40/
         zkupN+7KfCCJPbSvFEfXwFccj+vvnEXvy9VIioCLIjBjoKLYc1TfJcCaz398k7N7zo4Z
         iwLOTlW89utbm9NsFJ+Fut4kqYAPHQ/Mqcn/Q=
Date: Sat, 3 Oct 2009 14:28:48 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Johan Hovold <jhovold@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20091003122848.GD605@localhost>
References: <20090924154023.GA27480@localhost>
 <20091002173308.6158d734@lxorguk.ukuu.org.uk>
 <20091003114229.GB605@localhost>
 <200910031411.41543.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910031411.41543.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 02:11:40PM +0200, Oliver Neukum wrote:
> This unfortunately is incorrect. If an unthrottling happens before the read
> callback runs you submit a running URB.

Duh. :) Here's an update that uses both throttle flags which is of
course required.

Thanks,
Johan


>From 41c00680e69b72bd8bd3650609b29ed5ec3f1dde Mon Sep 17 00:00:00 2001
From: Johan Hovold <jhovold@gmail.com>
Date: Sat, 3 Oct 2009 12:30:13 +0200
Subject: [PATCH] USB: ftdi_sio: Rewrite.

 - Remove work queue.
 - Use urb status to determine when port is closed rather than port
   count. (Fixes stalled reads due to open race on 2.6.31).
 - Re-structure read processing.
 - Use tty_insert_flip_string instead of per character push unless
   console.
 - Always process before throttling.
 - Handle late call to unthrottle during serial_close by checking
   ASYNCB_CLOSING.
 - Remove rx_flags and lock and use flags in usb_serial_port instead.
 - Remove unused rx_bytes counter.
---
 drivers/usb/serial/ftdi_sio.c |  427 ++++++++++++++---------------------------
 1 files changed, 144 insertions(+), 283 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 0ac2c2f..84c2b83 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -76,12 +76,7 @@ struct ftdi_private {
 	unsigned long last_dtr_rts;	/* saved modem control outputs */
 	wait_queue_head_t delta_msr_wait; /* Used for TIOCMIWAIT */
 	char prev_status, diff_status;        /* Used for TIOCMIWAIT */
-	__u8 rx_flags;		/* receive state flags (throttling) */
-	spinlock_t rx_lock;	/* spinlock for receive state */
-	struct delayed_work rx_work;
 	struct usb_serial_port *port;
-	int rx_processed;
-	unsigned long rx_bytes;
 
 	__u16 interface;	/* FT2232C, FT2232H or FT4232H port interface
 				   (0 for FT232/245) */
@@ -737,10 +732,6 @@ static const char *ftdi_chip_name[] = {
 /* Constants for read urb and write urb */
 #define BUFSZ 512
 
-/* rx_flags */
-#define THROTTLED		0x01
-#define ACTUALLY_THROTTLED	0x02
-
 /* Used for TIOCMIWAIT */
 #define FTDI_STATUS_B0_MASK	(FTDI_RS0_CTS | FTDI_RS0_DSR | FTDI_RS0_RI | FTDI_RS0_RLSD)
 #define FTDI_STATUS_B1_MASK	(FTDI_RS_BI)
@@ -763,7 +754,7 @@ static int  ftdi_write_room(struct tty_struct *tty);
 static int  ftdi_chars_in_buffer(struct tty_struct *tty);
 static void ftdi_write_bulk_callback(struct urb *urb);
 static void ftdi_read_bulk_callback(struct urb *urb);
-static void ftdi_process_read(struct work_struct *work);
+static void ftdi_process_read(struct usb_serial_port *port);
 static void ftdi_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
 static int  ftdi_tiocmget(struct tty_struct *tty, struct file *file);
@@ -1526,7 +1517,6 @@ static int ftdi_sio_port_probe(struct usb_serial_port *port)
 	}
 
 	kref_init(&priv->kref);
-	spin_lock_init(&priv->rx_lock);
 	spin_lock_init(&priv->tx_lock);
 	init_waitqueue_head(&priv->delta_msr_wait);
 	/* This will push the characters through immediately rather
@@ -1548,7 +1538,6 @@ static int ftdi_sio_port_probe(struct usb_serial_port *port)
 		port->read_urb->transfer_buffer_length = BUFSZ;
 	}
 
-	INIT_DELAYED_WORK(&priv->rx_work, ftdi_process_read);
 	priv->port = port;
 
 	/* Free port's existing write urb and transfer buffer. */
@@ -1685,6 +1674,26 @@ static int ftdi_sio_port_remove(struct usb_serial_port *port)
 	return 0;
 }
 
+int ftdi_submit_read_urb(struct usb_serial_port *port, gfp_t mem_flags)
+{
+	struct urb *urb = port->read_urb;
+	struct usb_serial *serial = port->serial;
+	int result;
+
+	usb_fill_bulk_urb(urb, serial->dev,
+			   usb_rcvbulkpipe(serial->dev,
+					port->bulk_in_endpointAddress),
+			   urb->transfer_buffer,
+			   urb->transfer_buffer_length,
+			   ftdi_read_bulk_callback, port);
+	result = usb_submit_urb(urb, mem_flags);
+	if (result)
+		dev_err(&port->dev,
+			"%s - failed submitting read urb, error %d\n",
+							__func__, result);
+	return result;
+}
+
 static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
 { /* ftdi_open */
 	struct usb_device *dev = port->serial->dev;
@@ -1699,9 +1708,6 @@ static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
 	spin_lock_irqsave(&priv->tx_lock, flags);
 	priv->tx_bytes = 0;
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
-	spin_lock_irqsave(&priv->rx_lock, flags);
-	priv->rx_bytes = 0;
-	spin_unlock_irqrestore(&priv->rx_lock, flags);
 
 	write_latency_timer(port);
 
@@ -1721,23 +1727,14 @@ static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
 		ftdi_set_termios(tty, port, tty->termios);
 
 	/* Not throttled */
-	spin_lock_irqsave(&priv->rx_lock, flags);
-	priv->rx_flags &= ~(THROTTLED | ACTUALLY_THROTTLED);
-	spin_unlock_irqrestore(&priv->rx_lock, flags);
+	spin_lock_irqsave(&port->lock, flags);
+	port->throttled = 0;
+	port->throttle_req = 0;
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	/* Start reading from the device */
-	priv->rx_processed = 0;
-	usb_fill_bulk_urb(port->read_urb, dev,
-			usb_rcvbulkpipe(dev, port->bulk_in_endpointAddress),
-			port->read_urb->transfer_buffer,
-				port->read_urb->transfer_buffer_length,
-			ftdi_read_bulk_callback, port);
-	result = usb_submit_urb(port->read_urb, GFP_KERNEL);
-	if (result)
-		dev_err(&port->dev,
-			"%s - failed submitting read urb, error %d\n",
-			__func__, result);
-	else
+	result = ftdi_submit_read_urb(port, GFP_KERNEL);
+	if (!result)
 		kref_get(&priv->kref);
 
 	return result;
@@ -1783,10 +1780,6 @@ static void ftdi_close(struct usb_serial_port *port)
 
 	dbg("%s", __func__);
 
-
-	/* cancel any scheduled reading */
-	cancel_delayed_work_sync(&priv->rx_work);
-
 	/* shutdown our bulk read */
 	usb_kill_urb(port->read_urb);
 	kref_put(&priv->kref, ftdi_sio_priv_release);
@@ -2009,271 +2002,142 @@ static int ftdi_chars_in_buffer(struct tty_struct *tty)
 	return buffered;
 }
 
-static void ftdi_read_bulk_callback(struct urb *urb)
+static void ftdi_process_packet(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ftdi_private *priv,
+		char *packet, int len)
 {
-	struct usb_serial_port *port = urb->context;
-	struct tty_struct *tty;
-	struct ftdi_private *priv;
-	unsigned long countread;
-	unsigned long flags;
-	int status = urb->status;
-
-	if (urb->number_of_packets > 0) {
-		dev_err(&port->dev, "%s transfer_buffer_length %d "
-			"actual_length %d number of packets %d\n", __func__,
-			urb->transfer_buffer_length,
-			urb->actual_length, urb->number_of_packets);
-		dev_err(&port->dev, "%s transfer_flags %x\n", __func__,
-			urb->transfer_flags);
-	}
+	int i;
+	char status;
+	char flag;
+	char *ch;
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (port->port.count <= 0)
-		return;
-
-	tty = tty_port_tty_get(&port->port);
-	if (!tty) {
-		dbg("%s - bad tty pointer - exiting", __func__);
-		return;
+	/* Compare new line status to the old one, signal if different/
+	   N.B. packet may be processed more than once, but differences
+	   are only processed once.  */
+	status = packet[0] & FTDI_STATUS_B0_MASK;
+	if (status != priv->prev_status) {
+		priv->diff_status |= status ^ priv->prev_status;
+		wake_up_interruptible(&priv->delta_msr_wait);
+		priv->prev_status = status;
 	}
 
-	priv = usb_get_serial_port_data(port);
-	if (!priv) {
-		dbg("%s - bad port private data pointer - exiting", __func__);
-		goto out;
+	/*
+	 * Although the device uses a bitmask and hence can have multiple
+	 * errors on a packet - the order here sets the priority the error is
+	 * returned to the tty layer.
+	 */
+	flag = TTY_NORMAL;
+	if (packet[1] & FTDI_RS_OE) {
+		flag = TTY_OVERRUN;
+		dbg("OVERRRUN error");
 	}
-
-	if (urb != port->read_urb)
-		dev_err(&port->dev, "%s - Not my urb!\n", __func__);
-
-	if (status) {
-		/* This will happen at close every time so it is a dbg not an
-		   err */
-		dbg("(this is ok on close) nonzero read bulk status received: %d", status);
-		goto out;
+	if (packet[1] & FTDI_RS_BI) {
+		flag = TTY_BREAK;
+		dbg("BREAK received");
+		usb_serial_handle_break(port);
+	}
+	if (packet[1] & FTDI_RS_PE) {
+		flag = TTY_PARITY;
+		dbg("PARITY error");
+	}
+	if (packet[1] & FTDI_RS_FE) {
+		flag = TTY_FRAME;
+		dbg("FRAMING error");
 	}
 
-	/* count data bytes, but not status bytes */
-	countread = urb->actual_length;
-	countread -= 2 * DIV_ROUND_UP(countread, priv->max_packet_size);
-	spin_lock_irqsave(&priv->rx_lock, flags);
-	priv->rx_bytes += countread;
-	spin_unlock_irqrestore(&priv->rx_lock, flags);
-
-	ftdi_process_read(&priv->rx_work.work);
-out:
-	tty_kref_put(tty);
-} /* ftdi_read_bulk_callback */
+	/*
+	 * The per character mucking around with sysrq path it too slow, so
+	 * shortcircuit it in the 99.9999999% of cases where the USB serial is
+	 * not a console anyway.
+	 */
+	ch = packet + 2;
+	len -= 2;
+	if (!port->console || !port->sysrq)
+		tty_insert_flip_string(tty, ch, len);
+	else {
+		/* Push data to tty */
+		for (i = 0; i < len; i++, ch++) {
+			if (!usb_serial_handle_sysrq_char(tty, port, *ch))
+				tty_insert_flip_char(tty, *ch, flag);
+		}
+	}
+}
 
 
-static void ftdi_process_read(struct work_struct *work)
-{ /* ftdi_process_read */
-	struct ftdi_private *priv =
-		container_of(work, struct ftdi_private, rx_work.work);
-	struct usb_serial_port *port = priv->port;
-	struct urb *urb;
+static void ftdi_process_read(struct usb_serial_port *port)
+{
+	struct urb *urb = port->read_urb;
 	struct tty_struct *tty;
-	char error_flag;
-	unsigned char *data;
-
+	struct ftdi_private *priv = usb_get_serial_port_data(port);
+	char *data = (char *)urb->transfer_buffer;
 	int i;
-	int result;
+	int len;
 	int need_flip;
-	int packet_offset;
-	unsigned long flags;
 
-	dbg("%s - port %d", __func__, port->number);
-
-	if (port->port.count <= 0)
-		return;
+	if (urb->actual_length <= 2)
+		return;		/* status only */
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty) {
-		dbg("%s - bad tty pointer - exiting", __func__);
+	tty =  tty_port_tty_get(&port->port);
+	if (!tty)
 		return;
-	}
 
-	priv = usb_get_serial_port_data(port);
-	if (!priv) {
-		dbg("%s - bad port private data pointer - exiting", __func__);
-		goto out;
-	}
-
-	urb = port->read_urb;
-	if (!urb) {
-		dbg("%s - bad read_urb pointer - exiting", __func__);
-		goto out;
-	}
-
-	data = urb->transfer_buffer;
-
-	if (priv->rx_processed) {
-		dbg("%s - already processed: %d bytes, %d remain", __func__,
-				priv->rx_processed,
-				urb->actual_length - priv->rx_processed);
-	} else {
-		/* The first two bytes of every read packet are status */
-		if (urb->actual_length > 2)
-			usb_serial_debug_data(debug, &port->dev, __func__,
-						urb->actual_length, data);
-		else
-			dbg("Status only: %03oo %03oo", data[0], data[1]);
-	}
-
-
-	/* TO DO -- check for hung up line and handle appropriately: */
-	/*   send hangup  */
-	/* See acm.c - you do a tty_hangup  - eg tty_hangup(tty) */
-	/* if CD is dropped and the line is not CLOCAL then we should hangup */
-
-	need_flip = 0;
-	for (packet_offset = priv->rx_processed;
-		packet_offset < urb->actual_length; packet_offset += priv->max_packet_size) {
-		int length;
-
-		/* Compare new line status to the old one, signal if different/
-		   N.B. packet may be processed more than once, but differences
-		   are only processed once.  */
-		char new_status = data[packet_offset + 0] &
-						FTDI_STATUS_B0_MASK;
-		if (new_status != priv->prev_status) {
-			priv->diff_status |=
-				new_status ^ priv->prev_status;
-			wake_up_interruptible(&priv->delta_msr_wait);
-			priv->prev_status = new_status;
-		}
+	/* FIXME: check priv? */
 
-		length = min_t(u32, priv->max_packet_size, urb->actual_length-packet_offset)-2;
-		if (length < 0) {
-			dev_err(&port->dev, "%s - bad packet length: %d\n",
-				__func__, length+2);
-			length = 0;
-		}
-
-		if (priv->rx_flags & THROTTLED) {
-			dbg("%s - throttled", __func__);
-			break;
-		}
-		if (tty_buffer_request_room(tty, length) < length) {
-			/* break out & wait for throttling/unthrottling to
-			   happen */
-			dbg("%s - receive room low", __func__);
-			break;
-		}
-
-		/* Handle errors and break */
-		error_flag = TTY_NORMAL;
-		/* Although the device uses a bitmask and hence can have
-		   multiple errors on a packet - the order here sets the
-		   priority the error is returned to the tty layer  */
-
-		if (data[packet_offset+1] & FTDI_RS_OE) {
-			error_flag = TTY_OVERRUN;
-			dbg("OVERRRUN error");
-		}
-		if (data[packet_offset+1] & FTDI_RS_BI) {
-			error_flag = TTY_BREAK;
-			dbg("BREAK received");
-			usb_serial_handle_break(port);
-		}
-		if (data[packet_offset+1] & FTDI_RS_PE) {
-			error_flag = TTY_PARITY;
-			dbg("PARITY error");
-		}
-		if (data[packet_offset+1] & FTDI_RS_FE) {
-			error_flag = TTY_FRAME;
-			dbg("FRAMING error");
-		}
-		if (length > 0) {
-			for (i = 2; i < length+2; i++) {
-				/* Note that the error flag is duplicated for
-				   every character received since we don't know
-				   which character it applied to */
-				if (!usb_serial_handle_sysrq_char(tty, port,
-						data[packet_offset + i]))
-					tty_insert_flip_char(tty,
-						data[packet_offset + i],
-						error_flag);
-			}
+	for (i = 0; i < urb->actual_length; i += priv->max_packet_size) {
+		len = min_t(int, urb->actual_length - i, priv->max_packet_size);
+		if (len > 2) {
+			ftdi_process_packet(tty, port, priv, &data[i], len);
 			need_flip = 1;
 		}
+	}
 
-#ifdef NOT_CORRECT_BUT_KEEPING_IT_FOR_NOW
-		/* if a parity error is detected you get status packets forever
-		   until a character is sent without a parity error.
-		   This doesn't work well since the application receives a
-		   never ending stream of bad data - even though new data
-		   hasn't been sent. Therefore I (bill) have taken this out.
-		   However - this might make sense for framing errors and so on
-		   so I am leaving the code in for now.
-		*/
-		else {
-			if (error_flag != TTY_NORMAL) {
-				dbg("error_flag is not normal");
-				/* In this case it is just status - if that is
-				   an error send a bad character */
-				if (tty->flip.count >= TTY_FLIPBUF_SIZE)
-					tty_flip_buffer_push(tty);
-				tty_insert_flip_char(tty, 0xff, error_flag);
-				need_flip = 1;
-			}
-		}
-#endif
-	} /* "for(packet_offset=0..." */
-
-	/* Low latency */
 	if (need_flip)
 		tty_flip_buffer_push(tty);
+	tty_kref_put(tty);
+}
 
-	if (packet_offset < urb->actual_length) {
-		/* not completely processed - record progress */
-		priv->rx_processed = packet_offset;
-		dbg("%s - incomplete, %d bytes processed, %d remain",
-				__func__, packet_offset,
-				urb->actual_length - packet_offset);
-		/* check if we were throttled while processing */
-		spin_lock_irqsave(&priv->rx_lock, flags);
-		if (priv->rx_flags & THROTTLED) {
-			priv->rx_flags |= ACTUALLY_THROTTLED;
-			spin_unlock_irqrestore(&priv->rx_lock, flags);
-			dbg("%s - deferring remainder until unthrottled",
-					__func__);
-			goto out;
-		}
-		spin_unlock_irqrestore(&priv->rx_lock, flags);
-		/* if the port is closed stop trying to read */
-		if (port->port.count > 0)
-			/* delay processing of remainder */
-			schedule_delayed_work(&priv->rx_work, 1);
-		else
-			dbg("%s - port is closed", __func__);
-		goto out;
-	}
+static void ftdi_read_bulk_callback(struct urb *urb)
+{
+	struct usb_serial_port *port = urb->context;
+	unsigned char *data = urb->transfer_buffer;
+	int status = urb->status;
+	unsigned long flags;
 
-	/* urb is completely processed */
-	priv->rx_processed = 0;
+	dbg("%s - port %d", __func__, port->number);
 
-	/* if the port is closed stop trying to read */
-	if (port->port.count > 0) {
-		/* Continue trying to always read  */
-		usb_fill_bulk_urb(port->read_urb, port->serial->dev,
-			usb_rcvbulkpipe(port->serial->dev,
-					port->bulk_in_endpointAddress),
-			port->read_urb->transfer_buffer,
-			port->read_urb->transfer_buffer_length,
-			ftdi_read_bulk_callback, port);
+	/* FIXME: remove? */
+	if (urb->number_of_packets > 0) {
+		dev_err(&port->dev, "%s transfer_buffer_length %d "
+			"actual_length %d number of packets %d\n", __func__,
+			urb->transfer_buffer_length,
+			urb->actual_length, urb->number_of_packets);
+		dev_err(&port->dev, "%s transfer_flags %x\n", __func__,
+			urb->transfer_flags);
+	}
 
-		result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
-		if (result)
-			dev_err(&port->dev,
-				"%s - failed resubmitting read urb, error %d\n",
-				__func__, result);
+	if (unlikely(status != 0)) {
+		dbg("%s - nonzero read bulk status received: %d",
+		    __func__, status);
+		return;
 	}
-out:
-	tty_kref_put(tty);
-} /* ftdi_process_read */
 
+	/* FIXME: check urb != port->read_urb? */
+
+	usb_serial_debug_data(debug, &port->dev, __func__,
+						urb->actual_length, data);
+
+	ftdi_process_read(port);
+
+	spin_lock_irqsave(&port->lock, flags);
+	port->throttled = port->throttle_req;
+	if (!port->throttled) {
+		spin_unlock_irqrestore(&port->lock, flags);
+		ftdi_submit_read_urb(port, GFP_ATOMIC);
+	} else
+		spin_unlock_irqrestore(&port->lock, flags);
+}
 
 static void ftdi_break_ctl(struct tty_struct *tty, int break_state)
 {
@@ -2605,33 +2469,30 @@ static int ftdi_ioctl(struct tty_struct *tty, struct file *file,
 static void ftdi_throttle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 
 	dbg("%s - port %d", __func__, port->number);
 
-	spin_lock_irqsave(&priv->rx_lock, flags);
-	priv->rx_flags |= THROTTLED;
-	spin_unlock_irqrestore(&priv->rx_lock, flags);
+	spin_lock_irqsave(&port->lock, flags);
+	port->throttle_req = 1;
+	spin_unlock_irqrestore(&port->lock, flags);
 }
 
-
-static void ftdi_unthrottle(struct tty_struct *tty)
+void ftdi_unthrottle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct ftdi_private *priv = usb_get_serial_port_data(port);
-	int actually_throttled;
+	int was_throttled;
 	unsigned long flags;
 
 	dbg("%s - port %d", __func__, port->number);
 
-	spin_lock_irqsave(&priv->rx_lock, flags);
-	actually_throttled = priv->rx_flags & ACTUALLY_THROTTLED;
-	priv->rx_flags &= ~(THROTTLED | ACTUALLY_THROTTLED);
-	spin_unlock_irqrestore(&priv->rx_lock, flags);
+	spin_lock_irqsave(&port->lock, flags);
+	was_throttled = port->throttled;
+	port->throttled = port->throttle_req = 0;
+	spin_unlock_irqrestore(&port->lock, flags);
 
-	if (actually_throttled)
-		schedule_delayed_work(&priv->rx_work, 0);
+	if (was_throttled && !test_bit(ASYNCB_CLOSING, &port->port.flags))
+		ftdi_submit_read_urb(port, GFP_KERNEL);
 }
 
 static int __init ftdi_init(void)
-- 
1.6.4.2

