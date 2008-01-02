Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbYABVM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbYABVM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbYABVMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:12:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbYABVMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:12:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH -mm] x86 compat_binfmt_elf
X-Fcc: ~/Mail/linus
In-Reply-To: Roland McGrath's message of  Wednesday, 2 January 2008 13:08:31 -0800 <20080102210831.9F80426F9A0@magilla.localdomain>
References: <20071223183920.GA13976@elte.hu>
	<20071223211603.3FFB126F8E7@magilla.localdomain>
	<20071230163614.GB1384@elte.hu>
	<20080102044157.A5CC526F99F@magilla.localdomain>
	<20080102111431.GD14731@elte.hu>
	<20080102191030.GA11217@uranus.ravnborg.org>
	<20080102210831.9F80426F9A0@magilla.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080102211243.D7CFA26F9A0@magilla.localdomain>
Date: Wed,  2 Jan 2008 13:12:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the earlier patch by the same title already in x86/mm:

	commit a9014d2dfcb253fb3ce5f4e3318849f743b85427
	Author: Roland McGrath <roland@redhat.com>

	    x86 compat_binfmt_elf

It requires the new patch I just posted, titled "compat_binfmt_elf Kconfig".


Thanks,
Roland
---
x86 compat_binfmt_elf

This switches x86-64's 32-bit ELF support to use the shared
fs/compat_binfmt_elf.c code instead of our own ia32_binfmt.c.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig             |    1 +
 arch/x86/ia32/Makefile       |    3 +-
 arch/x86/vdso/vdso32-setup.c |   33 ++++++++++++++++
 include/asm-x86/elf.h        |   88 ++++++++++++++++++++++++++++++-----------
 4 files changed, 99 insertions(+), 26 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 66d38bf..0000000 100644  
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1546,6 +1546,7 @@ source "fs/Kconfig.binfmt"
 config IA32_EMULATION
 	bool "IA32 Emulation"
 	depends on X86_64
+	select COMPAT_BINFMT_ELF
 	help
 	  Include code to run 32-bit programs under a 64-bit kernel. You should
 	  likely turn this on, unless you're 100% sure that you don't have any
diff --git a/arch/x86/ia32/Makefile b/arch/x86/ia32/Makefile
index 93a6fda..0000000 100644  
--- a/arch/x86/ia32/Makefile
+++ b/arch/x86/ia32/Makefile
@@ -2,8 +2,7 @@
 # Makefile for the ia32 kernel emulation subsystem.
 #
 
-obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o \
-	ia32_binfmt.o
+obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o
 
 sysv-$(CONFIG_SYSVIPC) := ipc32.o
 obj-$(CONFIG_IA32_EMULATION) += $(sysv-y)
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index e0feb66..0000000 100644  
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -377,6 +377,39 @@ int arch_setup_additional_pages(struct l
 
 __initcall(sysenter_setup);
 
+#ifdef CONFIG_SYSCTL
+/* Register vsyscall32 into the ABI table */
+#include <linux/sysctl.h>
+
+static ctl_table abi_table2[] = {
+	{
+		.procname	= "vsyscall32",
+		.data		= &sysctl_vsyscall32,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
+	{}
+};
+
+static ctl_table abi_root_table2[] = {
+	{
+		.ctl_name = CTL_ABI,
+		.procname = "abi",
+		.mode = 0555,
+		.child = abi_table2
+	},
+	{}
+};
+
+static __init int ia32_binfmt_init(void)
+{
+	register_sysctl_table(abi_root_table2);
+	return 0;
+}
+__initcall(ia32_binfmt_init);
+#endif
+
 #else  /* CONFIG_X86_32 */
 
 const char *arch_vma_name(struct vm_area_struct *vma)
diff --git a/include/asm-x86/elf.h b/include/asm-x86/elf.h
index d6bf742..0000000 100644  
--- a/include/asm-x86/elf.h
+++ b/include/asm-x86/elf.h
@@ -73,6 +73,9 @@ typedef struct user_fxsr_struct elf_fpxr
 #endif
 
 #ifdef __KERNEL__
+#include <asm/vdso.h>
+
+extern unsigned int vdso_enabled;
 
 /*
  * This is used to ensure we don't load something for the wrong architecture.
@@ -84,7 +87,6 @@ typedef struct user_fxsr_struct elf_fpxr
 #include <asm/processor.h>
 #include <asm/system.h>		/* for savesegment */
 #include <asm/desc.h>
-#include <asm/vdso.h>
 
 #define elf_check_arch(x)	elf_check_arch_ia32(x)
 
@@ -106,7 +108,6 @@ typedef struct user_fxsr_struct elf_fpxr
 
 #define ELF_PLATFORM	(utsname()->machine)
 #define set_personality_64bit()	do { } while (0)
-extern unsigned int vdso_enabled;
 
 #else /* CONFIG_X86_32 */
 
@@ -118,29 +119,57 @@ extern unsigned int vdso_enabled;
 #define elf_check_arch(x) \
 	((x)->e_machine == EM_X86_64)
 
+#define compat_elf_check_arch(x)	elf_check_arch_ia32(x)
+
+static inline void start_ia32_thread(struct pt_regs *regs, u32 ip, u32 sp)
+{
+	asm volatile("movl %0,%%fs" :: "r" (0));
+	asm volatile("movl %0,%%es; movl %0,%%ds" : : "r" (__USER32_DS));
+	load_gs_index(0);
+	regs->ip = ip;
+	regs->sp = sp;
+	regs->flags = X86_EFLAGS_IF;
+	regs->cs = __USER32_CS;
+	regs->ss = __USER32_DS;
+}
+
+static inline void elf_common_init(struct thread_struct *t,
+				   struct pt_regs *regs, const u16 ds)
+{
+	regs->ax = regs->bx = regs->cx = regs->dx = 0;
+	regs->si = regs->di = regs->bp = 0;
+	regs->r8 = regs->r9 = regs->r10 = regs->r11 = 0;
+	regs->r12 = regs->r13 = regs->r14 = regs->r15 = 0;
+	t->fs = t->gs = 0;
+	t->fsindex = t->gsindex = 0;
+	t->ds = t->es = ds;
+}
+
 #define ELF_PLAT_INIT(_r, load_addr)	do {		  \
-	struct task_struct *cur = current;		  \
-	(_r)->bx = 0; (_r)->cx = 0; (_r)->dx = 0;	  \
-	(_r)->si = 0; (_r)->di = 0; (_r)->bp = 0;	  \
-	(_r)->ax = 0;					  \
-	(_r)->r8 = 0;					  \
-	(_r)->r9 = 0;					  \
-	(_r)->r10 = 0;					  \
-	(_r)->r11 = 0;					  \
-	(_r)->r12 = 0;					  \
-	(_r)->r13 = 0;					  \
-	(_r)->r14 = 0;					  \
-	(_r)->r15 = 0;					  \
-	cur->thread.fs = 0; cur->thread.gs = 0;		  \
-	cur->thread.fsindex = 0; cur->thread.gsindex = 0; \
-	cur->thread.ds = 0; cur->thread.es = 0;		  \
+	elf_common_init(&current->thread, _r, 0);	  \
 	clear_thread_flag(TIF_IA32);			  \
 } while (0)
 
+#define	COMPAT_ELF_PLAT_INIT(regs, load_addr)	\
+	elf_common_init(&current->thread, regs, __USER_DS)
+#define	compat_start_thread(regs, ip, sp)	do {		\
+		start_ia32_thread(regs, ip, sp);		\
+		set_fs(USER_DS);				\
+	} while (0)
+#define COMPAT_SET_PERSONALITY(ex, ibcs2)	do {		\
+		if (test_thread_flag(TIF_IA32))			\
+			clear_thread_flag(TIF_ABI_PENDING);	\
+		else						\
+			set_thread_flag(TIF_ABI_PENDING);	\
+		current->personality |= force_personality32;	\
+	} while (0)
+#define COMPAT_ELF_PLATFORM			("i686")
+
 /* I'm not sure if we can use '-' here */
 #define ELF_PLATFORM       ("x86_64")
 extern void set_personality_64bit(void);
-extern int vdso_enabled;
+extern unsigned int sysctl_vsyscall32;
+extern int force_personality32;
 
 #endif /* !CONFIG_X86_32 */
 
@@ -179,17 +208,19 @@ extern int vdso_enabled;
 
 struct task_struct;
 
+#define	ARCH_DLINFO_IA32(vdso_enabled) \
+do if (vdso_enabled) {							\
+		NEW_AUX_ENT(AT_SYSINFO,	VDSO_ENTRY);			\
+		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_CURRENT_BASE);	\
+} while (0)
+
 #ifdef CONFIG_X86_32
 
 #define VDSO_HIGH_BASE		(__fix_to_virt(FIX_VDSO))
 
-/* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
+#define ARCH_DLINFO		ARCH_DLINFO_IA32(vdso_enabled)
 
-#define ARCH_DLINFO \
-do if (vdso_enabled) {							\
-		NEW_AUX_ENT(AT_SYSINFO,	VDSO_ENTRY);			\
-		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_CURRENT_BASE);	\
-} while (0)
+/* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 
 #else /* CONFIG_X86_32 */
 
@@ -203,6 +234,12 @@ do if (vdso_enabled) {						\
 	NEW_AUX_ENT(AT_SYSINFO_EHDR,(unsigned long)current->mm->context.vdso);\
 } while (0)
 
+#define AT_SYSINFO		32
+
+#define COMPAT_ARCH_DLINFO	ARCH_DLINFO_IA32(sysctl_vsyscall32)
+
+#define COMPAT_ELF_ET_DYN_BASE	(TASK_UNMAPPED_BASE + 0x1000000)
+
 #endif /* !CONFIG_X86_32 */
 
 #define VDSO_CURRENT_BASE	((unsigned long)current->mm->context.vdso)
@@ -216,6 +253,9 @@ struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 				       int executable_stack);
 
+extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
+#define compat_arch_setup_additional_pages	syscall32_setup_pages
+
 extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 #define arch_randomize_brk arch_randomize_brk
 
