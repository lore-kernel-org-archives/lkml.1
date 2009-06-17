Return-Path: <linux-kernel-owner+w=401wt.eu-S1762055AbZFQWgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762055AbZFQWgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 18:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761918AbZFQWgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 18:36:21 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41178 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761685AbZFQWgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 18:36:19 -0400
X-Sasl-enc: 9ExmyoKs+vw6aTmkEITUokt3XOpFA3JItDAAHEKUOPby 1245278180
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Stas Sergeev <stsp@aknet.ru>, Tejun Heo <tj@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 1/3] i386: fix return to 16-bit stack from NMI handler
Date: Thu, 18 Jun 2009 00:35:57 +0200
Message-Id: <1245278159-6840-2-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1245278159-6840-1-git-send-email-heukelum@fastmail.fm>
References: <1245278159-6840-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Returning to a task with a 16-bit stack requires special care: the iret
instruction does not restore the high word of esp in that case. The
espfix code fixes this, but currently is not invoked on NMIs. This means
that a running task gets the upper word of esp clobbered due intervening
NMIs. To reproduce, compile and run the following program with the nmi
watchdog enabled (nmi_watchdog=2 on the command line). Using gdb you can
see that the high bits of esp contain garbage, while the low bits are
still correct.

This patch puts the espfix code back into the NMI code path.

The patch is slightly complicated due to the irqtrace infrastructure not
being NMI-safe. The NMI return path cannot call TRACE_IRQS_IRET.
Otherwise, the tail of the normal iret-code is correct for the nmi code
path too. To be able to share this code-path, the TRACE_IRQS_IRET was
move up a bit. The espfix code exists after the TRACE_IRQS_IRET, but
this code explicitly disables interrupts. This short interrupts-off
section is now not traced anymore. The return-to-kernel path now always
includes the preliminary test to decide if the espfix code should be
called. This is never the case, but doing it this way keeps the patch as
simple as possible and the few extra instructions should not affect
timing in any significant way.

 #define _GNU_SOURCE
 #include <stdio.h>
 #include <sys/types.h>
 #include <sys/mman.h>
 #include <unistd.h>
 #include <sys/syscall.h>
 #include <asm/ldt.h>

int modify_ldt(int func, void *ptr, unsigned long bytecount)
{
        return syscall(SYS_modify_ldt, func, ptr, bytecount);
}

/* this is assumed to be usable */
 #define SEGBASEADDR 0x10000
 #define SEGLIMIT 0x20000

/* 16-bit segment */
struct user_desc desc = {
        .entry_number = 0,
        .base_addr = SEGBASEADDR,
        .limit = SEGLIMIT,
        .seg_32bit = 0,
        .contents = 0, /* ??? */
        .read_exec_only = 0,
        .limit_in_pages = 0,
        .seg_not_present = 0,
        .useable = 1
};

int main(void)
{
        setvbuf(stdout, NULL, _IONBF, 0);

        /* map a 64 kb segment */
        char *pointer = mmap((void *)SEGBASEADDR, SEGLIMIT+1,
                        PROT_EXEC|PROT_READ|PROT_WRITE,
                        MAP_SHARED|MAP_ANONYMOUS, -1, 0);
        if (pointer == NULL) {
                printf("could not map space\n");
                return 0;
        }

        /* write ldt, new mode */
        int err = modify_ldt(0x11, &desc, sizeof(desc));
        if (err) {
                printf("error modifying ldt: %i\n", err);
                return 0;
        }

        for (int i=0; i<1000; i++) {
        asm volatile (
                "pusha\n\t"
                "mov %ss, %eax\n\t" /* preserve ss:esp */
                "mov %esp, %ebp\n\t"
                "push $7\n\t" /* index 0, ldt, user mode */
                "push $65536-4096\n\t" /* esp */
                "lss (%esp), %esp\n\t" /* switch to new stack */
                "push %eax\n\t" /* save old ss:esp on new stack */
                "push %ebp\n\t"
                "add $17*65536, %esp\n\t" /* set high bits */
                "mov %esp, %edx\n\t"

                "mov $10000000, %ecx\n\t" /* wait... */
                "1: loop 1b\n\t" /* ... a bit */

                "cmp %esp, %edx\n\t"
                "je 1f\n\t"
                "ud2\n\t" /* esp changed inexplicably! */
                "1:\n\t"
                "sub $17*65536, %esp\n\t" /* restore high bits */
                "lss (%esp), %esp\n\t" /* restore old ss:esp */
                "popa\n\t");

                printf("\rx%ix", i);
        }

        return 0;
}

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Acked-by: Stas Sergeev <stsp@aknet.ru>

---
 arch/x86/kernel/entry_32.S |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c929add..d7d1c7d 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -84,7 +84,7 @@
 #define preempt_stop(clobbers)	DISABLE_INTERRUPTS(clobbers); TRACE_IRQS_OFF
 #else
 #define preempt_stop(clobbers)
-#define resume_kernel		restore_nocheck
+#define resume_kernel		restore_all
 #endif
 
 .macro TRACE_IRQS_IRET
@@ -372,7 +372,7 @@ END(ret_from_exception)
 ENTRY(resume_kernel)
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	cmpl $0,TI_preempt_count(%ebp)	# non-zero preempt_count ?
-	jnz restore_nocheck
+	jnz restore_all
 need_resched:
 	movl TI_flags(%ebp), %ecx	# need_resched set ?
 	testb $_TIF_NEED_RESCHED, %cl
@@ -540,6 +540,8 @@ syscall_exit:
 	jne syscall_exit_work
 
 restore_all:
+	TRACE_IRQS_IRET
+restore_all_notrace:
 	movl PT_EFLAGS(%esp), %eax	# mix EFLAGS, SS and CS
 	# Warning: PT_OLDSS(%esp) contains the wrong/random values if we
 	# are returning to the kernel.
@@ -551,8 +553,6 @@ restore_all:
 	CFI_REMEMBER_STATE
 	je ldt_ss			# returning to user-space with LDT SS
 restore_nocheck:
-	TRACE_IRQS_IRET
-restore_nocheck_notrace:
 	RESTORE_REGS 4			# skip orig_eax/error_code
 	CFI_ADJUST_CFA_OFFSET -4
 irq_return:
@@ -601,8 +601,10 @@ ldt_ss:
 	CFI_ADJUST_CFA_OFFSET 4
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
+	/* Disable interrupts, but do not irqtrace this section: we
+	 * will soon execute iret and the tracer was already set to
+	 * the irqstate after the iret */
 	DISABLE_INTERRUPTS(CLBR_EAX)
-	TRACE_IRQS_OFF
 	lss (%esp), %esp
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp restore_nocheck
@@ -1329,7 +1331,7 @@ nmi_stack_correct:
 	xorl %edx,%edx		# zero error code
 	movl %esp,%eax		# pt_regs pointer
 	call do_nmi
-	jmp restore_nocheck_notrace
+	jmp restore_all_notrace
 	CFI_ENDPROC
 
 nmi_stack_fixup:
-- 
1.5.4.3

