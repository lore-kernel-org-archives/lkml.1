Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbYCFKYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbYCFKYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbYCFKYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:24:09 -0500
Received: from mail164.messagelabs.com ([216.82.253.131]:29132 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755541AbYCFKYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:24:07 -0500
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-14.tower-164.messagelabs.com!1204799046!11019376!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: linux-kernel@vger.kernel.org
Cc: Raphael Assenat <raph@8d.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] call gpio_cansleep only after gpio_request succeeded
Date: Thu,  6 Mar 2008 11:24:51 +0100
Message-Id: <1204799091-11880-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1202999569-9022-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
References: <1202999569-9022-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Mar 2008 10:24:02.0910 (UTC) FILETIME=[330727E0:01C87F74]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15770.003
X-TM-AS-Result: No--7.070000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you have GPIO_LIB gpio_cansleep oopses on an invalid
gpio.  So better gpio_request your pin first.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Raphael Assenat <raph@8d.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
Hello,

I already sent that patch on Thu, 14 Feb 2008.  Since then I changed

	gpio_request(led_dat->gpio, ...

to

	gpio_request(cur_led->gpio, ...

because at that time led_dat->gpio isn't initialized yet.

And I got the Acked-by: David.

Best regards
Uwe

---
 drivers/leds/leds-gpio.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 6c0a9c4..d13b622 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -79,6 +79,10 @@ static int gpio_led_probe(struct platform_device *pdev)
 		cur_led = &pdata->leds[i];
 		led_dat = &leds_data[i];
 
+		ret = gpio_request(cur_led->gpio, cur_led->name);
+		if (ret < 0)
+			goto err;
+
 		led_dat->cdev.name = cur_led->name;
 		led_dat->cdev.default_trigger = cur_led->default_trigger;
 		led_dat->gpio = cur_led->gpio;
@@ -87,10 +91,6 @@ static int gpio_led_probe(struct platform_device *pdev)
 		led_dat->cdev.brightness_set = gpio_led_set;
 		led_dat->cdev.brightness = LED_OFF;
 
-		ret = gpio_request(led_dat->gpio, led_dat->cdev.name);
-		if (ret < 0)
-			goto err;
-
 		gpio_direction_output(led_dat->gpio, led_dat->active_low);
 
 		INIT_WORK(&led_dat->work, gpio_led_work);
-- 
1.5.4.3

