Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYIUOhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYIUOhT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 10:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYIUOhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 10:37:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:22028 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbYIUOhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 10:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=eu8gRqaT6XanziX1w4/hqV5ED+1vYYbvddbouZvbzE8VSCs+xeeHcJzNe4y4RpQoP9
         K7bXXyArKNg0RHkYwpaSFs+CxDqmU35/i0DRMu8EclgIyPXwuO8fAbGtzYIEo89YvC05
         kLFngji4BuYHw54uVzrmp+8DLWKsF51hJRE5Q=
Date: Sun, 21 Sep 2008 23:36:58 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andriy Skulysh <askulysh@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] hp680_bl: use platform_device_register_simple()
Message-ID: <20080921143656.GE8790@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change also fixes error handling when platform_device_alloc() fails.
(When platform_device_alloc() failed, it returns error without
unregistering hp680_bl_driver)

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andriy Skulysh <askulysh@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/hp680_bl.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

Index: 2.6-git/drivers/video/backlight/hp680_bl.c
===================================================================
--- 2.6-git.orig/drivers/video/backlight/hp680_bl.c
+++ 2.6-git/drivers/video/backlight/hp680_bl.c
@@ -151,19 +151,15 @@ static int __init hp680bl_init(void)
 	int ret;
 
 	ret = platform_driver_register(&hp680bl_driver);
-	if (!ret) {
-		hp680bl_device = platform_device_alloc("hp680-bl", -1);
-		if (!hp680bl_device)
-			return -ENOMEM;
-
-		ret = platform_device_add(hp680bl_device);
-
-		if (ret) {
-			platform_device_put(hp680bl_device);
-			platform_driver_unregister(&hp680bl_driver);
-		}
+	if (ret)
+		return ret;
+	hp680bl_device = platform_device_register_simple("hp680-bl", -1,
+							NULL, 0);
+	if (IS_ERR(hp680bl_device)) {
+		platform_driver_unregister(&hp680bl_driver);
+		return PTR_ERR(hp680bl_device);
 	}
-	return ret;
+	return 0;
 }
 
 static void __exit hp680bl_exit(void)
