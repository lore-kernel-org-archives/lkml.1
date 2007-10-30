Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbXJ3EpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbXJ3EpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbXJ3Em6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:42:58 -0400
Received: from rex.snapgear.com ([203.143.235.140]:37135 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754758AbXJ3Em5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:42:57 -0400
Date: Tue, 30 Oct 2007 14:41:56 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710300441.l9U4fuuI032236@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: platform setup for 5206e ColdFire UARTs
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to platform style configuration for 5206e ColdFire UARTs.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.23-rc1/arch/m68knommu/platform/5206e/config.c linux-2.6.23-rc1.platform/arch/m68knommu/platform/5206e/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/5206e/config.c	2007-10-25 10:48:36.000000000 +1000
+++ linux-2.6.23-rc1.platform/arch/m68knommu/platform/5206e/config.c	2007-10-30 14:18:24.000000000 +1000
@@ -10,9 +10,11 @@
 
 #include <linux/kernel.h>
 #include <linux/param.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/dma.h>
 #include <asm/machdep.h>
+#include <asm/dma.h>
+#include <asm/io.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
@@ -35,6 +37,54 @@ unsigned int dma_device_address[MAX_M68K
 
 /***************************************************************************/
 
+static struct mcf_platform_uart m5206_uart_platform[] = {
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
+static struct platform_device m5206_uart = {
+	.name			= "mcfuart",
+	.id			= 0,
+	.dev.platform_data	= m5206_uart_platform,
+};
+
+static struct platform_device *m5206_devices[] __initdata = {
+	&m5206_uart,
+};
+
+/***************************************************************************/
+
+static void __init m5206_uart_init_line(int line, int irq)
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
+static void __init m5206_uarts_init(void)
+{
+	const int nrlines = ARRAY_SIZE(m5206_uart_platform);
+	int line;
+
+	for (line = 0; (line < nrlines); line++)
+		m5206_uart_init_line(line, m5206_uart_platform[line].irq);
+}
+
+/***************************************************************************/
+
 void mcf_autovector(unsigned int vec)
 {
 	volatile unsigned char  *mbar;
@@ -85,7 +135,7 @@ int mcf_timerirqpending(int timer)
 
 /***************************************************************************/
 
-void config_BSP(char *commandp, int size)
+void __init config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 
@@ -99,3 +149,14 @@ void config_BSP(char *commandp, int size
 }
 
 /***************************************************************************/
+
+static int __init init_BSP(void)
+{
+	m5206_uarts_init();
+	platform_add_devices(m5206_devices, ARRAY_SIZE(m5206_devices));
+	return 0;
+}
+
+arch_initcall(init_BSP);
+
+/***************************************************************************/
