Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbXKSWHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbXKSWHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbXKSWGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:06:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbXKSWGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:06:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 08/18] x86 vDSO: i386 vdso32
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
Emacs: because Hell was full.
Message-Id: <20071119220545.2646F26F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:05:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This makes the i386 kernel use the new vDSO build in arch/x86/vdso/vdso32/
to replace the old one from arch/x86/kernel/.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/Makefile_32                             |    3 +-
 arch/x86/kernel/Makefile_32                      |   43 +--------------
 arch/x86/kernel/asm-offsets_32.c                 |    2 -
 arch/x86/kernel/signal_32.c                      |    5 +-
 arch/x86/kernel/sysenter_32.c                    |    6 +-
 arch/x86/kernel/vsyscall_32.lds.S                |   67 ----------------------
 arch/x86/vdso/Makefile                           |    8 ++-
 arch/x86/{kernel/vsyscall_32.S => vdso/vdso32.S} |    4 +-
 arch/x86/vdso/vdso32/note.S                      |    3 +-
 arch/x86/vdso/vdso32/sysenter.S                  |    3 +-
 arch/x86/xen/setup.c                             |    5 +-
 include/asm-x86/elf.h                            |   13 +---
 include/asm-x86/vdso.h                           |   14 +++++
 13 files changed, 37 insertions(+), 139 deletions(-)
 delete mode 100644 arch/x86/kernel/vsyscall_32.lds.S
 rename arch/x86/{kernel/vsyscall_32.S => vdso/vdso32.S} (70%)

diff --git a/arch/x86/Makefile_32 b/arch/x86/Makefile_32
index 50394da..99dc511 100644
--- a/arch/x86/Makefile_32
+++ b/arch/x86/Makefile_32
@@ -114,7 +114,8 @@ libs-y 					+= arch/x86/lib/
 core-y					+= arch/x86/kernel/ \
 					   arch/x86/mm/ \
 					   $(mcore-y)/ \
-					   arch/x86/crypto/
+					   arch/x86/crypto/ \
+					   arch/x86/vdso/
 drivers-$(CONFIG_MATH_EMULATION)	+= arch/x86/math-emu/
 drivers-$(CONFIG_PCI)			+= arch/x86/pci/
 # must be linked after kernel/
diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index 7791895..1ece642 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -33,7 +33,7 @@ obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
 obj-$(CONFIG_KPROBES)		+= kprobes_32.o
 obj-$(CONFIG_MODULES)		+= module_32.o
-obj-y				+= sysenter_32.o vsyscall_32.o
+obj-y				+= sysenter_32.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
 obj-$(CONFIG_EFI) 		+= efi_32.o efi_stub_32.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
@@ -48,44 +48,3 @@ obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
 obj-y				+= pcspeaker.o
 
 obj-$(CONFIG_SCx200)		+= scx200_32.o
-
-# vsyscall_32.o contains the vsyscall DSO images as __initdata.
-# We must build both images before we can assemble it.
-# Note: kbuild does not track this dependency due to usage of .incbin
-$(obj)/vsyscall_32.o: $(obj)/vsyscall-int80_32.so $(obj)/vsyscall-sysenter_32.so
-targets += $(foreach F,int80 sysenter,vsyscall-$F_32.o vsyscall-$F_32.so)
-targets += vsyscall-note_32.o vsyscall_32.lds
-
-$(obj)/vsyscall-%_32.o: $(src)/../vdso/vdso32/%.S
-	$(call if_changed_dep,as_o_S)
-
-# The DSO images are built using a special linker script.
-quiet_cmd_syscall = SYSCALL $@
-      cmd_syscall = $(CC) -m elf_i386 -nostdlib $(SYSCFLAGS_$(@F)) \
-		          -Wl,-T,$(filter-out FORCE,$^) -o $@
-
-export CPPFLAGS_vsyscall_32.lds += -P -C -Ui386
-
-vsyscall-flags = -shared -s -Wl,-soname=linux-gate.so.1 \
-		 $(call ld-option, -Wl$(comma)--hash-style=sysv)
-SYSCFLAGS_vsyscall-sysenter_32.so	= $(vsyscall-flags)
-SYSCFLAGS_vsyscall-int80_32.so	= $(vsyscall-flags)
-
-$(obj)/vsyscall-int80_32.so $(obj)/vsyscall-sysenter_32.so: \
-$(obj)/vsyscall-%.so: $(src)/vsyscall_32.lds \
-		      $(obj)/vsyscall-%.o $(obj)/vsyscall-note_32.o FORCE
-	$(call if_changed,syscall)
-
-# We also create a special relocatable object that should mirror the symbol
-# table and layout of the linked DSO.  With ld -R we can then refer to
-# these symbols in the kernel code rather than hand-coded addresses.
-extra-y += vsyscall-syms.o
-$(obj)/built-in.o: $(obj)/vsyscall-syms.o
-$(obj)/built-in.o: ld_flags += -R $(obj)/vsyscall-syms.o
-
-SYSCFLAGS_vsyscall-syms.o = -r
-$(obj)/vsyscall-syms.o: $(src)/vsyscall_32.lds \
-			$(obj)/vsyscall-sysenter_32.o $(obj)/vsyscall-note_32.o FORCE
-	$(call if_changed,syscall)
-
-
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index c578a2b..2784f2c 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -111,8 +111,6 @@ void foo(void)
 	DEFINE(PTRS_PER_PMD, PTRS_PER_PMD);
 	DEFINE(PTRS_PER_PGD, PTRS_PER_PGD);
 
-	DEFINE(VDSO_PRELINK_asm, VDSO_PRELINK);
-
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
 
 #ifdef CONFIG_PARAVIRT
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 9bdd830..696cb89 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -23,6 +23,7 @@
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
+#include <asm/vdso.h>
 #include "sigframe_32.h"
 
 #define DEBUG_SIG 0
@@ -355,7 +356,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 	}
 
 	if (current->binfmt->hasvdso)
-		restorer = (void *)VDSO_SYM(&__kernel_sigreturn);
+		restorer = VDSO32_SYMBOL(current->mm->context.vdso, sigreturn);
 	else
 		restorer = (void *)&frame->retcode;
 	if (ka->sa.sa_flags & SA_RESTORER)
@@ -452,7 +453,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		goto give_sigsegv;
 
 	/* Set up to return from userspace.  */
-	restorer = (void *)VDSO_SYM(&__kernel_rt_sigreturn);
+	restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
 	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = ka->sa.sa_restorer;
 	err |= __put_user(restorer, &frame->pretcode);
diff --git a/arch/x86/kernel/sysenter_32.c b/arch/x86/kernel/sysenter_32.c
index 5a2d951..85c52d2 100644
--- a/arch/x86/kernel/sysenter_32.c
+++ b/arch/x86/kernel/sysenter_32.c
@@ -23,6 +23,7 @@
 #include <asm/unistd.h>
 #include <asm/elf.h>
 #include <asm/tlbflush.h>
+#include <asm/vdso.h>
 
 enum {
 	VDSO_DISABLED = 0,
@@ -259,9 +260,6 @@ int __init sysenter_setup(void)
 	return 0;
 }
 
-/* Defined in vsyscall-sysenter.S */
-extern void SYSENTER_RETURN;
-
 /* Setup a VMA at program startup for the vsyscall page */
 int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
 {
@@ -308,7 +306,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
 
 	current->mm->context.vdso = (void *)addr;
 	current_thread_info()->sysenter_return =
-		(void *)VDSO_SYM(&SYSENTER_RETURN);
+		VDSO32_SYMBOL(addr, SYSENTER_RETURN);
 
   up_fail:
 	up_write(&mm->mmap_sem);
diff --git a/arch/x86/kernel/vsyscall_32.lds.S b/arch/x86/kernel/vsyscall_32.lds.S
deleted file mode 100644
index 4a8b0ed..0000000
--- a/arch/x86/kernel/vsyscall_32.lds.S
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- * Linker script for vsyscall DSO.  The vsyscall page is an ELF shared
- * object prelinked to its virtual address, and with only one read-only
- * segment (that fits in one page).  This script controls its layout.
- */
-#include <asm/asm-offsets.h>
-
-SECTIONS
-{
-  . = VDSO_PRELINK_asm + SIZEOF_HEADERS;
-
-  .hash           : { *(.hash) }		:text
-  .gnu.hash       : { *(.gnu.hash) }
-  .dynsym         : { *(.dynsym) }
-  .dynstr         : { *(.dynstr) }
-  .gnu.version    : { *(.gnu.version) }
-  .gnu.version_d  : { *(.gnu.version_d) }
-  .gnu.version_r  : { *(.gnu.version_r) }
-
-  /* This linker script is used both with -r and with -shared.
-     For the layouts to match, we need to skip more than enough
-     space for the dynamic symbol table et al.  If this amount
-     is insufficient, ld -shared will barf.  Just increase it here.  */
-  . = VDSO_PRELINK_asm + 0x400;
-
-  .text           : { *(.text) }		:text =0x90909090
-  .note		  : { *(.note.*) }		:text :note
-  .eh_frame_hdr   : { *(.eh_frame_hdr) }	:text :eh_frame_hdr
-  .eh_frame       : { KEEP (*(.eh_frame)) }	:text
-  .dynamic        : { *(.dynamic) }		:text :dynamic
-  .useless        : {
-  	*(.got.plt) *(.got)
-	*(.data .data.* .gnu.linkonce.d.*)
-	*(.dynbss)
-	*(.bss .bss.* .gnu.linkonce.b.*)
-  }						:text
-}
-
-/*
- * We must supply the ELF program headers explicitly to get just one
- * PT_LOAD segment, and set the flags explicitly to make segments read-only.
- */
-PHDRS
-{
-  text PT_LOAD FILEHDR PHDRS FLAGS(5); /* PF_R|PF_X */
-  dynamic PT_DYNAMIC FLAGS(4); /* PF_R */
-  note PT_NOTE FLAGS(4); /* PF_R */
-  eh_frame_hdr 0x6474e550; /* PT_GNU_EH_FRAME, but ld doesn't match the name */
-}
-
-/*
- * This controls what symbols we export from the DSO.
- */
-VERSION
-{
-  LINUX_2.5 {
-    global:
-    	__kernel_vsyscall;
-    	__kernel_sigreturn;
-    	__kernel_rt_sigreturn;
-
-    local: *;
-  };
-}
-
-/* The ELF entry point can be used to set the AT_SYSINFO value.  */
-ENTRY(__kernel_vsyscall);
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index a1e0418..cabb0c2 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -14,7 +14,8 @@ vdso-install-$(VDSO32-y)	+= $(vdso32-y:=.so)
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
 
 # files to link into kernel
-obj-y := vma.o vdso.o
+obj-$(VDSO64-y)			+= vma.o vdso.o
+obj-$(CONFIG_X86_32)		+= vdso32.o
 
 vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
 
@@ -52,7 +53,7 @@ $(obj)/vclock_gettime.o: KBUILD_CFLAGS = $(CFL)
 $(obj)/vgetcpu.o: KBUILD_CFLAGS = $(CFL)
 
 targets += vdso-syms.lds
-obj-y += vdso-syms.lds
+obj-$(VDSO64-y)			+= vdso-syms.lds
 
 #
 # Match symbols in the DSO that look like VDSO*; produce a file of constants.
@@ -68,6 +69,7 @@ $(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
 #
 # Build multiple 32-bit vDSO images to choose from at boot time.
 #
+obj-$(VDSO32-y)			+= vdso32-syms.lds
 vdso32.so-$(CONFIG_X86_32)	+= int80
 vdso32.so-$(VDSO32-y)		+= sysenter
 
@@ -84,6 +86,8 @@ targets += vdso32/note.o $(vdso32.so-y:%=vdso32/%.o)
 
 extra-y	+= $(vdso32.so-y:%=vdso32-%.so)
 
+$(obj)/vdso32.o: $(vdso32.so-y:%=$(obj)/vdso32-%.so)
+
 $(vdso32.so-y:%=$(obj)/vdso32-%.so.dbg): asflags-$(CONFIG_X86_64) += -m32
 
 $(vdso32.so-y:%=$(obj)/vdso32-%.so.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
diff --git a/arch/x86/kernel/vsyscall_32.S b/arch/x86/vdso/vdso32.S
similarity index 70%
rename from arch/x86/kernel/vsyscall_32.S
rename to arch/x86/vdso/vdso32.S
index a5ab3dc..cab020c 100644
--- a/arch/x86/kernel/vsyscall_32.S
+++ b/arch/x86/vdso/vdso32.S
@@ -4,12 +4,12 @@ __INITDATA
 
 	.globl vsyscall_int80_start, vsyscall_int80_end
 vsyscall_int80_start:
-	.incbin "arch/x86/kernel/vsyscall-int80_32.so"
+	.incbin "arch/x86/vdso/vdso32-int80.so"
 vsyscall_int80_end:
 
 	.globl vsyscall_sysenter_start, vsyscall_sysenter_end
 vsyscall_sysenter_start:
-	.incbin "arch/x86/kernel/vsyscall-sysenter_32.so"
+	.incbin "arch/x86/vdso/vdso32-sysenter.so"
 vsyscall_sysenter_end:
 
 __FINIT
diff --git a/arch/x86/vdso/vdso32/note.S b/arch/x86/vdso/vdso32/note.S
index 0cf934f..c83f257 100644
--- a/arch/x86/vdso/vdso32/note.S
+++ b/arch/x86/vdso/vdso32/note.S
@@ -35,10 +35,9 @@ ELFNOTE_END
 
 #include "../../xen/vdso.h"	/* Defines VDSO_NOTE_NONEGSEG_BIT.  */
 
-	.globl VDSO_NOTE_MASK
 ELFNOTE_START(GNU, 2, "a")
 	.long 1			/* ncaps */
-VDSO_NOTE_MASK:
+VDSO32_NOTE_MASK:		/* Symbol used by arch/x86/xen/setup.c */
 	.long 0			/* mask */
 	.byte VDSO_NOTE_NONEGSEG_BIT; .asciz "nosegneg"	/* bit, name */
 ELFNOTE_END
diff --git a/arch/x86/vdso/vdso32/sysenter.S b/arch/x86/vdso/vdso32/sysenter.S
index 4b98fc4..109bfa3 100644
--- a/arch/x86/vdso/vdso32/sysenter.S
+++ b/arch/x86/vdso/vdso32/sysenter.S
@@ -45,8 +45,7 @@ __kernel_vsyscall:
 	/* 14: System call restart point is here! (SYSENTER_RETURN-2) */
 	jmp .Lenter_kernel
 	/* 16: System call normal return point is here! */
-	.globl SYSENTER_RETURN	/* Symbol used by sysenter.c  */
-SYSENTER_RETURN:
+VDSO32_SYSENTER_RETURN:	/* Symbol used by sysenter.c via vdso32-syms.h */
 	pop %ebp
 .Lpop_ebp:
 	pop %edx
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index f84e772..fd91568 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -10,6 +10,7 @@
 #include <linux/pm.h>
 
 #include <asm/elf.h>
+#include <asm/vdso.h>
 #include <asm/e820.h>
 #include <asm/setup.h>
 #include <asm/xen/hypervisor.h>
@@ -61,10 +62,8 @@ static void xen_idle(void)
  */
 static void fiddle_vdso(void)
 {
-	extern u32 VDSO_NOTE_MASK; /* See ../kernel/vsyscall-note.S.  */
 	extern char vsyscall_int80_start;
-	u32 *mask = (u32 *) ((unsigned long) &VDSO_NOTE_MASK - VDSO_PRELINK +
-			     &vsyscall_int80_start);
+	u32 *mask = VDSO32_SYMBOL(&vsyscall_int80_start, NOTE_MASK);
 	*mask |= 1 << VDSO_NOTE_NONEGSEG_BIT;
 }
 
diff --git a/include/asm-x86/elf.h b/include/asm-x86/elf.h
index ec42a4d..0dd21ee 100644
--- a/include/asm-x86/elf.h
+++ b/include/asm-x86/elf.h
@@ -78,6 +78,7 @@ typedef struct user_fxsr_struct elf_fpxregset_t;
 #include <asm/processor.h>
 #include <asm/system.h>		/* for savesegment */
 #include <asm/desc.h>
+#include <asm/vdso.h>
 
 /*
  * This is used to ensure we don't load something for the wrong architecture.
@@ -247,17 +248,9 @@ extern int dump_task_extended_fpu (struct task_struct *,
 
 #define VDSO_HIGH_BASE		(__fix_to_virt(FIX_VDSO))
 #define VDSO_CURRENT_BASE	((unsigned long)current->mm->context.vdso)
-#define VDSO_PRELINK		0
 
-#define VDSO_SYM(x) \
-		(VDSO_CURRENT_BASE + (unsigned long)(x) - VDSO_PRELINK)
-
-#define VDSO_HIGH_EHDR		((const struct elfhdr *) VDSO_HIGH_BASE)
-#define VDSO_EHDR		((const struct elfhdr *) VDSO_CURRENT_BASE)
-
-extern void __kernel_vsyscall;
-
-#define VDSO_ENTRY		VDSO_SYM(&__kernel_vsyscall)
+#define VDSO_ENTRY \
+	((unsigned long) VDSO32_SYMBOL(VDSO_CURRENT_BASE, vsyscall))
 
 /* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 
diff --git a/include/asm-x86/vdso.h b/include/asm-x86/vdso.h
index 9379ec0..629bcb6 100644
--- a/include/asm-x86/vdso.h
+++ b/include/asm-x86/vdso.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_VDSO_H
 #define _ASM_X86_VDSO_H	1
 
+#ifdef CONFIG_X86_64
 extern const char VDSO64_PRELINK[];
 
 /*
@@ -10,5 +11,18 @@ extern const char VDSO64_PRELINK[];
 #define VDSO64_SYMBOL(base, name) ({		\
 	extern const char VDSO64_##name[];	\
 	(void *) (VDSO64_##name - VDSO64_PRELINK + (unsigned long) (base)); })
+#endif
+
+#if defined CONFIG_X86_32 || defined CONFIG_COMPAT
+extern const char VDSO32_PRELINK[];
+
+/*
+ * Given a pointer to the vDSO image, find the pointer to VDSO32_name
+ * as that symbol is defined in the vDSO sources or linker script.
+ */
+#define VDSO32_SYMBOL(base, name) ({		\
+	extern const char VDSO32_##name[];	\
+	(void *) (VDSO32_##name - VDSO32_PRELINK + (unsigned long) (base)); })
+#endif
 
 #endif	/* asm-x86/vdso.h */
