Return-Path: <linux-kernel-owner+w=401wt.eu-S1765882AbYBAHfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765882AbYBAHfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763545AbYBAHfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:35:15 -0500
Received: from rex.snapgear.com ([203.143.235.140]:47361 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763654AbYBAHfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:35:13 -0500
Date: Fri, 1 Feb 2008 17:34:10 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010734.m117YAx4022578@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: platform setup for 520x ColdFire parts
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to platform style configuration for 520x ColdFire parts.
Initial support is for the UARTs. DMA support moved to common code
for all ColdFire parts.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/arch/m68knommu/platform/520x/config.c linux-2.6.24-uc0/arch/m68knommu/platform/520x/config.c
--- linux-2.6.24/arch/m68knommu/platform/520x/config.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/arch/m68knommu/platform/520x/config.c	2007-11-30 11:03:11.000000000 +1000
@@ -5,7 +5,7 @@
  *
  *  Copyright (C) 2005,      Freescale (www.freescale.com)
  *  Copyright (C) 2005,      Intec Automation (mike@steroidmicros.com)
- *  Copyright (C) 1999-2003, Greg Ungerer (gerg@snapgear.com)
+ *  Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  *  Copyright (C) 2001-2003, SnapGear Inc. (www.snapgear.com)
  */
 
@@ -13,21 +13,93 @@
 
 #include <linux/kernel.h>
 #include <linux/param.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <asm/machdep.h>
-#include <asm/dma.h>
+#include <asm/coldfire.h>
+#include <asm/mcfsim.h>
+#include <asm/mcfuart.h>
 
 /***************************************************************************/
 
-/*
- *	DMA channel base address table.
- */
-unsigned int dma_base_addr[MAX_M68K_DMA_CHANNELS];
-unsigned int dma_device_address[MAX_M68K_DMA_CHANNELS];
+void coldfire_reset(void);
 
 /***************************************************************************/
 
-void coldfire_reset(void);
+static struct mcf_platform_uart m520x_uart_platform[] = {
+	{
+		.mapbase	= MCF_MBAR + MCFUART_BASE1,
+		.irq		= MCFINT_VECBASE + MCFINT_UART0,
+	},
+	{
+		.mapbase 	= MCF_MBAR + MCFUART_BASE2,
+		.irq		= MCFINT_VECBASE + MCFINT_UART1,
+	},
+	{
+		.mapbase 	= MCF_MBAR + MCFUART_BASE3,
+		.irq		= MCFINT_VECBASE + MCFINT_UART2,
+	},
+	{ },
+};
+
+static struct platform_device m520x_uart = {
+	.name			= "mcfuart",
+	.id			= 0,
+	.dev.platform_data	= m520x_uart_platform,
+};
+
+static struct platform_device *m520x_devices[] __initdata = {
+	&m520x_uart,
+};
+
+/***************************************************************************/
+
+#define	INTC0	(MCF_MBAR + MCFICM_INTC0)
+
+static void __init m520x_uart_init_line(int line, int irq)
+{
+	u32 imr;
+	u16 par;
+	u8 par2;
+
+	writeb(0x03, INTC0 + MCFINTC_ICR0 + MCFINT_UART0 + line);
+
+	imr = readl(INTC0 + MCFINTC_IMRL);
+	imr &= ~((1 << (irq - MCFINT_VECBASE)) | 1);
+	writel(imr, INTC0 + MCFINTC_IMRL);
+
+	switch (line) {
+	case 0:
+		par = readw(MCF_IPSBAR + MCF_GPIO_PAR_UART);
+		par |= MCF_GPIO_PAR_UART_PAR_UTXD0 |
+		       MCF_GPIO_PAR_UART_PAR_URXD0;
+		writew(par, MCF_IPSBAR + MCF_GPIO_PAR_UART);
+		break;
+	case 1:
+		par = readw(MCF_IPSBAR + MCF_GPIO_PAR_UART);
+		par |= MCF_GPIO_PAR_UART_PAR_UTXD1 |
+		       MCF_GPIO_PAR_UART_PAR_URXD1;
+		writew(par, MCF_IPSBAR + MCF_GPIO_PAR_UART);
+		break;
+	case 2:
+		par2 = readb(MCF_IPSBAR + MCF_GPIO_PAR_FECI2C);
+		par2 &= ~0x0F;
+		par2 |= MCF_GPIO_PAR_FECI2C_PAR_SCL_UTXD2 |
+			MCF_GPIO_PAR_FECI2C_PAR_SDA_URXD2;
+		writeb(par2, MCF_IPSBAR + MCF_GPIO_PAR_FECI2C);
+		break;
+	}
+}
+
+static void __init m520x_uarts_init(void)
+{
+	const int nrlines = ARRAY_SIZE(m520x_uart_platform);
+	int line;
+
+	for (line = 0; (line < nrlines); line++)
+		m520x_uart_init_line(line, m520x_uart_platform[line].irq);
+}
 
 /***************************************************************************/
 
@@ -42,9 +114,20 @@ void mcf_autovector(unsigned int vec)
 
 /***************************************************************************/
 
-void config_BSP(char *commandp, int size)
+void __init config_BSP(char *commandp, int size)
 {
 	mach_reset = coldfire_reset;
+	m520x_uarts_init();
+}
+
+/***************************************************************************/
+
+static int __init init_BSP(void)
+{
+	platform_add_devices(m520x_devices, ARRAY_SIZE(m520x_devices));
+	return 0;
 }
 
+arch_initcall(init_BSP);
+
 /***************************************************************************/
