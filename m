Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbXBPNkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbXBPNkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932320AbXBPNkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:40:37 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43849 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbXBPNkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:40:35 -0500
Message-ID: <45D5B44F.6030901@hitachi.com>
Date: Fri, 16 Feb 2007 22:40:31 +0900
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
Subject: [PATCH 2/4] coredump: ELF: enable to omit anonymous shared memory
References: <45D5B2E3.3030607@hitachi.com>
In-Reply-To: <45D5B2E3.3030607@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables to omit anonymous shared memory from an ELF
formatted core file when it is generated.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/binfmt_elf.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6.20-mm1/fs/binfmt_elf.c
===================================================================
--- linux-2.6.20-mm1.orig/fs/binfmt_elf.c
+++ linux-2.6.20-mm1/fs/binfmt_elf.c
@@ -1181,7 +1181,7 @@ static int dump_seek(struct file *file, 
  *
  * I think we should skip something. But I am not sure how. H.J.
  */
-static int maydump(struct vm_area_struct *vma)
+static int maydump(struct vm_area_struct *vma, unsigned int omit_anon_shared)
 {
 	/* The vma can be set up to tell us the answer directly.  */
 	if (vma->vm_flags & VM_ALWAYSDUMP)
@@ -1191,9 +1191,15 @@ static int maydump(struct vm_area_struct
 	if (vma->vm_flags & (VM_IO | VM_RESERVED))
 		return 0;
 
-	/* Dump shared memory only if mapped from an anonymous file. */
-	if (vma->vm_flags & VM_SHARED)
-		return vma->vm_file->f_path.dentry->d_inode->i_nlink == 0;
+	/*
+	 * Dump shared memory only if mapped from an anonymous file and
+	 * /proc/<pid>/coredump_omit_anonymous_shared flag is not set.
+	 */
+	if (vma->vm_flags & VM_SHARED) {
+		if (vma->vm_file->f_path.dentry->d_inode->i_nlink)
+			return 0;
+		return omit_anon_shared == 0;
+	}
 
 	/* If it hasn't been written to, don't write it out */
 	if (!vma->anon_vma)
@@ -1491,6 +1497,7 @@ static int elf_core_dump(long signr, str
 #endif
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
+	unsigned int omit_anon_shared = 0;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1629,6 +1636,7 @@ static int elf_core_dump(long signr, str
 	}
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
+	omit_anon_shared = current->mm->coredump_omit_anon_shared;
 
 	/* Write program headers for segments dump */
 	for (vma = first_vma(current, gate_vma); vma != NULL;
@@ -1642,7 +1650,7 @@ static int elf_core_dump(long signr, str
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma) ? sz : 0;
+		phdr.p_filesz = maydump(vma, omit_anon_shared) ? sz : 0;
 		phdr.p_memsz = sz;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -1685,7 +1693,7 @@ static int elf_core_dump(long signr, str
 			vma = next_vma(vma, gate_vma)) {
 		unsigned long addr;
 
-		if (!maydump(vma))
+		if (!maydump(vma, omit_anon_shared))
 			continue;
 
 		for (addr = vma->vm_start;


