Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbZFZMQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbZFZMQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760175AbZFZMPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:15:54 -0400
Received: from smtp.nokia.com ([192.100.105.134]:60896 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760193AbZFZMPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:15:52 -0400
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: alek.du@intel.com
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, soni.trilok@gmail.com, ben-linux@fluff.org,
       ext-phil.2.carmody@nokia.com, ext-jani.1.nikula@nokia.com
Subject: [PATCH 1/2] Revert "Input: gpio-keys - change timer to workqueue"
Date: Fri, 26 Jun 2009 15:15:17 +0300
Message-Id: <05e493155e58484c4b854eff8ed80f8b00d8a3bc.1246015395.git.ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1246015395.git.ext-jani.1.nikula@nokia.com>
References: <20090626002345.07928230@dxy.sh.intel.com>
 <cover.1246015395.git.ext-jani.1.nikula@nokia.com>
In-Reply-To: <cover.1246015395.git.ext-jani.1.nikula@nokia.com>
References: <cover.1246015395.git.ext-jani.1.nikula@nokia.com>
X-OriginalArrivalTime: 26 Jun 2009 12:15:22.0261 (UTC) FILETIME=[C745FC50:01C9F657]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 0b346838c5862bfe911432956a106d602535d030.

This commit breaks GPIO debouncing by replacing the original mod_timer
with schedule_delayed_work in the interrupt handler. The latter does not
kick the timer further on GPIO line changes as it should to perform
debouncing.

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
---
 drivers/input/keyboard/gpio_keys.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 2157cd7..9767213 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -22,14 +22,13 @@
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
-#include <linux/workqueue.h>
 
 #include <asm/gpio.h>
 
 struct gpio_button_data {
 	struct gpio_keys_button *button;
 	struct input_dev *input;
-	struct delayed_work work;
+	struct timer_list timer;
 };
 
 struct gpio_keys_drvdata {
@@ -37,10 +36,8 @@ struct gpio_keys_drvdata {
 	struct gpio_button_data data[0];
 };
 
-static void gpio_keys_report_event(struct work_struct *work)
+static void gpio_keys_report_event(struct gpio_button_data *bdata)
 {
-	struct gpio_button_data *bdata =
-		container_of(work, struct gpio_button_data, work.work);
 	struct gpio_keys_button *button = bdata->button;
 	struct input_dev *input = bdata->input;
 	unsigned int type = button->type ?: EV_KEY;
@@ -50,17 +47,25 @@ static void gpio_keys_report_event(struct work_struct *work)
 	input_sync(input);
 }
 
+static void gpio_check_button(unsigned long _data)
+{
+	struct gpio_button_data *data = (struct gpio_button_data *)_data;
+
+	gpio_keys_report_event(data);
+}
+
 static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 {
 	struct gpio_button_data *bdata = dev_id;
 	struct gpio_keys_button *button = bdata->button;
-	unsigned long delay;
 
 	BUG_ON(irq != gpio_to_irq(button->gpio));
 
-	delay = button->debounce_interval ?
-			msecs_to_jiffies(button->debounce_interval) : 0;
-	schedule_delayed_work(&bdata->work, delay);
+	if (button->debounce_interval)
+		mod_timer(&bdata->timer,
+			jiffies + msecs_to_jiffies(button->debounce_interval));
+	else
+		gpio_keys_report_event(bdata);
 
 	return IRQ_HANDLED;
 }
@@ -107,7 +112,8 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 
 		bdata->input = input;
 		bdata->button = button;
-		INIT_DELAYED_WORK(&bdata->work, gpio_keys_report_event);
+		setup_timer(&bdata->timer,
+			    gpio_check_button, (unsigned long)bdata);
 
 		error = gpio_request(button->gpio, button->desc ?: "gpio_keys");
 		if (error < 0) {
@@ -166,7 +172,8 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
  fail2:
 	while (--i >= 0) {
 		free_irq(gpio_to_irq(pdata->buttons[i].gpio), &ddata->data[i]);
-		cancel_delayed_work_sync(&ddata->data[i].work);
+		if (pdata->buttons[i].debounce_interval)
+			del_timer_sync(&ddata->data[i].timer);
 		gpio_free(pdata->buttons[i].gpio);
 	}
 
@@ -190,7 +197,8 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
 	for (i = 0; i < pdata->nbuttons; i++) {
 		int irq = gpio_to_irq(pdata->buttons[i].gpio);
 		free_irq(irq, &ddata->data[i]);
-		cancel_delayed_work_sync(&ddata->data[i].work);
+		if (pdata->buttons[i].debounce_interval)
+			del_timer_sync(&ddata->data[i].timer);
 		gpio_free(pdata->buttons[i].gpio);
 	}
 
-- 
1.6.3.2

