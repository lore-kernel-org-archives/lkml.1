Return-Path: <linux-kernel-owner+w=401wt.eu-S934915AbYBAHiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934915AbYBAHiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933824AbYBAHgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:36:13 -0500
Received: from rex.snapgear.com ([203.143.235.140]:47375 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933781AbYBAHgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:36:08 -0500
Date: Fri, 1 Feb 2008 17:35:03 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010735.m117Z3xC022621@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: platform setup for 5407 ColdFire parts
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to platform style configuration for 5407 ColdFire parts.
Initial support is for the UARTs. DMA support moved to common code
for all ColdFire parts.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/arch/m68knommu/platform/5407/config.c linux-2.6.24-uc0/arch/m68knommu/platform/5407/config.c
--- linux-2.6.24/arch/m68knommu/platform/5407/config.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/arch/m68knommu/platform/5407/config.c	2008-01-11 13:37:39.000000000 +1000
@@ -13,11 +13,11 @@
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
 
@@ -29,17 +29,51 @@ extern unsigned int mcf_timerlevel;
 
 /***************************************************************************/
 
-/*
- *	DMA channel base address table.
- */
-unsigned int   dma_base_addr[MAX_M68K_DMA_CHANNELS] = {
-        MCF_MBAR + MCFDMA_BASE0,
-        MCF_MBAR + MCFDMA_BASE1,
-        MCF_MBAR + MCFDMA_BASE2,
-        MCF_MBAR + MCFDMA_BASE3,
+static struct mcf_platform_uart m5407_uart_platform[] = {
+	{
+		.mapbase	= MCF_MBAR + MCFUART_BASE1,
+		.irq		= 73,
+	},
+	{
+		.mapbase 	= MCF_MBAR + MCFUART_BASE2,
+		.irq		= 74,
+	},
+	{ },
 };
 
-unsigned int dma_device_address[MAX_M68K_DMA_CHANNELS];
+static struct platform_device m5407_uart = {
+	.name			= "mcfuart",
+	.id			= 0,
+	.dev.platform_data	= m5407_uart_platform,
+};
+
+static struct platform_device *m5407_devices[] __initdata = {
+	&m5407_uart,
+};
+
+/***************************************************************************/
+
+static void __init m5407_uart_init_line(int line, int irq)
+{
+	if (line == 0) {
+		writel(MCFSIM_ICR_LEVEL6 | MCFSIM_ICR_PRI1, MCF_MBAR + MCFSIM_UART1ICR);
+		writeb(irq, MCFUART_BASE1 + MCFUART_UIVR);
+		mcf_setimr(mcf_getimr() & ~MCFSIM_IMR_UART1);
+	} else if (line == 1) {
+		writel(MCFSIM_ICR_LEVEL6 | MCFSIM_ICR_PRI2, MCF_MBAR + MCFSIM_UART2ICR);
+		writeb(irq, MCFUART_BASE2 + MCFUART_UIVR);
+		mcf_setimr(mcf_getimr() & ~MCFSIM_IMR_UART2);
+	}
+}
+
+static void __init m5407_uarts_init(void)
+{
+	const int nrlines = ARRAY_SIZE(m5407_uart_platform);
+	int line;
+
+	for (line = 0; (line < nrlines); line++)
+		m5407_uart_init_line(line, m5407_uart_platform[line].irq);
+}
 
 /***************************************************************************/
 
@@ -90,7 +124,7 @@ int mcf_timerirqpending(int timer)
 
 /***************************************************************************/
 
-void config_BSP(char *commandp, int size)
+void __init config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 
@@ -105,3 +139,14 @@ void config_BSP(char *commandp, int size
 }
 
 /***************************************************************************/
+
+static int __init init_BSP(void)
+{
+	m5407_uarts_init();
+	platform_add_devices(m5407_devices, ARRAY_SIZE(m5407_devices));
+	return 0;
+}
+
+arch_initcall(init_BSP);
+
+/***************************************************************************/
