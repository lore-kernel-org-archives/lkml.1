Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbYLJQmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbYLJQmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbYLJQmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:42:22 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:52561 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757560AbYLJQmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:42:20 -0500
Date: Wed, 10 Dec 2008 17:42:16 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, mhoffman@lightlink.com,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 25/28] drivers/hwmon/smsc47b397: Drop return value from
 platform_driver remove functions
Message-ID: <Pine.LNX.4.64.0812101741530.21998@ask.diku.dk>
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
 drivers/hwmon/smsc47b397.c |    6 ++----
 drivers/hwmon/smsc47m1.c   |    8 +++-----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/smsc47b397.c b/drivers/hwmon/smsc47b397.c
index eb03544..fd4d596 100644
--- a/drivers/hwmon/smsc47b397.c
+++ b/drivers/hwmon/smsc47b397.c
@@ -221,7 +221,7 @@ static const struct attribute_group smsc47b397_group = {
 	.attrs = smsc47b397_attributes,
 };
 
-static int __devexit smsc47b397_remove(struct platform_device *pdev)
+static void __devexit smsc47b397_remove(struct platform_device *pdev)
 {
 	struct smsc47b397_data *data = platform_get_drvdata(pdev);
 	struct resource *res;
@@ -231,8 +231,6 @@ static int __devexit smsc47b397_remove(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	release_region(res->start, SMSC_EXTENT);
 	kfree(data);
-
-	return 0;
 }
 
 static int smsc47b397_probe(struct platform_device *pdev);
@@ -243,7 +241,7 @@ static struct platform_driver smsc47b397_driver = {
 		.name	= DRVNAME,
 	},
 	.probe		= smsc47b397_probe,
-	.remove		= __devexit_p(smsc47b397_remove),
+	.remove_new	= __devexit_p(smsc47b397_remove),
 };
 
 static int __devinit smsc47b397_probe(struct platform_device *pdev)
diff --git a/drivers/hwmon/smsc47m1.c b/drivers/hwmon/smsc47m1.c
index d1b4985..fbd9556 100644
--- a/drivers/hwmon/smsc47m1.c
+++ b/drivers/hwmon/smsc47m1.c
@@ -138,7 +138,7 @@ struct smsc47m1_sio_data {
 
 
 static int smsc47m1_probe(struct platform_device *pdev);
-static int __devexit smsc47m1_remove(struct platform_device *pdev);
+static void __devexit smsc47m1_remove(struct platform_device *pdev);
 static struct smsc47m1_data *smsc47m1_update_device(struct device *dev,
 		int init);
 
@@ -159,7 +159,7 @@ static struct platform_driver smsc47m1_driver = {
 		.name	= DRVNAME,
 	},
 	.probe		= smsc47m1_probe,
-	.remove		= __devexit_p(smsc47m1_remove),
+	.remove_new	= __devexit_p(smsc47m1_remove),
 };
 
 static ssize_t get_fan(struct device *dev, struct device_attribute
@@ -629,7 +629,7 @@ error_release:
 	return err;
 }
 
-static int __devexit smsc47m1_remove(struct platform_device *pdev)
+static void __devexit smsc47m1_remove(struct platform_device *pdev)
 {
 	struct smsc47m1_data *data = platform_get_drvdata(pdev);
 	struct resource *res;
@@ -641,8 +641,6 @@ static int __devexit smsc47m1_remove(struct platform_device *pdev)
 	release_region(res->start, SMSC_EXTENT);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
-
-	return 0;
 }
 
 static struct smsc47m1_data *smsc47m1_update_device(struct device *dev,
