Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbXK2NwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbXK2NwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 08:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759663AbXK2Nvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 08:51:52 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:51728 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756686AbXK2Nvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 08:51:51 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] atmel_lcdfb: Validate display timings
Date: Thu, 29 Nov 2007 14:51:33 +0100
Message-Id: <1196344293-31101-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Setting a display timing parameter too high or too low may cause it to
wrap around and thus become completely wrong. Validate the timings in
atmel_lcdfb_check_var() and saturate to the highest or lowest possible
value if necessary.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/video/atmel_lcdfb.c |   20 ++++++++++++++++++++
 include/video/atmel_lcdc.h  |   14 +++++++-------
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 235b618..58d49e4 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -203,6 +203,26 @@ static int atmel_lcdfb_check_var(struct fb_var_screeninfo *var,
 	var->transp.offset = var->transp.length = 0;
 	var->xoffset = var->yoffset = 0;
 
+	/* Saturate vertical and horizontal timings at maximum values */
+	var->vsync_len = min_t(u32, var->vsync_len,
+			(ATMEL_LCDC_VPW >> ATMEL_LCDC_VPW_OFFSET) + 1);
+	var->upper_margin = min_t(u32, var->upper_margin,
+			ATMEL_LCDC_VBP >> ATMEL_LCDC_VBP_OFFSET);
+	var->lower_margin = min_t(u32, var->lower_margin,
+			ATMEL_LCDC_VFP);
+	var->right_margin = min_t(u32, var->right_margin,
+			(ATMEL_LCDC_HFP >> ATMEL_LCDC_HFP_OFFSET) + 1);
+	var->hsync_len = min_t(u32, var->hsync_len,
+			(ATMEL_LCDC_HPW >> ATMEL_LCDC_HPW_OFFSET) + 1);
+	var->left_margin = min_t(u32, var->left_margin,
+			ATMEL_LCDC_HBP + 1);
+
+	/* Some parameters can't be zero */
+	var->vsync_len = max_t(u32, var->vsync_len, 1);
+	var->right_margin = max_t(u32, var->right_margin, 1);
+	var->hsync_len = max_t(u32, var->hsync_len, 1);
+	var->left_margin = max_t(u32, var->left_margin, 1);
+
 	switch (var->bits_per_pixel) {
 	case 1:
 	case 2:
diff --git a/include/video/atmel_lcdc.h b/include/video/atmel_lcdc.h
index 4eea637..76095e7 100644
--- a/include/video/atmel_lcdc.h
+++ b/include/video/atmel_lcdc.h
@@ -115,20 +115,20 @@ struct atmel_lcdfb_info {
 #define		ATMEL_LCDC_MEMOR_LITTLE		(1 << 31)
 
 #define ATMEL_LCDC_TIM1		0x0808
-#define	ATMEL_LCDC_VFP		(0xff <<  0)
+#define	ATMEL_LCDC_VFP		(0xffU <<  0)
 #define	ATMEL_LCDC_VBP_OFFSET		8
-#define	ATMEL_LCDC_VBP		(0xff <<  ATMEL_LCDC_VBP_OFFSET)
+#define	ATMEL_LCDC_VBP		(0xffU <<  ATMEL_LCDC_VBP_OFFSET)
 #define	ATMEL_LCDC_VPW_OFFSET		16
-#define	ATMEL_LCDC_VPW		(0x3f << ATMEL_LCDC_VPW_OFFSET)
+#define	ATMEL_LCDC_VPW		(0x3fU << ATMEL_LCDC_VPW_OFFSET)
 #define	ATMEL_LCDC_VHDLY_OFFSET		24
-#define	ATMEL_LCDC_VHDLY	(0xf  << ATMEL_LCDC_VHDLY_OFFSET)
+#define	ATMEL_LCDC_VHDLY	(0xfU  << ATMEL_LCDC_VHDLY_OFFSET)
 
 #define ATMEL_LCDC_TIM2		0x080c
-#define	ATMEL_LCDC_HBP		(0xff  <<  0)
+#define	ATMEL_LCDC_HBP		(0xffU  <<  0)
 #define	ATMEL_LCDC_HPW_OFFSET		8
-#define	ATMEL_LCDC_HPW		(0x3f  <<  ATMEL_LCDC_HPW_OFFSET)
+#define	ATMEL_LCDC_HPW		(0x3fU  <<  ATMEL_LCDC_HPW_OFFSET)
 #define	ATMEL_LCDC_HFP_OFFSET		21
-#define	ATMEL_LCDC_HFP		(0x7ff << ATMEL_LCDC_HFP_OFFSET)
+#define	ATMEL_LCDC_HFP		(0x7ffU << ATMEL_LCDC_HFP_OFFSET)
 
 #define ATMEL_LCDC_LCDFRMCFG	0x0810
 #define	ATMEL_LCDC_LINEVAL	(0x7ff <<  0)
-- 
1.5.3.4

