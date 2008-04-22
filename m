Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbYDVB1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbYDVB1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 21:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932292AbYDVB10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 21:27:26 -0400
Received: from ozlabs.org ([203.10.76.45]:50625 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181AbYDVB1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 21:27:25 -0400
To: <linux-fbdev-devel@lists.sourceforge.net>
CC: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       <adaplas@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 22 Apr 2008 11:26:07 +1000
Subject: [PATCH 1/3] radeonfb: Fix 64 bits resources on 32 bits archs
Message-Id: <20080422012723.BA9F2DE13F@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes radeonfb to not truncate 64 bits resources on 32 bits
platforms. Unfortunately, there are still issues with addresses
returned to userspace via struct fb_fix_screeninfo. This will
have to be dealt with separately.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 drivers/video/aty/radeon_base.c |    4 ++--
 drivers/video/aty/radeonfb.h    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- linux-work.orig/drivers/video/aty/radeon_base.c	2008-04-22 11:04:19.000000000 +1000
+++ linux-work/drivers/video/aty/radeon_base.c	2008-04-22 11:05:00.000000000 +1000
@@ -1886,7 +1886,7 @@ static int __devinit radeon_set_fbinfo (
 	info->screen_size = rinfo->mapped_vram;
 	/* Fill fix common fields */
 	strlcpy(info->fix.id, rinfo->name, sizeof(info->fix.id));
-        info->fix.smem_start = rinfo->fb_base_phys;
+        info->fix.smem_start = (unsigned long)rinfo->fb_base_phys;
         info->fix.smem_len = rinfo->video_ram;
         info->fix.type = FB_TYPE_PACKED_PIXELS;
         info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
@@ -1894,7 +1894,7 @@ static int __devinit radeon_set_fbinfo (
         info->fix.ypanstep = 1;
         info->fix.ywrapstep = 0;
         info->fix.type_aux = 0;
-        info->fix.mmio_start = rinfo->mmio_base_phys;
+        info->fix.mmio_start = (unsigned long)rinfo->mmio_base_phys;
         info->fix.mmio_len = RADEON_REGSIZE;
 	info->fix.accel = FB_ACCEL_ATI_RADEON;
 
Index: linux-work/drivers/video/aty/radeonfb.h
===================================================================
--- linux-work.orig/drivers/video/aty/radeonfb.h	2008-04-22 11:03:17.000000000 +1000
+++ linux-work/drivers/video/aty/radeonfb.h	2008-04-22 11:03:27.000000000 +1000
@@ -287,8 +287,8 @@ struct radeonfb_info {
 
 	char			name[DEVICE_NAME_SIZE];
 
-	unsigned long		mmio_base_phys;
-	unsigned long		fb_base_phys;
+	resource_size_t		mmio_base_phys;
+	resource_size_t		fb_base_phys;
 
 	void __iomem		*mmio_base;
 	void __iomem		*fb_base;
