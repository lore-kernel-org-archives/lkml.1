Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbYGMRQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbYGMRQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYGMRQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:16:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:30112 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbYGMRQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C1gTv5rxZ4sCDrMjdIfhOlrFFAhkHF+EFYc7Y3T+lpPqg9Nr46B8PNw+kCp/+1XqJ4
         lOBxayA/GTUP2O0NfpEeMX8r0zOTJxZKGSSViGpztG6USfcShm+3skVTdhLAs/z/46p7
         e9I2iZnI+P9OZZYwmlLRJpeuIu/MBeIgcdsj8=
Date: Sun, 13 Jul 2008 21:16:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too
Message-ID: <20080713171634.GD7459@asus>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807111841.55403.yhlu.kernel@gmail.com> <20080713010843.GD1678@linux-os.sc.intel.com> <86802c440807121904m1516b47am22a384a1e5868f68@mail.gmail.com> <20080713162804.GI1678@linux-os.sc.intel.com> <Pine.LNX.4.55.0807131737240.10630@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807131737240.10630@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Sun, Jul 13, 2008 at 05:51:30PM +0100]
| On Sun, 13 Jul 2008, Suresh Siddha wrote:
| 
| > So we should probably have native_apic_mem_write_around() and use that
| > in ack_APIC_irq() and for good apic it is native_apic_mem_write()
| > and for !CONFIG_X86_GOOD_APIC, it is native_apic_mem_write_atomic()
| 
|  Why don't you simply define apic_write_around() correctly for your
| platform? -- for 64-bit it is always the same as apic_write() as
| X86_GOOD_APIC may only be cleared for the original Pentium processor, so
| any unnecessary code for the opposite case will be optimised away at the
| build time, whether you use a macro or an inline function.  Why do you
| think you need to create more variations of this contraption which is a
| workaround for a corner-case hw erratum anyway?
| 
|   Maciej

Guys, when I was in attempt to unify apic code first thing was -
renaming apic_write. Here is a patch for this - only ESR and K8
registers are untouched - may be usefull to apply (actually not
sure if it will apply without fuzz now). Wonder if this help :)
If this attempt just a crap - ignore it please and don't swearing
me :-)

		- Cyrill -

---

x86: apic - unify apic writes to write_around form

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-07-10 20:06:16.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-07-10 20:06:21.000000000 +0400
@@ -807,7 +807,7 @@ int __init verify_local_APIC(void)
 	 */
 	reg0 = apic_read(APIC_LVR);
 	apic_printk(APIC_DEBUG, "Getting VERSION: %x\n", reg0);
-	apic_write(APIC_LVR, reg0 ^ APIC_LVR_MASK);
+	apic_write_around(APIC_LVR, reg0 ^ APIC_LVR_MASK);
 	reg1 = apic_read(APIC_LVR);
 	apic_printk(APIC_DEBUG, "Getting VERSION: %x\n", reg1);
 
@@ -1619,26 +1619,26 @@ static int lapic_resume(struct sys_devic
 	l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
 	wrmsr(MSR_IA32_APICBASE, l, h);
 
-	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR | APIC_LVT_MASKED);
-	apic_write(APIC_ID, apic_pm_state.apic_id);
-	apic_write(APIC_DFR, apic_pm_state.apic_dfr);
-	apic_write(APIC_LDR, apic_pm_state.apic_ldr);
-	apic_write(APIC_TASKPRI, apic_pm_state.apic_taskpri);
-	apic_write(APIC_SPIV, apic_pm_state.apic_spiv);
-	apic_write(APIC_LVT0, apic_pm_state.apic_lvt0);
-	apic_write(APIC_LVT1, apic_pm_state.apic_lvt1);
+	apic_write_around(APIC_LVTERR, ERROR_APIC_VECTOR | APIC_LVT_MASKED);
+	apic_write_around(APIC_ID, apic_pm_state.apic_id);
+	apic_write_around(APIC_DFR, apic_pm_state.apic_dfr);
+	apic_write_around(APIC_LDR, apic_pm_state.apic_ldr);
+	apic_write_around(APIC_TASKPRI, apic_pm_state.apic_taskpri);
+	apic_write_around(APIC_SPIV, apic_pm_state.apic_spiv);
+	apic_write_around(APIC_LVT0, apic_pm_state.apic_lvt0);
+	apic_write_around(APIC_LVT1, apic_pm_state.apic_lvt1);
 #ifdef CONFIG_X86_MCE_P4THERMAL
 	if (maxlvt >= 5)
-		apic_write(APIC_LVTTHMR, apic_pm_state.apic_thmr);
+		apic_write_around(APIC_LVTTHMR, apic_pm_state.apic_thmr);
 #endif
 	if (maxlvt >= 4)
-		apic_write(APIC_LVTPC, apic_pm_state.apic_lvtpc);
-	apic_write(APIC_LVTT, apic_pm_state.apic_lvtt);
-	apic_write(APIC_TDCR, apic_pm_state.apic_tdcr);
-	apic_write(APIC_TMICT, apic_pm_state.apic_tmict);
+		apic_write_around(APIC_LVTPC, apic_pm_state.apic_lvtpc);
+	apic_write_around(APIC_LVTT, apic_pm_state.apic_lvtt);
+	apic_write_around(APIC_TDCR, apic_pm_state.apic_tdcr);
+	apic_write_around(APIC_TMICT, apic_pm_state.apic_tmict);
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
-	apic_write(APIC_LVTERR, apic_pm_state.apic_lvterr);
+	apic_write_around(APIC_LVTERR, apic_pm_state.apic_lvterr);
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 	local_irq_restore(flags);
Index: linux-2.6.git/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-07-10 20:06:21.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-07-10 20:06:21.000000000 +0400
@@ -155,7 +155,7 @@ void __cpuinit enable_NMI_through_LVT0(v
 
 	/* unmask and set to NMI */
 	v = APIC_DM_NMI;
-	apic_write(APIC_LVT0, v);
+	apic_write_around(APIC_LVT0, v);
 }
 
 /**
@@ -191,18 +191,18 @@ static void __setup_APIC_LVTT(unsigned i
 	if (!irqen)
 		lvtt_value |= APIC_LVT_MASKED;
 
-	apic_write(APIC_LVTT, lvtt_value);
+	apic_write_around(APIC_LVTT, lvtt_value);
 
 	/*
 	 * Divide PICLK by 16
 	 */
 	tmp_value = apic_read(APIC_TDCR);
-	apic_write(APIC_TDCR, (tmp_value
+	apic_write_around(APIC_TDCR, (tmp_value
 				& ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE))
 				| APIC_TDR_DIV_16);
 
 	if (!oneshot)
-		apic_write(APIC_TMICT, clocks);
+		apic_write_around(APIC_TMICT, clocks);
 }
 
 /*
@@ -241,7 +241,7 @@ u8 setup_APIC_eilvt_ibs(u8 vector, u8 ms
 static int lapic_next_event(unsigned long delta,
 			    struct clock_event_device *evt)
 {
-	apic_write(APIC_TMICT, delta);
+	apic_write_around(APIC_TMICT, delta);
 	return 0;
 }
 
@@ -270,7 +270,7 @@ static void lapic_timer_setup(enum clock
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		v = apic_read(APIC_LVTT);
 		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
-		apic_write(APIC_LVTT, v);
+		apic_write_around(APIC_LVTT, v);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
 		/* Nothing to do here */
@@ -529,33 +529,33 @@ void clear_local_APIC(void)
 	 */
 	if (maxlvt >= 3) {
 		v = ERROR_APIC_VECTOR; /* any non-zero vector will do */
-		apic_write(APIC_LVTERR, v | APIC_LVT_MASKED);
+		apic_write_around(APIC_LVTERR, v | APIC_LVT_MASKED);
 	}
 	/*
 	 * Careful: we have to set masks only first to deassert
 	 * any level-triggered sources.
 	 */
 	v = apic_read(APIC_LVTT);
-	apic_write(APIC_LVTT, v | APIC_LVT_MASKED);
+	apic_write_around(APIC_LVTT, v | APIC_LVT_MASKED);
 	v = apic_read(APIC_LVT0);
-	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
+	apic_write_around(APIC_LVT0, v | APIC_LVT_MASKED);
 	v = apic_read(APIC_LVT1);
-	apic_write(APIC_LVT1, v | APIC_LVT_MASKED);
+	apic_write_around(APIC_LVT1, v | APIC_LVT_MASKED);
 	if (maxlvt >= 4) {
 		v = apic_read(APIC_LVTPC);
-		apic_write(APIC_LVTPC, v | APIC_LVT_MASKED);
+		apic_write_around(APIC_LVTPC, v | APIC_LVT_MASKED);
 	}
 
 	/*
 	 * Clean APIC state for other OSs:
 	 */
-	apic_write(APIC_LVTT, APIC_LVT_MASKED);
-	apic_write(APIC_LVT0, APIC_LVT_MASKED);
-	apic_write(APIC_LVT1, APIC_LVT_MASKED);
+	apic_write_around(APIC_LVTT, APIC_LVT_MASKED);
+	apic_write_around(APIC_LVT0, APIC_LVT_MASKED);
+	apic_write_around(APIC_LVT1, APIC_LVT_MASKED);
 	if (maxlvt >= 3)
-		apic_write(APIC_LVTERR, APIC_LVT_MASKED);
+		apic_write_around(APIC_LVTERR, APIC_LVT_MASKED);
 	if (maxlvt >= 4)
-		apic_write(APIC_LVTPC, APIC_LVT_MASKED);
+		apic_write_around(APIC_LVTPC, APIC_LVT_MASKED);
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 }
@@ -575,7 +575,7 @@ void disable_local_APIC(void)
 	 */
 	value = apic_read(APIC_SPIV);
 	value &= ~APIC_SPIV_APIC_ENABLED;
-	apic_write(APIC_SPIV, value);
+	apic_write_around(APIC_SPIV, value);
 }
 
 void lapic_shutdown(void)
@@ -606,7 +606,7 @@ int __init verify_local_APIC(void)
 	 */
 	reg0 = apic_read(APIC_LVR);
 	apic_printk(APIC_DEBUG, "Getting VERSION: %x\n", reg0);
-	apic_write(APIC_LVR, reg0 ^ APIC_LVR_MASK);
+	apic_write_around(APIC_LVR, reg0 ^ APIC_LVR_MASK);
 	reg1 = apic_read(APIC_LVR);
 	apic_printk(APIC_DEBUG, "Getting VERSION: %x\n", reg1);
 
@@ -633,10 +633,10 @@ int __init verify_local_APIC(void)
 	 */
 	reg0 = read_apic_id();
 	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg0);
-	apic_write(APIC_ID, reg0 ^ APIC_ID_MASK);
+	apic_write_around(APIC_ID, reg0 ^ APIC_ID_MASK);
 	reg1 = read_apic_id();
 	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg1);
-	apic_write(APIC_ID, reg0);
+	apic_write_around(APIC_ID, reg0);
 	if (reg1 != (reg0 ^ APIC_ID_MASK))
 		return 0;
 
@@ -668,7 +668,7 @@ void __init sync_Arb_IDs(void)
 	apic_wait_icr_idle();
 
 	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
-	apic_write(APIC_ICR, APIC_DEST_ALLINC | APIC_INT_LEVELTRIG
+	apic_write_around(APIC_ICR, APIC_DEST_ALLINC | APIC_INT_LEVELTRIG
 				| APIC_DM_INIT);
 }
 
@@ -701,14 +701,14 @@ void __init init_bsp_APIC(void)
 	value |= APIC_SPIV_APIC_ENABLED;
 	value |= APIC_SPIV_FOCUS_DISABLED;
 	value |= SPURIOUS_APIC_VECTOR;
-	apic_write(APIC_SPIV, value);
+	apic_write_around(APIC_SPIV, value);
 
 	/*
 	 * Set up the virtual wire mode.
 	 */
-	apic_write(APIC_LVT0, APIC_DM_EXTINT);
+	apic_write_around(APIC_LVT0, APIC_DM_EXTINT);
 	value = APIC_DM_NMI;
-	apic_write(APIC_LVT1, value);
+	apic_write_around(APIC_LVT1, value);
 }
 
 /**
@@ -744,7 +744,7 @@ void __cpuinit setup_local_APIC(void)
 	 */
 	value = apic_read(APIC_TASKPRI);
 	value &= ~APIC_TPRI_MASK;
-	apic_write(APIC_TASKPRI, value);
+	apic_write_around(APIC_TASKPRI, value);
 
 	/*
 	 * After a crash, we no longer service the interrupts and a pending
@@ -781,7 +781,7 @@ void __cpuinit setup_local_APIC(void)
 	 * Set spurious IRQ vector
 	 */
 	value |= SPURIOUS_APIC_VECTOR;
-	apic_write(APIC_SPIV, value);
+	apic_write_around(APIC_SPIV, value);
 
 	/*
 	 * Set up LVT0, LVT1:
@@ -803,7 +803,7 @@ void __cpuinit setup_local_APIC(void)
 		apic_printk(APIC_VERBOSE, "masked ExtINT on CPU#%d\n",
 			    smp_processor_id());
 	}
-	apic_write(APIC_LVT0, value);
+	apic_write_around(APIC_LVT0, value);
 
 	/*
 	 * only the BP should see the LINT1 NMI signal, obviously.
@@ -812,7 +812,7 @@ void __cpuinit setup_local_APIC(void)
 		value = APIC_DM_NMI;
 	else
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
-	apic_write(APIC_LVT1, value);
+	apic_write_around(APIC_LVT1, value);
 	preempt_enable();
 }
 
@@ -820,7 +820,7 @@ static void __cpuinit lapic_setup_esr(vo
 {
 	unsigned maxlvt = lapic_get_maxlvt();
 
-	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR);
+	apic_write_around(APIC_LVTERR, ERROR_APIC_VECTOR);
 	/*
 	 * spec says clear errors after enabling vector.
 	 */
@@ -925,7 +925,7 @@ int __init APIC_init_uniprocessor(void)
 	connect_bsp_APIC();
 
 	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
-	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
+	apic_write_around(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
 
 	setup_local_APIC();
 
@@ -1023,7 +1023,7 @@ void disconnect_bsp_APIC(int virt_wire_s
 	value &= ~APIC_VECTOR_MASK;
 	value |= APIC_SPIV_APIC_ENABLED;
 	value |= 0xf;
-	apic_write(APIC_SPIV, value);
+	apic_write_around(APIC_SPIV, value);
 
 	if (!virt_wire_setup) {
 		/*
@@ -1036,10 +1036,10 @@ void disconnect_bsp_APIC(int virt_wire_s
 			APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED);
 		value |= APIC_LVT_REMOTE_IRR | APIC_SEND_PENDING;
 		value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_EXTINT);
-		apic_write(APIC_LVT0, value);
+		apic_write_around(APIC_LVT0, value);
 	} else {
 		/* Disable LVT0 */
-		apic_write(APIC_LVT0, APIC_LVT_MASKED);
+		apic_write_around(APIC_LVT0, APIC_LVT_MASKED);
 	}
 
 	/* For LVT1 make it edge triggered, active high, nmi and enabled */
@@ -1049,7 +1049,7 @@ void disconnect_bsp_APIC(int virt_wire_s
 			APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED);
 	value |= APIC_LVT_REMOTE_IRR | APIC_SEND_PENDING;
 	value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_NMI);
-	apic_write(APIC_LVT1, value);
+	apic_write_around(APIC_LVT1, value);
 }
 
 void __cpuinit generic_processor_info(int apicid, int version)
@@ -1176,26 +1176,26 @@ static int lapic_resume(struct sys_devic
 	l &= ~MSR_IA32_APICBASE_BASE;
 	l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
 	wrmsr(MSR_IA32_APICBASE, l, h);
-	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR | APIC_LVT_MASKED);
-	apic_write(APIC_ID, apic_pm_state.apic_id);
-	apic_write(APIC_DFR, apic_pm_state.apic_dfr);
-	apic_write(APIC_LDR, apic_pm_state.apic_ldr);
-	apic_write(APIC_TASKPRI, apic_pm_state.apic_taskpri);
-	apic_write(APIC_SPIV, apic_pm_state.apic_spiv);
-	apic_write(APIC_LVT0, apic_pm_state.apic_lvt0);
-	apic_write(APIC_LVT1, apic_pm_state.apic_lvt1);
+	apic_write_around(APIC_LVTERR, ERROR_APIC_VECTOR | APIC_LVT_MASKED);
+	apic_write_around(APIC_ID, apic_pm_state.apic_id);
+	apic_write_around(APIC_DFR, apic_pm_state.apic_dfr);
+	apic_write_around(APIC_LDR, apic_pm_state.apic_ldr);
+	apic_write_around(APIC_TASKPRI, apic_pm_state.apic_taskpri);
+	apic_write_around(APIC_SPIV, apic_pm_state.apic_spiv);
+	apic_write_around(APIC_LVT0, apic_pm_state.apic_lvt0);
+	apic_write_around(APIC_LVT1, apic_pm_state.apic_lvt1);
 #ifdef CONFIG_X86_MCE_INTEL
 	if (maxlvt >= 5)
-		apic_write(APIC_LVTTHMR, apic_pm_state.apic_thmr);
+		apic_write_around(APIC_LVTTHMR, apic_pm_state.apic_thmr);
 #endif
 	if (maxlvt >= 4)
-		apic_write(APIC_LVTPC, apic_pm_state.apic_lvtpc);
-	apic_write(APIC_LVTT, apic_pm_state.apic_lvtt);
-	apic_write(APIC_TDCR, apic_pm_state.apic_tdcr);
-	apic_write(APIC_TMICT, apic_pm_state.apic_tmict);
+		apic_write_around(APIC_LVTPC, apic_pm_state.apic_lvtpc);
+	apic_write_around(APIC_LVTT, apic_pm_state.apic_lvtt);
+	apic_write_around(APIC_TDCR, apic_pm_state.apic_tdcr);
+	apic_write_around(APIC_TMICT, apic_pm_state.apic_tmict);
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
-	apic_write(APIC_LVTERR, apic_pm_state.apic_lvterr);
+	apic_write_around(APIC_LVTERR, apic_pm_state.apic_lvterr);
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 	local_irq_restore(flags);
