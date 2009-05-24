Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbZEXSYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbZEXSYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 14:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZEXSYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 14:24:12 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43447 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393AbZEXSYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 14:24:11 -0400
X-Sasl-enc: NBc9+78/ibsngks8bNIlyocC093qBPpR73rslpk4UPJx 1243189451
Date: Sun, 24 May 2009 20:24:09 +0200 (CEST)
From: Alexander van Heukelum <alexander@mail.messagingengine.com>
X-X-Sender: alexander@diotoir
To: Ingo Molnar <mingo@elte.hu>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       The stable team <stable@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: i386: fix return to 16-bit stack from NMI handler
Message-ID: <alpine.DEB.2.00.0905242021460.3810@diotoir>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nmi handler changes esp on return from the kernel to a process
with a 16-bit stack. To reproduce, compile and run the following
program with the nmi watchdog enabled (nmi_watchdog=2 on the command
line). Using gdb you can see that the high bits of esp contain garbage,
while the low bits are still correct. This is what the 'espfix' code is
supposed to fix, but the nmi handler does not include it.

The nmi code cannot call the irqtrace infrastructure. Otherwise, the tail
of the normal iret-code is correct for the nmi code path too. To be
able to share this code-path, I moved the TRACE_IRQS_IRET a bit earlier.
This code-path now includes the espfix code, which explicitly disables
interrupts. This short interrupts-off section is now not traced anymore.
The preempt-return-to-kernel path now includes the preliminary test to
decide if the espfix code should be called. This is never the case, but
doing it this way keeps the patch simple and the few extra instructions
should not affect timing in any significant way.

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

The bug is present in 2.6.28, and probably even much earlier.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: The stable team <stable@kernel.org>

---

Hi Ingo, Peter, Cyrill, ...

Mucking with entry_32.S and trying to exercise all code paths, I found
the problem described above. Please check this patch carefully for side
effects I may have overlooked!

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
