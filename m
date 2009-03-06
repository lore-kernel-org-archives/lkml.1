Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZCFAq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZCFAq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 19:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZCFAqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 19:46:48 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:31398 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750898AbZCFAqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 19:46:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nuIvNlf7jWNAF7RYTWW0/G33hLis2JpQxLSBalUAkhxniieJl+JlIfK3l12jkbjKYOyVKWxc/+ahp0n5a+jzXXXkyGFwS9r+r74rNIeXt1FE0Tmknobg1XnnIUCiTTVqdh8qOttXuCHnP3xt2OJdjqJ5i8dJ2zeyoTYF2cv8+WU=  ;
X-YMail-OSG: 1arQ3gQVM1nwBIYVgOxr6p0U60BdFdKL_YQKcRo6p6ZuY6uMljHjBobW8OmMPcc0NKpjvhdH1dqIVXgJg9KbjdwygcZAQcuLqol0esAQRbGlPXjAMXXSl_W8OTahVH7puZTWONZALhqYsSYe.isElbz.1raYC08Vp3lB50u6uyxTYbaB01ex7A3vyduWk3oLm5VR2VLmXfJNRCdxYN1wKl8fv19tF1t6.Bt0DQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Richard Purdie <rpurdie@rpsys.net>
Subject: [patch 2.6.29-rc7] leds-gpio: just ignore invalid GPIOs
Date: Thu, 5 Mar 2009 16:46:44 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>,
       Diego Dompe <diego.dompe@ridgerun.com>, Jason Kridner <jdk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903051646.44364.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Sometimes it's awkward to make sure that the array in the
platform_data handed to the leds-gpio driver has only valid
data ... some leds may not be always available, and coping
with that currently requires patching or rebuilding the array.

This patch fixes that by making it be OK to pass an invalid
GPIO (such as "-EINVAL") ... such table entries are skipped.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Tested-by: Diego Dompe <diego.dompe@ridgerun.com>
---
Noted on OMAP3 Beagle board ... one of the three programmable
LEDs is driven by a twl4030 GPIO, which might not be configured.
(In fact it's a PWM-capable LED, but the PWM support isn't yet
available.)

 drivers/leds/leds-gpio.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -90,13 +90,19 @@ static int gpio_led_probe(struct platfor
 		cur_led = &pdata->leds[i];
 		led_dat = &leds_data[i];
 
+		/* skip leds that aren't available */
+		led_dat->gpio = cur_led->gpio;
+		if (!gpio_is_valid(led_dat->gpio)) {
+			dev_dbg(&pdev->dev, "skipping %s\n", cur_led->name);
+			continue;
+		}
+
 		ret = gpio_request(cur_led->gpio, cur_led->name);
 		if (ret < 0)
 			goto err;
 
 		led_dat->cdev.name = cur_led->name;
 		led_dat->cdev.default_trigger = cur_led->default_trigger;
-		led_dat->gpio = cur_led->gpio;
 		led_dat->can_sleep = gpio_cansleep(cur_led->gpio);
 		led_dat->active_low = cur_led->active_low;
 		if (pdata->gpio_blink_set) {
@@ -125,6 +131,8 @@ static int gpio_led_probe(struct platfor
 err:
 	if (i > 0) {
 		for (i = i - 1; i >= 0; i--) {
+			if (!gpio_is_valid(leds_data[i].gpio))
+				continue;
 			led_classdev_unregister(&leds_data[i].cdev);
 			cancel_work_sync(&leds_data[i].work);
 			gpio_free(leds_data[i].gpio);
@@ -145,6 +153,8 @@ static int __devexit gpio_led_remove(str
 	leds_data = platform_get_drvdata(pdev);
 
 	for (i = 0; i < pdata->num_leds; i++) {
+		if (!gpio_is_valid(leds_data[i].gpio))
+			continue;
 		led_classdev_unregister(&leds_data[i].cdev);
 		cancel_work_sync(&leds_data[i].work);
 		gpio_free(leds_data[i].gpio);
