Return-Path: <linux-kernel-owner+w=401wt.eu-S1422812AbXBAL3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422812AbXBAL3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422814AbXBAL3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:29:15 -0500
Received: from styx.suse.cz ([82.119.242.94]:54133 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422812AbXBAL3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:29:13 -0500
Message-Id: <20070201103754.041245000@jet.suse.cz>
References: <20070201095952.589234000@jet.suse.cz>
User-Agent: quilt/0.44-16.5
Date: Thu, 01 Feb 2007 10:59:59 +0100
From: jbohac@suse.cz
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: [patch 7/9] Adapt the time initialization code
Content-Disposition: inline; filename=time_init
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We need to:
 - initialize the RDTSCP instruction if available
 - decide which hardware timer to use as MT (PM or HPET)
 - decide what level of TSC->MT approximation to use
   - none (as slow as the hardware MT can get) -- "notsc" option
   - strictly monotonic (can't be done in a vsyscall) -- default
   - unguaranteed monotonicity (very fast, vsyscall) -- "nomonotonic" option

Signed-off-by: Jiri Bohac <jbohac@suse.cz>

Index: linux-2.6.20-rc5/arch/x86_64/kernel/smpboot.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/smpboot.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/smpboot.c
@@ -318,6 +318,8 @@ static inline void set_cpu_sibling_map(i
 	}
 }
 
+extern void time_initialize_cpu(void);
+
 /*
  * Setup code on secondary processor (after comming out of the trampoline)
  */
@@ -345,6 +347,7 @@ void __cpuinit start_secondary(void)
 		enable_NMI_through_LVT0(NULL);
 		enable_8259A_irq(0);
 	}
+	time_initialize_cpu();
 
 	enable_APIC_timer();
 
@@ -963,6 +966,8 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	return err;
 }
 
+extern void time_init_gtod(void);
+
 /*
  * Finish the SMP boot.
  */
Index: linux-2.6.20-rc5/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/time.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/time.c
@@ -968,6 +968,16 @@ static struct irqaction irq0 = {
 	timer_interrupt, IRQF_DISABLED, CPU_MASK_NONE, "timer", NULL, NULL
 };
 
+static void time_init_rdtsc(void)
+{
+	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP)) {
+		int p;
+		p = smp_processor_id();
+		printk(KERN_INFO "Initializing RDTSCP feature on cpu %d.\n", p);
+		write_rdtscp_aux(p);
+	}
+}
+
 void __init time_init(void)
 {
 	if (nohpet)
@@ -979,27 +989,40 @@ void __init time_init(void)
 	set_normalized_timespec(&wall_to_monotonic,
 	                        -xtime.tv_sec, -xtime.tv_nsec);
 
-	if (!hpet_init())
-                vxtime_hz = (FSEC_PER_SEC + hpet_period / 2) / hpet_period;
-	else
-		vxtime.hpet_address = 0;
+	/* decide what to use as Master Timer: HPET or PM? */
+	if (!hpet_init()) {
+		vxtime.mt_q = (hpet_period << 32) / FSEC_PER_NSEC;
+		mt_per_tick = hpet_use_timer ?
+			hpet_tick : LATCH * 12;
+		read_master_timer = read_master_timer_hpet;
+		timename = "HPET";
+	} else
+	if (pmtmr_ioport) {
+		vxtime.mt_q = (NSEC_PER_SEC << 32) / 916363636UL;
+		mt_per_tick = (LATCH * 3) << 8;
+		read_master_timer = read_master_timer_pm;
+		timename = "PM timer";
+	} else
+		panic("No suitable Master Timer found.\n");
 
-	if (hpet_use_timer) {
-		/* set tick_nsec to use the proper rate for HPET */
-	  	tick_nsec = TICK_NSEC_HPET;
+	/* use PIT as main timer interrupt source if we can't use HPET */
+	if (hpet_use_timer)
 		cpu_khz = hpet_calibrate_tsc();
-		timename = "HPET";
-	} else {
+	else {
 		pit_init();
 		cpu_khz = pit_calibrate_tsc();
-		timename = "PIT";
 	}
 
-	vxtime.mode = VXTIME_TSC;
-	vxtime.quot = (USEC_PER_SEC << US_SCALE) / vxtime_hz;
-	vxtime.tsc_quot = (USEC_PER_MSEC << US_SCALE) / cpu_khz;
-	vxtime.last_tsc = get_cycles_sync();
-	set_cyc2ns_scale(cpu_khz);
+	/* initialize the master timer */
+	set_master_timer64(0);
+
+	/* initialize the timekeeping variables of the boot CPU */
+	vxtime.cpu[0].tsc_last = get_cycles_sync();
+	vxtime.cpu[0].mt_last = vxtime.cpu[0].mt_base = 0;
+	vxtime.cpu[0].tsc_slope = vxtime.cpu[0].tsc_slope_avg = (((USEC_PER_SEC << 32) / vxtime.mt_q) << TSC_SLOPE_SCALE) / cpu_khz;
+	time_init_rdtsc();
+
+	vxtime.mode = VXTIME_TSCS; /* not sure yet if CPUs have synced TSCs */
 	setup_irq(0, &irq0);
 
 #ifndef CONFIG_SMP
@@ -1037,28 +1060,71 @@ __cpuinit int unsynchronized_tsc(void)
  */
 void time_init_gtod(void)
 {
-	char *timetype;
-
-	if (unsynchronized_tsc())
-		notsc = 1;
+	char *tsc_method;
 
  	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
 		vgetcpu_mode = VGETCPU_RDTSCP;
 	else
 		vgetcpu_mode = VGETCPU_LSL;
 
-		timetype = hpet_use_timer ? "HPET/TSC" : "PIT/TSC";
+	if (notsc) {
+		tsc_method = "nothing";
+		vxtime.mode = VXTIME_MT;
+	}
+	else if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP)) {
+		if (nomonotonic) {
+			tsc_method = "RDTSCP";
+			vxtime.mode = VXTIME_TSCP;
+		}
+		else {
+			tsc_method = "RDTSCM (syscall)";
+			vxtime.mode = VXTIME_TSCM;
+		}
+	}
+	else {
+		tsc_method = "RDTSC";
 		vxtime.mode = VXTIME_TSC;
+#ifdef CONFIG_SMP
+		if (unsynchronized_tsc()) {
+			if (nomonotonic) {
+				tsc_method = "RDTSC (syscall)";
+				vxtime.mode = VXTIME_TSCS;
+			}
+			else {
+				tsc_method = "RDTSCM (syscall)";
+				vxtime.mode = VXTIME_TSCM;
+			}
+		}
+#endif
+ 	}
+
 
-	printk(KERN_INFO "time.c: Using %ld.%06ld MHz WALL %s GTOD %s timer.\n",
-	       vxtime_hz / 1000000, vxtime_hz % 1000000, timename, timetype);
+	printk(KERN_INFO "time.c: Using %s as master timer, %s for time caching; vsyscall %s.\n",
+	       timename, tsc_method, sysctl_vsyscall ? "enabled" : "disabled");
+	printk(KERN_INFO "time.c: Using %s as interrupt source.\n",
+	       hpet_use_timer ? "HPET" : "PIT");
 	printk(KERN_INFO "time.c: Detected %d.%03d MHz processor.\n",
 		cpu_khz / 1000, cpu_khz % 1000);
-	vxtime.quot = (USEC_PER_SEC << US_SCALE) / vxtime_hz;
-	vxtime.tsc_quot = (USEC_PER_MSEC << US_SCALE) / cpu_khz;
-	vxtime.last_tsc = get_cycles_sync();
+}
 
-	set_cyc2ns_scale(cpu_khz);
+/*
+ * initialize the per_cpu timekeeping variables
+ * for non-boot CPUs
+ */
+void time_initialize_cpu(void *info)
+{
+	unsigned long flags;
+	int cpu = smp_processor_id();
+	u64 mt_now;
+	write_seqlock_irqsave(&xtime_lock, flags);
+	mt_now = get_master_timer64();
+	vxtime.cpu[cpu].tsc_last = get_cycles_sync();
+	vxtime.cpu[cpu].mt_last = mt_now;
+	vxtime.cpu[cpu].mt_base = mt_now;
+	vxtime.cpu[cpu].tsc_slope = vxtime.cpu[0].tsc_slope;
+	vxtime.cpu[cpu].tsc_slope_avg = vxtime.cpu[0].tsc_slope_avg;
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+	time_init_rdtsc();
 }
 
 __setup("report_lost_ticks", time_setup);
@@ -1098,19 +1164,38 @@ static int timer_resume(struct sys_devic
 		sleep_length = 0;
 		ctime = sleep_start;
 	}
-	if (vxtime.hpet_address)
+
+	write_seqlock_irqsave(&xtime_lock,flags);
+
+	/* reenable the Master Timer */
+	if (read_master_timer == read_master_timer_hpet || hpet_use_timer)
 		hpet_reenable();
+	/* reenable PIT if used as main timer interrupt source */
 	else
 		i8254_timer_resume();
 
 	sec = ctime + clock_cmos_diff;
-	write_seqlock_irqsave(&xtime_lock,flags);
 	xtime.tv_sec = sec;
 	xtime.tv_nsec = 0;
-		vxtime.last_tsc = get_cycles_sync();
-	write_sequnlock_irqrestore(&xtime_lock,flags);
+
+	/* re-initialize the master timer */
+	add_master_timer64(sleep_length * mt_per_tick);
+	vxtime.mt_wall += sleep_length * mt_per_tick;
+
 	jiffies += sleep_length;
-	monotonic_base += sleep_length * (NSEC_PER_SEC/HZ);
+
+	/* re-initialize the timekeeping variables of the boot CPU */
+	vxtime.cpu[0].tsc_last = get_cycles_sync();
+	vxtime.cpu[0].mt_last = vxtime.cpu[0].mt_base = get_master_timer64();
+	/* FIXME: what speed does the cpu really start at; I doubt cpu_khz is right at this point ??!!!
+	   And what speed do the non-boot cpus start at? Their timekeeping variables will probably be set wrong
+	   by copying from CPU 0 in time_initialize_cpu(); Not a great deal, as they will be synced somehow,
+	   but not exactly nice -JB */
+	vxtime.cpu[0].tsc_slope = vxtime.cpu[0].tsc_slope_avg =
+		(((USEC_PER_SEC << 32) / vxtime.mt_q) << TSC_SLOPE_SCALE) / cpu_khz;
+
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+	
 	touch_softlockup_watchdog();
 	return 0;
 }
@@ -1402,3 +1487,11 @@ int __init notsc_setup(char *s)
 }
 
 __setup("notsc", notsc_setup);
+
+int __init nomonotonic_setup(char *s)
+{
+	nomonotonic = 1;
+	return 1;
+}
+
+__setup("nomonotonic", nomonotonic_setup);
Index: linux-2.6.20-rc5/include/linux/time.h
===================================================================
--- linux-2.6.20-rc5.orig/include/linux/time.h
+++ linux-2.6.20-rc5/include/linux/time.h
@@ -31,6 +31,7 @@ struct timezone {
 #define MSEC_PER_SEC	1000L
 #define USEC_PER_MSEC	1000L
 #define NSEC_PER_USEC	1000L
+#define FSEC_PER_NSEC 	1000000L
 #define NSEC_PER_MSEC	1000000L
 #define USEC_PER_SEC	1000000L
 #define NSEC_PER_SEC	1000000000L

--
