Return-Path: <linux-kernel-owner+w=401wt.eu-S935236AbYBGX54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935236AbYBGX54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758724AbYBGX51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:57:27 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45323 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757172AbYBGX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:57:24 -0500
X-Sasl-enc: mJ9Cl9aRpEQgJ1PgQuWdSf82j5/0xieCxpJg6MbC9o9q 1202428643
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
       linux-acpi@vger.kernel.org,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 1/3] LED: add support to leds with readable status
Date: Thu,  7 Feb 2008 21:57:11 -0200
Message-Id: <1202428633-6711-1-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1202428145-6106-1-git-send-email-hmh@hmh.eng.br>
References: <1202428145-6106-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some led hardware allows drivers to query the led state, and this patch
adds a hook to let the led class take advantage of that information when
available.

Without this functionality, when access to the led hardware is not
exclusive (i.e. firmware or hardware might change its state behind the
kernel's back), reality goes out of sync with the led class' idea of what
the led is doing, which is annoying at best.

Behaviour for drivers that do not or cannot read the led status is
unchanged.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class.c |    9 +++++++++
 include/linux/leds.h     |    2 ++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 835f939..3bb38a8 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -24,6 +24,12 @@
 
 static struct class *leds_class;
 
+static void led_update_brightness(struct led_classdev *led_cdev)
+{
+	if (led_cdev->brightness_get)
+		led_cdev->brightness = led_cdev->brightness_get(led_cdev);
+}
+
 static ssize_t led_brightness_show(struct device *dev, 
 		struct device_attribute *attr, char *buf)
 {
@@ -31,6 +37,7 @@ static ssize_t led_brightness_show(struct device *dev,
 	ssize_t ret = 0;
 
 	/* no lock needed for this */
+	led_update_brightness(led_cdev);
 	sprintf(buf, "%u\n", led_cdev->brightness);
 	ret = strlen(buf) + 1;
 
@@ -112,6 +119,8 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 	list_add_tail(&led_cdev->node, &leds_list);
 	up_write(&leds_list_lock);
 
+	led_update_brightness(led_cdev);
+
 #ifdef CONFIG_LEDS_TRIGGERS
 	init_rwsem(&led_cdev->trigger_lock);
 
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 4cb5927..dd5969e 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -37,6 +37,8 @@ struct led_classdev {
 	/* Set LED brightness level */
 	void		(*brightness_set)(struct led_classdev *led_cdev,
 					  enum led_brightness brightness);
+	/* Get LED brightness level */
+	enum led_brightness (*brightness_get)(struct led_classdev *led_cdev);
 
 	/* Activate hardware accelerated blink */
 	int		(*blink_set)(struct led_classdev *led_cdev,
-- 
1.5.3.8

