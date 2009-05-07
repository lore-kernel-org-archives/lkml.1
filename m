Return-Path: <linux-kernel-owner+w=401wt.eu-S1763396AbZEGWay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763396AbZEGWay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762831AbZEGW1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:27:17 -0400
Received: from mga06.intel.com ([134.134.136.21]:35559 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755022AbZEGW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:27:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="410470462"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 09/14] x86, boot: add new runtime_address and runtime_size bzImage fields
Date: Thu,  7 May 2009 15:26:57 -0700
Message-Id: <1241735222-6640-10-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Make the (minimum) runtime address and the required amount of linear
address space available to the boot loader.  A relocating boot loader
can use this information to select a kernel location; furthermore, it
is permitted to modify the minimum runtime address field in order for
the boot loader to force a specific location for the kernel (as long
as it fits the alignment constraints.)

This means that the address space layout for the kernel compressor has
to be determined at compile time.  Since we have to do that, we might
as well reap the benefit and remove some runtime calculations in
assembly.

Note: bounding the amount of linear address space (not necessarily
bounding the amount of memory needed, but the amount that has to be
linearly contiguous before the memory map is consulted) was only
possible since Jeremy Fitzhardinge's brk support work.

[ Impact: new feature; simplication of compressed/head_*.S ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/boot/Makefile               |   24 ++++++---
 arch/x86/boot/compressed/Makefile    |   14 ++++--
 arch/x86/boot/compressed/head_32.S   |   54 ++++++-------------
 arch/x86/boot/compressed/head_64.S   |   52 +++++-------------
 arch/x86/boot/compressed/mkpiggy.c   |   97 ++++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/vmlinux.scr |   10 ----
 arch/x86/boot/header.S               |   19 +++++--
 arch/x86/include/asm/bootparam.h     |    2 +
 arch/x86/kernel/asm-offsets_32.c     |    1 +
 arch/x86/kernel/asm-offsets_64.c     |    1 +
 10 files changed, 173 insertions(+), 101 deletions(-)
 create mode 100644 arch/x86/boot/compressed/mkpiggy.c
 delete mode 100644 arch/x86/boot/compressed/vmlinux.scr

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 6633b6e..3332d22 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -86,19 +86,27 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
-sed-offsets := -e 's/^00*/0/' \
-        -e 's/^\([0-9a-fA-F]*\) . \(input_data\|input_data_end\)$$/\#define \2 0x\1/p'
+sed-voffset := -e 's/^\([0-9a-fA-F]*\) . \(_text\|_end\)$$/\#define VO_\2 0x\1/p'
 
-quiet_cmd_offsets = OFFSETS $@
-      cmd_offsets = $(NM) $< | sed -n $(sed-offsets) > $@
+quiet_cmd_voffset = VOFFSET $@
+      cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
 
-$(obj)/offsets.h: $(obj)/compressed/vmlinux FORCE
-	$(call if_changed,offsets)
+targets += voffset.h
+$(obj)/voffset.h: vmlinux FORCE
+	$(call if_changed,voffset)
+
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(input_data\|_ebss\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+
+quiet_cmd_zoffset = ZOFFSET $@
+      cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
+
+targets += zoffset.h
+$(obj)/zoffset.h: $(obj)/compressed/vmlinux FORCE
+	$(call if_changed,zoffset)
 
-targets += offsets.h
 
 AFLAGS_header.o += -I$(obj)
-$(obj)/header.o: $(obj)/offsets.h
+$(obj)/header.o: $(obj)/voffset.h $(obj)/zoffset.h
 
 LDFLAGS_setup.elf	:= -T
 $(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) FORCE
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index b35c3bb..6f4d7ba 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,8 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
+targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 \
+	   vmlinux.bin.lzma head_$(BITS).o misc.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -19,6 +20,8 @@ KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
 
+hostprogs-y	:= mkpiggy
+
 $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o $(obj)/piggy.o FORCE
 	$(call if_changed,ld)
 	@:
@@ -50,6 +53,9 @@ suffix_$(CONFIG_KERNEL_GZIP)  = gz
 suffix_$(CONFIG_KERNEL_BZIP2) = bz2
 suffix_$(CONFIG_KERNEL_LZMA)  = lzma
 
-LDFLAGS_piggy.o := -r --format binary --oformat $(CONFIG_OUTPUT_FORMAT) -T
-$(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix_y) FORCE
-	$(call if_changed,ld)
+quiet_cmd_mkpiggy = MKPIGGY $@
+      cmd_mkpiggy = $(obj)/mkpiggy $< > $@
+
+targets += piggy.S
+$(obj)/piggy.S: $(obj)/vmlinux.bin.$(suffix_y) $(obj)/mkpiggy FORCE
+	$(call if_changed,mkpiggy)
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 511b0be..47636b3 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -64,7 +64,7 @@ ENTRY(startup_32)
  */
 
 #ifdef CONFIG_RELOCATABLE
-	movl $LOAD_PHYSICAL_ADDR, %eax
+	movl BP_runtime_start(%esi), %eax
 	movl %ebp, %ebx
 	cmpl %ebx, %eax
 	jbe 1f
@@ -75,26 +75,13 @@ ENTRY(startup_32)
 #else
 	movl $LOAD_PHYSICAL_ADDR, %ebx
 #endif
-	movl %ebx, %edi		/* Save kernel target address */
-
-	/* Replace the compressed data size with the uncompressed size */
-	subl input_len(%ebp), %ebx
-	movl output_len(%ebp), %eax
-	addl %eax, %ebx
-	/* Add 8 bytes for every 32K input block */
-	shrl $12, %eax
-	addl %eax, %ebx
-	/* Add 32K + 18 bytes of extra slack */
-	addl $(32768 + 18), %ebx
-	/* Align on a 4K boundary */
-	addl $4095, %ebx
-	andl $~4095, %ebx
+	/* Target address to relocate to for decompression */
+	addl $z_extract_offset, %ebx
 
 /*
  * Set up the stack
  */
 	leal boot_stack_end(%ebx), %esp
-	pushl %edi		/* Saved kernel target address */
 
 /*
  * Copy the compressed kernel to the end of our buffer
@@ -111,11 +98,6 @@ ENTRY(startup_32)
 	popl %esi
 
 /*
- * %ebp -> kernel target address
- */
-	popl %ebp
-
-/*
  * Jump to the relocated address.
  */
 	leal relocated(%ebx), %eax
@@ -138,29 +120,27 @@ relocated:
 /*
  * Do the decompression, and jump to the new kernel..
  */
-	movl output_len(%ebx), %eax
-	pushl %eax
-			# push arguments for decompress_kernel:
-	pushl %ebp	# output address
-	movl input_len(%ebx), %eax
-	pushl %eax	# input_len
+	leal z_extract_offset_negative(%ebx), %ebp
+	pushl %ebp		# output address
+	pushl $z_input_len	# input_len
 	leal input_data(%ebx), %eax
-	pushl %eax	# input_data
+	pushl %eax		# input_data
 	leal boot_heap(%ebx), %eax
-	pushl %eax	# heap area
-	pushl %esi	# real mode pointer
+	pushl %eax		# heap area
+	pushl %esi		# real mode pointer
 	call decompress_kernel
 	addl $20, %esp
-	popl %ecx
 
-#if CONFIG_RELOCATABLE
-/* Find the address of the relocations.
+#ifdef CONFIG_RELOCATABLE
+/*
+ * Find the address of the relocations.
  */
-	movl %ebp, %edi
-	addl %ecx, %edi
+	leal z_output_len(%ebp), %edi
 
-/* Calculate the delta between where vmlinux was compiled to run
- * and where it was actually loaded.
+/*
+ * Calculate the delta between where vmlinux was compiled to run
+ * and where it was actually loaded.  Use the compile-time
+ * LOAD_PHYSICAL_ADDR here, not boot_param.runtime_start.
  */
 	movl %ebp, %ebx
 	subl $LOAD_PHYSICAL_ADDR, %ebx
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 191b0d3..2678fdf 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -72,7 +72,7 @@ ENTRY(startup_32)
  * for safe in-place decompression.
  */
 #ifdef CONFIG_RELOCATABLE
-	movl	$LOAD_PHYSICAL_ADDR, %eax
+	movl	BP_runtime_start(%esi), %eax
 	movl	%ebp, %ebx
 	addl	$(LOAD_PHYSICAL_ALIGN - 1), %ebx
 	andl	$~(LOAD_PHYSICAL_ALIGN - 1), %ebx
@@ -83,17 +83,8 @@ ENTRY(startup_32)
 #else
 	movl	$LOAD_PHYSICAL_ADDR, %ebx
 #endif
-
-	/* Replace the compressed data size with the uncompressed size */
-	subl	input_len(%ebp), %ebx
-	movl	output_len(%ebp), %eax
-	addl	%eax, %ebx
-	/* Add 8 bytes for every 32K input block */
-	shrl	$12, %eax
-	addl	%eax, %ebx
-	/* Add 32K + 18 bytes of extra slack and align on a 4K boundary */
-	addl	$(32768 + 18 + 4095), %ebx
-	andl	$~4095, %ebx
+	/* Target address to relocate to for decompression */
+	addl	$z_extract_offset, %ebx
 
 /*
  * Prepare for entering 64 bit mode
@@ -207,19 +198,17 @@ ENTRY(startup_64)
 	movl    $0x20, %eax
 	ltr	%ax
 
-	/* Compute the decompressed kernel start address.  It is where
-	 * we were loaded at aligned to a 2M boundary. %rbp contains the
-	 * decompressed kernel start address.
+	/*
+	 * Kernel load address and relocation information... note that
+	 * we can't rely on the calculation in 32-bit mode since we might
+	 * have come here via the 64-bit entrypoint.
 	 *
-	 * If it is a relocatable kernel then decompress and run the kernel
-	 * from load address aligned to 2MB addr, otherwise decompress and
-	 * run the kernel from LOAD_PHYSICAL_ADDR
+	 * At the end of this, %rbp points to the decompressed kernel
+	 * load address, and %rbx to where we need to relocate ourselves to.
 	 */
-
-	/* Start with the delta to where the kernel will run at. */
 #ifdef CONFIG_RELOCATABLE
 	leaq	startup_32(%rip) /* - $startup_32 */, %rbp
-	movq	$LOAD_PHYSICAL_ADDR, %rax
+	movl	BP_runtime_start(%rsi), %eax
 	addq	$(LOAD_PHYSICAL_ALIGN - 1), %rbp
 	andq	$~(LOAD_PHYSICAL_ALIGN - 1), %rbp
 	cmpq	%rbp, %rax
@@ -227,21 +216,9 @@ ENTRY(startup_64)
 	movq	%rax, %rbp
 1:
 #else
-	movq	$LOAD_PHYSICAL_ADDR, %rbp
+	movl	$LOAD_PHYSICAL_ADDR, %ebp
 #endif
-	movq	%rbp, %rbx
-
-	/* Replace the compressed data size with the uncompressed size */
-	movl	input_len(%rip), %eax
-	subq	%rax, %rbx
-	movl	output_len(%rip), %eax
-	addq	%rax, %rbx
-	/* Add 8 bytes for every 32K input block */
-	shrq	$12, %rax
-	addq	%rax, %rbx
-	/* Add 32K + 18 bytes of extra slack and align on a 4K boundary */
-	addq	$(32768 + 18 + 4095), %rbx
-	andq	$~4095, %rbx
+	leaq	z_extract_offset(%rbp), %rbx
 
 /* Copy the compressed kernel to the end of our buffer
  * where decompression in place becomes safe.
@@ -290,9 +267,8 @@ relocated:
 	movq	%rsi, %rdi		# real mode address
 	leaq	boot_heap(%rip), %rsi	# malloc area for uncompression
 	leaq	input_data(%rip), %rdx  # input_data
-	movl	input_len(%rip), %eax
-	movq	%rax, %rcx		# input_len
-	movq	%rbp, %r8		# output
+	movl	$z_input_len, %ecx	# input_len
+	movq	%rbp, %r8		# output target address
 	call	decompress_kernel
 	popq	%rsi
 
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
new file mode 100644
index 0000000..bcbd36c
--- /dev/null
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -0,0 +1,97 @@
+/* ----------------------------------------------------------------------- *
+ *
+ *  Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License version
+ *  2 as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ *
+ *  H. Peter Anvin <hpa@linux.intel.com>
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * Compute the desired load offset from a compressed program; outputs
+ * a small assembly wrapper with the appropriate symbols defined.
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <inttypes.h>
+
+static uint32_t getle32(const void *p)
+{
+	const uint8_t *cp = p;
+
+	return (uint32_t)cp[0] + ((uint32_t)cp[1] << 8) +
+		((uint32_t)cp[2] << 16) + ((uint32_t)cp[3] << 24);
+}
+
+int main(int argc, char *argv[])
+{
+	uint32_t olen;
+	long ilen;
+	unsigned long offs;
+	FILE *f;
+
+	if (argc < 2) {
+		fprintf(stderr, "Usage: %s compressed_file\n", argv[0]);
+		return 1;
+	}
+
+	/* Get the information for the compressed kernel image first */
+
+	f = fopen(argv[1], "r");
+	if (!f) {
+		perror(argv[1]);
+		return 1;
+	}
+
+
+	if (fseek(f, -4L, SEEK_END)) {
+		perror(argv[1]);
+	}
+	fread(&olen, sizeof olen, 1, f);
+	ilen = ftell(f);
+	olen = getle32(&olen);
+	fclose(f);
+
+	/*
+	 * Now we have the input (compressed) and output (uncompressed)
+	 * sizes, compute the necessary decompression offset...
+	 */
+
+	offs = (olen > ilen) ? olen - ilen : 0;
+	offs += olen >> 12;	/* Add 8 bytes for each 32K block */
+	offs += 32*1024 + 18;	/* Add 32K + 18 bytes slack */
+	offs = (offs+4095) & ~4095; /* Round to a 4K boundary */
+
+	printf(".section \".rodata.compressed\",\"a\",@progbits\n");
+	printf(".globl z_input_len\n");
+	printf("z_input_len = %lu\n", ilen);
+	printf(".globl z_output_len\n");
+	printf("z_output_len = %lu\n", (unsigned long)olen);
+	printf(".globl z_extract_offset\n");
+	printf("z_extract_offset = 0x%lx\n", offs);
+	/* z_extract_offset_negative allows simplification of head_32.S */
+	printf(".globl z_extract_offset_negative\n");
+	printf("z_extract_offset_negative = -0x%lx\n", offs);
+
+	printf(".globl input_data, input_data_end\n");
+	printf("input_data:\n");
+	printf(".incbin \"%s\"\n", argv[1]);
+	printf("input_data_end:\n");
+
+	return 0;
+}
diff --git a/arch/x86/boot/compressed/vmlinux.scr b/arch/x86/boot/compressed/vmlinux.scr
deleted file mode 100644
index f02382a..0000000
--- a/arch/x86/boot/compressed/vmlinux.scr
+++ /dev/null
@@ -1,10 +0,0 @@
-SECTIONS
-{
-  .rodata.compressed : {
-	input_len = .;
-	LONG(input_data_end - input_data) input_data = .;
-	*(.data)
-	output_len = . - 4;
-	input_data_end = .;
-	}
-}
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index cfd3bc4..0491fc4 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -22,7 +22,8 @@
 #include <asm/page_types.h>
 #include <asm/setup.h>
 #include "boot.h"
-#include "offsets.h"
+#include "voffset.h"
+#include "zoffset.h"
 
 BOOTSEG		= 0x07C0		/* original address of boot-sector */
 SYSSEG		= 0x1000		/* historical load address >> 4 */
@@ -115,7 +116,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0209		# header version number (>= 0x0105)
+		.word	0x020a		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -212,13 +213,23 @@ hardware_subarch:	.long 0			# subarchitecture, added with 2.07
 
 hardware_subarch_data:	.quad 0
 
-payload_offset:		.long input_data
-payload_length:		.long input_data_end-input_data
+payload_offset:		.long ZO_input_data
+payload_length:		.long ZO_z_input_len
 
 setup_data:		.quad 0			# 64-bit physical pointer to
 						# single linked list of
 						# struct setup_data
 
+runtime_start:		.long LOAD_PHYSICAL_ADDR
+#define ZO_RUNTIME_SIZE	(ZO__ebss+ZO_z_expand_offset)
+#define VO_RUNTIME_SIZE	(VO__end-VO__text)
+#if VO_RUNTIME_SIZE > ZO_RUNTIME_SIZE
+#define RUNTIME_SIZE	VO_RUNTIME_SIZE
+#else
+#define RUNTIME_SIZE	ZO_RUNTIME_SIZE
+#endif
+runtime_size:		.long RUNTIME_SIZE	# Minimum contiguous memory
+
 # End of setup header #####################################################
 
 	.section ".inittext", "ax"
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 433adae..dd924b5 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -62,6 +62,8 @@ struct setup_header {
 	__u32	payload_offset;
 	__u32	payload_length;
 	__u64	setup_data;
+	__u32	runtime_start;
+	__u32	runtime_size;
 } __attribute__((packed));
 
 struct sys_desc_table {
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 5a6aa1c..742e256 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -146,4 +146,5 @@ void foo(void)
 	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
 	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
 	OFFSET(BP_version, boot_params, hdr.version);
+	OFFSET(BP_runtime_start, boot_params, hdr.runtime_start);
 }
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index e72f062..5a29d50 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -125,6 +125,7 @@ int main(void)
 	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
 	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
 	OFFSET(BP_version, boot_params, hdr.version);
+	OFFSET(BP_runtime_start, boot_params, hdr.runtime_start);
 
 	BLANK();
 	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
-- 
1.6.0.6

