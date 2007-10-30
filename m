Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbXJ3Epf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbXJ3Epf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbXJ3EnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:43:00 -0400
Received: from rex.snapgear.com ([203.143.235.140]:37136 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754791AbXJ3Em7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:42:59 -0400
Date: Tue, 30 Oct 2007 14:42:24 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710300442.l9U4gOCW032254@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: platform setup for 5272 ColdFire UARTs
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to platform style configuration for 5272 ColdFire UARTs.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.23-rc1/arch/m68knommu/platform/5272/config.c linux-2.6.23-rc1.platform/arch/m68knommu/platform/5272/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/5272/config.c	2007-10-25 10:48:36.000000000 +1000
+++ linux-2.6.23-rc1.platform/arch/m68knommu/platform/5272/config.c	2007-10-30 14:18:24.000000000 +1000
@@ -13,11 +13,12 @@
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/dma.h>
 #include <asm/machdep.h>
+#include <asm/dma.h>
+#include <asm/io.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
-#include <asm/mcfdma.h>
+#include <asm/mcfuart.h>
 
 /***************************************************************************/
 
@@ -48,6 +49,60 @@ unsigned int dma_device_address[MAX_M68K
 
 /***************************************************************************/
 
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
+};
+
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
+
+/***************************************************************************/
+
 void mcf_disableall(void)
 {
 	volatile unsigned long	*icrp;
@@ -93,7 +148,7 @@ int mcf_timerirqpending(int timer)
 
 /***************************************************************************/
 
-void config_BSP(char *commandp, int size)
+void __init config_BSP(char *commandp, int size)
 {
 #if defined (CONFIG_MOD5272)
 	volatile unsigned char	*pivrp;
@@ -109,10 +164,6 @@ void config_BSP(char *commandp, int size
 	/* Copy command line from FLASH to local buffer... */
 	memcpy(commandp, (char *) 0xf0004000, size);
 	commandp[size-1] = 0;
-#elif defined(CONFIG_MTD_KeyTechnology)
-	/* Copy command line from FLASH to local buffer... */
-	memcpy(commandp, (char *) 0xffe06000, size);
-	commandp[size-1] = 0;
 #elif defined(CONFIG_CANCam)
 	/* Copy command line from FLASH to local buffer... */
 	memcpy(commandp, (char *) 0xf0010000, size);
@@ -125,3 +176,14 @@ void config_BSP(char *commandp, int size
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
