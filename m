Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYLJQke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYLJQke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbYLJQkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:40:19 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:55414 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbYLJQkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:40:17 -0500
Date: Wed, 10 Dec 2008 17:40:14 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, rmk@arm.linux.org.uk,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 20/28] arch/arm: Drop return value from platform_driver remove
 functions
Message-ID: <Pine.LNX.4.64.0812101739410.21998@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The return value of the remove function of a driver structure, and thus of
a platform_driver structure, is ultimately ignored, and is thus
unnecessary.  This patch removes the return value for the remove function
stored in a platform_driver structure.  In arch/arm/common/scoop.c, in the
original code, there could have been a return of a value other than 0.  The
original return value is 0 in all other cases.

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
 arch/arm/common/locomo.c     |    6 ++----
 arch/arm/common/sa1111.c     |    6 ++----
 arch/arm/common/scoop.c      |   10 ++++------
 arch/arm/common/sharpsl_pm.c |    6 ++----
 4 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/arch/arm/common/locomo.c b/arch/arm/common/locomo.c
index 7c6b4b9..ae57b07 100644
--- a/arch/arm/common/locomo.c
+++ b/arch/arm/common/locomo.c
@@ -799,7 +799,7 @@ static int locomo_probe(struct platform_device *dev)
 	return __locomo_probe(&dev->dev, mem, irq);
 }
 
-static int locomo_remove(struct platform_device *dev)
+static void locomo_remove(struct platform_device *dev)
 {
 	struct locomo *lchip = platform_get_drvdata(dev);
 
@@ -807,8 +807,6 @@ static int locomo_remove(struct platform_device *dev)
 		__locomo_remove(lchip);
 		platform_set_drvdata(dev, NULL);
 	}
-
-	return 0;
 }
 
 /*
@@ -819,7 +817,7 @@ static int locomo_remove(struct platform_device *dev)
  */
 static struct platform_driver locomo_device_driver = {
 	.probe		= locomo_probe,
-	.remove		= locomo_remove,
+	.remove_new	= locomo_remove,
 #ifdef CONFIG_PM
 	.suspend	= locomo_suspend,
 	.resume		= locomo_resume,
diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index 47ccec9..9620972 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -954,7 +954,7 @@ static int __devinit sa1111_probe(struct platform_device *pdev)
 	return __sa1111_probe(&pdev->dev, mem, irq);
 }
 
-static int sa1111_remove(struct platform_device *pdev)
+static void sa1111_remove(struct platform_device *pdev)
 {
 	struct sa1111 *sachip = platform_get_drvdata(pdev);
 
@@ -967,8 +967,6 @@ static int sa1111_remove(struct platform_device *pdev)
 		sachip->saved_state = NULL;
 #endif
 	}
-
-	return 0;
 }
 
 /*
@@ -982,7 +980,7 @@ static int sa1111_remove(struct platform_device *pdev)
  */
 static struct platform_driver sa1111_device_driver = {
 	.probe		= sa1111_probe,
-	.remove		= sa1111_remove,
+	.remove_new	= sa1111_remove,
 	.suspend	= sa1111_suspend,
 	.resume		= sa1111_resume,
 	.driver		= {
diff --git a/arch/arm/common/scoop.c b/arch/arm/common/scoop.c
index 697c649..d84f0a9 100644
--- a/arch/arm/common/scoop.c
+++ b/arch/arm/common/scoop.c
@@ -273,32 +273,30 @@ err_ioremap:
 	return ret;
 }
 
-static int __devexit scoop_remove(struct platform_device *pdev)
+static void __devexit scoop_remove(struct platform_device *pdev)
 {
 	struct scoop_dev *sdev = platform_get_drvdata(pdev);
 	int ret;
 
 	if (!sdev)
-		return -EINVAL;
+		return;
 
 	if (sdev->gpio.base != -1) {
 		ret = gpiochip_remove(&sdev->gpio);
 		if (ret) {
 			dev_err(&pdev->dev, "Can't remove gpio chip: %d\n", ret);
-			return ret;
+			return;
 		}
 	}
 
 	platform_set_drvdata(pdev, NULL);
 	iounmap(sdev->base);
 	kfree(sdev);
-
-	return 0;
 }
 
 static struct platform_driver scoop_driver = {
 	.probe		= scoop_probe,
-	.remove		= __devexit_p(scoop_remove),
+	.remove_new	= __devexit_p(scoop_remove),
 	.suspend	= scoop_suspend,
 	.resume		= scoop_resume,
 	.driver		= {
diff --git a/arch/arm/common/sharpsl_pm.c b/arch/arm/common/sharpsl_pm.c
index 780bbf7..61393f3 100644
--- a/arch/arm/common/sharpsl_pm.c
+++ b/arch/arm/common/sharpsl_pm.c
@@ -818,7 +818,7 @@ static int __init sharpsl_pm_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int sharpsl_pm_remove(struct platform_device *pdev)
+static void sharpsl_pm_remove(struct platform_device *pdev)
 {
 	suspend_set_ops(NULL);
 
@@ -831,13 +831,11 @@ static int sharpsl_pm_remove(struct platform_device *pdev)
 
 	del_timer_sync(&sharpsl_pm.chrg_full_timer);
 	del_timer_sync(&sharpsl_pm.ac_timer);
-
-	return 0;
 }
 
 static struct platform_driver sharpsl_pm_driver = {
 	.probe		= sharpsl_pm_probe,
-	.remove		= sharpsl_pm_remove,
+	.remove_new	= sharpsl_pm_remove,
 	.suspend	= sharpsl_pm_suspend,
 	.resume		= sharpsl_pm_resume,
 	.driver		= {
