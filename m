Return-Path: <linux-kernel-owner+w=401wt.eu-S964997AbXBLQxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964997AbXBLQxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964968AbXBLQwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:52:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964999AbXBLQvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:45 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [23/29] x86: Don't require the vDSO for handling a.out signals
Message-Id: <20070212165144.0460313E1A@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


and in other strange binfmts. vDSO is not necessarily mapped there.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/signal.c      |    6 +++++-
 arch/x86_64/ia32/ia32_signal.c |    7 ++++++-
 fs/binfmt_elf.c                |    3 ++-
 include/linux/binfmts.h        |    1 +
 4 files changed, 14 insertions(+), 3 deletions(-)

Index: linux/arch/i386/kernel/signal.c
===================================================================
--- linux.orig/arch/i386/kernel/signal.c
+++ linux/arch/i386/kernel/signal.c
@@ -21,6 +21,7 @@
 #include <linux/suspend.h>
 #include <linux/ptrace.h>
 #include <linux/elf.h>
+#include <linux/binfmts.h>
 #include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
@@ -349,7 +350,10 @@ static int setup_frame(int sig, struct k
 			goto give_sigsegv;
 	}
 
-	restorer = (void *)VDSO_SYM(&__kernel_sigreturn);
+	if (current->binfmt->hasvdso)
+		restorer = (void *)VDSO_SYM(&__kernel_sigreturn);
+	else
+		restorer = (void *)&frame->retcode;
 	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = ka->sa.sa_restorer;
 
Index: linux/arch/x86_64/ia32/ia32_signal.c
===================================================================
--- linux.orig/arch/x86_64/ia32/ia32_signal.c
+++ linux/arch/x86_64/ia32/ia32_signal.c
@@ -21,6 +21,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/compat.h>
+#include <linux/binfmts.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
@@ -449,7 +450,11 @@ int ia32_setup_frame(int sig, struct k_s
 
 	/* Return stub is in 32bit vsyscall page */
 	{ 
-		void __user *restorer = VSYSCALL32_SIGRETURN; 
+		void __user *restorer;
+		if (current->binfmt->hasvdso)
+			restorer = VSYSCALL32_SIGRETURN;
+		else
+			restorer = (void *)&frame->retcode;
 		if (ka->sa.sa_flags & SA_RESTORER)
 			restorer = ka->sa.sa_restorer;       
 		err |= __put_user(ptr_to_compat(restorer), &frame->pretcode);
Index: linux/fs/binfmt_elf.c
===================================================================
--- linux.orig/fs/binfmt_elf.c
+++ linux/fs/binfmt_elf.c
@@ -76,7 +76,8 @@ static struct linux_binfmt elf_format = 
 		.load_binary	= load_elf_binary,
 		.load_shlib	= load_elf_library,
 		.core_dump	= elf_core_dump,
-		.min_coredump	= ELF_EXEC_PAGESIZE
+		.min_coredump	= ELF_EXEC_PAGESIZE,
+		.hasvdso	= 1
 };
 
 #define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
Index: linux/include/linux/binfmts.h
===================================================================
--- linux.orig/include/linux/binfmts.h
+++ linux/include/linux/binfmts.h
@@ -59,6 +59,7 @@ struct linux_binfmt {
 	int (*load_shlib)(struct file *);
 	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file);
 	unsigned long min_coredump;	/* minimal dump size */
+	int hasvdso;
 };
 
 extern int register_binfmt(struct linux_binfmt *);
