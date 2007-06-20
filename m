Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbXFUAdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbXFUAdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 20:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757965AbXFUAc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 20:32:29 -0400
Received: from bay-wan-b-65.sfo.dsl.cerfnet.com ([216.148.65.65]:46217 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753938AbXFUAc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 20:32:27 -0400
Message-Id: <20070620231852.829465239@goop.org>
References: <20070620231726.834538992@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 16:17:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 4/9] i386: make the bzImage payload an ELF file
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
 arch/i386/boot/Makefile                 |   11 +++--
 arch/i386/boot/compressed/Makefile      |   18 ++++++--
 arch/i386/boot/compressed/elfhdr.c      |   65 +++++++++++++++++++++++++++++++
 arch/i386/boot/compressed/head.S        |    9 ++--
 arch/i386/boot/compressed/notes.c       |    7 +++
 arch/i386/boot/compressed/piggy.S       |    5 +-
 arch/i386/boot/compressed/vmlinux.lds   |   29 +++++++++++--
 arch/i386/boot/header.S                 |   14 ++----
 arch/i386/boot/setup.ld                 |    5 +-
 arch/i386/kernel/asm-offsets.c          |    2 
 arch/i386/kernel/head.S                 |   26 ++++++++++--
 arch/i386/kernel/vmlinux.lds.S          |    4 +
 arch/x86_64/boot/compressed/Makefile    |   22 ++++++++--
 arch/x86_64/boot/compressed/elfhdr.c    |    1 
 arch/x86_64/boot/compressed/head.S      |   12 ++---
 arch/x86_64/boot/compressed/vmlinux.lds |   21 +++++++++-
 arch/x86_64/kernel/vmlinux.lds.S        |    3 +
 include/asm-x86_64/elf-defines.h        |    5 ++
 include/asm-x86_64/elf.h                |    2 
 scripts/Makefile.lib                    |   11 +++++
 20 files changed, 226 insertions(+), 46 deletions(-)

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
@@ -4,21 +4,31 @@
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
+EXTRACTSYMS_blob-syms := blob_entry_32
+$(obj)/blob-syms: $(obj)/blob FORCE
+	$(call if_changed,symextract)
+
+EXTRACTSYMS_vmlinux-syms := __kernel_end __kernel_data_size
+$(obj)/vmlinux-syms: vmlinux FORCE
+	$(call if_changed,symextract)
 
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
===================================================================
--- /dev/null
+++ b/arch/i386/boot/compressed/elfhdr.c
@@ -0,0 +1,65 @@
+#include <linux/elf-defn.h>
+#include <asm/boot.h>
+#include <asm/page.h>
+#include <asm/elf-defines.h>
+
+typedef char ld_sym_t[];
+
+extern ld_sym_t blob_filesz, blob_memsz,
+	blob_notesz, _notes, blob_entry_32, blob_entry_64;
+
+#define LDSYM(x)	((unsigned long)x)
+
+#define PHDR(type, offset, vaddr, paddr, filesz, memsz, flags, align)	\
+	{								\
+		.p_type = type, .p_offset = offset,			\
+		.p_vaddr = vaddr, .p_paddr = paddr,			\
+		.p_filesz = filesz, .p_memsz = memsz,			\
+		.p_flags = flags, .p_align = align,			\
+	}
+
+static Elf_Phdr phdr[]
+__attribute__((section(".elf.phdr"), used)) = {
+	PHDR(PT_LOAD, 0, LOAD_PHYSICAL_ADDR, LOAD_PHYSICAL_ADDR,
+	     LDSYM(blob_filesz), LDSYM(blob_memsz),
+	     PF_R | PF_W | PF_X,
+	     PAGE_SIZE),
+	PHDR(PT_NOTE, LDSYM(_notes), 0, 0, LDSYM(blob_notesz), 0, 0, 0),
+};
+
+static Elf_Ehdr ehdr
+__attribute__((section(".elf.ehdr"), used)) = {
+	.e_ident = { [EI_MAG0] = ELFMAG0,
+		     [EI_MAG1] = ELFMAG1,
+		     [EI_MAG2] = ELFMAG2,
+		     [EI_MAG3] = ELFMAG3,
+
+		     [EI_CLASS] = ELF_CLASS,
+		     [EI_DATA] = ELF_DATA,
+		     [EI_VERSION] = EV_CURRENT,
+		     [EI_OSABI] = ELFOSABI_STANDALONE,
+	},
+#ifdef CONFIG_RELOCATABLE
+	.e_type = ET_DYN,
+#else
+	.e_type = ET_EXEC,
+#endif
+	.e_machine = ELF_ARCH,
+	.e_version = 1,
+#if ELF_CLASS == ELFCLASS32
+	.e_entry = LDSYM(blob_entry_32),
+#elif ELF_CLASS == ELFCLASS64
+	.e_entry = LDSYM(blob_entry_64),
+#else
+#warning ELF_CLASS not set
+#endif
+	.e_phoff = (unsigned long)phdr,
+	.e_shoff = 0,
+	.e_flags = 0,
+	.e_ehsize = sizeof(Elf_Ehdr),
+	.e_phentsize = sizeof(Elf_Phdr),
+	.e_phnum = sizeof(phdr)/sizeof(*phdr),
+	.e_shentsize = sizeof(Elf_Shdr),
+	.e_shnum = 0,
+	.e_shstrndx = 0,
+};
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
+++ b/arch/i386/boot/compressed/notes.c
@@ -0,0 +1,7 @@
+#include <linux/elfnote.h>
+#include <linux/elf_boot.h>
+#include <linux/utsrelease.h>
+
+ELFNOTE(ELF_NOTE_BOOT, EIN_PROGRAM_NAME, "Linux");
+ELFNOTE(ELF_NOTE_BOOT, EIN_PROGRAM_VERSION, UTS_RELEASE);
+ELFNOTE(ELF_NOTE_BOOT, EIN_ARGUMENT_STYLE, "Linux");
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
@@ -1,18 +1,27 @@ OUTPUT_FORMAT("elf32-i386")
 OUTPUT_FORMAT("elf32-i386")
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
+		*(.elf.ehdr)
+		*(.elf.phdr)
+		_notes = . ;
+		*(.note*)
+		_notes_end = .;
+
 		_head = . ;
+	blob_entry_32 = blob_startup_32 + IMAGE_OFFSET;
 		*(.text.head)
 		_ehead = . ;
 	}
+	blob_notesz = _notes_end - _notes;
 	.data.compressed : {
+	blob_payload = input_data + IMAGE_OFFSET;
 		*(.data.compressed)
 	}
 	.text :	{
@@ -33,6 +42,8 @@ SECTIONS
 		*(.data.*)
 		_edata = . ;
 	}
+
+	blob_filesz = . ;
 	.bss : {
 		_bss = . ;
 		*(.bss)
@@ -41,4 +52,14 @@ SECTIONS
 		. = ALIGN(8);
 		_end = . ;
 	}
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
@@ -148,20 +148,16 @@ CAN_USE_HEAP	= 0x80			# If set, the load
 		.byte	LOADED_HIGH
 #endif
 
-setup_move_size: .word  _setup_size	# size to move, when setup is not
+setup_move_size: .word  0x8000		# size to move, when setup is not
 					# loaded at 0x90000. We will move setup
 					# to 0x90000 then just before jumping
 					# into the kernel. However, only the
 					# loader knows how much data behind
-					# us also needs to be loaded.
-
-code32_start:				# here loaders can put a different
+					# us also needs to be loaded.  Needs to
+					# default to 0x8000 for old bootloaders.
+
+code32_start:	.long blob_entry_32	# here loaders can put a different
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
@@ -49,17 +49,33 @@
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
+
+/*
+ * Where the kernel's initial load-time mapping must end for this code
+ * to get started.  This includes the kernel text+data+bss+enough
+ * pg0 space to map INIT_MAP_BEYOND_END.  This is only really needed for
+ * bootloaders which start the kernel with paging enabled, which may
+ * not use this pagetable setup anyway, but its good to be consistent.
+ */
+.globl pg0_init_size
+pg0_init_size = ROUNDUP(INIT_MAP_BEYOND_END / 1024, PAGE_SIZE_asm)
 
 /*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
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
===================================================================
--- a/arch/x86_64/boot/compressed/Makefile
+++ b/arch/x86_64/boot/compressed/Makefile
@@ -6,19 +6,33 @@
 # Note all the files here are compiled/linked as 32bit executables.
 #
 
-targets		:= blob vmlinux.bin vmlinux.bin.gz head.o misc.o piggy.o
+targets		:= blob vmlinux.bin vmlinux.bin.gz \
+			elfhdr.o head.o misc.o piggy.o
 
 CFLAGS := -m64 -D__KERNEL__ $(LINUXINCLUDE) -O2  \
 	  -fno-strict-aliasing -fPIC -mcmodel=small \
 	   $(call cc-option, -ffreestanding) \
 	   $(call cc-option, -fno-stack-protector)
 AFLAGS  := $(CFLAGS) -D__ASSEMBLY__
-LDFLAGS := -m elf_x86_64
 
-LDFLAGS_blob := -T
-$(obj)/blob: $(src)/vmlinux.lds $(obj)/head.o $(obj)/misc.o $(obj)/piggy.o FORCE
+LDFLAGS := -m elf_x86_64 -R $(obj)/vmlinux-syms --defsym IMAGE_OFFSET=$(IMAGE_OFFSET) -T
+OBJS=$(addprefix $(obj)/,elfhdr.o head.o misc.o notes.o piggy.o)
+
+$(obj)/elfhdr.o: $(src)/../../../i386/boot/compressed/elfhdr.c
+$(obj)/notes.o: $(src)/../../../i386/boot/compressed/notes.c
+
+$(obj)/blob: $(src)/vmlinux.lds $(obj)/vmlinux-syms $(OBJS) FORCE
 	$(call if_changed,ld)
 	@:
+
+EXTRACTSYMS_blob-syms := blob_entry_64 blob_entry_32
+EXTRACTOUTPUT_blob-syms := --32
+$(obj)/blob-syms: $(obj)/blob FORCE
+	$(call if_changed,symextract)
+
+EXTRACTSYMS_vmlinux-syms := __kernel_end __kernel_data_size
+$(obj)/vmlinux-syms: vmlinux FORCE
+	$(call if_changed,symextract)
 
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
===================================================================
--- /dev/null
+++ b/arch/x86_64/boot/compressed/elfhdr.c
@@ -0,0 +1,1 @@
+#include "../../../i386/boot/compressed/elfhdr.c"
===================================================================
--- a/arch/x86_64/boot/compressed/head.S
+++ b/arch/x86_64/boot/compressed/head.S
@@ -32,9 +32,9 @@
 
 .section ".text.head"
 	.code32
-	.globl startup_32
-
-startup_32:
+	.globl blob_startup_32
+
+blob_startup_32:
 	cld
 	cli
 	movl	$(__KERNEL_DS), %eax
@@ -158,7 +158,7 @@ 1:	movl	%eax, 0(%edi)
 	 * used to perform that far jump.
 	 */
 	pushl	$__KERNEL_CS
-	leal	startup_64(%ebp), %eax
+	leal	blob_startup_64(%ebp), %eax
 	pushl	%eax
 
 	/* Enter paged protected Mode, activating Long Mode */
@@ -183,7 +183,7 @@ 1:
 	 */
 	.code64
 	.org 0x200
-ENTRY(startup_64)
+ENTRY(blob_startup_64)
 	/* We come here either from startup_32 or directly from a
 	 * 64bit bootloader.  If we come here from a bootloader we depend on
 	 * an identity mapped page table being provied that maps our
@@ -207,7 +207,7 @@ ENTRY(startup_64)
 
 	/* Start with the delta to where the kernel will run at. */
 #ifdef CONFIG_RELOCATABLE
-	leaq	startup_32(%rip) /* - $startup_32 */, %rbp
+	leaq	blob_startup_32(%rip) /* - $startup_32 */, %rbp
 	addq	$(LARGE_PAGE_SIZE - 1), %rbp
 	andq	$LARGE_PAGE_MASK, %rbp
 	movq	%rbp, %rbx
===================================================================
--- a/arch/x86_64/boot/compressed/vmlinux.lds
+++ b/arch/x86_64/boot/compressed/vmlinux.lds
@@ -1,6 +1,6 @@ OUTPUT_FORMAT("elf64-x86-64")
 OUTPUT_FORMAT("elf64-x86-64")
 OUTPUT_ARCH(i386:x86-64)
-ENTRY(startup_64)
+
 SECTIONS
 {
 	/* Be careful parts of head.S assume startup_32 is at
@@ -8,7 +8,15 @@ SECTIONS
 	 */
 	. = 0;
 	.text :	{
+		*(.elf.ehdr)
+		*(.elf.phdr)
+		_notes = . ;
+		*(.note*)
+		_notes_end = .;
+
 		_head = . ;
+	blob_entry_32 = blob_startup_32 + IMAGE_OFFSET;
+	blob_entry_64 = blob_startup_64 + IMAGE_OFFSET;
 		*(.text.head)
 		_ehead = . ;
 		*(.text.compressed)
@@ -29,6 +37,7 @@ SECTIONS
 		*(.data.*)
 		_edata = . ;
 	}
+	blob_filesz = . ;
 	.bss : {
 		_bss = . ;
 		*(.bss)
@@ -41,4 +50,14 @@ SECTIONS
 		. = . + 4096 * 6;
 		_heap = .;
 	}
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
 }
===================================================================
--- a/arch/x86_64/kernel/vmlinux.lds.S
+++ b/arch/x86_64/kernel/vmlinux.lds.S
@@ -232,6 +232,9 @@ SECTIONS
 
   _end = . ;
 
+  __kernel_end = _end - LOAD_OFFSET;
+  __kernel_data_size = __init_end - _text;
+
   /* Sections to be discarded */
   /DISCARD/ : {
 	*(.exitcall.exit)
===================================================================
--- a/include/asm-x86_64/elf-defines.h
+++ b/include/asm-x86_64/elf-defines.h
@@ -1,1 +1,6 @@
 #include <asm-generic/elf64-defines.h>
+#define ELF_DATA	ELFDATA2LSB
+
+#ifndef ELF_ARCH
+#define ELF_ARCH	EM_X86_64
+#endif
===================================================================
--- a/include/asm-x86_64/elf.h
+++ b/include/asm-x86_64/elf.h
@@ -40,8 +40,6 @@ typedef struct user_i387_struct elf_fpre
  * These are used to set parameters in the core dumps.
  */
 #include <asm/elf-defines.h>
-#define ELF_DATA	ELFDATA2LSB
-#define ELF_ARCH	EM_X86_64
 
 #ifdef __KERNEL__
 #include <asm/processor.h>
===================================================================
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -163,3 +163,14 @@ cmd_gzip = gzip -f -9 < $< > $@
 cmd_gzip = gzip -f -9 < $< > $@
 
 
+# Symbol extraction
+# ---------------------------------------------------------------------------
+# Generate a stripped-down object including only the symbols needed
+# so that we can get them with ld -R.
+empty:=
+space:=$(empty) $(empty)
+quiet_cmd_symextract = SYMEXT  $@
+      cmd_symextract = $(NM) -tx $< | \
+			gawk -v 'pattern=$(subst $(space),|,$(strip $(EXTRACTSYMS) $(EXTRACTSYMS_$(@F))))' \
+			'$$3~(pattern) {printf ".globl %s;%s=0x%s\n",$$3,$$3,$$1}' \
+			| $(AS) $(EXTRACTOUTPUT_$(@F)) -o $@

-- 

