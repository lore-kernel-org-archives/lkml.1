Return-Path: <linux-kernel-owner+w=401wt.eu-S1030237AbXDIV2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237AbXDIV2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXDIV0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:26:47 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:29394 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965951AbXDIV01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:26:27 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6/6] ARM: OMAP: OSK led fixes
Date: Mon,  9 Apr 2007 17:25:44 -0400
Message-Id: <1176153966353-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761539621074-git-send-email-tony@atomide.com>
References: <1176153944991-git-send-email-tony@atomide.com> <1176153948771-git-send-email-tony@atomide.com> <11761539511877-git-send-email-tony@atomide.com> <11761539553166-git-send-email-tony@atomide.com> <11761539581152-git-send-email-tony@atomide.com> <11761539621074-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

Bugfixes for the OSK led support:

 - Fix Kconfig merge glitches:  Mistral handles idle and timer leds just fine
 - Fix pm_suspend() runtime botch:  can't sleep, so can't touch tps65010 leds

Improvements:
 - Switch sense of Mistral idle led, so idle == off

Probably the TPS65010 leds should be handled only by the "new led" API.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/Kconfig               |    7 +++++--
 arch/arm/mach-omap1/leds-osk.c |    6 +++---
 arch/arm/mach-omap1/pm.c       |   11 -----------
 3 files changed, 8 insertions(+), 16 deletions(-)

Index: linux-2.6/arch/arm/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/Kconfig	2007-04-09 16:39:05.000000000 -0400
+++ linux-2.6/arch/arm/Kconfig	2007-04-09 16:39:15.000000000 -0400
@@ -668,7 +668,8 @@ config LEDS
 
 config LEDS_TIMER
 	bool "Timer LED" if (!ARCH_CDB89712 && !ARCH_OMAP) || \
-			    MACH_OMAP_H2 || MACH_OMAP_PERSEUS2
+			    OMAP_OSK_MISTRAL || MACH_OMAP_H2 \
+			    || MACH_OMAP_PERSEUS2
 	depends on LEDS
 	default y if ARCH_EBSA110
 	help
@@ -684,7 +685,9 @@ config LEDS_TIMER
 
 config LEDS_CPU
 	bool "CPU usage LED" if (!ARCH_CDB89712 && !ARCH_EBSA110 && \
-			!ARCH_OMAP) || MACH_OMAP_H2 || MACH_OMAP_PERSEUS2
+			!ARCH_OMAP) \
+			|| OMAP_OSK_MISTRAL || MACH_OMAP_H2 \
+			|| MACH_OMAP_PERSEUS2
 	depends on LEDS
 	help
 	  If you say Y here, the red LED will be used to give a good real
Index: linux-2.6/arch/arm/mach-omap1/leds-osk.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/leds-osk.c	2007-04-09 16:38:12.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/leds-osk.c	2007-04-09 16:39:15.000000000 -0400
@@ -133,13 +133,13 @@ void osk_leds_event(led_event_t evt)
 		mistral_setled();
 		break;
 
-	case led_idle_start:
-		hw_led_state |= IDLE_LED;
+	case led_idle_start:	/* idle == off */
+		hw_led_state &= ~IDLE_LED;
 		mistral_setled();
 		break;
 
 	case led_idle_end:
-		hw_led_state &= ~IDLE_LED;
+		hw_led_state |= IDLE_LED;
 		mistral_setled();
 		break;
 
Index: linux-2.6/arch/arm/mach-omap1/pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/pm.c	2007-04-09 16:39:10.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/pm.c	2007-04-09 16:39:15.000000000 -0400
@@ -58,7 +58,6 @@
 #include <asm/arch/tc.h>
 #include <asm/arch/pm.h>
 #include <asm/arch/mux.h>
-#include <asm/arch/tps65010.h>
 #include <asm/arch/dma.h>
 #include <asm/arch/dsp_common.h>
 #include <asm/arch/dmtimer.h>
@@ -248,11 +247,6 @@ void omap_pm_suspend(void)
 
 	omap_serial_wake_trigger(1);
 
-	if (machine_is_omap_osk()) {
-		/* Stop LED1 (D9) blink */
-		tps65010_set_led(LED1, OFF);
-	}
-
 	if (!cpu_is_omap15xx())
 		omap_writew(0xffff, ULPD_SOFT_DISABLE_REQ_REG);
 
@@ -445,11 +439,6 @@ void omap_pm_suspend(void)
 	omap_serial_wake_trigger(0);
 
 	printk("PM: OMAP%x is re-starting from deep sleep...\n", system_rev);
-
-	if (machine_is_omap_osk()) {
-		/* Let LED1 (D9) blink again */
-		tps65010_set_led(LED1, BLINK);
-	}
 }
 
 #if defined(DEBUG) && defined(CONFIG_PROC_FS)
