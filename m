Return-Path: <linux-kernel-owner+w=401wt.eu-S1161187AbXDWFVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161187AbXDWFVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 01:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161202AbXDWFVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 01:21:12 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44473 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161187AbXDWFVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 01:21:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: vgoyal@in.ibm.com, Jurriaan <thunder7@xs4all.nl>,
       Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org,
       Magnus Damm <magnus@valinux.co.jp>, Horms <horms@verge.net.au>,
       <fastboot@osdl.org>, Kexec Mailing List <kexec@lists.infradead.org>
Subject: [PATCH 2/2] x86_64: Remove CONFIG_PHYSICAL_START and CONFIG_RELOCATABLE
References: <20070331005303.354411f0.akpm@linux-foundation.org>
	<20070401052932.GA9894@amd64.of.nowhere>
	<m1ircghb6w.fsf@ebiederm.dsl.xmission.com>
	<20070331232957.e1c93f19.akpm@linux-foundation.org>
	<20070402074159.GA13704@in.ibm.com>
	<m1abxrf9o3.fsf@ebiederm.dsl.xmission.com>
	<20070402094520.GC13704@in.ibm.com>
	<m1648eg01d.fsf@ebiederm.dsl.xmission.com>
	<20070403040152.GA5108@in.ibm.com>
	<m1zm5qc9q2.fsf@ebiederm.dsl.xmission.com>
	<20070403100349.GA21759@in.ibm.com>
	<m18xcjznbm.fsf_-_@ebiederm.dsl.xmission.com>
Date: Sun, 22 Apr 2007 23:15:48 -0600
In-Reply-To: <m18xcjznbm.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Sun, 22 Apr 2007 23:12:13 -0600")
Message-ID: <m14pn7zn5n.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that the vmlinux is marked as relocatable there is no reason to
retain the CONFIG_PHYSICAL_START option, as we can put the binary we
have at any 2MB aligned address in memory.

With CONFIG_PHYSICAL_START gone the handful of code lines that depend
on CONFIG_RELOCATABLE no longer make sense to be conditional and can
be removed.

The big win of this patch (besides Kconfig simplicity) is that the
nasty BUILD_BUG_ON test for people misaligning their kernel when using
CONFIG_PHYSICAL_START can be removed as this case can only happen with
CONFIG_PHYSICAL_START selected.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/Kconfig                |   55 +-----------------------------------
 arch/x86_64/Makefile               |    2 -
 arch/x86_64/boot/compressed/head.S |   13 +--------
 arch/x86_64/boot/setup.S           |    4 --
 arch/x86_64/defconfig              |    2 -
 arch/x86_64/kernel/head64.c        |    7 ----
 include/asm-x86_64/page.h          |    2 +-
 7 files changed, 3 insertions(+), 82 deletions(-)

diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 773b487..713c1ad 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -565,62 +565,9 @@ config CRASH_DUMP
           which are loaded in the main kernel with kexec-tools into
           a specially reserved region and then later executed after
           a crash by kdump/kexec. The crash dump kernel must be compiled
-	  to a memory address not used by the main kernel or BIOS using
-	  PHYSICAL_START.
+	  to a memory address not used by the main kernel or BIOS
           For more details see Documentation/kdump/kdump.txt
 
-config RELOCATABLE
-	bool "Build a relocatable kernel(EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-	  Builds a relocatable kernel. This enables loading and running
-	  a kernel binary from a different physical address than it has
-	  been compiled for.
-
-	  One use is for the kexec on panic case where the recovery kernel
-	  must live at a different physical address than the primary
-	  kernel.
-
-	  Note: If CONFIG_RELOCATABLE=y, then kernel run from the address
-	  it has been loaded at and compile time physical address
-	  (CONFIG_PHYSICAL_START) is ignored.
-
-config PHYSICAL_START
-	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
-	default "0x200000"
-	help
-	  This gives the physical address where the kernel is loaded. It
-	  should be aligned to 2MB boundary.
-
-	  If kernel is a not relocatable (CONFIG_RELOCATABLE=n) then
-	  bzImage will decompress itself to above physical address and
-	  run from there. Otherwise, bzImage will run from the address where
-	  it has been loaded by the boot loader and will ignore above physical
-	  address.
-
-	  In normal kdump cases one does not have to set/change this option
-	  as now bzImage can be compiled as a completely relocatable image
-	  (CONFIG_RELOCATABLE=y) and be used to load and run from a different
-	  address. This option is mainly useful for the folks who don't want
-	  to use a bzImage for capturing the crash dump and want to use a
-	  vmlinux instead.
-
-	  So if you are using bzImage for capturing the crash dump, leave
-	  the value here unchanged to 0x200000 and set CONFIG_RELOCATABLE=y.
-	  Otherwise if you plan to use vmlinux for capturing the crash dump
-	  change this value to start of the reserved region (Typically 16MB
-	  0x1000000). In other words, it can be set based on the "X" value as
-	  specified in the "crashkernel=YM@XM" command line boot parameter
-	  passed to the panic-ed kernel. Typically this parameter is set as
-	  crashkernel=64M@16M. Please take a look at
-	  Documentation/kdump/kdump.txt for more details about crash dumps.
-
-	  Usage of bzImage for capturing the crash dump is advantageous as
-	  one does not have to build two kernels. Same kernel can be used
-	  as production kernel and capture kernel.
-
-	  Don't change this unless you know what you are doing.
-
 config SECCOMP
 	bool "Enable seccomp to safely compute untrusted bytecode"
 	depends on PROC_FS
diff --git a/arch/x86_64/Makefile b/arch/x86_64/Makefile
index 5ae79ab..5d96f4f 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86_64/Makefile
@@ -124,7 +124,6 @@ define archhelp
   echo  '  isoimage     - Create a boot CD-ROM image'
 endef
 
-ifeq ($(CONFIG_RELOCATABLE),y)
 define cmd_vmlinux__
       $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
       -T $(vmlinux-lds) $(vmlinux-init)		\
@@ -132,7 +131,6 @@ define cmd_vmlinux__
       $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) FORCE ,$^) \
       && scripts/mketrel $@
 endef
-endif
 
 CLEAN_FILES += arch/$(ARCH)/boot/fdimage \
 	       arch/$(ARCH)/boot/image.iso \
diff --git a/arch/x86_64/boot/compressed/head.S b/arch/x86_64/boot/compressed/head.S
index f9d5692..493723e 100644
--- a/arch/x86_64/boot/compressed/head.S
+++ b/arch/x86_64/boot/compressed/head.S
@@ -71,13 +71,9 @@ startup_32:
  * for safe in-place decompression.
  */
 
-#ifdef CONFIG_RELOCATABLE
 	movl	%ebp, %ebx
 	addl	$(LARGE_PAGE_SIZE -1), %ebx
 	andl	$LARGE_PAGE_MASK, %ebx
-#else
-	movl	$CONFIG_PHYSICAL_START, %ebx
-#endif
 
 	/* Replace the compressed data size with the uncompressed size */
 	subl	input_len(%ebp), %ebx
@@ -200,21 +196,14 @@ ENTRY(startup_64)
 	 * we were loaded at aligned to a 2M boundary. %rbp contains the
 	 * decompressed kernel start address.
 	 *
-	 * If it is a relocatable kernel then decompress and run the kernel
-	 * from load address aligned to 2MB addr, otherwise decompress and
-	 * run the kernel from CONFIG_PHYSICAL_START
+	 * Decompress and run the kernel from load address aligned to 2MB addr
 	 */
 
 	/* Start with the delta to where the kernel will run at. */
-#ifdef CONFIG_RELOCATABLE
 	leaq	startup_32(%rip) /* - $startup_32 */, %rbp
 	addq	$(LARGE_PAGE_SIZE - 1), %rbp
 	andq	$LARGE_PAGE_MASK, %rbp
 	movq	%rbp, %rbx
-#else
-	movq	$CONFIG_PHYSICAL_START, %rbp
-	movq	%rbp, %rbx
-#endif
 
 	/* Replace the compressed data size with the uncompressed size */
 	movl	input_len(%rip), %eax
diff --git a/arch/x86_64/boot/setup.S b/arch/x86_64/boot/setup.S
index 4f88510..8a70c92 100644
--- a/arch/x86_64/boot/setup.S
+++ b/arch/x86_64/boot/setup.S
@@ -158,11 +158,7 @@ cmd_line_ptr:	.long 0			# (Header version 0x0202 or later)
 ramdisk_max:	.long 0xffffffff
 kernel_alignment:  .long 0x200000       # physical addr alignment required for
 					# protected mode relocatable kernel
-#ifdef CONFIG_RELOCATABLE
 relocatable_kernel:    .byte 1
-#else
-relocatable_kernel:    .byte 0
-#endif
 pad2:                  .byte 0
 pad3:                  .word 0
 
diff --git a/arch/x86_64/defconfig b/arch/x86_64/defconfig
index 90c5a9d..d977bcb 100644
--- a/arch/x86_64/defconfig
+++ b/arch/x86_64/defconfig
@@ -174,8 +174,6 @@ CONFIG_X86_MCE_INTEL=y
 CONFIG_X86_MCE_AMD=y
 # CONFIG_KEXEC is not set
 # CONFIG_CRASH_DUMP is not set
-# CONFIG_RELOCATABLE is not set
-CONFIG_PHYSICAL_START=0x200000
 CONFIG_SECCOMP=y
 # CONFIG_CC_STACKPROTECTOR is not set
 # CONFIG_HZ_100 is not set
diff --git a/arch/x86_64/kernel/head64.c b/arch/x86_64/kernel/head64.c
index 213d90e..6c34bdd 100644
--- a/arch/x86_64/kernel/head64.c
+++ b/arch/x86_64/kernel/head64.c
@@ -62,13 +62,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 {
 	int i;
 
-	/*
-	 * Make sure kernel is aligned to 2MB address. Catching it at compile
-	 * time is better. Change your config file and compile the kernel
-	 * for a 2MB aligned address (CONFIG_PHYSICAL_START)
-	 */
-	BUILD_BUG_ON(CONFIG_PHYSICAL_START & (__KERNEL_ALIGN - 1));
-
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
diff --git a/include/asm-x86_64/page.h b/include/asm-x86_64/page.h
index 7bb725f..20662ab 100644
--- a/include/asm-x86_64/page.h
+++ b/include/asm-x86_64/page.h
@@ -78,7 +78,7 @@ extern unsigned long phys_base;
 
 #endif /* !__ASSEMBLY__ */
 
-#define __PHYSICAL_START	CONFIG_PHYSICAL_START
+#define __PHYSICAL_START	0x200000
 #define __KERNEL_ALIGN		0x200000
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	0xffffffff80000000
-- 
1.5.1.1.181.g2de0

