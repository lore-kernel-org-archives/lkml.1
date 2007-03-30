Return-Path: <linux-kernel-owner+w=401wt.eu-S1751643AbXC3SIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbXC3SIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbXC3SIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:08:45 -0400
Received: from smtpout.mac.com ([17.250.248.184]:51676 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbXC3SIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:08:42 -0400
In-Reply-To: <5E1467FD-223A-46DD-9A03-5EA20B5D4842@mac.com>
References: <5E1467FD-223A-46DD-9A03-5EA20B5D4842@mac.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-3--597611019
Message-Id: <BE29E855-30F1-470B-9239-A61086D75FFF@mac.com>
Cc: LKML Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [RFC][PATCH 2/2] Darwinux:  Proper support for digging through the Mach-O load-command table 
Date: Fri, 30 Mar 2007 14:08:04 -0400
To: Kyle Moffett <mrmacman_g4@mac.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-3--597611019
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Proper support for digging through the Mach-O load-command table

Uses kernel_read() to carefully iterate through all the Mach-O load
commands and logs their properties to the dmesg buffer.  Partial  
support is
also present for VM setup, but it's lacking a necessary symbol export on
PowerPC (arch_pick_mmap_layout).  The process currently receives a  
SIGKILL
after reading through all the load commands; pending completion of the
memory-mapping and setup code.

Signed-off-by: Kyle Moffett <mrmacman_g4@mac.com>
---
fs/mach-o/binfmt.c   |  258 +++++++++++++++++++++++----------
fs/mach-o/cpus.h     |   49 ++++---
fs/mach-o/files.h    |   67 +++++----
fs/mach-o/loadcmds.h |  389 ++++++++++++++++++++++++++++++++++++++++++ 
++++++++
4 files changed, 640 insertions(+), 123 deletions(-)


--Apple-Mail-3--597611019
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	x-unix-mode=0644;
	name=darwinux_02.txt
Content-Disposition: attachment;
	filename=darwinux_02.txt

diff --git a/fs/mach-o/binfmt.c b/fs/mach-o/binfmt.c
index b5ea936..ea2f46e 100644
--- a/fs/mach-o/binfmt.c
+++ b/fs/mach-o/binfmt.c
@@ -14,44 +14,13 @@
 #include <linux/binfmts.h>
 #include <linux/fs.h>
 #include <linux/err.h>
+#include <linux/personality.h>
 
 #include "debug.h"
 #include "cpus.h"
 #include "headers.h"
 #include "files.h"
-
-#if 0
-#include <linux/kernel.h>
-#include <linux/stat.h>
-#include <linux/time.h>
-#include <linux/mm.h>
-#include <linux/mman.h>
-#include <linux/a.out.h>
-#include <linux/errno.h>
-#include <linux/signal.h>
-#include <linux/string.h>
-#include <linux/file.h>
-#include <linux/fcntl.h>
-#include <linux/ptrace.h>
-#include <linux/slab.h>
-#include <linux/shm.h>
-#include <linux/personality.h>
-#include <linux/elfcore.h>
-#include <linux/init.h>
-#include <linux/highuid.h>
-#include <linux/smp.h>
-#include <linux/smp_lock.h>
-#include <linux/compiler.h>
-#include <linux/highmem.h>
-#include <linux/pagemap.h>
-#include <linux/security.h>
-#include <linux/syscalls.h>
-#include <linux/random.h>
-
-#include <asm/uaccess.h>
-#include <asm/param.h>
-#include <asm/page.h>
-#endif
+#include "loadcmds.h"
 
 MODULE_LICENSE("GPL");
 
@@ -187,21 +156,25 @@ static int load_macho_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			struct macho_mach32_header mach32;
 			struct macho_mach64_header mach64;
 		} header;
-#if 0
-		struct macho_loadcmd loadcmd;
-#endif
+		union macho_loadcmd loadcmd;
 	} *data = NULL;
-	unsigned long offset;
+	unsigned long hdr_cmd_count, hdr_cmd_size;
+	unsigned long cur_offset, loadcmd_size, i;
+	unsigned long arch_offset;
 	long retval;
-	int err;
+	int err = -ENOEXEC;
+
+	/* Make sure the file has appropriate ops */
+	if (!bprm->file->f_op || !bprm->file->f_op->mmap)
+		goto out;
 
 	/*
 	 * Read the Mach-O file headers to find the offset of our
 	 * architecture-specific portion
 	 */
-	offset = get_arch_offset(bprm);
-	if (IS_ERR_VALUE(offset)) {
-		err = (long)offset;
+	arch_offset = get_arch_offset(bprm);
+	if (IS_ERR_VALUE(arch_offset)) {
+		err = (long)arch_offset;
 		goto out;
 	}
 
@@ -213,14 +186,14 @@ static int load_macho_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	}
 
 	/* Read the header data and check the magic */
-	retval = kernel_read(bprm->file, offset,
+	retval = kernel_read(bprm->file, arch_offset,
 			(void *)&data->header, sizeof(data->header));
 	if (retval != sizeof(data->header)) {
 		/*
 		 * If we didn't see an arch table then it must not really be
 		 * a Mach-O file so just return as not executable.
 		 */
-		if (!offset)
+		if (!arch_offset)
 			err = -ENOEXEC;
 
 		/* If kernel_read() returned an error, handle it */
@@ -251,7 +224,7 @@ static int load_macho_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	 */
 	if (data->header.magic != MACHO_MACH32_MAGIC &&
 			data->header.magic != MACHO_MACH64_MAGIC) {
-		if (offset)
+		if (arch_offset)
 			macho_dbg("Corrupt embedded Mach-O object!\n");
 		err = -ENOEXEC;
 		goto out;
@@ -260,13 +233,12 @@ static int load_macho_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	/* CPU type (lines up between 32-bit and 64-bit Mach-O files) */
 	if (!macho_check_cpu(data->header.mach32.cpu_type,
 			data->header.mach32.cpu_subtype)) {
-
 		/*
 		 * The CPU didn't match, so either this is Mach-O file is for
-		 * a different platform (offset == 0) or the FAT Mach-O has
-		 * been corrupted.
+		 * a different platform (arch_offset == 0) or the FAT Mach-O
+		 * has been corrupted.
 		 */
-		if (offset)
+		if (arch_offset)
 			macho_dbg("FAT Mach-O wrapper has mismatched CPU"
 					" types:  Mach-O file corrupt?\n");
 		else
@@ -283,39 +255,175 @@ static int load_macho_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		goto out;
 	}
 
+	/*
+	 * Get some load-command info out of the header (NOTE: Lines up
+	 * between 32-bit and 64-bit Mach-O files
+	 */
+	hdr_cmd_count = data->header.mach32.cmd_count;
+	hdr_cmd_size  = data->header.mach32.cmd_size;
+
+	/* 
+	 * FIXME:  Limits the total space for load commands to 1MB, but this
+	 * should be made configurable somehow for embedded systems with
+	 * minimal available resources.  Is there an rlimit or some page
+	 * accounting we can hook into?  I don't think this is that critical
+	 * of an issue since for the most part we only store one load-command
+	 * in kernel memory at a time, however some things like unixthread
+	 * and thread load-commands need to be kept around until after we've
+	 * loaded the dynamic linker.
+	 */
+	if (hdr_cmd_size > (1 << 20)) {
+		macho_dbg("Mach-O file has more than 1MB worth of "
+				"load-commands (%lu bytes)\n", hdr_cmd_size);
+		err = -ENOMEM;
+		goto out;
+	}
+
 	/* Move past the Mach-O header to find the first load_command */
-	if (data->header.magic == MACHO_MACH32_MAGIC)
-		offset += sizeof(struct macho_mach32_header);
-	else
-		offset += sizeof(struct macho_mach64_header);
+	cur_offset = arch_offset +
+		((data->header.magic == MACHO_MACH32_MAGIC)
+			? sizeof(struct macho_mach32_header)
+			: sizeof(struct macho_mach64_header));
+
+#if 0
+	/*
+	 * Just to avoid allocating gobs of kernel memory while we parse the
+	 * load-command table, we're going to go past the point of no return
+	 * nice and early, so we can just start mapping things into memory
+	 */
+	err = flush_old_exec(bprm);
+	if (err)
+		goto out;
+
+	/* FIXME: This needs to actually switch to the darwin personality */
+	set_personality(PER_LINUX);
+	
+	/* FIXME: Set up ugly stack/brk/etc for testing, need to fix later */
+	current->mm->start_data	= 0;
+	current->mm->end_data	= 0;
+	current->mm->end_code	= 0;
+	current->mm->mmap	= NULL;
+	current->mm->def_flags	= 0;
+
+	/* Make sure to clear the fork-but-not-exec bit on this process */
+	current->flags &= ~PF_FORKNOEXEC;
+
+	/*
+	 * FIXME: Figure out how to do MMAP, may need to be changed to be
+	 * darwinish
+	 */
+	current->mm->mmap_base = TASK_UNMAPPED_BASE;
+	current->mm->get_unmapped_area = arch_get_unmapped_area;
+	current->mm->unmap_area = arch_unmap_area;
+	current->mm->free_area_cache = current->mm->mmap_base;
+	current->mm->cached_hole_size = 0;
+#endif
+
+	/* Iterate over reading the load commands */
+	loadcmd_size = 0;
+	for (i = 0; i < hdr_cmd_count; i++) {
+		unsigned long size;
+
+		/* Check that we have room for another load command */
+		if (loadcmd_size + sizeof(data->loadcmd.hdr) > hdr_cmd_size) {
+			macho_dbg("Mach-O header doesn't allocate enough "
+					"space for load-commands %lu-%lu!\n",
+					i, hdr_cmd_count-1);
+			err = -ENOEXEC;
+			goto out_noreturn;
+		}
+
+		/* First read the itty-bitty command num and size fields */
+		retval = kernel_read(bprm->file, cur_offset,
+				(void *)&data->loadcmd.hdr,
+				sizeof(data->loadcmd.hdr));
+		if (retval != sizeof(data->loadcmd.hdr)) {
+			/* If kernel_read() returned an error, handle it */
+			if (retval < 0) {
+				macho_dbg("Error while reading Mach-O load"
+					" command %lu: %li\n", i, retval);
+				err = retval;
+			} else {
+				macho_dbg("Truncated Mach-O load command "
+					"%lu: (got %lib, wanted %lub)\n", i,
+					retval, sizeof(data->loadcmd.hdr));
+				err = -ENOEXEC;
+			}
+			goto out_noreturn;
+		}
+
+		/* Check/display the load command number */
+		macho_check_loadcmd(data->loadcmd.hdr.cmd);
+		size = data->loadcmd.hdr.size;
+
+		/* 
+		 * Ensure the load-command size is a multiple of 4 bytes and
+		 * large enough to contain the load-command header.
+		 */
+		if (size & 0x3 || size < sizeof(data->loadcmd.hdr)) {
+			macho_dbg("Invalid size for load command %lu: %lu\n",
+				i, (unsigned long)data->loadcmd.hdr.size);
+			err = -ENOEXEC;
+			goto out_noreturn;
+		}
+
+		/* Check that we have room for another load command */
+		if (loadcmd_size + size > hdr_cmd_size) {
+			macho_dbg("Mach-O header doesn't allocate enough "
+					"space for load-commands %lu-%lu!\n",
+					i, hdr_cmd_count-1);
+			err = -ENOEXEC;
+			goto out_noreturn;
+		}
+
+		/* Check that it isn't too big */
+		if (size > sizeof(data->loadcmd)) {
+			macho_dbg("Load command %lu is too big (%lu > %lu): "
+				"skipped!\n", i, size, sizeof(data->loadcmd));
+			loadcmd_size += size;
+			cur_offset   += size;
+			continue;
+		}
+
+		/* Read in the rest of the load-command and move past it */
+		retval = kernel_read(bprm->file, cur_offset,
+				(void *)&data->loadcmd, size);
+		if (retval != size) {
+			/* If kernel_read() returned an error, handle it */
+			if (retval < 0) {
+				macho_dbg("Error while reading Mach-O load"
+					" command %lu: %li\n", i, retval);
+				err = retval;
+			} else {
+				macho_dbg("Truncated Mach-O load command "
+					"%lu: (got %lib, wanted %lub)\n", i,
+					retval, size);
+				err = -ENOEXEC;
+			}
+			goto out_noreturn;
+		}
+		loadcmd_size += size;
+		cur_offset   += size;
+
+		switch (data->loadcmd.hdr.cmd) {
+			case MACHO_LOADCMD_NUM_SEGMENT64:
+			case MACHO_LOADCMD_NUM_SEGMENT32:
+			case MACHO_LOADCMD_NUM_THREAD_NOSTACK:
+			case MACHO_LOADCMD_NUM_THREAD:
+			case MACHO_LOADCMD_NUM_REF_DYLD:
+				macho_dbg("    Load command completed!\n");
+				break;
+		}
+		/* XXX FIXME XXX: Process the load-command */
+	}
 
 	err = -EINVAL;
-	goto out;
+	goto out_noreturn;
 
+out_noreturn:
+	send_sig(SIGKILL, current, 0);
 out:
 	kfree(data);
 	return err;
 }
 
-
-
-#if 0
-	char buf[BINPRM_BUF_SIZE];
-	struct page *page[MAX_ARG_PAGES];
-	struct mm_struct *mm;
-	unsigned long p; /* current top of mem */
-	int sh_bang;
-	struct file * file;
-	int e_uid, e_gid;
-	kernel_cap_t cap_inheritable, cap_permitted, cap_effective;
-	void *security;
-	int argc, envc;
-	char * filename;	/* Name of binary as seen by procps */
-	char * interp;		/* Name of the binary really executed. Most
-				   of the time same as filename, but could be
-				   different for binfmt_{misc,script} */
-	unsigned interp_flags;
-	unsigned interp_data;
-	unsigned long loader, exec;
-#endif
-
diff --git a/fs/mach-o/cpus.h b/fs/mach-o/cpus.h
index a1f2276..00fa3c0 100644
--- a/fs/mach-o/cpus.h
+++ b/fs/mach-o/cpus.h
@@ -12,20 +12,27 @@ typedef __u32 __bitwise macho_cpu_type_t;
 #define _ENTRY(type, num) \
 	MACHO_CPU_TYPE_##type = ((__force macho_cpu_type_t)num)
 enum {
-	_ENTRY(VAX,	0x00000001),
-	_ENTRY(M68K,	0x00000006),
-	_ENTRY(I386,	0x00000007),
-	_ENTRY(MIPS,	0x00000008),
-	_ENTRY(M98K,	0x0000000a),
-	_ENTRY(PARISC,	0x0000000b),
-	_ENTRY(ARM,	0x0000000c),
-	_ENTRY(M88K,	0x0000000d),
-	_ENTRY(SPARC,	0x0000000e),
-	_ENTRY(I860,	0x0000000f),
-	_ENTRY(ALPHA,	0x00000010),
-	_ENTRY(PPC32,	0x00000012),
-	_ENTRY(PPC64,	0x01000012),
-	_ENTRY(ANY,	0xffffffff),
+	/* Historical architecture codes */
+	_ENTRY(ANY,	0xffffffff),	/* CPU_TYPE_ANY		*/
+	_ENTRY(VAX,	0x00000001),	/* CPU_TYPE_VAX		*/
+	_ENTRY(M68K,	0x00000006),	/* CPU_TYPE_MC680x0	*/
+	_ENTRY(MIPS,	0x00000008),	/* CPU_TYPE_MIPS	*/
+	_ENTRY(M98K,	0x0000000a),	/* CPU_TYPE_M98000	*/
+	_ENTRY(PARISC,	0x0000000b),	/* CPU_TYPE_HPPA	*/
+	_ENTRY(ARM,	0x0000000c),	/* CPU_TYPE_ARM		*/
+	_ENTRY(M88K,	0x0000000d),	/* CPU_TYPE_M88000	*/
+	_ENTRY(SPARC,	0x0000000e),	/* CPU_TYPE_SPARC	*/
+	_ENTRY(I860,	0x0000000f),	/* CPU_TYPE_I860	*/
+	_ENTRY(ALPHA,	0x00000010),	/* CPU_TYPE_ALPHA	*/
+
+	/*
+	 * Modern supported architectures. Note that a "CPU_TYPE_ABI64" flag
+	 * is OR-ed into the architecture code for a 64-bit architecture
+	 */
+	_ENTRY(I386,	0x00000007),	/* CPU_TYPE_X86 / CPU_TYPE_I386	*/
+	_ENTRY(X86_64,	0x01000007),	/* CPU_TYPE_X86_64		*/
+	_ENTRY(PPC32,	0x00000012),	/* CPU_TYPE_POWERPC		*/
+	_ENTRY(PPC64,	0x01000012),	/* CPU_TYPE_POWERPC64		*/
 };
 #undef _ENTRY
 
@@ -84,6 +91,9 @@ enum {
 	_ENTRY(I386_XEON,		0x0000000c),
 	_ENTRY(I386_XEON_MP,		0x0000001c),
 
+	/* AMD 64-bit subtypes */
+	_ENTRY(X86_64_ALL,		0x00000003),
+
 	/* MIPS subtypes */
 	_ENTRY(MIPS_ALL,		0x00000000),
 	_ENTRY(MIPS_R2300,		0x00000001),
@@ -131,7 +141,7 @@ enum {
 
 	/* Motorola/Freescale/IBM PowerPC64 subtypes */
 	_ENTRY(PPC64_ALL,		0x00000000),
-	/*_ENTRY(PPC64_970,		0x00000001),*/
+	_ENTRY(PPC64_970,		0x00000064),
 };
 #undef _ENTRY
 
@@ -198,6 +208,10 @@ static const struct macho_cpu_subentry macho_cpu_i386_subtypes[] = {
 	_ENTRY(I386,	XEON_MP,	"Intel Xeon SMP",		 0),
 	{ .name = NULL },
 };
+static const struct macho_cpu_subentry macho_cpu_x86_64_subtypes[] = {
+	_ENTRY(X86_64,	ALL,		"all 64-bit AMD",		 0),
+	{ .name = NULL },
+};
 static const struct macho_cpu_subentry macho_cpu_mips_subtypes[] = {
 	_ENTRY(MIPS,	ALL,		"all MIPS",			 0),
 	_ENTRY(MIPS,	R2300,		"MIPS r2300",			 0),
@@ -252,7 +266,7 @@ static const struct macho_cpu_subentry macho_cpu_ppc32_subtypes[] = {
 };
 static const struct macho_cpu_subentry macho_cpu_ppc64_subtypes[] = {
 	_ENTRY(PPC64,	ALL,		"all PowerPC64",		14),
-	/*_ENTRY(PPC64,	970,		"PowerPC 970",			 1),*/
+	_ENTRY(PPC64,	970,		"PowerPC 970",			15),
 	{ .name = NULL },
 };
 #undef _ENTRY
@@ -273,7 +287,8 @@ static const struct macho_cpu_entry macho_cpu_types[] = {
 	}
 	_ENTRY(PPC32,	macho_cpu_ppc32_subtypes,	"PowerPC"	),
 	_ENTRY(PPC64,	macho_cpu_ppc64_subtypes,	"PowerPC64"	),
-	_ENTRY(I386,	macho_cpu_i386_subtypes,	"Intel x86"	),
+	_ENTRY(I386,	macho_cpu_i386_subtypes,	"Intel/AMD x86"	),
+	_ENTRY(X86_64,	macho_cpu_x86_64_subtypes,	"AMD 64-bit x86"),
 	_ENTRY(VAX,	macho_cpu_vax_subtypes,		"VAX"		),
 	_ENTRY(M68K,	macho_cpu_m68k_subtypes,	"Motorola 68xxx"),
 	_ENTRY(MIPS,	macho_cpu_mips_subtypes,	"MIPS"		),
diff --git a/fs/mach-o/files.h b/fs/mach-o/files.h
index 17253d9..cdbd028 100644
--- a/fs/mach-o/files.h
+++ b/fs/mach-o/files.h
@@ -8,20 +8,21 @@
  * Mach-O file types, borrowed from Darwin
  */
 typedef __u32 __bitwise macho_file_type_t;
+enum {
 # define _ENTRY(type, num) \
 	MACHO_FILE_TYPE_##type = ((__force macho_file_type_t)num)
-enum {
-	_ENTRY(OBJECT,		1),
-	_ENTRY(EXECUTE,		2),
-	_ENTRY(FVMLIB,		3),
-	_ENTRY(CORE,		4),
-	_ENTRY(PRELOAD,		5),
-	_ENTRY(DYLIB,		6),
-	_ENTRY(DYLINKER,	7),
-	_ENTRY(BUNDLE,		8),
-	_ENTRY(DYLIB_STUB,	9),
-};
+	_ENTRY(OBJECT,		0x01), /* MH_OBJECT	*/
+	_ENTRY(EXECUTE,		0x02), /* MH_EXECUTE	*/
+	_ENTRY(FVMLIB,		0x03), /* MH_FVMLIB	*/
+	_ENTRY(CORE,		0x04), /* MH_CORE	*/
+	_ENTRY(PRELOAD,		0x05), /* MH_PRELOAD	*/
+	_ENTRY(DYLIB,		0x06), /* MH_DYLIB	*/
+	_ENTRY(DYLD,		0x07), /* MH_DYLINKER	*/
+	_ENTRY(BUNDLE,		0x08), /* MH_BUNDLE	*/
+	_ENTRY(DYLIB_STUB,	0x09), /* MH_DYLIB_STUB	*/
+	_ENTRY(DEBUG_SYM,	0x0a), /* MY_DSYM	*/
 #undef _ENTRY
+};
 
 /*
  * A file type mapping table with human-readable strings
@@ -44,9 +45,10 @@ static const struct macho_file_type_entry macho_file_types[] = {
 	_ENTRY(CORE,		"coredump",				0),
 	_ENTRY(PRELOAD,		"preloaded executable",			1),
 	_ENTRY(DYLIB,		"dynamically linked shared library",	0),
-	_ENTRY(DYLINKER,	"dynamic link editor",			0),
+	_ENTRY(DYLD,		"dynamic link editor",			0),
 	_ENTRY(BUNDLE,		"dynamically linked module",		0),
 	_ENTRY(DYLIB_STUB,	"shared library stub for static link",	0),
+	_ENTRY(DEBUG_SYM,	"debug symbol file",			0),
 	{ .name = NULL, }
 #undef _ENTRY
 };
@@ -55,24 +57,26 @@ static const struct macho_file_type_entry macho_file_types[] = {
  * Mach-O file flags, borrowed from Darwin
  */
 enum macho_file_flag {
-	MACHO_FILE_FLAG_NO_UNDEF	= 0,
-	MACHO_FILE_FLAG_INCR_LINK	= 1,
-	MACHO_FILE_FLAG_DYN_LINK	= 2,
-	MACHO_FILE_FLAG_BIND_AT_LOAD	= 3,
-	MACHO_FILE_FLAG_PREBOUND	= 4,
-	MACHO_FILE_FLAG_SPLIT_SEGS	= 5,
-	MACHO_FILE_FLAG_LAZY_INIT	= 6,
-	MACHO_FILE_FLAG_TWO_LEVEL	= 7,
-	MACHO_FILE_FLAG_FORCE_FLAT	= 8,
-	MACHO_FILE_FLAG_NO_MULT_DEFS	= 9,
-	MACHO_FILE_FLAG_NO_FIX_PREBIND	= 10,
-	MACHO_FILE_FLAG_PREBINDABLE	= 11,
-	MACHO_FILE_FLAG_ALL_MODS_BOUND	= 12,
-	MACHO_FILE_FLAG_SUBSECT_VIA_SYM	= 13,
-	MACHO_FILE_FLAG_CANONICAL	= 14,
-	MACHO_FILE_FLAG_WEAK_DEFINES	= 15,
-	MACHO_FILE_FLAG_BINDS_TO_WEAK	= 16,
-	MACHO_FILE_FLAG_EXECSTACK	= 17,
+#define _ENTRY(type, num) MACHO_FILE_FLAG_##type = num
+	_ENTRY(NO_UNDEF,	 0), /* MH_NOUNDEFS			*/
+	_ENTRY(INCR_LINK,	 1), /* MH_INCRLINK			*/
+	_ENTRY(DYN_LINK,	 2), /* MH_DYLDLINK			*/
+	_ENTRY(BIND_AT_LOAD,	 3), /* MH_BINDATLOAD			*/
+	_ENTRY(PREBOUND,	 4), /* MH_PREBOUND			*/
+	_ENTRY(SPLIT_SEGS,	 5), /* MH_SPLIT_SEGS			*/
+	_ENTRY(LAZY_INIT,	 6), /* MH_LAZY_INIT			*/
+	_ENTRY(TWO_LEVEL,	 7), /* MH_TWOLEVEL			*/
+	_ENTRY(FORCE_FLAT,	 8), /* MH_FORCE_FLAT			*/
+	_ENTRY(NO_MULT_DEFS,	 9), /* MH_NOMULTIDEFS			*/
+	_ENTRY(NO_FIX_PREBIND,	10), /* MH_NOFIXPREBINDING		*/
+	_ENTRY(PREBINDABLE,	11), /* MH_PREBINDABLE			*/
+	_ENTRY(ALL_MODS_BOUND,	12), /* MH_ALLMODSBOUND			*/
+	_ENTRY(SUBSECT_VIA_SYM,	13), /* MH_SUBSECTIONS_VIA_SYMBOLS	*/
+	_ENTRY(CANONICAL,	14), /* MH_CANONICAL			*/
+	_ENTRY(WEAK_DEFINES,	15), /* MH_WEAK_DEFINES			*/
+	_ENTRY(BINDS_TO_WEAK,	16), /* MH_BINDS_TO_WEAK		*/
+	_ENTRY(EXECSTACK,	17), /* MH_ALLOW_STACK_EXECUTION	*/
+#undef _ENTRY
 };
 
 /*
@@ -98,7 +102,8 @@ static const char *macho_file_flags[] = {
 	_ENTRY( WEAK_DEFINES,	"exports weak symbols"			),
 	_ENTRY( BINDS_TO_WEAK,	"imports weak symbols"			),
 	_ENTRY( EXECSTACK,	"requires executable stack"		),
-	NULL
+	NULL,
+#undef _ENTRY
 };
 
 static int macho_check_file(macho_file_type_t type, __u32 flags)
diff --git a/fs/mach-o/loadcmds.h b/fs/mach-o/loadcmds.h
new file mode 100644
index 0000000..0ee35c3
--- /dev/null
+++ b/fs/mach-o/loadcmds.h
@@ -0,0 +1,389 @@
+#ifndef  _MACHO_LOADCMDS_H
+# define _MACHO_LOADCMDS_H 1
+
+# include <linux/types.h>
+
+/*
+ * Mach-O load-command types, borrowed from Darwin
+ */
+typedef __u32 __bitwise macho_loadcmd_num_t;
+enum {
+# define _ENTRY(type, num) \
+	MACHO_LOADCMD_NUM_##type = ((__force macho_loadcmd_num_t)num)
+	_ENTRY(SEGMENT32,	0x01), /* LC_SEGMENT		*/
+	_ENTRY(SYMTAB_STAB,	0x02), /* LC_SYMTAB		*/
+	_ENTRY(SYMTAB_GDB,	0x03), /* LC_SYMSEG		*/
+	_ENTRY(THREAD_NOSTACK,	0x04), /* LC_THREAD		*/
+	_ENTRY(THREAD,		0x05), /* LC_UNIXTHREAD		*/
+	_ENTRY(REF_FVMLIB,	0x06), /* LC_LOADFVMLIB		*/
+	_ENTRY(ID_FVMLIB,	0x07), /* LC_IDFVMLIB		*/
+	_ENTRY(ID,		0x08), /* LC_IDENT		*/
+	_ENTRY(FVMFILE,		0x09), /* LC_FVMFILE		*/
+	_ENTRY(PREPAGE,		0x0a), /* LC_PREPAGE		*/
+	_ENTRY(SYMTAB_DYLD,	0x0b), /* LC_DYSYMTAB		*/
+	_ENTRY(REF_DYLIB,	0x0c), /* LC_LOAD_DYLIB		*/
+	_ENTRY(ID_DYLIB,	0x0d), /* LC_ID_DYLIB		*/
+	_ENTRY(REF_DYLD,	0x0e), /* LC_LOAD_DYLINKER	*/
+	_ENTRY(ID_DYLD,		0x0f), /* LC_ID_DYLINKER	*/
+	_ENTRY(PREBINDING,	0x10), /* LC_PREBOUND_DYLIB	*/
+	_ENTRY(INITCODE32,	0x11), /* LC_ROUTINES		*/
+	_ENTRY(SUB_FRAMEWORK,	0x12), /* LC_SUB_FRAMEWORK	*/
+	_ENTRY(SUB_UMBRELLA,	0x13), /* LC_SUB_UMBRELLA	*/
+	_ENTRY(SUB_CLIENT,	0x14), /* LC_SUB_CLIENT		*/
+	_ENTRY(SUB_LIBRARY,	0x15), /* LC_SUB_LIBRARY	*/
+	_ENTRY(HINTS_2LEVEL,	0x16), /* LC_TWOLEVEL_HINTS	*/
+	_ENTRY(PREBIND_CKSUM,	0x17), /* LC_PREBIND_CKSUM	*/
+	_ENTRY(WEAKREF_DYLIB,	0x18), /* LC_LOAD_DYLIB_WEAK	*/
+	_ENTRY(SEGMENT64,	0x19), /* LC_SEGMENT_64		*/
+	_ENTRY(INITCODE64,	0x1a), /* LC_ROUTINES_64	*/
+	_ENTRY(UUID,		0x1b), /* LC_UUID		*/
+# undef _ENTRY
+};
+
+/* Mach-O load command header */
+struct macho_loadcmd_hdr {
+	__u32 cmd;
+	__u32 size;
+} __attribute__((__packed__));
+
+/* Variable-length string in a Mach-O load command */
+struct macho_loadcmd_varstr {
+	__u32 off;
+} __attribute__((__packed__));
+
+/* Generic large load command */
+struct macho_loadcmd_unknown {
+	struct macho_loadcmd_hdr hdr;
+	__u8 data[2048 - sizeof(struct macho_loadcmd_hdr)];
+} __attribute__((__packed__));
+
+/* Mach-O memory-mapped file segment (32-bit) */
+struct macho_loadcmd_segment32 {
+	struct macho_loadcmd_hdr hdr;
+	char name[16];
+	__u32 vm_addr;
+	__u32 vm_size;
+	__u32 file_off;
+	__u32 file_size;
+	__u32 prot_max;
+	__u32 prot_init;
+	__u32 sect_count;
+	__u32 flags;
+} __attribute__((__packed__));
+
+/* Mach-O symbol table (stab) */
+struct macho_loadcmd_symtab_stab {
+	struct macho_loadcmd_hdr hdr;
+	__u32 sym_off;
+	__u32 sym_count;
+	__u32 str_off;
+	__u32 str_size;
+} __attribute__((__packed__));
+
+/* Mach-O symbol table (gdb, obsolete) */
+struct macho_loadcmd_symtab_gdb {
+	struct macho_loadcmd_hdr hdr;
+	__u32 symtab_off;
+	__u32 symtab_size;
+} __attribute__((__packed__));
+
+/* Mach-O new thread (with or without stack) */
+# define MACHO_LOADCMD_THREAD_MAX_PPC 144
+# define MACHO_LOADCMD_THREAD_MAX_X86 144
+struct macho_loadcmd_thread {
+	struct macho_loadcmd_hdr hdr;
+	__u32 threaddata[];
+} __attribute__((__packed__));
+
+/* Mach-O reference to or identity of a fixed-VM shared lib */
+struct macho_loadcmd_fvmlib {
+	struct macho_loadcmd_hdr hdr;
+	struct macho_loadcmd_varstr path;
+	__u32 vers;
+	__u32 addr;
+	__u8 data[];
+} __attribute__((__packed__));
+
+/* Mach-O identity of an object (obsolete) */
+struct macho_loadcmd_id {
+	struct macho_loadcmd_hdr hdr;
+	__u8 iddata[];
+} __attribute__((__packed__));
+
+/* Mach-O reference to a fixed VM file */
+struct macho_loadcmd_fvmfile {
+	struct macho_loadcmd_hdr hdr;
+	struct macho_loadcmd_varstr path;
+	__u32 addr;
+	__u8 data[];
+} __attribute__((__packed__));
+
+/* Mach-O unknown (LC_PREPAGE) */
+struct macho_loadcmd_prepage {
+	struct macho_loadcmd_hdr hdr;
+	__u8 prepagedata[];
+} __attribute__((__packed__));
+
+/* Mach-O symbol table (dyld) */
+struct macho_loadcmd_symtab_dyld {
+	struct macho_loadcmd_hdr hdr;
+	__u32 sym_local_off;
+	__u32 sym_local_num;
+	__u32 sym_extern_off;
+	__u32 sym_extern_num;
+	__u32 sym_undef_off;
+	__u32 sym_undef_num;
+	__u32 toc_off;
+	__u32 toc_num;
+	__u32 modtab_off;
+	__u32 modtab_num;
+	__u32 extref_off;
+	__u32 extref_num;
+	__u32 indirect_off;
+	__u32 indirect_num;
+	__u32 extrel_off;
+	__u32 extrel_num;
+	__u32 localrel_off;
+	__u32 localrel_num;
+} __attribute__((__packed__));
+
+/* Mach-O reference to or identity of a dynamic shared lib */
+struct macho_loadcmd_dylib {
+	struct macho_loadcmd_hdr hdr;
+	struct macho_loadcmd_varstr path;
+	__u32 timestamp;
+	__u32 vers_current;
+	__u32 vers_compat;
+	__u8 data[];
+} __attribute__((__packed__));
+
+/* Mach-O reference to or identity of a dynamic linker */
+struct macho_loadcmd_dyld {
+	struct macho_loadcmd_hdr hdr;
+	struct macho_loadcmd_varstr path;
+	__u8 data[];
+} __attribute__((__packed__));
+
+/* Mach-O prebinding against a dynamic shared lib */
+struct macho_loadcmd_prebinding {
+	struct macho_loadcmd_hdr hdr;
+	struct macho_loadcmd_varstr path;
+	__u32 modvec_num;
+	__u32 modvec_off;
+	__u8 data[];
+} __attribute__((__packed__));
+
+/* Mach-O shared library init routine (32-bit) */
+struct macho_loadcmd_initcode32 {
+	struct macho_loadcmd_hdr hdr;
+	__u32 init_address;
+	__u32 init_module;
+	__u32 reserved[6];
+} __attribute__((__packed__));
+
+/* Mach-O sub-framework file */
+struct macho_loadcmd_sub_framework {
+	struct macho_loadcmd_hdr hdr;
+	struct macho_loadcmd_varstr parent;
+	__u8 data[];
+} __attribute__((__packed__));
+
+/* Mach-O sub-umbrella-framework file */
+struct macho_loadcmd_sub_umbrella {
+	struct macho_loadcmd_hdr hdr;
+	struct macho_loadcmd_varstr parent;
+	__u8 data[];
+} __attribute__((__packed__));
+
+/* Mach-O sub-framework client entry */
+struct macho_loadcmd_sub_client {
+	struct macho_loadcmd_hdr hdr;
+	struct macho_loadcmd_varstr client;
+	__u8 data[];
+} __attribute__((__packed__));
+
+/* Mach-O sub-framework library */
+struct macho_loadcmd_sub_library {
+	struct macho_loadcmd_hdr hdr;
+	struct macho_loadcmd_varstr parent;
+	__u8 data[];
+} __attribute__((__packed__));
+
+/* Mach-O two-level namespace hinting table */
+struct macho_loadcmd_hints_2level {
+	struct macho_loadcmd_hdr hdr;
+	__u32 hinttable_offset;
+	__u32 hinttable_count;
+} __attribute__((__packed__));
+
+/* Mach-O prebinding checksum */
+struct macho_loadcmd_prebind_cksum {
+	struct macho_loadcmd_hdr hdr;
+	__u8 data[];
+} __attribute__((__packed__));
+
+/* Mach-O memory-mapped file segment (64-bit) */
+struct macho_loadcmd_segment64 {
+	struct macho_loadcmd_hdr hdr;
+	char name[16];
+	__u64 vm_addr;
+	__u64 vm_size;
+	__u32 file_off;
+	__u32 file_size;
+	__u32 prot_max;
+	__u32 prot_init;
+	__u32 sect_count;
+	__u32 flags;
+} __attribute__((__packed__));
+
+/* Mach-O shared library init routine (64-bit) */
+struct macho_loadcmd_initcode64 {
+	struct macho_loadcmd_hdr hdr;
+	__u64 init_address;
+	__u64 init_module;
+	__u64 reserved[6];
+} __attribute__((__packed__));
+
+/* Mach-O linked object UUID (LC_UUID) */
+struct macho_loadcmd_uuid {
+	struct macho_loadcmd_hdr hdr;
+	__u8 uuid[16];
+} __attribute__((__packed__));
+
+/* A generic Mach-O load command */
+union macho_loadcmd {
+	struct macho_loadcmd_hdr		hdr;
+	struct macho_loadcmd_unknown		unknown;
+	struct macho_loadcmd_segment32		segment32;
+	struct macho_loadcmd_symtab_stab	symtab_stab;
+	struct macho_loadcmd_symtab_gdb		symtab_gdb;
+	struct macho_loadcmd_thread		thread;
+	struct macho_loadcmd_fvmlib		fvmlib;
+	struct macho_loadcmd_id			id;
+	struct macho_loadcmd_fvmfile		fvmfile;
+	struct macho_loadcmd_prepage		prepage;
+	struct macho_loadcmd_symtab_dyld	symtab_dyld;
+	struct macho_loadcmd_dylib		dylib;
+	struct macho_loadcmd_dyld		dyld;
+	struct macho_loadcmd_prebinding		prebinding;
+	struct macho_loadcmd_initcode32		initcode32;
+	struct macho_loadcmd_sub_framework	sub_framework;
+	struct macho_loadcmd_sub_umbrella	sub_umbrella;
+	struct macho_loadcmd_sub_client		sub_client;
+	struct macho_loadcmd_sub_library	sub_library;
+	struct macho_loadcmd_hints_2level	hints_2level;
+	struct macho_loadcmd_prebind_cksum	prebind_cksum;
+	struct macho_loadcmd_segment64		segment64;
+	struct macho_loadcmd_initcode64		initcode64;
+	struct macho_loadcmd_uuid		uuid;
+} __attribute__((__packed__));
+
+/* Inernal function to check and return a load-command string */
+static inline const __u8 *macho_loadcmd_varstr_get__(
+		const struct macho_loadcmd_hdr *hdr,
+		const struct macho_loadcmd_varstr *varstr,
+		const __u8 *loadcmd_data)
+{
+	unsigned long data_offset = ((const void *)loadcmd_data) -
+			((const void *)hdr);
+	unsigned long str_offset, i;
+
+	/* Make sure the varstr points into the data area */
+	if (varstr->off < data_offset)
+		return NULL;
+	str_offset = varstr->off - data_offset;
+
+	/*
+	 * Iterate over all the characters in the variable-length string to
+	 * ensure that there is a trailing 0 before the end of the data area.
+	 */
+	for (i = str_offset; i < hdr->size; i++)
+		if (!loadcmd_data[i])
+			break;
+
+	/* If we quit before we hit end-of-data then it's a valid string */
+	if (i < hdr->size)
+		return &loadcmd_data[str_offset];
+
+	/* Sadly no such luck, it's a bogus Mach-O file */
+	return NULL;
+}
+
+/*
+ * Wrapper around the macho_loadcmd_varstr_get__ function above to make the
+ * calling-convention much easier.
+ *
+ * Example usage:
+ *   macho_loadcmd_dyld *dyld = (...);
+ *   const char *dyld_path = macho_loadcmd_varstr_get(dyld, path);
+ *   if (!dyld_path)
+ *           return -ENOEXEC;
+ */
+#define macho_loadcmd_varstr_get(LOADCMD, VARSTR) \
+	(macho_loadcmd_varstr_get__(&((LOADCMD)->hdr), \
+			&((LOADCMD)->VARSTR), (LOADCMD)->data))
+
+/*
+ * A Mach-O load-command mapping table with human-readable strings
+ */
+struct macho_loadcmd_entry {
+	const char *name;
+	macho_loadcmd_num_t cmd;
+	int pass;
+};
+
+static const struct macho_loadcmd_entry macho_loadcmds[] = {
+#define _ENTRY(TYPE, NAME) {			\
+		.name = NAME,				\
+		.cmd = MACHO_LOADCMD_NUM_ ## TYPE,	\
+	}
+	_ENTRY(SEGMENT32,	"memory-mapped file segment (32-bit)"),
+	_ENTRY(SYMTAB_STAB,	"symbol table (stab)"),
+	_ENTRY(SYMTAB_GDB,	"symbol table (gdb, obsolete)"),
+	_ENTRY(THREAD_NOSTACK,	"new thread (without stack)"),
+	_ENTRY(THREAD,		"new thread (with stack)"),
+	_ENTRY(REF_FVMLIB,	"reference to a fixed-VM shared lib"),
+	_ENTRY(ID_FVMLIB,	"identity of a fixed-VM shared lib"),
+	_ENTRY(ID,		"identity of an object (obsolete)"),
+	_ENTRY(FVMFILE,		"reference to a fixed VM file"),
+	_ENTRY(PREPAGE,		"unknown (LC_PREPAGE)"),
+	_ENTRY(SYMTAB_DYLD,	"symbol table (dyld)"),
+	_ENTRY(REF_DYLIB,	"reference to a dynamic shared lib"),
+	_ENTRY(ID_DYLIB,	"identity of a dynamic shared lib"),
+	_ENTRY(REF_DYLD,	"reference to a dynamic linker"),
+	_ENTRY(ID_DYLD,		"identity of a dynamic linker"),
+	_ENTRY(PREBINDING,	"prebinding against a dynamic shared lib"),
+	_ENTRY(INITCODE32,	"shared library init routine (32-bit)"),
+	_ENTRY(SUB_FRAMEWORK,	"sub-framework file"),
+	_ENTRY(SUB_UMBRELLA,	"sub-umbrella-framework file"),
+	_ENTRY(SUB_CLIENT,	"sub-framework client entry"),
+	_ENTRY(SUB_LIBRARY,	"sub-framework library"),
+	_ENTRY(HINTS_2LEVEL,	"two-level namespace hinting table"),
+	_ENTRY(PREBIND_CKSUM,	"prebinding checksum"),
+	_ENTRY(WEAKREF_DYLIB,	"weak reference to a dynamic shared lib"),
+	_ENTRY(SEGMENT64,	"memory-mapped file segment (64-bit)"),
+	_ENTRY(INITCODE64,	"shared library init routine (64-bit)"),
+	_ENTRY(UUID,		"linked object UUID"),
+	{ .name = NULL, }
+#undef _ENTRY
+};
+
+static void macho_check_loadcmd(macho_loadcmd_num_t cmd)
+{
+	unsigned long i;
+
+	/* Iterate over the list of file types */
+	for (i = 0; macho_loadcmds[i].name; i++)
+		if (macho_loadcmds[i].cmd == cmd)
+			break;
+
+	/* If we didn't find the load command type then ignore it */
+	if (!macho_loadcmds[i].name) {
+		macho_dbg("  Mach-O load command: unknown (%u)\n", cmd);
+		return;
+	}
+
+	macho_dbg("  Mach-O load command: %s\n", macho_loadcmds[i].name);
+}
+
+#endif /* not _MACHO_LOADCMDS_H */

--Apple-Mail-3--597611019--
