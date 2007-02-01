Return-Path: <linux-kernel-owner+w=401wt.eu-S1422799AbXBALNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422799AbXBALNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422798AbXBALMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:12:40 -0500
Received: from styx.suse.cz ([82.119.242.94]:53744 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751736AbXBALMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:12:34 -0500
Message-Id: <20070201103753.508377000@jet.suse.cz>
References: <20070201095952.589234000@jet.suse.cz>
User-Agent: quilt/0.44-16.5
Date: Thu, 01 Feb 2007 10:59:54 +0100
From: jbohac@suse.cz
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: [patch 2/9] Remove the support for the VXTIME_PMTMR timer mode
Content-Disposition: inline; filename=remove_vxtime_pmtmr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

VXTIME_PMTMR will be replaced by a more generic "Master Timer"

Signed-off-by: Jiri Bohac <jbohac@suse.cz>

Index: linux-2.6.20-rc5/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/apic.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/apic.c
@@ -784,16 +784,7 @@ static void setup_APIC_timer(unsigned in
 		} while (c2 - c1 < 300);
 	}
 	__setup_APIC_LVTT(clocks);
-	/* Turn off PIT interrupt if we use APIC timer as main timer.
-	   Only works with the PM timer right now
-	   TBD fix it for HPET too. */
-	if (vxtime.mode == VXTIME_PMTMR &&
-		smp_processor_id() == boot_cpu_id &&
-		apic_runs_main_timer == 1 &&
-		!cpu_isset(boot_cpu_id, timer_interrupt_broadcast_ipi_mask)) {
-		stop_timer_interrupt();
-		apic_runs_main_timer++;
-	}
+
 	local_irq_restore(flags);
 }
 
Index: linux-2.6.20-rc5/arch/x86_64/kernel/pmtimer.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/pmtimer.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/pmtimer.c
@@ -29,10 +29,6 @@
  * in arch/i386/kernel/acpi/boot.c */
 u32 pmtmr_ioport __read_mostly;
 
-/* value of the Power timer at last timer interrupt */
-static u32 offset_delay;
-static u32 last_pmtmr_tick;
-
 #define ACPI_PM_MASK 0xFFFFFF /* limit it to 24 bits */
 
 static inline u32 cyc2us(u32 cycles)
@@ -48,38 +44,6 @@ static inline u32 cyc2us(u32 cycles)
 	return (cycles >> 10);
 }
 
-int pmtimer_mark_offset(void)
-{
-	static int first_run = 1;
-	unsigned long tsc;
-	u32 lost;
-
-	u32 tick = inl(pmtmr_ioport);
-	u32 delta;
-
-	delta = cyc2us((tick - last_pmtmr_tick) & ACPI_PM_MASK);
-
-	last_pmtmr_tick = tick;
-	monotonic_base += delta * NSEC_PER_USEC;
-
-	delta += offset_delay;
-
-	lost = delta / (USEC_PER_SEC / HZ);
-	offset_delay = delta % (USEC_PER_SEC / HZ);
-
-	rdtscll(tsc);
-	vxtime.last_tsc = tsc - offset_delay * (u64)cpu_khz / 1000;
-
-	/* don't calculate delay for first run,
-	   or if we've got less then a tick */
-	if (first_run || (lost < 1)) {
-		first_run = 0;
-		offset_delay = 0;
-	}
-
-	return lost - 1;
-}
-
 static unsigned pmtimer_wait_tick(void)
 {
 	u32 a, b;
@@ -100,28 +64,3 @@ void pmtimer_wait(unsigned us)
 		cpu_relax();
 	} while (cyc2us(b - a) < us);
 }
-
-void pmtimer_resume(void)
-{
-	last_pmtmr_tick = inl(pmtmr_ioport);
-}
-
-unsigned int do_gettimeoffset_pm(void)
-{
-	u32 now, offset, delta = 0;
-
-	offset = last_pmtmr_tick;
-	now = inl(pmtmr_ioport);
-	delta = (now - offset) & ACPI_PM_MASK;
-
-	return offset_delay + cyc2us(delta);
-}
-
-
-static int __init nopmtimer_setup(char *s)
-{
-	pmtmr_ioport = 0;
-	return 1;
-}
-
-__setup("nopmtimer", nopmtimer_setup);
Index: linux-2.6.20-rc5/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/time.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/time.c
@@ -364,13 +364,6 @@ void main_timer_handler(void)
 		 */
 		offset = hpet_readl(HPET_T0_CMP) - hpet_tick;
 		delay = hpet_readl(HPET_COUNTER) - offset;
-	} else if (!pmtmr_ioport) {
-		spin_lock(&i8253_lock);
-		outb_p(0x00, 0x43);
-		delay = inb_p(0x40);
-		delay |= inb(0x40) << 8;
-		spin_unlock(&i8253_lock);
-		delay = LATCH - 1 - delay;
 	}
 
 	tsc = get_cycles_sync();
@@ -384,10 +377,6 @@ void main_timer_handler(void)
 			(offset - vxtime.last) * NSEC_PER_TICK / hpet_tick;
 
 		vxtime.last = offset;
-#ifdef CONFIG_X86_PM_TIMER
-	} else if (vxtime.mode == VXTIME_PMTMR) {
-		lost = pmtimer_mark_offset();
-#endif
 	} else {
 		offset = (((tsc - vxtime.last_tsc) *
 			   vxtime.tsc_quot) >> US_SCALE) - USEC_PER_TICK;
@@ -914,13 +903,6 @@ void __init time_init(void)
 	  	tick_nsec = TICK_NSEC_HPET;
 		cpu_khz = hpet_calibrate_tsc();
 		timename = "HPET";
-#ifdef CONFIG_X86_PM_TIMER
-	} else if (pmtmr_ioport && !vxtime.hpet_address) {
-		vxtime_hz = PM_TIMER_FREQUENCY;
-		timename = "PM";
-		pit_init();
-		cpu_khz = pit_calibrate_tsc();
-#endif
 	} else {
 		pit_init();
 		cpu_khz = pit_calibrate_tsc();
@@ -987,16 +969,6 @@ void time_init_gtod(void)
 			vxtime.last = hpet_readl(HPET_COUNTER);
 		vxtime.mode = VXTIME_HPET;
 		do_gettimeoffset = do_gettimeoffset_hpet;
-#ifdef CONFIG_X86_PM_TIMER
-	/* Using PM for gettimeofday is quite slow, but we have no other
-	   choice because the TSC is too unreliable on some systems. */
-	} else if (pmtmr_ioport && !vxtime.hpet_address && notsc) {
-		timetype = "PM";
-		do_gettimeoffset = do_gettimeoffset_pm;
-		vxtime.mode = VXTIME_PMTMR;
-		sysctl_vsyscall = 0;
-		printk(KERN_INFO "Disabling vsyscall due to use of PM timer\n");
-#endif
 	} else {
 		timetype = hpet_use_timer ? "HPET/TSC" : "PIT/TSC";
 		vxtime.mode = VXTIME_TSC;
@@ -1064,10 +1036,6 @@ static int timer_resume(struct sys_devic
 			vxtime.last = hpet_readl(HPET_T0_CMP) - hpet_tick;
 		else
 			vxtime.last = hpet_readl(HPET_COUNTER);
-#ifdef CONFIG_X86_PM_TIMER
-	} else if (vxtime.mode == VXTIME_PMTMR) {
-		pmtimer_resume();
-#endif
 	} else
 		vxtime.last_tsc = get_cycles_sync();
 	write_sequnlock_irqrestore(&xtime_lock,flags);
Index: linux-2.6.20-rc5/include/asm-x86_64/vsyscall.h
===================================================================
--- linux-2.6.20-rc5.orig/include/asm-x86_64/vsyscall.h
+++ linux-2.6.20-rc5/include/asm-x86_64/vsyscall.h
@@ -26,7 +26,6 @@ enum vsyscall_num {
 
 #define VXTIME_TSC	1
 #define VXTIME_HPET	2
-#define VXTIME_PMTMR	3
 
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2

--
