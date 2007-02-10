Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbXBJCcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbXBJCcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 21:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXBJCby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 21:31:54 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:46316 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbXBJCbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 21:31:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:from;
        b=Q36zkZdtiwQWHh/3UcnAaQwkNE6jk5/zjQcplgPwnFGn8ww/G4Rc7uYy/5J7F60RK+cmPMXK+Ld3OCy3N0X4Z2SEcmiQV9OJmHf4WUl1ZWOq5a3P2o9KU+3XbnEwWnWfo3cDcw7KnoIAP/Sr0zOw4O+DF/ldDj01LajJaZiqzWs=
Date: Fri, 9 Feb 2007 21:31:45 -0500 (EST)
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ak@suse.de, joerg@hydrops.han.de,
       dsd@gentoo.org, paulus@samba.org, benh@kernel.crashing.org,
       lethal@linux-sh.org
Subject: [PATCH] Make aout executables work again
Message-ID: <Pine.LNX.4.64.0702092100540.3984@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: Parag Warudkar <parag.warudkar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This a reworked, replacement version of 
x86-fix-vdso-mapping-for-aout-executables-* series of patches in -mm.

1) Define arch_setup_additional_pages() as weak in linux/interp.h
2) Include linux/interp.h in appropriate places
3) Conditionally call arch_setup_additional_pages() from binfmt_*.c if the 
arch defines it
4) EXPORT_SYMBOL_GPL(arch_setup_additional_pages) for all x86{64}, 
powerpc, sh - binfmt_aout can be built as module
5) Get rid of ARCH_HAS_SETUP_ADDITIONAL_PAGES from various places
6) For x86_64 - define and export arch_setup_additional_pages as a wrapper 
over syscall32_setup_pages, call it from ia32_aout.c

Fully tested on x86. (Compile, boot and run the aout binary at 
http://ftp.funet.fi/pub/Linux/bin/as86.tar.Z). Other arches - changes are 
minimal but still I'll appreciate if someone tests them.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

diff -urN --exclude='*git*' --exclude='scripts*' linux-2.6-us/arch/i386/kernel/sysenter.c linux-2.6-wk/arch/i386/kernel/sysenter.c
--- linux-2.6-us/arch/i386/kernel/sysenter.c	2007-02-09 17:29:34.000000000 -0500
+++ linux-2.6-wk/arch/i386/kernel/sysenter.c	2007-02-09 17:54:48.000000000 -0500
@@ -137,6 +137,7 @@
  	up_write(&mm->mmap_sem);
  	return ret;
  }
+EXPORT_SYMBOL_GPL(arch_setup_additional_pages);

  const char *arch_vma_name(struct vm_area_struct *vma)
  {
diff -urN --exclude='*git*' --exclude='scripts*' linux-2.6-us/arch/powerpc/kernel/vdso.c linux-2.6-wk/arch/powerpc/kernel/vdso.c
--- linux-2.6-us/arch/powerpc/kernel/vdso.c	2007-02-09 17:29:34.000000000 -0500
+++ linux-2.6-wk/arch/powerpc/kernel/vdso.c	2007-02-09 18:02:09.000000000 -0500
@@ -254,6 +254,7 @@
  	up_write(&mm->mmap_sem);
  	return rc;
  }
+EXPORT_SYMBOL_GPL(arch_setup_additional_pages);

  const char *arch_vma_name(struct vm_area_struct *vma)
  {
diff -urN --exclude='*git*' --exclude='scripts*' linux-2.6-us/arch/sh/kernel/vsyscall/vsyscall.c linux-2.6-wk/arch/sh/kernel/vsyscall/vsyscall.c
--- linux-2.6-us/arch/sh/kernel/vsyscall/vsyscall.c	2007-02-09 17:29:34.000000000 -0500
+++ linux-2.6-wk/arch/sh/kernel/vsyscall/vsyscall.c	2007-02-09 18:02:51.000000000 -0500
@@ -85,6 +85,7 @@
  	up_write(&mm->mmap_sem);
  	return ret;
  }
+EXPORT_SYMBOL_GPL(arch_setup_additional_pages);

  const char *arch_vma_name(struct vm_area_struct *vma)
  {
diff -urN --exclude='*git*' --exclude='scripts*' linux-2.6-us/arch/x86_64/ia32/ia32_aout.c linux-2.6-wk/arch/x86_64/ia32/ia32_aout.c
--- linux-2.6-us/arch/x86_64/ia32/ia32_aout.c	2007-01-26 18:49:37.000000000 -0500
+++ linux-2.6-wk/arch/x86_64/ia32/ia32_aout.c	2007-02-09 20:29:01.000000000 -0500
@@ -23,6 +23,7 @@
  #include <linux/user.h>
  #include <linux/slab.h>
  #include <linux/binfmts.h>
+#include <linux/interp.h>
  #include <linux/personality.h>
  #include <linux/init.h>

@@ -410,6 +411,12 @@
  		send_sig(SIGKILL, current, 0);
  		return retval;
  	}
+ 
+	retval = arch_setup_additional_pages(bprm, EXSTACK_DEFAULT);
+	if (retval < 0) { 
+		send_sig(SIGKILL, current, 0); 
+		return retval;
+	}

  	current->mm->start_stack =
  		(unsigned long)create_aout_tables((char __user *)bprm->p, bprm);
diff -urN --exclude='*git*' --exclude='scripts*' linux-2.6-us/arch/x86_64/ia32/ia32_binfmt.c linux-2.6-wk/arch/x86_64/ia32/ia32_binfmt.c
--- linux-2.6-us/arch/x86_64/ia32/ia32_binfmt.c	2007-01-27 17:23:08.000000000 -0500
+++ linux-2.6-wk/arch/x86_64/ia32/ia32_binfmt.c	2007-02-09 17:58:42.000000000 -0500
@@ -258,10 +258,6 @@

  static void elf32_init(struct pt_regs *);

-#define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
-#define arch_setup_additional_pages syscall32_setup_pages
-extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
-
  #include "../../../fs/binfmt_elf.c"

  static void elf32_init(struct pt_regs *regs)
diff -urN --exclude='*git*' --exclude='scripts*' linux-2.6-us/arch/x86_64/ia32/syscall32.c linux-2.6-wk/arch/x86_64/ia32/syscall32.c
--- linux-2.6-us/arch/x86_64/ia32/syscall32.c	2007-02-09 17:29:34.000000000 -0500
+++ linux-2.6-wk/arch/x86_64/ia32/syscall32.c	2007-02-09 18:01:23.000000000 -0500
@@ -48,6 +48,12 @@
  	return ret;
  }

+int arch_setup_additional_pages(struct linux_binprm* bprm, int exstack)
+{
+	return syscall32_setup_pages(bprm, exstack);
+}
+EXPORT_SYMBOL_GPL(arch_setup_additional_pages);
+
  const char *arch_vma_name(struct vm_area_struct *vma)
  {
  	if (vma->vm_start == VSYSCALL32_BASE &&
diff -urN --exclude='*git*' --exclude='scripts*' linux-2.6-us/fs/binfmt_aout.c linux-2.6-wk/fs/binfmt_aout.c
--- linux-2.6-us/fs/binfmt_aout.c	2007-01-26 18:49:39.000000000 -0500
+++ linux-2.6-wk/fs/binfmt_aout.c	2007-02-09 17:53:33.000000000 -0500
@@ -22,6 +22,7 @@
  #include <linux/user.h>
  #include <linux/slab.h>
  #include <linux/binfmts.h>
+#include <linux/interp.h>
  #include <linux/personality.h>
  #include <linux/init.h>

@@ -445,6 +446,14 @@
  		send_sig(SIGKILL, current, 0);
  		return retval;
  	}
+ 
+	if(arch_setup_additional_pages) {
+		retval = arch_setup_additional_pages(bprm, EXSTACK_DEFAULT);
+		if (retval < 0) { 
+			send_sig(SIGKILL, current, 0); 
+			return retval;
+		}
+	}

  	current->mm->start_stack =
  		(unsigned long) create_aout_tables((char __user *) bprm->p, bprm);
diff -urN --exclude='*git*' --exclude='scripts*' linux-2.6-us/fs/binfmt_elf.c linux-2.6-wk/fs/binfmt_elf.c
--- linux-2.6-us/fs/binfmt_elf.c	2007-01-27 17:23:08.000000000 -0500
+++ linux-2.6-wk/fs/binfmt_elf.c	2007-02-09 17:48:18.000000000 -0500
@@ -20,6 +20,7 @@
  #include <linux/errno.h>
  #include <linux/signal.h>
  #include <linux/binfmts.h>
+#include <linux/interp.h>
  #include <linux/string.h>
  #include <linux/file.h>
  #include <linux/fcntl.h>
@@ -974,13 +975,13 @@

  	set_binfmt(&elf_format);

-#ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
-	retval = arch_setup_additional_pages(bprm, executable_stack);
-	if (retval < 0) {
-		send_sig(SIGKILL, current, 0);
-		goto out;
+	if (arch_setup_additional_pages) {
+		retval = arch_setup_additional_pages(bprm, executable_stack);
+		if (retval < 0) {
+			send_sig(SIGKILL, current, 0);
+			goto out;
+		}
  	}
-#endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGES */

  	compute_creds(bprm);
  	current->flags &= ~PF_FORKNOEXEC;
diff -urN --exclude='*git*' --exclude='scripts*' linux-2.6-us/include/linux/interp.h linux-2.6-wk/include/linux/interp.h
--- linux-2.6-us/include/linux/interp.h	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6-wk/include/linux/interp.h	2007-02-09 21:26:34.000000000 -0500
@@ -0,0 +1,8 @@
+#ifndef _LINUX_INTERP_H
+#define _LINUX_INTERP_H
+
+struct linux_binprm;
+
+extern int __attribute__((weak)) 
+	arch_setup_additional_pages(struct linux_binprm*, int);
+#endif /* _LINUX_INTERP_H */
