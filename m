Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZFZHJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZFZHJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZFZHI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:08:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33142 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbZFZHI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:08:57 -0400
Date: Fri, 26 Jun 2009 09:08:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 7/9] x86/apbt: Moorestown APB system timer driver
Message-ID: <20090626070840.GC14078@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E6@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F07556412B7E6@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pan, Jacob jun <jacob.jun.pan@intel.com> wrote:

> >From 016f663ccfa36a3cf46a00664e2f336968f5d902 Mon Sep 17 00:00:00 2001
> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Mon, 8 Jun 2009 12:57:47 +0800
> Subject: [PATCH] x86/apbt: Moorestown APB system timer driver
> 
> Moorestown platform has introduced legacy replacement system timers, called
> APB timers. There are four timers available to the kernel via SFI MTMR table.
> APB timers are always running and have a known frequency. Two timers used
> for per CPU clockevent deivces, one for clocksource, one by the watchdog
> driver. This driver serve similar functionality found in i8254 and HPET,
> APB timers are given higher rating than local APIC timer so that they are
> used for per CPU timer in SMP/HT. Broadcast timer is avoided. If cmdline
> option no_percpu_apbt is given, the kernel will pick local APIC timers
> and one APB timer as broadcast clockevent device.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> ---
>  Documentation/kernel-parameters.txt |    4 +
>  arch/x86/Kconfig                    |   12 +
>  arch/x86/include/asm/apb_timer.h    |   78 ++++
>  arch/x86/include/asm/fixmap.h       |    3 +
>  arch/x86/include/asm/mach_timer.h   |   16 +-
>  arch/x86/include/asm/time.h         |    4 +-
>  arch/x86/kernel/Makefile            |    2 +-
>  arch/x86/kernel/apb_timer.c         |  778 +++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/time_32.c           |   21 +-
>  arch/x86/kernel/tsc.c               |   14 +-
>  10 files changed, 924 insertions(+), 8 deletions(-)
>  create mode 100644 arch/x86/include/asm/apb_timer.h
>  create mode 100644 arch/x86/kernel/apb_timer.c
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index f17bce0..8cb6ade 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1650,6 +1650,10 @@ and is between 256 and 4096 characters. It is defined in the file
>         nomfgpt         [X86-32] Disable Multi-Function General Purpose
>                         Timer usage (for AMD Geode machines).
> 
> +       no_percpu_apbt  [X86-32,APBT]
> +                       Disable per CPU APB timer as clockevent devices. this
> +                       will make the local APIC timer used as per CPU timer.
> +
>         norandmaps      Don't use address space randomization.  Equivalent to
>                         echo 0 > /proc/sys/kernel/randomize_va_space
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ee78581..62224d8 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -569,6 +569,18 @@ config HPET_TIMER
>  config HPET_EMULATE_RTC
>         def_bool y
>         depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
> +config APB_TIMER
> +       def_bool y
> +       depends on SFI && MRST
> +       prompt "Langwell APB Timer Support" if X86_32
> +       help
> +       APB timer is the replacement for 8254, HPET on X86 MID platforms.
> +       The APBT provides a stable time base on SMP
> +       systems, unlike the TSC, but it is more expensive to access,
> +       as it is off-chip. APB timers are always running regardless of CPU
> +       C states, they are used as per CPU clockevent device when possible.
> +
> +       Must choose Y if you are running Intel Moorestown platform.
> 
>  # Mark as embedded because too many people got it wrong.
>  # The code disables itself when not needed.
> diff --git a/arch/x86/include/asm/apb_timer.h b/arch/x86/include/asm/apb_timer.h
> new file mode 100644
> index 0000000..3394580
> --- /dev/null
> +++ b/arch/x86/include/asm/apb_timer.h
> @@ -0,0 +1,78 @@
> +/*
> + * apb_timer.h: Driver for Langwell APB timer based on Synopsis DesignWare
> + *
> + * (C) Copyright 2008 Intel Corporation
> + * Author: Jacob Pan (jacob.jun.pan@intel.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + *
> + * Note:
> + * Langwell provide two external timers to the IA32 host, these two timers
> + * can be used as clockevent device per CPU/Thread. The interrupt of each
> + * timer is independently routed via IOAPIC.
> + */
> +
> +#ifndef ASM_X86_APBT_H
> +#define ASM_X86_APBT_H
> +#include <linux/sfi.h>
> +
> +#ifdef CONFIG_APB_TIMER
> +/* Langwell DW APB timer registers */
> +#define APBTMR_0_LOAD_COUNT    0x00
> +#define APBTMR_0_CURRENT_VALUE 0x04
> +#define APBTMR_0_CONTROL       0x08
> +#define APBTMR_0_EOI           0x0c
> +#define APBTMR_0_INT_STATUS    0x10
> +
> +#define APBTMR_1_LOAD_COUNT    0x14
> +#define APBTMR_1_CURRENT_VALUE 0x18
> +#define APBTMR_1_CONTROL       0x1c
> +#define APBTMR_1_EOI           0x20
> +#define APBTMR_1_INT_STATUS    0x24
> +
> +#define APBTMRS_INT_STATUS     0xa0
> +#define APBTMRS_EOI            0xa4
> +#define APBTMRS_RAW_INT_STATUS 0xa8
> +#define APBTMRS_COMP_VERSION   0xac
> +#define APBTMRS_REG_SIZE       0x14
> +
> +/* register bits */
> +#define APBTMR_CONTROL_ENABLE  (1<<0)
> +#define APBTMR_CONTROL_MODE_PERIODIC   (1<<1) /*1: periodic 0:free running */
> +#define APBTMR_CONTROL_INT     (1<<2)
> +
> +/* default memory mapped register base */
> +#define LNW_SCU_ADDR           0xFF100000
> +#define LNW_EXT_TIMER_OFFSET   0x1B800
> +#define APBT_DEFAULT_BASE      (LNW_SCU_ADDR+LNW_EXT_TIMER_OFFSET)
> +#define LNW_EXT_TIMER_PGOFFSET         0x800
> +
> +/* APBT clock speed range from PCLK to fabric base, 25-100MHz */
> +#define APBT_MAX_FREQ          50
> +#define APBT_MIN_FREQ          1
> +#define APBT_MMAP_SIZE         1024
> +/* Normally timer status should be cleared by kernel driver reading EOI reg.
> + * but SCU FW is doing this for us upon receiving APIC EOI.
> + */
> +#define APBT_SCU_FW_EOI
> +
> +extern int apbt_enable(void);
> +extern struct clock_event_device *global_clock_event;
> +extern struct sfi_mtimer_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
> +extern unsigned long apbt_quick_calibrate(void);
> +extern int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu);
> +extern void apbt_setup_secondary_clock(void);
> +void apbt_prepare_count(unsigned int);
> +void apbt_countup(unsigned long *);
> +extern unsigned int boot_cpu_id;
> +#else /* CONFIG_APB_TIMER */
> +static inline int __init apb_timer_enable(void) {return 0; }
> +static inline void apbt_prepare_count(unsigned int msec) {return; }
> +static inline void apbt_countup(unsigned long *count_p)        {return; }
> +static inline unsigned long apbt_quick_calibrate(void) {return 0; }
> +static inline int apbt_enable(void) {return 0; }
> +#endif
> +#endif /* ASM_X86_APBT_H */
> diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
> index 2d81af3..9f7a4b7 100644
> --- a/arch/x86/include/asm/fixmap.h
> +++ b/arch/x86/include/asm/fixmap.h
> @@ -117,6 +117,9 @@ enum fixed_addresses {
>  #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
>         FIX_OHCI1394_BASE,
>  #endif
> +#ifdef CONFIG_APB_TIMER
> +       FIX_APB_TIMER,
> +#endif
>         /*
>          * 256 temporary boot-time mappings, used by early_ioremap(),
>          * before ioremap() is functional.
> diff --git a/arch/x86/include/asm/mach_timer.h b/arch/x86/include/asm/mach_timer.h
> index 8537285..1d3bada 100644
> --- a/arch/x86/include/asm/mach_timer.h
> +++ b/arch/x86/include/asm/mach_timer.h
> @@ -13,14 +13,22 @@
>  #ifndef _ASM_X86_MACH_DEFAULT_MACH_TIMER_H
>  #define _ASM_X86_MACH_DEFAULT_MACH_TIMER_H
> 
> +#include <asm/platform_feature.h>
> +#include <asm/apb_timer.h>
> +
>  #define CALIBRATE_TIME_MSEC 30 /* 30 msecs */
>  #define CALIBRATE_LATCH        \
>         ((CLOCK_TICK_RATE * CALIBRATE_TIME_MSEC + 1000/2)/1000)
> 
>  static inline void mach_prepare_counter(void)
>  {
> -       /* Set the Gate high, disable speaker */
> -       outb((inb(0x61) & ~0x02) | 0x01, 0x61);
> +       if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
> +               apbt_prepare_count(CALIBRATE_TIME_MSEC);
> +               return;
> +       }
> +       /* Set the Gate high, disable speaker */
> +       if (platform_has(X86_PLATFORM_FEATURE_8254))
> +               outb((inb(0x61) & ~0x02) | 0x01, 0x61);
> 
>         /*
>          * Now let's take care of CTC channel 2
> @@ -39,6 +47,10 @@ static inline void mach_prepare_counter(void)
>  static inline void mach_countup(unsigned long *count_p)
>  {
>         unsigned long count = 0;
> +       if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
> +               apbt_countup(count_p);
> +               return;
> +       }
>         do {
>                 count++;
>         } while ((inb_p(0x61) & 0x20) == 0);
> diff --git a/arch/x86/include/asm/time.h b/arch/x86/include/asm/time.h
> index 50c733a..af08d45 100644
> --- a/arch/x86/include/asm/time.h
> +++ b/arch/x86/include/asm/time.h
> @@ -2,7 +2,8 @@
>  #define _ASM_X86_TIME_H
> 
>  extern void hpet_time_init(void);
> -
> +#include <asm/platform_feature.h>
> +#include <asm/apb_timer.h>
>  #include <asm/mc146818rtc.h>
>  #ifdef CONFIG_X86_32
>  #include <linux/efi.h>
> @@ -54,7 +55,6 @@ extern void time_init(void);
> 
>  #define get_wallclock() native_get_wallclock()
>  #define set_wallclock(x) native_set_wallclock(x)
> -#define choose_time_init() hpet_time_init
> 
>  #endif /* CONFIG_PARAVIRT */
> 
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 42f30f3..cbd60e2 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -85,7 +85,7 @@ obj-$(CONFIG_VM86)            += vm86_32.o
>  obj-$(CONFIG_EARLY_PRINTK)     += early_printk.o
> 
>  obj-$(CONFIG_HPET_TIMER)       += hpet.o
> -
> +obj-$(CONFIG_APB_TIMER)        += apb_timer.o
>  obj-$(CONFIG_K8_NB)            += k8.o
>  obj-$(CONFIG_MGEODE_LX)                += geode_32.o mfgpt_32.o
>  obj-$(CONFIG_DEBUG_RODATA_TEST)        += test_rodata.o
> diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
> new file mode 100644
> index 0000000..0076a47
> --- /dev/null
> +++ b/arch/x86/kernel/apb_timer.c
> @@ -0,0 +1,778 @@
> +/*
> + * apb_timer.c: Driver for Langwell APB timer based on Synopsis DesignWare
> + *
> + * (C) Copyright 2008 Intel Corporation
> + * Author: Jacob Pan (jacob.jun.pan@intel.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + *
> + * Note:
> + * Langwell provide three external timers to the IA32 host, two timers are
> + * used as clockevent device per CPU/Thread; the third timer is used for
> + * clocksource.
> + * The interrupt of each timer is delivered to SCU (system controller unit) then
> + * independently routed via IOAPIC.
> + * When local APIC timers are used, only one APB timer is used to drive global
> + * clockevent. By default on SMP kernel, per CPU APB timer is used without APIC
> + * timers. Timer broadcast are avoided since APB timers are always on.
> + */
> +#include <linux/clocksource.h>
> +#include <linux/clockchips.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/sysdev.h>
> +#include <linux/pm.h>
> +#include <linux/pci.h>
> +#include <linux/sfi.h>
> +#include <linux/interrupt.h>
> +#include <linux/cpu.h>
> +
> +#include <asm/fixmap.h>
> +#include <asm/apb_timer.h>
> +#define APBT_MASK      CLOCKSOURCE_MASK(32)
> +#define APBT_SHIFT                     22
> +#define APBT_CLOCKEVENT_RATING         150
> +#define APBT_CLOCKSOURCE_RATING                250
> +#define APBT_MIN_DELTA_USEC            200
> +#undef APBT_DEBUG
> +#ifdef APBT_DEBUG
> +
> +#      define apbt_dbg(fmt, args...) \
> +       do { printk(KERN_DEBUG "apbt:" fmt, ## args); } while (0)
> +#else
> +#      define apbt_dbg(fmt, args...) do { } while (0)
> +#endif
> +
> +#define EVT_TO_APBT_DEV(evt) container_of(evt, struct apbt_dev, evt)
> +#define APBT_CLOCKEVENT0_NUM   (0)
> +#define APBT_CLOCKEVENT1_NUM   (1)
> +#define APBT_CLOCKSOURCE_NUM   (2)
> +
> +static unsigned long apbt_address;
> +static int apb_timer_block_enabled;
> +static void __iomem *apbt_virt_address;
> +static int phy_cs_timer_id;
> +
> +/*
> + * Common DW APB timer info
> + */
> +static uint64_t apbt_freq;
> +
> +static void apb_timer_set_mode(enum clock_event_mode mode,
> +                         struct clock_event_device *evt);
> +static int apb_timer_next_event(unsigned long delta,
> +                          struct clock_event_device *evt);
> +
> +struct apbt_dev {
> +       struct clock_event_device       evt;
> +       unsigned int num;
> +       int cpu;
> +       unsigned int irq;
> +       unsigned int tick;
> +       unsigned int count;
> +       unsigned int flags;
> +       char name[10];
> +};
> +
> +static int disable_apbt_percpu __cpuinitdata;
> +
> +#ifdef CONFIG_SMP
> +static unsigned int apbt_num_timers_used;
> +static DEFINE_PER_CPU(struct apbt_dev *, cpu_apbt_dev);
> +static struct apbt_dev *apbt_devs;
> +#endif
> +static  inline unsigned long apbt_readl_reg(unsigned long a)
> +{
> +       unsigned long data;
> +       data = readl(apbt_virt_address + a);
> +       return data;
> +}
> +static inline void apbt_writel_reg(unsigned long d, unsigned long a)
> +{
> +       writel(d, apbt_virt_address + a);
> +}
> +
> +static inline unsigned long apbt_readl(int n, unsigned long a)
> +{
> +       unsigned long data;
> +       data = readl(apbt_virt_address + a + n * APBTMRS_REG_SIZE);
> +       return data;
> +}
> +static inline void apbt_writel(int n, unsigned long d, unsigned long a)
> +{
> +       writel(d, apbt_virt_address + a + n * APBTMRS_REG_SIZE);
> +}
> +
> +/* used for TSC calibration which is before mem_init() so that ioremap() can
> + * not be used. use fixmap instead. this is boot only.
> + */
> +static inline void apbt_set_mapping_early(void)
> +{
> +       static int early_mapped;
> +       struct sfi_mtimer_entry *mtmr;
> +       if (early_mapped)
> +               return;
> +       mtmr = sfi_get_mtmr(APBT_CLOCKEVENT0_NUM);
> +       if (mtmr == NULL) {
> +               printk(KERN_ERR "Failed to get MTMR from SFI\n");
> +               return;
> +       }
> +       if (!apbt_address)
> +               apbt_address = mtmr->phy_addr;
> +
> +       set_fixmap_nocache(FIX_APB_TIMER, apbt_address);
> +       /* fixmap is per page */
> +       apbt_virt_address = (unsigned char __iomem *)
> +                       __fix_to_virt(FIX_APB_TIMER) + LNW_EXT_TIMER_PGOFFSET;
> +       if (apbt_virt_address)
> +               apbt_dbg("Fix mapped APBT at %p (%lu)\n",
> +                       apbt_virt_address, apbt_address);
> +       else
> +               printk(KERN_INFO "Failed to map fix apbt\n");
> +       early_mapped = 1;
> +       apbt_freq = mtmr->freq / USEC_PER_SEC;
> +       sfi_free_mtmr(mtmr);
> +       return;
> +}
> +
> +static inline void apbt_set_mapping(void)
> +{
> +       struct sfi_mtimer_entry *mtmr;
> +       mtmr = sfi_get_mtmr(APBT_CLOCKEVENT0_NUM);
> +       if (mtmr == NULL) {
> +               printk(KERN_ERR "Failed to get MTMR %d from SFI\n",
> +                       APBT_CLOCKEVENT0_NUM);
> +               return;
> +       }
> +       apbt_address = (unsigned long)mtmr->phy_addr;
> +       if (!apbt_address) {
> +               printk(KERN_WARNING "No timer base from SFI, use default\n");
> +               apbt_address = APBT_DEFAULT_BASE;
> +       }
> +       apbt_virt_address = ioremap_nocache(apbt_address, APBT_MMAP_SIZE);
> +       if (apbt_virt_address) {
> +               apbt_dbg("Mapped APBT physical addr %p at virtual addr %p\n",\
> +                       (void *)apbt_address, (void *)apbt_virt_address);
> +       } else {
> +               apbt_dbg("Failed mapping APBT phy address at %p\n",\
> +                       (void *)apbt_address);
> +       }
> +       apbt_freq = mtmr->freq / USEC_PER_SEC;
> +       sfi_free_mtmr(mtmr);
> +       /* Now figure out the physical timer id for clocksource device */
> +       mtmr = sfi_get_mtmr(APBT_CLOCKSOURCE_NUM);
> +       if (mtmr == NULL) {
> +               printk(KERN_ERR "Failed to get APBT clocksource\n");
> +               return;
> +       }
> +       /* Now figure out the physical timer id */
> +       phy_cs_timer_id = (unsigned int)(mtmr->phy_addr & 0xff)
> +                       / APBTMRS_REG_SIZE;
> +       apbt_dbg("Use timer %d for clocksource\n", phy_cs_timer_id);
> +}
> +
> +static inline void apbt_clear_mapping(void)
> +{
> +       iounmap(apbt_virt_address);
> +       apbt_virt_address = NULL;
> +}
> +/*
> + * APBT timer interrupt enable / disable
> + */
> +static inline int is_apbt_capable(void)
> +{
> +       return apbt_virt_address ? 1 : 0;
> +}
> +/*
> + * is_apbt_enabled - check whether the apbt timer interrupt is enabled
> + */
> +int is_apbt_enabled(void)
> +{
> +       return is_apbt_capable();
> +}
> +EXPORT_SYMBOL_GPL(is_apbt_enabled);
> +
> +static void __init apbt_event_handler(struct clock_event_device *dev)
> +{
> +       return;
> +}
> +
> +/*
> + * boot APB clock event device
> + */
> +static struct clock_event_device apbt_clockevent = {
> +       .name           = "apbt0",
> +       .features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +       .set_mode       = apb_timer_set_mode,
> +       .event_handler  = apbt_event_handler,
> +       .set_next_event = apb_timer_next_event,
> +       .shift          = APBT_SHIFT,
> +       .irq            = 0,
> +       .rating         = APBT_CLOCKEVENT_RATING,
> +};
> +
> +/* if user does not want to use per CPU apb timer, just give it a lower rating
> + * than local apic timer and skip the late per cpu timer init.
> + */
> +static inline int __init setup_no_percpu_apbt(char *arg)
> +{
> +       disable_apbt_percpu = 1;
> +       return 0;
> +}
> +__setup("no_percpu_apbt", setup_no_percpu_apbt);
> +
> +/* we should start counter with free running mode initial load value all Fs
> + * But ESL 60 has a bug that prevent us using it. so let's use user mode
> + * with a large initial count.
> + */
> +static void apbt_start_counter(int n)
> +{
> +       unsigned long ctrl = apbt_readl(n, APBTMR_0_CONTROL);
> +       ctrl &= ~APBTMR_CONTROL_ENABLE;
> +       apbt_writel(n, ctrl, APBTMR_0_CONTROL);
> +       apbt_writel(n, ~0, APBTMR_0_LOAD_COUNT);
> +       ctrl |= (APBTMR_CONTROL_ENABLE | APBTMR_CONTROL_MODE_PERIODIC);
> +       apbt_writel(n, ctrl, APBTMR_0_CONTROL);
> +}
> +#ifdef CONFIG_SMP
> +static irqreturn_t apbt_interrupt_handler(int irq, void *data)
> +{
> +       struct apbt_dev *dev = (struct apbt_dev *)data;
> +       struct clock_event_device *aevt = &dev->evt;
> +
> +       if (!aevt->event_handler) {
> +               printk(KERN_INFO "Spurious APBT timer interrupt on %d\n",
> +                               dev->num);
> +               return IRQ_HANDLED;
> +       }
> +       aevt->event_handler(aevt);
> +       return IRQ_HANDLED;
> +}
> +#endif
> +
> +static void apbt_restart_clocksource(void)
> +{
> +       apbt_start_counter(phy_cs_timer_id);
> +}
> +/* Setup IRQ routing via IOAPIC */
> +#ifdef CONFIG_SMP
> +static void apbt_setup_irq(struct apbt_dev *adev)
> +{
> +       /* timer0 irq has been setup early*/
> +       if (adev->irq == 0)
> +               return;
> +       disable_irq(adev->irq);
> +       irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
> +       enable_irq(adev->irq);
> +       /* IRQ should already been setup */
> +
> +       arch_setup_apbt_irqs(adev->irq, 0, 0, adev->cpu);
> +       if (request_irq(adev->irq, apbt_interrupt_handler,
> +                       IRQF_DISABLED|IRQF_NOBALANCING, adev->name, adev)) {
> +               printk(KERN_ERR "Failed request IRQ for APBT %d\n", adev->num);
> +               return;
> +       }
> +}
> +#endif
> +
> +static void apbt_enable_int(int n)
> +{
> +       unsigned long ctrl = apbt_readl(n, APBTMR_0_CONTROL);
> +       ctrl &= ~APBTMR_CONTROL_INT;
> +       apbt_writel(n, ctrl, APBTMR_0_CONTROL);
> +}
> +static int apbt_clockevent_register(void)
> +{
> +       struct sfi_mtimer_entry *mtmr;
> +       mtmr = sfi_get_mtmr(APBT_CLOCKEVENT0_NUM);
> +       if (mtmr == NULL) {
> +               printk(KERN_ERR "Failed to get MTMR %d from SFI\n",
> +                       APBT_CLOCKEVENT0_NUM);
> +               return -ENODEV;
> +       }
> +       /* Start APBT 0 interrupts */
> +       apbt_enable_int(APBT_CLOCKEVENT0_NUM);
> +       /*
> +        * We need to calculate the scaled math multiplication factor for
> +        * nanosecond to apbt tick conversion.
> +        * mult = (nsec/cycle)*2^APBT_SHIFT
> +        */
> +       apbt_clockevent.mult = div_sc((unsigned long) mtmr->freq
> +                       , NSEC_PER_SEC, APBT_SHIFT);
> +
> +       /* Calculate the min / max delta */
> +       apbt_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
> +                                                          &apbt_clockevent);
> +       apbt_clockevent.min_delta_ns = clockevent_delta2ns(
> +                                               APBT_MIN_DELTA_USEC*apbt_freq,
> +                                               &apbt_clockevent);
> +       /*
> +        * Start apbt with the boot cpu mask and make it
> +        * global after the IO_APIC has been initialized.
> +        */
> +       apbt_clockevent.cpumask = cpumask_of(smp_processor_id());
> +       if (disable_apbt_percpu)
> +               apbt_clockevent.rating = APBT_CLOCKEVENT_RATING - 100;
> +
> +       clockevents_register_device(&apbt_clockevent);
> +       global_clock_event = &apbt_clockevent;
> +       printk(KERN_DEBUG "%s clockevent registered as global\n",
> +               global_clock_event->name);
> +       sfi_free_mtmr(mtmr);
> +       return 0;
> +}
> +#ifdef CONFIG_SMP
> +/* Should be called with per cpu */
> +static int apbt_clockevent_late_register(void)
> +{
> +       struct apbt_dev *adev;
> +       struct clock_event_device *aevt;
> +       int cpu;
> +       /* Don't register boot CPU clockevent */
> +       cpu = smp_processor_id();
> +       if (cpu == boot_cpu_id)
> +               return 0;
> +
> +       /*
> +        * We need to calculate the scaled math multiplication factor for
> +        * nanosecond to apbt tick conversion.
> +        * mult = (nsec/cycle)*2^APBT_SHIFT
> +        */
> +       printk(KERN_INFO "Init per CPU clockevent %d\n", cpu);
> +       adev = per_cpu(cpu_apbt_dev, cpu);
> +       aevt = &adev->evt;
> +       aevt->name = adev->name;
> +       aevt->shift = APBT_SHIFT;
> +       aevt->set_mode  = apb_timer_set_mode;
> +       aevt->event_handler = apbt_event_handler;
> +       aevt->set_next_event = apb_timer_next_event;
> +       aevt->mult = div_sc((unsigned long)apbt_freq * USEC_PER_SEC,
> +                               NSEC_PER_SEC, APBT_SHIFT);
> +       /* Calculate the min / max delta */
> +       aevt->max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
> +                          &apbt_clockevent);
> +       /* The min delta is tuned based on SCU FW performance */
> +       aevt->min_delta_ns = clockevent_delta2ns(APBT_MIN_DELTA_USEC*apbt_freq,
> +                                               &apbt_clockevent);
> +       aevt->cpumask = cpumask_of(smp_processor_id());
> +       aevt->irq = adev->irq;
> +       aevt->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC;
> +       aevt->rating = APBT_CLOCKEVENT_RATING;
> +       printk(KERN_INFO "Registering CPU %d clockevent device %s\n",
> +               cpu, aevt->name);
> +       clockevents_register_device(aevt);
> +       apbt_setup_irq(adev);
> +       apbt_enable_int(cpu);
> +       return 0;
> +}
> +
> +/* Initialize per CPU timer data structures based on SFI MTMR table */
> +static int apbt_cpuhp_notify(struct notifier_block *n,
> +               unsigned long action, void *hcpu)
> +{
> +       unsigned long cpu = (unsigned long)hcpu;
> +       struct apbt_dev *adev = per_cpu(cpu_apbt_dev, cpu);
> +       switch (action & 0xf) {
> +       case CPU_DEAD:
> +               if (adev) {
> +                       apbt_dbg("APBT clockevent for cpu %lu offline\n", cpu);
> +                       free_irq(adev->irq, adev);
> +               }
> +               break;
> +       }
> +       return NOTIFY_OK;
> +}
> +
> +static __init int apbt_late_init(void)
> +{
> +       if (disable_apbt_percpu)
> +               return 0;
> +       /* This notifier should be called after workqueue is ready */
> +       hotcpu_notifier(apbt_cpuhp_notify, -20);
> +       return 0;
> +}
> +fs_initcall(apbt_late_init);
> +
> +inline void apbt_setup_secondary_clock(void)
> +{
> +       if (!disable_apbt_percpu)
> +               apbt_clockevent_late_register();
> +       else
> +               setup_secondary_clock();
> +}
> +
> +#endif
> +
> +static void apb_timer_set_mode(enum clock_event_mode mode,
> +                         struct clock_event_device *evt)
> +{
> +       unsigned long ctrl;
> +       uint64_t delta;
> +       int timer_num;
> +#ifdef CONFIG_SMP
> +       struct apbt_dev *adev = EVT_TO_APBT_DEV(evt);
> +       timer_num = adev->num;
> +#else
> +       timer_num = 0;
> +#endif
> +       if ((timer_num < 0) || (timer_num > sfi_mtimer_num)) {
> +               printk(KERN_ERR "apbt: set mode for invalid timer %d\n",
> +                               timer_num);
> +               return;
> +       }
> +       apbt_dbg("%s CPU %d timer %d mode=%d\n",
> +               __func__, first_cpu(*evt->cpumask), timer_num, mode);
> +       switch (mode) {
> +       case CLOCK_EVT_MODE_PERIODIC:
> +               delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * apbt_clockevent.mult;
> +               delta >>= apbt_clockevent.shift;
> +               ctrl = apbt_readl(timer_num, APBTMR_0_CONTROL);
> +               ctrl |= APBTMR_CONTROL_MODE_PERIODIC;
> +               apbt_writel(timer_num, ctrl, APBTMR_0_CONTROL);
> +               /* DW APB p. 46, have to disable timer before load counter,
> +                * may cause sync problem.
> +                */
> +               ctrl &= ~APBTMR_CONTROL_ENABLE;
> +               apbt_writel(timer_num, ctrl, APBTMR_0_CONTROL);
> +               udelay(1);
> +               apbt_dbg("Setting clock period %d for HZ %d\n", (int)delta, HZ);
> +               apbt_writel(timer_num, delta, APBTMR_0_LOAD_COUNT);
> +               ctrl |= APBTMR_CONTROL_ENABLE;
> +               apbt_writel(timer_num, ctrl, APBTMR_0_CONTROL);
> +               break;
> +       /* APB timer does not have one-shot mode, use free running mode */
> +       case CLOCK_EVT_MODE_ONESHOT:
> +               ctrl = apbt_readl(timer_num, APBTMR_0_CONTROL);
> +               /* set free running mode, this mode will let timer reload max
> +                * timeout which will give time (3min on 25MHz clock) to rearm
> +                * the next event, therefore emulate the one-shot mode.
> +                */
> +               ctrl &= ~APBTMR_CONTROL_ENABLE;
> +               ctrl &= ~APBTMR_CONTROL_MODE_PERIODIC;
> +               ctrl &= ~APBTMR_CONTROL_INT;
> +               apbt_writel(timer_num, ctrl, APBTMR_0_CONTROL);
> +               /* write again to set free running mode */
> +               apbt_writel(timer_num, ctrl, APBTMR_0_CONTROL);
> +
> +               /* DW APB p. 46, load counter with all 1s before starting free
> +                * running mode.
> +               */
> +               apbt_writel(timer_num, ~0, APBTMR_0_LOAD_COUNT);
> +               ctrl |= APBTMR_CONTROL_ENABLE;
> +               /* Caution: this is slightly different than OS writers guide,
> +                * where new load count is loaded before enalbing timer.
> +               */
> +               apbt_writel(timer_num, ctrl, APBTMR_0_CONTROL);
> +               break;
> +
> +       case CLOCK_EVT_MODE_UNUSED:
> +       case CLOCK_EVT_MODE_SHUTDOWN:
> +               ctrl = apbt_readl(timer_num, APBTMR_0_CONTROL);
> +               ctrl &= ~APBTMR_CONTROL_ENABLE;
> +               apbt_writel(timer_num, ctrl, APBTMR_0_CONTROL);
> +               break;
> +
> +       case CLOCK_EVT_MODE_RESUME:
> +               apbt_enable_int(timer_num);
> +               break;
> +       }
> +}
> +
> +static int apb_timer_next_event(unsigned long delta,
> +                          struct clock_event_device *evt)
> +{
> +       unsigned long ctrl, current_cnt;
> +       unsigned int retry = 0;
> +       int timer_num;
> +#ifdef CONFIG_SMP
> +       struct apbt_dev *adev = EVT_TO_APBT_DEV(evt);
> +       timer_num = adev->num;
> +#else
> +       timer_num = 0;
> +#endif
> +retry:
> +       /* Disable timer */
> +       ctrl = apbt_readl(timer_num, APBTMR_0_CONTROL);
> +       ctrl &= ~APBTMR_CONTROL_ENABLE;
> +       apbt_writel(timer_num, ctrl, APBTMR_0_CONTROL);
> +       /* write new count */
> +       apbt_writel(timer_num, delta, APBTMR_0_LOAD_COUNT);
> +       ctrl |= APBTMR_CONTROL_ENABLE;
> +       apbt_writel(timer_num, ctrl, APBTMR_0_CONTROL);
> +       udelay(1);
> +       current_cnt = apbt_readl(timer_num, APBTMR_0_CURRENT_VALUE);
> +       if (current_cnt < delta)
> +               return 0;
> +       else if (retry++ < 5)
> +               goto retry;
> +       else
> +               return -ETIME;
> +}
> +
> +/*
> + * Clock source related code
> + */
> +static cycle_t apbt_read_clocksource(struct clocksource *cs)
> +{
> +       return (cycle_t)~apbt_readl(phy_cs_timer_id,
> +                               APBTMR_0_CURRENT_VALUE);
> +}
> +
> +static struct clocksource clocksource_apbt = {
> +       .name           = "apbt",
> +       .rating         = APBT_CLOCKSOURCE_RATING,
> +       .read           = apbt_read_clocksource,
> +       .mask           = APBT_MASK,
> +       .shift          = APBT_SHIFT,
> +       .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
> +       .resume         = apbt_restart_clocksource,
> +};
> +
> +static int apbt_clocksource_register(void)
> +{
> +       u64 start, now;
> +       cycle_t t1;
> +
> +       /* Start the counter, use timer 2 as source, timer 0/1 for event */
> +       apbt_start_counter(phy_cs_timer_id);
> +
> +       /* Verify whether apbt counter works */
> +       t1 = apbt_read_clocksource(&clocksource_apbt);
> +       rdtscll(start);
> +
> +       /*
> +        * We don't know the TSC frequency yet, but waiting for
> +        * 200000 TSC cycles is safe:
> +        * 4 GHz == 50us
> +        * 1 GHz == 200us
> +        */
> +       do {
> +               rep_nop();
> +               rdtscll(now);
> +       } while ((now - start) < 200000UL);
> +
> +       if (t1 == apbt_read_clocksource(&clocksource_apbt)) {
> +               printk(KERN_WARNING
> +                      "APBT counter not counting. APBT disabled\n");
> +               return -ENODEV;
> +       }
> +
> +       /* Initialize and register APBT clocksource
> +        * convert that to ns/clock cycle
> +        * mult = (ns/c) * 2^APBT_SHIFT
> +        */
> +       clocksource_apbt.mult = div_sc(MSEC_PER_SEC,
> +               (unsigned long) apbt_freq, APBT_SHIFT);
> +       clocksource_register(&clocksource_apbt);
> +
> +       return 0;
> +}
> +
> +/*
> + * Early setup the APBT timer, only use timer 0 for booting then switch to
> + * per CPU timer if possible.
> + */
> +int __init apbt_enable(void)
> +{
> +#ifdef CONFIG_SMP
> +       int i;
> +       struct sfi_mtimer_entry *p_mtmr;
> +       unsigned int percpu_timer;
> +#endif
> +       if (apb_timer_block_enabled)
> +               return 1;
> +       apbt_set_mapping();
> +       if (apbt_virt_address) {
> +               apbt_dbg("Found APBT version 0x%lx\n",\
> +                        apbt_readl_reg(APBTMRS_COMP_VERSION));
> +       } else
> +               goto out_noapbt;
> +       /*
> +        * Read the frequency and check for a sane value, for ESL model
> +        * we extend the possible clock range to allow time scaling.
> +        */
> +
> +       if (apbt_freq < APBT_MIN_FREQ || apbt_freq > APBT_MAX_FREQ) {
> +               apbt_dbg("APBT has invalid freq 0x%llx\n", apbt_freq);
> +               goto out_noapbt;
> +       }
> +       if (apbt_clocksource_register()) {
> +               apbt_dbg("APBT has failed to register clocksource\n");
> +               goto out_noapbt;
> +       }
> +       if (!apbt_clockevent_register())
> +               apb_timer_block_enabled = 1;
> +       else {
> +               apbt_dbg("APBT has failed to register clockevent\n");
> +               goto out_noapbt;
> +       }
> +#ifdef CONFIG_SMP
> +       /* kernel cmdline disable apb timer, so we will use lapic timers */
> +       if (disable_apbt_percpu) {
> +               printk(KERN_INFO "apbt: disabled per cpu timer\n");
> +               return 1;
> +       }
> +       apbt_dbg("%s: %d CPUs online\n", __func__, num_online_cpus());
> +       if (num_possible_cpus() <= 2 &&
> +           num_possible_cpus() <= sfi_mtimer_num) {
> +               percpu_timer = 1;
> +               apbt_num_timers_used = num_possible_cpus();
> +       } else {
> +               percpu_timer = 0;
> +               apbt_num_timers_used = 1;
> +               per_cpu(cpu_apbt_dev, 0) = NULL;
> +       }
> +       apbt_dbg("%s: %d APB timers used\n", __func__, apbt_num_timers_used);
> +
> +       /* here we set up per CPU timer data structure */
> +       apbt_devs = kzalloc(sizeof(struct apbt_dev) * apbt_num_timers_used,
> +                               GFP_KERNEL);
> +       if (!apbt_devs) {
> +               printk(KERN_ERR "Failed to allocate APB timer devices\n");
> +               return -ENODEV;
> +       }
> +       for (i = 0; i < apbt_num_timers_used; i++) {
> +               per_cpu(cpu_apbt_dev, i) = &apbt_devs[i];
> +               apbt_devs[i].num = i;
> +               apbt_devs[i].cpu = i;
> +               p_mtmr = sfi_get_mtmr(i);
> +               if (p_mtmr) {
> +                       apbt_devs[i].tick = p_mtmr->freq;
> +                       apbt_devs[i].irq = p_mtmr->irq;
> +               } else
> +                       printk(KERN_ERR "Failed to get timer for cpu %d\n", i);
> +               apbt_devs[i].count = 0;
> +               sprintf(apbt_devs[i].name, "apbt%d", i);
> +       }
> +
> +       /* Set up IRQ routing for the watchdog timer */
> +       p_mtmr = sfi_get_mtmr(sfi_mtimer_num);
> +       if (p_mtmr)
> +               arch_setup_apbt_irqs(p_mtmr->irq, 0, 0, 0);
> +       else
> +               printk(KERN_ERR
> +               "apbt: failed to setup watchdog timer %d IRQ routing\n", i);
> +       sfi_free_mtmr(p_mtmr);
> +#endif
> +
> +       return 1;
> +
> +out_noapbt:
> +       printk(KERN_DEBUG "failed to enable APB timer\n");
> +       apbt_clear_mapping();
> +       apb_timer_block_enabled = 0;
> +       return -ENODEV;
> +}
> +
> +void apbt_disable(int n)
> +{
> +       if (is_apbt_capable()) {
> +               unsigned long ctrl =  apbt_readl(n, APBTMR_0_CONTROL);
> +               ctrl &= ~APBTMR_CONTROL_ENABLE;
> +               apbt_writel(n, ctrl, APBTMR_0_CONTROL);
> +       }
> +}
> +
> +/* this function is used by CPU TSC calibration code, it replaces PIT counter
> + * for calibration base.
> + * timer 1 is used to count up at a known frequency which is obtained from
> + * SFI MTMR table.
> + */
> +void apbt_prepare_count(unsigned int msec)
> +{
> +       unsigned long ctrl, loadcount;
> +       apbt_set_mapping_early();
> +       if (apbt_virt_address) {
> +               apbt_dbg("Found APBT version 0x%lx\n",\
> +                        apbt_readl_reg(APBTMRS_COMP_VERSION));
> +       }
> +       loadcount = (unsigned long)apbt_freq * msec / MSEC_PER_SEC;
> +       apbt_dbg(KERN_INFO "%s prepare count up %lu for %d msec\n",\
> +                       __func__, loadcount, msec);
> +       ctrl = apbt_readl(phy_cs_timer_id, APBTMR_0_CONTROL);
> +       ctrl &= ~APBTMR_CONTROL_ENABLE;
> +       apbt_writel(phy_cs_timer_id, ctrl, APBTMR_0_CONTROL);
> +       apbt_writel(phy_cs_timer_id, loadcount, APBTMR_0_LOAD_COUNT);
> +       /* enable timer but mask interrupt, we only use raw int status */
> +       ctrl |= (APBTMR_CONTROL_ENABLE | APBTMR_CONTROL_MODE_PERIODIC |
> +               APBTMR_CONTROL_INT);
> +       apbt_writel(phy_cs_timer_id, ctrl, APBTMR_0_CONTROL);
> +}
> +
> +void apbt_countup(unsigned long *count_p)
> +{
> +       unsigned long raw_int_status = 0, count = 0, now = 0;
> +       /* let's poll raw interrupt status for timer 1 see if we have reached
> +        * calibration period.
> +        */
> +       while (!(raw_int_status & 0x2)) {
> +               count++;
> +               raw_int_status = apbt_readl_reg(APBTMRS_RAW_INT_STATUS);
> +               now = apbt_readl(phy_cs_timer_id, APBTMR_0_CURRENT_VALUE);
> +               /* can not exceed 30 ms at max freq */
> +               if (count > APBT_MAX_FREQ * 30000) {
> +                       printk(KERN_ERR "APBT countup err, limit exceeded\n");
> +                       *count_p = -1;
> +                       return;
> +               }
> +       }
> +       *count_p = count;
> +       apbt_dbg(KERN_INFO "raw int status 0x%lx, now 0x%lx, count 0x%lx\n",
> +               raw_int_status, now, count);
> +}
> +/* called before apb_timer_enable, use early map */
> +unsigned long apbt_quick_calibrate()
> +{
> +       int i, scale;
> +       u64 old, new;
> +       cycle_t t1, t2;
> +       unsigned long khz = 0;
> +       u32 freq, loop, shift;
> +
> +       freq = sfi_mtimer_array[0].freq;
> +
> +       apbt_set_mapping_early();
> +       apbt_start_counter(phy_cs_timer_id);
> +
> +       /* check if the timer can count down, otherwise return */
> +       old = apbt_read_clocksource(&clocksource_apbt);
> +       i = 10000;
> +       while (--i) {
> +               if (old != apbt_read_clocksource(&clocksource_apbt))
> +                       break;
> +       }
> +       if (!i)
> +               goto failed;
> +
> +       /* count 16 ms */
> +       loop = (freq / 1000) << 4;
> +
> +       /* restart the timer to makesure it won't get to 0 in the calibration */
> +       apbt_start_counter(phy_cs_timer_id);
> +       t1 = __native_read_tsc();
> +
> +       old = apbt_read_clocksource(&clocksource_apbt);
> +       old += loop;
> +       do {
> +               new = apbt_read_clocksource(&clocksource_apbt);
> +       } while (new < old);
> +
> +       t2 = __native_read_tsc();
> +
> +       shift = 5;
> +       if (unlikely(loop >> shift == 0)) {
> +               printk(KERN_INFO
> +               "APBT TSC calibration failed, not enough resolution\n");
> +               return 0;
> +       }
> +       scale = (int)div_u64((t2 - t1), loop >> shift);
> +       khz = (scale * (freq / 1000)) >> shift;
> +       printk(KERN_INFO "TSC freq calculated by APB timer is %lu khz\n", khz);
> +       return khz;
> +failed:
> +       return 0;
> +}
> diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
> index 5c5d87f..96b1c6f 100644
> --- a/arch/x86/kernel/time_32.c
> +++ b/arch/x86/kernel/time_32.c
> @@ -35,8 +35,10 @@
> 
>  #include <asm/setup.h>
>  #include <asm/hpet.h>
> +#include <asm/apb_timer.h>
>  #include <asm/time.h>
>  #include <asm/timer.h>
> +#include <asm/platform_feature.h>
> 
>  #include <asm/do_timer.h>
> 
> @@ -78,7 +80,7 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
>         inc_irq_stat(irq0_irqs);
> 
>  #ifdef CONFIG_X86_IO_APIC
> -       if (timer_ack) {
> +       if (timer_ack && platform_has(X86_PLATFORM_FEATURE_8259)) {
>                 /*
>                  * Subtle, when I/O APICs are used we have to ack timer IRQ
>                  * manually to deassert NMI lines for the watchdog if run
> @@ -118,9 +120,26 @@ void __init hpet_time_init(void)
>  {
>         if (!hpet_enable())
>                 setup_pit_timer();
> +}
> +#ifndef CONFIG_PARAVIRT
> +static inline void __init native_time_init(void)
> +{
> +       if (platform_has(X86_PLATFORM_FEATURE_HPET))
> +               hpet_time_init();
> +       else if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
> +               apbt_enable();
> +       } else {
> +               /* should not get here, at least one timer should be found */
> +               BUG();
> +       }
>         x86_quirk_time_init();
>  }
> +static inline void (*choose_time_init(void))(void)
> +{
> +       return native_time_init;
> +}
> 
> +#endif
>  /*
>   * This is called directly from init code; we must delay timer setup in the
>   * HPET case as we can't make the decision to turn on HPET this early in the
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 6e1a368..88827a5 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -17,6 +17,9 @@
>  #include <asm/time.h>
>  #include <asm/delay.h>
>  #include <asm/hypervisor.h>
> +#include <asm/platform_feature.h>
> + /* for Moorewtown platform */
> + #include <asm/apb_timer.h>
> 
>  unsigned int __read_mostly cpu_khz;    /* TSC clocks / usec, not used here */
>  EXPORT_SYMBOL(cpu_khz);
> @@ -394,6 +397,14 @@ unsigned long native_calibrate_tsc(void)
>                 return hv_tsc_khz;
>         }
> 
> +       /* first check if apb timer exist and is usable */
> +       if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
> +               local_irq_save(flags);
> +               fast_calibrate = apbt_quick_calibrate();
> +               local_irq_restore(flags);
> +               if (fast_calibrate)
> +                       return fast_calibrate;
> +       }
>         local_irq_save(flags);
>         fast_calibrate = quick_pit_calibrate();
>         local_irq_restore(flags);
> @@ -655,7 +666,7 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
>         if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
>                         (val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
>                         (val == CPUFREQ_RESUMECHANGE)) {
> -               *lpj =  cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
> +               *lpj = cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
> 
>                 tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
>                 if (!(freq->flags & CPUFREQ_CONST_LOOPS))
> @@ -892,4 +903,3 @@ void __init tsc_init(void)
>         check_system_tsc_reliable();
>         init_tsc_clocksource();
>  }

Same general stylistic and structural objections as with the 9/9 
patch. We can do a lot cleaner and nicer than this.

	Ingo
