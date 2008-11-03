Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbYKCHHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbYKCHHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 02:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYKCHG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 02:06:58 -0500
Received: from home.keithp.com ([63.227.221.253]:40572 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbYKCHG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 02:06:57 -0500
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>
Subject: [PATCH] [drivers/video/fb] Eliminate recursive mutex in compat fb ioctl path
Date: Sun,  2 Nov 2008 23:06:50 -0800
Message-Id: <1225696010-6574-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fb_compat_ioctl grabbed the fb mutex and then called fb_ioctl, which also
grabs the same mutex. I traced through all existing fb_compat_ioctl
functions in the various fb drivers and found that they also transform their
arguments and call the native fb_ioctl function. So, it is correct to just
remove the mutex_lock/mutex_unlock pair in the top-level compat path.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/video/fbmem.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index cd5f20d..548cf26 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1253,7 +1253,6 @@ fb_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct fb_ops *fb = info->fbops;
 	long ret = -ENOIOCTLCMD;
 
-	mutex_lock(&info->lock);
 	switch(cmd) {
 	case FBIOGET_VSCREENINFO:
 	case FBIOPUT_VSCREENINFO:
@@ -1279,7 +1278,6 @@ fb_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			ret = fb->fb_compat_ioctl(info, cmd, arg);
 		break;
 	}
-	mutex_unlock(&info->lock);
 	return ret;
 }
 #endif
-- 
1.5.6.5

