Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbZBEQia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbZBEQia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZBEQiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:38:22 -0500
Received: from mail.gmx.net ([213.165.64.20]:59798 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753506AbZBEQiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:38:21 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18bn3AWGJobA6m9lTP4VTvVz5n8v+g9EO1J99ZQZr
	pnQ+DAhcOm/bTY
Date: Thu, 5 Feb 2009 17:38:26 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-input@vger.kernel.org
cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: [PATCH] gpio-keys: poll for release if GPIO cannot interrupt on both
 edges
Message-ID: <Pine.LNX.4.64.0902051730300.5553@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are GPIO controllers, that cannot be configured to produce 
interrupts on both edges. To be able to meaningfully use these for 
gpio-keys, add a polling option.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

I previously tried to solve this problem by reporting a release event 
immediately after press, but this proved to be not very useful. This patch 
adds a timer to poll for release events on such buttons. I so far set the 
polling period to 50ms, don't know how good or bad this is, and whether we 
want to have it configurable.

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index ad67d76..2203fd0 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -29,10 +29,13 @@ struct gpio_button_data {
 	struct gpio_keys_button *button;
 	struct input_dev *input;
 	struct timer_list timer;
+	struct timer_list *release;
+	int state;
 };
 
 struct gpio_keys_drvdata {
 	struct input_dev *input;
+	struct timer_list release;
 	struct gpio_button_data data[0];
 };
 
@@ -43,10 +46,41 @@ static void gpio_keys_report_event(struct gpio_button_data *bdata)
 	unsigned int type = button->type ?: EV_KEY;
 	int state = (gpio_get_value(button->gpio) ? 1 : 0) ^ button->active_low;
 
-	input_event(input, type, button->code, !!state);
+	bdata->state = !!state;
+	input_event(input, type, button->code, bdata->state);
+	/* If the button only supports press events, poll for release */
+	if (state && button->irq_trigger != (IRQF_TRIGGER_RISING |
+					     IRQF_TRIGGER_FALLING))
+		mod_timer(bdata->release, jiffies + msecs_to_jiffies(50));
+
 	input_sync(input);
 }
 
+static void gpio_poll_button(unsigned long _data)
+{
+	struct platform_device *pdev = (struct platform_device *)_data;
+	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_keys_drvdata *ddata = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < pdata->nbuttons; i++) {
+		struct gpio_button_data *bdata = &ddata->data[i];
+		struct gpio_keys_button *button = bdata->button;
+
+		if (bdata->state && button->irq_trigger !=
+		    (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING)) {
+			int state = (gpio_get_value(button->gpio) ? 1 : 0) ^
+				button->active_low;
+
+			if (!state)
+				gpio_keys_report_event(bdata);
+			else
+				mod_timer(bdata->release, jiffies +
+					  msecs_to_jiffies(50));
+		}
+	}
+}
+
 static void gpio_check_button(unsigned long _data)
 {
 	struct gpio_button_data *data = (struct gpio_button_data *)_data;
@@ -104,6 +138,9 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 
 	ddata->input = input;
 
+	setup_timer(&ddata->release,
+		    gpio_poll_button, (unsigned long)pdev);
+
 	for (i = 0; i < pdata->nbuttons; i++) {
 		struct gpio_keys_button *button = &pdata->buttons[i];
 		struct gpio_button_data *bdata = &ddata->data[i];
@@ -141,9 +178,19 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 			goto fail2;
 		}
 
+		button->irq_trigger &= IRQF_TRIGGER_RISING |
+			IRQF_TRIGGER_FALLING;
+
+		if (!button->irq_trigger)
+			button->irq_trigger = IRQF_TRIGGER_RISING |
+				IRQF_TRIGGER_FALLING;
+
+		if (button->irq_trigger != (IRQF_TRIGGER_RISING |
+					    IRQF_TRIGGER_FALLING))
+			bdata->release = &ddata->release;
+
 		error = request_irq(irq, gpio_keys_isr,
-				    IRQF_SAMPLE_RANDOM | IRQF_TRIGGER_RISING |
-					IRQF_TRIGGER_FALLING,
+				    IRQF_SAMPLE_RANDOM | button->irq_trigger,
 				    button->desc ? button->desc : "gpio_keys",
 				    bdata);
 		if (error) {
@@ -171,6 +218,7 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 	return 0;
 
  fail2:
+	del_timer_sync(&ddata->release);
 	while (--i >= 0) {
 		free_irq(gpio_to_irq(pdata->buttons[i].gpio), &ddata->data[i]);
 		if (pdata->buttons[i].debounce_interval)
@@ -195,6 +243,8 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 0);
 
+	del_timer_sync(&ddata->release);
+
 	for (i = 0; i < pdata->nbuttons; i++) {
 		int irq = gpio_to_irq(pdata->buttons[i].gpio);
 		free_irq(irq, &ddata->data[i]);
diff --git a/include/linux/gpio_keys.h b/include/linux/gpio_keys.h
index 1289fa7..d0bd8e2 100644
--- a/include/linux/gpio_keys.h
+++ b/include/linux/gpio_keys.h
@@ -10,6 +10,7 @@ struct gpio_keys_button {
 	int type;		/* input event type (EV_KEY, EV_SW) */
 	int wakeup;		/* configure the button as a wake-up source */
 	int debounce_interval;	/* debounce ticks interval in msecs */
+	unsigned long irq_trigger; /* IRQF_TRIGGER_{RISING,FALLING} */
 };
 
 struct gpio_keys_platform_data {
