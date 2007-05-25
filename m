Return-Path: <linux-kernel-owner+w=401wt.eu-S1760435AbXEYNJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435AbXEYNJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760340AbXEYNJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:09:04 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53133 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760010AbXEYNJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:09:01 -0400
Message-ID: <4656DFD8.8070504@hitachi.com>
Date: Fri, 25 May 2007 22:08:40 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, holt@sgi.com, alan@lxorguk.ukuu.org.uk,
       masami.hiramatsu.pt@hitachi.com, yumiko.sugita.yf@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: [PATCH 4/7] ELF: enable core dump filtering
References: <4656DBFB.2050501@hitachi.com>
In-Reply-To: <4656DBFB.2050501@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables core dump filtering for ELF-formatted core file.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/binfmt_elf.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

Index: linux-2.6.22-rc2-mm1/fs/binfmt_elf.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/fs/binfmt_elf.c
+++ linux-2.6.22-rc2-mm1/fs/binfmt_elf.c
@@ -1189,7 +1189,7 @@ static int dump_seek(struct file *file, 
  *
  * I think we should skip something. But I am not sure how. H.J.
  */
-static int maydump(struct vm_area_struct *vma)
+static int maydump(struct vm_area_struct *vma, unsigned long mm_flags)
 {
 	/* The vma can be set up to tell us the answer directly.  */
 	if (vma->vm_flags & VM_ALWAYSDUMP)
@@ -1199,15 +1199,19 @@ static int maydump(struct vm_area_struct
 	if (vma->vm_flags & (VM_IO | VM_RESERVED))
 		return 0;
 
-	/* Dump shared memory only if mapped from an anonymous file. */
-	if (vma->vm_flags & VM_SHARED)
-		return vma->vm_file->f_path.dentry->d_inode->i_nlink == 0;
+	/* By default, dump shared memory if mapped from an anonymous file. */
+	if (vma->vm_flags & VM_SHARED) {
+		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0)
+			return test_bit(MMF_DUMP_ANON_SHARED, &mm_flags);
+		else
+			return test_bit(MMF_DUMP_MAPPED_SHARED, &mm_flags);
+	}
 
-	/* If it hasn't been written to, don't write it out */
+	/* By default, if it hasn't been written to, don't write it out. */
 	if (!vma->anon_vma)
-		return 0;
+		return test_bit(MMF_DUMP_MAPPED_PRIVATE, &mm_flags);
 
-	return 1;
+	return test_bit(MMF_DUMP_ANON_PRIVATE, &mm_flags);
 }
 
 /* An ELF note in memory */
@@ -1499,6 +1503,7 @@ static int elf_core_dump(long signr, str
 #endif
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
+	unsigned long mm_flags;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1638,6 +1643,13 @@ static int elf_core_dump(long signr, str
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
+	/*
+	 * We must use the same mm->flags while dumping core to avoid
+	 * inconsistency between the program headers and bodies, otherwise an
+	 * unusable core file can be generated.
+	 */
+	mm_flags = current->mm->flags;
+
 	/* Write program headers for segments dump */
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
@@ -1650,7 +1662,7 @@ static int elf_core_dump(long signr, str
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma) ? sz : 0;
+		phdr.p_filesz = maydump(vma, mm_flags) ? sz : 0;
 		phdr.p_memsz = sz;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -1693,7 +1705,7 @@ static int elf_core_dump(long signr, str
 			vma = next_vma(vma, gate_vma)) {
 		unsigned long addr;
 
-		if (!maydump(vma))
+		if (!maydump(vma, mm_flags))
 			continue;
 
 		for (addr = vma->vm_start;


