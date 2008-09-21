Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbYIUOjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbYIUOjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 10:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYIUOjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 10:39:37 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:25799 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbYIUOjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 10:39:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=AOxjEsknbhTGLFDg/y20cZNpKTY5IfRVFkUoKEY6zl+5barVjMuIg7/80nRuMVGuxO
         HPZTZMeGX40eY0ZqARc6fYxAa4CRX091Idezqzm8V1DpOZ6sm7YLm+EJJ80+T0Fdzwym
         vxRDFyYCbGnzfgpRqfmcfo5hNyyFfY7a8/koY=
Date: Sun, 21 Sep 2008 23:39:28 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>,
       Alan Hourihane <alanh@tungstengraphics.com>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] cr_bllcd: use platform_device_register_simple()
Message-ID: <20080921143927.GG8790@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change also fixes error handling when platform_device_alloc() fails.
(When platform_device_alloc() failed, it returns error without
unregistering cr_backlight_driver)

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>
Cc: Alan Hourihane <alanh@tungstengraphics.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/cr_bllcd.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

Index: 2.6-git/drivers/video/backlight/cr_bllcd.c
===================================================================
--- 2.6-git.orig/drivers/video/backlight/cr_bllcd.c
+++ 2.6-git/drivers/video/backlight/cr_bllcd.c
@@ -259,22 +259,18 @@ static int __init cr_backlight_init(void
 {
 	int ret = platform_driver_register(&cr_backlight_driver);
 
-	if (!ret) {
-		crp = platform_device_alloc("cr_backlight", -1);
-		if (!crp)
-			return -ENOMEM;
-
-		ret = platform_device_add(crp);
-
-		if (ret) {
-			platform_device_put(crp);
-			platform_driver_unregister(&cr_backlight_driver);
-		}
+	if (ret)
+		return ret;
+
+	crp = platform_device_register_simple("cr_backlight", -1, NULL, 0);
+	if (IS_ERR(crp)) {
+		platform_driver_unregister(&cr_backlight_driver);
+		return PTR_ERR(crp);
 	}
 
 	printk("Carillo Ranch Backlight Driver Initialized.\n");
 
-	return ret;
+	return 0;
 }
 
 static void __exit cr_backlight_exit(void)
