Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZJZGEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZJZGEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 02:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZJZGEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 02:04:11 -0400
Received: from icculus.org ([67.106.77.212]:33703 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787AbZJZGEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 02:04:09 -0400
Date: Mon, 26 Oct 2009 02:03:42 -0400 (EDT)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@andre.icculuslan
To: "Anton D. Kachalov" <mouse@mayc.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] binfmt_elf: FatELF support in the binary loader.
In-Reply-To: <alpine.OSX.1.10.0910241242570.2441@caridad.icculuslan>
Message-ID: <alpine.DEB.2.00.0910260157580.21285@andre.icculuslan>
References: <4AE17C1A.4060009@mayc.ru> <alpine.OSX.1.10.0910231933550.2186@caridad.icculuslan> <4AE2C218.2040306@mayc.ru> <alpine.OSX.1.10.0910241242570.2441@caridad.icculuslan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > It's necessary if you would like to use setarch to choose binaries on biarch
> > systems.
> 
> I didn't understand that when I first looked at the patch; sorry for any 
> confusion I caused. I should probably add a similar test to FatELF.

...and now I have.

This is the same as the previous revision of my patch, plus a few lines to 
check the personality, so setarch(8) can be used to force a 32-bit record 
to be selected. Thanks to Anton for the idea!



>From 083ebfa908c1bfbdabf81e921f3ce6b5d430bcb9 Mon Sep 17 00:00:00 2001
From: Ryan C. Gordon <icculus@icculus.org>
Date: Mon, 26 Oct 2009 01:50:41 -0400
Subject: [PATCH] binfmt_elf: FatELF support in the binary loader.

This allows the kernel to load a single file that contains multiple ELF
binaries (a "FatELF" file), selecting the correct one for the system.

Details, rationale, tools, and patches for handling FatELF binaries can be
found at http://icculus.org/fatelf/

Signed-off-by: Ryan C. Gordon <icculus@icculus.org>
---
 arch/ia64/ia32/binfmt_elf32.c |    4 +-
 fs/binfmt_elf.c               |  159 ++++++++++++++++++++++++++++++++++------
 include/linux/elf.h           |   23 ++++++
 3 files changed, 160 insertions(+), 26 deletions(-)

diff --git a/arch/ia64/ia32/binfmt_elf32.c b/arch/ia64/ia32/binfmt_elf32.c
index c69552b..02d5dd1 100644
--- a/arch/ia64/ia32/binfmt_elf32.c
+++ b/arch/ia64/ia32/binfmt_elf32.c
@@ -223,12 +223,12 @@ elf32_set_personality (void)
 
 static unsigned long
 elf32_map(struct file *filep, unsigned long addr, struct elf_phdr *eppnt,
-		int prot, int type, unsigned long unused)
+		int prot, int type, unsigned long unused, unsigned long base)
 {
 	unsigned long pgoff = (eppnt->p_vaddr) & ~IA32_PAGE_MASK;
 
 	return ia32_do_mmap(filep, (addr & IA32_PAGE_MASK), eppnt->p_filesz + pgoff, prot, type,
-			    eppnt->p_offset - pgoff);
+			    (eppnt->p_offset + base) - pgoff);
 }
 
 #define cpu_uses_ia32el()	(local_cpu_data->family > 0x1f)
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index b9b3bb5..a195024 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -37,8 +37,9 @@
 
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
-static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
-				int, int, unsigned long);
+static unsigned long 
+elf_map(struct file *, unsigned long, struct elf_phdr *,
+				int, int, unsigned long, unsigned long);
 
 /*
  * If we don't support core dumping, then supply a NULL so we
@@ -319,7 +320,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 
 static unsigned long elf_map(struct file *filep, unsigned long addr,
 		struct elf_phdr *eppnt, int prot, int type,
-		unsigned long total_size)
+		unsigned long total_size, unsigned long base_offset)
 {
 	unsigned long map_addr;
 	unsigned long size = eppnt->p_filesz + ELF_PAGEOFFSET(eppnt->p_vaddr);
@@ -343,11 +344,14 @@ static unsigned long elf_map(struct file *filep, unsigned long addr,
 	*/
 	if (total_size) {
 		total_size = ELF_PAGEALIGN(total_size);
-		map_addr = do_mmap(filep, addr, total_size, prot, type, off);
+		map_addr = do_mmap(filep, addr, total_size, prot, type,
+		                   off + base_offset);
 		if (!BAD_ADDR(map_addr))
 			do_munmap(current->mm, map_addr+size, total_size-size);
-	} else
-		map_addr = do_mmap(filep, addr, size, prot, type, off);
+	} else {
+		map_addr = do_mmap(filep, addr, size, prot, type,
+		                   off + base_offset);
+	}
 
 	up_write(&current->mm->mmap_sem);
 	return(map_addr);
@@ -381,7 +385,7 @@ static unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
 
 static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 		struct file *interpreter, unsigned long *interp_map_addr,
-		unsigned long no_base)
+		unsigned long no_base, unsigned long base_offset)
 {
 	struct elf_phdr *elf_phdata;
 	struct elf_phdr *eppnt;
@@ -419,7 +423,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 	if (!elf_phdata)
 		goto out;
 
-	retval = kernel_read(interpreter, interp_elf_ex->e_phoff,
+	retval = kernel_read(interpreter, interp_elf_ex->e_phoff + base_offset,
 			     (char *)elf_phdata,size);
 	error = -EIO;
 	if (retval != size) {
@@ -455,7 +459,8 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 				load_addr = -vaddr;
 
 			map_addr = elf_map(interpreter, load_addr + vaddr,
-					eppnt, elf_prot, elf_type, total_size);
+					eppnt, elf_prot, elf_type, total_size,
+					base_offset);
 			total_size = 0;
 			if (!*interp_map_addr)
 				*interp_map_addr = map_addr;
@@ -560,10 +565,97 @@ static unsigned long randomize_stack_top(unsigned long stack_top)
 #endif
 }
 
+
+/*
+ * See if we're a valid FatELF binary, find the right record, and
+ *  load (*elf) with the actual ELF header. Sets (*offset) to the
+ *  base offset of the chosen ELF binary. Returns 0 on success or a negative
+ *  error code.
+ * If we're not a FatELF binary, (*elf) is loaded with the existing contents
+ *  of (buf) and 0 is returned.
+ */
+static int examine_fatelf(struct file *file, const char *filename, char *buf,
+		int buflen, unsigned long *offset, struct elfhdr *elf)
+{
+	int records, i, rc;
+	const Fatelf_hdr *fatelf = (Fatelf_hdr *) buf;
+
+#if ((BITS_PER_LONG == 64) && (ELF_CLASS == ELFCLASS64) && CONFIG_COMPAT)
+	if (unlikely(personality(current->personality) == PER_LINUX32))
+		return -ENOEXEC;  /* want to force 32-bit record! */
+#endif
+
+	if (likely(le32_to_cpu(fatelf->magic) != FATELF_MAGIC)) {
+		*elf = *((struct elfhdr *)buf);  /* treat like normal ELF. */
+		return 0;  /* not a FatELF binary; not an error. */
+	}
+
+	if (unlikely(le16_to_cpu(fatelf->version) != 1))
+		return -ENOEXEC; /* Unrecognized format version. */
+
+	/*
+	 * In theory, there could be 255 separate records packed into this
+	 *  binary, but for now, bprm->buf (128 bytes) holds exactly 5
+	 *  records with the fatelf header, and that seems reasonable for
+	 *  most uses. We could add the complexity to read more records later
+	 *  if there's a serious need.
+	 */
+	records = (int) fatelf->num_records;  /* uint8, no byteswap needed */
+	if (unlikely(records > 5))
+		records = 5;  /* clamp, in case we find one we can use. */
+
+	for (i = 0; i < records; i++) {
+		const Fatelf_record *record = &fatelf->records[i];
+		const __u8 osabi = record->osabi;
+		const int abiok = likely( likely(osabi == ELFOSABI_NONE) ||
+		                          unlikely(osabi == ELFOSABI_LINUX) );
+
+		/* Fill in the data elf_check_arch() might care about. */
+		elf->e_ident[EI_OSABI] = record->osabi;
+		elf->e_ident[EI_CLASS] = record->word_size;
+		elf->e_ident[EI_DATA] = record->byte_order;
+		elf->e_machine = le16_to_cpu(record->machine);
+
+		if (unlikely(elf_check_arch(elf))
+		    && likely(abiok)
+		    && likely(record->osabi_version == 0)) {
+			/* We can support this ELF arch/abi. */
+			const __u64 rec_offset = le64_to_cpu(record->offset);
+			const __u64 rec_size = le64_to_cpu(record->size);
+			const __u64 end_offset = rec_offset + rec_size;
+			const unsigned long uloff = (unsigned long) rec_offset;
+
+#if BITS_PER_LONG == 32
+			if (unlikely(end_offset > 0xFFFFFFFF))
+				continue;
+#endif
+
+			if (unlikely(end_offset < rec_offset))
+				continue;  /* overflow (corrupt file?) */
+			if (unlikely(ELF_PAGEOFFSET(uloff) != 0))
+				continue;  /* bad alignment. */
+
+			/* replace the FatELF data with the real ELF header. */
+			rc = kernel_read(file, uloff, (char*) elf, sizeof(*elf));
+			if (unlikely((rc != sizeof(*elf)) && (rc >= 0)))
+				rc = -EIO;
+			else if (likely(rc == sizeof(*elf))) {
+				*offset = uloff;
+				rc = 0;
+			}
+
+			return rc;
+		}
+	}
+
+	return -ENOEXEC;  /* no binaries we could use. */
+}
+
+
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 {
 	struct file *interpreter = NULL; /* to shut gcc up */
- 	unsigned long load_addr = 0, load_bias = 0;
+	unsigned long load_addr = 0, load_bias = 0;
 	int load_addr_set = 0;
 	char * elf_interpreter = NULL;
 	unsigned long error;
@@ -571,6 +663,8 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	unsigned long elf_bss, elf_brk;
 	int retval, i;
 	unsigned int size;
+	unsigned long base_offset = 0;
+	unsigned long interp_base_offset = 0;
 	unsigned long elf_entry;
 	unsigned long interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
@@ -587,9 +681,11 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		retval = -ENOMEM;
 		goto out_ret;
 	}
-	
-	/* Get the exec-header */
-	loc->elf_ex = *((struct elfhdr *)bprm->buf);
+
+	retval = examine_fatelf(bprm->file, bprm->filename, bprm->buf,
+	                        BINPRM_BUF_SIZE, &base_offset, &loc->elf_ex);
+	if (unlikely(retval < 0))
+		goto out_ret;
 
 	retval = -ENOEXEC;
 	/* First of all, some simple consistency checks */
@@ -615,7 +711,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (!elf_phdata)
 		goto out;
 
-	retval = kernel_read(bprm->file, loc->elf_ex.e_phoff,
+	retval = kernel_read(bprm->file, loc->elf_ex.e_phoff + base_offset,
 			     (char *)elf_phdata, size);
 	if (retval != size) {
 		if (retval >= 0)
@@ -649,7 +745,8 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			if (!elf_interpreter)
 				goto out_free_ph;
 
-			retval = kernel_read(bprm->file, elf_ppnt->p_offset,
+			retval = kernel_read(bprm->file,
+					     elf_ppnt->p_offset + base_offset,
 					     elf_interpreter,
 					     elf_ppnt->p_filesz);
 			if (retval != elf_ppnt->p_filesz) {
@@ -704,8 +801,13 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 				goto out_free_dentry;
 			}
 
-			/* Get the exec headers */
-			loc->interp_elf_ex = *((struct elfhdr *)bprm->buf);
+			retval = examine_fatelf(interpreter, elf_interpreter,
+			                        bprm->buf, BINPRM_BUF_SIZE,
+			                        &interp_base_offset,
+			                        &loc->interp_elf_ex);
+			if (unlikely(retval < 0)) {
+				goto out_free_dentry;
+			}
 			break;
 		}
 		elf_ppnt++;
@@ -830,7 +932,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		}
 
 		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
-				elf_prot, elf_flags, 0);
+				elf_prot, elf_flags, 0, base_offset);
 		if (BAD_ADDR(error)) {
 			send_sig(SIGKILL, current, 0);
 			retval = IS_ERR((void *)error) ?
@@ -911,7 +1013,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		elf_entry = load_elf_interp(&loc->interp_elf_ex,
 					    interpreter,
 					    &interp_map_addr,
-					    load_bias);
+					    load_bias, interp_base_offset);
 		if (!IS_ERR((void *)elf_entry)) {
 			/*
 			 * load_elf_interp() returns relocation
@@ -1026,11 +1128,19 @@ static int load_elf_library(struct file *file)
 	unsigned long elf_bss, bss, len;
 	int retval, error, i, j;
 	struct elfhdr elf_ex;
+	unsigned long base_offset = 0;
+	char buf[BINPRM_BUF_SIZE];
 
-	error = -ENOEXEC;
-	retval = kernel_read(file, 0, (char *)&elf_ex, sizeof(elf_ex));
-	if (retval != sizeof(elf_ex))
+	retval = kernel_read(file, 0, buf, sizeof(buf));
+	if (unlikely(retval != sizeof(buf))) {
+		error = (retval >= 0) ? -EIO : retval;
 		goto out;
+	}
+	error = examine_fatelf(file, 0, buf, sizeof(buf), &base_offset, &elf_ex);
+	if (unlikely(retval < 0)) {
+		goto out;
+	}
+	error = -ENOEXEC;
 
 	if (memcmp(elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
 		goto out;
@@ -1052,7 +1162,8 @@ static int load_elf_library(struct file *file)
 
 	eppnt = elf_phdata;
 	error = -ENOEXEC;
-	retval = kernel_read(file, elf_ex.e_phoff, (char *)eppnt, j);
+	retval = kernel_read(file, elf_ex.e_phoff + base_offset,
+	                     (char *)eppnt, j);
 	if (retval != j)
 		goto out_free_ph;
 
@@ -1074,7 +1185,7 @@ static int load_elf_library(struct file *file)
 			PROT_READ | PROT_WRITE | PROT_EXEC,
 			MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE,
 			(eppnt->p_offset -
-			 ELF_PAGEOFFSET(eppnt->p_vaddr)));
+			 ELF_PAGEOFFSET(eppnt->p_vaddr)) + base_offset);
 	up_write(&current->mm->mmap_sem);
 	if (error != ELF_PAGESTART(eppnt->p_vaddr))
 		goto out_free_ph;
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 90a4ed0..ded1fb6 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -33,6 +33,29 @@ typedef __u32	Elf64_Word;
 typedef __u64	Elf64_Xword;
 typedef __s64	Elf64_Sxword;
 
+/* FatELF (multiple ELF binaries in one file) support */
+#define FATELF_MAGIC (0x1F0E70FA)
+
+typedef struct Fatelf_record {
+  __le16 machine;      /* maps to e_machine */
+  __u8 osabi;          /* maps to e_ident[EI_OSABI] */
+  __u8 osabi_version;  /* maps to e_ident[EI_ABIVERSION] */
+  __u8 word_size;      /* maps to e_ident[EI_CLASS] */
+  __u8 byte_order;     /* maps to e_ident[EI_DATA] */
+  __u8 reserved0;
+  __u8 reserved1;
+  __le64 offset;
+  __le64 size;
+} Fatelf_record;
+
+typedef struct Fatelf_hdr {
+  __le32 magic;
+  __le16 version;
+  __u8 num_records;
+  __u8 reserved0;
+  Fatelf_record records[];
+} Fatelf_hdr;
+
 /* These constants are for the segment types stored in the image headers */
 #define PT_NULL    0
 #define PT_LOAD    1
-- 
1.6.0.4



