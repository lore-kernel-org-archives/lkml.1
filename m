Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYCIBrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYCIBrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 20:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYCIBpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 20:45:52 -0500
Received: from mail.queued.net ([207.210.101.209]:2730 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbYCIBpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 20:45:51 -0500
Date: Sat, 8 Mar 2008 20:49:27 -0500
From: Andres Salomon <dilinger@queued.net>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       info-linux@geode.amd.com, Jordan Crouse <jordan.crouse@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/6] PM/FB/gxfb: add config option that allows disabling of
 VT switch during suspend
Message-ID: <20080308204927.73afa56c@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is purely for suspend/resume time optimization.


>From 874aa20022a2501a30704163ed31a7baba7de9e5 Mon Sep 17 00:00:00 2001
From: Andres Salomon <dilinger@debian.org>
Date: Wed, 5 Mar 2008 16:40:25 -0500
Subject: [PATCH] PM: add config option that allows disabling of VT switch during suspend

Prior to suspend, we allocate and switch to a new VT; after suspend, we
switch back to the original VT.  This can be slow, and is completely
unnecessary if the framebuffer we're using can restore video properly.

This adds CONFIG_DISABLE_SUSPEND_VT_SWITCH which allows the user to
select whether or not to do that switch.  This has been tested with the
gxfb driver (on a Geode GX dev board and OLPC prototype machines).  In
order for the user to even see this option, a framebuffer has to declare
support for it (via CONFIG_FBDEV_SUPPORTS_NOSWITCH).

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/char/Kconfig        |   21 +++++++++++++++++++++
 drivers/video/geode/Kconfig |    1 +
 include/linux/suspend.h     |    2 +-
 kernel/power/console.c      |    2 +-
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 47c6be8..7fe0e85 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -58,6 +58,27 @@ config VT_CONSOLE
 
 	  If unsure, say Y.
 
+config FBDEV_SUPPORTS_NOSWITCH
+	bool
+	default n
+
+config DISABLE_SUSPEND_VT_SWITCH
+	bool "Disable the console switch prior to suspend (EXPERIMENTAL)"
+	depends on VT_CONSOLE && PM && EXPERIMENTAL && FBDEV_SUPPORTS_NOSWITCH
+	default n
+	---help---
+	  This option disables the automatic switch to VT console that happens
+	  prior to Linux going into a suspend/sleep.  Your
+	  video card/framebuffer must be able to properly restore the
+	  display (even if X is doing something crazy!) in this scenario.
+	  This is useful for saving precious milliseconds during suspend and
+	  resume; however, if your framebuffer lacks support, it could leave
+	  your display in a weird state.  If you're even seeing this option,
+	  it means at least one of your selected framebuffer drivers supports
+	  restoring the display.
+
+	  If unsure, say N.
+
 config HW_CONSOLE
 	bool
 	depends on VT && !S390 && !UML
diff --git a/drivers/video/geode/Kconfig b/drivers/video/geode/Kconfig
index c5d8ba4..1497fe4 100644
--- a/drivers/video/geode/Kconfig
+++ b/drivers/video/geode/Kconfig
@@ -29,6 +29,7 @@ config FB_GEODE_GX
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FBDEV_SUPPORTS_NOSWITCH
 	---help---
 	  Framebuffer driver for the display controller integrated into the
 	  AMD Geode GX processors.
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 1d7d4c5..46080f5 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -11,7 +11,7 @@
 #include <linux/mm.h>
 #include <asm/errno.h>
 
-#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE) && !defined(CONFIG_DISABLE_SUSPEND_VT_SWITCH)
 extern int pm_prepare_console(void);
 extern void pm_restore_console(void);
 #else
diff --git a/kernel/power/console.c b/kernel/power/console.c
index 89bcf49..dca98f5 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -9,7 +9,7 @@
 #include <linux/console.h>
 #include "power.h"
 
-#if defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
+#if defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE) && !defined(CONFIG_DISABLE_SUSPEND_VT_SWITCH)
 #define SUSPEND_CONSOLE	(MAX_NR_CONSOLES-1)
 
 static int orig_fgconsole, orig_kmsg;
-- 
1.5.3.7

