Return-Path: <linux-kernel-owner+w=401wt.eu-S1760209AbYDNHvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbYDNHvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbYDNHvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:51:03 -0400
Received: from mail.queued.net ([207.210.101.209]:4887 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661AbYDNHvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:51:01 -0400
Date: Mon, 14 Apr 2008 03:53:02 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, info-linux@geode.amd.com,
       jordan.crouse@amd.com, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 3/3] OLPC: gxfb/lxfb: add DCON panel modes to framebuffer
 drivers
Message-ID: <20080414035302.794dcd7a@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since there's no way to autodetect panel modes, we're forced to hardcode
them in the driver and add a big fat #ifdef.  The OLPC DCON needs a
specific mode line (at 1200x900).  This adds it to both gxfb and lxfb.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/gxfb_core.c |   35 ++++++++++++++++++++++++++++++++++-
 drivers/video/geode/lxfb_core.c |   35 +++++++++++++++++++++++++++++++----
 2 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/drivers/video/geode/gxfb_core.c b/drivers/video/geode/gxfb_core.c
index 988c8e4..3e76e06 100644
--- a/drivers/video/geode/gxfb_core.c
+++ b/drivers/video/geode/gxfb_core.c
@@ -108,6 +108,35 @@ static const struct fb_videomode gx_modedb[] __initdata = {
 	  FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
 };
 
+#ifdef CONFIG_OLPC
+#include <asm/olpc.h>
+
+static const struct fb_videomode gx_dcon_modedb[] __initdata = {
+	/* The only mode the DCON has is 1200x900 */
+	{ NULL, 50, 1200, 900, 17460, 24, 8, 4, 5, 8, 3,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 }
+};
+
+static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
+{
+	if (olpc_has_dcon()) {
+		*modedb = (struct fb_videomode *) gx_dcon_modedb;
+		*size = ARRAY_SIZE(gx_dcon_modedb);
+	} else {
+		*modedb = (struct fb_videomode *) gx_modedb;
+		*size = ARRAY_SIZE(gx_modedb);
+	}
+}
+
+#else
+static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
+{
+	*modedb = (struct fb_videomode *) gx_modedb;
+	*size = ARRAY_SIZE(gx_modedb);
+}
+#endif
+
 static int gxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	if (var->xres > 1600 || var->yres > 1200)
@@ -356,6 +385,9 @@ static int __init gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	int ret;
 	unsigned long val;
 
+	struct fb_videomode *modedb_ptr;
+	unsigned int modedb_size;
+
 	info = gxfb_init_fbinfo(&pdev->dev);
 	if (!info)
 		return -ENOMEM;
@@ -375,8 +407,9 @@ static int __init gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	else
 		par->enable_crt = 1;
 
+	get_modedb(&modedb_ptr, &modedb_size);
 	ret = fb_find_mode(&info->var, info, mode_option,
-			   gx_modedb, ARRAY_SIZE(gx_modedb), NULL, 16);
+			   modedb_ptr, modedb_size, NULL, 16);
 	if (ret == 0 || ret == 4) {
 		dev_err(&pdev->dev, "could not find valid video mode\n");
 		ret = -EINVAL;
diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index e290981..28fa3c4 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -217,6 +217,35 @@ static const struct fb_videomode geode_modedb[] __initdata = {
 	  0, FB_VMODE_NONINTERLACED, 0 },
 };
 
+#ifdef CONFIG_OLPC
+#include <asm/olpc.h>
+
+const struct fb_videomode olpc_dcon_modedb[] __initdata = {
+	/* The only mode the DCON has is 1200x900 */
+	{ NULL, 50, 1200, 900, 17460, 24, 8, 4, 5, 8, 3,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 }
+};
+
+static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
+{
+	if (olpc_has_dcon()) {
+		*modedb = (struct fb_videomode *) olpc_dcon_modedb;
+		*size = ARRAY_SIZE(olpc_dcon_modedb);
+	} else {
+		*modedb = (struct fb_videomode *) geode_modedb;
+		*size = ARRAY_SIZE(geode_modedb);
+	}
+}
+
+#else
+static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
+{
+	*modedb = (struct fb_videomode *) geode_modedb;
+	*size = ARRAY_SIZE(geode_modedb);
+}
+#endif
+
 static int lxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	if (var->xres > 1920 || var->yres > 1440)
@@ -480,7 +509,7 @@ static int __init lxfb_probe(struct pci_dev *pdev,
 	int ret;
 
 	struct fb_videomode *modedb_ptr;
-	int modedb_size;
+	unsigned int modedb_size;
 
 	info = lxfb_init_fbinfo(&pdev->dev);
 
@@ -505,9 +534,7 @@ static int __init lxfb_probe(struct pci_dev *pdev,
 
 	/* Set up the mode database */
 
-	modedb_ptr = (struct fb_videomode *) geode_modedb;
-	modedb_size = ARRAY_SIZE(geode_modedb);
-
+	get_modedb(&modedb_ptr, &modedb_size);
 	ret = fb_find_mode(&info->var, info, mode_option,
 			   modedb_ptr, modedb_size, NULL, 16);
 
-- 
1.5.4.4



-- 
Need a kernel or Debian developer?  Contact me, I'm looking for contracts.
