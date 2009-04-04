Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbZDDT3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbZDDT3B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 15:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbZDDT2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 15:28:30 -0400
Received: from [213.79.90.228] ([213.79.90.228]:8090 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756321AbZDDT23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 15:28:29 -0400
Date: Sat, 4 Apr 2009 23:28:26 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 3/3] powerpc/86xx: Add MMC SPI support for MPC8610HPCD
	boards
Message-ID: <20090404192826.GC12183@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds spi and mmc-spi-slot nodes, plus a gpio-controller
for PIXIS' sdcsr bank that is used for managing SPI chip-select and
for reading card's states.

Note that spi-max-frequency is lowered since at high frequencies SD
cards don't work reliably (there is some problem with the chip select
line, it's probably quite slow because it's routed via PIXIS).

Previously there was a work around: we didn't use chip-select line
at all, but some cards don't like that, so we'd better use the low
frequency.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/boot/dts/mpc8610_hpcd.dts     |   32 ++++++++++++++++++++++++++++
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c |    4 +++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8610_hpcd.dts b/arch/powerpc/boot/dts/mpc8610_hpcd.dts
index 1bd3ebe..a18fa5c 100644
--- a/arch/powerpc/boot/dts/mpc8610_hpcd.dts
+++ b/arch/powerpc/boot/dts/mpc8610_hpcd.dts
@@ -100,8 +100,18 @@
 		};
 
 		board-control@3,0 {
+			#address-cells = <1>;
+			#size-cells = <1>;
 			compatible = "fsl,fpga-pixis";
 			reg = <3 0 0x20>;
+			ranges = <0 3 0 0x20>;
+
+			sdcsr_pio: gpio-controller@a {
+				#gpio-cells = <2>;
+				compatible = "fsl,fpga-pixis-gpio-bank";
+				reg = <0xa 1>;
+				gpio-controller;
+			};
 		};
 	};
 
@@ -164,6 +174,28 @@
 			interrupt-parent = <&mpic>;
 		};
 
+		spi@7000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "fsl,mpc8610-spi", "fsl,spi";
+			reg = <0x7000 0x40>;
+			cell-index = <0>;
+			interrupts = <59 2>;
+			interrupt-parent = <&mpic>;
+			mode = "cpu";
+			gpios = <&sdcsr_pio 7 0>;
+
+			mmc-slot@0 {
+				compatible = "fsl,mpc8610hpcd-mmc-slot",
+					     "mmc-spi-slot";
+				reg = <0>;
+				gpios = <&sdcsr_pio 0 1   /* nCD */
+					 &sdcsr_pio 1 0>; /*  WP */
+				voltage-ranges = <3300 3300>;
+				spi-max-frequency = <6000000>;
+			};
+		};
+
 		display@2c000 {
 			compatible = "fsl,diu";
 			reg = <0x2c000 100>;
diff --git a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
index 3f49a6f..ce64572 100644
--- a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
+++ b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
@@ -38,6 +38,7 @@
 #include <linux/of_platform.h>
 #include <sysdev/fsl_pci.h>
 #include <sysdev/fsl_soc.h>
+#include <sysdev/simple_gpio.h>
 
 #include "mpc86xx.h"
 
@@ -52,6 +53,9 @@ static struct of_device_id __initdata mpc8610_ids[] = {
 
 static int __init mpc8610_declare_of_platform_devices(void)
 {
+	/* Firstly, register PIXIS GPIOs. */
+	simple_gpiochip_init("fsl,fpga-pixis-gpio-bank");
+
 	/* Without this call, the SSI device driver won't get probed. */
 	of_platform_bus_probe(NULL, mpc8610_ids, NULL);
 
-- 
1.5.6.5
