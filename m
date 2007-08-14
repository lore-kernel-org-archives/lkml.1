Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbXHNSRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbXHNSRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbXHNSRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:17:35 -0400
Received: from are.twiddle.net ([64.81.246.98]:50093 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbXHNSRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:17:33 -0400
X-Greylist: delayed 702 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 14:17:32 EDT
Date: Tue, 14 Aug 2007 11:04:57 -0700
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org, axp-list@redhat.com
Subject: aboot fixes for 2.6.23
Message-ID: <20070814180457.GA24179@twiddle.net>
Mail-Followup-To: linux-kernel@vger.kernel.org, axp-list@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recent build changes have added a PT_NOTE entry to the kernel's
ELF header.  A perfectly valid change, but Alpha's aboot loader
is none too bright about examining these headers.

The following patch to aboot-1.0_pre20040408.tar.bz2 makes it
so that only PT_LOAD entries are considered for loading, as well
as several other changes required to get the damned thing to
build again.


r~


diff -rup aboot-1.0_pre20040408/Makefile aboot-local/Makefile
--- aboot-1.0_pre20040408/Makefile	2004-04-08 08:19:01.000000000 -0700
+++ aboot-local/Makefile	2007-08-13 16:08:01.000000000 -0700
@@ -32,15 +32,15 @@ export
 #
 LOADADDR	= 20000000
 
-ABOOT_LDFLAGS = -static -N -Taboot.lds
+ABOOT_LDFLAGS = -static -N -Taboot.lds --relax
 
 CC		= gcc
 TOP		= $(shell pwd)
 ifeq ($(TESTING),)
-CPPFLAGS	= $(CFGDEFS) -I$(TOP)/include
-CFLAGS		= $(CPPFLAGS) -D__KERNEL__ -Os -Wall -fno-builtin -mno-fp-regs -ffixed-8
+CPPFLAGS	= $(CFGDEFS) -I$(TOP)/include -I$(KSRC)/include
+CFLAGS		= $(CPPFLAGS) -D__KERNEL__ -Os -Wall -fno-builtin -mno-fp-regs
 else
-CPPFLAGS	= -DTESTING $(CFGDEFS) -I$(TOP)/include
+CPPFLAGS	= -DTESTING $(CFGDEFS) -I$(TOP)/include -I$(KSRC)/include
 CFLAGS		= $(CPPFLAGS) -O -g3 -Wall -D__KERNEL__ -ffixed-8
 endif
 ASFLAGS		= $(CPPFLAGS)
diff -rup aboot-1.0_pre20040408/aboot.c aboot-local/aboot.c
--- aboot-1.0_pre20040408/aboot.c	2004-04-08 10:53:57.000000000 -0700
+++ aboot-local/aboot.c	2007-08-13 15:46:33.000000000 -0700
@@ -19,14 +19,13 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/elf.h>
 #include <linux/kernel.h>
 #include <linux/version.h>
-
 #include <asm/console.h>
 #include <asm/hwrpb.h>
 #include <asm/system.h>
 
+#include <elf.h>
 #include <alloca.h>
 #include <errno.h>
 
@@ -37,16 +36,6 @@
 #include "utils.h"
 #include "string.h"
 
-#ifndef elf_check_arch
-# define aboot_elf_check_arch(e)	1
-#else
-# if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-#  define aboot_elf_check_arch(e)        elf_check_arch(e)
-# else
-#  define aboot_elf_check_arch(e)        elf_check_arch(e->e_machine)
-# endif
-#endif
-
 struct bootfs *	bfs = 0;		/* filesystem to boot from */
 char *		dest_addr = 0;
 jmp_buf		jump_buffer;
@@ -83,77 +72,86 @@ static unsigned long entry_addr = START_
 long
 first_block (const char *buf, long blocksize)
 {
-	struct elfhdr *elf;
-	struct elf_phdr *phdrs;
+	Elf64_Ehdr *elf;
+	Elf64_Phdr *phdrs;
+	int i, j;
 
-	elf  = (struct elfhdr *) buf;
+	elf  = (Elf64_Ehdr *) buf;
 	
-	if (elf->e_ident[0] == 0x7f
-	    && strncmp(elf->e_ident + 1, "ELF", 3) == 0)
-	{
-		int i;
-		/* looks like an ELF binary: */
-		if (elf->e_type != ET_EXEC) {
-			printf("aboot: not an executable ELF file\n");
-			return -1;
-		}
-		if (!aboot_elf_check_arch(elf)) {
-			printf("aboot: ELF executable not for this machine\n");
-			return -1;
-		}
-		if (elf->e_phoff + elf->e_phnum * sizeof(*phdrs) > (unsigned) blocksize) {
-			printf("aboot: "
-			       "ELF program headers not in first block (%ld)\n",
-			       (long) elf->e_phoff);
+	if (elf->e_ident[0] != 0x7f
+	    || elf->e_ident[1] != 'E'
+	    || elf->e_ident[2] != 'L'
+	    || elf->e_ident[3] != 'F') {
+		/* Fail silently, it might be a compressed file */
+		return -1;
+	}
+	if (elf->e_ident[EI_CLASS] != ELFCLASS64
+	    || elf->e_ident[EI_DATA] != ELFDATA2LSB
+	    || elf->e_machine != EM_ALPHA) {
+		printf("aboot: ELF executable not for this machine\n");
+		return -1;
+	}
+
+	/* Looks like an ELF binary. */
+	if (elf->e_type != ET_EXEC) {
+		printf("aboot: not an executable ELF file\n");
+		return -1;
+	}
+
+	if (elf->e_phoff + elf->e_phnum * sizeof(*phdrs)
+	    > (unsigned) blocksize) {
+		printf("aboot: ELF program headers not in first block (%ld)\n",
+		       (long) elf->e_phoff);
+		return -1;
+	}
+
+	phdrs = (struct elf_phdr *) (buf + elf->e_phoff);
+	chunks = malloc(sizeof(struct segment) * elf->e_phnum);
+	start_addr = phdrs[0].p_vaddr; /* assume they are sorted */
+	entry_addr = elf->e_entry;
+
+	for (i = j = 0; i < elf->e_phnum; ++i) {
+		int status;
+
+		if (phdrs[i].p_type != PT_LOAD)
+			continue;
+
+		chunks[j].addr   = phdrs[i].p_vaddr;
+		chunks[j].offset = phdrs[i].p_offset;
+		chunks[j].size   = phdrs[i].p_filesz;
+		printf("aboot: PHDR %d vaddr %#lx offset %#lx size %#lx\n",
+		       i, chunks[j].addr, chunks[j].offset, chunks[j].size);
+
+		status = check_memory(chunks[j].addr, chunks[j].size);
+		if (status) {
+			printf("aboot: Can't load kernel.\n"
+			       "  Memory at %lx - %lx (PHDR %i) "
+			         "is %s\n",
+			       chunks[j].addr,
+			       chunks[j].addr + chunks[j].size - 1,
+			       i,
+			       (status == -ENOMEM) ?
+			          "Not Found" :
+				  "Busy (Reserved)");
 			return -1;
 		}
-		phdrs = (struct elf_phdr *) (buf + elf->e_phoff);
-		chunks = malloc(sizeof(struct segment) * elf->e_phnum);
-		nchunks = elf->e_phnum;
-		start_addr = phdrs[0].p_vaddr; /* assume they are sorted */
-		entry_addr = elf->e_entry;
-#ifdef DEBUG
-		printf("aboot: %d program headers, start address %#lx, entry %#lx\n",
-		       nchunks, start_addr, entry_addr);
-#endif
-		for (i = 0; i < elf->e_phnum; ++i) {
-			int status;
-
-			chunks[i].addr   = phdrs[i].p_vaddr;
-			chunks[i].offset = phdrs[i].p_offset;
-			chunks[i].size   = phdrs[i].p_filesz;
-#ifdef DEBUG
-			printf("aboot: segment %d vaddr %#lx offset %#lx size %#lx\n",
-			       i, chunks[i].addr, chunks[i].offset, chunks[i].size);
-#endif
-
-#ifndef TESTING
-			status = check_memory(chunks[i].addr, chunks[i].size);
-			if (status) {
+
+		if (phdrs[i].p_memsz > phdrs[i].p_filesz) {
+			if (bss_size > 0) {
 				printf("aboot: Can't load kernel.\n"
-				       "  Memory at %lx - %lx (chunk %i) "
-				         "is %s\n",
-				       chunks[i].addr,
-				       chunks[i].addr + chunks[i].size - 1,
-				       i,
-				       (status == -ENOMEM) ?
-				          "Not Found" :
-					  "Busy (Reserved)");
+				       "  Multiple BSS segments"
+				       " (PHDR %d)\n", i);
 				return -1;
 			}
-#endif
+			bss_start = (char *) (phdrs[i].p_vaddr +
+					      phdrs[i].p_filesz);
+			bss_size = phdrs[i].p_memsz - phdrs[i].p_filesz;
 		}
-		bss_start = (char *) (phdrs[elf->e_phnum - 1].p_vaddr +
-				      phdrs[elf->e_phnum - 1].p_filesz);
-		bss_size = (phdrs[elf->e_phnum - 1].p_memsz -
-			    phdrs[elf->e_phnum - 1].p_filesz);
-#ifdef DEBUG
-		printf("aboot: bss at 0x%p, size %#lx\n", bss_start, bss_size);
-#endif
-	} else {
-		/* Fail silently, it might be a compressed file */
-		return -1;
+
+		j++;
 	}
+	nchunks = j;
+	printf("aboot: bss at 0x%p, size %#lx\n", bss_start, bss_size);
 
 	return 0;
 }
diff -rup aboot-1.0_pre20040408/aboot.lds aboot-local/aboot.lds
--- aboot-1.0_pre20040408/aboot.lds	2001-10-08 16:03:50.000000000 -0700
+++ aboot-local/aboot.lds	2007-08-13 15:59:46.000000000 -0700
@@ -1,22 +1,25 @@
 OUTPUT_FORMAT("elf64-alpha")
 ENTRY(__start)
+PHDRS { kernel PT_LOAD; }
 SECTIONS
 {
   . = 0x20000000;
-  .text : { *(.text) }
+  .text : { *(.text) } :kernel
   _etext = .;
   PROVIDE (etext = .);
-  .rodata : { *(.rodata) }
-  .data : { *(.data) CONSTRUCTORS }
-  .got : { *(.got) }
-  .sdata : { *(.sdata) }
+  .rodata : { *(.rodata*) } :kernel
+  .data : { *(.data*) } :kernel
+  .got : { *(.got) } :kernel
+  .sdata : { *(.sdata) } :kernel
   _edata = .;
   PROVIDE (edata = .);
-  .sbss : { *(.sbss) *(.scommon) }
-  .bss : { *(.bss) *(COMMON) }
+  .sbss : { *(.sbss) *(.scommon) } :kernel
+  .bss : { *(.bss) *(COMMON) } :kernel
   _end = . ;
   PROVIDE (end = .);
 
+  /DISCARD/ : { *(.eh_frame) } 
+
   .mdebug 0 : { *(.mdebug) }
   .note 0 : { *(.note) }
   .comment 0 : { *(.comment) }
diff -rup aboot-1.0_pre20040408/cons.c aboot-local/cons.c
--- aboot-1.0_pre20040408/cons.c	2003-11-30 19:56:34.000000000 -0800
+++ aboot-local/cons.c	2007-08-13 15:48:45.000000000 -0700
@@ -1,5 +1,3 @@
-#include <alloca.h>
-
 #include <linux/kernel.h>
 
 #include <asm/console.h>
@@ -20,7 +18,7 @@
 #endif
 
 long cons_dev;			/* console device */
-extern long int dispatch();	/* Need the full 64 bit return here...*/
+extern long int dispatch(long, ...);	/* Need the full 64 bit return here...*/
 
 long
 cons_puts(const char *str, long len)
@@ -82,7 +80,7 @@ cons_getenv(long index, char *envval, lo
 	 * allocated on the stack (which guaranteed to by 8 byte
 	 * aligned).
 	 */
-	char * tmp = alloca(maxlen);
+	char tmp[maxlen];
 	long len;
 
 	len = dispatch(CCB_GET_ENV, index, tmp, maxlen - 1);
diff -rup aboot-1.0_pre20040408/disk.c aboot-local/disk.c
--- aboot-1.0_pre20040408/disk.c	2004-04-08 11:14:06.000000000 -0700
+++ aboot-local/disk.c	2007-08-13 15:50:22.000000000 -0700
@@ -113,7 +113,7 @@ int
 load_uncompressed (int fd)
 {
 	long nread, nblocks;
-	unsigned char *buf;
+	char *buf;
 	int i;
 
 	buf = malloc(bfs->blocksize);
@@ -131,7 +131,7 @@ load_uncompressed (int fd)
 	
 		for(i = 0; i < 16; i++) {
 			for (j = 0; j < 16; j++)
-				printf("%02X ", buf[j+16*i]);
+				printf("%02X ", (unsigned char) buf[j+16*i]);
 			for(j = 0; j < 16; j++) {
 				c = buf[j+16*i];
 				printf("%c", (c >= ' ') ? c : ' ');
diff -rup aboot-1.0_pre20040408/head.S aboot-local/head.S
--- aboot-1.0_pre20040408/head.S	2001-10-08 16:03:51.000000000 -0700
+++ aboot-local/head.S	2007-08-13 16:03:57.000000000 -0700
@@ -19,8 +19,7 @@ __start:
 	.quad	0,0,0,0,0,0,0,0
 1:	br	$27,2f
 2:	ldgp	$29,0($27)
-	lda	$27,main_
-	jsr	$26,($27),main_
+	bsr	$26,main_	!samegp
 	call_pal PAL_halt
 	.end __start
 
@@ -170,4 +169,4 @@ run_kernel:
 	mov	$16,$27
 	mov	$17,$30
 	jmp	$31,($27)
-	.end run_kernel
\ No newline at end of file
+	.end run_kernel
