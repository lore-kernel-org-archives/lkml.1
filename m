Return-Path: <linux-kernel-owner+w=401wt.eu-S1422802AbXBALM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422802AbXBALM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422800AbXBALMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:12:43 -0500
Received: from styx.suse.cz ([82.119.242.94]:53764 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751788AbXBALMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:12:35 -0500
Message-Id: <20070201103753.655278000@jet.suse.cz>
References: <20070201095952.589234000@jet.suse.cz>
User-Agent: quilt/0.44-16.5
Date: Thu, 01 Feb 2007 10:59:55 +0100
From: jbohac@suse.cz
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: [patch 3/9] Remove the support for the VXTIME_HPET timer mode
Content-Disposition: inline; filename=remove_vxtime_hpet
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

VXTIME_HPET will be replaced by a more generic "Master Timer"

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Index: linux-2.6.20-rc5/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/time.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/time.c
@@ -101,13 +101,6 @@ static inline unsigned int do_gettimeoff
 	return x;
 }
 
-static inline unsigned int do_gettimeoffset_hpet(void)
-{
-	/* cap counter read to one tick to avoid inconsistencies */
-	unsigned long counter = hpet_readl(HPET_COUNTER) - vxtime.last;
-	return (min(counter,hpet_tick) * vxtime.quot) >> US_SCALE;
-}
-
 unsigned int (*do_gettimeoffset)(void) = do_gettimeoffset_tsc;
 
 /*
@@ -278,17 +271,6 @@ unsigned long long monotonic_clock(void)
  	u32 last_offset, this_offset, offset;
 	unsigned long long base;
 
-	if (vxtime.mode == VXTIME_HPET) {
-		do {
-			seq = read_seqbegin(&xtime_lock);
-
-			last_offset = vxtime.last;
-			base = monotonic_base;
-			this_offset = hpet_readl(HPET_COUNTER);
-		} while (read_seqretry(&xtime_lock, seq));
-		offset = (this_offset - last_offset);
-		offset *= NSEC_PER_TICK / hpet_tick;
-	} else {
 		do {
 			seq = read_seqbegin(&xtime_lock);
 
@@ -297,7 +279,6 @@ unsigned long long monotonic_clock(void)
 		} while (read_seqretry(&xtime_lock, seq));
 		this_offset = get_cycles_sync();
 		offset = cycles_2_ns(this_offset - last_offset);
-	}
 	return base + offset;
 }
 EXPORT_SYMBOL(monotonic_clock);
@@ -316,16 +297,6 @@ static noinline void handle_lost_ticks(i
 		       KERN_WARNING "Your time source seems to be instable or "
 		   		"some driver is hogging interupts\n");
 		print_symbol("rip %s\n", get_irq_regs()->rip);
-		if (vxtime.mode == VXTIME_TSC && vxtime.hpet_address) {
-			printk(KERN_WARNING "Falling back to HPET\n");
-			if (hpet_use_timer)
-				vxtime.last = hpet_readl(HPET_T0_CMP) - 
-							hpet_tick;
-			else
-				vxtime.last = hpet_readl(HPET_COUNTER);
-			vxtime.mode = VXTIME_HPET;
-			do_gettimeoffset = do_gettimeoffset_hpet;
-		}
 		/* else should fall back to PIT, but code missing. */
 		warned = 1;
 	} else
@@ -368,16 +339,6 @@ void main_timer_handler(void)
 
 	tsc = get_cycles_sync();
 
-	if (vxtime.mode == VXTIME_HPET) {
-		if (offset - vxtime.last > hpet_tick) {
-			lost = (offset - vxtime.last) / hpet_tick - 1;
-		}
-
-		monotonic_base += 
-			(offset - vxtime.last) * NSEC_PER_TICK / hpet_tick;
-
-		vxtime.last = offset;
-	} else {
 		offset = (((tsc - vxtime.last_tsc) *
 			   vxtime.tsc_quot) >> US_SCALE) - USEC_PER_TICK;
 
@@ -387,7 +348,6 @@ void main_timer_handler(void)
 		if (offset > USEC_PER_TICK) {
 			lost = offset / USEC_PER_TICK;
 			offset %= USEC_PER_TICK;
-		}
 
 		monotonic_base += cycles_2_ns(tsc - vxtime.last_tsc);
 
@@ -465,20 +425,6 @@ unsigned long long sched_clock(void)
 {
 	unsigned long a = 0;
 
-#if 0
-	/* Don't do a HPET read here. Using TSC always is much faster
-	   and HPET may not be mapped yet when the scheduler first runs.
-           Disadvantage is a small drift between CPUs in some configurations,
-	   but that should be tolerable. */
-	if (__vxtime.mode == VXTIME_HPET)
-		return (hpet_readl(HPET_COUNTER) * vxtime.quot) >> US_SCALE;
-#endif
-
-	/* Could do CPU core sync here. Opteron can execute rdtsc speculatively,
-	   which means it is not completely exact and may not be monotonous between
-	   CPUs. But the errors should be too small to matter for scheduling
-	   purposes. */
-
 	rdtscll(a);
 	return cycles_2_ns(a);
 }
@@ -961,18 +907,8 @@ void time_init_gtod(void)
 	else
 		vgetcpu_mode = VGETCPU_LSL;
 
-	if (vxtime.hpet_address && notsc) {
-		timetype = hpet_use_timer ? "HPET" : "PIT/HPET";
-		if (hpet_use_timer)
-			vxtime.last = hpet_readl(HPET_T0_CMP) - hpet_tick;
-		else
-			vxtime.last = hpet_readl(HPET_COUNTER);
-		vxtime.mode = VXTIME_HPET;
-		do_gettimeoffset = do_gettimeoffset_hpet;
-	} else {
 		timetype = hpet_use_timer ? "HPET/TSC" : "PIT/TSC";
 		vxtime.mode = VXTIME_TSC;
-	}
 
 	printk(KERN_INFO "time.c: Using %ld.%06ld MHz WALL %s GTOD %s timer.\n",
 	       vxtime_hz / 1000000, vxtime_hz % 1000000, timename, timetype);
@@ -1031,12 +967,6 @@ static int timer_resume(struct sys_devic
 	write_seqlock_irqsave(&xtime_lock,flags);
 	xtime.tv_sec = sec;
 	xtime.tv_nsec = 0;
-	if (vxtime.mode == VXTIME_HPET) {
-		if (hpet_use_timer)
-			vxtime.last = hpet_readl(HPET_T0_CMP) - hpet_tick;
-		else
-			vxtime.last = hpet_readl(HPET_COUNTER);
-	} else
 		vxtime.last_tsc = get_cycles_sync();
 	write_sequnlock_irqrestore(&xtime_lock,flags);
 	jiffies += sleep_length;
Index: linux-2.6.20-rc5/arch/x86_64/kernel/vsyscall.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/vsyscall.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/vsyscall.c
@@ -72,18 +72,9 @@ static __always_inline void do_vgettimeo
 		sec = __xtime.tv_sec;
 		usec = __xtime.tv_nsec / 1000;
 
-		if (__vxtime.mode != VXTIME_HPET) {
-			t = get_cycles_sync();
-			if (t < __vxtime.last_tsc)
-				t = __vxtime.last_tsc;
-			usec += ((t - __vxtime.last_tsc) *
-				 __vxtime.tsc_quot) >> 32;
-			/* See comment in x86_64 do_gettimeofday. */
-		} else {
 			usec += ((readl((void __iomem *)
 				   fix_to_virt(VSYSCALL_HPET) + 0xf0) -
 				  __vxtime.last) * __vxtime.quot) >> 32;
-		}
 	} while (read_seqretry(&__xtime_lock, sequence));
 
 	tv->tv_sec = sec + usec / 1000000;
Index: linux-2.6.20-rc5/include/asm-x86_64/vsyscall.h
===================================================================
--- linux-2.6.20-rc5.orig/include/asm-x86_64/vsyscall.h
+++ linux-2.6.20-rc5/include/asm-x86_64/vsyscall.h
@@ -25,7 +25,6 @@ enum vsyscall_num {
 #define __section_xtime_lock __attribute__ ((unused, __section__ (".xtime_lock"), aligned(16)))
 
 #define VXTIME_TSC	1
-#define VXTIME_HPET	2
 
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2

--
