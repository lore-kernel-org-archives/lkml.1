Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZI1XWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZI1XWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 19:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZI1XWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 19:22:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:44348 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753456AbZI1XWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 19:22:39 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19CsacK1NpCwVhoHXrvI3I5fay7wwX8ei6h/7yLxK
	4jjnc1F3cEWBGq
From: Peter Huewe <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] staging/panel: prevent driver from calling misc_deregister twice on same ressource
Date: Tue, 29 Sep 2009 01:22:40 +0200
User-Agent: KMail/1.9.10
Cc: Willy Tarreau <w@1wt.eu>, Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       Costantino Leandro <lcostantino@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909290122.40485.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch prevents the driver from calling misc_deregister twice on the same
ressouce when unloading the driver.
Unloading the driver without this patch results in a Kernel BUG like this:
Panel driver version 0.9.5 registered on parport0 (io=0x378).
BUG: unable to handle kernel paging request at 0000000000100108
IP: [<ffffffff803c02ee>] misc_deregister+0x2d/0x90
PGD 6caff067 PUD 762b7067 PMD 0
Oops: 0002 [#1] PREEMPT SMP
last sysfs file: /sys/devices/platform/w83627hf.656/in8_input
...

This patch fixes this issue, although maybe not in the best way possible :)

linux version v2.6.32-rc1 - linus git tree, Di 29. Sep 01:10:18 CEST 2009

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
old mode 100644
new mode 100755
index dd7d3fd..4ce399b
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -2071,11 +2071,15 @@ static void panel_detach(struct parport *port)
 		return;
 	}
 
-	if (keypad_enabled && keypad_initialized)
+	if (keypad_enabled && keypad_initialized) {
 		misc_deregister(&keypad_dev);
+		keypad_initialized = 0;
+	}
 
-	if (lcd_enabled && lcd_initialized)
+	if (lcd_enabled && lcd_initialized) {
 		misc_deregister(&lcd_dev);
+		lcd_initialized = 0;
+	}
 
 	parport_release(pprt);
 	parport_unregister_device(pprt);
@@ -2211,13 +2215,16 @@ static void __exit panel_cleanup_module(void)
 		del_timer(&scan_timer);
 
 	if (pprt != NULL) {
-		if (keypad_enabled)
+		if (keypad_enabled) {
 			misc_deregister(&keypad_dev);
+			keypad_initialized = 0;
+		}
 
 		if (lcd_enabled) {
 			panel_lcd_print("\x0cLCD driver " PANEL_VERSION
 					"\nunloaded.\x1b[Lc\x1b[Lb\x1b[L-");
 			misc_deregister(&lcd_dev);
+			lcd_initialized = 0;
 		}
 
 		/* TODO: free all input signals */
