Return-Path: <linux-kernel-owner+w=401wt.eu-S932322AbXBPNlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbXBPNlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932319AbXBPNla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:41:30 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44141 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbXBPNl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:41:29 -0500
Message-ID: <45D5B483.3020502@hitachi.com>
Date: Fri, 16 Feb 2007 22:41:23 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared
    memory
References: <45D5B2E3.3030607@hitachi.com>
In-Reply-To: <45D5B2E3.3030607@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables to omit anonymous shared memory from an ELF-FDPIC
formatted core file when it is generated.

The debug messages from maydump() in fs/binfmt_elf_fdpic.c are changed
appropriately so that we can know what kind of memory segments are
dumped or not.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/binfmt_elf_fdpic.c |   37 +++++++++++++++++++++++++------------
 1 files changed, 25 insertions(+), 12 deletions(-)

Index: linux-2.6.20-mm1/fs/binfmt_elf_fdpic.c
===================================================================
--- linux-2.6.20-mm1.orig/fs/binfmt_elf_fdpic.c
+++ linux-2.6.20-mm1/fs/binfmt_elf_fdpic.c
@@ -1168,7 +1168,7 @@ static int dump_seek(struct file *file, 
  *
  * I think we should skip something. But I am not sure how. H.J.
  */
-static int maydump(struct vm_area_struct *vma)
+static int maydump(struct vm_area_struct *vma, unsigned int omit_anon_shared)
 {
 	/* Do not dump I/O mapped devices or special mappings */
 	if (vma->vm_flags & (VM_IO | VM_RESERVED)) {
@@ -1184,15 +1184,22 @@ static int maydump(struct vm_area_struct
 		return 0;
 	}
 
-	/* Dump shared memory only if mapped from an anonymous file. */
+	/*
+	 * Dump shared memory only if mapped from an anonymous file and
+	 * /proc/<pid>/coredump_omit_anonymous_shared flag is not set.
+	 */
 	if (vma->vm_flags & VM_SHARED) {
-		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0) {
+		if (vma->vm_file->f_path.dentry->d_inode->i_nlink) {
 			kdcore("%08lx: %08lx: no (share)", vma->vm_start, vma->vm_flags);
+			return 0;
+		}
+		if (omit_anon_shared) {
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
@@ -1444,14 +1451,15 @@ static int elf_dump_thread_status(long s
  */
 #ifdef CONFIG_MMU
 static int elf_fdpic_dump_segments(struct file *file, struct mm_struct *mm,
-				   size_t *size, unsigned long *limit)
+				   size_t *size, unsigned long *limit,
+				   unsigned int omit_anon_shared)
 {
 	struct vm_area_struct *vma;
 
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
 		unsigned long addr;
 
-		if (!maydump(vma))
+		if (!maydump(vma, omit_anon_shared))
 			continue;
 
 		for (addr = vma->vm_start;
@@ -1499,14 +1507,15 @@ end_coredump:
  */
 #ifndef CONFIG_MMU
 static int elf_fdpic_dump_segments(struct file *file, struct mm_struct *mm,
-				   size_t *size, unsigned long *limit)
+				   size_t *size, unsigned long *limit,
+				   unsigned int omit_anon_shared)
 {
 	struct vm_list_struct *vml;
 
 	for (vml = current->mm->context.vmlist; vml; vml = vml->next) {
 	struct vm_area_struct *vma = vml->vma;
 
-		if (!maydump(vma))
+		if (!maydump(vma, omit_anon_shared))
 			continue;
 
 		if ((*size += PAGE_SIZE) > *limit)
@@ -1557,6 +1566,7 @@ static int elf_fdpic_core_dump(long sign
 	struct vm_list_struct *vml;
 #endif
 	elf_addr_t *auxv;
+	unsigned int omit_anon_shared = 0;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1694,6 +1704,8 @@ static int elf_fdpic_core_dump(long sign
 	/* Page-align dumped data */
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
+	omit_anon_shared = current->mm->coredump_omit_anon_shared;
+
 	/* write program headers for segments dump */
 	for (
 #ifdef CONFIG_MMU
@@ -1715,7 +1727,7 @@ static int elf_fdpic_core_dump(long sign
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma) ? sz : 0;
+		phdr.p_filesz = maydump(vma, omit_anon_shared) ? sz : 0;
 		phdr.p_memsz = sz;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -1749,7 +1761,8 @@ static int elf_fdpic_core_dump(long sign
 
 	DUMP_SEEK(dataoff);
 
-	if (elf_fdpic_dump_segments(file, current->mm, &size, &limit) < 0)
+	if (elf_fdpic_dump_segments(file, current->mm, &size, &limit,
+				    omit_anon_shared) < 0)
 		goto end_coredump;
 
 #ifdef ELF_CORE_WRITE_EXTRA_DATA


