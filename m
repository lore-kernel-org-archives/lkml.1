Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYHUEs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYHUEs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 00:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYHUErN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 00:47:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:60664 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbYHUErH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 00:47:07 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 5/9] serial/mpc52xx_uart: remove code associated with !CONFIG_PPC_MERGE
Date: Wed, 20 Aug 2008 23:46:54 -0500
Message-Id: <1219294018-12557-6-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1219294018-12557-5-git-send-email-galak@kernel.crashing.org>
References: <1219294018-12557-1-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-2-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-3-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-4-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-5-git-send-email-galak@kernel.crashing.org>
CC: linux-serial@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that arch/ppc is gone we don't need CONFIG_PPC_MERGE anymore
remove the dead code associated with !CONFIG_PPC_MERGE.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/serial/mpc52xx_uart.c |  181 +----------------------------------------
 1 files changed, 1 insertions(+), 180 deletions(-)

diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
index 3612607..6117d3d 100644
--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -72,13 +72,8 @@
 #include <linux/console.h>
 #include <linux/delay.h>
 #include <linux/io.h>
-
-#if defined(CONFIG_PPC_MERGE)
 #include <linux/of.h>
 #include <linux/of_platform.h>
-#else
-#include <linux/platform_device.h>
-#endif
 
 #include <asm/mpc52xx.h>
 #include <asm/mpc512x.h>
@@ -107,12 +102,11 @@ static struct uart_port mpc52xx_uart_ports[MPC52xx_PSC_MAXNUM];
 	 *        it's cleared, then a memset(...,0,...) should be added to
 	 *        the console_init
 	 */
-#if defined(CONFIG_PPC_MERGE)
+
 /* lookup table for matching device nodes to index numbers */
 static struct device_node *mpc52xx_uart_nodes[MPC52xx_PSC_MAXNUM];
 
 static void mpc52xx_uart_of_enumerate(void);
-#endif
 
 
 #define PSC(port) ((struct mpc52xx_psc __iomem *)((port)->membase))
@@ -255,17 +249,12 @@ static void mpc52xx_psc_cw_restore_ints(struct uart_port *port)
 /* Search for bus-frequency property in this node or a parent */
 static unsigned long mpc52xx_getuartclk(void *p)
 {
-#if defined(CONFIG_PPC_MERGE)
 	/*
 	 * 5200 UARTs have a / 32 prescaler
 	 * but the generic serial code assumes 16
 	 * so return ipb freq / 2
 	 */
 	return mpc52xx_find_ipb_freq(p) / 2;
-#else
-	pr_debug("unexpected call to mpc52xx_getuartclk with arch/ppc\n");
-	return NULL;
-#endif
 }
 
 static struct psc_ops mpc52xx_psc_ops = {
@@ -886,10 +875,6 @@ mpc52xx_console_get_options(struct uart_port *port,
 
 	/* CT{U,L}R are write-only ! */
 	*baud = CONFIG_SERIAL_MPC52xx_CONSOLE_BAUD;
-#if !defined(CONFIG_PPC_MERGE)
-	if (__res.bi_baudrate)
-		*baud = __res.bi_baudrate;
-#endif
 
 	/* Parse them */
 	switch (mr1 & MPC52xx_PSC_MODE_BITS_MASK) {
@@ -946,42 +931,6 @@ mpc52xx_console_write(struct console *co, const char *s, unsigned int count)
 	psc_ops->cw_restore_ints(port);
 }
 
-#if !defined(CONFIG_PPC_MERGE)
-static int __init
-mpc52xx_console_setup(struct console *co, char *options)
-{
-	struct uart_port *port = &mpc52xx_uart_ports[co->index];
-
-	int baud = CONFIG_SERIAL_MPC52xx_CONSOLE_BAUD;
-	int bits = 8;
-	int parity = 'n';
-	int flow = 'n';
-
-	if (co->index < 0 || co->index >= MPC52xx_PSC_MAXNUM)
-		return -EINVAL;
-
-	/* Basic port init. Needed since we use some uart_??? func before
-	 * real init for early access */
-	spin_lock_init(&port->lock);
-	port->uartclk	= __res.bi_ipbfreq / 2; /* Look at CTLR doc */
-	port->ops	= &mpc52xx_uart_ops;
-	port->mapbase	= MPC52xx_PA(MPC52xx_PSCx_OFFSET(co->index+1));
-
-	/* We ioremap ourself */
-	port->membase = ioremap(port->mapbase, MPC52xx_PSC_SIZE);
-	if (port->membase == NULL)
-		return -EINVAL;
-
-	/* Setup the port parameters accoding to options */
-	if (options)
-		uart_parse_options(options, &baud, &parity, &bits, &flow);
-	else
-		mpc52xx_console_get_options(port, &baud, &parity, &bits, &flow);
-
-	return uart_set_options(port, co, baud, parity, bits, flow);
-}
-
-#else
 
 static int __init
 mpc52xx_console_setup(struct console *co, char *options)
@@ -1053,7 +1002,6 @@ mpc52xx_console_setup(struct console *co, char *options)
 
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
-#endif /* defined(CONFIG_PPC_MERGE) */
 
 
 static struct uart_driver mpc52xx_uart_driver;
@@ -1072,9 +1020,7 @@ static struct console mpc52xx_console = {
 static int __init
 mpc52xx_console_init(void)
 {
-#if defined(CONFIG_PPC_MERGE)
 	mpc52xx_uart_of_enumerate();
-#endif
 	register_console(&mpc52xx_console);
 	return 0;
 }
@@ -1100,115 +1046,6 @@ static struct uart_driver mpc52xx_uart_driver = {
 	.cons		= MPC52xx_PSC_CONSOLE,
 };
 
-
-#if !defined(CONFIG_PPC_MERGE)
-/* ======================================================================== */
-/* Platform Driver                                                          */
-/* ======================================================================== */
-
-static int __devinit
-mpc52xx_uart_probe(struct platform_device *dev)
-{
-	struct resource *res = dev->resource;
-
-	struct uart_port *port = NULL;
-	int i, idx, ret;
-
-	/* Check validity & presence */
-	idx = dev->id;
-	if (idx < 0 || idx >= MPC52xx_PSC_MAXNUM)
-		return -EINVAL;
-
-	if (!mpc52xx_match_psc_function(idx, "uart"))
-		return -ENODEV;
-
-	/* Init the port structure */
-	port = &mpc52xx_uart_ports[idx];
-
-	spin_lock_init(&port->lock);
-	port->uartclk	= __res.bi_ipbfreq / 2; /* Look at CTLR doc */
-	port->fifosize	= 512;
-	port->iotype	= UPIO_MEM;
-	port->flags	= UPF_BOOT_AUTOCONF |
-			  (uart_console(port) ? 0 : UPF_IOREMAP);
-	port->line	= idx;
-	port->ops	= &mpc52xx_uart_ops;
-	port->dev	= &dev->dev;
-
-	/* Search for IRQ and mapbase */
-	for (i = 0 ; i < dev->num_resources ; i++, res++) {
-		if (res->flags & IORESOURCE_MEM)
-			port->mapbase = res->start;
-		else if (res->flags & IORESOURCE_IRQ)
-			port->irq = res->start;
-	}
-	if (!port->irq || !port->mapbase)
-		return -EINVAL;
-
-	/* Add the port to the uart sub-system */
-	ret = uart_add_one_port(&mpc52xx_uart_driver, port);
-	if (!ret)
-		platform_set_drvdata(dev, (void *)port);
-
-	return ret;
-}
-
-static int
-mpc52xx_uart_remove(struct platform_device *dev)
-{
-	struct uart_port *port = (struct uart_port *) platform_get_drvdata(dev);
-
-	platform_set_drvdata(dev, NULL);
-
-	if (port)
-		uart_remove_one_port(&mpc52xx_uart_driver, port);
-
-	return 0;
-}
-
-#ifdef CONFIG_PM
-static int
-mpc52xx_uart_suspend(struct platform_device *dev, pm_message_t state)
-{
-	struct uart_port *port = (struct uart_port *) platform_get_drvdata(dev);
-
-	if (port)
-		uart_suspend_port(&mpc52xx_uart_driver, port);
-
-	return 0;
-}
-
-static int
-mpc52xx_uart_resume(struct platform_device *dev)
-{
-	struct uart_port *port = (struct uart_port *) platform_get_drvdata(dev);
-
-	if (port)
-		uart_resume_port(&mpc52xx_uart_driver, port);
-
-	return 0;
-}
-#endif
-
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:mpc52xx-psc");
-
-static struct platform_driver mpc52xx_uart_platform_driver = {
-	.probe		= mpc52xx_uart_probe,
-	.remove		= mpc52xx_uart_remove,
-#ifdef CONFIG_PM
-	.suspend	= mpc52xx_uart_suspend,
-	.resume		= mpc52xx_uart_resume,
-#endif
-	.driver		= {
-		.owner	= THIS_MODULE,
-		.name	= "mpc52xx-psc",
-	},
-};
-#endif /* !defined(CONFIG_PPC_MERGE) */
-
-
-#if defined(CONFIG_PPC_MERGE)
 /* ======================================================================== */
 /* OF Platform Driver                                                       */
 /* ======================================================================== */
@@ -1402,7 +1239,6 @@ static struct of_platform_driver mpc52xx_uart_of_driver = {
 		.name	= "mpc52xx-psc-uart",
 	},
 };
-#endif /* defined(CONFIG_PPC_MERGE) */
 
 
 /* ======================================================================== */
@@ -1423,7 +1259,6 @@ mpc52xx_uart_init(void)
 		return ret;
 	}
 
-#if defined(CONFIG_PPC_MERGE)
 	mpc52xx_uart_of_enumerate();
 
 	ret = of_register_platform_driver(&mpc52xx_uart_of_driver);
@@ -1433,16 +1268,6 @@ mpc52xx_uart_init(void)
 		uart_unregister_driver(&mpc52xx_uart_driver);
 		return ret;
 	}
-#else
-	psc_ops = &mpc52xx_psc_ops;
-	ret = platform_driver_register(&mpc52xx_uart_platform_driver);
-	if (ret) {
-		printk(KERN_ERR "%s: platform_driver_register failed (%i)\n",
-		       __FILE__, ret);
-		uart_unregister_driver(&mpc52xx_uart_driver);
-		return ret;
-	}
-#endif
 
 	return 0;
 }
@@ -1450,11 +1275,7 @@ mpc52xx_uart_init(void)
 static void __exit
 mpc52xx_uart_exit(void)
 {
-#if defined(CONFIG_PPC_MERGE)
 	of_unregister_platform_driver(&mpc52xx_uart_of_driver);
-#else
-	platform_driver_unregister(&mpc52xx_uart_platform_driver);
-#endif
 	uart_unregister_driver(&mpc52xx_uart_driver);
 }
 
-- 
1.5.5.1

