Return-Path: <linux-kernel-owner+w=401wt.eu-S964803AbXBYLrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964803AbXBYLrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 06:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964807AbXBYLrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 06:47:31 -0500
Received: from aun.it.uu.se ([130.238.12.36]:36942 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964803AbXBYLrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 06:47:31 -0500
Date: Sun, 25 Feb 2007 12:47:09 +0100 (MET)
Message-Id: <200702251147.l1PBl9ab003231@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: torvalds@linux-foundation.org
Subject: [PATCH 2.6.21-rc1] x86 signal number delivery fixes
Cc: ak@suse.de, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The invokation of signal handlers on x86 has several bugs
in its treatment of the signal number parameter:

- the i386 kernel passes the raw not the translated signal number
  in EAX to non-SA_SIGINFO handlers compiled with -mregparm=3;
  the value passed on the stack is correct, and SA_SIGINFO handlers
  are also invoked correctly
- the x86-64 kernel's ia32 emulation for SA_SIGINFO handlers also
  passes the wrong (untranslated) signal number in EAX; the value
  on the stack is correct
- the x86-64 kernel's ia32 emulation for non-SA_SIGINFO handlers
  passes the wrong (untranslated) signal number both on the stack
  and in EAX

Also, the x86-64 kernel's ia32_setup_rt_frame() has duplicated code
for setting up -mregparm=3 parameters: it looks like the same patch
hunk was merged twice at some point.

Fixed by the following patch.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

---

The fix in ia32_setup_frame() is ugly, but follows the coding style
of ia32_setup_rt_frame().

 arch/i386/kernel/signal.c      |    2 +-
 arch/x86_64/ia32/ia32_signal.c |   31 +++++++++++++++++--------------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff -rupN linux-2.6.21-rc1/arch/i386/kernel/signal.c linux-2.6.21-rc1.x86-signals-usig-fixes/arch/i386/kernel/signal.c
--- linux-2.6.21-rc1/arch/i386/kernel/signal.c	2007-02-24 22:32:42.000000000 +0100
+++ linux-2.6.21-rc1.x86-signals-usig-fixes/arch/i386/kernel/signal.c	2007-02-25 11:09:24.000000000 +0100
@@ -377,7 +377,7 @@ static int setup_frame(int sig, struct k
 	/* Set up registers for signal handler */
 	regs->esp = (unsigned long) frame;
 	regs->eip = (unsigned long) ka->sa.sa_handler;
-	regs->eax = (unsigned long) sig;
+	regs->eax = (unsigned long) usig;
 	regs->edx = (unsigned long) 0;
 	regs->ecx = (unsigned long) 0;
 
diff -rupN linux-2.6.21-rc1/arch/x86_64/ia32/ia32_signal.c linux-2.6.21-rc1.x86-signals-usig-fixes/arch/x86_64/ia32/ia32_signal.c
--- linux-2.6.21-rc1/arch/x86_64/ia32/ia32_signal.c	2007-02-24 22:32:42.000000000 +0100
+++ linux-2.6.21-rc1.x86-signals-usig-fixes/arch/x86_64/ia32/ia32_signal.c	2007-02-25 11:09:24.000000000 +0100
@@ -426,13 +426,21 @@ int ia32_setup_frame(int sig, struct k_s
 {
 	struct sigframe __user *frame;
 	int err = 0;
+	int usig;
 
 	frame = get_sigframe(ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
 
-	err |= __put_user(sig, &frame->sig);
+	{
+		struct exec_domain *ed = current_thread_info()->exec_domain;
+		if (ed && ed->signal_invmap && sig < 32)
+			usig = ed->signal_invmap[sig];
+		else
+			usig = sig;
+		err |= __put_user(usig, &frame->sig);
+	}
 	if (err)
 		goto give_sigsegv;
 
@@ -484,7 +492,7 @@ int ia32_setup_frame(int sig, struct k_s
 	regs->rip = (unsigned long) ka->sa.sa_handler;
 
 	/* Make -mregparm=3 work */
-	regs->rax = sig;
+	regs->rax = usig;
 	regs->rdx = 0;
 	regs->rcx = 0;
 
@@ -516,6 +524,7 @@ int ia32_setup_rt_frame(int sig, struct 
 {
 	struct rt_sigframe __user *frame;
 	int err = 0;
+	int usig;
 
 	frame = get_sigframe(ka, regs, sizeof(*frame));
 
@@ -524,12 +533,11 @@ int ia32_setup_rt_frame(int sig, struct 
 
 	{
 		struct exec_domain *ed = current_thread_info()->exec_domain;
-		err |= __put_user((ed
-		    	   && ed->signal_invmap
-		    	   && sig < 32
-		    	   ? ed->signal_invmap[sig]
-			   : sig),
-			  &frame->sig);
+		if (ed && ed->signal_invmap && sig < 32)
+			usig = ed->signal_invmap[sig];
+		else
+			usig = sig;
+		err |= __put_user(usig, &frame->sig);
 	}
 	err |= __put_user(ptr_to_compat(&frame->info), &frame->pinfo);
 	err |= __put_user(ptr_to_compat(&frame->uc), &frame->puc);
@@ -585,12 +593,7 @@ int ia32_setup_rt_frame(int sig, struct 
 	regs->rip = (unsigned long) ka->sa.sa_handler;
 
 	/* Make -mregparm=3 work */
-	regs->rax = sig;
-	regs->rdx = (unsigned long) &frame->info;
-	regs->rcx = (unsigned long) &frame->uc;
-
-	/* Make -mregparm=3 work */
-	regs->rax = sig;
+	regs->rax = usig;
 	regs->rdx = (unsigned long) &frame->info;
 	regs->rcx = (unsigned long) &frame->uc;
 
