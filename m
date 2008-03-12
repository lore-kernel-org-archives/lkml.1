Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYCLUfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYCLUfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYCLUed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:34:33 -0400
Received: from zaphod.rfc1149.net ([88.191.14.223]:43261 "EHLO
	mail.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYCLUeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:34:31 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Samuel Tardieu <sam@rfc1149.net>
To: linux-kernel@vger.kernel.org, wim@iguana.be
Cc: P@draigBrady.com, Samuel Tardieu <sam@rfc1149.net>
Subject: [PATCH 3/3] watchdog: Add w83697h_wdt early_disable option
Date: Wed, 12 Mar 2008 14:28:03 +0100
Message-Id: <f47d032b598c9cbbfa060c8c56a2f482a8653bfe.1205328258.git.sam@rfc1149.net>
X-Mailer: git-send-email 1.5.4.3.611.g29c00.dirty
In-Reply-To: <e2b93eb1cff2f2dd926caf6d9d76b62054a8ae24.1205328258.git.sam@rfc1149.net>
References: <1205328483-3814-1-git-send-email-sam@rfc1149.net>
 <9b2269dbdb0d6674cc8dc79e5cb61f23bff86ae0.1205328258.git.sam@rfc1149.net>
 <e2b93eb1cff2f2dd926caf6d9d76b62054a8ae24.1205328258.git.sam@rfc1149.net>
In-Reply-To: <9b2269dbdb0d6674cc8dc79e5cb61f23bff86ae0.1205328258.git.sam@rfc1149.net>
References: <9b2269dbdb0d6674cc8dc79e5cb61f23bff86ae0.1205328258.git.sam@rfc1149.net>
Organisation: RFC1149 (see http://www.rfc1149.net/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pádraig Brady requested the possibility of not disabling the watchdog
at module load time or kernel boot time if it had been previously enabled
in the bios. It may help rebooting the machine if it freezes before the
userland daemon kicks in.

Signed-off-by: Samuel Tardieu <sam@rfc1149.net>
Cc: Pádraig Brady <P@draigBrady.com>
---
 drivers/watchdog/w83697hf_wdt.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index 2120702..528b882 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -44,6 +44,7 @@
 #define WATCHDOG_NAME "w83697hf/hg WDT"
 #define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
+#define WATCHDOG_EARLY_DISABLE 1	/* Disable until userland kicks in */
 
 static unsigned long wdt_is_open;
 static char expect_close;
@@ -62,6 +63,10 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" _
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+static int early_disable = WATCHDOG_EARLY_DISABLE;
+module_param(early_disable, int, 0);
+MODULE_PARM_DESC(early_disable, "Watchdog gets disabled at boot time (default=" __MODULE_STRING(WATCHDOG_EARLY_DISABLE) ")");
+
 /*
  *	Kernel methods.
  */
@@ -178,6 +183,22 @@ wdt_disable(void)
 	spin_unlock(&io_lock);
 }
 
+static unsigned char
+wdt_running(void)
+{
+	unsigned char t;
+
+	spin_lock(&io_lock);
+	w83697hf_select_wdt();
+
+	t = w83697hf_get_reg(0xF4);	/* Read timer */
+
+	w83697hf_deselect_wdt();
+	spin_unlock(&io_lock);
+
+	return t;
+}
+
 static int
 wdt_set_heartbeat(int t)
 {
@@ -394,7 +415,11 @@ wdt_init(void)
 	}
 
 	w83697hf_init();
-	wdt_disable();	/* Disable watchdog until first use */
+	if (early_disable) {
+		if (wdt_running())
+			printk (KERN_WARNING PFX "Stopping previously enabled watchdog until userland kicks in\n");
+		wdt_disable();
+	}
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-- 
1.5.4.3.611.g29c00.dirty

