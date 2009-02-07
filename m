Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZBGRTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZBGRTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbZBGRSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:18:52 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43431 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbZBGRSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:18:51 -0500
Date: Sat, 7 Feb 2009 12:18:48 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com
Subject: [PATCH 13/15] amba-clcd: fix cmap memory leaks
Message-ID: <20090207121848.536b136d@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - fix cmap leak in removal path
 - fix cmap leak when register_framebuffer fails

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/amba-clcd.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
index 4e046fe..61050ab 100644
--- a/drivers/video/amba-clcd.c
+++ b/drivers/video/amba-clcd.c
@@ -408,7 +408,9 @@ static int clcdfb_register(struct clcd_fb *fb)
 	/*
 	 * Allocate colourmap.
 	 */
-	fb_alloc_cmap(&fb->fb.cmap, 256, 0);
+	ret = fb_alloc_cmap(&fb->fb.cmap, 256, 0);
+	if (ret)
+		goto unmap;
 
 	/*
 	 * Ensure interrupts are disabled.
@@ -426,6 +428,8 @@ static int clcdfb_register(struct clcd_fb *fb)
 
 	printk(KERN_ERR "CLCD: cannot register framebuffer (%d)\n", ret);
 
+	fb_dealloc_cmap(&fb->fb.cmap);
+ unmap:
 	iounmap(fb->regs);
  free_clk:
 	clk_put(fb->clk);
@@ -485,6 +489,8 @@ static int clcdfb_remove(struct amba_device *dev)
 
 	clcdfb_disable(fb);
 	unregister_framebuffer(&fb->fb);
+	if (fb->fb.cmap.len)
+		fb_dealloc_cmap(&fb->fb.cmap);
 	iounmap(fb->regs);
 	clk_put(fb->clk);
 
-- 
1.5.6.5

