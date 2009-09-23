Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZIWRhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZIWRhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZIWRhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:37:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41675 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbZIWRhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:37:17 -0400
Date: Wed, 23 Sep 2009 19:37:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>, Jason Wessel <jason.wessel@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: [origin tree boot hang] [PATCH] Revert "early_printk: Allow more
	than one early console"
Message-ID: <20090923173709.GA18056@elte.hu>
References: <20090923135539.GA6542@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923135539.GA6542@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>       early_printk: Allow more than one early console

this patch broke things pretty badly on x86, with pretty much any 
config, as long as the early console is used - which most of my 
test-systems do :-(

I'm getting an early boot hard lockup, which is due to an infinite 
stream of:

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] console [earlyser0] enabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuset
[ ... ]

i've reverted it via the patch below, as it clearly has unintended side 
effects.

	Ingo

>From 1070163596c13d3c34809c747c7800b3b06b158e Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 23 Sep 2009 19:31:04 +0200
Subject: [PATCH] Revert "early_printk: Allow more than one early console"

This reverts commit c9530948bc626c8b638015c0b32abb9615659ec6.
---
 arch/x86/kernel/early_printk.c |   65 +++++++++++++++++++--------------------
 1 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 2acfd3f..519a5e1 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -176,19 +176,10 @@ asmlinkage void early_printk(const char *fmt, ...)
 	va_end(ap);
 }
 
-static inline void early_console_register(struct console *con, int keep_early)
-{
-	early_console = con;
-	if (keep_early)
-		early_console->flags &= ~CON_BOOT;
-	else
-		early_console->flags |= CON_BOOT;
-	register_console(early_console);
-}
 
 static int __init setup_early_printk(char *buf)
 {
-	int keep;
+	int keep_early;
 
 	if (!buf)
 		return 0;
@@ -197,34 +188,42 @@ static int __init setup_early_printk(char *buf)
 		return 0;
 	early_console_initialized = 1;
 
-	keep = (strstr(buf, "keep") != NULL);
-
-	while (*buf != '\0') {
-		if (!strncmp(buf, "serial", 6)) {
-			early_serial_init(buf + 6);
-			early_console_register(&early_serial_console, keep);
-		}
-		if (!strncmp(buf, "ttyS", 4)) {
-			early_serial_init(buf + 4);
-			early_console_register(&early_serial_console, keep);
-		}
-		if (!strncmp(buf, "vga", 3) &&
-		    boot_params.screen_info.orig_video_isVGA == 1) {
-			max_xpos = boot_params.screen_info.orig_video_cols;
-			max_ypos = boot_params.screen_info.orig_video_lines;
-			current_ypos = boot_params.screen_info.orig_y;
-			early_console_register(&early_vga_console, keep);
-		}
+	keep_early = (strstr(buf, "keep") != NULL);
+
+	if (!strncmp(buf, "serial", 6)) {
+		early_serial_init(buf + 6);
+		early_console = &early_serial_console;
+	} else if (!strncmp(buf, "ttyS", 4)) {
+		early_serial_init(buf);
+		early_console = &early_serial_console;
+	} else if (!strncmp(buf, "vga", 3)
+		&& boot_params.screen_info.orig_video_isVGA == 1) {
+		max_xpos = boot_params.screen_info.orig_video_cols;
+		max_ypos = boot_params.screen_info.orig_video_lines;
+		current_ypos = boot_params.screen_info.orig_y;
+		early_console = &early_vga_console;
 #ifdef CONFIG_EARLY_PRINTK_DBGP
-		if (!strncmp(buf, "dbgp", 4) && !early_dbgp_init(buf + 4))
-			early_console_register(&early_dbgp_console, keep);
+	} else if (!strncmp(buf, "dbgp", 4)) {
+		if (early_dbgp_init(buf+4) < 0)
+			return 0;
+		early_console = &early_dbgp_console;
+		/*
+		 * usb subsys will reset ehci controller, so don't keep
+		 * that early console
+		 */
+		keep_early = 0;
 #endif
 #ifdef CONFIG_HVC_XEN
-		if (!strncmp(buf, "xen", 3))
-			early_console_register(&xenboot_console, keep);
+	} else if (!strncmp(buf, "xen", 3)) {
+		early_console = &xenboot_console;
 #endif
-		buf++;
 	}
+
+	if (keep_early)
+		early_console->flags &= ~CON_BOOT;
+	else
+		early_console->flags |= CON_BOOT;
+	register_console(early_console);
 	return 0;
 }
 
