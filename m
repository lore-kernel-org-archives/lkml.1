Return-Path: <linux-kernel-owner+w=401wt.eu-S2993015AbXDDSYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993015AbXDDSYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934060AbXDDSML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:12:11 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:38675 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbXDDSLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:11:50 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 58/90] ARM: OMAP: musb_hdrc: tusb dma patch, minor
Date: Wed,  4 Apr 2007 14:05:37 -0400
Message-Id: <11757101252580-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101233966-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Move all DMAREQ for TUSB6010 into its chip setup; it shouldn't be in
either the board-specific code, or the tusb6010 glue.  (Note, we still
aren't passing the "which channels" info to the driver...)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-h4.c     |    5 +++--
 arch/arm/mach-omap2/usb-tusb6010.c |   16 ++++++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-h4.c b/arch/arm/mach-omap2/board-h4.c
index 100aea4..e85bbeb 100644
--- a/arch/arm/mach-omap2/board-h4.c
+++ b/arch/arm/mach-omap2/board-h4.c
@@ -476,9 +476,10 @@ static void __init tusb_evm_setup(void)
 		 */
 		omap_cfg_reg(J15_24XX_GPIO99);
 		irq = 99;
-		omap_cfg_reg(AA10_242X_DMAREQ0);
-		omap_cfg_reg(AA6_242X_DMAREQ1);
 		dmachan = (1 << 1) | (1 << 0);
+#if !(defined(CONFIG_MTD_OMAP_NOR) || defined(CONFIG_MTD_OMAP_NOR_MODULE))
+		dmachan |= (1 << 5) | (1 << 4) (1 << 3) | (1 << 2);
+#endif
 		break;
 	}
 
diff --git a/arch/arm/mach-omap2/usb-tusb6010.c b/arch/arm/mach-omap2/usb-tusb6010.c
index 5f276c5..497f733 100644
--- a/arch/arm/mach-omap2/usb-tusb6010.c
+++ b/arch/arm/mach-omap2/usb-tusb6010.c
@@ -17,6 +17,7 @@
 
 #include <asm/arch/gpmc.h>
 #include <asm/arch/gpio.h>
+#include <asm/arch/mux.h>
 
 
 static u8		async_cs, sync_cs;
@@ -322,6 +323,21 @@ tusb6010_setup_interface(struct musb_hdrc_platform_data *data,
 	/* REVISIT let the driver know what DMA channels work */
 	if (!dmachan)
 		tusb_device.dev.dma_mask = NULL;
+	else {
+		/* assume OMAP 2420 ES2.0 and later */
+		if (dmachan & (1 << 0))
+			omap_cfg_reg(AA10_242X_DMAREQ0);
+		if (dmachan & (1 << 1))
+			omap_cfg_reg(AA6_242X_DMAREQ1);
+		if (dmachan & (1 << 2))
+			omap_cfg_reg(E4_242X_DMAREQ2);
+		if (dmachan & (1 << 3))
+			omap_cfg_reg(G4_242X_DMAREQ3);
+		if (dmachan & (1 << 4))
+			omap_cfg_reg(D3_242X_DMAREQ4);
+		if (dmachan & (1 << 5))
+			omap_cfg_reg(E3_242X_DMAREQ5);
+	}
 
 	/* so far so good ... register the device */
 	status = platform_device_register(&tusb_device);
-- 
1.4.4.2

