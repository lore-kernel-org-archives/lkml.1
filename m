Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0BIVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 16:16:28 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:36944 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0BIVQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 16:16:25 -0500
X-Auth-Info: C1JiXicroeUtQtJksyWqW46akxWwSrnw/h+glEunUzw=
From: Anatolij Gustschin <agust@denx.de>
To: linuxppc-dev@ozlabs.org
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, gregkh@suse.de,
       jcrigby@gmail.com, dzu@denx.de, wd@denx.de,
       Anatolij Gustschin <agust@denx.de>
Subject: [PATCH v2 1/3] serial: mpc52xx_uart: re-enable mpc5121 PSC UART support
Date: Tue,  9 Feb 2010 22:13:50 +0100
Message-Id: <1265750032-2803-2-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265750032-2803-1-git-send-email-agust@denx.de>
References: <1265750032-2803-1-git-send-email-agust@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the support for MPC5121 PSC UART in the mpc52xx_uart
driver is broken (only console pre-initialized by the bootloader
works). Re-enable it now by providing MPC5121 specific ops
for PSCx clock activation, FIFO controller init/uninit and
MPC5121 PSC FIFO shared interrupt handling functions.

Signed-off-by: John Rigby <jcrigby@gmail.com>
Signed-off-by: Anatolij Gustschin <agust@denx.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
Changes since v1:
 - droped irq_dispose_mapping() entirely as suggested by Grant.
 - added John's SoB as fifoc init code is based on his code. I
   forgot to add the SoB in previous patch version, sorry.

 drivers/serial/mpc52xx_uart.c |  251 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 236 insertions(+), 15 deletions(-)

diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
index 7ce9e9f..3119fdd 100644
--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -74,6 +74,7 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/clk.h>
 
 #include <asm/mpc52xx.h>
 #include <asm/mpc52xx_psc.h>
@@ -113,6 +114,7 @@ static void mpc52xx_uart_of_enumerate(void);
 
 /* Forward declaration of the interruption handling routine */
 static irqreturn_t mpc52xx_uart_int(int irq, void *dev_id);
+static irqreturn_t mpc5xxx_uart_process_int(struct uart_port *port);
 
 
 /* Simple macro to test if a port is console or not. This one is taken
@@ -145,6 +147,11 @@ struct psc_ops {
 	void		(*cw_disable_ints)(struct uart_port *port);
 	void		(*cw_restore_ints)(struct uart_port *port);
 	unsigned long	(*getuartclk)(void *p);
+	int		(*clock)(struct uart_port *port, int enable);
+	int		(*fifoc_init)(void);
+	void		(*fifoc_uninit)(void);
+	void		(*get_irq)(struct uart_port *, struct device_node *);
+	irqreturn_t	(*handle_irq)(struct uart_port *port);
 };
 
 #ifdef CONFIG_PPC_MPC52xx
@@ -256,6 +263,18 @@ static unsigned long mpc52xx_getuartclk(void *p)
 	return mpc5xxx_get_bus_frequency(p) / 2;
 }
 
+static void mpc52xx_psc_get_irq(struct uart_port *port, struct device_node *np)
+{
+	port->irqflags = IRQF_DISABLED;
+	port->irq = irq_of_parse_and_map(np, 0);
+}
+
+/* 52xx specific interrupt handler. The caller holds the port lock */
+static irqreturn_t mpc52xx_psc_handle_irq(struct uart_port *port)
+{
+	return mpc5xxx_uart_process_int(port);
+}
+
 static struct psc_ops mpc52xx_psc_ops = {
 	.fifo_init = mpc52xx_psc_fifo_init,
 	.raw_rx_rdy = mpc52xx_psc_raw_rx_rdy,
@@ -273,14 +292,32 @@ static struct psc_ops mpc52xx_psc_ops = {
 	.cw_disable_ints = mpc52xx_psc_cw_disable_ints,
 	.cw_restore_ints = mpc52xx_psc_cw_restore_ints,
 	.getuartclk = mpc52xx_getuartclk,
+	.get_irq = mpc52xx_psc_get_irq,
+	.handle_irq = mpc52xx_psc_handle_irq,
 };
 
 #endif /* CONFIG_MPC52xx */
 
 #ifdef CONFIG_PPC_MPC512x
 #define FIFO_512x(port) ((struct mpc512x_psc_fifo __iomem *)(PSC(port)+1))
+
+/* PSC FIFO Controller for mpc512x */
+struct psc_fifoc {
+	u32 fifoc_cmd;
+	u32 fifoc_int;
+	u32 fifoc_dma;
+	u32 fifoc_axe;
+	u32 fifoc_debug;
+};
+
+static struct psc_fifoc __iomem *psc_fifoc;
+static unsigned int psc_fifoc_irq;
+
 static void mpc512x_psc_fifo_init(struct uart_port *port)
 {
+	/* /32 prescaler */
+	out_be16(&PSC(port)->mpc52xx_psc_clock_select, 0xdd00);
+
 	out_be32(&FIFO_512x(port)->txcmd, MPC512x_PSC_FIFO_RESET_SLICE);
 	out_be32(&FIFO_512x(port)->txcmd, MPC512x_PSC_FIFO_ENABLE_SLICE);
 	out_be32(&FIFO_512x(port)->txalarm, 1);
@@ -393,6 +430,160 @@ static unsigned long mpc512x_getuartclk(void *p)
 	return mpc5xxx_get_bus_frequency(p);
 }
 
+#define DEFAULT_FIFO_SIZE 16
+
+static unsigned int __init get_fifo_size(struct device_node *np,
+					 char *fifo_name)
+{
+	const unsigned int *fp;
+
+	fp = of_get_property(np, fifo_name, NULL);
+	if (fp)
+		return *fp;
+
+	pr_warning("no %s property in %s node, defaulting to %d\n",
+		   fifo_name, np->full_name, DEFAULT_FIFO_SIZE);
+
+	return DEFAULT_FIFO_SIZE;
+}
+
+#define FIFOC(_base) ((struct mpc512x_psc_fifo __iomem *) \
+		    ((u32)(_base) + sizeof(struct mpc52xx_psc)))
+
+/* Init PSC FIFO Controller */
+static int __init mpc512x_psc_fifoc_init(void)
+{
+	struct device_node *np;
+	void __iomem *psc;
+	unsigned int tx_fifo_size;
+	unsigned int rx_fifo_size;
+	int fifobase = 0; /* current fifo address in 32 bit words */
+
+	np = of_find_compatible_node(NULL, NULL,
+				     "fsl,mpc5121-psc-fifo");
+	if (!np) {
+		pr_err("%s: Can't find FIFOC node\n", __func__);
+		return -ENODEV;
+	}
+
+	psc_fifoc = of_iomap(np, 0);
+	if (!psc_fifoc) {
+		pr_err("%s: Can't map FIFOC\n", __func__);
+		return -ENODEV;
+	}
+
+	psc_fifoc_irq = irq_of_parse_and_map(np, 0);
+	of_node_put(np);
+	if (psc_fifoc_irq == NO_IRQ) {
+		pr_err("%s: Can't get FIFOC irq\n", __func__);
+		iounmap(psc_fifoc);
+		return -ENODEV;
+	}
+
+	for_each_compatible_node(np, NULL, "fsl,mpc5121-psc-uart") {
+		tx_fifo_size = get_fifo_size(np, "fsl,tx-fifo-size");
+		rx_fifo_size = get_fifo_size(np, "fsl,rx-fifo-size");
+
+		/* size in register is in 4 byte units */
+		tx_fifo_size /= 4;
+		rx_fifo_size /= 4;
+		if (!tx_fifo_size)
+			tx_fifo_size = 1;
+		if (!rx_fifo_size)
+			rx_fifo_size = 1;
+
+		psc = of_iomap(np, 0);
+		if (!psc) {
+			pr_err("%s: Can't map %s device\n",
+				__func__, np->full_name);
+			continue;
+		}
+
+		/* FIFO space is 4KiB, check if requested size is available */
+		if ((fifobase + tx_fifo_size + rx_fifo_size) > 0x1000) {
+			pr_err("%s: no fifo space available for %s\n",
+				__func__, np->full_name);
+			iounmap(psc);
+			/*
+			 * chances are that another device requests less
+			 * fifo space, so we continue.
+			 */
+			continue;
+		}
+		/* set tx and rx fifo size registers */
+		out_be32(&FIFOC(psc)->txsz, (fifobase << 16) | tx_fifo_size);
+		fifobase += tx_fifo_size;
+		out_be32(&FIFOC(psc)->rxsz, (fifobase << 16) | rx_fifo_size);
+		fifobase += rx_fifo_size;
+
+		/* reset and enable the slices */
+		out_be32(&FIFOC(psc)->txcmd, 0x80);
+		out_be32(&FIFOC(psc)->txcmd, 0x01);
+		out_be32(&FIFOC(psc)->rxcmd, 0x80);
+		out_be32(&FIFOC(psc)->rxcmd, 0x01);
+
+		iounmap(psc);
+	}
+
+	return 0;
+}
+
+static void __exit mpc512x_psc_fifoc_uninit(void)
+{
+	iounmap(psc_fifoc);
+}
+
+/* 512x specific interrupt handler. The caller holds the port lock */
+static irqreturn_t mpc512x_psc_handle_irq(struct uart_port *port)
+{
+	unsigned long fifoc_int;
+	int psc_num;
+
+	/* Read pending PSC FIFOC interrupts */
+	fifoc_int = in_be32(&psc_fifoc->fifoc_int);
+
+	/* Check if it is an interrupt for this port */
+	psc_num = (port->mapbase & 0xf00) >> 8;
+	if (test_bit(psc_num, &fifoc_int) ||
+	    test_bit(psc_num + 16, &fifoc_int))
+		return mpc5xxx_uart_process_int(port);
+
+	return IRQ_NONE;
+}
+
+static int mpc512x_psc_clock(struct uart_port *port, int enable)
+{
+	struct clk *psc_clk;
+	int psc_num;
+	char clk_name[10];
+
+	if (uart_console(port))
+		return 0;
+
+	psc_num = (port->mapbase & 0xf00) >> 8;
+	snprintf(clk_name, sizeof(clk_name), "psc%d_clk", psc_num);
+	psc_clk = clk_get(port->dev, clk_name);
+	if (IS_ERR(psc_clk)) {
+		dev_err(port->dev, "Failed to get PSC clock entry!\n");
+		return -ENODEV;
+	}
+
+	dev_dbg(port->dev, "%s %sable\n", clk_name, enable ? "en" : "dis");
+
+	if (enable)
+		clk_enable(psc_clk);
+	else
+		clk_disable(psc_clk);
+
+	return 0;
+}
+
+static void mpc512x_psc_get_irq(struct uart_port *port, struct device_node *np)
+{
+	port->irqflags = IRQF_SHARED;
+	port->irq = psc_fifoc_irq;
+}
+
 static struct psc_ops mpc512x_psc_ops = {
 	.fifo_init = mpc512x_psc_fifo_init,
 	.raw_rx_rdy = mpc512x_psc_raw_rx_rdy,
@@ -410,6 +601,11 @@ static struct psc_ops mpc512x_psc_ops = {
 	.cw_disable_ints = mpc512x_psc_cw_disable_ints,
 	.cw_restore_ints = mpc512x_psc_cw_restore_ints,
 	.getuartclk = mpc512x_getuartclk,
+	.clock = mpc512x_psc_clock,
+	.fifoc_init = mpc512x_psc_fifoc_init,
+	.fifoc_uninit = mpc512x_psc_fifoc_uninit,
+	.get_irq = mpc512x_psc_get_irq,
+	.handle_irq = mpc512x_psc_handle_irq,
 };
 #endif
 
@@ -519,10 +715,15 @@ mpc52xx_uart_startup(struct uart_port *port)
 	struct mpc52xx_psc __iomem *psc = PSC(port);
 	int ret;
 
+	if (psc_ops->clock) {
+		ret = psc_ops->clock(port, 1);
+		if (ret)
+			return ret;
+	}
+
 	/* Request IRQ */
 	ret = request_irq(port->irq, mpc52xx_uart_int,
-		IRQF_DISABLED | IRQF_SAMPLE_RANDOM,
-		"mpc52xx_psc_uart", port);
+			  port->irqflags, "mpc52xx_psc_uart", port);
 	if (ret)
 		return ret;
 
@@ -553,6 +754,9 @@ mpc52xx_uart_shutdown(struct uart_port *port)
 	port->read_status_mask = 0;
 	out_be16(&psc->mpc52xx_psc_imr, port->read_status_mask);
 
+	if (psc_ops->clock)
+		psc_ops->clock(port, 0);
+
 	/* Release interrupt */
 	free_irq(port->irq, port);
 }
@@ -851,15 +1055,12 @@ mpc52xx_uart_int_tx_chars(struct uart_port *port)
 }
 
 static irqreturn_t
-mpc52xx_uart_int(int irq, void *dev_id)
+mpc5xxx_uart_process_int(struct uart_port *port)
 {
-	struct uart_port *port = dev_id;
 	unsigned long pass = ISR_PASS_LIMIT;
 	unsigned int keepgoing;
 	u8 status;
 
-	spin_lock(&port->lock);
-
 	/* While we have stuff to do, we continue */
 	do {
 		/* If we don't find anything to do, we stop */
@@ -886,11 +1087,23 @@ mpc52xx_uart_int(int irq, void *dev_id)
 
 	} while (keepgoing);
 
-	spin_unlock(&port->lock);
-
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t
+mpc52xx_uart_int(int irq, void *dev_id)
+{
+	struct uart_port *port = dev_id;
+	irqreturn_t ret;
+
+	spin_lock(&port->lock);
+
+	ret = psc_ops->handle_irq(port);
+
+	spin_unlock(&port->lock);
+
+	return ret;
+}
 
 /* ======================================================================== */
 /* Console ( if applicable )                                                */
@@ -1152,7 +1365,7 @@ mpc52xx_uart_of_probe(struct of_device *op, const struct of_device_id *match)
 		return -EINVAL;
 	}
 
-	port->irq = irq_of_parse_and_map(op->node, 0);
+	psc_ops->get_irq(port, op->node);
 	if (port->irq == NO_IRQ) {
 		dev_dbg(&op->dev, "Could not get irq\n");
 		return -EINVAL;
@@ -1163,10 +1376,8 @@ mpc52xx_uart_of_probe(struct of_device *op, const struct of_device_id *match)
 
 	/* Add the port to the uart sub-system */
 	ret = uart_add_one_port(&mpc52xx_uart_driver, port);
-	if (ret) {
-		irq_dispose_mapping(port->irq);
+	if (ret)
 		return ret;
-	}
 
 	dev_set_drvdata(&op->dev, (void *)port);
 	return 0;
@@ -1178,10 +1389,8 @@ mpc52xx_uart_of_remove(struct of_device *op)
 	struct uart_port *port = dev_get_drvdata(&op->dev);
 	dev_set_drvdata(&op->dev, NULL);
 
-	if (port) {
+	if (port)
 		uart_remove_one_port(&mpc52xx_uart_driver, port);
-		irq_dispose_mapping(port->irq);
-	}
 
 	return 0;
 }
@@ -1288,6 +1497,15 @@ mpc52xx_uart_init(void)
 
 	mpc52xx_uart_of_enumerate();
 
+	/*
+	 * Map the PSC FIFO Controller and init if on MPC512x.
+	 */
+	if (psc_ops->fifoc_init) {
+		ret = psc_ops->fifoc_init();
+		if (ret)
+			return ret;
+	}
+
 	ret = of_register_platform_driver(&mpc52xx_uart_of_driver);
 	if (ret) {
 		printk(KERN_ERR "%s: of_register_platform_driver failed (%i)\n",
@@ -1302,6 +1520,9 @@ mpc52xx_uart_init(void)
 static void __exit
 mpc52xx_uart_exit(void)
 {
+	if (psc_ops->fifoc_uninit)
+		psc_ops->fifoc_uninit();
+
 	of_unregister_platform_driver(&mpc52xx_uart_of_driver);
 	uart_unregister_driver(&mpc52xx_uart_driver);
 }
-- 
1.6.3.3

