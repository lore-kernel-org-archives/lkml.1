Return-Path: <linux-kernel-owner+w=401wt.eu-S934859AbYBAHjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934859AbYBAHjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbYBAHgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:36:21 -0500
Received: from rex.snapgear.com ([203.143.235.140]:47379 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933829AbYBAHgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:36:17 -0500
Date: Fri, 1 Feb 2008 17:34:40 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010734.m117YeZV022603@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: platform setup for 527x ColdFire parts
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to platform style configuration for 527x ColdFire parts.
Initial support is for the UARTs. DMA support moved to common code
for all ColdFire parts.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/arch/m68knommu/platform/527x/config.c linux-2.6.24-uc0/arch/m68knommu/platform/527x/config.c
--- linux-2.6.24/arch/m68knommu/platform/527x/config.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/arch/m68knommu/platform/527x/config.c	2007-11-30 11:03:11.000000000 +1000
@@ -16,11 +16,11 @@
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/dma.h>
+#include <linux/io.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
-#include <asm/mcfdma.h>
+#include <asm/mcfuart.h>
 
 /***************************************************************************/
 
@@ -28,14 +28,72 @@ void coldfire_reset(void);
 
 /***************************************************************************/
 
-/*
- *	DMA channel base address table.
- */
-unsigned int   dma_base_addr[MAX_M68K_DMA_CHANNELS] = {
-        MCF_MBAR + MCFDMA_BASE0,
+static struct mcf_platform_uart m527x_uart_platform[] = {
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
 };
 
-unsigned int dma_device_address[MAX_M68K_DMA_CHANNELS];
+static struct platform_device m527x_uart = {
+	.name			= "mcfuart",
+	.id			= 0,
+	.dev.platform_data	= m527x_uart_platform,
+};
+
+static struct platform_device *m527x_devices[] __initdata = {
+	&m527x_uart,
+};
+
+/***************************************************************************/
+
+#define	INTC0	(MCF_MBAR + MCFICM_INTC0)
+
+static void __init m527x_uart_init_line(int line, int irq)
+{
+	u16 sepmask;
+	u32 imr;
+
+	if ((line < 0) || (line > 2))
+		return;
+
+	/* level 6, line based priority */
+	writeb(0x30+line, INTC0 + MCFINTC_ICR0 + MCFINT_UART0 + line);
+
+	imr = readl(INTC0 + MCFINTC_IMRL);
+	imr &= ~((1 << (irq - MCFINT_VECBASE)) | 1);
+	writel(imr, INTC0 + MCFINTC_IMRL);
+
+	/*
+	 * External Pin Mask Setting & Enable External Pin for Interface
+	 */
+	sepmask = readw(MCF_IPSBAR + MCF_GPIO_PAR_UART);
+	if (line == 0)
+		sepmask |= UART0_ENABLE_MASK;
+	else if (line == 1)
+		sepmask |= UART1_ENABLE_MASK;
+	else if (line == 2)
+		sepmask |= UART2_ENABLE_MASK;
+	writew(sepmask, MCF_IPSBAR + MCF_GPIO_PAR_UART);
+}
+
+static void __init m527x_uarts_init(void)
+{
+	const int nrlines = ARRAY_SIZE(m527x_uart_platform);
+	int line;
+
+	for (line = 0; (line < nrlines); line++)
+		m527x_uart_init_line(line, m527x_uart_platform[line].irq);
+}
 
 /***************************************************************************/
 
@@ -54,10 +112,21 @@ void mcf_autovector(unsigned int vec)
 
 /***************************************************************************/
 
-void config_BSP(char *commandp, int size)
+void __init config_BSP(char *commandp, int size)
 {
 	mcf_disableall();
 	mach_reset = coldfire_reset;
 }
 
 /***************************************************************************/
+
+static int __init init_BSP(void)
+{
+	m527x_uarts_init();
+	platform_add_devices(m527x_devices, ARRAY_SIZE(m527x_devices));
+	return 0;
+}
+
+arch_initcall(init_BSP);
+
+/***************************************************************************/
