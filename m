Return-Path: <linux-kernel-owner+w=401wt.eu-S1759852AbYCUXsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbYCUXsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYCUXpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:45:35 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60181 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbYCUXp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:45:26 -0400
Message-Id: <20080321224347.716247516@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:11 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Jan Beulich <jbeulich@novell.com>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 21/76] x86: adjust enable_NMI_through_LVT0()
Content-Disposition: inline; filename=x86-adjust-enable_nmi_through_lvt0.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jan Beulich <jbeulich@novell.com>

commit e94271017f0933b29362a3c9dea5a6b9d04d98e1

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
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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

--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -154,7 +154,7 @@ unsigned long safe_apic_wait_icr_idle(vo
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
-void enable_NMI_through_LVT0 (void * dummy)
+void __cpuinit enable_NMI_through_LVT0(void)
 {
 	unsigned int v = APIC_DM_NMI;
 
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -151,7 +151,7 @@ unsigned int safe_apic_wait_icr_idle(voi
 	return send_status;
 }
 
-void enable_NMI_through_LVT0 (void * dummy)
+void enable_NMI_through_LVT0(void)
 {
 	unsigned int v;
 
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
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
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
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
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -405,7 +405,7 @@ static void __cpuinit start_secondary(vo
 	setup_secondary_clock();
 	if (nmi_watchdog == NMI_IO_APIC) {
 		disable_8259A_irq(0);
-		enable_NMI_through_LVT0(NULL);
+		enable_NMI_through_LVT0();
 		enable_8259A_irq(0);
 	}
 	/*
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -338,7 +338,7 @@ void __cpuinit start_secondary(void)
 
 	if (nmi_watchdog == NMI_IO_APIC) {
 		disable_8259A_irq(0);
-		enable_NMI_through_LVT0(NULL);
+		enable_NMI_through_LVT0();
 		enable_8259A_irq(0);
 	}
 
--- a/include/asm-x86/apic_32.h
+++ b/include/asm-x86/apic_32.h
@@ -109,7 +109,7 @@ extern void setup_boot_APIC_clock (void)
 extern void setup_secondary_APIC_clock (void);
 extern int APIC_init_uniprocessor (void);
 
-extern void enable_NMI_through_LVT0 (void * dummy);
+extern void enable_NMI_through_LVT0(void);
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
--- a/include/asm-x86/io_apic_64.h
+++ b/include/asm-x86/io_apic_64.h
@@ -129,7 +129,7 @@ extern int io_apic_set_pci_routing (int 
 
 extern int sis_apic_bug; /* dummy */ 
 
-void enable_NMI_through_LVT0 (void * dummy);
+void enable_NMI_through_LVT0(void);
 
 extern spinlock_t i8259A_lock;
 

-- 
