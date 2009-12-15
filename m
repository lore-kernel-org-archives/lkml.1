Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbZLOCls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbZLOCls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbZLOClq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:41:46 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39436 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759043AbZLOClm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:41:42 -0500
Date: Tue, 15 Dec 2009 11:41:37 +0900 (JST)
Message-Id: <20091215.114137.104035145.d.hatayama@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jdike@addtoit.com, tony.luck@intel.com,
       mhiramat@redhat.com
Subject: [RFC, PATCH 3/4] elf_core_dump(): make offset calculation and
 writing processes explicit
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My next patch will change elf_core_dump() so that the produced
corefile may include section header table. But here is a problem.

If the corefile contains section header table, one needs to
write its file header to e_shoff field of the ELF header. It
is impossible to implement it while keeping the current
implementation.

Currently, writing operation for ELF header is done at very
early stage, where the file offset cannot be calculated. So,
one needs to choose which of the following ways:

 1. Seeking back to retry writing operation for ELF header
    after completing writing process for a whole part

 2. Making offset calculation process and writing process
    totally sequential

However, the clause 1. is not always possible, since one
cannot assume that dump_seek() function always supports
the seek in the minus direction. Consider no_llseek.

Therefore, this patch adopts the clause 2.

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
---
 fs/binfmt_elf.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 9666a8a..cded1ba 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1935,6 +1935,7 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	loff_t offset = 0, dataoff, foffset;
 	unsigned long mm_flags;
 	struct elf_note_info info;
+	struct elf_phdr *phdr4note = NULL;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1977,30 +1978,34 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 
-	size += sizeof(*elf);
-	if (size > limit || !dump_write(file, elf, sizeof(*elf)))
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
-		size += sizeof(phdr);
-		if (size > limit || !dump_write(file, &phdr, sizeof(phdr)))
+		phdr4note = kmalloc(sizeof(*phdr4note), GFP_KERNEL);
+		if (!phdr4note)
 			goto end_coredump;
+
+		fill_elf_note_phdr(phdr4note, sz, offset);
+		offset += sz;
 	}
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
+	size += sizeof(*elf);
+	if (size > limit || !dump_write(file, elf, sizeof(*elf)))
+		goto end_coredump;
+
+	size += sizeof(*phdr4note);
+	if (size > limit || !dump_write(file, phdr4note, sizeof(*phdr4note)))
+		goto end_coredump;
+
 	/*
 	 * We must use the same mm->flags while dumping core to avoid
 	 * inconsistency between the program headers and bodies, otherwise an
@@ -2079,6 +2084,7 @@ end_coredump:
 
 cleanup:
 	free_note_info(&info);
+	kfree(phdr4note);
 	kfree(elf);
 out:
 	return has_dumped;
-- 
1.6.5.1

