Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYJ1Rrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYJ1Rrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYJ1RqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:46:23 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:57692 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754127AbYJ1RqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:46:22 -0400
Date: Tue, 28 Oct 2008 20:46:21 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <david-b@pacbell.net>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: [PATCH 6/6] gpio: OpenFirmware bindings for the pca953x
Message-ID: <20081028174621.GF25349@oksana.dev.rtsoft.ru>
References: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately we have to duplicate compatibles list, since
MODULE_DEVICE_TABLE() doesn't work with the extern symbols. :-(

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/gpio/Kconfig      |    7 ++
 drivers/gpio/Makefile     |    1 +
 drivers/gpio/of_pca953x.c |  134 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/of/base.c         |   21 +++++++
 4 files changed, 163 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/of_pca953x.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 7f2ee27..d5a9e2c 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -103,6 +103,13 @@ config GPIO_PCA953X
 	  This driver can also be built as a module.  If so, the module
 	  will be called pca953x.
 
+config GPIO_OF_PCA953X
+	tristate "OpenFirmware Bindings for PCA953x, PCA955x, and MAX7310"
+	depends on GPIO_PCA953X
+	help
+	  Say yes here to enable OpenFirmware bindings for PCA953x, PCA955x,
+	  and MAX7310 I/O ports.
+
 config GPIO_PCF857X
 	tristate "PCF857x, PCA{85,96}7x, and MAX732[89] I2C GPIO expanders"
 	depends on I2C
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 6aafdeb..b6edf33 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
 obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
+obj-$(CONFIG_GPIO_OF_PCA953X)	+= of_pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
diff --git a/drivers/gpio/of_pca953x.c b/drivers/gpio/of_pca953x.c
new file mode 100644
index 0000000..6884776
--- /dev/null
+++ b/drivers/gpio/of_pca953x.c
@@ -0,0 +1,134 @@
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/of.h>
+#include <linux/of_i2c.h>
+#include <linux/of_gpio.h>
+#include <linux/of_platform.h>
+#include <linux/i2c/pca953x.h>
+
+struct of_pca953x {
+	struct device_node *node;
+	struct pca953x_platform_data pdata;
+	struct i2c_client *client;
+};
+
+static int of_pca953x_setup(struct i2c_client *client, struct gpio_chip *chip,
+			    void *context)
+{
+	struct of_pca953x *of_pca = context;
+	struct of_gpio_chip *of_gc;
+
+	of_gc = kzalloc(sizeof(*of_gc), GFP_KERNEL);
+	if (!of_gc)
+		return -ENOMEM;
+
+	of_gc->gpio_cells = 2;
+	of_gc->xlate = of_gpio_simple_xlate;
+
+	of_gc->chip = chip;
+	of_pca->node->data = of_gc;
+
+	return 0;
+}
+
+static int of_pca953x_teardown(struct i2c_client *client,
+			       struct gpio_chip *chip,
+			       void *context)
+{
+	struct of_pca953x *of_pca = context;
+	struct of_gpio_chip *of_gc = of_pca->node->data;
+
+	of_pca->node->data = NULL;
+	kfree(of_gc);
+	return 0;
+}
+
+static int __devinit of_pca953x_platform_probe(struct of_device *ofdev,
+					    const struct of_device_id *match)
+{
+	struct device *dev = &ofdev->dev;
+	struct device *adap_dev = dev->parent;
+	struct i2c_adapter *adap = to_i2c_adapter(adap_dev);
+	struct device_node *node = ofdev->node;
+	struct i2c_board_info info = {};
+	struct of_pca953x *of_pca;
+	int ret;
+
+	of_pca = kzalloc(sizeof(*of_pca), GFP_KERNEL);
+	if (!of_pca)
+		return -ENOMEM;
+
+	of_pca->node = node;
+	of_pca->pdata.gpio_base = -1;
+	of_pca->pdata.context = of_pca;
+	of_pca->pdata.setup = of_pca953x_setup;
+	of_pca->pdata.teardown = of_pca953x_teardown;
+	info.platform_data = &of_pca->pdata;
+
+	of_pca->client = of_register_i2c_device(adap, &info, node);
+	if (!of_pca->client) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	dev_set_drvdata(dev, of_pca);
+	return 0;
+err:
+	kfree(of_pca);
+	return ret;
+}
+
+static int __devexit of_pca953x_platform_remove(struct of_device *ofdev)
+{
+	struct of_pca953x *of_pca = dev_get_drvdata(&ofdev->dev);
+
+	of_unregister_i2c_device(of_pca->client);
+	return 0;
+}
+
+static const struct of_device_id of_pca953x_ids[] = {
+	{ "nxp,pca9534" },
+	{ "nxp,pca9535" },
+	{ "nxp,pca9536" },
+	{ "nxp,pca9537" },
+	{ "nxp,pca9538" },
+	{ "nxp,pca9539" },
+	{ "nxp,pca9554" },
+	{ "nxp,pca9555" },
+	{ "nxp,pca9557" },
+	{ "ti,pca9534" },
+	{ "ti,pca9535" },
+	{ "ti,pca9536" },
+	{ "ti,pca9537" },
+	{ "ti,pca9538" },
+	{ "ti,pca9539" },
+	{ "ti,pca9554" },
+	{ "ti,pca9555" },
+	{ "ti,pca9557" },
+	{ "maxim,max7310" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_pca953x_ids);
+
+static struct of_platform_driver of_pca953x_platform_driver = {
+	.name		= "of_pca953x_platform",
+	.match_table	= of_pca953x_ids,
+	.probe		= of_pca953x_platform_probe,
+	.remove		= __devexit_p(of_pca953x_platform_remove),
+};
+
+static int __init of_pca953x_platform_init(void)
+{
+	return of_register_platform_driver(&of_pca953x_platform_driver);
+}
+module_init(of_pca953x_platform_init);
+
+static void __exit of_pca953x_platform_exit(void)
+{
+	of_unregister_platform_driver(&of_pca953x_platform_driver);
+}
+module_exit(of_pca953x_platform_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 1baeee3..f828792 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -464,6 +464,27 @@ EXPORT_SYMBOL_GPL(of_modalias_node);
  * devices.
  */
 static const char *of_pdev_list[] = {
+#if defined(CONFIG_GPIO_OF_PCA953X) || defined(CONFIG_GPIO_OF_PCA953X_MODULE)
+	"nxp,pca9534",
+	"nxp,pca9535",
+	"nxp,pca9536",
+	"nxp,pca9537",
+	"nxp,pca9538",
+	"nxp,pca9539",
+	"nxp,pca9554",
+	"nxp,pca9555",
+	"nxp,pca9557",
+	"ti,pca9534",
+	"ti,pca9535",
+	"ti,pca9536",
+	"ti,pca9537",
+	"ti,pca9538",
+	"ti,pca9539",
+	"ti,pca9554",
+	"ti,pca9555",
+	"ti,pca9557",
+	"maxim,max7310",
+#endif
 };
 
 /**
-- 
1.5.6.3
