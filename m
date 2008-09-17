Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbYIQIaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbYIQIaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbYIQI2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:28:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:29713 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbYIQI2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=r+wVBSLcY2pogJlzZQ9iAG+nrPfS+G/+IClUBEp/Vxg7JqswDUKw4yP5JeJxLGNQRX
         tCELr8aV1U8QisHwpYNdInpLKZRLm+bb6qpXZmewXcQBAi4Oe16XMz/ZqVl8D1ULOLgT
         zQpZgIYSZUvf3jSacJi0aFjvrbRqDN4N5HD50=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 6/6] x86: add KERN_APIC
Date: Wed, 17 Sep 2008 01:27:47 -0700
Message-Id: <1221640067-24389-7-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and kill apic_printk
using loglevel=apic:8 intead

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 Documentation/kernel-parameters.txt         |    6 
 arch/x86/kernel/apic.c                      |  108 +++++-------
 arch/x86/kernel/io_apic.c                   |  235 +++++++++++++---------------
 arch/x86/kernel/mpparse.c                   |   10 -
 arch/x86/kernel/smpboot.c                   |   11 -
 include/asm-x86/apic.h                      |   20 --
 include/asm-x86/es7000/wakecpu.h            |    6 
 include/asm-x86/mach-default/mach_wakecpu.h |    6 
 8 files changed, 178 insertions(+), 224 deletions(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -306,12 +306,6 @@ and is between 256 and 4096 characters.
 			not play well with APC CPU idle - disable it if you have
 			APC and your system crashes randomly.
 
-	apic=		[APIC,i386] Advanced Programmable Interrupt Controller
-			Change the output verbosity whilst booting
-			Format: { quiet (default) | verbose | debug }
-			Change the amount of debugging information output
-			when initialising the APIC and IO-APIC components.
-
 	apm=		[APM] Advanced Power Management
 			See header of arch/x86/kernel/apm_32.c.
 
Index: linux-2.6/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic.c
+++ linux-2.6/arch/x86/kernel/apic.c
@@ -58,6 +58,8 @@
 # error SPURIOUS_APIC_VECTOR definition error
 #endif
 
+DEFINE_LOGLEVEL_SETUP_DEF(apic, KERN_APIC, "apic:", 6);
+
 #ifdef CONFIG_X86_32
 /*
  * Knob to control our willingness to enable the local APIC.
@@ -123,8 +125,6 @@ char system_vectors[NR_VECTORS] = { [0 .
 /*
  * Debug level, exported for io_apic.c
  */
-unsigned int apic_verbosity;
-
 int pic_mode;
 
 /* Have we found an MP table */
@@ -549,7 +549,7 @@ static int __init calibrate_by_pmtimer(l
 	return -1;
 #endif
 
-	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
+	printk(APIC_VERBOSE "... PM timer delta = %ld\n", deltapm);
 
 	/* Check, if the PM timer is available */
 	if (!deltapm)
@@ -559,17 +559,17 @@ static int __init calibrate_by_pmtimer(l
 
 	if (deltapm > (pm_100ms - pm_thresh) &&
 	    deltapm < (pm_100ms + pm_thresh)) {
-		apic_printk(APIC_VERBOSE, "... PM timer result ok\n");
+		printk(APIC_VERBOSE "... PM timer result ok\n");
 	} else {
 		res = (((u64)deltapm) *  mult) >> 22;
 		do_div(res, 1000000);
-		printk(KERN_WARNING "APIC calibration not consistent "
+		printk(KERN_WARNING KERN_APIC "APIC calibration not consistent "
 			"with PM Timer: %ldms instead of 100ms\n",
 			(long)res);
 		/* Correct the lapic counter value */
 		res = (((u64)(*delta)) * pm_100ms);
 		do_div(res, deltapm);
-		printk(KERN_INFO "APIC delta adjusted to PM-Timer: "
+		printk(KERN_INFO KERN_APIC "APIC delta adjusted to PM-Timer: "
 			"%lu (%ld)\n", (unsigned long)res, *delta);
 		*delta = (long)res;
 	}
@@ -610,7 +610,7 @@ static int __init calibrate_APIC_clock(v
 
 	/* Build delta t1-t2 as apic timer counts down */
 	delta = lapic_cal_t1 - lapic_cal_t2;
-	apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);
+	printk(APIC_VERBOSE "... lapic delta = %ld\n", delta);
 
 	/* we trust the PM based calibration if possible */
 	pm_referenced = !calibrate_by_pmtimer(lapic_cal_pm2 - lapic_cal_pm1,
@@ -626,20 +626,20 @@ static int __init calibrate_APIC_clock(v
 
 	calibration_result = (delta * APIC_DIVISOR) / LAPIC_CAL_LOOPS;
 
-	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
-	apic_printk(APIC_VERBOSE, "..... mult: %ld\n", lapic_clockevent.mult);
-	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
+	printk(APIC_VERBOSE "..... delta %ld\n", delta);
+	printk(APIC_VERBOSE "..... mult: %ld\n", lapic_clockevent.mult);
+	printk(APIC_VERBOSE "..... calibration result: %u\n",
 		    calibration_result);
 
 	if (cpu_has_tsc) {
 		delta = (long)(lapic_cal_tsc2 - lapic_cal_tsc1);
-		apic_printk(APIC_VERBOSE, "..... CPU clock speed is "
+		printk(APIC_VERBOSE "..... CPU clock speed is "
 			    "%ld.%04ld MHz.\n",
 			    (delta / LAPIC_CAL_LOOPS) / (1000000 / HZ),
 			    (delta / LAPIC_CAL_LOOPS) % (1000000 / HZ));
 	}
 
-	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
+	printk(APIC_VERBOSE "..... host bus clock speed is "
 		    "%u.%04u MHz.\n",
 		    calibration_result / (1000000 / HZ),
 		    calibration_result % (1000000 / HZ));
@@ -649,7 +649,7 @@ static int __init calibrate_APIC_clock(v
 	 */
 	if (calibration_result < (1000000 / HZ)) {
 		local_irq_enable();
-		printk(KERN_WARNING
+		printk(KERN_WARNING KERN_APIC
 		       "APIC frequency too slow, disabling apic timer\n");
 		return -1;
 	}
@@ -661,7 +661,7 @@ static int __init calibrate_APIC_clock(v
 	 * so lets try APIC timer based calibration
 	 */
 	if (!pm_referenced) {
-		apic_printk(APIC_VERBOSE, "... verify APIC timer\n");
+		printk(APIC_VERBOSE "... verify APIC timer\n");
 
 		/*
 		 * Setup the apic timer manually
@@ -685,18 +685,18 @@ static int __init calibrate_APIC_clock(v
 
 		/* Jiffies delta */
 		deltaj = lapic_cal_j2 - lapic_cal_j1;
-		apic_printk(APIC_VERBOSE, "... jiffies delta = %lu\n", deltaj);
+		printk(APIC_VERBOSE "... jiffies delta = %lu\n", deltaj);
 
 		/* Check, if the jiffies result is consistent */
 		if (deltaj >= LAPIC_CAL_LOOPS-2 && deltaj <= LAPIC_CAL_LOOPS+2)
-			apic_printk(APIC_VERBOSE, "... jiffies result ok\n");
+			printk(APIC_VERBOSE "... jiffies result ok\n");
 		else
 			levt->features |= CLOCK_EVT_FEAT_DUMMY;
 	} else
 		local_irq_enable();
 
 	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
-		printk(KERN_WARNING
+		printk(KERN_WARNING KERN_APIC
 		       "APIC timer disabled due to verification failure.\n");
 			return -1;
 	}
@@ -718,7 +718,7 @@ void __init setup_boot_APIC_clock(void)
 	 * broadcast mechanism is used. On UP systems simply ignore it.
 	 */
 	if (disable_apic_timer) {
-		printk(KERN_INFO "Disabling APIC timer\n");
+		printk(KERN_INFO KERN_APIC "Disabling APIC timer\n");
 		/* No broadcast on UP ! */
 		if (num_possible_cpus() > 1) {
 			lapic_clockevent.mult = 1;
@@ -727,7 +727,7 @@ void __init setup_boot_APIC_clock(void)
 		return;
 	}
 
-	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
+	printk(APIC_VERBOSE "Using local APIC timer interrupts.\n"
 		    "calibrating APIC timer ...\n");
 
 	if (calibrate_APIC_clock()) {
@@ -745,7 +745,7 @@ void __init setup_boot_APIC_clock(void)
 	if (nmi_watchdog != NMI_IO_APIC)
 		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
 	else
-		printk(KERN_WARNING "APIC timer registered as dummy,"
+		printk(KERN_WARNING KERN_APIC "APIC timer registered as dummy,"
 			" due to nmi_watchdog=%d!\n", nmi_watchdog);
 
 	/* Setup the lapic or request the broadcast */
@@ -777,7 +777,7 @@ static void local_apic_timer_interrupt(v
 	 * spurious.
 	 */
 	if (!evt->event_handler) {
-		printk(KERN_WARNING
+		printk(KERN_WARNING KERN_APIC
 		       "Spurious LAPIC timer interrupt on cpu %d\n", cpu);
 		/* Switch it off */
 		lapic_timer_setup(CLOCK_EVT_MODE_SHUTDOWN, evt);
@@ -975,10 +975,10 @@ int __init verify_local_APIC(void)
 	 * The version register is read-only in a real APIC.
 	 */
 	reg0 = apic_read(APIC_LVR);
-	apic_printk(APIC_DEBUG, "Getting VERSION: %x\n", reg0);
+	printk(APIC_DEBUG "Getting VERSION: %x\n", reg0);
 	apic_write(APIC_LVR, reg0 ^ APIC_LVR_MASK);
 	reg1 = apic_read(APIC_LVR);
-	apic_printk(APIC_DEBUG, "Getting VERSION: %x\n", reg1);
+	printk(APIC_DEBUG "Getting VERSION: %x\n", reg1);
 
 	/*
 	 * The two version reads above should print the same
@@ -1002,10 +1002,10 @@ int __init verify_local_APIC(void)
 	 * The ID register is read/write in a real APIC.
 	 */
 	reg0 = apic_read(APIC_ID);
-	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg0);
+	printk(APIC_DEBUG "Getting ID: %x\n", reg0);
 	apic_write(APIC_ID, reg0 ^ APIC_ID_MASK);
 	reg1 = apic_read(APIC_ID);
-	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg1);
+	printk(APIC_DEBUG "Getting ID: %x\n", reg1);
 	apic_write(APIC_ID, reg0);
 	if (reg1 != (reg0 ^ APIC_ID_MASK))
 		return 0;
@@ -1016,9 +1016,9 @@ int __init verify_local_APIC(void)
 	 * compatibility mode, but most boxes are anymore.
 	 */
 	reg0 = apic_read(APIC_LVT0);
-	apic_printk(APIC_DEBUG, "Getting LVT0: %x\n", reg0);
+	printk(APIC_DEBUG "Getting LVT0: %x\n", reg0);
 	reg1 = apic_read(APIC_LVT1);
-	apic_printk(APIC_DEBUG, "Getting LVT1: %x\n", reg1);
+	printk(APIC_DEBUG "Getting LVT1: %x\n", reg1);
 
 	return 1;
 }
@@ -1040,7 +1040,7 @@ void __init sync_Arb_IDs(void)
 	 */
 	apic_wait_icr_idle();
 
-	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
+	printk(APIC_DEBUG "Synchronizing Arb IDs.\n");
 	apic_write(APIC_ICR, APIC_DEST_ALLINC |
 			APIC_INT_LEVELTRIG | APIC_DM_INIT);
 }
@@ -1097,7 +1097,7 @@ static void __cpuinit lapic_setup_esr(vo
 	unsigned int oldvalue, value, maxlvt;
 
 	if (!lapic_is_integrated()) {
-		printk(KERN_INFO "No ESR for 82489DX.\n");
+		printk(KERN_INFO KERN_APIC "No ESR for 82489DX.\n");
 		return;
 	}
 
@@ -1108,7 +1108,7 @@ static void __cpuinit lapic_setup_esr(vo
 		 * ESR disabled - we can't do anything useful with the
 		 * errors anyway - mbligh
 		 */
-		printk(KERN_INFO "Leaving ESR disabled.\n");
+		printk(KERN_INFO KERN_APIC "Leaving ESR disabled.\n");
 		return;
 	}
 
@@ -1128,7 +1128,7 @@ static void __cpuinit lapic_setup_esr(vo
 		apic_write(APIC_ESR, 0);
 	value = apic_read(APIC_ESR);
 	if (value != oldvalue)
-		apic_printk(APIC_VERBOSE, "ESR value before enabling "
+		printk(APIC_VERBOSE "ESR value before enabling "
 			"vector: 0x%08x  after: 0x%08x\n",
 			oldvalue, value);
 }
@@ -1253,11 +1253,11 @@ void __cpuinit setup_local_APIC(void)
 	value = apic_read(APIC_LVT0) & APIC_LVT_MASKED;
 	if (!smp_processor_id() && (pic_mode || !value)) {
 		value = APIC_DM_EXTINT;
-		apic_printk(APIC_VERBOSE, "enabled ExtINT on CPU#%d\n",
+		printk(APIC_VERBOSE "enabled ExtINT on CPU#%d\n",
 				smp_processor_id());
 	} else {
 		value = APIC_DM_EXTINT | APIC_LVT_MASKED;
-		apic_printk(APIC_VERBOSE, "masked ExtINT on CPU#%d\n",
+		printk(APIC_VERBOSE "masked ExtINT on CPU#%d\n",
 				smp_processor_id());
 	}
 	apic_write(APIC_LVT0, value);
@@ -1425,7 +1425,7 @@ end:
 static int __init detect_init_APIC(void)
 {
 	if (!cpu_has_apic) {
-		printk(KERN_INFO "No local APIC present\n");
+		printk(KERN_INFO KERN_APIC "No local APIC present\n");
 		return -1;
 	}
 
@@ -1466,7 +1466,7 @@ static int __init detect_init_APIC(void)
 		 * "lapic" specified.
 		 */
 		if (!force_enable_local_apic) {
-			printk(KERN_INFO "Local APIC disabled by BIOS -- "
+			printk(KERN_INFO KERN_APIC "Local APIC disabled by BIOS -- "
 			       "you can enable it with \"lapic\"\n");
 			return -1;
 		}
@@ -1477,7 +1477,7 @@ static int __init detect_init_APIC(void)
 		 */
 		rdmsr(MSR_IA32_APICBASE, l, h);
 		if (!(l & MSR_IA32_APICBASE_ENABLE)) {
-			printk(KERN_INFO
+			printk(KERN_INFO KERN_APIC
 			       "Local APIC disabled by BIOS -- reenabling.\n");
 			l &= ~MSR_IA32_APICBASE_BASE;
 			l |= MSR_IA32_APICBASE_ENABLE | APIC_DEFAULT_PHYS_BASE;
@@ -1491,7 +1491,7 @@ static int __init detect_init_APIC(void)
 	 */
 	features = cpuid_edx(1);
 	if (!(features & (1 << X86_FEATURE_APIC))) {
-		printk(KERN_WARNING "Could not enable APIC!\n");
+		printk(KERN_WARNING KERN_APIC "Could not enable APIC!\n");
 		return -1;
 	}
 	set_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
@@ -1502,14 +1502,14 @@ static int __init detect_init_APIC(void)
 	if (l & MSR_IA32_APICBASE_ENABLE)
 		mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
 
-	printk(KERN_INFO "Found and enabled local APIC!\n");
+	printk(KERN_INFO KERN_APIC "Found and enabled local APIC!\n");
 
 	apic_pm_activate();
 
 	return 0;
 
 no_apic:
-	printk(KERN_INFO "No local APIC present or hardware disabled\n");
+	printk(KERN_INFO KERN_APIC "No local APIC present or hardware disabled\n");
 	return -1;
 }
 #endif
@@ -1529,7 +1529,7 @@ void __init early_init_lapic_mapping(voi
 	phys_addr = mp_lapic_addr;
 
 	set_fixmap_nocache(FIX_APIC_BASE, phys_addr);
-	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+	printk(APIC_VERBOSE "mapped APIC to %16lx (%16lx)\n",
 		    APIC_BASE, phys_addr);
 
 	/*
@@ -1564,7 +1564,7 @@ void __init init_apic_mappings(void)
 		apic_phys = mp_lapic_addr;
 
 	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-	apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
+	printk(APIC_VERBOSE "mapped APIC to %08lx (%08lx)\n",
 				APIC_BASE, apic_phys);
 
 	/*
@@ -1585,12 +1585,12 @@ int __init APIC_init_uniprocessor(void)
 {
 #ifdef CONFIG_X86_64
 	if (disable_apic) {
-		printk(KERN_INFO "Apic disabled\n");
+		printk(KERN_INFO KERN_APIC "Apic disabled\n");
 		return -1;
 	}
 	if (!cpu_has_apic) {
 		disable_apic = 1;
-		printk(KERN_INFO "Apic disabled by BIOS\n");
+		printk(KERN_INFO KERN_APIC "Apic disabled by BIOS\n");
 		return -1;
 	}
 #else
@@ -1602,7 +1602,7 @@ int __init APIC_init_uniprocessor(void)
 	 */
 	if (!cpu_has_apic &&
 	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
-		printk(KERN_ERR "BIOS bug, local APIC 0x%x not detected!...\n",
+		printk(KERN_ERR KERN_APIC "BIOS bug, local APIC 0x%x not detected!...\n",
 		       boot_cpu_physical_apicid);
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 		return -1;
@@ -1696,7 +1696,7 @@ void smp_spurious_interrupt(struct pt_re
 	add_pda(irq_spurious_count, 1);
 #else
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
-	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
+	printk(KERN_INFO KERN_APIC "spurious APIC interrupt on CPU#%d, "
 	       "should never happen.\n", smp_processor_id());
 	__get_cpu_var(irq_stat).irq_spurious_count++;
 #endif
@@ -1731,7 +1731,7 @@ void smp_error_interrupt(struct pt_regs
 	   6: Received illegal vector
 	   7: Illegal register address
 	*/
-	printk(KERN_DEBUG "APIC error on CPU%d: %02x(%02x)\n",
+	printk(KERN_DEBUG KERN_APIC "APIC error on CPU%d: %02x(%02x)\n",
 		smp_processor_id(), v , v1);
 	irq_exit();
 }
@@ -1751,7 +1751,7 @@ void __init connect_bsp_APIC(void)
 		 * PIC mode, enable APIC mode in the IMCR, i.e.  connect BSP's
 		 * local APIC to INT and NMI lines.
 		 */
-		apic_printk(APIC_VERBOSE, "leaving PIC mode, "
+		printk(APIC_VERBOSE "leaving PIC mode, "
 				"enabling APIC mode.\n");
 		outb(0x70, 0x22);
 		outb(0x01, 0x23);
@@ -1779,7 +1779,7 @@ void disconnect_bsp_APIC(int virt_wire_s
 		 * IPIs, won't work beyond this point!  The only exception are
 		 * INIT IPIs.
 		 */
-		apic_printk(APIC_VERBOSE, "disabling APIC mode, "
+		printk(APIC_VERBOSE "disabling APIC mode, "
 				"entering PIC mode.\n");
 		outb(0x70, 0x22);
 		outb(0x00, 0x23);
@@ -1835,7 +1835,7 @@ void __cpuinit generic_processor_info(in
 	 * Validate version
 	 */
 	if (version == 0x0) {
-		printk(KERN_WARNING "BIOS bug, APIC version is 0 for CPU#%d! "
+		printk(KERN_WARNING KERN_APIC "BIOS bug, APIC version is 0 for CPU#%d! "
 				"fixing up to 0x10. (tell your hw vendor)\n",
 				version);
 		version = 0x10;
@@ -2201,16 +2201,6 @@ static int __init apic_set_verbosity(cha
 		return -EINVAL;
 	}
 
-	if (strcmp("debug", arg) == 0)
-		apic_verbosity = APIC_DEBUG;
-	else if (strcmp("verbose", arg) == 0)
-		apic_verbosity = APIC_VERBOSE;
-	else {
-		printk(KERN_WARNING "APIC Verbosity level %s not recognised"
-			" use apic=verbose or apic=debug\n", arg);
-		return -EINVAL;
-	}
-
 	return 0;
 }
 early_param("apic", apic_set_verbosity);
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -783,14 +783,14 @@ static int __init ioapic_pirq_setup(char
 		pirq_entries[i] = -1;
 
 	pirqs_enabled = 1;
-	apic_printk(APIC_VERBOSE, KERN_INFO
+	printk(APIC_VERBOSE
 			"PIRQ redirection, working around broken MP-BIOS.\n");
 	max = MAX_PIRQS;
 	if (ints[0] < MAX_PIRQS)
 		max = ints[0];
 
 	for (i = 0; i < max; i++) {
-		apic_printk(APIC_VERBOSE, KERN_DEBUG
+		printk(APIC_VERBOSE
 				"... PIRQ%d -> IRQ %d\n", i, ints[i+1]);
 		/*
 		 * PIRQs are mapped upside down, usually.
@@ -940,10 +940,10 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 {
 	int apic, i, best_guess = -1;
 
-	apic_printk(APIC_DEBUG, "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
+	printk(APIC_DEBUG "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
 		bus, slot, pin);
 	if (test_bit(bus, mp_bus_not_pci)) {
-		apic_printk(APIC_VERBOSE, "PCI BIOS passed nonexistent PCI bus %d!\n", bus);
+		printk(APIC_VERBOSE "PCI BIOS passed nonexistent PCI bus %d!\n", bus);
 		return -1;
 	}
 	for (i = 0; i < mp_irq_entries; i++) {
@@ -988,7 +988,7 @@ static int EISA_ELCR(unsigned int irq)
 		unsigned int port = 0x4d0 + (irq >> 3);
 		return (inb(port) >> (irq & 7)) & 1;
 	}
-	apic_printk(APIC_VERBOSE, KERN_INFO
+	printk(APIC_VERBOSE
 			"Broken MPtable reports ISA irq %d\n", irq);
 	return 0;
 }
@@ -1044,7 +1044,7 @@ static int MPBIOS_polarity(int idx)
 		}
 		case 2: /* reserved */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			printk(KERN_WARNING KERN_APIC "broken BIOS!!\n");
 			polarity = 1;
 			break;
 		}
@@ -1055,7 +1055,7 @@ static int MPBIOS_polarity(int idx)
 		}
 		default: /* invalid */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			printk(KERN_WARNING KERN_APIC "broken BIOS!!\n");
 			polarity = 1;
 			break;
 		}
@@ -1102,7 +1102,7 @@ static int MPBIOS_trigger(int idx)
 				}
 				default:
 				{
-					printk(KERN_WARNING "broken BIOS!!\n");
+					printk(KERN_WARNING KERN_APIC "broken BIOS!!\n");
 					trigger = 1;
 					break;
 				}
@@ -1116,7 +1116,7 @@ static int MPBIOS_trigger(int idx)
 		}
 		case 2: /* reserved */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			printk(KERN_WARNING KERN_APIC "broken BIOS!!\n");
 			trigger = 1;
 			break;
 		}
@@ -1127,7 +1127,7 @@ static int MPBIOS_trigger(int idx)
 		}
 		default: /* invalid */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			printk(KERN_WARNING KERN_APIC "broken BIOS!!\n");
 			trigger = 0;
 			break;
 		}
@@ -1155,7 +1155,7 @@ static int pin_2_irq(int idx, int apic,
 	 * Debugging check, we are in big trouble if this message pops up!
 	 */
 	if (mp_irqs[idx].mp_dstirq != pin)
-		printk(KERN_ERR "broken BIOS or MPTABLE parser, ayiee!!\n");
+		printk(KERN_ERR KERN_APIC "broken BIOS or MPTABLE parser, ayiee!!\n");
 
 	if (test_bit(bus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].mp_srcbusirq;
@@ -1181,11 +1181,11 @@ static int pin_2_irq(int idx, int apic,
 	if ((pin >= 16) && (pin <= 23)) {
 		if (pirq_entries[pin-16] != -1) {
 			if (!pirq_entries[pin-16]) {
-				apic_printk(APIC_VERBOSE, KERN_DEBUG
+				printk(APIC_VERBOSE
 						"disabling PIRQ%d\n", pin-16);
 			} else {
 				irq = pirq_entries[pin-16];
-				apic_printk(APIC_VERBOSE, KERN_DEBUG
+				printk(APIC_VERBOSE
 						"using PIRQ%d -> IRQ %d\n",
 						pin-16, irq);
 			}
@@ -1494,7 +1494,7 @@ static void setup_IO_APIC_irq(int apic,
 
 	cpus_and(mask, cfg->domain, mask);
 
-	apic_printk(APIC_VERBOSE,KERN_DEBUG
+	printk(APIC_VERBOSE
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
 		    "IRQ %d Mode:%i Active:%i)\n",
 		    apic, mp_ioapics[apic].mp_apicid, pin, cfg->vector,
@@ -1504,7 +1504,7 @@ static void setup_IO_APIC_irq(int apic,
 	if (setup_ioapic_entry(mp_ioapics[apic].mp_apicid, irq, &entry,
 			       cpu_mask_to_apicid(mask), trigger, polarity,
 			       cfg->vector)) {
-		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
+		printk(APIC_DEBUG "Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic].mp_apicid, pin);
 		__clear_irq_vector(irq);
 		return;
@@ -1522,7 +1522,7 @@ static void __init setup_IO_APIC_irqs(vo
 	int apic, pin, idx, irq;
 	int notcon = 0;
 
-	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
+	printk(APIC_VERBOSE "init IO_APIC IRQs\n");
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
@@ -1531,19 +1531,17 @@ static void __init setup_IO_APIC_irqs(vo
 			if (idx == -1) {
 				if (!notcon) {
 					notcon = 1;
-					apic_printk(APIC_VERBOSE,
-						KERN_DEBUG " %d-%d",
+					printk(APIC_VERBOSE " %d-%d",
 						mp_ioapics[apic].mp_apicid,
 						pin);
 				} else
-					apic_printk(APIC_VERBOSE, " %d-%d",
+					printk(KERN_CONT KERN_APIC " %d-%d",
 						mp_ioapics[apic].mp_apicid,
 						pin);
 				continue;
 			}
 			if (notcon) {
-				apic_printk(APIC_VERBOSE,
-					" (apicid-pin) not connected\n");
+				printk(KERN_CONT KERN_APIC " (apicid-pin) not connected\n");
 				notcon = 0;
 			}
 
@@ -1560,8 +1558,7 @@ static void __init setup_IO_APIC_irqs(vo
 	}
 
 	if (notcon)
-		apic_printk(APIC_VERBOSE,
-			" (apicid-pin) not connected\n");
+		printk(KERN_CONT KERN_APIC " (apicid-pin) not connected\n");
 }
 
 /*
@@ -1615,19 +1612,16 @@ __apicdebuginit(void) print_IO_APIC(void
 	struct irq_cfg *cfg;
 	unsigned int irq;
 
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
-	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
+	printk(APIC_VERBOSE "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
-		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
+		printk(APIC_VERBOSE "number of IO-APIC #%d registers: %d.\n",
 		       mp_ioapics[i].mp_apicid, nr_ioapic_registers[i]);
 
 	/*
 	 * We are a bit conservative about what we expect.  We have to
 	 * know about every hardware change ASAP.
 	 */
-	printk(KERN_INFO "testing the IO APIC.......................\n");
+	printk(APIC_VERBOSE "testing the IO APIC.......................\n");
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
 
@@ -1640,18 +1634,18 @@ __apicdebuginit(void) print_IO_APIC(void
                 reg_03.raw = io_apic_read(apic, 3);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
-	printk("\n");
-	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].mp_apicid);
-	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
-	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
-	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
-	printk(KERN_DEBUG ".......    : LTS          : %X\n", reg_00.bits.LTS);
+	printk(APIC_VERBOSE "\n");
+	printk(APIC_VERBOSE "IO APIC #%d......\n", mp_ioapics[apic].mp_apicid);
+	printk(APIC_VERBOSE ".... register #00: %08X\n", reg_00.raw);
+	printk(APIC_VERBOSE ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
+	printk(APIC_VERBOSE ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
+	printk(APIC_VERBOSE ".......    : LTS          : %X\n", reg_00.bits.LTS);
 
-	printk(KERN_DEBUG ".... register #01: %08X\n", *(int *)&reg_01);
-	printk(KERN_DEBUG ".......     : max redirection entries: %04X\n", reg_01.bits.entries);
+	printk(APIC_VERBOSE ".... register #01: %08X\n", *(int *)&reg_01);
+	printk(APIC_VERBOSE ".......     : max redirection entries: %04X\n", reg_01.bits.entries);
 
-	printk(KERN_DEBUG ".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
-	printk(KERN_DEBUG ".......     : IO APIC version: %04X\n", reg_01.bits.version);
+	printk(APIC_VERBOSE ".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
+	printk(APIC_VERBOSE ".......     : IO APIC version: %04X\n", reg_01.bits.version);
 
 	/*
 	 * Some Intel chipsets with IO APIC VERSION of 0x1? don't have reg_02,
@@ -1659,8 +1653,8 @@ __apicdebuginit(void) print_IO_APIC(void
 	 * value, so ignore it if reg_02 == reg_01.
 	 */
 	if (reg_01.bits.version >= 0x10 && reg_02.raw != reg_01.raw) {
-		printk(KERN_DEBUG ".... register #02: %08X\n", reg_02.raw);
-		printk(KERN_DEBUG ".......     : arbitration: %02X\n", reg_02.bits.arbitration);
+		printk(APIC_VERBOSE ".... register #02: %08X\n", reg_02.raw);
+		printk(APIC_VERBOSE ".......     : arbitration: %02X\n", reg_02.bits.arbitration);
 	}
 
 	/*
@@ -1670,13 +1664,13 @@ __apicdebuginit(void) print_IO_APIC(void
 	 */
 	if (reg_01.bits.version >= 0x20 && reg_03.raw != reg_02.raw &&
 	    reg_03.raw != reg_01.raw) {
-		printk(KERN_DEBUG ".... register #03: %08X\n", reg_03.raw);
-		printk(KERN_DEBUG ".......     : Boot DT    : %X\n", reg_03.bits.boot_DT);
+		printk(APIC_VERBOSE ".... register #03: %08X\n", reg_03.raw);
+		printk(APIC_VERBOSE ".......     : Boot DT    : %X\n", reg_03.bits.boot_DT);
 	}
 
-	printk(KERN_DEBUG ".... IRQ redirection table:\n");
+	printk(APIC_VERBOSE ".... IRQ redirection table:\n");
 
-	printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
+	printk(APIC_VERBOSE " NR Dst Mask Trig IRR Pol"
 			  " Stat Dmod Deli Vect:   \n");
 
 	for (i = 0; i <= reg_01.bits.entries; i++) {
@@ -1684,12 +1678,12 @@ __apicdebuginit(void) print_IO_APIC(void
 
 		entry = ioapic_read_entry(apic, i);
 
-		printk(KERN_DEBUG " %02x %03X ",
+		printk(KERN_CONT KERN_APIC " %02x %03X ",
 			i,
 			entry.dest
 		);
 
-		printk("%1d    %1d    %1d   %1d   %1d    %1d    %1d    %02X\n",
+		printk(KERN_CONT KERN_APIC "%1d    %1d    %1d   %1d   %1d    %1d    %1d    %02X\n",
 			entry.mask,
 			entry.trigger,
 			entry.irr,
@@ -1701,22 +1695,22 @@ __apicdebuginit(void) print_IO_APIC(void
 		);
 	}
 	}
-	printk(KERN_DEBUG "IRQ to pin mappings:\n");
+	printk(APIC_VERBOSE "IRQ to pin mappings:\n");
 	for_each_irq_cfg(irq, cfg) {
 		struct irq_pin_list *entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;
-		printk(KERN_DEBUG "IRQ%d ", irq);
+		printk(APIC_VERBOSE "IRQ%d ", irq);
 		for (;;) {
-			printk("-> %d:%d", entry->apic, entry->pin);
+			printk(KERN_CONT KERN_APIC "-> %d:%d", entry->apic, entry->pin);
 			if (!entry->next)
 				break;
 			entry = entry->next;
 		}
-		printk("\n");
+		printk(KERN_CONT KERN_APIC "\n");
 	}
 
-	printk(KERN_INFO ".................................... done.\n");
+	printk(APIC_VERBOSE ".................................... done.\n");
 
 	return;
 }
@@ -1726,19 +1720,17 @@ __apicdebuginit(void) print_APIC_bitfiel
 	unsigned int v;
 	int i, j;
 
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
-	printk(KERN_DEBUG "0123456789abcdef0123456789abcdef\n" KERN_DEBUG);
+	printk(APIC_VERBOSE "    0123456789abcdef0123456789abcdef\n");
 	for (i = 0; i < 8; i++) {
+		printk(APIC_VERBOSE "    ");
 		v = apic_read(base + i*0x10);
 		for (j = 0; j < 32; j++) {
 			if (v & (1<<j))
-				printk("1");
+				printk(KERN_CONT KERN_APIC "1");
 			else
-				printk("0");
+				printk(KERN_CONT KERN_APIC "0");
 		}
-		printk("\n");
+		printk(KERN_CONT KERN_APIC "\n");
 	}
 }
 
@@ -1747,29 +1739,27 @@ __apicdebuginit(void) print_local_APIC(v
 	unsigned int v, ver, maxlvt;
 	u64 icr;
 
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
-	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
+	printk(APIC_VERBOSE "\n");
+	printk(APIC_VERBOSE "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
-	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, read_apic_id());
+	printk(APIC_VERBOSE "... APIC ID:      %08x (%01x)\n", v, read_apic_id());
 	v = apic_read(APIC_LVR);
-	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
+	printk(APIC_VERBOSE "... APIC VERSION: %08x\n", v);
 	ver = GET_APIC_VERSION(v);
 	maxlvt = lapic_get_maxlvt();
 
 	v = apic_read(APIC_TASKPRI);
-	printk(KERN_DEBUG "... APIC TASKPRI: %08x (%02x)\n", v, v & APIC_TPRI_MASK);
+	printk(APIC_VERBOSE "... APIC TASKPRI: %08x (%02x)\n", v, v & APIC_TPRI_MASK);
 
 	if (APIC_INTEGRATED(ver)) {                     /* !82489DX */
 		if (!APIC_XAPIC(ver)) {
 			v = apic_read(APIC_ARBPRI);
-			printk(KERN_DEBUG "... APIC ARBPRI: %08x (%02x)\n", v,
+			printk(APIC_VERBOSE "... APIC ARBPRI: %08x (%02x)\n", v,
 			       v & APIC_ARBPRI_MASK);
 		}
 		v = apic_read(APIC_PROCPRI);
-		printk(KERN_DEBUG "... APIC PROCPRI: %08x\n", v);
+		printk(APIC_VERBOSE "... APIC PROCPRI: %08x\n", v);
 	}
 
 	/*
@@ -1778,23 +1768,23 @@ __apicdebuginit(void) print_local_APIC(v
 	 */
 	if (!APIC_INTEGRATED(ver) || maxlvt == 3) {
 		v = apic_read(APIC_RRR);
-		printk(KERN_DEBUG "... APIC RRR: %08x\n", v);
+		printk(APIC_VERBOSE "... APIC RRR: %08x\n", v);
 	}
 
 	v = apic_read(APIC_LDR);
-	printk(KERN_DEBUG "... APIC LDR: %08x\n", v);
+	printk(APIC_VERBOSE "... APIC LDR: %08x\n", v);
 	if (!x2apic_enabled()) {
 		v = apic_read(APIC_DFR);
-		printk(KERN_DEBUG "... APIC DFR: %08x\n", v);
+		printk(APIC_VERBOSE "... APIC DFR: %08x\n", v);
 	}
 	v = apic_read(APIC_SPIV);
-	printk(KERN_DEBUG "... APIC SPIV: %08x\n", v);
+	printk(APIC_VERBOSE "... APIC SPIV: %08x\n", v);
 
-	printk(KERN_DEBUG "... APIC ISR field:\n");
+	printk(APIC_VERBOSE "... APIC ISR field:\n");
 	print_APIC_bitfield(APIC_ISR);
-	printk(KERN_DEBUG "... APIC TMR field:\n");
+	printk(APIC_VERBOSE "... APIC TMR field:\n");
 	print_APIC_bitfield(APIC_TMR);
-	printk(KERN_DEBUG "... APIC IRR field:\n");
+	printk(APIC_VERBOSE "... APIC IRR field:\n");
 	print_APIC_bitfield(APIC_IRR);
 
 	if (APIC_INTEGRATED(ver)) {             /* !82489DX */
@@ -1802,37 +1792,37 @@ __apicdebuginit(void) print_local_APIC(v
 			apic_write(APIC_ESR, 0);
 
 		v = apic_read(APIC_ESR);
-		printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
+		printk(APIC_VERBOSE "... APIC ESR: %08x\n", v);
 	}
 
 	icr = apic_icr_read();
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", (u32)icr);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", (u32)(icr >> 32));
+	printk(APIC_VERBOSE "... APIC ICR: %08x\n", (u32)icr);
+	printk(APIC_VERBOSE "... APIC ICR2: %08x\n", (u32)(icr >> 32));
 
 	v = apic_read(APIC_LVTT);
-	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
+	printk(APIC_VERBOSE "... APIC LVTT: %08x\n", v);
 
 	if (maxlvt > 3) {                       /* PC is LVT#4. */
 		v = apic_read(APIC_LVTPC);
-		printk(KERN_DEBUG "... APIC LVTPC: %08x\n", v);
+		printk(APIC_VERBOSE "... APIC LVTPC: %08x\n", v);
 	}
 	v = apic_read(APIC_LVT0);
-	printk(KERN_DEBUG "... APIC LVT0: %08x\n", v);
+	printk(APIC_VERBOSE "... APIC LVT0: %08x\n", v);
 	v = apic_read(APIC_LVT1);
-	printk(KERN_DEBUG "... APIC LVT1: %08x\n", v);
+	printk(APIC_VERBOSE "... APIC LVT1: %08x\n", v);
 
 	if (maxlvt > 2) {			/* ERR is LVT#3. */
 		v = apic_read(APIC_LVTERR);
-		printk(KERN_DEBUG "... APIC LVTERR: %08x\n", v);
+		printk(APIC_VERBOSE "... APIC LVTERR: %08x\n", v);
 	}
 
 	v = apic_read(APIC_TMICT);
-	printk(KERN_DEBUG "... APIC TMICT: %08x\n", v);
+	printk(APIC_VERBOSE "... APIC TMICT: %08x\n", v);
 	v = apic_read(APIC_TMCCT);
-	printk(KERN_DEBUG "... APIC TMCCT: %08x\n", v);
+	printk(APIC_VERBOSE "... APIC TMCCT: %08x\n", v);
 	v = apic_read(APIC_TDCR);
-	printk(KERN_DEBUG "... APIC TDCR: %08x\n", v);
-	printk("\n");
+	printk(APIC_VERBOSE "... APIC TDCR: %08x\n", v);
+	printk(APIC_VERBOSE "\n");
 }
 
 __apicdebuginit(void) print_all_local_APICs(void)
@@ -1850,18 +1840,15 @@ __apicdebuginit(void) print_PIC(void)
 	unsigned int v;
 	unsigned long flags;
 
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
-	printk(KERN_DEBUG "\nprinting PIC contents\n");
+	printk(APIC_VERBOSE "\nprinting PIC contents\n");
 
 	spin_lock_irqsave(&i8259A_lock, flags);
 
 	v = inb(0xa1) << 8 | inb(0x21);
-	printk(KERN_DEBUG "... PIC  IMR: %04x\n", v);
+	printk(APIC_VERBOSE "... PIC  IMR: %04x\n", v);
 
 	v = inb(0xa0) << 8 | inb(0x20);
-	printk(KERN_DEBUG "... PIC  IRR: %04x\n", v);
+	printk(APIC_VERBOSE "... PIC  IRR: %04x\n", v);
 
 	outb(0x0b,0xa0);
 	outb(0x0b,0x20);
@@ -1871,10 +1858,10 @@ __apicdebuginit(void) print_PIC(void)
 
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 
-	printk(KERN_DEBUG "... PIC  ISR: %04x\n", v);
+	printk(APIC_VERBOSE "... PIC  ISR: %04x\n", v);
 
 	v = inb(0x4d1) << 8 | inb(0x4d0);
-	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
+	printk(APIC_VERBOSE "... PIC ELCR: %04x\n", v);
 }
 
 __apicdebuginit(int) print_all_ICs(void)
@@ -1942,7 +1929,7 @@ void __init enable_IO_APIC(void)
 	i8259_apic = find_isa_irq_apic(0, mp_ExtINT);
 	/* Trust the MP table if nothing is setup in the hardware */
 	if ((ioapic_i8259.pin == -1) && (i8259_pin >= 0)) {
-		printk(KERN_WARNING "ExtINT not setup in hardware but reported by MP table\n");
+		printk(KERN_WARNING KERN_APIC "ExtINT not setup in hardware but reported by MP table\n");
 		ioapic_i8259.pin  = i8259_pin;
 		ioapic_i8259.apic = i8259_apic;
 	}
@@ -1950,7 +1937,7 @@ void __init enable_IO_APIC(void)
 	if (((ioapic_i8259.apic != i8259_apic) || (ioapic_i8259.pin != i8259_pin)) &&
 		(i8259_pin >= 0) && (ioapic_i8259.pin >= 0))
 	{
-		printk(KERN_WARNING "ExtINT in hardware and MP table differ\n");
+		printk(KERN_WARNING KERN_APIC "ExtINT in hardware and MP table differ\n");
 	}
 
 	/*
@@ -2043,9 +2030,9 @@ static void __init setup_ioapic_ids_from
 		old_id = mp_ioapics[apic].mp_apicid;
 
 		if (mp_ioapics[apic].mp_apicid >= get_physical_broadcast()) {
-			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
+			printk(KERN_ERR KERN_APIC "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
 				apic, mp_ioapics[apic].mp_apicid);
-			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
+			printk(KERN_ERR KERN_APIC "... fixing up to %d. (tell your hw vendor)\n",
 				reg_00.bits.ID);
 			mp_ioapics[apic].mp_apicid = reg_00.bits.ID;
 		}
@@ -2057,21 +2044,21 @@ static void __init setup_ioapic_ids_from
 		 */
 		if (check_apicid_used(phys_id_present_map,
 					mp_ioapics[apic].mp_apicid)) {
-			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
+			printk(KERN_ERR KERN_APIC "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
 				apic, mp_ioapics[apic].mp_apicid);
 			for (i = 0; i < get_physical_broadcast(); i++)
 				if (!physid_isset(i, phys_id_present_map))
 					break;
 			if (i >= get_physical_broadcast())
 				panic("Max APIC ID exceeded!\n");
-			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
+			printk(KERN_ERR KERN_APIC "... fixing up to %d. (tell your hw vendor)\n",
 				i);
 			physid_set(i, phys_id_present_map);
 			mp_ioapics[apic].mp_apicid = i;
 		} else {
 			physid_mask_t tmp;
 			tmp = apicid_to_cpu_present(mp_ioapics[apic].mp_apicid);
-			apic_printk(APIC_VERBOSE, "Setting %d in the "
+			printk(APIC_VERBOSE "Setting %d in the "
 					"phys_id_present_map\n",
 					mp_ioapics[apic].mp_apicid);
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
@@ -2092,7 +2079,7 @@ static void __init setup_ioapic_ids_from
 		 * Read the right value from the MPC table and
 		 * write it into the ID register.
 		 */
-		apic_printk(APIC_VERBOSE, KERN_INFO
+		printk(APIC_VERBOSE
 			"...changing IO-APIC physical APIC ID to %d ...",
 			mp_ioapics[apic].mp_apicid);
 
@@ -2108,9 +2095,9 @@ static void __init setup_ioapic_ids_from
 		reg_00.raw = io_apic_read(apic, 0);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 		if (reg_00.bits.ID != mp_ioapics[apic].mp_apicid)
-			printk("could not set ID!\n");
+			printk(KERN_CONT KERN_APIC "could not set ID!\n");
 		else
-			apic_printk(APIC_VERBOSE, " ok.\n");
+			printk(KERN_CONT KERN_APIC " ok.\n");
 	}
 }
 #endif
@@ -2668,11 +2655,11 @@ static void __init setup_nmi(void)
 	 * is from Maciej W. Rozycki - so we do not have to EOI from
 	 * the NMI handler or the timer interrupt.
 	 */
-	apic_printk(APIC_VERBOSE, KERN_INFO "activating NMI Watchdog ...");
+	printk(APIC_VERBOSE "activating NMI Watchdog ...");
 
 	enable_NMI_through_LVT0();
 
-	apic_printk(APIC_VERBOSE, " done.\n");
+	printk(KERN_CONT KERN_APIC " done.\n");
 }
 
 /*
@@ -2792,7 +2779,7 @@ static inline void __init check_timer(vo
 	pin2  = ioapic_i8259.pin;
 	apic2 = ioapic_i8259.apic;
 
-	apic_printk(APIC_QUIET, KERN_INFO "..TIMER: vector=0x%02X "
+	printk(APIC_QUIET "..TIMER: vector=0x%02X "
 		    "apic1=%d pin1=%d apic2=%d pin2=%d\n",
 		    cfg->vector, apic1, pin1, apic2, pin2);
 
@@ -2840,12 +2827,12 @@ static inline void __init check_timer(vo
 #endif
 		clear_IO_APIC_pin(apic1, pin1);
 		if (!no_pin1)
-			apic_printk(APIC_QUIET, KERN_ERR "..MP-BIOS bug: "
+			printk(APIC_QUIET "..MP-BIOS bug: "
 				    "8254 timer not connected to IO-APIC\n");
 
-		apic_printk(APIC_QUIET, KERN_INFO "...trying to set up timer "
+		printk(APIC_QUIET "...trying to set up timer "
 			    "(IRQ0) through the 8259A ...\n");
-		apic_printk(APIC_QUIET, KERN_INFO
+		printk(APIC_QUIET
 			    "..... (found apic %d pin %d) ...\n", apic2, pin2);
 		/*
 		 * legacy devices should be connected to IO APIC #0
@@ -2855,7 +2842,7 @@ static inline void __init check_timer(vo
 		unmask_IO_APIC_irq(0);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
-			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
+			printk(APIC_QUIET "....... works.\n");
 			timer_through_8259 = 1;
 			if (nmi_watchdog == NMI_IO_APIC) {
 				disable_8259A_irq(0);
@@ -2869,11 +2856,11 @@ static inline void __init check_timer(vo
 		 */
 		disable_8259A_irq(0);
 		clear_IO_APIC_pin(apic2, pin2);
-		apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
+		printk(APIC_QUIET "....... failed.\n");
 	}
 
 	if (nmi_watchdog == NMI_IO_APIC) {
-		apic_printk(APIC_QUIET, KERN_WARNING "timer doesn't work "
+		printk(APIC_QUIET "timer doesn't work "
 			    "through the IO-APIC - disabling NMI Watchdog!\n");
 		nmi_watchdog = NMI_NONE;
 	}
@@ -2881,7 +2868,7 @@ static inline void __init check_timer(vo
 	timer_ack = 0;
 #endif
 
-	apic_printk(APIC_QUIET, KERN_INFO
+	printk(APIC_QUIET
 		    "...trying to set up timer as Virtual Wire IRQ...\n");
 
 	lapic_register_intr(0);
@@ -2889,14 +2876,14 @@ static inline void __init check_timer(vo
 	enable_8259A_irq(0);
 
 	if (timer_irq_works()) {
-		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
+		printk(APIC_QUIET "..... works.\n");
 		goto out;
 	}
 	disable_8259A_irq(0);
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
-	apic_printk(APIC_QUIET, KERN_INFO "..... failed.\n");
+	printk(APIC_QUIET "..... failed.\n");
 
-	apic_printk(APIC_QUIET, KERN_INFO
+	printk(APIC_QUIET
 		    "...trying to set up timer as ExtINT IRQ...\n");
 
 	init_8259A(0);
@@ -2906,10 +2893,10 @@ static inline void __init check_timer(vo
 	unlock_ExtINT_logic();
 
 	if (timer_irq_works()) {
-		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
+		printk(APIC_QUIET "..... works.\n");
 		goto out;
 	}
-	apic_printk(APIC_QUIET, KERN_INFO "..... failed :(.\n");
+	printk(APIC_QUIET "..... failed :(.\n");
 	panic("IO-APIC + timer doesn't work!  Boot with apic=debug and send a "
 		"report.  Then try booting with the 'noapic' option.\n");
 out:
@@ -2948,7 +2935,7 @@ void __init setup_IO_APIC(void)
 
 	io_apic_irqs = ~PIC_IRQS;
 
-	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
+	printk(APIC_VERBOSE "ENABLING IO-APIC IRQs\n");
         /*
          * Set up IO-APIC IRQ routing.
          */
@@ -3802,7 +3789,7 @@ int __init io_apic_get_unique_id(int ioa
 		}
 	}
 
-	apic_printk(APIC_VERBOSE, KERN_INFO
+	printk(APIC_VERBOSE
 			"IOAPIC[%d]: Assigned apic_id %d\n", ioapic, apic_id);
 
 	return apic_id;
@@ -3824,7 +3811,7 @@ int __init io_apic_get_version(int ioapi
 int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int polarity)
 {
 	if (!IO_APIC_IRQ(irq)) {
-		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
+		printk(APIC_QUIET "IOAPIC[%d]: Invalid reference to IRQ 0\n",
 			ioapic);
 		return -EINVAL;
 	}
@@ -3970,7 +3957,7 @@ fake_ioapic_page:
 			ioapic_phys = __pa(ioapic_phys);
 		}
 		set_fixmap_nocache(idx, ioapic_phys);
-		apic_printk(APIC_VERBOSE,
+		printk(APIC_VERBOSE
 			    "mapped IOAPIC to %08lx (%08lx)\n",
 			    __fix_to_virt(idx), ioapic_phys);
 		idx++;
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -83,7 +83,7 @@ static void __init MP_bus_info(struct mp
 	if (x86_quirks->mpc_oem_bus_info)
 		x86_quirks->mpc_oem_bus_info(m, str);
 	else
-		apic_printk(APIC_VERBOSE, "Bus #%d is %s\n", m->mpc_busid, str);
+		printk(APIC_VERBOSE "Bus #%d is %s\n", m->mpc_busid, str);
 
 #if MAX_MP_BUSSES < 256
 	if (m->mpc_busid >= MAX_MP_BUSSES) {
@@ -154,7 +154,7 @@ static void __init MP_ioapic_info(struct
 
 static void print_MP_intsrc_info(struct mpc_config_intsrc *m)
 {
-	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
+	printk(APIC_VERBOSE "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		m->mpc_irqtype, m->mpc_irqflag & 3,
 		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbus,
@@ -163,7 +163,7 @@ static void print_MP_intsrc_info(struct
 
 static void __init print_mp_irq_info(struct mp_config_intsrc *mp_irq)
 {
-	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
+	printk(APIC_VERBOSE "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		mp_irq->mp_irqtype, mp_irq->mp_irqflag & 3,
 		(mp_irq->mp_irqflag >> 2) & 3, mp_irq->mp_srcbus,
@@ -235,7 +235,7 @@ static void __init MP_intsrc_info(struct
 
 static void __init MP_lintsrc_info(struct mpc_config_lintsrc *m)
 {
-	apic_printk(APIC_VERBOSE, "Lint: type %d, pol %d, trig %d, bus %02x,"
+	printk(APIC_VERBOSE "Lint: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC LINT %02x\n",
 		m->mpc_irqtype, m->mpc_irqflag & 3,
 		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbusid,
@@ -697,7 +697,7 @@ static int __init smp_scan_config(unsign
 	unsigned int *bp = phys_to_virt(base);
 	struct intel_mp_floating *mpf;
 
-	apic_printk(APIC_VERBOSE, "Scan SMP from %p for %ld bytes.\n",
+	printk(APIC_VERBOSE "Scan SMP from %p for %ld bytes.\n",
 			bp, length);
 	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -542,17 +542,18 @@ static inline void __inquire_remote_apic
 	int timeout;
 	u32 status;
 
-	printk(KERN_INFO "Inquiring remote APIC 0x%x...\n", apicid);
+	printk(APIC_DEBUG "Inquiring remote APIC 0x%x...\n", apicid);
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++) {
-		printk(KERN_INFO "... APIC 0x%x %s: ", apicid, names[i]);
+		printk(APIC_DEBUG "... APIC 0x%x %s: ",
+			 apicid, names[i]);
 
 		/*
 		 * Wait for idle.
 		 */
 		status = safe_apic_wait_icr_idle();
 		if (status)
-			printk(KERN_CONT
+			printk(KERN_CONT KERN_APIC
 			       "a previous APIC delivery may have failed\n");
 
 		apic_icr_write(APIC_DM_REMRD | regs[i], apicid);
@@ -566,10 +567,10 @@ static inline void __inquire_remote_apic
 		switch (status) {
 		case APIC_ICR_RR_VALID:
 			status = apic_read(APIC_RRR);
-			printk(KERN_CONT "%08x\n", status);
+			printk(KERN_CONT KERN_APIC "%08x\n", status);
 			break;
 		default:
-			printk(KERN_CONT "failed\n");
+			printk(KERN_CONT KERN_APIC "failed\n");
 		}
 	}
 }
Index: linux-2.6/include/asm-x86/apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/apic.h
+++ linux-2.6/include/asm-x86/apic.h
@@ -14,24 +14,14 @@
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
-/*
- * Debugging macros
- */
-#define APIC_QUIET   0
-#define APIC_VERBOSE 1
-#define APIC_DEBUG   2
+#define KERN_APIC "<apic>"
 
 /*
- * Define the default level of output to be very little
- * This can be turned up by using apic=verbose for more
- * information and apic=debug for _lots_ of information.
- * apic_verbosity is defined in apic.c
+ * Debugging macros
  */
-#define apic_printk(v, s, a...) do {       \
-		if ((v) <= apic_verbosity) \
-			printk(s, ##a);    \
-	} while (0)
-
+#define APIC_QUIET   KERN_WARNING KERN_APIC
+#define APIC_VERBOSE KERN_INFO KERN_APIC
+#define APIC_DEBUG   KERN_DEBUG KERN_APIC
 
 extern void generic_apic_probe(void);
 
Index: linux-2.6/include/asm-x86/es7000/wakecpu.h
===================================================================
--- linux-2.6.orig/include/asm-x86/es7000/wakecpu.h
+++ linux-2.6/include/asm-x86/es7000/wakecpu.h
@@ -50,10 +50,6 @@ static inline void restore_NMI_vector(un
 {
 }
 
-#if APIC_DEBUG
- #define inquire_remote_apic(apicid) __inquire_remote_apic(apicid)
-#else
- #define inquire_remote_apic(apicid) {}
-#endif
+#define inquire_remote_apic(apicid) __inquire_remote_apic(apicid)
 
 #endif /* __ASM_MACH_WAKECPU_H */
Index: linux-2.6/include/asm-x86/mach-default/mach_wakecpu.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-default/mach_wakecpu.h
+++ linux-2.6/include/asm-x86/mach-default/mach_wakecpu.h
@@ -33,10 +33,6 @@ static inline void restore_NMI_vector(un
 {
 }
 
-#if APIC_DEBUG
- #define inquire_remote_apic(apicid) __inquire_remote_apic(apicid)
-#else
- #define inquire_remote_apic(apicid) {}
-#endif
+#define inquire_remote_apic(apicid) __inquire_remote_apic(apicid)
 
 #endif /* ASM_X86__MACH_DEFAULT__MACH_WAKECPU_H */
