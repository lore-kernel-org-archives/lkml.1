Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbXKSWLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbXKSWLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbXKSWIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:08:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbXKSWIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:08:01 -0500
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
Subject: [PATCH 15/18] x86 vDSO: consolidate vdso32
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071119220644.F41CA26F8C1@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:06:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This makes x86_64's ia32 emulation support share the sources used in the
32-bit kernel for the 32-bit vDSO and much of its setup code.

The 32-bit vDSO mapping now behaves the same on x86_64 as on native 32-bit.
The abi.syscall32 sysctl on x86_64 now takes the same values that
vm.vdso_enabled takes on the 32-bit kernel.  That is, 1 means a randomized
vDSO location, 2 means the fixed old address.  The CONFIG_COMPAT_VDSO
option is now available to make this the default setting, the same meaning
it has for the 32-bit kernel.  (This does not affect the 64-bit vDSO.)

The argument vdso32=[012] can be used on both 32-bit and 64-bit kernels to
set this paramter at boot time.  The vdso=[012] argument still does this
same thing on the 32-bit kernel.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 Documentation/kernel-parameters.txt |    5 ++
 arch/x86/Kconfig                    |    4 +-
 arch/x86/ia32/Makefile              |    2 +-
 arch/x86/ia32/ia32_binfmt.c         |    9 +--
 arch/x86/ia32/ia32_signal.c         |    8 ++-
 arch/x86/vdso/Makefile              |    2 +-
 arch/x86/vdso/vdso32-setup.c        |  119 +++++++++++++++++++++++++++--------
 arch/x86/vdso/vdso32.S              |   16 +++--
 arch/x86/xen/setup.c                |    4 +-
 include/asm-x86/elf.h               |   23 ++++---
 10 files changed, 137 insertions(+), 55 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 33121d6..2374e37 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1951,6 +1951,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			vdso=1: enable VDSO (default)
 			vdso=0: disable VDSO mapping
 
+	vdso32=		[X86-32,X86-64]
+			vdso32=2: enable compat VDSO (default with COMPAT_VDSO)
+			vdso32=1: enable 32-bit VDSO (default)
+			vdso32=0: disable 32-bit VDSO mapping
+
 	vector=		[IA-64,SMP]
 			vector=percpu: enable percpu vector domain
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 368864d..52280e3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1189,9 +1189,9 @@ config HOTPLUG_CPU
 config COMPAT_VDSO
 	bool "Compat VDSO support"
 	default y
-	depends on X86_32
+	depends on X86_32 || IA32_EMULATION
 	help
-	  Map the VDSO to the predictable old-style address too.
+	  Map the 32-bit VDSO to the predictable old-style address too.
 	---help---
 	  Say N here if you are running a sufficiently recent glibc
 	  version (2.3.3 or later), to remove the high-mapped
diff --git a/arch/x86/ia32/Makefile b/arch/x86/ia32/Makefile
index e2edda2..9abb0db 100644
--- a/arch/x86/ia32/Makefile
+++ b/arch/x86/ia32/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o tls32.o \
-	ia32_binfmt.o fpu32.o ptrace32.o syscall32.o syscall32_syscall.o \
+	ia32_binfmt.o fpu32.o ptrace32.o \
 	mmap32.o
 
 sysv-$(CONFIG_SYSVIPC) := ipc32.o
diff --git a/arch/x86/ia32/ia32_binfmt.c b/arch/x86/ia32/ia32_binfmt.c
index 55822d2..e32974c 100644
--- a/arch/x86/ia32/ia32_binfmt.c
+++ b/arch/x86/ia32/ia32_binfmt.c
@@ -26,7 +26,7 @@
 #include <asm/i387.h>
 #include <asm/uaccess.h>
 #include <asm/ia32.h>
-#include <asm/vsyscall32.h>
+#include <asm/vdso.h>
 
 #undef	ELF_ARCH
 #undef	ELF_CLASS
@@ -47,14 +47,13 @@
 #define AT_SYSINFO 32
 #define AT_SYSINFO_EHDR		33
 
-int sysctl_vsyscall32 = 1;
+extern int sysctl_vsyscall32;
 
 #undef ARCH_DLINFO
 #define ARCH_DLINFO do {  \
 	if (sysctl_vsyscall32) { \
-		current->mm->context.vdso = (void *)VSYSCALL32_BASE;	\
-		NEW_AUX_ENT(AT_SYSINFO, (u32)(u64)VSYSCALL32_VSYSCALL); \
-		NEW_AUX_ENT(AT_SYSINFO_EHDR, VSYSCALL32_BASE);    \
+		NEW_AUX_ENT(AT_SYSINFO, (u32)VDSO_ENTRY);		\
+		NEW_AUX_ENT(AT_SYSINFO_EHDR, (u32)VDSO_CURRENT_BASE);	\
 	}	\
 } while(0)
 
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 6ea19c2..120b607 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -31,7 +31,7 @@
 #include <asm/sigcontext32.h>
 #include <asm/fpu32.h>
 #include <asm/proto.h>
-#include <asm/vsyscall32.h>
+#include <asm/vdso.h>
 
 #define DEBUG_SIG 0
 
@@ -451,7 +451,8 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	{ 
 		void __user *restorer;
 		if (current->binfmt->hasvdso)
-			restorer = VSYSCALL32_SIGRETURN;
+			restorer = VDSO32_SYMBOL(current->mm->context.vdso,
+						 sigreturn);
 		else
 			restorer = (void *)&frame->retcode;
 		if (ka->sa.sa_flags & SA_RESTORER)
@@ -551,7 +552,8 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	
 	{ 
-		void __user *restorer = VSYSCALL32_RTSIGRETURN; 
+		void __user *restorer = VDSO32_SYMBOL(current->mm->context.vdso,
+						      rt_sigreturn);
 		if (ka->sa.sa_flags & SA_RESTORER)
 			restorer = ka->sa.sa_restorer;       
 		err |= __put_user(ptr_to_compat(restorer), &frame->pretcode);
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 64e4f47..53f36bc 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -15,7 +15,7 @@ vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
 
 # files to link into kernel
 obj-$(VDSO64-y)			+= vma.o vdso.o
-obj-$(CONFIG_X86_32)		+= vdso32.o vdso32-setup.o
+obj-$(VDSO32-y)			+= vdso32.o vdso32-setup.o
 
 vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
 
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index fb71a93..d97a6d7 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -24,6 +24,7 @@
 #include <asm/elf.h>
 #include <asm/tlbflush.h>
 #include <asm/vdso.h>
+#include <asm/proto.h>
 
 enum {
 	VDSO_DISABLED = 0,
@@ -37,14 +38,24 @@ enum {
 #define VDSO_DEFAULT	VDSO_ENABLED
 #endif
 
+#ifdef CONFIG_X86_64
+#define vdso_enabled			sysctl_vsyscall32
+#define arch_setup_additional_pages	syscall32_setup_pages
+#endif
+
+/*
+ * This is the difference between the prelinked addresses in the vDSO images
+ * and the VDSO_HIGH_BASE address where CONFIG_COMPAT_VDSO places the vDSO
+ * in the user address space.
+ */
+#define VDSO_ADDR_ADJUST	(VDSO_HIGH_BASE - (unsigned long)VDSO32_PRELINK)
+
 /*
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
  */
 unsigned int __read_mostly vdso_enabled = VDSO_DEFAULT;
 
-EXPORT_SYMBOL_GPL(vdso_enabled);
-
 static int __init vdso_setup(char *s)
 {
 	vdso_enabled = simple_strtoul(s, NULL, 0);
@@ -52,9 +63,18 @@ static int __init vdso_setup(char *s)
 	return 1;
 }
 
-__setup("vdso=", vdso_setup);
+/*
+ * For consistency, the argument vdso32=[012] affects the 32-bit vDSO
+ * behavior on both 64-bit and 32-bit kernels.
+ * On 32-bit kernels, vdso=[012] means the same thing.
+ */
+__setup("vdso32=", vdso_setup);
 
-extern asmlinkage void ia32_sysenter_target(void);
+#ifdef CONFIG_X86_32
+__setup_param("vdso=", vdso32_setup, vdso_setup, 0);
+
+EXPORT_SYMBOL_GPL(vdso_enabled);
+#endif
 
 static __init void reloc_symtab(Elf32_Ehdr *ehdr,
 				unsigned offset, unsigned size)
@@ -79,7 +99,7 @@ static __init void reloc_symtab(Elf32_Ehdr *ehdr,
 		case STT_FUNC:
 		case STT_SECTION:
 		case STT_FILE:
-			sym->st_value += VDSO_HIGH_BASE;
+			sym->st_value += VDSO_ADDR_ADJUST;
 		}
 	}
 }
@@ -105,7 +125,7 @@ static __init void reloc_dyn(Elf32_Ehdr *ehdr, unsigned offset)
 		case DT_VERNEED:
 		case DT_ADDRRNGLO ... DT_ADDRRNGHI:
 			/* definitely pointers needing relocation */
-			dyn->d_un.d_ptr += VDSO_HIGH_BASE;
+			dyn->d_un.d_ptr += VDSO_ADDR_ADJUST;
 			break;
 
 		case DT_ENCODING ... OLD_DT_LOOS-1:
@@ -114,7 +134,7 @@ static __init void reloc_dyn(Elf32_Ehdr *ehdr, unsigned offset)
 			   they're even */
 			if (dyn->d_tag >= DT_ENCODING &&
 			    (dyn->d_tag & 1) == 0)
-				dyn->d_un.d_ptr += VDSO_HIGH_BASE;
+				dyn->d_un.d_ptr += VDSO_ADDR_ADJUST;
 			break;
 
 		case DT_VERDEFNUM:
@@ -143,15 +163,15 @@ static __init void relocate_vdso(Elf32_Ehdr *ehdr)
 	int i;
 
 	BUG_ON(memcmp(ehdr->e_ident, ELFMAG, 4) != 0 ||
-	       !elf_check_arch(ehdr) ||
+	       !elf_check_arch_ia32(ehdr) ||
 	       ehdr->e_type != ET_DYN);
 
-	ehdr->e_entry += VDSO_HIGH_BASE;
+	ehdr->e_entry += VDSO_ADDR_ADJUST;
 
 	/* rebase phdrs */
 	phdr = (void *)ehdr + ehdr->e_phoff;
 	for (i = 0; i < ehdr->e_phnum; i++) {
-		phdr[i].p_vaddr += VDSO_HIGH_BASE;
+		phdr[i].p_vaddr += VDSO_ADDR_ADJUST;
 
 		/* relocate dynamic stuff */
 		if (phdr[i].p_type == PT_DYNAMIC)
@@ -164,7 +184,7 @@ static __init void relocate_vdso(Elf32_Ehdr *ehdr)
 		if (!(shdr[i].sh_flags & SHF_ALLOC))
 			continue;
 
-		shdr[i].sh_addr += VDSO_HIGH_BASE;
+		shdr[i].sh_addr += VDSO_ADDR_ADJUST;
 
 		if (shdr[i].sh_type == SHT_SYMTAB ||
 		    shdr[i].sh_type == SHT_DYNSYM)
@@ -173,6 +193,45 @@ static __init void relocate_vdso(Elf32_Ehdr *ehdr)
 	}
 }
 
+/*
+ * These symbols are defined by vdso32.S to mark the bounds
+ * of the ELF DSO images included therein.
+ */
+extern const char vdso32_default_start, vdso32_default_end;
+extern const char vdso32_sysenter_start, vdso32_sysenter_end;
+static struct page *vdso32_pages[1];
+
+#ifdef CONFIG_X86_64
+
+static int use_sysenter __read_mostly = -1;
+
+#define	vdso32_sysenter()	(use_sysenter > 0)
+
+/* May not be __init: called during resume */
+void syscall32_cpu_init(void)
+{
+	if (use_sysenter < 0)
+		use_sysenter = (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL);
+
+	/* Load these always in case some future AMD CPU supports
+	   SYSENTER from compat mode too. */
+	checking_wrmsrl(MSR_IA32_SYSENTER_CS, (u64)__KERNEL_CS);
+	checking_wrmsrl(MSR_IA32_SYSENTER_ESP, 0ULL);
+	checking_wrmsrl(MSR_IA32_SYSENTER_EIP, (u64)ia32_sysenter_target);
+
+	wrmsrl(MSR_CSTAR, ia32_cstar_target);
+}
+
+#define compat_uses_vma		1
+
+static inline void map_compat_vdso(int map)
+{
+}
+
+#else  /* CONFIG_X86_32 */
+
+#define vdso32_sysenter()	(boot_cpu_has(X86_FEATURE_SEP))
+
 void enable_sep_cpu(void)
 {
 	int cpu = get_cpu();
@@ -210,13 +269,7 @@ static int __init gate_vma_init(void)
 	return 0;
 }
 
-/*
- * These symbols are defined by vsyscall.o to mark the bounds
- * of the ELF DSO images included therein.
- */
-extern const char vsyscall_int80_start, vsyscall_int80_end;
-extern const char vsyscall_sysenter_start, vsyscall_sysenter_end;
-static struct page *syscall_pages[1];
+#define compat_uses_vma		0
 
 static void map_compat_vdso(int map)
 {
@@ -227,31 +280,35 @@ static void map_compat_vdso(int map)
 
 	vdso_mapped = map;
 
-	__set_fixmap(FIX_VDSO, page_to_pfn(syscall_pages[0]) << PAGE_SHIFT,
+	__set_fixmap(FIX_VDSO, page_to_pfn(vdso32_pages[0]) << PAGE_SHIFT,
 		     map ? PAGE_READONLY_EXEC : PAGE_NONE);
 
 	/* flush stray tlbs */
 	flush_tlb_all();
 }
 
+#endif	/* CONFIG_X86_64 */
+
 int __init sysenter_setup(void)
 {
 	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
 	const void *vsyscall;
 	size_t vsyscall_len;
 
-	syscall_pages[0] = virt_to_page(syscall_page);
+	vdso32_pages[0] = virt_to_page(syscall_page);
 
+#ifdef CONFIG_X86_32
 	gate_vma_init();
 
 	printk("Compat vDSO mapped to %08lx.\n", __fix_to_virt(FIX_VDSO));
+#endif
 
-	if (!boot_cpu_has(X86_FEATURE_SEP)) {
-		vsyscall = &vsyscall_int80_start;
-		vsyscall_len = &vsyscall_int80_end - &vsyscall_int80_start;
+	if (!vdso32_sysenter()) {
+		vsyscall = &vdso32_default_start;
+		vsyscall_len = &vdso32_default_end - &vdso32_default_start;
 	} else {
-		vsyscall = &vsyscall_sysenter_start;
-		vsyscall_len = &vsyscall_sysenter_end - &vsyscall_sysenter_start;
+		vsyscall = &vdso32_sysenter_start;
+		vsyscall_len = &vdso32_sysenter_end - &vdso32_sysenter_start;
 	}
 
 	memcpy(syscall_page, vsyscall, vsyscall_len);
@@ -284,7 +341,9 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
 			ret = addr;
 			goto up_fail;
 		}
+	}
 
+	if (compat_uses_vma || !compat) {
 		/*
 		 * MAYWRITE to allow gdb to COW and set breakpoints
 		 *
@@ -298,7 +357,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
 					      VM_READ|VM_EXEC|
 					      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
 					      VM_ALWAYSDUMP,
-					      syscall_pages);
+					      vdso32_pages);
 
 		if (ret)
 			goto up_fail;
@@ -314,6 +373,12 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
 	return ret;
 }
 
+#ifdef CONFIG_X86_64
+
+__initcall(sysenter_setup);
+
+#else  /* CONFIG_X86_32 */
+
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
 	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
@@ -342,3 +407,5 @@ int in_gate_area_no_task(unsigned long addr)
 {
 	return 0;
 }
+
+#endif	/* CONFIG_X86_64 */
diff --git a/arch/x86/vdso/vdso32.S b/arch/x86/vdso/vdso32.S
index cab020c..1e36f72 100644
--- a/arch/x86/vdso/vdso32.S
+++ b/arch/x86/vdso/vdso32.S
@@ -2,14 +2,18 @@
 
 __INITDATA
 
-	.globl vsyscall_int80_start, vsyscall_int80_end
-vsyscall_int80_start:
+	.globl vdso32_default_start, vdso32_default_end
+vdso32_default_start:
+#ifdef CONFIG_X86_32
 	.incbin "arch/x86/vdso/vdso32-int80.so"
-vsyscall_int80_end:
+#else
+	.incbin "arch/x86/vdso/vdso32-syscall.so"
+#endif
+vdso32_default_end:
 
-	.globl vsyscall_sysenter_start, vsyscall_sysenter_end
-vsyscall_sysenter_start:
+	.globl vdso32_sysenter_start, vdso32_sysenter_end
+vdso32_sysenter_start:
 	.incbin "arch/x86/vdso/vdso32-sysenter.so"
-vsyscall_sysenter_end:
+vdso32_sysenter_end:
 
 __FINIT
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index fd91568..7d6d0ef 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -62,8 +62,8 @@ static void xen_idle(void)
  */
 static void fiddle_vdso(void)
 {
-	extern char vsyscall_int80_start;
-	u32 *mask = VDSO32_SYMBOL(&vsyscall_int80_start, NOTE_MASK);
+	extern const char vdso32_default_start;
+	u32 *mask = VDSO32_SYMBOL(&vdso32_default_start, NOTE_MASK);
 	*mask |= 1 << VDSO_NOTE_NONEGSEG_BIT;
 }
 
diff --git a/include/asm-x86/elf.h b/include/asm-x86/elf.h
index 0dd21ee..0ff9c2f 100644
--- a/include/asm-x86/elf.h
+++ b/include/asm-x86/elf.h
@@ -74,17 +74,19 @@ typedef struct user_fxsr_struct elf_fpxregset_t;
 
 #ifdef __KERNEL__
 
+/*
+ * This is used to ensure we don't load something for the wrong architecture.
+ */
+#define elf_check_arch_ia32(x) \
+	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
+
 #ifdef CONFIG_X86_32
 #include <asm/processor.h>
 #include <asm/system.h>		/* for savesegment */
 #include <asm/desc.h>
 #include <asm/vdso.h>
 
-/*
- * This is used to ensure we don't load something for the wrong architecture.
- */
-#define elf_check_arch(x) \
-	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
+#define elf_check_arch(x)	elf_check_arch_ia32(x)
 
 /* SVR4/i386 ABI (pages 3-31, 3-32) says that when the program starts %edx
    contains a pointer to a function which might be registered using `atexit'.
@@ -247,10 +249,6 @@ extern int dump_task_extended_fpu (struct task_struct *,
 #define ELF_CORE_XFPREG_TYPE NT_PRXFPREG
 
 #define VDSO_HIGH_BASE		(__fix_to_virt(FIX_VDSO))
-#define VDSO_CURRENT_BASE	((unsigned long)current->mm->context.vdso)
-
-#define VDSO_ENTRY \
-	((unsigned long) VDSO32_SYMBOL(VDSO_CURRENT_BASE, vsyscall))
 
 /* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 
@@ -262,6 +260,8 @@ do if (vdso_enabled) {							\
 
 #else /* CONFIG_X86_32 */
 
+#define VDSO_HIGH_BASE		0xffffe000U /* CONFIG_COMPAT_VDSO address */
+
 /* 1GB for 64bit, 8MB for 32bit */
 #define STACK_RND_MASK (test_thread_flag(TIF_IA32) ? 0x7ff : 0x3fffff)
 
@@ -272,6 +272,11 @@ do if (vdso_enabled) {						\
 
 #endif /* !CONFIG_X86_32 */
 
+#define VDSO_CURRENT_BASE	((unsigned long)current->mm->context.vdso)
+
+#define VDSO_ENTRY \
+	((unsigned long) VDSO32_SYMBOL(VDSO_CURRENT_BASE, vsyscall))
+
 struct linux_binprm;
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
