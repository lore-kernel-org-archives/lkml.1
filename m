Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbXJaWA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbXJaWA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbXJaV7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:59:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759228AbXJaV7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:59:19 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6/7] consolidate apic.h functions
Date: Wed, 31 Oct 2007 16:13:18 -0300
Message-Id: <11938580331218-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11938580272819-git-send-email-gcosta@redhat.com>
References: <1193857999499-git-send-email-gcosta@redhat.com> <11938580063444-git-send-email-gcosta@redhat.com> <11938580111179-git-send-email-gcosta@redhat.com> <119385801745-git-send-email-gcosta@redhat.com> <1193858022794-git-send-email-gcosta@redhat.com> <11938580272819-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch consolidates apic.h functions for i386 and x86_64.
notice that we use u32 to be explicit about sizing requirements
between them

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/smpboot_64.c |   10 ++++++++--
 include/asm-x86/apic.h       |   38 ++++++++++++++++++++++++++++++++++++++
 include/asm-x86/apic_32.h    |   31 -------------------------------
 include/asm-x86/apic_64.h    |   14 --------------
 4 files changed, 46 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index ecd00f6..53db29d 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -370,7 +370,7 @@ void __cpuinit start_secondary(void)
 
 	unlock_ipi_call_lock();
 
-	setup_secondary_APIC_clock();
+	setup_secondary_clock();
 
 	cpu_idle();
 }
@@ -462,6 +462,12 @@ static int __cpuinit wakeup_secondary_via_INIT(int phys_apicid, unsigned int sta
 	num_starts = 2;
 
 	/*
+	 * Paravirt wants a startup IPI hook here to set up the
+	 * target processor state.
+	 */
+	startup_ipi_hook(phys_apicid, (unsigned long) start_rip,
+			(unsigned long) init_rsp);
+	/*
 	 * Run STARTUP IPI loop.
 	 */
 	Dprintk("#startup loops: %d.\n", num_starts);
@@ -903,7 +909,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	 * Set up local APIC timer on boot CPU.
 	 */
 
-	setup_boot_APIC_clock();
+	setup_boot_clock();
 }
 
 /*
diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index 9fbcc0b..6f61672 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -1,5 +1,43 @@
+#ifndef _X86_APIC_H_
+#define _X86_APIC_H_
+#include <asm/apicdef.h>
+#include <asm/fixmap.h>
+
+#ifdef CONFIG_X86_LOCAL_APIC
+/*
+ * Basic functions accessing APICs.
+ */
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define apic_write(reg, v) native_apic_write(reg, v)
+#define apic_write_atomic(reg, v) native_apic_write_atomic(reg, v)
+#define apic_read(reg) native_apic_read(reg)
+#define setup_boot_clock setup_boot_APIC_clock
+#define setup_secondary_clock setup_secondary_APIC_clock
+#endif
+static __inline fastcall void native_apic_write(unsigned long reg,
+						u32 v)
+{
+	*((volatile u32 *)(APIC_BASE+reg)) = v;
+}
+
+static __inline fastcall void native_apic_write_atomic(unsigned long reg,
+						       u32 v)
+{
+	xchg((volatile unsigned long *)(APIC_BASE+reg), v);
+}
+
+static __inline fastcall u32 native_apic_read(unsigned long reg)
+{
+	return *((volatile u32 *)(APIC_BASE+reg));
+}
+
+#endif /* CONFIG_X86_LOCAL_APIC */
+
 #ifdef CONFIG_X86_32
 # include "apic_32.h"
 #else
 # include "apic_64.h"
 #endif
+#endif
diff --git a/include/asm-x86/apic_32.h b/include/asm-x86/apic_32.h
index 4091b33..dbe51b4 100644
--- a/include/asm-x86/apic_32.h
+++ b/include/asm-x86/apic_32.h
@@ -34,37 +34,6 @@ extern int apic_verbosity;
 extern void generic_apic_probe(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
-
-/*
- * Basic functions accessing APICs.
- */
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define apic_write native_apic_write
-#define apic_write_atomic native_apic_write_atomic
-#define apic_read native_apic_read
-#define setup_boot_clock setup_boot_APIC_clock
-#define setup_secondary_clock setup_secondary_APIC_clock
-#endif
-
-static __inline fastcall void native_apic_write(unsigned long reg,
-						unsigned long v)
-{
-	*((volatile unsigned long *)(APIC_BASE+reg)) = v;
-}
-
-static __inline fastcall void native_apic_write_atomic(unsigned long reg,
-						       unsigned long v)
-{
-	xchg((volatile unsigned long *)(APIC_BASE+reg), v);
-}
-
-static __inline fastcall unsigned long native_apic_read(unsigned long reg)
-{
-	return *((volatile unsigned long *)(APIC_BASE+reg));
-}
-
 void apic_wait_icr_idle(void);
 unsigned long safe_apic_wait_icr_idle(void);
 int get_physical_broadcast(void);
diff --git a/include/asm-x86/apic_64.h b/include/asm-x86/apic_64.h
index 2747a11..aaba5af 100644
--- a/include/asm-x86/apic_64.h
+++ b/include/asm-x86/apic_64.h
@@ -34,20 +34,6 @@ extern int disable_apic_timer;
 
 struct pt_regs;
 
-/*
- * Basic functions accessing APICs.
- */
-
-static __inline void apic_write(unsigned long reg, unsigned int v)
-{
-	*((volatile unsigned int *)(APIC_BASE+reg)) = v;
-}
-
-static __inline unsigned int apic_read(unsigned long reg)
-{
-	return *((volatile unsigned int *)(APIC_BASE+reg));
-}
-
 extern void apic_wait_icr_idle(void);
 extern unsigned int safe_apic_wait_icr_idle(void);
 
-- 
1.4.4.2

