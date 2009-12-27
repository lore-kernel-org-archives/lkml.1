Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbZL0Vxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbZL0Vxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbZL0Vxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:53:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56472 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbZL0Vxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:53:45 -0500
Date: Sun, 27 Dec 2009 22:53:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Arve Hj?nnev?g <arve@android.com>, Daniel Walker <dwalker@codeaurora.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org,
       Greg KH <greg@kroah.com>
Subject: Re: tree with htc dream support
Message-ID: <20091227215324.GA7766@elf.ucw.cz>
References: <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
 <1260627482.20913.7.camel@desktop>
 <d6200be20912121434x1a247837w75c518ba20fe684f@mail.gmail.com>
 <20091213212504.GD5114@elf.ucw.cz>
 <d6200be20912142234ia050c67p34fd2672e7248170@mail.gmail.com>
 <20091227093537.GD11737@elf.ucw.cz>
 <20091227201514.GA29174@elf.ucw.cz>
 <a55d774e0912271220p1d102b1dr398e0524c9386702@mail.gmail.com>
 <20091227203704.GK11737@elf.ucw.cz>
 <20091227211322.GB29174@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091227211322.GB29174@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This switches gpio_ code and touchscreen driver to the version in
staging tree; removing 2KLoC.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 42a5a5a..17a0bb4 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_INPUT_BFIN_ROTARY)		+= bfin_rotary.o
 obj-$(CONFIG_INPUT_CM109)		+= cm109.o
 obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
-obj-$(CONFIG_INPUT_GPIO)		+= gpio_event.o gpio_matrix.o gpio_input.o gpio_output.o gpio_axis.o
+obj-$(CONFIG_INPUT_GPIO)		+= ../../staging/dream/gpio_event.o ../../staging/dream/gpio_matrix.o ../../staging/dream/gpio_input.o ../../staging/dream/gpio_output.o ../../staging/dream/gpio_axis.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
 obj-$(CONFIG_INPUT_KEYCHORD)		+= keychord.o
diff --git a/drivers/input/misc/gpio_axis.c b/drivers/input/misc/gpio_axis.c
deleted file mode 100644
index 30b9f56..0000000
--- a/drivers/input/misc/gpio_axis.c
+++ /dev/null
@@ -1,191 +0,0 @@
-/* drivers/input/misc/gpio_axis.c
- *
- * Copyright (C) 2007 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/gpio.h>
-#include <linux/gpio_event.h>
-#include <linux/interrupt.h>
-
-struct gpio_axis_state {
-	struct gpio_event_input_devs *input_devs;
-	struct gpio_event_axis_info *info;
-	uint32_t pos;
-};
-
-uint16_t gpio_axis_4bit_gray_map_table[] = {
-	[0x0] = 0x0, [0x1] = 0x1, /* 0000 0001 */
-	[0x3] = 0x2, [0x2] = 0x3, /* 0011 0010 */
-	[0x6] = 0x4, [0x7] = 0x5, /* 0110 0111 */
-	[0x5] = 0x6, [0x4] = 0x7, /* 0101 0100 */
-	[0xc] = 0x8, [0xd] = 0x9, /* 1100 1101 */
-	[0xf] = 0xa, [0xe] = 0xb, /* 1111 1110 */
-	[0xa] = 0xc, [0xb] = 0xd, /* 1010 1011 */
-	[0x9] = 0xe, [0x8] = 0xf, /* 1001 1000 */
-};
-uint16_t gpio_axis_4bit_gray_map(struct gpio_event_axis_info *info, uint16_t in)
-{
-	return gpio_axis_4bit_gray_map_table[in];
-}
-
-uint16_t gpio_axis_5bit_singletrack_map_table[] = {
-	[0x10] = 0x00, [0x14] = 0x01, [0x1c] = 0x02, /*     10000 10100 11100 */
-	[0x1e] = 0x03, [0x1a] = 0x04, [0x18] = 0x05, /*     11110 11010 11000 */
-	[0x08] = 0x06, [0x0a] = 0x07, [0x0e] = 0x08, /*    01000 01010 01110  */
-	[0x0f] = 0x09, [0x0d] = 0x0a, [0x0c] = 0x0b, /*    01111 01101 01100  */
-	[0x04] = 0x0c, [0x05] = 0x0d, [0x07] = 0x0e, /*   00100 00101 00111   */
-	[0x17] = 0x0f, [0x16] = 0x10, [0x06] = 0x11, /*   10111 10110 00110   */
-	[0x02] = 0x12, [0x12] = 0x13, [0x13] = 0x14, /*  00010 10010 10011    */
-	[0x1b] = 0x15, [0x0b] = 0x16, [0x03] = 0x17, /*  11011 01011 00011    */
-	[0x01] = 0x18, [0x09] = 0x19, [0x19] = 0x1a, /* 00001 01001 11001     */
-	[0x1d] = 0x1b, [0x15] = 0x1c, [0x11] = 0x1d, /* 11101 10101 10001     */
-};
-uint16_t gpio_axis_5bit_singletrack_map(
-	struct gpio_event_axis_info *info, uint16_t in)
-{
-	return gpio_axis_5bit_singletrack_map_table[in];
-}
-
-static void gpio_event_update_axis(struct gpio_axis_state *as, int report)
-{
-	struct gpio_event_axis_info *ai = as->info;
-	int i;
-	int change;
-	uint16_t state = 0;
-	uint16_t pos;
-	uint16_t old_pos = as->pos;
-	for (i = ai->count - 1; i >= 0; i--)
-		state = (state << 1) | gpio_get_value(ai->gpio[i]);
-	pos = ai->map(ai, state);
-	if (ai->flags & GPIOEAF_PRINT_RAW)
-		pr_info("axis %d-%d raw %x, pos %d -> %d\n",
-			ai->type, ai->code, state, old_pos, pos);
-	if (report && pos != old_pos) {
-		if (ai->type == EV_REL) {
-			change = (ai->decoded_size + pos - old_pos) %
-				  ai->decoded_size;
-			if (change > ai->decoded_size / 2)
-				change -= ai->decoded_size;
-			if (change == ai->decoded_size / 2) {
-				if (ai->flags & GPIOEAF_PRINT_EVENT)
-					pr_info("axis %d-%d unknown direction, "
-						"pos %d -> %d\n", ai->type,
-						ai->code, old_pos, pos);
-				change = 0; /* no closest direction */
-			}
-			if (ai->flags & GPIOEAF_PRINT_EVENT)
-				pr_info("axis %d-%d change %d\n",
-					ai->type, ai->code, change);
-			input_report_rel(as->input_devs->dev[ai->dev],
-						ai->code, change);
-		} else {
-			if (ai->flags & GPIOEAF_PRINT_EVENT)
-				pr_info("axis %d-%d now %d\n",
-					ai->type, ai->code, pos);
-			input_event(as->input_devs->dev[ai->dev],
-					ai->type, ai->code, pos);
-		}
-		input_sync(as->input_devs->dev[ai->dev]);
-	}
-	as->pos = pos;
-}
-
-static irqreturn_t gpio_axis_irq_handler(int irq, void *dev_id)
-{
-	struct gpio_axis_state *as = dev_id;
-	gpio_event_update_axis(as, 1);
-	return IRQ_HANDLED;
-}
-
-int gpio_event_axis_func(struct gpio_event_input_devs *input_devs,
-			 struct gpio_event_info *info, void **data, int func)
-{
-	int ret;
-	int i;
-	int irq;
-	struct gpio_event_axis_info *ai;
-	struct gpio_axis_state *as;
-
-	ai = container_of(info, struct gpio_event_axis_info, info);
-	if (func == GPIO_EVENT_FUNC_SUSPEND) {
-		for (i = 0; i < ai->count; i++)
-			disable_irq(gpio_to_irq(ai->gpio[i]));
-		return 0;
-	}
-	if (func == GPIO_EVENT_FUNC_RESUME) {
-		for (i = 0; i < ai->count; i++)
-			enable_irq(gpio_to_irq(ai->gpio[i]));
-		return 0;
-	}
-
-	if (func == GPIO_EVENT_FUNC_INIT) {
-		*data = as = kmalloc(sizeof(*as), GFP_KERNEL);
-		if (as == NULL) {
-			ret = -ENOMEM;
-			goto err_alloc_axis_state_failed;
-		}
-		as->input_devs = input_devs;
-		as->info = ai;
-		if (ai->dev >= input_devs->count) {
-			pr_err("gpio_event_axis: bad device index %d >= %d "
-				"for %d:%d\n", ai->dev, input_devs->count,
-				ai->type, ai->code);
-			ret = -EINVAL;
-			goto err_bad_device_index;
-		}
-
-		input_set_capability(input_devs->dev[ai->dev],
-				     ai->type, ai->code);
-		if (ai->type == EV_ABS) {
-			input_set_abs_params(input_devs->dev[ai->dev], ai->code,
-					     0, ai->decoded_size - 1, 0, 0);
-		}
-		for (i = 0; i < ai->count; i++) {
-			ret = gpio_request(ai->gpio[i], "gpio_event_axis");
-			if (ret < 0)
-				goto err_request_gpio_failed;
-			ret = gpio_direction_input(ai->gpio[i]);
-			if (ret < 0)
-				goto err_gpio_direction_input_failed;
-			ret = irq = gpio_to_irq(ai->gpio[i]);
-			if (ret < 0)
-				goto err_get_irq_num_failed;
-			ret = request_irq(irq, gpio_axis_irq_handler,
-					  IRQF_TRIGGER_RISING |
-					  IRQF_TRIGGER_FALLING,
-					  "gpio_event_axis", as);
-			if (ret < 0)
-				goto err_request_irq_failed;
-		}
-		gpio_event_update_axis(as, 0);
-		return 0;
-	}
-
-	ret = 0;
-	as = *data;
-	for (i = ai->count - 1; i >= 0; i--) {
-		free_irq(gpio_to_irq(ai->gpio[i]), as);
-err_request_irq_failed:
-err_get_irq_num_failed:
-err_gpio_direction_input_failed:
-		gpio_free(ai->gpio[i]);
-err_request_gpio_failed:
-		;
-	}
-err_bad_device_index:
-	kfree(as);
-	*data = NULL;
-err_alloc_axis_state_failed:
-	return ret;
-}
diff --git a/drivers/input/misc/gpio_event.c b/drivers/input/misc/gpio_event.c
deleted file mode 100644
index 139b360..0000000
--- a/drivers/input/misc/gpio_event.c
+++ /dev/null
@@ -1,259 +0,0 @@
-/* drivers/input/misc/gpio_event.c
- *
- * Copyright (C) 2007 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/earlysuspend.h>
-#include <linux/module.h>
-#include <linux/input.h>
-#include <linux/gpio_event.h>
-#include <linux/hrtimer.h>
-#include <linux/platform_device.h>
-
-struct gpio_event {
-	struct gpio_event_input_devs *input_devs;
-	const struct gpio_event_platform_data *info;
-	struct early_suspend early_suspend;
-	void *state[0];
-};
-
-static int gpio_input_event(
-	struct input_dev *dev, unsigned int type, unsigned int code, int value)
-{
-	int i;
-	int devnr;
-	int ret = 0;
-	int tmp_ret;
-	struct gpio_event_info **ii;
-	struct gpio_event *ip = input_get_drvdata(dev);
-
-	for (devnr = 0; devnr < ip->input_devs->count; devnr++)
-		if (ip->input_devs->dev[devnr] == dev)
-			break;
-	if (devnr == ip->input_devs->count) {
-		pr_err("gpio_input_event: unknown device %p\n", dev);
-		return -EIO;
-	}
-
-	for (i = 0, ii = ip->info->info; i < ip->info->info_count; i++, ii++) {
-		if ((*ii)->event) {
-			tmp_ret = (*ii)->event(ip->input_devs, *ii,
-						&ip->state[i],
-						devnr, type, code, value);
-			if (tmp_ret)
-				ret = tmp_ret;
-		}
-	}
-	return ret;
-}
-
-static int gpio_event_call_all_func(struct gpio_event *ip, int func)
-{
-	int i;
-	int ret;
-	struct gpio_event_info **ii;
-
-	if (func == GPIO_EVENT_FUNC_INIT || func == GPIO_EVENT_FUNC_RESUME) {
-		ii = ip->info->info;
-		for (i = 0; i < ip->info->info_count; i++, ii++) {
-			if ((*ii)->func == NULL) {
-				ret = -ENODEV;
-				pr_err("gpio_event_probe: Incomplete pdata, "
-					"no function\n");
-				goto err_no_func;
-			}
-			if (func == GPIO_EVENT_FUNC_RESUME && (*ii)->no_suspend)
-				continue;
-			ret = (*ii)->func(ip->input_devs, *ii, &ip->state[i],
-					  func);
-			if (ret) {
-				pr_err("gpio_event_probe: function failed\n");
-				goto err_func_failed;
-			}
-		}
-		return 0;
-	}
-
-	ret = 0;
-	i = ip->info->info_count;
-	ii = ip->info->info + i;
-	while (i > 0) {
-		i--;
-		ii--;
-		if ((func & ~1) == GPIO_EVENT_FUNC_SUSPEND && (*ii)->no_suspend)
-			continue;
-		(*ii)->func(ip->input_devs, *ii, &ip->state[i], func & ~1);
-err_func_failed:
-err_no_func:
-		;
-	}
-	return ret;
-}
-
-#ifdef CONFIG_HAS_EARLYSUSPEND
-void gpio_event_suspend(struct early_suspend *h)
-{
-	struct gpio_event *ip;
-	ip = container_of(h, struct gpio_event, early_suspend);
-	gpio_event_call_all_func(ip, GPIO_EVENT_FUNC_SUSPEND);
-	ip->info->power(ip->info, 0);
-}
-
-void gpio_event_resume(struct early_suspend *h)
-{
-	struct gpio_event *ip;
-	ip = container_of(h, struct gpio_event, early_suspend);
-	ip->info->power(ip->info, 1);
-	gpio_event_call_all_func(ip, GPIO_EVENT_FUNC_RESUME);
-}
-#endif
-
-static int __init gpio_event_probe(struct platform_device *pdev)
-{
-	int err;
-	struct gpio_event *ip;
-	struct gpio_event_platform_data *event_info;
-	int dev_count = 1;
-	int i;
-	int registered = 0;
-
-	event_info = pdev->dev.platform_data;
-	if (event_info == NULL) {
-		pr_err("gpio_event_probe: No pdata\n");
-		return -ENODEV;
-	}
-	if ((!event_info->name && !event_info->names[0]) ||
-	    !event_info->info || !event_info->info_count) {
-		pr_err("gpio_event_probe: Incomplete pdata\n");
-		return -ENODEV;
-	}
-	if (!event_info->name)
-		while (event_info->names[dev_count])
-			dev_count++;
-	ip = kzalloc(sizeof(*ip) +
-		     sizeof(ip->state[0]) * event_info->info_count +
-		     sizeof(*ip->input_devs) +
-		     sizeof(ip->input_devs->dev[0]) * dev_count, GFP_KERNEL);
-	if (ip == NULL) {
-		err = -ENOMEM;
-		pr_err("gpio_event_probe: Failed to allocate private data\n");
-		goto err_kp_alloc_failed;
-	}
-	ip->input_devs = (void*)&ip->state[event_info->info_count];
-	platform_set_drvdata(pdev, ip);
-
-	for (i = 0; i < dev_count; i++) {
-		struct input_dev *input_dev = input_allocate_device();
-		if (input_dev == NULL) {
-			err = -ENOMEM;
-			pr_err("gpio_event_probe: "
-				"Failed to allocate input device\n");
-			goto err_input_dev_alloc_failed;
-		}
-		input_set_drvdata(input_dev, ip);
-		input_dev->name = event_info->name ?
-					event_info->name : event_info->names[i];
-		input_dev->event = gpio_input_event;
-		ip->input_devs->dev[i] = input_dev;
-	}
-	ip->input_devs->count = dev_count;
-	ip->info = event_info;
-	if (event_info->power) {
-#ifdef CONFIG_HAS_EARLYSUSPEND
-		ip->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 1;
-		ip->early_suspend.suspend = gpio_event_suspend;
-		ip->early_suspend.resume = gpio_event_resume;
-		register_early_suspend(&ip->early_suspend);
-#endif
-		ip->info->power(ip->info, 1);
-	}
-
-	err = gpio_event_call_all_func(ip, GPIO_EVENT_FUNC_INIT);
-	if (err)
-		goto err_call_all_func_failed;
-
-	for (i = 0; i < dev_count; i++) {
-		err = input_register_device(ip->input_devs->dev[i]);
-		if (err) {
-			pr_err("gpio_event_probe: Unable to register %s "
-				"input device\n", ip->input_devs->dev[i]->name);
-			goto err_input_register_device_failed;
-		}
-		registered++;
-	}
-
-	return 0;
-
-err_input_register_device_failed:
-	gpio_event_call_all_func(ip, GPIO_EVENT_FUNC_UNINIT);
-err_call_all_func_failed:
-	if (event_info->power) {
-#ifdef CONFIG_HAS_EARLYSUSPEND
-		unregister_early_suspend(&ip->early_suspend);
-#endif
-		ip->info->power(ip->info, 0);
-	}
-	for (i = 0; i < registered; i++)
-		input_unregister_device(ip->input_devs->dev[i]);
-	for (i = dev_count - 1; i >= registered; i--) {
-		input_free_device(ip->input_devs->dev[i]);
-err_input_dev_alloc_failed:
-		;
-	}
-	kfree(ip);
-err_kp_alloc_failed:
-	return err;
-}
-
-static int gpio_event_remove(struct platform_device *pdev)
-{
-	struct gpio_event *ip = platform_get_drvdata(pdev);
-	int i;
-
-	gpio_event_call_all_func(ip, GPIO_EVENT_FUNC_UNINIT);
-	if (ip->info->power) {
-#ifdef CONFIG_HAS_EARLYSUSPEND
-		unregister_early_suspend(&ip->early_suspend);
-#endif
-		ip->info->power(ip->info, 0);
-	}
-	for (i = 0; i < ip->input_devs->count; i++)
-		input_unregister_device(ip->input_devs->dev[i]);
-	kfree(ip);
-	return 0;
-}
-
-static struct platform_driver gpio_event_driver = {
-	.probe		= gpio_event_probe,
-	.remove		= gpio_event_remove,
-	.driver		= {
-		.name	= GPIO_EVENT_DEV_NAME,
-	},
-};
-
-static int __devinit gpio_event_init(void)
-{
-	return platform_driver_register(&gpio_event_driver);
-}
-
-static void __exit gpio_event_exit(void)
-{
-	platform_driver_unregister(&gpio_event_driver);
-}
-
-module_init(gpio_event_init);
-module_exit(gpio_event_exit);
-
-MODULE_DESCRIPTION("GPIO Event Driver");
-MODULE_LICENSE("GPL");
-
diff --git a/drivers/input/misc/gpio_input.c b/drivers/input/misc/gpio_input.c
deleted file mode 100644
index 7e66f8c..0000000
--- a/drivers/input/misc/gpio_input.c
+++ /dev/null
@@ -1,352 +0,0 @@
-/* drivers/input/misc/gpio_input.c
- *
- * Copyright (C) 2007 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/gpio.h>
-#include <linux/gpio_event.h>
-#include <linux/hrtimer.h>
-#include <linux/input.h>
-#include <linux/interrupt.h>
-#include <linux/wakelock.h>
-
-enum {
-	DEBOUNCE_UNSTABLE     = BIT(0),	/* Got irq, while debouncing */
-	DEBOUNCE_PRESSED      = BIT(1),
-	DEBOUNCE_NOTPRESSED   = BIT(2),
-	DEBOUNCE_WAIT_IRQ     = BIT(3),	/* Stable irq state */
-	DEBOUNCE_POLL         = BIT(4),	/* Stable polling state */
-
-	DEBOUNCE_UNKNOWN =
-		DEBOUNCE_PRESSED | DEBOUNCE_NOTPRESSED,
-};
-
-struct gpio_key_state {
-	struct gpio_input_state *ds;
-	uint8_t debounce;
-};
-
-struct gpio_input_state {
-	struct gpio_event_input_devs *input_devs;
-	const struct gpio_event_input_info *info;
-	struct hrtimer timer;
-	int use_irq;
-	int debounce_count;
-	spinlock_t irq_lock;
-	struct wake_lock wake_lock;
-	struct gpio_key_state key_state[0];
-};
-
-static enum hrtimer_restart gpio_event_input_timer_func(struct hrtimer *timer)
-{
-	int i;
-	int pressed;
-	struct gpio_input_state *ds =
-		container_of(timer, struct gpio_input_state, timer);
-	unsigned gpio_flags = ds->info->flags;
-	unsigned npolarity;
-	int nkeys = ds->info->keymap_size;
-	const struct gpio_event_direct_entry *key_entry;
-	struct gpio_key_state *key_state;
-	unsigned long irqflags;
-	uint8_t debounce;
-
-#if 0
-	key_entry = kp->keys_info->keymap;
-	key_state = kp->key_state;
-	for (i = 0; i < nkeys; i++, key_entry++, key_state++)
-		pr_info("gpio_read_detect_status %d %d\n", key_entry->gpio,
-			gpio_read_detect_status(key_entry->gpio));
-#endif
-	key_entry = ds->info->keymap;
-	key_state = ds->key_state;
-	spin_lock_irqsave(&ds->irq_lock, irqflags);
-	for (i = 0; i < nkeys; i++, key_entry++, key_state++) {
-		debounce = key_state->debounce;
-		if (debounce & DEBOUNCE_WAIT_IRQ)
-			continue;
-		if (key_state->debounce & DEBOUNCE_UNSTABLE) {
-			debounce = key_state->debounce = DEBOUNCE_UNKNOWN;
-			enable_irq(gpio_to_irq(key_entry->gpio));
-			pr_info("gpio_keys_scan_keys: key %x-%x, %d "
-				"(%d) continue debounce\n",
-				ds->info->type, key_entry->code,
-				i, key_entry->gpio);
-		}
-		npolarity = !(gpio_flags & GPIOEDF_ACTIVE_HIGH);
-		pressed = gpio_get_value(key_entry->gpio) ^ npolarity;
-		if (debounce & DEBOUNCE_POLL) {
-			if (pressed == !(debounce & DEBOUNCE_PRESSED)) {
-				ds->debounce_count++;
-				key_state->debounce = DEBOUNCE_UNKNOWN;
-				if (gpio_flags & GPIOEDF_PRINT_KEY_DEBOUNCE)
-					pr_info("gpio_keys_scan_keys: key %x-"
-						"%x, %d (%d) start debounce\n",
-						ds->info->type, key_entry->code,
-						i, key_entry->gpio);
-			}
-			continue;
-		}
-		if (pressed && (debounce & DEBOUNCE_NOTPRESSED)) {
-			if (gpio_flags & GPIOEDF_PRINT_KEY_DEBOUNCE)
-				pr_info("gpio_keys_scan_keys: key %x-%x, %d "
-					"(%d) debounce pressed 1\n",
-					ds->info->type, key_entry->code,
-					i, key_entry->gpio);
-			key_state->debounce = DEBOUNCE_PRESSED;
-			continue;
-		}
-		if (!pressed && (debounce & DEBOUNCE_PRESSED)) {
-			if (gpio_flags & GPIOEDF_PRINT_KEY_DEBOUNCE)
-				pr_info("gpio_keys_scan_keys: key %x-%x, %d "
-					"(%d) debounce pressed 0\n",
-					ds->info->type, key_entry->code,
-					i, key_entry->gpio);
-			key_state->debounce = DEBOUNCE_NOTPRESSED;
-			continue;
-		}
-		/* key is stable */
-		ds->debounce_count--;
-		if (ds->use_irq)
-			key_state->debounce |= DEBOUNCE_WAIT_IRQ;
-		else
-			key_state->debounce |= DEBOUNCE_POLL;
-		if (gpio_flags & GPIOEDF_PRINT_KEYS)
-			pr_info("gpio_keys_scan_keys: key %x-%x, %d (%d) "
-				"changed to %d\n", ds->info->type,
-				key_entry->code, i, key_entry->gpio, pressed);
-		input_event(ds->input_devs->dev[key_entry->dev], ds->info->type,
-			    key_entry->code, pressed);
-	}
-
-#if 0
-	key_entry = kp->keys_info->keymap;
-	key_state = kp->key_state;
-	for (i = 0; i < nkeys; i++, key_entry++, key_state++) {
-		pr_info("gpio_read_detect_status %d %d\n", key_entry->gpio,
-			gpio_read_detect_status(key_entry->gpio));
-	}
-#endif
-
-	if (ds->debounce_count)
-		hrtimer_start(timer, ds->info->debounce_time, HRTIMER_MODE_REL);
-	else if (!ds->use_irq)
-		hrtimer_start(timer, ds->info->poll_time, HRTIMER_MODE_REL);
-	else
-		wake_unlock(&ds->wake_lock);
-
-	spin_unlock_irqrestore(&ds->irq_lock, irqflags);
-
-	return HRTIMER_NORESTART;
-}
-
-static irqreturn_t gpio_event_input_irq_handler(int irq, void *dev_id)
-{
-	struct gpio_key_state *ks = dev_id;
-	struct gpio_input_state *ds = ks->ds;
-	int keymap_index = ks - ds->key_state;
-	const struct gpio_event_direct_entry *key_entry;
-	unsigned long irqflags;
-	int pressed;
-
-	if (!ds->use_irq)
-		return IRQ_HANDLED;
-
-	key_entry = &ds->info->keymap[keymap_index];
-
-	if (ds->info->debounce_time.tv64) {
-		spin_lock_irqsave(&ds->irq_lock, irqflags);
-		if (ks->debounce & DEBOUNCE_WAIT_IRQ) {
-			ks->debounce = DEBOUNCE_UNKNOWN;
-			if (ds->debounce_count++ == 0) {
-				wake_lock(&ds->wake_lock);
-				hrtimer_start(
-					&ds->timer, ds->info->debounce_time,
-					HRTIMER_MODE_REL);
-			}
-			if (ds->info->flags & GPIOEDF_PRINT_KEY_DEBOUNCE)
-				pr_info("gpio_event_input_irq_handler: "
-					"key %x-%x, %d (%d) start debounce\n",
-					ds->info->type, key_entry->code,
-					keymap_index, key_entry->gpio);
-		} else {
-			disable_irq_nosync(irq);
-			ks->debounce = DEBOUNCE_UNSTABLE;
-		}
-		spin_unlock_irqrestore(&ds->irq_lock, irqflags);
-	} else {
-		pressed = gpio_get_value(key_entry->gpio) ^
-			!(ds->info->flags & GPIOEDF_ACTIVE_HIGH);
-		if (ds->info->flags & GPIOEDF_PRINT_KEYS)
-			pr_info("gpio_event_input_irq_handler: key %x-%x, %d "
-				"(%d) changed to %d\n",
-				ds->info->type, key_entry->code, keymap_index,
-				key_entry->gpio, pressed);
-		input_event(ds->input_devs->dev[key_entry->dev], ds->info->type,
-			    key_entry->code, pressed);
-	}
-	return IRQ_HANDLED;
-}
-
-static int gpio_event_input_request_irqs(struct gpio_input_state *ds)
-{
-	int i;
-	int err;
-	unsigned int irq;
-	unsigned long req_flags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING;
-
-	for (i = 0; i < ds->info->keymap_size; i++) {
-		err = irq = gpio_to_irq(ds->info->keymap[i].gpio);
-		if (err < 0)
-			goto err_gpio_get_irq_num_failed;
-		err = request_irq(irq, gpio_event_input_irq_handler,
-				  req_flags, "gpio_keys", &ds->key_state[i]);
-		if (err) {
-			pr_err("gpio_event_input_request_irqs: request_irq "
-				"failed for input %d, irq %d\n",
-				ds->info->keymap[i].gpio, irq);
-			goto err_request_irq_failed;
-		}
-		enable_irq_wake(irq);
-	}
-	return 0;
-
-	for (i = ds->info->keymap_size - 1; i >= 0; i--) {
-		free_irq(gpio_to_irq(ds->info->keymap[i].gpio),
-			 &ds->key_state[i]);
-err_request_irq_failed:
-err_gpio_get_irq_num_failed:
-		;
-	}
-	return err;
-}
-
-int gpio_event_input_func(struct gpio_event_input_devs *input_devs,
-			struct gpio_event_info *info, void **data, int func)
-{
-	int ret;
-	int i;
-	unsigned long irqflags;
-	struct gpio_event_input_info *di;
-	struct gpio_input_state *ds = *data;
-
-	di = container_of(info, struct gpio_event_input_info, info);
-
-	if (func == GPIO_EVENT_FUNC_SUSPEND) {
-		if (ds->use_irq)
-			for (i = 0; i < di->keymap_size; i++)
-				disable_irq(gpio_to_irq(di->keymap[i].gpio));
-		hrtimer_cancel(&ds->timer);
-		return 0;
-	}
-	if (func == GPIO_EVENT_FUNC_RESUME) {
-		spin_lock_irqsave(&ds->irq_lock, irqflags);
-		if (ds->use_irq)
-			for (i = 0; i < di->keymap_size; i++)
-				enable_irq(gpio_to_irq(di->keymap[i].gpio));
-		hrtimer_start(&ds->timer, ktime_set(0, 0), HRTIMER_MODE_REL);
-		spin_unlock_irqrestore(&ds->irq_lock, irqflags);
-		return 0;
-	}
-
-	if (func == GPIO_EVENT_FUNC_INIT) {
-		if (ktime_to_ns(di->poll_time) <= 0)
-			di->poll_time = ktime_set(0, 20 * NSEC_PER_MSEC);
-
-		*data = ds = kzalloc(sizeof(*ds) + sizeof(ds->key_state[0]) *
-					di->keymap_size, GFP_KERNEL);
-		if (ds == NULL) {
-			ret = -ENOMEM;
-			pr_err("gpio_event_input_func: "
-				"Failed to allocate private data\n");
-			goto err_ds_alloc_failed;
-		}
-		ds->debounce_count = di->keymap_size;
-		ds->input_devs = input_devs;
-		ds->info = di;
-		wake_lock_init(&ds->wake_lock, WAKE_LOCK_SUSPEND, "gpio_input");
-		spin_lock_init(&ds->irq_lock);
-
-		for (i = 0; i < di->keymap_size; i++) {
-			int dev = di->keymap[i].dev;
-			if (dev >= input_devs->count) {
-				pr_err("gpio_event_input_func: bad device "
-					"index %d >= %d for key code %d\n",
-					dev, input_devs->count,
-					di->keymap[i].code);
-				ret = -EINVAL;
-				goto err_bad_keymap;
-			}
-			input_set_capability(input_devs->dev[dev], di->type,
-					     di->keymap[i].code);
-			ds->key_state[i].ds = ds;
-			ds->key_state[i].debounce = DEBOUNCE_UNKNOWN;
-		}
-
-		for (i = 0; i < di->keymap_size; i++) {
-			ret = gpio_request(di->keymap[i].gpio, "gpio_kp_in");
-			if (ret) {
-				pr_err("gpio_event_input_func: gpio_request "
-					"failed for %d\n", di->keymap[i].gpio);
-				goto err_gpio_request_failed;
-			}
-			ret = gpio_direction_input(di->keymap[i].gpio);
-			if (ret) {
-				pr_err("gpio_event_input_func: "
-					"gpio_direction_input failed for %d\n",
-					di->keymap[i].gpio);
-				goto err_gpio_configure_failed;
-			}
-		}
-
-		ret = gpio_event_input_request_irqs(ds);
-
-		spin_lock_irqsave(&ds->irq_lock, irqflags);
-		ds->use_irq = ret == 0;
-
-		pr_info("GPIO Input Driver: Start gpio inputs for %s%s in %s "
-			"mode\n", input_devs->dev[0]->name,
-			(input_devs->count > 1) ? "..." : "",
-			ret == 0 ? "interrupt" : "polling");
-
-		hrtimer_init(&ds->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-		ds->timer.function = gpio_event_input_timer_func;
-		hrtimer_start(&ds->timer, ktime_set(0, 0), HRTIMER_MODE_REL);
-		spin_unlock_irqrestore(&ds->irq_lock, irqflags);
-		return 0;
-	}
-
-	ret = 0;
-	spin_lock_irqsave(&ds->irq_lock, irqflags);
-	hrtimer_cancel(&ds->timer);
-	if (ds->use_irq) {
-		for (i = di->keymap_size - 1; i >= 0; i--) {
-			free_irq(gpio_to_irq(di->keymap[i].gpio),
-				 &ds->key_state[i]);
-		}
-	}
-	spin_unlock_irqrestore(&ds->irq_lock, irqflags);
-
-	for (i = di->keymap_size - 1; i >= 0; i--) {
-err_gpio_configure_failed:
-		gpio_free(di->keymap[i].gpio);
-err_gpio_request_failed:
-		;
-	}
-err_bad_keymap:
-	wake_lock_destroy(&ds->wake_lock);
-	kfree(ds);
-err_ds_alloc_failed:
-	return ret;
-}
diff --git a/drivers/input/misc/gpio_matrix.c b/drivers/input/misc/gpio_matrix.c
deleted file mode 100644
index 90866c4..0000000
--- a/drivers/input/misc/gpio_matrix.c
+++ /dev/null
@@ -1,422 +0,0 @@
-/* drivers/input/misc/gpio_matrix.c
- *
- * Copyright (C) 2007 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/gpio.h>
-#include <linux/gpio_event.h>
-#include <linux/hrtimer.h>
-#include <linux/interrupt.h>
-#include <linux/wakelock.h>
-
-struct gpio_kp {
-	struct gpio_event_input_devs *input_devs;
-	struct gpio_event_matrix_info *keypad_info;
-	struct hrtimer timer;
-	struct wake_lock wake_lock;
-	int current_output;
-	unsigned int use_irq:1;
-	unsigned int key_state_changed:1;
-	unsigned int last_key_state_changed:1;
-	unsigned int some_keys_pressed:2;
-	unsigned long keys_pressed[0];
-};
-
-static void clear_phantom_key(struct gpio_kp *kp, int out, int in)
-{
-	struct gpio_event_matrix_info *mi = kp->keypad_info;
-	int key_index = out * mi->ninputs + in;
-	unsigned short keyentry = mi->keymap[key_index];
-	unsigned short keycode = keyentry & MATRIX_KEY_MASK;
-	unsigned short dev = keyentry >> MATRIX_CODE_BITS;
-
-	if (!test_bit(keycode, kp->input_devs->dev[dev]->key)) {
-		if (mi->flags & GPIOKPF_PRINT_PHANTOM_KEYS)
-			pr_info("gpiomatrix: phantom key %x, %d-%d (%d-%d) "
-				"cleared\n", keycode, out, in,
-				mi->output_gpios[out], mi->input_gpios[in]);
-		__clear_bit(key_index, kp->keys_pressed);
-	} else {
-		if (mi->flags & GPIOKPF_PRINT_PHANTOM_KEYS)
-			pr_info("gpiomatrix: phantom key %x, %d-%d (%d-%d) "
-				"not cleared\n", keycode, out, in,
-				mi->output_gpios[out], mi->input_gpios[in]);
-	}
-}
-
-static int restore_keys_for_input(struct gpio_kp *kp, int out, int in)
-{
-	int rv = 0;
-	int key_index;
-
-	key_index = out * kp->keypad_info->ninputs + in;
-	while (out < kp->keypad_info->noutputs) {
-		if (test_bit(key_index, kp->keys_pressed)) {
-			rv = 1;
-			clear_phantom_key(kp, out, in);
-		}
-		key_index += kp->keypad_info->ninputs;
-		out++;
-	}
-	return rv;
-}
-
-static void remove_phantom_keys(struct gpio_kp *kp)
-{
-	int out, in, inp;
-	int key_index;
-
-	if (kp->some_keys_pressed < 3)
-		return;
-
-	for (out = 0; out < kp->keypad_info->noutputs; out++) {
-		inp = -1;
-		key_index = out * kp->keypad_info->ninputs;
-		for (in = 0; in < kp->keypad_info->ninputs; in++, key_index++) {
-			if (test_bit(key_index, kp->keys_pressed)) {
-				if (inp == -1) {
-					inp = in;
-					continue;
-				}
-				if (inp >= 0) {
-					if (!restore_keys_for_input(kp, out + 1,
-									inp))
-						break;
-					clear_phantom_key(kp, out, inp);
-					inp = -2;
-				}
-				restore_keys_for_input(kp, out, in);
-			}
-		}
-	}
-}
-
-static void report_key(struct gpio_kp *kp, int key_index, int out, int in)
-{
-	struct gpio_event_matrix_info *mi = kp->keypad_info;
-	int pressed = test_bit(key_index, kp->keys_pressed);
-	unsigned short keyentry = mi->keymap[key_index];
-	unsigned short keycode = keyentry & MATRIX_KEY_MASK;
-	unsigned short dev = keyentry >> MATRIX_CODE_BITS;
-
-	if (pressed != test_bit(keycode, kp->input_devs->dev[dev]->key)) {
-		if (keycode == KEY_RESERVED) {
-			if (mi->flags & GPIOKPF_PRINT_UNMAPPED_KEYS)
-				pr_info("gpiomatrix: unmapped key, %d-%d "
-					"(%d-%d) changed to %d\n",
-					out, in, mi->output_gpios[out],
-					mi->input_gpios[in], pressed);
-		} else {
-			if (mi->flags & GPIOKPF_PRINT_MAPPED_KEYS)
-				pr_info("gpiomatrix: key %x, %d-%d (%d-%d) "
-					"changed to %d\n", keycode,
-					out, in, mi->output_gpios[out],
-					mi->input_gpios[in], pressed);
-			input_report_key(kp->input_devs->dev[dev], keycode, pressed);
-		}
-	}
-}
-
-static enum hrtimer_restart gpio_keypad_timer_func(struct hrtimer *timer)
-{
-	int out, in;
-	int key_index;
-	int gpio;
-	struct gpio_kp *kp = container_of(timer, struct gpio_kp, timer);
-	struct gpio_event_matrix_info *mi = kp->keypad_info;
-	unsigned gpio_keypad_flags = mi->flags;
-	unsigned polarity = !!(gpio_keypad_flags & GPIOKPF_ACTIVE_HIGH);
-
-	out = kp->current_output;
-	if (out == mi->noutputs) {
-		out = 0;
-		kp->last_key_state_changed = kp->key_state_changed;
-		kp->key_state_changed = 0;
-		kp->some_keys_pressed = 0;
-	} else {
-		key_index = out * mi->ninputs;
-		for (in = 0; in < mi->ninputs; in++, key_index++) {
-			gpio = mi->input_gpios[in];
-			if (gpio_get_value(gpio) ^ !polarity) {
-				if (kp->some_keys_pressed < 3)
-					kp->some_keys_pressed++;
-				kp->key_state_changed |= !__test_and_set_bit(
-						key_index, kp->keys_pressed);
-			} else
-				kp->key_state_changed |= __test_and_clear_bit(
-						key_index, kp->keys_pressed);
-		}
-		gpio = mi->output_gpios[out];
-		if (gpio_keypad_flags & GPIOKPF_DRIVE_INACTIVE)
-			gpio_set_value(gpio, !polarity);
-		else
-			gpio_direction_input(gpio);
-		out++;
-	}
-	kp->current_output = out;
-	if (out < mi->noutputs) {
-		gpio = mi->output_gpios[out];
-		if (gpio_keypad_flags & GPIOKPF_DRIVE_INACTIVE)
-			gpio_set_value(gpio, polarity);
-		else
-			gpio_direction_output(gpio, polarity);
-		hrtimer_start(timer, mi->settle_time, HRTIMER_MODE_REL);
-		return HRTIMER_NORESTART;
-	}
-	if (gpio_keypad_flags & GPIOKPF_DEBOUNCE) {
-		if (kp->key_state_changed) {
-			hrtimer_start(&kp->timer, mi->debounce_delay,
-				      HRTIMER_MODE_REL);
-			return HRTIMER_NORESTART;
-		}
-		kp->key_state_changed = kp->last_key_state_changed;
-	}
-	if (kp->key_state_changed) {
-		if (gpio_keypad_flags & GPIOKPF_REMOVE_SOME_PHANTOM_KEYS)
-			remove_phantom_keys(kp);
-		key_index = 0;
-		for (out = 0; out < mi->noutputs; out++)
-			for (in = 0; in < mi->ninputs; in++, key_index++)
-				report_key(kp, key_index, out, in);
-	}
-	if (!kp->use_irq || kp->some_keys_pressed) {
-		hrtimer_start(timer, mi->poll_time, HRTIMER_MODE_REL);
-		return HRTIMER_NORESTART;
-	}
-
-	/* No keys are pressed, reenable interrupt */
-	for (out = 0; out < mi->noutputs; out++) {
-		if (gpio_keypad_flags & GPIOKPF_DRIVE_INACTIVE)
-			gpio_set_value(mi->output_gpios[out], polarity);
-		else
-			gpio_direction_output(mi->output_gpios[out], polarity);
-	}
-	for (in = 0; in < mi->ninputs; in++)
-		enable_irq(gpio_to_irq(mi->input_gpios[in]));
-	wake_unlock(&kp->wake_lock);
-	return HRTIMER_NORESTART;
-}
-
-static irqreturn_t gpio_keypad_irq_handler(int irq_in, void *dev_id)
-{
-	int i;
-	struct gpio_kp *kp = dev_id;
-	struct gpio_event_matrix_info *mi = kp->keypad_info;
-	unsigned gpio_keypad_flags = mi->flags;
-
-	if (!kp->use_irq) /* ignore interrupt while registering the handler */
-		return IRQ_HANDLED;
-
-	for (i = 0; i < mi->ninputs; i++)
-		disable_irq_nosync(gpio_to_irq(mi->input_gpios[i]));
-	for (i = 0; i < mi->noutputs; i++) {
-		if (gpio_keypad_flags & GPIOKPF_DRIVE_INACTIVE)
-			gpio_set_value(mi->output_gpios[i],
-				!(gpio_keypad_flags & GPIOKPF_ACTIVE_HIGH));
-		else
-			gpio_direction_input(mi->output_gpios[i]);
-	}
-	wake_lock(&kp->wake_lock);
-	hrtimer_start(&kp->timer, ktime_set(0, 0), HRTIMER_MODE_REL);
-	return IRQ_HANDLED;
-}
-
-static int gpio_keypad_request_irqs(struct gpio_kp *kp)
-{
-	int i;
-	int err;
-	unsigned int irq;
-	unsigned long request_flags;
-	struct gpio_event_matrix_info *mi = kp->keypad_info;
-
-	switch (mi->flags & (GPIOKPF_ACTIVE_HIGH|GPIOKPF_LEVEL_TRIGGERED_IRQ)) {
-	default:
-		request_flags = IRQF_TRIGGER_FALLING;
-		break;
-	case GPIOKPF_ACTIVE_HIGH:
-		request_flags = IRQF_TRIGGER_RISING;
-		break;
-	case GPIOKPF_LEVEL_TRIGGERED_IRQ:
-		request_flags = IRQF_TRIGGER_LOW;
-		break;
-	case GPIOKPF_LEVEL_TRIGGERED_IRQ | GPIOKPF_ACTIVE_HIGH:
-		request_flags = IRQF_TRIGGER_HIGH;
-		break;
-	}
-
-	for (i = 0; i < mi->ninputs; i++) {
-		err = irq = gpio_to_irq(mi->input_gpios[i]);
-		if (err < 0)
-			goto err_gpio_get_irq_num_failed;
-		err = request_irq(irq, gpio_keypad_irq_handler, request_flags,
-				  "gpio_kp", kp);
-		if (err) {
-			pr_err("gpiomatrix: request_irq failed for input %d, "
-				"irq %d\n", mi->input_gpios[i], irq);
-			goto err_request_irq_failed;
-		}
-		err = set_irq_wake(irq, 1);
-		if (err) {
-			pr_err("gpiomatrix: set_irq_wake failed for input %d, "
-				"irq %d\n", mi->input_gpios[i], irq);
-		}
-		disable_irq(irq);
-	}
-	return 0;
-
-	for (i = mi->noutputs - 1; i >= 0; i--) {
-		free_irq(gpio_to_irq(mi->input_gpios[i]), kp);
-err_request_irq_failed:
-err_gpio_get_irq_num_failed:
-		;
-	}
-	return err;
-}
-
-int gpio_event_matrix_func(struct gpio_event_input_devs *input_devs,
-	struct gpio_event_info *info, void **data, int func)
-{
-	int i;
-	int err;
-	int key_count;
-	struct gpio_kp *kp;
-	struct gpio_event_matrix_info *mi;
-
-	mi = container_of(info, struct gpio_event_matrix_info, info);
-	if (func == GPIO_EVENT_FUNC_SUSPEND || func == GPIO_EVENT_FUNC_RESUME) {
-		/* TODO: disable scanning */
-		return 0;
-	}
-
-	if (func == GPIO_EVENT_FUNC_INIT) {
-		if (mi->keymap == NULL ||
-		   mi->input_gpios == NULL ||
-		   mi->output_gpios == NULL) {
-			err = -ENODEV;
-			pr_err("gpiomatrix: Incomplete pdata\n");
-			goto err_invalid_platform_data;
-		}
-		key_count = mi->ninputs * mi->noutputs;
-
-		*data = kp = kzalloc(sizeof(*kp) + sizeof(kp->keys_pressed[0]) *
-				     BITS_TO_LONGS(key_count), GFP_KERNEL);
-		if (kp == NULL) {
-			err = -ENOMEM;
-			pr_err("gpiomatrix: Failed to allocate private data\n");
-			goto err_kp_alloc_failed;
-		}
-		kp->input_devs = input_devs;
-		kp->keypad_info = mi;
-		for (i = 0; i < key_count; i++) {
-			unsigned short keyentry = mi->keymap[i];
-			unsigned short keycode = keyentry & MATRIX_KEY_MASK;
-			unsigned short dev = keyentry >> MATRIX_CODE_BITS;
-			if (dev >= input_devs->count) {
-				pr_err("gpiomatrix: bad device index %d >= "
-					"%d for key code %d\n",
-					dev, input_devs->count, keycode);
-				err = -EINVAL;
-				goto err_bad_keymap;
-			}
-			if (keycode && keycode <= KEY_MAX)
-				input_set_capability(input_devs->dev[dev],
-							EV_KEY, keycode);
-		}
-
-		for (i = 0; i < mi->noutputs; i++) {
-			if (gpio_cansleep(mi->output_gpios[i])) {
-				pr_err("gpiomatrix: unsupported output gpio %d,"
-					" can sleep\n", mi->output_gpios[i]);
-				err = -EINVAL;
-				goto err_request_output_gpio_failed;
-			}
-			err = gpio_request(mi->output_gpios[i], "gpio_kp_out");
-			if (err) {
-				pr_err("gpiomatrix: gpio_request failed for "
-					"output %d\n", mi->output_gpios[i]);
-				goto err_request_output_gpio_failed;
-			}
-			if (mi->flags & GPIOKPF_DRIVE_INACTIVE)
-				err = gpio_direction_output(mi->output_gpios[i],
-					!(mi->flags & GPIOKPF_ACTIVE_HIGH));
-			else
-				err = gpio_direction_input(mi->output_gpios[i]);
-			if (err) {
-				pr_err("gpiomatrix: gpio_configure failed for "
-					"output %d\n", mi->output_gpios[i]);
-				goto err_output_gpio_configure_failed;
-			}
-		}
-		for (i = 0; i < mi->ninputs; i++) {
-			err = gpio_request(mi->input_gpios[i], "gpio_kp_in");
-			if (err) {
-				pr_err("gpiomatrix: gpio_request failed for "
-					"input %d\n", mi->input_gpios[i]);
-				goto err_request_input_gpio_failed;
-			}
-			err = gpio_direction_input(mi->input_gpios[i]);
-			if (err) {
-				pr_err("gpiomatrix: gpio_direction_input failed"
-					" for input %d\n", mi->input_gpios[i]);
-				goto err_gpio_direction_input_failed;
-			}
-		}
-		kp->current_output = mi->noutputs;
-		kp->key_state_changed = 1;
-
-		hrtimer_init(&kp->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-		kp->timer.function = gpio_keypad_timer_func;
-		wake_lock_init(&kp->wake_lock, WAKE_LOCK_SUSPEND, "gpio_kp");
-		err = gpio_keypad_request_irqs(kp);
-		kp->use_irq = err == 0;
-
-		pr_info("GPIO Matrix Keypad Driver: Start keypad matrix for "
-			"%s%s in %s mode\n", input_devs->dev[0]->name,
-			(input_devs->count > 1) ? "..." : "",
-			kp->use_irq ? "interrupt" : "polling");
-
-		if (kp->use_irq)
-			wake_lock(&kp->wake_lock);
-		hrtimer_start(&kp->timer, ktime_set(0, 0), HRTIMER_MODE_REL);
-
-		return 0;
-	}
-
-	err = 0;
-	kp = *data;
-
-	if (kp->use_irq)
-		for (i = mi->noutputs - 1; i >= 0; i--)
-			free_irq(gpio_to_irq(mi->input_gpios[i]), kp);
-
-	hrtimer_cancel(&kp->timer);
-	wake_lock_destroy(&kp->wake_lock);
-	for (i = mi->noutputs - 1; i >= 0; i--) {
-err_gpio_direction_input_failed:
-		gpio_free(mi->input_gpios[i]);
-err_request_input_gpio_failed:
-		;
-	}
-	for (i = mi->noutputs - 1; i >= 0; i--) {
-err_output_gpio_configure_failed:
-		gpio_free(mi->output_gpios[i]);
-err_request_output_gpio_failed:
-		;
-	}
-err_bad_keymap:
-	kfree(kp);
-err_kp_alloc_failed:
-err_invalid_platform_data:
-	return err;
-}
diff --git a/drivers/input/misc/gpio_output.c b/drivers/input/misc/gpio_output.c
deleted file mode 100644
index 2aac2fa..0000000
--- a/drivers/input/misc/gpio_output.c
+++ /dev/null
@@ -1,97 +0,0 @@
-/* drivers/input/misc/gpio_output.c
- *
- * Copyright (C) 2007 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/gpio.h>
-#include <linux/gpio_event.h>
-
-int gpio_event_output_event(
-	struct gpio_event_input_devs *input_devs, struct gpio_event_info *info,
-	void **data, unsigned int dev, unsigned int type,
-	unsigned int code, int value)
-{
-	int i;
-	struct gpio_event_output_info *oi;
-	oi = container_of(info, struct gpio_event_output_info, info);
-	if (type != oi->type)
-		return 0;
-	if (!(oi->flags & GPIOEDF_ACTIVE_HIGH))
-		value = !value;
-	for (i = 0; i < oi->keymap_size; i++)
-		if (dev == oi->keymap[i].dev && code == oi->keymap[i].code)
-			gpio_set_value(oi->keymap[i].gpio, value);
-	return 0;
-}
-
-int gpio_event_output_func(
-	struct gpio_event_input_devs *input_devs, struct gpio_event_info *info,
-	void **data, int func)
-{
-	int ret;
-	int i;
-	struct gpio_event_output_info *oi;
-	oi = container_of(info, struct gpio_event_output_info, info);
-
-	if (func == GPIO_EVENT_FUNC_SUSPEND || func == GPIO_EVENT_FUNC_RESUME)
-		return 0;
-
-	if (func == GPIO_EVENT_FUNC_INIT) {
-		int output_level = !(oi->flags & GPIOEDF_ACTIVE_HIGH);
-
-		for (i = 0; i < oi->keymap_size; i++) {
-			int dev = oi->keymap[i].dev;
-			if (dev >= input_devs->count) {
-				pr_err("gpio_event_output_func: bad device "
-					"index %d >= %d for key code %d\n",
-					dev, input_devs->count,
-					oi->keymap[i].code);
-				ret = -EINVAL;
-				goto err_bad_keymap;
-			}
-			input_set_capability(input_devs->dev[dev], oi->type,
-					     oi->keymap[i].code);
-		}
-
-		for (i = 0; i < oi->keymap_size; i++) {
-			ret = gpio_request(oi->keymap[i].gpio,
-					   "gpio_event_output");
-			if (ret) {
-				pr_err("gpio_event_output_func: gpio_request "
-					"failed for %d\n", oi->keymap[i].gpio);
-				goto err_gpio_request_failed;
-			}
-			ret = gpio_direction_output(oi->keymap[i].gpio,
-						    output_level);
-			if (ret) {
-				pr_err("gpio_event_output_func: "
-					"gpio_direction_output failed for %d\n",
-					oi->keymap[i].gpio);
-				goto err_gpio_direction_output_failed;
-			}
-		}
-		return 0;
-	}
-
-	ret = 0;
-	for (i = oi->keymap_size - 1; i >= 0; i--) {
-err_gpio_direction_output_failed:
-		gpio_free(oi->keymap[i].gpio);
-err_gpio_request_failed:
-		;
-	}
-err_bad_keymap:
-	return ret;
-}
-
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 3c49e49..438e477 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -27,7 +27,7 @@ obj-$(CONFIG_TOUCHSCREEN_HP7XX)		+= jornada720_ts.o
 obj-$(CONFIG_TOUCHSCREEN_HTCPEN)	+= htcpen.o
 obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)	+= usbtouchscreen.o
 obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= penmount.o
-obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI)	+= synaptics_i2c_rmi.o
+obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI)	+= ../../staging/dream/synaptics_i2c_rmi.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)	+= touchit213.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)	+= touchwin.o
diff --git a/drivers/input/touchscreen/synaptics_i2c_rmi.c b/drivers/input/touchscreen/synaptics_i2c_rmi.c
deleted file mode 100644
index f37c0c0..0000000
--- a/drivers/input/touchscreen/synaptics_i2c_rmi.c
+++ /dev/null
@@ -1,674 +0,0 @@
-/* drivers/input/keyboard/synaptics_i2c_rmi.c
- *
- * Copyright (C) 2007 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/module.h>
-#include <linux/delay.h>
-#include <linux/earlysuspend.h>
-#include <linux/hrtimer.h>
-#include <linux/i2c.h>
-#include <linux/input.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/platform_device.h>
-#include <linux/synaptics_i2c_rmi.h>
-
-static struct workqueue_struct *synaptics_wq;
-
-struct synaptics_ts_data {
-	uint16_t addr;
-	struct i2c_client *client;
-	struct input_dev *input_dev;
-	int use_irq;
-	bool has_relative_report;
-	struct hrtimer timer;
-	struct work_struct  work;
-	uint16_t max[2];
-	int snap_state[2][2];
-	int snap_down_on[2];
-	int snap_down_off[2];
-	int snap_up_on[2];
-	int snap_up_off[2];
-	int snap_down[2];
-	int snap_up[2];
-	uint32_t flags;
-	int reported_finger_count;
-	int8_t sensitivity_adjust;
-	int (*power)(int on);
-	struct early_suspend early_suspend;
-};
-
-#ifdef CONFIG_HAS_EARLYSUSPEND
-static void synaptics_ts_early_suspend(struct early_suspend *h);
-static void synaptics_ts_late_resume(struct early_suspend *h);
-#endif
-
-static int synaptics_init_panel(struct synaptics_ts_data *ts)
-{
-	int ret;
-
-	ret = i2c_smbus_write_byte_data(ts->client, 0xff, 0x10); /* page select = 0x10 */
-	if (ret < 0) {
-		printk(KERN_ERR "i2c_smbus_write_byte_data failed for page select\n");
-		goto err_page_select_failed;
-	}
-	ret = i2c_smbus_write_byte_data(ts->client, 0x41, 0x04); /* Set "No Clip Z" */
-	if (ret < 0)
-		printk(KERN_ERR "i2c_smbus_write_byte_data failed for No Clip Z\n");
-
-	ret = i2c_smbus_write_byte_data(ts->client, 0x44,
-					ts->sensitivity_adjust);
-	if (ret < 0)
-		pr_err("synaptics_ts: failed to set Sensitivity Adjust\n");
-
-err_page_select_failed:
-	ret = i2c_smbus_write_byte_data(ts->client, 0xff, 0x04); /* page select = 0x04 */
-	if (ret < 0)
-		printk(KERN_ERR "i2c_smbus_write_byte_data failed for page select\n");
-	ret = i2c_smbus_write_byte_data(ts->client, 0xf0, 0x81); /* normal operation, 80 reports per second */
-	if (ret < 0)
-		printk(KERN_ERR "synaptics_ts_resume: i2c_smbus_write_byte_data failed\n");
-	return ret;
-}
-
-static void synaptics_ts_work_func(struct work_struct *work)
-{
-	int i;
-	int ret;
-	int bad_data = 0;
-	struct i2c_msg msg[2];
-	uint8_t start_reg;
-	uint8_t buf[15];
-	struct synaptics_ts_data *ts = container_of(work, struct synaptics_ts_data, work);
-	int buf_len = ts->has_relative_report ? 15 : 13;
-
-	msg[0].addr = ts->client->addr;
-	msg[0].flags = 0;
-	msg[0].len = 1;
-	msg[0].buf = &start_reg;
-	start_reg = 0x00;
-	msg[1].addr = ts->client->addr;
-	msg[1].flags = I2C_M_RD;
-	msg[1].len = buf_len;
-	msg[1].buf = buf;
-
-	/* printk("synaptics_ts_work_func\n"); */
-	for (i = 0; i < ((ts->use_irq && !bad_data) ? 1 : 10); i++) {
-		ret = i2c_transfer(ts->client->adapter, msg, 2);
-		if (ret < 0) {
-			printk(KERN_ERR "synaptics_ts_work_func: i2c_transfer failed\n");
-			bad_data = 1;
-		} else {
-			/* printk("synaptics_ts_work_func: %x %x %x %x %x %x" */
-			/*        " %x %x %x %x %x %x %x %x %x, ret %d\n", */
-			/*        buf[0], buf[1], buf[2], buf[3], */
-			/*        buf[4], buf[5], buf[6], buf[7], */
-			/*        buf[8], buf[9], buf[10], buf[11], */
-			/*        buf[12], buf[13], buf[14], ret); */
-			if ((buf[buf_len - 1] & 0xc0) != 0x40) {
-				printk(KERN_WARNING "synaptics_ts_work_func:"
-				       " bad read %x %x %x %x %x %x %x %x %x"
-				       " %x %x %x %x %x %x, ret %d\n",
-				       buf[0], buf[1], buf[2], buf[3],
-				       buf[4], buf[5], buf[6], buf[7],
-				       buf[8], buf[9], buf[10], buf[11],
-				       buf[12], buf[13], buf[14], ret);
-				if (bad_data)
-					synaptics_init_panel(ts);
-				bad_data = 1;
-				continue;
-			}
-			bad_data = 0;
-			if ((buf[buf_len - 1] & 1) == 0) {
-				/* printk("read %d coordinates\n", i); */
-				break;
-			} else {
-				int pos[2][2];
-				int f, a;
-				int base;
-				/* int x = buf[3] | (uint16_t)(buf[2] & 0x1f) << 8; */
-				/* int y = buf[5] | (uint16_t)(buf[4] & 0x1f) << 8; */
-				int z = buf[1];
-				int w = buf[0] >> 4;
-				int finger = buf[0] & 7;
-
-				/* int x2 = buf[3+6] | (uint16_t)(buf[2+6] & 0x1f) << 8; */
-				/* int y2 = buf[5+6] | (uint16_t)(buf[4+6] & 0x1f) << 8; */
-				/* int z2 = buf[1+6]; */
-				/* int w2 = buf[0+6] >> 4; */
-				/* int finger2 = buf[0+6] & 7; */
-
-				/* int dx = (int8_t)buf[12]; */
-				/* int dy = (int8_t)buf[13]; */
-				int finger2_pressed;
-
-				/* printk("x %4d, y %4d, z %3d, w %2d, F %d, 2nd: x %4d, y %4d, z %3d, w %2d, F %d, dx %4d, dy %4d\n", */
-				/*	x, y, z, w, finger, */
-				/*	x2, y2, z2, w2, finger2, */
-				/*	dx, dy); */
-
-				base = 2;
-				for (f = 0; f < 2; f++) {
-					uint32_t flip_flag = SYNAPTICS_FLIP_X;
-					for (a = 0; a < 2; a++) {
-						int p = buf[base + 1];
-						p |= (uint16_t)(buf[base] & 0x1f) << 8;
-						if (ts->flags & flip_flag)
-							p = ts->max[a] - p;
-						if (ts->flags & SYNAPTICS_SNAP_TO_INACTIVE_EDGE) {
-							if (ts->snap_state[f][a]) {
-								if (p <= ts->snap_down_off[a])
-									p = ts->snap_down[a];
-								else if (p >= ts->snap_up_off[a])
-									p = ts->snap_up[a];
-								else
-									ts->snap_state[f][a] = 0;
-							} else {
-								if (p <= ts->snap_down_on[a]) {
-									p = ts->snap_down[a];
-									ts->snap_state[f][a] = 1;
-								} else if (p >= ts->snap_up_on[a]) {
-									p = ts->snap_up[a];
-									ts->snap_state[f][a] = 1;
-								}
-							}
-						}
-						pos[f][a] = p;
-						base += 2;
-						flip_flag <<= 1;
-					}
-					base += 2;
-					if (ts->flags & SYNAPTICS_SWAP_XY)
-						swap(pos[f][0], pos[f][1]);
-				}
-				if (z) {
-					input_report_abs(ts->input_dev, ABS_X, pos[0][0]);
-					input_report_abs(ts->input_dev, ABS_Y, pos[0][1]);
-				}
-				input_report_abs(ts->input_dev, ABS_PRESSURE, z);
-				input_report_abs(ts->input_dev, ABS_TOOL_WIDTH, w);
-				input_report_key(ts->input_dev, BTN_TOUCH, finger);
-				finger2_pressed = finger > 1 && finger != 7;
-				input_report_key(ts->input_dev, BTN_2, finger2_pressed);
-				if (finger2_pressed) {
-					input_report_abs(ts->input_dev, ABS_HAT0X, pos[1][0]);
-					input_report_abs(ts->input_dev, ABS_HAT0Y, pos[1][1]);
-				}
-
-				if (!finger)
-					z = 0;
-				input_report_abs(ts->input_dev, ABS_MT_TOUCH_MAJOR, z);
-				input_report_abs(ts->input_dev, ABS_MT_WIDTH_MAJOR, w);
-				input_report_abs(ts->input_dev, ABS_MT_POSITION_X, pos[0][0]);
-				input_report_abs(ts->input_dev, ABS_MT_POSITION_Y, pos[0][1]);
-				input_mt_sync(ts->input_dev);
-				if (finger2_pressed) {
-					input_report_abs(ts->input_dev, ABS_MT_TOUCH_MAJOR, z);
-					input_report_abs(ts->input_dev, ABS_MT_WIDTH_MAJOR, w);
-					input_report_abs(ts->input_dev, ABS_MT_POSITION_X, pos[1][0]);
-					input_report_abs(ts->input_dev, ABS_MT_POSITION_Y, pos[1][1]);
-					input_mt_sync(ts->input_dev);
-				} else if (ts->reported_finger_count > 1) {
-					input_report_abs(ts->input_dev, ABS_MT_TOUCH_MAJOR, 0);
-					input_report_abs(ts->input_dev, ABS_MT_WIDTH_MAJOR, 0);
-					input_mt_sync(ts->input_dev);
-				}
-				ts->reported_finger_count = finger;
-				input_sync(ts->input_dev);
-			}
-		}
-	}
-	if (ts->use_irq)
-		enable_irq(ts->client->irq);
-}
-
-static enum hrtimer_restart synaptics_ts_timer_func(struct hrtimer *timer)
-{
-	struct synaptics_ts_data *ts = container_of(timer, struct synaptics_ts_data, timer);
-	/* printk("synaptics_ts_timer_func\n"); */
-
-	queue_work(synaptics_wq, &ts->work);
-
-	hrtimer_start(&ts->timer, ktime_set(0, 12500000), HRTIMER_MODE_REL);
-	return HRTIMER_NORESTART;
-}
-
-static irqreturn_t synaptics_ts_irq_handler(int irq, void *dev_id)
-{
-	struct synaptics_ts_data *ts = dev_id;
-
-	/* printk("synaptics_ts_irq_handler\n"); */
-	disable_irq_nosync(ts->client->irq);
-	queue_work(synaptics_wq, &ts->work);
-	return IRQ_HANDLED;
-}
-
-static int synaptics_ts_probe(
-	struct i2c_client *client, const struct i2c_device_id *id)
-{
-	struct synaptics_ts_data *ts;
-	uint8_t buf0[4];
-	uint8_t buf1[8];
-	struct i2c_msg msg[2];
-	int ret = 0;
-	uint16_t max_x, max_y;
-	int fuzz_x, fuzz_y, fuzz_p, fuzz_w;
-	struct synaptics_i2c_rmi_platform_data *pdata;
-	unsigned long irqflags;
-	int inactive_area_left;
-	int inactive_area_right;
-	int inactive_area_top;
-	int inactive_area_bottom;
-	int snap_left_on;
-	int snap_left_off;
-	int snap_right_on;
-	int snap_right_off;
-	int snap_top_on;
-	int snap_top_off;
-	int snap_bottom_on;
-	int snap_bottom_off;
-	uint32_t panel_version;
-
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
-		printk(KERN_ERR "synaptics_ts_probe: need I2C_FUNC_I2C\n");
-		ret = -ENODEV;
-		goto err_check_functionality_failed;
-	}
-
-	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
-	if (ts == NULL) {
-		ret = -ENOMEM;
-		goto err_alloc_data_failed;
-	}
-	INIT_WORK(&ts->work, synaptics_ts_work_func);
-	ts->client = client;
-	i2c_set_clientdata(client, ts);
-	pdata = client->dev.platform_data;
-	if (pdata)
-		ts->power = pdata->power;
-	if (ts->power) {
-		ret = ts->power(1);
-		if (ret < 0) {
-			printk(KERN_ERR "synaptics_ts_probe power on failed\n");
-			goto err_power_failed;
-		}
-	}
-
-	ret = i2c_smbus_write_byte_data(ts->client, 0xf4, 0x01); /* device command = reset */
-	if (ret < 0) {
-		printk(KERN_ERR "i2c_smbus_write_byte_data failed\n");
-		/* fail? */
-	}
-	{
-		int retry = 10;
-		while (retry-- > 0) {
-			ret = i2c_smbus_read_byte_data(ts->client, 0xe4);
-			if (ret >= 0)
-				break;
-			msleep(100);
-		}
-	}
-	if (ret < 0) {
-		printk(KERN_ERR "i2c_smbus_read_byte_data failed\n");
-		goto err_detect_failed;
-	}
-	printk(KERN_INFO "synaptics_ts_probe: Product Major Version %x\n", ret);
-	panel_version = ret << 8;
-	ret = i2c_smbus_read_byte_data(ts->client, 0xe5);
-	if (ret < 0) {
-		printk(KERN_ERR "i2c_smbus_read_byte_data failed\n");
-		goto err_detect_failed;
-	}
-	printk(KERN_INFO "synaptics_ts_probe: Product Minor Version %x\n", ret);
-	panel_version |= ret;
-
-	ret = i2c_smbus_read_byte_data(ts->client, 0xe3);
-	if (ret < 0) {
-		printk(KERN_ERR "i2c_smbus_read_byte_data failed\n");
-		goto err_detect_failed;
-	}
-	printk(KERN_INFO "synaptics_ts_probe: product property %x\n", ret);
-
-	if (pdata) {
-		while (pdata->version > panel_version)
-			pdata++;
-		ts->flags = pdata->flags;
-		ts->sensitivity_adjust = pdata->sensitivity_adjust;
-		irqflags = pdata->irqflags;
-		inactive_area_left = pdata->inactive_left;
-		inactive_area_right = pdata->inactive_right;
-		inactive_area_top = pdata->inactive_top;
-		inactive_area_bottom = pdata->inactive_bottom;
-		snap_left_on = pdata->snap_left_on;
-		snap_left_off = pdata->snap_left_off;
-		snap_right_on = pdata->snap_right_on;
-		snap_right_off = pdata->snap_right_off;
-		snap_top_on = pdata->snap_top_on;
-		snap_top_off = pdata->snap_top_off;
-		snap_bottom_on = pdata->snap_bottom_on;
-		snap_bottom_off = pdata->snap_bottom_off;
-		fuzz_x = pdata->fuzz_x;
-		fuzz_y = pdata->fuzz_y;
-		fuzz_p = pdata->fuzz_p;
-		fuzz_w = pdata->fuzz_w;
-	} else {
-		irqflags = 0;
-		inactive_area_left = 0;
-		inactive_area_right = 0;
-		inactive_area_top = 0;
-		inactive_area_bottom = 0;
-		snap_left_on = 0;
-		snap_left_off = 0;
-		snap_right_on = 0;
-		snap_right_off = 0;
-		snap_top_on = 0;
-		snap_top_off = 0;
-		snap_bottom_on = 0;
-		snap_bottom_off = 0;
-		fuzz_x = 0;
-		fuzz_y = 0;
-		fuzz_p = 0;
-		fuzz_w = 0;
-	}
-
-	ret = i2c_smbus_read_byte_data(ts->client, 0xf0);
-	if (ret < 0) {
-		printk(KERN_ERR "i2c_smbus_read_byte_data failed\n");
-		goto err_detect_failed;
-	}
-	printk(KERN_INFO "synaptics_ts_probe: device control %x\n", ret);
-
-	ret = i2c_smbus_read_byte_data(ts->client, 0xf1);
-	if (ret < 0) {
-		printk(KERN_ERR "i2c_smbus_read_byte_data failed\n");
-		goto err_detect_failed;
-	}
-	printk(KERN_INFO "synaptics_ts_probe: interrupt enable %x\n", ret);
-
-	ret = i2c_smbus_write_byte_data(ts->client, 0xf1, 0); /* disable interrupt */
-	if (ret < 0) {
-		printk(KERN_ERR "i2c_smbus_write_byte_data failed\n");
-		goto err_detect_failed;
-	}
-
-	msg[0].addr = ts->client->addr;
-	msg[0].flags = 0;
-	msg[0].len = 1;
-	msg[0].buf = buf0;
-	buf0[0] = 0xe0;
-	msg[1].addr = ts->client->addr;
-	msg[1].flags = I2C_M_RD;
-	msg[1].len = 8;
-	msg[1].buf = buf1;
-	ret = i2c_transfer(ts->client->adapter, msg, 2);
-	if (ret < 0) {
-		printk(KERN_ERR "i2c_transfer failed\n");
-		goto err_detect_failed;
-	}
-	printk(KERN_INFO "synaptics_ts_probe: 0xe0: %x %x %x %x %x %x %x %x\n",
-	       buf1[0], buf1[1], buf1[2], buf1[3],
-	       buf1[4], buf1[5], buf1[6], buf1[7]);
-
-	ret = i2c_smbus_write_byte_data(ts->client, 0xff, 0x10); /* page select = 0x10 */
-	if (ret < 0) {
-		printk(KERN_ERR "i2c_smbus_write_byte_data failed for page select\n");
-		goto err_detect_failed;
-	}
-	ret = i2c_smbus_read_word_data(ts->client, 0x02);
-	if (ret < 0) {
-		printk(KERN_ERR "i2c_smbus_read_word_data failed\n");
-		goto err_detect_failed;
-	}
-	ts->has_relative_report = !(ret & 0x100);
-	printk(KERN_INFO "synaptics_ts_probe: Sensor properties %x\n", ret);
-	ret = i2c_smbus_read_word_data(ts->client, 0x04);
-	if (ret < 0) {
-		printk(KERN_ERR "i2c_smbus_read_word_data failed\n");
-		goto err_detect_failed;
-	}
-	ts->max[0] = max_x = (ret >> 8 & 0xff) | ((ret & 0x1f) << 8);
-	ret = i2c_smbus_read_word_data(ts->client, 0x06);
-	if (ret < 0) {
-		printk(KERN_ERR "i2c_smbus_read_word_data failed\n");
-		goto err_detect_failed;
-	}
-	ts->max[1] = max_y = (ret >> 8 & 0xff) | ((ret & 0x1f) << 8);
-	if (ts->flags & SYNAPTICS_SWAP_XY)
-		swap(max_x, max_y);
-
-	ret = synaptics_init_panel(ts); /* will also switch back to page 0x04 */
-	if (ret < 0) {
-		printk(KERN_ERR "synaptics_init_panel failed\n");
-		goto err_detect_failed;
-	}
-
-	ts->input_dev = input_allocate_device();
-	if (ts->input_dev == NULL) {
-		ret = -ENOMEM;
-		printk(KERN_ERR "synaptics_ts_probe: Failed to allocate input device\n");
-		goto err_input_dev_alloc_failed;
-	}
-	ts->input_dev->name = "synaptics-rmi-touchscreen";
-	set_bit(EV_SYN, ts->input_dev->evbit);
-	set_bit(EV_KEY, ts->input_dev->evbit);
-	set_bit(BTN_TOUCH, ts->input_dev->keybit);
-	set_bit(BTN_2, ts->input_dev->keybit);
-	set_bit(EV_ABS, ts->input_dev->evbit);
-	inactive_area_left = inactive_area_left * max_x / 0x10000;
-	inactive_area_right = inactive_area_right * max_x / 0x10000;
-	inactive_area_top = inactive_area_top * max_y / 0x10000;
-	inactive_area_bottom = inactive_area_bottom * max_y / 0x10000;
-	snap_left_on = snap_left_on * max_x / 0x10000;
-	snap_left_off = snap_left_off * max_x / 0x10000;
-	snap_right_on = snap_right_on * max_x / 0x10000;
-	snap_right_off = snap_right_off * max_x / 0x10000;
-	snap_top_on = snap_top_on * max_y / 0x10000;
-	snap_top_off = snap_top_off * max_y / 0x10000;
-	snap_bottom_on = snap_bottom_on * max_y / 0x10000;
-	snap_bottom_off = snap_bottom_off * max_y / 0x10000;
-	fuzz_x = fuzz_x * max_x / 0x10000;
-	fuzz_y = fuzz_y * max_y / 0x10000;
-	ts->snap_down[!!(ts->flags & SYNAPTICS_SWAP_XY)] = -inactive_area_left;
-	ts->snap_up[!!(ts->flags & SYNAPTICS_SWAP_XY)] = max_x + inactive_area_right;
-	ts->snap_down[!(ts->flags & SYNAPTICS_SWAP_XY)] = -inactive_area_top;
-	ts->snap_up[!(ts->flags & SYNAPTICS_SWAP_XY)] = max_y + inactive_area_bottom;
-	ts->snap_down_on[!!(ts->flags & SYNAPTICS_SWAP_XY)] = snap_left_on;
-	ts->snap_down_off[!!(ts->flags & SYNAPTICS_SWAP_XY)] = snap_left_off;
-	ts->snap_up_on[!!(ts->flags & SYNAPTICS_SWAP_XY)] = max_x - snap_right_on;
-	ts->snap_up_off[!!(ts->flags & SYNAPTICS_SWAP_XY)] = max_x - snap_right_off;
-	ts->snap_down_on[!(ts->flags & SYNAPTICS_SWAP_XY)] = snap_top_on;
-	ts->snap_down_off[!(ts->flags & SYNAPTICS_SWAP_XY)] = snap_top_off;
-	ts->snap_up_on[!(ts->flags & SYNAPTICS_SWAP_XY)] = max_y - snap_bottom_on;
-	ts->snap_up_off[!(ts->flags & SYNAPTICS_SWAP_XY)] = max_y - snap_bottom_off;
-	printk(KERN_INFO "synaptics_ts_probe: max_x %d, max_y %d\n", max_x, max_y);
-	printk(KERN_INFO "synaptics_ts_probe: inactive_x %d %d, inactive_y %d %d\n",
-	       inactive_area_left, inactive_area_right,
-	       inactive_area_top, inactive_area_bottom);
-	printk(KERN_INFO "synaptics_ts_probe: snap_x %d-%d %d-%d, snap_y %d-%d %d-%d\n",
-	       snap_left_on, snap_left_off, snap_right_on, snap_right_off,
-	       snap_top_on, snap_top_off, snap_bottom_on, snap_bottom_off);
-	input_set_abs_params(ts->input_dev, ABS_X, -inactive_area_left, max_x + inactive_area_right, fuzz_x, 0);
-	input_set_abs_params(ts->input_dev, ABS_Y, -inactive_area_top, max_y + inactive_area_bottom, fuzz_y, 0);
-	input_set_abs_params(ts->input_dev, ABS_PRESSURE, 0, 255, fuzz_p, 0);
-	input_set_abs_params(ts->input_dev, ABS_TOOL_WIDTH, 0, 15, fuzz_w, 0);
-	input_set_abs_params(ts->input_dev, ABS_HAT0X, -inactive_area_left, max_x + inactive_area_right, fuzz_x, 0);
-	input_set_abs_params(ts->input_dev, ABS_HAT0Y, -inactive_area_top, max_y + inactive_area_bottom, fuzz_y, 0);
-	input_set_abs_params(ts->input_dev, ABS_MT_POSITION_X, -inactive_area_left, max_x + inactive_area_right, fuzz_x, 0);
-	input_set_abs_params(ts->input_dev, ABS_MT_POSITION_Y, -inactive_area_top, max_y + inactive_area_bottom, fuzz_y, 0);
-	input_set_abs_params(ts->input_dev, ABS_MT_TOUCH_MAJOR, 0, 255, fuzz_p, 0);
-	input_set_abs_params(ts->input_dev, ABS_MT_WIDTH_MAJOR, 0, 15, fuzz_w, 0);
-	/* ts->input_dev->name = ts->keypad_info->name; */
-	ret = input_register_device(ts->input_dev);
-	if (ret) {
-		printk(KERN_ERR "synaptics_ts_probe: Unable to register %s input device\n", ts->input_dev->name);
-		goto err_input_register_device_failed;
-	}
-	if (client->irq) {
-		ret = request_irq(client->irq, synaptics_ts_irq_handler, irqflags, client->name, ts);
-		if (ret == 0) {
-			ret = i2c_smbus_write_byte_data(ts->client, 0xf1, 0x01); /* enable abs int */
-			if (ret)
-				free_irq(client->irq, ts);
-		}
-		if (ret == 0)
-			ts->use_irq = 1;
-		else
-			dev_err(&client->dev, "request_irq failed\n");
-	}
-	if (!ts->use_irq) {
-		hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-		ts->timer.function = synaptics_ts_timer_func;
-		hrtimer_start(&ts->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
-	}
-#ifdef CONFIG_HAS_EARLYSUSPEND
-	ts->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 1;
-	ts->early_suspend.suspend = synaptics_ts_early_suspend;
-	ts->early_suspend.resume = synaptics_ts_late_resume;
-	register_early_suspend(&ts->early_suspend);
-#endif
-
-	printk(KERN_INFO "synaptics_ts_probe: Start touchscreen %s in %s mode\n", ts->input_dev->name, ts->use_irq ? "interrupt" : "polling");
-
-	return 0;
-
-err_input_register_device_failed:
-	input_free_device(ts->input_dev);
-
-err_input_dev_alloc_failed:
-err_detect_failed:
-err_power_failed:
-	kfree(ts);
-err_alloc_data_failed:
-err_check_functionality_failed:
-	return ret;
-}
-
-static int synaptics_ts_remove(struct i2c_client *client)
-{
-	struct synaptics_ts_data *ts = i2c_get_clientdata(client);
-	unregister_early_suspend(&ts->early_suspend);
-	if (ts->use_irq)
-		free_irq(client->irq, ts);
-	else
-		hrtimer_cancel(&ts->timer);
-	input_unregister_device(ts->input_dev);
-	kfree(ts);
-	return 0;
-}
-
-static int synaptics_ts_suspend(struct i2c_client *client, pm_message_t mesg)
-{
-	int ret;
-	struct synaptics_ts_data *ts = i2c_get_clientdata(client);
-
-	if (ts->use_irq)
-		disable_irq(client->irq);
-	else
-		hrtimer_cancel(&ts->timer);
-	ret = cancel_work_sync(&ts->work);
-	if (ret && ts->use_irq) /* if work was pending disable-count is now 2 */
-		enable_irq(client->irq);
-	ret = i2c_smbus_write_byte_data(ts->client, 0xf1, 0); /* disable interrupt */
-	if (ret < 0)
-		printk(KERN_ERR "synaptics_ts_suspend: i2c_smbus_write_byte_data failed\n");
-
-	ret = i2c_smbus_write_byte_data(client, 0xf0, 0x86); /* deep sleep */
-	if (ret < 0)
-		printk(KERN_ERR "synaptics_ts_suspend: i2c_smbus_write_byte_data failed\n");
-	if (ts->power) {
-		ret = ts->power(0);
-		if (ret < 0)
-			printk(KERN_ERR "synaptics_ts_resume power off failed\n");
-	}
-	return 0;
-}
-
-static int synaptics_ts_resume(struct i2c_client *client)
-{
-	int ret;
-	struct synaptics_ts_data *ts = i2c_get_clientdata(client);
-
-	if (ts->power) {
-		ret = ts->power(1);
-		if (ret < 0)
-			printk(KERN_ERR "synaptics_ts_resume power on failed\n");
-	}
-
-	synaptics_init_panel(ts);
-
-	if (ts->use_irq)
-		enable_irq(client->irq);
-
-	if (!ts->use_irq)
-		hrtimer_start(&ts->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
-	else
-		i2c_smbus_write_byte_data(ts->client, 0xf1, 0x01); /* enable abs int */
-
-	return 0;
-}
-
-#ifdef CONFIG_HAS_EARLYSUSPEND
-static void synaptics_ts_early_suspend(struct early_suspend *h)
-{
-	struct synaptics_ts_data *ts;
-	ts = container_of(h, struct synaptics_ts_data, early_suspend);
-	synaptics_ts_suspend(ts->client, PMSG_SUSPEND);
-}
-
-static void synaptics_ts_late_resume(struct early_suspend *h)
-{
-	struct synaptics_ts_data *ts;
-	ts = container_of(h, struct synaptics_ts_data, early_suspend);
-	synaptics_ts_resume(ts->client);
-}
-#endif
-
-static const struct i2c_device_id synaptics_ts_id[] = {
-	{ SYNAPTICS_I2C_RMI_NAME, 0 },
-	{ }
-};
-
-static struct i2c_driver synaptics_ts_driver = {
-	.probe		= synaptics_ts_probe,
-	.remove		= synaptics_ts_remove,
-#ifndef CONFIG_HAS_EARLYSUSPEND
-	.suspend	= synaptics_ts_suspend,
-	.resume		= synaptics_ts_resume,
-#endif
-	.id_table	= synaptics_ts_id,
-	.driver = {
-		.name	= SYNAPTICS_I2C_RMI_NAME,
-	},
-};
-
-static int __devinit synaptics_ts_init(void)
-{
-	synaptics_wq = create_singlethread_workqueue("synaptics_wq");
-	if (!synaptics_wq)
-		return -ENOMEM;
-	return i2c_add_driver(&synaptics_ts_driver);
-}
-
-static void __exit synaptics_ts_exit(void)
-{
-	i2c_del_driver(&synaptics_ts_driver);
-	if (synaptics_wq)
-		destroy_workqueue(synaptics_wq);
-}
-
-module_init(synaptics_ts_init);
-module_exit(synaptics_ts_exit);
-
-MODULE_DESCRIPTION("Synaptics Touchscreen Driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/staging/dream/gpio_axis.c b/drivers/staging/dream/gpio_axis.c
index c801172..30b9f56 100644
--- a/drivers/staging/dream/gpio_axis.c
+++ b/drivers/staging/dream/gpio_axis.c
@@ -19,7 +19,7 @@
 #include <linux/interrupt.h>
 
 struct gpio_axis_state {
-	struct input_dev *input_dev;
+	struct gpio_event_input_devs *input_devs;
 	struct gpio_event_axis_info *info;
 	uint32_t pos;
 };
@@ -87,14 +87,16 @@ static void gpio_event_update_axis(struct gpio_axis_state *as, int report)
 			if (ai->flags & GPIOEAF_PRINT_EVENT)
 				pr_info("axis %d-%d change %d\n",
 					ai->type, ai->code, change);
-			input_report_rel(as->input_dev, ai->code, change);
+			input_report_rel(as->input_devs->dev[ai->dev],
+						ai->code, change);
 		} else {
 			if (ai->flags & GPIOEAF_PRINT_EVENT)
 				pr_info("axis %d-%d now %d\n",
 					ai->type, ai->code, pos);
-			input_event(as->input_dev, ai->type, ai->code, pos);
+			input_event(as->input_devs->dev[ai->dev],
+					ai->type, ai->code, pos);
 		}
-		input_sync(as->input_dev);
+		input_sync(as->input_devs->dev[ai->dev]);
 	}
 	as->pos = pos;
 }
@@ -106,7 +108,7 @@ static irqreturn_t gpio_axis_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-int gpio_event_axis_func(struct input_dev *input_dev,
+int gpio_event_axis_func(struct gpio_event_input_devs *input_devs,
 			 struct gpio_event_info *info, void **data, int func)
 {
 	int ret;
@@ -133,13 +135,21 @@ int gpio_event_axis_func(struct input_dev *input_dev,
 			ret = -ENOMEM;
 			goto err_alloc_axis_state_failed;
 		}
-		as->input_dev = input_dev;
+		as->input_devs = input_devs;
 		as->info = ai;
+		if (ai->dev >= input_devs->count) {
+			pr_err("gpio_event_axis: bad device index %d >= %d "
+				"for %d:%d\n", ai->dev, input_devs->count,
+				ai->type, ai->code);
+			ret = -EINVAL;
+			goto err_bad_device_index;
+		}
 
-		input_set_capability(input_dev, ai->type, ai->code);
+		input_set_capability(input_devs->dev[ai->dev],
+				     ai->type, ai->code);
 		if (ai->type == EV_ABS) {
-			input_set_abs_params(input_dev, ai->code, 0,
-					     ai->decoded_size - 1, 0, 0);
+			input_set_abs_params(input_devs->dev[ai->dev], ai->code,
+					     0, ai->decoded_size - 1, 0, 0);
 		}
 		for (i = 0; i < ai->count; i++) {
 			ret = gpio_request(ai->gpio[i], "gpio_event_axis");
@@ -173,6 +183,7 @@ err_gpio_direction_input_failed:
 err_request_gpio_failed:
 		;
 	}
+err_bad_device_index:
 	kfree(as);
 	*data = NULL;
 err_alloc_axis_state_failed:
diff --git a/drivers/staging/dream/gpio_event.c b/drivers/staging/dream/gpio_event.c
index 8b64c1e..139b360 100644
--- a/drivers/staging/dream/gpio_event.c
+++ b/drivers/staging/dream/gpio_event.c
@@ -21,7 +21,7 @@
 #include <linux/platform_device.h>
 
 struct gpio_event {
-	struct input_dev *input_dev;
+	struct gpio_event_input_devs *input_devs;
 	const struct gpio_event_platform_data *info;
 	struct early_suspend early_suspend;
 	void *state[0];
@@ -31,15 +31,25 @@ static int gpio_input_event(
 	struct input_dev *dev, unsigned int type, unsigned int code, int value)
 {
 	int i;
+	int devnr;
 	int ret = 0;
 	int tmp_ret;
 	struct gpio_event_info **ii;
 	struct gpio_event *ip = input_get_drvdata(dev);
 
+	for (devnr = 0; devnr < ip->input_devs->count; devnr++)
+		if (ip->input_devs->dev[devnr] == dev)
+			break;
+	if (devnr == ip->input_devs->count) {
+		pr_err("gpio_input_event: unknown device %p\n", dev);
+		return -EIO;
+	}
+
 	for (i = 0, ii = ip->info->info; i < ip->info->info_count; i++, ii++) {
 		if ((*ii)->event) {
-			tmp_ret = (*ii)->event(ip->input_dev, *ii,
-					&ip->state[i], type, code, value);
+			tmp_ret = (*ii)->event(ip->input_devs, *ii,
+						&ip->state[i],
+						devnr, type, code, value);
 			if (tmp_ret)
 				ret = tmp_ret;
 		}
@@ -62,7 +72,9 @@ static int gpio_event_call_all_func(struct gpio_event *ip, int func)
 					"no function\n");
 				goto err_no_func;
 			}
-			ret = (*ii)->func(ip->input_dev, *ii, &ip->state[i],
+			if (func == GPIO_EVENT_FUNC_RESUME && (*ii)->no_suspend)
+				continue;
+			ret = (*ii)->func(ip->input_devs, *ii, &ip->state[i],
 					  func);
 			if (ret) {
 				pr_err("gpio_event_probe: function failed\n");
@@ -78,7 +90,9 @@ static int gpio_event_call_all_func(struct gpio_event *ip, int func)
 	while (i > 0) {
 		i--;
 		ii--;
-		(*ii)->func(ip->input_dev, *ii, &ip->state[i], func & ~1);
+		if ((func & ~1) == GPIO_EVENT_FUNC_SUSPEND && (*ii)->no_suspend)
+			continue;
+		(*ii)->func(ip->input_devs, *ii, &ip->state[i], func & ~1);
 err_func_failed:
 err_no_func:
 		;
@@ -108,37 +122,51 @@ static int __init gpio_event_probe(struct platform_device *pdev)
 {
 	int err;
 	struct gpio_event *ip;
-	struct input_dev *input_dev;
 	struct gpio_event_platform_data *event_info;
+	int dev_count = 1;
+	int i;
+	int registered = 0;
 
 	event_info = pdev->dev.platform_data;
 	if (event_info == NULL) {
 		pr_err("gpio_event_probe: No pdata\n");
 		return -ENODEV;
 	}
-	if (event_info->name == NULL ||
-	   event_info->info == NULL ||
-	   event_info->info_count == 0) {
+	if ((!event_info->name && !event_info->names[0]) ||
+	    !event_info->info || !event_info->info_count) {
 		pr_err("gpio_event_probe: Incomplete pdata\n");
 		return -ENODEV;
 	}
+	if (!event_info->name)
+		while (event_info->names[dev_count])
+			dev_count++;
 	ip = kzalloc(sizeof(*ip) +
-		     sizeof(ip->state[0]) * event_info->info_count, GFP_KERNEL);
+		     sizeof(ip->state[0]) * event_info->info_count +
+		     sizeof(*ip->input_devs) +
+		     sizeof(ip->input_devs->dev[0]) * dev_count, GFP_KERNEL);
 	if (ip == NULL) {
 		err = -ENOMEM;
 		pr_err("gpio_event_probe: Failed to allocate private data\n");
 		goto err_kp_alloc_failed;
 	}
+	ip->input_devs = (void*)&ip->state[event_info->info_count];
 	platform_set_drvdata(pdev, ip);
 
-	input_dev = input_allocate_device();
-	if (input_dev == NULL) {
-		err = -ENOMEM;
-		pr_err("gpio_event_probe: Failed to allocate input device\n");
-		goto err_input_dev_alloc_failed;
+	for (i = 0; i < dev_count; i++) {
+		struct input_dev *input_dev = input_allocate_device();
+		if (input_dev == NULL) {
+			err = -ENOMEM;
+			pr_err("gpio_event_probe: "
+				"Failed to allocate input device\n");
+			goto err_input_dev_alloc_failed;
+		}
+		input_set_drvdata(input_dev, ip);
+		input_dev->name = event_info->name ?
+					event_info->name : event_info->names[i];
+		input_dev->event = gpio_input_event;
+		ip->input_devs->dev[i] = input_dev;
 	}
-	input_set_drvdata(input_dev, ip);
-	ip->input_dev = input_dev;
+	ip->input_devs->count = dev_count;
 	ip->info = event_info;
 	if (event_info->power) {
 #ifdef CONFIG_HAS_EARLYSUSPEND
@@ -150,18 +178,18 @@ static int __init gpio_event_probe(struct platform_device *pdev)
 		ip->info->power(ip->info, 1);
 	}
 
-	input_dev->name = ip->info->name;
-	input_dev->event = gpio_input_event;
-
 	err = gpio_event_call_all_func(ip, GPIO_EVENT_FUNC_INIT);
 	if (err)
 		goto err_call_all_func_failed;
 
-	err = input_register_device(input_dev);
-	if (err) {
-		pr_err("gpio_event_probe: Unable to register %s input device\n",
-			input_dev->name);
-		goto err_input_register_device_failed;
+	for (i = 0; i < dev_count; i++) {
+		err = input_register_device(ip->input_devs->dev[i]);
+		if (err) {
+			pr_err("gpio_event_probe: Unable to register %s "
+				"input device\n", ip->input_devs->dev[i]->name);
+			goto err_input_register_device_failed;
+		}
+		registered++;
 	}
 
 	return 0;
@@ -175,8 +203,13 @@ err_call_all_func_failed:
 #endif
 		ip->info->power(ip->info, 0);
 	}
-	input_free_device(input_dev);
+	for (i = 0; i < registered; i++)
+		input_unregister_device(ip->input_devs->dev[i]);
+	for (i = dev_count - 1; i >= registered; i--) {
+		input_free_device(ip->input_devs->dev[i]);
 err_input_dev_alloc_failed:
+		;
+	}
 	kfree(ip);
 err_kp_alloc_failed:
 	return err;
@@ -185,6 +218,7 @@ err_kp_alloc_failed:
 static int gpio_event_remove(struct platform_device *pdev)
 {
 	struct gpio_event *ip = platform_get_drvdata(pdev);
+	int i;
 
 	gpio_event_call_all_func(ip, GPIO_EVENT_FUNC_UNINIT);
 	if (ip->info->power) {
@@ -193,7 +227,8 @@ static int gpio_event_remove(struct platform_device *pdev)
 #endif
 		ip->info->power(ip->info, 0);
 	}
-	input_unregister_device(ip->input_dev);
+	for (i = 0; i < ip->input_devs->count; i++)
+		input_unregister_device(ip->input_devs->dev[i]);
 	kfree(ip);
 	return 0;
 }
diff --git a/drivers/staging/dream/gpio_input.c b/drivers/staging/dream/gpio_input.c
index 7e307f2..7e66f8c 100644
--- a/drivers/staging/dream/gpio_input.c
+++ b/drivers/staging/dream/gpio_input.c
@@ -38,7 +38,7 @@ struct gpio_key_state {
 };
 
 struct gpio_input_state {
-	struct input_dev *input_dev;
+	struct gpio_event_input_devs *input_devs;
 	const struct gpio_event_input_info *info;
 	struct hrtimer timer;
 	int use_irq;
@@ -126,7 +126,7 @@ static enum hrtimer_restart gpio_event_input_timer_func(struct hrtimer *timer)
 			pr_info("gpio_keys_scan_keys: key %x-%x, %d (%d) "
 				"changed to %d\n", ds->info->type,
 				key_entry->code, i, key_entry->gpio, pressed);
-		input_event(ds->input_dev, ds->info->type,
+		input_event(ds->input_devs->dev[key_entry->dev], ds->info->type,
 			    key_entry->code, pressed);
 	}
 
@@ -181,7 +181,7 @@ static irqreturn_t gpio_event_input_irq_handler(int irq, void *dev_id)
 					ds->info->type, key_entry->code,
 					keymap_index, key_entry->gpio);
 		} else {
-			disable_irq(irq);
+			disable_irq_nosync(irq);
 			ks->debounce = DEBOUNCE_UNSTABLE;
 		}
 		spin_unlock_irqrestore(&ds->irq_lock, irqflags);
@@ -193,7 +193,7 @@ static irqreturn_t gpio_event_input_irq_handler(int irq, void *dev_id)
 				"(%d) changed to %d\n",
 				ds->info->type, key_entry->code, keymap_index,
 				key_entry->gpio, pressed);
-		input_event(ds->input_dev, ds->info->type,
+		input_event(ds->input_devs->dev[key_entry->dev], ds->info->type,
 			    key_entry->code, pressed);
 	}
 	return IRQ_HANDLED;
@@ -232,7 +232,7 @@ err_gpio_get_irq_num_failed:
 	return err;
 }
 
-int gpio_event_input_func(struct input_dev *input_dev,
+int gpio_event_input_func(struct gpio_event_input_devs *input_devs,
 			struct gpio_event_info *info, void **data, int func)
 {
 	int ret;
@@ -244,11 +244,9 @@ int gpio_event_input_func(struct input_dev *input_dev,
 	di = container_of(info, struct gpio_event_input_info, info);
 
 	if (func == GPIO_EVENT_FUNC_SUSPEND) {
-		spin_lock_irqsave(&ds->irq_lock, irqflags);
 		if (ds->use_irq)
 			for (i = 0; i < di->keymap_size; i++)
 				disable_irq(gpio_to_irq(di->keymap[i].gpio));
-		spin_unlock_irqrestore(&ds->irq_lock, irqflags);
 		hrtimer_cancel(&ds->timer);
 		return 0;
 	}
@@ -275,13 +273,22 @@ int gpio_event_input_func(struct input_dev *input_dev,
 			goto err_ds_alloc_failed;
 		}
 		ds->debounce_count = di->keymap_size;
-		ds->input_dev = input_dev;
+		ds->input_devs = input_devs;
 		ds->info = di;
 		wake_lock_init(&ds->wake_lock, WAKE_LOCK_SUSPEND, "gpio_input");
 		spin_lock_init(&ds->irq_lock);
 
 		for (i = 0; i < di->keymap_size; i++) {
-			input_set_capability(input_dev, di->type,
+			int dev = di->keymap[i].dev;
+			if (dev >= input_devs->count) {
+				pr_err("gpio_event_input_func: bad device "
+					"index %d >= %d for key code %d\n",
+					dev, input_devs->count,
+					di->keymap[i].code);
+				ret = -EINVAL;
+				goto err_bad_keymap;
+			}
+			input_set_capability(input_devs->dev[dev], di->type,
 					     di->keymap[i].code);
 			ds->key_state[i].ds = ds;
 			ds->key_state[i].debounce = DEBOUNCE_UNKNOWN;
@@ -308,9 +315,10 @@ int gpio_event_input_func(struct input_dev *input_dev,
 		spin_lock_irqsave(&ds->irq_lock, irqflags);
 		ds->use_irq = ret == 0;
 
-		pr_info("GPIO Input Driver: Start gpio inputs for %s in %s "
-			"mode\n",
-			input_dev->name, ret == 0 ? "interrupt" : "polling");
+		pr_info("GPIO Input Driver: Start gpio inputs for %s%s in %s "
+			"mode\n", input_devs->dev[0]->name,
+			(input_devs->count > 1) ? "..." : "",
+			ret == 0 ? "interrupt" : "polling");
 
 		hrtimer_init(&ds->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 		ds->timer.function = gpio_event_input_timer_func;
@@ -336,6 +344,7 @@ err_gpio_configure_failed:
 err_gpio_request_failed:
 		;
 	}
+err_bad_keymap:
 	wake_lock_destroy(&ds->wake_lock);
 	kfree(ds);
 err_ds_alloc_failed:
diff --git a/drivers/staging/dream/gpio_matrix.c b/drivers/staging/dream/gpio_matrix.c
index c1f4765..90866c4 100644
--- a/drivers/staging/dream/gpio_matrix.c
+++ b/drivers/staging/dream/gpio_matrix.c
@@ -21,7 +21,7 @@
 #include <linux/wakelock.h>
 
 struct gpio_kp {
-	struct input_dev *input_dev;
+	struct gpio_event_input_devs *input_devs;
 	struct gpio_event_matrix_info *keypad_info;
 	struct hrtimer timer;
 	struct wake_lock wake_lock;
@@ -37,9 +37,11 @@ static void clear_phantom_key(struct gpio_kp *kp, int out, int in)
 {
 	struct gpio_event_matrix_info *mi = kp->keypad_info;
 	int key_index = out * mi->ninputs + in;
-	unsigned short keycode = mi->keymap[key_index];;
+	unsigned short keyentry = mi->keymap[key_index];
+	unsigned short keycode = keyentry & MATRIX_KEY_MASK;
+	unsigned short dev = keyentry >> MATRIX_CODE_BITS;
 
-	if (!test_bit(keycode, kp->input_dev->key)) {
+	if (!test_bit(keycode, kp->input_devs->dev[dev]->key)) {
 		if (mi->flags & GPIOKPF_PRINT_PHANTOM_KEYS)
 			pr_info("gpiomatrix: phantom key %x, %d-%d (%d-%d) "
 				"cleared\n", keycode, out, in,
@@ -104,8 +106,11 @@ static void report_key(struct gpio_kp *kp, int key_index, int out, int in)
 {
 	struct gpio_event_matrix_info *mi = kp->keypad_info;
 	int pressed = test_bit(key_index, kp->keys_pressed);
-	unsigned short keycode = mi->keymap[key_index];
-	if (pressed != test_bit(keycode, kp->input_dev->key)) {
+	unsigned short keyentry = mi->keymap[key_index];
+	unsigned short keycode = keyentry & MATRIX_KEY_MASK;
+	unsigned short dev = keyentry >> MATRIX_CODE_BITS;
+
+	if (pressed != test_bit(keycode, kp->input_devs->dev[dev]->key)) {
 		if (keycode == KEY_RESERVED) {
 			if (mi->flags & GPIOKPF_PRINT_UNMAPPED_KEYS)
 				pr_info("gpiomatrix: unmapped key, %d-%d "
@@ -118,7 +123,7 @@ static void report_key(struct gpio_kp *kp, int key_index, int out, int in)
 					"changed to %d\n", keycode,
 					out, in, mi->output_gpios[out],
 					mi->input_gpios[in], pressed);
-			input_report_key(kp->input_dev, keycode, pressed);
+			input_report_key(kp->input_devs->dev[dev], keycode, pressed);
 		}
 	}
 }
@@ -214,7 +219,7 @@ static irqreturn_t gpio_keypad_irq_handler(int irq_in, void *dev_id)
 		return IRQ_HANDLED;
 
 	for (i = 0; i < mi->ninputs; i++)
-		disable_irq(gpio_to_irq(mi->input_gpios[i]));
+		disable_irq_nosync(gpio_to_irq(mi->input_gpios[i]));
 	for (i = 0; i < mi->noutputs; i++) {
 		if (gpio_keypad_flags & GPIOKPF_DRIVE_INACTIVE)
 			gpio_set_value(mi->output_gpios[i],
@@ -279,7 +284,7 @@ err_gpio_get_irq_num_failed:
 	return err;
 }
 
-int gpio_event_matrix_func(struct input_dev *input_dev,
+int gpio_event_matrix_func(struct gpio_event_input_devs *input_devs,
 	struct gpio_event_info *info, void **data, int func)
 {
 	int i;
@@ -311,13 +316,22 @@ int gpio_event_matrix_func(struct input_dev *input_dev,
 			pr_err("gpiomatrix: Failed to allocate private data\n");
 			goto err_kp_alloc_failed;
 		}
-		kp->input_dev = input_dev;
+		kp->input_devs = input_devs;
 		kp->keypad_info = mi;
-		set_bit(EV_KEY, input_dev->evbit);
 		for (i = 0; i < key_count; i++) {
-			if (mi->keymap[i])
-				set_bit(mi->keymap[i] & KEY_MAX,
-					input_dev->keybit);
+			unsigned short keyentry = mi->keymap[i];
+			unsigned short keycode = keyentry & MATRIX_KEY_MASK;
+			unsigned short dev = keyentry >> MATRIX_CODE_BITS;
+			if (dev >= input_devs->count) {
+				pr_err("gpiomatrix: bad device index %d >= "
+					"%d for key code %d\n",
+					dev, input_devs->count, keycode);
+				err = -EINVAL;
+				goto err_bad_keymap;
+			}
+			if (keycode && keycode <= KEY_MAX)
+				input_set_capability(input_devs->dev[dev],
+							EV_KEY, keycode);
 		}
 
 		for (i = 0; i < mi->noutputs; i++) {
@@ -367,8 +381,9 @@ int gpio_event_matrix_func(struct input_dev *input_dev,
 		err = gpio_keypad_request_irqs(kp);
 		kp->use_irq = err == 0;
 
-		pr_info("GPIO Matrix Keypad Driver: Start keypad matrix for %s "
-			"in %s mode\n", input_dev->name,
+		pr_info("GPIO Matrix Keypad Driver: Start keypad matrix for "
+			"%s%s in %s mode\n", input_devs->dev[0]->name,
+			(input_devs->count > 1) ? "..." : "",
 			kp->use_irq ? "interrupt" : "polling");
 
 		if (kp->use_irq)
@@ -399,6 +414,7 @@ err_output_gpio_configure_failed:
 err_request_output_gpio_failed:
 		;
 	}
+err_bad_keymap:
 	kfree(kp);
 err_kp_alloc_failed:
 err_invalid_platform_data:
diff --git a/drivers/staging/dream/gpio_output.c b/drivers/staging/dream/gpio_output.c
index 6f8453c..2aac2fa 100644
--- a/drivers/staging/dream/gpio_output.c
+++ b/drivers/staging/dream/gpio_output.c
@@ -18,8 +18,9 @@
 #include <linux/gpio_event.h>
 
 int gpio_event_output_event(
-	struct input_dev *input_dev, struct gpio_event_info *info, void **data,
-	unsigned int type, unsigned int code, int value)
+	struct gpio_event_input_devs *input_devs, struct gpio_event_info *info,
+	void **data, unsigned int dev, unsigned int type,
+	unsigned int code, int value)
 {
 	int i;
 	struct gpio_event_output_info *oi;
@@ -29,14 +30,14 @@ int gpio_event_output_event(
 	if (!(oi->flags & GPIOEDF_ACTIVE_HIGH))
 		value = !value;
 	for (i = 0; i < oi->keymap_size; i++)
-		if (code == oi->keymap[i].code)
+		if (dev == oi->keymap[i].dev && code == oi->keymap[i].code)
 			gpio_set_value(oi->keymap[i].gpio, value);
 	return 0;
 }
 
 int gpio_event_output_func(
-	struct input_dev *input_dev, struct gpio_event_info *info, void **data,
-	int func)
+	struct gpio_event_input_devs *input_devs, struct gpio_event_info *info,
+	void **data, int func)
 {
 	int ret;
 	int i;
@@ -48,9 +49,20 @@ int gpio_event_output_func(
 
 	if (func == GPIO_EVENT_FUNC_INIT) {
 		int output_level = !(oi->flags & GPIOEDF_ACTIVE_HIGH);
-		for (i = 0; i < oi->keymap_size; i++)
-			input_set_capability(input_dev, oi->type,
+
+		for (i = 0; i < oi->keymap_size; i++) {
+			int dev = oi->keymap[i].dev;
+			if (dev >= input_devs->count) {
+				pr_err("gpio_event_output_func: bad device "
+					"index %d >= %d for key code %d\n",
+					dev, input_devs->count,
+					oi->keymap[i].code);
+				ret = -EINVAL;
+				goto err_bad_keymap;
+			}
+			input_set_capability(input_devs->dev[dev], oi->type,
 					     oi->keymap[i].code);
+		}
 
 		for (i = 0; i < oi->keymap_size; i++) {
 			ret = gpio_request(oi->keymap[i].gpio,
@@ -79,6 +91,7 @@ err_gpio_direction_output_failed:
 err_gpio_request_failed:
 		;
 	}
+err_bad_keymap:
 	return ret;
 }
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
