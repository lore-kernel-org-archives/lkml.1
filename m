Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYLUPCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYLUPCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbYLUPCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:02:06 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:45340 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYLUPCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:02:00 -0500
Message-Id: <20081221150121.904146951@mail.of.borg>
References: <20081221150059.844577615@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 21 Dec 2008 16:01:00 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/6] fbdev: atafb - Fix line length handling
Content-Disposition: inline; filename=atafb-linelen.diff
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
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -614,7 +614,7 @@ static int tt_encode_fix(struct fb_fix_s
 	fix->xpanstep = 0;
 	fix->ypanstep = 1;
 	fix->ywrapstep = 0;
-	fix->line_length = 0;
+	fix->line_length = par->next_line;
 	fix->accel = FB_ACCEL_ATARIBLITT;
 	return 0;
 }
@@ -691,6 +691,7 @@ static int tt_decode_var(struct fb_var_s
 		return -EINVAL;
 	par->yres_virtual = yres_virtual;
 	par->screen_base = screen_base + var->yoffset * linelen;
+	par->next_line = linelen;
 	return 0;
 }
 
@@ -918,7 +919,7 @@ static int falcon_encode_fix(struct fb_f
 		fix->visual = FB_VISUAL_TRUECOLOR;
 		fix->xpanstep = 2;
 	}
-	fix->line_length = 0;
+	fix->line_length = par->next_line;
 	fix->accel = FB_ACCEL_ATARIBLITT;
 	return 0;
 }
@@ -1852,7 +1853,7 @@ static int stste_encode_fix(struct fb_fi
 		fix->ypanstep = 0;
 	}
 	fix->ywrapstep = 0;
-	fix->line_length = 0;
+	fix->line_length = par->next_line;
 	fix->accel = FB_ACCEL_ATARIBLITT;
 	return 0;
 }
@@ -1910,6 +1911,7 @@ static int stste_decode_var(struct fb_va
 		return -EINVAL;
 	par->yres_virtual = yres_virtual;
 	par->screen_base = screen_base + var->yoffset * linelen;
+	par->next_line = linelen;
 	return 0;
 }
 
@@ -2169,7 +2171,7 @@ static int ext_encode_fix(struct fb_fix_
 	fix->xpanstep = 0;
 	fix->ypanstep = 0;
 	fix->ywrapstep = 0;
-	fix->line_length = 0;
+	fix->line_length = par->next_line;
 	return 0;
 }
 
@@ -2184,6 +2186,8 @@ static int ext_decode_var(struct fb_var_
 	    var->xoffset > 0 ||
 	    var->yoffset > 0)
 		return -EINVAL;
+
+	par->next_line = external_xres_virtual * external_depth / 8;
 	return 0;
 }
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

