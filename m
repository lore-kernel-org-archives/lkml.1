Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZHTUmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZHTUmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbZHTUmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:42:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:51244 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbZHTUmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:42:05 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 05/11] early_printk: Allow more than one early console
Date: Thu, 20 Aug 2009 15:39:52 -0500
Message-Id: <1250800798-31559-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1250800798-31559-5-git-send-email-jason.wessel@windriver.com>
References: <1250800798-31559-1-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-2-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-3-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-4-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 20 Aug 2009 20:40:37.0945 (UTC) FILETIME=[798C8290:01CA21D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is desirable to be able to use one early boot device to debug
another or to have multiple places you can see the early boot
diagnostics, such as the vga screen or serial device.

This patch changes the early_printk console device registration to
allow more than one early printk device to get registered via
register_console().

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/kernel/early_printk.c |   65 ++++++++++++++++++++-------------------
 1 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 519a5e1..2acfd3f 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -176,10 +176,19 @@ asmlinkage void early_printk(const char *fmt, ...)
 	va_end(ap);
 }
 
+static inline void early_console_register(struct console *con, int keep_early)
+{
+	early_console = con;
+	if (keep_early)
+		early_console->flags &= ~CON_BOOT;
+	else
+		early_console->flags |= CON_BOOT;
+	register_console(early_console);
+}
 
 static int __init setup_early_printk(char *buf)
 {
-	int keep_early;
+	int keep;
 
 	if (!buf)
 		return 0;
@@ -188,42 +197,34 @@ static int __init setup_early_printk(char *buf)
 		return 0;
 	early_console_initialized = 1;
 
-	keep_early = (strstr(buf, "keep") != NULL);
-
-	if (!strncmp(buf, "serial", 6)) {
-		early_serial_init(buf + 6);
-		early_console = &early_serial_console;
-	} else if (!strncmp(buf, "ttyS", 4)) {
-		early_serial_init(buf);
-		early_console = &early_serial_console;
-	} else if (!strncmp(buf, "vga", 3)
-		&& boot_params.screen_info.orig_video_isVGA == 1) {
-		max_xpos = boot_params.screen_info.orig_video_cols;
-		max_ypos = boot_params.screen_info.orig_video_lines;
-		current_ypos = boot_params.screen_info.orig_y;
-		early_console = &early_vga_console;
+	keep = (strstr(buf, "keep") != NULL);
+
+	while (*buf != '\0') {
+		if (!strncmp(buf, "serial", 6)) {
+			early_serial_init(buf + 6);
+			early_console_register(&early_serial_console, keep);
+		}
+		if (!strncmp(buf, "ttyS", 4)) {
+			early_serial_init(buf + 4);
+			early_console_register(&early_serial_console, keep);
+		}
+		if (!strncmp(buf, "vga", 3) &&
+		    boot_params.screen_info.orig_video_isVGA == 1) {
+			max_xpos = boot_params.screen_info.orig_video_cols;
+			max_ypos = boot_params.screen_info.orig_video_lines;
+			current_ypos = boot_params.screen_info.orig_y;
+			early_console_register(&early_vga_console, keep);
+		}
 #ifdef CONFIG_EARLY_PRINTK_DBGP
-	} else if (!strncmp(buf, "dbgp", 4)) {
-		if (early_dbgp_init(buf+4) < 0)
-			return 0;
-		early_console = &early_dbgp_console;
-		/*
-		 * usb subsys will reset ehci controller, so don't keep
-		 * that early console
-		 */
-		keep_early = 0;
+		if (!strncmp(buf, "dbgp", 4) && !early_dbgp_init(buf + 4))
+			early_console_register(&early_dbgp_console, keep);
 #endif
 #ifdef CONFIG_HVC_XEN
-	} else if (!strncmp(buf, "xen", 3)) {
-		early_console = &xenboot_console;
+		if (!strncmp(buf, "xen", 3))
+			early_console_register(&xenboot_console, keep);
 #endif
+		buf++;
 	}
-
-	if (keep_early)
-		early_console->flags &= ~CON_BOOT;
-	else
-		early_console->flags |= CON_BOOT;
-	register_console(early_console);
 	return 0;
 }
 
-- 
1.6.3.1.9.g95405b

