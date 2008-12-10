Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYLJQmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYLJQmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbYLJQl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:41:57 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:52542 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041AbYLJQl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:41:56 -0500
Date: Wed, 10 Dec 2008 17:41:52 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, jim.cromie@gmail.com, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 24/28] drivers/hwmon/pc87xxx: Drop return value from
 platform_driver remove functions
Message-ID: <Pine.LNX.4.64.0812101741310.21998@ask.diku.dk>
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
 drivers/hwmon/pc87360.c |    8 +++-----
 drivers/hwmon/pc87427.c |    6 ++----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/pc87360.c b/drivers/hwmon/pc87360.c
index 5fbfa34..87c4ce3 100644
--- a/drivers/hwmon/pc87360.c
+++ b/drivers/hwmon/pc87360.c
@@ -225,7 +225,7 @@ struct pc87360_data {
  */
 
 static int pc87360_probe(struct platform_device *pdev);
-static int __devexit pc87360_remove(struct platform_device *pdev);
+static void __devexit pc87360_remove(struct platform_device *pdev);
 
 static int pc87360_read_value(struct pc87360_data *data, u8 ldi, u8 bank,
 			      u8 reg);
@@ -245,7 +245,7 @@ static struct platform_driver pc87360_driver = {
 		.name	= "pc87360",
 	},
 	.probe		= pc87360_probe,
-	.remove		= __devexit_p(pc87360_remove),
+	.remove_new	= __devexit_p(pc87360_remove),
 };
 
 /*
@@ -1266,7 +1266,7 @@ ERROR1:
 	return err;
 }
 
-static int __devexit pc87360_remove(struct platform_device *pdev)
+static void __devexit pc87360_remove(struct platform_device *pdev)
 {
 	struct pc87360_data *data = platform_get_drvdata(pdev);
 	int i;
@@ -1285,8 +1285,6 @@ static int __devexit pc87360_remove(struct platform_device *pdev)
 		}
 	}
 	kfree(data);
-
-	return 0;
 }
 
 /* ldi is the logical device index
diff --git a/drivers/hwmon/pc87427.c b/drivers/hwmon/pc87427.c
index 7265f22..674176f 100644
--- a/drivers/hwmon/pc87427.c
+++ b/drivers/hwmon/pc87427.c
@@ -482,7 +482,7 @@ exit:
 	return err;
 }
 
-static int __devexit pc87427_remove(struct platform_device *pdev)
+static void __devexit pc87427_remove(struct platform_device *pdev)
 {
 	struct pc87427_data *data = platform_get_drvdata(pdev);
 	struct resource *res;
@@ -500,8 +500,6 @@ static int __devexit pc87427_remove(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	release_region(res->start, res->end - res->start + 1);
-
-	return 0;
 }
 
 
@@ -511,7 +509,7 @@ static struct platform_driver pc87427_driver = {
 		.name	= DRVNAME,
 	},
 	.probe		= pc87427_probe,
-	.remove		= __devexit_p(pc87427_remove),
+	.remove_new	= __devexit_p(pc87427_remove),
 };
 
 static int __init pc87427_device_add(unsigned short address)
