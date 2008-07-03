Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbYGCNcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbYGCNcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYGCNcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:32:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50542 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYGCNcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:32:21 -0400
Date: Thu, 3 Jul 2008 15:31:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: next-0703: build failure in x86/entry_64.S
Message-ID: <20080703133132.GC12102@elte.hu>
References: <a4423d670807030600y3b1e651end20b9993ca5c8d94@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670807030600y3b1e651end20b9993ca5c8d94@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Beregalov <a.beregalov@gmail.com> wrote:

> Hi
> 
>   AS      arch/x86/kernel/entry_64.o
> arch/x86/kernel/entry_64.S: Assembler messages:
> arch/x86/kernel/entry_64.S:1200: Error: invalid character '_' in mnemonic
> arch/x86/kernel/entry_64.S:1204: Error: invalid character '_' in mnemonic
> arch/x86/kernel/entry_64.S:1208: Error: invalid character '_' in mnemonic
> arch/x86/kernel/entry_64.S:1212: Error: invalid character '_' in mnemonic

hm, cannot reproduce it here with linux-next-0702.

but ... this looks quite similar to an issue triggered by the 
tip/x86/xen-64bit topic (and fixed by the patch below) - but that's not 
in linux-next yet.

	Ingo

------------->
commit 6d2a6e57be1582b017a39f52385adf49d7cc4b0f
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Fri Jun 27 12:04:03 2008 -0700

    x86_64: fix non-paravirt compilation
    
    Make sure SWAPGS and PARAVIRT_ADJUST_EXCEPTION_FRAME are properly
    defined when CONFIG_PARAVIRT is off.
    
    Fixes Ingo's build failure:
    arch/x86/kernel/entry_64.S: Assembler messages:
    arch/x86/kernel/entry_64.S:1201: Error: invalid character '_' in mnemonic
    arch/x86/kernel/entry_64.S:1205: Error: invalid character '_' in mnemonic
    arch/x86/kernel/entry_64.S:1209: Error: invalid character '_' in mnemonic
    arch/x86/kernel/entry_64.S:1213: Error: invalid character '_' in mnemonic
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Cc: Nick Piggin <npiggin@suse.de>
    Cc: Mark McLoughlin <markmc@redhat.com>
    Cc: xen-devel <xen-devel@lists.xensource.com>
    Cc: Eduardo Habkost <ehabkost@redhat.com>
    Cc: Vegard Nossum <vegard.nossum@gmail.com>
    Cc: Stephen Tweedie <sct@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/asm-x86/irqflags.h b/include/asm-x86/irqflags.h
index 484c74f..754bb3a 100644
--- a/include/asm-x86/irqflags.h
+++ b/include/asm-x86/irqflags.h
@@ -167,7 +167,20 @@ static inline unsigned long __raw_local_irq_save(void)
 #define INTERRUPT_RETURN_NMI_SAFE	NATIVE_INTERRUPT_RETURN_NMI_SAFE
 
 #ifdef CONFIG_X86_64
+#define SWAPGS	swapgs
+/*
+ * Currently paravirt can't handle swapgs nicely when we
+ * don't have a stack we can rely on (such as a user space
+ * stack).  So we either find a way around these or just fault
+ * and emulate if a guest tries to call swapgs directly.
+ *
+ * Either way, this is a good way to document that we don't
+ * have a reliable stack. x86_64 only.
+ */
 #define SWAPGS_UNSAFE_STACK	swapgs
+
+#define PARAVIRT_ADJUST_EXCEPTION_FRAME	/*  */
+
 #define INTERRUPT_RETURN	iretq
 #define USERGS_SYSRET64				\
 	swapgs;					\
@@ -233,15 +246,6 @@ static inline void trace_hardirqs_fixup(void)
 #else
 
 #ifdef CONFIG_X86_64
-/*
- * Currently paravirt can't handle swapgs nicely when we
- * don't have a stack we can rely on (such as a user space
- * stack).  So we either find a way around these or just fault
- * and emulate if a guest tries to call swapgs directly.
- *
- * Either way, this is a good way to document that we don't
- * have a reliable stack. x86_64 only.
- */
 #define ARCH_TRACE_IRQS_ON		call trace_hardirqs_on_thunk
 #define ARCH_TRACE_IRQS_OFF		call trace_hardirqs_off_thunk
 #define ARCH_LOCKDEP_SYS_EXIT		call lockdep_sys_exit_thunk
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index a935c70..6f5e195 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -535,9 +535,6 @@ static inline void load_sp0(struct tss_struct *tss,
 }
 
 #define set_iopl_mask native_set_iopl_mask
-#define SWAPGS	swapgs
-
-#define PARAVIRT_ADJUST_EXCEPTION_FRAME	/*  */
 #endif /* CONFIG_PARAVIRT */
 
 /*
