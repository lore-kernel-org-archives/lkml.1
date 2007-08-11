Return-Path: <linux-kernel-owner+w=401wt.eu-S1764380AbXHKTFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764380AbXHKTFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760375AbXHKS6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:38 -0400
Received: from 1wt.eu ([62.212.114.60]:1579 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762436AbXHKS63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:29 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184855.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:18 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chuck Ebbert <cebbert@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 26/28] i386: fix infinite loop with singlestep int80 syscalls
Content-Disposition: inline; filename=0026-i386-fix-infinite-loop-with-singlestep-int80-syscal.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
	char str[80] = "child: int80 test
";

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
			fprintf(stderr, "child stop @ %08lx, expected %08lx %s
",
					eip, expected,
					eip == expected ? "" : " <== ERROR");

		if (*(unsigned short *)eip == 0x80cd) {
			fprintf(stderr, "int 0x80 at %08x
", (unsigned int)eip);
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
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/i386/kernel/entry.S |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/i386/kernel/entry.S b/arch/i386/kernel/entry.S
index 5e47683..9bf056e 100644
--- a/arch/i386/kernel/entry.S
+++ b/arch/i386/kernel/entry.S
@@ -367,10 +367,6 @@ ENTRY(system_call)
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
@@ -385,6 +381,10 @@ syscall_exit:
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
-- 
1.5.2.4

-- 
