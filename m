Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbZFBOrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbZFBOrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZFBOrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:47:32 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:41132 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbZFBOrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:47:32 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>
Subject: [PATCH] console: make blank timeout value a boot option
Date: Tue,  2 Jun 2009 16:46:33 +0200
Message-Id: <1243953993-18608-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The console blank timer is currently hardcoded to 10*60 seconds which is
ok for most applications but might be annoying when using the console
for debugging and no userspace application was started to manually
change this default behaviour.

This patch defines a core_param for the variable in charge which allows
users to entirely disable the blank feature by setting it 0.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
 Documentation/kernel-parameters.txt |    4 ++++
 drivers/char/vt.c                   |   13 +++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e87bdbf..67331e8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -545,6 +545,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			console=brl,ttyS0
 		For now, only VisioBraille is supported.
 
+	consoleblank=	[KNL] The console blank (screen saver) timeout in
+			seconds. Defaults to 10*60 = 10mins. A value of 0
+			disables the blank timer.
+
 	coredump_filter=
 			[KNL] Change the default value for
 			/proc/<pid>/coredump_filter.
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 08151d4..85efe81 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -172,8 +172,9 @@ int do_poke_blanked_console;
 int console_blanked;
 
 static int vesa_blank_mode; /* 0:none 1:suspendV 2:suspendH 3:powerdown */
-static int blankinterval = 10*60*HZ;
 static int vesa_off_interval;
+static int blankinterval = 10*60;
+core_param(consoleblank, blankinterval, int, 0444);
 
 static DECLARE_WORK(console_work, console_callback);
 
@@ -1486,7 +1487,7 @@ static void setterm_command(struct vc_data *vc)
 			update_attr(vc);
 			break;
 		case 9:	/* set blanking interval */
-			blankinterval = ((vc->vc_par[1] < 60) ? vc->vc_par[1] : 60) * 60 * HZ;
+			blankinterval = ((vc->vc_par[1] < 60) ? vc->vc_par[1] : 60) * 60;
 			poke_blanked_console();
 			break;
 		case 10: /* set bell frequency in Hz */
@@ -2872,7 +2873,7 @@ static int __init con_init(void)
 
 	if (blankinterval) {
 		blank_state = blank_normal_wait;
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 	}
 
 	/*
@@ -3681,7 +3682,7 @@ void do_unblank_screen(int leaving_gfx)
 		return; /* but leave console_blanked != 0 */
 
 	if (blankinterval) {
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 		blank_state = blank_normal_wait;
 	}
 
@@ -3715,7 +3716,7 @@ void unblank_screen(void)
 static void blank_screen_t(unsigned long dummy)
 {
 	if (unlikely(!keventd_up())) {
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 		return;
 	}
 	blank_timer_expired = 1;
@@ -3745,7 +3746,7 @@ void poke_blanked_console(void)
 	if (console_blanked)
 		unblank_screen();
 	else if (blankinterval) {
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 		blank_state = blank_normal_wait;
 	}
 }
-- 
1.6.3.1

