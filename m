Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbZLOCle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbZLOCle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758419AbZLOClb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:41:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56764 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759014AbZLOCl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:41:29 -0500
Date: Tue, 15 Dec 2009 11:41:25 +0900 (JST)
Message-Id: <20091215.114125.71090684.d.hatayama@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jdike@addtoit.com, tony.luck@intel.com,
       mhiramat@redhat.com
Subject: [RFC, PATCH 2/4] elf_core_dump(): Remove DUMP_WRITE macro
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In DUMP_WRITE macro, some local variables and goto statement are used
implicitly, which makes it confusing to understand how the dumping
process behaves. So, clean up it by unfolding the macro body directly
to the point where the original macro is used plus a bit of style
change.

Now that the previous patch replaced ELF_CORE_EXTRA_* macros in
fs/binfmt_elf.c, there is no users for DUMP_WRITE macro in
fs/binfmt_elf.c. Thus remove the definition of DUMP_WRITE macro.

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
---
 fs/binfmt_elf.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 5f7be51..9666a8a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1277,10 +1277,6 @@ static int writenote(struct memelfnote *men, struct file *file,
 }
 #undef DUMP_WRITE
 
-#define DUMP_WRITE(addr, nr)	\
-	if ((size += (nr)) > limit || !dump_write(file, (addr), (nr))) \
-		goto end_coredump;
-
 static void fill_elf_header(struct elfhdr *elf, int segs,
 			    u16 machine, u32 flags, u8 osabi)
 {
@@ -1981,7 +1977,10 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 
-	DUMP_WRITE(elf, sizeof(*elf));
+	size += sizeof(*elf);
+	if (size > limit || !dump_write(file, elf, sizeof(*elf)))
+		goto end_coredump;
+
 	offset += sizeof(*elf);				/* Elf header */
 	offset += (segs + 1) * sizeof(struct elf_phdr); /* Program headers */
 	foffset = offset;
@@ -1995,7 +1994,9 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 
 		fill_elf_note_phdr(&phdr, sz, offset);
 		offset += sz;
-		DUMP_WRITE(&phdr, sizeof(phdr));
+		size += sizeof(phdr);
+		if (size > limit || !dump_write(file, &phdr, sizeof(phdr)))
+			goto end_coredump;
 	}
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
@@ -2026,7 +2027,9 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 			phdr.p_flags |= PF_X;
 		phdr.p_align = ELF_EXEC_PAGESIZE;
 
-		DUMP_WRITE(&phdr, sizeof(phdr));
+		size += sizeof(phdr);
+		if (size > limit || !dump_write(file, &phdr, sizeof(phdr)))
+			goto end_coredump;
 	}
 
 	if (!elf_core_write_extra_phdrs(file, offset, &size, limit))
-- 
1.6.5.1

