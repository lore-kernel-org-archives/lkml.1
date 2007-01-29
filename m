Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbXA2Iro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbXA2Iro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 03:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXA2Iro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 03:47:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:43116 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933275AbXA2IrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 03:47:20 -0500
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 7891] New: vdso page is no longer mapped for
Date: Mon, 29 Jan 2007 04:10:29 +0100
User-Agent: KMail/1.9.1
Cc: "Parag Warudkar" <parag.warudkar@gmail.com>, dsd@gentoo.org,
       joerg@hydrops.han.de, linux-kernel@vger.kernel.org
References: <82e4877d0701271201n3aa5bdf6v7c5fb8e41ee98c80@mail.gmail.com> <20070127140233.203ef7d3.akpm@osdl.org>
In-Reply-To: <20070127140233.203ef7d3.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701290410.29427.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 January 2007 23:02, Andrew Morton wrote:
> On Sat, 27 Jan 2007 15:01:51 -0500
>
> "Parag Warudkar" <parag.warudkar@gmail.com> wrote:
> > Here is a patch that does what Andrew Morton suggested (plus some more
> > as explained below) .
> > Patch inline below and also attached in case there is whitespace
> > damage. Compile tested on i386 with make defconfig; make. If anyone
> > can test on other arches and provide feedback that'd be great.
>
> Thanks - I can test elf on powerpc.  Does anyone remember how to
> create a.out executables?

You need an old toolkit, but the historic section of ftp.funet.fi
has a few binaries. I also got a tarball of an old a.out SUSE
installation somewhere that I can dig out if there is interest.

> Assuming this works, I'm not surew what to do with it.  Jam it into
> 2.6.20, I guess.  The lateness*largeness product is somewhat high though.

I simpler fix might be to just not require the vDSO for signal handling
on a.out. 

Here's a untested patch.

-Andi

Don't require the vDSO for handling a.out signals

and in other strange binfmts. vDSO is not necessarily mapped there.

Signed-off-by: Andi Kleen <ak@suse.de>

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
