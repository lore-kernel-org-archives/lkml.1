Return-Path: <linux-kernel-owner+w=401wt.eu-S1751090AbXC3SHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbXC3SHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbXC3SHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:07:41 -0400
Received: from smtpout.mac.com ([17.250.248.185]:61536 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbXC3SHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:07:39 -0400
In-Reply-To: <5E1467FD-223A-46DD-9A03-5EA20B5D4842@mac.com>
References: <5E1467FD-223A-46DD-9A03-5EA20B5D4842@mac.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-1--597678190
Message-Id: <1EDA02E4-1017-4475-BA75-D07864077195@mac.com>
Cc: LKML Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: [RFC][PATCH 1/2] Darwinux: Minimalist Mach-O binary format support
Date: Fri, 30 Mar 2007 14:06:57 -0400
To: Kyle Moffett <mrmacman_g4@mac.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-1--597678190
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Minimalist Mach-O binary format support

This code is sucessfully able to load and recognize Mach-O binary files.
It is able to sort through the FAT file headers and identify compatible
files, although it currently is hardcoded for PowerPC64 architecture.

Does not yet support load_commands or actually mapping the Mach-O files
into memory.

Signed-off-by: Kyle Moffett <mrmacman_g4@mac.com>
---
fs/Kconfig.binfmt   |   14 ++
fs/Makefile         |    1 +
fs/mach-o/Makefile  |    8 ++
fs/mach-o/binfmt.c  |  321 +++++++++++++++++++++++++++++++++++++++++++ 
++++++
fs/mach-o/cpus.h    |  329 +++++++++++++++++++++++++++++++++++++++++++ 
++++++++
fs/mach-o/debug.h   |    9 ++
fs/mach-o/files.h   |  139 ++++++++++++++++++++++
fs/mach-o/headers.h |   49 ++++++++
8 files changed, 870 insertions(+), 0 deletions(-)


--Apple-Mail-1--597678190
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	x-unix-mode=0644;
	name=darwinux_01.txt
Content-Disposition: attachment;
	filename=darwinux_01.txt

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index f3d3d81..c29b544 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -55,6 +55,20 @@ config BINFMT_SHARED_FLAT
 	help
 	  Support FLAT shared libraries
 
+config BINFMT_MACHO
+	tristate "Kernel support for Mach-O and FAT Mach-O binaries"
+	---help---
+	  Mach-O (Mach Object) is a format for libraries and executables used
+	  by the Mach and Darwin operating systems on multiple architectures.
+	  Saying Y here will enable your kernel to run Mach-O binaries built
+	  for your platform.  If the program or library is a FAT Mach-O
+	  binary then it may be run on any platform where an appropriate
+	  binary exists.
+
+	  If you wish to actually run programs compiled for either Darwin or
+	  Mac OS X, you probably also want to enable
+	  "Darwin syscall personality support" for your architecture.
+
 config BINFMT_AOUT
 	tristate "Kernel support for a.out and ECOFF binaries"
 	depends on X86_32 || ALPHA || ARM || M68K || SPARC32
diff --git a/fs/Makefile b/fs/Makefile
index 9edf411..bd70dd3 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
 obj-$(CONFIG_BINFMT_ELF_FDPIC)	+= binfmt_elf_fdpic.o
 obj-$(CONFIG_BINFMT_SOM)	+= binfmt_som.o
 obj-$(CONFIG_BINFMT_FLAT)	+= binfmt_flat.o
+obj-$(CONFIG_BINFMT_MACHO)	+= mach-o/
 
 obj-$(CONFIG_FS_MBCACHE)	+= mbcache.o
 obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.o xattr_acl.o
diff --git a/fs/mach-o/Makefile b/fs/mach-o/Makefile
new file mode 100644
index 0000000..9d1d374
--- /dev/null
+++ b/fs/mach-o/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for Mach-O binary format support
+#
+
+obj-$(CONFIG_BINFMT_MACHO) += binfmt_mach-o.o
+
+binfmt_mach-o-objs := binfmt.o
+
diff --git a/fs/mach-o/binfmt.c b/fs/mach-o/binfmt.c
new file mode 100644
index 0000000..b5ea936
--- /dev/null
+++ b/fs/mach-o/binfmt.c
@@ -0,0 +1,321 @@
+/*
+ * linux/fs/mach-o/binfmt.c
+ *
+ * These are the functions used to load Mach-O format executables as used
+ * on Mac OS X and Darwin machines.
+ *
+ * Copyright (C) 2006, Kyle Moffett <mrmacman_g4@mac.com>
+ *
+ * Designed from public documentation and Darwin sources as well as the Linux
+ * ELF loader by Eric Youngdale (ericy@cais.com).
+ */
+
+#include <linux/module.h>
+#include <linux/binfmts.h>
+#include <linux/fs.h>
+#include <linux/err.h>
+
+#include "debug.h"
+#include "cpus.h"
+#include "headers.h"
+#include "files.h"
+
+#if 0
+#include <linux/kernel.h>
+#include <linux/stat.h>
+#include <linux/time.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/a.out.h>
+#include <linux/errno.h>
+#include <linux/signal.h>
+#include <linux/string.h>
+#include <linux/file.h>
+#include <linux/fcntl.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/shm.h>
+#include <linux/personality.h>
+#include <linux/elfcore.h>
+#include <linux/init.h>
+#include <linux/highuid.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/compiler.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+#include <linux/security.h>
+#include <linux/syscalls.h>
+#include <linux/random.h>
+
+#include <asm/uaccess.h>
+#include <asm/param.h>
+#include <asm/page.h>
+#endif
+
+MODULE_LICENSE("GPL");
+
+/* Function prototypes */
+static unsigned long get_arch_offset(struct linux_binprm *bprm);
+static int load_macho_binary(struct linux_binprm *bprm, struct pt_regs *regs);
+
+/* Mach-O binary format */
+static struct linux_binfmt binfmt_macho = {
+	.module		= THIS_MODULE,
+	.load_binary	= load_macho_binary,
+	.load_shlib	= NULL,
+	.core_dump	= NULL,
+	.min_coredump	= PAGE_SIZE,
+};
+
+/* Module init and exit */
+static int __init init_binfmt_macho(void)
+{
+	return register_binfmt(&binfmt_macho);
+}
+core_initcall(init_binfmt_macho);
+
+static void __exit exit_binfmt_macho(void)
+{
+	unregister_binfmt(&binfmt_macho);
+}
+module_exit(exit_binfmt_macho);
+
+
+/*
+ * Read Mach-O file headers to find out where our architecture-specific
+ * portion is.
+ */
+#define MAX_ARCH_COUNT (PAGE_SIZE/sizeof(struct macho_fat_arch))
+static unsigned long get_arch_offset(struct linux_binprm *bprm)
+{
+	struct macho_fat_header *header;
+	struct macho_fat_arch *archs;
+	unsigned long arch_count, arch_data, i, offset = 0;
+	long retval;
+	unsigned int best_pref, best_arch;
+
+	/* Without a FAT (multi-arch binary) header just assume no offset */
+	header = (struct macho_fat_header *)bprm->buf;
+	if (header->magic != MACHO_FAT_MAGIC)
+		goto out;
+
+	macho_dbg("Found a Mach-O FAT header!\n");
+
+	/* Figure out how many archs to read (no more than a page worth) */
+	arch_count = __be32_to_cpu(header->arch_count);
+	if (arch_count > MAX_ARCH_COUNT) {
+		macho_dbg("Too many archs (%lu) in Mach-O binary.  Only using"
+				" %lu!\n", arch_count, MAX_ARCH_COUNT);
+		arch_count = MAX_ARCH_COUNT;
+	}
+
+	/* Size of the architecture data (for kmalloc and read) */
+	arch_data = arch_count * sizeof(struct macho_fat_arch);
+
+	/* Allocate memory for the architecture list */
+	archs = kmalloc(arch_data, GFP_KERNEL);
+	if (!archs) {
+		offset = (unsigned long)(-ENOMEM);
+		goto out;
+	}
+
+	/* Read in the architecture list */
+	retval = kernel_read(bprm->file, sizeof(struct macho_fat_header),
+			(void *)archs, arch_data);
+	if (retval != arch_data) {
+		if (retval < 0) {
+			macho_dbg("Error while reading Mach-O architecture"
+					" list: %li\n", retval);
+			offset = (unsigned long)retval;
+		} else {
+			macho_dbg("Truncated arch list (got %lub, wanted"
+					" %lub)\n", retval, arch_data);
+			offset = (unsigned long)(-ENOEXEC);
+		}
+		goto out;
+	}
+
+	/*
+	 * Iterate over the architecture list looking for the most-preferred
+	 * arch.  NOTE:  An architecture with a preference of 0 is not
+	 * compatible with the current CPU.
+	 */
+	best_pref = 0;
+	best_arch = 0;
+	for (i = 0; i < arch_count; i++) {
+		unsigned int pref = macho_check_cpu(
+				__be32_to_cpu(archs[i].cpu_type),
+				__be32_to_cpu(archs[i].cpu_subtype));
+		if (best_pref < pref) {
+			best_pref = pref;
+			best_arch = i;
+		}
+	}
+
+	/* If we didn't find any useable architectures then give up */
+	if (best_pref == 0) {
+		macho_dbg("No compatible binaries in Mach-O FAT binary\n");
+		offset = (unsigned long)(-ENOEXEC);
+		goto out;
+	}
+
+	/* Pick up the offset of the best available architecture */
+	offset = __be32_to_cpu(archs[best_arch].offset);
+
+	/*
+	 * If the offset would be confused with an error value then
+	 * it's too big (4GB program binary?!?!?) and we should just
+	 * return ENOEXEC instead
+	 */
+	if (IS_ERR_VALUE(offset))
+		offset = (unsigned long)(-ENOEXEC);
+
+out:
+	return offset;
+}
+
+/*
+ * Load a Mach-O binary
+ */
+static int load_macho_binary(struct linux_binprm *bprm, struct pt_regs *regs)
+{
+	struct {
+		union {
+			/* The first 4 bytes of either header are the magic */
+			__u32 magic;
+			struct macho_mach32_header mach32;
+			struct macho_mach64_header mach64;
+		} header;
+#if 0
+		struct macho_loadcmd loadcmd;
+#endif
+	} *data = NULL;
+	unsigned long offset;
+	long retval;
+	int err;
+
+	/*
+	 * Read the Mach-O file headers to find the offset of our
+	 * architecture-specific portion
+	 */
+	offset = get_arch_offset(bprm);
+	if (IS_ERR_VALUE(offset)) {
+		err = (long)offset;
+		goto out;
+	}
+
+	/* Allocate space for the file headers and a load command */
+	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* Read the header data and check the magic */
+	retval = kernel_read(bprm->file, offset,
+			(void *)&data->header, sizeof(data->header));
+	if (retval != sizeof(data->header)) {
+		/*
+		 * If we didn't see an arch table then it must not really be
+		 * a Mach-O file so just return as not executable.
+		 */
+		if (!offset)
+			err = -ENOEXEC;
+
+		/* If kernel_read() returned an error, handle it */
+		else if (retval < 0) {
+			macho_dbg("Error while reading Mach-O object"
+					" header: %li\n", retval);
+			err = retval;
+		} else {
+			macho_dbg("Truncated Mach-O object header: "
+					"(got %lub, wanted %lub)\n", retval,
+					sizeof(data->header));
+			err = -ENOEXEC;
+		}
+		goto out;
+	}
+
+	/* Check for backwards-endian files */
+	if (data->header.magic == MACHO_MACH32_CIGAM ||
+			data->header.magic == MACHO_MACH64_CIGAM) {
+		macho_dbg("Wrong endianness in Mach-O file\n");
+		err = -ENOEXEC;
+		goto out;
+	}
+
+	/*
+	 * It's not a valid Mach-O file then return, but print an error
+	 * message first if it was embedded in a Mach-O FAT wrapper.
+	 */
+	if (data->header.magic != MACHO_MACH32_MAGIC &&
+			data->header.magic != MACHO_MACH64_MAGIC) {
+		if (offset)
+			macho_dbg("Corrupt embedded Mach-O object!\n");
+		err = -ENOEXEC;
+		goto out;
+	}
+
+	/* CPU type (lines up between 32-bit and 64-bit Mach-O files) */
+	if (!macho_check_cpu(data->header.mach32.cpu_type,
+			data->header.mach32.cpu_subtype)) {
+
+		/*
+		 * The CPU didn't match, so either this is Mach-O file is for
+		 * a different platform (offset == 0) or the FAT Mach-O has
+		 * been corrupted.
+		 */
+		if (offset)
+			macho_dbg("FAT Mach-O wrapper has mismatched CPU"
+					" types:  Mach-O file corrupt?\n");
+		else
+			macho_dbg("Wrong architecture in Mach-O file\n");
+		err = -ENOEXEC;
+		goto out;
+	}
+
+	/* File type (also lines up between 32-bit and 64-bit) */
+	if (!macho_check_file(data->header.mach32.filetype,
+			data->header.mach32.flags)) {
+		macho_dbg("Attempted to execute nonexecutable Mach-O file\n");
+		err = -ENOEXEC;
+		goto out;
+	}
+
+	/* Move past the Mach-O header to find the first load_command */
+	if (data->header.magic == MACHO_MACH32_MAGIC)
+		offset += sizeof(struct macho_mach32_header);
+	else
+		offset += sizeof(struct macho_mach64_header);
+
+	err = -EINVAL;
+	goto out;
+
+out:
+	kfree(data);
+	return err;
+}
+
+
+
+#if 0
+	char buf[BINPRM_BUF_SIZE];
+	struct page *page[MAX_ARG_PAGES];
+	struct mm_struct *mm;
+	unsigned long p; /* current top of mem */
+	int sh_bang;
+	struct file * file;
+	int e_uid, e_gid;
+	kernel_cap_t cap_inheritable, cap_permitted, cap_effective;
+	void *security;
+	int argc, envc;
+	char * filename;	/* Name of binary as seen by procps */
+	char * interp;		/* Name of the binary really executed. Most
+				   of the time same as filename, but could be
+				   different for binfmt_{misc,script} */
+	unsigned interp_flags;
+	unsigned interp_data;
+	unsigned long loader, exec;
+#endif
+
diff --git a/fs/mach-o/cpus.h b/fs/mach-o/cpus.h
new file mode 100644
index 0000000..a1f2276
--- /dev/null
+++ b/fs/mach-o/cpus.h
@@ -0,0 +1,329 @@
+#ifndef  _MACHO_CPUS_H
+# define _MACHO_CPUS_H 1
+
+# include <linux/compiler.h>
+# include <linux/types.h>
+# include <linux/err.h>
+
+/*
+ * Mach-O CPU types, borrowed from Darwin
+ */
+typedef __u32 __bitwise macho_cpu_type_t;
+#define _ENTRY(type, num) \
+	MACHO_CPU_TYPE_##type = ((__force macho_cpu_type_t)num)
+enum {
+	_ENTRY(VAX,	0x00000001),
+	_ENTRY(M68K,	0x00000006),
+	_ENTRY(I386,	0x00000007),
+	_ENTRY(MIPS,	0x00000008),
+	_ENTRY(M98K,	0x0000000a),
+	_ENTRY(PARISC,	0x0000000b),
+	_ENTRY(ARM,	0x0000000c),
+	_ENTRY(M88K,	0x0000000d),
+	_ENTRY(SPARC,	0x0000000e),
+	_ENTRY(I860,	0x0000000f),
+	_ENTRY(ALPHA,	0x00000010),
+	_ENTRY(PPC32,	0x00000012),
+	_ENTRY(PPC64,	0x01000012),
+	_ENTRY(ANY,	0xffffffff),
+};
+#undef _ENTRY
+
+/*
+ * Mach-O CPU subtypes, borrowed from Darwin
+ */
+typedef __u32 __bitwise macho_cpu_subtype_t;
+#define _ENTRY(subtype, num) \
+	MACHO_CPU_SUBTYPE_##subtype = ((__force macho_cpu_subtype_t)num)
+enum {
+	/* Generic CPU subtypes (unused?) */
+	_ENTRY(MULTIPLE,		0xffffffff),
+	_ENTRY(LITTLE_ENDIAN,		0x00000000),
+	_ENTRY(BIG_ENDIAN,		0x00000001),
+
+	/* VAX subtypes */
+	_ENTRY(VAX_ALL,			0x00000000),
+	_ENTRY(VAX_VAX780,		0x00000001),
+	_ENTRY(VAX_VAX785,		0x00000002),
+	_ENTRY(VAX_VAX750,		0x00000003),
+	_ENTRY(VAX_VAX730,		0x00000004),
+	_ENTRY(VAX_UVAXI,		0x00000005),
+	_ENTRY(VAX_UVAXII,		0x00000006),
+	_ENTRY(VAX_VAX8200,		0x00000007),
+	_ENTRY(VAX_VAX8500,		0x00000008),
+	_ENTRY(VAX_VAX8600,		0x00000009),
+	_ENTRY(VAX_VAX8650,		0x0000000a),
+	_ENTRY(VAX_VAX8800,		0x0000000b),
+	_ENTRY(VAX_UVAXIII,		0x0000000c),
+
+	/* Motorola 680x0 subtypes */
+	_ENTRY(M68K_MC680X0,		0x00000001),
+	_ENTRY(M68K_MC68040,		0x00000002),
+	_ENTRY(M68K_MC68030,		0x00000003),
+
+	/* Intel/AMD x86 subtypes */
+	_ENTRY(I386_ALL,		0x00000003),
+	_ENTRY(I386_386,		0x00000003),
+	_ENTRY(I386_486,		0x00000004),
+	_ENTRY(I386_486SX,		0x00000084),
+	_ENTRY(I386_586,		0x00000005),
+	_ENTRY(I386_PENTIUM,		0x00000005),
+	_ENTRY(I386_PPRO,		0x00000016),
+	_ENTRY(I386_PENTIUM2_M3,	0x00000036),
+	_ENTRY(I386_PENTIUM2_M5,	0x00000056),
+	_ENTRY(I386_CELERON,		0x00000067),
+	_ENTRY(I386_CELERON_M,		0x00000077),
+	_ENTRY(I386_PENTIUM3,		0x00000008),
+	_ENTRY(I386_PENTIUM3_M,		0x00000018),
+	_ENTRY(I386_PENTIUM3_XEON,	0x00000028),
+	_ENTRY(I386_PENTIUM_M,		0x00000009),
+	_ENTRY(I386_PENTIUM4,		0x0000000a),
+	_ENTRY(I386_PENTIUM4_M,		0x0000001a),
+	_ENTRY(I386_ITANIUM,		0x0000000b),
+	_ENTRY(I386_ITANIUM2,		0x0000001b),
+	_ENTRY(I386_XEON,		0x0000000c),
+	_ENTRY(I386_XEON_MP,		0x0000001c),
+
+	/* MIPS subtypes */
+	_ENTRY(MIPS_ALL,		0x00000000),
+	_ENTRY(MIPS_R2300,		0x00000001),
+	_ENTRY(MIPS_R2600,		0x00000002),
+	_ENTRY(MIPS_R2800,		0x00000003),
+	_ENTRY(MIPS_R2000A,		0x00000004),
+	_ENTRY(MIPS_R2000,		0x00000005),
+	_ENTRY(MIPS_R3000A,		0x00000006),
+	_ENTRY(MIPS_R3000,		0x00000007),
+
+	/* Motorola 98xxx subtypes */
+	_ENTRY(M98K_ALL,		0x00000000),
+	_ENTRY(M98K_MC98601,		0x00000001),
+
+	/* HPPA subtypes */
+	_ENTRY(PARISC_ALL,		0x00000000),
+	_ENTRY(PARISC_7100LC,		0x00000001),
+
+	/* Motorola 88xxx subtypes */
+	_ENTRY(M88K_ALL,		0x00000000),
+	_ENTRY(M88K_MC88100,		0x00000001),
+	_ENTRY(M88K_MC88110,		0x00000002),
+
+	/* Sparc subtypes */
+	_ENTRY(SPARC_ALL,		0x00000000),
+
+	/* I860?? subtypes */
+	_ENTRY(I860_ALL,		0x00000000),
+	_ENTRY(I860_860,		0x00000001),
+
+	/* Motorola/Freescale/IBM PowerPC subtypes */
+	_ENTRY(PPC32_ALL,		0x00000000),
+	_ENTRY(PPC32_601,		0x00000001),
+	_ENTRY(PPC32_602,		0x00000002),
+	_ENTRY(PPC32_603,		0x00000003),
+	_ENTRY(PPC32_603E,		0x00000004),
+	_ENTRY(PPC32_603EV,		0x00000005),
+	_ENTRY(PPC32_604,		0x00000006),
+	_ENTRY(PPC32_604E,		0x00000007),
+	_ENTRY(PPC32_620,		0x00000008),
+	_ENTRY(PPC32_750,		0x00000009),
+	_ENTRY(PPC32_7400,		0x0000000a),
+	_ENTRY(PPC32_7450,		0x0000000b),
+	_ENTRY(PPC32_970,		0x00000064),
+
+	/* Motorola/Freescale/IBM PowerPC64 subtypes */
+	_ENTRY(PPC64_ALL,		0x00000000),
+	/*_ENTRY(PPC64_970,		0x00000001),*/
+};
+#undef _ENTRY
+
+/*
+ * A CPU subtype mapping table with human-readable strings
+ */
+struct macho_cpu_subentry {
+	const char *		name;
+	macho_cpu_type_t	type;
+	macho_cpu_subtype_t	subtype;
+	unsigned int		preference;
+};
+
+#define _ENTRY(TYPE, SUBTYPE, NAME, PREFERENCE) {			\
+		.name = NAME,						\
+		.type = MACHO_CPU_TYPE_ ## TYPE,			\
+		.subtype = MACHO_CPU_SUBTYPE_ ## TYPE ## _ ## SUBTYPE,	\
+		.preference = (PREFERENCE)				\
+	}
+
+static const struct macho_cpu_subentry macho_cpu_vax_subtypes[] = {
+	_ENTRY(VAX,	ALL,		"all VAX",			 0),
+	_ENTRY(VAX,	VAX780,		"VAX-780",			 0),
+	_ENTRY(VAX,	VAX785,		"VAX-785",			 0),
+	_ENTRY(VAX,	VAX750,		"VAX-750",			 0),
+	_ENTRY(VAX,	VAX730,		"VAX-730",			 0),
+	_ENTRY(VAX,	UVAXI,		"UVAX-I",			 0),
+	_ENTRY(VAX,	UVAXII,		"UVAX-II",			 0),
+	_ENTRY(VAX,	VAX8200,	"VAX-8200",			 0),
+	_ENTRY(VAX,	VAX8500,	"VAX-8500",			 0),
+	_ENTRY(VAX,	VAX8600,	"VAX-8600",			 0),
+	_ENTRY(VAX,	VAX8650,	"VAX-8650",			 0),
+	_ENTRY(VAX,	VAX8800,	"VAX-8800",			 0),
+	_ENTRY(VAX,	UVAXIII,	"UVAX-III",			 0),
+	{ .name = NULL },
+};
+static const struct macho_cpu_subentry macho_cpu_m68k_subtypes[] = {
+	_ENTRY(M68K,	MC680X0,	"all Motorola 68xxx",		 0),
+	_ENTRY(M68K,	MC68040,	"Motorola 68040",		 0),
+	_ENTRY(M68K,	MC68030,	"Motorola 68030",		 0),
+	{ .name = NULL },
+};
+static const struct macho_cpu_subentry macho_cpu_i386_subtypes[] = {
+	_ENTRY(I386,	ALL,		"all Intel/AMD",		 0),
+	_ENTRY(I386,	386,		"Intel 386",			 0),
+	_ENTRY(I386,	486,		"Intel 486",			 0),
+	_ENTRY(I386,	486SX,		"Intel 486SX",			 0),
+	_ENTRY(I386,	586,		"Intel 586",			 0),
+	_ENTRY(I386,	PENTIUM,	"Intel Pentium",		 0),
+	_ENTRY(I386,	PPRO,		"Intel Pentium Pro",		 0),
+	_ENTRY(I386,	PENTIUM2_M3,	"Intel Pentium II M3",		 0),
+	_ENTRY(I386,	PENTIUM2_M5,	"Intel Pentium II M5",		 0),
+	_ENTRY(I386,	CELERON,	"Intel Celeron",		 0),
+	_ENTRY(I386,	CELERON_M,	"Intel Celeron/M",		 0),
+	_ENTRY(I386,	PENTIUM3,	"Intel Pentium III",		 0),
+	_ENTRY(I386,	PENTIUM3_M,	"Intel Pentium III M",		 0),
+	_ENTRY(I386,	PENTIUM3_XEON,	"Intel Pentium III Xeon",	 0),
+	_ENTRY(I386,	PENTIUM_M,	"Intel Pentium/M",		 0),
+	_ENTRY(I386,	PENTIUM4,	"Intel Pentium IV",		 0),
+	_ENTRY(I386,	PENTIUM4_M,	"Intel Pentium IV/M",		 0),
+	_ENTRY(I386,	ITANIUM,	"Intel Itanium",		 0),
+	_ENTRY(I386,	ITANIUM2,	"Intel Itanium 2",		 0),
+	_ENTRY(I386,	XEON,		"Intel Xeon",			 0),
+	_ENTRY(I386,	XEON_MP,	"Intel Xeon SMP",		 0),
+	{ .name = NULL },
+};
+static const struct macho_cpu_subentry macho_cpu_mips_subtypes[] = {
+	_ENTRY(MIPS,	ALL,		"all MIPS",			 0),
+	_ENTRY(MIPS,	R2300,		"MIPS r2300",			 0),
+	_ENTRY(MIPS,	R2600,		"MIPS r2600",			 0),
+	_ENTRY(MIPS,	R2800,		"MIPS r2800",			 0),
+	_ENTRY(MIPS,	R2000A,		"MIPS r2000a",			 0),
+	_ENTRY(MIPS,	R2000,		"MIPS r2000",			 0),
+	_ENTRY(MIPS,	R3000A,		"MIPS r3000a",			 0),
+	_ENTRY(MIPS,	R3000,		"MIPS r3000",			 0),
+	{ .name = NULL },
+};
+static const struct macho_cpu_subentry macho_cpu_m98k_subtypes[] = {
+	_ENTRY(M98K,	ALL,		"all Motorola 98xxx",		 0),
+	_ENTRY(M98K,	MC98601,	"Motorola 98601",		 0),
+	{ .name = NULL },
+};
+static const struct macho_cpu_subentry macho_cpu_parisc_subtypes[] = {
+	_ENTRY(PARISC,	ALL,		"all HPPA/PaRISC",		 0),
+	_ENTRY(PARISC,	7100LC,		"HPPA 7100LC",			 0),
+	{ .name = NULL },
+};
+static const struct macho_cpu_subentry macho_cpu_m88k_subtypes[] = {
+	_ENTRY(M88K,	ALL,		"All Motorola 88xxx",		 0),
+	_ENTRY(M88K,	MC88100,	"Motorola 88100",		 0),
+	_ENTRY(M88K,	MC88110,	"Motorola 88110",		 0),
+	{ .name = NULL },
+};
+static const struct macho_cpu_subentry macho_cpu_sparc_subtypes[] = {
+	_ENTRY(SPARC,	ALL,		"all Sparc",			 0),
+	{ .name = NULL },
+};
+static const struct macho_cpu_subentry macho_cpu_i860_subtypes[] = {
+	_ENTRY(I860,	ALL,		"all i860",			 0),
+	_ENTRY(I860,	860,		"i860",				 0),
+	{ .name = NULL },
+};
+static const struct macho_cpu_subentry macho_cpu_ppc32_subtypes[] = {
+	_ENTRY(PPC32,	ALL,		"all PowerPC",			 1),
+	_ENTRY(PPC32,	601,		"PowerPC 601",			 2),
+	_ENTRY(PPC32,	602,		"PowerPC 602",			 3),
+	_ENTRY(PPC32,	603,		"PowerPC 603",			 4),
+	_ENTRY(PPC32,	603E,		"PowerPC 603e",			 5),
+	_ENTRY(PPC32,	603EV,		"PowerPC 603ev",		 6),
+	_ENTRY(PPC32,	604,		"PowerPC 604",			 7),
+	_ENTRY(PPC32,	604E,		"PowerPC 604e",			 8),
+	_ENTRY(PPC32,	620,		"PowerPC 620",			 9),
+	_ENTRY(PPC32,	750,		"PowerPC 750",			10),
+	_ENTRY(PPC32,	7400,		"PowerPC 7400",			11),
+	_ENTRY(PPC32,	7450,		"PowerPC 7450",			12),
+	_ENTRY(PPC32,	970,		"PowerPC 970",			13),
+	{ .name = NULL },
+};
+static const struct macho_cpu_subentry macho_cpu_ppc64_subtypes[] = {
+	_ENTRY(PPC64,	ALL,		"all PowerPC64",		14),
+	/*_ENTRY(PPC64,	970,		"PowerPC 970",			 1),*/
+	{ .name = NULL },
+};
+#undef _ENTRY
+
+/*
+ * A CPU type mapping table with human-readable strings
+ */
+struct macho_cpu_entry {
+	const char *name;
+	macho_cpu_type_t type;
+	const struct macho_cpu_subentry *subtypes;
+};
+static const struct macho_cpu_entry macho_cpu_types[] = {
+#define _ENTRY(TYPE, SUBTYPES, NAME) {				\
+		.name = NAME,					\
+		.type = MACHO_CPU_TYPE_ ## TYPE,		\
+		.subtypes = SUBTYPES				\
+	}
+	_ENTRY(PPC32,	macho_cpu_ppc32_subtypes,	"PowerPC"	),
+	_ENTRY(PPC64,	macho_cpu_ppc64_subtypes,	"PowerPC64"	),
+	_ENTRY(I386,	macho_cpu_i386_subtypes,	"Intel x86"	),
+	_ENTRY(VAX,	macho_cpu_vax_subtypes,		"VAX"		),
+	_ENTRY(M68K,	macho_cpu_m68k_subtypes,	"Motorola 68xxx"),
+	_ENTRY(MIPS,	macho_cpu_mips_subtypes,	"MIPS"		),
+	_ENTRY(M98K,	macho_cpu_m98k_subtypes,	"Motorola 98xxx"),
+	_ENTRY(PARISC,	macho_cpu_parisc_subtypes,	"HPPA/PaRISC"	),
+	_ENTRY(ARM,	NULL,				"ARM"		),
+	_ENTRY(M88K,	macho_cpu_m88k_subtypes,	"Motorola 88xxx"),
+	_ENTRY(SPARC,	macho_cpu_sparc_subtypes,	"Sparc"		),
+	_ENTRY(I860,	macho_cpu_i860_subtypes,	"i860"		),
+	_ENTRY(ALPHA,	NULL,				"Alpha"		),
+	_ENTRY(ANY,	NULL,				"unknown"	),
+	{ .name = NULL },
+#undef _ENTRY
+};
+
+static unsigned int macho_check_cpu(macho_cpu_type_t type,
+					macho_cpu_subtype_t subtype)
+{
+	const struct macho_cpu_subentry *entry = NULL;
+	unsigned long i;
+
+	/* Iterate over all the CPU types */
+	for (i = 0; macho_cpu_types[i].name; i++)
+		if (type == macho_cpu_types[i].type)
+			break;
+
+	/* Invalid CPU if we didn't find a match */
+	if (!macho_cpu_types[i].name) {
+		macho_dbg("Unknown CPU type (%u)\n", type);
+		return 0;
+	}
+
+	entry = macho_cpu_types[i].subtypes;
+
+	/* Iterate over all the CPU subtypes (if any) */
+	for (; entry && entry->name; entry++)
+		if (type == entry->type && subtype == entry->subtype)
+			break;
+
+	/* Invalid CPU if we didn't find a match */
+	if (!entry) {
+		macho_dbg("Unknown %s subtype (%u)\n",
+				macho_cpu_types[i].name, subtype);
+		return 0;
+	}
+
+	macho_dbg("Found binary image for %s\n", entry->name);
+
+	/* Return the preference level for this code */
+	return entry->preference;
+}
+
+#endif /* not _MACHO_CPUS_H */
diff --git a/fs/mach-o/debug.h b/fs/mach-o/debug.h
new file mode 100644
index 0000000..205cbfe
--- /dev/null
+++ b/fs/mach-o/debug.h
@@ -0,0 +1,9 @@
+#ifndef  _MACHO_DEBUG_H
+# define _MACHO_DEBUG_H 1
+
+# include <linux/kernel.h>	/* For printk()	*/
+
+# define macho_dbg(x, args...) \
+	printk(KERN_DEBUG "binfmt_mach-o: " x,##args)
+
+#endif /* not _MACHO_DEBUG_H */
diff --git a/fs/mach-o/files.h b/fs/mach-o/files.h
new file mode 100644
index 0000000..17253d9
--- /dev/null
+++ b/fs/mach-o/files.h
@@ -0,0 +1,139 @@
+#ifndef  _MACHO_FILES_H
+# define _MACHO_FILES_H 1
+
+# include "debug.h"
+# include <linux/types.h>	/* For __u32	*/
+
+/*
+ * Mach-O file types, borrowed from Darwin
+ */
+typedef __u32 __bitwise macho_file_type_t;
+# define _ENTRY(type, num) \
+	MACHO_FILE_TYPE_##type = ((__force macho_file_type_t)num)
+enum {
+	_ENTRY(OBJECT,		1),
+	_ENTRY(EXECUTE,		2),
+	_ENTRY(FVMLIB,		3),
+	_ENTRY(CORE,		4),
+	_ENTRY(PRELOAD,		5),
+	_ENTRY(DYLIB,		6),
+	_ENTRY(DYLINKER,	7),
+	_ENTRY(BUNDLE,		8),
+	_ENTRY(DYLIB_STUB,	9),
+};
+#undef _ENTRY
+
+/*
+ * A file type mapping table with human-readable strings
+ */
+struct macho_file_type_entry {
+	const char *name;
+	macho_file_type_t type;
+	unsigned int runnable;
+};
+
+static const struct macho_file_type_entry macho_file_types[] = {
+#define _ENTRY(TYPE, NAME, RUNNABLE) {			\
+		.name = NAME,				\
+		.type = MACHO_FILE_TYPE_ ## TYPE,	\
+		.runnable = RUNNABLE			\
+	}
+	_ENTRY(OBJECT,		"relocatable object",			1),
+	_ENTRY(EXECUTE,		"demand-paged executable",		1),
+	_ENTRY(FVMLIB,		"fixed-virtual-memory shared library",	0),
+	_ENTRY(CORE,		"coredump",				0),
+	_ENTRY(PRELOAD,		"preloaded executable",			1),
+	_ENTRY(DYLIB,		"dynamically linked shared library",	0),
+	_ENTRY(DYLINKER,	"dynamic link editor",			0),
+	_ENTRY(BUNDLE,		"dynamically linked module",		0),
+	_ENTRY(DYLIB_STUB,	"shared library stub for static link",	0),
+	{ .name = NULL, }
+#undef _ENTRY
+};
+
+/*
+ * Mach-O file flags, borrowed from Darwin
+ */
+enum macho_file_flag {
+	MACHO_FILE_FLAG_NO_UNDEF	= 0,
+	MACHO_FILE_FLAG_INCR_LINK	= 1,
+	MACHO_FILE_FLAG_DYN_LINK	= 2,
+	MACHO_FILE_FLAG_BIND_AT_LOAD	= 3,
+	MACHO_FILE_FLAG_PREBOUND	= 4,
+	MACHO_FILE_FLAG_SPLIT_SEGS	= 5,
+	MACHO_FILE_FLAG_LAZY_INIT	= 6,
+	MACHO_FILE_FLAG_TWO_LEVEL	= 7,
+	MACHO_FILE_FLAG_FORCE_FLAT	= 8,
+	MACHO_FILE_FLAG_NO_MULT_DEFS	= 9,
+	MACHO_FILE_FLAG_NO_FIX_PREBIND	= 10,
+	MACHO_FILE_FLAG_PREBINDABLE	= 11,
+	MACHO_FILE_FLAG_ALL_MODS_BOUND	= 12,
+	MACHO_FILE_FLAG_SUBSECT_VIA_SYM	= 13,
+	MACHO_FILE_FLAG_CANONICAL	= 14,
+	MACHO_FILE_FLAG_WEAK_DEFINES	= 15,
+	MACHO_FILE_FLAG_BINDS_TO_WEAK	= 16,
+	MACHO_FILE_FLAG_EXECSTACK	= 17,
+};
+
+/*
+ * A file flag mapping table with human-readable strings
+ */
+static const char *macho_file_flags[] = {
+#define _ENTRY(FLAG, NAME) [MACHO_FILE_FLAG_ ## FLAG] = NAME
+	_ENTRY( NO_UNDEF,	"has no undefined references"		),
+	_ENTRY( INCR_LINK,	"was incrementally linked"		),
+	_ENTRY( DYN_LINK,	"was dynamically linked"		),
+	_ENTRY( BIND_AT_LOAD,	"will bind undefined refs during load"	),
+	_ENTRY( PREBOUND,	"is prebound"				),
+	_ENTRY( SPLIT_SEGS,	"has split RO and R/W segments"		),
+	_ENTRY( LAZY_INIT,	"is lazily initialized"			),
+	_ENTRY( TWO_LEVEL,	"uses two-level namespace bindings"	),
+	_ENTRY( FORCE_FLAT,	"forces flat namespace bindings"	),
+	_ENTRY( NO_MULT_DEFS,	"doesn't have multiply defined symbols"	),
+	_ENTRY( NO_FIX_PREBIND,	"won't notify the prebinding agent"	),
+	_ENTRY( PREBINDABLE,	"can be prebound"			),
+	_ENTRY( ALL_MODS_BOUND,	"is fully bound to two-level namespaces"),
+	_ENTRY( SUBSECT_VIA_SYM,"can be divided via symbols"		),
+	_ENTRY( CANONICAL,	"is canonicalized by un-prebinding"	),
+	_ENTRY( WEAK_DEFINES,	"exports weak symbols"			),
+	_ENTRY( BINDS_TO_WEAK,	"imports weak symbols"			),
+	_ENTRY( EXECSTACK,	"requires executable stack"		),
+	NULL
+};
+
+static int macho_check_file(macho_file_type_t type, __u32 flags)
+{
+	enum macho_file_flag flag = /* 0 */ MACHO_FILE_FLAG_NO_UNDEF;
+	unsigned long i;
+
+	/* Iterate over the list of file types */
+	for (i = 0; macho_file_types[i].name; i++)
+		if (macho_file_types[i].type == type)
+			break;
+
+	/* If we didn't find the file type then it's not executable */
+	if (!macho_file_types[i].name) {
+		macho_dbg("Unknown filetype (%u)\n", type);
+		return 0;
+	}
+
+	macho_dbg("Mach-O %s (%sexecutable):\n", macho_file_types[i].name,
+			macho_file_types[i].runnable?"":"not ");
+
+	/* Check every flag */
+	while (flags && macho_file_flags[flag]) {
+		if (flags & 1)
+			macho_dbg("    %s\n", macho_file_flags[flag]);
+
+		flag++;
+		flags >>= 1;
+	}
+
+	if (flags)
+		macho_dbg("Unknown file flag bits: 0x%08lx\n",
+				(unsigned long)(flags << flag));
+
+	return macho_file_types[i].runnable;
+}
+
+#endif /* not _MACHO_FILES_H */
diff --git a/fs/mach-o/headers.h b/fs/mach-o/headers.h
new file mode 100644
index 0000000..17f019d
--- /dev/null
+++ b/fs/mach-o/headers.h
@@ -0,0 +1,49 @@
+#ifndef  _MACHO_HEADERS_H
+# define _MACHO_HEADERS_H 1
+
+# include <linux/types.h>
+# include "cpus.h"
+
+/* Mach-O universal binary header */
+# define MACHO_FAT_MAGIC (__constant_cpu_to_be32(0xcafebabe))
+struct macho_fat_header {
+	__be32 magic;
+	__be32 arch_count;
+} __attribute__((__packed__));
+
+struct macho_fat_arch {
+	__be32 cpu_type;
+	__be32 cpu_subtype;
+	__be32 offset;
+	__be32 size;
+	__be32 align;
+} __attribute__((__packed__));
+
+/* Mach-O 32-bit arch-specific binary header */
+# define MACHO_MACH32_MAGIC (0xfeedface)
+# define MACHO_MACH32_CIGAM (___constant_swab32(MACHO_MACH32_MAGIC))
+struct macho_mach32_header {
+	__u32 magic;
+	macho_cpu_type_t cpu_type;
+	macho_cpu_subtype_t cpu_subtype;
+	__u32 filetype;
+	__u32 cmd_count;
+	__u32 cmd_size;
+	__u32 flags;
+} __attribute__((__packed__));
+
+/* Mach-O 64-bit arch-specific binary header */
+# define MACHO_MACH64_MAGIC (0xfeedfacf)
+# define MACHO_MACH64_CIGAM (___constant_swab32(MACHO_MACH64_MAGIC))
+struct macho_mach64_header {
+	__u32 magic;
+	macho_cpu_type_t cpu_type;
+	macho_cpu_subtype_t cpu_subtype;
+	__u32 filetype;
+	__u32 cmd_count;
+	__u32 cmd_size;
+	__u32 flags;
+	__u32 reserved;
+} __attribute__((__packed__));
+
+#endif /* not _MACHO_HEADERS_H */

--Apple-Mail-1--597678190--
