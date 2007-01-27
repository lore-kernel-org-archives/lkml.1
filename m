Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbXA0UBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbXA0UBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 15:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbXA0UBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 15:01:54 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:14883 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbXA0UBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 15:01:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=GN17GY140JFztQrIcmEwkIkiyafuM4dtMlCawlYJotlwz87xzDs38KJZ0Rzrp5o1tddPUwV0luj98UXQPBWvBu4sqose+MRq2S0vohy0+XUjqE5QqklwMH4WSzu7iqOG8TgFdc+tDSe2cPvdbThPGkqGpmV2GfNN4p/oVTzEwyc=
Message-ID: <82e4877d0701271201n3aa5bdf6v7c5fb8e41ee98c80@mail.gmail.com>
Date: Sat, 27 Jan 2007 15:01:51 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: akpm@osdl.org, dsd@gentoo.org, joerg@hydrops.han.de, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 7891] New: vdso page is no longer mapped for
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_57818_5454779.1169928111992"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_57818_5454779.1169928111992
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Here is a patch that does what Andrew Morton suggested (plus some more
as explained below) .
Patch inline below and also attached in case there is whitespace
damage. Compile tested on i386 with make defconfig; make. If anyone
can test on other arches and provide feedback that'd be great.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

- Give i386, x86_64, powerpc and sh a new
  CONFIG_ARCH_HAS_SETUP_ADDITIONAL_PAGES

- Create a new include/linux/interp.h which has:

	struct linux_binprm;
	#ifdef CONFIG_ARCH_HAS_SETUP_ADDITIONAL_PAGES
	extern int arch_setup_additional_pages(struct linux_binprm *bprm,
                                       int executable_stack);
	#else
	static inline int arch_setup_additional_pages(struct linux_binprm *bprm,
                                       int executable_stack)
	{
		return 0;
	}
	#endif

- include <linux/interp.h> from binfmt_elf.c and binfmt_aout.c and from
  all the files which implement arch_setup_additional_pages().

- Remove the #ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES from binfmt_elf.c

- Add the call to arch_setup_additional_pages() in binfmt_aout.h.

- EXPORT_SYMBOL(arch_setup_additional_pages) for all arches referred
above - binfmt_aout.c can be built as module on all architectures and
it needs to call arch_setup_additional_pages

- For x86_64 - remove
   #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
   #define arch_setup_additional_pages syscall32_setup_pages
  from ia32_binfmt.c and instead use arch_setup_additional_pages as an
exported wrapper over  syscall32_setup_pages

diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/arch/i386/Kconfig
linux-2.6-wk/arch/i386/Kconfig
--- linux-2.6-us/arch/i386/Kconfig	2007-01-26 18:49:36.000000000 -0500
+++ linux-2.6-wk/arch/i386/Kconfig	2007-01-26 18:56:29.000000000 -0500
@@ -625,6 +625,11 @@
 config ARCH_POPULATES_NODE_MAP
 	def_bool y

+config ARCH_HAS_SETUP_ADDITIONAL_PAGES
+       bool
+       default y
+       depends on X86_32
+
 source "mm/Kconfig"

 config HIGHPTE
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/arch/i386/kernel/sysenter.c
linux-2.6-wk/arch/i386/kernel/sysenter.c
--- linux-2.6-us/arch/i386/kernel/sysenter.c	2007-01-26 18:49:36.000000000 -0500
+++ linux-2.6-wk/arch/i386/kernel/sysenter.c	2007-01-27 12:40:14.000000000 -0500
@@ -17,6 +17,7 @@
 #include <linux/elf.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/interp.h>

 #include <asm/cpufeature.h>
 #include <asm/msr.h>
@@ -165,6 +166,7 @@
 	up_write(&mm->mmap_sem);
 	return ret;
 }
+EXPORT_SYMBOL(arch_setup_additional_pages);

 const char *arch_vma_name(struct vm_area_struct *vma)
 {
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/arch/powerpc/Kconfig
linux-2.6-wk/arch/powerpc/Kconfig
--- linux-2.6-us/arch/powerpc/Kconfig	2007-01-26 18:49:36.000000000 -0500
+++ linux-2.6-wk/arch/powerpc/Kconfig	2007-01-26 19:01:39.000000000 -0500
@@ -45,6 +45,11 @@
 	bool
 	default y

+config ARCH_HAS_SETUP_ADDITIONAL_PAGES
+       bool
+       default y
+       depends on PPC32 || PPC64
+
 config ARCH_HAS_ILOG2_U64
 	bool
 	default y if 64BIT
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/arch/powerpc/kernel/vdso.c
linux-2.6-wk/arch/powerpc/kernel/vdso.c
--- linux-2.6-us/arch/powerpc/kernel/vdso.c	2007-01-26 18:49:36.000000000 -0500
+++ linux-2.6-wk/arch/powerpc/kernel/vdso.c	2007-01-27 12:39:39.000000000 -0500
@@ -22,6 +22,7 @@
 #include <linux/elf.h>
 #include <linux/security.h>
 #include <linux/bootmem.h>
+#include <linux/interp.h>

 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -305,6 +306,7 @@
 	up_write(&mm->mmap_sem);
 	return rc;
 }
+EXPORT_SYMBOL(arch_setup_additional_pages);

 const char *arch_vma_name(struct vm_area_struct *vma)
 {
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/arch/sh/Kconfig
linux-2.6-wk/arch/sh/Kconfig
--- linux-2.6-us/arch/sh/Kconfig	2007-01-26 18:49:36.000000000 -0500
+++ linux-2.6-wk/arch/sh/Kconfig	2007-01-26 19:04:00.000000000 -0500
@@ -67,6 +67,11 @@
 	bool
 	default n

+config ARCH_HAS_SETUP_ADDITIONAL_PAGES
+       bool
+       default y
+       depends on SUPERH
+
 source "init/Kconfig"

 menu "System type"
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/arch/sh/kernel/vsyscall/vsyscall.c
linux-2.6-wk/arch/sh/kernel/vsyscall/vsyscall.c
--- linux-2.6-us/arch/sh/kernel/vsyscall/vsyscall.c	2007-01-26
18:49:36.000000000 -0500
+++ linux-2.6-wk/arch/sh/kernel/vsyscall/vsyscall.c	2007-01-27
12:39:15.000000000 -0500
@@ -17,6 +17,7 @@
 #include <linux/gfp.h>
 #include <linux/module.h>
 #include <linux/elf.h>
+#include <linux/interp.h>

 /*
  * Should the kernel map a VDSO page into processes and pass its
@@ -125,6 +126,7 @@
 	up_write(&mm->mmap_sem);
 	return ret;
 }
+EXPORT_SYMBOL(arch_setup_additional_pages);

 const char *arch_vma_name(struct vm_area_struct *vma)
 {
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/arch/x86_64/ia32/ia32_aout.c
linux-2.6-wk/arch/x86_64/ia32/ia32_aout.c
--- linux-2.6-us/arch/x86_64/ia32/ia32_aout.c	2007-01-26
18:49:37.000000000 -0500
+++ linux-2.6-wk/arch/x86_64/ia32/ia32_aout.c	2007-01-27
13:30:08.000000000 -0500
@@ -25,6 +25,7 @@
 #include <linux/binfmts.h>
 #include <linux/personality.h>
 #include <linux/init.h>
+#include <linux/interp.h>

 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -410,7 +411,15 @@
 		send_sig(SIGKILL, current, 0);
 		return retval;
 	}
-
+	
+	retval = arch_setup_additional_pages(bprm, EXSTACK_DEFAULT);
+
+	if (retval < 0) {
+                /* Someone check-me: is this error path enough? */
+                send_sig(SIGKILL, current, 0);
+                return retval;
+        }
+	
 	current->mm->start_stack =
 		(unsigned long)create_aout_tables((char __user *)bprm->p, bprm);
 	/* start thread */
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/arch/x86_64/ia32/ia32_binfmt.c
linux-2.6-wk/arch/x86_64/ia32/ia32_binfmt.c
--- linux-2.6-us/arch/x86_64/ia32/ia32_binfmt.c	2007-01-26
18:49:37.000000000 -0500
+++ linux-2.6-wk/arch/x86_64/ia32/ia32_binfmt.c	2007-01-27
13:23:56.000000000 -0500
@@ -14,6 +14,7 @@
 #include <linux/binfmts.h>
 #include <linux/mm.h>
 #include <linux/security.h>
+#include <linux/interp.h>

 #include <asm/segment.h>
 #include <asm/ptrace.h>
@@ -307,10 +308,6 @@

 static void elf32_init(struct pt_regs *);

-#define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
-#define arch_setup_additional_pages syscall32_setup_pages
-extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
-
 #include "../../../fs/binfmt_elf.c"

 static void elf32_init(struct pt_regs *regs)
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/arch/x86_64/ia32/syscall32.c
linux-2.6-wk/arch/x86_64/ia32/syscall32.c
--- linux-2.6-us/arch/x86_64/ia32/syscall32.c	2007-01-26
18:49:37.000000000 -0500
+++ linux-2.6-wk/arch/x86_64/ia32/syscall32.c	2007-01-27
13:14:53.000000000 -0500
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/stringify.h>
 #include <linux/security.h>
+#include <linux/interp.h>
 #include <asm/proto.h>
 #include <asm/tlbflush.h>
 #include <asm/ia32_unistd.h>
@@ -75,6 +76,12 @@
 	return 0;
 }

+int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
+{
+	return syscall32_setup_pages(struct linux_binprm *bprm, int exstack);
+}
+EXPORT_SYMBOL(arch_setup_additional_pages);
+
 static int __init init_syscall32(void)
 {
 	syscall32_page = (void *)get_zeroed_page(GFP_KERNEL);
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/arch/x86_64/Kconfig
linux-2.6-wk/arch/x86_64/Kconfig
--- linux-2.6-us/arch/x86_64/Kconfig	2007-01-26 18:49:37.000000000 -0500
+++ linux-2.6-wk/arch/x86_64/Kconfig	2007-01-26 18:59:26.000000000 -0500
@@ -398,6 +398,11 @@
 	def_bool y
 	depends on NUMA

+config ARCH_HAS_SETUP_ADDITIONAL_PAGES
+       bool
+       default y
+       depends on X86_64
+
 config OUT_OF_LINE_PFN_TO_PAGE
 	def_bool y
 	depends on DISCONTIGMEM
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/fs/binfmt_aout.c
linux-2.6-wk/fs/binfmt_aout.c
--- linux-2.6-us/fs/binfmt_aout.c	2007-01-26 18:49:39.000000000 -0500
+++ linux-2.6-wk/fs/binfmt_aout.c	2007-01-27 12:22:48.000000000 -0500
@@ -22,6 +22,7 @@
 #include <linux/user.h>
 #include <linux/slab.h>
 #include <linux/binfmts.h>
+#include <linux/interp.h>
 #include <linux/personality.h>
 #include <linux/init.h>

@@ -269,7 +270,7 @@
 	unsigned long fd_offset;
 	unsigned long rlim;
 	int retval;
-
+	int executable_stack = EXSTACK_DEFAULT;
 	ex = *((struct exec *) bprm->buf);		/* exec-header */
 	if ((N_MAGIC(ex) != ZMAGIC && N_MAGIC(ex) != OMAGIC &&
 	     N_MAGIC(ex) != QMAGIC && N_MAGIC(ex) != NMAGIC) ||
@@ -432,6 +433,12 @@
 	}
 beyond_if:
 	set_binfmt(&aout_format);
+	
+	retval = arch_setup_additional_pages(bprm, executable_stack);
+        if (retval < 0) {
+                send_sig(SIGKILL, current, 0);
+                return retval;
+        }

 	retval = set_brk(current->mm->start_brk, current->mm->brk);
 	if (retval < 0) {
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/fs/binfmt_elf.c
linux-2.6-wk/fs/binfmt_elf.c
--- linux-2.6-us/fs/binfmt_elf.c	2007-01-26 18:49:39.000000000 -0500
+++ linux-2.6-wk/fs/binfmt_elf.c	2007-01-27 11:09:48.000000000 -0500
@@ -38,6 +38,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/random.h>
+#include <linux/interp.h>
 #include <linux/elf.h>
 #include <asm/uaccess.h>
 #include <asm/param.h>
@@ -965,13 +966,11 @@

 	set_binfmt(&elf_format);

-#ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
 	retval = arch_setup_additional_pages(bprm, executable_stack);
 	if (retval < 0) {
 		send_sig(SIGKILL, current, 0);
 		goto out;
 	}
-#endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGES */

 	compute_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/include/asm-i386/elf.h
linux-2.6-wk/include/asm-i386/elf.h
--- linux-2.6-us/include/asm-i386/elf.h	2007-01-26 18:49:40.000000000 -0500
+++ linux-2.6-wk/include/asm-i386/elf.h	2007-01-27 12:24:35.000000000 -0500
@@ -156,11 +156,6 @@

 #define VDSO_ENTRY		VDSO_SYM(&__kernel_vsyscall)

-#define ARCH_HAS_SETUP_ADDITIONAL_PAGES
-struct linux_binprm;
-extern int arch_setup_additional_pages(struct linux_binprm *bprm,
-                                       int executable_stack);
-
 extern unsigned int vdso_enabled;

 #define ARCH_DLINFO						\
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/include/asm-powerpc/elf.h
linux-2.6-wk/include/asm-powerpc/elf.h
--- linux-2.6-us/include/asm-powerpc/elf.h	2007-01-26 18:49:40.000000000 -0500
+++ linux-2.6-wk/include/asm-powerpc/elf.h	2007-01-27 12:24:51.000000000 -0500
@@ -266,11 +266,6 @@
 extern int icache_bsize;
 extern int ucache_bsize;

-/* vDSO has arch_setup_additional_pages */
-#define ARCH_HAS_SETUP_ADDITIONAL_PAGES
-struct linux_binprm;
-extern int arch_setup_additional_pages(struct linux_binprm *bprm,
-				       int executable_stack);
 #define VDSO_AUX_ENT(a,b) NEW_AUX_ENT(a,b);

 /*
diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/include/asm-sh/elf.h
linux-2.6-wk/include/asm-sh/elf.h
--- linux-2.6-us/include/asm-sh/elf.h	2007-01-26 18:49:40.000000000 -0500
+++ linux-2.6-wk/include/asm-sh/elf.h	2007-01-27 12:25:07.000000000 -0500
@@ -121,12 +121,6 @@
 #endif

 #ifdef CONFIG_VSYSCALL
-/* vDSO has arch_setup_additional_pages */
-#define ARCH_HAS_SETUP_ADDITIONAL_PAGES
-struct linux_binprm;
-extern int arch_setup_additional_pages(struct linux_binprm *bprm,
-				       int executable_stack);
-
 extern unsigned int vdso_enabled;
 extern void __kernel_vsyscall;

diff -urN --exclude='cscope*' --exclude='*git*' --exclude='*.[sSoO]'
--exclude='*.gz' linux-2.6-us/include/linux/interp.h
linux-2.6-wk/include/linux/interp.h
--- linux-2.6-us/include/linux/interp.h	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6-wk/include/linux/interp.h	2007-01-27 12:13:44.000000000 -0500
@@ -0,0 +1,17 @@
+/* interp.h */
+#ifndef _LINUX_INTERP_H
+#define _LINUX_INTERP_H
+
+struct linux_binprm;
+#ifdef CONFIG_ARCH_HAS_SETUP_ADDITIONAL_PAGES
+extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+					int executable_stack);
+#else
+static inline int arch_setup_additional_pages(struct linux_binprm *bprm,
+				int executable_stack)
+{
+	return 0;
+}
+#endif
+
+#endif /* interp.h */

------=_Part_57818_5454779.1169928111992
Content-Type: text/x-patch; name=fix-arch-setup-add-pages.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_exggx8iz
Content-Disposition: attachment; filename="fix-arch-setup-add-pages.patch"

ZGlmZiAtdXJOIC0tZXhjbHVkZT0nY3Njb3BlKicgLS1leGNsdWRlPScqZ2l0KicgLS1leGNsdWRl
PScqLltzU29PXScgLS1leGNsdWRlPScqLmd6JyBsaW51eC0yLjYtdXMvYXJjaC9pMzg2L0tjb25m
aWcgbGludXgtMi42LXdrL2FyY2gvaTM4Ni9LY29uZmlnCi0tLSBsaW51eC0yLjYtdXMvYXJjaC9p
Mzg2L0tjb25maWcJMjAwNy0wMS0yNiAxODo0OTozNi4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4
LTIuNi13ay9hcmNoL2kzODYvS2NvbmZpZwkyMDA3LTAxLTI2IDE4OjU2OjI5LjAwMDAwMDAwMCAt
MDUwMApAQCAtNjI1LDYgKzYyNSwxMSBAQAogY29uZmlnIEFSQ0hfUE9QVUxBVEVTX05PREVfTUFQ
CiAJZGVmX2Jvb2wgeQogCitjb25maWcgQVJDSF9IQVNfU0VUVVBfQURESVRJT05BTF9QQUdFUwor
ICAgICAgIGJvb2wKKyAgICAgICBkZWZhdWx0IHkKKyAgICAgICBkZXBlbmRzIG9uIFg4Nl8zMgor
CiBzb3VyY2UgIm1tL0tjb25maWciCiAKIGNvbmZpZyBISUdIUFRFCmRpZmYgLXVyTiAtLWV4Y2x1
ZGU9J2NzY29wZSonIC0tZXhjbHVkZT0nKmdpdConIC0tZXhjbHVkZT0nKi5bc1NvT10nIC0tZXhj
bHVkZT0nKi5neicgbGludXgtMi42LXVzL2FyY2gvaTM4Ni9rZXJuZWwvc3lzZW50ZXIuYyBsaW51
eC0yLjYtd2svYXJjaC9pMzg2L2tlcm5lbC9zeXNlbnRlci5jCi0tLSBsaW51eC0yLjYtdXMvYXJj
aC9pMzg2L2tlcm5lbC9zeXNlbnRlci5jCTIwMDctMDEtMjYgMTg6NDk6MzYuMDAwMDAwMDAwIC0w
NTAwCisrKyBsaW51eC0yLjYtd2svYXJjaC9pMzg2L2tlcm5lbC9zeXNlbnRlci5jCTIwMDctMDEt
MjcgMTI6NDA6MTQuMDAwMDAwMDAwIC0wNTAwCkBAIC0xNyw2ICsxNyw3IEBACiAjaW5jbHVkZSA8
bGludXgvZWxmLmg+CiAjaW5jbHVkZSA8bGludXgvbW0uaD4KICNpbmNsdWRlIDxsaW51eC9tb2R1
bGUuaD4KKyNpbmNsdWRlIDxsaW51eC9pbnRlcnAuaD4KIAogI2luY2x1ZGUgPGFzbS9jcHVmZWF0
dXJlLmg+CiAjaW5jbHVkZSA8YXNtL21zci5oPgpAQCAtMTY1LDYgKzE2Niw3IEBACiAJdXBfd3Jp
dGUoJm1tLT5tbWFwX3NlbSk7CiAJcmV0dXJuIHJldDsKIH0KK0VYUE9SVF9TWU1CT0woYXJjaF9z
ZXR1cF9hZGRpdGlvbmFsX3BhZ2VzKTsKIAogY29uc3QgY2hhciAqYXJjaF92bWFfbmFtZShzdHJ1
Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSkKIHsKZGlmZiAtdXJOIC0tZXhjbHVkZT0nY3Njb3BlKicg
LS1leGNsdWRlPScqZ2l0KicgLS1leGNsdWRlPScqLltzU29PXScgLS1leGNsdWRlPScqLmd6JyBs
aW51eC0yLjYtdXMvYXJjaC9wb3dlcnBjL0tjb25maWcgbGludXgtMi42LXdrL2FyY2gvcG93ZXJw
Yy9LY29uZmlnCi0tLSBsaW51eC0yLjYtdXMvYXJjaC9wb3dlcnBjL0tjb25maWcJMjAwNy0wMS0y
NiAxODo0OTozNi4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi13ay9hcmNoL3Bvd2VycGMv
S2NvbmZpZwkyMDA3LTAxLTI2IDE5OjAxOjM5LjAwMDAwMDAwMCAtMDUwMApAQCAtNDUsNiArNDUs
MTEgQEAKIAlib29sCiAJZGVmYXVsdCB5CiAKK2NvbmZpZyBBUkNIX0hBU19TRVRVUF9BRERJVElP
TkFMX1BBR0VTCisgICAgICAgYm9vbAorICAgICAgIGRlZmF1bHQgeQorICAgICAgIGRlcGVuZHMg
b24gUFBDMzIgfHwgUFBDNjQKKwogY29uZmlnIEFSQ0hfSEFTX0lMT0cyX1U2NAogCWJvb2wKIAlk
ZWZhdWx0IHkgaWYgNjRCSVQKZGlmZiAtdXJOIC0tZXhjbHVkZT0nY3Njb3BlKicgLS1leGNsdWRl
PScqZ2l0KicgLS1leGNsdWRlPScqLltzU29PXScgLS1leGNsdWRlPScqLmd6JyBsaW51eC0yLjYt
dXMvYXJjaC9wb3dlcnBjL2tlcm5lbC92ZHNvLmMgbGludXgtMi42LXdrL2FyY2gvcG93ZXJwYy9r
ZXJuZWwvdmRzby5jCi0tLSBsaW51eC0yLjYtdXMvYXJjaC9wb3dlcnBjL2tlcm5lbC92ZHNvLmMJ
MjAwNy0wMS0yNiAxODo0OTozNi4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi13ay9hcmNo
L3Bvd2VycGMva2VybmVsL3Zkc28uYwkyMDA3LTAxLTI3IDEyOjM5OjM5LjAwMDAwMDAwMCAtMDUw
MApAQCAtMjIsNiArMjIsNyBAQAogI2luY2x1ZGUgPGxpbnV4L2VsZi5oPgogI2luY2x1ZGUgPGxp
bnV4L3NlY3VyaXR5Lmg+CiAjaW5jbHVkZSA8bGludXgvYm9vdG1lbS5oPgorI2luY2x1ZGUgPGxp
bnV4L2ludGVycC5oPgogCiAjaW5jbHVkZSA8YXNtL3BndGFibGUuaD4KICNpbmNsdWRlIDxhc20v
c3lzdGVtLmg+CkBAIC0zMDUsNiArMzA2LDcgQEAKIAl1cF93cml0ZSgmbW0tPm1tYXBfc2VtKTsK
IAlyZXR1cm4gcmM7CiB9CitFWFBPUlRfU1lNQk9MKGFyY2hfc2V0dXBfYWRkaXRpb25hbF9wYWdl
cyk7CiAKIGNvbnN0IGNoYXIgKmFyY2hfdm1hX25hbWUoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2
bWEpCiB7CmRpZmYgLXVyTiAtLWV4Y2x1ZGU9J2NzY29wZSonIC0tZXhjbHVkZT0nKmdpdConIC0t
ZXhjbHVkZT0nKi5bc1NvT10nIC0tZXhjbHVkZT0nKi5neicgbGludXgtMi42LXVzL2FyY2gvc2gv
S2NvbmZpZyBsaW51eC0yLjYtd2svYXJjaC9zaC9LY29uZmlnCi0tLSBsaW51eC0yLjYtdXMvYXJj
aC9zaC9LY29uZmlnCTIwMDctMDEtMjYgMTg6NDk6MzYuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51
eC0yLjYtd2svYXJjaC9zaC9LY29uZmlnCTIwMDctMDEtMjYgMTk6MDQ6MDAuMDAwMDAwMDAwIC0w
NTAwCkBAIC02Nyw2ICs2NywxMSBAQAogCWJvb2wKIAlkZWZhdWx0IG4KIAorY29uZmlnIEFSQ0hf
SEFTX1NFVFVQX0FERElUSU9OQUxfUEFHRVMKKyAgICAgICBib29sCisgICAgICAgZGVmYXVsdCB5
CisgICAgICAgZGVwZW5kcyBvbiBTVVBFUkgKKwogc291cmNlICJpbml0L0tjb25maWciCiAKIG1l
bnUgIlN5c3RlbSB0eXBlIgpkaWZmIC11ck4gLS1leGNsdWRlPSdjc2NvcGUqJyAtLWV4Y2x1ZGU9
JypnaXQqJyAtLWV4Y2x1ZGU9JyouW3NTb09dJyAtLWV4Y2x1ZGU9JyouZ3onIGxpbnV4LTIuNi11
cy9hcmNoL3NoL2tlcm5lbC92c3lzY2FsbC92c3lzY2FsbC5jIGxpbnV4LTIuNi13ay9hcmNoL3No
L2tlcm5lbC92c3lzY2FsbC92c3lzY2FsbC5jCi0tLSBsaW51eC0yLjYtdXMvYXJjaC9zaC9rZXJu
ZWwvdnN5c2NhbGwvdnN5c2NhbGwuYwkyMDA3LTAxLTI2IDE4OjQ5OjM2LjAwMDAwMDAwMCAtMDUw
MAorKysgbGludXgtMi42LXdrL2FyY2gvc2gva2VybmVsL3ZzeXNjYWxsL3ZzeXNjYWxsLmMJMjAw
Ny0wMS0yNyAxMjozOToxNS4wMDAwMDAwMDAgLTA1MDAKQEAgLTE3LDYgKzE3LDcgQEAKICNpbmNs
dWRlIDxsaW51eC9nZnAuaD4KICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KICNpbmNsdWRlIDxs
aW51eC9lbGYuaD4KKyNpbmNsdWRlIDxsaW51eC9pbnRlcnAuaD4KIAogLyoKICAqIFNob3VsZCB0
aGUga2VybmVsIG1hcCBhIFZEU08gcGFnZSBpbnRvIHByb2Nlc3NlcyBhbmQgcGFzcyBpdHMKQEAg
LTEyNSw2ICsxMjYsNyBAQAogCXVwX3dyaXRlKCZtbS0+bW1hcF9zZW0pOwogCXJldHVybiByZXQ7
CiB9CitFWFBPUlRfU1lNQk9MKGFyY2hfc2V0dXBfYWRkaXRpb25hbF9wYWdlcyk7CiAKIGNvbnN0
IGNoYXIgKmFyY2hfdm1hX25hbWUoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpCiB7CmRpZmYg
LXVyTiAtLWV4Y2x1ZGU9J2NzY29wZSonIC0tZXhjbHVkZT0nKmdpdConIC0tZXhjbHVkZT0nKi5b
c1NvT10nIC0tZXhjbHVkZT0nKi5neicgbGludXgtMi42LXVzL2FyY2gveDg2XzY0L2lhMzIvaWEz
Ml9hb3V0LmMgbGludXgtMi42LXdrL2FyY2gveDg2XzY0L2lhMzIvaWEzMl9hb3V0LmMKLS0tIGxp
bnV4LTIuNi11cy9hcmNoL3g4Nl82NC9pYTMyL2lhMzJfYW91dC5jCTIwMDctMDEtMjYgMTg6NDk6
MzcuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYtd2svYXJjaC94ODZfNjQvaWEzMi9pYTMy
X2FvdXQuYwkyMDA3LTAxLTI3IDEzOjMwOjA4LjAwMDAwMDAwMCAtMDUwMApAQCAtMjUsNiArMjUs
NyBAQAogI2luY2x1ZGUgPGxpbnV4L2JpbmZtdHMuaD4KICNpbmNsdWRlIDxsaW51eC9wZXJzb25h
bGl0eS5oPgogI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNpbmNsdWRlIDxsaW51eC9pbnRlcnAu
aD4KIAogI2luY2x1ZGUgPGFzbS9zeXN0ZW0uaD4KICNpbmNsdWRlIDxhc20vdWFjY2Vzcy5oPgpA
QCAtNDEwLDcgKzQxMSwxNSBAQAogCQlzZW5kX3NpZyhTSUdLSUxMLCBjdXJyZW50LCAwKTsgCiAJ
CXJldHVybiByZXR2YWw7CiAJfQotCisJCisJcmV0dmFsID0gYXJjaF9zZXR1cF9hZGRpdGlvbmFs
X3BhZ2VzKGJwcm0sIEVYU1RBQ0tfREVGQVVMVCk7CisgICAgICAgIAorCWlmIChyZXR2YWwgPCAw
KSB7CisgICAgICAgICAgICAgICAgLyogU29tZW9uZSBjaGVjay1tZTogaXMgdGhpcyBlcnJvciBw
YXRoIGVub3VnaD8gKi8KKyAgICAgICAgICAgICAgICBzZW5kX3NpZyhTSUdLSUxMLCBjdXJyZW50
LCAwKTsKKyAgICAgICAgICAgICAgICByZXR1cm4gcmV0dmFsOworICAgICAgICB9CisJCiAJY3Vy
cmVudC0+bW0tPnN0YXJ0X3N0YWNrID0KIAkJKHVuc2lnbmVkIGxvbmcpY3JlYXRlX2FvdXRfdGFi
bGVzKChjaGFyIF9fdXNlciAqKWJwcm0tPnAsIGJwcm0pOwogCS8qIHN0YXJ0IHRocmVhZCAqLwpk
aWZmIC11ck4gLS1leGNsdWRlPSdjc2NvcGUqJyAtLWV4Y2x1ZGU9JypnaXQqJyAtLWV4Y2x1ZGU9
JyouW3NTb09dJyAtLWV4Y2x1ZGU9JyouZ3onIGxpbnV4LTIuNi11cy9hcmNoL3g4Nl82NC9pYTMy
L2lhMzJfYmluZm10LmMgbGludXgtMi42LXdrL2FyY2gveDg2XzY0L2lhMzIvaWEzMl9iaW5mbXQu
YwotLS0gbGludXgtMi42LXVzL2FyY2gveDg2XzY0L2lhMzIvaWEzMl9iaW5mbXQuYwkyMDA3LTAx
LTI2IDE4OjQ5OjM3LjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LXdrL2FyY2gveDg2XzY0
L2lhMzIvaWEzMl9iaW5mbXQuYwkyMDA3LTAxLTI3IDEzOjIzOjU2LjAwMDAwMDAwMCAtMDUwMApA
QCAtMTQsNiArMTQsNyBAQAogI2luY2x1ZGUgPGxpbnV4L2JpbmZtdHMuaD4KICNpbmNsdWRlIDxs
aW51eC9tbS5oPgogI2luY2x1ZGUgPGxpbnV4L3NlY3VyaXR5Lmg+CisjaW5jbHVkZSA8bGludXgv
aW50ZXJwLmg+CiAKICNpbmNsdWRlIDxhc20vc2VnbWVudC5oPiAKICNpbmNsdWRlIDxhc20vcHRy
YWNlLmg+CkBAIC0zMDcsMTAgKzMwOCw2IEBACiAKIHN0YXRpYyB2b2lkIGVsZjMyX2luaXQoc3Ry
dWN0IHB0X3JlZ3MgKik7CiAKLSNkZWZpbmUgQVJDSF9IQVNfU0VUVVBfQURESVRJT05BTF9QQUdF
UyAxCi0jZGVmaW5lIGFyY2hfc2V0dXBfYWRkaXRpb25hbF9wYWdlcyBzeXNjYWxsMzJfc2V0dXBf
cGFnZXMKLWV4dGVybiBpbnQgc3lzY2FsbDMyX3NldHVwX3BhZ2VzKHN0cnVjdCBsaW51eF9iaW5w
cm0gKiwgaW50IGV4c3RhY2spOwotCiAjaW5jbHVkZSAiLi4vLi4vLi4vZnMvYmluZm10X2VsZi5j
IiAKIAogc3RhdGljIHZvaWQgZWxmMzJfaW5pdChzdHJ1Y3QgcHRfcmVncyAqcmVncykKZGlmZiAt
dXJOIC0tZXhjbHVkZT0nY3Njb3BlKicgLS1leGNsdWRlPScqZ2l0KicgLS1leGNsdWRlPScqLltz
U29PXScgLS1leGNsdWRlPScqLmd6JyBsaW51eC0yLjYtdXMvYXJjaC94ODZfNjQvaWEzMi9zeXNj
YWxsMzIuYyBsaW51eC0yLjYtd2svYXJjaC94ODZfNjQvaWEzMi9zeXNjYWxsMzIuYwotLS0gbGlu
dXgtMi42LXVzL2FyY2gveDg2XzY0L2lhMzIvc3lzY2FsbDMyLmMJMjAwNy0wMS0yNiAxODo0OToz
Ny4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi13ay9hcmNoL3g4Nl82NC9pYTMyL3N5c2Nh
bGwzMi5jCTIwMDctMDEtMjcgMTM6MTQ6NTMuMDAwMDAwMDAwIC0wNTAwCkBAIC0xMCw2ICsxMCw3
IEBACiAjaW5jbHVkZSA8bGludXgvaW5pdC5oPgogI2luY2x1ZGUgPGxpbnV4L3N0cmluZ2lmeS5o
PgogI2luY2x1ZGUgPGxpbnV4L3NlY3VyaXR5Lmg+CisjaW5jbHVkZSA8bGludXgvaW50ZXJwLmg+
CiAjaW5jbHVkZSA8YXNtL3Byb3RvLmg+CiAjaW5jbHVkZSA8YXNtL3RsYmZsdXNoLmg+CiAjaW5j
bHVkZSA8YXNtL2lhMzJfdW5pc3RkLmg+CkBAIC03NSw2ICs3NiwxMiBAQAogCXJldHVybiAwOwog
fQogCitpbnQgYXJjaF9zZXR1cF9hZGRpdGlvbmFsX3BhZ2VzKHN0cnVjdCBsaW51eF9iaW5wcm0g
KmJwcm0sIGludCBleHN0YWNrKQoreworCXJldHVybiBzeXNjYWxsMzJfc2V0dXBfcGFnZXMoc3Ry
dWN0IGxpbnV4X2JpbnBybSAqYnBybSwgaW50IGV4c3RhY2spOworfQorRVhQT1JUX1NZTUJPTChh
cmNoX3NldHVwX2FkZGl0aW9uYWxfcGFnZXMpOworCiBzdGF0aWMgaW50IF9faW5pdCBpbml0X3N5
c2NhbGwzMih2b2lkKQogeyAKIAlzeXNjYWxsMzJfcGFnZSA9ICh2b2lkICopZ2V0X3plcm9lZF9w
YWdlKEdGUF9LRVJORUwpOyAKZGlmZiAtdXJOIC0tZXhjbHVkZT0nY3Njb3BlKicgLS1leGNsdWRl
PScqZ2l0KicgLS1leGNsdWRlPScqLltzU29PXScgLS1leGNsdWRlPScqLmd6JyBsaW51eC0yLjYt
dXMvYXJjaC94ODZfNjQvS2NvbmZpZyBsaW51eC0yLjYtd2svYXJjaC94ODZfNjQvS2NvbmZpZwot
LS0gbGludXgtMi42LXVzL2FyY2gveDg2XzY0L0tjb25maWcJMjAwNy0wMS0yNiAxODo0OTozNy4w
MDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi13ay9hcmNoL3g4Nl82NC9LY29uZmlnCTIwMDct
MDEtMjYgMTg6NTk6MjYuMDAwMDAwMDAwIC0wNTAwCkBAIC0zOTgsNiArMzk4LDExIEBACiAJZGVm
X2Jvb2wgeQogCWRlcGVuZHMgb24gTlVNQQogCitjb25maWcgQVJDSF9IQVNfU0VUVVBfQURESVRJ
T05BTF9QQUdFUworICAgICAgIGJvb2wKKyAgICAgICBkZWZhdWx0IHkKKyAgICAgICBkZXBlbmRz
IG9uIFg4Nl82NAorCiBjb25maWcgT1VUX09GX0xJTkVfUEZOX1RPX1BBR0UKIAlkZWZfYm9vbCB5
CiAJZGVwZW5kcyBvbiBESVNDT05USUdNRU0KZGlmZiAtdXJOIC0tZXhjbHVkZT0nY3Njb3BlKicg
LS1leGNsdWRlPScqZ2l0KicgLS1leGNsdWRlPScqLltzU29PXScgLS1leGNsdWRlPScqLmd6JyBs
aW51eC0yLjYtdXMvZnMvYmluZm10X2FvdXQuYyBsaW51eC0yLjYtd2svZnMvYmluZm10X2FvdXQu
YwotLS0gbGludXgtMi42LXVzL2ZzL2JpbmZtdF9hb3V0LmMJMjAwNy0wMS0yNiAxODo0OTozOS4w
MDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi13ay9mcy9iaW5mbXRfYW91dC5jCTIwMDctMDEt
MjcgMTI6MjI6NDguMDAwMDAwMDAwIC0wNTAwCkBAIC0yMiw2ICsyMiw3IEBACiAjaW5jbHVkZSA8
bGludXgvdXNlci5oPgogI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KICNpbmNsdWRlIDxsaW51eC9i
aW5mbXRzLmg+CisjaW5jbHVkZSA8bGludXgvaW50ZXJwLmg+CiAjaW5jbHVkZSA8bGludXgvcGVy
c29uYWxpdHkuaD4KICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+CiAKQEAgLTI2OSw3ICsyNzAsNyBA
QAogCXVuc2lnbmVkIGxvbmcgZmRfb2Zmc2V0OwogCXVuc2lnbmVkIGxvbmcgcmxpbTsKIAlpbnQg
cmV0dmFsOwotCisJaW50IGV4ZWN1dGFibGVfc3RhY2sgPSBFWFNUQUNLX0RFRkFVTFQ7CiAJZXgg
PSAqKChzdHJ1Y3QgZXhlYyAqKSBicHJtLT5idWYpOwkJLyogZXhlYy1oZWFkZXIgKi8KIAlpZiAo
KE5fTUFHSUMoZXgpICE9IFpNQUdJQyAmJiBOX01BR0lDKGV4KSAhPSBPTUFHSUMgJiYKIAkgICAg
IE5fTUFHSUMoZXgpICE9IFFNQUdJQyAmJiBOX01BR0lDKGV4KSAhPSBOTUFHSUMpIHx8CkBAIC00
MzIsNiArNDMzLDEyIEBACiAJfQogYmV5b25kX2lmOgogCXNldF9iaW5mbXQoJmFvdXRfZm9ybWF0
KTsKKwkKKwlyZXR2YWwgPSBhcmNoX3NldHVwX2FkZGl0aW9uYWxfcGFnZXMoYnBybSwgZXhlY3V0
YWJsZV9zdGFjayk7CisgICAgICAgIGlmIChyZXR2YWwgPCAwKSB7CisgICAgICAgICAgICAgICAg
c2VuZF9zaWcoU0lHS0lMTCwgY3VycmVudCwgMCk7CisgICAgICAgICAgICAgICAgcmV0dXJuIHJl
dHZhbDsKKyAgICAgICAgfQogCiAJcmV0dmFsID0gc2V0X2JyayhjdXJyZW50LT5tbS0+c3RhcnRf
YnJrLCBjdXJyZW50LT5tbS0+YnJrKTsKIAlpZiAocmV0dmFsIDwgMCkgewpkaWZmIC11ck4gLS1l
eGNsdWRlPSdjc2NvcGUqJyAtLWV4Y2x1ZGU9JypnaXQqJyAtLWV4Y2x1ZGU9JyouW3NTb09dJyAt
LWV4Y2x1ZGU9JyouZ3onIGxpbnV4LTIuNi11cy9mcy9iaW5mbXRfZWxmLmMgbGludXgtMi42LXdr
L2ZzL2JpbmZtdF9lbGYuYwotLS0gbGludXgtMi42LXVzL2ZzL2JpbmZtdF9lbGYuYwkyMDA3LTAx
LTI2IDE4OjQ5OjM5LjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LXdrL2ZzL2JpbmZtdF9l
bGYuYwkyMDA3LTAxLTI3IDExOjA5OjQ4LjAwMDAwMDAwMCAtMDUwMApAQCAtMzgsNiArMzgsNyBA
QAogI2luY2x1ZGUgPGxpbnV4L3NlY3VyaXR5Lmg+CiAjaW5jbHVkZSA8bGludXgvc3lzY2FsbHMu
aD4KICNpbmNsdWRlIDxsaW51eC9yYW5kb20uaD4KKyNpbmNsdWRlIDxsaW51eC9pbnRlcnAuaD4K
ICNpbmNsdWRlIDxsaW51eC9lbGYuaD4KICNpbmNsdWRlIDxhc20vdWFjY2Vzcy5oPgogI2luY2x1
ZGUgPGFzbS9wYXJhbS5oPgpAQCAtOTY1LDEzICs5NjYsMTEgQEAKIAogCXNldF9iaW5mbXQoJmVs
Zl9mb3JtYXQpOwogCi0jaWZkZWYgQVJDSF9IQVNfU0VUVVBfQURESVRJT05BTF9QQUdFUwogCXJl
dHZhbCA9IGFyY2hfc2V0dXBfYWRkaXRpb25hbF9wYWdlcyhicHJtLCBleGVjdXRhYmxlX3N0YWNr
KTsKIAlpZiAocmV0dmFsIDwgMCkgewogCQlzZW5kX3NpZyhTSUdLSUxMLCBjdXJyZW50LCAwKTsK
IAkJZ290byBvdXQ7CiAJfQotI2VuZGlmIC8qIEFSQ0hfSEFTX1NFVFVQX0FERElUSU9OQUxfUEFH
RVMgKi8KIAogCWNvbXB1dGVfY3JlZHMoYnBybSk7CiAJY3VycmVudC0+ZmxhZ3MgJj0gflBGX0ZP
UktOT0VYRUM7CmRpZmYgLXVyTiAtLWV4Y2x1ZGU9J2NzY29wZSonIC0tZXhjbHVkZT0nKmdpdCon
IC0tZXhjbHVkZT0nKi5bc1NvT10nIC0tZXhjbHVkZT0nKi5neicgbGludXgtMi42LXVzL2luY2x1
ZGUvYXNtLWkzODYvZWxmLmggbGludXgtMi42LXdrL2luY2x1ZGUvYXNtLWkzODYvZWxmLmgKLS0t
IGxpbnV4LTIuNi11cy9pbmNsdWRlL2FzbS1pMzg2L2VsZi5oCTIwMDctMDEtMjYgMTg6NDk6NDAu
MDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYtd2svaW5jbHVkZS9hc20taTM4Ni9lbGYuaAky
MDA3LTAxLTI3IDEyOjI0OjM1LjAwMDAwMDAwMCAtMDUwMApAQCAtMTU2LDExICsxNTYsNiBAQAog
CiAjZGVmaW5lIFZEU09fRU5UUlkJCVZEU09fU1lNKCZfX2tlcm5lbF92c3lzY2FsbCkKIAotI2Rl
ZmluZSBBUkNIX0hBU19TRVRVUF9BRERJVElPTkFMX1BBR0VTCi1zdHJ1Y3QgbGludXhfYmlucHJt
OwotZXh0ZXJuIGludCBhcmNoX3NldHVwX2FkZGl0aW9uYWxfcGFnZXMoc3RydWN0IGxpbnV4X2Jp
bnBybSAqYnBybSwKLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCBl
eGVjdXRhYmxlX3N0YWNrKTsKLQogZXh0ZXJuIHVuc2lnbmVkIGludCB2ZHNvX2VuYWJsZWQ7CiAK
ICNkZWZpbmUgQVJDSF9ETElORk8JCQkJCQlcCmRpZmYgLXVyTiAtLWV4Y2x1ZGU9J2NzY29wZSon
IC0tZXhjbHVkZT0nKmdpdConIC0tZXhjbHVkZT0nKi5bc1NvT10nIC0tZXhjbHVkZT0nKi5neicg
bGludXgtMi42LXVzL2luY2x1ZGUvYXNtLXBvd2VycGMvZWxmLmggbGludXgtMi42LXdrL2luY2x1
ZGUvYXNtLXBvd2VycGMvZWxmLmgKLS0tIGxpbnV4LTIuNi11cy9pbmNsdWRlL2FzbS1wb3dlcnBj
L2VsZi5oCTIwMDctMDEtMjYgMTg6NDk6NDAuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYt
d2svaW5jbHVkZS9hc20tcG93ZXJwYy9lbGYuaAkyMDA3LTAxLTI3IDEyOjI0OjUxLjAwMDAwMDAw
MCAtMDUwMApAQCAtMjY2LDExICsyNjYsNiBAQAogZXh0ZXJuIGludCBpY2FjaGVfYnNpemU7CiBl
eHRlcm4gaW50IHVjYWNoZV9ic2l6ZTsKIAotLyogdkRTTyBoYXMgYXJjaF9zZXR1cF9hZGRpdGlv
bmFsX3BhZ2VzICovCi0jZGVmaW5lIEFSQ0hfSEFTX1NFVFVQX0FERElUSU9OQUxfUEFHRVMKLXN0
cnVjdCBsaW51eF9iaW5wcm07Ci1leHRlcm4gaW50IGFyY2hfc2V0dXBfYWRkaXRpb25hbF9wYWdl
cyhzdHJ1Y3QgbGludXhfYmlucHJtICpicHJtLAotCQkJCSAgICAgICBpbnQgZXhlY3V0YWJsZV9z
dGFjayk7CiAjZGVmaW5lIFZEU09fQVVYX0VOVChhLGIpIE5FV19BVVhfRU5UKGEsYik7CiAKIC8q
CmRpZmYgLXVyTiAtLWV4Y2x1ZGU9J2NzY29wZSonIC0tZXhjbHVkZT0nKmdpdConIC0tZXhjbHVk
ZT0nKi5bc1NvT10nIC0tZXhjbHVkZT0nKi5neicgbGludXgtMi42LXVzL2luY2x1ZGUvYXNtLXNo
L2VsZi5oIGxpbnV4LTIuNi13ay9pbmNsdWRlL2FzbS1zaC9lbGYuaAotLS0gbGludXgtMi42LXVz
L2luY2x1ZGUvYXNtLXNoL2VsZi5oCTIwMDctMDEtMjYgMTg6NDk6NDAuMDAwMDAwMDAwIC0wNTAw
CisrKyBsaW51eC0yLjYtd2svaW5jbHVkZS9hc20tc2gvZWxmLmgJMjAwNy0wMS0yNyAxMjoyNTow
Ny4wMDAwMDAwMDAgLTA1MDAKQEAgLTEyMSwxMiArMTIxLDYgQEAKICNlbmRpZgogCiAjaWZkZWYg
Q09ORklHX1ZTWVNDQUxMCi0vKiB2RFNPIGhhcyBhcmNoX3NldHVwX2FkZGl0aW9uYWxfcGFnZXMg
Ki8KLSNkZWZpbmUgQVJDSF9IQVNfU0VUVVBfQURESVRJT05BTF9QQUdFUwotc3RydWN0IGxpbnV4
X2JpbnBybTsKLWV4dGVybiBpbnQgYXJjaF9zZXR1cF9hZGRpdGlvbmFsX3BhZ2VzKHN0cnVjdCBs
aW51eF9iaW5wcm0gKmJwcm0sCi0JCQkJICAgICAgIGludCBleGVjdXRhYmxlX3N0YWNrKTsKLQog
ZXh0ZXJuIHVuc2lnbmVkIGludCB2ZHNvX2VuYWJsZWQ7CiBleHRlcm4gdm9pZCBfX2tlcm5lbF92
c3lzY2FsbDsKIApkaWZmIC11ck4gLS1leGNsdWRlPSdjc2NvcGUqJyAtLWV4Y2x1ZGU9JypnaXQq
JyAtLWV4Y2x1ZGU9JyouW3NTb09dJyAtLWV4Y2x1ZGU9JyouZ3onIGxpbnV4LTIuNi11cy9pbmNs
dWRlL2xpbnV4L2ludGVycC5oIGxpbnV4LTIuNi13ay9pbmNsdWRlL2xpbnV4L2ludGVycC5oCi0t
LSBsaW51eC0yLjYtdXMvaW5jbHVkZS9saW51eC9pbnRlcnAuaAkxOTY5LTEyLTMxIDE5OjAwOjAw
LjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LXdrL2luY2x1ZGUvbGludXgvaW50ZXJwLmgJ
MjAwNy0wMS0yNyAxMjoxMzo0NC4wMDAwMDAwMDAgLTA1MDAKQEAgLTAsMCArMSwxNyBAQAorLyog
aW50ZXJwLmggKi8KKyNpZm5kZWYgX0xJTlVYX0lOVEVSUF9ICisjZGVmaW5lIF9MSU5VWF9JTlRF
UlBfSAorCitzdHJ1Y3QgbGludXhfYmlucHJtOworI2lmZGVmIENPTkZJR19BUkNIX0hBU19TRVRV
UF9BRERJVElPTkFMX1BBR0VTCitleHRlcm4gaW50IGFyY2hfc2V0dXBfYWRkaXRpb25hbF9wYWdl
cyhzdHJ1Y3QgbGludXhfYmlucHJtICpicHJtLAorCQkJCQlpbnQgZXhlY3V0YWJsZV9zdGFjayk7
CisjZWxzZQorc3RhdGljIGlubGluZSBpbnQgYXJjaF9zZXR1cF9hZGRpdGlvbmFsX3BhZ2VzKHN0
cnVjdCBsaW51eF9iaW5wcm0gKmJwcm0sCisJCQkJaW50IGV4ZWN1dGFibGVfc3RhY2spCit7CisJ
cmV0dXJuIDA7Cit9CisjZW5kaWYKKworI2VuZGlmIC8qIGludGVycC5oICovCg==
------=_Part_57818_5454779.1169928111992--
