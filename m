Return-Path: <linux-kernel-owner+w=401wt.eu-S1423479AbXD3P6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423479AbXD3P6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423373AbXD3P4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:56:20 -0400
Received: from mx1.suse.de ([195.135.220.2]:44980 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423446AbXD3Ptk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:40 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: fernando@oss.ntt.co.jp, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/34] i386: safe_apic_wait_icr_idle - i386
Message-Id: <20070430154938.18C80151F8@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Fernando Luis VazquezCao <fernando@oss.ntt.co.jp>

apic_wait_icr_idle looks like this:

static __inline__ void apic_wait_icr_idle(void)
{
  while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
    cpu_relax();
}

The busy loop in this function would not be problematic if the
corresponding status bit in the ICR were always updated, but that does
not seem to be the case under certain crash scenarios. Kdump uses an IPI
to stop the other CPUs in the event of a crash, but when any of the
other CPUs are locked-up inside the NMI handler the CPU that sends the
IPI will end up looping forever in the ICR check, effectively
hard-locking the whole system.

Quoting from Intel's "MultiProcessor Specification" (Version 1.4), B-3:

"A local APIC unit indicates successful dispatch of an IPI by
resetting the Delivery Status bit in the Interrupt Command
Register (ICR). The operating system polls the delivery status
bit after sending an INIT or STARTUP IPI until the command has
been dispatched.

A period of 20 microseconds should be sufficient for IPI dispatch
to complete under normal operating conditions. If the IPI is not
successfully dispatched, the operating system can abort the
command. Alternatively, the operating system can retry the IPI by
writing the lower 32-bit double word of the ICR. This “time-out”
mechanism can be implemented through an external interrupt, if
interrupts are enabled on the processor, or through execution of
an instruction or time-stamp counter spin loop."

Intel's documentation suggests the implementation of a time-out
mechanism, which, by the way, is already being open-coded in some parts
of the kernel that tinker with ICR.

Create a apic_wait_icr_idle replacement that implements the time-out
mechanism and that can be used to solve the aforementioned problem.

AK: moved both functions out of line
AK: added improved loop from Keith Owens

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Andi Kleen <ak@suse.de>

---

---
 arch/i386/kernel/apic.c |   22 ++++++++++++++++++++++
 include/asm-i386/apic.h |    9 +++------
 2 files changed, 25 insertions(+), 6 deletions(-)

Index: linux/include/asm-i386/apic.h
===================================================================
--- linux.orig/include/asm-i386/apic.h
+++ linux/include/asm-i386/apic.h
@@ -2,6 +2,7 @@
 #define __ASM_APIC_H
 
 #include <linux/pm.h>
+#include <linux/delay.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
 #include <asm/processor.h>
@@ -64,12 +65,8 @@ static __inline fastcall unsigned long n
 	return *((volatile unsigned long *)(APIC_BASE+reg));
 }
 
-static __inline__ void apic_wait_icr_idle(void)
-{
-	while ( apic_read( APIC_ICR ) & APIC_ICR_BUSY )
-		cpu_relax();
-}
-
+void apic_wait_icr_idle(void);
+unsigned long safe_apic_wait_icr_idle(void);
 int get_physical_broadcast(void);
 
 #ifdef CONFIG_X86_GOOD_APIC
Index: linux/arch/i386/kernel/apic.c
===================================================================
--- linux.orig/arch/i386/kernel/apic.c
+++ linux/arch/i386/kernel/apic.c
@@ -129,6 +129,28 @@ static int modern_apic(void)
 	return lapic_get_version() >= 0x14;
 }
 
+void apic_wait_icr_idle(void)
+{
+	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
+		cpu_relax();
+}
+
+unsigned long safe_apic_wait_icr_idle(void)
+{
+	unsigned long send_status;
+	int timeout;
+
+	timeout = 0;
+	do {
+		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
+		if (!send_status)
+			break;
+		udelay(100);
+	} while (timeout++ < 1000);
+
+	return send_status;
+}
+
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
