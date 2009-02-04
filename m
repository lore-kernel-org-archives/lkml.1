Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbZBDVqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbZBDVqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZBDVq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:46:29 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:62388 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZBDVq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:46:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hpDJpDDXrx03TjuITHHtopGh9p7QukL75CNwHK1OjBkvvJawgOZVTfDPPSojXT34e4
         cNnAc7pjRoHLmMOhA+3VTtMA7oVlGeDHkik/ZlbHLHfIP1uW3RJnjX7BQlf8w+fEMSk0
         PHtTsc5OFgV3OXJ0gpSOXp/XW3qe0eCugSaQ0=
From: Andrea Righi <righi.andrea@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Johannes Weiner <hannes@cmpxchg.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH -mmotm] fbmem: fix fb_info->lock and mm->mmap_sem circular locking dependency
Date: Wed,  4 Feb 2009 22:46:23 +0100
Message-Id: <1233783983-28802-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <498817E2.3020008@gmail.com>
References: <498817E2.3020008@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this circular locking dependencies in the frame buffer console
driver pushing down the mutex fb_info->lock.

Circular locking dependecies occur calling the blocking
fb_notifier_call_chain() with fb_info->lock held. Notifier callbacks can
try to acquire mm->mmap_sem, while fb_mmap() acquires the locks in the
reverse order mm->mmap_sem => fb_info->lock.

Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>
Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 drivers/video/backlight/backlight.c |    3 +
 drivers/video/backlight/lcd.c       |    3 +
 drivers/video/console/fbcon.c       |   73 ++++++++++++++++++++++++++++++-----
 drivers/video/fbmem.c               |   11 +-----
 4 files changed, 70 insertions(+), 20 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 157057c..dd37cbc 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -35,6 +35,8 @@ static int fb_notifier_callback(struct notifier_block *self,
 		return 0;
 
 	bd = container_of(self, struct backlight_device, fb_notif);
+	if (!lock_fb_info(evdata->info))
+		return -ENODEV;
 	mutex_lock(&bd->ops_lock);
 	if (bd->ops)
 		if (!bd->ops->check_fb ||
@@ -47,6 +49,7 @@ static int fb_notifier_callback(struct notifier_block *self,
 			backlight_update_status(bd);
 		}
 	mutex_unlock(&bd->ops_lock);
+	unlock_fb_info(evdata->info);
 	return 0;
 }
 
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index b644947..0bb13df 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -40,6 +40,8 @@ static int fb_notifier_callback(struct notifier_block *self,
 	if (!ld->ops)
 		return 0;
 
+	if (!lock_fb_info(evdata->info))
+		return -ENODEV;
 	mutex_lock(&ld->ops_lock);
 	if (!ld->ops->check_fb || ld->ops->check_fb(ld, evdata->info)) {
 		if (event == FB_EVENT_BLANK) {
@@ -51,6 +53,7 @@ static int fb_notifier_callback(struct notifier_block *self,
 		}
 	}
 	mutex_unlock(&ld->ops_lock);
+	unlock_fb_info(evdata->info);
 	return 0;
 }
 
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 1657b96..2cd500a 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -2954,8 +2954,11 @@ static int fbcon_fb_unbind(int idx)
 
 static int fbcon_fb_unregistered(struct fb_info *info)
 {
-	int i, idx = info->node;
+	int i, idx;
 
+	if (!lock_fb_info(info))
+		return -ENODEV;
+	idx = info->node;
 	for (i = first_fb_vc; i <= last_fb_vc; i++) {
 		if (con2fb_map[i] == idx)
 			con2fb_map[i] = -1;
@@ -2979,13 +2982,14 @@ static int fbcon_fb_unregistered(struct fb_info *info)
 		}
 	}
 
-	if (!num_registered_fb)
-		unregister_con_driver(&fb_con);
-
-
 	if (primary_device == idx)
 		primary_device = -1;
 
+	unlock_fb_info(info);
+
+	if (!num_registered_fb)
+		unregister_con_driver(&fb_con);
+
 	return 0;
 }
 
@@ -3021,9 +3025,13 @@ static inline void fbcon_select_primary(struct fb_info *info)
 
 static int fbcon_fb_registered(struct fb_info *info)
 {
-	int ret = 0, i, idx = info->node;
+	int ret = 0, i, idx;
 
+	if (!lock_fb_info(info))
+		return -ENODEV;
+	idx = info->node;
 	fbcon_select_primary(info);
+	unlock_fb_info(info);
 
 	if (info_idx == -1) {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
@@ -3124,7 +3132,7 @@ static void fbcon_get_requirement(struct fb_info *info,
 	}
 }
 
-static int fbcon_event_notify(struct notifier_block *self, 
+static int fbcon_event_notify(struct notifier_block *self,
 			      unsigned long action, void *data)
 {
 	struct fb_event *event = data;
@@ -3132,7 +3140,7 @@ static int fbcon_event_notify(struct notifier_block *self,
 	struct fb_videomode *mode;
 	struct fb_con2fbmap *con2fb;
 	struct fb_blit_caps *caps;
-	int ret = 0;
+	int idx, ret = 0;
 
 	/*
 	 * ignore all events except driver registration and deregistration
@@ -3144,23 +3152,54 @@ static int fbcon_event_notify(struct notifier_block *self,
 
 	switch(action) {
 	case FB_EVENT_SUSPEND:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_suspended(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_RESUME:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_resumed(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_CHANGE:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_modechanged(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_CHANGE_ALL:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_set_all_vcs(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_DELETE:
 		mode = event->data;
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		ret = fbcon_mode_deleted(info, mode);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_FB_UNBIND:
-		ret = fbcon_fb_unbind(info->node);
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
+		idx = info->node;
+		unlock_fb_info(info);
+		ret = fbcon_fb_unbind(idx);
 		break;
 	case FB_EVENT_FB_REGISTERED:
 		ret = fbcon_fb_registered(info);
@@ -3178,17 +3217,31 @@ static int fbcon_event_notify(struct notifier_block *self,
 		con2fb->framebuffer = con2fb_map[con2fb->console - 1];
 		break;
 	case FB_EVENT_BLANK:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_fb_blanked(info, *(int *)event->data);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_NEW_MODELIST:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_new_modelist(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_GET_REQ:
 		caps = event->data;
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_get_requirement(info, caps);
+		unlock_fb_info(info);
 		break;
 	}
-
 done:
 	return ret;
 }
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index cfd9dce..b64f061 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1086,13 +1086,8 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			return -EINVAL;
 		con2fb.framebuffer = -1;
 		event.data = &con2fb;
-
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		event.info = info;
 		fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP, &event);
-		unlock_fb_info(info);
-
 		ret = copy_to_user(argp, &con2fb, sizeof(con2fb)) ? -EFAULT : 0;
 		break;
 	case FBIOPUT_CON2FBMAP:
@@ -1109,12 +1104,8 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			break;
 		}
 		event.data = &con2fb;
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		event.info = info;
-		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP,
-					      &event);
-		unlock_fb_info(info);
+		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP, &event);
 		break;
 	case FBIOBLANK:
 		if (!lock_fb_info(info))
-- 
1.5.6.3

