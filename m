Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYLJQhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYLJQhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbYLJQg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:36:58 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:38201 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215AbYLJQg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:36:56 -0500
Date: Wed, 10 Dec 2008 17:36:52 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 14/28] drivers/ata: Drop return value from platform_driver
 remove functions
Message-ID: <Pine.LNX.4.64.0812101736310.21998@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The return value of the remove function of a driver structure, and thus of
a platform_driver structure, is ultimately ignored, and is thus
unnecessary.  This patch removes the return value for the remove function
stored in a platform_driver structure.  For the files in this patch, the
return values are always 0.

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
 drivers/ata/pata_at32.c      |   10 ++++------
 drivers/ata/pata_bf54x.c     |    6 ++----
 drivers/ata/pata_ixp4xx_cf.c |    6 ++----
 drivers/ata/pata_platform.c  |    6 +++---
 drivers/ata/pata_rb532_cf.c  |    6 ++----
 drivers/ata/sata_mv.c        |    7 +++----
 6 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/drivers/ata/pata_at32.c b/drivers/ata/pata_at32.c
index ab61095..b34f664 100644
--- a/drivers/ata/pata_at32.c
+++ b/drivers/ata/pata_at32.c
@@ -357,33 +357,31 @@ static int __init pata_at32_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int __exit pata_at32_remove(struct platform_device *pdev)
+static void __exit pata_at32_remove(struct platform_device *pdev)
 {
 	struct ata_host *host = platform_get_drvdata(pdev);
 	struct at32_ide_info *info;
 
 	if (!host)
-		return 0;
+		return;
 
 	info = host->private_data;
 	ata_host_detach(host);
 
 	if (!info)
-		return 0;
+		return;
 
 	release_resource(&info->res_ide);
 	release_resource(&info->res_alt);
 
 	kfree(info);
-
-	return 0;
 }
 
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:at32_ide");
 
 static struct platform_driver pata_at32_driver = {
-	.remove	       = __exit_p(pata_at32_remove),
+	.remove_new    = __exit_p(pata_at32_remove),
 	.driver	       = {
 		.name  = "at32_ide",
 		.owner = THIS_MODULE,
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 1266924..aa9e086 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1644,7 +1644,7 @@ static int __devinit bfin_atapi_probe(struct platform_device *pdev)
  *	A bfin atapi device has been unplugged. Perform the needed
  *	cleanup. Also called on module unload for any active devices.
  */
-static int __devexit bfin_atapi_remove(struct platform_device *pdev)
+static void __devexit bfin_atapi_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ata_host *host = dev_get_drvdata(dev);
@@ -1653,8 +1653,6 @@ static int __devexit bfin_atapi_remove(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, NULL);
 
 	peripheral_free_list(atapi_io_port);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -1690,7 +1688,7 @@ static int bfin_atapi_resume(struct platform_device *pdev)
 
 static struct platform_driver bfin_atapi_driver = {
 	.probe			= bfin_atapi_probe,
-	.remove			= __devexit_p(bfin_atapi_remove),
+	.remove_new		= __devexit_p(bfin_atapi_remove),
 	.suspend		= bfin_atapi_suspend,
 	.resume			= bfin_atapi_resume,
 	.driver = {
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 2014253..c449728 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -189,13 +189,11 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 	return ata_host_activate(host, irq, ata_sff_interrupt, 0, &ixp4xx_sht);
 }
 
-static __devexit int ixp4xx_pata_remove(struct platform_device *dev)
+static __devexit void ixp4xx_pata_remove(struct platform_device *dev)
 {
 	struct ata_host *host = platform_get_drvdata(dev);
 
 	ata_host_detach(host);
-
-	return 0;
 }
 
 static struct platform_driver ixp4xx_pata_platform_driver = {
@@ -204,7 +202,7 @@ static struct platform_driver ixp4xx_pata_platform_driver = {
 		.owner  = THIS_MODULE,
 	},
 	.probe		= ixp4xx_pata_probe,
-	.remove		= __devexit_p(ixp4xx_pata_remove),
+	.remove_new	= __devexit_p(ixp4xx_pata_remove),
 };
 
 static int __init ixp4xx_pata_init(void)
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 77e4e3b..f4bdde8 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -245,14 +245,14 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 				     pio_mask);
 }
 
-static int __devexit pata_platform_remove(struct platform_device *pdev)
+static void __devexit pata_platform_remove(struct platform_device *pdev)
 {
-	return __pata_platform_remove(&pdev->dev);
+	__pata_platform_remove(&pdev->dev);
 }
 
 static struct platform_driver pata_platform_driver = {
 	.probe		= pata_platform_probe,
-	.remove		= __devexit_p(pata_platform_remove),
+	.remove_new	= __devexit_p(pata_platform_remove),
 	.driver = {
 		.name		= DRV_NAME,
 		.owner		= THIS_MODULE,
diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index c2e6fb9..9a8fc19 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -235,15 +235,13 @@ err_free_gpio:
 	return ret;
 }
 
-static __devexit int rb532_pata_driver_remove(struct platform_device *pdev)
+static __devexit void rb532_pata_driver_remove(struct platform_device *pdev)
 {
 	struct ata_host *ah = platform_get_drvdata(pdev);
 	struct rb532_cf_info *info = ah->private_data;
 
 	ata_host_detach(ah);
 	gpio_free(info->gpio_line);
-
-	return 0;
 }
 
 /* work with hotplug and coldplug */
@@ -251,7 +249,7 @@ MODULE_ALIAS("platform:" DRV_NAME);
 
 static struct platform_driver rb532_pata_platform_driver = {
 	.probe		= rb532_pata_driver_probe,
-	.remove		= __devexit_p(rb532_pata_driver_remove),
+	.remove_new	= __devexit_p(rb532_pata_driver_remove),
 	.driver	 = {
 		.name   = DRV_NAME,
 		.owner  = THIS_MODULE,
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 2b24ae5..a139cd7 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -3262,18 +3262,17 @@ static int mv_platform_probe(struct platform_device *pdev)
  *      A platform bus SATA device has been unplugged. Perform the needed
  *      cleanup. Also called on module unload for any active devices.
  */
-static int __devexit mv_platform_remove(struct platform_device *pdev)
+static void __devexit mv_platform_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
-	return 0;
 }
 
 static struct platform_driver mv_platform_driver = {
 	.probe			= mv_platform_probe,
-	.remove			= __devexit_p(mv_platform_remove),
+	.remove_new		= __devexit_p(mv_platform_remove),
 	.driver			= {
 				   .name = DRV_NAME,
 				   .owner = THIS_MODULE,
@@ -3446,7 +3445,7 @@ static int mv_pci_init_one(struct pci_dev *pdev,
 #endif
 
 static int mv_platform_probe(struct platform_device *pdev);
-static int __devexit mv_platform_remove(struct platform_device *pdev);
+static void __devexit mv_platform_remove(struct platform_device *pdev);
 
 static int __init mv_init(void)
 {
