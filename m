Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616Ab0AYUEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0AYUEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468Ab0AYUEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:04:38 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:57644 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932131Ab0AYUEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:04:36 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIeHXUtbsswT/2dsb2JhbADbFAmEMAQ
Date: Mon, 25 Jan 2010 21:04:33 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Denis Turischev <denis@compulab.co.il>, Peter Huewe <PeterHuewe@gmx.de>
Subject: [WATCHDOG] v2.6.33-rc5 fixes
Message-ID: <20100125200433.GT3804@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig          |    4 ++--
 drivers/watchdog/ixp2000_wdt.c    |    1 +
 drivers/watchdog/sbc_fitpc2_wdt.c |   11 +++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

with these Changes:

Author: Denis Turischev <denis@compulab.co.il>
Date:   Thu Jan 21 16:10:07 2010 +0200

    [WATCHDOG] sbc_fitpc2_wdt: fix I/O space access technique.
    
    The mdelay function was used between I/O access commands, that causes peak
    in CPU usage. Fix it by substitution mdelay to msleep.
    
    Expand usage on fitPC2 compatible boards according to DMI identification.
    
    Signed-off-by: Denis Turischev <denis@compulab.co.il>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Peter Huewe <PeterHuewe@gmx.de>
Date:   Thu Jan 7 03:35:49 2010 +0100

    [WATCHDOG] ixp2000: Fix build failure caused by missing include
    
    This patch fixes a build failure[1] caused by the missing include of
    timer.h and thus fixes the build failure.
    
    Notably the build failure existed since October 2009! [2]
    
    References:
    [1] http://kisskb.ellerman.id.au/kisskb/buildresult/1983339/
    [2] http://kisskb.ellerman.id.au/kisskb/buildresult/1351737/
    
    Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 088f32f..050ee14 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -396,8 +396,8 @@ config SBC_FITPC2_WATCHDOG
 	tristate "Compulab SBC-FITPC2 watchdog"
 	depends on X86
 	---help---
-	  This is the driver for the built-in watchdog timer on the fit-PC2
-	  Single-board computer made by Compulab.
+	  This is the driver for the built-in watchdog timer on the fit-PC2,
+	  fit-PC2i, CM-iAM single-board computers made by Compulab.
 
 	  It`s possible to enable watchdog timer either from BIOS (F2) or from booted Linux.
 	  When "Watchdog Timer Value" enabled one can set 31-255 s operational range.
diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
index 4f4b35a..3c79dc5 100644
--- a/drivers/watchdog/ixp2000_wdt.c
+++ b/drivers/watchdog/ixp2000_wdt.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
+#include <linux/timer.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index 91430a8..e6763d2 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -46,9 +46,9 @@ static DEFINE_SPINLOCK(wdt_lock);
 static void wdt_send_data(unsigned char command, unsigned char data)
 {
 	outb(command, COMMAND_PORT);
-	mdelay(100);
+	msleep(100);
 	outb(data, DATA_PORT);
-	mdelay(200);
+	msleep(200);
 }
 
 static void wdt_enable(void)
@@ -202,11 +202,10 @@ static int __init fitpc2_wdt_init(void)
 {
 	int err;
 
-	if (strcmp("SBC-FITPC2", dmi_get_system_info(DMI_BOARD_NAME))) {
-		pr_info("board name is: %s. Should be SBC-FITPC2\n",
-			dmi_get_system_info(DMI_BOARD_NAME));
+	if (!strstr(dmi_get_system_info(DMI_BOARD_NAME), "SBC-FITPC2"))
 		return -ENODEV;
-	}
+
+	pr_info("%s found\n", dmi_get_system_info(DMI_BOARD_NAME));
 
 	if (!request_region(COMMAND_PORT, 1, WATCHDOG_NAME)) {
 		pr_err("I/O address 0x%04x already in use\n", COMMAND_PORT);
