Return-Path: <linux-kernel-owner+w=401wt.eu-S935770AbZDBLSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935770AbZDBLSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759064AbZDBLRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:17:49 -0400
Received: from mx1.emlix.com ([193.175.82.87]:59466 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZDBLRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:17:47 -0400
From: Oskar Schirmer <os@emlix.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Daniel Gloeckner <dg@emlix.com>, Chris Zankel <chris@zankel.net>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Oskar Schirmer <os@emlix.com>
Subject: [patch v2] i2c: xtensa s6000 i2c driver
Date: Thu,  2 Apr 2009 13:19:07 +0200
Message-Id: <1238671147-25698-1-git-send-email-os@emlix.com>
In-Reply-To: <20090331230134.GP19758@fluff.org.uk>
References: <20090331230134.GP19758@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for the s6000 on-chip i2c controller.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 drivers/i2c/busses/Kconfig     |   10 +
 drivers/i2c/busses/Makefile    |    1 +
 drivers/i2c/busses/i2c-s6000.c |  407 ++++++++++++++++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-s6000.h |   79 ++++++++
 include/linux/i2c/s6000.h      |   10 +
 5 files changed, 507 insertions(+), 0 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-s6000.c
 create mode 100644 drivers/i2c/busses/i2c-s6000.h
 create mode 100644 include/linux/i2c/s6000.h

Version 2:
  o fix copyright notice
  o document interface state structure
  o translate io helpers from cpp to c
  o use dev_printk()
  o dropped parens in '&(expression)'
  o use resource_size()
  o added common i2c module alias
  o newlines between logically separate blocks
  o clock-to-ns calculation: less accurate, much less object code

Ben, we left the clk-by-name thing in there.  The clk API is an
abstraction of the platform and some implementations don't even
support passing NULL as a name (sh, some arms, avr32, mips, ...).
Passing in a string works everywhere so we are on the safe side.

Any objections?

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 7f95905..904def4 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -461,6 +461,16 @@ config I2C_S3C2410
 	  Say Y here to include support for I2C controller in the
 	  Samsung S3C2410 based System-on-Chip devices.
 
+config I2C_S6000
+	tristate "S6000 I2C support"
+	depends on XTENSA_VARIANT_S6000
+	help
+	  This driver supports the on chip I2C device on the
+	  S6000 xtensa processor family.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called i2c-s6000.
+
 config I2C_SH7760
 	tristate "Renesas SH7760 I2C Controller"
 	depends on CPU_SUBTYPE_SH7760
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 0c2c4b2..f7989d1 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_I2C_PASEMI)	+= i2c-pasemi.o
 obj-$(CONFIG_I2C_PNX)		+= i2c-pnx.o
 obj-$(CONFIG_I2C_PXA)		+= i2c-pxa.o
 obj-$(CONFIG_I2C_S3C2410)	+= i2c-s3c2410.o
+obj-$(CONFIG_I2C_S6000)		+= i2c-s6000.o
 obj-$(CONFIG_I2C_SH7760)	+= i2c-sh7760.o
 obj-$(CONFIG_I2C_SH_MOBILE)	+= i2c-sh_mobile.o
 obj-$(CONFIG_I2C_SIMTEC)	+= i2c-simtec.o
diff --git a/drivers/i2c/busses/i2c-s6000.c b/drivers/i2c/busses/i2c-s6000.c
new file mode 100644
index 0000000..c91359f
--- /dev/null
+++ b/drivers/i2c/busses/i2c-s6000.c
@@ -0,0 +1,407 @@
+/*
+ * drivers/i2c/busses/i2c-s6000.c
+ *
+ * Description: Driver for S6000 Family I2C Interface
+ * Copyright (c) 2008 emlix GmbH
+ * Author:	Oskar Schirmer <os@emlix.com>
+ *
+ * Partially based on i2c-bfin-twi.c driver by <sonic.zhang@analog.com>
+ * Copyright (c) 2005-2007 Analog Devices, Inc.
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
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/i2c/s6000.h>
+#include <linux/timer.h>
+#include <linux/spinlock.h>
+#include <linux/completion.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+
+#include <asm/io.h>
+#include "i2c-s6000.h"
+
+#define DRV_NAME "i2c-s6000"
+
+#define POLL_TIMEOUT	(2 * HZ)
+
+struct s6i2c_if {
+	u8 __iomem		*reg; /* memory mapped registers */
+	int			irq;
+	spinlock_t		lock;
+	struct i2c_msg		*msgs; /* messages currently handled */
+	int			msgs_num; /* nb of msgs to do */
+	int			msgs_push; /* nb of msgs read/written */
+	int			msgs_done; /* nb of msgs finally handled */
+	unsigned		push; /* nb of bytes read/written in msg */
+	unsigned		done; /* nb of bytes finally handled */
+	int			timeout_count; /* timeout retries left */
+	struct timer_list	timeout_timer;
+	struct i2c_adapter	adap;
+	struct completion	complete;
+	struct clk		*clk;
+	struct resource		*res;
+};
+
+static inline u16 i2c_rd16(struct s6i2c_if *iface, unsigned n)
+{
+	return readw(iface->reg + (n));
+}
+
+static inline void i2c_wr16(struct s6i2c_if *iface, unsigned n, u16 v)
+{
+	writew(v, iface->reg + (n));
+}
+
+static inline u32 i2c_rd32(struct s6i2c_if *iface, unsigned n)
+{
+	return readl(iface->reg + (n));
+}
+
+static inline void i2c_wr32(struct s6i2c_if *iface, unsigned n, u32 v)
+{
+	writel(v, iface->reg + (n));
+}
+
+static struct s6i2c_if s6i2c_if;
+
+static void s6i2c_handle_interrupt(struct s6i2c_if *iface)
+{
+	if (i2c_rd16(iface, S6_I2C_INTRSTAT) & (1 << S6_I2C_INTR_TXABRT)) {
+		i2c_rd16(iface, S6_I2C_CLRTXABRT);
+		i2c_wr16(iface, S6_I2C_INTRMASK, 0);
+		complete(&iface->complete);
+		return;
+	}
+	if (iface->msgs_done >= iface->msgs_num) {
+		dev_err(&iface->adap.dev, "s6i2c: spurious I2C irq: %04x\n",
+			i2c_rd16(iface, S6_I2C_INTRSTAT));
+		i2c_wr16(iface, S6_I2C_INTRMASK, 0);
+		return;
+	}
+	while ((iface->msgs_push < iface->msgs_num)
+	    && (i2c_rd16(iface, S6_I2C_STATUS) & (1 << S6_I2C_STATUS_TFNF))) {
+		struct i2c_msg *m = &iface->msgs[iface->msgs_push];
+		if (!(m->flags & I2C_M_RD))
+			i2c_wr16(iface, S6_I2C_DATACMD, m->buf[iface->push]);
+		else
+			i2c_wr16(iface, S6_I2C_DATACMD,
+				 1 << S6_I2C_DATACMD_READ);
+		if (++iface->push >= m->len) {
+			iface->push = 0;
+			iface->msgs_push += 1;
+		}
+	}
+	do {
+		struct i2c_msg *m = &iface->msgs[iface->msgs_done];
+		if (!(m->flags & I2C_M_RD)) {
+			if (iface->msgs_done < iface->msgs_push)
+				iface->msgs_done += 1;
+			else
+				break;
+		} else if (i2c_rd16(iface, S6_I2C_STATUS)
+				& (1 << S6_I2C_STATUS_RFNE)) {
+			m->buf[iface->done] = i2c_rd16(iface, S6_I2C_DATACMD);
+			if (++iface->done >= m->len) {
+				iface->done = 0;
+				iface->msgs_done += 1;
+			}
+		} else{
+			break;
+		}
+	} while (iface->msgs_done < iface->msgs_num);
+	if (iface->msgs_done >= iface->msgs_num) {
+		i2c_wr16(iface, S6_I2C_INTRMASK, 1 << S6_I2C_INTR_TXABRT);
+		complete(&iface->complete);
+	} else if (iface->msgs_push >= iface->msgs_num) {
+		i2c_wr16(iface, S6_I2C_INTRMASK, (1 << S6_I2C_INTR_TXABRT) |
+						 (1 << S6_I2C_INTR_RXFULL));
+	} else {
+		i2c_wr16(iface, S6_I2C_INTRMASK, (1 << S6_I2C_INTR_TXABRT) |
+						 (1 << S6_I2C_INTR_TXEMPTY) |
+						 (1 << S6_I2C_INTR_RXFULL));
+	}
+}
+
+static irqreturn_t s6i2c_interrupt_entry(int irq, void *dev_id)
+{
+	struct s6i2c_if *iface = dev_id;
+	if (!(i2c_rd16(iface, S6_I2C_STATUS) & ((1 << S6_I2C_INTR_RXUNDER)
+					      | (1 << S6_I2C_INTR_RXOVER)
+					      | (1 << S6_I2C_INTR_RXFULL)
+					      | (1 << S6_I2C_INTR_TXOVER)
+					      | (1 << S6_I2C_INTR_TXEMPTY)
+					      | (1 << S6_I2C_INTR_RDREQ)
+					      | (1 << S6_I2C_INTR_TXABRT)
+					      | (1 << S6_I2C_INTR_RXDONE)
+					      | (1 << S6_I2C_INTR_ACTIVITY)
+					      | (1 << S6_I2C_INTR_STOPDET)
+					      | (1 << S6_I2C_INTR_STARTDET)
+					      | (1 << S6_I2C_INTR_GENCALL))))
+		return IRQ_NONE;
+
+	spin_lock(&iface->lock);
+	del_timer(&iface->timeout_timer);
+	s6i2c_handle_interrupt(iface);
+	spin_unlock(&iface->lock);
+	return IRQ_HANDLED;
+}
+
+static void s6i2c_timeout(unsigned long data)
+{
+	struct s6i2c_if *iface = (struct s6i2c_if *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iface->lock, flags);
+	s6i2c_handle_interrupt(iface);
+	if (--iface->timeout_count > 0) {
+		iface->timeout_timer.expires = jiffies + POLL_TIMEOUT;
+		add_timer(&iface->timeout_timer);
+	} else {
+		complete(&iface->complete);
+		i2c_wr16(iface, S6_I2C_INTRMASK, 0);
+	}
+	spin_unlock_irqrestore(&iface->lock, flags);
+}
+
+static int s6i2c_master_xfer(struct i2c_adapter *adap,
+				struct i2c_msg *msgs, int num)
+{
+	struct s6i2c_if *iface = adap->algo_data;
+	int i;
+	if (num == 0)
+		return 0;
+	if (i2c_rd16(iface, S6_I2C_STATUS) & (1 << S6_I2C_STATUS_ACTIVITY))
+		yield();
+	i2c_wr16(iface, S6_I2C_INTRMASK, 0);
+	i2c_rd16(iface, S6_I2C_CLRINTR);
+	for (i = 0; i < num; i++) {
+		if (msgs[i].flags & I2C_M_TEN) {
+			dev_err(&adap->dev,
+				"s6i2c: 10 bits addr not supported\n");
+			return -EINVAL;
+		}
+		if (msgs[i].len == 0) {
+			dev_err(&adap->dev,
+				"s6i2c: zero length message not supported\n");
+			return -EINVAL;
+		}
+		if (msgs[i].addr != msgs[0].addr) {
+			dev_err(&adap->dev,
+				"s6i2c: multiple xfer cannot change target\n");
+			return -EINVAL;
+		}
+	}
+
+	iface->msgs = msgs;
+	iface->msgs_num = num;
+	iface->msgs_push = 0;
+	iface->msgs_done = 0;
+	iface->push = 0;
+	iface->done = 0;
+	iface->timeout_count = 10;
+	i2c_wr16(iface, S6_I2C_TAR, msgs[0].addr);
+	i2c_wr16(iface, S6_I2C_ENABLE, 1);
+	i2c_wr16(iface, S6_I2C_INTRMASK, (1 << S6_I2C_INTR_TXEMPTY) |
+					 (1 << S6_I2C_INTR_TXABRT));
+
+	iface->timeout_timer.expires = jiffies + POLL_TIMEOUT;
+	add_timer(&iface->timeout_timer);
+	wait_for_completion(&iface->complete);
+	del_timer_sync(&iface->timeout_timer);
+	while (i2c_rd32(iface, S6_I2C_TXFLR) > 0)
+		schedule();
+	while (i2c_rd16(iface, S6_I2C_STATUS) & (1 << S6_I2C_STATUS_ACTIVITY))
+		schedule();
+
+	i2c_wr16(iface, S6_I2C_INTRMASK, 0);
+	i2c_wr16(iface, S6_I2C_ENABLE, 0);
+	return iface->msgs_done;
+}
+
+static u32 s6i2c_functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+static struct i2c_algorithm s6i2c_algorithm = {
+	.master_xfer   = s6i2c_master_xfer,
+	.functionality = s6i2c_functionality,
+};
+
+static u16 __devinit nanoseconds_on_clk(struct s6i2c_if *iface, u32 ns)
+{
+	u32 dividend = ((clk_get_rate(iface->clk) / 1000) * ns) / 1000000;
+	if (dividend > 0xffff)
+		return 0xffff;
+	return dividend;
+}
+
+static int __devinit s6i2c_probe(struct platform_device *dev)
+{
+	struct s6i2c_if *iface = &s6i2c_if;
+	struct i2c_adapter *p_adap;
+	const char *clock;
+	int bus_num, rc;
+	spin_lock_init(&iface->lock);
+	init_completion(&iface->complete);
+	iface->irq = platform_get_irq(dev, 0);
+	if (iface->irq < 0) {
+		rc = iface->irq;
+		goto err_out;
+	}
+	iface->res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!iface->res) {
+		rc = -ENXIO;
+		goto err_out;
+	}
+	iface->res = request_mem_region(iface->res->start,
+					resource_size(iface->res),
+					dev->dev.bus_id);
+	if (!iface->res) {
+		rc = -EBUSY;
+		goto err_out;
+	}
+	iface->reg = ioremap_nocache(iface->res->start,
+				     resource_size(iface->res));
+	if (!iface->reg) {
+		rc = -ENOMEM;
+		goto err_reg;
+	}
+
+	clock = 0;
+	bus_num = -1;
+	if (dev->dev.platform_data) {
+		struct s6_i2c_platform_data *pdata = dev->dev.platform_data;
+		bus_num = pdata->bus_num;
+		clock = pdata->clock;
+	}
+	iface->clk = clk_get(&dev->dev, clock);
+	if (IS_ERR(iface->clk)) {
+		rc = PTR_ERR(iface->clk);
+		goto err_map;
+	}
+	rc = clk_enable(iface->clk);
+	if (rc < 0)
+		goto err_clk_put;
+	init_timer(&iface->timeout_timer);
+	iface->timeout_timer.function = s6i2c_timeout;
+	iface->timeout_timer.data = (unsigned long)iface;
+
+	p_adap = &iface->adap;
+	strlcpy(p_adap->name, dev->name, sizeof(p_adap->name));
+	p_adap->algo = &s6i2c_algorithm;
+	p_adap->algo_data = iface;
+	p_adap->nr = bus_num;
+	p_adap->class = 0;
+	p_adap->dev.parent = &dev->dev;
+	i2c_wr16(iface, S6_I2C_INTRMASK, 0);
+	rc = request_irq(iface->irq, s6i2c_interrupt_entry,
+			 IRQF_SHARED, dev->name, iface);
+	if (rc) {
+		dev_err(&p_adap->dev, "s6i2c: cant get IRQ %d\n", iface->irq);
+		goto err_clk_dis;
+	}
+
+	i2c_wr16(iface, S6_I2C_ENABLE, 0);
+	udelay(1);
+	i2c_wr32(iface, S6_I2C_SRESET, 1 << S6_I2C_SRESET_IC_SRST);
+	i2c_wr16(iface, S6_I2C_CLRTXABRT, 1);
+	i2c_wr16(iface, S6_I2C_CON,
+			(1 << S6_I2C_CON_MASTER) |
+			(S6_I2C_CON_SPEED_NORMAL << S6_I2C_CON_SPEED) |
+			(0 << S6_I2C_CON_10BITSLAVE) |
+			(0 << S6_I2C_CON_10BITMASTER) |
+			(1 << S6_I2C_CON_RESTARTENA) |
+			(1 << S6_I2C_CON_SLAVEDISABLE));
+	i2c_wr16(iface, S6_I2C_SSHCNT, nanoseconds_on_clk(iface, 4000));
+	i2c_wr16(iface, S6_I2C_SSLCNT, nanoseconds_on_clk(iface, 4700));
+	i2c_wr16(iface, S6_I2C_FSHCNT, nanoseconds_on_clk(iface, 600));
+	i2c_wr16(iface, S6_I2C_FSLCNT, nanoseconds_on_clk(iface, 1300));
+	i2c_wr16(iface, S6_I2C_RXTL, 0);
+	i2c_wr16(iface, S6_I2C_TXTL, 0);
+
+	platform_set_drvdata(dev, iface);
+	if (bus_num < 0)
+		rc = i2c_add_adapter(p_adap);
+	else
+		rc = i2c_add_numbered_adapter(p_adap);
+	if (rc)
+		goto err_irq_free;
+	return 0;
+
+err_irq_free:
+	free_irq(iface->irq, iface);
+err_clk_dis:
+	clk_disable(iface->clk);
+err_clk_put:
+	clk_put(iface->clk);
+err_map:
+	iounmap(iface->reg);
+err_reg:
+	release_mem_region(iface->res->start,
+			   resource_size(iface->res));
+err_out:
+	return rc;
+}
+
+static int __devexit s6i2c_remove(struct platform_device *pdev)
+{
+	struct s6i2c_if *iface = platform_get_drvdata(pdev);
+	i2c_wr16(iface, S6_I2C_ENABLE, 0);
+	platform_set_drvdata(pdev, NULL);
+	i2c_del_adapter(&iface->adap);
+	free_irq(iface->irq, iface);
+	clk_disable(iface->clk);
+	clk_put(iface->clk);
+	iounmap(iface->reg);
+	release_mem_region(iface->res->start,
+			   resource_size(iface->res));
+	return 0;
+}
+
+static struct platform_driver s6i2c_driver = {
+	.probe		= s6i2c_probe,
+	.remove		= __devexit_p(s6i2c_remove),
+	.driver		= {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init s6i2c_init(void)
+{
+	pr_info("I2C: S6000 I2C driver\n");
+	return platform_driver_register(&s6i2c_driver);
+}
+
+static void __exit s6i2c_exit(void)
+{
+	platform_driver_unregister(&s6i2c_driver);
+}
+
+MODULE_DESCRIPTION("I2C-Bus adapter routines for S6000 I2C");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
+
+subsys_initcall(s6i2c_init);
+module_exit(s6i2c_exit);
diff --git a/drivers/i2c/busses/i2c-s6000.h b/drivers/i2c/busses/i2c-s6000.h
new file mode 100644
index 0000000..ff23b81
--- /dev/null
+++ b/drivers/i2c/busses/i2c-s6000.h
@@ -0,0 +1,79 @@
+/*
+ * drivers/i2c/busses/i2c-s6000.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2008 Emlix GmbH <info@emlix.com>
+ * Author:	Oskar Schirmer <os@emlix.com>
+ */
+
+#ifndef __DRIVERS_I2C_BUSSES_I2C_S6000_H
+#define __DRIVERS_I2C_BUSSES_I2C_S6000_H
+
+#define S6_I2C_CON		0x000
+#define S6_I2C_CON_MASTER		0
+#define S6_I2C_CON_SPEED		1
+#define S6_I2C_CON_SPEED_NORMAL			1
+#define S6_I2C_CON_SPEED_FAST			2
+#define S6_I2C_CON_SPEED_MASK			3
+#define S6_I2C_CON_10BITSLAVE		3
+#define S6_I2C_CON_10BITMASTER		4
+#define S6_I2C_CON_RESTARTENA		5
+#define S6_I2C_CON_SLAVEDISABLE		6
+#define S6_I2C_TAR		0x004
+#define S6_I2C_TAR_GCORSTART		10
+#define S6_I2C_TAR_SPECIAL		11
+#define S6_I2C_SAR		0x008
+#define S6_I2C_HSMADDR		0x00C
+#define S6_I2C_DATACMD		0x010
+#define S6_I2C_DATACMD_READ		8
+#define S6_I2C_SSHCNT		0x014
+#define S6_I2C_SSLCNT		0x018
+#define S6_I2C_FSHCNT		0x01C
+#define S6_I2C_FSLCNT		0x020
+#define S6_I2C_INTRSTAT		0x02C
+#define S6_I2C_INTRMASK		0x030
+#define S6_I2C_RAWINTR		0x034
+#define S6_I2C_INTR_RXUNDER		0
+#define S6_I2C_INTR_RXOVER		1
+#define S6_I2C_INTR_RXFULL		2
+#define S6_I2C_INTR_TXOVER		3
+#define S6_I2C_INTR_TXEMPTY		4
+#define S6_I2C_INTR_RDREQ		5
+#define S6_I2C_INTR_TXABRT		6
+#define S6_I2C_INTR_RXDONE		7
+#define S6_I2C_INTR_ACTIVITY		8
+#define S6_I2C_INTR_STOPDET		9
+#define S6_I2C_INTR_STARTDET		10
+#define S6_I2C_INTR_GENCALL		11
+#define S6_I2C_RXTL		0x038
+#define S6_I2C_TXTL		0x03C
+#define S6_I2C_CLRINTR		0x040
+#define S6_I2C_CLRRXUNDER	0x044
+#define S6_I2C_CLRRXOVER	0x048
+#define S6_I2C_CLRTXOVER	0x04C
+#define S6_I2C_CLRRDREQ		0x050
+#define S6_I2C_CLRTXABRT	0x054
+#define S6_I2C_CLRRXDONE	0x058
+#define S6_I2C_CLRACTIVITY	0x05C
+#define S6_I2C_CLRSTOPDET	0x060
+#define S6_I2C_CLRSTARTDET	0x064
+#define S6_I2C_CLRGENCALL	0x068
+#define S6_I2C_ENABLE		0x06C
+#define S6_I2C_STATUS		0x070
+#define S6_I2C_STATUS_ACTIVITY		0
+#define S6_I2C_STATUS_TFNF		1
+#define S6_I2C_STATUS_TFE		2
+#define S6_I2C_STATUS_RFNE		3
+#define S6_I2C_STATUS_RFF		4
+#define S6_I2C_TXFLR		0x074
+#define S6_I2C_RXFLR		0x078
+#define S6_I2C_SRESET		0x07C
+#define S6_I2C_SRESET_IC_SRST		0
+#define S6_I2C_SRESET_IC_MASTER_SRST	1
+#define S6_I2C_SRESET_IC_SLAVE_SRST	2
+#define S6_I2C_TXABRTSOURCE	0x080
+
+#endif
diff --git a/include/linux/i2c/s6000.h b/include/linux/i2c/s6000.h
new file mode 100644
index 0000000..d9b34bf
--- /dev/null
+++ b/include/linux/i2c/s6000.h
@@ -0,0 +1,10 @@
+#ifndef __LINUX_I2C_S6000_H
+#define __LINUX_I2C_S6000_H
+
+struct s6_i2c_platform_data {
+	const char *clock; /* the clock to use */
+	int bus_num; /* the bus number to register */
+};
+
+#endif
+
-- 
1.6.2.107.ge47ee

