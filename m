Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbZITUSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbZITUSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 16:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZITUSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 16:18:38 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:57353 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZITUSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 16:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:bcc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h2f9eFJymiFzuJVCLfptPjMVqPC5F1iBcbzAcVotLfk8vNbztquj2+8e1x0l/shg3N
         +UPhSDBSsVWpodxamg8qEqqSvE7hftcAZG9n5tjdjdhCqyVBleNKd11ggx1WHq3vewVS
         0jiG9cHCJ+1Ib60/oMzNmhDh0Mj0tOAF32Nig=
Date: Sun, 20 Sep 2009 22:18:36 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb@vger.kernel.org,
       e9hack <e9hack@googlemail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: serial: Fix read regression in 2.6.31.
Message-ID: <20090920201836.GA5602@localhost>
References: <Pine.LNX.4.44L0.0909191217430.15223-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0909191217430.15223-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ASYNCB_INITIALIZED to determine when to stop reading.

Port count can no longer be used to determine when to stop reading from
the device as it can be zero when the first read callbacks are made (see
tty_port_block_til_read where port count is temporarily decremented
during serial_open).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

Hi, 

Here's a patch which fixes the port count issue for all drivers. I only
have access to an ftdi device at the moment so that's the only driver
I've been able to test (against latest git with latest patches from
Greg's tree). 

Regards,
Johan


 drivers/usb/serial/aircable.c        |    5 +++--
 drivers/usb/serial/cypress_m8.c      |    3 ++-
 drivers/usb/serial/digi_acceleport.c |    8 +++++---
 drivers/usb/serial/ftdi_sio.c        |    8 ++++----
 drivers/usb/serial/generic.c         |    3 ++-
 drivers/usb/serial/ir-usb.c          |    3 ++-
 drivers/usb/serial/keyspan.c         |   24 ++++++++++++++----------
 drivers/usb/serial/opticon.c         |    2 +-
 drivers/usb/serial/option.c          |    4 +++-
 drivers/usb/serial/oti6858.c         |    4 ++--
 drivers/usb/serial/pl2303.c          |    4 ++--
 drivers/usb/serial/sierra.c          |    7 +++++--
 drivers/usb/serial/spcp8x5.c         |    5 +++--
 13 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/serial/aircable.c b/drivers/usb/serial/aircable.c
index 2cbfab3..edba62f 100644
--- a/drivers/usb/serial/aircable.c
+++ b/drivers/usb/serial/aircable.c
@@ -42,6 +42,7 @@
  *
  */
 
+#include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/circ_buf.h>
@@ -468,7 +469,7 @@ static void aircable_read_bulk_callback(struct urb *urb)
 
 	if (status) {
 		dbg("%s - urb status = %d", __func__, status);
-		if (!port->port.count) {
+		if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 			dbg("%s - port is closed, exiting.", __func__);
 			return;
 		}
@@ -531,7 +532,7 @@ static void aircable_read_bulk_callback(struct urb *urb)
 	tty_kref_put(tty);
 
 	/* Schedule the next read _if_ we are still open */
-	if (port->port.count) {
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		usb_fill_bulk_urb(port->read_urb, port->serial->dev,
 				  usb_rcvbulkpipe(port->serial->dev,
 					  port->bulk_in_endpointAddress),
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index e0a8b71..c683a10 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -1329,7 +1329,8 @@ continue_read:
 
 	/* Continue trying to always read... unless the port has closed. */
 
-	if (port->port.count > 0 && priv->comm_is_ok) {
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags) &&
+			priv->comm_is_ok) {
 		usb_fill_int_urb(port->interrupt_in_urb, port->serial->dev,
 				usb_rcvintpipe(port->serial->dev,
 					port->interrupt_in_endpointAddress),
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index ab3dd99..9259d38 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -244,6 +244,7 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/wait.h>
+#include <linux/serial.h>
 #include <linux/usb/serial.h>
 
 /* Defines */
@@ -1265,7 +1266,8 @@ static void digi_write_bulk_callback(struct urb *urb)
 	/* try to send any buffered data on this port, if it is open */
 	spin_lock(&priv->dp_port_lock);
 	priv->dp_write_urb_in_use = 0;
-	if (port->port.count && priv->dp_out_buf_len > 0) {
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags) &&
+			priv->dp_out_buf_len > 0) {
 		*((unsigned char *)(port->write_urb->transfer_buffer))
 			= (unsigned char)DIGI_CMD_SEND_DATA;
 		*((unsigned char *)(port->write_urb->transfer_buffer) + 1)
@@ -1663,7 +1665,7 @@ static int digi_read_inb_callback(struct urb *urb)
 
 	/* do not process callbacks on closed ports */
 	/* but do continue the read chain */
-	if (port->port.count == 0)
+	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 		return 0;
 
 	/* short/multiple packet check */
@@ -1776,7 +1778,7 @@ static int digi_read_oob_callback(struct urb *urb)
 
 		tty = tty_port_tty_get(&port->port);
 		rts = 0;
-		if (port->port.count)
+		if (test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 			rts = tty->termios->c_cflag & CRTSCTS;
 		
 		if (opcode == DIGI_CMD_READ_INPUT_SIGNALS) {
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 4f883b1..7eaea14 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2033,7 +2033,7 @@ static void ftdi_read_bulk_callback(struct urb *urb)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (port->port.count <= 0)
+	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 		return;
 
 	tty = tty_port_tty_get(&port->port);
@@ -2089,7 +2089,7 @@ static void ftdi_process_read(struct work_struct *work)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (port->port.count <= 0)
+	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 		return;
 
 	tty = tty_port_tty_get(&port->port);
@@ -2247,7 +2247,7 @@ static void ftdi_process_read(struct work_struct *work)
 		}
 		spin_unlock_irqrestore(&priv->rx_lock, flags);
 		/* if the port is closed stop trying to read */
-		if (port->port.count > 0)
+		if (test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 			/* delay processing of remainder */
 			schedule_delayed_work(&priv->rx_work, 1);
 		else
@@ -2259,7 +2259,7 @@ static void ftdi_process_read(struct work_struct *work)
 	priv->rx_processed = 0;
 
 	/* if the port is closed stop trying to read */
-	if (port->port.count > 0) {
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		/* Continue trying to always read  */
 		usb_fill_bulk_urb(port->read_urb, port->serial->dev,
 			usb_rcvbulkpipe(port->serial->dev,
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index deba08c..4aa2eb4 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/usb.h>
+#include <linux/serial.h>
 #include <linux/usb/serial.h>
 #include <linux/uaccess.h>
 #include <linux/kfifo.h>
@@ -583,7 +584,7 @@ int usb_serial_generic_resume(struct usb_serial *serial)
 
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
-		if (!port->port.count)
+		if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 			continue;
 
 		if (port->read_urb) {
diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index 95d8d26..694fe31 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -65,6 +65,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
+#include <linux/serial.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include <linux/usb/irda.h>
@@ -445,7 +446,7 @@ static void ir_read_bulk_callback(struct urb *urb)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (!port->port.count) {
+	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		dbg("%s - port closed.", __func__);
 		return;
 	}
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index f8c4b07..3193f3e 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -108,6 +108,7 @@
 #include <linux/firmware.h>
 #include <linux/ihex.h>
 #include <linux/uaccess.h>
+#include <linux/serial.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include "keyspan.h"
@@ -464,7 +465,7 @@ static void	usa26_indat_callback(struct urb *urb)
 
 	/* Resubmit urb so we continue receiving */
 	urb->dev = port->serial->dev;
-	if (port->port.count) {
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		err = usb_submit_urb(urb, GFP_ATOMIC);
 		if (err != 0)
 			dbg("%s - resubmit read urb failed. (%d)",
@@ -483,7 +484,7 @@ static void	usa2x_outdat_callback(struct urb *urb)
 	p_priv = usb_get_serial_port_data(port);
 	dbg("%s - urb %d", __func__, urb == p_priv->out_urbs[1]);
 
-	if (port->port.count)
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 		usb_serial_port_softint(port);
 }
 
@@ -615,7 +616,7 @@ static void usa28_indat_callback(struct urb *urb)
 
 		/* Resubmit urb so we continue receiving */
 		urb->dev = port->serial->dev;
-		if (port->port.count) {
+		if (test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 			err = usb_submit_urb(urb, GFP_ATOMIC);
 			if (err != 0)
 				dbg("%s - resubmit read urb failed. (%d)",
@@ -856,7 +857,7 @@ static void	usa49_indat_callback(struct urb *urb)
 
 	/* Resubmit urb so we continue receiving */
 	urb->dev = port->serial->dev;
-	if (port->port.count) {
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		err = usb_submit_urb(urb, GFP_ATOMIC);
 		if (err != 0)
 			dbg("%s - resubmit read urb failed. (%d)",
@@ -904,10 +905,11 @@ static void usa49wg_indat_callback(struct urb *urb)
 				/* no error on any byte */
 				i++;
 				for (x = 1; x < len ; ++x)
-					if (port->port.count)
+					if (test_bit(ASYNCB_INITIALIZED,
+							&port->port.flags)) {
 						tty_insert_flip_char(tty,
 								data[i++], 0);
-					else
+					} else
 						i++;
 			} else {
 				/*
@@ -922,13 +924,15 @@ static void usa49wg_indat_callback(struct urb *urb)
 					if (stat & RXERROR_PARITY)
 						flag |= TTY_PARITY;
 					/* XXX should handle break (0x10) */
-					if (port->port.count)
+					if (test_bit(ASYNCB_INITIALIZED,
+							&port->port.flags)) {
 						tty_insert_flip_char(tty,
 							data[i+1], flag);
+					}
 					i += 2;
 				}
 			}
-			if (port->port.count)
+			if (test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 				tty_flip_buffer_push(tty);
 			tty_kref_put(tty);
 		}
@@ -1013,7 +1017,7 @@ static void usa90_indat_callback(struct urb *urb)
 
 	/* Resubmit urb so we continue receiving */
 	urb->dev = port->serial->dev;
-	if (port->port.count) {
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		err = usb_submit_urb(urb, GFP_ATOMIC);
 		if (err != 0)
 			dbg("%s - resubmit read urb failed. (%d)",
@@ -2418,7 +2422,7 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 		msg.portEnabled = 0;
 	/* Sending intermediate configs */
 	else {
-		if (port->port.count)
+		if (test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 			msg.portEnabled = 1;
 		msg.txBreak = (p_priv->break_on);
 	}
diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 1085a57..1aa6593 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -499,7 +499,7 @@ static int opticon_resume(struct usb_interface *intf)
 	int result;
 
 	mutex_lock(&port->mutex);
-	if (port->port.count)
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 		result = usb_submit_urb(priv->bulk_read_urb, GFP_NOIO);
 	else
 		result = 0;
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index f66e398..63c3c7e 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -39,6 +39,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/serial.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
@@ -868,7 +869,8 @@ static void option_indat_callback(struct urb *urb)
 		tty_kref_put(tty);
 
 		/* Resubmit urb so we continue receiving */
-		if (port->port.count && status != -ESHUTDOWN) {
+		if (test_bit(ASYNCB_INITIALIZED, &port->port.flags) &&
+				status != -ESHUTDOWN) {
 			err = usb_submit_urb(urb, GFP_ATOMIC);
 			if (err)
 				printk(KERN_ERR "%s: resubmit read urb failed. "
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index 0f4a70c..d21d4cc 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -927,7 +927,7 @@ static void oti6858_read_bulk_callback(struct urb *urb)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (status != 0) {
-		if (!port->port.count) {
+		if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 			dbg("%s(): port is closed, exiting", __func__);
 			return;
 		}
@@ -955,7 +955,7 @@ static void oti6858_read_bulk_callback(struct urb *urb)
 	tty_kref_put(tty);
 
 	/* schedule the interrupt urb if we are still open */
-	if (port->port.count != 0) {
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		port->interrupt_in_urb->dev = port->serial->dev;
 		result = usb_submit_urb(port->interrupt_in_urb, GFP_ATOMIC);
 		if (result != 0) {
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 1128e01..2c3fc74 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -1070,7 +1070,7 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 
 	if (status) {
 		dbg("%s - urb status = %d", __func__, status);
-		if (!port->port.count) {
+		if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 			dbg("%s - port is closed, exiting.", __func__);
 			return;
 		}
@@ -1106,7 +1106,7 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 	}
 	tty_kref_put(tty);
 	/* Schedule the next read _if_ we are still open */
-	if (port->port.count) {
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		urb->dev = port->serial->dev;
 		result = usb_submit_urb(urb, GFP_ATOMIC);
 		if (result)
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 68fa0e4..9f4b43a 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -27,6 +27,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/module.h>
+#include <linux/serial.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
@@ -578,7 +579,8 @@ static void sierra_indat_callback(struct urb *urb)
 	}
 
 	/* Resubmit urb so we continue receiving */
-	if (port->port.count && status != -ESHUTDOWN && status != -EPERM) {
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags) &&
+			status != -ESHUTDOWN && status != -EPERM) {
 		usb_mark_last_busy(port->serial->dev);
 		err = usb_submit_urb(urb, GFP_ATOMIC);
 		if (err)
@@ -640,7 +642,8 @@ static void sierra_instat_callback(struct urb *urb)
 		dev_dbg(&port->dev, "%s: error %d\n", __func__, status);
 
 	/* Resubmit urb so we continue receiving IRQ data */
-	if (port->port.count && status != -ESHUTDOWN && status != -ENOENT) {
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags) &&
+			status != -ESHUTDOWN && status != -ENOENT) {
 		usb_mark_last_busy(serial->dev);
 		urb->dev = serial->dev;
 		err = usb_submit_urb(urb, GFP_ATOMIC);
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 61e7c40..43d54d1 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -23,6 +23,7 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
 #include <linux/module.h>
+#include <linux/serial.h>
 #include <linux/spinlock.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
@@ -687,7 +688,7 @@ static void spcp8x5_read_bulk_callback(struct urb *urb)
 
 	/* check the urb status */
 	if (result) {
-		if (!port->port.count)
+		if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 			return;
 		if (result == -EPROTO) {
 			/* spcp8x5 mysteriously fails with -EPROTO */
@@ -737,7 +738,7 @@ static void spcp8x5_read_bulk_callback(struct urb *urb)
 	tty_kref_put(tty);
 
 	/* Schedule the next read _if_ we are still open */
-	if (port->port.count) {
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		urb->dev = port->serial->dev;
 		result = usb_submit_urb(urb , GFP_ATOMIC);
 		if (result)
-- 
1.6.4.2

