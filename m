Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbXI0MNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbXI0MNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbXI0MNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:13:38 -0400
Received: from styx.suse.cz ([82.119.242.94]:34840 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750712AbXI0MNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:13:37 -0400
Date: Thu, 27 Sep 2007 14:13:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>, linux-kernel@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc8-mm1 -- powerpc link failure
In-Reply-To: <20070927120308.GJ2213@shadowen.org>
Message-ID: <Pine.LNX.4.64.0709271408170.7567@jikos.suse.cz>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
 <20070925134653.GB8447@shadowen.org> <Pine.LNX.4.64.0709251715530.7567@jikos.suse.cz>
 <20070927120308.GJ2213@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007, Andy Whitcroft wrote:

> Ok, this problem seems to still persist in 2.6.23-rc8-mm2.  It seems we 
> have three options from here:
> 1) update the compiler support list to exclude these compilers, or
> 2) back this change out, or
> 3) switch to the version not using __weak.
> The latter seems to be the least intrusive change.  As no-one closer to 
> the problem is stepping up to make the decision I will propose we go 
> with the third option here.

Andrew,

if you agree with Andy that we should support compilers that don't work 
with __weak, please drop i386-and-x86_64-randomize-brk.patch and replace 
it with the one below instead (this has been already posted at 
http://lkml.org/lkml/2007/8/31/113). Thanks.


From: Jiri Kosina <jkosina@suse.cz>

i386 and x86_64: randomize brk()

This patch randomizes the location of the heap (brk) for i386 and x86_64. 
The range is randomized in the range starting at current brk location up 
to 0x02000000 offset for both architectures. This, together with 
pie-executable-randomization.patch and 
pie-executable-randomization-fix.patch, should make the address space 
randomization on i386 and x86_64 complete.

The empty stubs are not added for architectures that don't support ELF 
binaries, namely blackfin, h8300, m68knommu and v850.

Arjan says:

This is known to break older versions of some emacs variants, whose dumper 
code assumed that the last variable declared in the program is equal to 
the start of the dynamically allocated memory region.

(The dumper is the code where emacs effectively dumps core at the end of 
it's compilation stage; this coredump is then loaded as the main program 
during normal use)

iirc this was 5 years or so; we found this way back when I was at RH and 
we first did the security stuff there (including this brk randomization).  
It wasn't all variants of emacs, and it got fixed as a result (I vaguely 
remember that emacs already had code to deal with it for other archs/oses, 
just ifdeffed wrongly).

It's a rare and wrong assumption as a general thing, just on x86 it mostly 
happened to be true (but to be honest, it'll break too if gcc does 
something fancy or if the linker does a non-standard order).  Still its 
something we should at least document.

Note 2: afaik it only broke the emacs *build*.  I'm not 100% sure about 
that (it IS 5 years ago) though.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
index 8466471..ba8ad15 100644
--- a/arch/i386/kernel/process.c
+++ b/arch/i386/kernel/process.c
@@ -949,3 +949,17 @@ unsigned long arch_align_stack(unsigned long sp)
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+void arch_randomize_brk(void)
+{
+	unsigned long new_brk;
+	unsigned long range_start;
+	unsigned long range_end;
+
+	range_start = current->mm->brk;
+	range_end = range_start + 0x02000000;
+	new_brk = randomize_range(range_start, range_end, 0);
+	if (new_brk)
+		current->mm->brk = current->mm->start_brk = new_brk;
+}
+
diff --git a/arch/x86_64/ia32/ia32_binfmt.c b/arch/x86_64/ia32/ia32_binfmt.c
index dffd2ac..ccc4350 100644
--- a/arch/x86_64/ia32/ia32_binfmt.c
+++ b/arch/x86_64/ia32/ia32_binfmt.c
@@ -262,6 +262,7 @@ static void elf32_init(struct pt_regs *);
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 #define arch_setup_additional_pages syscall32_setup_pages
 extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
+extern void arch_randomize_brk(void);
 
 #include "../../../fs/binfmt_elf.c" 
 
diff --git a/arch/x86_64/kernel/process.c b/arch/x86_64/kernel/process.c
index 2842f50..fe7203b 100644
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -902,3 +902,17 @@ unsigned long arch_align_stack(unsigned long sp)
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+void arch_randomize_brk(void)
+{
+	unsigned long new_brk;
+	unsigned long range_start;
+	unsigned long range_end;
+
+	range_start = current->mm->brk;
+	range_end = range_start + 0x02000000;
+	new_brk = randomize_range(range_start, range_end, 0);
+	if (new_brk)
+		current->mm->brk = current->mm->start_brk = new_brk;
+}
+
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d65f1d9..4c92461 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1073,6 +1073,9 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->end_data = end_data;
 	current->mm->start_stack = bprm->p;
 
+	if (current->flags & PF_RANDOMIZE)
+		arch_randomize_brk();
+
 	if (current->personality & MMAP_PAGE_ZERO) {
 		/* Why this, you ask???  Well SVr4 maps page 0 as read-only,
 		   and some applications "depend" upon this behavior.
diff --git a/include/asm-alpha/elf.h b/include/asm-alpha/elf.h
index 6c2d78f..18210cc 100644
--- a/include/asm-alpha/elf.h
+++ b/include/asm-alpha/elf.h
@@ -163,5 +163,9 @@ extern int alpha_l3_cacheshape;
     NEW_AUX_ENT(AT_L3_CACHESHAPE, alpha_l3_cacheshape);		\
   } while (0)
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_ALPHA_ELF_H */
diff --git a/include/asm-arm/elf.h b/include/asm-arm/elf.h
index ec1c685..eeeee3f 100644
--- a/include/asm-arm/elf.h
+++ b/include/asm-arm/elf.h
@@ -116,4 +116,8 @@ extern char elf_platform[];
 
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
diff --git a/include/asm-avr32/elf.h b/include/asm-avr32/elf.h
index d334b49..61b7d81 100644
--- a/include/asm-avr32/elf.h
+++ b/include/asm-avr32/elf.h
@@ -107,4 +107,8 @@ typedef struct user_fpu_struct elf_fpregset_t;
 #define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX_32BIT)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* __ASM_AVR32_ELF_H */
diff --git a/include/asm-cris/elf.h b/include/asm-cris/elf.h
index 96a40c1..10607c7 100644
--- a/include/asm-cris/elf.h
+++ b/include/asm-cris/elf.h
@@ -93,4 +93,8 @@ typedef unsigned long elf_fpregset_t;
 
 #endif /* __KERNEL__ */
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
diff --git a/include/asm-frv/elf.h b/include/asm-frv/elf.h
index 7df58a3..07df9dd 100644
--- a/include/asm-frv/elf.h
+++ b/include/asm-frv/elf.h
@@ -141,4 +141,8 @@ do {											\
 #define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
diff --git a/include/asm-i386/elf.h b/include/asm-i386/elf.h
index b32df3a..5935d4c 100644
--- a/include/asm-i386/elf.h
+++ b/include/asm-i386/elf.h
@@ -160,4 +160,6 @@ do if (vdso_enabled) {							\
 
 #endif
 
+extern void arch_randomize_brk(void);
+
 #endif
diff --git a/include/asm-ia64/elf.h b/include/asm-ia64/elf.h
index 25f9835..3b84b0d 100644
--- a/include/asm-ia64/elf.h
+++ b/include/asm-ia64/elf.h
@@ -249,4 +249,8 @@ do {									\
 
 #endif /* __KERNEL__ */
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* _ASM_IA64_ELF_H */
diff --git a/include/asm-m32r/elf.h b/include/asm-m32r/elf.h
index bbee8b2..33a5244 100644
--- a/include/asm-m32r/elf.h
+++ b/include/asm-m32r/elf.h
@@ -133,4 +133,8 @@ typedef elf_fpreg_t elf_fpregset_t;
 #define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif  /* _ASM_M32R__ELF_H */
diff --git a/include/asm-m68k/elf.h b/include/asm-m68k/elf.h
index eb63b85..f6ff4fe 100644
--- a/include/asm-m68k/elf.h
+++ b/include/asm-m68k/elf.h
@@ -118,4 +118,8 @@ typedef struct user_m68kfp_struct elf_fpregset_t;
 #define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
diff --git a/include/asm-mips/elf.h b/include/asm-mips/elf.h
index e7d95d4..571cd80 100644
--- a/include/asm-mips/elf.h
+++ b/include/asm-mips/elf.h
@@ -372,4 +372,8 @@ extern int dump_task_fpu(struct task_struct *, elf_fpregset_t *);
 #define ELF_ET_DYN_BASE         (TASK_SIZE / 3 * 2)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* _ASM_ELF_H */
diff --git a/include/asm-parisc/elf.h b/include/asm-parisc/elf.h
index f628ac7..9807cae 100644
--- a/include/asm-parisc/elf.h
+++ b/include/asm-parisc/elf.h
@@ -344,4 +344,8 @@ struct pt_regs;	/* forward declaration... */
 #define ELF_HWCAP	0
 /* (boot_cpu_data.x86_capability) */
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
diff --git a/include/asm-powerpc/elf.h b/include/asm-powerpc/elf.h
index de50799..af45d0e 100644
--- a/include/asm-powerpc/elf.h
+++ b/include/asm-powerpc/elf.h
@@ -422,4 +422,8 @@ extern void arch_write_notes(struct file *file);
 #define ARCH_HAVE_EXTRA_ELF_NOTES
 #endif /* CONFIG_PPC_CELL */
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* _ASM_POWERPC_ELF_H */
diff --git a/include/asm-s390/elf.h b/include/asm-s390/elf.h
index 91d0632..0a32ac3 100644
--- a/include/asm-s390/elf.h
+++ b/include/asm-s390/elf.h
@@ -216,4 +216,8 @@ do {							\
 #endif /* __s390x__ */
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
diff --git a/include/asm-sh/elf.h b/include/asm-sh/elf.h
index 43ca244..f055a68 100644
--- a/include/asm-sh/elf.h
+++ b/include/asm-sh/elf.h
@@ -140,4 +140,8 @@ do {								\
 } while (0)
 #endif /* CONFIG_VSYSCALL */
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* __ASM_SH_ELF_H */
diff --git a/include/asm-sh64/elf.h b/include/asm-sh64/elf.h
index f994286..5d6dd4b 100644
--- a/include/asm-sh64/elf.h
+++ b/include/asm-sh64/elf.h
@@ -104,4 +104,8 @@ typedef struct user_fpu_struct elf_fpregset_t;
 #define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX_32BIT)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* __ASM_SH64_ELF_H */
diff --git a/include/asm-sparc/elf.h b/include/asm-sparc/elf.h
index aaf6ef4..94b273d 100644
--- a/include/asm-sparc/elf.h
+++ b/include/asm-sparc/elf.h
@@ -168,4 +168,8 @@ do {	unsigned long *dest = &(__elf_regs[0]);		\
 
 #endif /* __KERNEL__ */
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* !(__ASMSPARC_ELF_H) */
diff --git a/include/asm-sparc64/elf.h b/include/asm-sparc64/elf.h
index 303d85e..8afe25f 100644
--- a/include/asm-sparc64/elf.h
+++ b/include/asm-sparc64/elf.h
@@ -190,4 +190,8 @@ do {	unsigned long new_flags = current_thread_info()->flags; \
 } while (0)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* !(__ASM_SPARC64_ELF_H) */
diff --git a/include/asm-um/elf-x86_64.h b/include/asm-um/elf-x86_64.h
index 8a8246d..e1d664e 100644
--- a/include/asm-um/elf-x86_64.h
+++ b/include/asm-um/elf-x86_64.h
@@ -81,6 +81,10 @@ extern long elf_aux_hwcap;
 
 #define SET_PERSONALITY(ex, ibcs2) do ; while(0)
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
 
 /*
diff --git a/include/asm-x86_64/elf.h b/include/asm-x86_64/elf.h
index b4fbe47..5a1adf9 100644
--- a/include/asm-x86_64/elf.h
+++ b/include/asm-x86_64/elf.h
@@ -177,4 +177,6 @@ do if (vdso_enabled) {						\
 
 #endif
 
+extern void arch_randomize_brk(void);
+
 #endif
diff --git a/include/asm-xtensa/elf.h b/include/asm-xtensa/elf.h
index 1569b53..10e60bf 100644
--- a/include/asm-xtensa/elf.h
+++ b/include/asm-xtensa/elf.h
@@ -222,5 +222,9 @@ extern void do_save_fpregs (elf_fpregset_t*, struct pt_regs*,
 extern int do_restore_fpregs (elf_fpregset_t*, struct pt_regs*,
 			      struct task_struct*);
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _XTENSA_ELF_H */
