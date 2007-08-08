Return-Path: <linux-kernel-owner+w=401wt.eu-S933807AbXHHOC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807AbXHHOC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbXHHOCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:02:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:41898 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754217AbXHHOCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:02:15 -0400
Date: Wed, 8 Aug 2007 16:03:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ulrich Kunitz <kune@deine-taler.de>, Bret Towe <magnade@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [RESEND] PIE executable randomization
Message-ID: <Pine.LNX.4.64.0708081552010.11054@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

below is a respin of the patch for executable code address randomization 
of PIE binaries, which already went through -mm into 2.6.22, but then got 
reverted because of bugreports stating that klibc binaries segfault due to 
this patch. However it turned out that this was bug in klibc 1.4 which has 
already been fixed in klibc 1.5 [1].

I have rebased the patch against 2.6.23-rc1-mm2 and fixed a BAD_ADDR 
macro, which was wrong in the original patch and fix for which was 
probably missed [2].

[1] http://lkml.org/lkml/2007/8/2/359
[2] http://lkml.org/lkml/2007/7/7/50

=======

This patch is using mmap()'s randomization functionality in such a way 
that it maps the main executable of (specially compiled/linked -pie/-fpie) 
ET_DYN binaries onto a random address (in cases in which mmap() is allowed 
to perform a randomization).

The code has been extraced from Ingo's exec-shield patch 
http://people.redhat.com/mingo/exec-shield/

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: Bret Towe <magnade@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

 arch/ia64/ia32/binfmt_elf32.c |    2 +-
 fs/binfmt_elf.c               |  107 ++++++++++++++++++++++++++++++++--------
 2 files changed, 86 insertions(+), 23 deletions(-)

diff --git a/arch/ia64/ia32/binfmt_elf32.c b/arch/ia64/ia32/binfmt_elf32.c
index f6ae3ec..3db699b 100644
--- a/arch/ia64/ia32/binfmt_elf32.c
+++ b/arch/ia64/ia32/binfmt_elf32.c
@@ -226,7 +226,7 @@ elf32_set_personality (void)
 }
 
 static unsigned long
-elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type)
+elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type, unsigned long unused)
 {
 	unsigned long pgoff = (eppnt->p_vaddr) & ~IA32_PAGE_MASK;
 
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index e45c60b..8c4b7fa 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -45,7 +45,7 @@
 
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
-static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int);
+static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);
 
 /*
  * If we don't support core dumping, then supply a NULL so we
@@ -295,33 +295,70 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 #ifndef elf_map
 
 static unsigned long elf_map(struct file *filep, unsigned long addr,
-		struct elf_phdr *eppnt, int prot, int type)
+		struct elf_phdr *eppnt, int prot, int type,
+		unsigned long total_size)
 {
 	unsigned long map_addr;
-	unsigned long pageoffset = ELF_PAGEOFFSET(eppnt->p_vaddr);
+	unsigned long size = eppnt->p_filesz + ELF_PAGEOFFSET(eppnt->p_vaddr);
+	unsigned long off = eppnt->p_offset - ELF_PAGEOFFSET(eppnt->p_vaddr);
+	addr = ELF_PAGESTART(addr);
+	size = ELF_PAGEALIGN(size);
 
-	down_write(&current->mm->mmap_sem);
 	/* mmap() will return -EINVAL if given a zero size, but a
 	 * segment with zero filesize is perfectly valid */
-	if (eppnt->p_filesz + pageoffset)
-		map_addr = do_mmap(filep, ELF_PAGESTART(addr),
-				   eppnt->p_filesz + pageoffset, prot, type,
-				   eppnt->p_offset - pageoffset);
-	else
-		map_addr = ELF_PAGESTART(addr);
+	if (!size)
+		return addr;
+
+	down_write(&current->mm->mmap_sem);
+	/*
+	* total_size is the size of the ELF (interpreter) image.
+	* The _first_ mmap needs to know the full size, otherwise
+	* randomization might put this image into an overlapping
+	* position with the ELF binary image. (since size < total_size)
+	* So we first map the 'big' image - and unmap the remainder at
+	* the end. (which unmap is needed for ELF images with holes.)
+	*/
+	if (total_size) {
+		total_size = ELF_PAGEALIGN(total_size);
+		map_addr = do_mmap(filep, addr, total_size, prot, type, off);
+		if (!BAD_ADDR(map_addr))
+			do_munmap(current->mm, map_addr+size, total_size-size);
+	} else
+		map_addr = do_mmap(filep, addr, size, prot, type, off);
+
 	up_write(&current->mm->mmap_sem);
 	return(map_addr);
 }
 
 #endif /* !elf_map */
 
+static unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
+{
+	int i, first_idx = -1, last_idx = -1;
+
+	for (i = 0; i < nr; i++) {
+		if (cmds[i].p_type == PT_LOAD) {
+			last_idx = i;
+			if (first_idx == -1)
+				first_idx = i;
+		}
+	}
+	if (first_idx == -1)
+		return 0;
+
+	return cmds[last_idx].p_vaddr + cmds[last_idx].p_memsz -
+				ELF_PAGESTART(cmds[first_idx].p_vaddr);
+}
+
+
 /* This is much more generalized than the library routine read function,
    so we keep this separate.  Technically the library read function
    is only provided so that we can read a.out libraries that have
    an ELF header */
 
 static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
-		struct file *interpreter, unsigned long *interp_load_addr)
+		struct file *interpreter, unsigned long *interp_map_addr,
+		unsigned long no_base)
 {
 	struct elf_phdr *elf_phdata;
 	struct elf_phdr *eppnt;
@@ -329,6 +366,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 	int load_addr_set = 0;
 	unsigned long last_bss = 0, elf_bss = 0;
 	unsigned long error = ~0UL;
+	unsigned long total_size;
 	int retval, i, size;
 
 	/* First of all, some simple consistency checks */
@@ -367,6 +405,12 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 		goto out_close;
 	}
 
+	total_size = total_mapping_size(elf_phdata, interp_elf_ex->e_phnum);
+	if (!total_size) {
+		error = -EINVAL;
+		goto out_close;
+	}
+
 	eppnt = elf_phdata;
 	for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
 		if (eppnt->p_type == PT_LOAD) {
@@ -384,9 +428,14 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 			vaddr = eppnt->p_vaddr;
 			if (interp_elf_ex->e_type == ET_EXEC || load_addr_set)
 				elf_type |= MAP_FIXED;
+			else if (no_base && interp_elf_ex->e_type == ET_DYN)
+				load_addr = -vaddr;
 
 			map_addr = elf_map(interpreter, load_addr + vaddr,
-					   eppnt, elf_prot, elf_type);
+					   eppnt, elf_prot, elf_type, total_size);
+			total_size = 0;
+			if (!*interp_map_addr)
+				*interp_map_addr = map_addr;
 			error = map_addr;
 			if (BAD_ADDR(map_addr))
 				goto out_close;
@@ -452,8 +501,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 			goto out_close;
 	}
 
-	*interp_load_addr = load_addr;
-	error = ((unsigned long)interp_elf_ex->e_entry) + load_addr;
+	error = load_addr;
 
 out_close:
 	kfree(elf_phdata);
@@ -550,7 +598,8 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	int elf_exec_fileno;
 	int retval, i;
 	unsigned int size;
-	unsigned long elf_entry, interp_load_addr = 0;
+	unsigned long elf_entry;
+	unsigned long interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long reloc_func_desc = 0;
 	char passed_fileno[6];
@@ -814,9 +863,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->start_stack = bprm->p;
 
 	/* Now we do a little grungy work by mmaping the ELF image into
-	   the correct location in memory.  At this point, we assume that
-	   the image should be loaded at fixed address, not at a variable
-	   address. */
+	   the correct location in memory. */
 	for(i = 0, elf_ppnt = elf_phdata;
 	    i < loc->elf_ex.e_phnum; i++, elf_ppnt++) {
 		int elf_prot = 0, elf_flags;
@@ -870,11 +917,15 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
+#ifdef CONFIG_X86
+			load_bias = 0;
+#else
 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
+#endif
 		}
 
 		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
-				elf_prot, elf_flags);
+				elf_prot, elf_flags,0);
 		if (BAD_ADDR(error)) {
 			send_sig(SIGKILL, current, 0);
 			retval = IS_ERR((void *)error) ?
@@ -950,13 +1001,25 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT)
+		if (interpreter_type == INTERPRETER_AOUT) {
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
-		else
+		} else {
+			unsigned long interp_map_addr;	/* unused */
+
 			elf_entry = load_elf_interp(&loc->interp_elf_ex,
 						    interpreter,
-						    &interp_load_addr);
+						    &interp_map_addr,
+						    load_bias);
+			if (!IS_ERR((void *)elf_entry)) {
+				/*
+				 * load_elf_interp() returns relocation
+				 * adjustment
+				 */
+				interp_load_addr = elf_entry;
+				elf_entry += loc->interp_elf_ex.e_entry;
+			}
+		}
 		if (BAD_ADDR(elf_entry)) {
 			force_sig(SIGSEGV, current);
 			retval = IS_ERR((void *)elf_entry) ?
