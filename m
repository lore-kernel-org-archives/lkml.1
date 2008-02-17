Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYBQMap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYBQMap (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbYBQMXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:23 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55079 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbYBQMXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:23:00 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Len Brown <len.brown@intel.com>
Subject: [PATCH 17/27] acer-wmi: fix section mismatch warnings
Date: Sun, 17 Feb 2008 13:22:54 +0100
Message-Id: <1203250984-11285-17-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: vmlinux.o(.text+0x672615): Section mismatch in reference from the function acer_platform_remove() to the function .exit.text:acer_backlight_exit()
WARNING: vmlinux.o(.devinit.text+0x1e859): Section mismatch in reference from the function acer_platform_probe() to the function .init.text:acer_led_init()
WARNING: vmlinux.o(.devinit.text+0x1e878): Section mismatch in reference from the function acer_platform_probe() to the function .init.text:acer_backlight_init()

Remove __exit annotation from acer_backlight_exit(). We cannot reference
a __exit annotated function from non __exit functions.

acer_led_init() and acer_backlight_init() where both annotated __init but
used from a __devinit function. This would result in an oops should
gcc drop their inlining and the module are hot plugged.

Fix by annotating acer_led_init() and acer_backlight_init() __devinit.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Len Brown <len.brown@intel.com>
---
 drivers/misc/acer-wmi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/acer-wmi.c b/drivers/misc/acer-wmi.c
index d7aea93..cdc733b 100644
--- a/drivers/misc/acer-wmi.c
+++ b/drivers/misc/acer-wmi.c
@@ -756,7 +756,7 @@ static struct led_classdev mail_led = {
 	.brightness_set = mail_led_set,
 };
 
-static int __init acer_led_init(struct device *dev)
+static int __devinit acer_led_init(struct device *dev)
 {
 	return led_classdev_register(dev, &mail_led);
 }
@@ -789,7 +789,7 @@ static struct backlight_ops acer_bl_ops = {
 	.update_status = update_bl_status,
 };
 
-static int __init acer_backlight_init(struct device *dev)
+static int __devinit acer_backlight_init(struct device *dev)
 {
 	struct backlight_device *bd;
 
@@ -808,7 +808,7 @@ static int __init acer_backlight_init(struct device *dev)
 	return 0;
 }
 
-static void __exit acer_backlight_exit(void)
+static void acer_backlight_exit(void)
 {
 	backlight_device_unregister(acer_backlight_device);
 }
-- 
1.5.4.rc3.14.g44397

