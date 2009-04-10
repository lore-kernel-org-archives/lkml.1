Return-Path: <linux-kernel-owner+w=401wt.eu-S937597AbZDJClq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937597AbZDJClq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935630AbZDJChi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:37:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:37894 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935537AbZDJChg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:37:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MYCmVjg29BwKyuDRmxzMFo5EijXQNndfRHVkZruoFv7Vat8uNb6bpL7Y6v0DxWxxyD
         1dSHgTLJo8AMPJLVQVfYaa4kMadYreI42RYD9mOJSilEiyKpZ1AXdDydodfTR/bjUmO0
         M5OeaCmJZnkwe/78/w/+wBzZr0YRwTaZ4BIdc=
Date: Fri, 10 Apr 2009 06:37:39 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 17/30] cr: extend arch_setup_additional_pages()
Message-ID: <20090410023739.GR27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "start" argument, it will be used to map vDSO to exactly same place
on restart(2).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/powerpc/include/asm/elf.h     |    1 +
 arch/powerpc/kernel/vdso.c         |    2 +-
 arch/s390/include/asm/elf.h        |    2 +-
 arch/s390/kernel/vdso.c            |    2 +-
 arch/sh/include/asm/elf.h          |    1 +
 arch/sh/kernel/vsyscall/vsyscall.c |    2 +-
 arch/x86/include/asm/elf.h         |    3 ++-
 arch/x86/vdso/vdso32-setup.c       |    2 +-
 fs/binfmt_elf.c                    |    2 +-
 9 files changed, 10 insertions(+), 7 deletions(-)

--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -269,6 +269,7 @@ extern int ucache_bsize;
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
 struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+				       unsigned long start,
 				       int uses_interp);
 #define VDSO_AUX_ENT(a,b) NEW_AUX_ENT(a,b);
 
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -184,7 +184,7 @@ static void dump_vdso_pages(struct vm_area_struct * vma)
  * This is called from binfmt_elf, we create the special vma for the
  * vDSO and insert it into the mm struct tree
  */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm, unsigned long start, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	struct page **vdso_pagelist;
--- a/arch/s390/include/asm/elf.h
+++ b/arch/s390/include/asm/elf.h
@@ -205,6 +205,6 @@ do {									    \
 struct linux_binprm;
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
-int arch_setup_additional_pages(struct linux_binprm *, int);
+int arch_setup_additional_pages(struct linux_binprm *, unsigned long, int);
 
 #endif
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -182,7 +182,7 @@ static void vdso_init_cr5(void)
  * This is called from binfmt_elf, we create the special vma for the
  * vDSO and insert it into the mm struct tree
  */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm, unsigned long start, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	struct page **vdso_pagelist;
--- a/arch/sh/include/asm/elf.h
+++ b/arch/sh/include/asm/elf.h
@@ -202,6 +202,7 @@ do {									\
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
 struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+				       unsigned long start,
 				       int uses_interp);
 
 extern unsigned int vdso_enabled;
--- a/arch/sh/kernel/vsyscall/vsyscall.c
+++ b/arch/sh/kernel/vsyscall/vsyscall.c
@@ -59,7 +59,7 @@ int __init vsyscall_init(void)
 }
 
 /* Setup a VMA at program startup for the vsyscall page */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm, unsigned long start, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -336,9 +336,10 @@ struct linux_binprm;
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+				       unsigned long start,
 				       int uses_interp);
 
-extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
+extern int syscall32_setup_pages(struct linux_binprm *, unsigned long start, int exstack);
 #define compat_arch_setup_additional_pages	syscall32_setup_pages
 
 extern unsigned long arch_randomize_brk(struct mm_struct *mm);
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -310,7 +310,7 @@ int __init sysenter_setup(void)
 }
 
 /* Setup a VMA at program startup for the vsyscall page */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm, unsigned long start, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -945,7 +945,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	set_binfmt(&elf_format);
 
 #ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
-	retval = arch_setup_additional_pages(bprm, !!elf_interpreter);
+	retval = arch_setup_additional_pages(bprm, 0, !!elf_interpreter);
 	if (retval < 0) {
 		send_sig(SIGKILL, current, 0);
 		goto out;
