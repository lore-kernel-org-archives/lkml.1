Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbZEFRRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbZEFRRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756336AbZEFRRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:17:07 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33151 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZEFRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:17:06 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force writes
Date: Wed, 6 May 2009 19:17:09 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Jason Wessel <jason.wessel@windriver.com>, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1241575205-12199-6-git-send-email-jason.wessel@windriver.com> <Pine.LNX.4.44L0.0905061058230.3227-100000@iolanthe.rowland.org> <20090506164141.55c8978c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090506164141.55c8978c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905061917.09454.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. Mai 2009 17:41:41 schrieb Alan Cox:
> Stuff data into the chip and if need be maintain an internal buffer. One
> of the problems with the serial stuff is that the buffering algorithms
> you need to packetize serial streams without poor behaviour or overruns
> are non trivial and the USB serial layer doesn't provide anything
> remotely resembling sanity.

Something a bit a like this:

commit a02639fe7d3f9788263305cff0669eac91f54002
Author: Oliver Neukum <oneukum@linux-d698.(none)>
Date:   Wed May 6 19:14:30 2009 +0200

    terrible implementation of usb serial write buffering

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 3a09777..83acde4 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -801,8 +801,13 @@ kevent (struct work_struct *work)
 	if (test_bit(EVENT_DEV_WAKING, &dev->flags)) {
 		status = usb_autopm_get_interface(dev->intf);
 		clear_bit(EVENT_DEV_WAKING, &dev->flags);
-		if (!status)
+		if (!status) {
 			usb_autopm_put_interface(dev->intf);
+		} else {
+			dev_kfree_skb_any((struct sk_buff*)dev->deferred->context);
+			usb_free_urb(dev->deferred);
+			netif_start_queue(dev->net);
+		}
 	}
 	/* usb_clear_halt() needs a thread context */
 	if (test_bit (EVENT_TX_HALT, &dev->flags)) {
@@ -1351,12 +1356,13 @@ int usbnet_resume (struct usb_interface *intf)
 		clear_bit(EVENT_DEV_ASLEEP, &dev->flags);
 		spin_unlock_irq(&dev->txq.lock);
 		if (res) {
+			skb = (struct sk_buff *)res->context;
 			retval = usb_submit_urb(res, GFP_NOIO);
 			if (retval < 0) {
+				dev_kfree_skb_any(skb);
 				usb_free_urb(res);
 				netif_start_queue(dev->net);
 			} else {
-				skb = (struct sk_buff *)res->context;
 				dev->net->trans_start = jiffies;
 				__skb_queue_tail (&dev->txq, skb);
 				if (!(dev->txq.qlen >= TX_QLEN(dev)))
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 4cec990..31dcbf7 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -191,12 +191,14 @@ void usb_serial_generic_close(struct tty_struct *tty,
 	generic_cleanup(port);
 }
 
+#define UPPER_WRITE_LIMIT 4
 int usb_serial_generic_write(struct tty_struct *tty,
 	struct usb_serial_port *port, const unsigned char *buf, int count)
 {
 	struct usb_serial *serial = port->serial;
+	struct urb *write_urb;
 	int result;
-	unsigned char *data;
+	u8 *data;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -209,41 +211,66 @@ int usb_serial_generic_write(struct tty_struct *tty,
 	if (serial->num_bulk_out) {
 		unsigned long flags;
 		spin_lock_irqsave(&port->lock, flags);
-		if (port->write_urb_busy) {
+		if (port->writes_in_flight >= UPPER_WRITE_LIMIT) {
+			if (!port->reserve_buffer) {
+				spin_unlock_irqrestore(&port->lock, flags);
+				return 0;
+			}
+			count = (count > port->bulk_out_size - port->reserve_filled) ?
+					port->bulk_out_size - port->reserve_filled
+					: count;
+			memcpy(port->reserve_buffer + port->reserve_filled,
+				buf, count);
+			port->reserve_filled += count;
 			spin_unlock_irqrestore(&port->lock, flags);
-			dbg("%s - already writing", __func__);
-			return 0;
+			dbg("%s - hitting reserves %d bytes left",
+				__func__, port->bulk_out_size - port->reserve_filled);
+			return count;
+		} else {
+			count = (count > port->bulk_out_size) ?
+					port->bulk_out_size : count;		
+			write_urb = usb_alloc_urb(0, GFP_ATOMIC);
+			if (!write_urb) {
+				spin_unlock_irqrestore(&port->lock, flags);
+				return 0;
+			}
+			data = kmalloc(count, GFP_ATOMIC);
+			if (!data) {
+				usb_free_urb(write_urb);
+				spin_unlock_irqrestore(&port->lock, flags);
+				return 0;
+			}
 		}
-		port->write_urb_busy = 1;
+		port->writes_in_flight++;
 		spin_unlock_irqrestore(&port->lock, flags);
 
-		count = (count > port->bulk_out_size) ?
-					port->bulk_out_size : count;
-
-		memcpy(port->write_urb->transfer_buffer, buf, count);
-		data = port->write_urb->transfer_buffer;
+		memcpy(data, buf, count);
+		write_urb->transfer_buffer = data;
 		usb_serial_debug_data(debug, &port->dev, __func__, count, data);
 
 		/* set up our urb */
-		usb_fill_bulk_urb(port->write_urb, serial->dev,
+		usb_fill_bulk_urb(write_urb, serial->dev,
 				   usb_sndbulkpipe(serial->dev,
 					port->bulk_out_endpointAddress),
-				   port->write_urb->transfer_buffer, count,
+				   data, count,
 				   ((serial->type->write_bulk_callback) ?
 				     serial->type->write_bulk_callback :
 				     usb_serial_generic_write_bulk_callback),
 				   port);
 
 		/* send the data out the bulk port */
-		port->write_urb_busy = 1;
-		result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
+		result = usb_submit_urb(write_urb, GFP_ATOMIC);
 		if (result) {
 			dev_err(&port->dev,
 				"%s - failed submitting write urb, error %d\n",
 							__func__, result);
 			/* don't have to grab the lock here, as we will
 			   retry if != 0 */
-			port->write_urb_busy = 0;
+			kfree(data);
+			usb_free_urb(write_urb);
+			spin_lock_irqsave(&port->lock, flags);
+			port->writes_in_flight--;
+			spin_unlock_irqrestore(&port->lock, flags);
 		} else
 			result = count;
 
@@ -264,7 +291,7 @@ int usb_serial_generic_write_room(struct tty_struct *tty)
 
 	/* FIXME: Locking */
 	if (serial->num_bulk_out) {
-		if (!(port->write_urb_busy))
+		if (port->writes_in_flight < UPPER_WRITE_LIMIT)
 			room = port->bulk_out_size;
 	}
 
@@ -282,8 +309,10 @@ int usb_serial_generic_chars_in_buffer(struct tty_struct 
*tty)
 
 	/* FIXME: Locking */
 	if (serial->num_bulk_out) {
-		if (port->write_urb_busy)
-			chars = port->write_urb->transfer_buffer_length;
+		if (port->writes_in_flight < UPPER_WRITE_LIMIT)
+			chars = port->bulk_out_size * UPPER_WRITE_LIMIT / 2;
+		else
+			chars = port->bulk_out_size * UPPER_WRITE_LIMIT;
 	}
 
 	dbg("%s - returns %d", __func__, chars);
@@ -369,7 +398,12 @@ void usb_serial_generic_write_bulk_callback(struct urb 
*urb)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	port->write_urb_busy = 0;
+	kfree(urb->transfer_buffer);
+	spin_lock(&port->lock);
+	if (!port->reserve_filled || status)
+		port->writes_in_flight--;
+	spin_unlock(&port->lock);
+
 	if (status) {
 		dbg("%s - nonzero write bulk status received: %d",
 		    __func__, status);
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 0a566ee..33d6ea4 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -519,10 +519,49 @@ static void usb_serial_port_work(struct work_struct 
*work)
 {
 	struct usb_serial_port *port =
 		container_of(work, struct usb_serial_port, work);
+	struct usb_serial *serial = port->serial;
+	struct urb *urb;
 	struct tty_struct *tty;
+	u8 *new_reserve;
+	int err;
+	unsigned long flags;
 
 	dbg("%s - port %d", __func__, port->number);
 
+	if (port->reserve_filled) {
+		/*
+		 * this cannot be done any later and here we can sleep
+		 * to allocate memory
+		 */
+		new_reserve = kmalloc(port->bulk_out_size, GFP_KERNEL);
+		urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (!new_reserve || !urb) {
+			/* now we drop data */
+			kfree(new_reserve);
+failure:
+			usb_free_urb(urb);
+			spin_lock_irqsave(&port->lock, flags);
+			port->writes_in_flight--;
+			port->reserve_filled = 0;
+			spin_unlock_irqrestore(&port->lock, flags);
+			goto bail_buffer_exhaustion;
+		}
+		urb->transfer_buffer = port->reserve_buffer;
+		usb_fill_bulk_urb(urb, serial->dev,
+				   usb_rcvbulkpipe(serial->dev,
+						port->bulk_in_endpointAddress),
+				   port->reserve_buffer,
+				   port->reserve_filled,
+				   usb_serial_generic_write_bulk_callback,
+				   port);
+		port->reserve_buffer = new_reserve;
+		err = usb_submit_urb(urb, GFP_KERNEL);
+		if (err < 0)
+			goto failure;
+		port->reserve_filled = 0;
+	}
+
+bail_buffer_exhaustion:
 	tty = tty_port_tty_get(&port->port);
 	if (!tty)
 		return;
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 625e9e4..4e0afed 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -88,7 +88,9 @@ struct usb_serial_port {
 	unsigned char		*bulk_out_buffer;
 	int			bulk_out_size;
 	struct urb		*write_urb;
-	int			write_urb_busy;
+	int			writes_in_flight;
+	int			reserve_filled;
+	u8			*reserve_buffer;
 	__u8			bulk_out_endpointAddress;
 
 	wait_queue_head_t	write_wait;

Just for discussion.

	Regards
		Oliver

