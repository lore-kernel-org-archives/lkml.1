Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbYIUOin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbYIUOin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 10:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYIUOig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 10:38:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:22858 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYIUOif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 10:38:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=iqHpGg0SPUAmCIWtXNuxz0maGSYYBH0haYriJfX1GqQ2gaqo3epYoBWt5yUQMQLvVd
         iXsA9Qi/fCgjfHdr0aYiLgl9Y/8/k+MomIyapnRkDT8XP/y+AXoqpH3mxx+uTx0jq3/a
         c1ZAnL0Uiv3oTSv3fb8aAb8VWSxvTrEtzcTW4=
Date: Sun, 21 Sep 2008 23:38:29 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Juszkiewicz <linux@hrw.one.pl>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] progear_bl: use platform_device_register_simple()
Message-ID: <20080921143827.GF8790@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change also fixes error handling when platform_device_alloc() fails.
(When platform_device_alloc() failed, it returns error without
unregistering progearbl_driver)

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Marcin Juszkiewicz <linux@hrw.one.pl>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/progear_bl.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

Index: 2.6-git/drivers/video/backlight/progear_bl.c
===================================================================
--- 2.6-git.orig/drivers/video/backlight/progear_bl.c
+++ 2.6-git/drivers/video/backlight/progear_bl.c
@@ -119,20 +119,16 @@ static int __init progearbl_init(void)
 {
 	int ret = platform_driver_register(&progearbl_driver);
 
-	if (!ret) {
-		progearbl_device = platform_device_alloc("progear-bl", -1);
-		if (!progearbl_device)
-			return -ENOMEM;
-
-		ret = platform_device_add(progearbl_device);
-
-		if (ret) {
-			platform_device_put(progearbl_device);
-			platform_driver_unregister(&progearbl_driver);
-		}
+	if (ret)
+		return ret;
+	progearbl_device = platform_device_register_simple("progear-bl", -1,
+								NULL, 0);
+	if (IS_ERR(progearbl_device)) {
+		platform_driver_unregister(&progearbl_driver);
+		return PTR_ERR(progearbl_device);
 	}
 
-	return ret;
+	return 0;
 }
 
 static void __exit progearbl_exit(void)
