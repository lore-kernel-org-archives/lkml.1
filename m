Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYKJFrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYKJFrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 00:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYKJFq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 00:46:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:40329 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYKJFq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 00:46:56 -0500
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       James Cloos <cloos@jhcloos.com>,
       Paul Collins <paul@burly.ondioline.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <wnN9HICUAgP.A._d.f5zFJB@chimera>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <wnN9HICUAgP.A._d.f5zFJB@chimera>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 16:46:25 +1100
Message-Id: <1226295985.7731.7.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-09 at 18:59 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).

Allright, so I finally managed to find a machine to reproduce it and
I have a patch that fixes it here. I'm basically implementing the same
thing as X which is to ensure the bitmap is padded to 32 pixels. The
core fbcon has support for that to a certain extent so it's a fairly
small change.

Note that there was another bug, I think I was missing one
wait_for_fifo() though fixing that didn't make a difference here.

However, it's possible that this significantly impacts the performances,
maybe to the point where we may want to back out the imageblt
acceleration.

David, would you mind testing on your machine ? It's the one that shows
the biggest performance improvement, and I would like to know how much
it is affected by that patch. As long as the "worst case" performance
is still reasonable, I'm ok to take the hit if the improvement for you
is still significant.

Cheers,
Ben.

radeonfb: Fix accel problems with new imageblit hook

Some radeon chips have issues with color expansion of pixmaps that
aren't a multiple of 32 pixels wide. This works around it the same
way X does by requesting the right pitch alignment from fbcon and
then using the chip scissors to do clipping to the requested size.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

If confirmed by the reporters (in CC), please apply for .28 as it
fixes a regression.

Index: linux-work/drivers/video/aty/radeon_accel.c
===================================================================
--- linux-work.orig/drivers/video/aty/radeon_accel.c	2008-11-10 14:05:06.000000000 +1100
+++ linux-work/drivers/video/aty/radeon_accel.c	2008-11-10 14:34:45.000000000 +1100
@@ -179,7 +179,7 @@ static void radeonfb_prim_imageblit(stru
 
 	radeonfb_set_creg(rinfo, DP_GUI_MASTER_CNTL, &rinfo->dp_gui_mc_cache,
 			  rinfo->dp_gui_mc_base |
-			  GMC_BRUSH_NONE |
+			  GMC_BRUSH_NONE | GMC_DST_CLIP_LEAVE |
 			  GMC_SRC_DATATYPE_MONO_FG_BG |
 			  ROP3_S |
 			  GMC_BYTE_ORDER_MSB_TO_LSB |
@@ -189,9 +189,6 @@ static void radeonfb_prim_imageblit(stru
 	radeonfb_set_creg(rinfo, DP_SRC_FRGD_CLR, &rinfo->dp_src_fg_cache, fg);
 	radeonfb_set_creg(rinfo, DP_SRC_BKGD_CLR, &rinfo->dp_src_bg_cache, bg);
 
-	radeon_fifo_wait(rinfo, 1);
-	OUTREG(DST_Y_X, (image->dy << 16) | image->dx);
-
 	/* Ensure the dst cache is flushed and the engine idle before
 	 * issuing the operation.
 	 *
@@ -205,13 +202,19 @@ static void radeonfb_prim_imageblit(stru
 
 	/* X here pads width to a multiple of 32 and uses the clipper to
 	 * adjust the result. Is that really necessary ? Things seem to
-	 * work ok for me without that and the doco doesn't seem to imply
+	 * work ok for me without that and the doco doesn't seem to imply]
 	 * there is such a restriction.
 	 */
-	OUTREG(DST_WIDTH_HEIGHT, (image->width << 16) | image->height);
+	radeon_fifo_wait(rinfo, 4);
+	OUTREG(SC_TOP_LEFT, (image->dy << 16) | image->dx);
+	OUTREG(SC_BOTTOM_RIGHT, ((image->dy + image->height) << 16) |
+	       (image->dx + image->width));
+	OUTREG(DST_Y_X, (image->dy << 16) | image->dx);
+
+	OUTREG(DST_HEIGHT_WIDTH, (image->height << 16) | ((image->width + 31) & ~31));
 
-	src_bytes = (((image->width * image->depth) + 7) / 8) * image->height;
-	dwords = (src_bytes + 3) / 4;
+	dwords = (image->width + 31) >> 5;
+	dwords *= image->height;
 	bits = (u32*)(image->data);
 
 	while(dwords >= 8) {
Index: linux-work/drivers/video/aty/radeon_base.c
===================================================================
--- linux-work.orig/drivers/video/aty/radeon_base.c	2008-11-10 14:01:50.000000000 +1100
+++ linux-work/drivers/video/aty/radeon_base.c	2008-11-10 14:36:26.000000000 +1100
@@ -1875,6 +1875,7 @@ static int __devinit radeon_set_fbinfo (
 	info->fbops = &radeonfb_ops;
 	info->screen_base = rinfo->fb_base;
 	info->screen_size = rinfo->mapped_vram;
+
 	/* Fill fix common fields */
 	strlcpy(info->fix.id, rinfo->name, sizeof(info->fix.id));
         info->fix.smem_start = rinfo->fb_base_phys;
@@ -1889,8 +1890,25 @@ static int __devinit radeon_set_fbinfo (
         info->fix.mmio_len = RADEON_REGSIZE;
 	info->fix.accel = FB_ACCEL_ATI_RADEON;
 
+	/* Allocate colormap */
 	fb_alloc_cmap(&info->cmap, 256, 0);
 
+	/* Setup pixmap used for acceleration */
+#define PIXMAP_SIZE	(2048 * 4)
+
+	info->pixmap.addr = kmalloc(PIXMAP_SIZE, GFP_KERNEL);
+	if (!info->pixmap.addr) {
+		printk(KERN_ERR "radeonfb: Failed to allocate pixmap !\n");
+		noaccel = 1;
+		goto bail;
+	}
+	info->pixmap.size = PIXMAP_SIZE;
+	info->pixmap.flags = FB_PIXMAP_SYSTEM;
+	info->pixmap.scan_align = 4;
+	info->pixmap.buf_align = 4;
+	info->pixmap.access_align = 32;
+
+bail:
 	if (noaccel)
 		info->flags |= FBINFO_HWACCEL_DISABLED;
 


