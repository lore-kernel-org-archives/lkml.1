Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141Ab0ADBUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0ADBUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 20:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119Ab0ADBUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 20:20:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45502 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0ADBUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 20:20:41 -0500
Date: Mon, 04 Jan 2010 10:20:38 +0900 (JST)
Message-Id: <20100104.102038.59657110.d.hatayama@jp.fujitsu.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mhiramat@redhat.com, xiyou.wangcong@gmail.com, andi@firstfloor.org,
       jdike@addtoit.com, tony.luck@intel.com
Subject: [RESEND][mmotm][PATCH v2, 4/5] elf coredump: make offset
 calculation process and writing process explicit
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20100104.100607.189714443.d.hatayama@jp.fujitsu.com>
References: <20100104.100607.189714443.d.hatayama@jp.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the next patch, elf_core_dump() and elf_fdpic_core_dump() will
support extended numbering and so will produce the corefiles with
section header table in a special case.

The problem is the process of writing a file header offset of the
section header table into e_shoff field of the ELF header. ELF header
is positioned at the beginning of the corefile, while section header
at the end. So, we need to take which of the following ways:

 1. Seek backward to retry writing operation for ELF header
    after writing process for a whole part

 2. Make offset calculation process and writing process
    totally sequential

The clause 1. is not always possible: one cannot assume that file
system supports seek function. Consider the no_llseek case.

Therefore, this patch adopts the clause 2.

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
---
 fs/binfmt_elf.c       |   27 ++++++++++++++++-----------
 fs/binfmt_elf_fdpic.c |   29 ++++++++++++++++-------------
 2 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 1b7e9de..b1ded32 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1879,6 +1879,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 	loff_t offset = 0, dataoff, foffset;
 	unsigned long mm_flags;
 	struct elf_note_info info;
+	struct elf_phdr *phdr4note = NULL;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1921,28 +1922,22 @@ static int elf_core_dump(struct coredump_params *cprm)
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 
-	size += sizeof(*elf);
-	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
-		goto end_coredump;
-
 	offset += sizeof(*elf);				/* Elf header */
 	offset += (segs + 1) * sizeof(struct elf_phdr); /* Program headers */
 	foffset = offset;
 
 	/* Write notes phdr entry */
 	{
-		struct elf_phdr phdr;
 		size_t sz = get_note_info_size(&info);
 
 		sz += elf_coredump_extra_notes_size();
 
-		fill_elf_note_phdr(&phdr, sz, offset);
-		offset += sz;
-
-		size += sizeof(phdr);
-		if (size > cprm->limit
-		    || !dump_write(cprm->file, &phdr, sizeof(phdr)))
+		phdr4note = kmalloc(sizeof(*phdr4note), GFP_KERNEL);
+		if (!phdr4note)
 			goto end_coredump;
+
+		fill_elf_note_phdr(phdr4note, sz, offset);
+		offset += sz;
 	}
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
@@ -1954,6 +1949,15 @@ static int elf_core_dump(struct coredump_params *cprm)
 	 */
 	mm_flags = current->mm->flags;
 
+	size += sizeof(*elf);
+	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
+		goto end_coredump;
+
+	size += sizeof(*phdr4note);
+	if (size > cprm->limit
+	    || !dump_write(cprm->file, phdr4note, sizeof(*phdr4note)))
+		goto end_coredump;
+
 	/* Write program headers for segments dump */
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
@@ -2027,6 +2031,7 @@ end_coredump:
 
 cleanup:
 	free_note_info(&info);
+	kfree(phdr4note);
 	kfree(elf);
 out:
 	return has_dumped;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 4c16ff6..cbfa34e 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1588,6 +1588,7 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
 	unsigned long mm_flags;
+	struct elf_phdr *phdr4note = NULL;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1694,18 +1695,12 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 
-	size += sizeof(*elf);
-	if (size > cprm->limit
-	    || !dump_write(cprm->file, elf, sizeof(*elf)))
-		goto end_coredump;
-
 	offset += sizeof(*elf);				/* Elf header */
 	offset += (segs+1) * sizeof(struct elf_phdr);	/* Program headers */
 	foffset = offset;
 
 	/* Write notes phdr entry */
 	{
-		struct elf_phdr phdr;
 		int sz = 0;
 
 		for (i = 0; i < numnote; i++)
@@ -1713,13 +1708,12 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 
 		sz += thread_status_size;
 
-		fill_elf_note_phdr(&phdr, sz, offset);
-		offset += sz;
-
-		size += sizeof(phdr);
-		if (size > cprm->limit
-		    || !dump_write(cprm->file, &phdr, sizeof(phdr)))
+		phdr4note = kmalloc(sizeof(*phdr4note), GFP_KERNEL);
+		if (!phdr4note)
 			goto end_coredump;
+
+		fill_elf_note_phdr(phdr4note, sz, offset);
+		offset += sz;
 	}
 
 	/* Page-align dumped data */
@@ -1732,6 +1726,15 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	 */
 	mm_flags = current->mm->flags;
 
+	size += sizeof(*elf);
+	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
+		goto end_coredump;
+
+	size += sizeof(*phdr4note);
+	if (size > cprm->limit
+	    || !dump_write(cprm->file, phdr4note, sizeof(*phdr4note)))
+		goto end_coredump;
+
 	/* write program headers for segments dump */
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
 		struct elf_phdr phdr;
@@ -1803,7 +1806,7 @@ cleanup:
 		list_del(tmp);
 		kfree(list_entry(tmp, struct elf_thread_status, list));
 	}
-
+	kfree(phdr4note);
 	kfree(elf);
 	kfree(prstatus);
 	kfree(psinfo);
-- 
1.6.5.1

