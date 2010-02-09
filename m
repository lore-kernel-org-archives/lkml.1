Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab0BIUrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:47:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:41478 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0BIUqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:46:38 -0500
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-embedded@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bill Gatliff <bgat@billgatliff.com>
Subject: [PWM PATCH 2/7] Emulates PWM hardware using a high-resolution timer and a GPIO pin
Date: Tue,  9 Feb 2010 14:46:29 -0600
Message-Id: <7178097a5a8af15f61656f11b6bef68b0da71498.1265748264.git.bgat@billgatliff.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <b7afd475c3fce08f459bceff7814de57ffce7bd0.1265748264.git.bgat@billgatliff.com>
References: <cover.1265748263.git.bgat@billgatliff.com>
 <b7afd475c3fce08f459bceff7814de57ffce7bd0.1265748264.git.bgat@billgatliff.com>
In-Reply-To: <cover.1265748263.git.bgat@billgatliff.com>
References: <cover.1265748263.git.bgat@billgatliff.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bill Gatliff <bgat@billgatliff.com>
---
 drivers/pwm/gpio.c |  312 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 312 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pwm/gpio.c

diff --git a/drivers/pwm/gpio.c b/drivers/pwm/gpio.c
new file mode 100644
index 0000000..151536b
--- /dev/null
+++ b/drivers/pwm/gpio.c
@@ -0,0 +1,312 @@
+/*
+ * drivers/pwm/gpio.c
+ *
+ * Models a single-channel PWM device using a kernel interval timer
+ * and a GPIO pin.
+ *
+ * Copyright (C) 2010 Bill Gatliff <bgat@billgatliff.com>
+ *
+ * This program is free software; you may redistribute and/or modify
+ * it under the terms of the GNU General Public License Version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/hrtimer.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+#include <linux/gpio.h>
+#include <linux/pwm/pwm.h>
+
+struct gpio_pwm {
+	struct pwm_device pwm;
+	struct hrtimer t;
+	struct work_struct work;
+	pwm_callback_t callback;
+	int gpio;
+	unsigned long polarity : 1;
+	unsigned long active : 1;
+};
+
+static inline struct gpio_pwm *to_gpio_pwm(const struct pwm_channel *p)
+{
+	return container_of(p->pwm, struct gpio_pwm, pwm);
+}
+
+static void
+gpio_pwm_work (struct work_struct *work)
+{
+	struct gpio_pwm *gp = container_of(work, struct gpio_pwm, work);
+
+	if (gp->active)
+		gpio_direction_output(gp->gpio, gp->polarity ? 1 : 0);
+	else
+		gpio_direction_output(gp->gpio, gp->polarity ? 0 : 1);
+}
+
+static enum hrtimer_restart
+gpio_pwm_timeout(struct hrtimer *t)
+{
+	struct gpio_pwm *gp = container_of(t, struct gpio_pwm, t);
+
+	if (unlikely(gp->pwm.channels[0].duty_ticks == 0))
+		gp->active = 0;
+	else if (unlikely(gp->pwm.channels[0].duty_ticks
+			  == gp->pwm.channels[0].period_ticks))
+		gp->active = 1;
+	else
+		gp->active ^= 1;
+
+	if (gpio_cansleep(gp->gpio))
+		schedule_work(&gp->work);
+	else
+		gpio_pwm_work(&gp->work);
+
+	if (!gp->active && gp->pwm.channels[0].callback)
+		gp->pwm.channels[0].callback(&gp->pwm.channels[0]);
+
+	if (unlikely(!gp->active &&
+		     (gp->pwm.channels[0].flags & BIT(FLAG_STOP)))) {
+		clear_bit(FLAG_STOP, &gp->pwm.channels[0].flags);
+		complete_all(&gp->pwm.channels[0].complete);
+		return HRTIMER_NORESTART;
+	}
+
+	if (gp->active)
+		hrtimer_start(&gp->t,
+			      ktime_set(0, gp->pwm.channels[0].duty_ticks),
+			      HRTIMER_MODE_REL);
+	else
+		hrtimer_start(&gp->t,
+			      ktime_set(0,gp->pwm.channels[0].period_ticks
+					- gp->pwm.channels[0].duty_ticks),
+			      HRTIMER_MODE_REL);
+	return HRTIMER_NORESTART;
+}
+
+static void gpio_pwm_start(struct pwm_channel *p)
+{
+	struct gpio_pwm *gp = to_gpio_pwm(p);
+
+	gp->active = 0;
+	gpio_pwm_timeout(&gp->t);
+	pr_debug("%s:%d start, %lu ticks\n",
+		 dev_name(p->pwm->dev), p->chan, p->duty_ticks);
+}
+
+static int
+gpio_pwm_config_nosleep(struct pwm_channel *p,
+			struct pwm_channel_config *c)
+{
+	struct gpio_pwm *gp = to_gpio_pwm(p);
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->lock, flags);
+
+	switch (c->config_mask) {
+
+	case PWM_CONFIG_DUTY_TICKS:
+		p->duty_ticks = c->duty_ticks;
+		dev_dbg(p->pwm->dev, ":%d duty_ticks %lu\n",
+			p->chan, p->duty_ticks);
+		break;
+
+	case PWM_CONFIG_START:
+		if (!hrtimer_active(&gp->t)) {
+			gpio_pwm_start(p);
+		}
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	spin_unlock_irqrestore(&p->lock, flags);
+	return ret;
+}
+
+static int
+gpio_pwm_stop_sync(struct pwm_channel *p)
+{
+	struct gpio_pwm *gp = to_gpio_pwm(p);
+	int ret;
+	int was_on = hrtimer_active(&gp->t);
+
+	if (was_on) {
+		do {
+			init_completion(&p->complete);
+			set_bit(FLAG_STOP, &p->flags);
+
+			dev_dbg(p->pwm->dev, ":%d waiting on stop_sync completion...\n",
+				p->chan);
+
+			ret = wait_for_completion_interruptible(&p->complete);
+
+			dev_dbg(p->pwm->dev, ":%d stop_sync complete (%d)\n",
+				p->chan, ret);
+
+			if (ret)
+				return ret;
+		} while (p->flags & BIT(FLAG_STOP));
+	}
+
+	dev_dbg(p->pwm->dev, ":%d stop_sync returning %d\n",
+		p->chan, was_on);
+
+	return was_on;
+}
+
+static int
+gpio_pwm_config(struct pwm_channel *p,
+		struct pwm_channel_config *c)
+{
+	struct gpio_pwm *gp = to_gpio_pwm(p);
+	int was_on = 0;
+
+	if (p->pwm->config_nosleep) {
+		if (!p->pwm->config_nosleep(p, c))
+			return 0;
+	}
+
+	might_sleep();
+	dev_dbg(p->pwm->dev, ":%d config_mask %x\n",
+		p->chan, c->config_mask);
+
+	was_on = gpio_pwm_stop_sync(p);
+	if (was_on < 0)
+		return was_on;
+
+	if (c->config_mask & PWM_CONFIG_PERIOD_TICKS)
+		p->period_ticks = c->period_ticks;
+
+	if (c->config_mask & PWM_CONFIG_DUTY_TICKS)
+		p->duty_ticks = c->duty_ticks;
+
+	if (c->config_mask & PWM_CONFIG_POLARITY)
+		gp->polarity = c->polarity ? 1 : 0;
+
+	if ((c->config_mask & PWM_CONFIG_START)
+	    || (was_on && !(c->config_mask & PWM_CONFIG_STOP)))
+		gpio_pwm_start(p);
+
+	return 0;
+}
+
+static int
+gpio_pwm_set_callback(struct pwm_channel *p,
+		      pwm_callback_t callback)
+{
+	struct gpio_pwm *gp = to_gpio_pwm(p);
+	gp->callback = callback;
+	return 0;
+}
+
+static int
+gpio_pwm_request(struct pwm_channel *p)
+{
+	p->tick_hz = 1000000000UL;
+	return 0;
+}
+
+static int __devinit
+gpio_pwm_probe(struct platform_device *pdev)
+{
+	struct gpio_pwm *gp;
+	struct gpio_pwm_platform_data *gpd = pdev->dev.platform_data;
+	int ret = 0;
+
+	/* TODO: create configfs entries, so users can assign GPIOs to
+	 * PWMs at runtime instead of creating a platform_device
+	 * specification and rebuilding their kernel */
+
+	if (!gpd || gpio_request(gpd->gpio, dev_name(&pdev->dev)))
+		return -EINVAL;
+
+	gp = kzalloc(sizeof(*gp), GFP_KERNEL);
+	if (!gp) {
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+
+	platform_set_drvdata(pdev, gp);
+
+	gp->pwm.dev = &pdev->dev;
+	gp->pwm.bus_id = dev_name(&pdev->dev);
+	gp->pwm.nchan = 1;
+	gp->gpio = gpd->gpio;
+
+	INIT_WORK(&gp->work, gpio_pwm_work);
+
+	hrtimer_init(&gp->t, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	gp->t.function = gpio_pwm_timeout;
+
+	gp->pwm.owner = THIS_MODULE;
+	gp->pwm.config_nosleep = gpio_pwm_config_nosleep;
+	gp->pwm.config = gpio_pwm_config;
+	gp->pwm.request = gpio_pwm_request;
+	gp->pwm.set_callback = gpio_pwm_set_callback;
+
+	ret = pwm_register(&gp->pwm);
+	if (ret)
+		goto err_pwm_register;
+
+	return 0;
+
+err_pwm_register:
+	kfree(gp);
+err_alloc:
+	return ret;
+}
+
+static int __devexit
+gpio_pwm_remove(struct platform_device *pdev)
+{
+	struct gpio_pwm *gp = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = pwm_unregister(&gp->pwm);
+	hrtimer_cancel(&gp->t);
+	cancel_work_sync(&gp->work);
+	kfree(gp);
+
+	return 0;
+}
+
+static struct platform_driver gpio_pwm_driver = {
+	.driver = {
+		.name = "gpio_pwm",
+		.owner = THIS_MODULE,
+	},
+	.probe = gpio_pwm_probe,
+	.remove = __devexit_p(gpio_pwm_remove),
+};
+
+static int __init gpio_pwm_init(void)
+{
+	return platform_driver_register(&gpio_pwm_driver);
+}
+module_init(gpio_pwm_init);
+
+static void __exit gpio_pwm_exit(void)
+{
+	platform_driver_unregister(&gpio_pwm_driver);
+}
+module_exit(gpio_pwm_exit);
+
+MODULE_AUTHOR("Bill Gatliff <bgat@billgatliff.com>");
+MODULE_DESCRIPTION("PWM output using GPIO and a high-resolution timer");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:gpio_pwm");
-- 
1.6.5

