Return-Path: <linux-kernel-owner+w=401wt.eu-S933224AbZHDSQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbZHDSQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933213AbZHDSQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:16:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:38965 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932940AbZHDSQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:16:47 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/lLlt2ei3lXmNHA6tvUkMtoC0iOn9cFk1hO/Io+Z
	y8L1WAoxncOR4/
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/2] viafb: split viafb_set_start_addr up
Date: Tue,  4 Aug 2009 18:18:29 +0000
Message-Id: <1249409909-3500-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1249409909-3500-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1249409909-3500-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: split viafb_set_start_addr up

Move individual start address setting to viafb_set_primary_address and
viafb_set_secondary_address and make it more flexible to reuse it for
panning. Using central functions makes it easier to follow HW
manipulations.
Remove crt locking as it should be only needed for timing manipulation.
Move iga_path manipulation to via_pci_probe.
Remove memset for screen cleaning as it is currently done only for the
second screen. This is not needed for normal operation but has a little
chance of causing unwanted display artifacts. This can be fixed later
more consistent and more efficient (using viafb_fillrect) if needed.
This is a code clenup, no notable runtime changes expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 hw.c       |   80 ++++++++++++-----------------------------------------------
 hw.h       |    3 +-
 viafbdev.c |   15 +++++------
 3 files changed, 26 insertions(+), 72 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 64a820c..5be4a67 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -629,70 +629,23 @@ void viafb_set_iga_path(void)
 	}
 }
 
-void viafb_set_start_addr(void)
+void viafb_set_primary_address(u32 addr)
 {
-	unsigned long offset = 0, tmp = 0, size = 0;
-	unsigned long length;
-
-	DEBUG_MSG(KERN_INFO "viafb_set_start_addr!\n");
-	viafb_unlock_crt();
-	/* update starting address of IGA1 */
-	viafb_write_reg(CR0C, VIACR, 0x00);	/*initial starting address */
-	viafb_write_reg(CR0D, VIACR, 0x00);
-	viafb_write_reg(CR34, VIACR, 0x00);
-	viafb_write_reg_mask(CR48, VIACR, 0x00, 0x1F);
-
-	if (viafb_dual_fb) {
-		viaparinfo->iga_path = IGA1;
-		viaparinfo1->iga_path = IGA2;
-	}
-
-	if (viafb_SAMM_ON == 1) {
-		if (!viafb_dual_fb) {
-			if (viafb_second_size)
-				size = viafb_second_size * 1024 * 1024;
-			else
-				size = 8 * 1024 * 1024;
-		} else {
-
-			size = viaparinfo1->memsize;
-		}
-		offset = viafb_second_offset;
-		DEBUG_MSG(KERN_INFO
-			  "viafb_second_size=%lx, second start_adddress=%lx\n",
-			  size, offset);
-	}
-	if (viafb_SAMM_ON == 1) {
-		offset = offset >> 3;
-
-		tmp = viafb_read_reg(VIACR, 0x62) & 0x01;
-		tmp |= (offset & 0x7F) << 1;
-		viafb_write_reg(CR62, VIACR, tmp);
-		viafb_write_reg(CR63, VIACR, ((offset & 0x7F80) >> 7));
-		viafb_write_reg(CR64, VIACR, ((offset & 0x7F8000) >> 15));
-		viafb_write_reg(CRA3, VIACR, ((offset & 0x3800000) >> 23));
-	} else {
-		/* update starting address */
-		viafb_write_reg(CR62, VIACR, 0x00);
-		viafb_write_reg(CR63, VIACR, 0x00);
-		viafb_write_reg(CR64, VIACR, 0x00);
-		viafb_write_reg(CRA3, VIACR, 0x00);
-	}
-
-	if (viafb_SAMM_ON == 1) {
-		if (viafb_accel) {
-			if (!viafb_dual_fb)
-				length = size - viaparinfo->fbmem_used;
-			else
-				length = size - viaparinfo1->fbmem_used;
-		} else
-			length = size;
-		offset = (unsigned long)(void *)viafb_FB_MM +
-			viafb_second_offset;
-		memset((void *)offset, 0, length);
-	}
+	DEBUG_MSG(KERN_DEBUG "viafb_set_primary_address(0x%08X)\n", addr);
+	viafb_write_reg(CR0D, VIACR, addr & 0xFF);
+	viafb_write_reg(CR0C, VIACR, (addr >> 8) & 0xFF);
+	viafb_write_reg(CR34, VIACR, (addr >> 16) & 0xFF);
+	viafb_write_reg_mask(CR48, VIACR, (addr >> 24) & 0x1F, 0x1F);
+}
 
-	viafb_lock_crt();
+void viafb_set_secondary_address(u32 addr)
+{
+	DEBUG_MSG(KERN_DEBUG "viafb_set_secondary_address(0x%08X)\n", addr);
+	/* secondary display supports only quadword aligned memory */
+	viafb_write_reg_mask(CR62, VIACR, (addr >> 2) & 0xFE, 0xFE);
+	viafb_write_reg(CR63, VIACR, (addr >> 10) & 0xFF);
+	viafb_write_reg(CR64, VIACR, (addr >> 18) & 0xFF);
+	viafb_write_reg_mask(CRA3, VIACR, (addr >> 26) & 0x07, 0x07);
 }
 
 void viafb_set_output_path(int device, int set_iga, int output_interface)
@@ -2288,7 +2241,8 @@ int viafb_setmode(int vmode_index, int hor_res, int ver_res, int video_bpp,
 		outb(VPIT.SR[i - 1], VIASR + 1);
 	}
 
-	viafb_set_start_addr();
+	viafb_set_primary_address(0);
+	viafb_set_secondary_address(viafb_SAMM_ON ? viafb_second_offset : 0);
 	viafb_set_iga_path();
 
 	/* Write CRTC */
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 6ff38fa..874ea3f 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -927,7 +927,8 @@ void viafb_get_mmio_info(unsigned long *mmio_base,
 	unsigned long *mmio_len);
 
 void viafb_set_iga_path(void);
-void viafb_set_start_addr(void);
+void viafb_set_primary_address(u32 addr);
+void viafb_set_secondary_address(u32 addr);
 void viafb_get_fb_info(unsigned int *fb_base, unsigned int *fb_len);
 
 #endif /* __HW_H__ */
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 6612ddc..743eed4 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -481,12 +481,7 @@ static int viafb_pan_display(struct fb_var_screeninfo *var,
 	    var->bits_per_pixel / 16;
 
 	DEBUG_MSG(KERN_INFO "\nviafb_pan_display,offset =%d ", offset);
-
-	viafb_write_reg_mask(0x48, 0x3d4, ((offset >> 24) & 0x3), 0x3);
-	viafb_write_reg_mask(0x34, 0x3d4, ((offset >> 16) & 0xff), 0xff);
-	viafb_write_reg_mask(0x0c, 0x3d4, ((offset >> 8) & 0xff), 0xff);
-	viafb_write_reg_mask(0x0d, 0x3d4, (offset & 0xff), 0xff);
-
+	viafb_set_primary_address(offset);
 	return 0;
 }
 
@@ -1353,7 +1348,8 @@ static void viafb_set_device(struct device_t active_dev)
 		viafb_SAMM_ON = active_dev.samm;
 	viafb_primary_dev = active_dev.primary_dev;
 
-	viafb_set_start_addr();
+	viafb_set_primary_address(0);
+	viafb_set_secondary_address(viafb_SAMM_ON ? viafb_second_offset : 0);
 	viafb_set_iga_path();
 }
 
@@ -1537,7 +1533,8 @@ static int apply_device_setting(struct viafb_ioctl_setting setting_info,
 			if (viafb_SAMM_ON)
 				viafb_primary_dev = setting_info.primary_device;
 
-			viafb_set_start_addr();
+			viafb_set_primary_address(0);
+			viafb_set_secondary_address(viafb_SAMM_ON ? viafb_second_offset : 0);
 			viafb_set_iga_path();
 		}
 		need_set_mode = 1;
@@ -2275,6 +2272,8 @@ static int __devinit via_pci_probe(void)
 				viafb_second_offset;
 		}
 
+		viaparinfo->iga_path = IGA1;
+		viaparinfo1->iga_path = IGA2;
 		memcpy(viafbinfo1, viafbinfo, sizeof(struct fb_info));
 		viafbinfo1->screen_base = viafbinfo->screen_base +
 			viafb_second_offset;
-- 
1.6.3.2

