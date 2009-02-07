Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZBGRS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZBGRS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZBGRSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:18:44 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43427 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665AbZBGRSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:18:43 -0500
Date: Sat, 7 Feb 2009 12:18:40 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com
Subject: [PATCH 12/15] 68328fb: fix cmap memory leaks
Message-ID: <20090207121840.5138cb3d@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - fix cmap leak in removal path
 - fix cmap leak when register_framebuffer fails
 - check return value of fb_alloc_cmap

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/68328fb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/video/68328fb.c b/drivers/video/68328fb.c
index 7f907fb..0b17824 100644
--- a/drivers/video/68328fb.c
+++ b/drivers/video/68328fb.c
@@ -471,9 +471,11 @@ int __init mc68x328fb_init(void)
 	fb_info.pseudo_palette = &mc68x328fb_pseudo_palette;
 	fb_info.flags = FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
 
-	fb_alloc_cmap(&fb_info.cmap, 256, 0);
+	if (fb_alloc_cmap(&fb_info.cmap, 256, 0))
+		return -ENOMEM;
 
 	if (register_framebuffer(&fb_info) < 0) {
+		fb_dealloc_cmap(&fb_info.cmap);
 		return -EINVAL;
 	}
 
@@ -494,6 +496,7 @@ module_init(mc68x328fb_init);
 static void __exit mc68x328fb_cleanup(void)
 {
 	unregister_framebuffer(&fb_info);
+	fb_dealloc_cmap(&fb_info.cmap);
 }
 
 module_exit(mc68x328fb_cleanup);
-- 
1.5.6.5

