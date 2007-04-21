Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbXDUXAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbXDUXAN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 19:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXDUXAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 19:00:13 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:35814 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753661AbXDUXAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 19:00:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=a9QWctHfIk4UjkhLUgF5V/8pj/IFqlTpcCyQyu4VXOFJqZGUXPrqAG8EsKr3Lyk6muGLlRJbRxDuzSS6wV8yr8sC3IclxgaX3ts/lwyAJVST2vHM3S9ho8Ra44vg3aelS0dzKNt4ahWxuenXN/2LJkSRsoN5BCOW9LVG3ImSRRk=  ;
X-YMail-OSG: g_.JKVgVM1kvum9lSsMoF2PBGD3VDLfUSkzKfipEBnb8XQiO9oqGaY3UsOAG51l2eouMBRvO2w--
From: David Brownell <david-b@pacbell.net>
To: linux@bohmer.net
Subject: Re: gtod/clocksource/clockevents documentation
Date: Sat, 21 Apr 2007 16:00:02 -0700
User-Agent: KMail/1.9.6
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <3efb10970704211414q7c66c154m79cc06db61eb76be@mail.gmail.com>
In-Reply-To: <3efb10970704211414q7c66c154m79cc06db61eb76be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704211600.02278.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2007, Remy Bohmer wrote:
> Hello All,
> 
> I need to implement a gtod/clocksource/clockevents implementation for
> the Atmel ARM AT91SAM9261 CPU, and I am looking for some kernel
> (interface) documentation about these mechanisms.
> 
> I already investigated the 'examples'/implementations of other
> architectures in the kernel, but that did not really help me... I also
> looked at the patch for the AT91RM9200 CPU posted by David Brownell...

You know, I started that partly because I couldn't find enough
info to satisfy my curiousity about how the "new dyntick" was
expected to work ... ;)


> I hacked something which now makes the RT kernel to boot, but the
> time-of-day warps several minutes per second, back and forward in
> time... ;-)

Maybe you've got the scaling wrong on the clocksources?  The
concerns with the shift/mult stuff were particularly opaque;
some sanity checks might be worth adding, it's easy enough
to provide wrong values with exactly those failures mode, and
it's not immediately obvious what "good" values may be.


> So, Can anybody please give me pointer to some useful documentation
> and/or examples?

The best I found was www.kernel.org, current GIT trees.  There
were some old OLS papers too.

One thing I found lacking was the simple statement up front that
clocksources are just fixed-rate free running counters; and that
clockevents are just dual-mode (PIT or oneshot) timers.


> The reason behind this initiative is to make the RT-preempt patch
> compile and work on this architecture. Currently the GENERIC_TIME is
> not set, which results in several unresolved externals at compile
> time, and I believe the best way to fix this is to implement proper
> gtod/clocksource/clockevents to allow the enabling of GENERIC_TIME

Try the appended patch ... the clocksource should work for you,
giving GENERIC_TIME with maybe a bit of tweaking.

- Dave

=====================	CUT HERE
This defines a simple library to allocate at91 timer/counter blocks,
insulating drivers from CPU differences.  Making that work also implies
defining TC clocks for each processor, and handing a table of TC block
descriptors to that library.

It also defines a simple TC based clocksource.  Any available TC block
can be used as a higher precision clocksource than one based on the 32KHz
slow clock.  Its timebase is MCLK/8, usually 5-10 MHz.  The way it works
is to combine two 16-bit counters to get a 32-bit clocksource.

INCOMPLETE:
    (a)	The clocksource is currently not efficient for suspend/resume;
	it doesn't have suspend or resume methods to shut down the TC
	clocks it uses.

    (b)	AVR32 uses this same timer/counter block, albeit with different
	input clocks and prescalers ... the library to should work for
	those platforms too, but <linux/atmel_tc.h> has AT91-isms.

    (c) Recent versions of AVR32 code stopped using the architectural
	counter for the clocksource, and switched over to the TC block.
	Similar code should become fully sharable with at least the
	AT91sam926 chips.

Note that AT91rm9200 chips don't really have a need for this other than
the additional precision; their "system timer" module is more powerful
than the corresponding AT91sam926 logic, and can fully support the new
style dynamic tick framework.  (Although the timer IRQ path becomes so
long that DBGU consistently drops multiple character for things like
uparrow keys at 38400 baud...)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 arch/arm/mach-at91/Kconfig       |   16 ++
 arch/arm/mach-at91/Makefile      |    1 
 arch/arm/mach-at91/at91rm9200.c  |   36 ++++++
 arch/arm/mach-at91/at91sam9260.c |   36 ++++++
 arch/arm/mach-at91/at91sam9261.c |   27 ++++
 arch/arm/mach-at91/at91sam9263.c |   27 ++++
 arch/arm/mach-at91/generic.h     |    4 
 arch/arm/mach-at91/tclib.c       |  220 +++++++++++++++++++++++++++++++++++++++
 include/linux/atmel_tc.h         |  187 +++++++++++++++++++++++++++++++++
 9 files changed, 554 insertions(+)

--- at91.orig/arch/arm/mach-at91/Kconfig	2007-03-08 20:17:01.000000000 -0800
+++ at91/arch/arm/mach-at91/Kconfig	2007-03-11 21:58:10.000000000 -0700
@@ -171,6 +171,22 @@ config AT91_PROGRAMMABLE_CLOCKS
 	  Select this if you need to program one or more of the PCK0..PCK3
 	  programmable clock outputs.
 
+config ATMEL_TCLIB
+	bool "Timer/Counter Library"
+	help
+	  Select this if you want a library to allocate the Timer/Counter
+	  blocks found on many Atmel processors.  This facilitates using
+	  these modules despite processor differences.
+
+config AT91_TC_CLOCKSOURCE
+	bool "Timer/Counter Clocksource"
+	depends on ATMEL_TCLIB && ARCH_AT91
+	help
+	  Select this to get a higher precision clocksource, with a
+	  multi-MHz PLL as the base rather than a 32 Khz oscillator.
+	  This prevents other drivers from using that TC block (which
+	  is currently rare), and draws power for two of its channels.
+
 endmenu
 
 endif
--- at91.orig/arch/arm/mach-at91/Makefile	2007-03-08 19:50:34.000000000 -0800
+++ at91/arch/arm/mach-at91/Makefile	2007-03-08 20:17:01.000000000 -0800
@@ -8,6 +8,7 @@ obj-n		:=
 obj-		:=
 
 obj-$(CONFIG_PM)		+= pm.o
+obj-$(CONFIG_ATMEL_TCLIB)	+= tclib.o
 
 # CPU-specific support
 obj-$(CONFIG_ARCH_AT91RM9200)	+= at91rm9200.o at91rm9200_time.o at91rm9200_devices.o
--- at91.orig/arch/arm/mach-at91/generic.h	2007-03-08 19:50:34.000000000 -0800
+++ at91/arch/arm/mach-at91/generic.h	2007-03-11 21:58:09.000000000 -0700
@@ -26,6 +26,10 @@ struct sys_timer;
 extern struct sys_timer at91rm9200_timer;
 extern struct sys_timer at91sam926x_timer;
 
+/* Timer/Counter library */
+struct tc_block;
+extern void __init atmel_tc_init(struct tc_block *, unsigned n);
+
  /* Clocks */
 extern int __init at91_clock_init(unsigned long main_clock);
 struct device;
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ at91/arch/arm/mach-at91/tclib.c	2007-03-10 09:26:11.000000000 -0800
@@ -0,0 +1,220 @@
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/string.h>
+#include <linux/clk.h>
+#include <linux/ioport.h>
+#include <linux/atmel_tc.h>
+
+#include <asm/errno.h>
+#include <asm/hardware.h>
+#include <asm/io.h>
+
+#include "generic.h"
+
+
+/*
+ * This is a thin library to solve the problem of how to portably allocate
+ * one of the TC modules.  For simplicitly, it doesn't currently expect to
+ * share individual timers between different drivers.
+ *
+ * And at the end of this file there's an optional clocksource.  That may be
+ * of interest in cases where more precision is needed, or with sam92xx chips
+ * where no better timer is available.
+ */
+
+static struct tc_block *blocks;
+static unsigned nblocks;
+
+static DEFINE_MUTEX(alloc_lock);
+
+struct tc_block *tc_allocate(int blk, const char *name)
+{
+	struct tc_block	*tc;
+
+	mutex_lock(&alloc_lock);
+	if (blk >= 0) {
+		if (blocks[blk].ioaddr)
+			goto full;
+	} else {
+		for (blk = 0; blk < nblocks; blk++) {
+			if (blocks[blk].ioaddr)
+				continue;
+			break;
+		}
+		if (blk == nblocks)
+			goto full;
+	}
+	tc = &blocks[blk];
+
+	if (!request_mem_region(tc->physaddr, 256, name))
+		goto full;
+
+	tc->ioaddr = ioremap(tc->physaddr, 256);
+	if (!tc->ioaddr)
+		goto requested;
+
+	pr_debug("%s: tc%d\n", __FUNCTION__, blk);
+	mutex_unlock(&alloc_lock);
+	return tc;
+
+requested:
+	release_mem_region(tc->physaddr, 256);
+full:
+	pr_debug("%s: alloc FAIL\n", __FUNCTION__);
+	mutex_unlock(&alloc_lock);
+	return NULL;
+}
+
+void tc_free(struct tc_block *tc)
+{
+	int blk;
+
+	for (blk = 0; blk < nblocks; blk++) {
+		if (tc->ioaddr == blocks[blk].ioaddr)
+			break;
+	}
+	if (blk == nblocks)
+		return;
+
+	mutex_lock(&alloc_lock);
+	pr_debug("%s: tc%d\n", __FUNCTION__, blk);
+	iounmap(tc->ioaddr);
+	tc->ioaddr = NULL;
+	release_mem_region(tc->physaddr, 256);
+	mutex_unlock(&alloc_lock);
+}
+
+void __init atmel_tc_init(struct tc_block *tcblocks, unsigned n)
+{
+	blocks = tcblocks;
+	nblocks = n;
+}
+
+
+/*--------------------------------------------------------------------------*/
+
+#ifdef CONFIG_AT91_TC_CLOCKSOURCE
+
+#include <linux/clocksource.h>
+
+/* Build a free-running 32 bit timer with a decent base rate of MCK/8
+ * (at around 5-10 MHz) by chaining two 16 bit TC timers.  This rolls
+ * over in around ten minutes.  (There seems to be little point in using
+ * CLOCK1, at MCK/2, given how long it takes to read the cycle count.
+ * This way, the reported precision reasonably matches its accuracy.)
+ *
+ * Example: rm9200 board MCK 46 Mhz, TC clk at 5.76 MHz or ~174 ns/tick.
+ * The first timer rolls over every 11.4 msec, incrementing the second
+ * counter at ~87 Hz.
+ *
+ * NOTE that the third timer does NOT make a very good clockevent source;
+ * sixteen bit counters are wasted silicon in this context.  In periodic
+ * mode, slightly higher MCK would prevent HZ=100 from working.  (The PIT
+ * timer in any AT91 chip is a better answer.)  For oneshot mode, it can't
+ * handle intervals long enough (up to a few seconds) for good "tickless"
+ * operation.  Using CLOCK4 or SLCK barely helps.
+ */
+
+static struct tc_block *tc;
+
+static cycle_t tc_get_cycles(void)
+{
+	union {
+		u32	word;
+		u16	half[2];
+	}		u;
+	unsigned long	flags;
+	void __iomem	*tcaddr = tc->ioaddr;
+
+	local_irq_save(flags);
+retry:
+	u.half[1] = __raw_readl(tcaddr + TC_CHAN(1, CV));
+	u.half[0] = __raw_readl(tcaddr + TC_CHAN(0, CV));
+	if (u.half[1] != __raw_readl(tcaddr + TC_CHAN(1, CV)))
+		goto retry;
+	local_irq_restore(flags);
+	return u.word;
+}
+
+static struct clocksource tc_clksrc = {
+	.name           = "tc_clksrc",
+	.rating         = 250,
+	.read           = tc_get_cycles,
+	.mask           = CLOCKSOURCE_MASK(32),
+	.shift          = 18,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+
+/* REVISIT behavior during system suspend states... we should disable all
+ * clocks and save the power, especially when the main oscillator will be
+ * disabled!  This implies defining and using a driver model device node.
+ */
+
+
+/* Init this late, so board-specific code has a chance to grab hardware.
+ * All we really care about is having two timers to chain; but sometimes
+ * TC modules will be used by drivers hooked up to external hardware.
+ */
+static int __init tc_clksrc_init(void)
+{
+	static char bootinfo[] __initdata
+		= KERN_INFO "%s: tc%d at %d.%03d MHz\n";
+
+	int value;
+	void __iomem *addr;
+
+	tc = tc_allocate(-1, tc_clksrc.name);
+	if (tc == NULL) {
+		pr_debug("can't alloc TC for clocksource\n");
+		return -ENODEV;
+	}
+
+	/* how fast will we be counting? */
+	value = (int) clk_get_rate(tc->tc0_clk) / 8;
+	tc_clksrc.mult = clocksource_hz2mult(value, tc_clksrc.shift);
+
+	printk(bootinfo, tc_clksrc.name, tc - blocks,
+			value/1000000, (value % 1000000) / 1000);
+
+	/* channel 0:  waveform mode, input mclk/8, clock TIOA0 on overflow */
+	addr = tc->ioaddr;
+	clk_enable(tc->tc0_clk);
+	__raw_writel(AT91_TC_TIMER_CLOCK2		/* input: mclk/8 */
+			| AT91_TC_WAVE
+			| AT91_TC_WAVESEL_UP		/* free-run */
+			| AT91_TC_ACPA_SET		/* TIOA0 rises at 0 */
+			| AT91_TC_ACPC_CLEAR,		/* (duty cycle 50%) */
+			addr + TC_CHAN(0, CMR));
+	__raw_writel(0x0000, addr + TC_CHAN(0, RA));
+	__raw_writel(0x8000, addr + TC_CHAN(0, RC));
+	__raw_writel(0xff, addr + TC_CHAN(0, IDR));	/* no irqs */
+	__raw_writel(AT91_TC_CLKEN, addr + TC_CHAN(0, CCR));
+
+	/* channel 1:  waveform mode, input TIOA0 */
+	clk_enable(tc->tc1_clk);	/* REVISIT: is this clock needed?? */
+	__raw_writel(AT91_TC_XC1			/* input: TIOA0 */
+			| AT91_TC_WAVE
+			| AT91_TC_WAVESEL_UP,		/* free-run */
+			addr + TC_CHAN(1, CMR));
+	__raw_writel(0xff, addr + TC_CHAN(1, IDR));	/* no irqs */
+	__raw_writel(AT91_TC_CLKEN, addr + TC_CHAN(1, CCR));
+
+	/* channel 2: UNUSED */
+
+	/* chain channel 0 to channel 1, then reset all the timers */
+	__raw_writel(AT91_TC_TC0XC0S_NONE
+			| AT91_TC_TC1XC1S_TIOA0
+			| AT91_TC_TC2XC2S_NONE,
+			tc->ioaddr + AT91_TC_BMR);
+	__raw_writel(AT91_TC_SYNC, tc->ioaddr + AT91_TC_BCR);
+
+	/* and away we go! */
+	clocksource_register(&tc_clksrc);
+
+	return 0;
+}
+late_initcall(tc_clksrc_init);
+
+#endif /* CONFIG_AT91_TC_CLOCKSOURCE */
--- at91.orig/arch/arm/mach-at91/at91rm9200.c	2007-03-08 19:50:34.000000000 -0800
+++ at91/arch/arm/mach-at91/at91rm9200.c	2007-03-10 09:16:49.000000000 -0800
@@ -248,6 +248,39 @@ static void at91rm9200_reset(void)
 	at91_sys_write(AT91_ST_CR, AT91_ST_WDRST);
 }
 
+/* --------------------------------------------------------------------
+ *  Timer/Counter library initialization
+ * -------------------------------------------------------------------- */
+#ifdef	CONFIG_ATMEL_TCLIB
+#include <linux/atmel_tc.h>
+
+static struct tc_block tcblocks[] = {
+	[0] = {
+		.physaddr = AT91RM9200_BASE_TCB0,
+		.tc0_clk = &tc0_clk,
+		.tc0_irq = AT91RM9200_ID_TC0,
+		.tc1_clk = &tc1_clk,
+		.tc1_irq = AT91RM9200_ID_TC1,
+		.tc2_clk = &tc2_clk,
+		.tc2_irq = AT91RM9200_ID_TC2,
+	},
+	[1] = {
+		.physaddr = AT91RM9200_BASE_TCB1,
+		.tc0_clk = &tc3_clk,
+		.tc0_irq = AT91RM9200_ID_TC3,
+		.tc1_clk = &tc4_clk,
+		.tc1_irq = AT91RM9200_ID_TC4,
+		.tc2_clk = &tc5_clk,
+		.tc2_irq = AT91RM9200_ID_TC5,
+	},
+};
+
+#define at91rm9200_tc_init()	atmel_tc_init(tcblocks, ARRAY_SIZE(tcblocks))
+
+#else
+#define at91rm9200_tc_init()	do{}while(0)
+#endif
+
 
 /* --------------------------------------------------------------------
  *  AT91RM9200 processor initialization
@@ -271,6 +304,9 @@ void __init at91rm9200_initialize(unsign
 
 	/* Initialize GPIO subsystem */
 	at91_gpio_init(at91rm9200_gpio, banks);
+
+	/* Initialize TC blocks */
+	at91rm9200_tc_init();
 }
 
 
--- at91.orig/arch/arm/mach-at91/at91sam9260.c	2007-03-08 19:50:34.000000000 -0800
+++ at91/arch/arm/mach-at91/at91sam9260.c	2007-03-10 09:16:56.000000000 -0800
@@ -262,6 +262,39 @@ static void at91sam9260_reset(void)
 	at91_sys_write(AT91_RSTC_CR, AT91_RSTC_KEY | AT91_RSTC_PROCRST | AT91_RSTC_PERRST);
 }
 
+/* --------------------------------------------------------------------
+ *  Timer/Counter library initialization
+ * -------------------------------------------------------------------- */
+#ifdef	CONFIG_ATMEL_TCLIB
+#include <linux/atmel_tc.h>
+
+static struct tc_block tcblocks[] = {
+	[0] = {
+		.physaddr = AT91SAM9260_BASE_TCB0,
+		.tc0_clk = &tc0_clk,
+		.tc0_irq = AT91SAM9260_ID_TC0,
+		.tc1_clk = &tc1_clk,
+		.tc1_irq = AT91SAM9260_ID_TC1,
+		.tc2_clk = &tc2_clk,
+		.tc2_irq = AT91SAM9260_ID_TC2,
+	},
+	[1] = {
+		.physaddr = AT91SAM9260_BASE_TCB1,
+		.tc0_clk = &tc3_clk,
+		.tc0_irq = AT91SAM9260_ID_TC3,
+		.tc1_clk = &tc4_clk,
+		.tc1_irq = AT91SAM9260_ID_TC4,
+		.tc2_clk = &tc5_clk,
+		.tc2_irq = AT91SAM9260_ID_TC5,
+	},
+};
+
+#define at91sam9260_tc_init()	atmel_tc_init(tcblocks, ARRAY_SIZE(tcblocks))
+
+#else
+#define at91sam9260_tc_init()	do{}while(0)
+#endif
+
 
 /* --------------------------------------------------------------------
  *  AT91SAM9260 processor initialization
@@ -310,6 +343,9 @@ void __init at91sam9260_initialize(unsig
 
 	/* Register GPIO subsystem */
 	at91_gpio_init(at91sam9260_gpio, 3);
+
+	/* Initialize TC blocks */
+	at91sam9260_tc_init();
 }
 
 /* --------------------------------------------------------------------
--- at91.orig/arch/arm/mach-at91/at91sam9261.c	2007-03-08 19:50:34.000000000 -0800
+++ at91/arch/arm/mach-at91/at91sam9261.c	2007-03-10 09:16:58.000000000 -0800
@@ -230,6 +230,30 @@ static void at91sam9261_reset(void)
 
 
 /* --------------------------------------------------------------------
+ *  Timer/Counter library initialization
+ * -------------------------------------------------------------------- */
+#ifdef	CONFIG_ATMEL_TCLIB
+#include <linux/atmel_tc.h>
+
+static struct tc_block tcblocks[] = {
+	[0] = {
+		.physaddr = AT91SAM9261_BASE_TCB0,
+		.tc0_clk = &tc0_clk,
+		.tc0_irq = AT91SAM9261_ID_TC0,
+		.tc1_clk = &tc1_clk,
+		.tc1_irq = AT91SAM9261_ID_TC1,
+		.tc2_clk = &tc2_clk,
+		.tc2_irq = AT91SAM9261_ID_TC2,
+	},
+};
+
+#define at91sam9261_tc_init()	atmel_tc_init(tcblocks, ARRAY_SIZE(tcblocks))
+
+#else
+#define at91sam9261_tc_init()	do{}while(0)
+#endif
+
+/* --------------------------------------------------------------------
  *  AT91SAM9261 processor initialization
  * -------------------------------------------------------------------- */
 
@@ -250,6 +274,9 @@ void __init at91sam9261_initialize(unsig
 
 	/* Register GPIO subsystem */
 	at91_gpio_init(at91sam9261_gpio, 3);
+
+	/* Initialize TC blocks */
+	at91sam9261_tc_init();
 }
 
 /* --------------------------------------------------------------------
--- at91.orig/arch/arm/mach-at91/at91sam9263.c	2007-03-08 19:50:34.000000000 -0800
+++ at91/arch/arm/mach-at91/at91sam9263.c	2007-03-10 09:17:02.000000000 -0800
@@ -237,6 +237,30 @@ static void at91sam9263_reset(void)
 
 
 /* --------------------------------------------------------------------
+ *  Timer/Counter library initialization
+ * -------------------------------------------------------------------- */
+#ifdef	CONFIG_ATMEL_TCLIB
+#include <linux/atmel_tc.h>
+
+static struct tc_block tcblocks[] = {
+	[0] = {
+		.physaddr = AT91SAM9263_BASE_TCB0,
+		.tc0_clk = &tcb_clk,
+		.tc0_irq = AT91SAM9261_ID_TCB,
+		.tc1_clk = &tcb_clk,
+		.tc1_irq = AT91SAM9261_ID_TCB,
+		.tc2_clk = &tcb_clk,
+		.tc2_irq = AT91SAM9261_ID_TCB,
+	},
+};
+
+#define at91sam9263_tc_init()	atmel_tc_init(tcblocks, ARRAY_SIZE(tcblocks))
+
+#else
+#define at91sam9263_tc_init()	do{}while(0)
+#endif
+
+/* --------------------------------------------------------------------
  *  AT91SAM9263 processor initialization
  * -------------------------------------------------------------------- */
 
@@ -256,6 +280,9 @@ void __init at91sam9263_initialize(unsig
 
 	/* Register GPIO subsystem */
 	at91_gpio_init(at91sam9263_gpio, 5);
+
+	/* Initialize TC blocks */
+	at91sam9263_tc_init();
 }
 
 /* --------------------------------------------------------------------
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ at91/include/linux/atmel_tc.h	2007-03-08 20:17:01.000000000 -0800
@@ -0,0 +1,187 @@
+/*
+ * <linux/atmel_tc.h>
+ *
+ * Copyright (C) SAN People
+ *
+ * Timer/Counter Unit (TC) registers.
+ * Based on AT91RM9200 datasheet revision E.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef ATMEL_TC_H
+#define ATMEL_TC_H
+
+/*
+ * This is a simple library to allocate the 16-bit Timer/Counter blocks..
+ * It allocates either specific blocks (interfacing to external hardware),
+ * or any unused block..  At least initially, this doesn't expect to share
+ * timers in one block between drivers.
+ *
+ * Note that some chips have multiple TC blocks, while others don't.
+ * Also, some chips have one clock (and irq) for each timer, but others
+ * share one for the whole block.
+ */
+
+/* REVISIT AVR32 uses interprets CLOCK1/CLOCK2/.../CLOCK5 differently
+ * than AT91.  Like the rm9200 and sam9260, the ap7000 has two TC modules.
+ *
+ * FIXME remove AT91 prefixes
+ */
+
+#define TC_CHAN(idx, reg)	((idx)*0x40 + AT91_TC_ ## reg)
+
+struct tc_block {
+	void __iomem	*ioaddr;
+	u32		physaddr;
+
+	struct clk	*tc0_clk;
+	int		tc0_irq;
+
+	struct clk	*tc1_clk;
+	int		tc1_irq;
+
+	struct clk	*tc2_clk;
+	int		tc2_irq;
+};
+
+/*
+ * Returned TC block is "on loan" to caller.
+ * Caller enables/disables TC clocks as needed (e.g. during suspend).
+ * BLOCK = 0, 1, etc; or negative to mean "any block"
+ */
+extern struct tc_block *tc_allocate(int block, const char *name);
+extern void tc_free(struct tc_block *tc);
+
+#define AT91_TC_BCR		0xc0		/* TC Block Control Register */
+#define		AT91_TC_SYNC		(1 << 0)	/* Synchro Command */
+
+#define AT91_TC_BMR		0xc4		/* TC Block Mode Register */
+#define		AT91_TC_TC0XC0S		(3 << 0)	/* External Clock Signal 0 Selection */
+#define			AT91_TC_TC0XC0S_TCLK0		(0 << 0)
+#define			AT91_TC_TC0XC0S_NONE		(1 << 0)
+#define			AT91_TC_TC0XC0S_TIOA1		(2 << 0)
+#define			AT91_TC_TC0XC0S_TIOA2		(3 << 0)
+#define		AT91_TC_TC1XC1S		(3 << 2)	/* External Clock Signal 1 Selection */
+#define			AT91_TC_TC1XC1S_TCLK1		(0 << 2)
+#define			AT91_TC_TC1XC1S_NONE		(1 << 2)
+#define			AT91_TC_TC1XC1S_TIOA0		(2 << 2)
+#define			AT91_TC_TC1XC1S_TIOA2		(3 << 2)
+#define		AT91_TC_TC2XC2S		(3 << 4)	/* External Clock Signal 2 Selection */
+#define			AT91_TC_TC2XC2S_TCLK2		(0 << 4)
+#define			AT91_TC_TC2XC2S_NONE		(1 << 4)
+#define			AT91_TC_TC2XC2S_TIOA0		(2 << 4)
+#define			AT91_TC_TC2XC2S_TIOA1		(3 << 4)
+
+
+#define AT91_TC_CCR		0x00		/* Channel Control Register */
+#define		AT91_TC_CLKEN		(1 << 0)	/* Counter Clock Enable Command */
+#define		AT91_TC_CLKDIS		(1 << 1)	/* Counter CLock Disable Command */
+#define		AT91_TC_SWTRG		(1 << 2)	/* Software Trigger Command */
+
+#define AT91_TC_CMR		0x04		/* Channel Mode Register */
+#define		AT91_TC_TCCLKS		(7 << 0)	/* Capture/Waveform Mode: Clock Selection */
+#define			AT91_TC_TIMER_CLOCK1		(0 << 0)
+#define			AT91_TC_TIMER_CLOCK2		(1 << 0)
+#define			AT91_TC_TIMER_CLOCK3		(2 << 0)
+#define			AT91_TC_TIMER_CLOCK4		(3 << 0)
+#define			AT91_TC_TIMER_CLOCK5		(4 << 0)
+#define			AT91_TC_XC0			(5 << 0)
+#define			AT91_TC_XC1			(6 << 0)
+#define			AT91_TC_XC2			(7 << 0)
+#define		AT91_TC_CLKI		(1 << 3)	/* Capture/Waveform Mode: Clock Invert */
+#define		AT91_TC_BURST		(3 << 4)	/* Capture/Waveform Mode: Burst Signal Selection */
+#define		AT91_TC_LDBSTOP		(1 << 6)	/* Capture Mode: Counter Clock Stopped with TB Loading */
+#define		AT91_TC_LDBDIS		(1 << 7)	/* Capture Mode: Counter Clock Disable with RB Loading */
+#define		AT91_TC_ETRGEDG		(3 << 8)	/* Capture Mode: External Trigger Edge Selection */
+#define		AT91_TC_ABETRG		(1 << 10)	/* Capture Mode: TIOA or TIOB External Trigger Selection */
+#define		AT91_TC_CPCTRG		(1 << 14)	/* Capture Mode: RC Compare Trigger Enable */
+#define		AT91_TC_WAVE		(1 << 15)	/* Capture/Waveform mode */
+#define		AT91_TC_LDRA		(3 << 16)	/* Capture Mode: RA Loading Selection */
+#define		AT91_TC_LDRB		(3 << 18)	/* Capture Mode: RB Loading Selection */
+
+#define		AT91_TC_CPCSTOP		(1 <<  6)	/* Waveform Mode: Counter Clock Stopped with RC Compare */
+#define		AT91_TC_CPCDIS		(1 <<  7)	/* Waveform Mode: Counter Clock Disable with RC Compare */
+#define		AT91_TC_EEVTEDG		(3 <<  8)	/* Waveform Mode: External Event Edge Selection */
+#define			AT91_TC_EEVTEDG_NONE		(0 << 8)
+#define			AT91_TC_EEVTEDG_RISING		(1 << 8)
+#define			AT91_TC_EEVTEDG_FALLING		(2 << 8)
+#define			AT91_TC_EEVTEDG_BOTH		(3 << 8)
+#define		AT91_TC_EEVT		(3 << 10)	/* Waveform Mode: External Event Selection */
+#define			AT91_TC_EEVT_TIOB		(0 << 10)
+#define			AT91_TC_EEVT_XC0		(1 << 10)
+#define			AT91_TC_EEVT_XC1		(2 << 10)
+#define			AT91_TC_EEVT_XC2		(3 << 10)
+#define		AT91_TC_ENETRG		(1 << 12)	/* Waveform Mode: External Event Trigger Enable */
+#define		AT91_TC_WAVESEL		(3 << 13)	/* Waveform Mode: Waveform Selection */
+#define			AT91_TC_WAVESEL_UP		(0 << 13)
+#define			AT91_TC_WAVESEL_UP_AUTO		(2 << 13)
+#define			AT91_TC_WAVESEL_UPDOWN		(1 << 13)
+#define			AT91_TC_WAVESEL_UPDOWN_AUTO	(3 << 13)
+#define		AT91_TC_ACPA		(3 << 16)	/* Waveform Mode: RA Compare Effect on TIOA */
+#define			AT91_TC_ACPA_NONE		(0 << 16)
+#define			AT91_TC_ACPA_SET		(1 << 16)
+#define			AT91_TC_ACPA_CLEAR		(2 << 16)
+#define			AT91_TC_ACPA_TOGGLE		(3 << 16)
+#define		AT91_TC_ACPC		(3 << 18)	/* Waveform Mode: RC Compre Effect on TIOA */
+#define			AT91_TC_ACPC_NONE		(0 << 18)
+#define			AT91_TC_ACPC_SET		(1 << 18)
+#define			AT91_TC_ACPC_CLEAR		(2 << 18)
+#define			AT91_TC_ACPC_TOGGLE		(3 << 18)
+#define		AT91_TC_AEEVT		(3 << 20)	/* Waveform Mode: External Event Effect on TIOA */
+#define			AT91_TC_AEEVT_NONE		(0 << 20)
+#define			AT91_TC_AEEVT_SET		(1 << 20)
+#define			AT91_TC_AEEVT_CLEAR		(2 << 20)
+#define			AT91_TC_AEEVT_TOGGLE		(3 << 20)
+#define		AT91_TC_ASWTRG		(3 << 22)	/* Waveform Mode: Software Trigger Effect on TIOA */
+#define			AT91_TC_ASWTRG_NONE		(0 << 22)
+#define			AT91_TC_ASWTRG_SET		(1 << 22)
+#define			AT91_TC_ASWTRG_CLEAR		(2 << 22)
+#define			AT91_TC_ASWTRG_TOGGLE		(3 << 22)
+#define		AT91_TC_BCPB		(3 << 24)	/* Waveform Mode: RB Compare Effect on TIOB */
+#define			AT91_TC_BCPB_NONE		(0 << 24)
+#define			AT91_TC_BCPB_SET		(1 << 24)
+#define			AT91_TC_BCPB_CLEAR		(2 << 24)
+#define			AT91_TC_BCPB_TOGGLE		(3 << 24)
+#define		AT91_TC_BCPC		(3 << 26)	/* Waveform Mode: RC Compare Effect on TIOB */
+#define			AT91_TC_BCPC_NONE		(0 << 26)
+#define			AT91_TC_BCPC_SET		(1 << 26)
+#define			AT91_TC_BCPC_CLEAR		(2 << 26)
+#define			AT91_TC_BCPC_TOGGLE		(3 << 26)
+#define		AT91_TC_BEEVT		(3 << 28)	/* Waveform Mode: External Event Effect on TIOB */
+#define			AT91_TC_BEEVT_NONE		(0 << 28)
+#define			AT91_TC_BEEVT_SET		(1 << 28)
+#define			AT91_TC_BEEVT_CLEAR		(2 << 28)
+#define			AT91_TC_BEEVT_TOGGLE		(3 << 28)
+#define		AT91_TC_BSWTRG		(3 << 30)	/* Waveform Mode: Software Trigger Effect on TIOB */
+#define			AT91_TC_BSWTRG_NONE		(0 << 30)
+#define			AT91_TC_BSWTRG_SET		(1 << 30)
+#define			AT91_TC_BSWTRG_CLEAR		(2 << 30)
+#define			AT91_TC_BSWTRG_TOGGLE		(3 << 30)
+
+#define AT91_TC_CV		0x10		/* Counter Value */
+#define AT91_TC_RA		0x14		/* Register A */
+#define AT91_TC_RB		0x18		/* Register B */
+#define AT91_TC_RC		0x1c		/* Register C */
+
+#define AT91_TC_SR		0x20		/* Status Register */
+#define		AT91_TC_COVFS		(1 <<  0)	/* Counter Overflow Status */
+#define		AT91_TC_LOVRS		(1 <<  1)	/* Load Overrun Status */
+#define		AT91_TC_CPAS		(1 <<  2)	/* RA Compare Status */
+#define		AT91_TC_CPBS		(1 <<  3)	/* RB Compare Status */
+#define		AT91_TC_CPCS		(1 <<  4)	/* RC Compare Status */
+#define		AT91_TC_LDRAS		(1 <<  5)	/* RA Loading Status */
+#define		AT91_TC_LDRBS		(1 <<  6)	/* RB Loading Status */
+#define		AT91_TC_ETRGS		(1 <<  7)	/* External Trigger Status */
+#define		AT91_TC_CLKSTA		(1 << 16)	/* Clock Enabling Status */
+#define		AT91_TC_MTIOA		(1 << 17)	/* TIOA Mirror */
+#define		AT91_TC_MTIOB		(1 << 18)	/* TIOB Mirror */
+
+#define AT91_TC_IER		0x24		/* Interrupt Enable Register */
+#define AT91_TC_IDR		0x28		/* Interrupt Disable Register */
+#define AT91_TC_IMR		0x2c		/* Interrupt Mask Register */
+
+#endif	/* ATMEL_TC_H */
  
