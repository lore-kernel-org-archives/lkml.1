Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbZBXP6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbZBXP6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758316AbZBXP5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:57:43 -0500
Received: from 81-7-68-229.static.zebra.lt ([81.7.68.229]:45106 "EHLO
	teltonika.lt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758275AbZBXP5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:57:41 -0500
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [RFC PATCH 2/3] mxc: move serial driver init()/exit() to
	platform_device
To: greg@kroah.com
Cc: s.hauer@pengutronix.de, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Date: Tue, 24 Feb 2009 17:57:37 +0200
Message-ID: <20090224155737.28880.3945.stgit@Programuotojas>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
---

 arch/arm/mach-mx1/devices.c |   43 ++++++++++++++
 arch/arm/mach-mx1/mx1ads.c  |   45 ---------------
 arch/arm/mach-mx2/mx27ads.c |  131 -------------------------------------------
 arch/arm/mach-mx2/pcm038.c  |   64 ---------------------
 arch/arm/mach-mx2/serial.c  |  127 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 170 insertions(+), 240 deletions(-)


diff --git a/arch/arm/mach-mx1/devices.c b/arch/arm/mach-mx1/devices.c
index a956441..5fd4ee3 100644
--- a/arch/arm/mach-mx1/devices.c
+++ b/arch/arm/mach-mx1/devices.c
@@ -26,6 +26,7 @@
 
 #include <mach/irqs.h>
 #include <mach/hardware.h>
+#include <mach/iomux-mx1-mx2.h>
 
 static struct resource imx_csi_resources[] = {
 	[0] = {
@@ -96,11 +97,32 @@ static struct resource imx_uart1_resources[] = {
 	},
 };
 
+static int mxc_uart1_pins[] = {
+	PC9_PF_UART1_CTS,
+	PC10_PF_UART1_RTS,
+	PC11_PF_UART1_TXD,
+	PC12_PF_UART1_RXD,
+};
+
+static int uart1_mxc_init(struct platform_device *pdev)
+{
+	return mxc_gpio_setup_multiple_pins(mxc_uart1_pins,
+			ARRAY_SIZE(mxc_uart1_pins), "UART1");
+}
+
+static void uart1_mxc_exit(struct platform_device *pdev)
+{
+	mxc_gpio_release_multiple_pins(mxc_uart1_pins,
+			ARRAY_SIZE(mxc_uart1_pins));
+}
+
 struct platform_device imx_uart1_device = {
 	.name		= "imx-uart",
 	.id		= 0,
 	.num_resources	= ARRAY_SIZE(imx_uart1_resources),
 	.resource	= imx_uart1_resources,
+	.init		= uart1_mxc_init,
+	.exit		= uart1_mxc_exit,
 };
 
 static struct resource imx_uart2_resources[] = {
@@ -126,11 +148,32 @@ static struct resource imx_uart2_resources[] = {
 	},
 };
 
+static int mxc_uart2_pins[] = {
+	PB28_PF_UART2_CTS,
+	PB29_PF_UART2_RTS,
+	PB30_PF_UART2_TXD,
+	PB31_PF_UART2_RXD,
+};
+
+static int uart2_mxc_init(struct platform_device *pdev)
+{
+	return mxc_gpio_setup_multiple_pins(mxc_uart2_pins,
+			ARRAY_SIZE(mxc_uart2_pins), "UART2");
+}
+
+static void uart2_mxc_exit(struct platform_device *pdev)
+{
+	mxc_gpio_release_multiple_pins(mxc_uart2_pins,
+			ARRAY_SIZE(mxc_uart2_pins));
+}
+
 struct platform_device imx_uart2_device = {
 	.name		= "imx-uart",
 	.id		= 1,
 	.num_resources	= ARRAY_SIZE(imx_uart2_resources),
 	.resource	= imx_uart2_resources,
+	.init		= uart2_mxc_init,
+	.exit		= uart2_mxc_exit,
 };
 
 static struct resource imx_rtc_resources[] = {
diff --git a/arch/arm/mach-mx1/mx1ads.c b/arch/arm/mach-mx1/mx1ads.c
index 3200cf6..086202f 100644
--- a/arch/arm/mach-mx1/mx1ads.c
+++ b/arch/arm/mach-mx1/mx1ads.c
@@ -25,60 +25,15 @@
 #include <mach/hardware.h>
 #include <mach/common.h>
 #include <mach/imx-uart.h>
-#include <mach/iomux-mx1-mx2.h>
 #include "devices.h"
 
 /*
  * UARTs platform data
  */
-static int mxc_uart1_pins[] = {
-	PC9_PF_UART1_CTS,
-	PC10_PF_UART1_RTS,
-	PC11_PF_UART1_TXD,
-	PC12_PF_UART1_RXD,
-};
-
-static int uart1_mxc_init(struct platform_device *pdev)
-{
-	return mxc_gpio_setup_multiple_pins(mxc_uart1_pins,
-			ARRAY_SIZE(mxc_uart1_pins), "UART1");
-}
-
-static int uart1_mxc_exit(struct platform_device *pdev)
-{
-	mxc_gpio_release_multiple_pins(mxc_uart1_pins,
-			ARRAY_SIZE(mxc_uart1_pins));
-	return 0;
-}
-
-static int mxc_uart2_pins[] = {
-	PB28_PF_UART2_CTS,
-	PB29_PF_UART2_RTS,
-	PB30_PF_UART2_TXD,
-	PB31_PF_UART2_RXD,
-};
-
-static int uart2_mxc_init(struct platform_device *pdev)
-{
-	return mxc_gpio_setup_multiple_pins(mxc_uart2_pins,
-			ARRAY_SIZE(mxc_uart2_pins), "UART2");
-}
-
-static int uart2_mxc_exit(struct platform_device *pdev)
-{
-	mxc_gpio_release_multiple_pins(mxc_uart2_pins,
-			ARRAY_SIZE(mxc_uart2_pins));
-	return 0;
-}
-
 static struct imxuart_platform_data uart_pdata[] = {
 	{
-		.init = uart1_mxc_init,
-		.exit = uart1_mxc_exit,
 		.flags = IMXUART_HAVE_RTSCTS,
 	}, {
-		.init = uart2_mxc_init,
-		.exit = uart2_mxc_exit,
 		.flags = IMXUART_HAVE_RTSCTS,
 	},
 };
diff --git a/arch/arm/mach-mx2/mx27ads.c b/arch/arm/mach-mx2/mx27ads.c
index 2b5c67f..7681558 100644
--- a/arch/arm/mach-mx2/mx27ads.c
+++ b/arch/arm/mach-mx2/mx27ads.c
@@ -58,125 +58,6 @@ static struct platform_device mx27ads_nor_mtd_device = {
 	.resource = &mx27ads_flash_resource,
 };
 
-static int mxc_uart0_pins[] = {
-	PE12_PF_UART1_TXD,
-	PE13_PF_UART1_RXD,
-	PE14_PF_UART1_CTS,
-	PE15_PF_UART1_RTS
-};
-
-static int uart_mxc_port0_init(struct platform_device *pdev)
-{
-	return mxc_gpio_setup_multiple_pins(mxc_uart0_pins,
-			ARRAY_SIZE(mxc_uart0_pins), "UART0");
-}
-
-static int uart_mxc_port0_exit(struct platform_device *pdev)
-{
-	mxc_gpio_release_multiple_pins(mxc_uart0_pins,
-			ARRAY_SIZE(mxc_uart0_pins));
-	return 0;
-}
-
-static int mxc_uart1_pins[] = {
-	PE3_PF_UART2_CTS,
-	PE4_PF_UART2_RTS,
-	PE6_PF_UART2_TXD,
-	PE7_PF_UART2_RXD
-};
-
-static int uart_mxc_port1_init(struct platform_device *pdev)
-{
-	return mxc_gpio_setup_multiple_pins(mxc_uart1_pins,
-			ARRAY_SIZE(mxc_uart1_pins), "UART1");
-}
-
-static int uart_mxc_port1_exit(struct platform_device *pdev)
-{
-	mxc_gpio_release_multiple_pins(mxc_uart1_pins,
-			ARRAY_SIZE(mxc_uart1_pins));
-	return 0;
-}
-
-static int mxc_uart2_pins[] = {
-	PE8_PF_UART3_TXD,
-	PE9_PF_UART3_RXD,
-	PE10_PF_UART3_CTS,
-	PE11_PF_UART3_RTS
-};
-
-static int uart_mxc_port2_init(struct platform_device *pdev)
-{
-	return mxc_gpio_setup_multiple_pins(mxc_uart2_pins,
-			ARRAY_SIZE(mxc_uart2_pins), "UART2");
-}
-
-static int uart_mxc_port2_exit(struct platform_device *pdev)
-{
-	mxc_gpio_release_multiple_pins(mxc_uart2_pins,
-			ARRAY_SIZE(mxc_uart2_pins));
-	return 0;
-}
-
-static int mxc_uart3_pins[] = {
-	PB26_AF_UART4_RTS,
-	PB28_AF_UART4_TXD,
-	PB29_AF_UART4_CTS,
-	PB31_AF_UART4_RXD
-};
-
-static int uart_mxc_port3_init(struct platform_device *pdev)
-{
-	return mxc_gpio_setup_multiple_pins(mxc_uart3_pins,
-			ARRAY_SIZE(mxc_uart3_pins), "UART3");
-}
-
-static int uart_mxc_port3_exit(struct platform_device *pdev)
-{
-	mxc_gpio_release_multiple_pins(mxc_uart3_pins,
-			ARRAY_SIZE(mxc_uart3_pins));
-}
-
-static int mxc_uart4_pins[] = {
-	PB18_AF_UART5_TXD,
-	PB19_AF_UART5_RXD,
-	PB20_AF_UART5_CTS,
-	PB21_AF_UART5_RTS
-};
-
-static int uart_mxc_port4_init(struct platform_device *pdev)
-{
-	return mxc_gpio_setup_multiple_pins(mxc_uart4_pins,
-			ARRAY_SIZE(mxc_uart4_pins), "UART4");
-}
-
-static int uart_mxc_port4_exit(struct platform_device *pdev)
-{
-	mxc_gpio_release_multiple_pins(mxc_uart4_pins,
-			ARRAY_SIZE(mxc_uart4_pins));
-	return 0;
-}
-
-static int mxc_uart5_pins[] = {
-	PB10_AF_UART6_TXD,
-	PB12_AF_UART6_CTS,
-	PB11_AF_UART6_RXD,
-	PB13_AF_UART6_RTS
-};
-
-static int uart_mxc_port5_init(struct platform_device *pdev)
-{
-	return mxc_gpio_setup_multiple_pins(mxc_uart5_pins,
-			ARRAY_SIZE(mxc_uart5_pins), "UART5");
-}
-
-static int uart_mxc_port5_exit(struct platform_device *pdev)
-{
-	mxc_gpio_release_multiple_pins(mxc_uart5_pins,
-			ARRAY_SIZE(mxc_uart5_pins));
-	return 0;
-}
-
 static struct platform_device *platform_devices[] __initdata = {
 	&mx27ads_nor_mtd_device,
 };
@@ -216,28 +97,16 @@ static void gpio_fec_inactive(void)
 
 static struct imxuart_platform_data uart_pdata[] = {
 	{
-		.init = uart_mxc_port0_init,
-		.exit = uart_mxc_port0_exit,
 		.flags = IMXUART_HAVE_RTSCTS,
 	}, {
-		.init = uart_mxc_port1_init,
-		.exit = uart_mxc_port1_exit,
 		.flags = IMXUART_HAVE_RTSCTS,
 	}, {
-		.init = uart_mxc_port2_init,
-		.exit = uart_mxc_port2_exit,
 		.flags = IMXUART_HAVE_RTSCTS,
 	}, {
-		.init = uart_mxc_port3_init,
-		.exit = uart_mxc_port3_exit,
 		.flags = IMXUART_HAVE_RTSCTS,
 	}, {
-		.init = uart_mxc_port4_init,
-		.exit = uart_mxc_port4_exit,
 		.flags = IMXUART_HAVE_RTSCTS,
 	}, {
-		.init = uart_mxc_port5_init,
-		.exit = uart_mxc_port5_exit,
 		.flags = IMXUART_HAVE_RTSCTS,
 	},
 };
diff --git a/arch/arm/mach-mx2/pcm038.c b/arch/arm/mach-mx2/pcm038.c
index dfd4156..c2747b4 100644
--- a/arch/arm/mach-mx2/pcm038.c
+++ b/arch/arm/mach-mx2/pcm038.c
@@ -81,76 +81,12 @@ static struct platform_device pcm038_nor_mtd_device = {
 	.resource = &pcm038_flash_resource,
 };
 
-static int mxc_uart0_pins[] = {
-	PE12_PF_UART1_TXD,
-	PE13_PF_UART1_RXD,
-	PE14_PF_UART1_CTS,
-	PE15_PF_UART1_RTS
-};
-
-static int uart_mxc_port0_init(struct platform_device *pdev)
-{
-	return mxc_gpio_setup_multiple_pins(mxc_uart0_pins,
-			ARRAY_SIZE(mxc_uart0_pins), "UART0");
-}
-
-static int uart_mxc_port0_exit(struct platform_device *pdev)
-{
-	mxc_gpio_release_multiple_pins(mxc_uart0_pins,
-			ARRAY_SIZE(mxc_uart0_pins));
-	return 0;
-}
-
-static int mxc_uart1_pins[] = {
-	PE3_PF_UART2_CTS,
-	PE4_PF_UART2_RTS,
-	PE6_PF_UART2_TXD,
-	PE7_PF_UART2_RXD
-};
-
-static int uart_mxc_port1_init(struct platform_device *pdev)
-{
-	return mxc_gpio_setup_multiple_pins(mxc_uart1_pins,
-			ARRAY_SIZE(mxc_uart1_pins), "UART1");
-}
-
-static int uart_mxc_port1_exit(struct platform_device *pdev)
-{
-	mxc_gpio_release_multiple_pins(mxc_uart1_pins,
-			ARRAY_SIZE(mxc_uart1_pins));
-	return 0;
-}
-
-static int mxc_uart2_pins[] = { PE10_PF_UART3_CTS,
-				PE9_PF_UART3_RXD,
-				PE10_PF_UART3_CTS,
-				PE9_PF_UART3_RXD };
-
-static int uart_mxc_port2_init(struct platform_device *pdev)
-{
-	return mxc_gpio_setup_multiple_pins(mxc_uart2_pins,
-			ARRAY_SIZE(mxc_uart2_pins), "UART2");
-}
-
-static int uart_mxc_port2_exit(struct platform_device *pdev)
-{
-	mxc_gpio_release_multiple_pins(mxc_uart2_pins,
-			ARRAY_SIZE(mxc_uart2_pins));
-	return 0;
-}
-
 static struct imxuart_platform_data uart_pdata[] = {
 	{
-		.init = uart_mxc_port0_init,
-		.exit = uart_mxc_port0_exit,
 		.flags = IMXUART_HAVE_RTSCTS,
 	}, {
-		.init = uart_mxc_port1_init,
-		.exit = uart_mxc_port1_exit,
 		.flags = IMXUART_HAVE_RTSCTS,
 	}, {
-		.init = uart_mxc_port2_init,
-		.exit = uart_mxc_port2_exit,
 		.flags = IMXUART_HAVE_RTSCTS,
 	},
 };
diff --git a/arch/arm/mach-mx2/serial.c b/arch/arm/mach-mx2/serial.c
index 16debc2..8c79664 100644
--- a/arch/arm/mach-mx2/serial.c
+++ b/arch/arm/mach-mx2/serial.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/serial.h>
 #include <mach/hardware.h>
+#include <mach/iomux-mx1-mx2.h>
 #include <mach/imx-uart.h>
 
 static struct resource uart0[] = {
@@ -35,11 +36,32 @@ static struct resource uart0[] = {
 	},
 };
 
+static int mxc_uart0_pins[] = {
+	PE12_PF_UART1_TXD,
+	PE13_PF_UART1_RXD,
+	PE14_PF_UART1_CTS,
+	PE15_PF_UART1_RTS
+};
+
+static int uart_mxc_port0_init(struct platform_device *pdev)
+{
+	return mxc_gpio_setup_multiple_pins(mxc_uart0_pins,
+			ARRAY_SIZE(mxc_uart0_pins), "UART0");
+}
+
+static void uart_mxc_port0_exit(struct platform_device *pdev)
+{
+	mxc_gpio_release_multiple_pins(mxc_uart0_pins,
+			ARRAY_SIZE(mxc_uart0_pins));
+}
+
 struct platform_device mxc_uart_device0 = {
 	.name = "imx-uart",
 	.id = 0,
 	.resource = uart0,
 	.num_resources = ARRAY_SIZE(uart0),
+	.init = uart_mxc_port0_init,
+	.exit = uart_mxc_port0_exit,
 };
 
 static struct resource uart1[] = {
@@ -54,11 +76,32 @@ static struct resource uart1[] = {
 	},
 };
 
+static int mxc_uart1_pins[] = {
+	PE3_PF_UART2_CTS,
+	PE4_PF_UART2_RTS,
+	PE6_PF_UART2_TXD,
+	PE7_PF_UART2_RXD
+};
+
+static int uart_mxc_port1_init(struct platform_device *pdev)
+{
+	return mxc_gpio_setup_multiple_pins(mxc_uart1_pins,
+			ARRAY_SIZE(mxc_uart1_pins), "UART1");
+}
+
+static void uart_mxc_port1_exit(struct platform_device *pdev)
+{
+	mxc_gpio_release_multiple_pins(mxc_uart1_pins,
+			ARRAY_SIZE(mxc_uart1_pins));
+}
+
 struct platform_device mxc_uart_device1 = {
 	.name = "imx-uart",
 	.id = 1,
 	.resource = uart1,
 	.num_resources = ARRAY_SIZE(uart1),
+	.init = uart_mxc_port1_init,
+	.exit = uart_mxc_port1_exit,
 };
 
 static struct resource uart2[] = {
@@ -73,11 +116,32 @@ static struct resource uart2[] = {
 	},
 };
 
+static int mxc_uart2_pins[] = {
+	PE8_PF_UART3_TXD,
+	PE9_PF_UART3_RXD,
+	PE10_PF_UART3_CTS,
+	PE11_PF_UART3_RTS
+};
+
+static int uart_mxc_port2_init(struct platform_device *pdev)
+{
+	return mxc_gpio_setup_multiple_pins(mxc_uart2_pins,
+			ARRAY_SIZE(mxc_uart2_pins), "UART2");
+}
+
+static void uart_mxc_port2_exit(struct platform_device *pdev)
+{
+	mxc_gpio_release_multiple_pins(mxc_uart2_pins,
+			ARRAY_SIZE(mxc_uart2_pins));
+}
+
 struct platform_device mxc_uart_device2 = {
 	.name = "imx-uart",
 	.id = 2,
 	.resource = uart2,
 	.num_resources = ARRAY_SIZE(uart2),
+	.init = uart_mxc_port2_init,
+	.exit = uart_mxc_port2_exit,
 };
 
 static struct resource uart3[] = {
@@ -92,11 +156,32 @@ static struct resource uart3[] = {
 	},
 };
 
+static int mxc_uart3_pins[] = {
+	PB26_AF_UART4_RTS,
+	PB28_AF_UART4_TXD,
+	PB29_AF_UART4_CTS,
+	PB31_AF_UART4_RXD
+};
+
+static int uart_mxc_port3_init(struct platform_device *pdev)
+{
+	return mxc_gpio_setup_multiple_pins(mxc_uart3_pins,
+			ARRAY_SIZE(mxc_uart3_pins), "UART3");
+}
+
+static void uart_mxc_port3_exit(struct platform_device *pdev)
+{
+	mxc_gpio_release_multiple_pins(mxc_uart3_pins,
+			ARRAY_SIZE(mxc_uart3_pins));
+}
+
 struct platform_device mxc_uart_device3 = {
 	.name = "imx-uart",
 	.id = 3,
 	.resource = uart3,
 	.num_resources = ARRAY_SIZE(uart3),
+	.init = uart_mxc_port3_init,
+	.exit = uart_mxc_port3_exit,
 };
 
 static struct resource uart4[] = {
@@ -111,11 +196,32 @@ static struct resource uart4[] = {
 	},
 };
 
+static int mxc_uart4_pins[] = {
+	PB18_AF_UART5_TXD,
+	PB19_AF_UART5_RXD,
+	PB20_AF_UART5_CTS,
+	PB21_AF_UART5_RTS
+};
+
+static int uart_mxc_port4_init(struct platform_device *pdev)
+{
+	return mxc_gpio_setup_multiple_pins(mxc_uart4_pins,
+			ARRAY_SIZE(mxc_uart4_pins), "UART4");
+}
+
+static void uart_mxc_port4_exit(struct platform_device *pdev)
+{
+	mxc_gpio_release_multiple_pins(mxc_uart4_pins,
+			ARRAY_SIZE(mxc_uart4_pins));
+}
+
 struct platform_device mxc_uart_device4 = {
 	.name = "imx-uart",
 	.id = 4,
 	.resource = uart4,
 	.num_resources = ARRAY_SIZE(uart4),
+	.init = uart_mxc_port4_init,
+	.exit = uart_mxc_port4_exit,
 };
 
 static struct resource uart5[] = {
@@ -130,9 +236,30 @@ static struct resource uart5[] = {
 	},
 };
 
+static int mxc_uart5_pins[] = {
+	PB10_AF_UART6_TXD,
+	PB12_AF_UART6_CTS,
+	PB11_AF_UART6_RXD,
+	PB13_AF_UART6_RTS
+};
+
+static int uart_mxc_port5_init(struct platform_device *pdev)
+{
+	return mxc_gpio_setup_multiple_pins(mxc_uart5_pins,
+			ARRAY_SIZE(mxc_uart5_pins), "UART5");
+}
+
+static void uart_mxc_port5_exit(struct platform_device *pdev)
+{
+	mxc_gpio_release_multiple_pins(mxc_uart5_pins,
+			ARRAY_SIZE(mxc_uart5_pins));
+}
+
 struct platform_device mxc_uart_device5 = {
 	.name = "imx-uart",
 	.id = 5,
 	.resource = uart5,
 	.num_resources = ARRAY_SIZE(uart5),
+	.init = uart_mxc_port5_init,
+	.exit = uart_mxc_port5_exit,
 };

