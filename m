Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990Ab0ADBU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab0ADBU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 20:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119Ab0ADBUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 20:20:54 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45508 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab0ADBUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 20:20:50 -0500
Date: Mon, 04 Jan 2010 10:20:45 +0900 (JST)
Message-Id: <20100104.102045.115911149.d.hatayama@jp.fujitsu.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mhiramat@redhat.com, xiyou.wangcong@gmail.com, andi@firstfloor.org,
       jdike@addtoit.com, tony.luck@intel.com
Subject: [RESEND][mmotm][PATCH v2, 5/5] elf coredump: Add extended
 numbering support
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

The current ELF dumper implementation can produce broken corefiles if
program headers exceed 65535. This number is determined by the number
of vmas which the process have. In particular, some extreme programs
may use more than 65535 vmas. (If you google max_map_count, you can
find some users facing this problem.) This kind of program never be
able to generate correct coredumps.

This patch implements ``extended numbering'' that uses sh_info field
of the first section header instead of e_phnum field in order to
represent upto 4294967295 vmas.

This is supported by
AMD64-ABI(http://www.x86-64.org/documentation.html) and
Solaris(http://docs.sun.com/app/docs/doc/817-1984/).
Of course, we are preparing patches for gdb and binutils.

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
---
 arch/ia64/ia32/elfcore32.h |    1 +
 arch/ia64/kernel/elfcore.c |   16 ++++++++++
 arch/um/sys-i386/elfcore.c |   16 ++++++++++
 fs/binfmt_elf.c            |   66 ++++++++++++++++++++++++++++++++++++++++++--
 fs/binfmt_elf_fdpic.c      |   63 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/elf.h        |   26 ++++++++++++++++-
 include/linux/elfcore.h    |    1 +
 kernel/elfcore.c           |    5 +++
 8 files changed, 188 insertions(+), 6 deletions(-)

diff --git a/arch/ia64/ia32/elfcore32.h b/arch/ia64/ia32/elfcore32.h
index 7877601..2c1defa 100644
--- a/arch/ia64/ia32/elfcore32.h
+++ b/arch/ia64/ia32/elfcore32.h
@@ -161,5 +161,6 @@ elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
 			   unsigned long limit);
 extern int
 elf_core_write_extra_data(struct file *file, size_t *size, unsigned long limit);
+extern size_t elf_core_extra_data_size(void);
 
 #endif /* _ELFCORE32_H_ */
diff --git a/arch/ia64/kernel/elfcore.c b/arch/ia64/kernel/elfcore.c
index 57a2298..bac1639 100644
--- a/arch/ia64/kernel/elfcore.c
+++ b/arch/ia64/kernel/elfcore.c
@@ -62,3 +62,19 @@ int elf_core_write_extra_data(struct file *file, size_t *size,
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
index 30cac52..6bb49b6 100644
--- a/arch/um/sys-i386/elfcore.c
+++ b/arch/um/sys-i386/elfcore.c
@@ -65,3 +65,19 @@ int elf_core_write_extra_data(struct file *file, size_t *size,
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
+		for (i = 0; i < ehdrp->e_phnum; ++i)
+			if (phdrp[i].p_type == PT_LOAD)
+				return (size_t) phdrp[i].p_filesz;
+	}
+	return 0;
+}
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index b1ded32..43e9219 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1861,6 +1861,34 @@ static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
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
+	memset(shdr4extnum, 0, sizeof(*shdr4extnum));
+
+	shdr4extnum->sh_type = SHT_NULL;
+	shdr4extnum->sh_size = elf->e_shnum;
+	shdr4extnum->sh_link = elf->e_shstrndx;
+	shdr4extnum->sh_info = segs;
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
  * Actual dumper
  *
@@ -1880,6 +1908,9 @@ static int elf_core_dump(struct coredump_params *cprm)
 	unsigned long mm_flags;
 	struct elf_note_info info;
 	struct elf_phdr *phdr4note = NULL;
+	struct elf_shdr *shdr4extnum = NULL;
+	Elf_Half e_phnum;
+	elf_addr_t e_shoff;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1908,12 +1939,19 @@ static int elf_core_dump(struct coredump_params *cprm)
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
-			    &info, cprm->signr, cprm->regs))
+	if (!fill_note_info(elf, e_phnum, &info, cprm->signr, cprm->regs))
 		goto cleanup;
 
 	has_dumped = 1;
@@ -1923,7 +1961,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 	set_fs(KERNEL_DS);
 
 	offset += sizeof(*elf);				/* Elf header */
-	offset += (segs + 1) * sizeof(struct elf_phdr); /* Program headers */
+	offset += segs * sizeof(struct elf_phdr);	/* Program headers */
 	foffset = offset;
 
 	/* Write notes phdr entry */
@@ -1949,6 +1987,19 @@ static int elf_core_dump(struct coredump_params *cprm)
 	 */
 	mm_flags = current->mm->flags;
 
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
 	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
 		goto end_coredump;
@@ -2026,11 +2077,20 @@ static int elf_core_dump(struct coredump_params *cprm)
 	if (!elf_core_write_extra_data(cprm->file, &size, cprm->limit))
 		goto end_coredump;
 
+	if (e_phnum == PN_XNUM) {
+		size += sizeof(*shdr4extnum);
+		if (size > cprm->limit
+		    || !dump_write(cprm->file, shdr4extnum,
+				   sizeof(*shdr4extnum)))
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
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index cbfa34e..d33a6d8 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1493,6 +1493,22 @@ static int elf_dump_thread_status(long signr, struct elf_thread_status *t)
 	return sz;
 }
 
+static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
+			     elf_addr_t e_shoff, int segs)
+{
+	elf->e_shoff = e_shoff;
+	elf->e_shentsize = sizeof(*shdr4extnum);
+	elf->e_shnum = 1;
+	elf->e_shstrndx = SHN_UNDEF;
+
+	memset(shdr4extnum, 0, sizeof(*shdr4extnum));
+
+	shdr4extnum->sh_type = SHT_NULL;
+	shdr4extnum->sh_size = elf->e_shnum;
+	shdr4extnum->sh_link = elf->e_shstrndx;
+	shdr4extnum->sh_info = segs;
+}
+
 /*
  * dump the segments for an MMU process
  */
@@ -1557,6 +1573,17 @@ static int elf_fdpic_dump_segments(struct file *file, size_t *size,
 }
 #endif
 
+static size_t elf_core_vma_data_size(unsigned long mm_flags)
+{
+	struct vm_area_struct *vma;
+	size_t size = 0;
+
+	for (vma = current->mm->mmap; vma; vma->vm_next)
+		if (maydump(vma, mm_flags))
+			size += vma->vm_end - vma->vm_start;
+	return size;
+}
+
 /*
  * Actual dumper
  *
@@ -1589,6 +1616,9 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	elf_addr_t *auxv;
 	unsigned long mm_flags;
 	struct elf_phdr *phdr4note = NULL;
+	struct elf_shdr *shdr4extnum = NULL;
+	Elf_Half e_phnum;
+	elf_addr_t e_shoff;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1655,8 +1685,16 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	segs = current->mm->map_count;
 	segs += elf_core_extra_phdrs();
 
+	/* for notes section */
+	segs++;
+
+	/* If segs > PN_XNUM(0xffff), then e_phnum overflows. To avoid
+	 * this, kernel supports extended numbering. Have a look at
+	 * include/linux/elf.h for further information. */
+	e_phnum = segs > PN_XNUM ? PN_XNUM : segs;
+
 	/* Set up header */
-	fill_elf_fdpic_header(elf, segs + 1);	/* including notes section */
+	fill_elf_fdpic_header(elf, e_phnum);
 
 	has_dumped = 1;
 	current->flags |= PF_DUMPCORE;
@@ -1696,7 +1734,7 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	set_fs(KERNEL_DS);
 
 	offset += sizeof(*elf);				/* Elf header */
-	offset += (segs+1) * sizeof(struct elf_phdr);	/* Program headers */
+	offset += segs * sizeof(struct elf_phdr);	/* Program headers */
 	foffset = offset;
 
 	/* Write notes phdr entry */
@@ -1726,6 +1764,19 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	 */
 	mm_flags = current->mm->flags;
 
+	offset += elf_core_vma_data_size(mm_flags);
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
 	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
 		goto end_coredump;
@@ -1790,6 +1841,14 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	if (!elf_core_write_extra_data(cprm->file, &size, cprm->limit))
 		goto end_coredump;
 
+	if (e_phnum == PN_XNUM) {
+		size += sizeof(*shdr4extnum);
+		if (size > cprm->limit
+		    || !dump_write(cprm->file, shdr4extnum,
+				   sizeof(*shdr4extnum)))
+			goto end_coredump;
+	}
+
 	if (file->f_pos != offset) {
 		/* Sanity check */
 		printk(KERN_WARNING
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
diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index cfda74f..e687bc3 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -166,5 +166,6 @@ elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
 			   unsigned long limit);
 extern int
 elf_core_write_extra_data(struct file *file, size_t *size, unsigned long limit);
+extern size_t elf_core_extra_data_size(void);
 
 #endif /* _LINUX_ELFCORE_H */
diff --git a/kernel/elfcore.c b/kernel/elfcore.c
index 5445741..ff915ef 100644
--- a/kernel/elfcore.c
+++ b/kernel/elfcore.c
@@ -21,3 +21,8 @@ int __weak elf_core_write_extra_data(struct file *file, size_t *size,
 {
 	return 1;
 }
+
+size_t __weak elf_core_extra_data_size(void)
+{
+	return 0;
+}
-- 
1.6.5.1

