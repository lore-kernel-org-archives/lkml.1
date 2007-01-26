Return-Path: <linux-kernel-owner+w=401wt.eu-S965678AbXAZOOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965678AbXAZOOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965690AbXAZOOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:14:00 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46328 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965678AbXAZON7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:13:59 -0500
Message-ID: <45BA0CA2.5060007@hitachi.com>
Date: Fri, 26 Jan 2007 23:13:54 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: akpm@osdl.org, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 2/4] coredump: enable to omit anonymous shared memory
References: <45BA0A93.30004@hitachi.com>
In-Reply-To: <45BA0A93.30004@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables to omit anonymous shared memory from a core file
when it is generated.

If you don't want to dump shared memory segments of <pid> process,
set the bit 0 of the /proc/<pid>/core_flags to 1.

  $ echo 1 > /proc/<pid>/core_flags


The debug messages from maydump() in fs/binfmt_elf_fdpic.c are changed
appropriately so that we can know what kind of memory segments are
dumped or not.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/binfmt_elf.c         |   20 ++++++++++++++------
 fs/binfmt_elf_fdpic.c   |   37 +++++++++++++++++++++++++------------
 include/linux/binfmts.h |    3 +++
 3 files changed, 42 insertions(+), 18 deletions(-)

Index: linux-2.6.20-rc4-mm1/fs/binfmt_elf.c
===================================================================
--- linux-2.6.20-rc4-mm1.orig/fs/binfmt_elf.c
+++ linux-2.6.20-rc4-mm1/fs/binfmt_elf.c
@@ -1176,15 +1176,21 @@ static int dump_seek(struct file *file, 
  *
  * I think we should skip something. But I am not sure how. H.J.
  */
-static int maydump(struct vm_area_struct *vma)
+static int maydump(struct vm_area_struct *vma, unsigned int core_flags)
 {
 	/* Do not dump I/O mapped devices or special mappings */
 	if (vma->vm_flags & (VM_IO | VM_RESERVED))
 		return 0;
 
-	/* Dump shared memory only if mapped from an anonymous file. */
-	if (vma->vm_flags & VM_SHARED)
-		return vma->vm_file->f_path.dentry->d_inode->i_nlink == 0;
+	/*
+	 * Dump shared memory only if mapped from an anonymous file and not
+	 * masked by /proc/<pid>/core_flags.
+	 */
+	if (vma->vm_flags & VM_SHARED) {
+		if (vma->vm_file->f_path.dentry->d_inode->i_nlink)
+			return 0;
+		return (core_flags & CORE_OMIT_ANON_SHARED) == 0;
+	}
 
 	/* If it hasn't been written to, don't write it out */
 	if (!vma->anon_vma)
@@ -1456,6 +1462,7 @@ static int elf_core_dump(long signr, str
 #endif
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
+	unsigned int core_flags;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1590,6 +1597,7 @@ static int elf_core_dump(long signr, str
 	}
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
+	__set_dump_bits(core_flags, current->mm->core_flags);
 
 	/* Write program headers for segments dump */
 	for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
@@ -1602,7 +1610,7 @@ static int elf_core_dump(long signr, str
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma) ? sz : 0;
+		phdr.p_filesz = maydump(vma, core_flags) ? sz : 0;
 		phdr.p_memsz = sz;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -1644,7 +1652,7 @@ static int elf_core_dump(long signr, str
 	for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
 		unsigned long addr;
 
-		if (!maydump(vma))
+		if (!maydump(vma, core_flags))
 			continue;
 
 		for (addr = vma->vm_start;
Index: linux-2.6.20-rc4-mm1/fs/binfmt_elf_fdpic.c
===================================================================
--- linux-2.6.20-rc4-mm1.orig/fs/binfmt_elf_fdpic.c
+++ linux-2.6.20-rc4-mm1/fs/binfmt_elf_fdpic.c
@@ -1167,7 +1167,7 @@ static int dump_seek(struct file *file, 
  *
  * I think we should skip something. But I am not sure how. H.J.
  */
-static int maydump(struct vm_area_struct *vma)
+static int maydump(struct vm_area_struct *vma, unsigned int core_flags)
 {
 	/* Do not dump I/O mapped devices or special mappings */
 	if (vma->vm_flags & (VM_IO | VM_RESERVED)) {
@@ -1183,15 +1183,22 @@ static int maydump(struct vm_area_struct
 		return 0;
 	}
 
-	/* Dump shared memory only if mapped from an anonymous file. */
+	/*
+	 * Dump shared memory only if mapped from an anonymous file and not
+	 * masked by /proc/<pid>/core_flags.
+	 */
 	if (vma->vm_flags & VM_SHARED) {
-		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0) {
+		if (vma->vm_file->f_path.dentry->d_inode->i_nlink) {
 			kdcore("%08lx: %08lx: no (share)", vma->vm_start, vma->vm_flags);
+			return 0;
+		}
+		if (core_flags & CORE_OMIT_ANON_SHARED) {
+			kdcore("%08lx: %08lx: no (anon-share)", vma->vm_start, vma->vm_flags);
+			return 0;
+		} else {
+			kdcore("%08lx: %08lx: yes (anon-share)", vma->vm_start, vma->vm_flags);
 			return 1;
 		}
-
-		kdcore("%08lx: %08lx: no (share)", vma->vm_start, vma->vm_flags);
-		return 0;
 	}
 
 #ifdef CONFIG_MMU
@@ -1443,14 +1450,15 @@ static int elf_dump_thread_status(long s
  */
 #ifdef CONFIG_MMU
 static int elf_fdpic_dump_segments(struct file *file, struct mm_struct *mm,
-				   size_t *size, unsigned long *limit)
+				   size_t *size, unsigned long *limit,
+				   unsigned int core_flags)
 {
 	struct vm_area_struct *vma;
 
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
 		unsigned long addr;
 
-		if (!maydump(vma))
+		if (!maydump(vma, core_flags))
 			continue;
 
 		for (addr = vma->vm_start;
@@ -1498,14 +1506,15 @@ end_coredump:
  */
 #ifndef CONFIG_MMU
 static int elf_fdpic_dump_segments(struct file *file, struct mm_struct *mm,
-				   size_t *size, unsigned long *limit)
+				   size_t *size, unsigned long *limit,
+				   unsigned int core_flags)
 {
 	struct vm_list_struct *vml;
 
 	for (vml = current->mm->context.vmlist; vml; vml = vml->next) {
 	struct vm_area_struct *vma = vml->vma;
 
-		if (!maydump(vma))
+		if (!maydump(vma, core_flags))
 			continue;
 
 		if ((*size += PAGE_SIZE) > *limit)
@@ -1556,6 +1565,7 @@ static int elf_fdpic_core_dump(long sign
 	struct vm_list_struct *vml;
 #endif
 	elf_addr_t *auxv;
+	unsigned int core_flags;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1693,6 +1703,8 @@ static int elf_fdpic_core_dump(long sign
 	/* Page-align dumped data */
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
+	__set_dump_bits(core_flags, current->mm->core_flags);
+
 	/* write program headers for segments dump */
 	for (
 #ifdef CONFIG_MMU
@@ -1714,7 +1726,7 @@ static int elf_fdpic_core_dump(long sign
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma) ? sz : 0;
+		phdr.p_filesz = maydump(vma, core_flags) ? sz : 0;
 		phdr.p_memsz = sz;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -1748,7 +1760,8 @@ static int elf_fdpic_core_dump(long sign
 
 	DUMP_SEEK(dataoff);
 
-	if (elf_fdpic_dump_segments(file, current->mm, &size, &limit) < 0)
+	if (elf_fdpic_dump_segments(file, current->mm, &size, &limit,
+				    core_flags) < 0)
 		goto end_coredump;
 
 #ifdef ELF_CORE_WRITE_EXTRA_DATA
Index: linux-2.6.20-rc4-mm1/include/linux/binfmts.h
===================================================================
--- linux-2.6.20-rc4-mm1.orig/include/linux/binfmts.h
+++ linux-2.6.20-rc4-mm1/include/linux/binfmts.h
@@ -79,6 +79,9 @@ extern int suid_dumpable;
 #define EXSTACK_DISABLE_X 1	/* Disable executable stacks */
 #define EXSTACK_ENABLE_X  2	/* Enable executable stacks */
 
+/* Core dump control flags */
+#define CORE_OMIT_ANON_SHARED 0x1  /* don't dump anonymous shared memory */
+
 extern int setup_arg_pages(struct linux_binprm * bprm,
 			   unsigned long stack_top,
 			   int executable_stack);



