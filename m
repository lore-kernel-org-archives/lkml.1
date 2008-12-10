Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbYLJQk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbYLJQk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbYLJQkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:40:45 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:55460 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874AbYLJQko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:40:44 -0500
Date: Wed, 10 Dec 2008 17:40:41 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 21/28] drivers/char/xilinx_hwicap: Drop return value from
 platform_driver remove functions
Message-ID: <Pine.LNX.4.64.0812101740170.21998@ask.diku.dk>
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
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index d161319..007b4df 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -743,14 +743,14 @@ static int __devinit hwicap_drv_probe(struct platform_device *pdev)
 			&buffer_icap_config, regs);
 }
 
-static int __devexit hwicap_drv_remove(struct platform_device *pdev)
+static void __devexit hwicap_drv_remove(struct platform_device *pdev)
 {
-	return hwicap_remove(&pdev->dev);
+	hwicap_remove(&pdev->dev);
 }
 
 static struct platform_driver hwicap_platform_driver = {
 	.probe = hwicap_drv_probe,
-	.remove = hwicap_drv_remove,
+	.remove_new = hwicap_drv_remove,
 	.driver = {
 		.owner = THIS_MODULE,
 		.name = DRIVER_NAME,
