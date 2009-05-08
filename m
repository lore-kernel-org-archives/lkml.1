Return-Path: <linux-kernel-owner+w=401wt.eu-S1762936AbZEHOGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762936AbZEHOGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758950AbZEHOBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:01:38 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58272 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756787AbZEHOBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:01:34 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 12/15] ps3fb: Tear down FB setup during cleanup
Date: Fri,  8 May 2009 16:01:21 +0200
Message-Id: <1241791284-11490-13-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241791284-11490-12-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-9-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-10-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-11-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-12-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During cleanup, use L1GPU_CONTEXT_ATTRIBUTE_FB_CLOSE to tear down the setup
done by L1GPU_CONTEXT_ATTRIBUTE_FB_SETUP.

This allows unloading and reloading of ps3fb while the sound driver keeps the
GPU open.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/powerpc/include/asm/ps3gpu.h |    8 ++++++++
 drivers/video/ps3fb.c             |    5 ++++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/ps3gpu.h b/arch/powerpc/include/asm/ps3gpu.h
index 1037efa..b2b8959 100644
--- a/arch/powerpc/include/asm/ps3gpu.h
+++ b/arch/powerpc/include/asm/ps3gpu.h
@@ -31,6 +31,7 @@
 #define L1GPU_CONTEXT_ATTRIBUTE_FB_SETUP	0x600
 #define L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT		0x601
 #define L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT_SYNC	0x602
+#define L1GPU_CONTEXT_ATTRIBUTE_FB_CLOSE	0x603
 
 #define L1GPU_FB_BLIT_WAIT_FOR_COMPLETION	(1ULL << 32)
 
@@ -75,4 +76,11 @@ static inline int lv1_gpu_fb_blit(u64 context_handle, u64 ddr_offset,
 					 pitch);
 }
 
+static inline int lv1_gpu_fb_close(u64 context_handle)
+{
+	return lv1_gpu_context_attribute(context_handle,
+					 L1GPU_CONTEXT_ATTRIBUTE_FB_CLOSE, 0,
+					 0, 0, 0);
+}
+
 #endif /* _ASM_POWERPC_PS3GPU_H */
diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
index 3bbdc9d..aa3ebe4 100644
--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -1122,7 +1122,7 @@ static int __devinit ps3fb_probe(struct ps3_system_bus_device *dev)
 
 	info = framebuffer_alloc(sizeof(struct ps3fb_par), &dev->core);
 	if (!info)
-		goto err_context_unmap;
+		goto err_context_fb_close;
 
 	par = info->par;
 	par->mode_id = ~ps3fb_mode;	/* != ps3fb_mode, to trigger change */
@@ -1187,6 +1187,8 @@ err_fb_dealloc:
 	fb_dealloc_cmap(&info->cmap);
 err_framebuffer_release:
 	framebuffer_release(info);
+err_context_fb_close:
+	lv1_gpu_fb_close(ps3fb.context_handle);
 err_context_unmap:
 	lv1_gpu_context_iomap(ps3fb.context_handle, GPU_IOIF, xdr_lpar,
 			      ps3fb_videomemory.size, IOPTE_M);
@@ -1232,6 +1234,7 @@ static int ps3fb_shutdown(struct ps3_system_bus_device *dev)
 		info = dev->core.driver_data = NULL;
 	}
 	iounmap((u8 __force __iomem *)ps3fb.dinfo);
+	lv1_gpu_fb_close(ps3fb.context_handle);
 	lv1_gpu_context_iomap(ps3fb.context_handle, GPU_IOIF, xdr_lpar,
 			      ps3fb_videomemory.size, IOPTE_M);
 	lv1_gpu_context_free(ps3fb.context_handle);
-- 
1.6.2.4

