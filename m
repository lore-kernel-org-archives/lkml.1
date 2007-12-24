Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbXLXOli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbXLXOli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbXLXOl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:41:28 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:50098 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbXLXOl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:41:27 -0500
Date: Mon, 24 Dec 2007 15:41:16 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 22/38] serial: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241540560.23999@ask.diku.dk>
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

diff -r -u -p a/drivers/serial/68360serial.c b/drivers/serial/68360serial.c
--- a/drivers/serial/68360serial.c	2007-07-20 17:45:57.000000000 +0200
+++ b/drivers/serial/68360serial.c	2007-12-23 20:30:39.000000000 +0100
@@ -51,6 +51,7 @@ extern int  kgdb_output_string (const ch
 
 /* #ifdef CONFIG_SERIAL_CONSOLE */ /* This seems to be a post 2.0 thing - mles */
 #include <linux/console.h>
+#include <linux/jiffies.h>
 
 /* this defines the index into rs_table for the port to use
  */
@@ -1729,7 +1730,7 @@ static void rs_360_wait_until_sent(struc
 		msleep_interruptible(jiffies_to_msecs(char_time));
 		if (signal_pending(current))
 			break;
-		if (timeout && ((orig_jiffies + timeout) < jiffies))
+		if (timeout && (time_after(jiffies, orig_jiffies + timeout)))
 			break;
 		/* The 'tx_cur' is really the next buffer to send.  We
 		 * have to back up to the previous BD and wait for it
