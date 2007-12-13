Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbXLMKKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbXLMKKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbXLMKKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:10:45 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:34282
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbXLMKKo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:10:44 -0500
Message-Id: <47611368.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 10:11:36 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: adjust enable_NMI_through_LVT0()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its previous use in a call to on_each_cpu() was pointless, as at the
time that code gets executed only one CPU is online. Further, the
function can be __cpuinit, and for this to work without
CONFIG_HOTPLUG_CPU setup_nmi() must also get an attribute (this one
can even be __init; on 64-bits check_timer() also was lacking that
attribute).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/apic_32.c    |    2 +-
 arch/x86/kernel/apic_64.c    |    2 +-
 arch/x86/kernel/io_apic_32.c |    4 ++--
 arch/x86/kernel/io_apic_64.c |    6 +++---
 arch/x86/kernel/smpboot_32.c |    2 +-
 arch/x86/kernel/smpboot_64.c |    2 +-
 include/asm-x86/apic_32.h    |    2 +-
 include/asm-x86/io_apic_64.h |    2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

--- linux-2.6.24-rc5/arch/x86/kernel/apic_32.c	2007-12-12 11:28:17.000000000 +0100
+++ 2.6.24-rc5-x86-enable_NMI_through_LVT0/arch/x86/kernel/apic_32.c	2007-12-11 13:35:33.000000000 +0100
@@ -154,7 +154,7 @@ unsigned long safe_apic_wait_icr_idle(vo
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
-void enable_NMI_through_LVT0 (void * dummy)
+void __cpuinit enable_NMI_through_LVT0(void)
 {
 	unsigned int v = APIC_DM_NMI;
 
--- linux-2.6.24-rc5/arch/x86/kernel/apic_64.c	2007-12-12 11:28:17.000000000 +0100
+++ 2.6.24-rc5-x86-enable_NMI_through_LVT0/arch/x86/kernel/apic_64.c	2007-12-11 13:35:41.000000000 +0100
@@ -151,7 +151,7 @@ unsigned int safe_apic_wait_icr_idle(voi
 	return send_status;
 }
 
-void enable_NMI_through_LVT0 (void * dummy)
+void __cpuinit enable_NMI_through_LVT0(void)
 {
 	unsigned int v;
 
--- linux-2.6.24-rc5/arch/x86/kernel/io_apic_32.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-enable_NMI_through_LVT0/arch/x86/kernel/io_apic_32.c	2007-12-11 11:53:31.000000000 +0100
@@ -2077,7 +2077,7 @@ static struct irq_chip lapic_chip __read
 	.eoi		= ack_apic,
 };
 
-static void setup_nmi (void)
+static void __init setup_nmi(void)
 {
 	/*
  	 * Dirty trick to enable the NMI watchdog ...
@@ -2090,7 +2090,7 @@ static void setup_nmi (void)
 	 */ 
 	apic_printk(APIC_VERBOSE, KERN_INFO "activating NMI Watchdog ...");
 
-	on_each_cpu(enable_NMI_through_LVT0, NULL, 1, 1);
+	enable_NMI_through_LVT0();
 
 	apic_printk(APIC_VERBOSE, " done.\n");
 }
--- linux-2.6.24-rc5/arch/x86/kernel/io_apic_64.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-enable_NMI_through_LVT0/arch/x86/kernel/io_apic_64.c	2007-12-11 11:53:31.000000000 +0100
@@ -1562,7 +1562,7 @@ static struct hw_interrupt_type lapic_ir
 	.end = end_lapic_irq,
 };
 
-static void setup_nmi (void)
+static void __init setup_nmi(void)
 {
 	/*
  	 * Dirty trick to enable the NMI watchdog ...
@@ -1575,7 +1575,7 @@ static void setup_nmi (void)
 	 */ 
 	printk(KERN_INFO "activating NMI Watchdog ...");
 
-	enable_NMI_through_LVT0(NULL);
+	enable_NMI_through_LVT0();
 
 	printk(" done.\n");
 }
@@ -1651,7 +1651,7 @@ static inline void unlock_ExtINT_logic(v
  *
  * FIXME: really need to revamp this for modern platforms only.
  */
-static inline void check_timer(void)
+static inline void __init check_timer(void)
 {
 	struct irq_cfg *cfg = irq_cfg + 0;
 	int apic1, pin1, apic2, pin2;
--- linux-2.6.24-rc5/arch/x86/kernel/smpboot_32.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-enable_NMI_through_LVT0/arch/x86/kernel/smpboot_32.c	2007-12-11 11:53:31.000000000 +0100
@@ -405,7 +405,7 @@ static void __cpuinit start_secondary(vo
 	setup_secondary_clock();
 	if (nmi_watchdog == NMI_IO_APIC) {
 		disable_8259A_irq(0);
-		enable_NMI_through_LVT0(NULL);
+		enable_NMI_through_LVT0();
 		enable_8259A_irq(0);
 	}
 	/*
--- linux-2.6.24-rc5/arch/x86/kernel/smpboot_64.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-enable_NMI_through_LVT0/arch/x86/kernel/smpboot_64.c	2007-12-11 11:53:31.000000000 +0100
@@ -338,7 +338,7 @@ void __cpuinit start_secondary(void)
 
 	if (nmi_watchdog == NMI_IO_APIC) {
 		disable_8259A_irq(0);
-		enable_NMI_through_LVT0(NULL);
+		enable_NMI_through_LVT0();
 		enable_8259A_irq(0);
 	}
 
--- linux-2.6.24-rc5/include/asm-x86/apic_32.h	2007-12-12 11:29:30.000000000 +0100
+++ 2.6.24-rc5-x86-enable_NMI_through_LVT0/include/asm-x86/apic_32.h	2007-12-11 11:53:31.000000000 +0100
@@ -109,7 +109,7 @@ extern void setup_boot_APIC_clock (void)
 extern void setup_secondary_APIC_clock (void);
 extern int APIC_init_uniprocessor (void);
 
-extern void enable_NMI_through_LVT0 (void * dummy);
+extern void enable_NMI_through_LVT0(void);
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
--- linux-2.6.24-rc5/include/asm-x86/io_apic_64.h	2007-12-12 11:29:30.000000000 +0100
+++ 2.6.24-rc5-x86-enable_NMI_through_LVT0/include/asm-x86/io_apic_64.h	2007-12-11 11:53:31.000000000 +0100
@@ -129,7 +129,7 @@ extern int io_apic_set_pci_routing (int 
 
 extern int sis_apic_bug; /* dummy */ 
 
-void enable_NMI_through_LVT0 (void * dummy);
+void enable_NMI_through_LVT0(void);
 
 extern spinlock_t i8259A_lock;
 


