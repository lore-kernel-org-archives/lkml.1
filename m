Return-Path: <linux-kernel-owner+w=401wt.eu-S1751420AbZKHGAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbZKHGAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 01:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZKHGAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 01:00:49 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:58578 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbZKHGAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 01:00:48 -0500
Date: Sun, 8 Nov 2009 01:00:43 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       cjb@laptop.org, deepak@laptop.org,
       Jordan Crouse <jordan@cosmicpenguin.net>
Subject: [PATCH 2/6] CS5535: add a generic clock event MFGPT driver
Message-ID: <20091108010043.11c8bdaa@mycelium.queued.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is based on the old code in arch/x86/kernel/mfgpt_32.c, but is
modular and not Geode-specific.  There's no reason why the clock event
device needs to be registered so early at boot; the clockevent code
is perfectly capable of dynamic switching.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/Kconfig                       |    2 +
 drivers/clocksource/Kconfig           |    9 ++
 drivers/clocksource/Makefile          |    1 +
 drivers/clocksource/cs5535-clockevt.c |  196 +++++++++++++++++++++++++++++++++
 4 files changed, 208 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clocksource/Kconfig
 create mode 100644 drivers/clocksource/cs5535-clockevt.c

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 48bbdbe..b4bc5a4 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -98,6 +98,8 @@ source "drivers/edac/Kconfig"
 
 source "drivers/rtc/Kconfig"
 
+source "drivers/clocksource/Kconfig"
+
 source "drivers/dma/Kconfig"
 
 source "drivers/dca/Kconfig"
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
new file mode 100644
index 0000000..08f726c
--- /dev/null
+++ b/drivers/clocksource/Kconfig
@@ -0,0 +1,9 @@
+config CS5535_CLOCK_EVENT_SRC
+	tristate "CS5535/CS5536 high-res timer (MFGPT) events"
+	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS && CS5535_MFGPT
+	help
+	  This driver provides a clock event source based on the MFGPT
+	  timer(s) in the CS5535 and CS5536 companion chips.
+	  MFGPTs have a better resolution and max interval than the
+	  generic PIT, and are suitable for use as high-res timers.
+
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index eef216f..be61ece 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_ATMEL_TCB_CLKSRC)	+= tcb_clksrc.o
 obj-$(CONFIG_X86_CYCLONE_TIMER)	+= cyclone.o
 obj-$(CONFIG_X86_PM_TIMER)	+= acpi_pm.o
 obj-$(CONFIG_SCx200HR_TIMER)	+= scx200_hrt.o
+obj-$(CONFIG_CS5535_CLOCK_EVENT_SRC)	+= cs5535-clockevt.o
 obj-$(CONFIG_SH_TIMER_CMT)	+= sh_cmt.o
 obj-$(CONFIG_SH_TIMER_MTU2)	+= sh_mtu2.o
 obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
diff --git a/drivers/clocksource/cs5535-clockevt.c b/drivers/clocksource/cs5535-clockevt.c
new file mode 100644
index 0000000..29e8621
--- /dev/null
+++ b/drivers/clocksource/cs5535-clockevt.c
@@ -0,0 +1,196 @@
+/*
+ * Clock event driver for the CS5535/CS5536
+ *
+ * Copyright (C) 2006, Advanced Micro Devices, Inc.
+ * Copyright (C) 2007  Andres Salomon <dilinger@debian.org>
+ * Copyright (C) 2009  Andres Salomon <dilinger@collabora.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ *
+ * The MFGPTs are documented in AMD Geode CS5536 Companion Device Data Book.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/cs5535.h>
+#include <linux/clockchips.h>
+
+#define DRV_NAME "cs5535-clockevt"
+
+static int timer_irq = CONFIG_CS5535_MFGPT_DEFAULT_IRQ;
+module_param_named(irq, timer_irq, int, 0644);
+MODULE_PARM_DESC(irq, "Which IRQ to use for the clock source MFGPT ticks.");
+
+/*
+ * We are using the 32.768kHz input clock - it's the only one that has the
+ * ranges we find desirable.  The following table lists the suitable
+ * divisors and the associated Hz, minimum interval and the maximum interval:
+ *
+ *  Divisor   Hz      Min Delta (s)  Max Delta (s)
+ *   1        32768   .00048828125      2.000
+ *   2        16384   .0009765625       4.000
+ *   4         8192   .001953125        8.000
+ *   8         4096   .00390625        16.000
+ *   16        2048   .0078125         32.000
+ *   32        1024   .015625          64.000
+ *   64         512   .03125          128.000
+ *  128         256   .0625           256.000
+ *  256         128   .125            512.000
+ */
+
+static unsigned int cs5535_tick_mode = CLOCK_EVT_MODE_SHUTDOWN;
+static struct cs5535_mfgpt_timer *cs5535_event_clock;
+
+/* Selected from the table above */
+
+#define MFGPT_DIVISOR 16
+#define MFGPT_SCALE  4     /* divisor = 2^(scale) */
+#define MFGPT_HZ  (32768 / MFGPT_DIVISOR)
+#define MFGPT_PERIODIC (MFGPT_HZ / HZ)
+
+/*
+ * The MFPGT timers on the CS5536 provide us with suitable timers to use
+ * as clock event sources - not as good as a HPET or APIC, but certainly
+ * better than the PIT.  This isn't a general purpose MFGPT driver, but
+ * a simplified one designed specifically to act as a clock event source.
+ * For full details about the MFGPT, please consult the CS5536 data sheet.
+ */
+
+static void disable_timer(struct cs5535_mfgpt_timer *timer)
+{
+	/* avoid races by clearing CMP1 and CMP2 unconditionally */
+	cs5535_mfgpt_write(timer, MFGPT_REG_SETUP,
+			(uint16_t) ~MFGPT_SETUP_CNTEN | MFGPT_SETUP_CMP1 |
+				MFGPT_SETUP_CMP2);
+}
+
+static void start_timer(struct cs5535_mfgpt_timer *timer, uint16_t delta)
+{
+	cs5535_mfgpt_write(timer, MFGPT_REG_CMP2, delta);
+	cs5535_mfgpt_write(timer, MFGPT_REG_COUNTER, 0);
+
+	cs5535_mfgpt_write(timer, MFGPT_REG_SETUP,
+			MFGPT_SETUP_CNTEN | MFGPT_SETUP_CMP2);
+}
+
+static void mfgpt_set_mode(enum clock_event_mode mode,
+		struct clock_event_device *evt)
+{
+	disable_timer(cs5535_event_clock);
+
+	if (mode == CLOCK_EVT_MODE_PERIODIC)
+		start_timer(cs5535_event_clock, MFGPT_PERIODIC);
+
+	cs5535_tick_mode = mode;
+}
+
+static int mfgpt_next_event(unsigned long delta, struct clock_event_device *evt)
+{
+	start_timer(cs5535_event_clock, delta);
+	return 0;
+}
+
+static struct clock_event_device cs5535_clockevent = {
+	.name = DRV_NAME,
+	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode = mfgpt_set_mode,
+	.set_next_event = mfgpt_next_event,
+	.rating = 250,
+	.cpumask = cpu_all_mask,
+	.shift = 32
+};
+
+static irqreturn_t mfgpt_tick(int irq, void *dev_id)
+{
+	uint16_t val = cs5535_mfgpt_read(cs5535_event_clock, MFGPT_REG_SETUP);
+
+	/* See if the interrupt was for us */
+	if (!(val & (MFGPT_SETUP_SETUP | MFGPT_SETUP_CMP2 | MFGPT_SETUP_CMP1)))
+		return IRQ_NONE;
+
+	/* Turn off the clock (and clear the event) */
+	disable_timer(cs5535_event_clock);
+
+	if (cs5535_tick_mode == CLOCK_EVT_MODE_SHUTDOWN)
+		return IRQ_HANDLED;
+
+	/* Clear the counter */
+	cs5535_mfgpt_write(cs5535_event_clock, MFGPT_REG_COUNTER, 0);
+
+	/* Restart the clock in periodic mode */
+
+	if (cs5535_tick_mode == CLOCK_EVT_MODE_PERIODIC)
+		cs5535_mfgpt_write(cs5535_event_clock, MFGPT_REG_SETUP,
+				MFGPT_SETUP_CNTEN | MFGPT_SETUP_CMP2);
+
+	cs5535_clockevent.event_handler(&cs5535_clockevent);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction mfgptirq  = {
+	.handler = mfgpt_tick,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
+	.name = DRV_NAME,
+};
+
+static int __init cs5535_mfgpt_init(void)
+{
+	struct cs5535_mfgpt_timer *timer;
+	int ret;
+	uint16_t val;
+
+	timer = cs5535_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
+	if (!timer) {
+		printk(KERN_ERR DRV_NAME ": Could not allocate MFPGT timer\n");
+		return -ENODEV;
+	}
+	cs5535_event_clock = timer;
+
+	/* Set up the IRQ on the MFGPT side */
+	if (cs5535_mfgpt_setup_irq(timer, MFGPT_CMP2, &timer_irq)) {
+		printk(KERN_ERR DRV_NAME ": Could not set up IRQ %d\n",
+				timer_irq);
+		return -EIO;
+	}
+
+	/* And register it with the kernel */
+	ret = setup_irq(timer_irq, &mfgptirq);
+	if (ret) {
+		printk(KERN_ERR DRV_NAME ": Unable to set up the interrupt.\n");
+		goto err;
+	}
+
+	/* Set the clock scale and enable the event mode for CMP2 */
+	val = MFGPT_SCALE | (3 << 8);
+
+	cs5535_mfgpt_write(cs5535_event_clock, MFGPT_REG_SETUP, val);
+
+	/* Set up the clock event */
+	cs5535_clockevent.mult = div_sc(MFGPT_HZ, NSEC_PER_SEC,
+			cs5535_clockevent.shift);
+	cs5535_clockevent.min_delta_ns = clockevent_delta2ns(0xF,
+			&cs5535_clockevent);
+	cs5535_clockevent.max_delta_ns = clockevent_delta2ns(0xFFFE,
+			&cs5535_clockevent);
+
+	printk(KERN_INFO DRV_NAME
+		": Registering MFGPT timer as a clock event, using IRQ %d\n",
+		timer_irq);
+	clockevents_register_device(&cs5535_clockevent);
+
+	return 0;
+
+err:
+	cs5535_mfgpt_release_irq(cs5535_event_clock, MFGPT_CMP2, &timer_irq);
+	printk(KERN_ERR DRV_NAME ": Unable to set up the MFGPT clock source\n");
+	return -EIO;
+}
+
+module_init(cs5535_mfgpt_init);
+
+MODULE_AUTHOR("Andres Salomon <dilinger@collabora.co.uk>");
+MODULE_DESCRIPTION("CS5535/CS5536 MFGPT clock event driver");
+MODULE_LICENSE("GPL");
-- 
1.5.6.5

