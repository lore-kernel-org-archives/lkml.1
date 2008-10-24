Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYJXDLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYJXDLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 23:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYJXDL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 23:11:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40374 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752584AbYJXDL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 23:11:28 -0400
Date: Thu, 23 Oct 2008 22:11:27 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH 2/2 v3] SGI RTC: add RTC system interrupt
Message-ID: <20081024031127.GA25165@sgi.com>
References: <20081023163041.GA14574@sgi.com> <20081023163223.GA14815@sgi.com> <20081023163414.GB14815@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023163414.GB14815@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allocates a system interrupt vector for architecture specific
use in implementing RTC timer interrupts.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

Note that this version (v3) was created simply to apply on top of the changes
brought about by the move from include/asm-x86 to arch/x86/include/asm:
	http://lkml.org/lkml/2008/10/23/63

No changes to the other patch in this set were required.

 arch/x86/include/asm/genapic_64.h  |    2 +
 arch/x86/include/asm/hw_irq.h      |    1 
 arch/x86/include/asm/irq_vectors.h |    1 
 arch/x86/kernel/entry_64.S         |    4 +++
 arch/x86/kernel/genx2apic_uv_x.c   |   41 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/irqinit_64.c       |    3 ++
 6 files changed, 52 insertions(+)

Index: linux/arch/x86/kernel/entry_64.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_64.S	2008-10-23 21:45:08.000000000 -0500
+++ linux/arch/x86/kernel/entry_64.S	2008-10-23 21:48:12.000000000 -0500
@@ -858,6 +858,10 @@ ENTRY(apic_timer_interrupt)
 	apicinterrupt LOCAL_TIMER_VECTOR,smp_apic_timer_interrupt
 END(apic_timer_interrupt)
 
+ENTRY(uv_rtc_timer_intr)
+	apicinterrupt RTC_TIMER_VECTOR,uv_rtc_timer_interrupt
+END(uv_rtc_timer_intr)
+
 ENTRY(uv_bau_message_intr1)
 	apicinterrupt 220,uv_bau_message_interrupt
 END(uv_bau_message_intr1)
Index: linux/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit_64.c	2008-10-23 21:45:08.000000000 -0500
+++ linux/arch/x86/kernel/irqinit_64.c	2008-10-23 21:48:12.000000000 -0500
@@ -201,6 +201,9 @@ static void __init apic_intr_init(void)
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
+	/* IPI for RTC timers */
+	alloc_intr_gate(RTC_TIMER_VECTOR, uv_rtc_timer_intr);
+
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-10-23 21:46:38.000000000 -0500
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2008-10-23 21:48:12.000000000 -0500
@@ -22,6 +22,7 @@
 #include <asm/ipi.h>
 #include <asm/genapic.h>
 #include <asm/pgtable.h>
+#include <asm/idle.h>
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/bios.h>
@@ -356,6 +357,46 @@ static __init void uv_rtc_init(void)
 		sn_rtc_cycles_per_second = ticks_per_sec;
 }
 
+/* Function pointer for RTC interrupt handling */
+static void (*uv_rtc_interrupt_extension)(void);
+
+int
+uv_rtc_reg_extension(void (*fn)(void))
+{
+	if (uv_rtc_interrupt_extension)
+		return 1;
+
+	uv_rtc_interrupt_extension = fn;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(uv_rtc_reg_extension);
+
+void
+uv_rtc_unreg_extension(void)
+{
+	if (uv_rtc_interrupt_extension)
+		uv_rtc_interrupt_extension = NULL;
+}
+EXPORT_SYMBOL_GPL(uv_rtc_unreg_extension);
+
+void uv_rtc_timer_interrupt(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	ack_APIC_irq();
+
+	exit_idle();
+
+	irq_enter();
+
+	if (uv_rtc_interrupt_extension)
+		uv_rtc_interrupt_extension();
+
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
+
 /*
  * Called on each cpu to initialize the per_cpu UV data area.
  * 	ZZZ hotplug not supported yet
Index: linux/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux.orig/arch/x86/include/asm/irq_vectors.h	2008-10-23 21:45:08.000000000 -0500
+++ linux/arch/x86/include/asm/irq_vectors.h	2008-10-23 21:50:14.000000000 -0500
@@ -85,6 +85,7 @@
  * sources per level' errata.
  */
 #define LOCAL_TIMER_VECTOR	0xef
+#define RTC_TIMER_VECTOR	0xee
 
 /*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
Index: linux/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/hw_irq.h	2008-10-23 21:45:08.000000000 -0500
+++ linux/arch/x86/include/asm/hw_irq.h	2008-10-23 21:54:05.000000000 -0500
@@ -29,6 +29,7 @@
 
 /* Interrupt handlers registered during init_IRQ */
 extern void apic_timer_interrupt(void);
+extern void uv_rtc_timer_intr(void);
 extern void error_interrupt(void);
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
Index: linux/arch/x86/include/asm/genapic_64.h
===================================================================
--- linux.orig/arch/x86/include/asm/genapic_64.h	2008-10-23 21:45:08.000000000 -0500
+++ linux/arch/x86/include/asm/genapic_64.h	2008-10-23 21:54:59.000000000 -0500
@@ -49,6 +49,8 @@ extern int is_uv_system(void);
 
 extern struct genapic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
+extern int uv_rtc_reg_extension(void (*fn)(void));
+extern void uv_rtc_unreg_extension(void);
 extern void uv_cpu_init(void);
 extern void uv_system_init(void);
 extern int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip);
