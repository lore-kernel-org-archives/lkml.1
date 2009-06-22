Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbZFVQpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbZFVQpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbZFVQof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:44:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37500 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756033AbZFVQoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:44:34 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 09/15] tty: fix some bogns in the serqt_usb2 driver
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 18:42:36 +0100
Message-ID: <20090622174234.25341.7067.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
References: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Remove the replicated urban legends from the comments and fix a couple of
other silly calls

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/serqt_usb2/serqt_usb2.c |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)


diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 581232b..90b29b5 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -284,21 +284,12 @@ static void ProcessModemStatus(struct quatech_port *qt_port,
 	return;
 }
 
-static void ProcessRxChar(struct usb_serial_port *port, unsigned char Data)
+static void ProcessRxChar(struct tty_struct *tty, struct usb_serial_port *port,
+						unsigned char data)
 {
-	struct tty_struct *tty;
 	struct urb *urb = port->read_urb;
-	tty = tty_port_tty_get(&port->port);
-
-	/* if we insert more than TTY_FLIPBUF_SIZE characters, we drop them. */
-
-	if (tty && urb->actual_length) {
-		tty_buffer_request_room(tty, 1);
-		tty_insert_flip_string(tty, &Data, 1);
-		/* tty_flip_buffer_push(tty); */
-	}
-
-	return;
+	if (urb->actual_length)
+		tty_insert_flip_char(tty, data, TTY_NORMAL);
 }
 
 static void qt_write_bulk_callback(struct urb *urb)
@@ -435,8 +426,10 @@ static void qt_read_bulk_callback(struct urb *urb)
 				case 0xff:
 					dbg("No status sequence. \n");
 
-					ProcessRxChar(port, data[i]);
-					ProcessRxChar(port, data[i + 1]);
+					if (tty) {
+						ProcessRxChar(tty, port, data[i]);
+						ProcessRxChar(tty, port, data[i + 1]);
+					}
 					i += 2;
 					break;
 				}
@@ -444,10 +437,8 @@ static void qt_read_bulk_callback(struct urb *urb)
 					continue;
 			}
 
-			if (tty && urb->actual_length) {
-				tty_buffer_request_room(tty, 1);
-				tty_insert_flip_string(tty, (data + i), 1);
-			}
+			if (tty && urb->actual_length)
+				tty_insert_flip_char(tty, data[i], TTY_NORMAL);
 
 		}
 		tty_flip_buffer_push(tty);

