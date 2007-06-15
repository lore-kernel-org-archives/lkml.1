Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbXFOOua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbXFOOua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbXFOOtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:49:10 -0400
Received: from gw.goop.org ([64.81.55.164]:34360 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbXFOOtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:49:05 -0400
Message-Id: <20070615005013.093570503@goop.org>
References: <20070615004818.424726597@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 17:48:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-Devel <xen-devel@lists.xensource.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 05/10] i386: make the bzImage payload an ELF file
Content-Disposition: inline; filename=i386-bzimage-elf-payload.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the payload of the bzImage file an ELF file.  In
other words, the bzImage is structured as follows:
 - boot sector
 - 16bit setup code
 - ELF header
  - decompressor
  - compressed kernel

A bootloader may find the start of the ELF file by looking at the
setup_size entry in the boot params, and using that to find the offset
of the ELF header.  The ELF Phdrs contain all the mapped memory
required to decompress and start booting the kernel.

One slightly complex part of this is that the bzImage boot_params need
to know about the internal structure of the ELF file, at least to the
extent of being able to point the core32_start entry at the ELF file's
entrypoint, so that loaders which use this field will still work.

Similarly, the ELF header needs to know how big the kernel vmlinux's
bss segment is, in order to make sure is is mapped properly.

To handle these two cases, we generate abstracted versions of the
object files which only contain the symbols we care about (generated
with objcopy --strip-all --keep-symbol=X), and then include those
symbol tables with ld -R.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/i386/boot/Makefile               |   11 ++++--
 arch/i386/boot/compressed/Makefile    |   29 +++++++++++++--
 arch/i386/boot/compressed/elfhdr.S    |   60 +++++++++++++++++++++++++++++++++
 arch/i386/boot/compressed/head.S      |    9 ++--
 arch/i386/boot/compressed/notes.S     |    7 +++
 arch/i386/boot/compressed/piggy.S     |    5 +-
 arch/i386/boot/compressed/vmlinux.lds |   33 +++++++++++++++---
 arch/i386/boot/header.S               |    7 ---
 arch/i386/boot/setup.ld               |    5 ++
 arch/i386/kernel/asm-offsets.c        |    2 +
 arch/i386/kernel/head.S               |   26 +++++++++++---
 arch/i386/kernel/vmlinux.lds.S        |    4 +-
 12 files changed, 167 insertions(+), 31 deletions(-)

===================================================================
--- a/arch/i386/boot/Makefile
+++ b/arch/i386/boot/Makefile
@@ -72,14 +72,19 @@ AFLAGS		:= $(CFLAGS) -D__ASSEMBLY__
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
-LDFLAGS_setup.elf	:= -T
-$(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) FORCE
+$(obj)/zImage $(obj)/bzImage: 				\
+	LDFLAGS	:=					\
+		-R $(obj)/compressed/blob-syms		\
+		--defsym IMAGE_OFFSET=$(IMAGE_OFFSET) -T
+
+$(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) 	\
+		$(obj)/compressed/blob-syms FORCE
 	$(call if_changed,ld)
 
 $(obj)/payload.o:	EXTRA_AFLAGS := -Wa,-I$(obj)
 $(obj)/payload.o: $(src)/payload.S $(obj)/blob.bin
 
-$(obj)/compressed/blob: FORCE
+$(obj)/compressed/blob $(obj)/compressed/blob-syms: FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/compressed IMAGE_OFFSET=$(IMAGE_OFFSET) $@
 
 # Set this if you want to pass append arguments to the zdisk/fdimage/isoimage kernel
===================================================================
--- a/arch/i386/boot/compressed/Makefile
+++ b/arch/i386/boot/compressed/Makefile
@@ -4,21 +4,42 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets		:= blob vmlinux.bin vmlinux.bin.gz head.o misc.o piggy.o \
+targets		:= blob vmlinux.bin vmlinux.bin.gz \
+			elfhdr.o head.o misc.o notes.o piggy.o \
 			vmlinux.bin.all vmlinux.relocs
 
-LDFLAGS_blob	:= -T
 hostprogs-y	:= relocs
 
 CFLAGS  := -m32 -D__KERNEL__ $(LINUX_INCLUDE) -O2 \
 	   -fno-strict-aliasing -fPIC \
 	   $(call cc-option,-ffreestanding) \
 	   $(call cc-option,-fno-stack-protector)
-LDFLAGS := -m elf_i386
+LDFLAGS := -R $(obj)/vmlinux-syms --defsym IMAGE_OFFSET=$(IMAGE_OFFSET) -T
 
-$(obj)/blob: $(src)/vmlinux.lds $(obj)/head.o $(obj)/misc.o $(obj)/piggy.o FORCE
+OBJS=$(addprefix $(obj)/,elfhdr.o head.o misc.o notes.o piggy.o)
+
+$(obj)/blob: $(src)/vmlinux.lds $(obj)/vmlinux-syms $(OBJS) FORCE
 	$(call if_changed,ld)
 	@:
+
+# Generate a stripped-down object including only the symbols needed
+# so that we can get them with ld -R. Direct stderr to /dev/null to
+# shut useless warning up.
+quiet_cmd_symextract = SYMEXT $@
+      cmd_symextract = objcopy -S \
+			$(addprefix -j,$(EXTRACTSECTS)) \
+			$(addprefix -K,$(EXTRACTSYMS)) \
+			$< $@ 2>/dev/null
+
+$(obj)/blob-syms: EXTRACTSYMS := blob_entry blob_payload
+$(obj)/blob-syms: EXTRACTSECTS := .text.head .data.compressed
+$(obj)/blob-syms: $(obj)/blob FORCE
+	$(call if_changed,symextract)
+
+$(obj)/vmlinux-syms: EXTRACTSYMS := __kernel_end __kernel_data_size
+$(obj)/vmlinux-syms: EXTRACTSECTS :=
+$(obj)/vmlinux-syms: vmlinux FORCE
+	$(call if_changed,symextract)
 
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
===================================================================
--- /dev/null
+++ b/arch/i386/boot/compressed/elfhdr.S
@@ -0,0 +1,60 @@
+/* DIY ELF header */
+
+#include <linux/elf.h>
+#include <asm/boot.h>
+
+.section .elfhdr,"a",@progbits
+ehdr:
+	# e_ident
+	.byte ELFMAG0, ELFMAG1, ELFMAG2, ELFMAG3
+	.byte ELFCLASS32, ELFDATA2LSB, EV_CURRENT, ELFOSABI_STANDALONE
+	.org ehdr + EI_NIDENT
+#ifndef CONFIG_RELOCATABLE
+	.word ET_EXEC				# e_type
+#else
+	.word ET_DYN				# e_type
+#endif
+	.word EM_386				# e_machine
+	.int  1					# e_version
+	.int  LOAD_PHYSICAL_ADDR + blob_startup_32 - ehdr	# e_entry
+	.int  phdr - ehdr			# e_phoff
+	.int  0					# e_shoff
+	.int  0					# e_flags
+	.word ehdr_end - ehdr			# e_ehsize
+	.word phdr_size				# e_phentsize
+	.word phnum				# e_phnum
+	.word 40				# e_shentsize
+	.word 0					# e_shnum
+	.word 0					# e_shstrndx
+ehdr_end:
+
+phdr:
+	.int PT_LOAD					# p_type
+	.int 0						# p_offset
+	.int LOAD_PHYSICAL_ADDR				# p_vaddr
+	.int LOAD_PHYSICAL_ADDR				# p_paddr
+	.int blob_filesz				# p_filesz
+	.int blob_memsz					# p_memsz
+	.int PF_R | PF_W | PF_X				# p_flags
+	.int 4096					# p_align
+phdr_size = . - phdr
+
+	.int PT_NOTE					# p_type
+	.int _notes - ehdr				# p_offset
+	.int 0						# p_vaddr
+	.int 0						# p_paddr
+	.int blob_notesz				# p_filesz
+	.int 0						# p_memsz
+	.int 0						# p_flags
+	.int 0						# p_align
+
+	.int PT_PHDR					# p_type
+	.int phdr - ehdr				# p_offset
+	.int LOAD_PHYSICAL_ADDR + phdr - ehdr		# p_vaddr
+	.int LOAD_PHYSICAL_ADDR + phdr - ehdr		# p_paddr
+	.int phdr_end - phdr				# p_filesz
+	.int phdr_end - phdr				# p_memsz
+	.int PF_R | PF_W | PF_X				# p_flags
+	.int 0						# p_align
+phdr_end:
+phnum = (phdr_end - phdr) / phdr_size
===================================================================
--- a/arch/i386/boot/compressed/head.S
+++ b/arch/i386/boot/compressed/head.S
@@ -27,11 +27,12 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/boot.h>
+#include <asm/asm-offsets.h>
 
 .section ".text.head","ax",@progbits
-	.globl startup_32
+	.globl blob_startup_32
 
-startup_32:
+blob_startup_32:
 	cld
 	cli
 	movl $(__BOOT_DS),%eax
@@ -48,7 +49,7 @@ startup_32:
  * data at 0x1e4 (defined as a scratch field) are used as the stack
  * for this calculation. Only 4 bytes are needed.
  */
-	leal (0x1e4+4)(%esi), %esp
+	leal (BP_scratch+4)(%esi), %esp
 	call 1f
 1:	popl %ebp
 	subl $1b, %ebp
@@ -85,7 +86,7 @@ 1:	popl %ebp
 	pushl %esi
 	leal _end(%ebp), %esi
 	leal _end(%ebx), %edi
-	movl $(_end - startup_32), %ecx
+	movl $(_end - blob_startup_32), %ecx
 	std
 	rep
 	movsb
===================================================================
--- /dev/null
+++ b/arch/i386/boot/compressed/notes.S
@@ -0,0 +1,7 @@
+#include <linux/elfnote.h>
+#include <linux/elf_boot.h>
+#include <linux/utsrelease.h>
+
+ELFNOTE(ELF_NOTE_BOOT, EIN_PROGRAM_NAME, .asciz "Linux")
+ELFNOTE(ELF_NOTE_BOOT, EIN_PROGRAM_VERSION, .asciz UTS_RELEASE)
+ELFNOTE(ELF_NOTE_BOOT, EIN_ARGUMENT_STYLE, .asciz "Linux")
===================================================================
--- a/arch/i386/boot/compressed/piggy.S
+++ b/arch/i386/boot/compressed/piggy.S
@@ -1,8 +1,9 @@
 .section .data.compressed,"a",@progbits
 
-.globl input_data, input_len, output_len
+.globl input_data, input_len, input_size, output_len
 
-input_len:	.long input_data_end - input_data
+input_size = input_data_end - input_data
+input_len:	.long input_size
 
 input_data:
 .incbin "vmlinux.bin.gz"
===================================================================
--- a/arch/i386/boot/compressed/vmlinux.lds
+++ b/arch/i386/boot/compressed/vmlinux.lds
@@ -1,18 +1,21 @@ OUTPUT_FORMAT("elf32-i386", "elf32-i386"
-OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
+OUTPUT_FORMAT("elf32-i386")
 OUTPUT_ARCH(i386)
-ENTRY(startup_32)
+
 SECTIONS
 {
-        /* Be careful parts of head.S assume startup_32 is at
-         * address 0.
-	 */
+	/* make sure we don't get anything from vmlinux-syms */
+	/DISCARD/ : { */vmlinux-syms(*) }
+
 	. =  0 	;
 	.text.head : {
+		*(.elfhdr)
 		_head = . ;
+	blob_entry = blob_startup_32 + IMAGE_OFFSET;
 		*(.text.head)
 		_ehead = . ;
 	}
 	.data.compressed : {
+	blob_payload = input_data + IMAGE_OFFSET;
 		*(.data.compressed)
 	}
 	.text :	{
@@ -33,6 +36,14 @@ SECTIONS
 		*(.data.*)
 		_edata = . ;
 	}
+	.notes : {
+		_notes = . ;
+		*(.note*)
+		_notes_end = .;
+	}
+	blob_notesz = _notes_end - _notes;
+
+	blob_filesz = . ;
 	.bss : {
 		_bss = . ;
 		*(.bss)
@@ -40,4 +51,16 @@ SECTIONS
 		*(COMMON)
 		_end = . ;
 	}
+
+	blob_notesz = _notes_end - _notes;
+
+	/* How much memory we need for decompression: */
+	blob_needs = . - IMAGE_OFFSET +	/* compressed data + decompressor */
+		__kernel_data_size +	/* uncompressed data */
+		(__kernel_data_size / 0x8000 * 8) + 0x8000 + 18; /* overhead */
+
+	/* Memory we need to reserve in PHDR:
+	   max of our needs and kernel's needs */
+	blob_memsz = blob_needs > __kernel_end ? blob_needs : __kernel_end;
+
 }
===================================================================
--- a/arch/i386/boot/header.S
+++ b/arch/i386/boot/header.S
@@ -155,13 +155,8 @@ setup_move_size: .word  _setup_size	# si
 					# loader knows how much data behind
 					# us also needs to be loaded.
 
-code32_start:				# here loaders can put a different
+code32_start:	.long blob_entry	# here loaders can put a different
 					# start address for 32-bit code.
-#ifndef __BIG_KERNEL__
-		.long	0x1000		#   0x1000 = default for zImage
-#else
-		.long	0x100000	# 0x100000 = default for big kernel
-#endif
 
 ramdisk_image:	.long	0		# address of loaded ramdisk image
 					# Here the loader puts the 32-bit
===================================================================
--- a/arch/i386/boot/setup.ld
+++ b/arch/i386/boot/setup.ld
@@ -9,6 +9,9 @@ ENTRY(_start)
 
 SECTIONS
 {
+	/* make sure we don't get anything from blob-syms */
+	/DISCARD/	: { */blob-syms(*) }
+
 	.bstext 0	: { *(.bstext) }
 	.bsdata		: { *(.bsdata) }
 
@@ -45,7 +48,7 @@ SECTIONS
 
 	/DISCARD/ : { *(.note*) }
 
-	. = ALIGN(512);		/* align to sector size */
+	. = ALIGN(4096);		/* align to page size */
 	_setup_size = . - _start;
 	_setup_sects = _setup_size / 512;
 
===================================================================
--- a/arch/i386/kernel/asm-offsets.c
+++ b/arch/i386/kernel/asm-offsets.c
@@ -109,6 +109,8 @@ void foo(void)
 	DEFINE(PTRS_PER_PTE, PTRS_PER_PTE);
 	DEFINE(PTRS_PER_PMD, PTRS_PER_PMD);
 	DEFINE(PTRS_PER_PGD, PTRS_PER_PGD);
+	DEFINE(PMD_SIZE, PMD_SIZE);
+	DEFINE(PGDIR_SIZE, PGDIR_SIZE);
 
 	DEFINE(VDSO_PRELINK_asm, VDSO_PRELINK);
 
===================================================================
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -49,18 +49,34 @@
  *
  * This should be a multiple of a page.
  */
-LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
-
+LOW_PAGES = ((-__PAGE_OFFSET) >> PAGE_SHIFT_asm)
+
+
+#define ROUNDUP(x,y)	(((x) + (y) - 1) & ~((y)-1))
+
+/* number of pages needed to map x bytes */
 #if PTRS_PER_PMD > 1
-PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PMD) + PTRS_PER_PGD
+#define MAPPING_SIZE(x)	(ROUNDUP(x, PMD_SIZE) / PTRS_PER_PMD + PTRS_PER_PGD)
 #else
-PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PGD)
-#endif
+#define MAPPING_SIZE(x)	(ROUNDUP(x, PGDIR_SIZE) / PTRS_PER_PGD)
+#endif
+
+PAGE_TABLE_SIZE = MAPPING_SIZE(LOW_PAGES)
 BOOTBITMAP_SIZE = LOW_PAGES / 8
 ALLOCATOR_SLOP = 4
 
 INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + ALLOCATOR_SLOP)*PAGE_SIZE_asm
 
+/*
+ * Where the kernel's initial load-time mapping must end for this code
+ * to get started.  This includes the kernel text+data+bss+enough
+ * pg0 space to map INIT_MAP_BEYOND_END.  This is only really needed for
+ * bootloaders which start the kernel with paging enabled, which may
+ * not use this pagetable setup anyway, but its good to be consistent.
+ */
+.globl pg0_init_size
+pg0_init_size = ROUNDUP(INIT_MAP_BEYOND_END / 1024, PAGE_SIZE_asm)
+
 /*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
  * %esi points to the real-mode code as a 32-bit pointer.
===================================================================
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -199,7 +199,9 @@ SECTIONS
 	/* This is where the kernel creates the early boot page tables */
 	. = ALIGN(4096);
 	pg0 = . ;
-  }
+	__kernel_end = pg0 + pg0_init_size - LOAD_OFFSET - LOAD_PHYSICAL_ADDR ;
+  }
+  __kernel_data_size = __init_end - _text	;
 
   /* Sections to be discarded */
   /DISCARD/ : {

-- 

