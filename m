Return-Path: <linux-kernel-owner+w=401wt.eu-S1760571AbYDVB2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760571AbYDVB2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 21:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932389AbYDVB12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 21:27:28 -0400
Received: from ozlabs.org ([203.10.76.45]:50670 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350AbYDVB11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 21:27:27 -0400
To: <linux-fbdev-devel@lists.sourceforge.net>
CC: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       <adaplas@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 22 Apr 2008 11:26:09 +1000
Subject: [PATCH 3/3] atyfb: Fix 64 bits resources on 32 bits archs
Message-Id: <20080422012726.42775DE2A3@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes atyfb to not truncate 64 bits resources on 32 bits
platforms. Unfortunately, there are still issues with addresses
returned to userspace via struct fb_fix_screeninfo. This will
have to be dealt with separately.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 drivers/video/aty/atyfb_base.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-work.orig/drivers/video/aty/atyfb_base.c	2008-04-22 11:21:46.000000000 +1000
+++ linux-work/drivers/video/aty/atyfb_base.c	2008-04-22 11:23:58.000000000 +1000
@@ -2842,7 +2842,7 @@ static int atyfb_setcolreg(u_int regno, 
 #ifdef __sparc__
 
 static int __devinit atyfb_setup_sparc(struct pci_dev *pdev,
-			struct fb_info *info, unsigned long addr)
+			struct fb_info *info, resource_size_t addr)
 {
 	struct atyfb_par *par = info->par;
 	struct device_node *dp;
@@ -3334,11 +3334,11 @@ static int __devinit init_from_bios(stru
 }
 #endif /* __i386__ */
 
-static int __devinit atyfb_setup_generic(struct pci_dev *pdev, struct fb_info *info, unsigned long addr)
+static int __devinit atyfb_setup_generic(struct pci_dev *pdev, struct fb_info *info, resource_size_t addr)
 {
 	struct atyfb_par *par = info->par;
 	u16 tmp;
-	unsigned long raddr;
+	resource_size_t raddr;
 	struct resource *rrp;
 	int ret = 0;
 
@@ -3351,8 +3351,8 @@ static int __devinit atyfb_setup_generic
 		PRINTKI("using auxiliary register aperture\n");
 	}
 
-	info->fix.mmio_start = raddr;
-	par->ati_regbase = ioremap(info->fix.mmio_start, 0x1000);
+	info->fix.mmio_start = (unsigned long)raddr;
+	par->ati_regbase = ioremap(raddr, 0x1000);
 	if (par->ati_regbase == 0)
 		return -ENOMEM;
 
@@ -3374,7 +3374,7 @@ static int __devinit atyfb_setup_generic
 #endif
 
 	/* Map in frame buffer */
-	info->fix.smem_start = addr;
+	info->fix.smem_start = (unsigned long)addr;
 	info->screen_base = ioremap(addr, 0x800000);
 	if (info->screen_base == NULL) {
 		ret = -ENOMEM;
@@ -3411,7 +3411,7 @@ atyfb_setup_generic_fail:
 
 static int __devinit atyfb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	unsigned long addr, res_start, res_size;
+	resource_size_t addr, res_start, res_size;
 	struct fb_info *info;
 	struct resource *rp;
 	struct atyfb_par *par;
