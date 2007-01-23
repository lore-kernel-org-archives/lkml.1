Return-Path: <linux-kernel-owner+w=401wt.eu-S964927AbXAWTsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927AbXAWTsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965422AbXAWTsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:48:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51638 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964927AbXAWTsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:48:39 -0500
Date: Tue, 23 Jan 2007 11:48:25 -0800
From: Andrew Morton <akpm@osdl.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/11] i386 vDSO: use VM_ALWAYSDUMP
Message-Id: <20070123114825.21ebc2e3.akpm@osdl.org>
In-Reply-To: <20070114053428.900DB1800E5@magilla.sf.frob.com>
References: <20070114053140.351701800E5@magilla.sf.frob.com>
	<20070114053428.900DB1800E5@magilla.sf.frob.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Jan 2007 21:34:28 -0800 (PST)
Roland McGrath <roland@redhat.com> wrote:

> +	     vma = vma->vm_next ?: vma == gate_vma ? NULL : gate_vma) {

Painful.   Can we do this?


diff -puN fs/binfmt_elf.c~i386-vdso-use-vm_alwaysdump-tidy fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~i386-vdso-use-vm_alwaysdump-tidy
+++ a/fs/binfmt_elf.c
@@ -1429,6 +1429,23 @@ static int elf_dump_thread_status(long s
 }
 
 /*
+ * Helper function for iterating across a vma list.  It ensures that the caller
+ * will visit `gate_vma' prior to terminating the search.
+ */
+static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
+					struct vm_area_struct *gate_vma)
+{
+	struct vm_area_struct *ret;
+
+	ret = this_vma->vm_next;
+	if (ret)
+		return ret;
+	if (this_vma == gate_vma)
+		return NULL;
+	return gate_vma;
+}
+
+/*
  * Actual dumper
  *
  * This is a two-pass process; first we find the offsets of the bits,
@@ -1600,8 +1617,7 @@ static int elf_core_dump(long signr, str
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
 	/* Write program headers for segments dump */
-	for (vma = current->mm->mmap; vma != NULL;
-	     vma = vma->vm_next ?: vma == gate_vma ? NULL : gate_vma) {
+	for (vma = current->mm->mmap; vma; vma = next_vma(vma, gate_vma)) {
 		struct elf_phdr phdr;
 		size_t sz;
 
@@ -1650,8 +1666,7 @@ static int elf_core_dump(long signr, str
 	/* Align to page */
 	DUMP_SEEK(dataoff - foffset);
 
-	for (vma = current->mm->mmap; vma != NULL;
-	     vma = vma->vm_next ?: vma == gate_vma ? NULL : gate_vma) {
+	for (vma = current->mm->mmap; vma; vma = next_vma(vma, gate_vma)) {
 		unsigned long addr;
 
 		if (!maydump(vma))
_

