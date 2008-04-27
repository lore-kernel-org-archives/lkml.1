Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbYD0Kqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbYD0Kqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 06:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYD0Kq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 06:46:27 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:50500 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbYD0Kq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 06:46:26 -0400
Date: Sun, 27 Apr 2008 12:46:22 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/video/pnx4008: eliminate double free
Message-ID: <Pine.LNX.4.64.0804271245510.7217@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The function framebuffer_release just calls kfree, so calling kfree
subsequently on the same argument represents a double free.  The
comments with the definition of framebuffer_release
in drivers/video/fbsysfs.c suggest that a more elaborate definition of this
function is planned, such that the splitting up of framebuffer_release and
kfree as done in the second instance might someday make sense, but it does
not make sense now. 

This was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
@@

* kfree(E);
...
* framebuffer_release(E);

@@
expression E;
@@

* framebuffer_release(E);
...
* kfree(E);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/video/pnx4008/pnxrgbfb.c b/drivers/video/pnx4008/pnxrgbfb.c
--- a/drivers/video/pnx4008/pnxrgbfb.c	2008-04-07 13:50:27.000000000 +0200
+++ b/drivers/video/pnx4008/pnxrgbfb.c	2008-04-27 12:25:52.000000000 +0200
@@ -100,7 +100,6 @@ static int rgbfb_remove(struct platform_
 		fb_dealloc_cmap(&info->cmap);
 		framebuffer_release(info);
 		platform_set_drvdata(pdev, NULL);
-		kfree(info);
 	}
 
 	pnx4008_free_dum_channel(channel_owned, pdev->id);
@@ -168,23 +167,21 @@ static int __devinit rgbfb_probe(struct 
 
 	ret = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (ret < 0)
-		goto err2;
+		goto err1;
 
 	ret = register_framebuffer(info);
 	if (ret < 0)
-		goto err3;
+		goto err2;
 	platform_set_drvdata(pdev, info);
 
 	return 0;
 
-err3:
-	fb_dealloc_cmap(&info->cmap);
 err2:
-	framebuffer_release(info);
+	fb_dealloc_cmap(&info->cmap);
 err1:
 	pnx4008_free_dum_channel(channel_owned, pdev->id);
 err0:
-	kfree(info);
+	framebuffer_release(info);
 err:
 	return ret;
 }
