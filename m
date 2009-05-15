Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbZEOWXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbZEOWXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 18:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbZEOWXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 18:23:11 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:49728 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZEOWXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 18:23:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jDPe8CRTsGbMSPYFFTLvctkZYVCLKg3I6dzFXKn+YFDI1VBErjsBifC9QafEVvQyfp
         xqIA23wA7iQbmmsMgMCjIvxOG5LD90Y5k10kfysY8/MYpSKzzr1cQmomW5dQ46c8DVvk
         pxOEvgnwAheEouQTteAiebOzXt+H1qkWzou2w=
Subject: [PATCH 23/30] loongson: CS5536 MFGPT as system clock source support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org
Cc: Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com,
       zhangfx@lemote.com, yanh@lemote.com,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Erwan Lerale <erwan@thiscow.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Sat, 16 May 2009 06:23:02 +0800
Message-Id: <1242426182.10164.168.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a3524f6a9c412e6e814277b2dfea6f136a0c3fef Mon Sep 17 00:00:00 2001
From: Wu Zhangjin <wuzhangjin@gmail.com>
Date: Sat, 16 May 2009 04:43:36 +0800
Subject: [PATCH 23/30] loongson: CS5536 MFGPT as system clock source
support

The cpu count timer should not be used if oprofile and cpufreq are to be
supported. Instead the CS5536's mfgpt is a proper timer alternative
---
 arch/mips/loongson/Kconfig         |   19 ++-
 arch/mips/loongson/common/Makefile |    5 +
 arch/mips/loongson/common/mfgpt.c  |  259
++++++++++++++++++++++++++++++++++++
 arch/mips/loongson/common/time.c   |    6 +
 4 files changed, 283 insertions(+), 6 deletions(-)
 create mode 100644 arch/mips/loongson/common/mfgpt.c

diff --git a/arch/mips/loongson/Kconfig b/arch/mips/loongson/Kconfig
index 49cb375..572054c 100644
--- a/arch/mips/loongson/Kconfig
+++ b/arch/mips/loongson/Kconfig
@@ -5,8 +5,8 @@ choice
 config LEMOTE_FULOONG2E
 	bool "Lemote Fuloong(2e) mini-PC"
 	select ARCH_SPARSEMEM_ENABLE
-	select CEVT_R4K
-	select CSRC_R4K
+	select CEVT_R4K if !CS5536_MFGPT
+	select CSRC_R4K if !CS5536_MFGPT
 	select SYS_HAS_CPU_LOONGSON2E
 	select DMA_NONCOHERENT
 	select BOOT_ELF32
@@ -32,8 +32,8 @@ config LEMOTE_FULOONG2E
 config LEMOTE_FULOONG2F
 	bool "Lemote Fuloong(2f) mini-PC"
 	select ARCH_SPARSEMEM_ENABLE
-	select CEVT_R4K
-	select CSRC_R4K
+	select CEVT_R4K if !CS5536_MFGPT
+	select CSRC_R4K if !CS5536_MFGPT
 	select SYS_HAS_CPU_LOONGSON2F
 	select DMA_NONCOHERENT
 	select BOOT_ELF32
@@ -62,8 +62,8 @@ config LEMOTE_FULOONG2F
 config LEMOTE_YEELOONG2F
 	bool "Lemote Yeeloong(2f) mini Notebook"
 	select ARCH_SPARSEMEM_ENABLE
-	select CEVT_R4K
-	select CSRC_R4K
+	select CEVT_R4K if !CS5536_MFGPT
+	select CSRC_R4K if !CS5536_MFGPT
 	select SYS_HAS_CPU_LOONGSON2F
 	select DMA_NONCOHERENT
 	select BOOT_ELF32
@@ -100,6 +100,13 @@ config CS5536
 config SYS_HAS_MACH_PROM_INIT_CMDLINE
 	bool
 
+config CS5536_MFGPT
+ 	bool "Using cs5536's MFGPT as system clock"
+ 	depends on CS5536
+ 	help
+ 	  This is needed if cpufreq and oprofile should be enabled in
+ 	  Loongson2(F) machines
+
 config UCA_SIZE
  	hex "Uncache Accelerated Region size"
  	depends on LOONGSON2F 
diff --git a/arch/mips/loongson/common/Makefile
b/arch/mips/loongson/common/Makefile
index 91ba177..c95629c 100644
--- a/arch/mips/loongson/common/Makefile
+++ b/arch/mips/loongson/common/Makefile
@@ -24,6 +24,11 @@ obj-$(CONFIG_RTC_DRV_CMOS) += rtc.o
 obj-$(CONFIG_CS5536) += cs5536_vsm.o
 
 #
+# Enable cs5536 mfgpt Timer
+#
+obj-$(CONFIG_CS5536_MFGPT) += mfgpt.o
+
+#
 # Enable serial port
 #
 obj-$(CONFIG_SERIAL_8250) += serial.o
diff --git a/arch/mips/loongson/common/mfgpt.c
b/arch/mips/loongson/common/mfgpt.c
new file mode 100644
index 0000000..8af6061
--- /dev/null
+++ b/arch/mips/loongson/common/mfgpt.c
@@ -0,0 +1,259 @@
+/*
+ * CS5536 General timer functions
+ *
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Yanhua, yanh@lemote.com
+ *
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu zhangjin, wuzj@lemote.com
+ *
+ * Reference: 'AMD Geode(TM) CS5536 Companion Device Data Book'
+ *
+ *  This program is free software; you can redistribute  it and/or
modify it
+ *  under  the terms of  the GNU General  Public License as published
by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at
your
+ *  option) any later version.
+ */
+#include <linux/clockchips.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+
+#include <asm/delay.h>
+#include <asm/io.h>
+#include <asm/time.h>
+
+#include <cs5536/mfgpt.h>
+
+DEFINE_SPINLOCK(mfgpt_lock);
+EXPORT_SYMBOL(mfgpt_lock);
+
+#if 1
+#define MFGPT_TICK_RATE 14318000
+#else
+#define MFGPT_TICK_RATE (14318180 / 8)
+#endif
+#define COMPARE  ((MFGPT_TICK_RATE + HZ/2) / HZ)
+
+static u32 MFGPT_BASE;
+
+/*
+ * Initialize the MFGPT timer.
+ *
+ * This is also called after resume to bring the MFGPT into operation
again.
+ */
+/* setup register bit fields:
+   15: counter enable
+   14: compare2 output status, write 1 to clear when in event mode
+   13: compare1 output status
+   12: setup(ro)
+   11: stop enable, stop on sleep
+   10: external enable
+   9:8 compare2 mode; 00: disable, 01: compare on equal; 10: compare on
GE, 11 event: GE + irq
+   7:6 compare1 mode
+   5:  reverse enable, bit reverse of the counter
+   4:  clock select. 0: 32KHz, 1: 14.318MHz
+   3:0 counter prescaler scale factor. select the input clock divide-by
value. 2^n
+   bit 11:0 is write once.
+*/
+
+static void init_mfgpt_timer(enum clock_event_mode mode,
+			     struct clock_event_device *evt)
+{
+	spin_lock(&mfgpt_lock);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		outw(COMPARE, MFGPT0_CMP2);	/* set comparator2 */
+		outw(0, MFGPT0_CNT);	/* set counter to 0 */
+		/* enable counter, comparator2 to event mode, 14.318MHz clock */
+		outw(0xe310, MFGPT0_SETUP);
+		break;
+
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+		if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
+		    evt->mode == CLOCK_EVT_MODE_ONESHOT) {
+			/* disable counter */
+			outw(inw(MFGPT0_SETUP) & 0x7fff, MFGPT0_SETUP);
+		}
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* One shot setup */
+		outw(0xe300, MFGPT0_SETUP);
+		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
+		break;
+	}
+	spin_unlock(&mfgpt_lock);
+}
+
+/*
+ * Program the next event in oneshot mode
+ *
+ * Delta is given in MFGPT ticks
+ */
+static int mfgpt_next_event(unsigned long delta, struct
clock_event_device *evt)
+{
+	spin_lock(&mfgpt_lock);
+	outw(delta & 0xffff, MFGPT0_CMP2);	/* set comparator2 */
+	outw(0, MFGPT0_CNT);	/* set counter to 0 */
+	spin_unlock(&mfgpt_lock);
+
+	return 0;
+}
+
+static struct clock_event_device mfgpt_clockevent = {
+	.name = "mfgpt",
+	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_MODE_ONESHOT,
+	.set_mode = init_mfgpt_timer,
+	.set_next_event = mfgpt_next_event,
+	.rating = 2000,
+	.irq = 5,
+};
+
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	u32 basehi;
+
+	/* 
+	 * get MFGPT base address
+	 *
+	 * NOTE: do not remove me, it's need for the value of mfgpt_base is
variable
+	 */
+	_rdmsr(CS5536_DIVIL_MSR_BASE + DIVIL_LBAR_MFGPT, &basehi,
&mfgpt_base);
+
+	/* ack */
+	outw(inw(MFGPT0_SETUP) | 0x4000, MFGPT0_SETUP);
+
+	mfgpt_clockevent.event_handler(&mfgpt_clockevent);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction irq5 = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
+	.mask = CPU_MASK_NONE,
+	.name = "timer"
+};
+
+/*
+ * Initialize the conversion factor and the min/max deltas of the clock
event
+ * structure and register the clock event source with the framework.
+ */
+void __init setup_mfgpt_timer(void)
+{
+	u32 basehi;
+	struct clock_event_device *cd = &mfgpt_clockevent;
+	unsigned int cpu = smp_processor_id();
+
+	cd->cpumask = cpumask_of(cpu);
+	clockevent_set_clock(cd, MFGPT_TICK_RATE);
+	cd->max_delta_ns = clockevent_delta2ns(0xffff, cd);
+	cd->min_delta_ns = clockevent_delta2ns(0xf, cd);
+
+	/* Enable MFGPT0 Comparator 2 Output to the Interrupt Mapper */
+	_wrmsr(CS5536_DIVIL_MSR_BASE + MFGPT_IRQ, 0, 0x100);
+
+	/* Enable Interrupt Gate 5 */
+	_wrmsr(CS5536_DIVIL_MSR_BASE + PIC_ZSEL_LOW, 0, 0x50000);
+
+	/* get MFGPT base address */
+	_rdmsr(CS5536_DIVIL_MSR_BASE + DIVIL_LBAR_MFGPT, &basehi,
&mfgpt_base);
+
+	irq5.mask = cpumask_of_cpu(cpu);
+
+	clockevents_register_device(cd);
+
+	setup_irq(5, &irq5);
+}
+
+/*
+ * Since the MFGPT overflows every tick, its not very useful
+ * to just read by itself. So use jiffies to emulate a free
+ * running counter:
+ */
+static cycle_t mfgpt_read(void)
+{
+	unsigned long flags;
+	int count;
+	u32 jifs;
+	static int old_count;
+	static u32 old_jifs;
+
+	spin_lock_irqsave(&mfgpt_lock, flags);
+	/*
+	 * Although our caller may have the read side of xtime_lock,
+	 * this is now a seqlock, and we are cheating in this routine
+	 * by having side effects on state that we cannot undo if
+	 * there is a collision on the seqlock and our caller has to
+	 * retry.  (Namely, old_jifs and old_count.)  So we must treat
+	 * jiffies as volatile despite the lock.  We read jiffies
+	 * before latching the timer count to guarantee that although
+	 * the jiffies value might be older than the count (that is,
+	 * the counter may underflow between the last point where
+	 * jiffies was incremented and the point where we latch the
+	 * count), it cannot be newer.
+	 */
+	jifs = jiffies;
+	outw(inw(MFGPT0_SETUP) | 0x0200, MFGPT0_SETUP);	/* latch the counter
*/
+	count = inw(MFGPT0_CNT);			/* read the latched count */
+	outw(inw(MFGPT0_SETUP) & 0xfdff, MFGPT0_SETUP);	/* restart the counter
*/
+
+	/* reset the latch if count > max + 1 */
+	if (count > COMPARE) {
+		/* set comparator2 */
+		outw(COMPARE, MFGPT0_CMP2);
+		/* set counter to 0 */
+		outw(0, MFGPT0_CNT);
+		/* enable counter, comparator2 to event mode, 14.318MHz clock */
+		outw(0xe310, MFGPT0_SETUP);
+
+		count = COMPARE - 1;
+	}
+
+	/*
+	 * It's possible for count to appear to go the wrong way for this
reason:
+	 *
+	 *  The timer counter underflows, but we haven't handled the
+	 *  resulting interrupt and incremented jiffies yet.
+	 *
+	 * Previous attempts to handle these cases intelligently were
+	 * buggy, so we just do the simple thing now.
+	 */
+	if (count > old_count && jifs == old_jifs) {
+		count = old_count;
+	}
+	old_count = count;
+	old_jifs = jifs;
+
+	spin_unlock_irqrestore(&mfgpt_lock, flags);
+
+	return (cycle_t) (jifs * COMPARE) + count;
+}
+
+static struct clocksource clocksource_mfgpt = {
+	.name = "mfgpt",
+	.rating = 1200,
+	.read = mfgpt_read,
+	.mask = CLOCKSOURCE_MASK(32),
+	.mult = 0,
+	.shift = 22,
+};
+
+int __init init_mfgpt_clocksource(void)
+{
+	if (num_possible_cpus() > 1)	/* MFGPT does not scale! */
+		return 0;
+
+	clocksource_mfgpt.mult = clocksource_hz2mult(MFGPT_TICK_RATE, 22);
+	return clocksource_register(&clocksource_mfgpt);
+}
+
+arch_initcall(init_mfgpt_clocksource);
diff --git a/arch/mips/loongson/common/time.c
b/arch/mips/loongson/common/time.c
index 8c916ff..148761b 100644
--- a/arch/mips/loongson/common/time.c
+++ b/arch/mips/loongson/common/time.c
@@ -20,8 +20,14 @@ unsigned long read_persistent_clock(void)
 
 extern unsigned long cpu_clock_freq;
 
+extern void setup_mfgpt_timer(void);
+
 void __init plat_time_init(void)
 {
 	/* setup mips r4k timer */
 	mips_hpt_frequency = cpu_clock_freq / 2;
+
+#ifdef CONFIG_CS5536_MFGPT
+ 	setup_mfgpt_timer();
+#endif
 }
-- 
1.6.2.1



