Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYCPR53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYCPR53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 13:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYCPR5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 13:57:21 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56240 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278AbYCPR5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 13:57:21 -0400
X-Sasl-enc: hI3ygYDOvVkALlAqbaGzD5uMwnefAZ6ZFs333PwcomyM 1205690239
Date: Sun, 16 Mar 2008 14:57:19 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] leds: add support to leds with readable status
Message-ID: <20080316175719.GF19825@khazad-dum.debian.net>
References: <1205686229-23408-1-git-send-email-hmh@hmh.eng.br> <20080316172706.GE19825@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080316172706.GE19825@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
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
 Resend with a proper "leds:" prefix on patch short title
 instead of "LED:".

 drivers/leds/led-class.c |    9 +++++++++
 include/linux/leds.h     |    2 ++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 1801317..3c40383 100644
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
 
@@ -113,6 +120,8 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
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
1.5.4.4

