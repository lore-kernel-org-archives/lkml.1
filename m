Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbYFTUfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbYFTUfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762087AbYFTUWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:22:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35231 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762067AbYFTUWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:22:10 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 51/70] keyspan: Use string flip functions when possible
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:04:46 +0100
Message-ID: <20080620200444.1479.24072.stgit@localhost.localdomain>
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

 drivers/usb/serial/keyspan.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)


diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 8c7dc40..a90098a 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -575,7 +575,7 @@ static void	usa26_glocont_callback(struct urb *urb)
 
 static void usa28_indat_callback(struct urb *urb)
 {
-	int                     i, err;
+	int                     err;
 	struct usb_serial_port  *port;
 	struct tty_struct       *tty;
 	unsigned char           *data;
@@ -604,8 +604,7 @@ static void usa28_indat_callback(struct urb *urb)
 
 		tty = port->port.tty;
 		if (urb->actual_length) {
-			for (i = 0; i < urb->actual_length ; ++i)
-				tty_insert_flip_char(tty, data[i], 0);
+			tty_insert_flip_string(tty, data, urb->actual_length);
 			tty_flip_buffer_push(tty);
 		}
 
@@ -831,8 +830,8 @@ static void	usa49_indat_callback(struct urb *urb)
 		/* 0x80 bit is error flag */
 		if ((data[0] & 0x80) == 0) {
 			/* no error on any byte */
-			for (i = 1; i < urb->actual_length ; ++i)
-				tty_insert_flip_char(tty, data[i], 0);
+			tty_insert_flip_string(tty, data + 1,
+						urb->actual_length - 1);
 		} else {
 			/* some bytes had errors, every byte has status */
 			for (i = 0; i + 1 < urb->actual_length; i += 2) {
@@ -971,10 +970,9 @@ static void usa90_indat_callback(struct urb *urb)
 		/* if current mode is DMA, looks like usa28 format
 		   otherwise looks like usa26 data format */
 
-		if (p_priv->baud > 57600) {
-			for (i = 0; i < urb->actual_length ; ++i)
-				tty_insert_flip_char(tty, data[i], 0);
-		} else {
+		if (p_priv->baud > 57600)
+			tty_insert_flip_string(tty, data, urb->actual_length);
+		else {
 			/* 0x80 bit is error flag */
 			if ((data[0] & 0x80) == 0) {
 				/* no errors on individual bytes, only
@@ -1665,7 +1663,7 @@ static int keyspan_usa19_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 	dbg("%s - %d.", __func__, baud_rate);
 
 	/* prevent divide by zero...  */
-	b16 = baud_rate * 16L
+	b16 = baud_rate * 16L;
 	if (b16 == 0)
 		return KEYSPAN_INVALID_BAUD_RATE;
 	/* Any "standard" rate over 57k6 is marginal on the USA-19

