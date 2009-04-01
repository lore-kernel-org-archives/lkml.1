Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbZDARVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbZDARVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZDARVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:21:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:47921 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbZDARVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:21:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gELyYiEAWL84vUC2Rg5/5kr32w3Gq55kEl2KDnqldB+Qi7IQ7E8Oj0+GgORE2auVWl
         FD1klnlxduslq1V2AwdJwjMnMDz5pkwwzKQ0TTKhXwahHUoFNf7s6eC9w14+JtAJuCpJ
         Y83bzOwDLqE51WoBmGsC+ncspxq+rKQxCNSUU=
Date: Wed, 1 Apr 2009 21:22:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, xemul@openvz.org, yhlu.kernel@gmail.com
Subject: Re: [patch 4/6] x86: irqinit - merge native_init_IRQ
Message-ID: <20090401172208.GG15781@localhost>
References: <20090329201545.470255691@openvz.org> <20090329202208.155551990@openvz.org> <20090401145328.GB6196@elte.hu> <20090401161609.GD15781@localhost> <20090401162250.GA22517@elte.hu> <20090401164001.GE15781@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401164001.GE15781@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

here is what I meant. The x86_quirk_pre_intr_init
and x86_quirk_intr_init do all we need. The only
paid off -- is that on x86-64 the functions
will check for x86_quirks->arch_intr_init and
x86_quirks->arch_pre_intr_init which are always
NULL for x86-64 (at least for now). If that is
acceptable -- then apply the patch below for
testing please. Othrewise we could eliminate
useless check by #ifdef (which would not be
that much differ from what I've posted initially
in patch series :)

        Cyrill
---

x86: irqinit - merge native_init_IRQ

For this purpose on X86-64 init_ISA_irqs is called
indirectly via x86_quirk_pre_intr_init (ie the same
way as X86-32 do).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/irqinit_32.c |    4 +++-
 arch/x86/kernel/irqinit_64.c |   22 +++++++++++++++++++++-
 arch/x86/kernel/setup.c      |    2 +-
 3 files changed, 25 insertions(+), 3 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6.git/arch/x86/kernel/irqinit_32.c
@@ -215,7 +215,7 @@ void __init native_init_IRQ(void)
 	 */
 	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
 		int vector = FIRST_EXTERNAL_VECTOR + i;
-		/* SYSCALL_VECTOR was reserved in trap_init. */
+		/* X86-32: SYSCALL_VECTOR was reserved in trap_init. */
 		if (!test_bit(vector, used_vectors))
 			set_intr_gate(vector, interrupt[i]);
 	}
@@ -229,6 +229,7 @@ void __init native_init_IRQ(void)
 	 */
 	x86_quirk_intr_init();
 
+#ifdef CONFIG_X86_32
 	/*
 	 * External FPU? Set up irq13 if so, for
 	 * original braindamaged IBM FERR coupling.
@@ -237,4 +238,5 @@ void __init native_init_IRQ(void)
 		setup_irq(FPU_IRQ, &fpu_irq);
 
 	irq_ctx_init(smp_processor_id());
+#endif
 }
Index: linux-2.6.git/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6.git/arch/x86/kernel/irqinit_64.c
@@ -21,6 +21,7 @@
 #include <asm/pgtable.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
+#include <asm/setup.h>
 #include <asm/i8259.h>
 
 /*
@@ -174,7 +175,8 @@ void __init native_init_IRQ(void)
 {
 	int i;
 
-	init_ISA_irqs();
+	/* Execute any quirks before the call gates are initialised: */
+	x86_quirk_pre_intr_init();
 
 	apic_intr_init();
 
@@ -185,10 +187,28 @@ void __init native_init_IRQ(void)
 	 */
 	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
 		int vector = FIRST_EXTERNAL_VECTOR + i;
+		/* X86-32: SYSCALL_VECTOR was reserved in trap_init. */
 		if (!test_bit(vector, used_vectors))
 			set_intr_gate(vector, interrupt[i]);
 	}
 
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
+
+	/*
+	 * Call quirks after call gates are initialised (usually add in
+	 * the architecture specific gates):
+	 */
+	x86_quirk_intr_init();
+
+#ifdef CONFIG_X86_32
+	/*
+	 * External FPU? Set up irq13 if so, for
+	 * original braindamaged IBM FERR coupling.
+	 */
+	if (boot_cpu_data.hard_math && !cpu_has_fpu)
+		setup_irq(FPU_IRQ, &fpu_irq);
+
+	irq_ctx_init(smp_processor_id());
+#endif
 }
Index: linux-2.6.git/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/setup.c
+++ linux-2.6.git/arch/x86/kernel/setup.c
@@ -995,7 +995,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 }
 
-#ifdef CONFIG_X86_32
 
 /**
  * x86_quirk_pre_intr_init - initialisation prior to setting up interrupt vectors
@@ -1032,6 +1031,7 @@ void __init x86_quirk_intr_init(void)
 	}
 }
 
+#ifdef CONFIG_X86_32
 /**
  * x86_quirk_trap_init - initialise system specific traps
  *
