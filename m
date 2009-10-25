Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZJYRyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZJYRyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 13:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbZJYRyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 13:54:05 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:57168 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbZJYRx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 13:53:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=UL/gHtkofd7HOnItivJV/3HtmKPveM7AY+L/TTIKskjSx4muPzze9X+43TtS3ENQFi
         mVgOKEY58yutu1NcR0DVXMo/WIim17D7mkZdsmQt0O20KgN6Gbi+fabV/2GbyYPBdJGv
         PRQAsMDgFm1/y5I6jAIFg9cfmSPI4gFrXvyBM=
Message-Id: <20091025175328.305409387@gmail.com>
References: <20091025175057.270011110@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 25 Oct 2009 18:51:03 +0100
From: bart.hartgers@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bart Hartgers <bart.hartgers@gmail.com>
Subject: [PATCH 6/7] ark3116: (3rd try) Callbacks for interrupt and bulk read
Content-Disposition: inline; filename=0030_ark3116_callbacks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
---
Index: linux-2.6.32-rc4/drivers/usb/serial/ark3116.c
===================================================================
--- linux-2.6.32-rc4.orig/drivers/usb/serial/ark3116.c	2009-10-25 13:39:15.000000000 +0100
+++ linux-2.6.32-rc4/drivers/usb/serial/ark3116.c	2009-10-25 13:46:48.000000000 +0100
@@ -626,6 +626,190 @@ static void ark3116_break_ctl(struct tty
 	mutex_unlock(&priv->lock);
 }
 
+static void ark3116_update_msr(struct usb_serial_port *port, __u8 msr)
+{
+	struct ark3116_private *priv = usb_get_serial_port_data(port);
+
+	atomic_set(&priv->msr, msr);
+
+	if (msr & UART_MSR_ANY_DELTA) {
+		/* update input line counters */
+		if (msr & UART_MSR_DCTS)
+			priv->icount.cts++;
+		if (msr & UART_MSR_DDSR)
+			priv->icount.dsr++;
+		if (msr & UART_MSR_DDCD)
+			priv->icount.dcd++;
+		if (msr & UART_MSR_TERI)
+			priv->icount.rng++;
+		wake_up_interruptible(&priv->delta_msr_wait);
+	}
+}
+
+static void ark3116_combine_lsr(struct usb_serial_port *port, __u8 lsr)
+{
+	struct ark3116_private *priv = usb_get_serial_port_data(port);
+
+	/* combine bits */
+	ark3116_atomic_set_clear(lsr, 0, &priv->lsr);
+
+	if (lsr&UART_LSR_BRK_ERROR_BITS) {
+		if (lsr & UART_LSR_BI)
+			priv->icount.brk++;
+		if (lsr & UART_LSR_FE)
+			priv->icount.frame++;
+		if (lsr & UART_LSR_PE)
+			priv->icount.parity++;
+		if (lsr & UART_LSR_OE)
+			priv->icount.overrun++;
+	}
+}
+
+static void ark3116_read_int_callback(struct urb *urb)
+{
+	struct usb_serial_port *port = urb->context;
+	int status = urb->status;
+	const __u8 *data = urb->transfer_buffer;
+	int result;
+
+	switch (status) {
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		/* this urb is terminated, clean up */
+		dbg("%s - urb shutting down with status: %d",
+		    __func__, status);
+		return;
+	default:
+		dbg("%s - nonzero urb status received: %d",
+		    __func__, status);
+		break;
+	case 0: /* success */
+		/* discovered this by trail and error... */
+		if ((urb->actual_length == 4) && (data[0] == 0xe8)) {
+			const __u8 id = data[1]&UART_IIR_ID;
+			dbg("%s: iir=%02x", __func__, data[1]);
+			if (id == UART_IIR_MSI) {
+				dbg("%s: msr=%02x", __func__, data[3]);
+				ark3116_update_msr(port, data[3]);
+				break;
+			} else if (id == UART_IIR_RLSI) {
+				dbg("%s: lsr=%02x", __func__, data[2]);
+				ark3116_combine_lsr(port, data[2]);
+				break;
+			}
+		}
+		/*
+		 * Not sure what this data meant...
+		 */
+		usb_serial_debug_data(debug, &port->dev,
+				      __func__,
+				      urb->actual_length,
+				      urb->transfer_buffer);
+		break;
+	}
+
+	result = usb_submit_urb(urb, GFP_ATOMIC);
+	if (result)
+		dev_err(&urb->dev->dev,
+			"%s - Error %d submitting interrupt urb\n",
+			__func__, result);
+}
+
+
+/* Data comes in via the bulk (data) URB, erors/interrupts via the int URB.
+ * This means that we cannot be sure which data byte has an associated error
+ * condition, so we report an error for all data in the next bulk read.
+ *
+ * Actually, there might even be a window between the bulk data leaving the
+ * ark and reading/resetting the lsr in the read_bulk_callback where an
+ * interrupt for the next data block could come in.
+ * Without somekind of ordering on the ark, we would have to report the
+ * error for the next block of data as well...
+ * For now, let's pretend this can't happen.
+ */
+
+static void send_to_tty(struct tty_struct *tty,
+			const unsigned char *chars,
+			size_t size, char flag)
+{
+	if (size == 0)
+		return;
+	if (flag == TTY_NORMAL) {
+		tty_insert_flip_string(tty, chars, size);
+	} else {
+		int i;
+		for (i = 0; i < size; ++i)
+			tty_insert_flip_char(tty, chars[i], flag);
+	}
+}
+
+static void ark3116_read_bulk_callback(struct urb *urb)
+{
+	struct usb_serial_port *port =  urb->context;
+	struct ark3116_private *priv = usb_get_serial_port_data(port);
+	const __u8 *data = urb->transfer_buffer;
+	int status = urb->status;
+	struct tty_struct *tty;
+	unsigned long flags;
+	int result;
+	char flag;
+	__u8 lsr;
+
+	switch (status) {
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		/* this urb is terminated, clean up */
+		dbg("%s - urb shutting down with status: %d",
+		    __func__, status);
+		return;
+	default:
+		dbg("%s - nonzero urb status received: %d",
+		    __func__, status);
+		break;
+	case 0: /* success */
+
+		lsr = atomic_read(&priv->lsr);
+	   	/* clear error bits; works because update_lsr ors the bits */
+	   	atomic_sub( lsr & UART_LSR_BRK_ERROR_BITS, &priv->lsr);
+
+		if (unlikely(lsr & UART_LSR_BI))
+			flag = TTY_BREAK;
+		else if (unlikely(lsr & UART_LSR_PE))
+			flag = TTY_PARITY;
+		else if (unlikely(lsr & UART_LSR_FE))
+			flag = TTY_FRAME;
+		else
+			flag = TTY_NORMAL;
+
+		tty = tty_port_tty_get(&port->port);
+		if (tty) {
+			tty_buffer_request_room(tty, urb->actual_length + 1);
+			/* overrun is special, not associated with a char */
+			if (unlikely(lsr & UART_LSR_OE))
+				tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			send_to_tty(tty, data, urb->actual_length, flag);
+			tty_flip_buffer_push(tty);
+			tty_kref_put(tty);
+		}
+
+		/* Throttle the device if requested by tty */
+		spin_lock_irqsave(&port->lock, flags);
+		port->throttled = port->throttle_req;
+		if (port->throttled) {
+			spin_unlock_irqrestore(&port->lock, flags);
+			return;
+		} else
+			spin_unlock_irqrestore(&port->lock, flags);
+	}
+	/* Continue reading from device */
+	result = usb_submit_urb(urb, GFP_ATOMIC);
+	if (result)
+		dev_err(&urb->dev->dev, "%s - failed resubmitting"
+			" read urb, error %d\n", __func__, result);
+}
+
 static struct usb_driver ark3116_driver = {
 	.name =		"ark3116",
 	.probe =	usb_serial_probe,
@@ -652,6 +836,8 @@ static struct usb_serial_driver ark3116_
 	.open =			ark3116_open,
 	.close =		ark3116_close,
 	.break_ctl = 		ark3116_break_ctl,
+	.read_int_callback = 	ark3116_read_int_callback,
+	.read_bulk_callback =	ark3116_read_bulk_callback,
 };
 
 static int __init ark3116_init(void)

-- 
