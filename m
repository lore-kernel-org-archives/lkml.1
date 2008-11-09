Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYKITeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYKITeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbYKITeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:34:10 -0500
Received: from ppp-111-41.adsl.restena.lu ([158.64.111.41]:45529 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755643AbYKITeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:34:09 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Nov 2008 14:34:09 EST
Date: Sun, 9 Nov 2008 20:25:37 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: JosephChan@via.com.tw, Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix crash in viafb due to 4k stack overflow
Message-ID: <20081109202537.33ead0a2@neptune.home>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function viafb_cursor() uses 2 stack-variables of CURSOR_SIZE bits;
CURSOR_SIZE is defined as (8 * 1024). Using up twice 1k on stack is too much
for 4k-stack (though it works with 8k-stacks).

Make those two variables kzalloc'ed to preserve stack space.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>

---
--- linux-2.6.28-rc3.orig/drviers/video/via/viafbdev.c	2008-11-09 19:22:15.000000000 +0100
+++ linux-2.6.28-rc3/drivers/video/via/viafbdev.c	2008-11-09 19:36:15.000000000 +0100
@@ -1052,10 +1052,8 @@ static void viafb_imageblit(struct fb_in
 
 static int viafb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 {
-	u8 data[CURSOR_SIZE / 8];
-	u32 data_bak[CURSOR_SIZE / 32];
 	u32 temp, xx, yy, bg_col = 0, fg_col = 0;
-	int size, i, j = 0;
+	int i, j = 0;
 	static int hw_cursor;
 	struct viafb_par *p_viafb_par;
 
@@ -1178,10 +1176,15 @@ static int viafb_cursor(struct fb_info *
 	}
 
 	if (cursor->set & FB_CUR_SETSHAPE) {
-		size =
+		u8 *data = kzalloc(CURSOR_SIZE / 8, GFP_KERNEL);
+		u32 *data_bak = kzalloc(CURSOR_SIZE / 32, GFP_KERNEL);
+		int size =
 		    ((viacursor.image.width + 7) >> 3) *
 		    viacursor.image.height;
 
+		if (data == NULL || data_bak == NULL)
+			goto out;
+
 		if (MAX_CURS == 32) {
 			for (i = 0; i < (CURSOR_SIZE / 32); i++) {
 				data_bak[i] = 0x0;
@@ -1231,6 +1234,9 @@ static int viafb_cursor(struct fb_info *
 		memcpy(((struct viafb_par *)(info->par))->fbmem_virt +
 		       ((struct viafb_par *)(info->par))->cursor_start,
 		       data_bak, CURSOR_SIZE);
+out:
+		kfree(data);
+		kfree(data_bak);
 	}
 
 	if (viacursor.enable)
