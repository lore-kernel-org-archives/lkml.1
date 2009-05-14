Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZENUZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZENUZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZENUZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:25:09 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:55778 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbZENUZF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:25:05 -0400
Date: Thu, 14 May 2009 22:25:01 +0200
Message-Id: <715998165@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: akataria@vmware.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+axDmfbPVaUbMydJaEKGQf60JW9X8bkkUUz3yKovMi+9snA
 lDjgT6L9Uku4JRjiAAxo1tPn/E21vz1G4kv3LZ0hIPUDICHH4A=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2009-05-12 at 12:45 -0700, devzero@web.de wrote:
> > >> > As a side note Red Hat ships runtime configurable tick behaviour in RHEL
> > >> > these days. HZ is fixed but the ticks can be bunched up. That was done as
> > >> > a quick fix to keep stuff portable but its a lot more sensible than
> > >> > randomly messing with the HZ value and its not much code either.
> > >> > 
> > >> Hi Alan, 
> > >> 
> > >> I guess you are talking about the tick_divider patch ? 
> > >> And that's still same as reducing the HZ value only that it can be done
> > >> dynamically (boot time), right ? 
> > >
> > >Yes - which has the advantage that you can select different behaviours
> > >rather than distributions having to build with HZ=1000 either for
> > >compatibility or responsiveness can still allow users to drop to a lower
> > >HZ value if doing stuff like HPC.
> > >
> > >Basically it removes the need to argue about it at build time and lets
> > >the user decide.
> > 
> > any reason why this did not reach mainline?
> 
> I think it is because during the time when this was implemented for RHEL
> 5, mainline was moving towards the tickless approach, which might have
> prompted people to think that it would no more be useful for mainline.
> 
> Since Alan was the one who implemented those patches, I guess he would
> have a better say on this. Alan, are there any plans for mainlining this
> now ?
> 
> Alok

anyway, just fyi or for some additional transparency, here`s the 4 tick-divider 
related patches from "recent" RHEL5  kernel 
(-> http://isoredirect.centos.org/centos/5/os/SRPMS/kernel-2.6.18-128.el5.src.rpm)

regards
roland


cat ./linux-2.6-docs-update-kernel-parameters-with-tick-divider.patch

From: Chris Lalancette <clalance@redhat.com>
Date: Wed, 17 Sep 2008 17:14:19 +0200
Subject: [docs] update kernel-parameters with tick-divider
Message-id: 48D11ECB.1060100@redhat.com
O-Subject: [RHEL5.3 PATCH v2]: Update kernel-parameters with tick-divider
Bugzilla: 454792
RH-Acked-by: Prarit Bhargava <prarit@redhat.com>
RH-Acked-by: Alan Cox <alan@redhat.com>
RH-Nacked-by: Alan Cox <alan@redhat.com>

We have a request to better document the tick divider patch that went into 5.1.
 Towards this end, I came up with the following patch to
Documentation/kernel-parameters.txt.  Not sure if it needs ACKs or anything, but
I wanted to make sure dzickus saw it.  This will resolve BZ 454792.  This
version doesn't tell the user to divide by zero (thanks Alan).

--
Chris Lalancette

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b5bbd11..20ab2a9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -470,6 +470,10 @@ running once the system is up.
                        See drivers/char/README.epca and
                        Documentation/digiepca.txt.

+       divider=        [IA-32,X86-64]
+                       divide kernel HZ rate by given value.
+                       Format: <num>, where <num> is between 1 and 25
+
        dmascc=         [HW,AX25,SERIAL] AX.25 Z80SCC driver with DMA
                        support available.
                        Format: <io_dev0>[,<io_dev1>[,..<io_dev32>]]





cat ./linux-2.6-x86_64-fix-casting-issue-in-tick-divider-patch.patch

From: Prarit Bhargava <prarit@redhat.com>
Subject: [RHEL 5.1 PATCH]: Fix casting issue in tick divider patch
Date: Wed, 20 Jun 2007 14:16:29 -0400
Bugzilla: 244861
Message-Id: <20070620181629.28881.27223.sendpatchset@prarit.boston.redhat.com>
Changelog: [x86_64] Fix casting issue in tick divider patch


Fix a casting bug in the tick divider patch.

Successfully tested by me on a variety of systems that were exhibiting slow
boot behaviour.

Resolves BZ 244861.

--- linux-2.6.18.x86_64/arch/x86_64/kernel/time.c.orig  2007-06-20 04:21:58.000000000 -0400
+++ linux-2.6.18.x86_64/arch/x86_64/kernel/time.c       2007-06-20 04:28:58.000000000 -0400
@@ -433,7 +433,7 @@ void main_timer_handler(struct pt_regs *
                                (((long) offset << US_SCALE) / vxtime.tsc_quot) - 1;
        }
        /* SCALE: We expect tick_divider - 1 lost, ie 0 for normal behaviour */
-       if (lost > tick_divider - 1)  {
+       if (lost > (int)tick_divider - 1)  {
                handle_lost_ticks(lost, regs);
                jiffies += lost - (tick_divider - 1);
        }



cat ./linux-2.6-x86-fixes-for-the-tick-divider-patch.patch

From: Chris Lalancette <clalance@redhat.com>
Subject: Re: [RHEL 5.1.z PATCH]: Fixes for the tick divider patch
Date: Tue, 02 Oct 2007 16:53:22 -0400
Bugzilla: 315471
Message-Id: <4702AFC2.9020702@redhat.com>
Changelog: [x86] Fixes for the tick divider patch

All,
     While testing the tick divider patch under VMware, a number of issues were
found with it:

1)  On i386, when specifying "divider=10 apic=verbose", a bogus value was
printed for the CPU MHz and the host bus speed.  This is because during APIC
calibration, we were using "HZ/10" loops instead of "REAL_HZ/10", causing the
calculation to go out of bounds.

2)  On x86_64, when using the tick divider, it wasn't dividing the local APIC as
well as the external timer.  This causes problems under VMware since the
hypervisor (ESX server) has to deliver 1000 local APIC interrupts per second to
each logical processor, which can end up causing time drift.  By properly
dividing the local APIC as well as the external time source, it significantly
reduces the load on the HV, and the guests have less tendency to drift.

3)  On x86_64, we weren't looping during smp_local_timer_interrupt(), so we were
losing profiling ticks.

3)  On x86_64, when using the tick divider with PM-Timer, lost tick compensation
wasn't being calculated properly.  In particular, we would count ticks as lost
when they really weren't, because we were using HZ instead of REAL_HZ in the
lost calculation.

4)  On x86_64, TSC suffers from the same problem as PM-Timer.

The attached patch fixes all 4 of these problems.  Additionally, this patch also
adds a "hz=" command-line parameter for both i386 and x86_64.  This is nicer way
to specify the divider from a user point-of-view; they don't have to know the
current value of HZ in order to specify the HZ value they want.

These patches are not upstream, since upstream has since gone with the tickless
kernel.

Patches successfully tested by myself (just for verifying basic correctness),
and HP and VMware using ESX server.

This fixes BZ 305011.  Please review and ACK.

Chris Lalancette


>
> ACK less the hz= bits for 5.1.z, per Alan's concern about only certain
> values in the currently accepted range actually being valid. I'd say
> fully bake that part for 5.2 and just take the fixes for 5.1.z.
>

Same patch, with hz= bits removed for the z-stream.

Chris Lalancette

diff -urp linux-2.6.18.noarch.orig/arch/i386/kernel/apic.c linux-2.6.18.noarch/arch/i386/kernel/apic.c
--- linux-2.6.18.noarch.orig/arch/i386/kernel/apic.c    2007-10-02 16:42:24.000000000 -0400
+++ linux-2.6.18.noarch/arch/i386/kernel/apic.c 2007-10-02 16:47:00.000000000 -0400
@@ -1027,7 +1027,7 @@ static int __init calibrate_APIC_clock(v
        long tt1, tt2;
        long result;
        int i;
-       const int LOOPS = HZ/10;
+       const int LOOPS = REAL_HZ/10;

        apic_printk(APIC_VERBOSE, "calibrating APIC timer ...\n");

@@ -1076,13 +1076,13 @@ static int __init calibrate_APIC_clock(v
        if (cpu_has_tsc)
                apic_printk(APIC_VERBOSE, "..... CPU clock speed is "
                        "%ld.%04ld MHz.\n",
-                       ((long)(t2-t1)/LOOPS)/(1000000/HZ),
-                       ((long)(t2-t1)/LOOPS)%(1000000/HZ));
+                       ((long)(t2-t1)/LOOPS)/(1000000/REAL_HZ),
+                       ((long)(t2-t1)/LOOPS)%(1000000/REAL_HZ));

        apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
                "%ld.%04ld MHz.\n",
-               result/(1000000/HZ),
-               result%(1000000/HZ));
+               result/(1000000/REAL_HZ),
+               result%(1000000/REAL_HZ));

        return result;
 }
diff -urp linux-2.6.18.noarch.orig/arch/x86_64/kernel/apic.c linux-2.6.18.noarch/arch/x86_64/kernel/apic.c
--- linux-2.6.18.noarch.orig/arch/x86_64/kernel/apic.c  2007-10-02 16:42:30.000000000 -0400
+++ linux-2.6.18.noarch/arch/x86_64/kernel/apic.c       2007-10-02 16:47:00.000000000 -0400
@@ -811,7 +811,7 @@ static int __init calibrate_APIC_clock(v
        printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
                result / 1000 / 1000, result / 1000 % 1000);

-       return result * APIC_DIVISOR / HZ;
+       return result * APIC_DIVISOR / REAL_HZ;
 }

 static unsigned int calibration_result;
@@ -941,10 +941,13 @@ void setup_APIC_extened_lvt(unsigned cha

 void smp_local_timer_interrupt(struct pt_regs *regs)
 {
-       profile_tick(CPU_PROFILING, regs);
+       int i;
+       for (i = 0; i < tick_divider; i++) {
+               profile_tick(CPU_PROFILING, regs);
 #ifdef CONFIG_SMP
-       update_process_times(user_mode(regs));
+               update_process_times(user_mode(regs));
 #endif
+       }
        if (apic_runs_main_timer > 1 && smp_processor_id() == boot_cpu_id)
                main_timer_handler(regs);
        /*
diff -urp linux-2.6.18.noarch.orig/arch/x86_64/kernel/pmtimer.c linux-2.6.18.noarch/arch/x86_64/kernel/pmtimer.c
--- linux-2.6.18.noarch.orig/arch/x86_64/kernel/pmtimer.c       2006-09-19 23:42:06.000000000 -0400
+++ linux-2.6.18.noarch/arch/x86_64/kernel/pmtimer.c    2007-10-02 16:47:00.000000000 -0400
@@ -64,8 +64,8 @@ int pmtimer_mark_offset(void)

        delta += offset_delay;

-       lost = delta / (USEC_PER_SEC / HZ);
-       offset_delay = delta % (USEC_PER_SEC / HZ);
+       lost = delta / (USEC_PER_SEC / REAL_HZ);
+       offset_delay = delta % (USEC_PER_SEC / REAL_HZ);

        rdtscll(tsc);
        vxtime.last_tsc = tsc - offset_delay * (u64)cpu_khz / 1000;
diff -urp linux-2.6.18.noarch.orig/arch/x86_64/kernel/time.c linux-2.6.18.noarch/arch/x86_64/kernel/time.c
--- linux-2.6.18.noarch.orig/arch/x86_64/kernel/time.c  2007-10-02 16:42:31.000000000 -0400
+++ linux-2.6.18.noarch/arch/x86_64/kernel/time.c       2007-10-02 16:47:43.000000000 -0400
@@ -65,6 +65,8 @@ static int notsc __initdata = 0;
 #define NSEC_PER_TICK (NSEC_PER_SEC / HZ)
 #define FSEC_PER_TICK (FSEC_PER_SEC / HZ)

+#define USEC_PER_REAL_TICK (USEC_PER_SEC / REAL_HZ)
+
 #define NS_SCALE       10 /* 2^10, carefully chosen */
 #define US_SCALE       32 /* 2^32, arbitralrily chosen */

@@ -304,7 +306,7 @@ unsigned long long monotonic_clock(void)
                        this_offset = hpet_readl(HPET_COUNTER);
                } while (read_seqretry(&xtime_lock, seq));
                offset = (this_offset - last_offset);
-               offset *= NSEC_PER_TICK / hpet_tick;
+               offset *= NSEC_PER_TICK / hpet_tick_real;
        } else {
                do {
                        seq = read_seqbegin(&xtime_lock);
@@ -406,7 +408,7 @@ void main_timer_handler(struct pt_regs *
                }

                monotonic_base +=
-                       (offset - vxtime.last) * NSEC_PER_TICK / hpet_tick;
+                       (offset - vxtime.last) * NSEC_PER_TICK / hpet_tick_real;

                vxtime.last = offset;
 #ifdef CONFIG_X86_PM_TIMER
@@ -415,14 +417,14 @@ void main_timer_handler(struct pt_regs *
 #endif
        } else {
                offset = (((tsc - vxtime.last_tsc) *
-                          vxtime.tsc_quot) >> US_SCALE) - USEC_PER_TICK;
+                          vxtime.tsc_quot) >> US_SCALE) - USEC_PER_REAL_TICK;

                if (offset < 0)
                        offset = 0;

-               if (offset > USEC_PER_TICK) {
-                       lost = offset / USEC_PER_TICK;
-                       offset %= USEC_PER_TICK;
+               if (offset > USEC_PER_REAL_TICK) {
+                       lost = offset / USEC_PER_REAL_TICK;
+                       offset %= USEC_PER_REAL_TICK;
                }

                /* FIXME: 1000 or 1000000? */







cat ./linux-2.6-x86-tick-divider.patch

From: Alan Cox <alan@redhat.com>
Subject: [RHEL5]: Tick Divider (Bugzilla #215403]
Date: Wed, 18 Apr 2007 16:39:15 -0400
Bugzilla: 215403
Message-Id: <20070418203915.GA23344@devserv.devel.redhat.com>
Changelog: [x86] Tick Divider


The following patch implements a tick divider feature that allows you to
boot the kernel with HZ at 1000 but the real timer tick rate lower (thus
not breaking all the modules and kABI).

The selection is done at boot to minimize risk and the patch has been reworked
so that you can do an informal attempt at a proof that it doesn't cause
regression for the non dividing case.

The patch interleaved with notes follows, and below that the actual patch
proper.

Xen kernels remain at 250HZ because
a) Xen guests have a 'tickless mode'
b) Xen itself has issues with multiple differing guest GZ rates

Not queued for upstream as the upstream path is Ingo's tickless kernel, which
is not viable as a RHEL5 tweak

Index: linux-2.6.18.noarch/arch/i386/kernel/apic.c
===================================================================
--- linux-2.6.18.noarch.orig/arch/i386/kernel/apic.c
+++ linux-2.6.18.noarch/arch/i386/kernel/apic.c
@@ -1185,10 +1185,13 @@ EXPORT_SYMBOL(switch_ipi_to_APIC_timer);

 inline void smp_local_timer_interrupt(struct pt_regs * regs)
 {
-       profile_tick(CPU_PROFILING, regs);
+       int i;
+       for (i = 0; i < tick_divider; i++) {
+               profile_tick(CPU_PROFILING, regs);
 #ifdef CONFIG_SMP
-       update_process_times(user_mode_vm(regs));
+               update_process_times(user_mode_vm(regs));
 #endif
+       }

        /*
         * We take the 'long' return path, and there every subsystem
Index: linux-2.6.18.noarch/arch/i386/kernel/apm.c
===================================================================
--- linux-2.6.18.noarch.orig/arch/i386/kernel/apm.c
+++ linux-2.6.18.noarch/arch/i386/kernel/apm.c
@@ -1189,7 +1189,7 @@ static void reinit_timer(void)
        unsigned long flags;

        spin_lock_irqsave(&i8253_lock, flags);
-       /* set the clock to 100 Hz */
+       /* set the clock to HZ */
        outb_p(0x34, PIT_MODE);         /* binary, mode 2, LSB/MSB, ch 0 */
        udelay(10);
        outb_p(LATCH & 0xff, PIT_CH0);  /* LSB */
Index: linux-2.6.18.noarch/arch/i386/kernel/i8253.c
===================================================================
--- linux-2.6.18.noarch.orig/arch/i386/kernel/i8253.c
+++ linux-2.6.18.noarch/arch/i386/kernel/i8253.c
@@ -26,6 +26,7 @@ void setup_pit_timer(void)
        spin_lock_irqsave(&i8253_lock, flags);
        outb_p(0x34,PIT_MODE);          /* binary, mode 2, LSB/MSB, ch 0 */
        udelay(10);
+       /* Physical HZ */
        outb_p(LATCH & 0xff , PIT_CH0); /* LSB */
        udelay(10);
        outb(LATCH >> 8 , PIT_CH0);     /* MSB */
@@ -94,8 +95,11 @@ static cycle_t pit_read(void)
        spin_unlock_irqrestore(&i8253_lock, flags);

        count = (LATCH - 1) - count;
-
-       return (cycle_t)(jifs * LATCH) + count;
+       /* Adjust to logical ticks */
+       count *= tick_divider;
+
+       /* Keep the jiffies in terms of logical ticks not physical */
+       return (cycle_t)(jifs * LOGICAL_LATCH) + count;
 }

 static struct clocksource clocksource_pit = {
Index: linux-2.6.18.noarch/arch/i386/kernel/time.c
===================================================================
--- linux-2.6.18.noarch.orig/arch/i386/kernel/time.c
+++ linux-2.6.18.noarch/arch/i386/kernel/time.c
@@ -366,3 +367,22 @@ void __init time_init(void)

        time_init_hook();
 }
+
+#ifdef CONFIG_TICK_DIVIDER
+
+unsigned int tick_divider = 1;
+
+static int __init divider_setup(char *s)
+{
+       unsigned int divider = 1;
+       get_option(&s, &divider);
+       if (divider >= 1 && HZ/divider >= 25)
+               tick_divider = divider;
+       else
+               printk(KERN_ERR "tick_divider: %d is out of range.\n", divider);
+       return 1;
+}
+
+__setup("divider=", divider_setup);
+
+#endif
Index: linux-2.6.18.noarch/arch/i386/kernel/time_hpet.c
===================================================================
--- linux-2.6.18.noarch.orig/arch/i386/kernel/time_hpet.c
+++ linux-2.6.18.noarch/arch/i386/kernel/time_hpet.c
@@ -24,6 +24,7 @@

 static unsigned long hpet_period;      /* fsecs / HPET clock */
 unsigned long hpet_tick;               /* hpet clks count per tick */
+unsigned long hpet_tick_real;          /* hpet clocks per interrupt */
 unsigned long hpet_address;            /* hpet memory map physical address */
 int hpet_use_timer;

@@ -156,7 +157,8 @@ int __init hpet_enable(void)

        hpet_use_timer = id & HPET_ID_LEGSUP;

-       if (hpet_timer_stop_set_go(hpet_tick))
+       hpet_tick_real = hpet_tick * tick_divider;
+       if (hpet_timer_stop_set_go(hpet_tick_real))
                return -1;

        use_hpet = 1;
Index: linux-2.6.18.noarch/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.18.noarch.orig/arch/x86_64/Kconfig
+++ linux-2.6.18.noarch/arch/x86_64/Kconfig
@@ -443,6 +443,13 @@ config HPET_EMULATE_RTC
        bool "Provide RTC interrupt"
        depends on HPET_TIMER && RTC=y

+config TICK_DIVIDER
+       bool "Support clock division"
+       default n
+       help
+         Supports the use of clock division allowing the real interrupt
+         rate to be lower than the HZ setting.
+
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
 config IOMMU
Index: linux-2.6.18.noarch/arch/x86_64/kernel/i8259.c
===================================================================
--- linux-2.6.18.noarch.orig/arch/x86_64/kernel/i8259.c
+++ linux-2.6.18.noarch/arch/x86_64/kernel/i8259.c
@@ -498,6 +498,7 @@ static void setup_timer_hardware(void)
 {
        outb_p(0x34,0x43);              /* binary, mode 2, LSB/MSB, ch 0 */
        udelay(10);
+       /* LATCH is in physical clocks */
        outb_p(LATCH & 0xff , 0x40);    /* LSB */
        udelay(10);
        outb(LATCH >> 8 , 0x40);        /* MSB */
Index: linux-2.6.18.noarch/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.18.noarch.orig/arch/x86_64/kernel/time.c
+++ linux-2.6.18.noarch/arch/x86_64/kernel/time.c
@@ -70,7 +70,8 @@ static int notsc __initdata = 0;
 unsigned int cpu_khz;                                  /* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
 static unsigned long hpet_period;                      /* fsecs / HPET clock */
-unsigned long hpet_tick;                               /* HPET clocks / interrupt */
+unsigned long hpet_tick;                               /* HPET clocks / HZ */
+unsigned long hpet_tick_real;                          /* HPET clocks / interrupt */
 int hpet_use_timer;                            /* Use counter of hpet for time keeping, otherwise PIT */
 unsigned long vxtime_hz = PIT_TICK_RATE;
 int report_lost_ticks;                         /* command line option */
@@ -108,7 +109,9 @@ static inline unsigned int do_gettimeoff
 {
        /* cap counter read to one tick to avoid inconsistencies */
        unsigned long counter = hpet_readl(HPET_COUNTER) - vxtime.last;
-       return (min(counter,hpet_tick) * vxtime.quot) >> US_SCALE;
+       /* The hpet counter runs at a fixed rate so we don't care about HZ
+          scaling here. We do however care that the limit is in real ticks */
+       return (min(counter,hpet_tick_real) * vxtime.quot) >> US_SCALE;
 }

 unsigned int (*do_gettimeoffset)(void) = do_gettimeoffset_tsc;
@@ -332,7 +335,7 @@ static noinline void handle_lost_ticks(i
                        printk(KERN_WARNING "Falling back to HPET\n");
                        if (hpet_use_timer)
                                vxtime.last = hpet_readl(HPET_T0_CMP) -
-                                                       hpet_tick;
+                                                       hpet_tick_real;
                        else
                                vxtime.last = hpet_readl(HPET_COUNTER);
                        vxtime.mode = VXTIME_HPET;
@@ -355,7 +358,7 @@ void main_timer_handler(struct pt_regs *
 {
        static unsigned long rtc_update = 0;
        unsigned long tsc;
-       int delay = 0, offset = 0, lost = 0;
+       int delay = 0, offset = 0, lost = 0, i;

 /*
  * Here we are in the timer irq handler. We have irqs locally disabled (so we
@@ -373,8 +376,10 @@ void main_timer_handler(struct pt_regs *
                /* if we're using the hpet timer functionality,
                 * we can more accurately know the counter value
                 * when the timer interrupt occured.
+                *
+                * We are working in physical time here
                 */
-               offset = hpet_readl(HPET_T0_CMP) - hpet_tick;
+               offset = hpet_readl(HPET_T0_CMP) - hpet_tick_real;
                delay = hpet_readl(HPET_COUNTER) - offset;
        } else if (!pmtmr_ioport) {
                spin_lock(&i8253_lock);
@@ -382,14 +387,19 @@ void main_timer_handler(struct pt_regs *
                delay = inb_p(0x40);
                delay |= inb(0x40) << 8;
                spin_unlock(&i8253_lock);
+               /* We are in physical not logical ticks */
                delay = LATCH - 1 - delay;
+               /* True ticks of delay elapsed */
+               delay *= tick_divider;
        }

        tsc = get_cycles_sync();

        if (vxtime.mode == VXTIME_HPET) {
-               if (offset - vxtime.last > hpet_tick) {
-                       lost = (offset - vxtime.last) / hpet_tick - 1;
+               if (offset - vxtime.last > hpet_tick_real) {
+                       lost = (offset - vxtime.last) / hpet_tick_real - 1;
+                       /* Lost is now in real ticks but we want logical */
+                       lost *= tick_divider;
                }

                monotonic_base +=
@@ -422,33 +432,35 @@ void main_timer_handler(struct pt_regs *
                        vxtime.last_tsc = tsc -
                                (((long) offset << US_SCALE) / vxtime.tsc_quot) - 1;
        }
-
-       if (lost > 0) {
+       /* SCALE: We expect tick_divider - 1 lost, ie 0 for normal behaviour */
+       if (lost > tick_divider - 1)  {
                handle_lost_ticks(lost, regs);
-               jiffies += lost;
+               jiffies += lost - (tick_divider - 1);
        }

 /*
  * Do the timer stuff.
  */

-       do_timer(regs);
+       for (i = 0; i < tick_divider; i++) {
+               do_timer(regs);
 #ifndef CONFIG_SMP
-       update_process_times(user_mode(regs));
+               update_process_times(user_mode(regs));
 #endif

-/*
- * In the SMP case we use the local APIC timer interrupt to do the profiling,
- * except when we simulate SMP mode on a uniprocessor system, in that case we
- * have to call the local interrupt handler.
- */
+       /*
+        * In the SMP case we use the local APIC timer interrupt to do the profiling,
+        * except when we simulate SMP mode on a uniprocessor system, in that case we
+        * have to call the local interrupt handler.
+        */

 #ifndef CONFIG_X86_LOCAL_APIC
-       profile_tick(CPU_PROFILING, regs);
+               profile_tick(CPU_PROFILING, regs);
 #else
-       if (!using_apic_timer)
-               smp_local_timer_interrupt(regs);
+               if (!using_apic_timer)
+                       smp_local_timer_interrupt(regs);
 #endif
+       }

 /*
  * If we have an externally synchronized Linux clock, then update CMOS clock
@@ -800,8 +812,8 @@ static int hpet_timer_stop_set_go(unsign
        if (hpet_use_timer) {
                hpet_writel(HPET_TN_ENABLE | HPET_TN_PERIODIC | HPET_TN_SETVAL |
                    HPET_TN_32BIT, HPET_T0_CFG);
-               hpet_writel(hpet_tick, HPET_T0_CMP); /* next interrupt */
-               hpet_writel(hpet_tick, HPET_T0_CMP); /* period */
+               hpet_writel(hpet_tick_real, HPET_T0_CMP); /* next interrupt */
+               hpet_writel(hpet_tick_real, HPET_T0_CMP); /* period */
                cfg |= HPET_CFG_LEGACY;
        }
 /*
@@ -836,16 +848,19 @@ static int hpet_init(void)
        if (hpet_period < 100000 || hpet_period > 100000000)
                return -1;

+       /* Logical ticks */
        hpet_tick = (FSEC_PER_TICK + hpet_period / 2) / hpet_period;
+       /* Ticks per real interrupt */
+       hpet_tick_real = hpet_tick * tick_divider;

        hpet_use_timer = (id & HPET_ID_LEGSUP);

-       return hpet_timer_stop_set_go(hpet_tick);
+       return hpet_timer_stop_set_go(hpet_tick_real);
 }

 static int hpet_reenable(void)
 {
-       return hpet_timer_stop_set_go(hpet_tick);
+       return hpet_timer_stop_set_go(hpet_tick_real);
 }

 #define PIT_MODE 0x43
@@ -864,6 +879,7 @@ static void __init __pit_init(int val, u

 void __init pit_init(void)
 {
+       /* LATCH is in actual interrupt ticks */
        __pit_init(LATCH, 0x34); /* binary, mode 2, LSB/MSB, ch 0 */
 }

@@ -1002,7 +1018,7 @@ void time_init_gtod(void)
        if (vxtime.hpet_address && notsc) {
                timetype = hpet_use_timer ? "HPET" : "PIT/HPET";
                if (hpet_use_timer)
-                       vxtime.last = hpet_readl(HPET_T0_CMP) - hpet_tick;
+                       vxtime.last = hpet_readl(HPET_T0_CMP) - hpet_tick_real;
                else
                        vxtime.last = hpet_readl(HPET_COUNTER);
                vxtime.mode = VXTIME_HPET;
@@ -1073,7 +1089,7 @@ static int timer_resume(struct sys_devic
        xtime.tv_nsec = 0;
        if (vxtime.mode == VXTIME_HPET) {
                if (hpet_use_timer)
-                       vxtime.last = hpet_readl(HPET_T0_CMP) - hpet_tick;
+                       vxtime.last = hpet_readl(HPET_T0_CMP) - hpet_tick_real;
                else
                        vxtime.last = hpet_readl(HPET_COUNTER);
 #ifdef CONFIG_X86_PM_TIMER
@@ -1352,3 +1368,22 @@ int __init notsc_setup(char *s)
 }

 __setup("notsc", notsc_setup);
+
+#ifdef CONFIG_TICK_DIVIDER
+
+
+unsigned int tick_divider = 1;
+
+static int __init divider_setup(char *s)
+{
+       unsigned int divider = 1;
+       get_option(&s, &divider);
+       if (divider >= 1 && HZ/divider >= 25)
+               tick_divider = divider;
+       else
+               printk(KERN_ERR "tick_divider: %d is out of range.\n", divider);
+       return 1;
+}
+
+__setup("divider=", divider_setup);
+#endif
Index: linux-2.6.18.noarch/include/asm-i386/mach-default/do_timer.h
===================================================================
--- linux-2.6.18.noarch.orig/include/asm-i386/mach-default/do_timer.h
+++ linux-2.6.18.noarch/include/asm-i386/mach-default/do_timer.h
@@ -16,17 +16,21 @@

 static inline void do_timer_interrupt_hook(struct pt_regs *regs)
 {
-       do_timer(regs);
+       int i;
+       for (i = 0; i < tick_divider; i++) {
+               do_timer(regs);
 #ifndef CONFIG_SMP
-       update_process_times(user_mode_vm(regs));
+               update_process_times(user_mode_vm(regs));
 #endif
+       }
 /*
  * In the SMP case we use the local APIC timer interrupt to do the
  * profiling, except when we simulate SMP mode on a uniprocessor
  * system, in that case we have to call the local interrupt handler.
  */
 #ifndef CONFIG_X86_LOCAL_APIC
-       profile_tick(CPU_PROFILING, regs);
+       for (i = 0; i < tick_divider; i++)
+               profile_tick(CPU_PROFILING, regs);
 #else
        if (!using_apic_timer)
                smp_local_timer_interrupt(regs);
Index: linux-2.6.18.noarch/include/asm-i386/mach-visws/do_timer.h
===================================================================
--- linux-2.6.18.noarch.orig/include/asm-i386/mach-visws/do_timer.h
+++ linux-2.6.18.noarch/include/asm-i386/mach-visws/do_timer.h
@@ -6,20 +6,24 @@

 static inline void do_timer_interrupt_hook(struct pt_regs *regs)
 {
+       int i;
        /* Clear the interrupt */
        co_cpu_write(CO_CPU_STAT,co_cpu_read(CO_CPU_STAT) & ~CO_STAT_TIMEINTR);

-       do_timer(regs);
+       for (i = 0; i < tick_divider; i++) {
+               do_timer(regs);
 #ifndef CONFIG_SMP
-       update_process_times(user_mode_vm(regs));
+               update_process_times(user_mode_vm(regs));
 #endif
+       }
 /*
  * In the SMP case we use the local APIC timer interrupt to do the
  * profiling, except when we simulate SMP mode on a uniprocessor
  * system, in that case we have to call the local interrupt handler.
  */
 #ifndef CONFIG_X86_LOCAL_APIC
-       profile_tick(CPU_PROFILING, regs);
+       for (i = 0; i < tick_divider; i++)
+               profile_tick(CPU_PROFILING, regs);
 #else
        if (!using_apic_timer)
                smp_local_timer_interrupt(regs);
Index: linux-2.6.18.noarch/include/asm-i386/mach-voyager/do_timer.h
===================================================================
--- linux-2.6.18.noarch.orig/include/asm-i386/mach-voyager/do_timer.h
+++ linux-2.6.18.noarch/include/asm-i386/mach-voyager/do_timer.h
@@ -3,12 +3,14 @@

 static inline void do_timer_interrupt_hook(struct pt_regs *regs)
 {
-       do_timer(regs);
+       int i;
+       for (i = 0; i < tick_divider; i++) {
+               do_timer(regs);
 #ifndef CONFIG_SMP
-       update_process_times(user_mode_vm(regs));
+               update_process_times(user_mode_vm(regs));
 #endif
-
-       voyager_timer_interrupt(regs);
+               voyager_timer_interrupt(regs);
+       }
 }

 static inline int do_timer_overflow(int count)
Index: linux-2.6.18.noarch/include/linux/jiffies.h
===================================================================
--- linux-2.6.18.noarch.orig/include/linux/jiffies.h
+++ linux-2.6.18.noarch/include/linux/jiffies.h
@@ -33,10 +33,21 @@
 # error You lose.
 #endif

+#ifndef CONFIG_TICK_DIVIDER
+#define tick_divider 1
+#else
+extern unsigned int tick_divider;
+#endif
+
+#define REAL_HZ (HZ/tick_divider)
 /* LATCH is used in the interval timer and ftape setup. */
-#define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ) /* For divider */
+#define LATCH  ((CLOCK_TICK_RATE + REAL_HZ/2) / REAL_HZ)       /* For divider */
+
+#define LATCH_HPET ((HPET_TICK_RATE + REAL_HZ/2) / REAL_HZ)
+
+#define LOGICAL_LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ) /* For divider */

-#define LATCH_HPET ((HPET_TICK_RATE + HZ/2) / HZ)
+#define LOGICAL_LATCH_HPET ((HPET_TICK_RATE + HZ/2) / HZ)

 /* Suppose we want to devide two numbers NOM and DEN: NOM/DEN, the we can
  * improve accuracy by shifting LSH bits, hence calculating:
@@ -51,9 +62,9 @@
                              + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))

 /* HZ is the requested value. ACTHZ is actual HZ ("<< 8" is for accuracy) */
-#define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
+#define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LOGICAL_LATCH, 8))

-#define ACTHZ_HPET (SH_DIV (HPET_TICK_RATE, LATCH_HPET, 8))
+#define ACTHZ_HPET (SH_DIV (HPET_TICK_RATE, LOGICAL_LATCH_HPET, 8))

 /* TICK_NSEC is the time between ticks in nsec assuming real ACTHZ */
 #define TICK_NSEC (SH_DIV (1000000UL * 1000, ACTHZ, 8))
Index: linux-2.6.18.noarch/init/calibrate.c
===================================================================
--- linux-2.6.18.noarch.orig/init/calibrate.c
+++ linux-2.6.18.noarch/init/calibrate.c
@@ -26,7 +26,6 @@ __setup("lpj=", lpj_setup);
  * Also, this code tries to handle non-maskable asynchronous events
  * (like SMIs)
  */
-#define DELAY_CALIBRATION_TICKS                        ((HZ < 100) ? 1 : (HZ/100))
 #define MAX_DIRECT_CALIBRATION_RETRIES         5

 static unsigned long __devinit calibrate_delay_direct(void)
@@ -37,6 +36,7 @@ static unsigned long __devinit calibrate
        unsigned long tsc_rate_min, tsc_rate_max;
        unsigned long good_tsc_sum = 0;
        unsigned long good_tsc_count = 0;
+       unsigned long delay_calibration_ticks = ((REAL_HZ < 100) ? 1 : (REAL_HZ/100));
        int i;

        if (read_current_timer(&pre_start) < 0 )
@@ -65,7 +65,7 @@ static unsigned long __devinit calibrate
                pre_start = 0;
                read_current_timer(&start);
                start_jiffies = jiffies;
-               while (jiffies <= (start_jiffies + 1)) {
+               while (jiffies <= (start_jiffies + tick_divider)) {
                        pre_start = start;
                        read_current_timer(&start);
                }
@@ -74,15 +74,18 @@ static unsigned long __devinit calibrate
                pre_end = 0;
                end = post_start;
                while (jiffies <=
-                      (start_jiffies + 1 + DELAY_CALIBRATION_TICKS)) {
+                      (start_jiffies + tick_divider * (1 + delay_calibration_ticks))) {
                        pre_end = end;
                        read_current_timer(&end);
                }
                read_current_timer(&post_end);

-               tsc_rate_max = (post_end - pre_start) / DELAY_CALIBRATION_TICKS;
-               tsc_rate_min = (pre_end - post_start) / DELAY_CALIBRATION_TICKS;
-
+               tsc_rate_max = (post_end - pre_start) / delay_calibration_ticks;
+               tsc_rate_min = (pre_end - post_start) / delay_calibration_ticks;
+
+               tsc_rate_max /= tick_divider;
+               tsc_rate_min /= tick_divider;
+
                /*
                 * If the upper limit and lower limit of the tsc_rate is
                 * >= 12.5% apart, redo calibration.
Index: linux-2.6.18.noarch/arch/i386/Kconfig
===================================================================
--- linux-2.6.18.noarch.orig/arch/i386/Kconfig
+++ linux-2.6.18.noarch/arch/i386/Kconfig
@@ -238,6 +238,13 @@ config HPET_EMULATE_RTC
        depends on HPET_TIMER && RTC=y
        default y

+config TICK_DIVIDER
+       bool "Support clock division"
+       default n
+       help
+         Supports the use of clock division allowing the real interrupt
+         rate to be lower than the HZ setting.
+
 config NR_CPUS
        int "Maximum number of CPUs (2-255)"
        range 2 255

______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

