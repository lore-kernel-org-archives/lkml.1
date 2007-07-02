Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbXGBUyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbXGBUyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 16:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbXGBUx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 16:53:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:53600 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbXGBUx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 16:53:58 -0400
Message-ID: <468965D8.7020405@windriver.com>
Date: Mon, 02 Jul 2007 15:53:44 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: [PATCH] i386 - Fix regression, endless loop in ptrace singlestep
 over an int80
Content-Type: multipart/mixed;
 boundary="------------000906030103080504050907"
X-OriginalArrivalTime: 02 Jul 2007 20:53:46.0576 (UTC) FILETIME=[15670D00:01C7BCEB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000906030103080504050907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Attached is a patch with a complete test case to fix the regression 
introduced by the commit: 635cf99a80f4ebee59d70eb64bb85ce829e4591f.

This patch is against kernel 2.6.21 but the fix is applicable to 2.6.21 
and up.  Prior to the commit that introduced the regression the ltp 
ptrace tests would complete correctly.  I augmented the test case from 
the original patch header to include the problem case that shows up in 
the lpt tests.

The brief summary is that the the TIF_SINGLESTEP state needs to be 
altered on the exit path and not the entry path to a syscall, else it 
can loop forever on the same instruction right after the syscall is 
executed in certain cases.

Thanks,
Jason.

--------------000906030103080504050907
Content-Type: text/plain;
 name="ptrace_int80_loop_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ptrace_int80_loop_fix.patch"

ptrace_int80_loop_fix.patch

[PATCH] i386: fix infinite loop with singlestep int80 syscalls

The commit 635cf99a80f4ebee59d70eb64bb85ce829e4591f introduced a
regression.  Executing a ptrace single step after certain int80
accesses will infinitely loop and never advance the PC.

The TIF_SINGLESTEP check should be done on the return from the syscall
and not before it.

The new test case is below:

/* Test whether singlestep through an int80 syscall works.
 */
#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <asm/user.h>
#include <string.h>

static int child, status;
static struct user_regs_struct regs;

static void do_child()
{
	char str[80] = "child: int80 test\n";

	ptrace(PTRACE_TRACEME, 0, 0, 0);
	kill(getpid(), SIGUSR1);
	write(fileno(stdout),str,strlen(str));
	asm ("int $0x80" : : "a" (20)); /* getpid */
}
    
static void do_parent()
{
	unsigned long eip, expected = 0;
again:
	waitpid(child, &status, 0);
	if (WIFEXITED(status) || WIFSIGNALED(status))
		return;
    
	if (WIFSTOPPED(status)) {
		ptrace(PTRACE_GETREGS, child, 0, &regs);
		eip = regs.eip;
		if (expected)
			fprintf(stderr, "child stop @ %08lx, expected %08lx %s\n",
					eip, expected,
					eip == expected ? "" : " <== ERROR");
    
		if (*(unsigned short *)eip == 0x80cd) {
			fprintf(stderr, "int 0x80 at %08x\n", (unsigned int)eip);
			expected = eip + 2;
		} else
			expected = 0;
    
		ptrace(PTRACE_SINGLESTEP, child, NULL, NULL);
	}
	goto again;
}
    
int main(int argc, char * const argv[])
{
	child = fork();
	if (child)
		do_parent();
	else
		do_child();
	return 0;
}


Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/i386/kernel/entry.S |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.21-standard/arch/i386/kernel/entry.S
===================================================================
--- linux-2.6.21-standard.orig/arch/i386/kernel/entry.S
+++ linux-2.6.21-standard/arch/i386/kernel/entry.S
@@ -371,10 +371,6 @@ ENTRY(system_call)
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
-	testl $TF_MASK,PT_EFLAGS(%esp)
-	jz no_singlestep
-	orl $_TIF_SINGLESTEP,TI_flags(%ebp)
-no_singlestep:
 					# system call tracing in operation / emulation
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
 	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
@@ -389,6 +385,10 @@ syscall_exit:
 					# setting need_resched or sigpending
 					# between sampling and the iret
 	TRACE_IRQS_OFF
+	testl $TF_MASK,PT_EFLAGS(%esp)	# If tracing set singlestep flag on exit
+	jz no_singlestep
+	orl $_TIF_SINGLESTEP,TI_flags(%ebp)
+no_singlestep:
 	movl TI_flags(%ebp), %ecx
 	testw $_TIF_ALLWORK_MASK, %cx	# current->work
 	jne syscall_exit_work

--------------000906030103080504050907--
