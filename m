Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbZBLMvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbZBLMvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758892AbZBLMui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:50:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54457 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790AbZBLMug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:50:36 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212149.227733077@firstfloor.org>
In-Reply-To: <20090212149.227733077@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/9] x86: CMCI: Factor out threshold interrupt handler
Message-Id: <20090212124931.444CE3E666D@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:49:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup; preparation for feature

The mce_amd_64 code has an own private MC threshold vector with an own
interrupt handler. Since Intel needs a similar handler
it makes sense to share the vector because both can not 
be active at the same time. 

I factored the common APIC handler code into a separate file which can
be used by both the Intel or AMD MC code. 

This is needed for the next patch which adds an Intel specific
CMCI handler.

This patch should be a nop for AMD, it just moves some code 
around.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/Kconfig                        |    5 +++++
 arch/x86/include/asm/mce.h              |    2 ++
 arch/x86/kernel/cpu/mcheck/Makefile     |    1 +
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |   15 ++++++---------
 arch/x86/kernel/cpu/mcheck/threshold.c  |   24 ++++++++++++++++++++++++
 5 files changed, 38 insertions(+), 9 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/threshold.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/arch/x86/kernel/cpu/mcheck/threshold.c	2009-02-12 12:10:18.000000000 +0100
@@ -0,0 +1,24 @@
+/* Common corrected MCE threshold handler code */
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <asm/mce.h>
+#include <asm/irq_vectors.h>
+#include <asm/idle.h>
+
+static void default_threshold_interrupt(void)
+{
+	printk(KERN_ERR "Unexpected threshold interrupt at vector %x\n",
+			 THRESHOLD_APIC_VECTOR);
+}
+
+void (*mce_threshold_vector)(void) = default_threshold_interrupt;
+
+asmlinkage void mce_threshold_interrupt(void)
+{
+	ack_APIC_irq();
+	exit_idle();
+	irq_enter();
+	inc_irq_stat(irq_threshold_count);
+	mce_threshold_vector();
+	irq_exit();
+}
Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig	2009-02-12 11:30:47.000000000 +0100
+++ linux/arch/x86/Kconfig	2009-02-12 11:30:51.000000000 +0100
@@ -751,6 +751,11 @@
 	   Additional support for AMD specific MCE features such as
 	   the DRAM Error Threshold.
 
+config X86_MCE_THRESHOLD
+	depends on X86_MCE_AMD || X86_MCE_INTEL
+	bool
+	default y
+
 config X86_MCE_NONFATAL
 	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
 	depends on X86_32 && X86_MCE
Index: linux/arch/x86/kernel/cpu/mcheck/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/Makefile	2009-02-12 11:30:47.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/Makefile	2009-02-12 11:30:51.000000000 +0100
@@ -4,3 +4,4 @@
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel_64.o
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd_64.o
 obj-$(CONFIG_X86_MCE_NONFATAL)	+= non-fatal.o
+obj-$(CONFIG_X86_MCE_THRESHOLD) += threshold.o
Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/include/asm/mce.h	2009-02-12 12:10:17.000000000 +0100
@@ -135,5 +135,7 @@
 #define mcheck_init(c) do { } while (0)
 #endif
 
+extern void (*mce_threshold_vector)(void);
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
Index: linux/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2009-02-12 12:10:17.000000000 +0100
@@ -79,6 +79,8 @@
 
 static DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
 
+static void amd_threshold_interrupt(void);
+
 /*
  * CPU Initialization
  */
@@ -174,6 +176,8 @@
 			tr.reset = 0;
 			tr.old_limit = 0;
 			threshold_restart_bank(&tr);
+
+			mce_threshold_vector = amd_threshold_interrupt;
 		}
 	}
 }
@@ -187,16 +191,12 @@
  * the interrupt goes off when error_count reaches threshold_limit.
  * the handler will simply log mcelog w/ software defined bank number.
  */
-asmlinkage void mce_threshold_interrupt(void)
+static void amd_threshold_interrupt(void)
 {
 	unsigned int bank, block;
 	struct mce m;
 	u32 low = 0, high = 0, address = 0;
 
-	ack_APIC_irq();
-	exit_idle();
-	irq_enter();
-
 	mce_setup(&m);
 
 	/* assume first bank caused it */
@@ -241,13 +241,10 @@
 				       + bank * NR_BLOCKS
 				       + block;
 				mce_log(&m);
-				goto out;
+				return;
 			}
 		}
 	}
-out:
-	inc_irq_stat(irq_threshold_count);
-	irq_exit();
 }
 
 /*
