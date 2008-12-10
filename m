Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbYLJQ1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbYLJQ1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbYLJQ11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:27:27 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:54093 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080AbYLJQ1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:27:25 -0500
Date: Wed, 10 Dec 2008 17:27:20 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/28] drivers/ide: Drop return value from platform_driver
 remove functions
Message-ID: <Pine.LNX.4.64.0812101727000.21998@ask.diku.dk>
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
 drivers/ide/ide_platform.c |    6 ++----
 drivers/ide/tx4938ide.c    |    5 ++---
 drivers/ide/tx4939ide.c    |    5 ++---
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/ide/ide_platform.c b/drivers/ide/ide_platform.c
index 051b4ab..1b75c18 100644
--- a/drivers/ide/ide_platform.c
+++ b/drivers/ide/ide_platform.c
@@ -111,13 +111,11 @@ out:
 	return ret;
 }
 
-static int __devexit plat_ide_remove(struct platform_device *pdev)
+static void __devexit plat_ide_remove(struct platform_device *pdev)
 {
 	struct ide_host *host = pdev->dev.driver_data;
 
 	ide_host_remove(host);
-
-	return 0;
 }
 
 static struct platform_driver platform_ide_driver = {
@@ -126,7 +124,7 @@ static struct platform_driver platform_ide_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = plat_ide_probe,
-	.remove = __devexit_p(plat_ide_remove),
+	.remove_new = __devexit_p(plat_ide_remove),
 };
 
 static int __init platform_ide_init(void)
diff --git a/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
index 9120063..523d95e 100644
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -289,12 +289,11 @@ static int __init tx4938ide_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int __exit tx4938ide_remove(struct platform_device *pdev)
+static void __exit tx4938ide_remove(struct platform_device *pdev)
 {
 	struct ide_host *host = platform_get_drvdata(pdev);
 
 	ide_host_remove(host);
-	return 0;
 }
 
 static struct platform_driver tx4938ide_driver = {
@@ -302,7 +301,7 @@ static struct platform_driver tx4938ide_driver = {
 		.name	= "tx4938ide",
 		.owner	= THIS_MODULE,
 	},
-	.remove = __exit_p(tx4938ide_remove),
+	.remove_new = __exit_p(tx4938ide_remove),
 };
 
 static int __init tx4938ide_init(void)
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index bafb7d1..e23d07c 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -706,12 +706,11 @@ static int __init tx4939ide_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit tx4939ide_remove(struct platform_device *pdev)
+static void __exit tx4939ide_remove(struct platform_device *pdev)
 {
 	struct ide_host *host = platform_get_drvdata(pdev);
 
 	ide_host_remove(host);
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -732,7 +731,7 @@ static struct platform_driver tx4939ide_driver = {
 		.name = MODNAME,
 		.owner = THIS_MODULE,
 	},
-	.remove = __exit_p(tx4939ide_remove),
+	.remove_new = __exit_p(tx4939ide_remove),
 	.resume = tx4939ide_resume,
 };
 
