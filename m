Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbYC1AGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbYC1AGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYC1AGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:06:12 -0400
Received: from mail.queued.net ([207.210.101.209]:1975 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbYC1AGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:06:11 -0400
Date: Thu, 27 Mar 2008 20:06:52 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com
Subject: [PATCH 3/7] lxfb: clean up final bits of df_regs
Message-ID: <20080327200652.6e53e97d@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Finally drop the last remnants of df_regs, using vp_regs instead.  Also,
drop panel_width and panel_height from lxfb_par; they're unused.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/lxfb.h      |   12 +++++-------
 drivers/video/geode/lxfb_core.c |   12 ++++++------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/video/geode/lxfb.h b/drivers/video/geode/lxfb.h
index 6eac13d..0e3cb91 100644
--- a/drivers/video/geode/lxfb.h
+++ b/drivers/video/geode/lxfb.h
@@ -8,12 +8,10 @@
 
 struct lxfb_par {
 	int output;
-	int panel_width;
-	int panel_height;
 
 	void __iomem *gp_regs;
 	void __iomem *dc_regs;
-	void __iomem *df_regs;
+	void __iomem *vp_regs;
 };
 
 static inline unsigned int lx_get_pitch(unsigned int xres, int bpp)
@@ -374,22 +372,22 @@ static inline void write_dc(struct lxfb_par *par, int reg, uint32_t val)
 
 static inline uint32_t read_vp(struct lxfb_par *par, int reg)
 {
-	return readl(par->df_regs + 8*reg);
+	return readl(par->vp_regs + 8*reg);
 }
 
 static inline void write_vp(struct lxfb_par *par, int reg, uint32_t val)
 {
-	writel(val, par->df_regs + 8*reg);
+	writel(val, par->vp_regs + 8*reg);
 }
 
 static inline uint32_t read_fp(struct lxfb_par *par, int reg)
 {
-	return readl(par->df_regs + 8*reg + VP_FP_START);
+	return readl(par->vp_regs + 8*reg + VP_FP_START);
 }
 
 static inline void write_fp(struct lxfb_par *par, int reg, uint32_t val)
 {
-	writel(val, par->df_regs + 8*reg + VP_FP_START);
+	writel(val, par->vp_regs + 8*reg + VP_FP_START);
 }
 
 #endif
diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index acf1bf6..19eabef 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -333,7 +333,7 @@ static int __init lxfb_map_video_memory(struct fb_info *info,
 	if (ret)
 		return ret;
 
-	ret = pci_request_region(dev, 3, "lxfb-vip");
+	ret = pci_request_region(dev, 3, "lxfb-vp");
 
 	if (ret)
 		return ret;
@@ -360,10 +360,10 @@ static int __init lxfb_map_video_memory(struct fb_info *info,
 	if (par->dc_regs == NULL)
 		return ret;
 
-	par->df_regs = ioremap(pci_resource_start(dev, 3),
+	par->vp_regs = ioremap(pci_resource_start(dev, 3),
 			       pci_resource_len(dev, 3));
 
-	if (par->df_regs == NULL)
+	if (par->vp_regs == NULL)
 		return ret;
 
 	write_dc(par, DC_UNLOCK, DC_UNLOCK_UNLOCK);
@@ -507,8 +507,8 @@ err:
 		iounmap(par->dc_regs);
 		pci_release_region(pdev, 2);
 	}
-	if (par->df_regs) {
-		iounmap(par->df_regs);
+	if (par->vp_regs) {
+		iounmap(par->vp_regs);
 		pci_release_region(pdev, 3);
 	}
 
@@ -534,7 +534,7 @@ static void lxfb_remove(struct pci_dev *pdev)
 	iounmap(par->dc_regs);
 	pci_release_region(pdev, 2);
 
-	iounmap(par->df_regs);
+	iounmap(par->vp_regs);
 	pci_release_region(pdev, 3);
 
 	pci_set_drvdata(pdev, NULL);
-- 
1.5.3.7

