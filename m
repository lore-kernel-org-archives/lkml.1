Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYGJVvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYGJVvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYGJVvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:51:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbYGJVvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:51:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: fix delayed signals
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Quizzical hair apparitions
   (2) Blasphemous weary distinguishers
   (3) Conscientious perspicacious malnutrition
Message-Id: <20080710215039.2A143154218@magilla.localdomain>
Date: Thu, 10 Jul 2008 14:50:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On three of the several paths in entry_64.S that call
do_notify_resume() on the way back to user mode, we fail to properly
check again for newly-arrived work that requires another call to
do_notify_resume() before going to user mode.  These paths set the
mask to check only _TIF_NEED_RESCHED, but this is wrong.  The other
paths that lead to do_notify_resume() do this correctly already, and
entry_32.S does it correctly in all cases.

All paths back to user mode have to check all the _TIF_WORK_MASK
flags at the last possible stage, with interrupts disabled.
Otherwise, we miss any flags (TIF_SIGPENDING for example) that were
set any time after we entered do_notify_resume().  More work flags
can be set (or left set) synchronously inside do_notify_resume(), as
TIF_SIGPENDING can be, or asynchronously by interrupts or other CPUs
(which then send an asynchronous interrupt).

There are many different scenarios that could hit this bug, most of
them races.  The simplest one to demonstrate does not require any
race: when one signal has done handler setup at the check before
returning from a syscall, and there is another signal pending that
should be handled.  The second signal's handler should interrupt the
first signal handler before it actually starts (so the interrupted PC
is still at the handler's entry point).  Instead, it runs away until
the next kernel entry (next syscall, tick, etc).

This test behaves correctly on 32-bit kernels, and fails on 64-bit
(either 32-bit or 64-bit test binary).  With this fix, it works.

    #define _GNU_SOURCE
    #include <stdio.h>
    #include <signal.h>
    #include <string.h>
    #include <sys/ucontext.h>

    #ifndef REG_RIP
    #define REG_RIP REG_EIP
    #endif

    static sig_atomic_t hit1, hit2;

    static void
    handler (int sig, siginfo_t *info, void *ctx)
    {
      ucontext_t *uc = ctx;

      if ((void *) uc->uc_mcontext.gregs[REG_RIP] == &handler)
        {
          if (sig == SIGUSR1)
            hit1 = 1;
          else
            hit2 = 1;
        }

      printf ("%s at %#lx\n", strsignal (sig),
              uc->uc_mcontext.gregs[REG_RIP]);
    }

    int
    main (void)
    {
      struct sigaction sa;
      sigset_t set;

      sigemptyset (&sa.sa_mask);
      sa.sa_flags = SA_SIGINFO;
      sa.sa_sigaction = &handler;

      if (sigaction (SIGUSR1, &sa, NULL)
          || sigaction (SIGUSR2, &sa, NULL))
        return 2;

      sigemptyset (&set);
      sigaddset (&set, SIGUSR1);
      sigaddset (&set, SIGUSR2);
      if (sigprocmask (SIG_BLOCK, &set, NULL))
        return 3;

      printf ("main at %p, handler at %p\n", &main, &handler);

      raise (SIGUSR1);
      raise (SIGUSR2);

      if (sigprocmask (SIG_UNBLOCK, &set, NULL))
        return 4;

      if (hit1 + hit2 == 1)
        {
          puts ("PASS");
          return 0;
        }

      puts ("FAIL");
      return 1;
    }

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/entry_64.S |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 556a8df..968cf54 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -305,7 +305,7 @@ sysret_signal:
 	leaq -ARGOFFSET(%rsp),%rdi # &pt_regs -> arg1
 	xorl %esi,%esi # oldset -> arg2
 	call ptregscall_common
-1:	movl $_TIF_NEED_RESCHED,%edi
+1:	movl $_TIF_WORK_MASK,%edi
 	/* Use IRET because user could have changed frame. This
 	   works because ptregscall_common has called FIXUP_TOP_OF_STACK. */
 	DISABLE_INTERRUPTS(CLBR_NONE)
@@ -393,7 +393,7 @@ int_signal:
 	movq %rsp,%rdi		# &ptregs -> arg1
 	xorl %esi,%esi		# oldset -> arg2
 	call do_notify_resume
-1:	movl $_TIF_NEED_RESCHED,%edi	
+1:	movl $_TIF_WORK_MASK,%edi
 int_restore_rest:
 	RESTORE_REST
 	DISABLE_INTERRUPTS(CLBR_NONE)
@@ -647,9 +647,8 @@ retint_signal:
 	RESTORE_REST
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	movl $_TIF_NEED_RESCHED,%edi
 	GET_THREAD_INFO(%rcx)
-	jmp retint_check
+	jmp retint_with_reschedule
 
 #ifdef CONFIG_PREEMPT
 	/* Returning to kernel space. Check if we need preemption */
