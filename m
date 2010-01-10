Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686Ab0AJQ7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab0AJQ7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 11:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494Ab0AJQ7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 11:59:44 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:58110 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab0AJQ7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 11:59:43 -0500
Message-ID: <4B4A0772.9070007@freemail.hu>
Date: Sun, 10 Jan 2010 17:59:30 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: linux-serial@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH 1/3] serial: make Open Firmware device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32711; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The match_table field of the struct of_device_id is constant in <linux/of_platform.h>
so it is worth to make the initialization data also constant.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
disable decl_init,const_decl_init;
identifier I1, I2, x;
@@
	struct I1 {
	  ...
	  const struct I2 *x;
	  ...
	};
@s@
identifier r.I1, y;
identifier r.x, E;
@@
	struct I1 y = {
	  .x = E,
	};
@c@
identifier r.I2;
identifier s.E;
@@
	const struct I2 E[] = ... ;
@depends on !c@
identifier r.I2;
identifier s.E;
@@
+	const
	struct I2 E[] = ...;
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
---
diff -u -p a/drivers/serial/of_serial.c b/drivers/serial/of_serial.c
--- a/drivers/serial/of_serial.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/serial/of_serial.c 2010-01-08 18:42:19.000000000 +0100
@@ -158,7 +158,7 @@ static int of_platform_serial_remove(str
 /*
  * A few common types, add more as needed.
  */
-static struct of_device_id __devinitdata of_platform_serial_table[] = {
+static const struct of_device_id of_platform_serial_table[] __devinitconst = {
 	{ .type = "serial", .compatible = "ns8250",   .data = (void *)PORT_8250, },
 	{ .type = "serial", .compatible = "ns16450",  .data = (void *)PORT_16450, },
 	{ .type = "serial", .compatible = "ns16550a", .data = (void *)PORT_16550A, },
diff -u -p a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
--- a/drivers/serial/mpc52xx_uart.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/serial/mpc52xx_uart.c 2010-01-08 18:45:41.000000000 +0100
@@ -1088,7 +1088,7 @@ static struct uart_driver mpc52xx_uart_d
 /* OF Platform Driver                                                       */
 /* ======================================================================== */

-static struct of_device_id mpc52xx_uart_of_match[] = {
+static const struct of_device_id mpc52xx_uart_of_match[] = {
 #ifdef CONFIG_PPC_MPC52xx
 	{ .compatible = "fsl,mpc5200-psc-uart", .data = &mpc52xx_psc_ops, },
 	/* binding used by old lite5200 device trees: */
diff -u -p a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
--- a/drivers/serial/uartlite.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/serial/uartlite.c 2010-01-08 18:47:33.000000000 +0100
@@ -25,7 +25,7 @@
 #include <linux/of_platform.h>

 /* Match table for of_platform binding */
-static struct of_device_id ulite_of_match[] __devinitdata = {
+static const struct of_device_id ulite_of_match[] __devinitconst = {
 	{ .compatible = "xlnx,opb-uartlite-1.00.b", },
 	{ .compatible = "xlnx,xps-uartlite-1.00.a", },
 	{}
diff -u -p a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
--- a/drivers/serial/cpm_uart/cpm_uart_core.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c 2010-01-08 18:49:48.000000000 +0100
@@ -1355,7 +1355,7 @@ static int __devexit cpm_uart_remove(str
 	return uart_remove_one_port(&cpm_reg, &pinfo->port);
 }

-static struct of_device_id cpm_uart_match[] = {
+static const struct of_device_id cpm_uart_match[] = {
 	{
 		.compatible = "fsl,cpm1-smc-uart",
 	},
diff -u -p a/drivers/serial/ucc_uart.c b/drivers/serial/ucc_uart.c
--- a/drivers/serial/ucc_uart.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/serial/ucc_uart.c 2010-01-08 18:50:15.000000000 +0100
@@ -1475,7 +1475,7 @@ static int ucc_uart_remove(struct of_dev
 	return 0;
 }

-static struct of_device_id ucc_uart_match[] = {
+static const struct of_device_id ucc_uart_match[] = {
 	{
 		.type = "serial",
 		.compatible = "ucc_uart",
diff -u -p a/drivers/serial/apbuart.c b/drivers/serial/apbuart.c
--- a/drivers/serial/apbuart.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/serial/apbuart.c 2010-01-08 18:51:23.000000000 +0100
@@ -576,7 +576,7 @@ static int __devinit apbuart_probe(struc

 }

-static struct of_device_id __initdata apbuart_match[] = {
+static const struct of_device_id apbuart_match[] __initconst = {
 	{
 	 .name = "GAISLER_APBUART",
 	 },
