Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbZFXLlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbZFXLlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757910AbZFXLgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:36:46 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25484 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686AbZFXLgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:36:42 -0400
From: Imre Deak <imre.deak@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <Tomi.Valkeinen@nokia.com>
Subject: [PATCH 14/20] omapfb: dispc: Disable iface clocks along with func clocks
Date: Wed, 24 Jun 2009 14:33:39 +0300
Message-Id: <cba1956a016f911d20cce07f38a33ebbf6c6186e.1245842329.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1ad64c0995ee88d15ebce74dec4d1da9746367f0.1245842329.git.imre.deak@nokia.com>
References: <1245843225-1036-1-git-send-email-imre.deak@nokia.com>
 <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
 <5cf7e298c3b70ad6e07d34034cc901689445e978.1245842329.git.imre.deak@nokia.com>
 <f2b49525146391a3d01b944bf4ebce045cb503d4.1245842329.git.imre.deak@nokia.com>
 <9cecdc5077b72042551eb8e3dc96911e9f4fa3fd.1245842329.git.imre.deak@nokia.com>
 <a3b6ef17cc694c350bc3a585a1697cf57cb0b1c1.1245842329.git.imre.deak@nokia.com>
 <0e2b7b0555c657a8eab00df0091b9828fb292f4c.1245842329.git.imre.deak@nokia.com>
 <af3d1e0dff22f0bb72f6ccee57dfa9a1e5f31abb.1245842329.git.imre.deak@nokia.com>
 <6881ca5b34fcf36c3f39b13de85857dcc20f568d.1245842329.git.imre.deak@nokia.com>
 <726d4af0547b42ec8a9af7c6f0079cf9b7fadf5c.1245842329.git.imre.deak@nokia.com>
 <742d96c9c8d6826eddd49a913b6adaa8f176edbe.1245842329.git.imre.deak@nokia.com>
 <279625bb9ea911185e017cdf8d18a46f263fbb5c.1245842329.git.imre.deak@nokia.com>
 <db880b91c36cbd5672f503e249d44411448533bd.1245842329.git.imre.deak@nokia.com>
 <1ad64c0995ee88d15ebce74dec4d1da9746367f0.1245842329.git.imre.deak@nokia.com>
In-Reply-To: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
References: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
X-OriginalArrivalTime: 24 Jun 2009 11:36:14.0994 (UTC) FILETIME=[FB5DF720:01C9F4BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jouni Hogander <jouni.hogander@nokia.com>

Leaving interface clocks enabled causes dss pwrdm to stay in active
state when mpu is in active state. This fix puts dss to sleep state
when it is not needed.

Earlier version broke framebuffer on 24xx. This is fixed by enabling
clocks before trying to access DISPC_IRQSTATUS register.

Signed-off-by: Jouni Hogander <jouni.hogander@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
 drivers/video/omap/dispc.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/video/omap/dispc.c b/drivers/video/omap/dispc.c
index 2db8fbb..cc3c817 100644
--- a/drivers/video/omap/dispc.c
+++ b/drivers/video/omap/dispc.c
@@ -858,8 +858,11 @@ EXPORT_SYMBOL(omap_dispc_free_irq);
 
 static irqreturn_t omap_dispc_irq_handler(int irq, void *dev)
 {
-	u32 stat = dispc_read_reg(DISPC_IRQSTATUS);
+	u32 stat;
 
+	enable_lcd_clocks(1);
+
+	stat = dispc_read_reg(DISPC_IRQSTATUS);
 	if (stat & DISPC_IRQ_FRAMEMASK)
 		complete(&dispc.frame_done);
 
@@ -875,6 +878,8 @@ static irqreturn_t omap_dispc_irq_handler(int irq, void *dev)
 
 	dispc_write_reg(DISPC_IRQSTATUS, stat);
 
+	enable_lcd_clocks(0);
+
 	return IRQ_HANDLED;
 }
 
@@ -913,18 +918,13 @@ static void put_dss_clocks(void)
 
 static void enable_lcd_clocks(int enable)
 {
-	if (enable)
+	if (enable) {
+		clk_enable(dispc.dss_ick);
 		clk_enable(dispc.dss1_fck);
-	else
+	} else {
 		clk_disable(dispc.dss1_fck);
-}
-
-static void enable_interface_clocks(int enable)
-{
-	if (enable)
-		clk_enable(dispc.dss_ick);
-	else
 		clk_disable(dispc.dss_ick);
+	}
 }
 
 static void enable_digit_clocks(int enable)
@@ -1365,7 +1365,6 @@ static int omap_dispc_init(struct omapfb_device *fbdev, int ext_mode,
 	if ((r = get_dss_clocks()) < 0)
 		goto fail0;
 
-	enable_interface_clocks(1);
 	enable_lcd_clocks(1);
 
 #ifdef CONFIG_FB_OMAP_BOOTLOADER_INIT
@@ -1469,7 +1468,6 @@ fail2:
 	free_irq(INT_24XX_DSS_IRQ, fbdev);
 fail1:
 	enable_lcd_clocks(0);
-	enable_interface_clocks(0);
 	put_dss_clocks();
 fail0:
 	iounmap(dispc.base);
@@ -1487,7 +1485,6 @@ static void omap_dispc_cleanup(void)
 	cleanup_fbmem();
 	free_palette_ram();
 	free_irq(INT_24XX_DSS_IRQ, dispc.fbdev);
-	enable_interface_clocks(0);
 	put_dss_clocks();
 	iounmap(dispc.base);
 }
-- 
1.6.3.2

