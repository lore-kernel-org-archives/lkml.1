Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbYLEDrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbYLEDrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYLEDrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:47:10 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:61511 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYLEDrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:47:09 -0500
Message-Id: <200812050344.mB53i9BF034723@www262.sakura.ne.jp>
Subject: [2.6.28-rc7] Define MODULE_SYSTEM_TABLE for mbp_nvidia_bl.o and applesmc.o
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: mjg@redhat.com, nicolas@boichat.ch
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Dec 2008 12:44:09 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling mbp_nvidia_bl.o and applesmc.o using gcc 3.3.5,
the below compilation error occurs.

  CC [M]  drivers/video/backlight/mbp_nvidia_bl.o
  drivers/video/backlight/mbp_nvidia_bl.c:114: error: storage size of `__mod_dmi_device_table' isn't known
  make[1]: *** [drivers/video/backlight/mbp_nvidia_bl.o] Error 1
  make: *** [drivers/video/backlight/mbp_nvidia_bl.o] Error 2

  CC [M]  drivers/hwmon/applesmc.o
  drivers/hwmon/applesmc.c:1567: error: storage size of `__mod_dmi_device_table' isn't known
  make[1]: *** [drivers/hwmon/applesmc.o] Error 1
  make: *** [drivers/hwmon/applesmc.o] Error 2

Diffs between 2.6.27.7 and 2.6.28-rc7 are shown below.

  # diff linux-2.6.27.7/drivers/video/backlight/mbp_nvidia_bl.c linux-2.6.28-rc7/drivers/video/backlight/mbp_nvidia_bl.c
  114,116c114
  < MODULE_ALIAS("svnAppleInc.:pnMacBookPro3,1");
  < MODULE_ALIAS("svnAppleInc.:pnMacBookPro3,2");
  < MODULE_ALIAS("svnAppleInc.:pnMacBookPro4,1");
  ---
  > MODULE_DEVICE_TABLE(dmi, mbp_device_table);

We can see that MODULE_ALIAS is replaced by MODULE_DEVICE_TABLE.

mbp_nvidia_bl.c and applesmc.c are using MODULE_DEVICE_TABLE(dmi, ...);
which will extracted to __mod_dmi_device_table, but it seems to me that
dmi does not define __mod_dmi_device_table.

I don't know why gcc 4.x doesn't trigger this compilation error.

I don't know whether mbp_nvidia_bl.o and applesmc.o compiled with this patch
work or not. Can somebody who has these hardwares try this patch?

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 drivers/hwmon/applesmc.c                |    2 +-
 drivers/video/backlight/mbp_nvidia_bl.c |    2 +-
 include/linux/module.h                  |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.28-rc7.orig/drivers/hwmon/applesmc.c
+++ linux-2.6.28-rc7/drivers/hwmon/applesmc.c
@@ -1564,4 +1564,4 @@ module_exit(applesmc_exit);
 MODULE_AUTHOR("Nicolas Boichat");
 MODULE_DESCRIPTION("Apple SMC");
 MODULE_LICENSE("GPL v2");
-MODULE_DEVICE_TABLE(dmi, applesmc_whitelist);
+MODULE_SYSTEM_TABLE(dmi, applesmc_whitelist);
--- linux-2.6.28-rc7.orig/drivers/video/backlight/mbp_nvidia_bl.c
+++ linux-2.6.28-rc7/drivers/video/backlight/mbp_nvidia_bl.c
@@ -111,4 +111,4 @@ module_exit(mbp_exit);
 MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
 MODULE_DESCRIPTION("Nvidia-based Macbook Pro Backlight Driver");
 MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(dmi, mbp_device_table);
+MODULE_SYSTEM_TABLE(dmi, mbp_device_table);
--- linux-2.6.28-rc7.orig/include/linux/module.h
+++ linux-2.6.28-rc7/include/linux/module.h
@@ -139,6 +139,8 @@ extern struct module __this_module;
 
 #define MODULE_DEVICE_TABLE(type,name)		\
   MODULE_GENERIC_TABLE(type##_device,name)
+#define MODULE_SYSTEM_TABLE(type,name)		\
+  MODULE_GENERIC_TABLE(type##_system,name)
 
 /* Version of form [<epoch>:]<version>[-<extra-version>].
    Or for CVS/RCS ID version, everything but the number is stripped.
