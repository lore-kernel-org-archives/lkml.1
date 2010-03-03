Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab0CCFIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:08:04 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:52361 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821Ab0CCFHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:07:53 -0500
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, armando.visconti@st.com, amit.goel@st.com,
       shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
       deepak.sikri@st.com, ashish.priyadarshi@st.com,
       Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 06/11] ST SPEAr: Added source files for SPEAr platform
Date: Wed,  3 Mar 2010 10:37:36 +0530
Message-Id: <1267592861-26911-7-git-send-email-viresh.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1267592861-26911-6-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-6-git-send-email-viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/plat-spear/Kconfig  |   31 +++
 arch/arm/plat-spear/Makefile |    6 +
 arch/arm/plat-spear/gpt.c    |  537 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/plat-spear/time.c   |  197 +++++++++++++++
 4 files changed, 771 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-spear/Kconfig
 create mode 100644 arch/arm/plat-spear/Makefile
 create mode 100644 arch/arm/plat-spear/gpt.c
 create mode 100644 arch/arm/plat-spear/time.c

diff --git a/arch/arm/plat-spear/Kconfig b/arch/arm/plat-spear/Kconfig
new file mode 100644
index 0000000..1bb3dbc
--- /dev/null
+++ b/arch/arm/plat-spear/Kconfig
@@ -0,0 +1,31 @@
+#
+# SPEAr Platform configuration file
+#
+
+if PLAT_SPEAR
+
+choice
+	prompt "ST SPEAr Family"
+	default ARCH_SPEAR3XX
+
+config ARCH_SPEAR3XX
+	bool "SPEAr3XX"
+	select ARM_VIC
+	select CPU_ARM926T
+	help
+	  Supports for ARM's SPEAR3XX family
+
+config ARCH_SPEAR6XX
+	bool "SPEAr6XX"
+	select ARM_VIC
+	select CPU_ARM926T
+	help
+	  Supports for ARM's SPEAR6XX family
+
+endchoice
+
+# Adding SPEAr machine specific configuration files
+source "arch/arm/mach-spear3xx/Kconfig"
+source "arch/arm/mach-spear6xx/Kconfig"
+
+endif
diff --git a/arch/arm/plat-spear/Makefile b/arch/arm/plat-spear/Makefile
new file mode 100644
index 0000000..4412f05
--- /dev/null
+++ b/arch/arm/plat-spear/Makefile
@@ -0,0 +1,6 @@
+#
+# SPEAr Platform specific Makefile
+#
+
+# Common support
+obj-y	:= clock.o gpt.o time.o
diff --git a/arch/arm/plat-spear/gpt.c b/arch/arm/plat-spear/gpt.c
new file mode 100644
index 0000000..3b16360
--- /dev/null
+++ b/arch/arm/plat-spear/gpt.c
@@ -0,0 +1,537 @@
+/*
+ * arch/arm/plat-spear/gpt.c
+ *
+ * ST GPT Timer driver, based on omap's dmtimer.c
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Shiraz Hashim<shiraz.hashim@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/clk.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <mach/irqs.h>
+#include <mach/spear.h>
+#include <plat/gpt.h>
+
+static const char *src_clk_con_id[] __initdata = {
+	"pll3_48m_clk",
+	"pll1_clk",
+	NULL
+};
+
+static struct clk *spear_source_clocks[2];
+static struct spear_timer *spear_timers;
+static int spear_timer_count;
+static spinlock_t spear_timer_lock;
+
+/*
+ * static helper functions
+ */
+static inline u16 spear_timer_read_reg(struct spear_timer *timer, u32 reg)
+{
+	return readw(timer->io_base + (reg & 0xff));
+}
+
+static inline void spear_timer_write_reg(struct spear_timer *timer, u32 reg,
+						u16 value)
+{
+	writew(value, timer->io_base + (reg & 0xff));
+}
+
+static void spear_timer_reset(struct spear_timer *timer)
+{
+
+	spear_timer_write_reg(timer, GPT_CTRL_OFF, 0x0);
+	spear_timer_write_reg(timer, GPT_LOAD_OFF, 0x0);
+	spear_timer_write_reg(timer, GPT_INT_OFF, GPT_STATUS_MATCH);
+	timer->prescaler = 0;
+}
+
+static void spear_timer_prepare(struct spear_timer *timer)
+{
+	spear_timer_enable(timer);
+	spear_timer_reset(timer);
+}
+
+/* functions exported for application */
+
+/**
+ * spear_timer_enable - enable a timer
+ * @timer: timer
+ *
+ * This API enables the functional clock of the timer
+ */
+int spear_timer_enable(struct spear_timer *timer)
+{
+	if (!timer)
+		return -ENODEV;
+
+	if (timer->enabled)
+		return -EINVAL;
+
+	clk_enable(timer->fclk);
+
+	timer->enabled = 1;
+
+	return 0;
+}
+
+/**
+ * spear_timer_disable - disables timer
+ * @timer: timer
+ *
+ * The API disables the functional clock of the timer
+ */
+int spear_timer_disable(struct spear_timer *timer)
+{
+	if (!timer)
+		return -ENODEV;
+
+	if (!timer->enabled)
+		return -EINVAL;
+
+	clk_disable(timer->fclk);
+
+	timer->enabled = 0;
+
+	return 0;
+}
+
+/**
+ * spear_timer_request - request for a timer
+ *
+ * This API returns a timer which is available, returns NULL if none is
+ * available
+ */
+struct spear_timer *spear_timer_request(void)
+{
+	struct spear_timer *timer = NULL;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&spear_timer_lock, flags);
+
+	for (i = 0; i < spear_timer_count; i++) {
+		if (spear_timers[i].reserved)
+			continue;
+
+		timer = &spear_timers[i];
+		timer->reserved = 1;
+		break;
+	}
+
+	spin_unlock_irqrestore(&spear_timer_lock, flags);
+
+	if (timer != NULL)
+		spear_timer_prepare(timer);
+
+	return timer;
+}
+EXPORT_SYMBOL(spear_timer_request);
+
+/**
+ * spear_timer_request_specific - request for a specific timer
+ * @id: timer id requested, 1 onwards
+ *
+ * This API returns specific timer which is requested, returns NULL if it is
+ * not available.
+ */
+struct spear_timer *spear_timer_request_specific(int id)
+{
+	struct spear_timer *timer;
+	unsigned long flags;
+
+	spin_lock_irqsave(&spear_timer_lock, flags);
+
+	if (id < 0 || id >= spear_timer_count ||
+			spear_timers[id].reserved) {
+		spin_unlock_irqrestore(&spear_timer_lock, flags);
+		printk(KERN_ERR "BUG: unable to get timer %d\n", id);
+		dump_stack();
+		return NULL;
+	}
+
+	timer = &spear_timers[id];
+	timer->reserved = 1;
+	spin_unlock_irqrestore(&spear_timer_lock, flags);
+
+	spear_timer_prepare(timer);
+
+	return timer;
+}
+EXPORT_SYMBOL(spear_timer_request_specific);
+
+/**
+ * spear_timer_free - free the timer
+ * @timer: timer which should be freed
+ *
+ * Applications should free the timer when not in use. The API also resets and
+ * disables the timer clock
+ */
+int spear_timer_free(struct spear_timer *timer)
+{
+	if (!timer)
+		return -ENODEV;
+
+	WARN_ON(!timer->reserved);
+
+	spear_timer_reset(timer);
+	spear_timer_disable(timer);
+
+	timer->reserved = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL(spear_timer_free);
+
+/**
+ * spear_timer_get_irq - get the irq number associated
+ * @timer: return the irq number for this timer
+ *
+ * The application may require the irq associated with a timer to register it
+ * with the OS interrupt framework.
+ */
+int spear_timer_get_irq(struct spear_timer *timer)
+{
+	return (timer) ? timer->irq : -ENODEV;
+}
+EXPORT_SYMBOL(spear_timer_get_irq);
+
+/**
+ * spear_timer_get_fclk - return the functional clock
+ * @timer: timer for which fclk is required
+ *
+ * Returns the functional clock of the timer at which it is operating.
+ * Functional clock represents the actual clock at which the timer is
+ * operating. The count period depends on this clock
+ */
+struct clk *spear_timer_get_fclk(struct spear_timer *timer)
+{
+	if (!timer)
+		return NULL;
+
+	return timer->fclk;
+}
+EXPORT_SYMBOL(spear_timer_get_fclk);
+
+/**
+ * spear_timer_start - start the timer operation
+ * @timer: timer to start
+ *
+ * The timer shall start operating only after calling this API
+ */
+int spear_timer_start(struct spear_timer *timer)
+{
+	u16 val;
+
+	if (!timer)
+		return -ENODEV;
+
+	val = spear_timer_read_reg(timer, GPT_CTRL_OFF);
+	if (!(val & GPT_CTRL_ENABLE)) {
+		val |= GPT_CTRL_ENABLE;
+		spear_timer_write_reg(timer, GPT_CTRL_OFF, val);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(spear_timer_start);
+
+/**
+ * spear_timer_stop - stop the timer operation
+ * @timer: timer to stop
+ *
+ * This API can be used to stop the timer operation
+ */
+int spear_timer_stop(struct spear_timer *timer)
+{
+	u16 val;
+
+	if (!timer)
+		return -ENODEV;
+
+	val = spear_timer_read_reg(timer, GPT_CTRL_OFF);
+	if (val & GPT_CTRL_ENABLE) {
+		val &= ~GPT_CTRL_ENABLE;
+		spear_timer_write_reg(timer, GPT_CTRL_OFF, val);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(spear_timer_stop);
+
+/**
+ * spear_timer_set_source - select the proper source clock
+ * @timer: timer
+ * @source: the clock cource
+ *
+ * source specifies the clock which has to be selected as the functional clock
+ * of timer. The available choice are 48 MHz (PLL3) output or AHB clock.
+ *
+ */
+int spear_timer_set_source(struct spear_timer *timer, int source)
+{
+	if (source < 0 || source >= 3)
+		return -EINVAL;
+
+	if (!timer)
+		return -ENODEV;
+
+	clk_disable(timer->fclk);
+	clk_set_parent(timer->fclk, spear_source_clocks[source]);
+	clk_enable(timer->fclk);
+	return 0;
+}
+EXPORT_SYMBOL(spear_timer_set_source);
+
+/**
+ * spear_timer_set_load - program the count value of timer
+ * @timer: timer
+ * @autoreload: boolean, whether the count will be reloaded
+ * @load: the actual count deciding the time period
+ *
+ * The timer will be programmed as per the value in load. The time period will
+ * depend on the clock and prescaler selected.
+ */
+int spear_timer_set_load(struct spear_timer *timer, int autoreload,
+		u16 load)
+{
+	u16 val;
+
+	if (!timer)
+		return -ENODEV;
+
+	val = spear_timer_read_reg(timer, GPT_CTRL_OFF);
+	if (autoreload)
+		val &= ~GPT_CTRL_MODE_AR;
+	else
+		val |= GPT_CTRL_MODE_AR;
+
+	spear_timer_write_reg(timer, GPT_LOAD_OFF, load);
+	spear_timer_write_reg(timer, GPT_CTRL_OFF, val);
+
+	return 0;
+}
+EXPORT_SYMBOL(spear_timer_set_load);
+
+/**
+ * spear_timer_set_load_start - program the count value of timer and start
+ * @timer: timer
+ * @autoreload: boolean, whether the count will be reloaded
+ * @load: the actual count deciding the time period
+ *
+ * The timer will be programmed as per the value in load and the operation will
+ * be started.
+ */
+int spear_timer_set_load_start(struct spear_timer *timer, int autoreload,
+		u16 load)
+{
+	u16 val;
+
+	if (!timer)
+		return -ENODEV;
+
+	val = spear_timer_read_reg(timer, GPT_CTRL_OFF);
+	if (autoreload)
+		val &= ~GPT_CTRL_MODE_AR;
+	else
+		val |= GPT_CTRL_MODE_AR;
+
+	val |= GPT_CTRL_ENABLE;
+
+	spear_timer_write_reg(timer, GPT_LOAD_OFF, load);
+	spear_timer_write_reg(timer, GPT_CTRL_OFF, val);
+
+	return 0;
+}
+EXPORT_SYMBOL(spear_timer_set_load_start);
+
+/**
+ * spear_timer_match_irq - enable the match interrupt
+ * @timer: timer
+ * @enable: boolean, 1 for enable
+ *
+ * If application wants to enable the interrupt on count match then this API
+ * should be called
+ */
+int spear_timer_match_irq(struct spear_timer *timer, int enable)
+{
+	u16 val;
+
+	if (!timer)
+		return -ENODEV;
+
+	val = spear_timer_read_reg(timer, GPT_CTRL_OFF);
+	if (enable)
+		val |= GPT_CTRL_MATCH_INT;
+	else
+		val &= ~GPT_CTRL_MATCH_INT;
+	spear_timer_write_reg(timer, GPT_CTRL_OFF, val);
+
+	return 0;
+}
+EXPORT_SYMBOL(spear_timer_match_irq);
+
+/**
+ * spear_timer_set_prescaler - set the prescaler for the timer
+ * @timer: timer
+ * @prescaler: the division factor to be applied on the src clk
+ *
+ * This API can be used to program the prescaler for the timer. Its value can
+ * be from 1 to 8 signifying division by 2^prescaler
+ */
+int spear_timer_set_prescaler(struct spear_timer *timer, int prescaler)
+{
+	u16 val;
+
+	if (!timer)
+		return -ENODEV;
+
+	val = spear_timer_read_reg(timer, GPT_CTRL_OFF);
+	if (prescaler >= 0x00 && prescaler <= 0x08) {
+		val &= 0xFFF0;
+		val |= prescaler;
+	} else {
+		printk(KERN_ERR "Invalid prescaler\n");
+	}
+
+	timer->prescaler = val & 0xF;
+	spear_timer_write_reg(timer, GPT_CTRL_OFF, val);
+	return 0;
+}
+EXPORT_SYMBOL(spear_timer_set_prescaler);
+
+/**
+ * spear_timer_read_status - read the interrupt status
+ * @timer: timer
+ *
+ * This API can be used to read the interrupt status of timer. Currently only
+ * match interrupt, at offset 0, is part of this.
+ */
+int spear_timer_read_status(struct spear_timer *timer)
+{
+	u16 val;
+
+	if (!timer)
+		return -ENODEV;
+
+	val = spear_timer_read_reg(timer, GPT_INT_OFF);
+
+	return val;
+}
+EXPORT_SYMBOL(spear_timer_read_status);
+
+/**
+ * spear_timer_clear_status - write to the interrupt status reg to clear
+ * @timer: timer
+ * @value: value to be written
+ *
+ * The API can be used to clear the match interrupt status by writing a value
+ * 0.
+ */
+int spear_timer_clear_status(struct spear_timer *timer, u16 value)
+{
+	if (!timer)
+		return -ENODEV;
+
+	spear_timer_write_reg(timer, GPT_INT_OFF, value);
+	return 0;
+}
+EXPORT_SYMBOL(spear_timer_clear_status);
+
+/**
+ * spear_timer_read_counter - get the current count value
+ * @timer: timer
+ *
+ * The API returns the current count value of the timer. One has to remember
+ * that if the timer is operating on asynchronous clock source then there is a
+ * probability that the application may get some junk count value. This is due
+ * to the fact that the count register is being accessed by two independent
+ * clock, one driving the timer (48MHz) and the other on which this register is
+ * read (system AHB clock). For more details refer GPT Application note.
+ */
+int spear_timer_read_counter(struct spear_timer *timer)
+{
+	u16 val;
+
+	if (!timer)
+		return -ENODEV;
+
+	val = spear_timer_read_reg(timer, GPT_COUNT_OFF);
+
+	return val;
+}
+EXPORT_SYMBOL(spear_timer_read_counter);
+
+/**
+ * spear_timer_active - is timer active
+ * @timer: timer
+ *
+ * This API can be used to find whether a timer is already enabled and is
+ * active i.e. it is under operation
+ */
+int spear_timer_active(struct spear_timer *timer)
+{
+	if (!timer)
+		return 0;
+
+	if (!timer->enabled)
+		return 0;
+
+	if (spear_timer_read_reg(timer, GPT_CTRL_OFF) & GPT_CTRL_ENABLE)
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(spear_timer_active);
+
+/**
+ * spear_timer_init - initialize the set of timers
+ * @timer: list of timers to be intialized
+ * @count: number of timers supported in platform
+ *
+ * This API must not be called by user and it is called only once by the
+ * platform specific intialization code.
+ */
+int __init spear_timer_init(struct spear_timer *timers, int count)
+{
+	struct spear_timer *timer;
+	int i;
+	int mtu; /* timer unit */
+	char dev_id[16];
+
+	spin_lock_init(&spear_timer_lock);
+
+	spear_timers = timers;
+	spear_timer_count = count;
+
+	for (i = 0; src_clk_con_id[i] != NULL; i++)
+		spear_source_clocks[i] = clk_get(NULL, src_clk_con_id[i]);
+
+	for (i = 0; i < spear_timer_count; i++) {
+		timer = &spear_timers[i];
+		timer->io_base = (void __iomem *)ioremap(timer->phys_base,
+				SZ_1K);
+		if (!timer->io_base) {
+			printk(KERN_ERR "BUG:ioremap failed for timer:%d\n", i);
+			continue;
+		}
+
+		/* each mtu has 2 timers with same set of clocks */
+		mtu = i >> 1;
+
+		sprintf(dev_id, "gpt%d", mtu);
+		timer->fclk = clk_get_sys(dev_id, NULL);
+	}
+
+	return 0;
+}
diff --git a/arch/arm/plat-spear/time.c b/arch/arm/plat-spear/time.c
new file mode 100644
index 0000000..d89ac17
--- /dev/null
+++ b/arch/arm/plat-spear/time.c
@@ -0,0 +1,197 @@
+/*
+ * arch/arm/plat-spear/time.c
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Shiraz Hashim<shiraz.hashim@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/time.h>
+#include <linux/irq.h>
+#include <asm/mach/time.h>
+#include <mach/irqs.h>
+#include <mach/hardware.h>
+#include <mach/spear.h>
+#include <mach/generic.h>
+#include <plat/gpt.h>
+
+static void clockevent_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *clk_event_dev);
+static int clockevent_next_event(unsigned long evt,
+				 struct clock_event_device *clk_event_dev);
+
+/*
+ * Timer0 and Timer1 both belong to same mtu in cpu subbsystem. Further they
+ * share same functional clock. Any change in one's functional clock will also
+ * affect other timer.
+ */
+static struct spear_timer *spear_timer_clkevt;
+static struct spear_timer *spear_timer_clksrc;
+
+/*
+ * Clock Source
+ */
+static cycle_t clocksource_read_cycles(struct clocksource *cs)
+{
+	return (cycle_t) spear_timer_read_counter(spear_timer_clksrc);
+}
+
+static struct clocksource clksrc = {
+	.name = "clock source",
+	.rating = 200,		/* its a pretty decent clock */
+	.read = clocksource_read_cycles,
+	.mask = 0xFFFF,		/* 16 bits */
+	.mult = 0,		/* to be computed */
+	.shift = 10,
+	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static void spear_clocksource_init(void)
+{
+	static struct spear_timer *timer;
+	u32 tick_rate;
+
+	timer = spear_timer_request_specific(1);
+	BUG_ON(timer == NULL);
+	spear_timer_clksrc = timer;
+
+	spear_timer_set_source(timer, SPEAR_TIMER_SRC_PLL3_CLK);
+	spear_timer_set_prescaler(timer, GPT_CTRL_PRESCALER256);
+
+	/* find out actual clock driving Timer */
+	tick_rate = clk_get_rate(spear_timer_get_fclk(timer));
+	tick_rate >>= timer->prescaler;
+
+	spear_timer_set_load_start(timer, 1, 0xFFFF); /* 16 bit maximum */
+
+	clksrc.mult =
+		clocksource_khz2mult((tick_rate / 1000), clksrc.shift);
+
+	/* register the clocksource */
+	clocksource_register(&clksrc);
+}
+
+/*
+* Clock Event
+*/
+static struct clock_event_device clkevt = {
+	.name = "clock_event",
+	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode = clockevent_set_mode,
+	.set_next_event = clockevent_next_event,
+	.shift = 20,
+};
+
+static void clockevent_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *clk_event_dev)
+{
+	u32 period;
+	struct spear_timer *timer = spear_timer_clkevt;
+
+	if (timer)
+		return;
+
+	spear_timer_stop(timer);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		period = clk_get_rate(spear_timer_get_fclk(timer)) / HZ;
+		period >>= timer->prescaler;
+
+		spear_timer_match_irq(timer, 1);
+		spear_timer_set_load_start(timer, 1, period);
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		spear_timer_match_irq(timer, 1);
+		break;
+
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_RESUME:
+		break;
+
+	default:
+		printk(KERN_ERR "BUG: Invalid mode requested\n");
+		break;
+	}
+}
+
+static int clockevent_next_event(unsigned long cycles,
+				 struct clock_event_device *clk_event_dev)
+{
+	spear_timer_set_load_start(spear_timer_clkevt, 0, (u16) cycles);
+
+	return 0;
+}
+
+static irqreturn_t spear_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = &clkevt;
+	struct spear_timer *timer = (struct spear_timer *)dev_id;
+
+	spear_timer_clear_status(timer, GPT_STATUS_MATCH);
+
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction spear_timer_irq = {
+	.name = "gp_timer",
+	.flags = IRQF_DISABLED | IRQF_TIMER,
+	.handler = spear_timer_interrupt
+};
+
+static void __init spear_clockevent_init(void)
+{
+	struct spear_timer *timer;
+	u32 tick_rate;
+
+	timer = spear_timer_request_specific(0);
+	BUG_ON(timer == NULL);
+	spear_timer_clkevt = timer;
+
+	spear_timer_set_source(timer, SPEAR_TIMER_SRC_PLL3_CLK);
+	spear_timer_set_prescaler(timer, GPT_CTRL_PRESCALER16);
+
+	tick_rate = clk_get_rate(spear_timer_get_fclk(timer));
+	tick_rate >>= timer->prescaler;
+
+	clkevt.mult = div_sc(tick_rate, NSEC_PER_SEC,
+					clkevt.shift);
+	clkevt.max_delta_ns = clockevent_delta2ns(0xfff0,
+			&clkevt);
+	clkevt.min_delta_ns = clockevent_delta2ns(3, &clkevt);
+
+	clkevt.cpumask = cpumask_of(0);
+	clockevents_register_device(&clkevt);
+
+	spear_timer_irq.dev_id = (void *)timer;
+
+	setup_irq(spear_timer_get_irq(timer), &spear_timer_irq);
+	spear_timer_match_irq(timer, 1);
+}
+
+void __init spear_setup_timer(void)
+{
+	/* Initialize all General Purpose Timers */
+	spear_gpt_init();
+
+	spear_clockevent_init();
+	spear_clocksource_init();
+}
+
+struct sys_timer spear_sys_timer = {
+	.init = spear_setup_timer,
+};
-- 
1.6.0.2

