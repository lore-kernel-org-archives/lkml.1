Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbYLJQiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbYLJQiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbYLJQi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:38:27 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:38280 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757373AbYLJQiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:38:24 -0500
Date: Wed, 10 Dec 2008 17:38:21 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, ben-linux@fluff.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 17/28] arch/arm: Drop return value from platform_driver remove
 functions
Message-ID: <Pine.LNX.4.64.0812101738000.21998@ask.diku.dk>
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
 arch/arm/mach-s3c2410/h1940-bluetooth.c |    5 ++---
 arch/arm/plat-s3c24xx/pwm.c             |    6 ++----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm/plat-s3c24xx/pwm.c b/arch/arm/plat-s3c24xx/pwm.c
index ec56b88..3fcda3f 100644
--- a/arch/arm/plat-s3c24xx/pwm.c
+++ b/arch/arm/plat-s3c24xx/pwm.c
@@ -361,15 +361,13 @@ static int s3c_pwm_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int s3c_pwm_remove(struct platform_device *pdev)
+static void s3c_pwm_remove(struct platform_device *pdev)
 {
 	struct pwm_device *pwm = platform_get_drvdata(pdev);
 
 	clk_put(pwm->clk_div);
 	clk_put(pwm->clk);
 	kfree(pwm);
-
-	return 0;
 }
 
 static struct platform_driver s3c_pwm_driver = {
@@ -378,7 +376,7 @@ static struct platform_driver s3c_pwm_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= s3c_pwm_probe,
-	.remove		= __devexit_p(s3c_pwm_remove),
+	.remove_new	= __devexit_p(s3c_pwm_remove),
 };
 
 static int __init pwm_init(void)
diff --git a/arch/arm/mach-s3c2410/h1940-bluetooth.c b/arch/arm/mach-s3c2410/h1940-bluetooth.c
index 5a6bc56..35560ce 100644
--- a/arch/arm/mach-s3c2410/h1940-bluetooth.c
+++ b/arch/arm/mach-s3c2410/h1940-bluetooth.c
@@ -106,12 +106,11 @@ static int __init h1940bt_probe(struct platform_device *pdev)
 	return device_create_file(&pdev->dev, &dev_attr_enable);
 }
 
-static int h1940bt_remove(struct platform_device *pdev)
+static void h1940bt_remove(struct platform_device *pdev)
 {
 #ifdef CONFIG_LEDS_H1940
 	led_trigger_unregister_simple(bt_led_trigger);
 #endif
-	return 0;
 }
 
 
@@ -120,7 +119,7 @@ static struct platform_driver h1940bt_driver = {
 		.name	= DRV_NAME,
 	},
 	.probe		= h1940bt_probe,
-	.remove		= h1940bt_remove,
+	.remove_new	= h1940bt_remove,
 };
 
 
