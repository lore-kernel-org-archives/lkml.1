Return-Path: <linux-kernel-owner+w=401wt.eu-S2992663AbXCXHcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992663AbXCXHcC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 03:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965225AbXCXHbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 03:31:40 -0400
Received: from peabody.ximian.com ([130.57.169.10]:36816 "EHLO
	peabody.ximian.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965320AbXCXHbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 03:31:32 -0400
Subject: [RFC][PATCH 3/3] add the 'menu' cpuidle governor
From: Adam Belay <abelay@novell.com>
To: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Shaohua Li <shaohua.li@intel.com>, Pallipadi@vger.kernel.org,
       Venkatesh <venkatesh.pallipadi@intel.com>, linux-acpi@vger.kernel.org
Content-Type: text/plain
Date: Sat, 24 Mar 2007 03:47:07 -0400
Message-Id: <1174722427.32554.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the 'menu' governor, as was described in my first email.

Thanks,
Adam

 Kconfig            |   11 +++
 governors/Makefile |    1
 governors/menu.c   |  152 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 164 insertions(+)


diff -urN a/drivers/cpuidle/governors/Makefile b/drivers/cpuidle/governors/Makefile
--- a/drivers/cpuidle/governors/Makefile	2007-03-23 23:09:45.000000000 -0400
+++ b/drivers/cpuidle/governors/Makefile	2007-03-24 02:10:29.000000000 -0400
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_CPU_IDLE_GOV_LADDER) += ladder.o
+obj-$(CONFIG_CPU_IDLE_GOV_MENU) += menu.o
diff -urN a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/cpuidle/governors/menu.c	2007-03-23 23:51:15.000000000 -0400
@@ -0,0 +1,152 @@
+/*
+ * menu.c - the menu idle governor
+ *
+ * Copyright (C) 2006-2007 Adam Belay <abelay@novell.com>
+ *
+ * This code is licenced under the GPL.
+ */
+
+#include <linux/kernel.h>
+#include <linux/cpuidle.h>
+#include <linux/latency.h>
+#include <linux/time.h>
+#include <linux/ktime.h>
+#include <linux/tick.h>
+#include <linux/hrtimer.h>
+
+#define BM_HOLDOFF	20000	/* 20 ms */
+
+struct menu_device {
+	int		last_state_idx;
+	int		deepest_bm_state;
+
+	int		break_last_us;
+	int		break_elapsed_us;
+
+	int		bm_elapsed_us;
+	int		bm_holdoff_us;
+
+	unsigned long	idle_jiffies;
+};
+
+static DEFINE_PER_CPU(struct menu_device, menu_devices);
+
+/**
+ * menu_select - selects the next idle state to enter
+ * @dev: the CPU
+ */
+static int menu_select(struct cpuidle_device *dev)
+{
+	struct menu_device *data = &__get_cpu_var(menu_devices);
+	int i, expected_us, max_state = dev->state_count;
+
+	/* discard BM history because it is sticky */
+	cpuidle_get_bm_activity();
+
+	/* determine the expected residency time */
+	expected_us = (s32) ktime_to_ns(tick_nohz_get_sleep_length()) / 1000;
+	expected_us = min(expected_us, data->break_last_us);
+
+	/* determine the maximum state compatible with current BM status */
+	if (cpuidle_get_bm_activity())
+		data->bm_elapsed_us = 0;
+	if (data->bm_elapsed_us <= data->bm_holdoff_us)
+		max_state = data->deepest_bm_state + 1;
+
+	/* find the deepest idle state that satisfies our constraints */
+	for (i = 1; i < max_state; i++) {
+		struct cpuidle_state *s = &dev->states[i];
+		if (s->target_residency > expected_us)
+			break;
+		if (s->exit_latency > system_latency_constraint())
+			break;
+	}
+
+	data->last_state_idx = i - 1;
+	data->idle_jiffies = tick_nohz_get_idle_jiffies();
+	return i - 1;
+}
+
+/**
+ * menu_reflect - attempts to guess what happened after entry
+ * @dev: the CPU
+ *
+ * NOTE: it's important to be fast here because this operation will add to
+ *       the overall exit latency.
+ */
+static void menu_reflect(struct cpuidle_device *dev)
+{
+	struct menu_device *data = &__get_cpu_var(menu_devices);
+	int last_idx = data->last_state_idx;
+	int measured_us = cpuidle_get_last_residency(dev);
+	struct cpuidle_state *target = &dev->states[last_idx];
+
+	/*
+	 * Ugh, this idle state doesn't support residency measurements, so we
+	 * are basically lost in the dark.  As a compromise, assume we slept
+	 * for one full standard timer tick.  However, be aware that this
+	 * could potentially result in a suboptimal state transition.
+	 */
+	if (!(target->flags & CPUIDLE_FLAG_TIME_VALID))
+		measured_us = USEC_PER_SEC / HZ;
+
+	data->bm_elapsed_us += measured_us;
+	data->break_elapsed_us += measured_us;
+
+	/*
+	 * Did something other than the timer interrupt cause the break event?
+	 */
+	if (tick_nohz_get_idle_jiffies() == data->idle_jiffies) {
+		data->break_last_us = data->break_elapsed_us;
+		data->break_elapsed_us = 0;
+	}
+}
+
+/**
+ * menu_scan_device - scans a CPU's states and does setup
+ * @dev: the CPU
+ */
+static void menu_scan_device(struct cpuidle_device *dev)
+{
+	struct menu_device *data = &per_cpu(menu_devices, dev->cpu);
+	int i;
+
+	data->last_state_idx = 0;
+	data->break_last_us = 0;
+	data->break_elapsed_us = 0;
+	data->bm_elapsed_us = 0;
+	data->bm_holdoff_us = BM_HOLDOFF;
+
+	for (i = 1; i < dev->state_count; i++)
+		if (dev->states[i].flags & CPUIDLE_FLAG_CHECK_BM)
+			break;
+	data->deepest_bm_state = i - 1;
+}
+
+struct cpuidle_governor menu_governor = {
+	.name =		"menu",
+	.scan =		menu_scan_device,
+	.select =	menu_select,
+	.reflect =	menu_reflect,
+	.owner =	THIS_MODULE,
+};
+
+/**
+ * init_menu - initializes the governor
+ */
+static int __init init_menu(void)
+{
+	return cpuidle_register_governor(&menu_governor);
+}
+
+/**
+ * exit_menu - exits the governor
+ */
+static void __exit exit_menu(void)
+{
+	cpuidle_unregister_governor(&menu_governor);
+}
+
+MODULE_LICENSE("GPL");
+module_init(init_menu);
+module_exit(exit_menu);
diff -urN a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
--- a/drivers/cpuidle/Kconfig	2007-03-23 23:09:45.000000000 -0400
+++ b/drivers/cpuidle/Kconfig	2007-03-24 02:18:19.000000000 -0400
@@ -23,6 +23,17 @@
 	  states using residency time and bus master activity as metrics.  This
 	  algorithm was originally introduced in the old ACPI processor driver.
 
+config CPU_IDLE_GOV_MENU
+	tristate "'menu' governor"
+	depends on CPU_IDLE && NO_HZ
+	default y
+	help
+	  This cpuidle governor evaluates all available states and chooses the
+	  deepest state that meets all of the following constraints: BM activity,
+	  expected time until next timer interrupt, and last break event time
+	  delta.  It is designed to minimize power consumption.  Currently
+	  dynticks is required.
+
 endif	# CPU_IDLE
 
 endmenu


