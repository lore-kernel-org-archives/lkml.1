Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbYGQHru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbYGQHru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYGQHrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:47:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbYGQHrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:47:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 1/6] x86: tracehook_signal_handler
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:45:50 -0700 <20080717074550.EE1E215411D@magilla.localdomain>
References: <20080717074550.EE1E215411D@magilla.localdomain>
X-Zippy-Says: UH-OH!!  I put on ``GREAT HEAD-ON TRAIN COLLISIONS of the 50's'' by
    mistake!!!
Message-Id: <20080717074738.5A9FA15411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:47:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the x86 signal handling code use tracehook_signal_handler() in
place of calling into ptrace guts.  The call is moved after the sa_mask
processing, but there is no other change.  This cleanup doesn't matter to
existing debuggers, but is the sensible thing: have all facets of the
handler setup complete before the debugger inspects the task again.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/signal_32.c |    6 ++++--
 arch/x86/kernel/signal_64.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 295b5f5..3ffb88f 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
+#include <linux/tracehook.h>
 #include <linux/elf.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
@@ -558,8 +559,6 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	 * handler too.
 	 */
 	regs->flags &= ~X86_EFLAGS_TF;
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
 
 	spin_lock_irq(&current->sighand->siglock);
 	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
@@ -568,6 +567,9 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
+	tracehook_signal_handler(sig, info, ka, regs,
+				 test_thread_flag(TIF_SINGLESTEP));
+
 	return 0;
 }
 
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index bf87684..5d6c237 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/wait.h>
 #include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
 #include <linux/personality.h>
@@ -391,8 +392,6 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 		 * handler too.
 		 */
 		regs->flags &= ~X86_EFLAGS_TF;
-		if (test_thread_flag(TIF_SINGLESTEP))
-			ptrace_notify(SIGTRAP);
 
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
@@ -400,6 +399,9 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 			sigaddset(&current->blocked,sig);
 		recalc_sigpending();
 		spin_unlock_irq(&current->sighand->siglock);
+
+		tracehook_signal_handler(sig, info, ka, regs,
+					 test_thread_flag(TIF_SINGLESTEP));
 	}
 
 	return ret;
