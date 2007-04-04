Return-Path: <linux-kernel-owner+w=401wt.eu-S1422734AbXDDSSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422734AbXDDSSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992748AbXDDSOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:14:32 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:39967 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934079AbXDDSOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:14:01 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 80/90] ARM: OMAP: partial LED fixes
Date: Wed,  4 Apr 2007 14:05:59 -0400
Message-Id: <11757101893744-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101862498-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

Partial fix for CONFIG_LEDS breakage ... at least allow platforms
using the debug-leds support (H4 for now) to build with the generic
LED support, and default the LED that would be the timer LED to
trigger using the "heartbeat" (timer driven, rate depends on load).

Right now only H2 and P2 seem to have working LED support; this
at least makes H4 less broken.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/debug-leds.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm/plat-omap/debug-leds.c b/arch/arm/plat-omap/debug-leds.c
index 511d6a5..9128a80 100644
--- a/arch/arm/plat-omap/debug-leds.c
+++ b/arch/arm/plat-omap/debug-leds.c
@@ -39,12 +39,6 @@ static struct h2p2_dbg_fpga __iomem	*fpga;
 static u16				led_state, hw_led_state;
 
 
-#ifdef	CONFIG_LEDS
-#define old_led_api()	1
-#else
-#define old_led_api()	0
-#endif
-
 #ifdef	CONFIG_LEDS_OMAP_DEBUG
 #define new_led_api()	1
 #else
@@ -202,7 +196,8 @@ struct dbg_led {
 static struct dbg_led dbg_leds[] = {
 	/* REVISIT at least H2 uses different timer & cpu leds... */
 #ifndef CONFIG_LEDS_TIMER
-	{ .mask = 1 << 0,  .cdev.name =  "d4:green", },		/* timer */
+	{ .mask = 1 << 0,  .cdev.name =  "d4:green",
+		.cdev.default_trigger = "heartbeat", },
 #endif
 #ifndef CONFIG_LEDS_CPU
 	{ .mask = 1 << 1,  .cdev.name =  "d5:green", },		/* !idle */
@@ -274,10 +269,10 @@ static int /* __init */ fpga_probe(struct platform_device *pdev)
 	fpga = ioremap(iomem->start, H2P2_DBG_FPGA_SIZE);
 	__raw_writew(~0, &fpga->leds);
 
-	if (old_led_api()) {
-		leds_event = h2p2_dbg_leds_event;
-		leds_event(led_start);
-	}
+#ifdef	CONFIG_LEDS
+	leds_event = h2p2_dbg_leds_event;
+	leds_event(led_start);
+#endif
 
 	if (new_led_api()) {
 		newled_init(&pdev->dev);
-- 
1.4.4.2

