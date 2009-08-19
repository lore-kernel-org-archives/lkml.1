Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZHSPvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZHSPvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZHSPvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:51:11 -0400
Received: from www.tglx.de ([62.245.132.106]:49897 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbZHSPvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:51:09 -0400
Date: Wed, 19 Aug 2009 17:49:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 6/10] x86/apbt: Moorestown APB system timer driver
In-Reply-To: <43F901BD926A4E43B106BF17856F0755643EBDF8@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0908191659080.3361@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F0755643EBDF8@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob,

On Thu, 16 Jul 2009, Pan, Jacob jun wrote:
> +config APB_TIMER
> +       def_bool y
> +       depends on SFI && MRST
> +       prompt "Langwell APB Timer Support" if X86_32
> +       help
> +       APB timer is the replacement for 8254, HPET on X86 MID platforms.

  	  help
	    APB .....

> +       The APBT provides a stable time base on SMP
> +       systems, unlike the TSC, but it is more expensive to access,
> +       as it is off-chip. APB timers are always running regardless of CPU
> +       C states, they are used as per CPU clockevent device when possible.
> +
> +       Must choose Y if you are running Intel Moorestown platform.

  Why is this selectable if you must select it for moorestown ? No
  extra config switch necessary.
 
> +++ b/arch/x86/kernel/apb_timer.c
> + * It is also worth notice that APB timer does not support true one-shot mode,
> + * free-running mode will be used here to emulate one-shot mode.
> + * APB timer can also be used as broadcast timer along with per cpu local APIC
> + * timer, but by default APB timer has higher rating than local APIC timers.

  Why ? Also why do you need the extra clock init quirks when your
  rating will select the APB timer anyway.

> + */
> +
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

missing new line

> +#define APBT_MASK      CLOCKSOURCE_MASK(32)
> +#define APBT_SHIFT                     22
> +#define APBT_CLOCKEVENT_RATING         150
> +#define APBT_CLOCKSOURCE_RATING                250
> +#define APBT_MIN_DELTA_USEC            200
> +
> +#undef APBT_DEBUG
> +#ifdef APBT_DEBUG
> +#      define apbt_dbg(fmt, args...) \
> +       do { printk(KERN_DEBUG "apbt:" fmt, ## args); } while (0)
> +#else
> +#      define apbt_dbg(fmt, args...) do { } while (0)
> +#endif

Please do not invent the next debugprint macro. pr_debug() is what's
already there

> +static int disable_apbt_percpu __cpuinitdata;
> +
> +#ifdef CONFIG_SMP
> +static unsigned int apbt_num_timers_used;
> +static DEFINE_PER_CPU(struct apbt_dev *, cpu_apbt_dev);
> +static struct apbt_dev *apbt_devs;
> +#endif
> +
> +static  inline unsigned long apbt_readl_reg(unsigned long a)
> +{
> +       unsigned long data;
> +
> +       data = readl(apbt_virt_address + a);
> +       return data;

  return readl(apbt_virt_address + a); please

> +}
> +
> +static inline void apbt_writel_reg(unsigned long d, unsigned long a)
> +{
> +       writel(d, apbt_virt_address + a);
> +}
> +
> +static inline unsigned long apbt_readl(int n, unsigned long a)
> +{
> +       unsigned long data;
> +
> +       data = readl(apbt_virt_address + a + n * APBTMRS_REG_SIZE);
> +       return data;

  ditto

> +}
> +
> +static inline void apbt_writel(int n, unsigned long d, unsigned long a)
> +{
> +       writel(d, apbt_virt_address + a + n * APBTMRS_REG_SIZE);
> +}
> +
> +/*
> + * used for TSC calibration which is before mem_init() so that ioremap() can
> + * not be used. use fixmap instead. this is boot only.
> + */

Err. We do hpet based TSC calibration late at least we used to do
so. Seems the code got changed, which is a different problem which
I'll look into in a minute.

> +static inline void apbt_set_mapping(void)
> +{
> +       struct sfi_mtimer_entry *mtmr;
> +
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

  Isn't the box completely dead when we fail to set up the APBT timer ?

> +static void __init apbt_event_handler(struct clock_event_device *dev)
> +{
> +       return;
> +}

  What's that for ?

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
> +/* boot APB clock event device */
> +static struct clock_event_device apbt_clockevent = {
> +       .name           = "apbt0",
> +       .features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +       .set_mode       = apb_timer_set_mode,
> +       .event_handler  = apbt_event_handler,

  No, that's wrong. The event handler is set by the clock events code.

> +       .set_next_event = apb_timer_next_event,
> +       .shift          = APBT_SHIFT,
> +       .irq            = 0,
> +       .rating         = APBT_CLOCKEVENT_RATING,
> +};

> +#ifdef CONFIG_SMP
> +static irqreturn_t apbt_interrupt_handler(int irq, void *data)
> +{
> +       struct apbt_dev *dev = (struct apbt_dev *)data;
> +       struct clock_event_device *aevt = &dev->evt;
> +
> +       if (!aevt->event_handler) {
> +               printk(KERN_INFO "Spurious APBT timer interrupt on %d\n",
> +                               dev->num);

  Why should this happen ?

> +               return IRQ_HANDLED;

  And why do you return handled ?

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
> +
> +/* Setup IRQ routing via IOAPIC */
> +#ifdef CONFIG_SMP
> +static void apbt_setup_irq(struct apbt_dev *adev)
> +{
> +       /* timer0 irq has been setup early */
> +       if (adev->irq == 0)
> +               return;
> +       disable_irq(adev->irq);
> +       irq_set_affinity(adev->irq, cpumask_of(adev->cpu));

  The clock events code takes care of affinity settings when you
  register the clock source as a per cpu clock source.

> +       /* enable irq descriptor */
> +       enable_irq(adev->irq);
> +       /* setup routing in interrupt controller chip */
> +       arch_setup_apbt_irqs(adev->irq, 0, 0, adev->cpu);

  Eew. The irq affinity code calls the irqchip->set_affinity
  function. So this function should take care of the irq routing.

> +       if (request_irq(adev->irq, apbt_interrupt_handler,
> +                       IRQF_DISABLED|IRQF_NOBALANCING, adev->name, adev)) {
> +               printk(KERN_ERR "Failed request IRQ for APBT%d\n", adev->num);
> +       }
> +}
> +#endif
> +
> +static void apbt_enable_int(int n)
> +{
> +       unsigned long ctrl = apbt_readl(n, APBTMR_N_CONTROL);
> +
> +       ctrl &= ~APBTMR_CONTROL_INT;
> +       apbt_writel(n, ctrl, APBTMR_N_CONTROL);
> +}
> +
> +static int apbt_clockevent_register(void)
> +{
> +       struct sfi_mtimer_entry *mtmr;
> +
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

  Why do we make it global ? If the timers are used as per cpu timers
  then you do not need that.

> +        */
> +       apbt_clockevent.cpumask = cpumask_of(smp_processor_id());
> +       if (disable_apbt_percpu)
> +               apbt_clockevent.rating = APBT_CLOCKEVENT_RATING - 100;
> +
> +       clockevents_register_device(&apbt_clockevent);
> +       global_clock_event = &apbt_clockevent;

  Hmm. Not sure about that.

> +       printk(KERN_DEBUG "%s clockevent registered as global\n",
> +               global_clock_event->name);
> +       sfi_free_mtmr(mtmr);

  Why do we free the timer if we use it ?


> +       return 0;
> +}
> +
> +#ifdef CONFIG_SMP
> +/* Should be called with per cpu */
> +static int apbt_clockevent_late_register(void)
> +{
> +       struct apbt_dev *adev;
> +       struct clock_event_device *aevt;
> +       int cpu;
> +
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

  Wrong, is set by the clock events code

> +       aevt->set_next_event = apb_timer_next_event;
> +       aevt->mult = div_sc((unsigned long)apbt_freq * USEC_PER_SEC,
> +                               NSEC_PER_SEC, APBT_SHIFT);
> +       /* Calculate the min / max delta */
> +       aevt->max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
> +                          &apbt_clockevent);
> +       /* The min delta is tuned based on SCU FW performance */
> +       aevt->min_delta_ns = clockevent_delta2ns(APBT_MIN_DELTA_USEC*apbt_freq,
> +                                               &apbt_clockevent);

You calculated all that already. Check setup_APIC_timer() how you can
avoid tons of code.

> +       aevt->cpumask = cpumask_of(smp_processor_id());
> +       aevt->irq = adev->irq;

  So all cpus have the same irq ?

> +       aevt->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC;
> +       aevt->rating = APBT_CLOCKEVENT_RATING;
> +
> +       printk(KERN_INFO "Registering CPU %d clockevent device %s\n",
> +               cpu, aevt->name);
> +       clockevents_register_device(aevt);

  Eeek. You register a data structure which is on the stack ?

> +       apbt_setup_irq(adev);
> +       apbt_enable_int(cpu);
> +
> +       return 0;
> +}
> +
> +/* Initialize per CPU timer data structures based on SFI MTMR table */

  That's hardly what the code does.

> +static int apbt_cpuhp_notify(struct notifier_block *n,
> +               unsigned long action, void *hcpu)
> +{
> +       unsigned long cpu = (unsigned long)hcpu;
> +       struct apbt_dev *adev = per_cpu(cpu_apbt_dev, cpu);
> +
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

  ????

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

  Again, how does that work with the quirks patches vs. secondary
  clock you did before ?

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
> +
> +#ifdef CONFIG_SMP
> +       struct apbt_dev *adev = EVT_TO_APBT_DEV(evt);
> +       timer_num = adev->num;
> +#else
> +       timer_num = 0;
> +#endif

  Where is the point of this. you get the device from the calling
  code.  So always embedd it into your data structure and have
  everything in place. No ifdeffery, just the same code for UP and
  SMP.


> +       if ((timer_num < 0) || (timer_num > sfi_mtimer_num)) {
> +               printk(KERN_ERR "apbt: set mode for invalid timer %d\n",
> +                               timer_num);
> +               return;
> +       }

  This check looks more than superfluous.

> +static int apb_timer_next_event(unsigned long delta,
> +                          struct clock_event_device *evt)
> +{
> +       unsigned long ctrl;
> +       int timer_num;
> +
> +#ifdef CONFIG_SMP
> +       struct apbt_dev *adev = EVT_TO_APBT_DEV(evt);
> +       timer_num = adev->num;
> +#else
> +       timer_num = 0;
> +#endif

 See above.

> +       /* Disable timer */
> +       ctrl = apbt_readl(timer_num, APBTMR_N_CONTROL);
> +       ctrl &= ~APBTMR_CONTROL_ENABLE;
> +       apbt_writel(timer_num, ctrl, APBTMR_N_CONTROL);
> +       /* write new count */
> +       apbt_writel(timer_num, delta, APBTMR_N_LOAD_COUNT);
> +       ctrl |= APBTMR_CONTROL_ENABLE;
> +       apbt_writel(timer_num, ctrl, APBTMR_N_CONTROL);
> +       return  0;
> +}
> +
> +/*
> + * APB timer clock is not in sync with pclk on Langwell, which translates to
> + * unreliable read value caused by sampling error. the error does not add up
> + * overtime and only happens when sampling a 0 as a 1 by mistake. so the time
> + * would go backwards. the following code is trying to prevent time traveling
> + * backwards. little bit paranoid.
> + */
> +static cycle_t apbt_read_clocksource(struct clocksource *cs)
> +{
> +       unsigned long t0, t1, t2;
> +       static unsigned long last_read;
> +
> +bad_count:
> +       t1 = apbt_readl(phy_cs_timer_id,
> +                               APBTMR_N_CURRENT_VALUE);
> +       t2 = apbt_readl(phy_cs_timer_id,
> +                               APBTMR_N_CURRENT_VALUE);
> +       if (unlikely(t1 < t2)) {
> +               apbt_dbg("APBT: read current count error %lx:%lx:%lx\n",
> +                               t1, t2, t2 - t1);
> +               goto bad_count;
> +       }
> +       /*
> +        * check against cached last read, makes sure time does not go back.
> +        * it could be a normal rollover but we will do tripple check anyway
> +        */
> +       if (unlikely(t2 > last_read)) {
> +               /* check if we have a normal rollover */
> +               unsigned long raw_intr_status =
> +                       apbt_readl_reg(APBTMRS_RAW_INT_STATUS);
> +               /*
> +                * cs timer interrupt is masked but raw intr bit is set if
> +                * rollover occurs. then we read EOI reg to clear it.
> +                */
> +               if (raw_intr_status & (1 << phy_cs_timer_id)) {
> +                       apbt_readl(phy_cs_timer_id, APBTMR_N_EOI);
> +                       goto out;
> +               }
> +               apbt_dbg("APB CS going back %lx:%lx:%lx ",
> +                               t2, last_read, t2 - last_read);
> +bad_count_x3:
> +               apbt_dbg(KERN_INFO "tripple check enforced\n");
> +               t0 = apbt_readl(phy_cs_timer_id,
> +                               APBTMR_N_CURRENT_VALUE);
> +               udelay(1);
> +               t1 = apbt_readl(phy_cs_timer_id,
> +                               APBTMR_N_CURRENT_VALUE);
> +               udelay(1);
> +               t2 = apbt_readl(phy_cs_timer_id,
> +                               APBTMR_N_CURRENT_VALUE);
> +               if ((t2 > t1) || (t1 > t0)) {
> +                       printk(KERN_ERR "Error: APB CS tripple check failed\n");
> +                       goto bad_count_x3;
> +               }
> +       }
> +out:
> +       last_read = t2;
> +       return (cycle_t)~t2;
> +}

  Can you please explain what the hardware is doing and what you want
  to prevent. That code looks like overkill. udelays in the
  timekeeping code ? Oh, no.

  As a side note: This is the ultimate proof that Intel's hardware
  folks are not able to design a working timer.

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

  How is the box supposed to work ?

> +       /*
> +        * initialize and register APBT clocksource
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
> +
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


  Useless double check. num_possible_cpus() <= sfi_mtimer_num is
  sufficient.

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

  And what's the purpose of this setup ? Also why is the watchdog SMP only?

> +#endif
> +
> +       return 1;
> +
> +out_noapbt:
> +       printk(KERN_DEBUG "failed to enable APB timer\n");
> +       apbt_clear_mapping();

  You get here also when you already registered a clocksource and the
  clock event setup failed. Guarantee to oops your kernel.

> +       apb_timer_block_enabled = 0;
> +       return -ENODEV;
> +}
> +
> +static inline void apbt_disable(int n)
> +{
> +       if (is_apbt_capable()) {
> +               unsigned long ctrl =  apbt_readl(n, APBTMR_N_CONTROL);
> +               ctrl &= ~APBTMR_CONTROL_ENABLE;
> +               apbt_writel(n, ctrl, APBTMR_N_CONTROL);
> +       }
> +}
> +
> +/* called before apb_timer_enable, use early map */

  We really need to look into that early calibration thing whether
  this is necessary at all.

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
> +       /* restart the timer to ensure it won't get to 0 in the calibration */
> +       apbt_start_counter(phy_cs_timer_id);
> +
> +       old = apbt_read_clocksource(&clocksource_apbt);
> +       old += loop;
> +
> +       t1 = __native_read_tsc();
> +
> +       do {
> +               new = apbt_read_clocksource(&clocksource_apbt);

  Eeek. Is the clock source already set up at this point ?

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

This code needs a lot of care.

Thanks,

	tglx
