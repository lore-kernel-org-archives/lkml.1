Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZGNRLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZGNRLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbZGNRLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:11:04 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:45217 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbZGNRLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:11:02 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: me@felipe.balbi.com
Cc: linux-kernel@vger.kernel.org, rpurdie@linux.intel.com, rpurdie@rpsys.net,
       srcvale@holoscopio.com,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 2/3] Fix multiple requests and releases of IRQ for GPIO LED Trigger.
Date: Tue, 14 Jul 2009 14:03:34 -0300
Message-Id: <1247591015-2428-2-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247591015-2428-1-git-send-email-cascardo@holoscopio.com>
References: <1247591015-2428-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting the same GPIO number, multiple IRQ shared requests will be
done without freing the previous request. It will also try to free a
failed request or an already freed IRQ if 0 was written to the gpio
file.

All these oops and leaks were fixed with the following solution: keep
the previous allocated GPIO (if any) still allocated in case the new
request fails. The alternative solution would desallocate the previous
allocated GPIO and set gpio as 0.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Samuel R. C. Vale <srcvale@holoscopio.com>
---
 drivers/leds/ledtrig-gpio.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
index 6b7bb12..7c9aff9 100644
--- a/drivers/leds/ledtrig-gpio.c
+++ b/drivers/leds/ledtrig-gpio.c
@@ -146,20 +146,26 @@ static ssize_t gpio_trig_gpio_store(struct device *dev,
 		return -EINVAL;
 	}
 
+	if (gpio_data->gpio == gpio)
+		return n;
+
 	if (!gpio) {
-		free_irq(gpio_to_irq(gpio_data->gpio), led);
+		if (gpio_data->gpio != 0)
+			free_irq(gpio_to_irq(gpio_data->gpio), led);
+		gpio_data->gpio = 0;
 		return n;
 	}
 
-	if (gpio_data->gpio > 0 && gpio_data->gpio != gpio)
-		free_irq(gpio_to_irq(gpio_data->gpio), led);
-
-	gpio_data->gpio = gpio;
 	ret = request_irq(gpio_to_irq(gpio), gpio_trig_irq,
 			IRQF_SHARED | IRQF_TRIGGER_RISING
 			| IRQF_TRIGGER_FALLING, "ledtrig-gpio", led);
-	if (ret)
+	if (ret) {
 		dev_err(dev, "request_irq failed with error %d\n", ret);
+	} else {
+		if (gpio_data->gpio != 0)
+			free_irq(gpio_to_irq(gpio_data->gpio), led);
+		gpio_data->gpio = gpio;
+	}
 
 	return ret ? ret : n;
 }
@@ -211,7 +217,8 @@ static void gpio_trig_deactivate(struct led_classdev *led)
 		device_remove_file(led->dev, &dev_attr_inverted);
 		device_remove_file(led->dev, &dev_attr_desired_brightness);
 		flush_work(&gpio_data->work);
-		free_irq(gpio_to_irq(gpio_data->gpio),led);
+		if (gpio_data->gpio != 0)
+			free_irq(gpio_to_irq(gpio_data->gpio), led);
 		kfree(gpio_data);
 	}
 }
-- 
1.6.3.3

