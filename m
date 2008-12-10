Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYLJQe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYLJQe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYLJQeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:34:46 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:32897 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbYLJQep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:34:45 -0500
Date: Wed, 10 Dec 2008 17:34:42 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 8/28] drivers/edac: Drop return value from platform_driver
 remove functions
Message-ID: <Pine.LNX.4.64.0812101734150.21998@ask.diku.dk>
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
 drivers/edac/cell_edac.c    |    5 ++---
 drivers/edac/mv64x60_edac.c |   22 ++++++++--------------
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index cd2e3b8..68afb41 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -213,12 +213,11 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __devexit cell_edac_remove(struct platform_device *pdev)
+static void __devexit cell_edac_remove(struct platform_device *pdev)
 {
 	struct mem_ctl_info *mci = edac_mc_del_mc(&pdev->dev);
 	if (mci)
 		edac_mc_free(mci);
-	return 0;
 }
 
 static struct platform_driver cell_edac_driver = {
@@ -227,7 +226,7 @@ static struct platform_driver cell_edac_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= cell_edac_probe,
-	.remove		= cell_edac_remove,
+	.remove_new	= cell_edac_remove,
 };
 
 static int __init cell_edac_init(void)
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 083ce8d..1432712 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -206,7 +206,7 @@ err:
 	return res;
 }
 
-static int mv64x60_pci_err_remove(struct platform_device *pdev)
+static void mv64x60_pci_err_remove(struct platform_device *pdev)
 {
 	struct edac_pci_ctl_info *pci = platform_get_drvdata(pdev);
 
@@ -215,13 +215,11 @@ static int mv64x60_pci_err_remove(struct platform_device *pdev)
 	edac_pci_del_device(&pdev->dev);
 
 	edac_pci_free_ctl_info(pci);
-
-	return 0;
 }
 
 static struct platform_driver mv64x60_pci_err_driver = {
 	.probe = mv64x60_pci_err_probe,
-	.remove = __devexit_p(mv64x60_pci_err_remove),
+	.remove_new = __devexit_p(mv64x60_pci_err_remove),
 	.driver = {
 		   .name = "mv64x60_pci_err",
 	}
@@ -375,7 +373,7 @@ err:
 	return res;
 }
 
-static int mv64x60_sram_err_remove(struct platform_device *pdev)
+static void mv64x60_sram_err_remove(struct platform_device *pdev)
 {
 	struct edac_device_ctl_info *edac_dev = platform_get_drvdata(pdev);
 
@@ -383,13 +381,11 @@ static int mv64x60_sram_err_remove(struct platform_device *pdev)
 
 	edac_device_del_device(&pdev->dev);
 	edac_device_free_ctl_info(edac_dev);
-
-	return 0;
 }
 
 static struct platform_driver mv64x60_sram_err_driver = {
 	.probe = mv64x60_sram_err_probe,
-	.remove = mv64x60_sram_err_remove,
+	.remove_new = mv64x60_sram_err_remove,
 	.driver = {
 		   .name = "mv64x60_sram_err",
 	}
@@ -570,7 +566,7 @@ err:
 	return res;
 }
 
-static int mv64x60_cpu_err_remove(struct platform_device *pdev)
+static void mv64x60_cpu_err_remove(struct platform_device *pdev)
 {
 	struct edac_device_ctl_info *edac_dev = platform_get_drvdata(pdev);
 
@@ -578,12 +574,11 @@ static int mv64x60_cpu_err_remove(struct platform_device *pdev)
 
 	edac_device_del_device(&pdev->dev);
 	edac_device_free_ctl_info(edac_dev);
-	return 0;
 }
 
 static struct platform_driver mv64x60_cpu_err_driver = {
 	.probe = mv64x60_cpu_err_probe,
-	.remove = mv64x60_cpu_err_remove,
+	.remove_new = mv64x60_cpu_err_remove,
 	.driver = {
 		   .name = "mv64x60_cpu_err",
 	}
@@ -812,7 +807,7 @@ err:
 	return res;
 }
 
-static int mv64x60_mc_err_remove(struct platform_device *pdev)
+static void mv64x60_mc_err_remove(struct platform_device *pdev)
 {
 	struct mem_ctl_info *mci = platform_get_drvdata(pdev);
 
@@ -820,12 +815,11 @@ static int mv64x60_mc_err_remove(struct platform_device *pdev)
 
 	edac_mc_del_mc(&pdev->dev);
 	edac_mc_free(mci);
-	return 0;
 }
 
 static struct platform_driver mv64x60_mc_err_driver = {
 	.probe = mv64x60_mc_err_probe,
-	.remove = mv64x60_mc_err_remove,
+	.remove_new = mv64x60_mc_err_remove,
 	.driver = {
 		   .name = "mv64x60_mc_err",
 	}
