Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYLJQfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYLJQfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYLJQfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:35:08 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:32908 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639AbYLJQfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:35:06 -0500
Date: Wed, 10 Dec 2008 17:35:02 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, maciej.sosnowski@intel.com,
       dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 9/28] drivers/dma: Drop return value from platform_driver
 remove functions
Message-ID: <Pine.LNX.4.64.0812101734430.21998@ask.diku.dk>
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
 drivers/dma/dw_dmac.c  |    6 ++----
 drivers/dma/iop-adma.c |    6 ++----
 drivers/dma/mv_xor.c   |   11 ++++-------
 3 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 0778d99..7b5521a 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1036,7 +1036,7 @@ err_kfree:
 	return err;
 }
 
-static int __exit dw_remove(struct platform_device *pdev)
+static void __exit dw_remove(struct platform_device *pdev)
 {
 	struct dw_dma		*dw = platform_get_drvdata(pdev);
 	struct dw_dma_chan	*dwc, *_dwc;
@@ -1064,8 +1064,6 @@ static int __exit dw_remove(struct platform_device *pdev)
 	release_mem_region(io->start, DW_REGLEN);
 
 	kfree(dw);
-
-	return 0;
 }
 
 static void dw_shutdown(struct platform_device *pdev)
@@ -1096,7 +1094,7 @@ static int dw_resume_early(struct platform_device *pdev)
 }
 
 static struct platform_driver dw_driver = {
-	.remove		= __exit_p(dw_remove),
+	.remove_new	= __exit_p(dw_remove),
 	.shutdown	= dw_shutdown,
 	.suspend_late	= dw_suspend_late,
 	.resume_early	= dw_resume_early,
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index c7a9306..9b89122 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1100,7 +1100,7 @@ out:
 	return err;
 }
 
-static int __devexit iop_adma_remove(struct platform_device *dev)
+static void __devexit iop_adma_remove(struct platform_device *dev)
 {
 	struct iop_adma_device *device = platform_get_drvdata(dev);
 	struct dma_chan *chan, *_chan;
@@ -1132,8 +1132,6 @@ static int __devexit iop_adma_remove(struct platform_device *dev)
 		kfree(iop_chan);
 	}
 	kfree(device);
-
-	return 0;
 }
 
 static int __devinit iop_adma_probe(struct platform_device *pdev)
@@ -1409,7 +1407,7 @@ MODULE_ALIAS("platform:iop-adma");
 
 static struct platform_driver iop_adma_driver = {
 	.probe		= iop_adma_probe,
-	.remove		= iop_adma_remove,
+	.remove_new	= iop_adma_remove,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "iop-adma",
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 0328da0..5103dba 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1098,7 +1098,7 @@ out:
 	return err;
 }
 
-static int __devexit mv_xor_remove(struct platform_device *dev)
+static void __devexit mv_xor_remove(struct platform_device *dev)
 {
 	struct mv_xor_device *device = platform_get_drvdata(dev);
 	struct dma_chan *chan, *_chan;
@@ -1115,8 +1115,6 @@ static int __devexit mv_xor_remove(struct platform_device *dev)
 		mv_chan = to_mv_xor_chan(chan);
 		list_del(&chan->device_node);
 	}
-
-	return 0;
 }
 
 static int __devinit mv_xor_probe(struct platform_device *pdev)
@@ -1281,7 +1279,7 @@ mv_xor_conf_mbus_windows(struct mv_xor_shared_private *msp,
 
 static struct platform_driver mv_xor_driver = {
 	.probe		= mv_xor_probe,
-	.remove		= mv_xor_remove,
+	.remove_new	= mv_xor_remove,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= MV_XOR_NAME,
@@ -1329,14 +1327,13 @@ static int mv_xor_shared_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int mv_xor_shared_remove(struct platform_device *pdev)
+static void mv_xor_shared_remove(struct platform_device *pdev)
 {
-	return 0;
 }
 
 static struct platform_driver mv_xor_shared_driver = {
 	.probe		= mv_xor_shared_probe,
-	.remove		= mv_xor_shared_remove,
+	.remove_new	= mv_xor_shared_remove,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= MV_XOR_SHARED_NAME,
