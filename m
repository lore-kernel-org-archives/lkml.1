Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbXBKAjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbXBKAjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 19:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXBKAjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 19:39:51 -0500
Received: from tim.rpsys.net ([194.106.48.114]:37270 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbXBKAju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 19:39:50 -0500
Subject: [PATCH RFC] backlight/fbcon: Add FB_EVENT_CONBLANK
From: Richard Purdie <rpurdie@rpsys.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fbdev-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Sun, 11 Feb 2007 00:39:39 +0000
Message-Id: <1171154379.5836.72.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've added this patch to the backlight git tree since it allows the
removal of a powermac specific hack to chipsfb_blank and fixes the
backlight class to work with drivers with no hardware blanking. Can
anyone see any problems with this? 


The backlight class wants notification whenever the console is blanked
but doesn't get this when hardware blanking fails and software blanking
is used. Changing FB_EVENT_BLANK to report both would be a behaviour
change which could confuse the console layer so add a new event for
software blanking and have the backlight class listen for both.

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>
---

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 4f987c4..5490b2a 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -28,7 +28,7 @@ static int fb_notifier_callback(struct notifier_block *self,
 	struct fb_event *evdata = data;
 
 	/* If we aren't interested in this event, skip it immediately ... */
-	if (event != FB_EVENT_BLANK)
+	if (event != FB_EVENT_BLANK && event != FB_EVENT_CONBLANK)
 		return 0;
 
 	bd = container_of(self, struct backlight_device, fb_notif);
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 31f476a..0b9954c 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -2234,6 +2234,8 @@ static int fbcon_switch(struct vc_data *vc)
 static void fbcon_generic_blank(struct vc_data *vc, struct fb_info *info,
 				int blank)
 {
+	struct fb_event event;
+
 	if (blank) {
 		unsigned short charmask = vc->vc_hi_font_mask ?
 			0x1ff : 0xff;
@@ -2244,6 +2246,11 @@ static void fbcon_generic_blank(struct vc_data *vc, struct fb_info *info,
 		fbcon_clear(vc, 0, 0, vc->vc_rows, vc->vc_cols);
 		vc->vc_video_erase_char = oldc;
 	}
+
+
+	event.info = info;
+	event.data = &blank;
+	fb_notifier_call_chain(FB_EVENT_CONBLANK, &event);
 }
 
 static int fbcon_blank(struct vc_data *vc, int blank, int mode_switch)
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 64177ec..8e197ce 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -509,13 +509,15 @@ struct fb_cursor_user {
 #define FB_EVENT_GET_CONSOLE_MAP        0x07
 /*      CONSOLE-SPECIFIC: set console to framebuffer mapping */
 #define FB_EVENT_SET_CONSOLE_MAP        0x08
-/*      A display blank is requested       */
+/*      A hardware display blank change occured */
 #define FB_EVENT_BLANK                  0x09
 /*      Private modelist is to be replaced */
 #define FB_EVENT_NEW_MODELIST           0x0A
 /*	The resolution of the passed in fb_info about to change and
         all vc's should be changed         */
 #define FB_EVENT_MODE_CHANGE_ALL	0x0B
+/*	A software display blank change occured */
+#define FB_EVENT_CONBLANK               0x0C
 
 struct fb_event {
 	struct fb_info *info;


