Return-Path: <linux-kernel-owner+w=401wt.eu-S1423549AbXBPKMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423549AbXBPKMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423551AbXBPKMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:12:52 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:57232 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423549AbXBPKMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:12:52 -0500
Date: Fri, 16 Feb 2007 10:12:51 +0000
From: Ben Dooks <ben@fluff.org.uk>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, vince@arm.linux.org.uk, ben-linux@fluff.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: SM501 framebuffer driver (#5)
Message-ID: <20070216101251.GG19392@home.fluff.org>
References: <20070216095045.GA15256@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216095045.GA15256@fluff.org.uk>
X-Disclaimer: I speak for me, myself, and the other one of me.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 09:50:45AM +0000, Ben Dooks wrote:
> Driver for the Silicon Motion SM501 multifunction device
> framebuffer subsystem.
> 
> This driver supports both the CRT and LCD panel heads,
> with some simple acceleration for the cursor plotting
> and support for screen panning. There is no current
> support for bitblt/drawing engines, which should be
> added at a later date.
> 
> This has been tested on a number of configurations,
> including PCI and generic-bus, on PPC, ARM and SH4

The difference between this and the previous version is
that the checks in pan display have been removed, as per
James' suggestion:

diff -urpN -X ../dontdiff linux-2.6.20-sm501-2/drivers/video/sm501fb.c linux-2.6.20-sm501-3/drivers/video/sm501fb.c
--- linux-2.6.20-sm501-2/drivers/video/sm501fb.c	2007-02-13 19:14:47.000000000 +0000
+++ linux-2.6.20-sm501-3/drivers/video/sm501fb.c	2007-02-16 09:33:07.000000000 +0000
@@ -496,23 +496,6 @@ static void sm501fb_set_par_geometry(str
 	writel(reg, base + SM501_OFF_DC_V_SYNC);
 }
 
-/* sm501fb_validate_pan
- *
- * check panning on a var
-*/
-
-static inline int sm501fb_validate_pan(struct fb_var_screeninfo *var)
-{
-	if (var->xoffset < 0 || var->yoffset < 0)
-		return 0;
-
-	if (var->xoffset > (var->xres_virtual - var->xres) ||
-	    var->yoffset > (var->yres_virtual - var->yres))
-		return 0;
-
-	return 1;
-}
-
 /* sm501fb_pan_crt
  *
  * pan the CRT display output within an virtual framebuffer
@@ -527,9 +510,6 @@ static int sm501fb_pan_crt(struct fb_var
 	unsigned long reg;
 	unsigned long xoffs;
 
-	if (!sm501fb_validate_pan(var))
-		return -EINVAL;
-
 	xoffs = var->xoffset * bytes_pixel;
 
 	reg = readl(fbi->regs + SM501_DC_CRT_CONTROL);
@@ -558,9 +538,6 @@ static int sm501fb_pan_pnl(struct fb_var
 	struct sm501fb_info *fbi = par->info;
 	unsigned long reg;
 
-	if (!sm501fb_validate_pan(var))
-		return -EINVAL;
-
 	reg = var->xoffset | (var->xres_virtual << 16);
 	writel(reg, fbi->regs + SM501_DC_PANEL_FB_WIDTH);
 


-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
