Return-Path: <linux-kernel-owner+w=401wt.eu-S1762999AbXEYNMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762999AbXEYNMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbXEYNL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:11:59 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53724 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbXEYNL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:11:58 -0400
Message-ID: <4656E08B.2030506@hitachi.com>
Date: Fri, 25 May 2007 22:11:39 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, holt@sgi.com, alan@lxorguk.ukuu.org.uk,
       masami.hiramatsu.pt@hitachi.com, yumiko.sugita.yf@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: [PATCH 6/7] ELF-FDPIC: enable core dump filtering
References: <4656DBFB.2050501@hitachi.com>
In-Reply-To: <4656DBFB.2050501@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables core dump filtering for ELF-FDPIC-formatted
core file.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/binfmt_elf_fdpic.c |   52 ++++++++++++++++++++++++++--------------
 1 files changed, 35 insertions(+), 17 deletions(-)

Index: linux-2.6.22-rc2-mm1/fs/binfmt_elf_fdpic.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/fs/binfmt_elf_fdpic.c
+++ linux-2.6.22-rc2-mm1/fs/binfmt_elf_fdpic.c
@@ -1181,8 +1181,10 @@ static int dump_seek(struct file *file, 
  *
  * I think we should skip something. But I am not sure how. H.J.
  */
-static int maydump(struct vm_area_struct *vma)
+static int maydump(struct vm_area_struct *vma, unsigned long mm_flags)
 {
+	int dump_ok;
+
 	/* Do not dump I/O mapped devices or special mappings */
 	if (vma->vm_flags & (VM_IO | VM_RESERVED)) {
 		kdcore("%08lx: %08lx: no (IO)", vma->vm_start, vma->vm_flags);
@@ -1197,27 +1199,35 @@ static int maydump(struct vm_area_struct
 		return 0;
 	}
 
-	/* Dump shared memory only if mapped from an anonymous file. */
+	/* By default, dump shared memory if mapped from an anonymous file. */
 	if (vma->vm_flags & VM_SHARED) {
 		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0) {
-			kdcore("%08lx: %08lx: no (share)", vma->vm_start, vma->vm_flags);
-			return 1;
+			dump_ok = test_bit(MMF_DUMP_ANON_SHARED, &mm_flags);
+			kdcore("%08lx: %08lx: %s (share)", vma->vm_start,
+			       vma->vm_flags, dump_ok ? "yes" : "no");
+			return dump_ok;
 		}
 
-		kdcore("%08lx: %08lx: no (share)", vma->vm_start, vma->vm_flags);
-		return 0;
+		dump_ok = test_bit(MMF_DUMP_MAPPED_SHARED, &mm_flags);
+		kdcore("%08lx: %08lx: %s (share)", vma->vm_start,
+		       vma->vm_flags, dump_ok ? "yes" : "no");
+		return dump_ok;
 	}
 
 #ifdef CONFIG_MMU
-	/* If it hasn't been written to, don't write it out */
+	/* By default, if it hasn't been written to, don't write it out */
 	if (!vma->anon_vma) {
-		kdcore("%08lx: %08lx: no (!anon)", vma->vm_start, vma->vm_flags);
-		return 0;
+		dump_ok = test_bit(MMF_DUMP_MAPPED_PRIVATE, &mm_flags);
+		kdcore("%08lx: %08lx: %s (!anon)", vma->vm_start,
+		       vma->vm_flags, dump_ok ? "yes" : "no");
+		return dump_ok;
 	}
 #endif
 
-	kdcore("%08lx: %08lx: yes", vma->vm_start, vma->vm_flags);
-	return 1;
+	dump_ok = test_bit(MMF_DUMP_ANON_PRIVATE, &mm_flags);
+	kdcore("%08lx: %08lx: %s", vma->vm_start, vma->vm_flags,
+	       dump_ok ? "yes" : "no");
+	return dump_ok;
 }
 
 /* An ELF note in memory */
@@ -1457,14 +1467,14 @@ static int elf_dump_thread_status(long s
  */
 #ifdef CONFIG_MMU
 static int elf_fdpic_dump_segments(struct file *file, size_t *size,
-				   unsigned long *limit)
+			   unsigned long *limit, unsigned long mm_flags)
 {
 	struct vm_area_struct *vma;
 
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
 		unsigned long addr;
 
-		if (!maydump(vma))
+		if (!maydump(vma, mm_flags))
 			continue;
 
 		for (addr = vma->vm_start;
@@ -1512,14 +1522,14 @@ end_coredump:
  */
 #ifndef CONFIG_MMU
 static int elf_fdpic_dump_segments(struct file *file, size_t *size,
-				   unsigned long *limit)
+			   unsigned long *limit, unsigned long mm_flags)
 {
 	struct vm_list_struct *vml;
 
 	for (vml = current->mm->context.vmlist; vml; vml = vml->next) {
 	struct vm_area_struct *vma = vml->vma;
 
-		if (!maydump(vma))
+		if (!maydump(vma, mm_flags))
 			continue;
 
 		if ((*size += PAGE_SIZE) > *limit)
@@ -1570,6 +1580,7 @@ static int elf_fdpic_core_dump(long sign
 	struct vm_list_struct *vml;
 #endif
 	elf_addr_t *auxv;
+	unsigned long mm_flags;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1707,6 +1718,13 @@ static int elf_fdpic_core_dump(long sign
 	/* Page-align dumped data */
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
+	/*
+	 * We must use the same mm->flags while dumping core to avoid
+	 * inconsistency between the program headers and bodies, otherwise an
+	 * unusable core file can be generated.
+	 */
+	mm_flags = current->mm->flags;
+
 	/* write program headers for segments dump */
 	for (
 #ifdef CONFIG_MMU
@@ -1728,7 +1746,7 @@ static int elf_fdpic_core_dump(long sign
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma) ? sz : 0;
+		phdr.p_filesz = maydump(vma, mm_flags) ? sz : 0;
 		phdr.p_memsz = sz;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -1762,7 +1780,7 @@ static int elf_fdpic_core_dump(long sign
 
 	DUMP_SEEK(dataoff);
 
-	if (elf_fdpic_dump_segments(file, current->mm, &size, &limit) < 0)
+	if (elf_fdpic_dump_segments(file, &size, &limit, mm_flags) < 0)
 		goto end_coredump;
 
 #ifdef ELF_CORE_WRITE_EXTRA_DATA


