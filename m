Return-Path: <linux-kernel-owner+w=401wt.eu-S964919AbXBLNyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964919AbXBLNyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 08:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964925AbXBLNyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 08:54:37 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:60330 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S964919AbXBLNyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 08:54:37 -0500
Date: Mon, 12 Feb 2007 14:54:35 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: James Simmons <jsimmons@infradead.org>
cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] RFC: Cell SPE logos
In-Reply-To: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.62.0702121452480.4624@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007, Geert Uytterhoeven wrote:
> I would like to hear your opinions about the patchset below (updated version
> compared to yesterday, lkml added to the CC list).
> 
> The Cell Broadband Engine contains a 64-bit PowerPC core with 2 hardware
> threads (called PPEs) and 8 Synergistic Processing Engines (called SPEs).
> When booting Linux, 2 penguins logos are shown on the graphical console by
> the standard frame buffer console logo code.
> 
> To emphasize the existence of the SPEs (which can be used under Linux), we
> added a second row of (smaller) helper penguin logos, one for each SPE.
> I attached a PNG version of the helper penguin logo for reference.
> 
> Summaries:
> [PATCH 1/7] fbdev: Avoid vertical overflow when making space for the logo
> [PATCH 2/7] fbdev: fb_do_show_logo() updates
> [PATCH 3/7] fbdev: extract fb_show_logo_line()
> [PATCH 4/7] fbdev: move logo externs to header file
> [PATCH 5/7] fbdev: Add fb_append_extra_logo()
> [PATCH 6/7] fbdev: SPE helper penguin logo
> [PATCH 7/7] Cell: Draw SPE helper penguin logos

The helper penguins overlap with the main penguins when using console rotation
(fbcon=rotate:x, with x != 0). Here's a fix:

---

Correct the image offsets when rotating the logo. Before image->dx and
image->dy were always zero, so nobody ever noticed.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/video/fbmem.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

--- ps3-linux-2.6.20.orig/drivers/video/fbmem.c
+++ ps3-linux-2.6.20/drivers/video/fbmem.c
@@ -355,22 +355,26 @@ static void fb_rotate_logo(struct fb_inf
 	if (rotate == FB_ROTATE_UD) {
 		fb_rotate_logo_ud(image->data, dst, image->width,
 				  image->height);
-		image->dx = info->var.xres - image->width;
-		image->dy = info->var.yres - image->height;
+		image->dx = info->var.xres - image->width - image->dx;
+		image->dy = info->var.yres - image->height - image->dy;
 	} else if (rotate == FB_ROTATE_CW) {
 		fb_rotate_logo_cw(image->data, dst, image->width,
 				  image->height);
 		tmp = image->width;
 		image->width = image->height;
 		image->height = tmp;
-		image->dx = info->var.xres - image->width;
+		tmp = image->dy;
+		image->dy = image->dx;
+		image->dx = info->var.xres - image->width - tmp;
 	} else if (rotate == FB_ROTATE_CCW) {
 		fb_rotate_logo_ccw(image->data, dst, image->width,
 				   image->height);
 		tmp = image->width;
 		image->width = image->height;
 		image->height = tmp;
-		image->dy = info->var.yres - image->height;
+		tmp = image->dx;
+		image->dx = image->dy;
+		image->dy = info->var.yres - image->height - tmp;
 	}
 
 	image->data = dst;

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
