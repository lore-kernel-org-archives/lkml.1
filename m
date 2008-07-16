Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbYGPSQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbYGPSQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 14:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYGPSQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 14:16:06 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64677 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753047AbYGPSQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 14:16:01 -0400
Date: Wed, 16 Jul 2008 19:15:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Use alternatives to select the workaround for the 11AP Pentium erratum
for the affected steppings on the fly rather than build time.  Remove the
X86_GOOD_APIC configuration option and replace all the calls to
apic_write_around() with plain apic_write(), protecting accesses to the
ESR as appropriate due to the 3AP Pentium erratum.  Remove
apic_read_around() and all its invocations altogether as not needed.  
Remove apic_write_atomic() and all its implementing backends.  The use of
ASM_OUTPUT2() is not strictly needed for input constraints, but I have
used it for readability's sake.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
Ingo,

 I had the feeling no one else was brave enough to do it, so I went ahead
and here it is.  Verified by checking the generated assembly and tested
with both a 32-bit and a 64-bit configuration, also with the 11AP
"feature" forced on and verified with gdb on /proc/kcore to work as
expected (as an 11AP machines are quite hard to get hands on these days).  
Some script complained about the use of "volatile", but apic_write() needs
it for the same reason and is effectively a replacement for writel(), so I
have disregarded it.

 This patch applies on top of the patches sent recently, in particular
patch-next-2.6.26-rc9-20080711-ioapic-print-timer-2 sent the other day and
hopefully will apply cleanly to your tree.  I understand you are now busy
merging with Linus, but once you are done with that and get at this patch,
then please do let me know if there are any conflicts and I will
regenerate it against a refreshed tree.

 I am not sure what the policy wrt defconfig files is, they are generated
and there is risk of a conflict resulting from an unrelated change, so I 
have left changes to them out.  The option will get removed from them at 
the next run.

 Some testing with machines other than mine will be needed to avoid some
stupid mistake, but despite its volume, the change is not really that
intrusive, so I am fairly confident that because it works for me, it will
everywhere.

  Maciej

patch-next-2.6.26-rc9-20080711-apic-write-5
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/Kconfig.cpu linux-next-2.6.26-rc9-20080711/arch/x86/Kconfig.cpu
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/Kconfig.cpu	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/Kconfig.cpu	2008-07-16 13:59:09.000000000 +0000
@@ -362,10 +362,6 @@ config X86_ALIGNMENT_16
 	def_bool y
 	depends on MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCYRIXIII || X86_ELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
 
-config X86_GOOD_APIC
-	def_bool y
-	depends on MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || MK8 || MEFFICEON || MCORE2 || MVIAC7 || X86_64
-
 config X86_INTEL_USERCOPY
 	def_bool y
 	depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX || X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/apic_32.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/apic_32.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/apic_32.c	2008-07-16 14:50:07.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/apic_32.c	2008-07-16 14:43:23.000000000 +0000
@@ -177,7 +177,7 @@ void __cpuinit enable_NMI_through_LVT0(v
 	/* Level triggered for 82489DX */
 	if (!lapic_is_integrated())
 		v |= APIC_LVT_LEVEL_TRIGGER;
-	apic_write_around(APIC_LVT0, v);
+	apic_write(APIC_LVT0, v);
 }
 
 /**
@@ -212,9 +212,6 @@ int lapic_get_maxlvt(void)
  * this function twice on the boot CPU, once with a bogus timeout
  * value, second time for real. The other (noncalibrating) CPUs
  * call this function only once, with the real, calibrated value.
- *
- * We do reads before writes even if unnecessary, to get around the
- * P5 APIC double write bug.
  */
 static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 {
@@ -229,18 +226,18 @@ static void __setup_APIC_LVTT(unsigned i
 	if (!irqen)
 		lvtt_value |= APIC_LVT_MASKED;
 
-	apic_write_around(APIC_LVTT, lvtt_value);
+	apic_write(APIC_LVTT, lvtt_value);
 
 	/*
 	 * Divide PICLK by 16
 	 */
 	tmp_value = apic_read(APIC_TDCR);
-	apic_write_around(APIC_TDCR, (tmp_value
-				& ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE))
-				| APIC_TDR_DIV_16);
+	apic_write(APIC_TDCR,
+		   (tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
+		   APIC_TDR_DIV_16);
 
 	if (!oneshot)
-		apic_write_around(APIC_TMICT, clocks/APIC_DIVISOR);
+		apic_write(APIC_TMICT, clocks / APIC_DIVISOR);
 }
 
 /*
@@ -249,7 +246,7 @@ static void __setup_APIC_LVTT(unsigned i
 static int lapic_next_event(unsigned long delta,
 			    struct clock_event_device *evt)
 {
-	apic_write_around(APIC_TMICT, delta);
+	apic_write(APIC_TMICT, delta);
 	return 0;
 }
 
@@ -278,7 +275,7 @@ static void lapic_timer_setup(enum clock
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		v = apic_read(APIC_LVTT);
 		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
-		apic_write_around(APIC_LVTT, v);
+		apic_write(APIC_LVTT, v);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
 		/* Nothing to do here */
@@ -693,44 +690,44 @@ void clear_local_APIC(void)
 	 */
 	if (maxlvt >= 3) {
 		v = ERROR_APIC_VECTOR; /* any non-zero vector will do */
-		apic_write_around(APIC_LVTERR, v | APIC_LVT_MASKED);
+		apic_write(APIC_LVTERR, v | APIC_LVT_MASKED);
 	}
 	/*
 	 * Careful: we have to set masks only first to deassert
 	 * any level-triggered sources.
 	 */
 	v = apic_read(APIC_LVTT);
-	apic_write_around(APIC_LVTT, v | APIC_LVT_MASKED);
+	apic_write(APIC_LVTT, v | APIC_LVT_MASKED);
 	v = apic_read(APIC_LVT0);
-	apic_write_around(APIC_LVT0, v | APIC_LVT_MASKED);
+	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 	v = apic_read(APIC_LVT1);
-	apic_write_around(APIC_LVT1, v | APIC_LVT_MASKED);
+	apic_write(APIC_LVT1, v | APIC_LVT_MASKED);
 	if (maxlvt >= 4) {
 		v = apic_read(APIC_LVTPC);
-		apic_write_around(APIC_LVTPC, v | APIC_LVT_MASKED);
+		apic_write(APIC_LVTPC, v | APIC_LVT_MASKED);
 	}
 
 	/* lets not touch this if we didn't frob it */
 #ifdef CONFIG_X86_MCE_P4THERMAL
 	if (maxlvt >= 5) {
 		v = apic_read(APIC_LVTTHMR);
-		apic_write_around(APIC_LVTTHMR, v | APIC_LVT_MASKED);
+		apic_write(APIC_LVTTHMR, v | APIC_LVT_MASKED);
 	}
 #endif
 	/*
 	 * Clean APIC state for other OSs:
 	 */
-	apic_write_around(APIC_LVTT, APIC_LVT_MASKED);
-	apic_write_around(APIC_LVT0, APIC_LVT_MASKED);
-	apic_write_around(APIC_LVT1, APIC_LVT_MASKED);
+	apic_write(APIC_LVTT, APIC_LVT_MASKED);
+	apic_write(APIC_LVT0, APIC_LVT_MASKED);
+	apic_write(APIC_LVT1, APIC_LVT_MASKED);
 	if (maxlvt >= 3)
-		apic_write_around(APIC_LVTERR, APIC_LVT_MASKED);
+		apic_write(APIC_LVTERR, APIC_LVT_MASKED);
 	if (maxlvt >= 4)
-		apic_write_around(APIC_LVTPC, APIC_LVT_MASKED);
+		apic_write(APIC_LVTPC, APIC_LVT_MASKED);
 
 #ifdef CONFIG_X86_MCE_P4THERMAL
 	if (maxlvt >= 5)
-		apic_write_around(APIC_LVTTHMR, APIC_LVT_MASKED);
+		apic_write(APIC_LVTTHMR, APIC_LVT_MASKED);
 #endif
 	/* Integrated APIC (!82489DX) ? */
 	if (lapic_is_integrated()) {
@@ -756,7 +753,7 @@ void disable_local_APIC(void)
 	 */
 	value = apic_read(APIC_SPIV);
 	value &= ~APIC_SPIV_APIC_ENABLED;
-	apic_write_around(APIC_SPIV, value);
+	apic_write(APIC_SPIV, value);
 
 	/*
 	 * When LAPIC was disabled by the BIOS and enabled by the kernel,
@@ -865,8 +862,8 @@ void __init sync_Arb_IDs(void)
 	apic_wait_icr_idle();
 
 	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
-	apic_write_around(APIC_ICR, APIC_DEST_ALLINC | APIC_INT_LEVELTRIG
-				| APIC_DM_INIT);
+	apic_write(APIC_ICR,
+		   APIC_DEST_ALLINC | APIC_INT_LEVELTRIG | APIC_DM_INIT);
 }
 
 /*
@@ -902,16 +899,16 @@ void __init init_bsp_APIC(void)
 	else
 		value |= APIC_SPIV_FOCUS_DISABLED;
 	value |= SPURIOUS_APIC_VECTOR;
-	apic_write_around(APIC_SPIV, value);
+	apic_write(APIC_SPIV, value);
 
 	/*
 	 * Set up the virtual wire mode.
 	 */
-	apic_write_around(APIC_LVT0, APIC_DM_EXTINT);
+	apic_write(APIC_LVT0, APIC_DM_EXTINT);
 	value = APIC_DM_NMI;
 	if (!lapic_is_integrated())		/* 82489DX */
 		value |= APIC_LVT_LEVEL_TRIGGER;
-	apic_write_around(APIC_LVT1, value);
+	apic_write(APIC_LVT1, value);
 }
 
 static void __cpuinit lapic_setup_esr(void)
@@ -926,7 +923,7 @@ static void __cpuinit lapic_setup_esr(vo
 
 		/* enables sending errors */
 		value = ERROR_APIC_VECTOR;
-		apic_write_around(APIC_LVTERR, value);
+		apic_write(APIC_LVTERR, value);
 		/*
 		 * spec says clear errors after enabling vector.
 		 */
@@ -989,7 +986,7 @@ void __cpuinit setup_local_APIC(void)
 	 */
 	value = apic_read(APIC_TASKPRI);
 	value &= ~APIC_TPRI_MASK;
-	apic_write_around(APIC_TASKPRI, value);
+	apic_write(APIC_TASKPRI, value);
 
 	/*
 	 * After a crash, we no longer service the interrupts and a pending
@@ -1047,7 +1044,7 @@ void __cpuinit setup_local_APIC(void)
 	 * Set spurious IRQ vector
 	 */
 	value |= SPURIOUS_APIC_VECTOR;
-	apic_write_around(APIC_SPIV, value);
+	apic_write(APIC_SPIV, value);
 
 	/*
 	 * Set up LVT0, LVT1:
@@ -1069,7 +1066,7 @@ void __cpuinit setup_local_APIC(void)
 		apic_printk(APIC_VERBOSE, "masked ExtINT on CPU#%d\n",
 				smp_processor_id());
 	}
-	apic_write_around(APIC_LVT0, value);
+	apic_write(APIC_LVT0, value);
 
 	/*
 	 * only the BP should see the LINT1 NMI signal, obviously.
@@ -1080,7 +1077,7 @@ void __cpuinit setup_local_APIC(void)
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
 	if (!integrated)		/* 82489DX */
 		value |= APIC_LVT_LEVEL_TRIGGER;
-	apic_write_around(APIC_LVT1, value);
+	apic_write(APIC_LVT1, value);
 }
 
 void __cpuinit end_local_APIC_setup(void)
@@ -1091,7 +1088,7 @@ void __cpuinit end_local_APIC_setup(void
 	/* Disable the local apic timer */
 	value = apic_read(APIC_LVTT);
 	value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
-	apic_write_around(APIC_LVTT, value);
+	apic_write(APIC_LVTT, value);
 
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
@@ -1419,7 +1416,7 @@ void disconnect_bsp_APIC(int virt_wire_s
 		value &= ~APIC_VECTOR_MASK;
 		value |= APIC_SPIV_APIC_ENABLED;
 		value |= 0xf;
-		apic_write_around(APIC_SPIV, value);
+		apic_write(APIC_SPIV, value);
 
 		if (!virt_wire_setup) {
 			/*
@@ -1432,10 +1429,10 @@ void disconnect_bsp_APIC(int virt_wire_s
 				APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED);
 			value |= APIC_LVT_REMOTE_IRR | APIC_SEND_PENDING;
 			value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_EXTINT);
-			apic_write_around(APIC_LVT0, value);
+			apic_write(APIC_LVT0, value);
 		} else {
 			/* Disable LVT0 */
-			apic_write_around(APIC_LVT0, APIC_LVT_MASKED);
+			apic_write(APIC_LVT0, APIC_LVT_MASKED);
 		}
 
 		/*
@@ -1449,7 +1446,7 @@ void disconnect_bsp_APIC(int virt_wire_s
 			APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED);
 		value |= APIC_LVT_REMOTE_IRR | APIC_SEND_PENDING;
 		value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_NMI);
-		apic_write_around(APIC_LVT1, value);
+		apic_write(APIC_LVT1, value);
 	}
 }
 
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/cpu/bugs.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/cpu/bugs.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/cpu/bugs.c	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/cpu/bugs.c	2008-07-16 13:55:47.000000000 +0000
@@ -131,13 +131,7 @@ static void __init check_popad(void)
  *   (for due to lack of "invlpg" and working WP on a i386)
  * - In order to run on anything without a TSC, we need to be
  *   compiled for a i486.
- * - In order to support the local APIC on a buggy Pentium machine,
- *   we need to be compiled with CONFIG_X86_GOOD_APIC disabled,
- *   which happens implicitly if compiled for a Pentium or lower
- *   (unless an advanced selection of CPU features is used) as an
- *   otherwise config implies a properly working local APIC without
- *   the need to do extra reads from the APIC.
-*/
+ */
 
 static void __init check_config(void)
 {
@@ -151,21 +145,6 @@ static void __init check_config(void)
 	if (boot_cpu_data.x86 == 3)
 		panic("Kernel requires i486+ for 'invlpg' and other features");
 #endif
-
-/*
- * If we were told we had a good local APIC, check for buggy Pentia,
- * i.e. all B steppings and the C2 stepping of P54C when using their
- * integrated APIC (see 11AP erratum in "Pentium Processor
- * Specification Update").
- */
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_GOOD_APIC)
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL
-	    && cpu_has_apic
-	    && boot_cpu_data.x86 == 5
-	    && boot_cpu_data.x86_model == 2
-	    && (boot_cpu_data.x86_mask < 6 || boot_cpu_data.x86_mask == 11))
-		panic("Kernel compiled for PMMX+, assumes a local APIC without the read-before-write bug!");
-#endif
 }
 
 
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/cpu/intel.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/cpu/intel.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/cpu/intel.c	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/cpu/intel.c	2008-07-16 13:53:45.000000000 +0000
@@ -226,6 +226,16 @@ static void __cpuinit init_intel(struct 
 
 	if (cpu_has_bts)
 		ds_init_intel(c);
+
+	/*
+	 * See if we have a good local APIC by checking for buggy Pentia,
+	 * i.e. all B steppings and the C2 stepping of P54C when using their
+	 * integrated APIC (see 11AP erratum in "Pentium Processor
+	 * Specification Update").
+	 */
+	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
+	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
+		set_cpu_cap(c, X86_FEATURE_11AP);
 }
 
 static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/cpu/mcheck/p4.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/cpu/mcheck/p4.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/cpu/mcheck/p4.c	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/cpu/mcheck/p4.c	2008-07-16 14:43:47.000000000 +0000
@@ -102,7 +102,7 @@ static void intel_init_thermal(struct cp
 	/* The temperature transition interrupt handler setup */
 	h = THERMAL_APIC_VECTOR;		/* our delivery vector */
 	h |= (APIC_DM_FIXED | APIC_LVT_MASKED);	/* we'll mask till we're ready */
-	apic_write_around(APIC_LVTTHMR, h);
+	apic_write(APIC_LVTTHMR, h);
 
 	rdmsr(MSR_IA32_THERM_INTERRUPT, l, h);
 	wrmsr(MSR_IA32_THERM_INTERRUPT, l | 0x03 , h);
@@ -114,7 +114,7 @@ static void intel_init_thermal(struct cp
 	wrmsr(MSR_IA32_MISC_ENABLE, l | (1<<3), h);
 
 	l = apic_read(APIC_LVTTHMR);
-	apic_write_around(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
+	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
 	printk(KERN_INFO "CPU%d: Thermal monitoring enabled\n", cpu);
 
 	/* enable thermal throttle processing */
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_32.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_32.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_32.c	2008-07-14 16:59:41.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_32.c	2008-07-16 15:04:33.000000000 +0000
@@ -763,7 +763,7 @@ void send_IPI_self(int vector)
 	/*
 	 * Send the IPI. The write to APIC_ICR fires this off.
 	 */
-	apic_write_around(APIC_ICR, cfg);
+	apic_write(APIC_ICR, cfg);
 }
 #endif /* !CONFIG_SMP */
 
@@ -2037,7 +2037,7 @@ static void mask_lapic_irq(unsigned int 
 	unsigned long v;
 
 	v = apic_read(APIC_LVT0);
-	apic_write_around(APIC_LVT0, v | APIC_LVT_MASKED);
+	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 }
 
 static void unmask_lapic_irq(unsigned int irq)
@@ -2045,7 +2045,7 @@ static void unmask_lapic_irq(unsigned in
 	unsigned long v;
 
 	v = apic_read(APIC_LVT0);
-	apic_write_around(APIC_LVT0, v & ~APIC_LVT_MASKED);
+	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
 static struct irq_chip lapic_chip __read_mostly = {
@@ -2175,7 +2175,7 @@ static inline void __init check_timer(vo
 	 * The AEOI mode will finish them in the 8259A
 	 * automatically.
 	 */
-	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
+	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
 	timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
 
@@ -2270,7 +2270,7 @@ static inline void __init check_timer(vo
 		    "...trying to set up timer as Virtual Wire IRQ...\n");
 
 	lapic_register_intr(0, vector);
-	apic_write_around(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
+	apic_write(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
 	if (timer_irq_works()) {
@@ -2278,7 +2278,7 @@ static inline void __init check_timer(vo
 		goto out;
 	}
 	disable_8259A_irq(0);
-	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | vector);
+	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | vector);
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed.\n");
 
 	apic_printk(APIC_QUIET, KERN_INFO
@@ -2286,7 +2286,7 @@ static inline void __init check_timer(vo
 
 	init_8259A(0);
 	make_8259A_irq(0);
-	apic_write_around(APIC_LVT0, APIC_DM_EXTINT);
+	apic_write(APIC_LVT0, APIC_DM_EXTINT);
 
 	unlock_ExtINT_logic();
 
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/ipi.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/ipi.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/ipi.c	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/ipi.c	2008-07-16 14:46:12.000000000 +0000
@@ -70,7 +70,7 @@ void __send_IPI_shortcut(unsigned int sh
 	/*
 	 * Send the IPI. The write to APIC_ICR fires this off.
 	 */
-	apic_write_around(APIC_ICR, cfg);
+	apic_write(APIC_ICR, cfg);
 }
 
 void send_IPI_self(int vector)
@@ -98,7 +98,7 @@ static inline void __send_IPI_dest_field
 	 * prepare target chip field
 	 */
 	cfg = __prepare_ICR2(mask);
-	apic_write_around(APIC_ICR2, cfg);
+	apic_write(APIC_ICR2, cfg);
 
 	/*
 	 * program the ICR
@@ -108,7 +108,7 @@ static inline void __send_IPI_dest_field
 	/*
 	 * Send the IPI. The write to APIC_ICR fires this off.
 	 */
-	apic_write_around(APIC_ICR, cfg);
+	apic_write(APIC_ICR, cfg);
 }
 
 /*
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/nmi.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/nmi.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/nmi.c	2008-07-13 02:18:46.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/nmi.c	2008-07-16 14:46:23.000000000 +0000
@@ -260,7 +260,7 @@ late_initcall(init_lapic_nmi_sysfs);
 
 static void __acpi_nmi_enable(void *__unused)
 {
-	apic_write_around(APIC_LVT0, APIC_DM_NMI);
+	apic_write(APIC_LVT0, APIC_DM_NMI);
 }
 
 /*
@@ -274,7 +274,7 @@ void acpi_nmi_enable(void)
 
 static void __acpi_nmi_disable(void *__unused)
 {
-	apic_write_around(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
+	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
 }
 
 /*
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/paravirt.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/paravirt.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/paravirt.c	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/paravirt.c	2008-07-16 14:31:05.000000000 +0000
@@ -361,7 +361,6 @@ struct pv_cpu_ops pv_cpu_ops = {
 struct pv_apic_ops pv_apic_ops = {
 #ifdef CONFIG_X86_LOCAL_APIC
 	.apic_write = native_apic_write,
-	.apic_write_atomic = native_apic_write_atomic,
 	.apic_read = native_apic_read,
 	.setup_boot_clock = setup_boot_APIC_clock,
 	.setup_secondary_clock = setup_secondary_APIC_clock,
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/smpboot.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/smpboot.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/smpboot.c	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/smpboot.c	2008-07-16 14:38:23.000000000 +0000
@@ -546,8 +546,8 @@ static inline void __inquire_remote_apic
 			printk(KERN_CONT
 			       "a previous APIC delivery may have failed\n");
 
-		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(apicid));
-		apic_write_around(APIC_ICR, APIC_DM_REMRD | regs[i]);
+		apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(apicid));
+		apic_write(APIC_ICR, APIC_DM_REMRD | regs[i]);
 
 		timeout = 0;
 		do {
@@ -579,11 +579,11 @@ wakeup_secondary_cpu(int logical_apicid,
 	int maxlvt;
 
 	/* Target chip */
-	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(logical_apicid));
+	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(logical_apicid));
 
 	/* Boot on the stack */
 	/* Kick the second */
-	apic_write_around(APIC_ICR, APIC_DM_NMI | APIC_DEST_LOGICAL);
+	apic_write(APIC_ICR, APIC_DM_NMI | APIC_DEST_LOGICAL);
 
 	Dprintk("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -592,14 +592,9 @@ wakeup_secondary_cpu(int logical_apicid,
 	 * Give the other CPU some time to accept the IPI.
 	 */
 	udelay(200);
-	/*
-	 * Due to the Pentium erratum 3AP.
-	 */
 	maxlvt = lapic_get_maxlvt();
-	if (maxlvt > 3) {
-		apic_read_around(APIC_SPIV);
+	if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
 		apic_write(APIC_ESR, 0);
-	}
 	accept_status = (apic_read(APIC_ESR) & 0xEF);
 	Dprintk("NMI sent.\n");
 
@@ -625,12 +620,14 @@ wakeup_secondary_cpu(int phys_apicid, un
 		return send_status;
 	}
 
+	maxlvt = lapic_get_maxlvt();
+
 	/*
 	 * Be paranoid about clearing APIC errors.
 	 */
 	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
-		apic_read_around(APIC_SPIV);
-		apic_write(APIC_ESR, 0);
+		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP.  */
+			apic_write(APIC_ESR, 0);
 		apic_read(APIC_ESR);
 	}
 
@@ -639,13 +636,13 @@ wakeup_secondary_cpu(int phys_apicid, un
 	/*
 	 * Turn INIT on target chip
 	 */
-	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
+	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
 
 	/*
 	 * Send IPI
 	 */
-	apic_write_around(APIC_ICR, APIC_INT_LEVELTRIG | APIC_INT_ASSERT
-				| APIC_DM_INIT);
+	apic_write(APIC_ICR,
+		   APIC_INT_LEVELTRIG | APIC_INT_ASSERT | APIC_DM_INIT);
 
 	Dprintk("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -655,10 +652,10 @@ wakeup_secondary_cpu(int phys_apicid, un
 	Dprintk("Deasserting INIT.\n");
 
 	/* Target chip */
-	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
+	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
 
 	/* Send IPI */
-	apic_write_around(APIC_ICR, APIC_INT_LEVELTRIG | APIC_DM_INIT);
+	apic_write(APIC_ICR, APIC_INT_LEVELTRIG | APIC_DM_INIT);
 
 	Dprintk("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -689,12 +686,10 @@ wakeup_secondary_cpu(int phys_apicid, un
 	 */
 	Dprintk("#startup loops: %d.\n", num_starts);
 
-	maxlvt = lapic_get_maxlvt();
-
 	for (j = 1; j <= num_starts; j++) {
 		Dprintk("Sending STARTUP #%d.\n", j);
-		apic_read_around(APIC_SPIV);
-		apic_write(APIC_ESR, 0);
+		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP.  */
+			apic_write(APIC_ESR, 0);
 		apic_read(APIC_ESR);
 		Dprintk("After apic_write.\n");
 
@@ -703,12 +698,11 @@ wakeup_secondary_cpu(int phys_apicid, un
 		 */
 
 		/* Target chip */
-		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
+		apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
 
 		/* Boot on the stack */
 		/* Kick the second */
-		apic_write_around(APIC_ICR, APIC_DM_STARTUP
-					| (start_eip >> 12));
+		apic_write(APIC_ICR, APIC_DM_STARTUP | (start_eip >> 12));
 
 		/*
 		 * Give the other CPU some time to accept the IPI.
@@ -724,13 +718,8 @@ wakeup_secondary_cpu(int phys_apicid, un
 		 * Give the other CPU some time to accept the IPI.
 		 */
 		udelay(200);
-		/*
-		 * Due to the Pentium erratum 3AP.
-		 */
-		if (maxlvt > 3) {
-			apic_read_around(APIC_SPIV);
+		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP.  */
 			apic_write(APIC_ESR, 0);
-		}
 		accept_status = (apic_read(APIC_ESR) & 0xEF);
 		if (send_status || accept_status)
 			break;
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/vmi_32.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/vmi_32.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/vmi_32.c	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/vmi_32.c	2008-07-16 14:30:19.000000000 +0000
@@ -906,7 +906,6 @@ static inline int __init activate_vmi(vo
 #ifdef CONFIG_X86_LOCAL_APIC
 	para_fill(pv_apic_ops.apic_read, APICRead);
 	para_fill(pv_apic_ops.apic_write, APICWrite);
-	para_fill(pv_apic_ops.apic_write_atomic, APICWrite);
 #endif
 
 	/*
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/lguest/boot.c linux-next-2.6.26-rc9-20080711/arch/x86/lguest/boot.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/lguest/boot.c	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/lguest/boot.c	2008-07-16 14:29:55.000000000 +0000
@@ -991,7 +991,6 @@ __init void lguest_init(void)
 #ifdef CONFIG_X86_LOCAL_APIC
 	/* apic read/write intercepts */
 	pv_apic_ops.apic_write = lguest_apic_write;
-	pv_apic_ops.apic_write_atomic = lguest_apic_write;
 	pv_apic_ops.apic_read = lguest_apic_read;
 #endif
 
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/xen/enlighten.c linux-next-2.6.26-rc9-20080711/arch/x86/xen/enlighten.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/xen/enlighten.c	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/xen/enlighten.c	2008-07-16 14:29:32.000000000 +0000
@@ -1131,7 +1131,6 @@ static const struct pv_irq_ops xen_irq_o
 static const struct pv_apic_ops xen_apic_ops __initdata = {
 #ifdef CONFIG_X86_LOCAL_APIC
 	.apic_write = xen_apic_write,
-	.apic_write_atomic = xen_apic_write,
 	.apic_read = xen_apic_read,
 	.setup_boot_clock = paravirt_nop,
 	.setup_secondary_clock = paravirt_nop,
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/apic.h linux-next-2.6.26-rc9-20080711/include/asm-x86/apic.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/apic.h	2008-07-16 14:50:07.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/apic.h	2008-07-16 16:42:03.000000000 +0000
@@ -3,6 +3,8 @@
 
 #include <linux/pm.h>
 #include <linux/delay.h>
+
+#include <asm/alternative.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
 #include <asm/processor.h>
@@ -48,7 +50,6 @@ extern int disable_apic;
 #include <asm/paravirt.h>
 #else
 #define apic_write native_apic_write
-#define apic_write_atomic native_apic_write_atomic
 #define apic_read native_apic_read
 #define setup_boot_clock setup_boot_APIC_clock
 #define setup_secondary_clock setup_secondary_APIC_clock
@@ -58,12 +59,11 @@ extern int is_vsmp_box(void);
 
 static inline void native_apic_write(unsigned long reg, u32 v)
 {
-	*((volatile u32 *)(APIC_BASE + reg)) = v;
-}
-
-static inline void native_apic_write_atomic(unsigned long reg, u32 v)
-{
-	(void)xchg((u32 *)(APIC_BASE + reg), v);
+	volatile u32 *addr = (volatile u32 *)(APIC_BASE + reg);
+	
+	alternative_io("movl %0, %1", "xchgl %0, %1", X86_FEATURE_11AP,
+		       ASM_OUTPUT2("=r" (v), "=m" (*addr)),
+		       ASM_OUTPUT2("0" (v), "m" (*addr)));
 }
 
 static inline u32 native_apic_read(unsigned long reg)
@@ -75,16 +75,6 @@ extern void apic_wait_icr_idle(void);
 extern u32 safe_apic_wait_icr_idle(void);
 extern int get_physical_broadcast(void);
 
-#ifdef CONFIG_X86_GOOD_APIC
-# define FORCE_READ_AROUND_WRITE 0
-# define apic_read_around(x)
-# define apic_write_around(x, y) apic_write((x), (y))
-#else
-# define FORCE_READ_AROUND_WRITE 1
-# define apic_read_around(x) apic_read(x)
-# define apic_write_around(x, y) apic_write_atomic((x), (y))
-#endif
-
 static inline void ack_APIC_irq(void)
 {
 	/*
@@ -95,7 +85,7 @@ static inline void ack_APIC_irq(void)
 	 */
 
 	/* Docs say use 0 for future compatibility */
-	apic_write_around(APIC_EOI, 0);
+	apic_write(APIC_EOI, 0);
 }
 
 extern int lapic_get_maxlvt(void);
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/cpufeature.h linux-next-2.6.26-rc9-20080711/include/asm-x86/cpufeature.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/cpufeature.h	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/cpufeature.h	2008-07-16 13:48:24.000000000 +0000
@@ -79,6 +79,7 @@
 #define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well on this CPU */
 #define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* Mfence synchronizes RDTSC */
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
+#define X86_FEATURE_11AP	(3*32+19)  /* Bad local APIC aka 11AP */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/mach-bigsmp/mach_apic.h linux-next-2.6.26-rc9-20080711/include/asm-x86/mach-bigsmp/mach_apic.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/mach-bigsmp/mach_apic.h	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/mach-bigsmp/mach_apic.h	2008-07-16 14:46:34.000000000 +0000
@@ -63,9 +63,9 @@ static inline void init_apic_ldr(void)
 	unsigned long val;
 	int cpu = smp_processor_id();
 
-	apic_write_around(APIC_DFR, APIC_DFR_VALUE);
+	apic_write(APIC_DFR, APIC_DFR_VALUE);
 	val = calculate_ldr(cpu);
-	apic_write_around(APIC_LDR, val);
+	apic_write(APIC_LDR, val);
 }
 
 static inline void setup_apic_routing(void)
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/mach-default/mach_apic.h linux-next-2.6.26-rc9-20080711/include/asm-x86/mach-default/mach_apic.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/mach-default/mach_apic.h	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/mach-default/mach_apic.h	2008-07-16 14:46:49.000000000 +0000
@@ -46,10 +46,10 @@ static inline void init_apic_ldr(void)
 {
 	unsigned long val;
 
-	apic_write_around(APIC_DFR, APIC_DFR_VALUE);
+	apic_write(APIC_DFR, APIC_DFR_VALUE);
 	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
 	val |= SET_APIC_LOGICAL_ID(1UL << smp_processor_id());
-	apic_write_around(APIC_LDR, val);
+	apic_write(APIC_LDR, val);
 }
 
 static inline int apic_id_registered(void)
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/mach-es7000/mach_apic.h linux-next-2.6.26-rc9-20080711/include/asm-x86/mach-es7000/mach_apic.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/mach-es7000/mach_apic.h	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/mach-es7000/mach_apic.h	2008-07-16 14:47:00.000000000 +0000
@@ -66,9 +66,9 @@ static inline void init_apic_ldr(void)
 	unsigned long val;
 	int cpu = smp_processor_id();
 
-	apic_write_around(APIC_DFR, APIC_DFR_VALUE);
+	apic_write(APIC_DFR, APIC_DFR_VALUE);
 	val = calculate_ldr(cpu);
-	apic_write_around(APIC_LDR, val);
+	apic_write(APIC_LDR, val);
 }
 
 #ifndef CONFIG_X86_GENERICARCH
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/mach-summit/mach_apic.h linux-next-2.6.26-rc9-20080711/include/asm-x86/mach-summit/mach_apic.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/mach-summit/mach_apic.h	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/mach-summit/mach_apic.h	2008-07-16 14:47:17.000000000 +0000
@@ -63,10 +63,10 @@ static inline void init_apic_ldr(void)
 	 * BIOS puts 5 CPUs in one APIC cluster, we're hosed. */
 	BUG_ON(count >= XAPIC_DEST_CPUS_SHIFT);
 	id = my_cluster | (1UL << count);
-	apic_write_around(APIC_DFR, APIC_DFR_VALUE);
+	apic_write(APIC_DFR, APIC_DFR_VALUE);
 	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
 	val |= SET_APIC_LOGICAL_ID(id);
-	apic_write_around(APIC_LDR, val);
+	apic_write(APIC_LDR, val);
 }
 
 static inline int multi_timer_check(int apic, int irq)
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/mach-visws/mach_apic.h linux-next-2.6.26-rc9-20080711/include/asm-x86/mach-visws/mach_apic.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/mach-visws/mach_apic.h	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/mach-visws/mach_apic.h	2008-07-16 14:47:31.000000000 +0000
@@ -37,10 +37,10 @@ static inline void init_apic_ldr(void)
 {
 	unsigned long val;
 
-	apic_write_around(APIC_DFR, APIC_DFR_VALUE);
+	apic_write(APIC_DFR, APIC_DFR_VALUE);
 	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
 	val |= SET_APIC_LOGICAL_ID(1UL << smp_processor_id());
-	apic_write_around(APIC_LDR, val);
+	apic_write(APIC_LDR, val);
 }
 
 static inline void summit_check(char *oem, char *productid) 
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/paravirt.h linux-next-2.6.26-rc9-20080711/include/asm-x86/paravirt.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/paravirt.h	2008-07-16 16:37:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/paravirt.h	2008-07-16 14:28:39.000000000 +0000
@@ -205,7 +205,6 @@ struct pv_apic_ops {
 	 * these shouldn't be in this interface.
 	 */
 	void (*apic_write)(unsigned long reg, u32 v);
-	void (*apic_write_atomic)(unsigned long reg, u32 v);
 	u32 (*apic_read)(unsigned long reg);
 	void (*setup_boot_clock)(void);
 	void (*setup_secondary_clock)(void);
@@ -896,11 +895,6 @@ static inline void apic_write(unsigned l
 	PVOP_VCALL2(pv_apic_ops.apic_write, reg, v);
 }
 
-static inline void apic_write_atomic(unsigned long reg, u32 v)
-{
-	PVOP_VCALL2(pv_apic_ops.apic_write_atomic, reg, v);
-}
-
 static inline u32 apic_read(unsigned long reg)
 {
 	return PVOP_CALL1(unsigned long, pv_apic_ops.apic_read, reg);
