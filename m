Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYLJQgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYLJQgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbYLJQge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:36:34 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:33989 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757023AbYLJQgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:36:33 -0500
Date: Wed, 10 Dec 2008 17:36:30 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, miguel.ojeda.sandonis@gmail.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 13/28] drivers/auxdisplay: Drop return value from platform_driver
 remove functions
Message-ID: <Pine.LNX.4.64.0812101736090.21998@ask.diku.dk>
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
 drivers/auxdisplay/cfag12864bfb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/auxdisplay/cfag12864bfb.c b/drivers/auxdisplay/cfag12864bfb.c
index fe3a865..56a3d22 100644
--- a/drivers/auxdisplay/cfag12864bfb.c
+++ b/drivers/auxdisplay/cfag12864bfb.c
@@ -115,7 +115,7 @@ none:
 	return ret;
 }
 
-static int cfag12864bfb_remove(struct platform_device *device)
+static void cfag12864bfb_remove(struct platform_device *device)
 {
 	struct fb_info *info = platform_get_drvdata(device);
 
@@ -123,13 +123,11 @@ static int cfag12864bfb_remove(struct platform_device *device)
 		unregister_framebuffer(info);
 		framebuffer_release(info);
 	}
-
-	return 0;
 }
 
 static struct platform_driver cfag12864bfb_driver = {
 	.probe	= cfag12864bfb_probe,
-	.remove = cfag12864bfb_remove,
+	.remove_new = cfag12864bfb_remove,
 	.driver = {
 		.name	= CFAG12864BFB_NAME,
 	},
