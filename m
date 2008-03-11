Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbYCKKaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbYCKKaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYCKKao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:30:44 -0400
Received: from www.tglx.de ([62.245.132.106]:45730 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbYCKKan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:30:43 -0400
Date: Tue, 11 Mar 2008 11:30:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: LKML <linux-kernel@vger.kernel.org>, Stable Team <stable@kernel.org>
Subject: Re: 2.6.24.3: WARNING: native_smp_call_function_mask() at boot
 time
In-Reply-To: <alpine.DEB.1.00.0803100426320.18620@p34.internal.lan>
Message-ID: <alpine.LFD.1.00.0803111104550.3781@apollo.tec.linutronix.de>
References: <alpine.DEB.1.00.0803100426320.18620@p34.internal.lan>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008, Justin Piszcz wrote:
> Running kernel 2.6.24.3 on Debian Testing here..
>
> [   19.141846] WARNING: at arch/x86/kernel/smp_32.c:561
> native_smp_call_function_mask()
> [   19.141896] Pid: 1, comm: swapper Not tainted 2.6.24.3 #1
> [   19.141937]  [<c010e50b>] native_smp_call_function_mask+0x14b/0x150
> [   19.142009]  [<c01036c3>] common_interrupt+0x23/0x28
> [   19.142076]  [<c010f470>] enable_NMI_through_LVT0+0x0/0x30
> [   19.142144]  [<c010f470>] enable_NMI_through_LVT0+0x0/0x30
> [   19.142212]  [<c010e8fc>] smp_call_function+0x1c/0x30
> [   19.142279]  [<c012196c>] on_each_cpu+0x2c/0x60
> [   19.142346]  [<c0110840>] setup_nmi+0x30/0x50

Can you please try the backported patch below.

Thanks,
	tglx

------------->

commit e94271017f0933b29362a3c9dea5a6b9d04d98e1
Author: Jan Beulich <jbeulich@novell.com>
Date:   Wed Jan 30 13:31:24 2008 +0100

    x86: adjust enable_NMI_through_LVT0()
    
    Its previous use in a call to on_each_cpu() was pointless, as at the
    time that code gets executed only one CPU is online. Further, the
    function can be __cpuinit, and for this to work without
    CONFIG_HOTPLUG_CPU setup_nmi() must also get an attribute (this one
    can even be __init; on 64-bits check_timer() also was lacking that
    attribute).
    
    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

[ tglx@linutronix.de: backport to 2.6.24.3]

---
 arch/x86/kernel/apic_32.c    |    2 +-
 arch/x86/kernel/apic_64.c    |    2 +-
 arch/x86/kernel/io_apic_32.c |    4 ++--
 arch/x86/kernel/io_apic_64.c |    6 +++---
 arch/x86/kernel/smpboot_32.c |    2 +-
 arch/x86/kernel/smpboot_64.c |    2 +-
 include/asm-x86/apic_32.h    |    2 +-
 include/asm-x86/io_apic_64.h |    2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6/arch/x86/kernel/apic_32.c
@@ -154,7 +154,7 @@ unsigned long safe_apic_wait_icr_idle(vo
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
-void enable_NMI_through_LVT0 (void * dummy)
+void __cpuinit enable_NMI_through_LVT0(void)
 {
 	unsigned int v = APIC_DM_NMI;
 
Index: linux-2.6/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6/arch/x86/kernel/apic_64.c
@@ -151,7 +151,7 @@ unsigned int safe_apic_wait_icr_idle(voi
 	return send_status;
 }
 
-void enable_NMI_through_LVT0 (void * dummy)
+void enable_NMI_through_LVT0(void)
 {
 	unsigned int v;
 
Index: linux-2.6/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_32.c
+++ linux-2.6/arch/x86/kernel/io_apic_32.c
@@ -2080,7 +2080,7 @@ static struct irq_chip lapic_chip __read
 	.eoi		= ack_apic,
 };
 
-static void setup_nmi (void)
+static void __init setup_nmi(void)
 {
 	/*
  	 * Dirty trick to enable the NMI watchdog ...
@@ -2093,7 +2093,7 @@ static void setup_nmi (void)
 	 */ 
 	apic_printk(APIC_VERBOSE, KERN_INFO "activating NMI Watchdog ...");
 
-	on_each_cpu(enable_NMI_through_LVT0, NULL, 1, 1);
+	enable_NMI_through_LVT0();
 
 	apic_printk(APIC_VERBOSE, " done.\n");
 }
Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
@@ -1565,7 +1565,7 @@ static struct hw_interrupt_type lapic_ir
 	.end = end_lapic_irq,
 };
 
-static void setup_nmi (void)
+static void __init setup_nmi(void)
 {
 	/*
  	 * Dirty trick to enable the NMI watchdog ...
@@ -1578,7 +1578,7 @@ static void setup_nmi (void)
 	 */ 
 	printk(KERN_INFO "activating NMI Watchdog ...");
 
-	enable_NMI_through_LVT0(NULL);
+	enable_NMI_through_LVT0();
 
 	printk(" done.\n");
 }
@@ -1654,7 +1654,7 @@ static inline void unlock_ExtINT_logic(v
  *
  * FIXME: really need to revamp this for modern platforms only.
  */
-static inline void check_timer(void)
+static inline void __init check_timer(void)
 {
 	struct irq_cfg *cfg = irq_cfg + 0;
 	int apic1, pin1, apic2, pin2;
Index: linux-2.6/arch/x86/kernel/smpboot_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot_32.c
+++ linux-2.6/arch/x86/kernel/smpboot_32.c
@@ -405,7 +405,7 @@ static void __cpuinit start_secondary(vo
 	setup_secondary_clock();
 	if (nmi_watchdog == NMI_IO_APIC) {
 		disable_8259A_irq(0);
-		enable_NMI_through_LVT0(NULL);
+		enable_NMI_through_LVT0();
 		enable_8259A_irq(0);
 	}
 	/*
Index: linux-2.6/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot_64.c
+++ linux-2.6/arch/x86/kernel/smpboot_64.c
@@ -338,7 +338,7 @@ void __cpuinit start_secondary(void)
 
 	if (nmi_watchdog == NMI_IO_APIC) {
 		disable_8259A_irq(0);
-		enable_NMI_through_LVT0(NULL);
+		enable_NMI_through_LVT0();
 		enable_8259A_irq(0);
 	}
 
Index: linux-2.6/include/asm-x86/apic_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/apic_32.h
+++ linux-2.6/include/asm-x86/apic_32.h
@@ -109,7 +109,7 @@ extern void setup_boot_APIC_clock (void)
 extern void setup_secondary_APIC_clock (void);
 extern int APIC_init_uniprocessor (void);
 
-extern void enable_NMI_through_LVT0 (void * dummy);
+extern void enable_NMI_through_LVT0(void);
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
Index: linux-2.6/include/asm-x86/io_apic_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/io_apic_64.h
+++ linux-2.6/include/asm-x86/io_apic_64.h
@@ -129,7 +129,7 @@ extern int io_apic_set_pci_routing (int 
 
 extern int sis_apic_bug; /* dummy */ 
 
-void enable_NMI_through_LVT0 (void * dummy);
+void enable_NMI_through_LVT0(void);
 
 extern spinlock_t i8259A_lock;
 


