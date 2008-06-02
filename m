Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYFBQjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYFBQjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYFBQjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:39:10 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:14253 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753538AbYFBQjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:39:09 -0400
Date: Mon, 2 Jun 2008 20:39:05 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: devzero@web.de
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] hgafb: fix module removal
Message-ID: <20080602163905.GA15128@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <299882843@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <299882843@web.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should allocate platform device dynamically, otherwise it can't be removed.

Also, back in time it was acceptable to mix devices and platform_devices,
today this might cause all sort of bugs. Fix that too.

This patch was build-tested only.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

On Sun, Jun 01, 2008 at 01:41:30PM +0200, devzero@web.de wrote:
> addon:
> 
> - the driver  has issues - see http://bugzilla.kernel.org/show_bug.cgi?id=9689
> - after digging out author's recent email on the net and asking him,
> he confirmed, that he doesen`t maintain it anymore. he lost his hga hardware
> in 2001. also see bugzilla entry.
> 
> furthermore:
> 
> >hgafb: probe of hgafb.0 failed with error -22
> >Device 'hgafb.0' does not have a release() function, it is broken and must be fixed.
> >WARNING: at drivers/base/core.c:107 device_release()
> 
> as that bug hasn't been touched since january and kernel telling that it`s
> broken, i think it also should  depend on BROKEN.

It should be just trivially fixed. Here is the patch, I can only build
test it though.

 drivers/video/hgafb.c |   39 ++++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/video/hgafb.c b/drivers/video/hgafb.c
index fb9e672..224ffb8 100644
--- a/drivers/video/hgafb.c
+++ b/drivers/video/hgafb.c
@@ -547,7 +547,7 @@ static struct fb_ops hgafb_ops = {
 	 *  Initialization
 	 */
 
-static int __init hgafb_probe(struct device *device)
+static int __init hgafb_probe(struct platform_device *pdev)
 {
 	struct fb_info *info;
 
@@ -589,13 +589,13 @@ static int __init hgafb_probe(struct device *device)
 
         printk(KERN_INFO "fb%d: %s frame buffer device\n",
                info->node, info->fix.id);
-	dev_set_drvdata(device, info);
+	platform_set_drvdata(pdev, info);
 	return 0;
 }
 
-static int hgafb_remove(struct device *device)
+static int __devexit hgafb_remove(struct platform_device *pdev)
 {
-	struct fb_info *info = dev_get_drvdata(device);
+	struct fb_info *info = platform_get_drvdata(pdev);
 
 	hga_txt_mode();
 	hga_clear_screen();
@@ -616,16 +616,15 @@ static int hgafb_remove(struct device *device)
 	return 0;
 }
 
-static struct device_driver hgafb_driver = {
-	.name = "hgafb",
-	.bus  = &platform_bus_type,
+static struct platform_driver hgafb_driver = {
+	.driver = {
+		.name = "hgafb",
+	},
 	.probe = hgafb_probe,
-	.remove = hgafb_remove,
+	.remove = __devexit_p(hgafb_remove),
 };
 
-static struct platform_device hgafb_device = {
-	.name = "hgafb",
-};
+static struct platform_device *hgafb_device;
 
 static int __init hgafb_init(void)
 {
@@ -634,21 +633,23 @@ static int __init hgafb_init(void)
 	if (fb_get_options("hgafb", NULL))
 		return -ENODEV;
 
-	ret = driver_register(&hgafb_driver);
+	ret = platform_driver_register(&hgafb_driver);
+	if (ret)
+		return ret;
 
-	if (!ret) {
-		ret = platform_device_register(&hgafb_device);
-		if (ret)
-			driver_unregister(&hgafb_driver);
+	hgafb_device = platform_device_register_simple("hgafb", -1, NULL, 0);
+	if (!hgafb_device) {
+		platform_driver_unregister(&hgafb_driver);
+		return -ENOMEM;
 	}
 
-	return ret;
+	return 0;
 }
 
 static void __exit hgafb_exit(void)
 {
-	platform_device_unregister(&hgafb_device);
-	driver_unregister(&hgafb_driver);
+	platform_device_unregister(hgafb_device);
+	platform_driver_unregister(&hgafb_driver);
 }
 
 /* -------------------------------------------------------------------------
-- 
1.5.5.1

