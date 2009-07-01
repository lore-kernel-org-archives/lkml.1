Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbZGAQ12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbZGAQ12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZGAQ1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:27:13 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:45364 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbZGAQ1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:27:11 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, <stable@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fb: move mutex_init to framebuffer_alloc()
Date: Wed,  1 Jul 2009 18:26:46 +0200
Message-Id: <1246465606-29346-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 537a1bf05, a per-fbinfo mutex was added and framebuffer drivers were
adopted accordingly. This new lock is currently initialized in
register_framebuffer().

The mx3fb driver takes this lock in mx3fb_map_video_memory() _before_
register_framebuffer() is called and hence crashes the system very
early.

Moving this mutex_init() to framebuffer_alloc() solves this and also
seems a lot more straight forward.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc:: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: <stable@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/fbmem.c   |    3 ---
 drivers/video/fbsysfs.c |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 53ea056..1d8d098 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1513,9 +1513,6 @@ register_framebuffer(struct fb_info *fb_info)
 		if (!registered_fb[i])
 			break;
 	fb_info->node = i;
-	mutex_init(&fb_info->lock);
-	mutex_init(&fb_info->mm_lock);
-
 	fb_info->dev = device_create(fb_class, fb_info->device,
 				     MKDEV(FB_MAJOR, i), NULL, "fb%d", i);
 	if (IS_ERR(fb_info->dev)) {
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index d4a2c11..60ddd1d 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -58,6 +58,9 @@ struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
 
 	info->device = dev;
 
+	mutex_init(&info->lock);
+	mutex_init(&info->mm_lock);
+
 #ifdef CONFIG_FB_BACKLIGHT
 	mutex_init(&info->bl_curve_mutex);
 #endif
-- 
1.6.3.1

