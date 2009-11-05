Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZKEJSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZKEJSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 04:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZKEJSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 04:18:07 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:50188 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZKEJSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 04:18:05 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH] fbcon: make cursor display conditional
Date: Thu,  5 Nov 2009 10:17:38 +0100
Message-Id: <1257412658-9444-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For embedded systems, the blinking cursor at startup time can be
annoying and unintended. Add a new kernel parameter
'fbcon_disable_cursor' which disables it conditionally. The default
behaviour is unchanged.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrea Righi <righi.andrea@gmail.com>
---
 Documentation/kernel-parameters.txt |    3 +++
 drivers/video/console/fbcon.c       |   11 ++++++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9107b38..80ac54e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -743,6 +743,9 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format: <interval>,<probability>,<space>,<times>
 			See also /Documentation/fault-injection/.
 
+	fbcon_disable_cursor
+			Disable the cursor in the framebuffer console
+
 	fd_mcs=		[HW,SCSI]
 			See header of drivers/scsi/fd_mcs.c.
 
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 5a686ce..039aa86 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -116,6 +116,14 @@ static int fbcon_has_exited;
 static int primary_device = -1;
 static int fbcon_has_console_bind;
 
+static int fbcon_disable_cursor;
+static int __init _fbcon_disable_cursor(char *str)
+{
+	fbcon_disable_cursor = 1;
+	return 1;
+}
+__setup("fbcon_disable_cursor", _fbcon_disable_cursor);
+
 #ifdef CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
 static int map_override;
 
@@ -1288,7 +1296,8 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
 	int y;
  	int c = scr_readw((u16 *) vc->vc_pos);
 
-	if (fbcon_is_inactive(vc, info) || vc->vc_deccm != 1)
+	if (fbcon_is_inactive(vc, info) || vc->vc_deccm != 1 ||
+	    fbcon_disable_cursor)
 		return;
 
 	if (vc->vc_cursor_type & 0x10)
-- 
1.6.5

