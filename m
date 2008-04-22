Return-Path: <linux-kernel-owner+w=401wt.eu-S932408AbYDVB2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbYDVB2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 21:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbYDVB11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 21:27:27 -0400
Received: from ozlabs.org ([203.10.76.45]:50627 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761411AbYDVB1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 21:27:25 -0400
To: <linux-fbdev-devel@lists.sourceforge.net>
CC: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       <adaplas@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 22 Apr 2008 11:26:08 +1000
Subject: [PATCH 2/3] aty128fb: Fix 64 bits resources on 32 bits archs
Message-Id: <20080422012724.C22F5DE1AF@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes aty128fb to not truncate 64 bits resources on 32 bits
platforms. Unfortunately, there are still issues with addresses
returned to userspace via struct fb_fix_screeninfo. This will
have to be dealt with separately.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 drivers/video/aty/aty128fb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-work.orig/drivers/video/aty/aty128fb.c	2008-04-22 11:18:41.000000000 +1000
+++ linux-work/drivers/video/aty/aty128fb.c	2008-04-22 11:19:31.000000000 +1000
@@ -2011,7 +2011,7 @@ static int __devinit aty128_init(struct 
 /* register a card    ++ajoshi */
 static int __devinit aty128_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	unsigned long fb_addr, reg_addr;
+	resource_size_t fb_addr, reg_addr;
 	struct aty128fb_par *par;
 	struct fb_info *info;
 	int err;
@@ -2052,7 +2052,6 @@ static int __devinit aty128_probe(struct
 	info->pseudo_palette = par->pseudo_palette;
 
 	/* Virtualize mmio region */
-	info->fix.mmio_start = reg_addr;
 	par->regbase = ioremap(reg_addr, pci_resource_len(pdev, 2));
 	if (!par->regbase)
 		goto err_free_info;
@@ -2068,9 +2067,9 @@ static int __devinit aty128_probe(struct
 
 	/* Set up info->fix */
 	info->fix = aty128fb_fix;
-	info->fix.smem_start = fb_addr;
+	info->fix.smem_start = (unsigned long)fb_addr;
 	info->fix.smem_len = par->vram_size;
-	info->fix.mmio_start = reg_addr;
+	info->fix.mmio_start = (unsigned long)reg_addr;
 
 	/* If we can't test scratch registers, something is seriously wrong */
 	if (!register_test(par)) {
