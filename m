Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbXLLUtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbXLLUtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbXLLUsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:48:50 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:40746 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXLLUst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:48:49 -0500
Date: Wed, 12 Dec 2007 15:48:00 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 6/6] UML - Clean up sig_handler_common_skas
Message-ID: <20071212204800.GA9144@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sig_handler_common_skas needs significant modernization, starting with
its name and storage class.

There is no need to hide the true type of the sigcontext pointer, so
the void * dummy parameter can be replaced with a sigcontext *sc.

The array of uml_pt_regs structs used in the page fault case are gone,
replaced by a local variable.  This is also used in the non-segfault
case instead of the copy in the task_struct.  Since it's local, the
special handling of the is_user flag can go away.

There hasn't been any special treatment of SIGUSR1 in ages, so the
line that enables it can be deleted.

The special treatment of SIGSEGV similarly goes away, but to
compensate, SA_NODEFER is added to sa_mask when registering a signal
handler.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/signal.c |   63 +++++++++++++---------------------------------
 1 file changed, 18 insertions(+), 45 deletions(-)

Index: linux-2.6-git/arch/um/os-Linux/signal.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/signal.c	2007-12-12 15:17:45.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/signal.c	2007-12-12 15:32:38.000000000 -0500
@@ -10,14 +10,15 @@
 #include <signal.h>
 #include <strings.h>
 #include "as-layout.h"
-#include "kern_constants.h"
 #include "kern_util.h"
 #include "os.h"
 #include "sysdep/barrier.h"
 #include "sysdep/sigcontext.h"
-#include "task.h"
 #include "user.h"
 
+/* Copied from linux/compiler-gcc.h since we can't include it directly */
+#define barrier() __asm__ __volatile__("": : :"memory")
+
 void (*sig_info[NSIG])(int, struct uml_pt_regs *) = {
 	[SIGTRAP]	= relay_signal,
 	[SIGFPE]	= relay_signal,
@@ -28,58 +29,27 @@ void (*sig_info[NSIG])(int, struct uml_p
 	[SIGIO]		= sigio_handler,
 	[SIGVTALRM]	= timer_handler };
 
-static struct uml_pt_regs ksig_regs[UM_NR_CPUS];
-
-void sig_handler_common_skas(int sig, void *sc_ptr)
+static void sig_handler_common(int sig, struct sigcontext *sc)
 {
-	struct sigcontext *sc = sc_ptr;
-	struct uml_pt_regs *r;
-	void (*handler)(int, struct uml_pt_regs *);
-	int save_user, save_errno = errno;
+	struct uml_pt_regs r;
+	int save_errno = errno;
 
-	/*
-	 * This is done because to allow SIGSEGV to be delivered inside a SEGV
-	 * handler.  This can happen in copy_user, and if SEGV is disabled,
-	 * the process will die.
-	 * XXX Figure out why this is better than SA_NODEFER
-	 */
+	r.is_user = 0;
 	if (sig == SIGSEGV) {
-		change_sig(SIGSEGV, 1);
-		/*
-		 * For segfaults, we want the data from the
-		 * sigcontext.  In this case, we don't want to mangle
-		 * the process registers, so use a static set of
-		 * registers.  For other signals, the process
-		 * registers are OK.
-		 */
-		r = &ksig_regs[cpu()];
-		copy_sc(r, sc_ptr);
-	} else
-		r = TASK_REGS(get_current());
-
-	save_user = r->is_user;
-	r->is_user = 0;
-	if ((sig == SIGFPE) || (sig == SIGSEGV) || (sig == SIGBUS) ||
-	    (sig == SIGILL) || (sig == SIGTRAP))
-		GET_FAULTINFO_FROM_SC(r->faultinfo, sc);
-
-	change_sig(SIGUSR1, 1);
-
-	handler = sig_info[sig];
+		/* For segfaults, we want the data from the sigcontext. */
+		copy_sc(&r, sc);
+		GET_FAULTINFO_FROM_SC(r.faultinfo, sc);
+	}
 
-	/* unblock SIGVTALRM, SIGIO if sig isn't IRQ signal */
+	/* enable signals if sig isn't IRQ signal */
 	if ((sig != SIGIO) && (sig != SIGWINCH) && (sig != SIGVTALRM))
 		unblock_signals();
 
-	handler(sig, r);
+	(*sig_info[sig])(sig, &r);
 
 	errno = save_errno;
-	r->is_user = save_user;
 }
 
-/* Copied from linux/compiler-gcc.h since we can't include it directly */
-#define barrier() __asm__ __volatile__("": : :"memory")
-
 /*
  * These are the asynchronous signals.  SIGPROF is excluded because we want to
  * be able to profile all of UML, not just the non-critical sections.  If
@@ -107,7 +77,7 @@ void sig_handler(int sig, struct sigcont
 
 	block_signals();
 
-	sig_handler_common_skas(sig, sc);
+	sig_handler_common(sig, sc);
 
 	set_signals(enabled);
 }
@@ -227,6 +197,9 @@ void set_handler(int sig, void (*handler
 		sigaddset(&action.sa_mask, mask);
 	va_end(ap);
 
+	if (sig == SIGSEGV)
+		flags |= SA_NODEFER;
+
 	action.sa_flags = flags;
 	action.sa_restorer = NULL;
 	if (sigaction(sig, &action, NULL) < 0)
@@ -306,7 +279,7 @@ void unblock_signals(void)
 		 * back here.
 		 */
 		if (save_pending & SIGIO_MASK)
-			sig_handler_common_skas(SIGIO, NULL);
+			sig_handler_common(SIGIO, NULL);
 
 		if (save_pending & SIGVTALRM_MASK)
 			real_alarm_handler(NULL);
