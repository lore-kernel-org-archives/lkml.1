Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbZJBQca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbZJBQca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZJBQc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:32:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34287 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755584AbZJBQc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:32:28 -0400
Date: Fri, 2 Oct 2009 17:33:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Johan Hovold <jhovold@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20091002173308.6158d734@lxorguk.ukuu.org.uk>
In-Reply-To: <20091002084755.GA7382@localhost>
References: <20090924154023.GA27480@localhost>
	<200909242103.48562.oliver@neukum.org>
	<20090924202107.4730f2af@lxorguk.ukuu.org.uk>
	<20090924211459.GB27963@localhost>
	<4ABD020B.4040901@gandalf.sssup.it>
	<20090929145514.GF2152@localhost>
	<20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
	<m163ayzevu.fsf@fess.ebiederm.org>
	<20091002084755.GA7382@localhost>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan, did you have time to look at it? Are there any reasons for wanting
> to keep low_latency in ftdi_sio when it was removed from all other
> drivers processing in interrupt context (without doing work queue
> re-implementations)?

Yes for latency handling (two layers of work queue is bad) but its the
right fix for stable.

For upstream how does this look as a tidy up
ftdi_sio: simplify driver

From: Alan Cox <alan@linux.intel.com>

This does a lot of stuff that the modern buffering logic will cover itself
so remove the cruft.

- Remove the code handling throttle half way through a packet. We have 64K
  of slack and flow control is async anyway so stopping is the wrong thing
  to do
- Remove various commented out bits
- Without the partial packet stuff we can remove the async queue stuff and
  split it into sensible functions for URB processing and for queueing urbs
  for receipt
- Remove the unused rx_bytes count. We take locks for it, we jump through
  hoops for it and we never expose it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/serial/ftdi_sio.c |  199 +++++++++++------------------------------
 1 files changed, 51 insertions(+), 148 deletions(-)


diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 4f883b1..f796b07 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -78,10 +78,7 @@ struct ftdi_private {
 	char prev_status, diff_status;        /* Used for TIOCMIWAIT */
 	__u8 rx_flags;		/* receive state flags (throttling) */
 	spinlock_t rx_lock;	/* spinlock for receive state */
-	struct delayed_work rx_work;
 	struct usb_serial_port *port;
-	int rx_processed;
-	unsigned long rx_bytes;
 
 	__u16 interface;	/* FT2232C, FT2232H or FT4232H port interface
 				   (0 for FT232/245) */
@@ -763,7 +760,8 @@ static int  ftdi_write_room(struct tty_struct *tty);
 static int  ftdi_chars_in_buffer(struct tty_struct *tty);
 static void ftdi_write_bulk_callback(struct urb *urb);
 static void ftdi_read_bulk_callback(struct urb *urb);
-static void ftdi_process_read(struct work_struct *work);
+static void ftdi_process_read(struct ftdi_private *priv,
+						struct tty_struct *tty);
 static void ftdi_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
 static int  ftdi_tiocmget(struct tty_struct *tty, struct file *file);
@@ -1549,7 +1547,6 @@ static int ftdi_sio_port_probe(struct usb_serial_port *port)
 		port->read_urb->transfer_buffer_length = BUFSZ;
 	}
 
-	INIT_DELAYED_WORK(&priv->rx_work, ftdi_process_read);
 	priv->port = port;
 
 	/* Free port's existing write urb and transfer buffer. */
@@ -1700,9 +1697,6 @@ static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
 	spin_lock_irqsave(&priv->tx_lock, flags);
 	priv->tx_bytes = 0;
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
-	spin_lock_irqsave(&priv->rx_lock, flags);
-	priv->rx_bytes = 0;
-	spin_unlock_irqrestore(&priv->rx_lock, flags);
 
 	if (tty)
 		tty->low_latency = (priv->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
@@ -1730,7 +1724,6 @@ static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
 	spin_unlock_irqrestore(&priv->rx_lock, flags);
 
 	/* Start reading from the device */
-	priv->rx_processed = 0;
 	usb_fill_bulk_urb(port->read_urb, dev,
 			usb_rcvbulkpipe(dev, port->bulk_in_endpointAddress),
 			port->read_urb->transfer_buffer,
@@ -1787,10 +1780,6 @@ static void ftdi_close(struct usb_serial_port *port)
 
 	dbg("%s", __func__);
 
-
-	/* cancel any scheduled reading */
-	cancel_delayed_work_sync(&priv->rx_work);
-
 	/* shutdown our bulk read */
 	usb_kill_urb(port->read_urb);
 	kref_put(&priv->kref, ftdi_sio_priv_release);
@@ -2019,7 +2008,6 @@ static void ftdi_read_bulk_callback(struct urb *urb)
 	struct tty_struct *tty;
 	struct ftdi_private *priv;
 	unsigned long countread;
-	unsigned long flags;
 	int status = urb->status;
 
 	if (urb->number_of_packets > 0) {
@@ -2036,94 +2024,88 @@ static void ftdi_read_bulk_callback(struct urb *urb)
 	if (port->port.count <= 0)
 		return;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty) {
-		dbg("%s - bad tty pointer - exiting", __func__);
+	if (status) {
+		/* This will happen at close every time so it is a dbg not an
+		   err */
+		dbg("(this is ok on close) nonzero read bulk status received: %d", status);
 		return;
 	}
 
 	priv = usb_get_serial_port_data(port);
 	if (!priv) {
 		dbg("%s - bad port private data pointer - exiting", __func__);
-		goto out;
+		return;
 	}
 
-	if (urb != port->read_urb)
-		dev_err(&port->dev, "%s - Not my urb!\n", __func__);
+	tty = tty_port_tty_get(&port->port);
+	if (!tty) {
+		dbg("%s - bad tty pointer - exiting", __func__);
+		return;
+	}
 
-	if (status) {
-		/* This will happen at close every time so it is a dbg not an
-		   err */
-		dbg("(this is ok on close) nonzero read bulk status received: %d", status);
-		goto out;
+
+	if (urb != port->read_urb) {
+		dev_err(&port->dev, "%s - Not my urb!\n", __func__);
+		return;
 	}
 
 	/* count data bytes, but not status bytes */
 	countread = urb->actual_length;
 	countread -= 2 * DIV_ROUND_UP(countread, priv->max_packet_size);
-	spin_lock_irqsave(&priv->rx_lock, flags);
-	priv->rx_bytes += countread;
-	spin_unlock_irqrestore(&priv->rx_lock, flags);
 
-	ftdi_process_read(&priv->rx_work.work);
-out:
+	ftdi_process_read(priv, tty);
 	tty_kref_put(tty);
 } /* ftdi_read_bulk_callback */
 
 
-static void ftdi_process_read(struct work_struct *work)
-{ /* ftdi_process_read */
-	struct ftdi_private *priv =
-		container_of(work, struct ftdi_private, rx_work.work);
+static void ftdi_repost_urb(struct ftdi_private *priv)
+{
+	struct usb_serial_port *port = priv->port;
+	int result;
+
+	/* if the port is closed or throttled stop trying to read */
+	if (port->port.count <= 0 || (priv->rx_flags & THROTTLED))
+		return;
+	/* Continue trying to always read  */
+	usb_fill_bulk_urb(port->read_urb, port->serial->dev,
+		usb_rcvbulkpipe(port->serial->dev,
+				port->bulk_in_endpointAddress),
+		port->read_urb->transfer_buffer,
+		port->read_urb->transfer_buffer_length,
+		ftdi_read_bulk_callback, port);
+
+	result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
+	if (result)
+		dev_err(&port->dev,
+			"%s - failed resubmitting read urb, error %d\n",
+				__func__, result);
+}
+
+static void ftdi_process_read(struct ftdi_private *priv, struct tty_struct *tty)
+{
 	struct usb_serial_port *port = priv->port;
 	struct urb *urb;
-	struct tty_struct *tty;
 	char error_flag;
 	unsigned char *data;
 
 	int i;
-	int result;
 	int need_flip;
 	int packet_offset;
-	unsigned long flags;
 
 	dbg("%s - port %d", __func__, port->number);
 
 	if (port->port.count <= 0)
 		return;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty) {
-		dbg("%s - bad tty pointer - exiting", __func__);
-		return;
-	}
-
-	priv = usb_get_serial_port_data(port);
-	if (!priv) {
-		dbg("%s - bad port private data pointer - exiting", __func__);
-		goto out;
-	}
-
 	urb = port->read_urb;
-	if (!urb) {
-		dbg("%s - bad read_urb pointer - exiting", __func__);
-		goto out;
-	}
-
 	data = urb->transfer_buffer;
 
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
+	/* The first two bytes of every read packet are status */
+	if (urb->actual_length > 2)
+		usb_serial_debug_data(debug, &port->dev, __func__,
+					urb->actual_length, data);
+	else
+		dbg("Status only: %03oo %03oo", data[0], data[1]);
 
 
 	/* TO DO -- check for hung up line and handle appropriately: */
@@ -2132,7 +2114,7 @@ static void ftdi_process_read(struct work_struct *work)
 	/* if CD is dropped and the line is not CLOCAL then we should hangup */
 
 	need_flip = 0;
-	for (packet_offset = priv->rx_processed;
+	for (packet_offset = 0;
 		packet_offset < urb->actual_length; packet_offset += priv->max_packet_size) {
 		int length;
 
@@ -2155,17 +2137,6 @@ static void ftdi_process_read(struct work_struct *work)
 			length = 0;
 		}
 
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
 		/* Handle errors and break */
 		error_flag = TTY_NORMAL;
 		/* Although the device uses a bitmask and hence can have
@@ -2203,79 +2174,11 @@ static void ftdi_process_read(struct work_struct *work)
 			need_flip = 1;
 		}
 
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
 	} /* "for(packet_offset=0..." */
 
-	/* Low latency */
 	if (need_flip)
 		tty_flip_buffer_push(tty);
-
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
-
-	/* urb is completely processed */
-	priv->rx_processed = 0;
-
-	/* if the port is closed stop trying to read */
-	if (port->port.count > 0) {
-		/* Continue trying to always read  */
-		usb_fill_bulk_urb(port->read_urb, port->serial->dev,
-			usb_rcvbulkpipe(port->serial->dev,
-					port->bulk_in_endpointAddress),
-			port->read_urb->transfer_buffer,
-			port->read_urb->transfer_buffer_length,
-			ftdi_read_bulk_callback, port);
-
-		result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
-		if (result)
-			dev_err(&port->dev,
-				"%s - failed resubmitting read urb, error %d\n",
-				__func__, result);
-	}
-out:
-	tty_kref_put(tty);
+	ftdi_repost_urb(priv);
 } /* ftdi_process_read */
 
 
@@ -2635,7 +2538,7 @@ static void ftdi_unthrottle(struct tty_struct *tty)
 	spin_unlock_irqrestore(&priv->rx_lock, flags);
 
 	if (actually_throttled)
-		schedule_delayed_work(&priv->rx_work, 0);
+		ftdi_repost_urb(priv);
 }
 
 static int __init ftdi_init(void)
