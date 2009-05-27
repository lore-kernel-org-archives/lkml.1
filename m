Return-Path: <linux-kernel-owner+w=401wt.eu-S1763845AbZE0NG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763845AbZE0NG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 09:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762670AbZE0NGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 09:06:18 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33076 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760244AbZE0NGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 09:06:17 -0400
X-Sasl-enc: r0rJxEQmyPIKjs02BfwSCEOvc3d43GiBns/HZZn7h6Yn 1243429577
Date: Wed, 27 May 2009 15:06:14 +0200 (CEST)
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, The stable team <stable@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH,resend] i386: fix return to 16-bit stack from NMI handler
Message-ID: <alpine.DEB.2.00.0905271459580.15211@diotoir>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 55f327fa9e876758491a82af7491104f1cc3fc4d changed the return path
of the NMI handler to skip the check and fixup for return to environments
with a 16-bit stack segment. If a task is running with such a 16-bit SS,
and an NMI intervenes, the top half of the task's esp is replaced with
the top half of the kernel's esp. To reproduce, run the included program
with the nmi watchdog enabled. This patch fixes it.

The patch is slightly more involved than changing the jump target at the
end of 'nmi_stack_correct' from 'restore_nocheck_notrace' back to
'restore_all', because the latter includes TRACE_IRQS_IRET, which
cannot be used in handling the NMI. Therefore, to keep things simple,
I moved the TRACE_IRQS_IRET to just after 'restore_all' and introduced
'restore_all_notrace' just below it.

Side effect of moving TRACE_IRQS_IRET is that the espfix code is now
executed after this macro, while it disables interrupts explicitly
in case the stack switch is needed. I removed the TRACE_IRQS_OFF there
to fix the tracing.

In !PREEMPT, 'check_userspace' is changed to jump to restore_all
instead of restore_nocheck in case the return is back to kernelspace,
such that the TRACE_IRQS_IRET is again included in the return path.
This code path does now include the espfix check too. Including the few
extra instructions keeps the patch simple and should not affect timing
in any significant way.


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
#define SEGLIMIT 0xffff

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
  		"push $61440\n\t" /* esp */
  		"lss (%esp), %esp\n\t" /* switch to new stack */
  		"push %eax\n\t" /* save old ss:esp on new stack */
  		"push %ebp\n\t"

  		"mov %esp, %edx\n\t"

  		/* wait a bit */
  		"mov $10000000, %ecx\n\t"
  		"1: loop 1b\n\t"

  		"cmp %esp, %edx\n\t"
  		"je 1f\n\t"
  		"ud2\n\t" /* esp changed inexplicably! */
  		"1:\n\t"
  		"lss (%esp), %esp\n\t" /* restore old ss:esp */
  		"popa\n\t");

  		printf("\rx%ix", i);
  	}

  	return 0;
}

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: The stable team <stable@kernel.org>

---

Hi Ingo,

Mucking with entry_32.S and trying to exercise all entry/exit code
paths, I found the problem described above. I sent this fix before,
but you may have missed it due to a mangled From-address in the last
attempt.

Greetings,
 	Alexander

   arch/x86/kernel/entry_32.S |   14 ++++++++------
   1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c929add..4a362f5 100644
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
