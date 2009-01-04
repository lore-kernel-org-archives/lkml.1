Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZADLrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZADLrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbZADLrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:47:12 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:38046 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZADLrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:47:08 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/7] fbdev: atafb - Fix line length handling
Date: Sun,  4 Jan 2009 12:46:58 +0100
Message-Id: <1231069624-13362-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231069624-13362-1-git-send-email-geert@linux-m68k.org>
References: <1231069624-13362-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Make sure par->next_line is always set (this was done for Falcon only),
    as all the text console drawing operations need a valid par->next_line,
  - Make sure fix->line_length is always set, as some userspace applications
    need it because they don't have fallback code for the case where it's zero.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/atafb.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index 77eb8b3..b7646ad 100644
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -614,7 +614,7 @@ static int tt_encode_fix(struct fb_fix_screeninfo *fix, struct atafb_par *par)
 	fix->xpanstep = 0;
 	fix->ypanstep = 1;
 	fix->ywrapstep = 0;
-	fix->line_length = 0;
+	fix->line_length = par->next_line;
 	fix->accel = FB_ACCEL_ATARIBLITT;
 	return 0;
 }
@@ -691,6 +691,7 @@ static int tt_decode_var(struct fb_var_screeninfo *var, struct atafb_par *par)
 		return -EINVAL;
 	par->yres_virtual = yres_virtual;
 	par->screen_base = screen_base + var->yoffset * linelen;
+	par->next_line = linelen;
 	return 0;
 }
 
@@ -918,7 +919,7 @@ static int falcon_encode_fix(struct fb_fix_screeninfo *fix,
 		fix->visual = FB_VISUAL_TRUECOLOR;
 		fix->xpanstep = 2;
 	}
-	fix->line_length = 0;
+	fix->line_length = par->next_line;
 	fix->accel = FB_ACCEL_ATARIBLITT;
 	return 0;
 }
@@ -1852,7 +1853,7 @@ static int stste_encode_fix(struct fb_fix_screeninfo *fix,
 		fix->ypanstep = 0;
 	}
 	fix->ywrapstep = 0;
-	fix->line_length = 0;
+	fix->line_length = par->next_line;
 	fix->accel = FB_ACCEL_ATARIBLITT;
 	return 0;
 }
@@ -1910,6 +1911,7 @@ static int stste_decode_var(struct fb_var_screeninfo *var,
 		return -EINVAL;
 	par->yres_virtual = yres_virtual;
 	par->screen_base = screen_base + var->yoffset * linelen;
+	par->next_line = linelen;
 	return 0;
 }
 
@@ -2169,7 +2171,7 @@ static int ext_encode_fix(struct fb_fix_screeninfo *fix, struct atafb_par *par)
 	fix->xpanstep = 0;
 	fix->ypanstep = 0;
 	fix->ywrapstep = 0;
-	fix->line_length = 0;
+	fix->line_length = par->next_line;
 	return 0;
 }
 
@@ -2184,6 +2186,8 @@ static int ext_decode_var(struct fb_var_screeninfo *var, struct atafb_par *par)
 	    var->xoffset > 0 ||
 	    var->yoffset > 0)
 		return -EINVAL;
+
+	par->next_line = external_xres_virtual * external_depth / 8;
 	return 0;
 }
 
-- 
1.5.6.5

