Return-Path: <linux-kernel-owner+w=401wt.eu-S932325AbYBAHhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbYBAHhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbYBAHgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:36:12 -0500
Received: from rex.snapgear.com ([203.143.235.140]:47374 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933717AbYBAHgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:36:08 -0500
Date: Fri, 1 Feb 2008 17:34:58 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010734.m117Yw8o022617@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: platform setup for 532x ColdFire parts
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to platform style configuration for 532x ColdFire parts.
Initial support is for the UARTs. DMA support moved to common code
for all ColdFire parts.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/arch/m68knommu/platform/532x/config.c linux-2.6.24-uc0/arch/m68knommu/platform/532x/config.c
--- linux-2.6.24/arch/m68knommu/platform/532x/config.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/arch/m68knommu/platform/532x/config.c	2008-01-11 13:37:38.000000000 +1000
@@ -21,10 +21,11 @@
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/dma.h>
+#include <linux/io.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
+#include <asm/mcfuart.h>
 #include <asm/mcfdma.h>
 #include <asm/mcfwdebug.h>
 
@@ -38,11 +39,60 @@ extern unsigned int mcf_timerlevel;
 
 /***************************************************************************/
 
-/*
- *	DMA channel base address table.
- */
-unsigned int dma_base_addr[MAX_M68K_DMA_CHANNELS] = { };
-unsigned int dma_device_address[MAX_M68K_DMA_CHANNELS];
+static struct mcf_platform_uart m532x_uart_platform[] = {
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
+static struct platform_device m532x_uart = {
+	.name			= "mcfuart",
+	.id			= 0,
+	.dev.platform_data	= m532x_uart_platform,
+};
+
+static struct platform_device *m532x_devices[] __initdata = {
+	&m532x_uart,
+};
+
+/***************************************************************************/
+
+static void __init m532x_uart_init_line(int line, int irq)
+{
+	if (line == 0) {
+		MCF_INTC0_ICR26 = 0x3;
+		MCF_INTC0_CIMR = 26;
+		/* GPIO initialization */
+		MCF_GPIO_PAR_UART |= 0x000F;
+	} else if (line == 1) {
+		MCF_INTC0_ICR27 = 0x3;
+		MCF_INTC0_CIMR = 27;
+		/* GPIO initialization */
+		MCF_GPIO_PAR_UART |= 0x0FF0;
+	} else if (line == 2) {
+		MCF_INTC0_ICR28 = 0x3;
+		MCF_INTC0_CIMR = 28;
+	}
+}
+
+static void __init m532x_uarts_init(void)
+{
+	const int nrlines = ARRAY_SIZE(m532x_uart_platform);
+	int line;
+
+	for (line = 0; (line < nrlines); line++)
+		m532x_uart_init_line(line, m532x_uart_platform[line].irq);
+}
 
 /***************************************************************************/
 
@@ -80,7 +130,7 @@ int mcf_timerirqpending(int timer)
 
 /***************************************************************************/
 
-void config_BSP(char *commandp, int size)
+void __init config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 
@@ -99,7 +149,7 @@ void config_BSP(char *commandp, int size
 	mcf_profilevector = 64+33;
 	mach_reset = coldfire_reset;
 
-#ifdef MCF_BDM_DISABLE
+#ifdef CONFIG_BDM_DISABLE
 	/*
 	 * Disable the BDM clocking.  This also turns off most of the rest of
 	 * the BDM device.  This is good for EMC reasons. This option is not
@@ -110,9 +160,19 @@ void config_BSP(char *commandp, int size
 }
 
 /***************************************************************************/
-/* Board initialization */
 
-/********************************************************************/
+static int __init init_BSP(void)
+{
+	m532x_uarts_init();
+	platform_add_devices(m532x_devices, ARRAY_SIZE(m532x_devices));
+	return 0;
+}
+
+arch_initcall(init_BSP);
+
+/***************************************************************************/
+/* Board initialization */
+/***************************************************************************/
 /* 
  * PLL min/max specifications
  */
