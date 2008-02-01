Return-Path: <linux-kernel-owner+w=401wt.eu-S934108AbYBAHgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108AbYBAHgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933518AbYBAHfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:35:53 -0500
Received: from rex.snapgear.com ([203.143.235.140]:47369 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933493AbYBAHfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:35:51 -0500
Date: Fri, 1 Feb 2008 17:34:32 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010734.m117YWOS022601@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: platform setup for 5272 ColdFire parts
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to platform style configuration for 5272 ColdFire parts.
Initial support is for the UARTs. DMA support moved to common code
for all ColdFire parts.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/arch/m68knommu/platform/5272/config.c linux-2.6.24-uc0/arch/m68knommu/platform/5272/config.c
--- linux-2.6.24/arch/m68knommu/platform/5272/config.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/arch/m68knommu/platform/5272/config.c	2008-01-11 13:37:38.000000000 +1000
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
 
@@ -37,14 +37,57 @@ unsigned char ledbank = 0xff;
 
 /***************************************************************************/
 
-/*
- *	DMA channel base address table.
- */
-unsigned int   dma_base_addr[MAX_M68K_DMA_CHANNELS] = {
-        MCF_MBAR + MCFDMA_BASE0,
+static struct mcf_platform_uart m5272_uart_platform[] = {
+	{
+		.mapbase	= MCF_MBAR + MCFUART_BASE1,
+		.irq		= 73,
+	},
+	{
+		.mapbase 	= MCF_MBAR + MCFUART_BASE2,
+		.irq		= 74,
+	},
+	{ },
+};
+
+static struct platform_device m5272_uart = {
+	.name			= "mcfuart",
+	.id			= 0,
+	.dev.platform_data	= m5272_uart_platform,
 };
 
-unsigned int dma_device_address[MAX_M68K_DMA_CHANNELS];
+static struct platform_device *m5272_devices[] __initdata = {
+	&m5272_uart,
+};
+
+/***************************************************************************/
+
+static void __init m5272_uart_init_line(int line, int irq)
+{
+	u32 v;
+
+	if ((line >= 0) && (line < 2)) {
+		v = (line) ? 0x0e000000 : 0xe0000000;
+		writel(v, MCF_MBAR + MCFSIM_ICR2);
+
+		/* Enable the output lines for the serial ports */
+		v = readl(MCF_MBAR + MCFSIM_PBCNT);
+		v = (v & ~0x000000ff) | 0x00000055;
+		writel(v, MCF_MBAR + MCFSIM_PBCNT);
+
+		v = readl(MCF_MBAR + MCFSIM_PDCNT);
+		v = (v & ~0x000003fc) | 0x000002a8;
+		writel(v, MCF_MBAR + MCFSIM_PDCNT);
+	}
+}
+
+static void __init m5272_uarts_init(void)
+{
+	const int nrlines = ARRAY_SIZE(m5272_uart_platform);
+	int line;
+
+	for (line = 0; (line < nrlines); line++)
+		m5272_uart_init_line(line, m5272_uart_platform[line].irq);
+}
 
 /***************************************************************************/
 
@@ -93,7 +136,7 @@ int mcf_timerirqpending(int timer)
 
 /***************************************************************************/
 
-void config_BSP(char *commandp, int size)
+void __init config_BSP(char *commandp, int size)
 {
 #if defined (CONFIG_MOD5272)
 	volatile unsigned char	*pivrp;
@@ -125,3 +168,14 @@ void config_BSP(char *commandp, int size
 }
 
 /***************************************************************************/
+
+static int __init init_BSP(void)
+{
+	m5272_uarts_init();
+	platform_add_devices(m5272_devices, ARRAY_SIZE(m5272_devices));
+	return 0;
+}
+
+arch_initcall(init_BSP);
+
+/***************************************************************************/
