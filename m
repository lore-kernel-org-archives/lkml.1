Return-Path: <linux-kernel-owner+w=401wt.eu-S932607AbZHQL4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbZHQL4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179AbZHQL4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:56:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:44984 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757882AbZHQL4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:56:00 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+UOhUp5jmUfmoXK2aKZjwmve9pyMt1g3EIXUAw7C
	czBPKvLFYyLnbm
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/4] viafb: cleanup virtual memory handling
Date: Mon, 17 Aug 2009 11:58:10 +0000
Message-Id: <1250510290-3327-4-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1250510290-3327-3-git-send-email-FlorianSchandinat@gmx.de>
References: <1250510290-3327-1-git-send-email-FlorianSchandinat@gmx.de>
 <1250510290-3327-2-git-send-email-FlorianSchandinat@gmx.de>
 <1250510290-3327-3-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: -0.07000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: cleanup virtual memory handling

This patch cleans the handling of ioremapped video memory up. The
following changes were made:

info->screen_base - viafb_FB_MM
(VRAM offset calculation) was replaced by
info->fix.smem_start - viafbinfo->fix.smem_start
which is essentially the same calculation but done with physical instead
virtual addresses.

*->fbmem_virt
was replaced by
viafbinfo->screen_base
This is true for viafbinfo and viafbinfo1 as the par pointers are equal.

An early initialization of viafbinfo1->fix.smem* was removed as done
later in viafb_setup_fixinfo.

This patch highlights that the only usage of the ioremapped video memory
in the driver is for hardware cursor handling. Even if it has to hold
the used virtual screen mapped for old-fashioned read/write calls (vs.
mmap'ed) a lot virtual memory could be saved by only ioremapping
on demand.

Code cleanup, no runtime changes expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 global.c   |    1 -
 global.h   |    1 -
 viafbdev.c |   27 ++++++++-------------------
 viafbdev.h |    1 -
 4 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/video/via/global.c b/drivers/video/via/global.c
index 468be24..1096fd5 100644
--- a/drivers/video/via/global.c
+++ b/drivers/video/via/global.c
@@ -46,7 +46,6 @@ int viafb_hotplug_refresh = 60;
 unsigned int viafb_second_offset;
 int viafb_second_size;
 int viafb_primary_dev = None_Device;
-void __iomem *viafb_FB_MM;
 unsigned int viafb_second_xres = 640;
 unsigned int viafb_second_yres = 480;
 unsigned int viafb_second_virtual_xres;
diff --git a/drivers/video/via/global.h b/drivers/video/via/global.h
index 7543d5f..11382e5 100644
--- a/drivers/video/via/global.h
+++ b/drivers/video/via/global.h
@@ -77,7 +77,6 @@ extern int viafb_hotplug_Yres;
 extern int viafb_hotplug_bpp;
 extern int viafb_hotplug_refresh;
 extern int viafb_primary_dev;
-extern void __iomem *viafb_FB_MM;
 extern struct fb_cursor viacursor;
 
 extern unsigned int viafb_second_xres;
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index e48e493..ab1f491 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -832,8 +832,7 @@ static void viafb_fillrect(struct fb_info *info,
 	/* Source Base Address */
 	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
 	/* Destination Base Address */
-	writel(((unsigned long) (info->screen_base) -
-		   (unsigned long) viafb_FB_MM) >> 3,
+	writel((info->fix.smem_start - viafbinfo->fix.smem_start) >> 3,
 		   viaparinfo->io_virt + VIA_REG_DSTBASE);
 	/* Pitch */
 	pitch = (info->var.xres_virtual + 7) & ~7;
@@ -887,12 +886,10 @@ static void viafb_copyarea(struct fb_info *info,
 	}
 
 	/* Source Base Address */
-	writel(((unsigned long) (info->screen_base) -
-		   (unsigned long) viafb_FB_MM) >> 3,
+	writel((info->fix.smem_start - viafbinfo->fix.smem_start) >> 3,
 		   viaparinfo->io_virt + VIA_REG_SRCBASE);
 	/* Destination Base Address */
-	writel(((unsigned long) (info->screen_base) -
-		   (unsigned long) viafb_FB_MM) >> 3,
+	writel((info->fix.smem_start - viafbinfo->fix.smem_start) >> 3,
 		   viaparinfo->io_virt + VIA_REG_DSTBASE);
 	/* Pitch */
 	pitch = (info->var.xres_virtual + 7) & ~7;
@@ -951,8 +948,7 @@ static void viafb_imageblit(struct fb_info *info,
 	/* Source Base Address */
 	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
 	/* Destination Base Address */
-	writel(((unsigned long) (info->screen_base) -
-		   (unsigned long) viafb_FB_MM) >> 3,
+	writel((info->fix.smem_start - viafbinfo->fix.smem_start) >> 3,
 		   viaparinfo->io_virt + VIA_REG_DSTBASE);
 	/* Pitch */
 	pitch = (info->var.xres_virtual + 7) & ~7;
@@ -1170,7 +1166,7 @@ static int viafb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 			}
 		}
 
-		memcpy(((struct viafb_par *)(info->par))->fbmem_virt +
+		memcpy(viafbinfo->screen_base +
 		       ((struct viafb_par *)(info->par))->cursor_start,
 		       cr_data->bak, CURSOR_SIZE);
 out:
@@ -2070,11 +2066,9 @@ static int __devinit via_pci_probe(void)
 	viafb_get_fb_info(&viaparinfo->fbmem, &viaparinfo->memsize);
 	viaparinfo->fbmem_free = viaparinfo->memsize;
 	viaparinfo->fbmem_used = 0;
-	viaparinfo->fbmem_virt = ioremap_nocache(viaparinfo->fbmem,
+	viafbinfo->screen_base = ioremap_nocache(viaparinfo->fbmem,
 		viaparinfo->memsize);
-	viafbinfo->screen_base = (char *)viaparinfo->fbmem_virt;
-
-	if (!viaparinfo->fbmem_virt) {
+	if (!viafbinfo->screen_base) {
 		printk(KERN_INFO "ioremap failed\n");
 		return -ENOMEM;
 	}
@@ -2107,7 +2101,6 @@ static int __devinit via_pci_probe(void)
 			viafb_second_size * 1024 * 1024;
 	}
 
-	viafb_FB_MM = viaparinfo->fbmem_virt;
 	tmpm = viafb_mode;
 	tmpc = strsep(&tmpm, "x");
 	strict_strtoul(tmpc, 0, &default_xres);
@@ -2200,8 +2193,6 @@ static int __devinit via_pci_probe(void)
 		viaparinfo1->memsize = viaparinfo->memsize -
 			viafb_second_offset;
 		viaparinfo->memsize = viafb_second_offset;
-		viaparinfo1->fbmem_virt = viaparinfo->fbmem_virt +
-			viafb_second_offset;
 		viaparinfo1->fbmem = viaparinfo->fbmem + viafb_second_offset;
 
 		viaparinfo1->fbmem_used = viaparinfo->fbmem_used;
@@ -2223,8 +2214,6 @@ static int __devinit via_pci_probe(void)
 		memcpy(viafbinfo1, viafbinfo, sizeof(struct fb_info));
 		viafbinfo1->screen_base = viafbinfo->screen_base +
 			viafb_second_offset;
-		viafbinfo1->fix.smem_start = viaparinfo1->fbmem;
-		viafbinfo1->fix.smem_len = viaparinfo1->fbmem_free;
 
 		default_var.xres = viafb_second_xres;
 		default_var.yres = viafb_second_yres;
@@ -2286,7 +2275,7 @@ static void __devexit via_pci_remove(void)
 	unregister_framebuffer(viafbinfo);
 	if (viafb_dual_fb)
 		unregister_framebuffer(viafbinfo1);
-	iounmap((void *)viaparinfo->fbmem_virt);
+	iounmap((void *)viafbinfo->screen_base);
 	iounmap(viaparinfo->io_virt);
 
 	viafb_delete_i2c_buss(viaparinfo);
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index 9231877..e5a247c 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -38,7 +38,6 @@
 #define VERSION_MINOR       4
 
 struct viafb_par {
-	void __iomem *fbmem_virt;	/*framebuffer virtual memory address */
 	void __iomem *io_virt;	/*iospace virtual memory address */
 	unsigned int fbmem;	/*framebuffer physical memory address */
 	unsigned int memsize;	/*size of fbmem */
-- 
1.6.3.2

