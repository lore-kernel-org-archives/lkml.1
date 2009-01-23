Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbZAWLDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbZAWLDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbZAWLBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:01:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:5663 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762208AbZAWLBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:01:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=BMt1sZ2R7QmATHLMWpO+Zy0g32t+r3GRjbtDLRWIkO/ZVaGJl9ukcZGJMbDpw17NSH
         /pitTuF4bQIfefZXUo8vA/GM18BRuLI5peiIAgb8bcmaraFKpo4g0ykNjnlYrZIaQTG2
         Mc+F4XixnQ9ynKC8tqjZg6RmbDXEVCKR1P2XY=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, gregkh@suse.de, roel.kluin@gmail.com,
       lethal@linux-sh.org, Magnus Damm <magnus.damm@gmail.com>,
       akpm@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de
Date: Fri, 23 Jan 2009 19:59:13 +0900
Message-Id: <20090123105913.18779.25389.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
References: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
Subject: [PATCH 009/011] sh-sci: add early platform support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch removes the old duplicated early serial code and
adds early platform support to the sh-sci driver.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 arch/sh/Kconfig.debug         |   27 -------
 arch/sh/kernel/early_printk.c |  142 -----------------------------------------
 drivers/serial/sh-sci.c       |   48 +++++++++++--
 3 files changed, 41 insertions(+), 176 deletions(-)

--- 0001/arch/sh/Kconfig.debug
+++ work/arch/sh/Kconfig.debug	2009-01-22 17:16:56.000000000 +0900
@@ -19,34 +19,9 @@ config SH_STANDARD_BIOS
 	  mask ROM and no flash (WindowsCE machines fall in this category).
 	  If unsure, say N.
 
-config EARLY_SCIF_CONSOLE
-	bool "Use early SCIF console"
-	help
-	  This enables an early console using a fixed SCIF port. This can
-	  be used by platforms that are either not running the SH
-	  standard BIOS, or do not wish to use the BIOS callbacks for the
-	  serial I/O.
-
-config EARLY_SCIF_CONSOLE_PORT
-	hex
-	depends on EARLY_SCIF_CONSOLE
-	default "0xa4400000" if CPU_SUBTYPE_SH7712 || CPU_SUBTYPE_SH7705
-	default "0xa4430000" if CPU_SUBTYPE_SH7720 || CPU_SUBTYPE_SH7721
-	default "0xf8420000" if CPU_SUBTYPE_SH7619
-	default "0xff804000" if CPU_SUBTYPE_MXG
-	default "0xffc30000" if CPU_SUBTYPE_SHX3
-	default "0xffe00000" if CPU_SUBTYPE_SH7780 || CPU_SUBTYPE_SH7763 || \
-				CPU_SUBTYPE_SH7722 || CPU_SUBTYPE_SH7366 || \
-				CPU_SUBTYPE_SH7343
-	default "0xffe80000" if CPU_SH4
-	default "0xffea0000" if CPU_SUBTYPE_SH7785
-	default "0xfffe8000" if CPU_SUBTYPE_SH7203
-	default "0xfffe9800" if CPU_SUBTYPE_SH7206 || CPU_SUBTYPE_SH7263
-	default "0x00000000"
-
 config EARLY_PRINTK
 	bool "Early printk support"
-	depends on SH_STANDARD_BIOS || EARLY_SCIF_CONSOLE
+	depends on SH_STANDARD_BIOS
 	help
 	  Say Y here to redirect kernel printk messages to the serial port
 	  used by the SH-IPL bootloader, starting very early in the boot
--- 0001/arch/sh/kernel/early_printk.c
+++ work/arch/sh/kernel/early_printk.c	2009-01-22 17:16:56.000000000 +0900
@@ -59,134 +59,6 @@ static struct console bios_console = {
 };
 #endif
 
-#ifdef CONFIG_EARLY_SCIF_CONSOLE
-#include <linux/serial_core.h>
-#include "../../../drivers/serial/sh-sci.h"
-
-#if defined(CONFIG_CPU_SUBTYPE_SH7720) || \
-    defined(CONFIG_CPU_SUBTYPE_SH7721)
-#define EPK_SCSMR_VALUE 0x000
-#define EPK_SCBRR_VALUE 0x00C
-#define EPK_FIFO_SIZE 64
-#define EPK_FIFO_BITS (0x7f00 >> 8)
-#else
-#define EPK_FIFO_SIZE 16
-#define EPK_FIFO_BITS (0x1f00 >> 8)
-#endif
-
-static struct uart_port scif_port = {
-	.type		= PORT_SCIF,
-	.mapbase	= CONFIG_EARLY_SCIF_CONSOLE_PORT,
-	.membase	= (char __iomem *)CONFIG_EARLY_SCIF_CONSOLE_PORT,
-};
-
-static void scif_sercon_putc(int c)
-{
-	while (((sci_in(&scif_port, SCFDR) & EPK_FIFO_BITS) >= EPK_FIFO_SIZE))
-		;
-
-	sci_in(&scif_port, SCxSR);
-	sci_out(&scif_port, SCxSR, 0xf3 & ~(0x20 | 0x40));
-	sci_out(&scif_port, SCxTDR, c);
-
-	while ((sci_in(&scif_port, SCxSR) & 0x40) == 0)
-		;
-
-	if (c == '\n')
-		scif_sercon_putc('\r');
-}
-
-static void scif_sercon_write(struct console *con, const char *s,
-			      unsigned count)
-{
-	while (count-- > 0)
-		scif_sercon_putc(*s++);
-}
-
-static int __init scif_sercon_setup(struct console *con, char *options)
-{
-	con->cflag = CREAD | HUPCL | CLOCAL | B115200 | CS8;
-
-	return 0;
-}
-
-static struct console scif_console = {
-	.name		= "sercon",
-	.write		= scif_sercon_write,
-	.setup		= scif_sercon_setup,
-	.flags		= CON_PRINTBUFFER,
-	.index		= -1,
-};
-
-#if !defined(CONFIG_SH_STANDARD_BIOS)
-#if defined(CONFIG_CPU_SUBTYPE_SH7720) || \
-    defined(CONFIG_CPU_SUBTYPE_SH7721)
-static void scif_sercon_init(char *s)
-{
-	sci_out(&scif_port, SCSCR, 0x0000);	/* clear TE and RE */
-	sci_out(&scif_port, SCFCR, 0x4006);	/* reset */
-	sci_out(&scif_port, SCSCR, 0x0000);	/* select internal clock */
-	sci_out(&scif_port, SCSMR, EPK_SCSMR_VALUE);
-	sci_out(&scif_port, SCBRR, EPK_SCBRR_VALUE);
-
-	mdelay(1);	/* wait 1-bit time */
-
-	sci_out(&scif_port, SCFCR, 0x0030);	/* TTRG=b'11 */
-	sci_out(&scif_port, SCSCR, 0x0030);	/* TE, RE */
-}
-#elif defined(CONFIG_CPU_SH4)
-#define DEFAULT_BAUD 115200
-/*
- * Simple SCIF init, primarily aimed at SH7750 and other similar SH-4
- * devices that aren't using sh-ipl+g.
- */
-static void scif_sercon_init(char *s)
-{
-	struct uart_port *port = &scif_port;
-	unsigned baud = DEFAULT_BAUD;
-	unsigned int status;
-	char *e;
-
-	if (*s == ',')
-		++s;
-
-	if (*s) {
-		/* ignore ioport/device name */
-		s += strcspn(s, ",");
-		if (*s == ',')
-			s++;
-	}
-
-	if (*s) {
-		baud = simple_strtoul(s, &e, 0);
-		if (baud == 0 || s == e)
-			baud = DEFAULT_BAUD;
-	}
-
-	do {
-		status = sci_in(port, SCxSR);
-	} while (!(status & SCxSR_TEND(port)));
-
-	sci_out(port, SCSCR, 0);	 /* TE=0, RE=0 */
-	sci_out(port, SCFCR, SCFCR_RFRST | SCFCR_TFRST);
-	sci_out(port, SCSMR, 0);
-
-	/* Set baud rate */
-	sci_out(port, SCBRR, (CONFIG_SH_PCLK_FREQ + 16 * baud) /
-		(32 * baud) - 1);
-	udelay((1000000+(baud-1)) / baud); /* Wait one bit interval */
-
-	sci_out(port, SCSPTR, 0);
-	sci_out(port, SCxSR, 0x60);
-	sci_out(port, SCLSR, 0);
-
-	sci_out(port, SCFCR, 0);
-	sci_out(port, SCSCR, 0x30);	 /* TE=1, RE=1 */
-}
-#endif /* defined(CONFIG_CPU_SUBTYPE_SH7720) */
-#endif /* !defined(CONFIG_SH_STANDARD_BIOS) */
-#endif /* CONFIG_EARLY_SCIF_CONSOLE */
-
 /*
  * Setup a default console, if more than one is compiled in, rely on the
  * earlyprintk= parsing to give priority.
@@ -194,8 +66,6 @@ static void scif_sercon_init(char *s)
 static struct console *early_console =
 #ifdef CONFIG_SH_STANDARD_BIOS
 	&bios_console
-#elif defined(CONFIG_EARLY_SCIF_CONSOLE)
-	&scif_console
 #else
 	NULL
 #endif
@@ -215,18 +85,6 @@ static int __init setup_early_printk(cha
 	if (!strncmp(buf, "bios", 4))
 		early_console = &bios_console;
 #endif
-#if defined(CONFIG_EARLY_SCIF_CONSOLE)
-	if (!strncmp(buf, "serial", 6)) {
-		early_console = &scif_console;
-
-#if !defined(CONFIG_SH_STANDARD_BIOS)
-#if defined(CONFIG_CPU_SH4) || defined(CONFIG_CPU_SUBTYPE_SH7720) || \
-    defined(CONFIG_CPU_SUBTYPE_SH7721)
-		scif_sercon_init(buf + 6);
-#endif
-#endif
-	}
-#endif
 
 	if (likely(early_console)) {
 		if (keep_early)
--- 0009/drivers/serial/sh-sci.c
+++ work/drivers/serial/sh-sci.c	2009-01-22 17:14:27.000000000 +0900
@@ -1074,10 +1075,13 @@ static void __devinit sci_init_single(st
 #endif
 	sci_port->port.uartclk	= CONFIG_CPU_CLOCK;
 #elif defined(CONFIG_HAVE_CLK)
-	sci_port->iclk		= p->clk ? clk_get(&dev->dev, p->clk) : NULL;
-	sci_port->dclk		= clk_get(&dev->dev, "module_clk");
-	sci_port->enable	= sci_clk_enable;
-	sci_port->disable	= sci_clk_disable;
+
+	if (dev) {
+		sci_port->iclk = p->clk ? clk_get(&dev->dev, p->clk) : NULL;
+		sci_port->dclk = clk_get(&dev->dev, "module_clk");
+		sci_port->enable = sci_clk_enable;
+		sci_port->disable = sci_clk_disable;
+	}
 #else
 #error "Need a valid uartclk"
 #endif
@@ -1091,11 +1095,12 @@ static void __devinit sci_init_single(st
 
 	sci_port->port.irq	= p->irqs[SCIx_TXI_IRQ];
 	sci_port->port.flags	= p->flags;
-	sci_port->port.dev	= &dev->dev;
 	sci_port->type		= sci_port->port.type = p->type;
 
 	memcpy(&sci_port->irqs, &p->irqs, sizeof(p->irqs));
 
+	if (dev)
+		sci_port->port.dev = &dev->dev;
 }
 
 #ifdef CONFIG_SERIAL_SH_SCI_CONSOLE
@@ -1155,9 +1160,14 @@ static int __init serial_console_setup(s
 	if (co->index >= SCI_NPORTS)
 		co->index = 0;
 
-	sci_port = &sci_ports[co->index];
-	port = &sci_port->port;
-	co->data = port;
+	if (co->data) {
+		port = co->data;
+		sci_port = to_sci_port(port);
+	} else {
+		sci_port = &sci_ports[co->index];
+		port = &sci_port->port;
+		co->data = port;
+	}
 
 	/*
 	 * Also need to check port->type, we don't actually have any
@@ -1201,6 +1211,15 @@ static int __init sci_console_init(void)
 	return 0;
 }
 console_initcall(sci_console_init);
+
+static struct sci_port early_serial_port;
+static struct console early_serial_console = {
+	.name		= "early_ttySC",
+	.write		= serial_console_write,
+	.setup		= serial_console_setup,
+	.flags		= CON_PRINTBUFFER | CON_BOOT,
+};
+
 #endif /* CONFIG_SERIAL_SH_SCI_CONSOLE */
 
 #if defined(CONFIG_SERIAL_SH_SCI_CONSOLE)
@@ -1289,6 +1308,19 @@ static int __devinit sci_probe(struct pl
 	struct sh_sci_priv *priv;
 	int i, ret = -EINVAL;
 
+	if (is_early_platform_device(dev)) {
+#ifdef CONFIG_SERIAL_SH_SCI_CONSOLE
+		if (dev->id == -1)
+			return -ENOTSUPP;
+
+		early_serial_console.index = dev->id;
+		early_serial_console.data = &early_serial_port.port;
+		sci_init_single(NULL, &early_serial_port, dev->id, p);
+		register_console(&early_serial_console);
+#endif
+		return 0;
+	}
+
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
@@ -1388,6 +1420,7 @@ static void __exit sci_exit(void)
 	uart_unregister_driver(&sci_uart_driver);
 }
 
+early_platform_init("earlyprintk", &sci_driver);
 module_init(sci_init);
 module_exit(sci_exit);
 
