Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbYLSRKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbYLSRKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYLSRK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:10:28 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44182 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbYLSRK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:10:27 -0500
Date: Fri, 19 Dec 2008 18:10:23 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] drivers/gpu/drm: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0812191809490.11217@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/).  The result has been modified to
move the initialization of driver down closer to where it is used.

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/gpu/drm/drm_drv.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 0b9f316..4bdfc98 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -297,7 +297,7 @@ EXPORT_SYMBOL(drm_init);
  */
 static void drm_cleanup(struct drm_device * dev)
 {
-	struct drm_driver *driver = dev->driver;
+	struct drm_driver *driver;
 
 	DRM_DEBUG("\n");
 
@@ -324,8 +324,9 @@ static void drm_cleanup(struct drm_device * dev)
 		dev->agp = NULL;
 	}
 
-	if (dev->driver->unload)
-		dev->driver->unload(dev);
+	driver = dev->driver;
+	if (driver->unload)
+		driver->unload(dev);
 
 	drm_ht_remove(&dev->map_hash);
 	drm_ctxbitmap_cleanup(dev);
