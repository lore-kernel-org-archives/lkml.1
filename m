Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbYLJQ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbYLJQ23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYLJQ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:28:06 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:54130 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521AbYLJQ2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:28:01 -0500
Date: Wed, 10 Dec 2008 17:27:56 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, khali@linux-fr.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/28] drivers/ide: Drop return value from platform_driver
 remove functions
Message-ID: <Pine.LNX.4.64.0812101727230.21998@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The return value of the remove function of a driver structure, and thus of
a platform_driver structure, is ultimately ignored, and is thus
unnecessary.  This patch removes the return value for the remove function
stored in a platform_driver structure.

For the files drivers/i2c/busses/i2c-at91.c and
drivers/i2c/busses/i2c-mv64xxx.c, the original return value was the value
of a variable storing the result of calling i2c_del_adapter.  I have thus
also deleted the declaration and initialization of this variable.  For the
other files, the return values were always 0.

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
struct platform_driver I;
identifier a,f;
position p;
@@
I.remove = \(f@p\|a(f@p)\);

@void_called@
identifier r.f;
position p;
@@
f@p(...);

@called@
identifier r.f;
position p1 != void_called.p;
@@
f@p1(...)

@localfn@
identifier r.f;
@@
static int f(...) { ... }

@depends on !called && localfn@
struct platform_driver I;
identifier a,f;
position r.p;
@@

I.
- remove
+ remove_new
   = \(f@p\|a(f@p)\);

@depends on !called && localfn@
identifier r.f,i;
constant C;
expression E;
@@

- int
+ void
       f(...) {
  <...
(
-  return \(C\|i\);
+  return;
|
-  return E;
+  E;
+  return;
)
  ...>
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/i2c/busses/i2c-at91.c          |    9 +++------
 drivers/i2c/busses/i2c-au1550.c        |    5 ++---
 drivers/i2c/busses/i2c-bfin-twi.c      |    6 ++----
 drivers/i2c/busses/i2c-davinci.c       |    5 ++---
 drivers/i2c/busses/i2c-gpio.c          |    6 ++----
 drivers/i2c/busses/i2c-highlander.c    |    6 ++----
 drivers/i2c/busses/i2c-iop3xx.c        |    6 ++----
 drivers/i2c/busses/i2c-ixp2000.c       |    6 ++----
 drivers/i2c/busses/i2c-mv64xxx.c       |    9 +++------
 drivers/i2c/busses/i2c-ocores.c        |    6 ++----
 drivers/i2c/busses/i2c-omap.c          |    5 ++---
 drivers/i2c/busses/i2c-parport-light.c |    6 ++----
 drivers/i2c/busses/i2c-pca-platform.c  |    6 ++----
 drivers/i2c/busses/i2c-pmcmsp.c        |    6 ++----
 drivers/i2c/busses/i2c-pnx.c           |    6 ++----
 drivers/i2c/busses/i2c-powermac.c      |    6 ++----
 drivers/i2c/busses/i2c-pxa.c           |    6 ++----
 drivers/i2c/busses/i2c-s3c2410.c       |    8 +++-----
 drivers/i2c/busses/i2c-sh7760.c        |    6 ++----
 drivers/i2c/busses/i2c-sh_mobile.c     |    5 ++---
 drivers/i2c/busses/i2c-simtec.c        |    6 ++----
 drivers/i2c/busses/i2c-versatile.c     |    5 ++---
 drivers/i2c/chips/isp1301_omap.c       |    5 ++---
 23 files changed, 49 insertions(+), 91 deletions(-)

diff --git a/drivers/i2c/busses/i2c-au1550.c b/drivers/i2c/busses/i2c-au1550.c
index 66a04c2..b52c460 100644
--- a/drivers/i2c/busses/i2c-au1550.c
+++ b/drivers/i2c/busses/i2c-au1550.c
@@ -427,7 +427,7 @@ out:
 	return ret;
 }
 
-static int __devexit
+static void __devexit
 i2c_au1550_remove(struct platform_device *pdev)
 {
 	struct i2c_au1550_data *priv = platform_get_drvdata(pdev);
@@ -438,7 +438,6 @@ i2c_au1550_remove(struct platform_device *pdev)
 	release_resource(priv->ioarea);
 	kfree(priv->ioarea);
 	kfree(priv);
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -472,7 +471,7 @@ static struct platform_driver au1xpsc_smbus_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= i2c_au1550_probe,
-	.remove		= __devexit_p(i2c_au1550_remove),
+	.remove_new	= __devexit_p(i2c_au1550_remove),
 	.suspend	= i2c_au1550_suspend,
 	.resume		= i2c_au1550_resume,
 };
diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 3c855ff..0048c6d 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -712,7 +712,7 @@ out_error_nomem:
 	return rc;
 }
 
-static int i2c_bfin_twi_remove(struct platform_device *pdev)
+static void i2c_bfin_twi_remove(struct platform_device *pdev)
 {
 	struct bfin_twi_iface *iface = platform_get_drvdata(pdev);
 
@@ -723,13 +723,11 @@ static int i2c_bfin_twi_remove(struct platform_device *pdev)
 	peripheral_free_list(pin_req[pdev->id]);
 	iounmap(iface->regs_base);
 	kfree(iface);
-
-	return 0;
 }
 
 static struct platform_driver i2c_bfin_twi_driver = {
 	.probe		= i2c_bfin_twi_probe,
-	.remove		= i2c_bfin_twi_remove,
+	.remove_new	= i2c_bfin_twi_remove,
 	.suspend	= i2c_bfin_twi_suspend,
 	.resume		= i2c_bfin_twi_resume,
 	.driver		= {
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 5d77898..02056a0 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -575,7 +575,7 @@ err_release_region:
 	return r;
 }
 
-static int davinci_i2c_remove(struct platform_device *pdev)
+static void davinci_i2c_remove(struct platform_device *pdev)
 {
 	struct davinci_i2c_dev *dev = platform_get_drvdata(pdev);
 	struct resource *mem;
@@ -594,7 +594,6 @@ static int davinci_i2c_remove(struct platform_device *pdev)
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(mem->start, (mem->end - mem->start) + 1);
-	return 0;
 }
 
 /* work with hotplug and coldplug */
@@ -602,7 +601,7 @@ MODULE_ALIAS("platform:i2c_davinci");
 
 static struct platform_driver davinci_i2c_driver = {
 	.probe		= davinci_i2c_probe,
-	.remove		= davinci_i2c_remove,
+	.remove_new	= davinci_i2c_remove,
 	.driver		= {
 		.name	= "i2c_davinci",
 		.owner	= THIS_MODULE,
diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index 32104ea..8515699 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -174,7 +174,7 @@ err_alloc_adap:
 	return ret;
 }
 
-static int __devexit i2c_gpio_remove(struct platform_device *pdev)
+static void __devexit i2c_gpio_remove(struct platform_device *pdev)
 {
 	struct i2c_gpio_platform_data *pdata;
 	struct i2c_adapter *adap;
@@ -187,8 +187,6 @@ static int __devexit i2c_gpio_remove(struct platform_device *pdev)
 	gpio_free(pdata->sda_pin);
 	kfree(adap->algo_data);
 	kfree(adap);
-
-	return 0;
 }
 
 static struct platform_driver i2c_gpio_driver = {
@@ -197,7 +195,7 @@ static struct platform_driver i2c_gpio_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= i2c_gpio_probe,
-	.remove		= __devexit_p(i2c_gpio_remove),
+	.remove_new	= __devexit_p(i2c_gpio_remove),
 };
 
 static int __init i2c_gpio_init(void)
diff --git a/drivers/i2c/busses/i2c-highlander.c b/drivers/i2c/busses/i2c-highlander.c
index f4d22ae..da592f6 100644
--- a/drivers/i2c/busses/i2c-highlander.c
+++ b/drivers/i2c/busses/i2c-highlander.c
@@ -441,7 +441,7 @@ err:
 	return ret;
 }
 
-static int __devexit highlander_i2c_remove(struct platform_device *pdev)
+static void __devexit highlander_i2c_remove(struct platform_device *pdev)
 {
 	struct highlander_i2c_dev *dev = platform_get_drvdata(pdev);
 
@@ -454,8 +454,6 @@ static int __devexit highlander_i2c_remove(struct platform_device *pdev)
 	kfree(dev);
 
 	platform_set_drvdata(pdev, NULL);
-
-	return 0;
 }
 
 static struct platform_driver highlander_i2c_driver = {
@@ -465,7 +463,7 @@ static struct platform_driver highlander_i2c_driver = {
 	},
 
 	.probe		= highlander_i2c_probe,
-	.remove		= __devexit_p(highlander_i2c_remove),
+	.remove_new	= __devexit_p(highlander_i2c_remove),
 };
 
 static int __init highlander_i2c_init(void)
diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
index fc2714a..e2827e1 100644
--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -400,7 +400,7 @@ static const struct i2c_algorithm iop3xx_i2c_algo = {
 	.functionality	= iop3xx_i2c_func,
 };
 
-static int 
+static void
 iop3xx_i2c_remove(struct platform_device *pdev)
 {
 	struct i2c_adapter *padapter = platform_get_drvdata(pdev);
@@ -422,8 +422,6 @@ iop3xx_i2c_remove(struct platform_device *pdev)
 	kfree(padapter);
 
 	platform_set_drvdata(pdev, NULL);
-
-	return 0;
 }
 
 static int 
@@ -524,7 +522,7 @@ out:
 
 static struct platform_driver iop3xx_i2c_driver = {
 	.probe		= iop3xx_i2c_probe,
-	.remove		= iop3xx_i2c_remove,
+	.remove_new	= iop3xx_i2c_remove,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "IOP3xx-I2C",
diff --git a/drivers/i2c/busses/i2c-ixp2000.c b/drivers/i2c/busses/i2c-ixp2000.c
index 05d72e9..77d4541 100644
--- a/drivers/i2c/busses/i2c-ixp2000.c
+++ b/drivers/i2c/busses/i2c-ixp2000.c
@@ -84,7 +84,7 @@ struct ixp2000_i2c_data {
 	struct i2c_algo_bit_data algo_data;
 };
 
-static int ixp2000_i2c_remove(struct platform_device *plat_dev)
+static void ixp2000_i2c_remove(struct platform_device *plat_dev)
 {
 	struct ixp2000_i2c_data *drv_data = platform_get_drvdata(plat_dev);
 
@@ -93,8 +93,6 @@ static int ixp2000_i2c_remove(struct platform_device *plat_dev)
 	i2c_del_adapter(&drv_data->adapter);
 
 	kfree(drv_data);
-
-	return 0;
 }
 
 static int ixp2000_i2c_probe(struct platform_device *plat_dev)
@@ -141,7 +139,7 @@ static int ixp2000_i2c_probe(struct platform_device *plat_dev)
 
 static struct platform_driver ixp2000_i2c_driver = {
 	.probe		= ixp2000_i2c_probe,
-	.remove		= ixp2000_i2c_remove,
+	.remove_new	= ixp2000_i2c_remove,
 	.driver		= {
 		.name	= "IXP2000-I2C",
 		.owner	= THIS_MODULE,
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index e5193bf..9205931 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -285,7 +285,7 @@ request_mem_failed:
 	return ret;
 }
 
-static int __devexit ocores_i2c_remove(struct platform_device* pdev)
+static void __devexit ocores_i2c_remove(struct platform_device *pdev)
 {
 	struct ocores_i2c *i2c = platform_get_drvdata(pdev);
 	struct resource *res;
@@ -309,8 +309,6 @@ static int __devexit ocores_i2c_remove(struct platform_device* pdev)
 		release_mem_region(res->start, res->end - res->start + 1);
 
 	kfree(i2c);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -343,7 +341,7 @@ MODULE_ALIAS("platform:ocores-i2c");
 
 static struct platform_driver ocores_i2c_driver = {
 	.probe   = ocores_i2c_probe,
-	.remove  = __devexit_p(ocores_i2c_remove),
+	.remove_new = __devexit_p(ocores_i2c_remove),
 	.suspend = ocores_i2c_suspend,
 	.resume  = ocores_i2c_resume,
 	.driver  = {
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 608038d..8f6b336 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -656,7 +656,7 @@ err_release_region:
 	return r;
 }
 
-static int
+static void
 omap_i2c_remove(struct platform_device *pdev)
 {
 	struct omap_i2c_dev	*dev = platform_get_drvdata(pdev);
@@ -672,12 +672,11 @@ omap_i2c_remove(struct platform_device *pdev)
 	kfree(dev);
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(mem->start, (mem->end - mem->start) + 1);
-	return 0;
 }
 
 static struct platform_driver omap_i2c_driver = {
 	.probe		= omap_i2c_probe,
-	.remove		= omap_i2c_remove,
+	.remove_new	= omap_i2c_remove,
 	.driver		= {
 		.name	= "i2c_omap",
 		.owner	= THIS_MODULE,
diff --git a/drivers/i2c/busses/i2c-parport-light.c b/drivers/i2c/busses/i2c-parport-light.c
index b2b8380..39f3841 100644
--- a/drivers/i2c/busses/i2c-parport-light.c
+++ b/drivers/i2c/busses/i2c-parport-light.c
@@ -138,15 +138,13 @@ static int __devinit i2c_parport_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int __devexit i2c_parport_remove(struct platform_device *pdev)
+static void __devexit i2c_parport_remove(struct platform_device *pdev)
 {
 	i2c_del_adapter(&parport_adapter);
 
 	/* Un-init if needed (power off...) */
 	if (adapter_parm[type].init.val)
 		line_set(0, &adapter_parm[type].init);
-
-	return 0;
 }
 
 static struct platform_driver i2c_parport_driver = {
@@ -155,7 +153,7 @@ static struct platform_driver i2c_parport_driver = {
 		.name	= DRVNAME,
 	},
 	.probe		= i2c_parport_probe,
-	.remove		= __devexit_p(i2c_parport_remove),
+	.remove_new	= __devexit_p(i2c_parport_remove),
 };
 
 static int __init i2c_parport_device_add(u16 address)
diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
index 6bb15ad..12fed52 100644
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -250,7 +250,7 @@ e_print:
 	return ret;
 }
 
-static int __devexit i2c_pca_pf_remove(struct platform_device *pdev)
+static void __devexit i2c_pca_pf_remove(struct platform_device *pdev)
 {
 	struct i2c_pca_pf_data *i2c = platform_get_drvdata(pdev);
 	platform_set_drvdata(pdev, NULL);
@@ -266,13 +266,11 @@ static int __devexit i2c_pca_pf_remove(struct platform_device *pdev)
 	iounmap(i2c->reg_base);
 	release_mem_region(i2c->io_base, i2c->io_size);
 	kfree(i2c);
-
-	return 0;
 }
 
 static struct platform_driver i2c_pca_pf_driver = {
 	.probe = i2c_pca_pf_probe,
-	.remove = __devexit_p(i2c_pca_pf_remove),
+	.remove_new = __devexit_p(i2c_pca_pf_remove),
 	.driver = {
 		.name = "i2c-pca-platform",
 		.owner = THIS_MODULE,
diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
index dcf2045..3f1266e 100644
--- a/drivers/i2c/busses/i2c-pmcmsp.c
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -369,7 +369,7 @@ ret_err:
 /*
  * Release the device and return 0 if there is one.
  */
-static int __devexit pmcmsptwi_remove(struct platform_device *pldev)
+static void __devexit pmcmsptwi_remove(struct platform_device *pldev)
 {
 	struct resource *res;
 
@@ -386,8 +386,6 @@ static int __devexit pmcmsptwi_remove(struct platform_device *pldev)
 
 	res = platform_get_resource(pldev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, res->end - res->start + 1);
-
-	return 0;
 }
 
 /*
@@ -632,7 +630,7 @@ MODULE_ALIAS("platform:" DRV_NAME);
 
 static struct platform_driver pmcmsptwi_driver = {
 	.probe  = pmcmsptwi_probe,
-	.remove	= __devexit_p(pmcmsptwi_remove),
+	.remove_new = __devexit_p(pmcmsptwi_remove),
 	.driver = {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
diff --git a/drivers/i2c/busses/i2c-pnx.c b/drivers/i2c/busses/i2c-pnx.c
index ec15cff..999dfc6 100644
--- a/drivers/i2c/busses/i2c-pnx.c
+++ b/drivers/i2c/busses/i2c-pnx.c
@@ -657,7 +657,7 @@ out:
 	return ret;
 }
 
-static int __devexit i2c_pnx_remove(struct platform_device *pdev)
+static void __devexit i2c_pnx_remove(struct platform_device *pdev)
 {
 	struct i2c_pnx_data *i2c_pnx = platform_get_drvdata(pdev);
 	struct i2c_adapter *adap = i2c_pnx->adapter;
@@ -669,8 +669,6 @@ static int __devexit i2c_pnx_remove(struct platform_device *pdev)
 	iounmap((void *)alg_data->ioaddr);
 	release_region(alg_data->base, I2C_PNX_REGION_SIZE);
 	platform_set_drvdata(pdev, NULL);
-
-	return 0;
 }
 
 static struct platform_driver i2c_pnx_driver = {
@@ -679,7 +677,7 @@ static struct platform_driver i2c_pnx_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = i2c_pnx_probe,
-	.remove = __devexit_p(i2c_pnx_remove),
+	.remove_new = __devexit_p(i2c_pnx_remove),
 	.suspend = i2c_pnx_controller_suspend,
 	.resume = i2c_pnx_controller_resume,
 };
diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
index 60ca917..2153260 100644
--- a/drivers/i2c/busses/i2c-powermac.c
+++ b/drivers/i2c/busses/i2c-powermac.c
@@ -180,7 +180,7 @@ static const struct i2c_algorithm i2c_powermac_algorithm = {
 };
 
 
-static int __devexit i2c_powermac_remove(struct platform_device *dev)
+static void __devexit i2c_powermac_remove(struct platform_device *dev)
 {
 	struct i2c_adapter	*adapter = platform_get_drvdata(dev);
 	struct pmac_i2c_bus	*bus = i2c_get_adapdata(adapter);
@@ -195,8 +195,6 @@ static int __devexit i2c_powermac_remove(struct platform_device *dev)
 		       adapter->name);
 	platform_set_drvdata(dev, NULL);
 	kfree(adapter);
-
-	return 0;
 }
 
 
@@ -297,7 +295,7 @@ MODULE_ALIAS("platform:i2c-powermac");
 
 static struct platform_driver i2c_powermac_driver = {
 	.probe = i2c_powermac_probe,
-	.remove = __devexit_p(i2c_powermac_remove),
+	.remove_new = __devexit_p(i2c_powermac_remove),
 	.driver = {
 		.name = "i2c-powermac",
 		.bus = &platform_bus_type,
diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 906f9b9..801db2b 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1098,7 +1098,7 @@ emalloc:
 	return ret;
 }
 
-static int __exit i2c_pxa_remove(struct platform_device *dev)
+static void __exit i2c_pxa_remove(struct platform_device *dev)
 {
 	struct pxa_i2c *i2c = platform_get_drvdata(dev);
 
@@ -1114,8 +1114,6 @@ static int __exit i2c_pxa_remove(struct platform_device *dev)
 	iounmap(i2c->reg_base);
 	release_mem_region(i2c->iobase, i2c->iosize);
 	kfree(i2c);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -1142,7 +1140,7 @@ static int i2c_pxa_resume_early(struct platform_device *dev)
 
 static struct platform_driver i2c_pxa_driver = {
 	.probe		= i2c_pxa_probe,
-	.remove		= __exit_p(i2c_pxa_remove),
+	.remove_new	= __exit_p(i2c_pxa_remove),
 	.suspend_late	= i2c_pxa_suspend_late,
 	.resume_early	= i2c_pxa_resume_early,
 	.driver		= {
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 1fac4e2..7a4472f 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -965,7 +965,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
  * called when device is removed from the bus
 */
 
-static int s3c24xx_i2c_remove(struct platform_device *pdev)
+static void s3c24xx_i2c_remove(struct platform_device *pdev)
 {
 	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
 
@@ -981,8 +981,6 @@ static int s3c24xx_i2c_remove(struct platform_device *pdev)
 
 	release_resource(i2c->ioarea);
 	kfree(i2c->ioarea);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -1004,7 +1002,7 @@ static int s3c24xx_i2c_resume(struct platform_device *dev)
 
 static struct platform_driver s3c2410_i2c_driver = {
 	.probe		= s3c24xx_i2c_probe,
-	.remove		= s3c24xx_i2c_remove,
+	.remove_new	= s3c24xx_i2c_remove,
 	.resume		= s3c24xx_i2c_resume,
 	.driver		= {
 		.owner	= THIS_MODULE,
@@ -1014,7 +1012,7 @@ static struct platform_driver s3c2410_i2c_driver = {
 
 static struct platform_driver s3c2440_i2c_driver = {
 	.probe		= s3c24xx_i2c_probe,
-	.remove		= s3c24xx_i2c_remove,
+	.remove_new	= s3c24xx_i2c_remove,
 	.resume		= s3c24xx_i2c_resume,
 	.driver		= {
 		.owner	= THIS_MODULE,
diff --git a/drivers/i2c/busses/i2c-sh7760.c b/drivers/i2c/busses/i2c-sh7760.c
index 5e0e254..6efea66 100644
--- a/drivers/i2c/busses/i2c-sh7760.c
+++ b/drivers/i2c/busses/i2c-sh7760.c
@@ -535,7 +535,7 @@ out0:
 	return ret;
 }
 
-static int __devexit sh7760_i2c_remove(struct platform_device *pdev)
+static void __devexit sh7760_i2c_remove(struct platform_device *pdev)
 {
 	struct cami2c *id = platform_get_drvdata(pdev);
 
@@ -546,8 +546,6 @@ static int __devexit sh7760_i2c_remove(struct platform_device *pdev)
 	kfree(id->ioarea);
 	kfree(id);
 	platform_set_drvdata(pdev, NULL);
-
-	return 0;
 }
 
 static struct platform_driver sh7760_i2c_drv = {
@@ -556,7 +554,7 @@ static struct platform_driver sh7760_i2c_drv = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= sh7760_i2c_probe,
-	.remove		= __devexit_p(sh7760_i2c_remove),
+	.remove_new	= __devexit_p(sh7760_i2c_remove),
 };
 
 static int __init sh7760_i2c_init(void)
diff --git a/drivers/i2c/busses/i2c-sh_mobile.c b/drivers/i2c/busses/i2c-sh_mobile.c
index 3384a71..0dcbbe7 100644
--- a/drivers/i2c/busses/i2c-sh_mobile.c
+++ b/drivers/i2c/busses/i2c-sh_mobile.c
@@ -607,7 +607,7 @@ static int sh_mobile_i2c_probe(struct platform_device *dev)
 	return ret;
 }
 
-static int sh_mobile_i2c_remove(struct platform_device *dev)
+static void sh_mobile_i2c_remove(struct platform_device *dev)
 {
 	struct sh_mobile_i2c_data *pd = platform_get_drvdata(dev);
 
@@ -616,7 +616,6 @@ static int sh_mobile_i2c_remove(struct platform_device *dev)
 	sh_mobile_i2c_hook_irqs(dev, 0);
 	clk_put(pd->clk);
 	kfree(pd);
-	return 0;
 }
 
 static struct platform_driver sh_mobile_i2c_driver = {
@@ -625,7 +624,7 @@ static struct platform_driver sh_mobile_i2c_driver = {
 		.owner		= THIS_MODULE,
 	},
 	.probe		= sh_mobile_i2c_probe,
-	.remove		= sh_mobile_i2c_remove,
+	.remove_new	= sh_mobile_i2c_remove,
 };
 
 static int __init sh_mobile_i2c_adap_init(void)
diff --git a/drivers/i2c/busses/i2c-simtec.c b/drivers/i2c/busses/i2c-simtec.c
index 042fda2..499ca5c 100644
--- a/drivers/i2c/busses/i2c-simtec.c
+++ b/drivers/i2c/busses/i2c-simtec.c
@@ -142,7 +142,7 @@ static int simtec_i2c_probe(struct platform_device *dev)
 	return ret;
 }
 
-static int simtec_i2c_remove(struct platform_device *dev)
+static void simtec_i2c_remove(struct platform_device *dev)
 {
 	struct simtec_i2c_data *pd = platform_get_drvdata(dev);
 
@@ -152,8 +152,6 @@ static int simtec_i2c_remove(struct platform_device *dev)
 	release_resource(pd->ioarea);
 	kfree(pd->ioarea);
 	kfree(pd);
-
-	return 0;
 }
 
 
@@ -168,7 +166,7 @@ static struct platform_driver simtec_i2c_driver = {
 		.owner		= THIS_MODULE,
 	},
 	.probe		= simtec_i2c_probe,
-	.remove		= simtec_i2c_remove,
+	.remove_new	= simtec_i2c_remove,
 };
 
 static int __init i2c_adap_simtec_init(void)
diff --git a/drivers/i2c/busses/i2c-versatile.c b/drivers/i2c/busses/i2c-versatile.c
index 4678bab..8e0eb91 100644
--- a/drivers/i2c/busses/i2c-versatile.c
+++ b/drivers/i2c/busses/i2c-versatile.c
@@ -117,19 +117,18 @@ static int i2c_versatile_probe(struct platform_device *dev)
 	return ret;
 }
 
-static int i2c_versatile_remove(struct platform_device *dev)
+static void i2c_versatile_remove(struct platform_device *dev)
 {
 	struct i2c_versatile *i2c = platform_get_drvdata(dev);
 
 	platform_set_drvdata(dev, NULL);
 
 	i2c_del_adapter(&i2c->adap);
-	return 0;
 }
 
 static struct platform_driver i2c_versatile_driver = {
 	.probe		= i2c_versatile_probe,
-	.remove		= i2c_versatile_remove,
+	.remove_new	= i2c_versatile_remove,
 	.driver		= {
 		.name	= "versatile-i2c",
 		.owner	= THIS_MODULE,
diff --git a/drivers/i2c/chips/isp1301_omap.c b/drivers/i2c/chips/isp1301_omap.c
index e0d56ef..96a74ab 100644
--- a/drivers/i2c/chips/isp1301_omap.c
+++ b/drivers/i2c/chips/isp1301_omap.c
@@ -908,15 +908,14 @@ static int otg_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int otg_remove(struct platform_device *dev)
+static void otg_remove(struct platform_device *dev)
 {
 	otg_dev = NULL;
-	return 0;
 }
 
 static struct platform_driver omap_otg_driver = {
 	.probe		= otg_probe,
-	.remove		= otg_remove,
+	.remove_new	= otg_remove,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "omap_otg",
diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 9efb021..2284a49 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -257,13 +257,12 @@ fail0:
 	return rc;
 }
 
-static int __devexit at91_i2c_remove(struct platform_device *pdev)
+static void __devexit at91_i2c_remove(struct platform_device *pdev)
 {
 	struct i2c_adapter *adapter = platform_get_drvdata(pdev);
 	struct resource *res;
-	int rc;
 
-	rc = i2c_del_adapter(adapter);
+	i2c_del_adapter(adapter);
 	platform_set_drvdata(pdev, NULL);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -272,8 +271,6 @@ static int __devexit at91_i2c_remove(struct platform_device *pdev)
 
 	clk_disable(twi_clk);		/* disable peripheral clock */
 	clk_put(twi_clk);
-
-	return rc;
 }
 
 #ifdef CONFIG_PM
@@ -301,7 +298,7 @@ MODULE_ALIAS("platform:at91_i2c");
 
 static struct platform_driver at91_i2c_driver = {
 	.probe		= at91_i2c_probe,
-	.remove		= __devexit_p(at91_i2c_remove),
+	.remove_new	= __devexit_p(at91_i2c_remove),
 	.suspend	= at91_i2c_suspend,
 	.resume		= at91_i2c_resume,
 	.driver		= {
diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 9e8118d..73a5a1e 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -562,23 +562,20 @@ mv64xxx_i2c_probe(struct platform_device *pd)
 	return rc;
 }
 
-static int __devexit
+static void __devexit
 mv64xxx_i2c_remove(struct platform_device *dev)
 {
 	struct mv64xxx_i2c_data		*drv_data = platform_get_drvdata(dev);
-	int	rc;
 
-	rc = i2c_del_adapter(&drv_data->adapter);
+	i2c_del_adapter(&drv_data->adapter);
 	free_irq(drv_data->irq, drv_data);
 	mv64xxx_i2c_unmap_regs(drv_data);
 	kfree(drv_data);
-
-	return rc;
 }
 
 static struct platform_driver mv64xxx_i2c_driver = {
 	.probe	= mv64xxx_i2c_probe,
-	.remove	= mv64xxx_i2c_remove,
+	.remove_new = mv64xxx_i2c_remove,
 	.driver	= {
 		.owner	= THIS_MODULE,
 		.name	= MV64XXX_I2C_CTLR_NAME,
