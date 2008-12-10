Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYLJQmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYLJQmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757937AbYLJQlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:41:35 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:55500 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686AbYLJQld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:41:33 -0500
Date: Wed, 10 Dec 2008 17:41:30 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, khali@linux-fr.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 23/28] drivers/hwmon/f71805f.c: Drop return value from
 platform_driver remove functions
Message-ID: <Pine.LNX.4.64.0812101741070.21998@ask.diku.dk>
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
 drivers/hwmon/f71805f.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/f71805f.c b/drivers/hwmon/f71805f.c
index 7a14a2d..76842db 100644
--- a/drivers/hwmon/f71805f.c
+++ b/drivers/hwmon/f71805f.c
@@ -1408,7 +1408,7 @@ exit:
 	return err;
 }
 
-static int __devexit f71805f_remove(struct platform_device *pdev)
+static void __devexit f71805f_remove(struct platform_device *pdev)
 {
 	struct f71805f_data *data = platform_get_drvdata(pdev);
 	struct resource *res;
@@ -1424,8 +1424,6 @@ static int __devexit f71805f_remove(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	release_region(res->start + ADDR_REG_OFFSET, 2);
-
-	return 0;
 }
 
 static struct platform_driver f71805f_driver = {
@@ -1434,7 +1432,7 @@ static struct platform_driver f71805f_driver = {
 		.name	= DRVNAME,
 	},
 	.probe		= f71805f_probe,
-	.remove		= __devexit_p(f71805f_remove),
+	.remove_new	= __devexit_p(f71805f_remove),
 };
 
 static int __init f71805f_device_add(unsigned short address,
