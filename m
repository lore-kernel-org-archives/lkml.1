Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbYGCXwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbYGCXwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 19:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYGCXwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 19:52:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44597 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757873AbYGCXwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 19:52:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for July 3
Date: Fri, 4 Jul 2008 01:54:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       kernel-testers@vger.kernel.org
References: <20080703190948.8e7bceca.sfr@canb.auug.org.au>
In-Reply-To: <20080703190948.8e7bceca.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807040154.16200.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of July 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since next-20080702:
> 
> New trees:  kmemcheck and generic-ipi.
> 
> The pci tree gained a conflict against the driver-core tree.
> 
> The powerpc tree gained a conflict against the i2c tree.
> 
> The net tree gained a couple of conflicts against Linus' tree and the
> wireless-current tree.
> 
> The wireless tree gained a couple of conflicts against the
> wireless-current tree.
> 
> The rr tree lost its two build fixup patches but gained another conflict
> against the sched tree.
> 
> The blk-removal tree lost its conflict with the s390 tree.
> 
> The kmemcheck tree gained conflicts against the ftrace, sched, and x86
> trees.
> 
> The generic-ipi tree gained conflicts against the powerpc, kmemcheck and
> net trees.  And had two build failures requiring a patch and a revert.
> 
> I have also applied the following patches for known problems (I assume
> that these will be merged into their appropriate trees shortly):
> 
> 	NFS: Fix the mount protocol defaults for binary mounts
> 	fix "ftrace: store mcount address in rec->ip"
> 
> There are several outstanding build failures due to structural changes in
> the ttydev tree (see http://kisskb.ellerman.id.au/linux-next).

This tree didn't compile for me on x86-64.

After adding the appended patch it started to compile, but it doesn't boot
(hangs very early, before any messages can get to the console).

I'll bisect tomorrow if I have the time.

Thanks,
Rafael

---
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

