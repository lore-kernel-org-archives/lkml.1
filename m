Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbXLXOmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbXLXOmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbXLXOly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:41:54 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:50127 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbXLXOlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:41:53 -0500
Date: Mon, 24 Dec 2007 15:41:42 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 23/38] usb/serial: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241541170.23999@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -r -u -p a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c	2007-07-23 11:27:17.000000000 +0200
+++ b/drivers/usb/serial/io_ti.c	2007-12-23 20:30:39.000000000 +0100
@@ -639,7 +639,7 @@ static void TIChasePort(struct edgeport_
 
 	/* wait for data to drain from the device */
 	timeout += jiffies;
-	while ((long)(jiffies - timeout) < 0 && !signal_pending(current)
+	while (time_before(jiffies, timeout) && !signal_pending(current)
 	&& usb_get_intfdata(port->port->serial->interface)) {  /* not disconnected */
 		if (!TIIsTxActive(port))
 			break;
diff -r -u -p a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c	2007-10-22 11:25:25.000000000 +0200
+++ b/drivers/usb/serial/ti_usb_3410_5052.c	2007-12-23 20:30:39.000000000 +0100
@@ -84,6 +84,7 @@
 #include <asm/semaphore.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/jiffies.h>
 
 #include "ti_usb_3410_5052.h"
 #include "ti_fw_3410.h"		/* firmware image for 3410 */
@@ -1531,7 +1532,7 @@ static void ti_drain(struct ti_port *tpo
 	/* wait for empty tx register, plus 20 ms */
 	timeout += jiffies;
 	tport->tp_lsr &= ~TI_LSR_TX_EMPTY;
-	while ((long)(jiffies - timeout) < 0 && !signal_pending(current)
+	while (time_before(jiffies, timeout) && !signal_pending(current)
 	&& !(tport->tp_lsr&TI_LSR_TX_EMPTY) && !tdev->td_urb_error
 	&& usb_get_intfdata(port->serial->interface)) {  /* not disconnected */
 		if (ti_get_lsr(tport))
