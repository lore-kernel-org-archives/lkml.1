Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbZEUJfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbZEUJfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZEUJew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:34:52 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:26883 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZEUJev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:34:51 -0400
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4A151F0A.9070405@tremplin-utc.net>
Date: Thu, 21 May 2009 11:29:46 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 1/4] lis3: fix misc device unregistering and printk
References: <4A151E9F.1080405@tremplin-utc.net>
In-Reply-To: <4A151E9F.1080405@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Can only unregister the misc device if it was registered before. Also
remove debugging messages, which in addition were not properly formated.

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/lis3lv02d.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 778eb77..17f2003 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -199,7 +199,6 @@ static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
 		return -EBUSY;
 	}
 	lis3lv02d_increase_use(&lis3_dev);
-	printk("lis3: registered interrupt %d\n", lis3_dev.irq);
 	return 0;
 }
 
@@ -378,7 +377,8 @@ void lis3lv02d_joystick_disable(void)
 	if (!lis3_dev.idev)
 		return;
 
-	misc_deregister(&lis3lv02d_misc_device);
+	if (lis3_dev.irq)
+		misc_deregister(&lis3lv02d_misc_device);
 	input_unregister_device(lis3_dev.idev);
 	lis3_dev.idev = NULL;
 }
@@ -493,8 +493,6 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 	if (lis3lv02d_joystick_enable())
 		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
 
-	printk("lis3_init_device: irq %d\n", dev->irq);
-
 	/* bail if we did not get an IRQ from the bus layer */
 	if (!dev->irq) {
 		printk(KERN_ERR DRIVER_NAME
@@ -502,7 +500,6 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		goto out;
 	}
 
-	printk("lis3: registering device\n");
 	if (misc_register(&lis3lv02d_misc_device))
 		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
 out:
-- 
1.6.2.4



