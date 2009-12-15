Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbZLOCl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbZLOCl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759059AbZLOClz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:41:55 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39446 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759057AbZLOClx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:41:53 -0500
Date: Tue, 15 Dec 2009 11:41:49 +0900 (JST)
Message-Id: <20091215.114149.189724375.d.hatayama@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jdike@addtoit.com, tony.luck@intel.com,
       mhiramat@redhat.com
Subject: [RFC, PATCH 4/4] elf_core_dump(): Add extended numbering support
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current ELF dumper implementation can produce broken corefiles
if program headers exceed 65535. This number is determined by the
number of vmas which the process have. In particular, some extreme
programs may use more than 65535 vmas. (If you google max_map_count,
you can find some users facing this problem.) This kind of program
never be able to generate correct coredumps.

This patch implements ``extended numbering'' that uses sh_info
field of the first section header instead of e_phnum field in order
to represent upto 4294967295 vmas.

This is supported by AMD64-ABI(http://www.x86-64.org/documentation.html)
and Solaris(http://docs.sun.com/app/docs/doc/817-1984/). Of course,
we are preparing patches for gdb and binutils.

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
---
 arch/ia64/kernel/elfcore.c |   16 ++++++++
 arch/um/sys-i386/elfcore.c |   18 +++++++++
 fs/binfmt_elf.c            |   88 +++++++++++++++++++++++++++++++++++++++-----
 include/linux/elf.h        |   26 ++++++++++++-
 4 files changed, 137 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/kernel/elfcore.c b/arch/ia64/kernel/elfcore.c
index 9c0dd8b..a15d8d4 100644
--- a/arch/ia64/kernel/elfcore.c
+++ b/arch/ia64/kernel/elfcore.c
@@ -73,3 +73,19 @@ int elf_core_write_extra_data(struct file *file, size_t *size,
 	}
 	return 1;
 }
+
+size_t elf_core_extra_data_size(void)
+{
+	const struct elf_phdr *const gate_phdrs =
+		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);
+	int i;
+	size_t size = 0;
+
+	for (i = 0; i < GATE_EHDR->e_phnum; ++i) {
+		if (gate_phdrs[i].p_type == PT_LOAD) {
+			size += PAGE_ALIGN(gate_phdrs[i].p_memsz);
+			break;
+		}
+	}
+	return size;
+}
diff --git a/arch/um/sys-i386/elfcore.c b/arch/um/sys-i386/elfcore.c
index 4e320f0..4e34e47 100644
--- a/arch/um/sys-i386/elfcore.c
+++ b/arch/um/sys-i386/elfcore.c
@@ -76,3 +76,21 @@ int elf_core_write_extra_data(struct file *file, size_t *size,
 	}
 	return 1;
 }
+
+size_t elf_core_extra_data_size(void)
+{
+	if ( vsyscall_ehdr ) {
+		const struct elfhdr *const ehdrp =
+			(struct elfhdr *)vsyscall_ehdr;
+		const struct elf_phdr *const phdrp =
+			(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);
+		int i;
+
+		for (i = 0; i < ehdrp->e_phnum; ++i) {
+			if (phdrp[i].p_type == PT_LOAD) {
+				return (size_t) phdrp[i].p_filesz;
+			}
+		}
+	}
+	return 0;
+}
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index cded1ba..ad2ad5f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1895,6 +1895,38 @@ static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
 	return gate_vma;
 }
 
+static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
+			     elf_addr_t e_shoff, int segs)
+{
+	elf->e_shoff = e_shoff;
+	elf->e_shentsize = sizeof(*shdr4extnum);
+	elf->e_shnum = 1;
+	elf->e_shstrndx = SHN_UNDEF;
+
+	shdr4extnum->sh_name = 0;
+	shdr4extnum->sh_addr = 0;
+	shdr4extnum->sh_offset = 0;
+	shdr4extnum->sh_type = SHT_NULL;
+	shdr4extnum->sh_flags = 0;
+	shdr4extnum->sh_size = elf->e_shnum;
+	shdr4extnum->sh_link = elf->e_shstrndx;
+	shdr4extnum->sh_info = segs;
+	shdr4extnum->sh_addralign = 0;
+	shdr4extnum->sh_entsize = 0;
+}
+
+static size_t elf_core_vma_data_size(struct vm_area_struct *gate_vma,
+				     unsigned long mm_flags)
+{
+	struct vm_area_struct *vma;
+	size_t size = 0;
+
+	for (vma = first_vma(current, gate_vma); vma != NULL;
+	     vma = next_vma(vma, gate_vma))
+		size += vma_dump_size(vma, mm_flags);
+	return size;
+}
+
 /*
  * It's been implemented that some architectures write out some extra
  * data into segments. On the other hand, other architechtures use
@@ -1917,6 +1949,11 @@ int __weak elf_core_write_extra_data(struct file *file, size_t *size,
 	return 1;
 }
 
+size_t __weak elf_core_extra_data_size(void)
+{
+	return 0;
+}
+
 /*
  * Actual dumper
  *
@@ -1936,6 +1973,9 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	unsigned long mm_flags;
 	struct elf_note_info info;
 	struct elf_phdr *phdr4note = NULL;
+	struct elf_shdr *shdr4extnum = NULL;
+	Elf_Half e_phnum = 0;
+	elf_addr_t e_shoff;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1964,12 +2004,19 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	if (gate_vma != NULL)
 		segs++;
 
+	/* for notes section */
+	segs++;
+
+	/* If segs > PN_XNUM(0xffff), then e_phnum overflows. To avoid
+	 * this, kernel supports extended numbering. Have a look at
+	 * include/linux/elf.h for further information. */
+	e_phnum = segs > PN_XNUM ? PN_XNUM : segs;
+
 	/*
 	 * Collect all the non-memory information about the process for the
 	 * notes.  This also sets up the file header.
 	 */
-	if (!fill_note_info(elf, segs + 1, /* including notes section */
-			    &info, signr, regs))
+	if (!fill_note_info(elf, e_phnum, &info, signr, regs))
 		goto cleanup;
 
 	has_dumped = 1;
@@ -1979,7 +2026,7 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	set_fs(KERNEL_DS);
 
 	offset += sizeof(*elf);				/* Elf header */
-	offset += (segs + 1) * sizeof(struct elf_phdr); /* Program headers */
+	offset += segs * sizeof(struct elf_phdr); /* Program headers */
 	foffset = offset;
 
 	/* Write notes phdr entry */
@@ -1998,6 +2045,26 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
+	/*
+	 * We must use the same mm->flags while dumping core to avoid
+	 * inconsistency between the program headers and bodies, otherwise an
+	 * unusable core file can be generated.
+	 */
+	mm_flags = current->mm->flags;
+
+	offset += elf_core_vma_data_size(gate_vma, mm_flags);
+	offset += elf_core_extra_data_size();
+	e_shoff = offset;
+
+	if (e_phnum == PN_XNUM) {
+		shdr4extnum = kmalloc(sizeof(*shdr4extnum), GFP_KERNEL);
+		if (!shdr4extnum)
+			goto end_coredump;
+		fill_extnum_info(elf, shdr4extnum, e_shoff, segs);
+	}
+
+	offset = dataoff;
+
 	size += sizeof(*elf);
 	if (size > limit || !dump_write(file, elf, sizeof(*elf)))
 		goto end_coredump;
@@ -2006,13 +2073,6 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	if (size > limit || !dump_write(file, phdr4note, sizeof(*phdr4note)))
 		goto end_coredump;
 
-	/*
-	 * We must use the same mm->flags while dumping core to avoid
-	 * inconsistency between the program headers and bodies, otherwise an
-	 * unusable core file can be generated.
-	 */
-	mm_flags = current->mm->flags;
-
 	/* Write program headers for segments dump */
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
@@ -2079,11 +2139,19 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	if (!elf_core_write_extra_data(file, &size, limit))
 		goto end_coredump;
 
+	if (e_phnum == PN_XNUM) {
+		size += sizeof(*shdr4extnum);
+		if (size > limit
+		    || !dump_write(file, shdr4extnum, sizeof(*shdr4extnum)))
+			goto end_coredump;
+	}
+
 end_coredump:
 	set_fs(fs);
 
 cleanup:
 	free_note_info(&info);
+	kfree(shdr4extnum);
 	kfree(phdr4note);
 	kfree(elf);
 out:
diff --git a/include/linux/elf.h b/include/linux/elf.h
index d103127..027fdfe 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -50,6 +50,28 @@ typedef __s64	Elf64_Sxword;
 
 #define PT_GNU_STACK	(PT_LOOS + 0x474e551)
 
+/*
+ * Extended Numbering
+ *
+ * If the real number of program header table entries is larger than
+ * or equal to PN_XNUM(0xffff), it is set to sh_info field of the
+ * section header at index 0, and PN_XNUM is set to e_phnum
+ * field. Otherwise, the section header at index 0 is zero
+ * initialized, if it exists.
+ *
+ * Specifications are available in:
+ *
+ * - Sun microsystems: Linker and Libraries.
+ *   Part No: 817-1984-17, September 2008.
+ *   URL: http://docs.sun.com/app/docs/doc/817-1984
+ *
+ * - System V ABI AMD64 Architecture Processor Supplement
+ *   Draft Version 0.99.,
+ *   May 11, 2009.
+ *   URL: http://www.x86-64.org/
+ */
+#define PN_XNUM 0xffff
+
 /* These constants define the different elf file types */
 #define ET_NONE   0
 #define ET_REL    1
@@ -286,7 +308,7 @@ typedef struct elf64_phdr {
 #define SHN_COMMON	0xfff2
 #define SHN_HIRESERVE	0xffff
  
-typedef struct {
+typedef struct elf32_shdr {
   Elf32_Word	sh_name;
   Elf32_Word	sh_type;
   Elf32_Word	sh_flags;
@@ -384,6 +406,7 @@ typedef struct elf64_note {
 extern Elf32_Dyn _DYNAMIC [];
 #define elfhdr		elf32_hdr
 #define elf_phdr	elf32_phdr
+#define elf_shdr	elf32_shdr
 #define elf_note	elf32_note
 #define elf_addr_t	Elf32_Off
 #define Elf_Half	Elf32_Half
@@ -393,6 +416,7 @@ extern Elf32_Dyn _DYNAMIC [];
 extern Elf64_Dyn _DYNAMIC [];
 #define elfhdr		elf64_hdr
 #define elf_phdr	elf64_phdr
+#define elf_shdr	elf64_shdr
 #define elf_note	elf64_note
 #define elf_addr_t	Elf64_Off
 #define Elf_Half	Elf64_Half
-- 
1.6.5.1

