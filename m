Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbYLJQnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbYLJQnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbYLJQnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:43:24 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:55577 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254AbYLJQnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:43:22 -0500
Date: Wed, 10 Dec 2008 17:43:19 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, dsaxena@plexity.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 28/28] drivers/char/hw_random/omap-rng.c: Drop return value
 from platform_driver remove functions
Message-ID: <Pine.LNX.4.64.0812101742590.21998@ask.diku.dk>
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
 drivers/char/hw_random/omap-rng.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index d4e7dca..104d005 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -155,7 +155,7 @@ err_region:
 	return ret;
 }
 
-static int __exit omap_rng_remove(struct platform_device *pdev)
+static void __exit omap_rng_remove(struct platform_device *pdev)
 {
 	struct resource *mem = dev_get_drvdata(&pdev->dev);
 
@@ -172,8 +172,6 @@ static int __exit omap_rng_remove(struct platform_device *pdev)
 
 	release_resource(mem);
 	rng_base = NULL;
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -206,7 +204,7 @@ static struct platform_driver omap_rng_driver = {
 		.owner		= THIS_MODULE,
 	},
 	.probe		= omap_rng_probe,
-	.remove		= __exit_p(omap_rng_remove),
+	.remove_new	= __exit_p(omap_rng_remove),
 	.suspend	= omap_rng_suspend,
 	.resume		= omap_rng_resume
 };
