Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYLJQhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYLJQhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbYLJQhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:37:40 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:34016 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbYLJQhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:37:38 -0500
Date: Wed, 10 Dec 2008 17:37:35 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 15/28] arch/sh: Drop return value from platform_driver remove
 functions
Message-ID: <Pine.LNX.4.64.0812101737120.21998@ask.diku.dk>
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
 arch/sh/drivers/heartbeat.c   |    6 ++----
 arch/sh/drivers/push-switch.c |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/sh/drivers/heartbeat.c b/arch/sh/drivers/heartbeat.c
index 938817e..8d8c8a3 100644
--- a/arch/sh/drivers/heartbeat.c
+++ b/arch/sh/drivers/heartbeat.c
@@ -116,7 +116,7 @@ static int heartbeat_drv_probe(struct platform_device *pdev)
 	return mod_timer(&hd->timer, jiffies + 1);
 }
 
-static int heartbeat_drv_remove(struct platform_device *pdev)
+static void heartbeat_drv_remove(struct platform_device *pdev)
 {
 	struct heartbeat_data *hd = platform_get_drvdata(pdev);
 
@@ -127,13 +127,11 @@ static int heartbeat_drv_remove(struct platform_device *pdev)
 
 	if (!pdev->dev.platform_data)
 		kfree(hd);
-
-	return 0;
 }
 
 static struct platform_driver heartbeat_driver = {
 	.probe		= heartbeat_drv_probe,
-	.remove		= heartbeat_drv_remove,
+	.remove_new	= heartbeat_drv_remove,
 	.driver		= {
 		.name	= DRV_NAME,
 	},
diff --git a/arch/sh/drivers/push-switch.c b/arch/sh/drivers/push-switch.c
index 725be6d..747c787 100644
--- a/arch/sh/drivers/push-switch.c
+++ b/arch/sh/drivers/push-switch.c
@@ -96,7 +96,7 @@ err:
 	return ret;
 }
 
-static int switch_drv_remove(struct platform_device *pdev)
+static void switch_drv_remove(struct platform_device *pdev)
 {
 	struct push_switch *psw = platform_get_drvdata(pdev);
 	struct push_switch_platform_info *psw_info = pdev->dev.platform_data;
@@ -111,13 +111,11 @@ static int switch_drv_remove(struct platform_device *pdev)
 	free_irq(irq, pdev);
 
 	kfree(psw);
-
-	return 0;
 }
 
 static struct platform_driver switch_driver = {
 	.probe		= switch_drv_probe,
-	.remove		= switch_drv_remove,
+	.remove_new	= switch_drv_remove,
 	.driver		= {
 		.name	= DRV_NAME,
 	},
