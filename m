Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbZHZR0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbZHZR0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZHZR0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:26:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:42370 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752370AbZHZR0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:26:18 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/mAUAnltXmba4zN2IVhxeY8ejBtZquP3VedelEu7
	QGabQF9d/DnbIf
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/3] viafb: another small cleanup of viafb_par
Date: Wed, 26 Aug 2009 17:29:12 +0000
Message-Id: <1251307753-5209-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1251307753-5209-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1251307753-5209-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: another small cleanup of viafb_par

This removes the completly useless io variable as well as the temporary
used variables mmio_base and mmio_len in favor to use directly the
fb_info variables.
This is a code cleanup only, no runtime change expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 hw.c       |    3 +--
 hw.h       |    3 +--
 viafbdev.c |    9 ++++-----
 viafbdev.h |    3 ---
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 5be4a67..86050e7 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2496,8 +2496,7 @@ void viafb_crt_enable(void)
 	viafb_write_reg_mask(CR36, VIACR, 0x0, BIT5 + BIT4);
 }
 
-void viafb_get_mmio_info(unsigned long *mmio_base,
-	unsigned long *mmio_len)
+void viafb_get_mmio_info(unsigned long *mmio_base, u32 *mmio_len)
 {
 	struct pci_dev *pdev = NULL;
 	u32 vendor, device;
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 874ea3f..cf1dfd5 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -923,8 +923,7 @@ int viafb_get_pixclock(int hres, int vres, int vmode_refresh);
 int viafb_get_refresh(int hres, int vres, u32 float_refresh);
 void viafb_update_device_setting(int hres, int vres, int bpp,
 			   int vmode_refresh, int flag);
-void viafb_get_mmio_info(unsigned long *mmio_base,
-	unsigned long *mmio_len);
+void viafb_get_mmio_info(unsigned long *mmio_base, u32 *mmio_len);
 
 void viafb_set_iga_path(void);
 void viafb_set_primary_address(u32 addr);
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 924177c..a17e138 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -69,8 +69,6 @@ static void viafb_setup_fixinfo(struct fb_fix_screeninfo *fix,
 
 	fix->smem_start = viaparinfo->fbmem;
 	fix->smem_len = viaparinfo->fbmem_free;
-	fix->mmio_start = viaparinfo->mmio_base;
-	fix->mmio_len = viaparinfo->mmio_len;
 
 	fix->type = FB_TYPE_PACKED_PIXELS;
 	fix->type_aux = 0;
@@ -2004,9 +2002,10 @@ static int __devinit via_pci_probe(void)
 		return -ENOMEM;
 	}
 
-	viafb_get_mmio_info(&viaparinfo->mmio_base, &viaparinfo->mmio_len);
-	viaparinfo->io_virt = ioremap_nocache(viaparinfo->mmio_base,
-		viaparinfo->mmio_len);
+	viafb_get_mmio_info(&viafbinfo->fix.mmio_start,
+		&viafbinfo->fix.mmio_len);
+	viaparinfo->io_virt = ioremap_nocache(viafbinfo->fix.mmio_start,
+		viafbinfo->fix.mmio_len);
 	if (!viaparinfo->io_virt) {
 		printk(KERN_WARNING "ioremap failed: hardware acceleration disabled\n");
 		viafb_accel = 0;
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index cd871f9..2763922 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -41,9 +41,6 @@ struct viafb_par {
 	void __iomem *io_virt;	/*iospace virtual memory address */
 	unsigned int fbmem;	/*framebuffer physical memory address */
 	unsigned int memsize;	/*size of fbmem */
-	unsigned int io;	/*io space address */
-	unsigned long mmio_base;	/*mmio base address */
-	unsigned long mmio_len;	/*mmio base length */
 	u32 fbmem_free;		/* Free FB memory */
 	u32 fbmem_used;		/* Use FB memory size */
 	u32 cursor_start;	/* Cursor Start Address */
-- 
1.6.3.2

