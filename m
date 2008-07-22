Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYGVFY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYGVFY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbYGVFWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:43040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649AbYGVFWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Antonino Daplas <adaplas@gmail.com>
Subject: [PATCH 10/79] device create: framebuffer: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:34 -0700
Message-Id: <1216703983-21448-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/video/console/fbcon.c |    3 ++-
 drivers/video/fbmem.c         |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 97aff8d..4be3b46 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -3586,7 +3586,8 @@ static int __init fb_console_init(void)
 
 	acquire_console_sem();
 	fb_register_client(&fbcon_event_notifier);
-	fbcon_device = device_create(fb_class, NULL, MKDEV(0, 0), "fbcon");
+	fbcon_device = device_create_drvdata(fb_class, NULL, MKDEV(0, 0),
+					     NULL, "fbcon");
 
 	if (IS_ERR(fbcon_device)) {
 		printk(KERN_WARNING "Unable to create device "
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 33ebdb1..1cd5071 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1439,8 +1439,9 @@ register_framebuffer(struct fb_info *fb_info)
 			break;
 	fb_info->node = i;
 
-	fb_info->dev = device_create(fb_class, fb_info->device,
-				     MKDEV(FB_MAJOR, i), "fb%d", i);
+	fb_info->dev = device_create_drvdata(fb_class, fb_info->device,
+					     MKDEV(FB_MAJOR, i), NULL,
+					     "fb%d", i);
 	if (IS_ERR(fb_info->dev)) {
 		/* Not fatal */
 		printk(KERN_WARNING "Unable to create device for framebuffer %d; errno = %ld\n", i, PTR_ERR(fb_info->dev));
-- 
1.5.6.3

