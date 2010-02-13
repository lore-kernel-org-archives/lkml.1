Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab0BMWyO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:54:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:42414 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758154Ab0BMWyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:54:10 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+Pjq5T+mGPRtPOfEm60a8K7elXWTQYNYaKs0pJ1o
	1cCi4/u1jHvSln
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/4] viafb: some virtual_xres handling fixes
Date: Sat, 13 Feb 2010 23:00:47 +0000
Message-Id: <1266102049-6209-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1266102049-6209-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1266102049-6209-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: some virtual_xres handling fixes

Do not require the virtual_xres to be aligned as line length is for
such purposes. Calculate always the smallest line length required.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index bd8db75..0fe748d 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -107,8 +107,7 @@ static void viafb_update_fix(struct fb_info *info)
 
 	info->fix.visual =
 		bpp == 8 ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
-	info->fix.line_length =
-		((info->var.xres_virtual + 7) & ~7) * bpp / 8;
+	info->fix.line_length = (info->var.xres_virtual * bpp / 8 + 7) & ~7;
 }
 
 static void viafb_setup_fixinfo(struct fb_fix_screeninfo *fix,
@@ -148,7 +147,7 @@ static int viafb_check_var(struct fb_var_screeninfo *var,
 	int htotal, vtotal, depth;
 	struct VideoModeTable *vmode_entry;
 	struct viafb_par *ppar = info->par;
-	u32 long_refresh;
+	u32 long_refresh, line;
 
 	DEBUG_MSG(KERN_INFO "viafb_check_var!\n");
 	/* Sanity check */
@@ -180,11 +179,8 @@ static int viafb_check_var(struct fb_var_screeninfo *var,
 		depth = 24;
 
 	viafb_fill_var_color_info(var, depth);
-	if ((var->xres_virtual * (var->bits_per_pixel >> 3)) & 0x1F)
-		/*32 pixel alignment */
-		var->xres_virtual = (var->xres_virtual + 31) & ~31;
-	if (var->xres_virtual * var->yres_virtual * var->bits_per_pixel / 8 >
-		ppar->memsize)
+	line = (var->xres_virtual * var->bits_per_pixel / 8 + 7) & ~7;
+	if (line * var->yres_virtual > ppar->memsize)
 		return -EINVAL;
 
 	/* Based on var passed in to calculate the refresh,
-- 
1.6.3.2

