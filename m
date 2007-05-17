Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbXEQUZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbXEQUZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbXEQUZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:25:08 -0400
Received: from twin.jikos.cz ([213.151.79.26]:36327 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbXEQUZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:25:06 -0400
Date: Thu, 17 May 2007 22:24:11 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: Jiri Kosina <jkosina@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] PIE randomization
In-Reply-To: <Pine.LNX.4.64.0705161851120.25986@twin.jikos.cz>
Message-ID: <alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz>
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz>
 <20070511125629.3df919cf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz>
 <20070511133651.63f8a14d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz>
 <Pine.LNX.4.64.0705161851120.25986@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  sorry for insufficient description in my earlier post. I hope it is better
this time.

Jiri: Thanks for help, I applied your change on my previous patch.

This patch is using mmap()'s randomization functionality in such a way 
that it maps the main executable of (specially compiled/linked -pie/-fpie) 
ET_DYN binaries onto a random address (in cases in which mmap() is allowed 
to perform a randomization).

Origin of this patch is in exec-shield (http://people.redhat.com/mingo/exec-shield/)

Signed-off-by: Jan Kratochvil <honza@jikos.cz>

---
  fs/binfmt_elf.c |   99 ++++++++++++++++++++++++++++++++++++++++++------------
  1 files changed, 77 insertions(+), 22 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fa8ea33..8406f9a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -45,7 +45,7 @@

  static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
  static int load_elf_library(struct file *);
-static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int);
+static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);

  /*
   * If we don't support core dumping, then supply a NULL so we
@@ -80,7 +80,7 @@ static struct linux_binfmt elf_format =
  		.hasvdso	= 1
  };

-#define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
+#define BAD_ADDR(x) ((unsigned long)(x) >= PAGE_MASK)

  static int set_brk(unsigned long start, unsigned long end)
  {
@@ -285,33 +285,70 @@ create_elf_tables(struct linux_binprm *b
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

+static inline unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
+{
+	int i, first_idx = -1, last_idx = -1;
+
+	for (i = 0; i < nr; i++)
+		if (cmds[i].p_type == PT_LOAD) {
+			last_idx = i;
+			if (first_idx == -1)
+				first_idx = i;
+		}
+
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
@@ -319,6 +356,7 @@ static unsigned long load_elf_interp(str
  	int load_addr_set = 0;
  	unsigned long last_bss = 0, elf_bss = 0;
  	unsigned long error = ~0UL;
+	unsigned long total_size;
  	int retval, i, size;

  	/* First of all, some simple consistency checks */
@@ -357,6 +395,10 @@ static unsigned long load_elf_interp(str
  		goto out_close;
  	}

+	total_size = total_mapping_size(elf_phdata, interp_elf_ex->e_phnum);
+	if (!total_size)
+		goto out_close;
+
  	eppnt = elf_phdata;
  	for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
  		if (eppnt->p_type == PT_LOAD) {
@@ -374,9 +416,14 @@ static unsigned long load_elf_interp(str
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
@@ -442,8 +489,7 @@ static unsigned long load_elf_interp(str
  			goto out_close;
  	}

-	*interp_load_addr = load_addr;
-	error = ((unsigned long)interp_elf_ex->e_entry) + load_addr;
+	error = load_addr;

  out_close:
  	kfree(elf_phdata);
@@ -540,7 +586,7 @@ static int load_elf_binary(struct linux_
  	int elf_exec_fileno;
  	int retval, i;
  	unsigned int size;
-	unsigned long elf_entry, interp_load_addr = 0;
+	unsigned long elf_entry, interp_load_addr = 0, interp_map_addr = 0;
  	unsigned long start_code, end_code, start_data, end_data;
  	unsigned long reloc_func_desc = 0;
  	char passed_fileno[6];
@@ -808,9 +854,7 @@ static int load_elf_binary(struct linux_
  	current->mm->start_stack = bprm->p;

  	/* Now we do a little grungy work by mmaping the ELF image into
-	   the correct location in memory.  At this point, we assume that
-	   the image should be loaded at fixed address, not at a variable
-	   address. */
+	   the correct location in memory. */
  	for(i = 0, elf_ppnt = elf_phdata;
  	    i < loc->elf_ex.e_phnum; i++, elf_ppnt++) {
  		int elf_prot = 0, elf_flags;
@@ -864,11 +908,15 @@ static int load_elf_binary(struct linux_
  			 * default mmap base, as well as whatever program they
  			 * might try to exec.  This is because the brk will
  			 * follow the loader, and is not movable.  */
+#if defined(__i386__) || defined(__x86_64__)
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
@@ -947,10 +995,17 @@ static int load_elf_binary(struct linux_
  		if (interpreter_type == INTERPRETER_AOUT)
  			elf_entry = load_aout_interp(&loc->interp_ex,
  						     interpreter);
-		else
+		else {
  			elf_entry = load_elf_interp(&loc->interp_elf_ex,
  						    interpreter,
-						    &interp_load_addr);
+						    &interp_map_addr,
+						    load_bias);
+			if (!BAD_ADDR(elf_entry)) {
+				/* load_elf_interp() returns relocation adjustment */
+				interp_load_addr = elf_entry;
+				elf_entry += loc->interp_elf_ex.e_entry;
+			}
+		}
  		if (BAD_ADDR(elf_entry)) {
  			force_sig(SIGSEGV, current);
  			retval = IS_ERR((void *)elf_entry) ?
-- 
1.4.3.4



