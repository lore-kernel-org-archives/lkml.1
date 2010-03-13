Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab0CMMiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:38:51 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:43263 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758156Ab0CMMit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:38:49 -0500
Date: Sat, 13 Mar 2010 13:38:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>, Greg KH <greg@kroah.com>
Subject: Dream: Hook up trackball to drivers/staging interface
Message-ID: <20100313123841.GE2192@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

With this and fixes from -rc4, applied on top of -working-mmc tree, I
get working trackball. (Tested with cat, not evtest).

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-msm/board-dream.c b/arch/arm/mach-msm/board-dream.c
index d40ce48..f48c797 100644
--- a/arch/arm/mach-msm/board-dream.c
+++ b/arch/arm/mach-msm/board-dream.c
@@ -31,6 +31,132 @@
 #include "board-dream.h"
 #include "proc_comm.h"
 
+#include <linux/gpio.h>
+
+/*
+ * Input devices
+ */
+
+#ifndef CONFIG_INPUT_GPIO
+#error Gpio input is very recommended on Dream
+#else
+#include "../../../drivers/staging/dream/include/linux/gpio_event.h"
+struct dream_axis_info {
+	struct gpio_event_axis_info info;
+	uint16_t in_state;
+	uint16_t out_state;
+};
+static bool nav_just_on;
+static int nav_on_jiffies;
+
+uint16_t dream_axis_map(struct gpio_event_axis_info *info, uint16_t in)
+{
+	struct dream_axis_info *ai = container_of(info, struct dream_axis_info, info);
+	uint16_t out = ai->out_state;
+
+	if (nav_just_on) {
+		if (jiffies == nav_on_jiffies || jiffies == nav_on_jiffies + 1)
+			goto ignore;
+		nav_just_on = 0;
+	}
+	if((ai->in_state ^ in) & 1)
+		out--;
+	if((ai->in_state ^ in) & 2)
+		out++;
+	ai->out_state = out;
+ignore:
+	ai->in_state = in;
+	return out;
+}
+
+int dream_nav_power(const struct gpio_event_platform_data *pdata, bool on)
+{
+	gpio_set_value(DREAM_GPIO_JOG_EN, on);
+	if (on) {
+		nav_just_on = 1;
+		nav_on_jiffies = jiffies;
+	}
+	return 0;
+}
+
+static uint32_t dream_4_x_axis_gpios[] = {
+	DREAM_4_BALL_LEFT_0, DREAM_4_BALL_RIGHT_0
+};
+static uint32_t dream_5_x_axis_gpios[] = {
+	DREAM_5_BALL_LEFT_0, DREAM_5_BALL_RIGHT_0
+};
+
+static struct dream_axis_info dream_x_axis = {
+	.info = {
+		.info.func = gpio_event_axis_func,
+		.count = ARRAY_SIZE(dream_5_x_axis_gpios),
+		.type = EV_REL,
+		.code = REL_X,
+		.decoded_size = 1U << ARRAY_SIZE(dream_5_x_axis_gpios),
+		.map = dream_axis_map,
+		.gpio = dream_5_x_axis_gpios,
+		.flags = GPIOEAF_PRINT_UNKNOWN_DIRECTION /*| GPIOEAF_PRINT_RAW | GPIOEAF_PRINT_EVENT */
+	}
+};
+
+static uint32_t dream_4_y_axis_gpios[] = {
+	DREAM_4_BALL_UP_0, DREAM_4_BALL_DOWN_0
+};
+static uint32_t dream_5_y_axis_gpios[] = {
+	DREAM_5_BALL_UP_0, DREAM_5_BALL_DOWN_0
+};
+
+static struct dream_axis_info dream_y_axis = {
+	.info = {
+		.info.func = gpio_event_axis_func,
+		.count = ARRAY_SIZE(dream_5_y_axis_gpios),
+		.type = EV_REL,
+		.code = REL_Y,
+		.decoded_size = 1U << ARRAY_SIZE(dream_5_y_axis_gpios),
+		.map = dream_axis_map,
+		.gpio = dream_5_y_axis_gpios,
+		.flags = GPIOEAF_PRINT_UNKNOWN_DIRECTION /*| GPIOEAF_PRINT_RAW | GPIOEAF_PRINT_EVENT */
+	}
+};
+
+static struct gpio_event_direct_entry dream_nav_buttons[] = {
+	{ DREAM_GPIO_NAVI_ACT_N, BTN_MOUSE }
+};
+
+static struct gpio_event_input_info dream_nav_button_info = {
+	.info.func = gpio_event_input_func,
+	.flags = 0,
+	.type = EV_KEY,
+	.keymap = dream_nav_buttons,
+	.keymap_size = ARRAY_SIZE(dream_nav_buttons)
+};
+
+static struct gpio_event_info *dream_nav_info[] = {
+	&dream_x_axis.info.info,
+	&dream_y_axis.info.info,
+	&dream_nav_button_info.info
+};
+
+static struct gpio_event_platform_data dream_nav_data = {
+	.name = "dream-nav",
+	.info = dream_nav_info,
+	.info_count = ARRAY_SIZE(dream_nav_info),
+	.power = dream_nav_power,
+};
+
+static struct platform_device dream_nav_device = {
+	.name = GPIO_EVENT_DEV_NAME,
+	.id = 2,
+	.dev = {
+		.platform_data = &dream_nav_data,
+	},
+};
+#endif
+
+/*
+ * Core stuff
+ */
+
 extern int dream_init_mmc(unsigned int);
 
 static struct platform_device *devices[] __initdata = {
@@ -39,6 +165,9 @@ static struct platform_device *devices[] __initdata = {
 	&msm_device_nand,
 	&msm_device_hsusb,
 	&msm_device_i2c,
+#ifdef CONFIG_INPUT_GPIO
+	&dream_nav_device,
+#endif
 };
 
 extern struct sys_timer msm_timer;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
