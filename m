Return-Path: <linux-kernel-owner+w=401wt.eu-S1751355AbYCKW4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbYCKW4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 18:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbYCKW4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 18:56:25 -0400
Received: from mail.queued.net ([207.210.101.209]:1170 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbYCKW4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 18:56:24 -0400
Date: Tue, 11 Mar 2008 19:00:11 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 6/6] PM/gxfb: add hook to PM console layer that allows
 disabling of suspend VT switch
Message-ID: <20080311190011.44e24d2e@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Prior to suspend, we allocate and switch to a new VT; after suspend, we
switch back to the original VT.  This can be slow, and is completely
unnecessary if the framebuffer we're using can restore video properly.

This adds a hook that allows drivers to select whether or not to do this
vt switch, and changes the gxfb driver to call this hook.  It also
adds a module param to gxfb to allow controlling of the vt switch
(defaulting to no switch).

(Note: I'm not convinced that console_sem is the best way to protect this,
but we should probably have some form of locking..)

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 Documentation/fb/gxfb.txt       |    3 ++-
 drivers/video/geode/gxfb_core.c |    7 +++++++
 include/linux/suspend.h         |    2 ++
 kernel/power/console.c          |   27 ++++++++++++++++++++++++++-
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/Documentation/fb/gxfb.txt b/Documentation/fb/gxfb.txt
index 2d3dbaf..6749759 100644
--- a/Documentation/fb/gxfb.txt
+++ b/Documentation/fb/gxfb.txt
@@ -45,7 +45,8 @@ Accepted options:
 mode_option	- specify the video mode.  Of the form
 		  <x>x<y>[-<bpp>][@<refresh>]
 vram		- size of video ram (normally auto-detected)
-
+vt_switch	- enable vt switching during suspend/resume.  The vt
+		  switch is slow, but harmless.
 
 --
 Andres Salomon <dilinger@debian.org>
diff --git a/drivers/video/geode/gxfb_core.c b/drivers/video/geode/gxfb_core.c
index 0cebc49..988c8e4 100644
--- a/drivers/video/geode/gxfb_core.c
+++ b/drivers/video/geode/gxfb_core.c
@@ -29,6 +29,7 @@
 #include <linux/delay.h>
 #include <linux/fb.h>
 #include <linux/console.h>
+#include <linux/suspend.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <asm/geode.h>
@@ -37,6 +38,7 @@
 
 static char *mode_option;
 static int vram;
+static int vt_switch;
 
 /* Modes relevant to the GX (taken from modedb.c) */
 static const struct fb_videomode gx_modedb[] __initdata = {
@@ -388,6 +390,8 @@ static int __init gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	gxfb_check_var(&info->var, info);
 	gxfb_set_par(info);
 
+	pm_set_vt_switch(vt_switch);
+
 	if (register_framebuffer(info) < 0) {
 		ret = -EINVAL;
 		goto err;
@@ -508,5 +512,8 @@ MODULE_PARM_DESC(mode_option, "video mode (<x>x<y>[-<bpp>][@<refr>])");
 module_param(vram, int, 0);
 MODULE_PARM_DESC(vram, "video memory size");
 
+module_param(vt_switch, int, 0);
+MODULE_PARM_DESC(vt_switch, "enable VT switch during suspend/resume");
+
 MODULE_DESCRIPTION("Framebuffer driver for the AMD Geode GX");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 1d7d4c5..bef66a7 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -12,9 +12,11 @@
 #include <asm/errno.h>
 
 #if defined(CONFIG_PM_SLEEP) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
+extern void pm_set_vt_switch(int);
 extern int pm_prepare_console(void);
 extern void pm_restore_console(void);
 #else
+static inline void pm_set_vt_switch(int) {}
 static inline int pm_prepare_console(void) { return 0; }
 static inline void pm_restore_console(void) {}
 #endif
diff --git a/kernel/power/console.c b/kernel/power/console.c
index 89bcf49..b8628be 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -7,17 +7,39 @@
 #include <linux/vt_kern.h>
 #include <linux/kbd_kern.h>
 #include <linux/console.h>
+#include <linux/module.h>
 #include "power.h"
 
 #if defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
 #define SUSPEND_CONSOLE	(MAX_NR_CONSOLES-1)
 
 static int orig_fgconsole, orig_kmsg;
+static int disable_vt_switch;
+
+/*
+ * Normally during a suspend, we allocate a new console and switch to it.
+ * When we resume, we switch back to the original console.  This switch
+ * can be slow, so on systems where the framebuffer can handle restoration
+ * of video registers anyways, there's little point in doing the console
+ * switch.  This function allows you to disable it by passing it '0'.
+ */
+void pm_set_vt_switch(int do_switch)
+{
+	acquire_console_sem();
+	disable_vt_switch = !do_switch;
+	release_console_sem();
+}
+EXPORT_SYMBOL(pm_set_vt_switch);
 
 int pm_prepare_console(void)
 {
 	acquire_console_sem();
 
+	if (disable_vt_switch) {
+		release_console_sem();
+		return 0;
+	}
+
 	orig_fgconsole = fg_console;
 
 	if (vc_allocate(SUSPEND_CONSOLE)) {
@@ -50,9 +72,12 @@ int pm_prepare_console(void)
 void pm_restore_console(void)
 {
 	acquire_console_sem();
+	if (disable_vt_switch) {
+		release_console_sem();
+		return;
+	}
 	set_console(orig_fgconsole);
 	release_console_sem();
 	kmsg_redirect = orig_kmsg;
-	return;
 }
 #endif
-- 
1.5.3.7

