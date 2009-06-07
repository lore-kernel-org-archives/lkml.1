Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbZFGNBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbZFGNBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbZFGMzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:55:54 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56654 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756337AbZFGMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:55:52 -0400
X-Greylist: delayed 793 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Jun 2009 08:55:51 EDT
X-Sasl-enc: TBkNGiUrg6tsKWZ/fpqIUFP2/4wlcL+h1N2+X4t+U29c 1244378561
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] i386: fix return to 16-bit stack from NMI handler
Date: Sun,  7 Jun 2009 14:42:35 +0200
Message-Id: <1244378557-5455-2-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1244378557-5455-1-git-send-email-heukelum@fastmail.fm>
References: <1244378557-5455-1-git-send-email-heukelum@fastmail.fm>
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

The bug was introduced with 55f327fa9e876758491a82af7491104f1cc3fc4d
("lockdep: irqtrace subsystem, i386 support").

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>

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
1.6.0.4

