Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab0BTXak (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 18:30:40 -0500
Received: from legolas.restena.lu ([158.64.1.34]:39965 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab0BTXa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 18:30:27 -0500
Date: Sun, 21 Feb 2010 00:20:01 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Richard Purdie <rpurdie@rpsys.net>,
       Thierry Reding <thierry.reding@avionic-design.de>,
       Emese Revfy <re.emese@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] backlight: Add backlight_device parameter to check_fb
Message-ID: <20100221002001.0a7e05a7@neptune.home>
In-Reply-To: <20100221001049.2f63f5d6@neptune.home>
References: <20100221001049.2f63f5d6@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_fb from backlight_ops lacks a reference to the backlight_device
that's being referred to. Add this parameter so a backlight_device
can be mapped to a single framebuffer, especially if the same driver
handles multiple devices on a single system.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/video/backlight/adx_bl.c    |    2 +-
 drivers/video/backlight/backlight.c |    2 +-
 include/linux/backlight.h           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/adx_bl.c b/drivers/video/backlight/adx_bl.c
index d769b0b..a683dd1 100644
--- a/drivers/video/backlight/adx_bl.c
+++ b/drivers/video/backlight/adx_bl.c
@@ -56,7 +56,7 @@ static int adx_backlight_get_brightness(struct backlight_device *bldev)
 	return brightness & 0xff;
 }
 
-static int adx_backlight_check_fb(struct fb_info *fb)
+static int adx_backlight_check_fb(struct backlight_device *bldev, struct fb_info *fb)
 {
 	return 1;
 }
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 18829cf..b800cd4 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -38,7 +38,7 @@ static int fb_notifier_callback(struct notifier_block *self,
 	mutex_lock(&bd->ops_lock);
 	if (bd->ops)
 		if (!bd->ops->check_fb ||
-		    bd->ops->check_fb(evdata->info)) {
+		    bd->ops->check_fb(bd, evdata->info)) {
 			bd->props.fb_blank = *(int *)evdata->data;
 			if (bd->props.fb_blank == FB_BLANK_UNBLANK)
 				bd->props.state &= ~BL_CORE_FBBLANK;
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 8c4f884..15413ce 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -47,7 +47,7 @@ struct backlight_ops {
 	int (* const get_brightness)(struct backlight_device *);
 	/* Check if given framebuffer device is the one bound to this backlight;
 	   return 0 if not, !=0 if it is. If NULL, backlight always matches the fb. */
-	int (* const check_fb)(struct fb_info *);
+	int (* const check_fb)(struct backlight_device *, struct fb_info *);
 };
 
 /* This structure defines all the properties of a backlight */
-- 
1.6.4.4

