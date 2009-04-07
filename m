Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbZDGAXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbZDGAXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 20:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZDGAWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 20:22:52 -0400
Received: from carmd-sa01.sierrawireless.com ([208.81.121.45]:49777 "EHLO
	carmd-sa01.sierrawireless.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbZDGAWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 20:22:49 -0400
X-ASG-Debug-ID: 1239062786-245f007b0000-xx1T2L
X-Barracuda-URL: http://carmd-sa01.sierrawireless.com:80/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: epasheva@sierrawireless.com
X-ASG-Orig-Subj: [PATCH 003/003] USB:  serial: sierra driver bug fixes in
	open/close and callbacks
Subject: [PATCH 003/003] USB:  serial: sierra driver bug fixes in
	open/close and callbacks
From: Elina <epasheva@sierrawireless.com>
To: <gregkh@suse.de>
CC: <rfiler@sierrawireless.com>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Date: Mon, 6 Apr 2009 17:06:02 -0700
Message-ID: <1239062762.10120.38.camel@Linuxdev3>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: UNKNOWN[10.0.6.5]
X-Barracuda-Start-Time: 1239062786
X-Barracuda-Encrypted: RC4-MD5
X-Barracuda-Virus-Scanned: by CARMD-SA01 at sierrawireless.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 003/003] USB:  serial: sierra driver bug fixes in 
open/close and callbacks
From: Elina Pasheva <epasheva@sierrawireless.com>

﻿The series of 3 patches modify sierra usb serial driver with
blacklisting of specific non-serial interfaces, bug fixing and
performance improvements. 
This is [PATCH 003/003]. This patch depends on [PATCH 002/003].
The following is summary of changes we have made to sierra.c driver in
[PATCH 003/003] dealing with bug fixes in open/close and callbacks:
- Fixed a problem in sierra_send_setup() for composite modems. Should
not be sending ACM commands to interfaces that are OBEX. Doing this
causes an apparent failure as the ACM command has to time out before the
interface can start being used
﻿- Fixed a problem in function sierra_indat_callback() which would stop
receiving traffic from a modem if a number of URB failures occur. Failed
URBs are not resubmitted for the next read and there is only a limited
number of URBs allocated for the IN path. After this number of failures,
the receive path stops working on a particular interface.
- Moved allocation of memory-based items to Open function from the
Startup function to conserve memory. This way, only interfaces that are
active will allocate and use the memory instead of all the memory being
allocated up front whether it would be needed or not
Signed-off-by: Elina Pasheva <epasheva@sierrawireless.com>
---

﻿drivers/usb/serial/sierra.c |  253 ++++++++++++++++++++--------------
1 file changed, 151 insertions(+), 102 deletions(-)

--- a/drivers/usb/serial/sierra.c	2009-03-27 16:26:23.000000000 -0700
+++ b/drivers/usb/serial/sierra.c	2009-03-27 16:52:44.000000000 -0700
@@ -71,7 +71,7 @@ static int sierra_set_power_state(struct
 static int sierra_vsc_set_nmea(struct usb_device *udev, __u16 enable)
 {
 	int result;
-	dev_dbg(&udev->dev, "%s", __func__);
+	dev_dbg(&udev->dev, "%s\n", __func__);
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			SWIMS_USB_REQUEST_SetNmea,	/* __u8 request      */
 			USB_TYPE_VENDOR,		/* __u8 request type */
@@ -124,7 +124,7 @@ static int sierra_calc_interface(struct 
 	int interface;
 	struct usb_interface *p_interface;
 	struct usb_host_interface *p_host_interface;
-	dev_dbg(&serial->dev->dev, "%s", __func__);
+	dev_dbg(&serial->dev->dev, "%s\n", __func__);
 
 	/* Get the interface structure pointer from the serial struct */
 	p_interface = serial->interface;
@@ -148,8 +148,8 @@ static int sierra_probe(struct usb_seria
 	u8 ifnum;
 
 	udev = serial->dev;
+	dev_dbg(&udev->dev, "%s\n", __func__);
 
-	/* Figure out the interface number from the serial structure */
 	ifnum = sierra_calc_interface(serial);
 	/*
 	 * If this interface supports more than 1 alternate
@@ -238,7 +238,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x0F3D, 0x0112) }, /* Airprime/Sierra PC 5220 */
 
 	{ USB_DEVICE(0x1199, 0x68A3), 	/* Sierra Wireless Direct IP modems */
-		.driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
 	{ }
 };
@@ -273,7 +273,6 @@ struct sierra_port_private {
 
 	/* Input endpoints and buffers for this port */
 	struct urb *in_urbs[N_IN_URB];
-	char *in_buffer[N_IN_URB];
 
 	/* Settings for the port */
 	int rts_state;	/* Handshaking pins (outputs) */
@@ -285,13 +284,13 @@ struct sierra_port_private {
 };
 
 static int sierra_send_setup(struct tty_struct *tty,
-						struct usb_serial_port *port)
+			struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
 	struct sierra_port_private *portdata;
 	__u16 interface = 0;
 
-	dev_dbg(&port->dev, "%s", __func__);
+	dev_dbg(&port->dev, "%s\n", __func__);
 
 	portdata = usb_get_serial_port_data(port);
 
@@ -303,8 +302,19 @@ static int sierra_send_setup(struct tty_
 			val |= 0x02;
 
 		/* If composite device then properly report interface */
-		if (serial->num_ports == 1)
+		if (serial->num_ports == 1) {
 			interface = sierra_calc_interface(serial);
+			/* Control message is send only to interfaces with
+			 * interrupt_in endpoints
+			 */
+			if (port->interrupt_in_urb) {
+				/* send control message */
+				return usb_control_msg(serial->dev,
+					usb_rcvctrlpipe(serial->dev, 0),
+					0x22, 0x21, val, interface,
+					NULL, 0, USB_CTRL_SET_TIMEOUT);
+			}
+		}
 
 		/* Otherwise the need to do non-composite mapping */
 		else {
@@ -314,12 +324,13 @@ static int sierra_send_setup(struct tty_
 				interface = 1;
 			else if (port->bulk_out_endpointAddress == 5)
 				interface = 2;
-		}
 
-		return usb_control_msg(serial->dev,
+			return usb_control_msg(serial->dev,
 				usb_rcvctrlpipe(serial->dev, 0),
 				0x22, 0x21, val, interface,
 				NULL, 0, USB_CTRL_SET_TIMEOUT);
+
+		}
 	}
 
 	return 0;
@@ -328,7 +339,7 @@ static int sierra_send_setup(struct tty_
 static void sierra_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
-	dev_dbg(&port->dev, "%s", __func__);
+	dev_dbg(&port->dev, "%s\n", __func__);
 	tty_termios_copy_hw(tty->termios, old_termios);
 	sierra_send_setup(tty, port);
 }
@@ -339,7 +350,7 @@ static int sierra_tiocmget(struct tty_st
 	unsigned int value;
 	struct sierra_port_private *portdata;
 
-	dev_dbg(&port->dev, "%s", __func__);
+	dev_dbg(&port->dev, "%s\n", __func__);
 	portdata = usb_get_serial_port_data(port);
 
 	value = ((portdata->rts_state) ? TIOCM_RTS : 0) |
@@ -371,6 +382,16 @@ static int sierra_tiocmset(struct tty_st
 		portdata->dtr_state = 0;
 	return sierra_send_setup(tty, port);
 }
+static void sierra_release_urb(struct urb *urb)
+{
+	struct usb_serial_port *port;
+	if (urb) {
+		port =  urb->context;
+		dev_dbg(&port->dev, "%s: %p\n", __func__, urb);
+		kfree(urb->transfer_buffer);
+		usb_free_urb(urb);
+	}
+}
 
 static void sierra_outdat_callback(struct urb *urb)
 {
@@ -379,17 +400,19 @@ static void sierra_outdat_callback(struc
 	int status = urb->status;
 	unsigned long flags;
 
-	dev_dbg(&port->dev, "%s - port %d", __func__, port->number);
+	dev_dbg(&port->dev, "%s - port %d\n", __func__, port->number);
 
 	/* free up the transfer buffer, as usb_free_urb() does not do this */
 	kfree(urb->transfer_buffer);
 
 	if (status)
 		dev_dbg(&port->dev, "%s - nonzero write bulk status "
-		    "received: %d", __func__, status);
+		    "received: %d\n", __func__, status);
 
 	spin_lock_irqsave(&portdata->lock, flags);
 	--portdata->outstanding_urbs;
+	dev_dbg(&port->dev, "%s - outstanding_urbs: %d\n", __func__,
+		portdata->outstanding_urbs);
 	spin_unlock_irqrestore(&portdata->lock, flags);
 
 	usb_serial_port_softint(port);
@@ -413,15 +436,19 @@ static int sierra_write(struct tty_struc
 
 	portdata = usb_get_serial_port_data(port);
 
-	dev_dbg(&port->dev, "%s: write (%d chars)", __func__, count);
+	dev_dbg(&port->dev, "%s: write (%d bytes)\n", __func__, writesize);
 
 	spin_lock_irqsave(&portdata->lock, flags);
+	dev_dbg(&port->dev, "%s - outstanding_urbs: %d\n", __func__,
+		portdata->outstanding_urbs);
 	if (portdata->outstanding_urbs > N_OUT_URB) {
 		spin_unlock_irqrestore(&portdata->lock, flags);
 		dev_dbg(&port->dev, "%s - write limit hit\n", __func__);
 		return 0;
 	}
 	portdata->outstanding_urbs++;
+	dev_dbg(&port->dev, "%s - 1, outstanding_urbs: %d\n", __func__,
+		portdata->outstanding_urbs);
 	spin_unlock_irqrestore(&portdata->lock, flags);
 
 	buffer = kmalloc(writesize, GFP_ATOMIC);
@@ -467,6 +494,8 @@ error_no_urb:
 error_no_buffer:
 	spin_lock_irqsave(&portdata->lock, flags);
 	--portdata->outstanding_urbs;
+	dev_dbg(&port->dev, "%s - 2. outstanding_urbs: %d\n", __func__,
+		portdata->outstanding_urbs);
 	spin_unlock_irqrestore(&portdata->lock, flags);
 	return retval;
 }
@@ -480,33 +509,41 @@ static void sierra_indat_callback(struct
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
 
-	dbg("%s: %p", __func__, urb);
-
 	endpoint = usb_pipeendpoint(urb->pipe);
 	port =  urb->context;
 
+	dev_dbg(&port->dev, "%s: %p\n", __func__, urb);
+
 	if (status) {
 		dev_dbg(&port->dev, "%s: nonzero status: %d on"
-		    " endpoint %02x.", __func__, status, endpoint);
+			" endpoint %02x\n", __func__, status, endpoint);
 	} else {
 		if (urb->actual_length) {
 			tty = tty_port_tty_get(&port->port);
+
 			tty_buffer_request_room(tty, urb->actual_length);
 			tty_insert_flip_string(tty, data, urb->actual_length);
 			tty_flip_buffer_push(tty);
+
 			tty_kref_put(tty);
-		} else
+			/* tty invalid after this point */
+			tty = NULL;
+			usb_serial_debug_data(debug, &port->dev, __func__,
+				urb->actual_length, data);
+		} else {
 			dev_dbg(&port->dev, "%s: empty read urb"
-				" received", __func__);
-
-		/* Resubmit urb so we continue receiving */
-		if (port->port.count && status != -ESHUTDOWN) {
-			err = usb_submit_urb(urb, GFP_ATOMIC);
-			if (err)
-				dev_err(&port->dev, "resubmit read urb failed."
-					"(%d)\n", err);
+				" received\n", __func__);
 		}
 	}
+
+	/* Resubmit urb so we continue receiving */
+	if (port->port.count && status != -ESHUTDOWN && status != -ENOENT) {
+		err = usb_submit_urb(urb, GFP_ATOMIC);
+		if (err)
+			dev_err(&port->dev, "resubmit read urb failed."
+				"(%d)\n", err);
+	}
+
 	return;
 }
 
@@ -518,8 +555,7 @@ static void sierra_instat_callback(struc
 	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
 	struct usb_serial *serial = port->serial;
 
-	dev_dbg(&port->dev, "%s", __func__);
-	dev_dbg(&port->dev, "%s: urb %p port %p has data %p", __func__,
+	dev_dbg(&port->dev, "%s: urb %p port %p has data %p\n", __func__,
 		urb, port, portdata);
 
 	if (status == 0) {
@@ -539,7 +575,7 @@ static void sierra_instat_callback(struc
 					sizeof(struct usb_ctrlrequest));
 			struct tty_struct *tty;
 
-			dev_dbg(&port->dev, "%s: signal x%x", __func__,
+			dev_dbg(&port->dev, "%s: signal x%x\n", __func__,
 				signals);
 
 			old_dcd_state = portdata->dcd_state;
@@ -554,20 +590,20 @@ static void sierra_instat_callback(struc
 				tty_hangup(tty);
 			tty_kref_put(tty);
 		} else {
-			dev_dbg(&port->dev, "%s: type %x req %x",
+			dev_dbg(&port->dev, "%s: type %x req %x\n",
 				__func__, req_pkt->bRequestType,
 				req_pkt->bRequest);
 		}
 	} else
-		dev_dbg(&port->dev, "%s: error %d", __func__, status);
+		dev_dbg(&port->dev, "%s: error %d\n", __func__, status);
 
 	/* Resubmit urb so we continue receiving IRQ data */
-	if (status != -ESHUTDOWN) {
+	if (port->port.count && status != -ESHUTDOWN) {
 		urb->dev = serial->dev;
 		err = usb_submit_urb(urb, GFP_ATOMIC);
 		if (err)
-			dev_dbg(&port->dev, "%s: resubmit intr urb "
-				"failed. (%d)",	__func__, err);
+			dev_err(&port->dev, "%s: resubmit intr urb "
+				"failed. (%d)\n", __func__, err);
 	}
 }
 
@@ -577,11 +613,13 @@ static int sierra_write_room(struct tty_
 	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
 	unsigned long flags;
 
-	dev_dbg(&port->dev, "%s - port %d", __func__, port->number);
+	dev_dbg(&port->dev, "%s - port %d\n", __func__, port->number);
 
 	/* try to give a good number back based on if we have any free urbs at
 	 * this point in time */
 	spin_lock_irqsave(&portdata->lock, flags);
+	dev_dbg(&port->dev, "%s - outstanding_urbs: %d\n", __func__,
+		portdata->outstanding_urbs);
 	if (portdata->outstanding_urbs > N_OUT_URB * 2 / 3) {
 		spin_unlock_irqrestore(&portdata->lock, flags);
 		dev_dbg(&port->dev, "%s - write limit hit\n", __func__);
@@ -592,33 +630,76 @@ static int sierra_write_room(struct tty_
 	return 2048;
 }
 
+
+static struct urb *sierra_setup_urb(struct usb_serial *serial, int endpoint,
+					int dir, void *ctx, int len,
+					usb_complete_t callback)
+{
+	struct urb	*urb;
+	u8		*buf;
+
+	if (endpoint == -1)
+		return NULL;
+
+	urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (urb == NULL) {
+		dev_dbg(&serial->dev->dev, "%s: alloc for endpoint %d failed\n",
+			__func__, endpoint);
+		return NULL;
+	}
+
+	buf = kmalloc(len, GFP_KERNEL);
+	if (buf) {
+		/* Fill URB using supplied data */
+		usb_fill_bulk_urb(urb, serial->dev,
+			usb_sndbulkpipe(serial->dev, endpoint) | dir,
+			buf, len, callback, ctx);
+
+		/* debug */
+		dev_dbg(&serial->dev->dev, "%s %c u:%p d:%p\n", __func__,
+				dir == USB_DIR_IN ? 'i' : 'o', urb, buf);
+	} else {
+		dev_dbg(&serial->dev->dev, "%s %c u:%p d:%p\n", __func__,
+				dir == USB_DIR_IN ? 'i' : 'o', urb, buf);
+
+		sierra_release_urb(urb);
+		urb = NULL;
+	}
+
+	return urb;
+}
 static int sierra_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp)
 {
 	struct sierra_port_private *portdata;
 	struct usb_serial *serial = port->serial;
-	int i;
+	int i, err;
 	struct urb *urb;
-	int result;
 
 	portdata = usb_get_serial_port_data(port);
 
-	dev_dbg(&port->dev, "%s", __func__);
+	dev_dbg(&port->dev, "%s\n", __func__);
 
 	/* Set some sane defaults */
 	portdata->rts_state = 1;
 	portdata->dtr_state = 1;
 
+	if (tty)
+		tty->low_latency = 1;
+
+	spin_lock_init(&portdata->lock);
+
 	/* Reset low level data toggle and start reading from endpoints */
 	for (i = 0; i < N_IN_URB; i++) {
-		urb = portdata->in_urbs[i];
+		urb = sierra_setup_urb(serial,
+					port->bulk_in_endpointAddress,
+					USB_DIR_IN,
+					port,
+					IN_BUFLEN,
+					sierra_indat_callback);
+		portdata->in_urbs[i] = urb;
 		if (!urb)
 			continue;
-		if (urb->dev != serial->dev) {
-			dev_dbg(&port->dev, "%s: dev %p != %p",
-				 __func__, urb->dev, serial->dev);
-			continue;
-		}
 
 		/*
 		 * make sure endpoint data toggle is synchronized with the
@@ -626,25 +707,27 @@ static int sierra_open(struct tty_struct
 		 */
 		usb_clear_halt(urb->dev, urb->pipe);
 
-		result = usb_submit_urb(urb, GFP_KERNEL);
-		if (result) {
-			dev_err(&port->dev, "submit urb %d failed (%d) %d\n",
-				i, result, urb->transfer_buffer_length);
+		err = usb_submit_urb(urb, GFP_KERNEL);
+		if (err) {
+			dev_err(&port->dev, "%s: submit urb %d failed
+				(%d) %d\n", __func__, i, err,
+				urb->transfer_buffer_length);
+			portdata->in_urbs[i] = NULL;
+			sierra_release_urb(urb);
 		}
 	}
 
-	if (tty)
-		tty->low_latency = 1;
+	/* Start up the interrupt endpoint if we have one */
+	if (port->interrupt_in_urb) {
+		port->interrupt_in_urb->dev = port->serial->dev;
+		err = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
+		if (err)
+			dev_err(&port->dev, "%s: submit irq_in urb failed %d\n",
+				__func__, err);
+	}
 
 	sierra_send_setup(tty, port);
 
-	/* start up the interrupt endpoint if we have one */
-	if (port->interrupt_in_urb) {
-		result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
-		if (result)
-			dev_err(&port->dev, "submit irq_in urb failed %d\n",
-				result);
-	}
 	return 0;
 }
 
@@ -655,7 +738,7 @@ static void sierra_close(struct tty_stru
 	struct usb_serial *serial = port->serial;
 	struct sierra_port_private *portdata;
 
-	dev_dbg(&port->dev, "%s", __func__);
+	dev_dbg(&port->dev, "%s\n", __func__);
 	portdata = usb_get_serial_port_data(port);
 
 	portdata->rts_state = 0;
@@ -668,23 +751,22 @@ static void sierra_close(struct tty_stru
 		mutex_unlock(&serial->disc_mutex);
 
 		/* Stop reading/writing urbs */
-		for (i = 0; i < N_IN_URB; i++)
+		for (i = 0; i < N_IN_URB; i++) {
 			usb_kill_urb(portdata->in_urbs[i]);
+			sierra_release_urb(portdata->in_urbs[i]);
+			portdata->in_urbs[i] = NULL;
+		}
 	}
-
 	usb_kill_urb(port->interrupt_in_urb);
-	tty_port_tty_set(&port->port, NULL);
 }
 
 static int sierra_startup(struct usb_serial *serial)
 {
 	struct usb_serial_port *port;
 	struct sierra_port_private *portdata;
-	struct urb *urb;
 	int i;
-	int j;
 
-	dev_dbg(&serial->dev->dev, "%s", __func__);
+	dev_dbg(&serial->dev->dev, "%s\n", __func__);
 
 	/* Set Device mode to D0 */
 	sierra_set_power_state(serial->dev, 0x0000);
@@ -699,39 +781,12 @@ static int sierra_startup(struct usb_ser
 		portdata = kzalloc(sizeof(*portdata), GFP_KERNEL);
 		if (!portdata) {
 			dev_dbg(&port->dev, "%s: kmalloc for "
-				"sierra_port_private (%d) failed!.",
+				"sierra_port_private (%d) failed!\n",
 				__func__, i);
 			return -ENOMEM;
 		}
-		spin_lock_init(&portdata->lock);
-		for (j = 0; j < N_IN_URB; j++) {
-			portdata->in_buffer[j] = kmalloc(IN_BUFLEN, GFP_KERNEL);
-			if (!portdata->in_buffer[j]) {
-				for (--j; j >= 0; j--)
-					kfree(portdata->in_buffer[j]);
-				kfree(portdata);
-				return -ENOMEM;
-			}
-		}
-
+		/* Set the port private data pointer */
 		usb_set_serial_port_data(port, portdata);
-
-		/* initialize the in urbs */
-		for (j = 0; j < N_IN_URB; ++j) {
-			urb = usb_alloc_urb(0, GFP_KERNEL);
-			if (urb == NULL) {
-				dev_dbg(&port->dev, "%s: alloc for in "
-					"port failed.", __func__);
-				continue;
-			}
-			/* Fill URB using supplied data. */
-			usb_fill_bulk_urb(urb, serial->dev,
-					  usb_rcvbulkpipe(serial->dev,
-						port->bulk_in_endpointAddress),
-					  portdata->in_buffer[j], IN_BUFLEN,
-					  sierra_indat_callback, port);
-			portdata->in_urbs[j] = urb;
-		}
 	}
 
 	return 0;
@@ -739,11 +794,11 @@ static int sierra_startup(struct usb_ser
 
 static void sierra_shutdown(struct usb_serial *serial)
 {
-	int i, j;
+	int i;
 	struct usb_serial_port *port;
 	struct sierra_port_private *portdata;
 
-	dev_dbg(&serial->dev->dev, "%s", __func__);
+	dev_dbg(&serial->dev->dev, "%s\n", __func__);
 
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
@@ -752,12 +807,6 @@ static void sierra_shutdown(struct usb_s
 		portdata = usb_get_serial_port_data(port);
 		if (!portdata)
 			continue;
-
-		for (j = 0; j < N_IN_URB; j++) {
-			usb_kill_urb(portdata->in_urbs[j]);
-			usb_free_urb(portdata->in_urbs[j]);
-			kfree(portdata->in_buffer[j]);
-		}
 		kfree(portdata);
 		usb_set_serial_port_data(port, NULL);
 	}


