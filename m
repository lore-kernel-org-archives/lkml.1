Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbYLJQj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbYLJQj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbYLJQjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:39:47 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:55362 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612AbYLJQjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:39:45 -0500
Date: Wed, 10 Dec 2008 17:39:41 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, eric.miao@marvell.com, linux@arm.linux.org.uk,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 19/28] arch/arm/mach-pxa: Drop return value from platform_driver
 remove functions
Message-ID: <Pine.LNX.4.64.0812101739170.21998@ask.diku.dk>
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
 arch/arm/mach-pxa/corgi_ssp.c |    5 ++---
 arch/arm/mach-pxa/mioa701.c   |    5 ++---
 arch/arm/mach-pxa/pwm.c       |    9 ++++-----
 arch/arm/mach-pxa/ssp.c       |   11 +++++------
 arch/arm/mach-pxa/tosa-bt.c   |    6 ++----
 5 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-pxa/corgi_ssp.c b/arch/arm/mach-pxa/corgi_ssp.c
index 8e2f221..a0e823d 100644
--- a/arch/arm/mach-pxa/corgi_ssp.c
+++ b/arch/arm/mach-pxa/corgi_ssp.c
@@ -230,10 +230,9 @@ static int __init corgi_ssp_probe(struct platform_device *dev)
 	return ret;
 }
 
-static int corgi_ssp_remove(struct platform_device *dev)
+static void corgi_ssp_remove(struct platform_device *dev)
 {
 	ssp_exit(&corgi_ssp_dev);
-	return 0;
 }
 
 static int corgi_ssp_suspend(struct platform_device *dev, pm_message_t state)
@@ -260,7 +259,7 @@ static int corgi_ssp_resume(struct platform_device *dev)
 
 static struct platform_driver corgissp_driver = {
 	.probe		= corgi_ssp_probe,
-	.remove		= corgi_ssp_remove,
+	.remove_new	= corgi_ssp_remove,
 	.suspend	= corgi_ssp_suspend,
 	.resume		= corgi_ssp_resume,
 	.driver		= {
diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index 782903f..8f965d0 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -775,10 +775,9 @@ static int battery_probe(struct platform_device *pdev)
 	return rc;
 }
 
-static int battery_remove(struct platform_device *pdev)
+static void battery_remove(struct platform_device *pdev)
 {
 	battery_wm = NULL;
-	return 0;
 }
 
 static struct platform_driver mioa701_battery_driver = {
@@ -786,7 +785,7 @@ static struct platform_driver mioa701_battery_driver = {
 		.name = "wm97xx-battery",
 	},
 	.probe = battery_probe,
-	.remove = battery_remove
+	.remove_new = battery_remove
 };
 
 static int __init mioa701_battery_init(void)
diff --git a/arch/arm/mach-pxa/pwm.c b/arch/arm/mach-pxa/pwm.c
index 74e2ead..43b4be6 100644
--- a/arch/arm/mach-pxa/pwm.c
+++ b/arch/arm/mach-pxa/pwm.c
@@ -250,14 +250,14 @@ static int __devinit pxa27x_pwm_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __devexit pwm_remove(struct platform_device *pdev)
+static void __devexit pwm_remove(struct platform_device *pdev)
 {
 	struct pwm_device *pwm;
 	struct resource *r;
 
 	pwm = platform_get_drvdata(pdev);
 	if (pwm == NULL)
-		return -ENODEV;
+		return;
 
 	mutex_lock(&pwm_lock);
 	list_del(&pwm->node);
@@ -270,7 +270,6 @@ static int __devexit pwm_remove(struct platform_device *pdev)
 
 	clk_put(pwm->clk);
 	kfree(pwm);
-	return 0;
 }
 
 static struct platform_driver pxa25x_pwm_driver = {
@@ -278,7 +277,7 @@ static struct platform_driver pxa25x_pwm_driver = {
 		.name	= "pxa25x-pwm",
 	},
 	.probe		= pxa25x_pwm_probe,
-	.remove		= __devexit_p(pwm_remove),
+	.remove_new	= __devexit_p(pwm_remove),
 };
 
 static struct platform_driver pxa27x_pwm_driver = {
@@ -286,7 +285,7 @@ static struct platform_driver pxa27x_pwm_driver = {
 		.name	= "pxa27x-pwm",
 	},
 	.probe		= pxa27x_pwm_probe,
-	.remove		= __devexit_p(pwm_remove),
+	.remove_new	= __devexit_p(pwm_remove),
 };
 
 static int __init pwm_init(void)
diff --git a/arch/arm/mach-pxa/ssp.c b/arch/arm/mach-pxa/ssp.c
index 2c31ec7..a1e94f7 100644
--- a/arch/arm/mach-pxa/ssp.c
+++ b/arch/arm/mach-pxa/ssp.c
@@ -434,14 +434,14 @@ err_free:
 	return ret;
 }
 
-static int __devexit ssp_remove(struct platform_device *pdev)
+static void __devexit ssp_remove(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct ssp_device *ssp;
 
 	ssp = platform_get_drvdata(pdev);
 	if (ssp == NULL)
-		return -ENODEV;
+		return;
 
 	iounmap(ssp->mmio_base);
 
@@ -455,7 +455,6 @@ static int __devexit ssp_remove(struct platform_device *pdev)
 	mutex_unlock(&ssp_lock);
 
 	kfree(ssp);
-	return 0;
 }
 
 static int __devinit pxa25x_ssp_probe(struct platform_device *pdev)
@@ -478,7 +477,7 @@ static struct platform_driver pxa25x_ssp_driver = {
 		.name	= "pxa25x-ssp",
 	},
 	.probe		= pxa25x_ssp_probe,
-	.remove		= __devexit_p(ssp_remove),
+	.remove_new	= __devexit_p(ssp_remove),
 };
 
 static struct platform_driver pxa25x_nssp_driver = {
@@ -486,7 +485,7 @@ static struct platform_driver pxa25x_nssp_driver = {
 		.name	= "pxa25x-nssp",
 	},
 	.probe		= pxa25x_nssp_probe,
-	.remove		= __devexit_p(ssp_remove),
+	.remove_new	= __devexit_p(ssp_remove),
 };
 
 static struct platform_driver pxa27x_ssp_driver = {
@@ -494,7 +493,7 @@ static struct platform_driver pxa27x_ssp_driver = {
 		.name	= "pxa27x-ssp",
 	},
 	.probe		= pxa27x_ssp_probe,
-	.remove		= __devexit_p(ssp_remove),
+	.remove_new	= __devexit_p(ssp_remove),
 };
 
 static int __init pxa_ssp_init(void)
diff --git a/arch/arm/mach-pxa/tosa-bt.c b/arch/arm/mach-pxa/tosa-bt.c
index fb0294b..d0039bd 100644
--- a/arch/arm/mach-pxa/tosa-bt.c
+++ b/arch/arm/mach-pxa/tosa-bt.c
@@ -106,7 +106,7 @@ err_reset:
 	return rc;
 }
 
-static int __devexit tosa_bt_remove(struct platform_device *dev)
+static void __devexit tosa_bt_remove(struct platform_device *dev)
 {
 	struct tosa_bt_data *data = dev->dev.platform_data;
 	struct rfkill *rfk = platform_get_drvdata(dev);
@@ -121,13 +121,11 @@ static int __devexit tosa_bt_remove(struct platform_device *dev)
 
 	gpio_free(data->gpio_pwr);
 	gpio_free(data->gpio_reset);
-
-	return 0;
 }
 
 static struct platform_driver tosa_bt_driver = {
 	.probe = tosa_bt_probe,
-	.remove = __devexit_p(tosa_bt_remove),
+	.remove_new = __devexit_p(tosa_bt_remove),
 
 	.driver = {
 		.name = "tosa-bt",
