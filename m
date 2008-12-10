Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYLJQfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYLJQfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYLJQfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:35:31 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:32946 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648AbYLJQf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:35:29 -0500
Date: Wed, 10 Dec 2008 17:35:25 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 10/28] drivers/char: Drop return value from platform_driver
 remove functions
Message-ID: <Pine.LNX.4.64.0812101735040.21998@ask.diku.dk>
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
 drivers/char/sonypi.c     |    6 ++----
 drivers/char/tb0219.c     |    6 ++----
 drivers/char/vr41xx_giu.c |    6 ++----
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index f437443..2539332 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -1432,7 +1432,7 @@ static int __devinit sonypi_probe(struct platform_device *dev)
 	return error;
 }
 
-static int __devexit sonypi_remove(struct platform_device *dev)
+static void __devexit sonypi_remove(struct platform_device *dev)
 {
 	sonypi_disable();
 
@@ -1456,8 +1456,6 @@ static int __devexit sonypi_remove(struct platform_device *dev)
 	}
 
 	kfifo_free(sonypi_device.fifo);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -1492,7 +1490,7 @@ static struct platform_driver sonypi_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= sonypi_probe,
-	.remove		= __devexit_p(sonypi_remove),
+	.remove_new	= __devexit_p(sonypi_remove),
 	.shutdown	= sonypi_shutdown,
 	.suspend	= sonypi_suspend,
 	.resume		= sonypi_resume,
diff --git a/drivers/char/tb0219.c b/drivers/char/tb0219.c
index 6062b62..67e58a4 100644
--- a/drivers/char/tb0219.c
+++ b/drivers/char/tb0219.c
@@ -321,7 +321,7 @@ static int __devinit tb0219_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __devexit tb0219_remove(struct platform_device *dev)
+static void __devexit tb0219_remove(struct platform_device *dev)
 {
 	_machine_restart = old_machine_restart;
 
@@ -329,15 +329,13 @@ static int __devexit tb0219_remove(struct platform_device *dev)
 	tb0219_base = NULL;
 
 	release_mem_region(TB0219_START, TB0219_SIZE);
-
-	return 0;
 }
 
 static struct platform_device *tb0219_platform_device;
 
 static struct platform_driver tb0219_device_driver = {
 	.probe		= tb0219_probe,
-	.remove		= __devexit_p(tb0219_remove),
+	.remove_new	= __devexit_p(tb0219_remove),
 	.driver		= {
 		.name	= "TB0219",
 		.owner	= THIS_MODULE,
diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
index 54c8372..40cafb5 100644
--- a/drivers/char/vr41xx_giu.c
+++ b/drivers/char/vr41xx_giu.c
@@ -647,19 +647,17 @@ static int __devinit giu_probe(struct platform_device *dev)
 	return cascade_irq(irq, giu_get_irq);
 }
 
-static int __devexit giu_remove(struct platform_device *dev)
+static void __devexit giu_remove(struct platform_device *dev)
 {
 	if (giu_base) {
 		iounmap(giu_base);
 		giu_base = NULL;
 	}
-
-	return 0;
 }
 
 static struct platform_driver giu_device_driver = {
 	.probe		= giu_probe,
-	.remove		= __devexit_p(giu_remove),
+	.remove_new	= __devexit_p(giu_remove),
 	.driver		= {
 		.name	= "GIU",
 		.owner	= THIS_MODULE,
