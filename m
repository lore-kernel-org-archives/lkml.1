Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZIKV2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZIKV2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbZIKV2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:28:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58228 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZIKV2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:28:00 -0400
Date: Fri, 11 Sep 2009 23:27:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>
Cc: arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: [patch] Re: newer version of HTC Dream support
Message-ID: <20090911212751.GA25544@elf.ucw.cz>
References: <20090824092204.GB25591@elf.ucw.cz> <20090901131832.GA1835@ucw.cz> <20090904090303.024e981a.randy.dunlap@oracle.com> <20090911071155.GA1386@ucw.cz> <20090911075847.2fb7210a.randy.dunlap@oracle.com> <20090911161335.GA8137@elf.ucw.cz> <20090911092157.ba202b0a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911092157.ba202b0a.randy.dunlap@oracle.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Can you do b. (boot) without a. (compile)?
> > 
> > Well, hardly, but I can do a) without b), and it is very much
> > easier. So... which is it?
> 
> I'm only targeting compile/build.

Ok, I guess I should appologize for testing patch in wrong
configuration. This should fix it:

---

Fix compilation of gpio_* input drivers on -next kernel. Adds needed
headers and removes unprotected wakelock/earlysuspend dependencies.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>


diff --git a/drivers/staging/dream/gpio_event.c b/drivers/staging/dream/gpio_event.c
index 8b64c1e..e60e2c0 100644
--- a/drivers/staging/dream/gpio_event.c
+++ b/drivers/staging/dream/gpio_event.c
@@ -13,7 +13,7 @@
  *
  */
 
-#include <linux/earlysuspend.h>
+
 #include <linux/module.h>
 #include <linux/input.h>
 #include <linux/gpio_event.h>
@@ -23,7 +23,6 @@
 struct gpio_event {
 	struct input_dev *input_dev;
 	const struct gpio_event_platform_data *info;
-	struct early_suspend early_suspend;
 	void *state[0];
 };
 
diff --git a/drivers/staging/dream/gpio_input.c b/drivers/staging/dream/gpio_input.c
index 7e307f2..0638ec4 100644
--- a/drivers/staging/dream/gpio_input.c
+++ b/drivers/staging/dream/gpio_input.c
@@ -19,7 +19,6 @@
 #include <linux/hrtimer.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
-#include <linux/wakelock.h>
 
 enum {
 	DEBOUNCE_UNSTABLE     = BIT(0),	/* Got irq, while debouncing */
@@ -44,7 +43,6 @@ struct gpio_input_state {
 	int use_irq;
 	int debounce_count;
 	spinlock_t irq_lock;
-	struct wake_lock wake_lock;
 	struct gpio_key_state key_state[0];
 };
 
@@ -143,8 +141,6 @@ static enum hrtimer_restart gpio_event_input_timer_func(struct hrtimer *timer)
 		hrtimer_start(timer, ds->info->debounce_time, HRTIMER_MODE_REL);
 	else if (!ds->use_irq)
 		hrtimer_start(timer, ds->info->poll_time, HRTIMER_MODE_REL);
-	else
-		wake_unlock(&ds->wake_lock);
 
 	spin_unlock_irqrestore(&ds->irq_lock, irqflags);
 
@@ -170,7 +166,6 @@ static irqreturn_t gpio_event_input_irq_handler(int irq, void *dev_id)
 		if (ks->debounce & DEBOUNCE_WAIT_IRQ) {
 			ks->debounce = DEBOUNCE_UNKNOWN;
 			if (ds->debounce_count++ == 0) {
-				wake_lock(&ds->wake_lock);
 				hrtimer_start(
 					&ds->timer, ds->info->debounce_time,
 					HRTIMER_MODE_REL);
@@ -277,7 +272,6 @@ int gpio_event_input_func(struct input_dev *input_dev,
 		ds->debounce_count = di->keymap_size;
 		ds->input_dev = input_dev;
 		ds->info = di;
-		wake_lock_init(&ds->wake_lock, WAKE_LOCK_SUSPEND, "gpio_input");
 		spin_lock_init(&ds->irq_lock);
 
 		for (i = 0; i < di->keymap_size; i++) {
@@ -336,7 +330,6 @@ err_gpio_configure_failed:
 err_gpio_request_failed:
 		;
 	}
-	wake_lock_destroy(&ds->wake_lock);
 	kfree(ds);
 err_ds_alloc_failed:
 	return ret;
diff --git a/drivers/staging/dream/gpio_matrix.c b/drivers/staging/dream/gpio_matrix.c
index c1f4765..796de4f 100644
--- a/drivers/staging/dream/gpio_matrix.c
+++ b/drivers/staging/dream/gpio_matrix.c
@@ -18,13 +18,11 @@
 #include <linux/gpio_event.h>
 #include <linux/hrtimer.h>
 #include <linux/interrupt.h>
-#include <linux/wakelock.h>
 
 struct gpio_kp {
 	struct input_dev *input_dev;
 	struct gpio_event_matrix_info *keypad_info;
 	struct hrtimer timer;
-	struct wake_lock wake_lock;
 	int current_output;
 	unsigned int use_irq:1;
 	unsigned int key_state_changed:1;
@@ -199,7 +197,6 @@ static enum hrtimer_restart gpio_keypad_timer_func(struct hrtimer *timer)
 	}
 	for (in = 0; in < mi->ninputs; in++)
 		enable_irq(gpio_to_irq(mi->input_gpios[in]));
-	wake_unlock(&kp->wake_lock);
 	return HRTIMER_NORESTART;
 }
 
@@ -222,7 +219,6 @@ static irqreturn_t gpio_keypad_irq_handler(int irq_in, void *dev_id)
 		else
 			gpio_direction_input(mi->output_gpios[i]);
 	}
-	wake_lock(&kp->wake_lock);
 	hrtimer_start(&kp->timer, ktime_set(0, 0), HRTIMER_MODE_REL);
 	return IRQ_HANDLED;
 }
@@ -363,7 +359,6 @@ int gpio_event_matrix_func(struct input_dev *input_dev,
 
 		hrtimer_init(&kp->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 		kp->timer.function = gpio_keypad_timer_func;
-		wake_lock_init(&kp->wake_lock, WAKE_LOCK_SUSPEND, "gpio_kp");
 		err = gpio_keypad_request_irqs(kp);
 		kp->use_irq = err == 0;
 
@@ -371,8 +366,6 @@ int gpio_event_matrix_func(struct input_dev *input_dev,
 			"in %s mode\n", input_dev->name,
 			kp->use_irq ? "interrupt" : "polling");
 
-		if (kp->use_irq)
-			wake_lock(&kp->wake_lock);
 		hrtimer_start(&kp->timer, ktime_set(0, 0), HRTIMER_MODE_REL);
 
 		return 0;
@@ -386,7 +379,6 @@ int gpio_event_matrix_func(struct input_dev *input_dev,
 			free_irq(gpio_to_irq(mi->input_gpios[i]), kp);
 
 	hrtimer_cancel(&kp->timer);
-	wake_lock_destroy(&kp->wake_lock);
 	for (i = mi->noutputs - 1; i >= 0; i--) {
 err_gpio_direction_input_failed:
 		gpio_free(mi->input_gpios[i]);
diff --git a/include/linux/gpio_event.h b/include/linux/gpio_event.h
new file mode 100644
index 0000000..5ff828b
--- /dev/null
+++ b/include/linux/gpio_event.h
@@ -0,0 +1,154 @@
+/* include/linux/gpio_event.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _LINUX_GPIO_EVENT_H
+#define _LINUX_GPIO_EVENT_H
+
+#include <linux/input.h>
+
+enum {
+	GPIO_EVENT_FUNC_UNINIT  = 0x0,
+	GPIO_EVENT_FUNC_INIT    = 0x1,
+	GPIO_EVENT_FUNC_SUSPEND = 0x2,
+	GPIO_EVENT_FUNC_RESUME  = 0x3,
+};
+struct gpio_event_info {
+	int (*func)(struct input_dev *input_dev,
+		    struct gpio_event_info *info,
+		    void **data, int func);
+	int (*event)(struct input_dev *input_dev,
+		     struct gpio_event_info *info,
+		     void **data, unsigned int type,
+		     unsigned int code, int value); /* out events */
+};
+
+struct gpio_event_platform_data {
+	const char *name;
+	struct gpio_event_info **info;
+	size_t info_count;
+	int (*power)(const struct gpio_event_platform_data *pdata, bool on);
+};
+
+#define GPIO_EVENT_DEV_NAME "gpio-event"
+
+/* Key matrix */
+
+enum gpio_event_matrix_flags {
+	/* unset: drive active output low, set: drive active output high */
+	GPIOKPF_ACTIVE_HIGH              = 1U << 0,
+	GPIOKPF_DEBOUNCE                 = 1U << 1,
+	GPIOKPF_REMOVE_SOME_PHANTOM_KEYS = 1U << 2,
+	GPIOKPF_REMOVE_PHANTOM_KEYS      = GPIOKPF_REMOVE_SOME_PHANTOM_KEYS |
+					   GPIOKPF_DEBOUNCE,
+	GPIOKPF_DRIVE_INACTIVE           = 1U << 3,
+	GPIOKPF_LEVEL_TRIGGERED_IRQ      = 1U << 4,
+	GPIOKPF_PRINT_UNMAPPED_KEYS      = 1U << 16,
+	GPIOKPF_PRINT_MAPPED_KEYS        = 1U << 17,
+	GPIOKPF_PRINT_PHANTOM_KEYS       = 1U << 18,
+};
+
+extern int gpio_event_matrix_func(struct input_dev *input_dev,
+			struct gpio_event_info *info, void **data, int func);
+struct gpio_event_matrix_info {
+	/* initialize to gpio_event_matrix_func */
+	struct gpio_event_info info;
+	/* size must be ninputs * noutputs */
+	const unsigned short *keymap;
+	unsigned int *input_gpios;
+	unsigned int *output_gpios;
+	unsigned int ninputs;
+	unsigned int noutputs;
+	/* time to wait before reading inputs after driving each output */
+	ktime_t settle_time;
+	/* time to wait before scanning the keypad a second time */
+	ktime_t debounce_delay;
+	ktime_t poll_time;
+	unsigned flags;
+};
+
+/* Directly connected inputs and outputs */
+
+enum gpio_event_direct_flags {
+	GPIOEDF_ACTIVE_HIGH         = 1U << 0,
+/*	GPIOEDF_USE_DOWN_IRQ        = 1U << 1, */
+/*	GPIOEDF_USE_IRQ             = (1U << 2) | GPIOIDF_USE_DOWN_IRQ, */
+	GPIOEDF_PRINT_KEYS          = 1U << 8,
+	GPIOEDF_PRINT_KEY_DEBOUNCE  = 1U << 9,
+};
+
+struct gpio_event_direct_entry {
+	uint32_t gpio:23;
+	uint32_t code:9;
+};
+
+/* inputs */
+extern int gpio_event_input_func(struct input_dev *input_dev,
+			struct gpio_event_info *info, void **data, int func);
+struct gpio_event_input_info {
+	/* initialize to gpio_event_input_func */
+	struct gpio_event_info info;
+	ktime_t debounce_time;
+	ktime_t poll_time;
+	uint16_t flags;
+	uint16_t type;
+	const struct gpio_event_direct_entry *keymap;
+	size_t keymap_size;
+};
+
+/* outputs */
+extern int gpio_event_output_func(struct input_dev *input_dev,
+			struct gpio_event_info *info, void **data, int func);
+extern int gpio_event_output_event(struct input_dev *input_dev,
+			struct gpio_event_info *info, void **data,
+			unsigned int type, unsigned int code, int value);
+struct gpio_event_output_info {
+	/* initialize to gpio_event_output_func and gpio_event_output_event */
+	struct gpio_event_info info;
+	uint16_t flags;
+	uint16_t type;
+	const struct gpio_event_direct_entry *keymap;
+	size_t keymap_size;
+};
+
+
+/* axes */
+
+enum gpio_event_axis_flags {
+	GPIOEAF_PRINT_UNKNOWN_DIRECTION  = 1U << 16,
+	GPIOEAF_PRINT_RAW                = 1U << 17,
+	GPIOEAF_PRINT_EVENT              = 1U << 18,
+};
+
+extern int gpio_event_axis_func(struct input_dev *input_dev,
+			struct gpio_event_info *info, void **data, int func);
+struct gpio_event_axis_info {
+	/* initialize to gpio_event_axis_func */
+	struct gpio_event_info info;
+	uint8_t  count;
+	uint8_t  type; /* EV_REL or EV_ABS */
+	uint16_t code;
+	uint16_t decoded_size;
+	uint16_t (*map)(struct gpio_event_axis_info *info, uint16_t in);
+	uint32_t *gpio;
+	uint32_t flags;
+};
+#define gpio_axis_2bit_gray_map gpio_axis_4bit_gray_map
+#define gpio_axis_3bit_gray_map gpio_axis_4bit_gray_map
+uint16_t gpio_axis_4bit_gray_map(
+			struct gpio_event_axis_info *info, uint16_t in);
+uint16_t gpio_axis_5bit_singletrack_map(
+			struct gpio_event_axis_info *info, uint16_t in);
+
+#endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
