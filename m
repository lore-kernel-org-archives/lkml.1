Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbZCTLsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbZCTLsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZCTLsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:48:05 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:41738 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751838AbZCTLsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:48:02 -0400
From: monstr@monstr.eu
To: tglx@linutronix.de
Cc: michal.simek@petalogix.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, john.williams@petalogix.com,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 1/1] Update timer.c code
Date: Fri, 20 Mar 2009 12:47:42 +0100
Message-Id: <1237549662-18795-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Here is update of timer.c code.
This patch is only generate for checking purpose.
This code will be available at git server too.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/timer.c |  261 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 261 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/timer.c

diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
new file mode 100644
index 0000000..a0d597c
--- /dev/null
+++ b/arch/microblaze/kernel/timer.c
@@ -0,0 +1,261 @@
+/*
+ * Copyright (C) 2007-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/interrupt.h>
+#include <linux/profile.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/io.h>
+#include <asm/cpuinfo.h>
+#include <asm/setup.h>
+#include <asm/prom.h>
+#include <asm/irq.h>
+#include <asm/system.h>
+
+#ifdef CONFIG_SELFMOD_TIMER
+#include <asm/selfmod.h>
+#define TIMER_BASE	BARRIER_BASE_ADDR
+#else
+static unsigned int timer_baseaddr;
+#define TIMER_BASE	timer_baseaddr
+#endif
+
+#define TCSR0	(0x00)
+#define TLR0	(0x04)
+#define TCR0	(0x08)
+#define TCSR1	(0x10)
+#define TLR1	(0x14)
+#define TCR1	(0x18)
+
+#define TCSR_MDT	(1<<0)
+#define TCSR_UDT	(1<<1)
+#define TCSR_GENT	(1<<2)
+#define TCSR_CAPT	(1<<3)
+#define TCSR_ARHT	(1<<4)
+#define TCSR_LOAD	(1<<5)
+#define TCSR_ENIT	(1<<6)
+#define TCSR_ENT	(1<<7)
+#define TCSR_TINT	(1<<8)
+#define TCSR_PWMA	(1<<9)
+#define TCSR_ENALL	(1<<10)
+
+static inline void microblaze_timer0_stop(void)
+{
+	out_be32(TIMER_BASE + TCSR0, in_be32(TIMER_BASE + TCSR0) & ~TCSR_ENT);
+}
+
+static inline void microblaze_timer0_start_periodic(unsigned long load_val)
+{
+	if (!load_val)
+		load_val = 1;
+	out_be32(TIMER_BASE + TLR0, load_val); /* loading value to timer reg */
+
+	/* load the initial value */
+	out_be32(TIMER_BASE + TCSR0, TCSR_LOAD);
+
+	/* see timer data sheet for detail
+	 * !ENALL - don't enable 'em all
+	 * !PWMA - disable pwm
+	 * TINT - clear interrupt status
+	 * ENT- enable timer itself
+	 * EINT - enable interrupt
+	 * !LOAD - clear the bit to let go
+	 * ARHT - auto reload
+	 * !CAPT - no external trigger
+	 * !GENT - no external signal
+	 * UDT - set the timer as down counter
+	 * !MDT0 - generate mode
+	 */
+	out_be32(TIMER_BASE + TCSR0,
+			TCSR_TINT|TCSR_ENIT|TCSR_ENT|TCSR_ARHT|TCSR_UDT);
+}
+
+static inline void microblaze_timer0_start_oneshot(unsigned long load_val)
+{
+	if (!load_val)
+		load_val = 1;
+	out_be32(TIMER_BASE + TLR0, load_val); /* loading value to timer reg */
+
+	/* load the initial value */
+	out_be32(TIMER_BASE + TCSR0, TCSR_LOAD);
+
+	out_be32(TIMER_BASE + TCSR0,
+			TCSR_TINT|TCSR_ENIT|TCSR_ENT|TCSR_ARHT|TCSR_UDT);
+}
+
+static int microblaze_timer_set_next_event(unsigned long delta,
+					struct clock_event_device *dev)
+{
+	pr_debug("%s: next event, delta %x\n", __func__, (u32)delta);
+	microblaze_timer0_start_oneshot(delta);
+	return 0;
+}
+
+static void microblaze_timer_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		printk(KERN_INFO "%s: periodic\n", __func__);
+		microblaze_timer0_start_periodic(cpuinfo.freq_div_hz);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		printk(KERN_INFO "%s: oneshot\n", __func__);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+		printk(KERN_INFO "%s: unused\n", __func__);
+		break;
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		printk(KERN_INFO "%s: shutdown\n", __func__);
+		microblaze_timer0_stop();
+		break;
+	case CLOCK_EVT_MODE_RESUME:
+		printk(KERN_INFO "%s: resume\n", __func__);
+		break;
+	}
+}
+
+static struct clock_event_device clockevent_microblaze_timer = {
+	.name		= "microblaze_clockevent",
+	.features       = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
+	.shift		= 32,
+	.rating		= 400,
+	.set_next_event	= microblaze_timer_set_next_event,
+	.set_mode	= microblaze_timer_set_mode,
+};
+
+static inline void timer_ack(void)
+{
+	out_be32(TIMER_BASE + TCSR0, in_be32(TIMER_BASE + TCSR0));
+}
+
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = &clockevent_microblaze_timer;
+#ifdef CONFIG_HEART_BEAT
+	heartbeat();
+#endif
+	timer_ack();
+	evt->event_handler(evt);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction timer_irqaction = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED | IRQF_TIMER,
+	.name = "timer",
+	.dev_id = &clockevent_microblaze_timer,
+};
+
+static __init void microblaze_clockevent_init(void)
+{
+	clockevent_microblaze_timer.mult =
+		div_sc(cpuinfo.cpu_clock_freq, NSEC_PER_SEC,
+				clockevent_microblaze_timer.shift);
+	clockevent_microblaze_timer.max_delta_ns =
+		clockevent_delta2ns((u32)~0, &clockevent_microblaze_timer);
+	clockevent_microblaze_timer.min_delta_ns =
+		clockevent_delta2ns(1, &clockevent_microblaze_timer);
+	clockevent_microblaze_timer.cpumask = cpumask_of(0);
+	clockevents_register_device(&clockevent_microblaze_timer);
+}
+
+static cycle_t microblaze_read(void)
+{
+	/* reading actual value of timer 1 */
+	return (cycle_t) (in_be32(TIMER_BASE + TCR1));
+}
+
+static struct clocksource clocksource_microblaze = {
+	.name		= "microblaze_clocksource",
+	.rating		= 400,
+	.read		= microblaze_read,
+	.mask		= CLOCKSOURCE_MASK(32),
+	.shift		= 0, /* I can shift it */
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static int __init microblaze_clocksource_init(void)
+{
+	clocksource_microblaze.mult =
+			clocksource_hz2mult(cpuinfo.cpu_clock_freq,
+						clocksource_microblaze.shift);
+	if (clocksource_register(&clocksource_microblaze))
+		panic("failed to register clocksource");
+
+	/* stop timer1 */
+	out_be32(TIMER_BASE + TCSR1, in_be32(TIMER_BASE + TCSR1) & ~TCSR_ENT);
+	/* start timer1 - up counting without interrupt */
+	out_be32(TIMER_BASE + TCSR1, TCSR_TINT|TCSR_ENT|TCSR_ARHT);
+	return 0;
+}
+
+void __init time_init(void)
+{
+	u32 irq, i = 0;
+	u32 timer_num = 1;
+	struct device_node *timer = NULL;
+#ifdef CONFIG_SELFMOD_TIMER
+	unsigned int timer_baseaddr = 0;
+	int arr_func[] = {
+				(int)&microblaze_read,
+				(int)&timer_interrupt,
+				(int)&microblaze_timer_set_mode,
+				(int)&microblaze_timer_set_next_event,
+				0
+			};
+#endif
+	char *timer_list[] = {
+				"xlnx,xps-timer-1.00.a",
+				"xlnx,opb-timer-1.00.b",
+				"xlnx,opb-timer-1.00.a",
+				NULL
+			};
+
+	for (i = 0; timer_list[i] != NULL; i++) {
+		timer = of_find_compatible_node(NULL, NULL, timer_list[i]);
+		if (timer)
+			break;
+	}
+
+	timer_baseaddr = *(int *) of_get_property(timer, "reg", NULL);
+	timer_baseaddr = (unsigned long) ioremap(timer_baseaddr, PAGE_SIZE);
+	irq = *(int *) of_get_property(timer, "interrupts", NULL);
+	timer_num =
+		*(int *) of_get_property(timer, "xlnx,one-timer-only", NULL);
+	if (timer_num) {
+		printk(KERN_EMERG "Please enable two timers in HW\n");
+		BUG();
+	}
+
+#ifdef CONFIG_SELFMOD_TIMER
+	selfmod_function((int *) arr_func, timer_baseaddr);
+#endif
+	printk(KERN_INFO "%s #0 at 0x%08x, irq=%d\n",
+		timer_list[i], timer_baseaddr, irq);
+
+	cpuinfo.freq_div_hz = cpuinfo.cpu_clock_freq / HZ;
+
+	setup_irq(irq, &timer_irqaction);
+#ifdef CONFIG_HEART_BEAT
+	setup_heartbeat();
+#endif
+	microblaze_clocksource_init();
+	microblaze_clockevent_init();
+}
+
-- 
1.5.5.1

