Return-Path: <linux-kernel-owner+w=401wt.eu-S965956AbXFFXmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965956AbXFFXmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965845AbXFFXlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:41:25 -0400
Received: from 8.sub-75-209-226.myvzw.com ([75.209.226.8]:59400 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965106AbXFFXlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:41:23 -0400
Message-Id: <20070606230922.476662240@goop.org>
References: <20070606225837.654272428@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jun 2007 15:58:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC 6/7] i386: make the bzImage payload an ELF file
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

---
 arch/i386/boot/Makefile               |   11 ++++--
 arch/i386/boot/compressed/Makefile    |   29 +++++++++++++--
 arch/i386/boot/compressed/elfhdr.S    |   60 +++++++++++++++++++++++++++++++++
 arch/i386/boot/compressed/head.S      |    9 ++--
 arch/i386/boot/compressed/notes.S     |    7 +++
 arch/i386/boot/compressed/vmlinux.lds |   24 ++++++++++---
 arch/i386/boot/header.S               |    7 ---
 arch/i386/boot/setup.ld               |    5 ++
 arch/i386/kernel/head.S               |    1 
 arch/i386/kernel/vmlinux.lds.S        |    1 
 10 files changed, 131 insertions(+), 23 deletions(-)

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
+$(obj)/vmlinux-syms: EXTRACTSYMS := __reserved_end
+$(obj)/vmlinux-syms: EXTRACTSECTS := .bss
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
+	.int _head - ehdr				# p_offset
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
@@ -33,6 +36,7 @@ SECTIONS
 		*(.data.*)
 		_edata = . ;
 	}
+	blob_filesz = . ;
 	.bss : {
 		_bss = . ;
 		*(.bss)
@@ -40,4 +44,14 @@ SECTIONS
 		*(COMMON)
 		_end = . ;
 	}
+
+	/* __reserved_end taken from vmlinux */
+	blob_memsz = __reserved_end;
+
+	.notes : {
+		_notes = . ;
+		*(.note*)
+		_notes_end = .;
+	}
+	blob_notesz = _notes_end - _notes;
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
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -59,6 +59,7 @@ BOOTBITMAP_SIZE = LOW_PAGES / 8
 BOOTBITMAP_SIZE = LOW_PAGES / 8
 ALLOCATOR_SLOP = 4
 
+.globl INIT_MAP_BEYOND_END
 INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + ALLOCATOR_SLOP)*PAGE_SIZE_asm
 
 /*
===================================================================
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -194,6 +194,7 @@ SECTIONS
 	/* This is where the kernel creates the early boot page tables */
 	. = ALIGN(4096);
 	pg0 = . ;
+	__reserved_end = . + INIT_MAP_BEYOND_END - LOAD_OFFSET;
   }
 
   /* Sections to be discarded */

-- 

