Return-Path: <linux-kernel-owner+w=401wt.eu-S1422801AbXCGRoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422801AbXCGRoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422813AbXCGRPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:15:33 -0500
Received: from ns2.suse.de ([195.135.220.15]:43221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422811AbXCGRPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:12 -0500
Message-Id: <20070307171334.883635879@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andi Kleen <ak@suse.de>
Subject: [patch 042/101] x86: Dont require the vDSO for handling a.out signals
Content-Disposition: inline; filename=x86-don-t-require-the-vdso-for-handling-a.out-signals.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@suse.de>

x86: Don't require the vDSO for handling a.out signals

and in other strange binfmts. vDSO is not necessarily mapped there.

This fixes signals in a.out programs

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/kernel/signal.c      |    6 +++++-
 arch/x86_64/ia32/ia32_signal.c |    7 ++++++-
 fs/binfmt_elf.c                |    3 ++-
 include/linux/binfmts.h        |    1 +
 4 files changed, 14 insertions(+), 3 deletions(-)

--- linux-2.6.20.1.orig/arch/i386/kernel/signal.c
+++ linux-2.6.20.1/arch/i386/kernel/signal.c
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
 
--- linux-2.6.20.1.orig/arch/x86_64/ia32/ia32_signal.c
+++ linux-2.6.20.1/arch/x86_64/ia32/ia32_signal.c
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
--- linux-2.6.20.1.orig/fs/binfmt_elf.c
+++ linux-2.6.20.1/fs/binfmt_elf.c
@@ -76,7 +76,8 @@ static struct linux_binfmt elf_format = 
 		.load_binary	= load_elf_binary,
 		.load_shlib	= load_elf_library,
 		.core_dump	= elf_core_dump,
-		.min_coredump	= ELF_EXEC_PAGESIZE
+		.min_coredump	= ELF_EXEC_PAGESIZE,
+		.hasvdso	= 1
 };
 
 #define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
--- linux-2.6.20.1.orig/include/linux/binfmts.h
+++ linux-2.6.20.1/include/linux/binfmts.h
@@ -59,6 +59,7 @@ struct linux_binfmt {
 	int (*load_shlib)(struct file *);
 	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file);
 	unsigned long min_coredump;	/* minimal dump size */
+	int hasvdso;
 };
 
 extern int register_binfmt(struct linux_binfmt *);

--
