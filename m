Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYLJQ3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYLJQ3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbYLJQ3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:29:19 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:50807 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608AbYLJQ3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:29:17 -0500
Date: Wed, 10 Dec 2008 17:29:14 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, sameo@openedhand.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/28] drivers/gpio/twl4030-gpio.c: Drop return value from
 platform_driver remove functions
Message-ID: <Pine.LNX.4.64.0812101728530.21998@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The return value of the remove function of a driver structure, and thus of
a platform_driver structure, is ultimately ignored, and is thus
unnecessary.  This patch removes the return value for the remove function
stored in a platform_driver structure.  The original return value was
either 0 or -EIO.

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
 drivers/gpio/twl4030-gpio.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/twl4030-gpio.c b/drivers/gpio/twl4030-gpio.c
index 37d3eec..31d8bb2 100644
--- a/drivers/gpio/twl4030-gpio.c
+++ b/drivers/gpio/twl4030-gpio.c
@@ -405,7 +405,7 @@ static int __devinit gpio_twl4030_pulls(u32 ups, u32 downs)
 				REG_GPIOPUPDCTR1, 5);
 }
 
-static int gpio_twl4030_remove(struct platform_device *pdev);
+static void gpio_twl4030_remove(struct platform_device *pdev);
 
 static int __devinit gpio_twl4030_probe(struct platform_device *pdev)
 {
@@ -468,7 +468,7 @@ no_irqs:
 	return ret;
 }
 
-static int __devexit gpio_twl4030_remove(struct platform_device *pdev)
+static void __devexit gpio_twl4030_remove(struct platform_device *pdev)
 {
 	struct twl4030_gpio_platform_data *pdata = pdev->dev.platform_data;
 	int status;
@@ -478,20 +478,19 @@ static int __devexit gpio_twl4030_remove(struct platform_device *pdev)
 				pdata->gpio_base, TWL4030_GPIO_MAX);
 		if (status) {
 			dev_dbg(&pdev->dev, "teardown --> %d\n", status);
-			return status;
+			return;
 		}
 	}
 
 	status = gpiochip_remove(&twl_gpiochip);
 	if (status < 0)
-		return status;
+		return;
 
 	if (is_module())
-		return 0;
+		return;
 
 	/* REVISIT no support yet for deregistering all the IRQs */
 	WARN_ON(1);
-	return -EIO;
 }
 
 /* Note:  this hardware lives inside an I2C-based multi-function device. */
@@ -501,7 +500,7 @@ static struct platform_driver gpio_twl4030_driver = {
 	.driver.name	= "twl4030_gpio",
 	.driver.owner	= THIS_MODULE,
 	.probe		= gpio_twl4030_probe,
-	.remove		= __devexit_p(gpio_twl4030_remove),
+	.remove_new	= __devexit_p(gpio_twl4030_remove),
 };
 
 static int __init gpio_twl4030_init(void)
