Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbYLJQjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbYLJQjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbYLJQjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:39:20 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:34082 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbYLJQjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:39:19 -0500
Date: Wed, 10 Dec 2008 17:39:16 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 18/28] arch/arm: Drop return value from platform_driver remove
 functions
Message-ID: <Pine.LNX.4.64.0812101738220.21998@ask.diku.dk>
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
 arch/arm/mach-omap1/mailbox.c         |    6 ++----
 arch/arm/mach-omap2/mailbox.c         |    5 ++---
 arch/arm/mach-sa1100/jornada720_ssp.c |    5 ++---
 arch/arm/plat-omap/mcbsp.c            |    6 ++----
 4 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/arm/plat-omap/mcbsp.c b/arch/arm/plat-omap/mcbsp.c
index af33fc7..07455c5 100644
--- a/arch/arm/plat-omap/mcbsp.c
+++ b/arch/arm/plat-omap/mcbsp.c
@@ -935,7 +935,7 @@ exit:
 	return ret;
 }
 
-static int __devexit omap_mcbsp_remove(struct platform_device *pdev)
+static void __devexit omap_mcbsp_remove(struct platform_device *pdev)
 {
 	struct omap_mcbsp *mcbsp = platform_get_drvdata(pdev);
 
@@ -955,13 +955,11 @@ static int __devexit omap_mcbsp_remove(struct platform_device *pdev)
 		mcbsp->free = 0;
 		mcbsp->dev = NULL;
 	}
-
-	return 0;
 }
 
 static struct platform_driver omap_mcbsp_driver = {
 	.probe		= omap_mcbsp_probe,
-	.remove		= __devexit_p(omap_mcbsp_remove),
+	.remove_new	= __devexit_p(omap_mcbsp_remove),
 	.driver		= {
 		.name	= "omap-mcbsp",
 	},
diff --git a/arch/arm/mach-sa1100/jornada720_ssp.c b/arch/arm/mach-sa1100/jornada720_ssp.c
index 28cf369..8bad8fd 100644
--- a/arch/arm/mach-sa1100/jornada720_ssp.c
+++ b/arch/arm/mach-sa1100/jornada720_ssp.c
@@ -178,18 +178,17 @@ static int __init jornada_ssp_probe(struct platform_device *dev)
 	return 0;
 };
 
-static int jornada_ssp_remove(struct platform_device *dev)
+static void jornada_ssp_remove(struct platform_device *dev)
 {
 	/* Note that this doesnt actually remove the driver, since theres nothing to remove
 	 * It just makes sure everything is turned off */
 	GPSR = GPIO_GPIO25;
 	ssp_exit();
-	return 0;
 };
 
 struct platform_driver jornadassp_driver = {
 	.probe	= jornada_ssp_probe,
-	.remove	= jornada_ssp_remove,
+	.remove_new = jornada_ssp_remove,
 	.driver	= {
 		.name	= "jornada_ssp",
 	},
diff --git a/arch/arm/mach-omap1/mailbox.c b/arch/arm/mach-omap1/mailbox.c
index 59abbf3..cfbf6ba 100644
--- a/arch/arm/mach-omap1/mailbox.c
+++ b/arch/arm/mach-omap1/mailbox.c
@@ -175,16 +175,14 @@ static int __init omap1_mbox_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int omap1_mbox_remove(struct platform_device *pdev)
+static void omap1_mbox_remove(struct platform_device *pdev)
 {
 	omap_mbox_unregister(&mbox_dsp_info);
-
-	return 0;
 }
 
 static struct platform_driver omap1_mbox_driver = {
 	.probe	= omap1_mbox_probe,
-	.remove	= omap1_mbox_remove,
+	.remove_new = omap1_mbox_remove,
 	.driver	= {
 		.name	= "mailbox",
 	},
diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index 32b7af3..4217222 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -293,15 +293,14 @@ static int __init omap2_mbox_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int omap2_mbox_remove(struct platform_device *pdev)
+static void omap2_mbox_remove(struct platform_device *pdev)
 {
 	omap_mbox_unregister(&mbox_dsp_info);
-	return 0;
 }
 
 static struct platform_driver omap2_mbox_driver = {
 	.probe = omap2_mbox_probe,
-	.remove = omap2_mbox_remove,
+	.remove_new = omap2_mbox_remove,
 	.driver = {
 		.name = "mailbox",
 	},
