Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab0BQNat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:30:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38581 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932921Ab0BQNaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:30:46 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/5] tty: Prune uses of tty_request_room in the USB layer
To: greg@kroah.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Date: Wed, 17 Feb 2010 13:06:48 +0000
Message-ID: <20100217130636.16008.79497.stgit@localhost.localdomain>
In-Reply-To: <20100217130604.16008.86393.stgit@localhost.localdomain>
References: <20100217130604.16008.86393.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have lots of callers that do not need to do this in the first place.
Remove the calls as they both cost CPU and for big buffers can mess up the
multi-page allocation avoidance.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/serial/ark3116.c          |    1 -
 drivers/usb/serial/cyberjack.c        |    1 -
 drivers/usb/serial/cypress_m8.c       |   10 +++-------
 drivers/usb/serial/digi_acceleport.c  |   13 ++-----------
 drivers/usb/serial/empeg.c            |    1 -
 drivers/usb/serial/garmin_gps.c       |    1 -
 drivers/usb/serial/io_edgeport.c      |   19 +++++++------------
 drivers/usb/serial/io_ti.c            |    1 -
 drivers/usb/serial/ipaq.c             |    1 -
 drivers/usb/serial/ipw.c              |    1 -
 drivers/usb/serial/ir-usb.c           |    6 ++----
 drivers/usb/serial/kl5kusb105.c       |    1 -
 drivers/usb/serial/kobil_sct.c        |    1 -
 drivers/usb/serial/mos7720.c          |    1 -
 drivers/usb/serial/mos7840.c          |    1 -
 drivers/usb/serial/navman.c           |    1 -
 drivers/usb/serial/opticon.c          |   11 +++--------
 drivers/usb/serial/option.c           |    1 -
 drivers/usb/serial/pl2303.c           |    1 -
 drivers/usb/serial/sierra.c           |    1 -
 drivers/usb/serial/spcp8x5.c          |    6 ++----
 drivers/usb/serial/symbolserial.c     |   10 ++--------
 drivers/usb/serial/ti_usb_3410_5052.c |    3 +--
 drivers/usb/serial/visor.c            |   10 +++-------
 24 files changed, 25 insertions(+), 78 deletions(-)


diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index 1f75fac..547c944 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -733,7 +733,6 @@ static void ark3116_read_bulk_callback(struct urb *urb)
 
 		tty = tty_port_tty_get(&port->port);
 		if (tty) {
-			tty_buffer_request_room(tty, urb->actual_length + 1);
 			/* overrun is special, not associated with a char */
 			if (unlikely(lsr & UART_LSR_OE))
 				tty_insert_flip_char(tty, 0, TTY_OVERRUN);
diff --git a/drivers/usb/serial/cyberjack.c b/drivers/usb/serial/cyberjack.c
index 23c8bd6..ba4ae6c 100644
--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -395,7 +395,6 @@ static void cyberjack_read_bulk_callback(struct urb *urb)
 		return;
 	}
 	if (urb->actual_length) {
-		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 3370dc4..47c5a0d 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -1307,13 +1307,9 @@ static void cypress_read_int_callback(struct urb *urb)
 		spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* process read if there is data other than line status */
-	if (tty && (bytes > i)) {
-		bytes = tty_buffer_request_room(tty, bytes);
-		for (; i < bytes ; ++i) {
-			dbg("pushing byte number %d - %d - %c", i, data[i],
-					data[i]);
-			tty_insert_flip_char(tty, data[i], tty_flag);
-		}
+	if (tty && bytes > i) {
+		tty_insert_flip_string_fixed_flag(tty, data + i,
+				bytes - i, tty_flag);
 		tty_flip_buffer_push(tty);
 	}
 
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 3b63484..3817228 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -1658,7 +1658,6 @@ static int digi_read_inb_callback(struct urb *urb)
 	int port_status = ((unsigned char *)urb->transfer_buffer)[2];
 	unsigned char *data = ((unsigned char *)urb->transfer_buffer) + 3;
 	int flag, throttled;
-	int i;
 	int status = urb->status;
 
 	/* do not process callbacks on closed ports */
@@ -1705,17 +1704,9 @@ static int digi_read_inb_callback(struct urb *urb)
 
 		/* data length is len-1 (one byte of len is port_status) */
 		--len;
-
-		len = tty_buffer_request_room(tty, len);
 		if (len > 0) {
-			/* Hot path */
-			if (flag == TTY_NORMAL)
-				tty_insert_flip_string(tty, data, len);
-			else {
-				for (i = 0; i < len; i++)
-					tty_insert_flip_char(tty,
-								data[i], flag);
-			}
+			tty_insert_flip_string_fixed_flag(tty, data, len,
+									flag);
 			tty_flip_buffer_push(tty);
 		}
 	}
diff --git a/drivers/usb/serial/empeg.c b/drivers/usb/serial/empeg.c
index d02e604..5f740a1 100644
--- a/drivers/usb/serial/empeg.c
+++ b/drivers/usb/serial/empeg.c
@@ -346,7 +346,6 @@ static void empeg_read_bulk_callback(struct urb *urb)
 	tty = tty_port_tty_get(&port->port);
 
 	if (urb->actual_length) {
-		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 		bytes_in += urb->actual_length;
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index 6bbedfb..a42b29a 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -271,7 +271,6 @@ static void send_to_tty(struct usb_serial_port *port,
 		usb_serial_debug_data(debug, &port->dev,
 					__func__, actual_length, data);
 
-		tty_buffer_request_room(tty, actual_length);
 		tty_insert_flip_string(tty, data, actual_length);
 		tty_flip_buffer_push(tty);
 	}
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 1467755..e40ec6d 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -2055,18 +2055,13 @@ static void edge_tty_recv(struct device *dev, struct tty_struct *tty,
 {
 	int cnt;
 
-	do {
-		cnt = tty_buffer_request_room(tty, length);
-		if (cnt < length) {
-			dev_err(dev, "%s - dropping data, %d bytes lost\n",
-					__func__, length - cnt);
-			if (cnt == 0)
-				break;
-		}
-		tty_insert_flip_string(tty, data, cnt);
-		data += cnt;
-		length -= cnt;
-	} while (length > 0);
+	cnt = tty_insert_flip_string(tty, data, length);
+	if (cnt < length) {
+		dev_err(dev, "%s - dropping data, %d bytes lost\n",
+				__func__, length - cnt);
+	}
+	data += cnt;
+	length -= cnt;
 
 	tty_flip_buffer_push(tty);
 }
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 8f0aa64..b84befa 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -1820,7 +1820,6 @@ static void edge_tty_recv(struct device *dev, struct tty_struct *tty,
 {
 	int queued;
 
-	tty_buffer_request_room(tty, length);
 	queued = tty_insert_flip_string(tty, data, length);
 	if (queued < length)
 		dev_err(dev, "%s - dropping data, %d bytes lost\n",
diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
index d6231c3..3fea929 100644
--- a/drivers/usb/serial/ipaq.c
+++ b/drivers/usb/serial/ipaq.c
@@ -747,7 +747,6 @@ static void ipaq_read_bulk_callback(struct urb *urb)
 
 	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
-		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 		bytes_in += urb->actual_length;
diff --git a/drivers/usb/serial/ipw.c b/drivers/usb/serial/ipw.c
index c0afa7a..e1d0784 100644
--- a/drivers/usb/serial/ipw.c
+++ b/drivers/usb/serial/ipw.c
@@ -172,7 +172,6 @@ static void ipw_read_bulk_callback(struct urb *urb)
 
 	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
-		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index fc2ab81..c3e5d50 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -462,10 +462,8 @@ static void ir_read_bulk_callback(struct urb *urb)
 		usb_serial_debug_data(debug, &port->dev, __func__,
 						urb->actual_length, data);
 		tty = tty_port_tty_get(&port->port);
-		if (tty_buffer_request_room(tty, urb->actual_length - 1)) {
-			tty_insert_flip_string(tty, data+1, urb->actual_length - 1);
-			tty_flip_buffer_push(tty);
-		}
+		tty_insert_flip_string(tty, data+1, urb->actual_length - 1);
+		tty_flip_buffer_push(tty);
 		tty_kref_put(tty);
 
 		/*
diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index 2dbe22a..8eef91b 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -699,7 +699,6 @@ static void klsi_105_read_bulk_callback(struct urb *urb)
 			bytes_sent = urb->actual_length - 2;
 		}
 
-		tty_buffer_request_room(tty, bytes_sent);
 		tty_insert_flip_string(tty, data + 2, bytes_sent);
 		tty_flip_buffer_push(tty);
 		tty_kref_put(tty);
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index fc78553..c113a2a 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -388,7 +388,6 @@ static void kobil_read_int_callback(struct urb *urb)
 		*/
 		/* END DEBUG */
 
-		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index e0aa031..900cfb8 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -290,7 +290,6 @@ static void mos7720_bulk_in_callback(struct urb *urb)
 
 	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
-		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index c89a89c..2fda1c0 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -764,7 +764,6 @@ static void mos7840_bulk_in_callback(struct urb *urb)
 	if (urb->actual_length) {
 		tty = tty_port_tty_get(&mos7840_port->port->port);
 		if (tty) {
-			tty_buffer_request_room(tty, urb->actual_length);
 			tty_insert_flip_string(tty, data, urb->actual_length);
 			dbg(" %s ", data);
 			tty_flip_buffer_push(tty);
diff --git a/drivers/usb/serial/navman.c b/drivers/usb/serial/navman.c
index efa61bc..04a6cbb 100644
--- a/drivers/usb/serial/navman.c
+++ b/drivers/usb/serial/navman.c
@@ -66,7 +66,6 @@ static void navman_read_int_callback(struct urb *urb)
 
 	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
-		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 05b3ac4..4972197 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -55,7 +55,6 @@ static void opticon_bulk_callback(struct urb *urb)
 	int status = urb->status;
 	struct tty_struct *tty;
 	int result;
-	int available_room = 0;
 	int data_length;
 
 	dbg("%s - port %d", __func__, port->number);
@@ -96,13 +95,9 @@ static void opticon_bulk_callback(struct urb *urb)
 			/* real data, send it to the tty layer */
 			tty = tty_port_tty_get(&port->port);
 			if (tty) {
-				available_room = tty_buffer_request_room(tty,
-								data_length);
-				if (available_room) {
-					tty_insert_flip_string(tty, data,
-							       available_room);
-					tty_flip_buffer_push(tty);
-				}
+				tty_insert_flip_string(tty, data,
+							       data_length);
+				tty_flip_buffer_push(tty);
 				tty_kref_put(tty);
 			}
 		} else {
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 51b0beb..ea92a6a 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -964,7 +964,6 @@ static void option_indat_callback(struct urb *urb)
 	} else {
 		tty = tty_port_tty_get(&port->port);
 		if (urb->actual_length) {
-			tty_buffer_request_room(tty, urb->actual_length);
 			tty_insert_flip_string(tty, data, urb->actual_length);
 			tty_flip_buffer_push(tty);
 		} else 
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 767000c..a3e5a56 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -1042,7 +1042,6 @@ static void pl2303_push_data(struct tty_struct *tty,
 		tty_flag = TTY_FRAME;
 	dbg("%s - tty_flag = %d", __func__, tty_flag);
 
-	tty_buffer_request_room(tty, urb->actual_length + 1);
 	/* overrun is special, not associated with a char */
 	if (line_status & UART_OVERRUN_ERROR)
 		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index bb0d56c..9ff8c65 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -605,7 +605,6 @@ static void sierra_indat_callback(struct urb *urb)
 		if (urb->actual_length) {
 			tty = tty_port_tty_get(&port->port);
 
-			tty_buffer_request_room(tty, urb->actual_length);
 			tty_insert_flip_string(tty, data, urb->actual_length);
 			tty_flip_buffer_push(tty);
 
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index ebd1688..5efb5f0 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -677,7 +677,6 @@ static void spcp8x5_read_bulk_callback(struct urb *urb)
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned long flags;
-	int i;
 	int result = urb->status;
 	u8 status;
 	char tty_flag;
@@ -726,12 +725,11 @@ static void spcp8x5_read_bulk_callback(struct urb *urb)
 
 	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
-		tty_buffer_request_room(tty, urb->actual_length + 1);
 		/* overrun is special, not associated with a char */
 		if (status & UART_OVERRUN_ERROR)
 			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
-		for (i = 0; i < urb->actual_length; ++i)
-			tty_insert_flip_char(tty, data[i], tty_flag);
+		tty_insert_flip_string_fixed_flag(tty, data,
+						urb->actual_length, tty_flag);
 		tty_flip_buffer_push(tty);
 	}
 	tty_kref_put(tty);
diff --git a/drivers/usb/serial/symbolserial.c b/drivers/usb/serial/symbolserial.c
index bd0fd6e..ee190cc 100644
--- a/drivers/usb/serial/symbolserial.c
+++ b/drivers/usb/serial/symbolserial.c
@@ -51,7 +51,6 @@ static void symbol_int_callback(struct urb *urb)
 	int status = urb->status;
 	struct tty_struct *tty;
 	int result;
-	int available_room = 0;
 	int data_length;
 
 	dbg("%s - port %d", __func__, port->number);
@@ -89,13 +88,8 @@ static void symbol_int_callback(struct urb *urb)
 		 */
 		tty = tty_port_tty_get(&port->port);
 		if (tty) {
-			available_room = tty_buffer_request_room(tty,
-							data_length);
-			if (available_room) {
-				tty_insert_flip_string(tty, &data[1],
-						       available_room);
-				tty_flip_buffer_push(tty);
-			}
+			tty_insert_flip_string(tty, &data[1], data_length);
+			tty_flip_buffer_push(tty);
 			tty_kref_put(tty);
 		}
 	} else {
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 1e9dc88..0afe5c7 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1271,14 +1271,13 @@ static void ti_recv(struct device *dev, struct tty_struct *tty,
 	int cnt;
 
 	do {
-		cnt = tty_buffer_request_room(tty, length);
+		cnt = tty_insert_flip_string(tty, data, length);
 		if (cnt < length) {
 			dev_err(dev, "%s - dropping data, %d bytes lost\n",
 						__func__, length - cnt);
 			if (cnt == 0)
 				break;
 		}
-		tty_insert_flip_string(tty, data, cnt);
 		tty_flip_buffer_push(tty);
 		data += cnt;
 		length -= cnt;
diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index 178e4d9..99eb983 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -503,13 +503,9 @@ static void visor_read_bulk_callback(struct urb *urb)
 	if (urb->actual_length) {
 		tty = tty_port_tty_get(&port->port);
 		if (tty) {
-			available_room = tty_buffer_request_room(tty,
-							urb->actual_length);
-			if (available_room) {
-				tty_insert_flip_string(tty, data,
-							available_room);
-				tty_flip_buffer_push(tty);
-			}
+			tty_insert_flip_string(tty, data,
+						urb->actual_length);
+			tty_flip_buffer_push(tty);
 			tty_kref_put(tty);
 		}
 		spin_lock(&priv->lock);

