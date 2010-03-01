Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab0CAWye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 17:54:34 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:49025 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab0CAWyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 17:54:33 -0500
Subject: [PATCH 2/3] arm: Convert arm to arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <1267483897.4216.91.camel@localhost.localdomain>
References: <1267483897.4216.91.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 14:54:14 -0800
Message-ID: <1267484054.4216.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts arm to use GENERIC_TIME via the arch_getoffset()
infrastructure, reducing the amount of arch specific code we need to
maintain.

The arm architecture is one of the last 2 arches that need to be
converted.

This patch applies on top of Linus' current -git tree

I've taken my best swing at converting this, but I'm not 100% confident
I got it right. My cross-compiler is now out of date (gcc4.2) so I
wasn't able to check if it compiled. Any assistance from arch
maintainers or testers to get this merged would be great.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

---
 arch/arm/Kconfig                 |   51 ++++++++++++++-------------
 arch/arm/include/asm/mach/time.h |    2 +-
 arch/arm/kernel/time.c           |   70 +++----------------------------------
 arch/arm/mach-at91/Kconfig       |   11 +-----
 4 files changed, 35 insertions(+), 99 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3b18128..ff8e0b4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -42,6 +42,11 @@ config GENERIC_GPIO
 
 config GENERIC_TIME
 	bool
+	default y
+
+config ARCH_USES_GETTIMEOFFSET
+	bool
+	default n
 
 config GENERIC_CLOCKEVENTS
 	bool
@@ -224,6 +229,7 @@ config ARCH_AAEC2000
 	select CPU_ARM920T
 	select ARM_AMBA
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Agilent AAEC-2000
 
@@ -234,6 +240,7 @@ config ARCH_INTEGRATOR
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST525
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for ARM's Integrator platform.
 
@@ -243,7 +250,6 @@ config ARCH_REALVIEW
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST307
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	help
@@ -256,7 +262,6 @@ config ARCH_VERSATILE
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST307
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	help
@@ -267,6 +272,7 @@ config ARCH_AT91
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Atmel AT91RM9200,
 	  AT91SAM9 and AT91CAP9 processors.
@@ -274,6 +280,7 @@ config ARCH_AT91
 config ARCH_CLPS711X
 	bool "Cirrus Logic CLPS711x/EP721x-based"
 	select CPU_ARM720T
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Cirrus Logic 711x/721x based boards.
 
@@ -282,6 +289,7 @@ config ARCH_GEMINI
 	select CPU_FA526
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for the Cortina Systems Gemini family SoCs
 
@@ -290,6 +298,7 @@ config ARCH_EBSA110
 	select CPU_SA110
 	select ISA
 	select NO_IOPORT
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This is an evaluation board for the StrongARM processor available
 	  from Digital. It has limited hardware on-board, including an
@@ -306,6 +315,7 @@ config ARCH_EP93XX
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_HOLES_MEMORYMODEL
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
 
@@ -313,13 +323,13 @@ config ARCH_FOOTBRIDGE
 	bool "FootBridge"
 	select CPU_SA110
 	select FOOTBRIDGE
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for systems based on the DC21285 companion chip
 	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
 
 config ARCH_MXC
 	bool "Freescale MXC/iMX-based"
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
@@ -334,7 +344,6 @@ config ARCH_STMP3XXX
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select USB_ARCH_HAS_EHCI
@@ -346,7 +355,6 @@ config ARCH_NETX
 	select CPU_ARM926T
 	select ARM_VIC
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_TIME
 	help
 	  This enables support for systems based on the Hilscher NetX Soc
 
@@ -354,6 +362,7 @@ config ARCH_H720X
 	bool "Hynix HMS720x-based"
 	select CPU_ARM720T
 	select ISA_DMA_API
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Hynix HMS720x
 
@@ -364,7 +373,6 @@ config ARCH_NOMADIK
 	select CPU_ARM926T
 	select HAVE_CLK
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
@@ -379,6 +387,7 @@ config ARCH_IOP13XX
 	select PCI
 	select ARCH_SUPPORTS_MSI
 	select VMSPLIT_1G
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IOP13XX (XScale) family of processors.
 
@@ -390,6 +399,7 @@ config ARCH_IOP32X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's 80219 and IOP32X (XScale) family of
 	  processors.
@@ -402,6 +412,7 @@ config ARCH_IOP33X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IOP33X (XScale) family of processors.
 
@@ -410,6 +421,7 @@ config ARCH_IXP23XX
 	depends on MMU
 	select CPU_XSC3
  	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IXP23xx (XScale) family of processors.
 
@@ -418,6 +430,7 @@ config ARCH_IXP2000
 	depends on MMU
 	select CPU_XSCALE
 	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IXP2400/2800 (XScale) family of processors.
 
@@ -426,7 +439,6 @@ config ARCH_IXP4XX
 	depends on MMU
 	select CPU_XSCALE
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select DMABOUNCE if PCI
 	help
@@ -436,6 +448,7 @@ config ARCH_L7200
 	bool "LinkUp-L7200"
 	select CPU_ARM720T
 	select FIQ
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Say Y here if you intend to run this kernel on a LinkUp Systems
 	  L7200 Software Development Board which uses an ARM720T processor.
@@ -451,7 +464,6 @@ config ARCH_DOVE
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -463,7 +475,6 @@ config ARCH_KIRKWOOD
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -473,7 +484,6 @@ config ARCH_KIRKWOOD
 config ARCH_LOKI
 	bool "Marvell Loki (88RC8480)"
 	select CPU_FEROCEON
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -485,7 +495,6 @@ config ARCH_MV78XX0
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -499,7 +508,6 @@ config ARCH_ORION5X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -514,7 +522,6 @@ config ARCH_MMP
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	select PLAT_PXA
@@ -526,6 +533,7 @@ config ARCH_KS8695
 	select CPU_ARM922T
 	select GENERIC_GPIO
         select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Micrel/Kendin KS8695 "Centaur" (ARM922T) based
 	  System-on-Chip devices.
@@ -534,7 +542,6 @@ config ARCH_NS9XXX
 	bool "NetSilicon NS9xxx"
 	select CPU_ARM926T
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	help
@@ -550,7 +557,6 @@ config ARCH_W90X900
 	select GENERIC_GPIO
 	select HAVE_CLK
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for Nuvoton (Winbond logic dept.) ARM9 processor,
@@ -575,6 +581,7 @@ config ARCH_PNX4008
 	select CPU_ARM926T
 	select HAVE_CLK
 	select COMMON_CLKDEV
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for Philips PNX4008 mobile platform.
 
@@ -587,7 +594,6 @@ config ARCH_PXA
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	select PLAT_PXA
@@ -597,7 +603,6 @@ config ARCH_PXA
 config ARCH_MSM
 	bool "Qualcomm MSM"
 	select CPU_V6
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for Qualcomm MSM7K based systems.  This runs on the ARM11
@@ -615,6 +620,7 @@ config ARCH_RPC
 	select ISA_DMA_API
 	select NO_IOPORT
 	select ARCH_SPARSEMEM_ENABLE
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
 	  CD-ROM interface, serial and parallel port, and the floppy drive.
@@ -628,7 +634,6 @@ config ARCH_SA1100
 	select ARCH_HAS_CPUFREQ
 	select CPU_FREQ
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	select TICK_ONESHOT
@@ -641,6 +646,7 @@ config ARCH_S3C2410
 	select GENERIC_GPIO
 	select ARCH_HAS_CPUFREQ
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
 	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
@@ -650,6 +656,7 @@ config ARCH_S3C64XX
 	bool "Samsung S3C64XX"
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	select ARCH_HAS_CPUFREQ
 	help
 	  Samsung S3C64XX series based systems
@@ -670,6 +677,7 @@ config ARCH_SHARK
 	select ISA_DMA
 	select ZONE_DMA
 	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for the StrongARM based Digital DNARD machine, also known
 	  as "Shark" (<http://www.shark-linux.de/shark.html>).
@@ -679,6 +687,7 @@ config ARCH_LH7A40X
 	select CPU_ARM922T
 	select ARCH_DISCONTIGMEM_ENABLE if !LH7A40X_CONTIGMEM
 	select ARCH_SPARSEMEM_ENABLE if !LH7A40X_CONTIGMEM
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Say Y here for systems based on one of the Sharp LH7A40X
 	  System on a Chip processors.  These CPUs include an ARM922T
@@ -692,7 +701,6 @@ config ARCH_U300
 	select HAVE_TCM
 	select ARM_AMBA
 	select ARM_VIC
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	select COMMON_CLKDEV
@@ -703,7 +711,6 @@ config ARCH_U300
 config ARCH_DAVINCI
 	bool "TI DaVinci"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
@@ -722,7 +729,6 @@ config ARCH_OMAP
 	select HAVE_CLK
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_CPUFREQ
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	help
@@ -734,7 +740,6 @@ config ARCH_BCMRING
 	select CPU_V6
 	select ARM_AMBA
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	help
@@ -744,7 +749,6 @@ config ARCH_U8500
 	bool "ST-Ericsson U8500 Series"
 	select CPU_V7
 	select ARM_AMBA
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select COMMON_CLKDEV
 	help
@@ -867,7 +871,6 @@ config ARCH_ACORN
 config PLAT_IOP
 	bool
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_TIME
 
 config PLAT_ORION
 	bool
diff --git a/arch/arm/include/asm/mach/time.h b/arch/arm/include/asm/mach/time.h
index 8bffc3f..35d408f 100644
--- a/arch/arm/include/asm/mach/time.h
+++ b/arch/arm/include/asm/mach/time.h
@@ -38,7 +38,7 @@ struct sys_timer {
 	void			(*init)(void);
 	void			(*suspend)(void);
 	void			(*resume)(void);
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	unsigned long		(*offset)(void);
 #endif
 };
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 2875380..38c261f 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -72,12 +72,15 @@ unsigned long profile_pc(struct pt_regs *regs)
 EXPORT_SYMBOL(profile_pc);
 #endif
 
-#ifndef CONFIG_GENERIC_TIME
-static unsigned long dummy_gettimeoffset(void)
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+u32 arch_gettimeoffset(void)
 {
+	if (system_timer->offset != NULL)
+		return system_timer->offset() * 1000;
+
 	return 0;
 }
-#endif
+#endif /* CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 #ifdef CONFIG_LEDS_TIMER
 static inline void do_leds(void)
@@ -93,63 +96,6 @@ static inline void do_leds(void)
 #define	do_leds()
 #endif
 
-#ifndef CONFIG_GENERIC_TIME
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = system_timer->offset();
-		sec = xtime.tv_sec;
-		usec += xtime.tv_nsec / 1000;
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	/* usec may have gone up a lot: be safe */
-	while (usec >= 1000000) {
-		usec -= 1000000;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * done, and then undo it!
-	 */
-	nsec -= system_timer->offset() * NSEC_PER_USEC;
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
-#endif /* !CONFIG_GENERIC_TIME */
 
 #ifndef CONFIG_GENERIC_CLOCKEVENTS
 /*
@@ -214,10 +160,6 @@ device_initcall(timer_init_sysfs);
 
 void __init time_init(void)
 {
-#ifndef CONFIG_GENERIC_TIME
-	if (system_timer->offset == NULL)
-		system_timer->offset = dummy_gettimeoffset;
-#endif
 	system_timer->init();
 }
 
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 2db43a5..2d040a4 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -23,14 +23,12 @@ choice
 config ARCH_AT91RM9200
 	bool "AT91RM9200"
 	select CPU_ARM920T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 
 config ARCH_AT91SAM9260
 	bool "AT91SAM9260 or AT91SAM9XE"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 	select HAVE_AT91_USART4
@@ -39,28 +37,24 @@ config ARCH_AT91SAM9260
 config ARCH_AT91SAM9261
 	bool "AT91SAM9261"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_FB_ATMEL
 
 config ARCH_AT91SAM9G10
 	bool "AT91SAM9G10"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_FB_ATMEL
 
 config ARCH_AT91SAM9263
 	bool "AT91SAM9263"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_FB_ATMEL
 
 config ARCH_AT91SAM9RL
 	bool "AT91SAM9RL"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 	select HAVE_FB_ATMEL
@@ -68,7 +62,6 @@ config ARCH_AT91SAM9RL
 config ARCH_AT91SAM9G20
 	bool "AT91SAM9G20"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 	select HAVE_AT91_USART4
@@ -77,7 +70,6 @@ config ARCH_AT91SAM9G20
 config ARCH_AT91SAM9G45
 	bool "AT91SAM9G45"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 	select HAVE_FB_ATMEL
@@ -85,18 +77,17 @@ config ARCH_AT91SAM9G45
 config ARCH_AT91CAP9
 	bool "AT91CAP9"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_FB_ATMEL
 
 config ARCH_AT572D940HF
 	bool "AT572D940HF"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91X40
 	bool "AT91x40"
+	select ARCH_USES_GETTIMEOFFSET
 
 endchoice
 
-- 
1.6.0.4



