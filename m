Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYCKWLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYCKWLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 18:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYCKWKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 18:10:24 -0400
Received: from mail.queued.net ([207.210.101.209]:4553 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbYCKWKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 18:10:23 -0400
Date: Tue, 11 Mar 2008 18:14:12 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com
Subject: [PATCH 3/6] gxfb: move MSR bit fields into gxfb.h
Message-ID: <20080311181412.1553a67a@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This continues the gxfb header cleanups.  MSRs are defined in geode.h;
the specific bits we care about are defined in gxfb.h.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/display_gx.h |    3 ---
 drivers/video/geode/gxfb.h       |   16 ++++++++++++++++
 drivers/video/geode/gxfb_core.c  |    2 +-
 drivers/video/geode/video_gx.c   |    4 ++--
 drivers/video/geode/video_gx.h   |   14 --------------
 5 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/video/geode/display_gx.h b/drivers/video/geode/display_gx.h
index 56e9d2e..ad556d3 100644
--- a/drivers/video/geode/display_gx.h
+++ b/drivers/video/geode/display_gx.h
@@ -16,7 +16,4 @@ int gx_line_delta(int xres, int bpp);
 
 extern struct geode_dc_ops gx_dc_ops;
 
-/* MSR that tells us if a TFT or CRT is attached */
-#define GLD_MSR_CONFIG_DM_FP 0x40
-
 #endif /* !__DISPLAY_GX1_H__ */
diff --git a/drivers/video/geode/gxfb.h b/drivers/video/geode/gxfb.h
index d408ad3..c21f9dc 100644
--- a/drivers/video/geode/gxfb.h
+++ b/drivers/video/geode/gxfb.h
@@ -252,4 +252,20 @@ static inline void write_fp(struct geodefb_par *par, int reg, uint32_t val)
 	writel(val, par->vid_regs + 8*reg + VP_FP_START);
 }
 
+
+/* MSRs are defined in asm/geode.h; their bitfields are here */
+
+#define MSR_GLCP_SYS_RSTPLL_DOTPOSTDIV3	(1 << 3)
+#define MSR_GLCP_SYS_RSTPLL_DOTPREMULT2	(1 << 2)
+#define MSR_GLCP_SYS_RSTPLL_DOTPREDIV2	(1 << 1)
+
+#define MSR_GLCP_DOTPLL_LOCK		(1 << 25)	/* r/o */
+#define MSR_GLCP_DOTPLL_BYPASS		(1 << 15)
+#define MSR_GLCP_DOTPLL_DOTRESET	(1 << 0)
+
+#define MSR_GX_MSR_PADSEL_MASK		0x3FFFFFFF	/* undocumented? */
+#define MSR_GX_MSR_PADSEL_TFT		0x1FFFFFFF	/* undocumented? */
+
+#define MSR_GX_GLD_MSR_CONFIG_FP	(1 << 3)
+
 #endif
diff --git a/drivers/video/geode/gxfb_core.c b/drivers/video/geode/gxfb_core.c
index fd58dcc..0913251 100644
--- a/drivers/video/geode/gxfb_core.c
+++ b/drivers/video/geode/gxfb_core.c
@@ -328,7 +328,7 @@ static int __init gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *i
 
 	rdmsrl(MSR_GX_GLD_MSR_CONFIG, val);
 
-	if ((val & GLD_MSR_CONFIG_DM_FP) == GLD_MSR_CONFIG_DM_FP)
+	if ((val & MSR_GX_GLD_MSR_CONFIG_FP) == MSR_GX_GLD_MSR_CONFIG_FP)
 		par->enable_crt = 0;
 	else
 		par->enable_crt = 1;
diff --git a/drivers/video/geode/video_gx.c b/drivers/video/geode/video_gx.c
index 1b98b7b..1e26bc4 100644
--- a/drivers/video/geode/video_gx.c
+++ b/drivers/video/geode/video_gx.c
@@ -187,8 +187,8 @@ gx_configure_tft(struct fb_info *info)
 	/* Set up the DF pad select MSR */
 
 	rdmsrl(MSR_GX_MSR_PADSEL, val);
-	val &= ~GX_VP_PAD_SELECT_MASK;
-	val |= GX_VP_PAD_SELECT_TFT;
+	val &= ~MSR_GX_MSR_PADSEL_MASK;
+	val |= MSR_GX_MSR_PADSEL_TFT;
 	wrmsrl(MSR_GX_MSR_PADSEL, val);
 
 	/* Turn off the panel */
diff --git a/drivers/video/geode/video_gx.h b/drivers/video/geode/video_gx.h
index 5457bd0..79f6e81 100644
--- a/drivers/video/geode/video_gx.h
+++ b/drivers/video/geode/video_gx.h
@@ -13,18 +13,4 @@
 
 extern struct geode_vid_ops gx_vid_ops;
 
-/* GX Flatpanel control MSR */
-#define GX_VP_PAD_SELECT_MASK          0x3FFFFFFF
-#define GX_VP_PAD_SELECT_TFT           0x1FFFFFFF
-
-/* Geode GX clock control MSRs */
-
-#  define MSR_GLCP_SYS_RSTPLL_DOTPREDIV2	(0x0000000000000002ull)
-#  define MSR_GLCP_SYS_RSTPLL_DOTPREMULT2	(0x0000000000000004ull)
-#  define MSR_GLCP_SYS_RSTPLL_DOTPOSTDIV3	(0x0000000000000008ull)
-
-#  define MSR_GLCP_DOTPLL_DOTRESET		(0x0000000000000001ull)
-#  define MSR_GLCP_DOTPLL_BYPASS		(0x0000000000008000ull)
-#  define MSR_GLCP_DOTPLL_LOCK			(0x0000000002000000ull)
-
 #endif /* !__VIDEO_GX_H__ */
-- 
1.5.3.7

