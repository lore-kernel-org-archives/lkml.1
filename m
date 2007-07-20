Return-Path: <linux-kernel-owner+w=401wt.eu-S1763668AbXGTMX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763668AbXGTMX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbXGTMXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:23:11 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:2764 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbXGTMXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:23:09 -0400
Date: Fri, 20 Jul 2007 13:23:06 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       sibyte-users@bitmover.com
Subject: [PATCH] sb1250-duart: __maybe_unused, etc. fixes
Message-ID: <Pine.LNX.4.64N.0707201314300.7402@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 This is a set of small fixes addressing points raised with the original 
driver submission.  In particular, __maybe_unused is used rather than a 
local hack and sbd_ops is made const.  Additionally I have made two local 
string variables automatic as rodata space was wasted for pointers 
unnecessarily.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
Hi,

 This should be obvious.  It builds.  Please apply.

  Maciej

patch-mips-2.6.22-20070710-serial-sb1250-duart-fix-0
diff -up --recursive --new-file linux-mips-2.6.22-20070710.macro/drivers/serial/sb1250-duart.c linux-mips-2.6.22-20070710/drivers/serial/sb1250-duart.c
--- linux-mips-2.6.22-20070710.macro/drivers/serial/sb1250-duart.c	2007-07-11 02:21:42.000000000 +0000
+++ linux-mips-2.6.22-20070710/drivers/serial/sb1250-duart.c	2007-07-19 23:46:33.000000000 +0000
@@ -25,6 +25,7 @@
 #define SUPPORT_SYSRQ
 #endif
 
+#include <linux/compiler.h>
 #include <linux/console.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -103,8 +104,6 @@ struct sbd_duart {
 
 static struct sbd_duart sbd_duarts[DUART_MAX_CHIP];
 
-#define __unused __attribute__((__unused__))
-
 
 /*
  * Reading and writing SB1250 DUART registers.
@@ -204,12 +203,12 @@ static int sbd_receive_drain(struct sbd_
 	return loops;
 }
 
-static int __unused sbd_transmit_ready(struct sbd_port *sport)
+static int __maybe_unused sbd_transmit_ready(struct sbd_port *sport)
 {
 	return read_sbdchn(sport, R_DUART_STATUS) & M_DUART_TX_RDY;
 }
 
-static int __unused sbd_transmit_drain(struct sbd_port *sport)
+static int __maybe_unused sbd_transmit_drain(struct sbd_port *sport)
 {
 	int loops = 10000;
 
@@ -664,7 +663,7 @@ static void sbd_release_port(struct uart
 
 static int sbd_map_port(struct uart_port *uport)
 {
-	static const char *err = KERN_ERR "sbd: Cannot map MMIO\n";
+	const char *err = KERN_ERR "sbd: Cannot map MMIO\n";
 	struct sbd_port *sport = to_sport(uport);
 	struct sbd_duart *duart = sport->duart;
 
@@ -691,8 +690,7 @@ static int sbd_map_port(struct uart_port
 
 static int sbd_request_port(struct uart_port *uport)
 {
-	static const char *err = KERN_ERR
-				 "sbd: Unable to reserve MMIO resource\n";
+	const char *err = KERN_ERR "sbd: Unable to reserve MMIO resource\n";
 	struct sbd_duart *duart = to_sport(uport)->duart;
 	int map_guard;
 	int ret = 0;
@@ -755,7 +753,7 @@ static int sbd_verify_port(struct uart_p
 }
 
 
-static struct uart_ops sbd_ops = {
+static const struct uart_ops sbd_ops = {
 	.tx_empty	= sbd_tx_empty,
 	.set_mctrl	= sbd_set_mctrl,
 	.get_mctrl	= sbd_get_mctrl,
