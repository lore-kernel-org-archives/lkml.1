Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbZLYXos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbZLYXos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 18:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZLYXor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 18:44:47 -0500
Received: from lixom.net ([66.141.50.11]:49692 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbZLYXoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 18:44:46 -0500
Date: Fri, 25 Dec 2009 17:49:58 -0600
From: Olof Johansson <olof@lixom.net>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       Emese Revfy <re.emese@gmail.com>
Subject: [PATCH] [REGRESSION] fix compilation of omap1_bl
Message-ID: <20091225234958.GA20440@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

9905a43b2d563e6f89e4c63c4278ada03f2ebb14 broke omap1_bl, since it assigns the
check_fb function based on platform data information:

drivers/video/backlight/omap1_bl.c: In function 'omapbl_probe':
drivers/video/backlight/omap1_bl.c:142: error: assignment of read-only variable 'omapbl_ops'

De-constify the function pointer (and the struct).


Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index 409ca96..8693e5f 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -125,7 +125,7 @@ static int omapbl_get_intensity(struct backlight_device *dev)
 	return bl->current_intensity;
 }
 
-static const struct backlight_ops omapbl_ops = {
+static struct backlight_ops omapbl_ops = {
 	.get_brightness = omapbl_get_intensity,
 	.update_status  = omapbl_update_status,
 };
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 8c4f884..76c4d65 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -47,7 +47,7 @@ struct backlight_ops {
 	int (* const get_brightness)(struct backlight_device *);
 	/* Check if given framebuffer device is the one bound to this backlight;
 	   return 0 if not, !=0 if it is. If NULL, backlight always matches the fb. */
-	int (* const check_fb)(struct fb_info *);
+	int (*check_fb)(struct fb_info *);
 };
 
 /* This structure defines all the properties of a backlight */
