Return-Path: <linux-kernel-owner+w=401wt.eu-S1751191AbZK0FXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbZK0FXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 00:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbZK0FXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 00:23:47 -0500
Received: from smtp-out-042.synserver.de ([212.40.180.42]:1057 "HELO
	smtp-out-041.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751002AbZK0FXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 00:23:47 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Nov 2009 00:23:46 EST
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 14904
From: Lars-Peter Clausen <lars@metafoo.de>
To: rpurdie@rpsys.net
Cc: l.fu@pengutronix.de, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] leds: leds-pwm: Set led_classdev max_brightness
Date: Fri, 27 Nov 2009 06:17:38 +0100
Message-Id: <1259299058-23443-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver leds-pwm doesn't set max_brightness for the led device
although it's platform data proides a maximum brightness. Instead it stores its
own private driver struct. The max_brightness defaults to 255 for led device if
it has not been set.
As a result any leds-pwm device with a different maximum brightness will show
incorrect behavior, as it is posible to either set a longer then period duty
time or not be able to switch the led to full brightness.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/leds/leds-pwm.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index cdfdc87..88b1dd0 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -27,7 +27,6 @@ struct led_pwm_data {
 	struct pwm_device	*pwm;
 	unsigned int 		active_low;
 	unsigned int		period;
-	unsigned int		max_brightness;
 };
 
 static void led_pwm_set(struct led_classdev *led_cdev,
@@ -35,7 +34,7 @@ static void led_pwm_set(struct led_classdev *led_cdev,
 {
 	struct led_pwm_data *led_dat =
 		container_of(led_cdev, struct led_pwm_data, cdev);
-	unsigned int max = led_dat->max_brightness;
+	unsigned int max = led_dat->cdev.max_brightness;
 	unsigned int period =  led_dat->period;
 
 	if (brightness == 0) {
@@ -77,10 +76,10 @@ static int led_pwm_probe(struct platform_device *pdev)
 		led_dat->cdev.name = cur_led->name;
 		led_dat->cdev.default_trigger = cur_led->default_trigger;
 		led_dat->active_low = cur_led->active_low;
-		led_dat->max_brightness = cur_led->max_brightness;
 		led_dat->period = cur_led->pwm_period_ns;
 		led_dat->cdev.brightness_set = led_pwm_set;
 		led_dat->cdev.brightness = LED_OFF;
+		led_dat->cdev.max_brightness = cur_led->max_brightness;
 		led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
 
 		ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
-- 
1.5.6.5

