Return-Path: <linux-kernel-owner+w=401wt.eu-S965912AbXDIVYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965912AbXDIVYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965933AbXDIVYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:24:33 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:27434 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965854AbXDIVYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:24:04 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 16/18] ARM: OMAP: partial LED fixes
Date: Mon,  9 Apr 2007 17:22:21 -0400
Message-Id: <1176153804679-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761538013111-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com> <11761537491968-git-send-email-tony@atomide.com> <11761537522665-git-send-email-tony@atomide.com> <11761537563620-git-send-email-tony@atomide.com> <11761537613625-git-send-email-tony@atomide.com> <11761537672719-git-send-email-tony@atomide.com> <1176153771729-git-send-email-tony@atomide.com> <11761537743905-git-send-email-tony@atomide.com> <1176153781321-git-send-email-tony@atomide.com> <1176153783637-git-send-email-tony@atomide.com> <11761537863183-git-send-email-tony@atomide.com> <117615378995-git-send-email-tony@atomide.com> <11761537921036-git-send-email-tony@atomide.com> <11761537971468-git-send-email-tony@atomide.com> <11761538013111-git-send-email-tony@atomide.com>
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

