Return-Path: <linux-kernel-owner+w=401wt.eu-S1946811AbXBJLxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946811AbXBJLxr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933431AbXBJLxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:53:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:50378 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933440AbXBJLwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:52:43 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101252.033732000@suse.de>
In-Reply-To: <200702101252.033732000@suse.de>
To: Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review II] [4/10] i386: sMP boot hook for paravirt
Message-Id: <20070210115232.3DE6513DDE@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:52:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>

Add VMI SMP boot hook.  We emulate a regular boot sequence and use the same
APIC IPI initiation, we just poke magic values to load into the CPU state when
the startup IPI is received, rather than having to jump through a real mode
trampoline.

This is all that was needed to get SMP to work.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/paravirt.c |    2 ++
 arch/i386/kernel/smpboot.c  |    7 +++++++
 include/asm-i386/paravirt.h |    9 +++++++++
 include/asm-i386/smp.h      |    5 +++++
 4 files changed, 23 insertions(+)

Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
@@ -572,6 +572,8 @@ struct paravirt_ops paravirt_ops = {
 
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
+
+	.startup_ipi_hook = (void *)native_nop,
 };
 
 /*
Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -834,6 +834,13 @@ wakeup_secondary_cpu(int phys_apicid, un
 		num_starts = 0;
 
 	/*
+	 * Paravirt / VMI wants a startup IPI hook here to set up the
+	 * target processor state.
+	 */
+	startup_ipi_hook(phys_apicid, (unsigned long) start_secondary,
+		         (unsigned long) stack_start.esp);
+
+	/*
 	 * Run STARTUP IPI loop.
 	 */
 	Dprintk("#startup loops: %d.\n", num_starts);
Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
@@ -151,6 +151,8 @@ struct paravirt_ops
 	/* These two are jmp to, not actually called. */
 	void (fastcall *irq_enable_sysexit)(void);
 	void (fastcall *iret)(void);
+
+	void (fastcall *startup_ipi_hook)(int phys_apicid, unsigned long start_eip, unsigned long start_esp);
 };
 
 /* Mark a paravirt probe function. */
@@ -323,6 +325,13 @@ static inline unsigned long apic_read(un
 }
 #endif
 
+#ifdef CONFIG_SMP
+static inline void startup_ipi_hook(int phys_apicid, unsigned long start_eip,
+				    unsigned long start_esp)
+{
+	return paravirt_ops.startup_ipi_hook(phys_apicid, start_eip, start_esp);
+}
+#endif
 
 #define __flush_tlb() paravirt_ops.flush_tlb_user()
 #define __flush_tlb_global() paravirt_ops.flush_tlb_kernel()
Index: linux/include/asm-i386/smp.h
===================================================================
--- linux.orig/include/asm-i386/smp.h
+++ linux/include/asm-i386/smp.h
@@ -52,6 +52,11 @@ extern void cpu_exit_clear(void);
 extern void cpu_uninit(void);
 #endif
 
+#ifndef CONFIG_PARAVIRT
+#define startup_ipi_hook(phys_apicid, start_eip, start_esp) 		\
+do { } while (0)
+#endif
+
 /*
  * This function is needed by all SMP systems. It must _always_ be valid
  * from the initial startup. We map APIC_BASE very early in page_setup(),
