Return-Path: <linux-kernel-owner+w=401wt.eu-S1759021AbZFIKsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbZFIKsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759222AbZFIKsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:48:13 -0400
Received: from mail.atmel.fr ([81.80.104.162]:64828 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270AbZFIKsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:48:09 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-usb@vger.kernel.org, avictor.za@gmail.com
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net,
       haavard.skinnemoen@atmel.com, patrice.vilchez@atmel.com,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/2] at91/USB: at91sam9g45 series USB host integration
Date: Tue,  9 Jun 2009 13:38:13 +0200
Message-Id: <1244547493-19654-3-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1244547493-19654-2-git-send-email-nicolas.ferre@atmel.com>
References: <1244547493-19654-1-git-send-email-nicolas.ferre@atmel.com>
 <1244547493-19654-2-git-send-email-nicolas.ferre@atmel.com>
Message-Id: <37875dad9f270c834319c78b1af15f2f12c52e46.1244545093.git.nicolas.ferre@atmel.com>
In-Reply-To: <7d35ee50ea2e14a3d4f350406693b1e884b034f3.1244545093.git.nicolas.ferre@atmel.com>
References: <7d35ee50ea2e14a3d4f350406693b1e884b034f3.1244545093.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the at91 specific part of USB host integration. The EHCI high speed
controller has a companion OHCI controller to manage USB full and low speed.
They are sharing the same IRQ line and vbus pin.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9g45_devices.c |   56 ++++++++++++++++++++++++++++++
 arch/arm/mach-at91/board-sam9m10g45ek.c  |    1 +
 arch/arm/mach-at91/include/mach/board.h  |    1 +
 3 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index d746e86..c2ecbb6 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -83,6 +83,62 @@ void __init at91_add_device_usbh_ohci(struct at91_usbh_data *data) {}
 
 
 /* --------------------------------------------------------------------
+ *  USB Host HS (EHCI)
+ *  Needs an OHCI host for low and full speed management
+ * -------------------------------------------------------------------- */
+
+#if defined(CONFIG_USB_EHCI_HCD) || defined(CONFIG_USB_EHCI_HCD_MODULE)
+static u64 ehci_dmamask = DMA_BIT_MASK(32);
+static struct at91_usbh_data usbh_ehci_data;
+
+static struct resource usbh_ehci_resources[] = {
+	[0] = {
+		.start	= AT91SAM9G45_EHCI_BASE,
+		.end	= AT91SAM9G45_EHCI_BASE + SZ_1M - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= AT91SAM9G45_ID_UHPHS,
+		.end	= AT91SAM9G45_ID_UHPHS,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at91_usbh_ehci_device = {
+	.name		= "atmel-ehci",
+	.id		= -1,
+	.dev		= {
+				.dma_mask		= &ehci_dmamask,
+				.coherent_dma_mask	= DMA_BIT_MASK(32),
+				.platform_data		= &usbh_ehci_data,
+	},
+	.resource	= usbh_ehci_resources,
+	.num_resources	= ARRAY_SIZE(usbh_ehci_resources),
+};
+
+void __init at91_add_device_usbh_ehci(struct at91_usbh_data *data)
+{
+	int i;
+
+	if (!data)
+		return;
+
+	/* Enable VBus control for UHP ports */
+	for (i = 0; i < data->ports; i++) {
+		if (data->vbus_pin[i])
+			at91_set_gpio_output(data->vbus_pin[i], 0);
+	}
+
+	usbh_ehci_data = *data;
+	at91_clock_associate("uhphs_clk", &at91_usbh_ehci_device.dev, "ehci_clk");
+	platform_device_register(&at91_usbh_ehci_device);
+}
+#else
+void __init at91_add_device_usbh_ehci(struct at91_usbh_data *data) {}
+#endif
+
+
+/* --------------------------------------------------------------------
  *  USB HS Device (Gadget)
  * -------------------------------------------------------------------- */
 
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index b8558ea..d7251b7 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -358,6 +358,7 @@ static void __init ek_board_init(void)
 	at91_add_device_serial();
 	/* USB HS Host */
 	at91_add_device_usbh_ohci(&ek_usbh_hs_data);
+	at91_add_device_usbh_ehci(&ek_usbh_hs_data);
 	/* USB HS Device */
 	at91_add_device_usba(&ek_usba_udc_data);
 	/* SPI */
diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index 74801d2..13640b0 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -92,6 +92,7 @@ struct at91_usbh_data {
 };
 extern void __init at91_add_device_usbh(struct at91_usbh_data *data);
 extern void __init at91_add_device_usbh_ohci(struct at91_usbh_data *data);
+extern void __init at91_add_device_usbh_ehci(struct at91_usbh_data *data);
 
  /* NAND / SmartMedia */
 struct atmel_nand_data {
-- 
1.5.3.7

