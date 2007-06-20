Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbXFUAnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbXFUAnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 20:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbXFUAnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 20:43:14 -0400
Received: from bay-wan-b-65.sfo.dsl.cerfnet.com ([216.148.65.65]:54417 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753512AbXFUAnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 20:43:08 -0400
X-Greylist: delayed 2815 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2007 20:41:47 EDT
Message-Id: <20070620230902.387008536@goop.org>
References: <20070620230854.246399397@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 16:08:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>, Ian Molton <spyro@f2s.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Aubrey Li <aubrey.li@analog.com>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Ralf Baechle <ralf@linux-mips.org>, Matthew Wilcox <matthew@wil.cx>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>,
       Miles Bader <uclinux-v850@lsi.nec.co.jp>,
       Chris Zankel <chris@zankel.net>
Subject: [PATCH] cross-architecture ELF clean up
Content-Disposition: inline; filename=elf-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the ELF headers and their users.  It does several
related things:

1. split linux/elf.h into pieces

This splits linux/elf.h into several pieces:
	linux/elf.h		- still the common elf header,
				  functionally unchanged
	linux/elf-const.h	- ELF constants, includable by asm code
	linux/elf-decl.h	- ELF type declarations, without definitions
	linux/elf-defn.h	- ELF type definitions

This makes it easier to use the ELF headers in various contexts such
as assembler and boot code, without pulling in a lot of other unneeded
headers.

2. add asm-*/elf-defines.h, and asm-generic/elf(32|64)-defines.h

Architectures define some arch-specific ELF definitions.

The most basic of these is whether they want to use a 32 or 64 bit ELF
class, and their associated types.  These common definitions have been
put into asm-generic/elf(32|64)-defines.h, so that a simple
architecture can simply include the appropriate generic header in its
asm/elf-defines.h.

The effect of including asm/elf-defines.h in any code is that you get
the architecture's preferred ELF_CLASS defined, and the generic types
(Elf_Ehdr, Elf_Phdr, etc) are defined to the appropriate class types
(Elf32_Ehdr, etc).

For most architectures this transition was straightforward, but some
need special handling:

  mips, powerpc, s390 allow both 32 and 64 bit operation.  powerpc's
  logic for this was particularly complex, so I just copied the code
  outright into asm-powerpc/elf-defines.h and hope that it's right.

  powerpc also appears to have its own duplicate copy of elf.h in
  arch/powerpc/boot/elf.h; presumably because the standard elf.h
  brings in too much.  Update it to just linux/elf-defn.h, which
  should be fine.

  x86-64 does some mucking about with ELF_CLASS in order to make
  fs/binfmt_elf also handle 32-bit binaries.  This is why
  asm-generic/elf(32|64)_defines.h only conditionally define
  ELF_CLASS.

3. Narrow elf.h includes.

Some headers, such as linux/modules.h, are included by a large
proportion of the kernel code, and end up including linux/elf.h which
in turn includes a lot of other headers.  In practice, linux/modules.h
only wants a couple of ELF type declarations, and so can make do with
asm/elf-defines.h, which includes very little.

A side effect of this is that some files were depending on
linux/elf.h's implicit includes, and so needed to have some extra
headers for the definitions they require.

Unfortunately I don't have the means to cross-build all the
architectures, but I did an cross builds of i386, x86-64, sparc64 and
powerpc and fixed up what I found.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Linux Arch <linux-arch@vger.kernel.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ian Molton <spyro@f2s.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Aubrey Li <aubrey.li@analog.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Andi Kleen <ak@suse.de>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Miles Bader <uclinux-v850@lsi.nec.co.jp>
Cc: Chris Zankel <chris@zankel.net>

---
 arch/frv/kernel/process.c                    |    2 
 arch/i386/kernel/smpcommon.c                 |    1 
 arch/i386/kernel/vmi.c                       |    1 
 arch/powerpc/boot/elf.h                      |  145 ---------
 arch/powerpc/kernel/prom_init.c              |    1 
 arch/powerpc/platforms/cell/io-workarounds.c |    1 
 arch/powerpc/platforms/cell/spufs/context.c  |    1 
 arch/powerpc/platforms/pseries/eeh.c         |    1 
 arch/powerpc/platforms/pseries/eeh_event.c   |    1 
 arch/powerpc/platforms/pseries/hotplug-cpu.c |    1 
 arch/powerpc/platforms/pseries/iommu.c       |    1 
 drivers/ps3/sys-manager.c                    |    1 
 include/asm-alpha/elf-defines.h              |    1 
 include/asm-alpha/elf.h                      |    2 
 include/asm-alpha/module.h                   |    8 
 include/asm-arm/elf-defines.h                |    1 
 include/asm-arm/elf.h                        |    2 
 include/asm-arm/module.h                     |    4 
 include/asm-arm26/elf-defines.h              |    1 
 include/asm-arm26/elf.h                      |    2 
 include/asm-avr32/elf-defines.h              |    1 
 include/asm-avr32/elf.h                      |    2 
 include/asm-avr32/module.h                   |    4 
 include/asm-blackfin/elf-defines.h           |    1 
 include/asm-blackfin/elf.h                   |    2 
 include/asm-blackfin/module.h                |    5 
 include/asm-cris/elf-defines.h               |    1 
 include/asm-cris/elf.h                       |    2 
 include/asm-cris/module.h                    |    4 
 include/asm-frv/elf-defines.h                |    1 
 include/asm-frv/elf.h                        |    2 
 include/asm-frv/module.h                     |    4 
 include/asm-generic/Kbuild                   |    2 
 include/asm-generic/Kbuild.asm               |    1 
 include/asm-generic/elf32-defines.h          |   21 +
 include/asm-generic/elf64-defines.h          |   21 +
 include/asm-h8300/elf-defines.h              |    1 
 include/asm-h8300/elf.h                      |    2 
 include/asm-h8300/module.h                   |    5 
 include/asm-i386/elf-defines.h               |   24 +
 include/asm-i386/elf.h                       |   22 -
 include/asm-i386/module.h                    |    4 
 include/asm-ia64/elf-defines.h               |    1 
 include/asm-ia64/elf.h                       |    2 
 include/asm-ia64/module.h                    |    4 
 include/asm-m32r/elf-defines.h               |    1 
 include/asm-m32r/elf.h                       |    2 
 include/asm-m32r/module.h                    |    4 
 include/asm-m68k/elf-defines.h               |    1 
 include/asm-m68k/elf.h                       |    2 
 include/asm-m68k/module.h                    |    5 
 include/asm-m68knommu/elf-defines.h          |    1 
 include/asm-m68knommu/elf.h                  |    2 
 include/asm-mips/elf-defines.h               |    6 
 include/asm-mips/elf.h                       |   15 
 include/asm-mips/module.h                    |   11 
 include/asm-parisc/elf-defines.h             |    5 
 include/asm-parisc/elf.h                     |    6 
 include/asm-parisc/module.h                  |   14 
 include/asm-powerpc/elf-defines.h            |   32 ++
 include/asm-powerpc/elf.h                    |   23 -
 include/asm-powerpc/module.h                 |    7 
 include/asm-s390/elf-defines.h               |    5 
 include/asm-s390/elf.h                       |    6 
 include/asm-s390/module.h                    |    6 
 include/asm-sh/elf-defines.h                 |    1 
 include/asm-sh/elf.h                         |    2 
 include/asm-sh/module.h                      |    4 
 include/asm-sh64/elf-defines.h               |    1 
 include/asm-sh64/elf.h                       |    2 
 include/asm-sh64/module.h                    |    4 
 include/asm-sparc/elf-defines.h              |    1 
 include/asm-sparc/elf.h                      |    2 
 include/asm-sparc/module.h                   |    4 
 include/asm-sparc64/elf-defines.h            |    1 
 include/asm-sparc64/elf.h                    |    2 
 include/asm-sparc64/module.h                 |    4 
 include/asm-v850/elf-defines.h               |    1 
 include/asm-v850/elf.h                       |    2 
 include/asm-v850/module.h                    |    4 
 include/asm-x86_64/elf-defines.h             |    1 
 include/asm-x86_64/elf.h                     |    2 
 include/asm-x86_64/module.h                  |    4 
 include/asm-xtensa/elf-defines.h             |    1 
 include/asm-xtensa/elf.h                     |    2 
 include/asm-xtensa/module.h                  |    4 
 include/linux/Kbuild                         |    4 
 include/linux/audit.h                        |    2 
 include/linux/elf-const.h                    |  222 ++++++++++++++
 include/linux/elf-decl.h                     |   48 +++
 include/linux/elf-defn.h                     |  174 +++++++++++
 include/linux/elf-em.h                       |   51 ---
 include/linux/elf.h                          |  399 +-------------------------
 include/linux/elfnote.h                      |   30 +
 include/linux/module.h                       |    1 
 kernel/sysctl.c                              |    1 
 lib/bug.c                                    |    1 
 97 files changed, 692 insertions(+), 761 deletions(-)

===================================================================
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -309,7 +309,7 @@ unsigned long thread_saved_pc(struct tas
 		return tsk->thread.pc;
 }
 
-int elf_check_arch(const struct elf32_hdr *hdr)
+int elf_check_arch(const Elf32_Ehdr *hdr)
 {
 	unsigned long hsr0 = __get_HSR(0);
 	unsigned long psr = __get_PSR();
===================================================================
--- a/arch/i386/kernel/smpcommon.c
+++ b/arch/i386/kernel/smpcommon.c
@@ -3,6 +3,7 @@
  */
 #include <linux/module.h>
 #include <asm/smp.h>
+#include <asm/desc.h>
 
 DEFINE_PER_CPU(unsigned long, this_cpu_off);
 EXPORT_PER_CPU_SYMBOL(this_cpu_off);
===================================================================
--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -37,6 +37,7 @@
 #include <asm/timer.h>
 #include <asm/vmi_time.h>
 #include <asm/kmap_types.h>
+#include <asm/desc.h>
 
 /* Convenient for calling VMI functions indirectly in the ROM */
 typedef u32 __attribute__((regparm(1))) (VROMFUNC)(void);
===================================================================
--- a/arch/powerpc/boot/elf.h
+++ b/arch/powerpc/boot/elf.h
@@ -1,150 +1,7 @@
 #ifndef _PPC_BOOT_ELF_H_
 #define _PPC_BOOT_ELF_H_
 
-/* 32-bit ELF base types. */
-typedef unsigned int Elf32_Addr;
-typedef unsigned short Elf32_Half;
-typedef unsigned int Elf32_Off;
-typedef signed int Elf32_Sword;
-typedef unsigned int Elf32_Word;
-
-/* 64-bit ELF base types. */
-typedef unsigned long long Elf64_Addr;
-typedef unsigned short Elf64_Half;
-typedef signed short Elf64_SHalf;
-typedef unsigned long long Elf64_Off;
-typedef signed int Elf64_Sword;
-typedef unsigned int Elf64_Word;
-typedef unsigned long long Elf64_Xword;
-typedef signed long long Elf64_Sxword;
-
-/* These constants are for the segment types stored in the image headers */
-#define PT_NULL    0
-#define PT_LOAD    1
-#define PT_DYNAMIC 2
-#define PT_INTERP  3
-#define PT_NOTE    4
-#define PT_SHLIB   5
-#define PT_PHDR    6
-#define PT_TLS     7		/* Thread local storage segment */
-#define PT_LOOS    0x60000000	/* OS-specific */
-#define PT_HIOS    0x6fffffff	/* OS-specific */
-#define PT_LOPROC  0x70000000
-#define PT_HIPROC  0x7fffffff
-#define PT_GNU_EH_FRAME		0x6474e550
-
-#define PT_GNU_STACK	(PT_LOOS + 0x474e551)
-
-/* These constants define the different elf file types */
-#define ET_NONE   0
-#define ET_REL    1
-#define ET_EXEC   2
-#define ET_DYN    3
-#define ET_CORE   4
-#define ET_LOPROC 0xff00
-#define ET_HIPROC 0xffff
-
-/* These constants define the various ELF target machines */
-#define EM_NONE  0
-#define EM_PPC	       20	/* PowerPC */
-#define EM_PPC64       21	/* PowerPC64 */
-
-#define EI_NIDENT	16
-
-typedef struct elf32_hdr {
-	unsigned char e_ident[EI_NIDENT];
-	Elf32_Half e_type;
-	Elf32_Half e_machine;
-	Elf32_Word e_version;
-	Elf32_Addr e_entry;	/* Entry point */
-	Elf32_Off e_phoff;
-	Elf32_Off e_shoff;
-	Elf32_Word e_flags;
-	Elf32_Half e_ehsize;
-	Elf32_Half e_phentsize;
-	Elf32_Half e_phnum;
-	Elf32_Half e_shentsize;
-	Elf32_Half e_shnum;
-	Elf32_Half e_shstrndx;
-} Elf32_Ehdr;
-
-typedef struct elf64_hdr {
-	unsigned char e_ident[16];	/* ELF "magic number" */
-	Elf64_Half e_type;
-	Elf64_Half e_machine;
-	Elf64_Word e_version;
-	Elf64_Addr e_entry;	/* Entry point virtual address */
-	Elf64_Off e_phoff;	/* Program header table file offset */
-	Elf64_Off e_shoff;	/* Section header table file offset */
-	Elf64_Word e_flags;
-	Elf64_Half e_ehsize;
-	Elf64_Half e_phentsize;
-	Elf64_Half e_phnum;
-	Elf64_Half e_shentsize;
-	Elf64_Half e_shnum;
-	Elf64_Half e_shstrndx;
-} Elf64_Ehdr;
-
-/* These constants define the permissions on sections in the program
-   header, p_flags. */
-#define PF_R		0x4
-#define PF_W		0x2
-#define PF_X		0x1
-
-typedef struct elf32_phdr {
-	Elf32_Word p_type;
-	Elf32_Off p_offset;
-	Elf32_Addr p_vaddr;
-	Elf32_Addr p_paddr;
-	Elf32_Word p_filesz;
-	Elf32_Word p_memsz;
-	Elf32_Word p_flags;
-	Elf32_Word p_align;
-} Elf32_Phdr;
-
-typedef struct elf64_phdr {
-	Elf64_Word p_type;
-	Elf64_Word p_flags;
-	Elf64_Off p_offset;	/* Segment file offset */
-	Elf64_Addr p_vaddr;	/* Segment virtual address */
-	Elf64_Addr p_paddr;	/* Segment physical address */
-	Elf64_Xword p_filesz;	/* Segment size in file */
-	Elf64_Xword p_memsz;	/* Segment size in memory */
-	Elf64_Xword p_align;	/* Segment alignment, file & memory */
-} Elf64_Phdr;
-
-#define	EI_MAG0		0	/* e_ident[] indexes */
-#define	EI_MAG1		1
-#define	EI_MAG2		2
-#define	EI_MAG3		3
-#define	EI_CLASS	4
-#define	EI_DATA		5
-#define	EI_VERSION	6
-#define	EI_OSABI	7
-#define	EI_PAD		8
-
-#define	ELFMAG0		0x7f	/* EI_MAG */
-#define	ELFMAG1		'E'
-#define	ELFMAG2		'L'
-#define	ELFMAG3		'F'
-#define	ELFMAG		"\177ELF"
-#define	SELFMAG		4
-
-#define	ELFCLASSNONE	0	/* EI_CLASS */
-#define	ELFCLASS32	1
-#define	ELFCLASS64	2
-#define	ELFCLASSNUM	3
-
-#define ELFDATANONE	0	/* e_ident[EI_DATA] */
-#define ELFDATA2LSB	1
-#define ELFDATA2MSB	2
-
-#define EV_NONE		0	/* e_version, EI_VERSION */
-#define EV_CURRENT	1
-#define EV_NUM		2
-
-#define ELFOSABI_NONE	0
-#define ELFOSABI_LINUX	3
+#include <linux/elf-defn.h>
 
 struct elf_info {
 	unsigned long loadsize;
===================================================================
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/initrd.h>
 #include <linux/bitops.h>
+#include <linux/elf.h>
 #include <asm/prom.h>
 #include <asm/rtas.h>
 #include <asm/page.h>
===================================================================
--- a/arch/powerpc/platforms/cell/io-workarounds.c
+++ b/arch/powerpc/platforms/cell/io-workarounds.c
@@ -9,6 +9,7 @@
 #undef DEBUG
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
 #include <asm/io.h>
===================================================================
--- a/arch/powerpc/platforms/cell/spufs/context.c
+++ b/arch/powerpc/platforms/cell/spufs/context.c
@@ -23,6 +23,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 #include <asm/spu.h>
 #include <asm/spu_csa.h>
 #include "spufs.h"
===================================================================
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -23,6 +23,7 @@
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/rbtree.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <asm/atomic.h>
===================================================================
--- a/arch/powerpc/platforms/pseries/eeh_event.c
+++ b/arch/powerpc/platforms/pseries/eeh_event.c
@@ -20,6 +20,7 @@
 
 #include <linux/delay.h>
 #include <linux/list.h>
+#include <linux/sched.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/workqueue.h>
===================================================================
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -20,6 +20,7 @@
 
 #include <linux/kernel.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/cpu.h>
 #include <asm/system.h>
 #include <asm/prom.h>
===================================================================
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/pci.h>
===================================================================
--- a/drivers/ps3/sys-manager.c
+++ b/drivers/ps3/sys-manager.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/workqueue.h>
+#include <linux/sched.h>
 #include <linux/reboot.h>
 
 #include <asm/firmware.h>
===================================================================
--- /dev/null
+++ b/include/asm-alpha/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf64-defines.h>
===================================================================
--- a/include/asm-alpha/elf.h
+++ b/include/asm-alpha/elf.h
@@ -77,7 +77,7 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_N
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS64
+#include <asm/elf-defines.h>
 #define ELF_DATA	ELFDATA2LSB
 #define ELF_ARCH	EM_ALPHA
 
===================================================================
--- a/include/asm-alpha/module.h
+++ b/include/asm-alpha/module.h
@@ -6,13 +6,7 @@ struct mod_arch_specific
 	unsigned int gotsecindex;
 };
 
-#define Elf_Sym Elf64_Sym
-#define Elf_Shdr Elf64_Shdr
-#define Elf_Ehdr Elf64_Ehdr
-#define Elf_Phdr Elf64_Phdr
-#define Elf_Dyn Elf64_Dyn
-#define Elf_Rel Elf64_Rel
-#define Elf_Rela Elf64_Rela
+#include <asm/elf-defines.h>
 
 #define ARCH_SHF_SMALL SHF_ALPHA_GPREL
 
===================================================================
--- /dev/null
+++ b/include/asm-arm/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-arm/elf.h
+++ b/include/asm-arm/elf.h
@@ -31,7 +31,7 @@ typedef struct user_fp elf_fpregset_t;
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #ifdef __ARMEB__
 #define ELF_DATA	ELFDATA2MSB
 #else
===================================================================
--- a/include/asm-arm/module.h
+++ b/include/asm-arm/module.h
@@ -6,9 +6,7 @@ struct mod_arch_specific
 	int foo;
 };
 
-#define Elf_Shdr	Elf32_Shdr
-#define Elf_Sym		Elf32_Sym
-#define Elf_Ehdr	Elf32_Ehdr
+#include <asm/elf-defines.h>
 
 /*
  * Include the ARM architecture version.
===================================================================
--- /dev/null
+++ b/include/asm-arm26/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-arm26/elf.h
+++ b/include/asm-arm26/elf.h
@@ -35,7 +35,7 @@ typedef struct { void *null; } elf_fpreg
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #define ELF_DATA	ELFDATA2LSB
 #define ELF_ARCH	EM_ARM
 
===================================================================
--- /dev/null
+++ b/include/asm-avr32/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-avr32/elf.h
+++ b/include/asm-avr32/elf.h
@@ -69,7 +69,7 @@ typedef struct user_fpu_struct elf_fpreg
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #ifdef __LITTLE_ENDIAN__
 #define ELF_DATA	ELFDATA2LSB
 #else
===================================================================
--- a/include/asm-avr32/module.h
+++ b/include/asm-avr32/module.h
@@ -17,9 +17,7 @@ struct mod_arch_specific {
 	struct mod_arch_syminfo *syminfo;
 };
 
-#define Elf_Shdr		Elf32_Shdr
-#define Elf_Sym			Elf32_Sym
-#define Elf_Ehdr		Elf32_Ehdr
+#include <asm/elf-defines.h>
 
 #define MODULE_PROC_FAMILY "AVR32v1"
 
===================================================================
--- /dev/null
+++ b/include/asm-blackfin/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-blackfin/elf.h
+++ b/include/asm-blackfin/elf.h
@@ -35,7 +35,7 @@ typedef struct user_bfinfp_struct elf_fp
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #define ELF_DATA	ELFDATA2LSB
 #define ELF_ARCH	EM_BLACKFIN
 
===================================================================
--- a/include/asm-blackfin/module.h
+++ b/include/asm-blackfin/module.h
@@ -3,9 +3,8 @@
 
 #define MODULE_SYMBOL_PREFIX "_"
 
-#define Elf_Shdr        Elf32_Shdr
-#define Elf_Sym         Elf32_Sym
-#define Elf_Ehdr        Elf32_Ehdr
+#include <asm/elf-defines.h>
+
 #define FLG_CODE_IN_L1	0x10
 #define FLG_DATA_IN_L1	0x20
 
===================================================================
--- /dev/null
+++ b/include/asm-cris/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-cris/elf.h
+++ b/include/asm-cris/elf.h
@@ -41,7 +41,7 @@ typedef unsigned long elf_fpregset_t;
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #define ELF_DATA	ELFDATA2LSB
 #define ELF_ARCH	EM_CRIS
 
===================================================================
--- a/include/asm-cris/module.h
+++ b/include/asm-cris/module.h
@@ -3,7 +3,5 @@
 /* cris is simple */
 struct mod_arch_specific { };
 
-#define Elf_Shdr Elf32_Shdr
-#define Elf_Sym Elf32_Sym
-#define Elf_Ehdr Elf32_Ehdr
+#include <asm/elf-defines.h>
 #endif /* _ASM_CRIS_MODULE_H */
===================================================================
--- /dev/null
+++ b/include/asm-frv/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-frv/elf.h
+++ b/include/asm-frv/elf.h
@@ -77,7 +77,7 @@ extern int elf_check_arch(const struct e
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #define ELF_DATA	ELFDATA2MSB
 #define ELF_ARCH	EM_FRV
 
===================================================================
--- a/include/asm-frv/module.h
+++ b/include/asm-frv/module.h
@@ -15,9 +15,7 @@ struct mod_arch_specific
 {
 };
 
-#define Elf_Shdr	Elf32_Shdr
-#define Elf_Sym		Elf32_Sym
-#define Elf_Ehdr	Elf32_Ehdr
+#include <asm/elf-defines.h>
 
 /*
  * Include the architecture version.
===================================================================
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -1,3 +1,5 @@ header-y += errno-base.h
+header-y += elf32-defines.h
+header-y += elf64-defines.h
 header-y += errno-base.h
 header-y += errno.h
 header-y += fcntl.h
===================================================================
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -1,6 +1,7 @@ unifdef-y += a.out.h
 unifdef-y += a.out.h
 unifdef-y += auxvec.h
 unifdef-y += byteorder.h
+unifdef-y += elf-defines.h
 unifdef-y += errno.h
 unifdef-y += fcntl.h
 unifdef-y += ioctl.h
===================================================================
--- /dev/null
+++ b/include/asm-generic/elf32-defines.h
@@ -0,0 +1,21 @@
+#ifndef __ASM_GENERIC_ELF32_DEFINES_H
+#define __ASM_GENERIC_ELF32_DEFINES_H
+
+#include <linux/elf-decl.h>
+#include <linux/elf-const.h>
+
+#ifndef ELF_CLASS
+#define ELF_CLASS	ELFCLASS32
+#endif
+
+typedef Elf32_Ehdr	Elf_Ehdr;
+typedef Elf32_Phdr	Elf_Phdr;
+typedef Elf32_Shdr	Elf_Shdr;
+typedef Elf32_Sym	Elf_Sym;
+typedef Elf32_Dyn	Elf_Dyn;
+typedef Elf32_Rel	Elf_Rel;
+typedef Elf32_Rela	Elf_Rela;
+
+typedef Elf32_Addr	Elf_Addr;
+
+#endif /* __ASM_GENERIC_ELF32_DEFINES_H */
===================================================================
--- /dev/null
+++ b/include/asm-generic/elf64-defines.h
@@ -0,0 +1,21 @@
+#ifndef __ASM_GENERIC_ELF64_DEFINES_H
+#define __ASM_GENERIC_ELF64_DEFINES_H
+
+#include <linux/elf-decl.h>
+#include <linux/elf-const.h>
+
+#ifndef ELF_CLASS
+#define ELF_CLASS	ELFCLASS64
+#endif
+
+typedef Elf64_Ehdr	Elf_Ehdr;
+typedef Elf64_Phdr	Elf_Phdr;
+typedef Elf64_Shdr	Elf_Shdr;
+typedef Elf64_Sym	Elf_Sym;
+typedef Elf64_Dyn	Elf_Dyn;
+typedef Elf64_Rel	Elf_Rel;
+typedef Elf64_Rela	Elf_Rela;
+
+typedef Elf64_Addr	Elf_Addr;
+
+#endif /* __ASM_GENERIC_ELF64_DEFINES_H */
===================================================================
--- /dev/null
+++ b/include/asm-h8300/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-h8300/elf.h
+++ b/include/asm-h8300/elf.h
@@ -22,7 +22,7 @@ typedef unsigned long elf_fpregset_t;
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #define ELF_DATA	ELFDATA2MSB
 #define ELF_ARCH	EM_H8_300
 #if defined(__H8300H__)
===================================================================
--- a/include/asm-h8300/module.h
+++ b/include/asm-h8300/module.h
@@ -4,9 +4,8 @@
  * This file contains the H8/300 architecture specific module code.
  */
 struct mod_arch_specific { };
-#define Elf_Shdr Elf32_Shdr
-#define Elf_Sym Elf32_Sym
-#define Elf_Ehdr Elf32_Ehdr
+
+#include <asm/elf-defines.h>
 
 #define MODULE_SYMBOL_PREFIX "_"
 
===================================================================
--- /dev/null
+++ b/include/asm-i386/elf-defines.h
@@ -0,0 +1,24 @@
+#ifndef __ASM_I386_ELF_DEFINES_H
+#define __ASM_I386_ELF_DEFINES_H
+
+#define R_386_NONE	0
+#define R_386_32	1
+#define R_386_PC32	2
+#define R_386_GOT32	3
+#define R_386_PLT32	4
+#define R_386_COPY	5
+#define R_386_GLOB_DAT	6
+#define R_386_JMP_SLOT	7
+#define R_386_RELATIVE	8
+#define R_386_GOTOFF	9
+#define R_386_GOTPC	10
+#define R_386_NUM	11
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#include <asm-generic/elf32-defines.h>
+#define ELF_DATA	ELFDATA2LSB
+#define ELF_ARCH	EM_386
+
+#endif /* __ASM_I386_ELF_DEFINES_H */
===================================================================
--- a/include/asm-i386/elf.h
+++ b/include/asm-i386/elf.h
@@ -5,22 +5,9 @@
  * ELF register definitions..
  */
 
-#include <asm/ptrace.h>
 #include <asm/user.h>
 #include <asm/auxvec.h>
-
-#define R_386_NONE	0
-#define R_386_32	1
-#define R_386_PC32	2
-#define R_386_GOT32	3
-#define R_386_PLT32	4
-#define R_386_COPY	5
-#define R_386_GLOB_DAT	6
-#define R_386_JMP_SLOT	7
-#define R_386_RELATIVE	8
-#define R_386_GOTOFF	9
-#define R_386_GOTPC	10
-#define R_386_NUM	11
+#include <asm/elf-defines.h>
 
 typedef unsigned long elf_greg_t;
 
@@ -35,13 +22,6 @@ typedef struct user_fxsr_struct elf_fpxr
  */
 #define elf_check_arch(x) \
 	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
-
-/*
- * These are used to set parameters in the core dumps.
- */
-#define ELF_CLASS	ELFCLASS32
-#define ELF_DATA	ELFDATA2LSB
-#define ELF_ARCH	EM_386
 
 #ifdef __KERNEL__
 
===================================================================
--- a/include/asm-i386/module.h
+++ b/include/asm-i386/module.h
@@ -6,9 +6,7 @@ struct mod_arch_specific
 {
 };
 
-#define Elf_Shdr Elf32_Shdr
-#define Elf_Sym Elf32_Sym
-#define Elf_Ehdr Elf32_Ehdr
+#include <asm/elf-defines.h>
 
 #ifdef CONFIG_M386
 #define MODULE_PROC_FAMILY "386 "
===================================================================
--- /dev/null
+++ b/include/asm-ia64/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf64-defines.h>
===================================================================
--- a/include/asm-ia64/elf.h
+++ b/include/asm-ia64/elf.h
@@ -21,7 +21,7 @@
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS64
+#include <asm/elf-defines.h>
 #define ELF_DATA	ELFDATA2LSB
 #define ELF_ARCH	EM_IA_64
 
===================================================================
--- a/include/asm-ia64/module.h
+++ b/include/asm-ia64/module.h
@@ -23,9 +23,7 @@ struct mod_arch_specific {
 	unsigned int next_got_entry;	/* index of next available got entry */
 };
 
-#define Elf_Shdr	Elf64_Shdr
-#define Elf_Sym		Elf64_Sym
-#define Elf_Ehdr	Elf64_Ehdr
+#include <asm/elf-defines.h>
 
 #define MODULE_PROC_FAMILY	"ia64"
 #define MODULE_ARCH_VERMAGIC	MODULE_PROC_FAMILY \
===================================================================
--- /dev/null
+++ b/include/asm-m32r/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-m32r/elf.h
+++ b/include/asm-m32r/elf.h
@@ -81,7 +81,7 @@ typedef elf_fpreg_t elf_fpregset_t;
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #if defined(__LITTLE_ENDIAN)
 #define ELF_DATA	ELFDATA2LSB
 #elif defined(__BIG_ENDIAN)
===================================================================
--- a/include/asm-m32r/module.h
+++ b/include/asm-m32r/module.h
@@ -3,8 +3,6 @@
 
 struct mod_arch_specific { };
 
-#define Elf_Shdr	Elf32_Shdr
-#define Elf_Sym		Elf32_Sym
-#define Elf_Ehdr	Elf32_Ehdr
+#include <asm/elf-defines.h>
 
 #endif /* _ASM_M32R_MODULE_H */
===================================================================
--- /dev/null
+++ b/include/asm-m68k/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-m68k/elf.h
+++ b/include/asm-m68k/elf.h
@@ -50,7 +50,7 @@ typedef struct user_m68kfp_struct elf_fp
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #define ELF_DATA	ELFDATA2MSB
 #define ELF_ARCH	EM_68K
 
===================================================================
--- a/include/asm-m68k/module.h
+++ b/include/asm-m68k/module.h
@@ -10,10 +10,7 @@ struct mod_arch_specific {
 	.fixup_end		= __stop_fixup,		\
 }
 
-#define Elf_Shdr Elf32_Shdr
-#define Elf_Sym Elf32_Sym
-#define Elf_Ehdr Elf32_Ehdr
-
+#include <asm/elf-defines.h>
 
 enum m68k_fixup_type {
 	m68k_fixup_memoffset,
===================================================================
--- /dev/null
+++ b/include/asm-m68knommu/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-m68knommu/elf.h
+++ b/include/asm-m68knommu/elf.h
@@ -50,7 +50,7 @@ typedef struct user_m68kfp_struct elf_fp
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #define ELF_DATA	ELFDATA2MSB
 #define ELF_ARCH	EM_68K
 
===================================================================
--- /dev/null
+++ b/include/asm-mips/elf-defines.h
@@ -0,0 +1,6 @@
+#ifdef CONFIG_64BIT
+#include <asm-generic/elf64-defines.h>
+#endif
+#ifdef CONFIG_32BIT
+#include <asm-generic/elf32-defines.h>
+#endif
===================================================================
--- a/include/asm-mips/elf.h
+++ b/include/asm-mips/elf.h
@@ -173,6 +173,11 @@ typedef double elf_fpreg_t;
 typedef double elf_fpreg_t;
 typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
 
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#include <asm/elf-defines.h>
+
 #ifdef CONFIG_32BIT
 
 /*
@@ -196,11 +201,6 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_N
 	__res;								\
 })
 
-/*
- * These are used to set parameters in the core dumps.
- */
-#define ELF_CLASS	ELFCLASS32
-
 #endif /* CONFIG_32BIT */
 
 #ifdef CONFIG_64BIT
@@ -219,11 +219,6 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_N
 									\
 	__res;								\
 })
-
-/*
- * These are used to set parameters in the core dumps.
- */
-#define ELF_CLASS	ELFCLASS64
 
 #endif /* CONFIG_64BIT */
 
===================================================================
--- a/include/asm-mips/module.h
+++ b/include/asm-mips/module.h
@@ -3,6 +3,7 @@
 
 #include <linux/list.h>
 #include <asm/uaccess.h>
+#include <asm/elf-defines.h>
 
 struct mod_arch_specific {
 	/* Data Bus Error exception tables */
@@ -34,11 +35,6 @@ typedef struct {
 
 #ifdef CONFIG_32BIT
 
-#define Elf_Shdr	Elf32_Shdr
-#define Elf_Sym		Elf32_Sym
-#define Elf_Ehdr	Elf32_Ehdr
-#define Elf_Addr	Elf32_Addr
-
 #define Elf_Mips_Rel	Elf32_Rel
 #define Elf_Mips_Rela	Elf32_Rela
 
@@ -48,11 +44,6 @@ typedef struct {
 #endif
 
 #ifdef CONFIG_64BIT
-
-#define Elf_Shdr	Elf64_Shdr
-#define Elf_Sym		Elf64_Sym
-#define Elf_Ehdr	Elf64_Ehdr
-#define Elf_Addr	Elf64_Addr
 
 #define Elf_Mips_Rel	Elf64_Mips_Rel
 #define Elf_Mips_Rela	Elf64_Mips_Rela
===================================================================
--- /dev/null
+++ b/include/asm-parisc/elf-defines.h
@@ -0,0 +1,5 @@
+#ifdef CONFIG_64BIT
+#include <asm-generic/elf64-defines.h>
+#else
+#include <asm-generic/elf32-defines.h>
+#endif
===================================================================
--- a/include/asm-parisc/elf.h
+++ b/include/asm-parisc/elf.h
@@ -220,11 +220,7 @@ typedef struct elf64_fdesc {
  * macros, and then it includes fs/binfmt_elf.c to provide an alternate
  * elf binary handler for 32 bit binaries (on the 64 bit kernel).
  */
-#ifdef CONFIG_64BIT
-#define ELF_CLASS       ELFCLASS64
-#else
-#define ELF_CLASS	ELFCLASS32
-#endif
+#include <asm/elf-defines.h>
 
 typedef unsigned long elf_greg_t;
 
===================================================================
--- a/include/asm-parisc/module.h
+++ b/include/asm-parisc/module.h
@@ -3,19 +3,7 @@
 /*
  * This file contains the parisc architecture specific module code.
  */
-#ifdef CONFIG_64BIT
-#define Elf_Shdr Elf64_Shdr
-#define Elf_Sym Elf64_Sym
-#define Elf_Ehdr Elf64_Ehdr
-#define Elf_Addr Elf64_Addr
-#define Elf_Rela Elf64_Rela
-#else
-#define Elf_Shdr Elf32_Shdr
-#define Elf_Sym Elf32_Sym
-#define Elf_Ehdr Elf32_Ehdr
-#define Elf_Addr Elf32_Addr
-#define Elf_Rela Elf32_Rela
-#endif
+#include <asm/elf-defines.h>
 
 struct unwind_table;
 
===================================================================
--- /dev/null
+++ b/include/asm-powerpc/elf-defines.h
@@ -0,0 +1,32 @@
+#ifndef _ASM_POWERPC_ELF_DEFINES_H
+#define _ASM_POWERPC_ELF_DEFINES_H
+
+#include <linux/elf-const.h>
+
+/*
+ * ELF_ARCH, CLASS, and DATA are used to set parameters in the core dumps.
+ */
+#ifdef __powerpc64__
+# define ELF_NVRREG32	33	/* includes vscr & vrsave stuffed together */
+# define ELF_NVRREG	34	/* includes vscr & vrsave in split vectors */
+# define ELF_GREG_TYPE	elf_greg_t64
+#else
+# define ELF_NEVRREG	34	/* includes acc (as 2) */
+# define ELF_NVRREG	33	/* includes vscr */
+# define ELF_GREG_TYPE	elf_greg_t32
+# define ELF_ARCH	EM_PPC
+# define ELF_CLASS	ELFCLASS32
+# define ELF_DATA	ELFDATA2MSB
+#endif /* __powerpc64__ */
+
+#ifndef ELF_ARCH
+# include <asm-generic/elf64-defines.h>
+# define ELF_ARCH	EM_PPC64
+# define ELF_CLASS	ELFCLASS64
+# define ELF_DATA	ELFDATA2MSB
+#else
+  /* Assumption: ELF_ARCH == EM_PPC and ELF_CLASS == ELFCLASS32 */
+# include <asm-generic/elf32-defines.h>
+#endif
+
+#endif	/* _ASM_POWERPC_ELF_DEFINES_H */
===================================================================
--- a/include/asm-powerpc/elf.h
+++ b/include/asm-powerpc/elf.h
@@ -102,26 +102,9 @@ typedef unsigned int elf_greg_t32;
 typedef unsigned int elf_greg_t32;
 typedef elf_greg_t32 elf_gregset_t32[ELF_NGREG];
 
-/*
- * ELF_ARCH, CLASS, and DATA are used to set parameters in the core dumps.
- */
-#ifdef __powerpc64__
-# define ELF_NVRREG32	33	/* includes vscr & vrsave stuffed together */
-# define ELF_NVRREG	34	/* includes vscr & vrsave in split vectors */
-# define ELF_GREG_TYPE	elf_greg_t64
-#else
-# define ELF_NEVRREG	34	/* includes acc (as 2) */
-# define ELF_NVRREG	33	/* includes vscr */
-# define ELF_GREG_TYPE	elf_greg_t32
-# define ELF_ARCH	EM_PPC
-# define ELF_CLASS	ELFCLASS32
-# define ELF_DATA	ELFDATA2MSB
-#endif /* __powerpc64__ */
-
-#ifndef ELF_ARCH
-# define ELF_ARCH	EM_PPC64
-# define ELF_CLASS	ELFCLASS64
-# define ELF_DATA	ELFDATA2MSB
+#include <asm/elf-defines.h>
+
+#if ELF_ARCH == EM_PPC64
   typedef elf_greg_t64 elf_greg_t;
   typedef elf_gregset_t64 elf_gregset_t;
 #else
===================================================================
--- a/include/asm-powerpc/module.h
+++ b/include/asm-powerpc/module.h
@@ -50,18 +50,13 @@ struct mod_arch_specific {
  * Select ELF headers.
  * Make empty section for module_frob_arch_sections to expand.
  */
+#include <asm/elf-defines.h>
 
 #ifdef __powerpc64__
-#    define Elf_Shdr	Elf64_Shdr
-#    define Elf_Sym	Elf64_Sym
-#    define Elf_Ehdr	Elf64_Ehdr
 #    ifdef MODULE
 	asm(".section .stubs,\"ax\",@nobits; .align 3; .previous");
 #    endif
 #else
-#    define Elf_Shdr	Elf32_Shdr
-#    define Elf_Sym	Elf32_Sym
-#    define Elf_Ehdr	Elf32_Ehdr
 #    ifdef MODULE
 	asm(".section .plt,\"ax\",@nobits; .align 3; .previous");
 	asm(".section .init.plt,\"ax\",@nobits; .align 3; .previous");
===================================================================
--- /dev/null
+++ b/include/asm-s390/elf-defines.h
@@ -0,0 +1,5 @@
+#ifndef __s390x__
+#include <asm-generic/elf32-defines.h>
+#else
+#include <asm-generic/elf64-defines.h>
+#endif
===================================================================
--- a/include/asm-s390/elf.h
+++ b/include/asm-s390/elf.h
@@ -95,11 +95,7 @@
 /*
  * These are used to set parameters in the core dumps.
  */
-#ifndef __s390x__
-#define ELF_CLASS	ELFCLASS32
-#else /* __s390x__ */
-#define ELF_CLASS	ELFCLASS64
-#endif /* __s390x__ */
+#include <asm/elf-defines.h>
 #define ELF_DATA	ELFDATA2MSB
 #define ELF_ARCH	EM_S390
 
===================================================================
--- a/include/asm-s390/module.h
+++ b/include/asm-s390/module.h
@@ -28,6 +28,7 @@ struct mod_arch_specific
 	struct mod_arch_syminfo *syminfo;
 };
 
+#include <asm/elf-defines.h>
 #ifdef __s390x__
 #define ElfW(x) Elf64_ ## x
 #define ELFW(x) ELF64_ ## x
@@ -36,11 +37,6 @@ struct mod_arch_specific
 #define ELFW(x) ELF32_ ## x
 #endif
 
-#define Elf_Addr ElfW(Addr)
-#define Elf_Rela ElfW(Rela)
-#define Elf_Shdr ElfW(Shdr)
-#define Elf_Sym ElfW(Sym)
-#define Elf_Ehdr ElfW(Ehdr)
 #define ELF_R_SYM ELFW(R_SYM)
 #define ELF_R_TYPE ELFW(R_TYPE)
 #endif /* _ASM_S390_MODULE_H */
===================================================================
--- /dev/null
+++ b/include/asm-sh/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-sh/elf.h
+++ b/include/asm-sh/elf.h
@@ -65,7 +65,7 @@ typedef struct user_fpu_struct elf_fpreg
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #ifdef __LITTLE_ENDIAN__
 #define ELF_DATA	ELFDATA2LSB
 #else
===================================================================
--- a/include/asm-sh/module.h
+++ b/include/asm-sh/module.h
@@ -9,9 +9,7 @@ struct mod_arch_specific {
 	/* Nothing to see here .. */
 };
 
-#define Elf_Shdr		Elf32_Shdr
-#define Elf_Sym			Elf32_Sym
-#define Elf_Ehdr		Elf32_Ehdr
+#include <asm/elf-defines.h>
 
 #ifdef CONFIG_CPU_LITTLE_ENDIAN
 # ifdef CONFIG_CPU_SH2
===================================================================
--- /dev/null
+++ b/include/asm-sh64/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-sh64/elf.h
+++ b/include/asm-sh64/elf.h
@@ -35,7 +35,7 @@ typedef struct user_fpu_struct elf_fpreg
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #ifdef __LITTLE_ENDIAN__
 #define ELF_DATA	ELFDATA2LSB
 #else
===================================================================
--- a/include/asm-sh64/module.h
+++ b/include/asm-sh64/module.h
@@ -8,9 +8,7 @@ struct mod_arch_specific {
 	/* empty */
 };
 
-#define Elf_Shdr		Elf32_Shdr
-#define Elf_Sym			Elf32_Sym
-#define Elf_Ehdr		Elf32_Ehdr
+#include <asm/elf-defines.h>
 
 #define module_map(x)		vmalloc(x)
 #define module_unmap(x)		vfree(x)
===================================================================
--- /dev/null
+++ b/include/asm-sparc/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-sparc/elf.h
+++ b/include/asm-sparc/elf.h
@@ -125,7 +125,7 @@ do {	unsigned long *dest = &(__elf_regs[
  * These are used to set parameters in the core dumps.
  */
 #define ELF_ARCH	EM_SPARC
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #define ELF_DATA	ELFDATA2MSB
 
 #define USE_ELF_CORE_DUMP
===================================================================
--- a/include/asm-sparc/module.h
+++ b/include/asm-sparc/module.h
@@ -1,7 +1,5 @@
 #ifndef _ASM_SPARC_MODULE_H
 #define _ASM_SPARC_MODULE_H
 struct mod_arch_specific { };
-#define Elf_Shdr Elf32_Shdr
-#define Elf_Sym Elf32_Sym
-#define Elf_Ehdr Elf32_Ehdr
+#include <asm/elf-defines.h>
 #endif /* _ASM_SPARC_MODULE_H */
===================================================================
--- /dev/null
+++ b/include/asm-sparc64/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf64-defines.h>
===================================================================
--- a/include/asm-sparc64/elf.h
+++ b/include/asm-sparc64/elf.h
@@ -75,8 +75,8 @@
  * These are used to set parameters in the core dumps.
  */
 #ifndef ELF_ARCH
+#include <asm/elf-defines.h>
 #define ELF_ARCH		EM_SPARCV9
-#define ELF_CLASS		ELFCLASS64
 #define ELF_DATA		ELFDATA2MSB
 
 typedef unsigned long elf_greg_t;
===================================================================
--- a/include/asm-sparc64/module.h
+++ b/include/asm-sparc64/module.h
@@ -1,7 +1,5 @@
 #ifndef _ASM_SPARC64_MODULE_H
 #define _ASM_SPARC64_MODULE_H
 struct mod_arch_specific { };
-#define Elf_Shdr Elf64_Shdr
-#define Elf_Sym Elf64_Sym
-#define Elf_Ehdr Elf64_Ehdr
+#include <asm/elf-defines.h>
 #endif /* _ASM_SPARC64_MODULE_H */
===================================================================
--- /dev/null
+++ b/include/asm-v850/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-v850/elf.h
+++ b/include/asm-v850/elf.h
@@ -50,7 +50,7 @@ typedef struct user_fpu_struct elf_fpreg
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #ifdef __LITTLE_ENDIAN__
 #define ELF_DATA	ELFDATA2LSB
 #else
===================================================================
--- a/include/asm-v850/module.h
+++ b/include/asm-v850/module.h
@@ -31,9 +31,7 @@ struct mod_arch_specific
 	unsigned int core_plt_section, init_plt_section;
 };
 
-#define Elf_Shdr Elf32_Shdr
-#define Elf_Sym Elf32_Sym
-#define Elf_Ehdr Elf32_Ehdr
+#include <asm/elf-defines.h>
 
 /* Make empty sections for module_frob_arch_sections to expand. */
 #ifdef MODULE
===================================================================
--- /dev/null
+++ b/include/asm-x86_64/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf64-defines.h>
===================================================================
--- a/include/asm-x86_64/elf.h
+++ b/include/asm-x86_64/elf.h
@@ -39,7 +39,7 @@ typedef struct user_i387_struct elf_fpre
 /*
  * These are used to set parameters in the core dumps.
  */
-#define ELF_CLASS	ELFCLASS64
+#include <asm/elf-defines.h>
 #define ELF_DATA	ELFDATA2LSB
 #define ELF_ARCH	EM_X86_64
 
===================================================================
--- a/include/asm-x86_64/module.h
+++ b/include/asm-x86_64/module.h
@@ -3,8 +3,6 @@
 
 struct mod_arch_specific {}; 
 
-#define Elf_Shdr Elf64_Shdr
-#define Elf_Sym Elf64_Sym
-#define Elf_Ehdr Elf64_Ehdr
+#include <asm/elf-defines.h>
 
 #endif 
===================================================================
--- /dev/null
+++ b/include/asm-xtensa/elf-defines.h
@@ -0,0 +1,1 @@
+#include <asm-generic/elf32-defines.h>
===================================================================
--- a/include/asm-xtensa/elf.h
+++ b/include/asm-xtensa/elf.h
@@ -153,7 +153,7 @@ extern void xtensa_elf_core_copy_regs (x
 # error processor byte order undefined!
 #endif
 
-#define ELF_CLASS	ELFCLASS32
+#include <asm/elf-defines.h>
 #define ELF_ARCH	EM_XTENSA
 
 #define USE_ELF_CORE_DUMP
===================================================================
--- a/include/asm-xtensa/module.h
+++ b/include/asm-xtensa/module.h
@@ -18,8 +18,6 @@ struct mod_arch_specific
 	/* Module support is not completely implemented. */
 };
 
-#define Elf_Shdr Elf32_Shdr
-#define Elf_Sym Elf32_Sym
-#define Elf_Ehdr Elf32_Ehdr
+#include <asm/elf-defines.h>
 
 #endif	/* _XTENSA_MODULE_H */
===================================================================
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -58,7 +58,9 @@ header-y += efs_fs_sb.h
 header-y += efs_fs_sb.h
 header-y += elf-fdpic.h
 header-y += elf.h
-header-y += elf-em.h
+header-y += elf-const.h
+header-y += elf-decl.h
+header-y += elf-defn.h
 header-y += fadvise.h
 header-y += fd.h
 header-y += fdreg.h
===================================================================
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -25,7 +25,7 @@
 #define _LINUX_AUDIT_H_
 
 #include <linux/types.h>
-#include <linux/elf-em.h>
+#include <linux/elf-const.h>
 
 /* The netlink messages for the audit system is divided into blocks:
  * 1000 - 1099 are for commanding the audit system
===================================================================
--- /dev/null
+++ b/include/linux/elf-const.h
@@ -0,0 +1,222 @@
+#ifndef _LINUX_ELF_CONST_H
+#define _LINUX_ELF_CONST_H
+
+/* These constants define the various ELF target machines */
+#define EM_NONE		0
+#define EM_M32		1
+#define EM_SPARC	2
+#define EM_386		3
+#define EM_68K		4
+#define EM_88K		5
+#define EM_486		6	/* Perhaps disused */
+#define EM_860		7
+#define EM_MIPS		8	/* MIPS R3000 (officially, big-endian only) */
+				/* Next two are historical and binaries and
+				   modules of these types will be rejected by
+				   Linux.  */
+#define EM_MIPS_RS3_LE	10	/* MIPS R3000 little-endian */
+#define EM_MIPS_RS4_BE	10	/* MIPS R4000 big-endian */
+
+#define EM_PARISC	15	/* HPPA */
+#define EM_SPARC32PLUS	18	/* Sun's "v8plus" */
+#define EM_PPC		20	/* PowerPC */
+#define EM_PPC64	21       /* PowerPC64 */
+#define EM_SH		42	/* SuperH */
+#define EM_SPARCV9	43	/* SPARC v9 64-bit */
+#define EM_IA_64	50	/* HP/Intel IA-64 */
+#define EM_X86_64	62	/* AMD x86-64 */
+#define EM_S390		22	/* IBM S/390 */
+#define EM_CRIS		76	/* Axis Communications 32-bit embedded processor */
+#define EM_V850		87	/* NEC v850 */
+#define EM_M32R		88	/* Renesas M32R */
+#define EM_H8_300	46	/* Renesas H8/300,300H,H8S */
+#define EM_BLACKFIN     106     /* ADI Blackfin Processor */
+#define EM_FRV		0x5441	/* Fujitsu FR-V */
+#define EM_AVR32	0x18ad	/* Atmel AVR32 */
+
+/*
+ * This is an interim value that we will use until the committee comes
+ * up with a final number.
+ */
+#define EM_ALPHA	0x9026
+
+/* Bogus old v850 magic number, used by old tools. */
+#define EM_CYGNUS_V850	0x9080
+/* Bogus old m32r magic number, used by old tools. */
+#define EM_CYGNUS_M32R	0x9041
+/* This is the old interim value for S/390 architecture */
+#define EM_S390_OLD	0xA390
+
+#define EI_NIDENT	16
+
+/* These constants define the permissions on sections in the program
+   header, p_flags. */
+#define PF_R		0x4
+#define PF_W		0x2
+#define PF_X		0x1
+
+/* These constants are for the segment types stored in the image headers */
+#define PT_NULL    0
+#define PT_LOAD    1
+#define PT_DYNAMIC 2
+#define PT_INTERP  3
+#define PT_NOTE    4
+#define PT_SHLIB   5
+#define PT_PHDR    6
+#define PT_TLS     7               /* Thread local storage segment */
+#define PT_LOOS    0x60000000      /* OS-specific */
+#define PT_HIOS    0x6fffffff      /* OS-specific */
+#define PT_LOPROC  0x70000000
+#define PT_HIPROC  0x7fffffff
+#define PT_GNU_EH_FRAME		0x6474e550
+
+#define PT_GNU_STACK	(PT_LOOS + 0x474e551)
+
+/* These constants define the different elf file types */
+#define ET_NONE   0
+#define ET_REL    1
+#define ET_EXEC   2
+#define ET_DYN    3
+#define ET_CORE   4
+#define ET_LOPROC 0xff00
+#define ET_HIPROC 0xffff
+
+/* This is the info that is needed to parse the dynamic section of the file */
+#define DT_NULL		0
+#define DT_NEEDED	1
+#define DT_PLTRELSZ	2
+#define DT_PLTGOT	3
+#define DT_HASH		4
+#define DT_STRTAB	5
+#define DT_SYMTAB	6
+#define DT_RELA		7
+#define DT_RELASZ	8
+#define DT_RELAENT	9
+#define DT_STRSZ	10
+#define DT_SYMENT	11
+#define DT_INIT		12
+#define DT_FINI		13
+#define DT_SONAME	14
+#define DT_RPATH 	15
+#define DT_SYMBOLIC	16
+#define DT_REL	        17
+#define DT_RELSZ	18
+#define DT_RELENT	19
+#define DT_PLTREL	20
+#define DT_DEBUG	21
+#define DT_TEXTREL	22
+#define DT_JMPREL	23
+#define DT_ENCODING	32
+#define OLD_DT_LOOS	0x60000000
+#define DT_LOOS		0x6000000d
+#define DT_HIOS		0x6ffff000
+#define DT_VALRNGLO	0x6ffffd00
+#define DT_VALRNGHI	0x6ffffdff
+#define DT_ADDRRNGLO	0x6ffffe00
+#define DT_ADDRRNGHI	0x6ffffeff
+#define DT_VERSYM	0x6ffffff0
+#define DT_RELACOUNT	0x6ffffff9
+#define DT_RELCOUNT	0x6ffffffa
+#define DT_FLAGS_1	0x6ffffffb
+#define DT_VERDEF	0x6ffffffc
+#define	DT_VERDEFNUM	0x6ffffffd
+#define DT_VERNEED	0x6ffffffe
+#define	DT_VERNEEDNUM	0x6fffffff
+#define OLD_DT_HIOS     0x6fffffff
+#define DT_LOPROC	0x70000000
+#define DT_HIPROC	0x7fffffff
+
+/* This info is needed when parsing the symbol table */
+#define STB_LOCAL  0
+#define STB_GLOBAL 1
+#define STB_WEAK   2
+
+#define STT_NOTYPE  0
+#define STT_OBJECT  1
+#define STT_FUNC    2
+#define STT_SECTION 3
+#define STT_FILE    4
+#define STT_COMMON  5
+#define STT_TLS     6
+
+/* sh_type */
+#define SHT_NULL	0
+#define SHT_PROGBITS	1
+#define SHT_SYMTAB	2
+#define SHT_STRTAB	3
+#define SHT_RELA	4
+#define SHT_HASH	5
+#define SHT_DYNAMIC	6
+#define SHT_NOTE	7
+#define SHT_NOBITS	8
+#define SHT_REL		9
+#define SHT_SHLIB	10
+#define SHT_DYNSYM	11
+#define SHT_NUM		12
+#define SHT_LOPROC	0x70000000
+#define SHT_HIPROC	0x7fffffff
+#define SHT_LOUSER	0x80000000
+#define SHT_HIUSER	0xffffffff
+
+/* sh_flags */
+#define SHF_WRITE	0x1
+#define SHF_ALLOC	0x2
+#define SHF_EXECINSTR	0x4
+#define SHF_MASKPROC	0xf0000000
+
+/* special section indexes */
+#define SHN_UNDEF	0
+#define SHN_LORESERVE	0xff00
+#define SHN_LOPROC	0xff00
+#define SHN_HIPROC	0xff1f
+#define SHN_ABS		0xfff1
+#define SHN_COMMON	0xfff2
+#define SHN_HIRESERVE	0xffff
+
+#define	EI_MAG0		0		/* e_ident[] indexes */
+#define	EI_MAG1		1
+#define	EI_MAG2		2
+#define	EI_MAG3		3
+#define	EI_CLASS	4
+#define	EI_DATA		5
+#define	EI_VERSION	6
+#define	EI_OSABI	7
+#define	EI_PAD		8
+
+#define	ELFMAG0		0x7f		/* EI_MAG */
+#define	ELFMAG1		'E'
+#define	ELFMAG2		'L'
+#define	ELFMAG3		'F'
+#define	ELFMAG		"\177ELF"
+#define	SELFMAG		4
+
+#define	ELFCLASSNONE	0		/* EI_CLASS */
+#define	ELFCLASS32	1
+#define	ELFCLASS64	2
+#define	ELFCLASSNUM	3
+
+#define ELFDATANONE	0		/* e_ident[EI_DATA] */
+#define ELFDATA2LSB	1
+#define ELFDATA2MSB	2
+
+#define EV_NONE		0		/* e_version, EI_VERSION */
+#define EV_CURRENT	1
+#define EV_NUM		2
+
+#define ELFOSABI_NONE	0
+#define ELFOSABI_LINUX	3
+#define ELFOSABI_STANDALONE	255
+
+#ifndef ELF_OSABI
+#define ELF_OSABI ELFOSABI_NONE
+#endif
+
+/* Notes used in ET_CORE */
+#define NT_PRSTATUS	1
+#define NT_PRFPREG	2
+#define NT_PRPSINFO	3
+#define NT_TASKSTRUCT	4
+#define NT_AUXV		6
+#define NT_PRXFPREG     0x46e62b7f      /* copied from gdb5.1/include/elf/common.h */
+
+#endif /* _LINUX_ELF_CONST_H */
===================================================================
--- /dev/null
+++ b/include/linux/elf-decl.h
@@ -0,0 +1,48 @@
+#ifndef _LINUX_ELF_DECL_H
+#define _LINUX_ELF_DECL_H
+
+#include <linux/types.h>
+
+/* 32-bit ELF base types. */
+typedef __u32	Elf32_Addr;
+typedef __u16	Elf32_Half;
+typedef __u32	Elf32_Off;
+typedef __s32	Elf32_Sword;
+typedef __u32	Elf32_Word;
+
+/* 64-bit ELF base types. */
+typedef __u64	Elf64_Addr;
+typedef __u16	Elf64_Half;
+typedef __s16	Elf64_SHalf;
+typedef __u64	Elf64_Off;
+typedef __s32	Elf64_Sword;
+typedef __u32	Elf64_Word;
+typedef __u64	Elf64_Xword;
+typedef __s64	Elf64_Sxword;
+
+typedef struct Elf32_Dyn Elf32_Dyn;
+typedef struct Elf64_Dyn Elf64_Dyn;
+
+typedef struct Elf32_Rel Elf32_Rel;
+typedef struct Elf64_Rel Elf64_Rel;
+
+typedef struct Elf32_Rela Elf32_Rela;
+typedef struct Elf64_Rela Elf64_Rela;
+
+typedef struct Elf32_Sym Elf32_Sym;
+typedef struct Elf64_Sym Elf64_Sym;
+
+typedef struct Elf32_Ehdr Elf32_Ehdr;
+typedef struct Elf64_Ehdr Elf64_Ehdr;
+
+typedef struct Elf32_Phdr Elf32_Phdr;
+typedef struct Elf64_Phdr Elf64_Phdr;
+
+typedef struct Elf32_Shdr Elf32_Shdr;
+typedef struct Elf64_Shdr Elf64_Shdr;
+
+typedef struct Elf32_Nhdr Elf32_Nhdr;
+typedef struct Elf64_Nhdr Elf64_Nhdr;
+
+
+#endif /* _LINUX_ELF_DECL_H */
===================================================================
--- /dev/null
+++ b/include/linux/elf-defn.h
@@ -0,0 +1,174 @@
+#ifndef _LINUX_ELF_DEFN_H
+#define _LINUX_ELF_DEFN_H
+
+#include <linux/elf-decl.h>
+#include <linux/elf-const.h>
+
+#define ELF_ST_BIND(x)		((x) >> 4)
+#define ELF_ST_TYPE(x)		(((unsigned int) x) & 0xf)
+#define ELF32_ST_BIND(x)	ELF_ST_BIND(x)
+#define ELF32_ST_TYPE(x)	ELF_ST_TYPE(x)
+#define ELF64_ST_BIND(x)	ELF_ST_BIND(x)
+#define ELF64_ST_TYPE(x)	ELF_ST_TYPE(x)
+
+struct Elf32_Dyn {
+  Elf32_Sword d_tag;
+  union{
+    Elf32_Sword	d_val;
+    Elf32_Addr	d_ptr;
+  } d_un;
+};
+
+struct  Elf64_Dyn {
+  Elf64_Sxword d_tag;		/* entry tag value */
+  union {
+    Elf64_Xword d_val;
+    Elf64_Addr d_ptr;
+  } d_un;
+};
+
+/* The following are used with relocations */
+#define ELF32_R_SYM(x) ((x) >> 8)
+#define ELF32_R_TYPE(x) ((x) & 0xff)
+
+#define ELF64_R_SYM(i)			((i) >> 32)
+#define ELF64_R_TYPE(i)			((i) & 0xffffffff)
+
+struct Elf32_Rel {
+  Elf32_Addr	r_offset;
+  Elf32_Word	r_info;
+};
+
+struct Elf64_Rel {
+  Elf64_Addr r_offset;	/* Location at which to apply the action */
+  Elf64_Xword r_info;	/* index and type of relocation */
+};
+
+struct Elf32_Rela {
+  Elf32_Addr	r_offset;
+  Elf32_Word	r_info;
+  Elf32_Sword	r_addend;
+};
+
+struct Elf64_Rela {
+  Elf64_Addr r_offset;	/* Location at which to apply the action */
+  Elf64_Xword r_info;	/* index and type of relocation */
+  Elf64_Sxword r_addend;	/* Constant addend used to compute value */
+};
+
+struct Elf32_Sym {
+  Elf32_Word	st_name;
+  Elf32_Addr	st_value;
+  Elf32_Word	st_size;
+  unsigned char	st_info;
+  unsigned char	st_other;
+  Elf32_Half	st_shndx;
+};
+
+struct Elf64_Sym {
+  Elf64_Word st_name;		/* Symbol name, index in string tbl */
+  unsigned char	st_info;	/* Type and binding attributes */
+  unsigned char	st_other;	/* No defined meaning, 0 */
+  Elf64_Half st_shndx;		/* Associated section index */
+  Elf64_Addr st_value;		/* Value of the symbol */
+  Elf64_Xword st_size;		/* Associated symbol size */
+};
+
+struct Elf32_Ehdr {
+  unsigned char	e_ident[EI_NIDENT];
+  Elf32_Half	e_type;
+  Elf32_Half	e_machine;
+  Elf32_Word	e_version;
+  Elf32_Addr	e_entry;  /* Entry point */
+  Elf32_Off	e_phoff;
+  Elf32_Off	e_shoff;
+  Elf32_Word	e_flags;
+  Elf32_Half	e_ehsize;
+  Elf32_Half	e_phentsize;
+  Elf32_Half	e_phnum;
+  Elf32_Half	e_shentsize;
+  Elf32_Half	e_shnum;
+  Elf32_Half	e_shstrndx;
+};
+
+struct Elf64_Ehdr {
+  unsigned char	e_ident[EI_NIDENT];	/* ELF "magic number" */
+  Elf64_Half e_type;
+  Elf64_Half e_machine;
+  Elf64_Word e_version;
+  Elf64_Addr e_entry;		/* Entry point virtual address */
+  Elf64_Off e_phoff;		/* Program header table file offset */
+  Elf64_Off e_shoff;		/* Section header table file offset */
+  Elf64_Word e_flags;
+  Elf64_Half e_ehsize;
+  Elf64_Half e_phentsize;
+  Elf64_Half e_phnum;
+  Elf64_Half e_shentsize;
+  Elf64_Half e_shnum;
+  Elf64_Half e_shstrndx;
+};
+
+struct Elf32_Phdr {
+  Elf32_Word	p_type;
+  Elf32_Off	p_offset;
+  Elf32_Addr	p_vaddr;
+  Elf32_Addr	p_paddr;
+  Elf32_Word	p_filesz;
+  Elf32_Word	p_memsz;
+  Elf32_Word	p_flags;
+  Elf32_Word	p_align;
+};
+
+struct Elf64_Phdr {
+  Elf64_Word p_type;
+  Elf64_Word p_flags;
+  Elf64_Off p_offset;		/* Segment file offset */
+  Elf64_Addr p_vaddr;		/* Segment virtual address */
+  Elf64_Addr p_paddr;		/* Segment physical address */
+  Elf64_Xword p_filesz;		/* Segment size in file */
+  Elf64_Xword p_memsz;		/* Segment size in memory */
+  Elf64_Xword p_align;		/* Segment alignment, file & memory */
+};
+
+struct Elf32_Shdr {
+  Elf32_Word	sh_name;
+  Elf32_Word	sh_type;
+  Elf32_Word	sh_flags;
+  Elf32_Addr	sh_addr;
+  Elf32_Off	sh_offset;
+  Elf32_Word	sh_size;
+  Elf32_Word	sh_link;
+  Elf32_Word	sh_info;
+  Elf32_Word	sh_addralign;
+  Elf32_Word	sh_entsize;
+};
+
+struct Elf64_Shdr {
+  Elf64_Word sh_name;		/* Section name, index in string tbl */
+  Elf64_Word sh_type;		/* Type of section */
+  Elf64_Xword sh_flags;		/* Miscellaneous section attributes */
+  Elf64_Addr sh_addr;		/* Section virtual addr at execution */
+  Elf64_Off sh_offset;		/* Section file offset */
+  Elf64_Xword sh_size;		/* Size of section in bytes */
+  Elf64_Word sh_link;		/* Index of another section */
+  Elf64_Word sh_info;		/* Additional section information */
+  Elf64_Xword sh_addralign;	/* Section alignment */
+  Elf64_Xword sh_entsize;	/* Entry size if section holds table */
+};
+
+/* Note header in a PT_NOTE section */
+struct Elf32_Nhdr {
+  Elf32_Word	n_namesz;	/* Name size */
+  Elf32_Word	n_descsz;	/* Content size */
+  Elf32_Word	n_type;		/* Content type */
+};
+
+/* Note header in a PT_NOTE section */
+struct Elf64_Nhdr {
+  Elf64_Word n_namesz;	/* Name size */
+  Elf64_Word n_descsz;	/* Content size */
+  Elf64_Word n_type;	/* Content type */
+};
+
+
+#endif	/* _LINUX_ELF_DEFN_H */
===================================================================
--- a/include/linux/elf-em.h
+++ /dev/null
@@ -1,51 +0,0 @@
-#ifndef _LINUX_ELF_EM_H
-#define _LINUX_ELF_EM_H
-
-/* These constants define the various ELF target machines */
-#define EM_NONE		0
-#define EM_M32		1
-#define EM_SPARC	2
-#define EM_386		3
-#define EM_68K		4
-#define EM_88K		5
-#define EM_486		6	/* Perhaps disused */
-#define EM_860		7
-#define EM_MIPS		8	/* MIPS R3000 (officially, big-endian only) */
-				/* Next two are historical and binaries and
-				   modules of these types will be rejected by
-				   Linux.  */
-#define EM_MIPS_RS3_LE	10	/* MIPS R3000 little-endian */
-#define EM_MIPS_RS4_BE	10	/* MIPS R4000 big-endian */
-
-#define EM_PARISC	15	/* HPPA */
-#define EM_SPARC32PLUS	18	/* Sun's "v8plus" */
-#define EM_PPC		20	/* PowerPC */
-#define EM_PPC64	21       /* PowerPC64 */
-#define EM_SH		42	/* SuperH */
-#define EM_SPARCV9	43	/* SPARC v9 64-bit */
-#define EM_IA_64	50	/* HP/Intel IA-64 */
-#define EM_X86_64	62	/* AMD x86-64 */
-#define EM_S390		22	/* IBM S/390 */
-#define EM_CRIS		76	/* Axis Communications 32-bit embedded processor */
-#define EM_V850		87	/* NEC v850 */
-#define EM_M32R		88	/* Renesas M32R */
-#define EM_H8_300	46	/* Renesas H8/300,300H,H8S */
-#define EM_BLACKFIN     106     /* ADI Blackfin Processor */
-#define EM_FRV		0x5441	/* Fujitsu FR-V */
-#define EM_AVR32	0x18ad	/* Atmel AVR32 */
-
-/*
- * This is an interim value that we will use until the committee comes
- * up with a final number.
- */
-#define EM_ALPHA	0x9026
-
-/* Bogus old v850 magic number, used by old tools. */
-#define EM_CYGNUS_V850	0x9080
-/* Bogus old m32r magic number, used by old tools. */
-#define EM_CYGNUS_M32R	0x9041
-/* This is the old interim value for S/390 architecture */
-#define EM_S390_OLD	0xA390
-
-
-#endif /* _LINUX_ELF_EM_H */
===================================================================
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -1,12 +1,27 @@
 #ifndef _LINUX_ELF_H
 #define _LINUX_ELF_H
 
-#include <linux/types.h>
-#include <linux/auxvec.h>
-#include <linux/elf-em.h>
+#include <linux/elf-const.h>
+#include <linux/elf-defn.h>
 #include <asm/elf.h>
 
-struct file;
+#if ELF_CLASS == ELFCLASS32
+
+extern Elf32_Dyn _DYNAMIC [];
+#define elfhdr		Elf32_Ehdr
+#define elf_phdr	Elf32_Phdr
+#define elf_note	Elf32_Nhdr
+#define elf_addr_t	Elf32_Off
+
+#else
+
+extern Elf64_Dyn _DYNAMIC [];
+#define elfhdr		Elf64_Ehdr
+#define elf_phdr	Elf64_Phdr
+#define elf_note	Elf64_Nhdr
+#define elf_addr_t	Elf64_Off
+
+#endif
 
 #ifndef elf_read_implies_exec
   /* Executables for which elf_read_implies_exec() returns TRUE will
@@ -15,381 +30,9 @@ struct file;
 # define elf_read_implies_exec(ex, have_pt_gnu_stack)	0
 #endif
 
-/* 32-bit ELF base types. */
-typedef __u32	Elf32_Addr;
-typedef __u16	Elf32_Half;
-typedef __u32	Elf32_Off;
-typedef __s32	Elf32_Sword;
-typedef __u32	Elf32_Word;
+#ifndef ARCH_HAVE_EXTRA_ELF_NOTES
+struct file;
 
-/* 64-bit ELF base types. */
-typedef __u64	Elf64_Addr;
-typedef __u16	Elf64_Half;
-typedef __s16	Elf64_SHalf;
-typedef __u64	Elf64_Off;
-typedef __s32	Elf64_Sword;
-typedef __u32	Elf64_Word;
-typedef __u64	Elf64_Xword;
-typedef __s64	Elf64_Sxword;
-
-/* These constants are for the segment types stored in the image headers */
-#define PT_NULL    0
-#define PT_LOAD    1
-#define PT_DYNAMIC 2
-#define PT_INTERP  3
-#define PT_NOTE    4
-#define PT_SHLIB   5
-#define PT_PHDR    6
-#define PT_TLS     7               /* Thread local storage segment */
-#define PT_LOOS    0x60000000      /* OS-specific */
-#define PT_HIOS    0x6fffffff      /* OS-specific */
-#define PT_LOPROC  0x70000000
-#define PT_HIPROC  0x7fffffff
-#define PT_GNU_EH_FRAME		0x6474e550
-
-#define PT_GNU_STACK	(PT_LOOS + 0x474e551)
-
-/* These constants define the different elf file types */
-#define ET_NONE   0
-#define ET_REL    1
-#define ET_EXEC   2
-#define ET_DYN    3
-#define ET_CORE   4
-#define ET_LOPROC 0xff00
-#define ET_HIPROC 0xffff
-
-/* This is the info that is needed to parse the dynamic section of the file */
-#define DT_NULL		0
-#define DT_NEEDED	1
-#define DT_PLTRELSZ	2
-#define DT_PLTGOT	3
-#define DT_HASH		4
-#define DT_STRTAB	5
-#define DT_SYMTAB	6
-#define DT_RELA		7
-#define DT_RELASZ	8
-#define DT_RELAENT	9
-#define DT_STRSZ	10
-#define DT_SYMENT	11
-#define DT_INIT		12
-#define DT_FINI		13
-#define DT_SONAME	14
-#define DT_RPATH 	15
-#define DT_SYMBOLIC	16
-#define DT_REL	        17
-#define DT_RELSZ	18
-#define DT_RELENT	19
-#define DT_PLTREL	20
-#define DT_DEBUG	21
-#define DT_TEXTREL	22
-#define DT_JMPREL	23
-#define DT_ENCODING	32
-#define OLD_DT_LOOS	0x60000000
-#define DT_LOOS		0x6000000d
-#define DT_HIOS		0x6ffff000
-#define DT_VALRNGLO	0x6ffffd00
-#define DT_VALRNGHI	0x6ffffdff
-#define DT_ADDRRNGLO	0x6ffffe00
-#define DT_ADDRRNGHI	0x6ffffeff
-#define DT_VERSYM	0x6ffffff0
-#define DT_RELACOUNT	0x6ffffff9
-#define DT_RELCOUNT	0x6ffffffa
-#define DT_FLAGS_1	0x6ffffffb
-#define DT_VERDEF	0x6ffffffc
-#define	DT_VERDEFNUM	0x6ffffffd
-#define DT_VERNEED	0x6ffffffe
-#define	DT_VERNEEDNUM	0x6fffffff
-#define OLD_DT_HIOS     0x6fffffff
-#define DT_LOPROC	0x70000000
-#define DT_HIPROC	0x7fffffff
-
-/* This info is needed when parsing the symbol table */
-#define STB_LOCAL  0
-#define STB_GLOBAL 1
-#define STB_WEAK   2
-
-#define STT_NOTYPE  0
-#define STT_OBJECT  1
-#define STT_FUNC    2
-#define STT_SECTION 3
-#define STT_FILE    4
-#define STT_COMMON  5
-#define STT_TLS     6
-
-#define ELF_ST_BIND(x)		((x) >> 4)
-#define ELF_ST_TYPE(x)		(((unsigned int) x) & 0xf)
-#define ELF32_ST_BIND(x)	ELF_ST_BIND(x)
-#define ELF32_ST_TYPE(x)	ELF_ST_TYPE(x)
-#define ELF64_ST_BIND(x)	ELF_ST_BIND(x)
-#define ELF64_ST_TYPE(x)	ELF_ST_TYPE(x)
-
-typedef struct dynamic{
-  Elf32_Sword d_tag;
-  union{
-    Elf32_Sword	d_val;
-    Elf32_Addr	d_ptr;
-  } d_un;
-} Elf32_Dyn;
-
-typedef struct {
-  Elf64_Sxword d_tag;		/* entry tag value */
-  union {
-    Elf64_Xword d_val;
-    Elf64_Addr d_ptr;
-  } d_un;
-} Elf64_Dyn;
-
-/* The following are used with relocations */
-#define ELF32_R_SYM(x) ((x) >> 8)
-#define ELF32_R_TYPE(x) ((x) & 0xff)
-
-#define ELF64_R_SYM(i)			((i) >> 32)
-#define ELF64_R_TYPE(i)			((i) & 0xffffffff)
-
-typedef struct elf32_rel {
-  Elf32_Addr	r_offset;
-  Elf32_Word	r_info;
-} Elf32_Rel;
-
-typedef struct elf64_rel {
-  Elf64_Addr r_offset;	/* Location at which to apply the action */
-  Elf64_Xword r_info;	/* index and type of relocation */
-} Elf64_Rel;
-
-typedef struct elf32_rela{
-  Elf32_Addr	r_offset;
-  Elf32_Word	r_info;
-  Elf32_Sword	r_addend;
-} Elf32_Rela;
-
-typedef struct elf64_rela {
-  Elf64_Addr r_offset;	/* Location at which to apply the action */
-  Elf64_Xword r_info;	/* index and type of relocation */
-  Elf64_Sxword r_addend;	/* Constant addend used to compute value */
-} Elf64_Rela;
-
-typedef struct elf32_sym{
-  Elf32_Word	st_name;
-  Elf32_Addr	st_value;
-  Elf32_Word	st_size;
-  unsigned char	st_info;
-  unsigned char	st_other;
-  Elf32_Half	st_shndx;
-} Elf32_Sym;
-
-typedef struct elf64_sym {
-  Elf64_Word st_name;		/* Symbol name, index in string tbl */
-  unsigned char	st_info;	/* Type and binding attributes */
-  unsigned char	st_other;	/* No defined meaning, 0 */
-  Elf64_Half st_shndx;		/* Associated section index */
-  Elf64_Addr st_value;		/* Value of the symbol */
-  Elf64_Xword st_size;		/* Associated symbol size */
-} Elf64_Sym;
-
-
-#define EI_NIDENT	16
-
-typedef struct elf32_hdr{
-  unsigned char	e_ident[EI_NIDENT];
-  Elf32_Half	e_type;
-  Elf32_Half	e_machine;
-  Elf32_Word	e_version;
-  Elf32_Addr	e_entry;  /* Entry point */
-  Elf32_Off	e_phoff;
-  Elf32_Off	e_shoff;
-  Elf32_Word	e_flags;
-  Elf32_Half	e_ehsize;
-  Elf32_Half	e_phentsize;
-  Elf32_Half	e_phnum;
-  Elf32_Half	e_shentsize;
-  Elf32_Half	e_shnum;
-  Elf32_Half	e_shstrndx;
-} Elf32_Ehdr;
-
-typedef struct elf64_hdr {
-  unsigned char	e_ident[16];		/* ELF "magic number" */
-  Elf64_Half e_type;
-  Elf64_Half e_machine;
-  Elf64_Word e_version;
-  Elf64_Addr e_entry;		/* Entry point virtual address */
-  Elf64_Off e_phoff;		/* Program header table file offset */
-  Elf64_Off e_shoff;		/* Section header table file offset */
-  Elf64_Word e_flags;
-  Elf64_Half e_ehsize;
-  Elf64_Half e_phentsize;
-  Elf64_Half e_phnum;
-  Elf64_Half e_shentsize;
-  Elf64_Half e_shnum;
-  Elf64_Half e_shstrndx;
-} Elf64_Ehdr;
-
-/* These constants define the permissions on sections in the program
-   header, p_flags. */
-#define PF_R		0x4
-#define PF_W		0x2
-#define PF_X		0x1
-
-typedef struct elf32_phdr{
-  Elf32_Word	p_type;
-  Elf32_Off	p_offset;
-  Elf32_Addr	p_vaddr;
-  Elf32_Addr	p_paddr;
-  Elf32_Word	p_filesz;
-  Elf32_Word	p_memsz;
-  Elf32_Word	p_flags;
-  Elf32_Word	p_align;
-} Elf32_Phdr;
-
-typedef struct elf64_phdr {
-  Elf64_Word p_type;
-  Elf64_Word p_flags;
-  Elf64_Off p_offset;		/* Segment file offset */
-  Elf64_Addr p_vaddr;		/* Segment virtual address */
-  Elf64_Addr p_paddr;		/* Segment physical address */
-  Elf64_Xword p_filesz;		/* Segment size in file */
-  Elf64_Xword p_memsz;		/* Segment size in memory */
-  Elf64_Xword p_align;		/* Segment alignment, file & memory */
-} Elf64_Phdr;
-
-/* sh_type */
-#define SHT_NULL	0
-#define SHT_PROGBITS	1
-#define SHT_SYMTAB	2
-#define SHT_STRTAB	3
-#define SHT_RELA	4
-#define SHT_HASH	5
-#define SHT_DYNAMIC	6
-#define SHT_NOTE	7
-#define SHT_NOBITS	8
-#define SHT_REL		9
-#define SHT_SHLIB	10
-#define SHT_DYNSYM	11
-#define SHT_NUM		12
-#define SHT_LOPROC	0x70000000
-#define SHT_HIPROC	0x7fffffff
-#define SHT_LOUSER	0x80000000
-#define SHT_HIUSER	0xffffffff
-
-/* sh_flags */
-#define SHF_WRITE	0x1
-#define SHF_ALLOC	0x2
-#define SHF_EXECINSTR	0x4
-#define SHF_MASKPROC	0xf0000000
-
-/* special section indexes */
-#define SHN_UNDEF	0
-#define SHN_LORESERVE	0xff00
-#define SHN_LOPROC	0xff00
-#define SHN_HIPROC	0xff1f
-#define SHN_ABS		0xfff1
-#define SHN_COMMON	0xfff2
-#define SHN_HIRESERVE	0xffff
- 
-typedef struct {
-  Elf32_Word	sh_name;
-  Elf32_Word	sh_type;
-  Elf32_Word	sh_flags;
-  Elf32_Addr	sh_addr;
-  Elf32_Off	sh_offset;
-  Elf32_Word	sh_size;
-  Elf32_Word	sh_link;
-  Elf32_Word	sh_info;
-  Elf32_Word	sh_addralign;
-  Elf32_Word	sh_entsize;
-} Elf32_Shdr;
-
-typedef struct elf64_shdr {
-  Elf64_Word sh_name;		/* Section name, index in string tbl */
-  Elf64_Word sh_type;		/* Type of section */
-  Elf64_Xword sh_flags;		/* Miscellaneous section attributes */
-  Elf64_Addr sh_addr;		/* Section virtual addr at execution */
-  Elf64_Off sh_offset;		/* Section file offset */
-  Elf64_Xword sh_size;		/* Size of section in bytes */
-  Elf64_Word sh_link;		/* Index of another section */
-  Elf64_Word sh_info;		/* Additional section information */
-  Elf64_Xword sh_addralign;	/* Section alignment */
-  Elf64_Xword sh_entsize;	/* Entry size if section holds table */
-} Elf64_Shdr;
-
-#define	EI_MAG0		0		/* e_ident[] indexes */
-#define	EI_MAG1		1
-#define	EI_MAG2		2
-#define	EI_MAG3		3
-#define	EI_CLASS	4
-#define	EI_DATA		5
-#define	EI_VERSION	6
-#define	EI_OSABI	7
-#define	EI_PAD		8
-
-#define	ELFMAG0		0x7f		/* EI_MAG */
-#define	ELFMAG1		'E'
-#define	ELFMAG2		'L'
-#define	ELFMAG3		'F'
-#define	ELFMAG		"\177ELF"
-#define	SELFMAG		4
-
-#define	ELFCLASSNONE	0		/* EI_CLASS */
-#define	ELFCLASS32	1
-#define	ELFCLASS64	2
-#define	ELFCLASSNUM	3
-
-#define ELFDATANONE	0		/* e_ident[EI_DATA] */
-#define ELFDATA2LSB	1
-#define ELFDATA2MSB	2
-
-#define EV_NONE		0		/* e_version, EI_VERSION */
-#define EV_CURRENT	1
-#define EV_NUM		2
-
-#define ELFOSABI_NONE	0
-#define ELFOSABI_LINUX	3
-
-#ifndef ELF_OSABI
-#define ELF_OSABI ELFOSABI_NONE
-#endif
-
-/* Notes used in ET_CORE */
-#define NT_PRSTATUS	1
-#define NT_PRFPREG	2
-#define NT_PRPSINFO	3
-#define NT_TASKSTRUCT	4
-#define NT_AUXV		6
-#define NT_PRXFPREG     0x46e62b7f      /* copied from gdb5.1/include/elf/common.h */
-
-
-/* Note header in a PT_NOTE section */
-typedef struct elf32_note {
-  Elf32_Word	n_namesz;	/* Name size */
-  Elf32_Word	n_descsz;	/* Content size */
-  Elf32_Word	n_type;		/* Content type */
-} Elf32_Nhdr;
-
-/* Note header in a PT_NOTE section */
-typedef struct elf64_note {
-  Elf64_Word n_namesz;	/* Name size */
-  Elf64_Word n_descsz;	/* Content size */
-  Elf64_Word n_type;	/* Content type */
-} Elf64_Nhdr;
-
-#if ELF_CLASS == ELFCLASS32
-
-extern Elf32_Dyn _DYNAMIC [];
-#define elfhdr		elf32_hdr
-#define elf_phdr	elf32_phdr
-#define elf_note	elf32_note
-#define elf_addr_t	Elf32_Off
-
-#else
-
-extern Elf64_Dyn _DYNAMIC [];
-#define elfhdr		elf64_hdr
-#define elf_phdr	elf64_phdr
-#define elf_note	elf64_note
-#define elf_addr_t	Elf64_Off
-
-#endif
-
-#ifndef ARCH_HAVE_EXTRA_ELF_NOTES
 static inline int arch_notes_size(void) { return 0; }
 static inline void arch_write_notes(struct file *file) { }
 
===================================================================
--- a/include/linux/elfnote.h
+++ b/include/linux/elfnote.h
@@ -58,7 +58,8 @@ 4484:.balign 4				;	\
 	ELFNOTE_END
 
 #else	/* !__ASSEMBLER__ */
-#include <linux/elf.h>
+#include <linux/elf-defn.h>
+#include <asm/elf-defines.h>
 /*
  * Use an anonymous structure which matches the shape of
  * Elf{32,64}_Nhdr, but includes the name and desc data.  The size and
@@ -67,15 +68,15 @@ 4484:.balign 4				;	\
  * only define one note per line, since __LINE__ is used to generate
  * unique symbols.
  */
-#define _ELFNOTE_PASTE(a,b)	a##b
-#define _ELFNOTE(size, name, unique, type, desc)			\
+#define __ELFNOTE_PASTE(a,b)	a##b
+#define __ELFNOTE(size, name, unique, type, desc)			\
 	static const struct {						\
-		struct elf##size##_note _nhdr;				\
+		struct Elf##size##_Nhdr _nhdr;				\
 		unsigned char _name[sizeof(name)]			\
-		__attribute__((aligned(sizeof(Elf##size##_Word))));	\
+			__attribute__((aligned(sizeof(Elf##size##_Word)))); \
 		typeof(desc) _desc					\
-			     __attribute__((aligned(sizeof(Elf##size##_Word)))); \
-	} _ELFNOTE_PASTE(_note_, unique)				\
+			__attribute__((aligned(sizeof(Elf##size##_Word)))); \
+	} __ELFNOTE_PASTE(_note_, unique)				\
 		__attribute_used__					\
 		__attribute__((section(".note." name),			\
 			       aligned(sizeof(Elf##size##_Word)),	\
@@ -88,11 +89,18 @@ 4484:.balign 4				;	\
 		name,							\
 		desc							\
 	}
-#define ELFNOTE(size, name, type, desc)		\
-	_ELFNOTE(size, name, __LINE__, type, desc)
 
-#define ELFNOTE32(name, type, desc) ELFNOTE(32, name, type, desc)
-#define ELFNOTE64(name, type, desc) ELFNOTE(64, name, type, desc)
+#define ELFNOTE32(name, type, desc) __ELFNOTE(32, name, __LINE__, type, desc)
+#define ELFNOTE64(name, type, desc) __ELFNOTE(64, name, __LINE__, type, desc)
+
+#if ELF_CLASS == ELFCLASS32
+#define ELFNOTE(name, type, desc)	ELFNOTE32(name, type, desc)
+#elif ELF_CLASS == ELFCLASS64
+#define ELFNOTE(name, type, desc)	ELFNOTE64(name, type, desc)
+#else
+#error Define ELFNOTE for this ELF_CLASS
+#endif
+
 #endif	/* __ASSEMBLER__ */
 
 #endif /* _LINUX_ELFNOTE_H */
===================================================================
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -11,7 +11,6 @@
 #include <linux/compiler.h>
 #include <linux/cache.h>
 #include <linux/kmod.h>
-#include <linux/elf.h>
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
===================================================================
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -50,6 +50,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
+#include <asm/elf.h>
 
 extern int proc_nr_files(ctl_table *table, int write, struct file *filp,
                      void __user *buffer, size_t *lenp, loff_t *ppos);
===================================================================
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -38,6 +38,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/bug.h>
+#include <linux/elf.h>
 
 extern const struct bug_entry __start___bug_table[], __stop___bug_table[];
 

-- 

