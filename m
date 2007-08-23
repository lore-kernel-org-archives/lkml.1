Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbXHWG6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbXHWG6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 02:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbXHWG6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 02:58:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbXHWG6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 02:58:31 -0400
Date: Wed, 22 Aug 2007 23:57:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: 2.6.23-rc3-mm1 - memory layout change?  - lost support for
 MAP_32BIT? - mono crashes
Message-Id: <20070822235756.e4f44c8d.akpm@linux-foundation.org>
In-Reply-To: <1187834905.190825.16.camel@localhost>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<1187834905.190825.16.camel@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 20:08:25 -0600 Zan Lynx <zlynx@acm.org> wrote:

> On Wed, 2007-08-22 at 02:06 -0700, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> 
> After installing this new wonder kernel on my AMD-64 laptop, I
> discovered that Beagle wouldn't start.  While enjoying how fast my
> system felt ( :) ) I also discovered that Evolution wouldn't start
> because it was built with mono integration.
> 
> Can't live without email, so I poked at it and discovered that if I run
> mono applications (including Evolution) with the legacy memory layout,
> they work.
> 
> Like this: setarch x86_64 -L evolution
> 
> This didn't happen on -rc2-mm2, so I think somebody changed something.
> Mono claims to mmap with the MAP_32BIT option.
> 
> In -rc3-mm1 strace shows mono's mmap like this:
> mmap(NULL, 65536, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS|MAP_32BIT, -1, 0) = 0x7fa21f5cb000
> 
> It's got MAP_32BIT, but that's not a 32-bit address...

Thanks, it helps.

I'm thinking unkind thoughts about pie-executable-randomization.patch.

Below is a patch which removes

pie-executable-randomization.patch
pie-executable-randomization-fix.patch
pie-executable-randomization-fix-2.patch

from 2.6.23-rc3-mm1.  'twould be great if you could see if that fixes
things, thanks.


 arch/ia64/ia32/binfmt_elf32.c |    2 
 arch/x86_64/mm/mmap.c         |  107 ++++----------------------------
 fs/binfmt_elf.c               |  107 ++++++--------------------------
 3 files changed, 38 insertions(+), 178 deletions(-)

diff -puN fs/binfmt_elf.c~revert-pie-executable-randomization fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~revert-pie-executable-randomization
+++ a/fs/binfmt_elf.c
@@ -45,7 +45,7 @@
 
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
-static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);
+static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int);
 
 /*
  * If we don't support core dumping, then supply a NULL so we
@@ -295,70 +295,33 @@ create_elf_tables(struct linux_binprm *b
 #ifndef elf_map
 
 static unsigned long elf_map(struct file *filep, unsigned long addr,
-		struct elf_phdr *eppnt, int prot, int type,
-		unsigned long total_size)
+		struct elf_phdr *eppnt, int prot, int type)
 {
 	unsigned long map_addr;
-	unsigned long size = eppnt->p_filesz + ELF_PAGEOFFSET(eppnt->p_vaddr);
-	unsigned long off = eppnt->p_offset - ELF_PAGEOFFSET(eppnt->p_vaddr);
-	addr = ELF_PAGESTART(addr);
-	size = ELF_PAGEALIGN(size);
+	unsigned long pageoffset = ELF_PAGEOFFSET(eppnt->p_vaddr);
 
+	down_write(&current->mm->mmap_sem);
 	/* mmap() will return -EINVAL if given a zero size, but a
 	 * segment with zero filesize is perfectly valid */
-	if (!size)
-		return addr;
-
-	down_write(&current->mm->mmap_sem);
-	/*
-	* total_size is the size of the ELF (interpreter) image.
-	* The _first_ mmap needs to know the full size, otherwise
-	* randomization might put this image into an overlapping
-	* position with the ELF binary image. (since size < total_size)
-	* So we first map the 'big' image - and unmap the remainder at
-	* the end. (which unmap is needed for ELF images with holes.)
-	*/
-	if (total_size) {
-		total_size = ELF_PAGEALIGN(total_size);
-		map_addr = do_mmap(filep, addr, total_size, prot, type, off);
-		if (!BAD_ADDR(map_addr))
-			do_munmap(current->mm, map_addr+size, total_size-size);
-	} else
-		map_addr = do_mmap(filep, addr, size, prot, type, off);
-
+	if (eppnt->p_filesz + pageoffset)
+		map_addr = do_mmap(filep, ELF_PAGESTART(addr),
+				   eppnt->p_filesz + pageoffset, prot, type,
+				   eppnt->p_offset - pageoffset);
+	else
+		map_addr = ELF_PAGESTART(addr);
 	up_write(&current->mm->mmap_sem);
 	return(map_addr);
 }
 
 #endif /* !elf_map */
 
-static unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
-{
-	int i, first_idx = -1, last_idx = -1;
-
-	for (i = 0; i < nr; i++) {
-		if (cmds[i].p_type == PT_LOAD) {
-			last_idx = i;
-			if (first_idx == -1)
-				first_idx = i;
-		}
-	}
-	if (first_idx == -1)
-		return 0;
-
-	return cmds[last_idx].p_vaddr + cmds[last_idx].p_memsz -
-				ELF_PAGESTART(cmds[first_idx].p_vaddr);
-}
-
-
 /* This is much more generalized than the library routine read function,
    so we keep this separate.  Technically the library read function
    is only provided so that we can read a.out libraries that have
    an ELF header */
 
 static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
-		struct file *interpreter, unsigned long *interp_map_addr,
-		unsigned long no_base)
+		struct file *interpreter, unsigned long *interp_load_addr)
 {
 	struct elf_phdr *elf_phdata;
 	struct elf_phdr *eppnt;
@@ -366,7 +329,6 @@ static unsigned long load_elf_interp(str
 	int load_addr_set = 0;
 	unsigned long last_bss = 0, elf_bss = 0;
 	unsigned long error = ~0UL;
-	unsigned long total_size;
 	int retval, i, size;
 
 	/* First of all, some simple consistency checks */
@@ -405,12 +367,6 @@ static unsigned long load_elf_interp(str
 		goto out_close;
 	}
 
-	total_size = total_mapping_size(elf_phdata, interp_elf_ex->e_phnum);
-	if (!total_size) {
-		error = -EINVAL;
-		goto out_close;
-	}
-
 	eppnt = elf_phdata;
 	for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
 		if (eppnt->p_type == PT_LOAD) {
@@ -428,14 +384,9 @@ static unsigned long load_elf_interp(str
 			vaddr = eppnt->p_vaddr;
 			if (interp_elf_ex->e_type == ET_EXEC || load_addr_set)
 				elf_type |= MAP_FIXED;
-			else if (no_base && interp_elf_ex->e_type == ET_DYN)
-				load_addr = -vaddr;
 
 			map_addr = elf_map(interpreter, load_addr + vaddr,
-					   eppnt, elf_prot, elf_type, total_size);
-			total_size = 0;
-			if (!*interp_map_addr)
-				*interp_map_addr = map_addr;
+					   eppnt, elf_prot, elf_type);
 			error = map_addr;
 			if (BAD_ADDR(map_addr))
 				goto out_close;
@@ -501,7 +452,8 @@ static unsigned long load_elf_interp(str
 			goto out_close;
 	}
 
-	error = load_addr;
+	*interp_load_addr = load_addr;
+	error = ((unsigned long)interp_elf_ex->e_entry) + load_addr;
 
 out_close:
 	kfree(elf_phdata);
@@ -598,8 +550,7 @@ static int load_elf_binary(struct linux_
 	int elf_exec_fileno;
 	int retval, i;
 	unsigned int size;
-	unsigned long elf_entry;
-	unsigned long interp_load_addr = 0;
+	unsigned long elf_entry, interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long reloc_func_desc = 0;
 	char passed_fileno[6];
@@ -871,7 +822,9 @@ static int load_elf_binary(struct linux_
 	current->mm->start_stack = bprm->p;
 
 	/* Now we do a little grungy work by mmaping the ELF image into
-	   the correct location in memory. */
+	   the correct location in memory.  At this point, we assume that
+	   the image should be loaded at fixed address, not at a variable
+	   address. */
 	for(i = 0, elf_ppnt = elf_phdata;
 	    i < loc->elf_ex.e_phnum; i++, elf_ppnt++) {
 		int elf_prot = 0, elf_flags;
@@ -925,15 +878,11 @@ static int load_elf_binary(struct linux_
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
-#ifdef CONFIG_X86
-			load_bias = 0;
-#else
 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
-#endif
 		}
 
 		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
-				elf_prot, elf_flags,0);
+				elf_prot, elf_flags);
 		if (BAD_ADDR(error)) {
 			send_sig(SIGKILL, current, 0);
 			retval = IS_ERR((void *)error) ?
@@ -1009,25 +958,13 @@ static int load_elf_binary(struct linux_
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT) {
+		if (interpreter_type == INTERPRETER_AOUT)
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
-		} else {
-			unsigned long uninitialized_var(interp_map_addr);
-
+		else
 			elf_entry = load_elf_interp(&loc->interp_elf_ex,
 						    interpreter,
-						    &interp_map_addr,
-						    load_bias);
-			if (!IS_ERR((void *)elf_entry)) {
-				/*
-				 * load_elf_interp() returns relocation
-				 * adjustment
-				 */
-				interp_load_addr = elf_entry;
-				elf_entry += loc->interp_elf_ex.e_entry;
-			}
-		}
+						    &interp_load_addr);
 		if (BAD_ADDR(elf_entry)) {
 			force_sig(SIGSEGV, current);
 			retval = IS_ERR((void *)elf_entry) ?
diff -puN arch/x86_64/mm/mmap.c~revert-pie-executable-randomization arch/x86_64/mm/mmap.c
--- a/arch/x86_64/mm/mmap.c~revert-pie-executable-randomization
+++ a/arch/x86_64/mm/mmap.c
@@ -1,106 +1,29 @@
-/*
- *  linux/arch/x86-64/mm/mmap.c
- *
- *  flexible mmap layout support
- *
- * Based on code by Ingo Molnar and Andi Kleen, copyrighted
- * as follows:
- *
- * Copyright 2003-2004 Red Hat Inc., Durham, North Carolina.
- * All Rights Reserved.
- * Copyright 2005 Andi Kleen, SuSE Labs.
- * Copyright 2007 Jiri Kosina, SuSE Labs.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
+/* Copyright 2005 Andi Kleen, SuSE Labs.
+ * Licensed under GPL, v.2
  */
-
-#include <linux/personality.h>
 #include <linux/mm.h>
-#include <linux/random.h>
-#include <linux/limits.h>
 #include <linux/sched.h>
+#include <linux/random.h>
 #include <asm/ia32.h>
 
-/*
- * Top of mmap area (just below the process stack).
- *
- * Leave an at least ~128 MB hole.
- */
-#define MIN_GAP (128*1024*1024)
-#define MAX_GAP (TASK_SIZE/6*5)
-
-static inline unsigned long mmap_base(void)
-{
-	unsigned long gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
-
-	if (gap < MIN_GAP)
-		gap = MIN_GAP;
-	else if (gap > MAX_GAP)
-		gap = MAX_GAP;
-
-	return TASK_SIZE - (gap & PAGE_MASK);
-}
+/* Notebook: move the mmap code from sys_x86_64.c over here. */
 
-static inline int mmap_is_legacy(void)
+void arch_pick_mmap_layout(struct mm_struct *mm)
 {
 #ifdef CONFIG_IA32_EMULATION
-	if (test_thread_flag(TIF_IA32))
-		return 1;
+	if (current_thread_info()->flags & _TIF_IA32)
+		return ia32_pick_mmap_layout(mm);
 #endif
-
-	if (current->personality & ADDR_COMPAT_LAYOUT)
-		return 1;
-
-	if (current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY)
-		return 1;
-
-	return sysctl_legacy_va_layout;
-}
-
-/*
- * This function, called very early during the creation of a new
- * process VM image, sets up which VM layout function to use:
- */
-void arch_pick_mmap_layout(struct mm_struct *mm)
-{
-	int rnd = 0;
+	mm->mmap_base = TASK_UNMAPPED_BASE;
 	if (current->flags & PF_RANDOMIZE) {
 		/* Add 28bit randomness which is about 40bits of address space
 		   because mmap base has to be page aligned.
-		   or ~1/128 of the total user VM
-		   (total user address space is 47bits) */
-		rnd = get_random_int() & 0xfffffff;
-	}
-
-	/*
-	 * Fall back to the standard layout if the personality
-	 * bit is set, or if the expected stack growth is unlimited:
-	 */
-	if (mmap_is_legacy()) {
-		mm->mmap_base = TASK_UNMAPPED_BASE;
-		mm->get_unmapped_area = arch_get_unmapped_area;
-		mm->unmap_area = arch_unmap_area;
-	} else {
-		mm->mmap_base = mmap_base();
-		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
-		mm->unmap_area = arch_unmap_area_topdown;
-		if (current->flags & PF_RANDOMIZE)
-			rnd = -rnd;
-	}
-	if (current->flags & PF_RANDOMIZE) {
-		mm->mmap_base += ((long)rnd) << PAGE_SHIFT;
+ 		   or ~1/128 of the total user VM
+	   	   (total user address space is 47bits) */
+		unsigned rnd = get_random_int() & 0xfffffff;
+		mm->mmap_base += ((unsigned long)rnd) << PAGE_SHIFT;
 	}
+	mm->get_unmapped_area = arch_get_unmapped_area;
+	mm->unmap_area = arch_unmap_area;
 }
+
diff -puN arch/ia64/ia32/binfmt_elf32.c~revert-pie-executable-randomization arch/ia64/ia32/binfmt_elf32.c
--- a/arch/ia64/ia32/binfmt_elf32.c~revert-pie-executable-randomization
+++ a/arch/ia64/ia32/binfmt_elf32.c
@@ -226,7 +226,7 @@ elf32_set_personality (void)
 }
 
 static unsigned long
-elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type, unsigned long unused)
+elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type)
 {
 	unsigned long pgoff = (eppnt->p_vaddr) & ~IA32_PAGE_MASK;
 
_

