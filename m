Return-Path: <linux-kernel-owner+w=401wt.eu-S1765153AbYFTUes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765153AbYFTUes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762078AbYFTUWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:22:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35229 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762055AbYFTUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:22:06 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 50/70] tty-usb-keyspan: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:04:39 +0100
Message-ID: <20080620200438.1479.39332.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>



Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/keyspan.c |  839 +++++++++++++++++++++---------------------
 1 files changed, 427 insertions(+), 412 deletions(-)


diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 823ea97..8c7dc40 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1,29 +1,29 @@
 /*
   Keyspan USB to Serial Converter driver
- 
+
   (C) Copyright (C) 2000-2001	Hugh Blemings <hugh@blemings.org>
   (C) Copyright (C) 2002	Greg Kroah-Hartman <greg@kroah.com>
-   
+
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
 
   See http://misc.nu/hugh/keyspan.html for more information.
-  
+
   Code in this driver inspired by and in a number of places taken
   from Brian Warner's original Keyspan-PDA driver.
 
   This driver has been put together with the support of Innosys, Inc.
   and Keyspan, Inc the manufacturers of the Keyspan USB-serial products.
   Thanks Guys :)
-  
+
   Thanks to Paulus for miscellaneous tidy ups, some largish chunks
   of much nicer and/or completely new code and (perhaps most uniquely)
   having the patience to sit down and explain why and where he'd changed
-  stuff. 
-  
-  Tip 'o the hat to IBM (and previously Linuxcare :) for supporting 
+  stuff.
+
+  Tip 'o the hat to IBM (and previously Linuxcare :) for supporting
   staff in their work on open source projects.
 
   Change History
@@ -70,21 +70,21 @@
 
     Thu May 31 11:56:42 PDT 2001 gkh
       switched from using spinlock to a semaphore
-   
+
     (04/08/2001) gb
 	Identify version on module load.
-   
+
     (11/01/2000) Adam J. Richter
 	usb_device_id table support.
-   
+
     Tue Oct 10 23:15:33 EST 2000 Hugh
       Merged Paul's changes with my USA-49W mods.  Work in progress
       still...
-  
+
     Wed Jul 19 14:00:42 EST 2000 gkh
       Added module_init and module_exit functions to handle the fact that
       this driver is a loadable module now.
- 
+
     Tue Jul 18 16:14:52 EST 2000 Hugh
       Basic character input/output for USA-19 now mostly works,
       fixed at 9600 baud for the moment.
@@ -105,7 +105,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include "keyspan.h"
@@ -130,15 +130,15 @@ struct keyspan_serial_private {
 	struct urb	*instat_urb;
 	char		instat_buf[INSTAT_BUFLEN];
 
-	/* added to support 49wg, where data from all 4 ports comes in on 1 EP */
-	/* and high-speed supported */
+	/* added to support 49wg, where data from all 4 ports comes in
+	   on 1 EP and high-speed supported */
 	struct urb	*indat_urb;
 	char		indat_buf[INDAT49W_BUFLEN];
 
 	/* XXX this one probably will need a lock */
 	struct urb	*glocont_urb;
 	char		glocont_buf[GLOCONT_BUFLEN];
-	char		ctrl_buf[8];			// for EP0 control message
+	char		ctrl_buf[8];	/* for EP0 control message */
 };
 
 struct keyspan_port_private {
@@ -184,19 +184,19 @@ struct keyspan_port_private {
 	int		resend_cont;	/* need to resend control packet */
 };
 
-	
 /* Include Keyspan message headers.  All current Keyspan Adapters
    make use of one of five message formats which are referred
-   to as USA-26, USA-28, USA-49, USA-90, USA-67 by Keyspan and within this driver. */
+   to as USA-26, USA-28, USA-49, USA-90, USA-67 by Keyspan and
+   within this driver. */
 #include "keyspan_usa26msg.h"
 #include "keyspan_usa28msg.h"
 #include "keyspan_usa49msg.h"
 #include "keyspan_usa90msg.h"
 #include "keyspan_usa67msg.h"
-	
+
 
 /* Functions used by new usb-serial code. */
-static int __init keyspan_init (void)
+static int __init keyspan_init(void)
 {
 	int retval;
 	retval = usb_serial_register(&keyspan_pre_device);
@@ -212,7 +212,7 @@ static int __init keyspan_init (void)
 	if (retval)
 		goto failed_4port_device_register;
 	retval = usb_register(&keyspan_driver);
-	if (retval) 
+	if (retval)
 		goto failed_usb_register;
 
 	info(DRIVER_VERSION ":" DRIVER_DESC);
@@ -230,13 +230,13 @@ failed_pre_device_register:
 	return retval;
 }
 
-static void __exit keyspan_exit (void)
+static void __exit keyspan_exit(void)
 {
-	usb_deregister (&keyspan_driver);
-	usb_serial_deregister (&keyspan_pre_device);
-	usb_serial_deregister (&keyspan_1port_device);
-	usb_serial_deregister (&keyspan_2port_device);
-	usb_serial_deregister (&keyspan_4port_device);
+	usb_deregister(&keyspan_driver);
+	usb_serial_deregister(&keyspan_pre_device);
+	usb_serial_deregister(&keyspan_1port_device);
+	usb_serial_deregister(&keyspan_2port_device);
+	usb_serial_deregister(&keyspan_4port_device);
 }
 
 module_init(keyspan_init);
@@ -247,7 +247,7 @@ static void keyspan_break_ctl(struct tty_struct *tty, int break_state)
 	struct usb_serial_port *port = tty->driver_data;
 	struct keyspan_port_private 	*p_priv;
 
- 	dbg("%s", __func__);
+	dbg("%s", __func__);
 
 	p_priv = usb_get_serial_port_data(port);
 
@@ -260,7 +260,7 @@ static void keyspan_break_ctl(struct tty_struct *tty, int break_state)
 }
 
 
-static void keyspan_set_termios (struct tty_struct *tty,
+static void keyspan_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	int				baud_rate, device_port;
@@ -278,7 +278,7 @@ static void keyspan_set_termios (struct tty_struct *tty,
 	/* Baud rate calculation takes baud rate as an integer
 	   so other rates can be generated if desired. */
 	baud_rate = tty_get_baud_rate(tty);
-	/* If no match or invalid, don't change */		
+	/* If no match or invalid, don't change */
 	if (d_details->calculate_baud_rate(baud_rate, d_details->baudclk,
 				NULL, NULL, NULL, device_port) == KEYSPAN_BAUD_RATE_OK) {
 		/* FIXME - more to do here to ensure rate changes cleanly */
@@ -303,13 +303,13 @@ static int keyspan_tiocmget(struct tty_struct *tty, struct file *file)
 	struct usb_serial_port *port = tty->driver_data;
 	struct keyspan_port_private *p_priv = usb_get_serial_port_data(port);
 	unsigned int			value;
-	
+
 	value = ((p_priv->rts_state) ? TIOCM_RTS : 0) |
 		((p_priv->dtr_state) ? TIOCM_DTR : 0) |
 		((p_priv->cts_state) ? TIOCM_CTS : 0) |
 		((p_priv->dsr_state) ? TIOCM_DSR : 0) |
 		((p_priv->dcd_state) ? TIOCM_CAR : 0) |
-		((p_priv->ri_state) ? TIOCM_RNG : 0); 
+		((p_priv->ri_state) ? TIOCM_RNG : 0);
 
 	return value;
 }
@@ -319,7 +319,7 @@ static int keyspan_tiocmset(struct tty_struct *tty, struct file *file,
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct keyspan_port_private *p_priv = usb_get_serial_port_data(port);
-	
+
 	if (set & TIOCM_RTS)
 		p_priv->rts_state = 1;
 	if (set & TIOCM_DTR)
@@ -342,19 +342,19 @@ static int keyspan_write(struct tty_struct *tty,
 	int				flip;
 	int 				left, todo;
 	struct urb			*this_urb;
- 	int 				err, maxDataLen, dataOffset;
+	int 				err, maxDataLen, dataOffset;
 
 	p_priv = usb_get_serial_port_data(port);
 	d_details = p_priv->device_details;
 
 	if (d_details->msg_format == msg_usa90) {
-   		maxDataLen = 64;
+		maxDataLen = 64;
 		dataOffset = 0;
 	} else {
 		maxDataLen = 63;
 		dataOffset = 1;
 	}
-	
+
 	dbg("%s - for port %d (%d chars), flip=%d",
 	    __func__, port->number, count, p_priv->out_flip);
 
@@ -364,37 +364,40 @@ static int keyspan_write(struct tty_struct *tty,
 			todo = maxDataLen;
 
 		flip = p_priv->out_flip;
-	
+
 		/* Check we have a valid urb/endpoint before we use it... */
-		if ((this_urb = p_priv->out_urbs[flip]) == NULL) {
+		this_urb = p_priv->out_urbs[flip];
+		if (this_urb == NULL) {
 			/* no bulk out, so return 0 bytes written */
 			dbg("%s - no output urb :(", __func__);
 			return count;
 		}
 
-		dbg("%s - endpoint %d flip %d", __func__, usb_pipeendpoint(this_urb->pipe), flip);
+		dbg("%s - endpoint %d flip %d",
+			__func__, usb_pipeendpoint(this_urb->pipe), flip);
 
 		if (this_urb->status == -EINPROGRESS) {
-			if (time_before(jiffies, p_priv->tx_start_time[flip] + 10 * HZ))
+			if (time_before(jiffies,
+					p_priv->tx_start_time[flip] + 10 * HZ))
 				break;
 			usb_unlink_urb(this_urb);
 			break;
 		}
 
-		/* First byte in buffer is "last flag" (except for usa19hx) - unused so
-		   for now so set to zero */
+		/* First byte in buffer is "last flag" (except for usa19hx)
+		   - unused so for now so set to zero */
 		((char *)this_urb->transfer_buffer)[0] = 0;
 
-		memcpy (this_urb->transfer_buffer + dataOffset, buf, todo);
+		memcpy(this_urb->transfer_buffer + dataOffset, buf, todo);
 		buf += todo;
 
 		/* send the data out the bulk port */
 		this_urb->transfer_buffer_length = todo + dataOffset;
 
 		this_urb->dev = port->serial->dev;
-		if ((err = usb_submit_urb(this_urb, GFP_ATOMIC)) != 0) {
+		err = usb_submit_urb(this_urb, GFP_ATOMIC);
+		if (err != 0)
 			dbg("usb_submit_urb(write bulk) failed (%d)", err);
-		}
 		p_priv->tx_start_time[flip] = jiffies;
 
 		/* Flip for next time if usa26 or usa28 interface
@@ -414,7 +417,7 @@ static void	usa26_indat_callback(struct urb *urb)
 	unsigned char 		*data = urb->transfer_buffer;
 	int status = urb->status;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	endpoint = usb_pipeendpoint(urb->pipe);
 
@@ -429,13 +432,14 @@ static void	usa26_indat_callback(struct urb *urb)
 	if (tty && urb->actual_length) {
 		/* 0x80 bit is error flag */
 		if ((data[0] & 0x80) == 0) {
-			/* no errors on individual bytes, only possible overrun err*/
+			/* no errors on individual bytes, only
+			   possible overrun err */
 			if (data[0] & RXERROR_OVERRUN)
-					err = TTY_OVERRUN;
-			else err = 0;
-			for (i = 1; i < urb->actual_length ; ++i) {
+				err = TTY_OVERRUN;
+			else
+				err = 0;
+			for (i = 1; i < urb->actual_length ; ++i)
 				tty_insert_flip_char(tty, data[i], err);
-			}
 		} else {
 			/* some bytes had errors, every byte has status */
 			dbg("%s - RX error!!!!", __func__);
@@ -453,17 +457,19 @@ static void	usa26_indat_callback(struct urb *urb)
 		}
 		tty_flip_buffer_push(tty);
 	}
-				
-		/* Resubmit urb so we continue receiving */
+
+	/* Resubmit urb so we continue receiving */
 	urb->dev = port->serial->dev;
-	if (port->port.count)
-		if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
-			dbg("%s - resubmit read urb failed. (%d)", __func__, err);
-		}
+	if (port->port.count) {
+		err = usb_submit_urb(urb, GFP_ATOMIC);
+		if (err != 0)
+			dbg("%s - resubmit read urb failed. (%d)",
+					__func__, err);
+	}
 	return;
 }
 
- 	/* Outdat handling is common for all devices */
+/* Outdat handling is common for all devices */
 static void	usa2x_outdat_callback(struct urb *urb)
 {
 	struct usb_serial_port *port;
@@ -471,7 +477,7 @@ static void	usa2x_outdat_callback(struct urb *urb)
 
 	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
-	dbg ("%s - urb %d", __func__, urb == p_priv->out_urbs[1]);
+	dbg("%s - urb %d", __func__, urb == p_priv->out_urbs[1]);
 
 	if (port->port.count)
 		usb_serial_port_softint(port);
@@ -479,8 +485,8 @@ static void	usa2x_outdat_callback(struct urb *urb)
 
 static void	usa26_inack_callback(struct urb *urb)
 {
-	dbg ("%s", __func__);
-	
+	dbg("%s", __func__);
+
 }
 
 static void	usa26_outcont_callback(struct urb *urb)
@@ -492,8 +498,9 @@ static void	usa26_outcont_callback(struct urb *urb)
 	p_priv = usb_get_serial_port_data(port);
 
 	if (p_priv->resend_cont) {
-		dbg ("%s - sending setup", __func__);
-		keyspan_usa26_send_setup(port->serial, port, p_priv->resend_cont - 1);
+		dbg("%s - sending setup", __func__);
+		keyspan_usa26_send_setup(port->serial, port,
+						p_priv->resend_cont - 1);
 	}
 }
 
@@ -529,14 +536,14 @@ static void	usa26_instat_callback(struct urb *urb)
 	/* Now do something useful with the data */
 
 
-	/* Check port number from message and retrieve private data */	
+	/* Check port number from message and retrieve private data */
 	if (msg->port >= serial->num_ports) {
-		dbg ("%s - Unexpected port number %d", __func__, msg->port);
+		dbg("%s - Unexpected port number %d", __func__, msg->port);
 		goto exit;
 	}
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
-	
+
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
 	p_priv->cts_state = ((msg->hskia_cts) ? 1 : 0);
@@ -551,19 +558,18 @@ static void	usa26_instat_callback(struct urb *urb)
 		/*  else */
 		/*	wake_up_interruptible(&p_priv->open_wait); */
 	}
-	
+
 	/* Resubmit urb so we continue receiving */
 	urb->dev = serial->dev;
-	if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (err != 0)
 		dbg("%s - resubmit read urb failed. (%d)", __func__, err);
-	}
 exit: ;
 }
 
 static void	usa26_glocont_callback(struct urb *urb)
 {
-	dbg ("%s", __func__);
-	
+	dbg("%s", __func__);
 }
 
 
@@ -576,7 +582,7 @@ static void usa28_indat_callback(struct urb *urb)
 	struct keyspan_port_private             *p_priv;
 	int status = urb->status;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
@@ -598,18 +604,19 @@ static void usa28_indat_callback(struct urb *urb)
 
 		tty = port->port.tty;
 		if (urb->actual_length) {
-			for (i = 0; i < urb->actual_length ; ++i) {
+			for (i = 0; i < urb->actual_length ; ++i)
 				tty_insert_flip_char(tty, data[i], 0);
-			}
 			tty_flip_buffer_push(tty);
 		}
 
 		/* Resubmit urb so we continue receiving */
 		urb->dev = port->serial->dev;
-		if (port->port.count)
-			if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
-				dbg("%s - resubmit read urb failed. (%d)", __func__, err);
-			}
+		if (port->port.count) {
+			err = usb_submit_urb(urb, GFP_ATOMIC);
+			if (err != 0)
+				dbg("%s - resubmit read urb failed. (%d)",
+								__func__, err);
+		}
 		p_priv->in_flip ^= 1;
 
 		urb = p_priv->in_urbs[p_priv->in_flip];
@@ -618,7 +625,7 @@ static void usa28_indat_callback(struct urb *urb)
 
 static void	usa28_inack_callback(struct urb *urb)
 {
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 }
 
 static void	usa28_outcont_callback(struct urb *urb)
@@ -630,8 +637,9 @@ static void	usa28_outcont_callback(struct urb *urb)
 	p_priv = usb_get_serial_port_data(port);
 
 	if (p_priv->resend_cont) {
-		dbg ("%s - sending setup", __func__);
-		keyspan_usa28_send_setup(port->serial, port, p_priv->resend_cont - 1);
+		dbg("%s - sending setup", __func__);
+		keyspan_usa28_send_setup(port->serial, port,
+						p_priv->resend_cont - 1);
 	}
 }
 
@@ -661,19 +669,18 @@ static void	usa28_instat_callback(struct urb *urb)
 	/*dbg("%s %x %x %x %x %x %x %x %x %x %x %x %x", __func__
 	    data[0], data[1], data[2], data[3], data[4], data[5],
 	    data[6], data[7], data[8], data[9], data[10], data[11]);*/
-	
-		/* Now do something useful with the data */
-	msg = (struct keyspan_usa28_portStatusMessage *)data;
 
+	/* Now do something useful with the data */
+	msg = (struct keyspan_usa28_portStatusMessage *)data;
 
-		/* Check port number from message and retrieve private data */	
+	/* Check port number from message and retrieve private data */
 	if (msg->port >= serial->num_ports) {
-		dbg ("%s - Unexpected port number %d", __func__, msg->port);
+		dbg("%s - Unexpected port number %d", __func__, msg->port);
 		goto exit;
 	}
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
-	
+
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
 	p_priv->cts_state = ((msg->cts) ? 1 : 0);
@@ -691,15 +698,15 @@ static void	usa28_instat_callback(struct urb *urb)
 
 		/* Resubmit urb so we continue receiving */
 	urb->dev = serial->dev;
-	if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (err != 0)
 		dbg("%s - resubmit read urb failed. (%d)", __func__, err);
-	}
 exit: ;
 }
 
 static void	usa28_glocont_callback(struct urb *urb)
 {
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 }
 
 
@@ -710,7 +717,7 @@ static void	usa49_glocont_callback(struct urb *urb)
 	struct keyspan_port_private *p_priv;
 	int i;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	serial =  urb->context;
 	for (i = 0; i < serial->num_ports; ++i) {
@@ -718,8 +725,9 @@ static void	usa49_glocont_callback(struct urb *urb)
 		p_priv = usb_get_serial_port_data(port);
 
 		if (p_priv->resend_cont) {
-			dbg ("%s - sending setup", __func__);
-			keyspan_usa49_send_setup(serial, port, p_priv->resend_cont - 1);
+			dbg("%s - sending setup", __func__);
+			keyspan_usa49_send_setup(serial, port,
+						p_priv->resend_cont - 1);
 			break;
 		}
 	}
@@ -738,7 +746,7 @@ static void	usa49_instat_callback(struct urb *urb)
 	int old_dcd_state;
 	int status = urb->status;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	serial =  urb->context;
 
@@ -747,7 +755,8 @@ static void	usa49_instat_callback(struct urb *urb)
 		return;
 	}
 
-	if (urb->actual_length != sizeof(struct keyspan_usa49_portStatusMessage)) {
+	if (urb->actual_length !=
+			sizeof(struct keyspan_usa49_portStatusMessage)) {
 		dbg("%s - bad length %d", __func__, urb->actual_length);
 		goto exit;
 	}
@@ -755,18 +764,19 @@ static void	usa49_instat_callback(struct urb *urb)
 	/*dbg(" %x %x %x %x %x %x %x %x %x %x %x", __func__,
 	    data[0], data[1], data[2], data[3], data[4], data[5],
 	    data[6], data[7], data[8], data[9], data[10]);*/
-	
-		/* Now do something useful with the data */
+
+	/* Now do something useful with the data */
 	msg = (struct keyspan_usa49_portStatusMessage *)data;
 
-		/* Check port number from message and retrieve private data */	
+	/* Check port number from message and retrieve private data */
 	if (msg->portNumber >= serial->num_ports) {
-		dbg ("%s - Unexpected port number %d", __func__, msg->portNumber);
+		dbg("%s - Unexpected port number %d",
+					__func__, msg->portNumber);
 		goto exit;
 	}
 	port = serial->port[msg->portNumber];
 	p_priv = usb_get_serial_port_data(port);
-	
+
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
 	p_priv->cts_state = ((msg->cts) ? 1 : 0);
@@ -782,18 +792,18 @@ static void	usa49_instat_callback(struct urb *urb)
 		/*	wake_up_interruptible(&p_priv->open_wait); */
 	}
 
-		/* Resubmit urb so we continue receiving */
+	/* Resubmit urb so we continue receiving */
 	urb->dev = serial->dev;
 
-	if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (err != 0)
 		dbg("%s - resubmit read urb failed. (%d)", __func__, err);
-	}
 exit:	;
 }
 
 static void	usa49_inack_callback(struct urb *urb)
 {
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 }
 
 static void	usa49_indat_callback(struct urb *urb)
@@ -805,7 +815,7 @@ static void	usa49_indat_callback(struct urb *urb)
 	unsigned char 		*data = urb->transfer_buffer;
 	int status = urb->status;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	endpoint = usb_pipeendpoint(urb->pipe);
 
@@ -821,9 +831,8 @@ static void	usa49_indat_callback(struct urb *urb)
 		/* 0x80 bit is error flag */
 		if ((data[0] & 0x80) == 0) {
 			/* no error on any byte */
-			for (i = 1; i < urb->actual_length ; ++i) {
+			for (i = 1; i < urb->actual_length ; ++i)
 				tty_insert_flip_char(tty, data[i], 0);
-			}
 		} else {
 			/* some bytes had errors, every byte has status */
 			for (i = 0; i + 1 < urb->actual_length; i += 2) {
@@ -840,13 +849,15 @@ static void	usa49_indat_callback(struct urb *urb)
 		}
 		tty_flip_buffer_push(tty);
 	}
-				
-		/* Resubmit urb so we continue receiving */
+
+	/* Resubmit urb so we continue receiving */
 	urb->dev = port->serial->dev;
-	if (port->port.count)
-		if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
-			dbg("%s - resubmit read urb failed. (%d)", __func__, err);
-		}
+	if (port->port.count) {
+		err = usb_submit_urb(urb, GFP_ATOMIC);
+		if (err != 0)
+			dbg("%s - resubmit read urb failed. (%d)",
+							__func__, err);
+	}
 }
 
 static void usa49wg_indat_callback(struct urb *urb)
@@ -858,7 +869,7 @@ static void usa49wg_indat_callback(struct urb *urb)
 	unsigned char 		*data = urb->transfer_buffer;
 	int status = urb->status;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	serial = urb->context;
 
@@ -876,7 +887,7 @@ static void usa49wg_indat_callback(struct urb *urb)
 
 			/* Check port number from message*/
 			if (data[i] >= serial->num_ports) {
-				dbg ("%s - Unexpected port number %d",
+				dbg("%s - Unexpected port number %d",
 					__func__, data[i]);
 				return;
 			}
@@ -929,7 +940,7 @@ static void usa49wg_indat_callback(struct urb *urb)
 /* not used, usa-49 doesn't have per-port control endpoints */
 static void usa49_outcont_callback(struct urb *urb)
 {
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 }
 
 static void usa90_indat_callback(struct urb *urb)
@@ -942,7 +953,7 @@ static void usa90_indat_callback(struct urb *urb)
 	unsigned char 		*data = urb->transfer_buffer;
 	int status = urb->status;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	endpoint = usb_pipeendpoint(urb->pipe);
 
@@ -957,27 +968,25 @@ static void usa90_indat_callback(struct urb *urb)
 
 	tty = port->port.tty;
 	if (urb->actual_length) {
-	
 		/* if current mode is DMA, looks like usa28 format
-	   		otherwise looks like usa26 data format */
+		   otherwise looks like usa26 data format */
 
 		if (p_priv->baud > 57600) {
-			for (i = 0; i < urb->actual_length ; ++i) 
+			for (i = 0; i < urb->actual_length ; ++i)
 				tty_insert_flip_char(tty, data[i], 0);
-		}
-		else {
-			
+		} else {
 			/* 0x80 bit is error flag */
 			if ((data[0] & 0x80) == 0) {
-				/* no errors on individual bytes, only possible overrun err*/
+				/* no errors on individual bytes, only
+				   possible overrun err*/
 				if (data[0] & RXERROR_OVERRUN)
-						err = TTY_OVERRUN;
-				else err = 0;
-				for (i = 1; i < urb->actual_length ; ++i) 
-					tty_insert_flip_char(tty, data[i], err);
-			
-			} 
-			else {
+					err = TTY_OVERRUN;
+				else
+					err = 0;
+				for (i = 1; i < urb->actual_length ; ++i)
+					tty_insert_flip_char(tty, data[i],
+									err);
+			}  else {
 			/* some bytes had errors, every byte has status */
 				dbg("%s - RX error!!!!", __func__);
 				for (i = 0; i + 1 < urb->actual_length; i += 2) {
@@ -989,19 +998,22 @@ static void usa90_indat_callback(struct urb *urb)
 					if (stat & RXERROR_PARITY)
 						flag |= TTY_PARITY;
 					/* XXX should handle break (0x10) */
-					tty_insert_flip_char(tty, data[i+1], flag);
+					tty_insert_flip_char(tty, data[i+1],
+									flag);
 				}
 			}
 		}
 		tty_flip_buffer_push(tty);
 	}
-				
+
 	/* Resubmit urb so we continue receiving */
 	urb->dev = port->serial->dev;
-	if (port->port.count)
-		if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
-			dbg("%s - resubmit read urb failed. (%d)", __func__, err);
-		}
+	if (port->port.count) {
+		err = usb_submit_urb(urb, GFP_ATOMIC);
+		if (err != 0)
+			dbg("%s - resubmit read urb failed. (%d)",
+							__func__, err);
+	}
 	return;
 }
 
@@ -1033,7 +1045,7 @@ static void	usa90_instat_callback(struct urb *urb)
 
 	port = serial->port[0];
 	p_priv = usb_get_serial_port_data(port);
-	
+
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
 	p_priv->cts_state = ((msg->cts) ? 1 : 0);
@@ -1048,12 +1060,12 @@ static void	usa90_instat_callback(struct urb *urb)
 		/*  else */
 		/*	wake_up_interruptible(&p_priv->open_wait); */
 	}
-	
+
 	/* Resubmit urb so we continue receiving */
 	urb->dev = serial->dev;
-	if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (err != 0)
 		dbg("%s - resubmit read urb failed. (%d)", __func__, err);
-	}
 exit:
 	;
 }
@@ -1067,8 +1079,9 @@ static void	usa90_outcont_callback(struct urb *urb)
 	p_priv = usb_get_serial_port_data(port);
 
 	if (p_priv->resend_cont) {
-		dbg ("%s - sending setup", __func__);
-		keyspan_usa90_send_setup(port->serial, port, p_priv->resend_cont - 1);
+		dbg("%s - sending setup", __func__);
+		keyspan_usa90_send_setup(port->serial, port,
+						p_priv->resend_cont - 1);
 	}
 }
 
@@ -1084,7 +1097,7 @@ static void	usa67_instat_callback(struct urb *urb)
 	int old_dcd_state;
 	int status = urb->status;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	serial = urb->context;
 
@@ -1093,7 +1106,8 @@ static void	usa67_instat_callback(struct urb *urb)
 		return;
 	}
 
-	if (urb->actual_length != sizeof(struct keyspan_usa67_portStatusMessage)) {
+	if (urb->actual_length !=
+			sizeof(struct keyspan_usa67_portStatusMessage)) {
 		dbg("%s - bad length %d", __func__, urb->actual_length);
 		return;
 	}
@@ -1104,7 +1118,7 @@ static void	usa67_instat_callback(struct urb *urb)
 
 	/* Check port number from message and retrieve private data */
 	if (msg->port >= serial->num_ports) {
-		dbg ("%s - Unexpected port number %d", __func__, msg->port);
+		dbg("%s - Unexpected port number %d", __func__, msg->port);
 		return;
 	}
 
@@ -1138,7 +1152,7 @@ static void usa67_glocont_callback(struct urb *urb)
 	struct keyspan_port_private *p_priv;
 	int i;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	serial = urb->context;
 	for (i = 0; i < serial->num_ports; ++i) {
@@ -1146,7 +1160,7 @@ static void usa67_glocont_callback(struct urb *urb)
 		p_priv = usb_get_serial_port_data(port);
 
 		if (p_priv->resend_cont) {
-			dbg ("%s - sending setup", __func__);
+			dbg("%s - sending setup", __func__);
 			keyspan_usa67_send_setup(serial, port,
 						p_priv->resend_cont - 1);
 			break;
@@ -1169,20 +1183,23 @@ static int keyspan_write_room(struct tty_struct *tty)
 
 	/* FIXME: locking */
 	if (d_details->msg_format == msg_usa90)
-   		data_len = 64;
+		data_len = 64;
 	else
 		data_len = 63;
 
 	flip = p_priv->out_flip;
 
 	/* Check both endpoints to see if any are available. */
-	if ((this_urb = p_priv->out_urbs[flip]) != NULL) {
+	this_urb = p_priv->out_urbs[flip];
+	if (this_urb != NULL) {
 		if (this_urb->status != -EINPROGRESS)
-			return (data_len);
-		flip = (flip + 1) & d_details->outdat_endp_flip;        
-		if ((this_urb = p_priv->out_urbs[flip]) != NULL) 
+			return data_len;
+		flip = (flip + 1) & d_details->outdat_endp_flip;
+		this_urb = p_priv->out_urbs[flip];
+		if (this_urb != NULL) {
 			if (this_urb->status != -EINPROGRESS)
-				return (data_len);
+				return data_len;
+		}
 	}
 	return 0;
 }
@@ -1220,25 +1237,28 @@ static int keyspan_open(struct tty_struct *tty,
 
 	/* Reset low level data toggle and start reading from endpoints */
 	for (i = 0; i < 2; i++) {
-		if ((urb = p_priv->in_urbs[i]) == NULL)
+		urb = p_priv->in_urbs[i];
+		if (urb == NULL)
 			continue;
 		urb->dev = serial->dev;
 
-		/* make sure endpoint data toggle is synchronized with the device */
-
+		/* make sure endpoint data toggle is synchronized
+		   with the device */
 		usb_clear_halt(urb->dev, urb->pipe);
-
-		if ((err = usb_submit_urb(urb, GFP_KERNEL)) != 0) {
-			dbg("%s - submit urb %d failed (%d)", __func__, i, err);
-		}
+		err = usb_submit_urb(urb, GFP_KERNEL);
+		if (err != 0)
+			dbg("%s - submit urb %d failed (%d)",
+							__func__, i, err);
 	}
 
 	/* Reset low level data toggle on out endpoints */
 	for (i = 0; i < 2; i++) {
-		if ((urb = p_priv->out_urbs[i]) == NULL)
+		urb = p_priv->out_urbs[i];
+		if (urb == NULL)
 			continue;
 		urb->dev = serial->dev;
-		/* usb_settoggle(urb->dev, usb_pipeendpoint(urb->pipe), usb_pipeout(urb->pipe), 0); */
+		/* usb_settoggle(urb->dev, usb_pipeendpoint(urb->pipe),
+						usb_pipeout(urb->pipe), 0); */
 	}
 
 	/* get the terminal config for the setup message now so we don't
@@ -1262,8 +1282,8 @@ static int keyspan_open(struct tty_struct *tty,
 	p_priv->flow_control = (cflag & CRTSCTS)? flow_cts: flow_none;
 
 	keyspan_send_setup(port, 1);
-	//mdelay(100);
-	//keyspan_set_termios(port, NULL);
+	/* mdelay(100); */
+	/* keyspan_set_termios(port, NULL); */
 
 	return 0;
 }
@@ -1285,15 +1305,15 @@ static void keyspan_close(struct tty_struct *tty,
 	dbg("%s", __func__);
 	s_priv = usb_get_serial_data(serial);
 	p_priv = usb_get_serial_port_data(port);
-	
+
 	p_priv->rts_state = 0;
 	p_priv->dtr_state = 0;
-	
+
 	if (serial->dev) {
 		keyspan_send_setup(port, 2);
 		/* pilot-xfer seems to work best with this delay */
 		mdelay(100);
-		// keyspan_set_termios(port, NULL);
+		/* keyspan_set_termios(port, NULL); */
 	}
 
 	/*while (p_priv->outcont_urb->status == -EINPROGRESS) {
@@ -1316,8 +1336,8 @@ static void keyspan_close(struct tty_struct *tty,
 }
 
 
-	/* download the firmware to a pre-renumeration device */
-static int keyspan_fake_startup (struct usb_serial *serial)
+/* download the firmware to a pre-renumeration device */
+static int keyspan_fake_startup(struct usb_serial *serial)
 {
 	int 				response;
 	const struct ezusb_hex_record 	*record;
@@ -1326,10 +1346,11 @@ static int keyspan_fake_startup (struct usb_serial *serial)
 	dbg("Keyspan startup version %04x product %04x",
 	    le16_to_cpu(serial->dev->descriptor.bcdDevice),
 	    le16_to_cpu(serial->dev->descriptor.idProduct));
-	
-	if ((le16_to_cpu(serial->dev->descriptor.bcdDevice) & 0x8000) != 0x8000) {
+
+	if ((le16_to_cpu(serial->dev->descriptor.bcdDevice) & 0x8000)
+								!= 0x8000) {
 		dbg("Firmware already loaded.  Quitting.");
-		return(1);
+		return 1;
 	}
 
 		/* Select firmware image on the basis of idProduct */
@@ -1358,12 +1379,12 @@ static int keyspan_fake_startup (struct usb_serial *serial)
 		record = &keyspan_usa19_firmware[0];
 		fw_name = "USA19";
 		break;
-			     
+
 	case keyspan_usa19qi_pre_product_id:
 		record = &keyspan_usa19qi_firmware[0];
 		fw_name = "USA19QI";
 		break;
-			     
+
 	case keyspan_mpr_pre_product_id:
 		record = &keyspan_mpr_firmware[0];
 		fw_name = "MPR";
@@ -1373,17 +1394,17 @@ static int keyspan_fake_startup (struct usb_serial *serial)
 		record = &keyspan_usa19qw_firmware[0];
 		fw_name = "USA19QI";
 		break;
-			     
+
 	case keyspan_usa18x_pre_product_id:
 		record = &keyspan_usa18x_firmware[0];
 		fw_name = "USA18X";
 		break;
-			     
+
 	case keyspan_usa19w_pre_product_id:
 		record = &keyspan_usa19w_firmware[0];
 		fw_name = "USA19W";
 		break;
-		
+
 	case keyspan_usa49w_pre_product_id:
 		record = &keyspan_usa49w_firmware[0];
 		fw_name = "USA49W";
@@ -1401,8 +1422,10 @@ static int keyspan_fake_startup (struct usb_serial *serial)
 	}
 
 	if (record == NULL) {
-		dev_err(&serial->dev->dev, "Required keyspan firmware image (%s) unavailable.\n", fw_name);
-		return(1);
+		dev_err(&serial->dev->dev,
+			"Required keyspan firmware image (%s) unavailable.\n",
+								fw_name);
+		return 1;
 	}
 
 	dbg("Uploading Keyspan %s firmware.", fw_name);
@@ -1410,15 +1433,16 @@ static int keyspan_fake_startup (struct usb_serial *serial)
 		/* download the firmware image */
 	response = ezusb_set_reset(serial, 1);
 
-	while(record->address != 0xffff) {
+	while (record->address != 0xffff) {
 		response = ezusb_writememory(serial, record->address,
 					     (unsigned char *)record->data,
 					     record->data_size, 0xa0);
 		if (response < 0) {
-			dev_err(&serial->dev->dev, "ezusb_writememory failed for Keyspan"
-				"firmware (%d %04X %p %d)\n",
-				response, 
-				record->address, record->data, record->data_size);
+			dev_err(&serial->dev->dev,
+				"ezusb_writememory failed for Keyspan firmware (%d %04X %p %d)\n",
+				response,
+				record->address, record->data,
+				record->data_size);
 			break;
 		}
 		record++;
@@ -1428,7 +1452,7 @@ static int keyspan_fake_startup (struct usb_serial *serial)
 	response = ezusb_set_reset(serial, 0);
 
 	/* we don't want this device to have a driver assigned to it. */
-	return (1);
+	return 1;
 }
 
 /* Helper functions used by keyspan_setup_urbs */
@@ -1450,7 +1474,7 @@ static struct usb_endpoint_descriptor const *find_ep(struct usb_serial const *se
 	return NULL;
 }
 
-static struct urb *keyspan_setup_urb (struct usb_serial *serial, int endpoint,
+static struct urb *keyspan_setup_urb(struct usb_serial *serial, int endpoint,
 				      int dir, void *ctx, char *buf, int len,
 				      void (*callback)(struct urb *))
 {
@@ -1461,10 +1485,10 @@ static struct urb *keyspan_setup_urb (struct usb_serial *serial, int endpoint,
 	if (endpoint == -1)
 		return NULL;		/* endpoint not needed */
 
-	dbg ("%s - alloc for endpoint %d.", __func__, endpoint);
+	dbg("%s - alloc for endpoint %d.", __func__, endpoint);
 	urb = usb_alloc_urb(0, GFP_KERNEL);		/* No ISO */
 	if (urb == NULL) {
-		dbg ("%s - alloc for endpoint %d failed.", __func__, endpoint);
+		dbg("%s - alloc for endpoint %d failed.", __func__, endpoint);
 		return NULL;
 	}
 
@@ -1537,7 +1561,7 @@ static struct callbacks {
 	}, {
 		/* msg_usa90 callbacks */
 		.instat_callback =	usa90_instat_callback,
-		.glocont_callback =	usa28_glocont_callback,		
+		.glocont_callback =	usa28_glocont_callback,
 		.indat_callback =	usa90_indat_callback,
 		.outdat_callback =	usa2x_outdat_callback,
 		.inack_callback =	usa28_inack_callback,
@@ -1565,16 +1589,16 @@ static void keyspan_setup_urbs(struct usb_serial *serial)
 	struct callbacks		*cback;
 	int				endp;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	s_priv = usb_get_serial_data(serial);
 	d_details = s_priv->device_details;
 
-		/* Setup values for the various callback routines */
+	/* Setup values for the various callback routines */
 	cback = &keyspan_callbacks[d_details->msg_format];
 
-		/* Allocate and set up urbs for each one that is in use, 
-		   starting with instat endpoints */
+	/* Allocate and set up urbs for each one that is in use,
+	   starting with instat endpoints */
 	s_priv->instat_urb = keyspan_setup_urb
 		(serial, d_details->instat_endpoint, USB_DIR_IN,
 		 serial, s_priv->instat_buf, INSTAT_BUFLEN,
@@ -1590,8 +1614,8 @@ static void keyspan_setup_urbs(struct usb_serial *serial)
 		 serial, s_priv->glocont_buf, GLOCONT_BUFLEN,
 		 cback->glocont_callback);
 
-		/* Setup endpoints for each port specific thing */
-	for (i = 0; i < d_details->num_ports; i ++) {
+	/* Setup endpoints for each port specific thing */
+	for (i = 0; i < d_details->num_ports; i++) {
 		port = serial->port[i];
 		p_priv = usb_get_serial_port_data(port);
 
@@ -1627,8 +1651,7 @@ static void keyspan_setup_urbs(struct usb_serial *serial)
 			(serial, d_details->outcont_endpoints[i], USB_DIR_OUT,
 			 port, p_priv->outcont_buffer, 64,
 			 cback->outcont_callback);
-	}	
-
+	}
 }
 
 /* usa19 function doesn't require prescaler */
@@ -1636,46 +1659,39 @@ static int keyspan_usa19_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				   u8 *rate_low, u8 *prescaler, int portnum)
 {
 	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
-		div,	/* divisor */	
+		div,	/* divisor */
 		cnt;	/* inverse of divisor (programmed into 8051) */
-		
-	dbg ("%s - %d.", __func__, baud_rate);
 
-		/* prevent divide by zero...  */
-	if( (b16 = (baud_rate * 16L)) == 0) {
-		return (KEYSPAN_INVALID_BAUD_RATE);
-	}
-
-		/* Any "standard" rate over 57k6 is marginal on the USA-19
-		   as we run out of divisor resolution. */
-	if (baud_rate > 57600) {
-		return (KEYSPAN_INVALID_BAUD_RATE);
-	}
-
-		/* calculate the divisor and the counter (its inverse) */
-	if( (div = (baudclk / b16)) == 0) {
-		return (KEYSPAN_INVALID_BAUD_RATE);
-	}
-	else {
+	dbg("%s - %d.", __func__, baud_rate);
+
+	/* prevent divide by zero...  */
+	b16 = baud_rate * 16L
+	if (b16 == 0)
+		return KEYSPAN_INVALID_BAUD_RATE;
+	/* Any "standard" rate over 57k6 is marginal on the USA-19
+	   as we run out of divisor resolution. */
+	if (baud_rate > 57600)
+		return KEYSPAN_INVALID_BAUD_RATE;
+
+	/* calculate the divisor and the counter (its inverse) */
+	div = baudclk / b16;
+	if (div == 0)
+		return KEYSPAN_INVALID_BAUD_RATE;
+	else
 		cnt = 0 - div;
-	}
 
-	if(div > 0xffff) {
-		return (KEYSPAN_INVALID_BAUD_RATE);
-	}
+	if (div > 0xffff)
+		return KEYSPAN_INVALID_BAUD_RATE;
 
-		/* return the counter values if non-null */
-	if (rate_low) {
+	/* return the counter values if non-null */
+	if (rate_low)
 		*rate_low = (u8) (cnt & 0xff);
-	}
-	if (rate_hi) {
+	if (rate_hi)
 		*rate_hi = (u8) ((cnt >> 8) & 0xff);
-	}
-	if (rate_low && rate_hi) {
-		dbg ("%s - %d %02x %02x.", __func__, baud_rate, *rate_hi, *rate_low);
-	}
-	
-	return (KEYSPAN_BAUD_RATE_OK);
+	if (rate_low && rate_hi)
+		dbg("%s - %d %02x %02x.",
+				__func__, baud_rate, *rate_hi, *rate_low);
+	return KEYSPAN_BAUD_RATE_OK;
 }
 
 /* usa19hs function doesn't require prescaler */
@@ -1683,34 +1699,35 @@ static int keyspan_usa19hs_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				   u8 *rate_low, u8 *prescaler, int portnum)
 {
 	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
-			div;	/* divisor */	
-		
-	dbg ("%s - %d.", __func__, baud_rate);
+			div;	/* divisor */
 
-		/* prevent divide by zero...  */
-	if( (b16 = (baud_rate * 16L)) == 0) 
-		return (KEYSPAN_INVALID_BAUD_RATE);
-	
+	dbg("%s - %d.", __func__, baud_rate);
 
+	/* prevent divide by zero...  */
+	b16 = baud_rate * 16L;
+	if (b16 == 0)
+		return KEYSPAN_INVALID_BAUD_RATE;
 
-		/* calculate the divisor */
-	if( (div = (baudclk / b16)) == 0) 
-		return (KEYSPAN_INVALID_BAUD_RATE);
+	/* calculate the divisor */
+	div = baudclk / b16;
+	if (div == 0)
+		return KEYSPAN_INVALID_BAUD_RATE;
 
-	if(div > 0xffff) 
-		return (KEYSPAN_INVALID_BAUD_RATE);
+	if (div > 0xffff)
+		return KEYSPAN_INVALID_BAUD_RATE;
 
-		/* return the counter values if non-null */
-	if (rate_low) 
+	/* return the counter values if non-null */
+	if (rate_low)
 		*rate_low = (u8) (div & 0xff);
-	
-	if (rate_hi) 
+
+	if (rate_hi)
 		*rate_hi = (u8) ((div >> 8) & 0xff);
-	
-	if (rate_low && rate_hi) 
-		dbg ("%s - %d %02x %02x.", __func__, baud_rate, *rate_hi, *rate_low);
-	
-	return (KEYSPAN_BAUD_RATE_OK);
+
+	if (rate_low && rate_hi)
+		dbg("%s - %d %02x %02x.",
+			__func__, baud_rate, *rate_hi, *rate_low);
+
+	return KEYSPAN_BAUD_RATE_OK;
 }
 
 static int keyspan_usa19w_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
@@ -1718,64 +1735,61 @@ static int keyspan_usa19w_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 {
 	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
 		clk,	/* clock with 13/8 prescaler */
-		div,	/* divisor using 13/8 prescaler */	
+		div,	/* divisor using 13/8 prescaler */
 		res,	/* resulting baud rate using 13/8 prescaler */
 		diff,	/* error using 13/8 prescaler */
 		smallest_diff;
 	u8	best_prescaler;
 	int	i;
 
-	dbg ("%s - %d.", __func__, baud_rate);
+	dbg("%s - %d.", __func__, baud_rate);
 
-		/* prevent divide by zero */
-	if( (b16 = baud_rate * 16L) == 0) {
-		return (KEYSPAN_INVALID_BAUD_RATE);
-	}
+	/* prevent divide by zero */
+	b16 = baud_rate * 16L;
+	if (b16 == 0)
+		return KEYSPAN_INVALID_BAUD_RATE;
 
-		/* Calculate prescaler by trying them all and looking
-		   for best fit */
-		
-		/* start with largest possible difference */
+	/* Calculate prescaler by trying them all and looking
+	   for best fit */
+
+	/* start with largest possible difference */
 	smallest_diff = 0xffffffff;
 
 		/* 0 is an invalid prescaler, used as a flag */
 	best_prescaler = 0;
 
-	for(i = 8; i <= 0xff; ++i) {
+	for (i = 8; i <= 0xff; ++i) {
 		clk = (baudclk * 8) / (u32) i;
-		
-		if( (div = clk / b16) == 0) {
+
+		div = clk / b16;
+		if (div == 0)
 			continue;
-		}
 
 		res = clk / div;
-		diff= (res > b16) ? (res-b16) : (b16-res);
+		diff = (res > b16) ? (res-b16) : (b16-res);
 
-		if(diff < smallest_diff) {
+		if (diff < smallest_diff) {
 			best_prescaler = i;
 			smallest_diff = diff;
 		}
 	}
 
-	if(best_prescaler == 0) {
-		return (KEYSPAN_INVALID_BAUD_RATE);
-	}
+	if (best_prescaler == 0)
+		return KEYSPAN_INVALID_BAUD_RATE;
 
 	clk = (baudclk * 8) / (u32) best_prescaler;
 	div = clk / b16;
 
-		/* return the divisor and prescaler if non-null */
-	if (rate_low) {
+	/* return the divisor and prescaler if non-null */
+	if (rate_low)
 		*rate_low = (u8) (div & 0xff);
-	}
-	if (rate_hi) {
+	if (rate_hi)
 		*rate_hi = (u8) ((div >> 8) & 0xff);
-	}
 	if (prescaler) {
 		*prescaler = best_prescaler;
 		/*  dbg("%s - %d %d", __func__, *prescaler, div); */
 	}
-	return (KEYSPAN_BAUD_RATE_OK);
+	return KEYSPAN_BAUD_RATE_OK;
 }
 
 	/* USA-28 supports different maximum baud rates on each port */
@@ -1783,57 +1797,51 @@ static int keyspan_usa28_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				    u8 *rate_low, u8 *prescaler, int portnum)
 {
 	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
-		div,	/* divisor */	
+		div,	/* divisor */
 		cnt;	/* inverse of divisor (programmed into 8051) */
 
-	dbg ("%s - %d.", __func__, baud_rate);
+	dbg("%s - %d.", __func__, baud_rate);
 
 		/* prevent divide by zero */
-	if ((b16 = baud_rate * 16L) == 0)
-		return (KEYSPAN_INVALID_BAUD_RATE);
-
-		/* calculate the divisor and the counter (its inverse) */
-	if ((div = (KEYSPAN_USA28_BAUDCLK / b16)) == 0) {
-		return (KEYSPAN_INVALID_BAUD_RATE);
-	}
-	else {
+	b16 = baud_rate * 16L;
+	if (b16 == 0)
+		return KEYSPAN_INVALID_BAUD_RATE;
+
+	/* calculate the divisor and the counter (its inverse) */
+	div = KEYSPAN_USA28_BAUDCLK / b16;
+	if (div == 0)
+		return KEYSPAN_INVALID_BAUD_RATE;
+	else
 		cnt = 0 - div;
-	}
 
-		/* check for out of range, based on portnum, 
-		   and return result */
-	if(portnum == 0) {
-		if(div > 0xffff)
-			return (KEYSPAN_INVALID_BAUD_RATE);
-	}
-	else {
-		if(portnum == 1) {
-			if(div > 0xff) {
-				return (KEYSPAN_INVALID_BAUD_RATE);
-			}
-		}
-		else {
-			return (KEYSPAN_INVALID_BAUD_RATE);
-		}
+	/* check for out of range, based on portnum,
+	   and return result */
+	if (portnum == 0) {
+		if (div > 0xffff)
+			return KEYSPAN_INVALID_BAUD_RATE;
+	} else {
+		if (portnum == 1) {
+			if (div > 0xff)
+				return KEYSPAN_INVALID_BAUD_RATE;
+		} else
+			return KEYSPAN_INVALID_BAUD_RATE;
 	}
 
 		/* return the counter values if not NULL
 		   (port 1 will ignore retHi) */
-	if (rate_low) {
+	if (rate_low)
 		*rate_low = (u8) (cnt & 0xff);
-	}
-	if (rate_hi) {
+	if (rate_hi)
 		*rate_hi = (u8) ((cnt >> 8) & 0xff);
-	}
-	dbg ("%s - %d OK.", __func__, baud_rate);
-	return (KEYSPAN_BAUD_RATE_OK);
+	dbg("%s - %d OK.", __func__, baud_rate);
+	return KEYSPAN_BAUD_RATE_OK;
 }
 
 static int keyspan_usa26_send_setup(struct usb_serial *serial,
 				    struct usb_serial_port *port,
 				    int reset_port)
 {
-	struct keyspan_usa26_portControlMessage	msg;		
+	struct keyspan_usa26_portControlMessage	msg;
 	struct keyspan_serial_private 		*s_priv;
 	struct keyspan_port_private 		*p_priv;
 	const struct keyspan_device_details	*d_details;
@@ -1841,7 +1849,7 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 	struct urb				*this_urb;
 	int 					device_port, err;
 
-	dbg ("%s reset=%d", __func__, reset_port);
+	dbg("%s reset=%d", __func__, reset_port);
 
 	s_priv = usb_get_serial_data(serial);
 	p_priv = usb_get_serial_port_data(port);
@@ -1864,22 +1872,22 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 	if ((reset_port + 1) > p_priv->resend_cont)
 		p_priv->resend_cont = reset_port + 1;
 	if (this_urb->status == -EINPROGRESS) {
-		/*  dbg ("%s - already writing", __func__); */
+		/*  dbg("%s - already writing", __func__); */
 		mdelay(5);
-		return(-1);
+		return -1;
 	}
 
-	memset(&msg, 0, sizeof (struct keyspan_usa26_portControlMessage));
-	
-		/* Only set baud rate if it's changed */	
+	memset(&msg, 0, sizeof(struct keyspan_usa26_portControlMessage));
+
+	/* Only set baud rate if it's changed */
 	if (p_priv->old_baud != p_priv->baud) {
 		p_priv->old_baud = p_priv->baud;
 		msg.setClocking = 0xff;
 		if (d_details->calculate_baud_rate
 		    (p_priv->baud, d_details->baudclk, &msg.baudHi,
-		     &msg.baudLo, &msg.prescaler, device_port) == KEYSPAN_INVALID_BAUD_RATE ) {
-			dbg("%s - Invalid baud rate %d requested, using 9600.", __func__,
-			    p_priv->baud);
+		     &msg.baudLo, &msg.prescaler, device_port) == KEYSPAN_INVALID_BAUD_RATE) {
+			dbg("%s - Invalid baud rate %d requested, using 9600.",
+						__func__, p_priv->baud);
 			msg.baudLo = 0;
 			msg.baudHi = 125;	/* Values for 9600 baud */
 			msg.prescaler = 10;
@@ -1905,7 +1913,7 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
 		msg.lcr |= (p_priv->cflag & PARODD)?
-			USA_PARITY_ODD: USA_PARITY_EVEN;
+			USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	msg.setLcr = 0xff;
 
@@ -1946,7 +1954,7 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 
 	/* Sending intermediate configs */
 	else {
-		msg._txOn = (! p_priv->break_on);
+		msg._txOn = (!p_priv->break_on);
 		msg._txOff = 0;
 		msg.txFlush = 0;
 		msg.txBreak = (p_priv->break_on);
@@ -1958,23 +1966,23 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 		msg.resetDataToggle = 0x0;
 	}
 
-		/* Do handshaking outputs */	
+	/* Do handshaking outputs */
 	msg.setTxTriState_setRts = 0xff;
 	msg.txTriState_rts = p_priv->rts_state;
 
 	msg.setHskoa_setDtr = 0xff;
 	msg.hskoa_dtr = p_priv->dtr_state;
-		
+
 	p_priv->resend_cont = 0;
-	memcpy (this_urb->transfer_buffer, &msg, sizeof(msg));
-	
+	memcpy(this_urb->transfer_buffer, &msg, sizeof(msg));
+
 	/* send the data out the device on control endpoint */
 	this_urb->transfer_buffer_length = sizeof(msg);
 
 	this_urb->dev = serial->dev;
-	if ((err = usb_submit_urb(this_urb, GFP_ATOMIC)) != 0) {
+	err = usb_submit_urb(this_urb, GFP_ATOMIC);
+	if (err != 0)
 		dbg("%s - usb_submit_urb(setup) failed (%d)", __func__, err);
-	}
 #if 0
 	else {
 		dbg("%s - usb_submit_urb(%d) OK %d bytes (end %d)", __func__
@@ -1990,14 +1998,14 @@ static int keyspan_usa28_send_setup(struct usb_serial *serial,
 				    struct usb_serial_port *port,
 				    int reset_port)
 {
-	struct keyspan_usa28_portControlMessage	msg;		
+	struct keyspan_usa28_portControlMessage	msg;
 	struct keyspan_serial_private	 	*s_priv;
 	struct keyspan_port_private 		*p_priv;
 	const struct keyspan_device_details	*d_details;
 	struct urb				*this_urb;
 	int 					device_port, err;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	s_priv = usb_get_serial_data(serial);
 	p_priv = usb_get_serial_port_data(port);
@@ -2005,7 +2013,8 @@ static int keyspan_usa28_send_setup(struct usb_serial *serial,
 	device_port = port->number - port->serial->minor;
 
 	/* only do something if we have a bulk out endpoint */
-	if ((this_urb = p_priv->outcont_urb) == NULL) {
+	this_urb = p_priv->outcont_urb;
+	if (this_urb == NULL) {
 		dbg("%s - oops no urb.", __func__);
 		return -1;
 	}
@@ -2015,17 +2024,18 @@ static int keyspan_usa28_send_setup(struct usb_serial *serial,
 	if ((reset_port + 1) > p_priv->resend_cont)
 		p_priv->resend_cont = reset_port + 1;
 	if (this_urb->status == -EINPROGRESS) {
-		dbg ("%s already writing", __func__);
+		dbg("%s already writing", __func__);
 		mdelay(5);
-		return(-1);
+		return -1;
 	}
 
-	memset(&msg, 0, sizeof (struct keyspan_usa28_portControlMessage));
+	memset(&msg, 0, sizeof(struct keyspan_usa28_portControlMessage));
 
 	msg.setBaudRate = 1;
 	if (d_details->calculate_baud_rate(p_priv->baud, d_details->baudclk,
-		&msg.baudHi, &msg.baudLo, NULL, device_port) == KEYSPAN_INVALID_BAUD_RATE ) {
-		dbg("%s - Invalid baud rate requested %d.", __func__, p_priv->baud);
+		&msg.baudHi, &msg.baudLo, NULL, device_port) == KEYSPAN_INVALID_BAUD_RATE) {
+		dbg("%s - Invalid baud rate requested %d.",
+						__func__, p_priv->baud);
 		msg.baudLo = 0xff;
 		msg.baudHi = 0xb2;	/* Values for 9600 baud */
 	}
@@ -2036,7 +2046,7 @@ static int keyspan_usa28_send_setup(struct usb_serial *serial,
 	msg.ctsFlowControl = (p_priv->flow_control == flow_cts);
 	msg.xonFlowControl = 0;
 
-	/* Do handshaking outputs, DTR is inverted relative to RTS */	
+	/* Do handshaking outputs, DTR is inverted relative to RTS */
 	msg.rts = p_priv->rts_state;
 	msg.dtr = p_priv->dtr_state;
 
@@ -2078,7 +2088,7 @@ static int keyspan_usa28_send_setup(struct usb_serial *serial,
 	}
 	/* Sending intermediate configs */
 	else {
-		msg._txOn = (! p_priv->break_on);
+		msg._txOn = (!p_priv->break_on);
 		msg._txOff = 0;
 		msg.txFlush = 0;
 		msg.txForceXoff = 0;
@@ -2092,15 +2102,15 @@ static int keyspan_usa28_send_setup(struct usb_serial *serial,
 	}
 
 	p_priv->resend_cont = 0;
-	memcpy (this_urb->transfer_buffer, &msg, sizeof(msg));
+	memcpy(this_urb->transfer_buffer, &msg, sizeof(msg));
 
 	/* send the data out the device on control endpoint */
 	this_urb->transfer_buffer_length = sizeof(msg);
 
 	this_urb->dev = serial->dev;
-	if ((err = usb_submit_urb(this_urb, GFP_ATOMIC)) != 0) {
+	err = usb_submit_urb(this_urb, GFP_ATOMIC);
+	if (err != 0)
 		dbg("%s - usb_submit_urb(setup) failed", __func__);
-	}
 #if 0
 	else {
 		dbg("%s - usb_submit_urb(setup) OK %d bytes", __func__,
@@ -2123,7 +2133,7 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 	struct urb				*this_urb;
 	int 					err, device_port;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	s_priv = usb_get_serial_data(serial);
 	p_priv = usb_get_serial_port_data(port);
@@ -2134,7 +2144,9 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 	/* Work out which port within the device is being setup */
 	device_port = port->number - port->serial->minor;
 
-	dbg("%s - endpoint %d port %d (%d)",__func__, usb_pipeendpoint(this_urb->pipe), port->number, device_port);
+	dbg("%s - endpoint %d port %d (%d)",
+			__func__, usb_pipeendpoint(this_urb->pipe),
+			port->number, device_port);
 
 		/* Make sure we have an urb then send the message */
 	if (this_urb == NULL) {
@@ -2148,30 +2160,30 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 		p_priv->resend_cont = reset_port + 1;
 
 	if (this_urb->status == -EINPROGRESS) {
-		/*  dbg ("%s - already writing", __func__); */
+		/*  dbg("%s - already writing", __func__); */
 		mdelay(5);
-		return(-1);
+		return -1;
 	}
 
-	memset(&msg, 0, sizeof (struct keyspan_usa49_portControlMessage));
+	memset(&msg, 0, sizeof(struct keyspan_usa49_portControlMessage));
 
 	/*msg.portNumber = port->number;*/
 	msg.portNumber = device_port;
-	
-		/* Only set baud rate if it's changed */	
+
+	/* Only set baud rate if it's changed */
 	if (p_priv->old_baud != p_priv->baud) {
 		p_priv->old_baud = p_priv->baud;
 		msg.setClocking = 0xff;
 		if (d_details->calculate_baud_rate
 		    (p_priv->baud, d_details->baudclk, &msg.baudHi,
-		     &msg.baudLo, &msg.prescaler, device_port) == KEYSPAN_INVALID_BAUD_RATE ) {
-			dbg("%s - Invalid baud rate %d requested, using 9600.", __func__,
-			    p_priv->baud);
+		     &msg.baudLo, &msg.prescaler, device_port) == KEYSPAN_INVALID_BAUD_RATE) {
+			dbg("%s - Invalid baud rate %d requested, using 9600.",
+						__func__, p_priv->baud);
 			msg.baudLo = 0;
 			msg.baudHi = 125;	/* Values for 9600 baud */
 			msg.prescaler = 10;
 		}
-		//msg.setPrescaler = 0xff;
+		/* msg.setPrescaler = 0xff; */
 	}
 
 	msg.lcr = (p_priv->cflag & CSTOPB)? STOPBITS_678_2: STOPBITS_5678_1;
@@ -2192,19 +2204,19 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
 		msg.lcr |= (p_priv->cflag & PARODD)?
-			USA_PARITY_ODD: USA_PARITY_EVEN;
+			USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	msg.setLcr = 0xff;
 
 	msg.ctsFlowControl = (p_priv->flow_control == flow_cts);
 	msg.xonFlowControl = 0;
 	msg.setFlowControl = 0xff;
-	
+
 	msg.forwardingLength = 16;
 	msg.xonChar = 17;
 	msg.xoffChar = 19;
 
-	/* Opening port */ 
+	/* Opening port */
 	if (reset_port == 1) {
 		msg._txOn = 1;
 		msg._txOff = 0;
@@ -2236,7 +2248,7 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 	}
 	/* Sending intermediate configs */
 	else {
-		msg._txOn = (! p_priv->break_on);
+		msg._txOn = (!p_priv->break_on);
 		msg._txOff = 0;
 		msg.txFlush = 0;
 		msg.txBreak = (p_priv->break_on);
@@ -2250,16 +2262,17 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 		msg.disablePort = 0;
 	}
 
-		/* Do handshaking outputs */	
+	/* Do handshaking outputs */
 	msg.setRts = 0xff;
 	msg.rts = p_priv->rts_state;
 
 	msg.setDtr = 0xff;
 	msg.dtr = p_priv->dtr_state;
-		
+
 	p_priv->resend_cont = 0;
 
-	/* if the device is a 49wg, we send control message on usb control EP 0 */
+	/* if the device is a 49wg, we send control message on usb
+	   control EP 0 */
 
 	if (d_details->product_id == keyspan_usa49wg_product_id) {
 		dr = (void *)(s_priv->ctrl_buf);
@@ -2269,23 +2282,24 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 		dr->wIndex = 0;
 		dr->wLength = cpu_to_le16(sizeof(msg));
 
-		memcpy (s_priv->glocont_buf, &msg, sizeof(msg));
+		memcpy(s_priv->glocont_buf, &msg, sizeof(msg));
 
-		usb_fill_control_urb(this_urb, serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			     (unsigned char *)dr, s_priv->glocont_buf, sizeof(msg),
-			     usa49_glocont_callback, serial);
+		usb_fill_control_urb(this_urb, serial->dev,
+				usb_sndctrlpipe(serial->dev, 0),
+				(unsigned char *)dr, s_priv->glocont_buf,
+				sizeof(msg), usa49_glocont_callback, serial);
 
 	} else {
 		memcpy(this_urb->transfer_buffer, &msg, sizeof(msg));
-	
+
 		/* send the data out the device on control endpoint */
 		this_urb->transfer_buffer_length = sizeof(msg);
 
 		this_urb->dev = serial->dev;
 	}
-	if ((err = usb_submit_urb(this_urb, GFP_ATOMIC)) != 0) {
+	err = usb_submit_urb(this_urb, GFP_ATOMIC);
+	if (err != 0)
 		dbg("%s - usb_submit_urb(setup) failed (%d)", __func__, err);
-	}
 #if 0
 	else {
 		dbg("%s - usb_submit_urb(%d) OK %d bytes (end %d)", __func__,
@@ -2301,7 +2315,7 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 				    struct usb_serial_port *port,
 				    int reset_port)
 {
-	struct keyspan_usa90_portControlMessage	msg;		
+	struct keyspan_usa90_portControlMessage	msg;
 	struct keyspan_serial_private 		*s_priv;
 	struct keyspan_port_private 		*p_priv;
 	const struct keyspan_device_details	*d_details;
@@ -2309,14 +2323,15 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 	int 					err;
 	u8						prescaler;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	s_priv = usb_get_serial_data(serial);
 	p_priv = usb_get_serial_port_data(port);
 	d_details = s_priv->device_details;
 
 	/* only do something if we have a bulk out endpoint */
-	if ((this_urb = p_priv->outcont_urb) == NULL) {
+	this_urb = p_priv->outcont_urb;
+	if (this_urb == NULL) {
 		dbg("%s - oops no urb.", __func__);
 		return -1;
 	}
@@ -2326,24 +2341,24 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 	if ((reset_port + 1) > p_priv->resend_cont)
 		p_priv->resend_cont = reset_port + 1;
 	if (this_urb->status == -EINPROGRESS) {
-		dbg ("%s already writing", __func__);
+		dbg("%s already writing", __func__);
 		mdelay(5);
-		return(-1);
+		return -1;
 	}
 
-	memset(&msg, 0, sizeof (struct keyspan_usa90_portControlMessage));
+	memset(&msg, 0, sizeof(struct keyspan_usa90_portControlMessage));
 
-	/* Only set baud rate if it's changed */	
+	/* Only set baud rate if it's changed */
 	if (p_priv->old_baud != p_priv->baud) {
 		p_priv->old_baud = p_priv->baud;
 		msg.setClocking = 0x01;
 		if (d_details->calculate_baud_rate
 		    (p_priv->baud, d_details->baudclk, &msg.baudHi,
-		     &msg.baudLo, &prescaler, 0) == KEYSPAN_INVALID_BAUD_RATE ) {
-			dbg("%s - Invalid baud rate %d requested, using 9600.", __func__,
-			    p_priv->baud);
+		     &msg.baudLo, &prescaler, 0) == KEYSPAN_INVALID_BAUD_RATE) {
+			dbg("%s - Invalid baud rate %d requested, using 9600.",
+						__func__, p_priv->baud);
 			p_priv->baud = 9600;
-			d_details->calculate_baud_rate (p_priv->baud, d_details->baudclk, 
+			d_details->calculate_baud_rate(p_priv->baud, d_details->baudclk,
 				&msg.baudHi, &msg.baudLo, &prescaler, 0);
 		}
 		msg.setRxMode = 1;
@@ -2351,13 +2366,10 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 	}
 
 	/* modes must always be correctly specified */
-	if (p_priv->baud > 57600)
-	{
+	if (p_priv->baud > 57600) {
 		msg.rxMode = RXMODE_DMA;
 		msg.txMode = TXMODE_DMA;
-	}
-	else
-	{
+	} else {
 		msg.rxMode = RXMODE_BYHAND;
 		msg.txMode = TXMODE_BYHAND;
 	}
@@ -2380,7 +2392,7 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
 		msg.lcr |= (p_priv->cflag & PARODD)?
-			USA_PARITY_ODD: USA_PARITY_EVEN;
+			USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	if (p_priv->old_cflag != p_priv->cflag) {
 		p_priv->old_cflag = p_priv->cflag;
@@ -2391,23 +2403,22 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 		msg.txFlowControl = TXFLOW_CTS;
 	msg.setTxFlowControl = 0x01;
 	msg.setRxFlowControl = 0x01;
-	
+
 	msg.rxForwardingLength = 16;
-	msg.rxForwardingTimeout = 16;	
+	msg.rxForwardingTimeout = 16;
 	msg.txAckSetting = 0;
 	msg.xonChar = 17;
 	msg.xoffChar = 19;
 
-	/* Opening port */ 
+	/* Opening port */
 	if (reset_port == 1) {
 		msg.portEnabled = 1;
 		msg.rxFlush = 1;
 		msg.txBreak = (p_priv->break_on);
 	}
 	/* Closing port */
-	else if (reset_port == 2) {
+	else if (reset_port == 2)
 		msg.portEnabled = 0;
-	}
 	/* Sending intermediate configs */
 	else {
 		if (port->port.count)
@@ -2415,23 +2426,23 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 		msg.txBreak = (p_priv->break_on);
 	}
 
-	/* Do handshaking outputs */	
+	/* Do handshaking outputs */
 	msg.setRts = 0x01;
 	msg.rts = p_priv->rts_state;
 
 	msg.setDtr = 0x01;
 	msg.dtr = p_priv->dtr_state;
-		
+
 	p_priv->resend_cont = 0;
-	memcpy (this_urb->transfer_buffer, &msg, sizeof(msg));
-	
+	memcpy(this_urb->transfer_buffer, &msg, sizeof(msg));
+
 	/* send the data out the device on control endpoint */
 	this_urb->transfer_buffer_length = sizeof(msg);
 
 	this_urb->dev = serial->dev;
-	if ((err = usb_submit_urb(this_urb, GFP_ATOMIC)) != 0) {
+	err = usb_submit_urb(this_urb, GFP_ATOMIC);
+	if (err != 0)
 		dbg("%s - usb_submit_urb(setup) failed (%d)", __func__, err);
-	}
 	return 0;
 }
 
@@ -2446,7 +2457,7 @@ static int keyspan_usa67_send_setup(struct usb_serial *serial,
 	struct urb				*this_urb;
 	int 					err, device_port;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	s_priv = usb_get_serial_data(serial);
 	p_priv = usb_get_serial_port_data(port);
@@ -2469,9 +2480,9 @@ static int keyspan_usa67_send_setup(struct usb_serial *serial,
 	if ((reset_port + 1) > p_priv->resend_cont)
 		p_priv->resend_cont = reset_port + 1;
 	if (this_urb->status == -EINPROGRESS) {
-		/*  dbg ("%s - already writing", __func__); */
+		/*  dbg("%s - already writing", __func__); */
 		mdelay(5);
-		return(-1);
+		return -1;
 	}
 
 	memset(&msg, 0, sizeof(struct keyspan_usa67_portControlMessage));
@@ -2484,9 +2495,9 @@ static int keyspan_usa67_send_setup(struct usb_serial *serial,
 		msg.setClocking = 0xff;
 		if (d_details->calculate_baud_rate
 		    (p_priv->baud, d_details->baudclk, &msg.baudHi,
-		     &msg.baudLo, &msg.prescaler, device_port) == KEYSPAN_INVALID_BAUD_RATE ) {
-			dbg("%s - Invalid baud rate %d requested, using 9600.", __func__,
-			    p_priv->baud);
+		     &msg.baudLo, &msg.prescaler, device_port) == KEYSPAN_INVALID_BAUD_RATE) {
+			dbg("%s - Invalid baud rate %d requested, using 9600.",
+						__func__, p_priv->baud);
 			msg.baudLo = 0;
 			msg.baudHi = 125;	/* Values for 9600 baud */
 			msg.prescaler = 10;
@@ -2512,7 +2523,7 @@ static int keyspan_usa67_send_setup(struct usb_serial *serial,
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
 		msg.lcr |= (p_priv->cflag & PARODD)?
-			USA_PARITY_ODD: USA_PARITY_EVEN;
+					USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	msg.setLcr = 0xff;
 
@@ -2549,7 +2560,7 @@ static int keyspan_usa67_send_setup(struct usb_serial *serial,
 		msg.resetDataToggle = 0;
 	} else {
 		/* Sending intermediate configs */
-		msg._txOn = (! p_priv->break_on);
+		msg._txOn = (!p_priv->break_on);
 		msg._txOff = 0;
 		msg.txFlush = 0;
 		msg.txBreak = (p_priv->break_on);
@@ -2589,7 +2600,7 @@ static void keyspan_send_setup(struct usb_serial_port *port, int reset_port)
 	struct keyspan_serial_private *s_priv;
 	const struct keyspan_device_details *d_details;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	s_priv = usb_get_serial_data(serial);
 	d_details = s_priv->device_details;
@@ -2616,7 +2627,7 @@ static void keyspan_send_setup(struct usb_serial_port *port, int reset_port)
 
 /* Gets called by the "real" driver (ie once firmware is loaded
    and renumeration has taken place. */
-static int keyspan_startup (struct usb_serial *serial)
+static int keyspan_startup(struct usb_serial *serial)
 {
 	int				i, err;
 	struct usb_serial_port		*port;
@@ -2627,17 +2638,20 @@ static int keyspan_startup (struct usb_serial *serial)
 	dbg("%s", __func__);
 
 	for (i = 0; (d_details = keyspan_devices[i]) != NULL; ++i)
-		if (d_details->product_id == le16_to_cpu(serial->dev->descriptor.idProduct))
+		if (d_details->product_id ==
+				le16_to_cpu(serial->dev->descriptor.idProduct))
 			break;
 	if (d_details == NULL) {
-		dev_err(&serial->dev->dev, "%s - unknown product id %x\n", __func__, le16_to_cpu(serial->dev->descriptor.idProduct));
+		dev_err(&serial->dev->dev, "%s - unknown product id %x\n",
+		    __func__, le16_to_cpu(serial->dev->descriptor.idProduct));
 		return 1;
 	}
 
 	/* Setup private data for serial driver */
 	s_priv = kzalloc(sizeof(struct keyspan_serial_private), GFP_KERNEL);
 	if (!s_priv) {
-		dbg("%s - kmalloc for keyspan_serial_private failed.", __func__);
+		dbg("%s - kmalloc for keyspan_serial_private failed.",
+								__func__);
 		return -ENOMEM;
 	}
 
@@ -2647,10 +2661,11 @@ static int keyspan_startup (struct usb_serial *serial)
 	/* Now setup per port private data */
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
-		p_priv = kzalloc(sizeof(struct keyspan_port_private), GFP_KERNEL);
+		p_priv = kzalloc(sizeof(struct keyspan_port_private),
+								GFP_KERNEL);
 		if (!p_priv) {
 			dbg("%s - kmalloc for keyspan_port_private (%d) failed!.", __func__, i);
-			return (1);
+			return 1;
 		}
 		p_priv->device_details = d_details;
 		usb_set_serial_port_data(port, p_priv);
@@ -2672,11 +2687,11 @@ static int keyspan_startup (struct usb_serial *serial)
 			dbg("%s - submit indat urb failed %d", __func__,
 				err);
 	}
-			
+
 	return 0;
 }
 
-static void keyspan_shutdown (struct usb_serial *serial)
+static void keyspan_shutdown(struct usb_serial *serial)
 {
 	int				i, j;
 	struct usb_serial_port		*port;
@@ -2728,8 +2743,8 @@ static void keyspan_shutdown (struct usb_serial *serial)
 	}
 }
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);

