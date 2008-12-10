Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbYLJQlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbYLJQlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbYLJQlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:41:11 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:55486 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051AbYLJQlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:41:09 -0500
Date: Wed, 10 Dec 2008 17:41:06 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, juergh@gmail.com, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 22/28] drivers/hwmon/dme1737.c: Drop return value from
 platform_driver remove functions
Message-ID: <Pine.LNX.4.64.0812101740430.21998@ask.diku.dk>
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
 drivers/hwmon/dme1737.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/dme1737.c b/drivers/hwmon/dme1737.c
index 27a5d39..3a9b988 100644
--- a/drivers/hwmon/dme1737.c
+++ b/drivers/hwmon/dme1737.c
@@ -2465,7 +2465,7 @@ exit:
 	return err;
 }
 
-static int __devexit dme1737_isa_remove(struct platform_device *pdev)
+static void __devexit dme1737_isa_remove(struct platform_device *pdev)
 {
 	struct dme1737_data *data = platform_get_drvdata(pdev);
 
@@ -2474,8 +2474,6 @@ static int __devexit dme1737_isa_remove(struct platform_device *pdev)
 	release_region(data->addr, DME1737_EXTENT);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
-
-	return 0;
 }
 
 static struct platform_driver dme1737_isa_driver = {
@@ -2484,7 +2482,7 @@ static struct platform_driver dme1737_isa_driver = {
 		.name = "dme1737",
 	},
 	.probe = dme1737_isa_probe,
-	.remove = __devexit_p(dme1737_isa_remove),
+	.remove_new = __devexit_p(dme1737_isa_remove),
 };
 
 /* ---------------------------------------------------------------------
