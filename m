Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbXKSWJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbXKSWJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbXKSWG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:06:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730AbXKSWGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:06:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 13/18] x86 vDSO: ia32 sysenter_return
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
Emacs: because idle RAM is the Devil's playground.
Message-Id: <20071119220622.C5ED026F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:06:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This changes the 64-bit kernel's support for the 32-bit sysenter
instruction to use stored fields rather than constants for the
user-mode return address, as the 32-bit kernel does.  This adds a
sysenter_return field to struct thread_info, as 32-bit has.  There
is no observable effect from this yet.  It makes the assembly code
independent of the 32-bit vDSO mapping address, paving the way for
making the vDSO address vary as it does on the 32-bit kernel.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ia32entry.S        |    7 +++----
 arch/x86/ia32/syscall32.c        |    4 ++++
 arch/x86/kernel/asm-offsets_64.c |    1 +
 include/asm-x86/thread_info_64.h |    3 +++
 4 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index df588f0..2499a32 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -12,7 +12,6 @@
 #include <asm/ia32_unistd.h>	
 #include <asm/thread_info.h>	
 #include <asm/segment.h>
-#include <asm/vsyscall32.h>
 #include <asm/irqflags.h>
 #include <linux/linkage.h>
 
@@ -104,7 +103,7 @@ ENTRY(ia32_sysenter_target)
 	pushfq
 	CFI_ADJUST_CFA_OFFSET 8
 	/*CFI_REL_OFFSET rflags,0*/
-	movl	$VSYSCALL32_SYSEXIT, %r10d
+	movl	8*3-THREAD_SIZE+threadinfo_sysenter_return(%rsp), %r10d
 	CFI_REGISTER rip,r10
 	pushq	$__USER32_CS
 	CFI_ADJUST_CFA_OFFSET 8
@@ -142,6 +141,8 @@ sysenter_do_call:
 	andl    $~TS_COMPAT,threadinfo_status(%r10)
 	/* clear IF, that popfq doesn't enable interrupts early */
 	andl  $~0x200,EFLAGS-R11(%rsp) 
+	movl	RIP-R11(%rsp),%edx		/* User %eip */
+	CFI_REGISTER rip,rdx
 	RESTORE_ARGS 1,24,1,1,1,1
 	popfq
 	CFI_ADJUST_CFA_OFFSET -8
@@ -149,8 +150,6 @@ sysenter_do_call:
 	popq	%rcx				/* User %esp */
 	CFI_ADJUST_CFA_OFFSET -8
 	CFI_REGISTER rsp,rcx
-	movl	$VSYSCALL32_SYSEXIT,%edx	/* User %eip */
-	CFI_REGISTER rip,rdx
 	TRACE_IRQS_ON
 	swapgs
 	sti		/* sti only takes effect after the next instruction */
diff --git a/arch/x86/ia32/syscall32.c b/arch/x86/ia32/syscall32.c
index 15013ba..2c9c145 100644
--- a/arch/x86/ia32/syscall32.c
+++ b/arch/x86/ia32/syscall32.c
@@ -45,6 +45,10 @@ int syscall32_setup_pages(struct linux_binprm *bprm, int exstack)
 				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
 				      VM_ALWAYSDUMP,
 				      syscall32_pages);
+	if (ret == 0) {
+		current->mm->context.vdso = (void __user *)VSYSCALL32_BASE;
+		current_thread_info()->sysenter_return = VSYSCALL32_SYSEXIT;
+	}
 	up_write(&mm->mmap_sem);
 	return ret;
 }
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index d1b6ed9..1f9b0b5 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -47,6 +47,7 @@ int main(void)
 	ENTRY(addr_limit);
 	ENTRY(preempt_count);
 	ENTRY(status);
+	ENTRY(sysenter_return);
 	BLANK();
 #undef ENTRY
 #define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))
diff --git a/include/asm-x86/thread_info_64.h b/include/asm-x86/thread_info_64.h
index beae2bf..f81638e 100644
--- a/include/asm-x86/thread_info_64.h
+++ b/include/asm-x86/thread_info_64.h
@@ -33,6 +33,9 @@ struct thread_info {
 
 	mm_segment_t		addr_limit;	
 	struct restart_block    restart_block;
+#ifdef CONFIG_IA32_EMULATION
+	void __user		*sysenter_return;
+#endif
 };
 #endif
 
