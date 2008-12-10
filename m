Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYLJQnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYLJQnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbYLJQmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:42:42 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:55537 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758133AbYLJQmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:42:40 -0500
Date: Wed, 10 Dec 2008 17:42:38 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, juergh@gmail.com, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 26/28] drivers/hwmon/vt1211.c: Drop return value from
 platform_driver remove functions
Message-ID: <Pine.LNX.4.64.0812101742170.21998@ask.diku.dk>
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
 drivers/hwmon/vt1211.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/vt1211.c b/drivers/hwmon/vt1211.c
index 12b4359..106b4bc 100644
--- a/drivers/hwmon/vt1211.c
+++ b/drivers/hwmon/vt1211.c
@@ -1216,7 +1216,7 @@ EXIT:
 	return err;
 }
 
-static int __devexit vt1211_remove(struct platform_device *pdev)
+static void __devexit vt1211_remove(struct platform_device *pdev)
 {
 	struct vt1211_data *data = platform_get_drvdata(pdev);
 	struct resource *res;
@@ -1228,8 +1228,6 @@ static int __devexit vt1211_remove(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	release_region(res->start, res->end - res->start + 1);
-
-	return 0;
 }
 
 static struct platform_driver vt1211_driver = {
@@ -1238,7 +1236,7 @@ static struct platform_driver vt1211_driver = {
 		.name  = DRVNAME,
 	},
 	.probe  = vt1211_probe,
-	.remove = __devexit_p(vt1211_remove),
+	.remove_new = __devexit_p(vt1211_remove),
 };
 
 static int __init vt1211_device_add(unsigned short address)
