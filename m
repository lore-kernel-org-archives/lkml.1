Return-Path: <linux-kernel-owner+w=401wt.eu-S1765767AbXGZJib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765767AbXGZJib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbXGZJiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:38:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbXGZJiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:38:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ELF core dump options
X-Zippy-Says: Wait..  is this a FUN THING or the END of LIFE in Petticoat Junction??
Message-Id: <20070726093743.4208A4D058D@magilla.localdomain>
Date: Thu, 26 Jul 2007 02:37:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This adds two sysctl items under fs.binfmt_elf for controlling how memory
segments are dumped in ELF core files.  The core_dump_whole_segments option
can be set to have private file mappings dumped in their entirety.  Some
people prefer the certainty to the saving disk space and i/o at dump time,
and a global default is easier to set than every individual mm's MMF_DUMP_*.

The more interesting new feature is the core_dump_elf_headers option.
This dumps the first page (only) of a read-only private file mapping if it
appears to be a mapping of an ELF file.  Including these pages in the core
dump may give sufficient identifying information to associate the original
DSO and executable file images and their debugging information with a core
file in a generic way just from its contents (e.g. when those binaries were
built with ld --build-id).  I expect this to become the default behavior
eventually.  Existing versions of gdb can be confused by the core dumps it
creates, so it won't enabled by default for some time to come.  Soon many
people will have systems with a gdb that handle these dumps, so they can
use the sysctl option.

On biarch machines, there are two sets of options.
The native dumper uses fs.binfmt_elf.core_dump_*.
The compat dumper uses fs.binfmt_elf.32bit.core_dump_*.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/binfmt_elf.c |  171 ++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 145 insertions(+), 26 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 4482a06..30565b1 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -20,6 +20,7 @@
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/binfmts.h>
+#include <linux/sysctl.h>
 #include <linux/string.h>
 #include <linux/file.h>
 #include <linux/fcntl.h>
@@ -1161,6 +1162,10 @@ out:
  * Modelled on fs/exec.c:aout_core_dump()
  * Jeremy Fitzhardinge <jeremy@sw.oz.au>
  */
+
+static int dump_whole_segments;
+static int dump_elf_headers;
+
 /*
  * These are the only things you should do on a core-file: use only these
  * functions to write out all the necessary info.
@@ -1193,17 +1198,14 @@ static int dump_seek(struct file *file, loff_t off)
 }
 
 /*
- * Decide whether a segment is worth dumping; default is yes to be
- * sure (missing info is worse than too much; etc).
- * Personally I'd include everything, and use the coredump limit...
- *
- * I think we should skip something. But I am not sure how. H.J.
+ * Decide what to dump of a segment, part, all or none.
  */
-static int maydump(struct vm_area_struct *vma, unsigned long mm_flags)
+static unsigned long vma_dump_size(struct vm_area_struct *vma,
+				   unsigned long mm_flags)
 {
 	/* The vma can be set up to tell us the answer directly.  */
 	if (vma->vm_flags & VM_ALWAYSDUMP)
-		return 1;
+		goto whole;
 
 	/* Do not dump I/O mapped devices or special mappings */
 	if (vma->vm_flags & (VM_IO | VM_RESERVED))
@@ -1211,17 +1213,51 @@ static int maydump(struct vm_area_struct *vma, unsigned long mm_flags)
 
 	/* By default, dump shared memory if mapped from an anonymous file. */
 	if (vma->vm_flags & VM_SHARED) {
-		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0)
-			return test_bit(MMF_DUMP_ANON_SHARED, &mm_flags);
-		else
-			return test_bit(MMF_DUMP_MAPPED_SHARED, &mm_flags);
+		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0 ?
+		    test_bit(MMF_DUMP_ANON_SHARED, &mm_flags) :
+		    test_bit(MMF_DUMP_MAPPED_SHARED, &mm_flags))
+			goto whole;
+		return 0;
+	}
+
+	/* Dump segments that have been written to.  */
+	if (vma->anon_vma) {
+		if (test_bit(MMF_DUMP_ANON_PRIVATE, &mm_flags))
+			goto whole;
+		return 0;
+	}
+
+	if (dump_whole_segments || test_bit(MMF_DUMP_MAPPED_PRIVATE, &mm_flags))
+		goto whole;
+
+	/*
+	 * If this looks like the beginning of a DSO or executable mapping,
+	 * check for an ELF header.  If we find one, dump the first page to
+	 * aid in determining what was mapped here.
+	 */
+	if (dump_elf_headers && vma->vm_file != NULL && vma->vm_pgoff == 0) {
+		u32 __user *header = (u32 __user *) vma->vm_start;
+		u32 word;
+		/*
+		 * Doing it this way gets the constant folded by GCC.
+		 */
+		union {
+			u32 cmp;
+			char elfmag[SELFMAG];
+		} magic;
+		BUILD_BUG_ON(SELFMAG != sizeof word);
+		magic.elfmag[EI_MAG0] = ELFMAG0;
+		magic.elfmag[EI_MAG1] = ELFMAG1;
+		magic.elfmag[EI_MAG2] = ELFMAG2;
+		magic.elfmag[EI_MAG3] = ELFMAG3;
+		if (get_user(word, header) == 0 && word == magic.cmp)
+			return PAGE_SIZE;
 	}
 
-	/* By default, if it hasn't been written to, don't write it out. */
-	if (!vma->anon_vma)
-		return test_bit(MMF_DUMP_MAPPED_PRIVATE, &mm_flags);
+	return 0;
 
-	return test_bit(MMF_DUMP_ANON_PRIVATE, &mm_flags);
+whole:
+	return vma->vm_end - vma->vm_start;
 }
 
 /* An ELF note in memory */
@@ -1668,16 +1704,13 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
 		struct elf_phdr phdr;
-		size_t sz;
-
-		sz = vma->vm_end - vma->vm_start;
 
 		phdr.p_type = PT_LOAD;
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma, mm_flags) ? sz : 0;
-		phdr.p_memsz = sz;
+		phdr.p_filesz = vma_dump_size(vma, mm_flags);
+		phdr.p_memsz = vma->vm_end - vma->vm_start;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
 		if (vma->vm_flags & VM_WRITE)
@@ -1719,13 +1752,11 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
 		unsigned long addr;
+		unsigned long end;
 
-		if (!maydump(vma, mm_flags))
-			continue;
+		end = vma->vm_start + vma_dump_size(vma, mm_flags);
 
-		for (addr = vma->vm_start;
-		     addr < vma->vm_end;
-		     addr += PAGE_SIZE) {
+		for (addr = vma->vm_start; addr < end; addr += PAGE_SIZE) {
 			struct page *page;
 			struct vm_area_struct *vma;
 
@@ -1783,17 +1814,105 @@ cleanup:
 #undef NUM_NOTES
 }
 
+
+static ctl_table elf_core_dump_sysctls[] = {
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "core_dump_whole_segments",
+		.data = &dump_whole_segments,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "core_dump_elf_headers",
+		.data = &dump_elf_headers,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{ .ctl_name = 0 }
+};
+
+#if BITS_PER_LONG > 32 && ELF_CLASS == ELFCLASS32
+static ctl_table binfmt_elf_sysctl_32bit_dir[] = {
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "32bit",
+		.mode = 0555,
+		.child = elf_core_dump_sysctls,
+	},
+	{ .ctl_name = 0 }
+};
+#define elf_core_dump_sysctls binfmt_elf_sysctl_32bit_dir
+#endif
+
+static ctl_table binfmt_elf_sysctl_dir[] = {
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "binfmt_elf",
+		.mode = 0555,
+		.child = elf_core_dump_sysctls,
+	},
+	{ .ctl_name = 0 }
+};
+
+static ctl_table binfmt_elf_sysctl_root[] = {
+	{
+		.ctl_name = CTL_FS,
+		.procname = "fs",
+		.mode = 0555,
+		.child = binfmt_elf_sysctl_dir,
+	},
+	{ .ctl_name = 0 }
+};
+
+static struct ctl_table_header *core_dump_sysctl_table;
+
+static int register_core_dump_sysctl(void)
+{
+	core_dump_sysctl_table = register_sysctl_table(binfmt_elf_sysctl_root);
+	if (core_dump_sysctl_table == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void unregister_core_dump_sysctl(void)
+{
+	unregister_sysctl_table(core_dump_sysctl_table);
+	core_dump_sysctl_table = NULL;
+}
+
+#else
+
+static int register_core_dump_sysctl(void)
+{
+	return 0;
+}
+
+static void unregister_core_dump_sysctl(void)
+{
+}
+
 #endif		/* USE_ELF_CORE_DUMP */
 
 static int __init init_elf_binfmt(void)
 {
-	return register_binfmt(&elf_format);
+	int error = register_core_dump_sysctl();
+	if (!error) {
+		error = register_binfmt(&elf_format);
+		if (error)
+			unregister_core_dump_sysctl();
+	}
+	return error;
 }
 
 static void __exit exit_elf_binfmt(void)
 {
 	/* Remove the COFF and ELF loaders. */
 	unregister_binfmt(&elf_format);
+	unregister_core_dump_sysctl();
 }
 
 core_initcall(init_elf_binfmt);
