Return-Path: <linux-kernel-owner+w=401wt.eu-S1422885AbXCBEvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422885AbXCBEvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422891AbXCBEvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:51:01 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45471 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422885AbXCBEvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:51:00 -0500
Message-ID: <45E7AD2D.20506@hitachi.com>
Date: Fri, 02 Mar 2007 13:50:53 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       David Howells <dhowells@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared
    memory
References: <45E7AAFA.4070402@hitachi.com>
In-Reply-To: <45E7AAFA.4070402@hitachi.com>
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
 fs/binfmt_elf_fdpic.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

Index: linux-2.6.20-mm2/fs/binfmt_elf_fdpic.c
===================================================================
--- linux-2.6.20-mm2.orig/fs/binfmt_elf_fdpic.c
+++ linux-2.6.20-mm2/fs/binfmt_elf_fdpic.c
@@ -1168,7 +1168,7 @@ static int dump_seek(struct file *file, 
  *
  * I think we should skip something. But I am not sure how. H.J.
  */
-static int maydump(struct vm_area_struct *vma)
+static int maydump(struct vm_area_struct *vma, struct mm_struct *mm)
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
+		if (mm->coredump_omit_anon_shared) {
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
@@ -1451,7 +1458,7 @@ static int elf_fdpic_dump_segments(struc
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
 		unsigned long addr;
 
-		if (!maydump(vma))
+		if (!maydump(vma, mm))
 			continue;
 
 		for (addr = vma->vm_start;
@@ -1506,7 +1513,7 @@ static int elf_fdpic_dump_segments(struc
 	for (vml = current->mm->context.vmlist; vml; vml = vml->next) {
 	struct vm_area_struct *vma = vml->vma;
 
-		if (!maydump(vma))
+		if (!maydump(vma, mm))
 			continue;
 
 		if ((*size += PAGE_SIZE) > *limit)
@@ -1715,7 +1722,7 @@ static int elf_fdpic_core_dump(long sign
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma) ? sz : 0;
+		phdr.p_filesz = maydump(vma, current->mm) ? sz : 0;
 		phdr.p_memsz = sz;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;


