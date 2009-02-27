Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbZB0WwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbZB0WwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbZB0WvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:51:22 -0500
Received: from kroah.org ([198.145.64.141]:53520 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758591AbZB0WvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:51:21 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Costantino Leandro <lcostantino@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/5] Staging: panel: fix oops on panel_cleanup_module
Date: Fri, 27 Feb 2009 14:49:20 -0800
Message-Id: <1235774963-19732-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <20090227224555.GB19545@kroah.com>
References: <20090227224555.GB19545@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Costantino Leandro <lcostantino@gmail.com>

Check for null pardevice (not registered, ej: panel never attached,
inexistent parport, etc. )  before calling parport_release,
parport_unregister_device, and related funcs on module release.

Signed-off-by: Costantino Leandro <lcostantino@gmail.com>
Acked-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/panel/panel.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index ab69c1b..c2747bc 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -2164,19 +2164,20 @@ static void __exit panel_cleanup_module(void)
 	if (scan_timer.function != NULL)
 		del_timer(&scan_timer);
 
-	if (keypad_enabled)
-		misc_deregister(&keypad_dev);
+	if (pprt != NULL) {
+		if (keypad_enabled)
+			misc_deregister(&keypad_dev);
+
+		if (lcd_enabled) {
+			panel_lcd_print("\x0cLCD driver " PANEL_VERSION
+					"\nunloaded.\x1b[Lc\x1b[Lb\x1b[L-");
+			misc_deregister(&lcd_dev);
+		}
 
-	if (lcd_enabled) {
-		panel_lcd_print("\x0cLCD driver " PANEL_VERSION
-				"\nunloaded.\x1b[Lc\x1b[Lb\x1b[L-");
-		misc_deregister(&lcd_dev);
+		/* TODO: free all input signals */
+		parport_release(pprt);
+		parport_unregister_device(pprt);
 	}
-
-	/* TODO: free all input signals */
-
-	parport_release(pprt);
-	parport_unregister_device(pprt);
 	parport_unregister_driver(&panel_driver);
 }
 
-- 
1.6.0.2

