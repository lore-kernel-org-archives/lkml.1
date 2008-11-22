Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbYKVXQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbYKVXQg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 18:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYKVXQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 18:16:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:59122 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbYKVXQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 18:16:26 -0500
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       James Cloos <cloos@jhcloos.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <vyitTh0pP2N.A.qBE.B9HKJB@chimera>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
	 <vyitTh0pP2N.A.qBE.B9HKJB@chimera>
Content-Type: text/plain
Date: Sun, 23 Nov 2008 10:15:58 +1100
Message-Id: <1227395758.7185.293.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-22 at 21:28 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).

The patch should definitely be merged as it fixes a problem. Andrew,
will you send it to Linus ? There's no fbdev maintainer anymore...

Here's the up to date patch (same as previously posted minus a warning
that was due to a now unused variable that I removed in this one). It
doesn't fix -other- problems reported with suspend & shutdown that have
been elusive so far (I really haven't reproduced despite some serious
torturing) and could be X bugs in the first place. I'll continue
investigating them but in the meantime, this should go in.

radeonfb: Fix problem with color expansion & alignment

The engine on some radeon variants locks up if color expansion is
called for non aligned source data. This patch enables a feature of
the core fbdev to request aligned input pixmaps and uses the HW
clipping engine to clip the output to the requested size

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-work/drivers/video/aty/radeon_accel.c
===================================================================
--- linux-work.orig/drivers/video/aty/radeon_accel.c	2008-11-23 10:10:16.000000000 +1100
+++ linux-work/drivers/video/aty/radeon_accel.c	2008-11-23 10:12:34.000000000 +1100
@@ -174,12 +174,12 @@ static void radeonfb_prim_imageblit(stru
 				    const struct fb_image *image,
 				    u32 fg, u32 bg)
 {
-	unsigned int src_bytes, dwords;
+	unsigned int dwords;
 	u32 *bits;
 
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
--- linux-work.orig/drivers/video/aty/radeon_base.c	2008-11-23 10:10:16.000000000 +1100
+++ linux-work/drivers/video/aty/radeon_base.c	2008-11-23 10:11:02.000000000 +1100
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
 


