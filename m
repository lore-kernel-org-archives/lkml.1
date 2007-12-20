Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbXLTEna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbXLTEna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 23:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758919AbXLTEmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 23:42:00 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:44205 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887AbXLTEl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 23:41:58 -0500
Date: Wed, 19 Dec 2007 23:41:44 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [PATCH 4/5] Convert PowerPC MPC i2c to of_platform_driver from
	platform_driver
In-reply-to: <20071220044136.20091.70984.stgit@terra.home>
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-id: <20071220044144.20091.35917.stgit@terra.home>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071220044136.20091.70984.stgit@terra.home>
User-Agent: StGIT/0.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert MPC i2c driver from being a platform_driver to an open firmware version. Error returns were improved. Routine names were changed from fsl_ to mpc_ to make them match the file name.

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
---

 arch/powerpc/sysdev/fsl_soc.c |   96 ----------------------
 drivers/i2c/busses/i2c-mpc.c  |  183 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 180 insertions(+), 99 deletions(-)


diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 268638a..d6ef264 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -318,102 +318,6 @@ err:
 
 arch_initcall(gfar_of_init);
 
-#ifdef CONFIG_I2C_BOARDINFO
-#include <linux/i2c.h>
-
-static void __init of_register_i2c_devices(struct device_node *adap_node,
-					   int bus_num)
-{
-	struct device_node *node = NULL;
-	const char *compatible;
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
-		compatible = of_get_property(node, "compatible", &len);
-		if (!compatible) {
-			printk(KERN_WARNING "i2c-mpc.c: invalid entry, missing compatible attribute\n");
-			continue;
-		}
-		strncpy(info.driver_name, compatible, sizeof(info.driver_name));
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
-	unsigned int i;
-	struct platform_device *i2c_dev;
-	int ret;
-
-	for (np = NULL, i = 0;
-	     (np = of_find_compatible_node(np, "i2c", "fsl-i2c")) != NULL;
-	     i++) {
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
-		of_register_i2c_devices(np, i);
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
index 7c35a8f..4f2e7ea 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -17,7 +17,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/init.h>
-#include <linux/platform_device.h>
+#include <linux/of_platform.h>
 
 #include <asm/io.h>
 #include <linux/fsl_devices.h>
@@ -25,13 +25,13 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 
-#define MPC_I2C_ADDR  0x00
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
@@ -316,6 +316,181 @@ static struct i2c_adapter mpc_ops = {
 	.retries = 1
 };
 
+struct i2c_driver_device {
+	char	*of_device;
+	char	*i2c_driver;
+	char	*i2c_type;
+};
+
+#ifdef CONFIG_PPC_MERGE
+
+static void of_register_i2c_devices(struct i2c_adapter *adap, struct device_node *adap_node)
+{
+	struct device_node *node = NULL;
+
+	while ((node = of_get_next_child(adap_node, node))) {
+		struct i2c_board_info info;
+		const u32 *addr;
+		const char *compatible;
+		int len;
+
+		addr = of_get_property(node, "reg", &len);
+		if (!addr || len < sizeof(int) || *addr > (1 << 10) - 1) {
+			printk(KERN_ERR "i2c-mpc.c: invalid entry, missing reg attribute\n");
+			continue;
+		}
+
+		info.irq = irq_of_parse_and_map(node, 0);
+		if (info.irq == NO_IRQ)
+			info.irq = -1;
+
+		compatible = of_get_property(node, "compatible", &len);
+		if (!compatible) {
+			printk(KERN_ERR "i2c-mpc.c: invalid entry, missing compatible attribute\n");
+			continue;
+		}
+		
+		/* need full alias i2c:NOF,vendor,device */
+		strcpy(info.driver_name, I2C_OF_MODULE_PREFIX);
+		strncat(info.driver_name, compatible, sizeof(info.driver_name));
+		request_module(info.driver_name);
+		
+		/* need module alias OF,vendor,device */
+		strcpy(info.driver_name, OF_I2C_PREFIX);
+		strncat(info.driver_name, compatible, sizeof(info.driver_name));
+		
+		info.type[0] = '\0';
+		info.platform_data = NULL;
+		info.addr = *addr;
+
+		if (!i2c_new_device(adap, &info)) {
+			printk(KERN_ERR "i2c-mpc.c: Failed to load driver for %s\n", info.driver_name);
+			continue;
+		}
+	}
+}
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
+	result = request_irq(i2c->irq, mpc_i2c_isr, IRQF_SHARED, "i2c-mpc", i2c);
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
+fail_add:
+	free_irq(i2c->irq, i2c);
+fail_request:
+	irq_dispose_mapping(i2c->irq);
+fail_irq:
+	iounmap(i2c->base);
+fail_map:
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
+static struct of_device_id mpc_i2c_of_match[] = {
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
+		printk(KERN_ERR DRV_NAME " of_register_platform_driver failed (%i)\n", rv);
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
@@ -416,6 +591,8 @@ static void __exit fsl_i2c_exit(void)
 module_init(fsl_i2c_init);
 module_exit(fsl_i2c_exit);
 
+#endif
+
 MODULE_AUTHOR("Adrian Cox <adrian@humboldt.co.uk>");
 MODULE_DESCRIPTION
     ("I2C-Bus adapter for MPC107 bridge and MPC824x/85xx/52xx processors");

