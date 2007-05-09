Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbXEIUd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbXEIUd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758638AbXEIUdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:33:19 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40442 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbXEIUdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:33:16 -0400
Date: Wed, 9 May 2007 16:27:21 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/6] UML - Tidy IRQ code
Message-ID: <20070509202721.GA22454@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some tidying of the irq code before introducing irq stacks.  Mostly
style fixes, but the timer handler calls the timer code directly
rather than going through the generic sig_handler_common_skas.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/init_task.c      |   11 -----------
 arch/um/kernel/irq.c            |    4 ++--
 arch/um/os-Linux/signal.c       |   10 +++++++---
 arch/um/os-Linux/skas/process.c |    6 ++++--
 4 files changed, 13 insertions(+), 18 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/init_task.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/init_task.c	2007-05-07 14:52:28.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/init_task.c	2007-05-07 14:56:24.000000000 -0400
@@ -46,14 +46,3 @@ void unprotect_stack(unsigned long stack
 {
 	os_protect_memory((void *) stack, THREAD_SIZE, 1, 1, 0);
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
Index: linux-2.6.21-mm/arch/um/kernel/irq.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/irq.c	2007-05-07 14:52:28.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/irq.c	2007-05-07 14:56:24.000000000 -0400
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  * Derived (i.e. mostly copied) from arch/i386/kernel/irq.c:
@@ -53,7 +53,7 @@ int show_interrupts(struct seq_file *p, 
 	if (i < NR_IRQS) {
 		spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
-		if (!action) 
+		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
 #ifndef CONFIG_SMP
Index: linux-2.6.21-mm/arch/um/os-Linux/signal.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/signal.c	2007-05-07 14:52:28.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/signal.c	2007-05-07 14:56:24.000000000 -0400
@@ -61,15 +61,19 @@ void sig_handler(int sig, struct sigcont
 
 static void real_alarm_handler(int sig, struct sigcontext *sc)
 {
+	union uml_pt_regs regs;
+
 	if(sig == SIGALRM)
 		switch_timers(0);
 
-	CHOOSE_MODE_PROC(sig_handler_common_tt, sig_handler_common_skas,
-			 sig, sc);
+	if(sc != NULL)
+		copy_sc(&regs, sc);
+	regs.skas.is_user = 0;
+	unblock_signals();
+	timer_handler(sig, &regs);
 
 	if(sig == SIGALRM)
 		switch_timers(1);
-
 }
 
 void alarm_handler(int sig, struct sigcontext *sc)
Index: linux-2.6.21-mm/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/skas/process.c	2007-05-07 14:52:28.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/skas/process.c	2007-05-07 14:56:24.000000000 -0400
@@ -288,7 +288,8 @@ int start_userspace(unsigned long stub_s
 void userspace(union uml_pt_regs *regs)
 {
 	int err, status, op, pid = userspace_pid[0];
-	int local_using_sysemu; /*To prevent races if using_sysemu changes under us.*/
+	/* To prevent races if using_sysemu changes under us.*/
+	int local_using_sysemu;
 
 	while(1){
 		restore_registers(pid, regs);
@@ -296,7 +297,8 @@ void userspace(union uml_pt_regs *regs)
 		/* Now we set local_using_sysemu to be used for one loop */
 		local_using_sysemu = get_using_sysemu();
 
-		op = SELECT_PTRACE_OPERATION(local_using_sysemu, singlestepping(NULL));
+		op = SELECT_PTRACE_OPERATION(local_using_sysemu,
+					     singlestepping(NULL));
 
 		err = ptrace(op, pid, 0, 0);
 		if(err)
