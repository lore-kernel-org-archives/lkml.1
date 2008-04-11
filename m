Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbYDKOKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbYDKOKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 10:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759450AbYDKOK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 10:10:29 -0400
Received: from mail0.scram.de ([78.47.204.202]:43795 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbYDKOK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 10:10:28 -0400
X-Spam-Score: -4.229
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <47FF7149.1080301@scram.de>
Date: Fri, 11 Apr 2008 16:10:17 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Jean Delvare <khali@linux-fr.org>, Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>
Subject: [PATCH4/7] i2c: Convert PowerPC MPC i2c to of_platform_driver from
 platform_driver
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on earlier work by Jon Smirl.

Changed common name from powerpc_ to of_ per Olof's suggestion.
Convert MPC i2c driver from a platform_driver to a of_platform_driver. Add the ability to dynamically load i2c drivers based on device tree names. Routine names were changed from fsl_ to mpc_ to make them match the file name. Common code moved to of-common.* Orginal ppc driver left intact for deletion when ppc arch is removed.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Cc: Jon Smirl <jonsmirl@gmail.com>
---
 arch/powerpc/sysdev/fsl_soc.c |  123 ---------------------------------
 drivers/i2c/busses/i2c-mpc.c  |  150 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 144 insertions(+), 129 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 2cd4ef9..6f68969 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -386,129 +386,6 @@ err:
 
 arch_initcall(gfar_of_init);
 
-#ifdef CONFIG_I2C_BOARDINFO
-#include <linux/i2c.h>
-struct i2c_driver_device {
-	char	*of_device;
-	char	*i2c_type;
-};
-
-static struct i2c_driver_device i2c_devices[] __initdata = {
-	{"ricoh,rs5c372a", "rs5c372a",},
-	{"ricoh,rs5c372b", "rs5c372b",},
-	{"ricoh,rv5c386",  "rv5c386",},
-	{"ricoh,rv5c387a", "rv5c387a",},
-	{"dallas,ds1307",  "ds1307",},
-	{"dallas,ds1337",  "ds1337",},
-	{"dallas,ds1338",  "ds1338",},
-	{"dallas,ds1339",  "ds1339",},
-	{"dallas,ds1340",  "ds1340",},
-	{"stm,m41t00",     "m41t00"},
-	{"dallas,ds1374",  "rtc-ds1374",},
-};
-
-static int __init of_find_i2c_driver(struct device_node *node,
-				     struct i2c_board_info *info)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(i2c_devices); i++) {
-		if (!of_device_is_compatible(node, i2c_devices[i].of_device))
-			continue;
-		if (strlcpy(info->type, i2c_devices[i].i2c_type,
-			    I2C_NAME_SIZE) >= I2C_NAME_SIZE)
-			return -ENOMEM;
-		return 0;
-	}
-	return -ENODEV;
-}
-
-static void __init of_register_i2c_devices(struct device_node *adap_node,
-					   int bus_num)
-{
-	struct device_node *node = NULL;
-
-	while ((node = of_get_next_child(adap_node, node))) {
-		struct i2c_board_info info = {};
-		const u32 *addr;
-		int len;
-
-		addr = of_get_property(node, "reg", &len);
-		if (!addr || len < sizeof(int) || *addr > (1 << 10) - 1) {
-			printk(KERN_WARNING "fsl_soc.c: invalid i2c device entry\n");
-			continue;
-		}
-
-		info.irq = irq_of_parse_and_map(node, 0);
-		if (info.irq == NO_IRQ)
-			info.irq = -1;
-
-		if (of_find_i2c_driver(node, &info) < 0)
-			continue;
-
-		info.addr = *addr;
-
-		i2c_register_board_info(bus_num, &info, 1);
-	}
-}
-
-static int __init fsl_i2c_of_init(void)
-{
-	struct device_node *np;
-	unsigned int i = 0;
-	struct platform_device *i2c_dev;
-	int ret;
-
-	for_each_compatible_node(np, NULL, "fsl-i2c") {
-		struct resource r[2];
-		struct fsl_i2c_platform_data i2c_data;
-		const unsigned char *flags = NULL;
-
-		memset(&r, 0, sizeof(r));
-		memset(&i2c_data, 0, sizeof(i2c_data));
-
-		ret = of_address_to_resource(np, 0, &r[0]);
-		if (ret)
-			goto err;
-
-		of_irq_to_resource(np, 0, &r[1]);
-
-		i2c_dev = platform_device_register_simple("fsl-i2c", i, r, 2);
-		if (IS_ERR(i2c_dev)) {
-			ret = PTR_ERR(i2c_dev);
-			goto err;
-		}
-
-		i2c_data.device_flags = 0;
-		flags = of_get_property(np, "dfsrr", NULL);
-		if (flags)
-			i2c_data.device_flags |= FSL_I2C_DEV_SEPARATE_DFSRR;
-
-		flags = of_get_property(np, "fsl5200-clocking", NULL);
-		if (flags)
-			i2c_data.device_flags |= FSL_I2C_DEV_CLOCK_5200;
-
-		ret =
-		    platform_device_add_data(i2c_dev, &i2c_data,
-					     sizeof(struct
-						    fsl_i2c_platform_data));
-		if (ret)
-			goto unreg;
-
-		of_register_i2c_devices(np, i++);
-	}
-
-	return 0;
-
-unreg:
-	platform_device_unregister(i2c_dev);
-err:
-	return ret;
-}
-
-arch_initcall(fsl_i2c_of_init);
-#endif
-
 #ifdef CONFIG_PPC_83xx
 static int __init mpc83xx_wdt_init(void)
 {
diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index bbe787b..fdc4f67 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -18,20 +18,24 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
-
 #include <asm/io.h>
 #include <linux/fsl_devices.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 
-#define MPC_I2C_ADDR  0x00
+#ifdef CONFIG_PPC_MERGE
+#include <linux/of_platform.h>
+#include <linux/of_i2c.h"
+#endif
+
+#define DRV_NAME "mpc-i2c"
+
 #define MPC_I2C_FDR 	0x04
 #define MPC_I2C_CR	0x08
 #define MPC_I2C_SR	0x0c
 #define MPC_I2C_DR	0x10
 #define MPC_I2C_DFSRR 0x14
-#define MPC_I2C_REGION 0x20
 
 #define CCR_MEN  0x80
 #define CCR_MIEN 0x40
@@ -57,7 +61,7 @@ struct mpc_i2c {
 	u32 flags;
 };
 
-static __inline__ void writeccr(struct mpc_i2c *i2c, u32 x)
+static inline void writeccr(struct mpc_i2c *i2c, u32 x)
 {
 	writeb(x, i2c->base + MPC_I2C_CR);
 }
@@ -178,7 +182,7 @@ static void mpc_i2c_stop(struct mpc_i2c *i2c)
 }
 
 static int mpc_write(struct mpc_i2c *i2c, int target,
-		     const u8 * data, int length, int restart)
+		     const u8 *data, int length, int restart)
 {
 	int i, result;
 	unsigned timeout = i2c->adap.timeout;
@@ -209,7 +213,7 @@ static int mpc_write(struct mpc_i2c *i2c, int target,
 }
 
 static int mpc_read(struct mpc_i2c *i2c, int target,
-		    u8 * data, int length, int restart)
+		    u8 *data, int length, int restart)
 {
 	unsigned timeout = i2c->adap.timeout;
 	int i, result;
@@ -315,6 +319,138 @@ static struct i2c_adapter mpc_ops = {
 	.timeout = 1,
 };
 
+#ifdef CONFIG_PPC_MERGE
+
+struct i2c_driver_device {
+	char	*of_device;
+	char	*i2c_driver;
+	char	*i2c_type;
+};
+
+static int mpc_i2c_probe(struct of_device *op, const struct of_device_id *match)
+{
+	int result = 0;
+	struct mpc_i2c *i2c;
+
+	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
+	if (!i2c)
+		return -ENOMEM;
+
+	if (of_get_property(op->node, "dfsrr", NULL))
+		i2c->flags |= FSL_I2C_DEV_SEPARATE_DFSRR;
+
+	if (of_device_is_compatible(op->node, "mpc5200-i2c"))
+		i2c->flags |= FSL_I2C_DEV_CLOCK_5200;
+
+	init_waitqueue_head(&i2c->queue);
+
+	i2c->base = of_iomap(op->node, 0);
+	if (!i2c->base) {
+		printk(KERN_ERR "i2c-mpc - failed to map controller\n");
+		result = -ENOMEM;
+		goto fail_map;
+	}
+
+	i2c->irq = irq_of_parse_and_map(op->node, 0);
+	if (i2c->irq == NO_IRQ) {
+		result = -ENXIO;
+		goto fail_irq;
+	}
+
+	result = request_irq(i2c->irq, mpc_i2c_isr,
+						IRQF_SHARED, "i2c-mpc", i2c);
+	if (result < 0) {
+		printk(KERN_ERR "i2c-mpc - failed to attach interrupt\n");
+		goto fail_request;
+	}
+
+	mpc_i2c_setclock(i2c);
+
+	dev_set_drvdata(&op->dev, i2c);
+
+	i2c->adap = mpc_ops;
+	i2c_set_adapdata(&i2c->adap, i2c);
+	i2c->adap.dev.parent = &op->dev;
+
+	result = i2c_add_adapter(&i2c->adap);
+	if (result < 0) {
+		printk(KERN_ERR "i2c-mpc - failed to add adapter\n");
+		goto fail_add;
+	}
+
+	of_register_i2c_devices(&i2c->adap, op->node);
+
+	return result;
+
+ fail_add:
+	dev_set_drvdata(&op->dev, NULL);
+	free_irq(i2c->irq, i2c);
+ fail_request:
+	irq_dispose_mapping(i2c->irq);
+ fail_irq:
+	iounmap(i2c->base);
+ fail_map:
+	kfree(i2c);
+	return result;
+};
+
+static int mpc_i2c_remove(struct of_device *op)
+{
+	struct mpc_i2c *i2c = dev_get_drvdata(&op->dev);
+
+	i2c_del_adapter(&i2c->adap);
+	dev_set_drvdata(&op->dev, NULL);
+
+	if (i2c->irq != NO_IRQ)
+		free_irq(i2c->irq, i2c);
+
+	irq_dispose_mapping(i2c->irq);
+	iounmap(i2c->base);
+	kfree(i2c);
+	return 0;
+};
+
+static const struct of_device_id mpc_i2c_of_match[] = {
+	{
+		.compatible	= "fsl-i2c",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, mpc_i2c_of_match);
+
+
+/* Structure for a device driver */
+static struct of_platform_driver mpc_i2c_driver = {
+	.match_table	= mpc_i2c_of_match,
+	.probe		= mpc_i2c_probe,
+	.remove		= __devexit_p(mpc_i2c_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= DRV_NAME,
+	},
+};
+
+static int __init mpc_i2c_init(void)
+{
+	int rv;
+
+	rv = of_register_platform_driver(&mpc_i2c_driver);
+	if (rv)
+		printk(KERN_ERR DRV_NAME
+		       " of_register_platform_driver failed (%i)\n", rv);
+	return rv;
+}
+
+static void __exit mpc_i2c_exit(void)
+{
+	of_unregister_platform_driver(&mpc_i2c_driver);
+}
+
+module_init(mpc_i2c_init);
+module_exit(mpc_i2c_exit);
+
+#else
+
 static int fsl_i2c_probe(struct platform_device *pdev)
 {
 	int result = 0;
@@ -415,6 +551,8 @@ static void __exit fsl_i2c_exit(void)
 module_init(fsl_i2c_init);
 module_exit(fsl_i2c_exit);
 
+#endif
+
 MODULE_AUTHOR("Adrian Cox <adrian@humboldt.co.uk>");
 MODULE_DESCRIPTION
     ("I2C-Bus adapter for MPC107 bridge and MPC824x/85xx/52xx processors");
-- 
1.5.4.5



