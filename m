Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZLDDM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZLDDM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 22:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZLDDMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 22:12:54 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:35326 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZLDDMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 22:12:53 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC][PATCH 03/10] arm: mxc: changes to common plat-mxc code to add support for i.MX5
Date: Thu, 3 Dec 2009 20:12:58 -0700
Message-ID: <DE2504B3A515524BBE6934369EFDC0DA08C2A56C@az33exm20.fsl.freescale.net>
In-Reply-To: <58eb7d14c6cf56cbc874657dff5789c47116b49e.1259893118.git.amit.kucheria@canonical.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 03/10] arm: mxc: changes to common plat-mxc code to add support for i.MX5
Thread-Index: Acp0jDMu1VPEEtKHRSW818DMi/DhswAALnzw
References: <cover.1259893118.git.amit.kucheria@canonical.com> <58eb7d14c6cf56cbc874657dff5789c47116b49e.1259893118.git.amit.kucheria@canonical.com>
From: "Herring Robert-RA7055" <ra7055@freescale.com>
To: "Amit Kucheria" <amit.kucheria@canonical.com>,
       "List Linux Kernel" <linux-kernel@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <s.hauer@pengutronix.de>,
       <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
       <grant.likely@secretlab.ca>,
       "Nguyen Dinh-R00091" <R00091@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit,

I would suggest you refactor the timer code into version 1 and version 2
either as 2 separate files or with a timer_is_v2() function rather than
the mess of cpu_is_X macros it currently has. Essentially there are 2
versions of the timer hardware. Version 1 is found on MX1/MXL and MX21.
Version 2 is found on MX25, MX27, MX31, MX35, MX37, MX51, and future
parts. I will send you what we have done in our tree.


> +#ifndef CONFIG_ARCH_MX5
>  #define MXC_INTERNAL_IRQS	64
> +#else
> +#define MXC_INTERNAL_IRQS	128
> +#endif

The number of internal interrupts is a function of having the TZIC or
AVIC, so using the TZIC config option would be a better option:

#ifdef CONFIG_MXC_TZIC
#define MXC_INTERNAL_IRQS	128
#else
#define MXC_INTERNAL_IRQS	64
#endif

Regards,
Rob

> -----Original Message-----
> From: Amit Kucheria [mailto:amit.kucheria@verdurent.com] On 
> Behalf Of Amit Kucheria
> Sent: Thursday, December 03, 2009 8:47 PM
> To: List Linux Kernel
> Cc: linux-arm-kernel@lists.infradead.org; 
> s.hauer@pengutronix.de; valentin.longchamp@epfl.ch; 
> daniel@caiaq.de; grant.likely@secretlab.ca; Nguyen 
> Dinh-R00091; Herring Robert-RA7055
> Subject: [RFC][PATCH 03/10] arm: mxc: changes to common 
> plat-mxc code to add support for i.MX5
> 
> Changes separted to help in the review process
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/plat-mxc/include/mach/common.h      |    3 +
>  arch/arm/plat-mxc/include/mach/debug-macro.S |    9 ++++
>  arch/arm/plat-mxc/include/mach/entry-macro.S |   34 ++++++++++++++++-
>  arch/arm/plat-mxc/include/mach/hardware.h    |    4 ++
>  arch/arm/plat-mxc/include/mach/irqs.h        |    9 ++++-
>  arch/arm/plat-mxc/include/mach/memory.h      |    3 +
>  arch/arm/plat-mxc/include/mach/mxc.h         |   13 ++++++
>  arch/arm/plat-mxc/include/mach/timex.h       |    2 +
>  arch/arm/plat-mxc/time.c                     |   52 
> +++++++++++++++++++++++++-
>  9 files changed, 126 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/include/mach/common.h 
> b/arch/arm/plat-mxc/include/mach/common.h
> index 286cb9b..b649382 100644
> --- a/arch/arm/plat-mxc/include/mach/common.h
> +++ b/arch/arm/plat-mxc/include/mach/common.h
> @@ -20,6 +20,7 @@ extern void mx25_map_io(void);
>  extern void mx27_map_io(void);
>  extern void mx31_map_io(void);
>  extern void mx35_map_io(void);
> +extern void mx51_map_io(void);
>  extern void mxc91231_map_io(void);
>  extern void mxc_init_irq(void __iomem *);
>  extern void mx1_init_irq(void);
> @@ -28,6 +29,7 @@ extern void mx25_init_irq(void);
>  extern void mx27_init_irq(void);
>  extern void mx31_init_irq(void);
>  extern void mx35_init_irq(void);
> +extern void mx51_init_irq(void);
>  extern void mxc91231_init_irq(void);
>  extern void mxc_timer_init(struct clk *timer_clk, void 
> __iomem *, int);
>  extern int mx1_clocks_init(unsigned long fref);
> @@ -36,6 +38,7 @@ extern int mx25_clocks_init(unsigned long fref);
>  extern int mx27_clocks_init(unsigned long fref);
>  extern int mx31_clocks_init(unsigned long fref);
>  extern int mx35_clocks_init(void);
> +extern int mx51_clocks_init(unsigned long ckil, unsigned 
> long osc, unsigned long ckih1, unsigned long ckih2);
>  extern int mxc91231_clocks_init(unsigned long fref);
>  extern int mxc_register_gpios(void);
>  extern int mxc_register_device(struct platform_device *pdev, 
> void *data);
> diff --git a/arch/arm/plat-mxc/include/mach/debug-macro.S 
> b/arch/arm/plat-mxc/include/mach/debug-macro.S
> index 15b2b14..9fe7300 100644
> --- a/arch/arm/plat-mxc/include/mach/debug-macro.S
> +++ b/arch/arm/plat-mxc/include/mach/debug-macro.S
> @@ -44,6 +44,15 @@
>  #define UART_VADDR	AIPS1_IO_ADDRESS(UART1_BASE_ADDR)
>  #endif
>  
> +#ifdef CONFIG_ARCH_MX5
> +#ifdef UART_PADDR
> +#error "CONFIG_DEBUG_LL is incompatible with multiple archs"
> +#endif
> +#include <mach/mx51.h>
> +#define UART_PADDR	UART1_BASE_ADDR
> +#define UART_VADDR	AIPS1_IO_ADDRESS(UART1_BASE_ADDR)
> +#endif
> +
>  #ifdef CONFIG_ARCH_MXC91231
>  #ifdef UART_PADDR
>  #error "CONFIG_DEBUG_LL is incompatible with multiple archs"
> diff --git a/arch/arm/plat-mxc/include/mach/entry-macro.S 
> b/arch/arm/plat-mxc/include/mach/entry-macro.S
> index 7cf290e..e48948f 100644
> --- a/arch/arm/plat-mxc/include/mach/entry-macro.S
> +++ b/arch/arm/plat-mxc/include/mach/entry-macro.S
> @@ -1,6 +1,6 @@
>  /*
>   *  Copyright (C) 2007 Lennert Buytenhek <buytenh@wantstofly.org>
> - *  Copyright 2004-2007 Freescale Semiconductor, Inc. All 
> Rights Reserved.
> + *  Copyright 2004-2009 Freescale Semiconductor, Inc. All 
> Rights Reserved.
>   */
>  
>  /*
> @@ -18,11 +18,16 @@
>  	.endm
>  
>  	.macro  get_irqnr_preamble, base, tmp
> +#ifndef CONFIG_MXC_TZIC
>  	ldr	\base, =avic_base
>  	ldr	\base, [\base]
>  #ifdef CONFIG_MXC_IRQ_PRIOR
>  	ldr	r4, [\base, #AVIC_NIMASK]
>  #endif
> +#elif defined CONFIG_MXC_TZIC
> +	ldr	\base, =tzic_base
> +	ldr	\base, [\base]
> +#endif /* CONFIG_MXC_TZIC */
>  	.endm
>  
>  	.macro  arch_ret_to_user, tmp1, tmp2
> @@ -32,6 +37,7 @@
>  	@ and returns its number in irqnr
>  	@ and returns if an interrupt occured in irqstat
>  	.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
> +#ifndef CONFIG_MXC_TZIC
>  	@ Load offset & priority of the highest priority
>  	@ interrupt pending from AVIC_NIVECSR
>  	ldr	\irqstat, [\base, #0x40]
> @@ -45,6 +51,32 @@
>  	strne	\tmp, [\base, #AVIC_NIMASK]
>  	streq	r4, [\base, #AVIC_NIMASK]
>  #endif
> +#elif defined CONFIG_MXC_TZIC
> +	@ Load offset & priority of the highest priority
> +	@ interrupt pending.
> +	@ 0xD80 is HIPND0 register
> +	ldr     \irqnr, =0
> +	ldr     \irqstat, =0x0D80
> +1000:
> +	ldr     \tmp,   [\irqstat, \base]
> +	cmp     \tmp, #0
> +	bne     1001f
> +	addeq   \irqnr, \irqnr, #32
> +	addeq   \irqstat, \irqstat, #4
> +	cmp     \irqnr, #128
> +	blo     1000b
> +	b       2001f
> +1001:	ldr     \irqstat, =1
> +1002:	tst     \tmp, \irqstat
> +	bne     2002f
> +	movs    \tmp, \tmp, lsr #1
> +	addne   \irqnr, \irqnr, #1
> +	bne     1002b
> +2001:
> +	ldr  \irqnr, =0
> +2002:
> +	movs \irqnr, \irqnr
> +#endif
>  	.endm
>  
>  	@ irq priority table (not used)
> diff --git a/arch/arm/plat-mxc/include/mach/hardware.h 
> b/arch/arm/plat-mxc/include/mach/hardware.h
> index 78db754..55ebe88 100644
> --- a/arch/arm/plat-mxc/include/mach/hardware.h
> +++ b/arch/arm/plat-mxc/include/mach/hardware.h
> @@ -22,6 +22,10 @@
>  
>  #include <asm/sizes.h>
>  
> +#ifdef CONFIG_ARCH_MX5
> +#include <mach/mx51.h>
> +#endif
> +
>  #ifdef CONFIG_ARCH_MX3
>  #include <mach/mx3x.h>
>  #include <mach/mx31.h>
> diff --git a/arch/arm/plat-mxc/include/mach/irqs.h 
> b/arch/arm/plat-mxc/include/mach/irqs.h
> index ead9d59..8740514 100644
> --- a/arch/arm/plat-mxc/include/mach/irqs.h
> +++ b/arch/arm/plat-mxc/include/mach/irqs.h
> @@ -12,9 +12,13 @@
>  #define __ASM_ARCH_MXC_IRQS_H__
>  
>  /*
> - * So far all i.MX SoCs have 64 internal interrupts
> + * All i.MX SoCs have 64 internal interrupts, except IMX51 
> which has 128
>   */
> +#ifndef CONFIG_ARCH_MX5
>  #define MXC_INTERNAL_IRQS	64
> +#else
> +#define MXC_INTERNAL_IRQS	128
> +#endif
>  
>  #define MXC_GPIO_IRQ_START	MXC_INTERNAL_IRQS
>  
> @@ -26,6 +30,8 @@
>  #define MXC_GPIO_IRQS		(32 * 3)
>  #elif defined CONFIG_ARCH_MX25
>  #define MXC_GPIO_IRQS		(32 * 4)
> +#elif defined CONFIG_ARCH_MX5
> +#define MXC_GPIO_IRQS		(32 * 4)
>  #elif defined CONFIG_ARCH_MXC91231
>  #define MXC_GPIO_IRQS		(32 * 4)
>  #endif
> @@ -46,6 +52,7 @@
>  #else
>  #define MX3_IPU_IRQS 0
>  #endif
> +/* REVISIT: Add IPU irqs on IMX51 */
>  
>  #define NR_IRQS			(MXC_IPU_IRQ_START + 
> MX3_IPU_IRQS)
>  
> diff --git a/arch/arm/plat-mxc/include/mach/memory.h 
> b/arch/arm/plat-mxc/include/mach/memory.h
> index d3afafd..e46626e 100644
> --- a/arch/arm/plat-mxc/include/mach/memory.h
> +++ b/arch/arm/plat-mxc/include/mach/memory.h
> @@ -27,6 +27,9 @@
>  #elif defined CONFIG_ARCH_MXC91231
>  #define PHYS_OFFSET		UL(0x90000000)
>  #endif
> +#ifdef CONFIG_ARCH_MX5
> +#define PHYS_OFFSET             UL(0x90000000)
> +#endif
>  
>  #if defined(CONFIG_MX1_VIDEO)
>  /*
> diff --git a/arch/arm/plat-mxc/include/mach/mxc.h 
> b/arch/arm/plat-mxc/include/mach/mxc.h
> index 5199053..555e5f8 100644
> --- a/arch/arm/plat-mxc/include/mach/mxc.h
> +++ b/arch/arm/plat-mxc/include/mach/mxc.h
> @@ -30,6 +30,7 @@
>  #define MXC_CPU_MX27		27
>  #define MXC_CPU_MX31		31
>  #define MXC_CPU_MX35		35
> +#define MXC_CPU_MX51		51
>  #define MXC_CPU_MXC91231	91231
>  
>  #ifndef __ASSEMBLY__
> @@ -108,6 +109,18 @@ extern unsigned int __mxc_cpu_type;
>  # define cpu_is_mx35()		(0)
>  #endif
>  
> +#ifdef CONFIG_ARCH_MX5
> +# ifdef mxc_cpu_type
> +#  undef mxc_cpu_type
> +#  define mxc_cpu_type __mxc_cpu_type
> +# else
> +#  define mxc_cpu_type MXC_CPU_MX51
> +# endif
> +# define cpu_is_mx51()		(mxc_cpu_type == MXC_CPU_MX51)
> +#else
> +# define cpu_is_mx51()		(0)
> +#endif
> +
>  #ifdef CONFIG_ARCH_MXC91231
>  # ifdef mxc_cpu_type
>  #  undef mxc_cpu_type
> diff --git a/arch/arm/plat-mxc/include/mach/timex.h 
> b/arch/arm/plat-mxc/include/mach/timex.h
> index 527a6c2..024416e 100644
> --- a/arch/arm/plat-mxc/include/mach/timex.h
> +++ b/arch/arm/plat-mxc/include/mach/timex.h
> @@ -28,6 +28,8 @@
>  #define CLOCK_TICK_RATE		16625000
>  #elif defined CONFIG_ARCH_MX25
>  #define CLOCK_TICK_RATE		16000000
> +#elif defined CONFIG_ARCH_MX5
> +#define CLOCK_TICK_RATE		8000000
>  #elif defined CONFIG_ARCH_MXC91231
>  #define CLOCK_TICK_RATE		13000000
>  #endif
> diff --git a/arch/arm/plat-mxc/time.c b/arch/arm/plat-mxc/time.c
> index 844567e..97fb590 100644
> --- a/arch/arm/plat-mxc/time.c
> +++ b/arch/arm/plat-mxc/time.c
> @@ -25,6 +25,7 @@
>  #include <linux/irq.h>
>  #include <linux/clockchips.h>
>  #include <linux/clk.h>
> +#include <linux/delay.h>
>  
>  #include <mach/hardware.h>
>  #include <asm/mach/time.h>
> @@ -57,6 +58,19 @@
>  #define MX3_TCN			0x24
>  #define MX3_TCMP		0x10
>  
> +/* MX51 */
> +#define MX51_TCTL_FRR		(1 << 9)
> +#define MX51_TCTL_VAL		(2 << 6) /* 
> ipg_clk_highfreq is source */
> +#define MX51_TCTL_TEN		(1 << 0) /* Enable module */
> +#define MX51_TCTL_TEN_MODE	(1 << 1) /* Reset counter when 
> module disabled */
> +#define MX51_TCTL_WAITEN	(1 << 3) /* Wait enable mode */
> +#define MX51_TCTL_INT_ENABLE	(1 << 0) /* Output compare 1 */
> +#define MX51_IR			0x0c
> +#define MX51_TSTAT		0x08
> +#define MX51_TSTAT_OF1		(1 << 0)
> +#define MX51_TCN		0x24
> +#define MX51_TCMP		0x10
> +
>  static struct clock_event_device clockevent_mxc;
>  static enum clock_event_mode clockevent_mode = CLOCK_EVT_MODE_UNUSED;
>  
> @@ -68,6 +82,8 @@ static inline void gpt_irq_disable(void)
>  
>  	if (cpu_is_mx3() || cpu_is_mx25())
>  		__raw_writel(0, timer_base + MX3_IR);
> +	else if (cpu_is_mx51())
> +		__raw_writel(0, timer_base + MX51_IR);
>  	else {
>  		tmp = __raw_readl(timer_base + MXC_TCTL);
>  		__raw_writel(tmp & ~MX1_2_TCTL_IRQEN, 
> timer_base + MXC_TCTL);
> @@ -78,6 +94,8 @@ static inline void gpt_irq_enable(void)
>  {
>  	if (cpu_is_mx3() || cpu_is_mx25())
>  		__raw_writel(1<<0, timer_base + MX3_IR);
> +	else if (cpu_is_mx51())
> +		__raw_writel(1<<0, timer_base + MX51_IR);
>  	else {
>  		__raw_writel(__raw_readl(timer_base + MXC_TCTL) 
> | MX1_2_TCTL_IRQEN,
>  			timer_base + MXC_TCTL);
> @@ -92,6 +110,8 @@ static void gpt_irq_acknowledge(void)
>  		__raw_writel(MX2_TSTAT_CAPT | MX2_TSTAT_COMP, 
> timer_base + MX1_2_TSTAT);
>  	if (cpu_is_mx3() || cpu_is_mx25())
>  		__raw_writel(MX3_TSTAT_OF1, timer_base + MX3_TSTAT);
> +	if (cpu_is_mx51())
> +		__raw_writel(MX51_TSTAT_OF1, timer_base + MX51_TSTAT);
>  }
>  
>  static cycle_t mx1_2_get_cycles(struct clocksource *cs)
> @@ -104,6 +124,11 @@ static cycle_t mx3_get_cycles(struct 
> clocksource *cs)
>  	return __raw_readl(timer_base + MX3_TCN);
>  }
>  
> +static cycle_t mx51_get_cycles(struct clocksource *cs)
> +{
> +	return __raw_readl(timer_base + MX51_TCN);
> +}
> +
>  static struct clocksource clocksource_mxc = {
>  	.name 		= "mxc_timer1",
>  	.rating		= 200,
> @@ -119,6 +144,8 @@ static int __init 
> mxc_clocksource_init(struct clk *timer_clk)
>  
>  	if (cpu_is_mx3() || cpu_is_mx25())
>  		clocksource_mxc.read = mx3_get_cycles;
> +	if (cpu_is_mx51())
> +		clocksource_mxc.read = mx51_get_cycles;
>  
>  	clocksource_mxc.mult = clocksource_hz2mult(c,
>  					clocksource_mxc.shift);
> @@ -155,6 +182,19 @@ static int mx3_set_next_event(unsigned long evt,
>  				-ETIME : 0;
>  }
>  
> +static int mx51_set_next_event(unsigned long evt,
> +			      struct clock_event_device *unused)
> +{
> +	unsigned long tcmp;
> +
> +	tcmp = __raw_readl(timer_base + MX51_TCN) + evt;
> +
> +	__raw_writel(tcmp, timer_base + MX51_TCMP);
> +
> +	return (int)(tcmp - __raw_readl(timer_base + MX51_TCN)) < 0 ?
> +				-ETIME : 0;
> +}
> +
>  #ifdef DEBUG
>  static const char *clock_event_mode_label[] = {
>  	[CLOCK_EVT_MODE_PERIODIC] = "CLOCK_EVT_MODE_PERIODIC",
> @@ -183,6 +223,9 @@ static void mxc_set_mode(enum 
> clock_event_mode mode,
>  		if (cpu_is_mx3() || cpu_is_mx25())
>  			__raw_writel(__raw_readl(timer_base + 
> MX3_TCN) - 3,
>  					timer_base + MX3_TCMP);
> +		else if (cpu_is_mx51())
> +			__raw_writel(__raw_readl(timer_base + 
> MX51_TCN) - 3,
> +					timer_base + MX51_TCMP);
>  		else
>  			__raw_writel(__raw_readl(timer_base + 
> MX1_2_TCN) - 3,
>  					timer_base + MX1_2_TCMP);
> @@ -235,6 +278,8 @@ static irqreturn_t 
> mxc_timer_interrupt(int irq, void *dev_id)
>  
>  	if (cpu_is_mx3() || cpu_is_mx25())
>  		tstat = __raw_readl(timer_base + MX3_TSTAT);
> +	if (cpu_is_mx51())
> +		tstat = __raw_readl(timer_base + MX51_TSTAT);
>  	else
>  		tstat = __raw_readl(timer_base + MX1_2_TSTAT);
>  
> @@ -266,6 +311,8 @@ static int __init 
> mxc_clockevent_init(struct clk *timer_clk)
>  
>  	if (cpu_is_mx3() || cpu_is_mx25())
>  		clockevent_mxc.set_next_event = mx3_set_next_event;
> +	if (cpu_is_mx51())
> +		clockevent_mxc.set_next_event = mx51_set_next_event;
>  
>  	clockevent_mxc.mult = div_sc(c, NSEC_PER_SEC,
>  					clockevent_mxc.shift);
> @@ -298,7 +345,10 @@ void __init mxc_timer_init(struct clk 
> *timer_clk, void __iomem *base, int irq)
>  
>  	if (cpu_is_mx3() || cpu_is_mx25())
>  		tctl_val = MX3_TCTL_CLK_IPG | MX3_TCTL_FRR | 
> MX3_TCTL_WAITEN | MXC_TCTL_TEN;
> -	else
> +	else if (cpu_is_mx51()) {
> +		tctl_val = MX51_TCTL_FRR | MX51_TCTL_VAL | 
> MX51_TCTL_WAITEN | MX51_TCTL_TEN;
> +		__raw_writel(MX51_TCTL_INT_ENABLE, timer_base + 
> MX51_IR);
> +	} else
>  		tctl_val = MX1_2_TCTL_FRR | 
> MX1_2_TCTL_CLK_PCLK1 | MXC_TCTL_TEN;
>  
>  	__raw_writel(tctl_val, timer_base + MXC_TCTL);
> -- 
> 1.6.3.3
> 
> 
> 
