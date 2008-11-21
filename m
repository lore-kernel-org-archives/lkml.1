Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbYKUKMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbYKUKMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYKUKMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:12:24 -0500
Received: from port-92-198-50-35.dynamic.qsc.de ([92.198.50.35]:36166 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbYKUKMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:12:23 -0500
Date: Fri, 21 Nov 2008 11:12:04 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
       Luotao Fu <l.fu@pengutronix.de>
Subject: Re: [PATCH] Add 1-wire master driver for i.MX27 / i.MX31
Message-ID: <20081121101204.GA6968@pengutronix.de>
References: <1227046577988-git-send-email-zbr@ioremap.net> <20081119001932.0038a80b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119001932.0038a80b.akpm@linux-foundation.org>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche
	Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 09:31:21 up 14:08,  2 users,  load average: 1.01, 0.37, 0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Sorry for the delay, we are moving to a new office at the moment.

On Wed, Nov 19, 2008 at 12:19:32AM -0800, Andrew Morton wrote:
> On Wed, 19 Nov 2008 01:16:13 +0300 Evgeniy Polyakov <zbr@ioremap.net> wrote:
> 
> > From: Sascha Hauer <s.hauer@pengutronix.de>
> > 
> > This patch adds support for the 1-wire master interface for i.MX27 and
> > i.MX31.
> 
> Looks sane.
> 
> > Ack for this one, the other patches from this series need to go via
> > Russell King to prevent merge conflicts with other MX2 patches. Sorry, I
> > should have made that clear.
> 
> Is this patch fully independent of the others?

The first patch adds a platform driver and the other patches add users
for this driver. Otherwise they are independent.

> 
> >
> > ...
> >
> > +static int __devinit mxc_w1_probe(struct platform_device *pdev)
> > +{
> > +	struct mxc_w1_device *mdev;
> > +	struct resource *res;
> > +	int err = 0;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res)
> > +		return -ENODEV;
> > +
> > +	mdev = kzalloc(sizeof(struct mxc_w1_device) +
> > +		      sizeof(struct w1_bus_master), GFP_KERNEL);
> 
> whee, that's a bit of a hack.  It would be better to do
> 
> struct foo {
> 	struct mxc_w1_device mxc_w1_device;
> 	struct w1_bus_master w1_bus_master;
> };
> 
> no?

Uh, yes that's indeed a hack. I changed it to:

struct mxc_w1_device {
	[...]
	struct w1_bus_master bus_master;
};

> 
> > +	if (!mdev)
> > +		return -ENOMEM;
> > +
> > +	mdev->clk = clk_get(&pdev->dev, "owire_clk");
> > +	if (!mdev->clk) {
> > +		err = -ENODEV;
> > +		goto failed_clk;
> > +	}
> > +
> > +	mdev->bus_master = (struct w1_bus_master *)(mdev + 1);
> > +	mdev->clkdiv = (clk_get_rate(mdev->clk) / 1000000) - 1;
> 
> If that 1000000 refers to microseconds then the use of USEC_PER_SEC
> would be clearer.

No, it's clk_get_rate() in Hz divided by 1000000 Hz to get a plain
divider without unit.


Here's an updated version of the patch. Let me know if you want a patch
against your tree instead.

Sascha


commit 8259cf2a77b1f2aa215940576f5a55ce72e58a64
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Wed Nov 12 16:19:22 2008 +0100

    Add 1-wire master driver for i.MX27 / i.MX31
    
    This patch adds support for the 1-wire master interface for i.MX27 and
    i.MX31.
    
    Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

diff --git a/Documentation/w1/masters/00-INDEX b/Documentation/w1/masters/00-INDEX
index 7b0ceaa..d63fa02 100644
--- a/Documentation/w1/masters/00-INDEX
+++ b/Documentation/w1/masters/00-INDEX
@@ -4,5 +4,7 @@ ds2482
 	- The Maxim/Dallas Semiconductor DS2482 provides 1-wire busses.
 ds2490
 	- The Maxim/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.
+mxc_w1
+	- W1 master controller driver found on Freescale MX2/MX3 SoCs
 w1-gpio
 	- GPIO 1-wire bus master driver.
diff --git a/Documentation/w1/masters/mxc-w1 b/Documentation/w1/masters/mxc-w1
new file mode 100644
index 0000000..97f6199
--- /dev/null
+++ b/Documentation/w1/masters/mxc-w1
@@ -0,0 +1,11 @@
+Kernel driver mxc_w1
+====================
+
+Supported chips:
+  * Freescale MX27, MX31 and probably other i.MX SoCs
+    Datasheets:
+        http://www.freescale.com/files/32bit/doc/data_sheet/MCIMX31.pdf?fpsp=1
+	http://www.freescale.com/files/dsp/MCIMX27.pdf?fpsp=1
+
+Author: Originally based on Freescale code, prepared for mainline by
+	Sascha Hauer <s.hauer@pengutronix.de>
diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index c449309..d4f8050 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -34,6 +34,12 @@ config W1_MASTER_DS2482
 	  This driver can also be built as a module.  If so, the module
 	  will be called ds2482.
 
+config W1_MASTER_MXC
+	tristate "Freescale MXC 1-wire busmaster"
+	depends on W1 && ARCH_MXC
+	help
+	  Say Y here to enable MXC 1-wire host
+
 config W1_MASTER_DS1WM
 	tristate "Maxim DS1WM 1-wire busmaster"
 	depends on W1 && ARM
diff --git a/drivers/w1/masters/Makefile b/drivers/w1/masters/Makefile
index 1420b5b..6c61e22 100644
--- a/drivers/w1/masters/Makefile
+++ b/drivers/w1/masters/Makefile
@@ -5,5 +5,7 @@
 obj-$(CONFIG_W1_MASTER_MATROX)		+= matrox_w1.o
 obj-$(CONFIG_W1_MASTER_DS2490)		+= ds2490.o
 obj-$(CONFIG_W1_MASTER_DS2482)		+= ds2482.o
+obj-$(CONFIG_W1_MASTER_MXC)		+= mxc_w1.o
+
 obj-$(CONFIG_W1_MASTER_DS1WM)		+= ds1wm.o
 obj-$(CONFIG_W1_MASTER_GPIO)		+= w1-gpio.o
diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
new file mode 100644
index 0000000..b9d74d0
--- /dev/null
+++ b/drivers/w1/masters/mxc_w1.c
@@ -0,0 +1,211 @@
+/*
+ * Copyright 2005-2008 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright 2008 Luotao Fu, kernel@pengutronix.de
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_log.h"
+
+/* According to the mx27 Datasheet the reset procedure should take up to about
+ * 1350us. We set the timeout to 500*100us = 50ms for sure */
+#define MXC_W1_RESET_TIMEOUT 500
+
+/*
+ * MXC W1 Register offsets
+ */
+#define MXC_W1_CONTROL          0x00
+#define MXC_W1_TIME_DIVIDER     0x02
+#define MXC_W1_RESET            0x04
+#define MXC_W1_COMMAND          0x06
+#define MXC_W1_TXRX             0x08
+#define MXC_W1_INTERRUPT        0x0A
+#define MXC_W1_INTERRUPT_EN     0x0C
+
+struct mxc_w1_device {
+	void __iomem *regs;
+	unsigned int clkdiv;
+	struct clk *clk;
+	struct w1_bus_master bus_master;
+};
+
+/*
+ * this is the low level routine to
+ * reset the device on the One Wire interface
+ * on the hardware
+ */
+static u8 mxc_w1_ds2_reset_bus(void *data)
+{
+	u8 reg_val;
+	unsigned int timeout_cnt = 0;
+	struct mxc_w1_device *dev = data;
+
+	__raw_writeb(0x80, (dev->regs + MXC_W1_CONTROL));
+
+	while (1) {
+		reg_val = __raw_readb(dev->regs + MXC_W1_CONTROL);
+
+		if (((reg_val >> 7) & 0x1) == 0 ||
+		    timeout_cnt > MXC_W1_RESET_TIMEOUT)
+			break;
+		else
+			timeout_cnt++;
+
+		udelay(100);
+	}
+	return (reg_val >> 7) & 0x1;
+}
+
+/*
+ * this is the low level routine to read/write a bit on the One Wire
+ * interface on the hardware. It does write 0 if parameter bit is set
+ * to 0, otherwise a write 1/read.
+ */
+static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
+{
+	struct mxc_w1_device *mdev = data;
+	void __iomem *ctrl_addr = mdev->regs + MXC_W1_CONTROL;
+	unsigned int timeout_cnt = 400; /* Takes max. 120us according to
+					 * datasheet.
+					 */
+
+	__raw_writeb((1 << (5 - bit)), ctrl_addr);
+
+	while (timeout_cnt--) {
+		if (!((__raw_readb(ctrl_addr) >> (5 - bit)) & 0x1))
+			break;
+
+		udelay(1);
+	}
+
+	return ((__raw_readb(ctrl_addr)) >> 3) & 0x1;
+}
+
+static int __init mxc_w1_probe(struct platform_device *pdev)
+{
+	struct mxc_w1_device *mdev;
+	struct resource *res;
+	int err = 0;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	mdev = kzalloc(sizeof(struct mxc_w1_device), GFP_KERNEL);
+	if (!mdev)
+		return -ENOMEM;
+
+	mdev->clk = clk_get(&pdev->dev, "owire_clk");
+	if (!mdev->clk) {
+		err = -ENODEV;
+		goto failed_clk;
+	}
+
+	mdev->clkdiv = (clk_get_rate(mdev->clk) / 1000000) - 1;
+
+	res = request_mem_region(res->start, resource_size(res),
+				"mxc_w1");
+	if (!res) {
+		err = -EBUSY;
+		goto failed_req;
+	}
+
+	mdev->regs = ioremap(res->start, resource_size(res));
+	if (!mdev->regs) {
+		printk(KERN_ERR "Cannot map frame buffer registers\n");
+		goto failed_ioremap;
+	}
+
+	clk_enable(mdev->clk);
+	__raw_writeb(mdev->clkdiv, mdev->regs + MXC_W1_TIME_DIVIDER);
+
+	mdev->bus_master.data = mdev;
+	mdev->bus_master.reset_bus = mxc_w1_ds2_reset_bus;
+	mdev->bus_master.touch_bit = mxc_w1_ds2_touch_bit;
+
+	err = w1_add_master_device(&mdev->bus_master);
+
+	if (err)
+		goto failed_add;
+
+	platform_set_drvdata(pdev, mdev);
+	return 0;
+
+failed_add:
+	iounmap(mdev->regs);
+failed_ioremap:
+	release_mem_region(res->start, resource_size(res));
+failed_req:
+	clk_put(mdev->clk);
+failed_clk:
+	kfree(mdev);
+	return err;
+}
+
+/*
+ * disassociate the w1 device from the driver
+ */
+static int mxc_w1_remove(struct platform_device *pdev)
+{
+	struct mxc_w1_device *mdev = platform_get_drvdata(pdev);
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	w1_remove_master_device(&mdev->bus_master);
+
+	iounmap(mdev->regs);
+	release_mem_region(res->start, resource_size(res));
+	clk_disable(mdev->clk);
+	clk_put(mdev->clk);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver mxc_w1_driver = {
+	.driver = {
+		   .name = "mxc_w1",
+	},
+	.probe = mxc_w1_probe,
+	.remove = mxc_w1_remove,
+};
+
+static int __init mxc_w1_init(void)
+{
+	return platform_driver_register(&mxc_w1_driver);
+}
+
+static void mxc_w1_exit(void)
+{
+	platform_driver_unregister(&mxc_w1_driver);
+}
+
+module_init(mxc_w1_init);
+module_exit(mxc_w1_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Freescale Semiconductors Inc");
+MODULE_DESCRIPTION("Driver for One-Wire on MXC");

-- 
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9
