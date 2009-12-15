Return-Path: <linux-kernel-owner+w=401wt.eu-S1758992AbZLOClZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992AbZLOClZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbZLOClY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:41:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56744 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723AbZLOClW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:41:22 -0500
Date: Tue, 15 Dec 2009 11:41:18 +0900 (JST)
Message-Id: <20091215.114118.226800461.d.hatayama@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jdike@addtoit.com, tony.luck@intel.com,
       mhiramat@redhat.com
Subject: [RFC, PATCH 1/4] cleanup elf_core_dump(): remove ELF_CORE_EXTRA_*
 macro
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

elf_core_dump() uses #ifdef and the corresponding macro for hiding
_multiline_ logics in functions. This patch removes #ifdef and
replaces ELF_CORE_EXTRA_* by corresponding functions. For
architectures not implemeonting ELF_CORE_EXTRA_*, we use weak
functions in order to reduce a range of modification.

This cleanup is for my next patches, but I think this cleanup itself
is worth doing regardless of my firnal purpose.

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
---
 arch/ia64/kernel/Makefile  |    2 +
 arch/ia64/kernel/elfcore.c |   75 ++++++++++++++++++++++++++++++++++++++++++
 arch/um/sys-i386/Makefile  |    2 +
 arch/um/sys-i386/elfcore.c |   78 ++++++++++++++++++++++++++++++++++++++++++++
 fs/binfmt_elf.c            |   36 +++++++++++++++-----
 include/linux/elf.h        |    2 +
 6 files changed, 186 insertions(+), 9 deletions(-)
 create mode 100644 arch/ia64/kernel/elfcore.c
 create mode 100644 arch/um/sys-i386/elfcore.c

diff --git a/arch/ia64/kernel/Makefile b/arch/ia64/kernel/Makefile
index 6b7edca..5e8d09a 100644
--- a/arch/ia64/kernel/Makefile
+++ b/arch/ia64/kernel/Makefile
@@ -51,6 +51,8 @@ endif
 obj-$(CONFIG_DMAR)		+= pci-dma.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
 
+obj-$(CONFIG_BINFMT_ELF)	+= elfcore.o
+
 # fp_emulate() expects f2-f5,f16-f31 to contain the user-level state.
 CFLAGS_traps.o  += -mfixed-range=f2-f5,f16-f31
 
diff --git a/arch/ia64/kernel/elfcore.c b/arch/ia64/kernel/elfcore.c
new file mode 100644
index 0000000..9c0dd8b
--- /dev/null
+++ b/arch/ia64/kernel/elfcore.c
@@ -0,0 +1,75 @@
+#include <linux/elf.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+
+#include <asm/elf.h>
+
+static int dump_write(struct file *file, const void *addr, int nr)
+{
+	return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
+}
+
+/*
+ * These functions parameterize elf_core_dump in fs/binfmt_elf.c to write out
+ * extra segments containing the gate DSO contents.  Dumping its
+ * contents makes post-mortem fully interpretable later without matching up
+ * the same kernel and hardware config to see what PC values meant.
+ * Dumping its extra ELF program headers includes all the other information
+ * a debugger needs to easily find how the gate DSO was being used.
+ */
+Elf64_Half elf_core_extra_phdrs(void)
+{
+	return GATE_EHDR->e_phnum;
+}
+
+int elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
+			       unsigned long limit)
+{
+	const struct elf_phdr *const gate_phdrs =
+		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);
+	int i;
+	Elf64_Off ofs = 0;
+
+	for (i = 0; i < GATE_EHDR->e_phnum; ++i) {
+		struct elf_phdr phdr = gate_phdrs[i];
+
+		if (phdr.p_type == PT_LOAD) {
+			phdr.p_memsz = PAGE_ALIGN(phdr.p_memsz);
+			phdr.p_filesz = phdr.p_memsz;
+			if (ofs == 0) {
+				ofs = phdr.p_offset = offset;
+				offset += phdr.p_filesz;
+			} else {
+				phdr.p_offset = ofs;
+			}
+		} else {
+			phdr.p_offset += ofs;
+		}
+		phdr.p_paddr = 0; /* match other core phdrs */
+		*size += sizeof(phdr);
+		if (*size > limit || !dump_write(file, &phdr, sizeof(phdr)))
+			return 0;
+	}
+	return 1;
+}
+
+int elf_core_write_extra_data(struct file *file, size_t *size,
+			      unsigned long limit)
+{
+	const struct elf_phdr *const gate_phdrs =
+		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);
+	int i;
+
+	for (i = 0; i < GATE_EHDR->e_phnum; ++i) {
+		if (gate_phdrs[i].p_type == PT_LOAD) {
+			void *addr = (void *)gate_phdrs[i].p_vaddr;
+			size_t memsz = PAGE_ALIGN(gate_phdrs[i].p_memsz);
+
+			*size += memsz;
+			if (*size > limit || !dump_write(file, addr, memsz))
+				return 0;
+			break;
+		}
+	}
+	return 1;
+}
diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
index 1b549bc..804b28d 100644
--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -6,6 +6,8 @@ obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 	ptrace_user.o setjmp.o signal.o stub.o stub_segv.o syscalls.o sysrq.o \
 	sys_call_table.o tls.o
 
+obj-$(CONFIG_BINFMT_ELF) += elfcore.o
+
 subarch-obj-y = lib/semaphore_32.o lib/string_32.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
diff --git a/arch/um/sys-i386/elfcore.c b/arch/um/sys-i386/elfcore.c
new file mode 100644
index 0000000..4e320f0
--- /dev/null
+++ b/arch/um/sys-i386/elfcore.c
@@ -0,0 +1,78 @@
+#include <linux/elf.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+
+#include <asm/elf.h>
+
+static int dump_write(struct file *file, const void *addr, int nr)
+{
+	return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
+}
+
+/*
+ * These functions parameterize elf_core_dump in fs/binfmt_elf.c to write out
+ * extra segments containing the vsyscall DSO contents.  Dumping its
+ * contents makes post-mortem fully interpretable later without matching up
+ * the same kernel and hardware config to see what PC values meant.
+ * Dumping its extra ELF program headers includes all the other information
+ * a debugger needs to easily find how the vsyscall DSO was being used.
+ */
+Elf32_Half elf_core_extra_phdrs(void)
+{
+	return vsyscall_ehdr ? (((struct elfhdr *)vsyscall_ehdr)->e_phnum) : 0;
+}
+
+int elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
+			       unsigned long limit)
+{
+	if ( vsyscall_ehdr ) {
+		const struct elfhdr *const ehdrp =
+			(struct elfhdr *) vsyscall_ehdr;
+		const struct elf_phdr *const phdrp =
+			(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);
+		int i;
+		Elf32_Off ofs = 0;
+
+		for (i = 0; i < ehdrp->e_phnum; ++i) {
+			struct elf_phdr phdr = phdrp[i];
+
+			if (phdr.p_type == PT_LOAD) {
+				ofs = phdr.p_offset = offset;
+				offset += phdr.p_filesz;
+			} else {
+				phdr.p_offset += ofs;
+			}
+			phdr.p_paddr = 0; /* match other core phdrs */
+			*size += sizeof(phdr);
+			if (*size > limit
+			    || !dump_write(file, &phdr, sizeof(phdr)))
+				return 0;
+		}
+	}
+	return 1;
+}
+
+int elf_core_write_extra_data(struct file *file, size_t *size,
+			      unsigned long limit)
+{
+	if ( vsyscall_ehdr ) {
+		const struct elfhdr *const ehdrp =
+			(struct elfhdr *) vsyscall_ehdr;
+		const struct elf_phdr *const phdrp =
+			(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);
+		int i;
+
+		for (i = 0; i < ehdrp->e_phnum; ++i) {
+			if (phdrp[i].p_type == PT_LOAD) {
+				void *addr = (void *) phdrp[i].p_vaddr;
+				size_t filesz = phdrp[i].p_filesz;
+
+				*size += filesz;
+				if (*size > limit
+				    || !dump_write(file, addr, filesz))
+					return 0;
+			}
+		}
+	}
+	return 1;
+}
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index b9b3bb5..5f7be51 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1900,6 +1900,28 @@ static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
 }
 
 /*
+ * It's been implemented that some architectures write out some extra
+ * data into segments. On the other hand, other architechtures use
+ * these dummy functions and hence do nothing.
+ */
+Elf_Half __weak elf_core_extra_phdrs(void)
+{
+	return 0;
+}
+
+int __weak elf_core_write_extra_phdrs(struct file *file, loff_t offset,
+				      size_t *size, unsigned long limit)
+{
+	return 1;
+}
+
+int __weak elf_core_write_extra_data(struct file *file, size_t *size,
+				     unsigned long limit)
+{
+	return 1;
+}
+
+/*
  * Actual dumper
  *
  * This is a two-pass process; first we find the offsets of the bits,
@@ -1939,9 +1961,7 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	 * Please check DEFAULT_MAX_MAP_COUNT definition when you modify here.
 	 */
 	segs = current->mm->map_count;
-#ifdef ELF_CORE_EXTRA_PHDRS
-	segs += ELF_CORE_EXTRA_PHDRS;
-#endif
+	segs += elf_core_extra_phdrs();
 
 	gate_vma = get_gate_vma(current);
 	if (gate_vma != NULL)
@@ -2009,9 +2029,8 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 		DUMP_WRITE(&phdr, sizeof(phdr));
 	}
 
-#ifdef ELF_CORE_WRITE_EXTRA_PHDRS
-	ELF_CORE_WRITE_EXTRA_PHDRS;
-#endif
+	if (!elf_core_write_extra_phdrs(file, offset, &size, limit))
+		goto end_coredump;
 
  	/* write out the notes section */
 	if (!write_note_info(&info, file, &foffset))
@@ -2049,9 +2068,8 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 		}
 	}
 
-#ifdef ELF_CORE_WRITE_EXTRA_DATA
-	ELF_CORE_WRITE_EXTRA_DATA;
-#endif
+	if (!elf_core_write_extra_data(file, &size, limit))
+		goto end_coredump;
 
 end_coredump:
 	set_fs(fs);
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 90a4ed0..d103127 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -386,6 +386,7 @@ extern Elf32_Dyn _DYNAMIC [];
 #define elf_phdr	elf32_phdr
 #define elf_note	elf32_note
 #define elf_addr_t	Elf32_Off
+#define Elf_Half	Elf32_Half
 
 #else
 
@@ -394,6 +395,7 @@ extern Elf64_Dyn _DYNAMIC [];
 #define elf_phdr	elf64_phdr
 #define elf_note	elf64_note
 #define elf_addr_t	Elf64_Off
+#define Elf_Half	Elf64_Half
 
 #endif
 
-- 
1.6.5.1

