Return-Path: <linux-kernel-owner+w=401wt.eu-S1751797Ab0AKAAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab0AKAAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 19:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010Ab0AKAAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 19:00:55 -0500
Received: from smtp101.biz.mail.mud.yahoo.com ([68.142.200.236]:48343 "HELO
	smtp101.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750950Ab0AKAAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 19:00:54 -0500
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-YMail-OSG: hpNlM4EVM1lhHjnpLSIHsjV6bfhJnE0u1r8FXQO61OR4upS8dVLj8z2mXGNiu0ihFf6Y_N4ifaNkre6LRqCCqeSB.LyLx1MeaAHBlz3wtCKd3f7a_lijkyMNpV8pfE1bOJXzg7Kidc2TuHaPzokkiJyBNu4wghDPheGhWAT5aww0OHsE81y7oA2o1vWkCGNwxoXGY1rzBtNAZEPw4gxl4JRWPreLqPqkCDWp9NUkzOqJvkqD61JF6Nys01QciYU.3nyAtyJa605R.jGvWlqCdbwqnuqc6pT9eo30foW2RTF_hzNfDcdOpGeNTDs.YGAOWZgd9xS9tGSpllXLLg0spe8pNKttAXQK4yShNze_LOLWtWBWRcUEwjqqE0Z7tKVl3lOifn6ulOCkE86NNtl5te03Eh_1zQ8.LrH0iDhbgW0lKiOaiiZNMsM7JFxLh90Re6jKu04p4G32TTTLUREHJGOCjl3CH1ZgNDvZf6Xqu1aGZmgTdFxoG.ruHv6FXHODonAnn0X5Dm7TR4hW
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: gerg@snapgear.com
Subject: [PATCH] m68knommu: driver for Freescale Coldfire I2C controller.
Date: Sun, 10 Jan 2010 16:00:41 -0800
User-Agent: KMail/1.9.9
Cc: khali@linux-fr.org, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001101600.41932.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the I2C controller used on Freescale/Motorola Coldfire MCUs. 

Signed-off-by: Steven King <sfking@fdwdc.com>

 drivers/i2c/busses/Kconfig   |   11 +
 drivers/i2c/busses/Makefile  |    1 +
 drivers/i2c/busses/i2c-mcf.c |  463 
++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 475 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 5f318ce..6caf7a0 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -429,6 +429,17 @@ config I2C_MPC
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-mpc.
 
+config I2C_MCF
+	tristate "Freescale Coldfire I2C driver"
+	depends on (M5206 || M5206e || M520x || M523x || M5249 || M527x || M528x || 
M5307 || M532x || M5407)
+	help
+	  This driver supports the I2C interface availible on some Freescale
+	  Coldfire processors (M520x, M523x, M5249, M5271, M5275, M528x,
+	  M5307, M532x, M5407).
+
+	  This driver can be built as a module.  If so, the module
+	  will be called i2c-mcf.
+
 config I2C_MV64XXX
 	tristate "Marvell mv64xxx I2C Controller"
 	depends on (MV64X60 || PLAT_ORION) && EXPERIMENTAL
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 302c551..c71349e 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_I2C_IMX)		+= i2c-imx.o
 obj-$(CONFIG_I2C_IOP3XX)	+= i2c-iop3xx.o
 obj-$(CONFIG_I2C_IXP2000)	+= i2c-ixp2000.o
 obj-$(CONFIG_I2C_MPC)		+= i2c-mpc.o
+obj-$(CONFIG_I2C_MCF)		+= i2c-mcf.o
 obj-$(CONFIG_I2C_MV64XXX)	+= i2c-mv64xxx.o
 obj-$(CONFIG_I2C_OCORES)	+= i2c-ocores.o
 obj-$(CONFIG_I2C_OMAP)		+= i2c-omap.o
diff --git a/drivers/i2c/busses/i2c-mcf.c b/drivers/i2c/busses/i2c-mcf.c
new file mode 100644
index 0000000..27f0d0b
--- /dev/null
+++ b/drivers/i2c/busses/i2c-mcf.c
@@ -0,0 +1,463 @@
+/* Freescale/Motorola Coldfire I2C driver.
+ *
+ * Copyright 2010 Steven King <sfking@fdwdc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/errno.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+
+#include <asm/mcfi2c.h>
+
+#define	DRIVER_NAME "mcfi2c"
+
+#define	MCFI2C_ADR			0x00
+#define	MCFI2C_FDR			0x04
+#define	MCFI2C_CR			0x08
+#define		MCFI2C_CR_IEN		0x80
+#define		MCFI2C_CR_IIEN		0x40
+#define		MCFI2C_CR_MSTA		0x20
+#define		MCFI2C_CR_MTX		0x10
+#define		MCFI2C_CR_TXAK		0x08
+#define		MCFI2C_CR_RSTA		0x04
+#define	MCFI2C_DR			0x10
+#define	MCFI2C_SR			0x0C
+#define		MCFI2C_SR_ICF		0x80
+#define		MCFI2C_SR_IAAS		0x40
+#define		MCFI2C_SR_IBB		0x20
+#define		MCFI2C_SR_IAL		0x10
+#define		MCFI2C_SR_SRW		0x04
+#define		MCFI2C_SR_IIF		0x02
+#define		MCFI2C_SR_RXAK		0x01
+
+#define	DEFAULT_I2C_BUS_SPEED		100000
+
+struct mcfi2c {
+	struct i2c_adapter	adapter;
+	void __iomem		*iobase;
+	int			irq;
+	struct clk		*clk;
+	struct completion	completion;
+};
+
+static u8 mcfi2c_rd_cr(struct mcfi2c *mcfi2c)
+{
+	return readb(mcfi2c->iobase + MCFI2C_CR);
+}
+
+static void mcfi2c_wr_cr(struct mcfi2c *mcfi2c, u8 val)
+{
+	writeb(val, mcfi2c->iobase + MCFI2C_CR);
+}
+
+static u8 mcfi2c_rd_sr(struct mcfi2c *mcfi2c)
+{
+	return readb(mcfi2c->iobase + MCFI2C_SR);
+}
+
+static void mcfi2c_wr_sr(struct mcfi2c *mcfi2c, u8 val)
+{
+	writeb(val, mcfi2c->iobase + MCFI2C_SR);
+}
+
+static u8 mcfi2c_rd_dr(struct mcfi2c *mcfi2c)
+{
+	return readb(mcfi2c->iobase + MCFI2C_DR);
+}
+
+static void mcfi2c_wr_dr(struct mcfi2c *mcfi2c, u8 val)
+{
+	writeb(val, mcfi2c->iobase + MCFI2C_DR);
+}
+
+static void mcfi2c_start(struct mcfi2c *mcfi2c)
+{
+	mcfi2c_wr_cr(mcfi2c, MCFI2C_CR_IEN | MCFI2C_CR_IIEN | MCFI2C_CR_MSTA |
+		     MCFI2C_CR_MTX);
+}
+
+static void mcfi2c_repeat_start(struct mcfi2c *mcfi2c)
+{
+	mcfi2c_wr_cr(mcfi2c, MCFI2C_CR_IEN | MCFI2C_CR_IIEN | MCFI2C_CR_MSTA |
+		     MCFI2C_CR_MTX | MCFI2C_CR_RSTA);
+}
+
+static void mcfi2c_stop(struct mcfi2c *mcfi2c)
+{
+	mcfi2c_wr_cr(mcfi2c, MCFI2C_CR_IEN);
+}
+
+static void mcfi2c_tx_ack(struct mcfi2c *mcfi2c)
+{
+	mcfi2c_wr_cr(mcfi2c, MCFI2C_CR_IEN | MCFI2C_CR_IIEN | MCFI2C_CR_MSTA);
+}
+
+static void mcfi2c_tx_nak(struct mcfi2c *mcfi2c)
+{
+	mcfi2c_wr_cr(mcfi2c, MCFI2C_CR_IEN | MCFI2C_CR_IIEN | MCFI2C_CR_MSTA |
+		     MCFI2C_CR_TXAK);
+}
+
+static irqreturn_t mcfi2c_irq_handler(int this_irq, void *dev_id)
+{
+	struct mcfi2c *mcfi2c = dev_id;
+
+	/* clear interrupt */
+	mcfi2c_wr_sr(mcfi2c, 0);
+	complete(&mcfi2c->completion);
+
+	return IRQ_HANDLED;
+}
+
+static void mcfi2c_reset(struct mcfi2c *mcfi2c)
+{
+	mcfi2c_wr_cr(mcfi2c, 0);
+	mcfi2c_wr_cr(mcfi2c, MCFI2C_CR_IEN | MCFI2C_CR_MSTA);
+	mcfi2c_rd_dr(mcfi2c);
+	mcfi2c_wr_sr(mcfi2c, 0);
+	mcfi2c_wr_cr(mcfi2c, 0);
+	mcfi2c_wr_cr(mcfi2c, MCFI2C_CR_IEN);
+}
+
+static void mcfi2c_wait_for_bus_idle(struct mcfi2c *mcfi2c)
+{
+	if (mcfi2c_rd_sr(mcfi2c) & MCFI2C_SR_IBB) {
+		unsigned long timeout = jiffies + HZ / 2;
+		do {
+			cond_resched();
+			if (time_after(jiffies, timeout)) {
+				mcfi2c_reset(mcfi2c);
+				break;
+			}
+		} while (mcfi2c_rd_sr(mcfi2c) & MCFI2C_SR_IBB);
+	}
+}
+
+static int mcfi2c_wait_for_bus_busy(struct mcfi2c *mcfi2c)
+{
+	u8 sr;
+	while (!((sr = mcfi2c_rd_sr(mcfi2c)) & MCFI2C_SR_IBB))
+		if (sr & MCFI2C_SR_IAL) {
+			mcfi2c_reset(mcfi2c);
+			return -EIO;
+		}
+	return 0;
+}
+
+static int mcfi2c_xmit(struct mcfi2c *mcfi2c, u16 addr, u16 flags, u8 *buf,
+		       u16 len, int timeout, int more)
+{
+	if (!(mcfi2c_rd_cr(mcfi2c) & MCFI2C_CR_MSTA)) {
+		mcfi2c_wait_for_bus_idle(mcfi2c);
+
+		INIT_COMPLETION(mcfi2c->completion);
+		mcfi2c_start(mcfi2c);
+
+		if (mcfi2c_wait_for_bus_busy(mcfi2c))
+			return -EIO;
+	}
+
+	mcfi2c_wr_dr(mcfi2c, (addr << 1) | (flags & I2C_M_RD));
+	while (wait_for_completion_timeout(&mcfi2c->completion, timeout)) {
+		u8 sr = mcfi2c_rd_sr(mcfi2c);
+		if (sr & MCFI2C_SR_IAL) {
+			mcfi2c_wr_sr(mcfi2c, ~MCFI2C_SR_IAL);
+			return -EIO;
+		} else if (mcfi2c_rd_cr(mcfi2c) & MCFI2C_CR_MTX) {
+			if (sr & MCFI2C_SR_RXAK) {
+				mcfi2c_stop(mcfi2c);
+				return -EIO;
+			} else if (flags & I2C_M_RD) {
+				if (len > 1)
+					mcfi2c_tx_ack(mcfi2c);
+				else
+					mcfi2c_tx_nak(mcfi2c);
+				/* dummy read */
+				mcfi2c_rd_dr(mcfi2c);
+			} else if (len--) {
+				mcfi2c_wr_dr(mcfi2c, *buf++);
+			} else {
+				if (more)
+					mcfi2c_repeat_start(mcfi2c);
+				else
+					mcfi2c_stop(mcfi2c);
+				return 0;
+			}
+		} else if (--len) {
+			if (!(len > 1))
+				mcfi2c_tx_nak(mcfi2c);
+			*buf++ = mcfi2c_rd_dr(mcfi2c);
+		} else {
+			if (more)
+				mcfi2c_repeat_start(mcfi2c);
+			else
+				mcfi2c_stop(mcfi2c);
+			*buf++ = mcfi2c_rd_dr(mcfi2c);
+			return 0;
+		}
+	}
+	mcfi2c_stop(mcfi2c);
+
+	return -ETIMEDOUT;
+}
+
+static int mcfi2c_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
+		int num)
+{
+	struct mcfi2c *mcfi2c = i2c_get_adapdata(adapter);
+	int cnt = 0;
+	int status;
+	int retries;
+
+	while (num--) {
+		retries = adapter->retries;
+		if (msgs->flags & ~I2C_M_RD)
+			return -EINVAL;
+		do {
+			status = mcfi2c_xmit(mcfi2c, msgs->addr, msgs->flags,
+					     msgs->buf, msgs->len,
+					     adapter->timeout, num);
+		} while (status && retries--);
+		if (status)
+			return status;
+		++cnt;
+		++msgs;
+	}
+
+	return cnt;
+}
+
+static u32 mcfi2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+static const struct i2c_algorithm mcfi2c_algo = {
+	.master_xfer	= mcfi2c_xfer,
+	.functionality	= mcfi2c_func,
+};
+
+static const u16 mcfi2c_fdr[] = {
+	  28,   30,   34,   40,   44,   48,   56,   68,
+	  80,   88,  104,  128,  144,  160,  192,  240,
+	 288,  320,  384,  480,  576,  640,  768,  960,
+	1152, 1280, 1536, 1920, 2304, 2560, 3072, 3840,
+	  20,   22,   24,   26,   28,   32,   36,   40,
+	  48,   56,   64,   72,   80,   96,  112,  128,
+	 160,  192,  224,  256,  320,  384,  448,  512,
+	 640,  768,  896, 1024, 1280, 1536, 1792, 2048
+};
+
+static u8 __devinit mcfi2c_calc_fdr(struct mcfi2c *mcfi2c,
+				    struct mcfi2c_platform_data *pdata)
+{
+	u32 bitrate = (pdata && pdata->bitrate) ?
+			pdata->bitrate : DEFAULT_I2C_BUS_SPEED;
+	int div = clk_get_rate(mcfi2c->clk)/bitrate;
+	int r = 0, i = 0;
+
+	do
+		if (abs(mcfi2c_fdr[i] - div) < abs(mcfi2c_fdr[r] - div))
+			r = i;
+	while (++i < ARRAY_SIZE(mcfi2c_fdr));
+
+	return r;
+}
+
+static int __devinit mcfi2c_probe(struct platform_device *pdev)
+{
+	struct mcfi2c *mcfi2c;
+	struct resource *res;
+	int status;
+
+	mcfi2c = kzalloc(sizeof(*mcfi2c), GFP_KERNEL);
+	if (!mcfi2c) {
+		dev_dbg(&pdev->dev, "kzalloc failed\n");
+
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_dbg(&pdev->dev, "platform_get_resource failed\n");
+		status = -ENXIO;
+		goto fail0;
+	}
+
+	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
+		dev_dbg(&pdev->dev, "request_mem_region failed\n");
+		status = -EBUSY;
+		goto fail0;
+	}
+
+	mcfi2c->iobase = ioremap(res->start, resource_size(res));
+	if (!mcfi2c->iobase) {
+		dev_dbg(&pdev->dev, "ioremap failed\n");
+		status = -ENOMEM;
+		goto fail1;
+	}
+
+	mcfi2c->irq = platform_get_irq(pdev, 0);
+	if (mcfi2c->irq < 0) {
+		dev_dbg(&pdev->dev, "platform_get_irq failed\n");
+		status = -ENXIO;
+		goto fail2;
+	}
+	status = request_irq(mcfi2c->irq, mcfi2c_irq_handler, IRQF_DISABLED,
+			     pdev->name, mcfi2c);
+	if (status) {
+		dev_dbg(&pdev->dev, "request_irq failed\n");
+		goto fail2;
+	}
+
+	mcfi2c->clk = clk_get(&pdev->dev, "i2c_clk");
+	if (IS_ERR(mcfi2c->clk)) {
+		dev_dbg(&pdev->dev, "clk_get failed\n");
+		status = PTR_ERR(mcfi2c->clk);
+		goto fail3;
+	}
+	clk_enable(mcfi2c->clk);
+
+	platform_set_drvdata(pdev, mcfi2c);
+
+	init_completion(&mcfi2c->completion);
+
+	writeb(mcfi2c_calc_fdr(mcfi2c, pdev->dev.platform_data),
+	       mcfi2c->iobase + MCFI2C_FDR);
+
+	writeb(0x00, mcfi2c->iobase + MCFI2C_ADR);
+
+	mcfi2c_wr_cr(mcfi2c, MCFI2C_CR_IEN);
+
+	/* if the bus busy (IBB) is set, reset the controller */
+	if (mcfi2c_rd_sr(mcfi2c) & MCFI2C_SR_IBB)
+		mcfi2c_reset(mcfi2c);
+
+	mcfi2c->adapter.algo		= &mcfi2c_algo;
+	mcfi2c->adapter.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD;
+	mcfi2c->adapter.dev.parent	= &pdev->dev;
+	mcfi2c->adapter.nr		= pdev->id;
+	mcfi2c->adapter.retries		= 2;
+	snprintf(mcfi2c->adapter.name, sizeof(mcfi2c->adapter.name),
+			DRIVER_NAME ".%d", pdev->id);
+
+	i2c_set_adapdata(&mcfi2c->adapter, mcfi2c);
+
+	status = i2c_add_numbered_adapter(&mcfi2c->adapter);
+	if (status < 0) {
+		dev_dbg(&pdev->dev, "i2c_add_numbered_adapter failed\n");
+		goto fail4;
+	}
+	dev_info(&pdev->dev, "Coldfire I2C bus driver\n");
+
+	return 0;
+
+fail4:
+	clk_disable(mcfi2c->clk);
+	clk_put(mcfi2c->clk);
+fail3:
+	free_irq(mcfi2c->irq, mcfi2c);
+fail2:
+	iounmap(mcfi2c->iobase);
+fail1:
+	release_mem_region(res->start, resource_size(res));
+fail0:
+	kfree(mcfi2c);
+
+	return status;
+}
+
+static int __devexit mcfi2c_remove(struct platform_device *pdev)
+{
+	struct mcfi2c *mcfi2c = platform_get_drvdata(pdev);
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	/* disable the hardware */
+	mcfi2c_wr_cr(mcfi2c, 0);
+
+	platform_set_drvdata(pdev, NULL);
+	i2c_del_adapter(&mcfi2c->adapter);
+	clk_disable(mcfi2c->clk);
+	clk_put(mcfi2c->clk);
+	free_irq(mcfi2c->irq, mcfi2c);
+	iounmap(mcfi2c->iobase);
+	release_mem_region(res->start, resource_size(res));
+	kfree(mcfi2c);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int mcfi2c_suspend(struct device *dev)
+{
+	struct mcfi2c *mcfi2c = platform_get_drvdata(to_platform_device(dev));
+
+	mcfi2c_wr_cr(mcfi2c, 0);
+	clk_disable(mcfi2c->clk);
+
+	return 0;
+}
+
+static int mcfi2c_resume(struct device *dev)
+{
+	struct mcfi2c *mcfi2c = platform_get_drvdata(to_platform_device(dev));
+
+	clk_enable(mcfi2c->clk);
+	mcfi2c_wr_cr(mcfi2c, MCFI2C_CR_IEN);
+
+	return 0;
+}
+
+static struct dev_pm_ops mcfi2c_dev_pm_ops = {
+	.suspend	= mcfi2c_suspend,
+	.resume		= mcfi2c_resume,
+};
+
+#define	MCFI2C_DEV_PM_OPS (&mcfi2c_dev_pm_ops)
+#else
+#define	MCFI2C_DEV_PM_OPS NULL
+#endif
+
+static struct platform_driver mcfi2c_driver = {
+	.driver.name	= DRIVER_NAME,
+	.driver.owner	= THIS_MODULE,
+	.driver.pm	= MCFI2C_DEV_PM_OPS,
+	.remove		= __devexit_p(mcfi2c_remove),
+};
+
+static int __init mcfi2c_init(void)
+{
+	return platform_driver_probe(&mcfi2c_driver, mcfi2c_probe);
+}
+module_init(mcfi2c_init);
+
+static void __exit mcfi2c_exit(void)
+{
+	platform_driver_unregister(&mcfi2c_driver);
+}
+module_exit(mcfi2c_exit);
+
+MODULE_AUTHOR("Steven King <sfking@fdwdc.com>");
+MODULE_DESCRIPTION("I2C-Bus support for Freescale Coldfire processors");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRIVER_NAME);
