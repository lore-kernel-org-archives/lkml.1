Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZGEOEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZGEOEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 10:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbZGEOEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 10:04:14 -0400
Received: from d1.icnet.pl ([212.160.220.21]:41366 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbZGEOEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 10:04:12 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Jonathan McDowell <noodles@earth.li>
Subject: [PATCH v2] OMAP1: AMS_DELTA: add modem support
Date: Sun, 5 Jul 2009 16:01:48 +0200
User-Agent: KMail/1.9.10
Cc: Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907051601.49194.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for modem device found on Amstrad E3 (Delta) board.

Created against linux-2.6.31-rc1.

Based on earlier patch by Jonathan McDowell, available at 
http://the.earth.li/pub/e3/2.6.19/ams-delta-modem.patch.
Modified after Ladislav Michl's arch/arm/mach-omap1/board-voiceblue.c.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
Registering the modem platform device from a separate arch_initcall (and not
from init_machine() callback) preserves serial console port at ttyS0.

OMAP mux pin set up just for case if Amstrad bootloader is ever replaced.

--- linux-2.6.31-rc1/arch/arm/mach-omap1/board-ams-delta.c.orig	2009-07-04 16:39:37.000000000 +0200
+++ linux-2.6.31-rc1/arch/arm/mach-omap1/board-ams-delta.c	2009-07-05 13:41:08.000000000 +0200
@@ -15,8 +15,11 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/input.h>
+#include <linux/irq.h>
 #include <linux/platform_device.h>
+#include <linux/serial_8250.h>
 
+#include <asm/serial.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -235,6 +238,41 @@ static void __init ams_delta_init(void)
 	platform_add_devices(ams_delta_devices, ARRAY_SIZE(ams_delta_devices));
 }
 
+static struct plat_serial8250_port ams_delta_modem_ports[] = {
+	{
+		.membase	= (void *) AMS_DELTA_MODEM_VIRT,
+		.mapbase	= AMS_DELTA_MODEM_PHYS,
+		.irq		= -EINVAL, /* changed later */
+		.flags		= UPF_BOOT_AUTOCONF,
+		.iotype		= UPIO_MEM,
+		.regshift	= 1,
+		.uartclk	= BASE_BAUD * 16,
+	},
+	{ },
+};
+
+static struct platform_device ams_delta_modem_device = {
+	.name	= "serial8250",
+	.id	= PLAT8250_DEV_PLATFORM1,
+	.dev		= {
+		.platform_data = ams_delta_modem_ports,
+	},
+};
+
+static int __init ams_delta_modem_init(void)
+{
+	omap_cfg_reg(M14_1510_GPIO2);
+	ams_delta_modem_ports[0].irq = gpio_to_irq(2);
+	set_irq_type(gpio_to_irq(2), IRQ_TYPE_EDGE_RISING);
+
+	ams_delta_latch2_write(
+		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC,
+		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC);
+
+	return platform_device_register(&ams_delta_modem_device);
+}
+arch_initcall(ams_delta_modem_init);
+
 static void __init ams_delta_map_io(void)
 {
 	omap1_map_common_io();

