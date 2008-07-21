Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbYGUEmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbYGUEmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 00:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYGUEmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 00:42:44 -0400
Received: from www.swissdisk.com ([216.66.254.197]:47216 "EHLO
	swissweb.swissdisk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbYGUEmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 00:42:44 -0400
X-Greylist: delayed 2890 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2008 00:42:44 EDT
From: Ben Collins <ben.collins@canonical.com>
Date: Sun, 20 Jul 2008 21:48:28 -0400
Subject: [PATCH 6/7] pm: Config option to disable handling of console during suspend/resume
To: linux-kernel@vger.kernel.org
In-Reply-To: <24762.90.138.930.038.1036103001.ben.collins@canonical.com>
Message-Id: <E1KKl4J-00068V-6f@swissweb.swissdisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Config option allows userspace to handle console during suspend/resume
instead of the kernel.

Signed-off-by: Ben Collins <ben.collins@canonical.com>
---
 kernel/power/Kconfig   |   15 +++++++++++++++
 kernel/power/console.c |    4 ++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index b45da40..6855299 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -105,6 +105,21 @@ config SUSPEND_FREEZER
 
 	  Turning OFF this setting is NOT recommended! If in doubt, say Y.
 
+config PM_DISABLE_CONSOLE
+	bool "Disable Power Management messing with the active console"
+	depends on PM
+	default n
+	---help---
+	  By default, PM will take over the active console (generally, this means
+	  switching to the console when suspending from X). This can at times cause
+	  problems, especially if userspace suspend scripts try to do things with
+	  the console before or after suspending (e.g. calling vbestate).
+
+	  To work around this, enable this option so that PM will not handle the
+	  console.
+
+	  If unsure, say N.
+
 config HIBERNATION
 	bool "Hibernation (aka 'suspend to disk')"
 	depends on PM && SWAP && ARCH_HIBERNATION_POSSIBLE
diff --git a/kernel/power/console.c b/kernel/power/console.c
index b8628be..8b9706f 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -33,6 +33,7 @@ EXPORT_SYMBOL(pm_set_vt_switch);
 
 int pm_prepare_console(void)
 {
+#ifndef CONFIG_PM_DISABLE_CONSOLE
 	acquire_console_sem();
 
 	if (disable_vt_switch) {
@@ -66,11 +67,13 @@ int pm_prepare_console(void)
 	}
 	orig_kmsg = kmsg_redirect;
 	kmsg_redirect = SUSPEND_CONSOLE;
+#endif
 	return 0;
 }
 
 void pm_restore_console(void)
 {
+#ifndef CONFIG_PM_DISABLE_CONSOLE
 	acquire_console_sem();
 	if (disable_vt_switch) {
 		release_console_sem();
@@ -79,5 +82,6 @@ void pm_restore_console(void)
 	set_console(orig_fgconsole);
 	release_console_sem();
 	kmsg_redirect = orig_kmsg;
+#endif
 }
 #endif
-- 
1.5.4.3

