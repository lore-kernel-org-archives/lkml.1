Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbZLOUgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbZLOUgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761079AbZLOUgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:36:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39317 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459AbZLOUgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:36:41 -0500
Date: Tue, 15 Dec 2009 21:36:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20091215203622.GA12777@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

( This includes the pt_regs related cleanups prompted by your comments about 
  the sys_iopl unification patch. They touch sensitive code so we gave them a 
  few days of testing. )

 Thanks,

	Ingo

------------------>
Brian Gerst (11):
      x86-32: Add new pt_regs stubs
      x86: Merge sys_iopl
      x86: Merge sys_execve
      x86: Merge sys_sigaltstack
      x86, 32-bit: Convert sys_vm86 & sys_vm86old
      x86: Merge sys_clone
      x86, 64-bit: Move kernel_thread to C
      x86, 64-bit: Use user_mode() to determine new stack pointer in copy_thread()
      x86, 32-bit: Use same regs as 64-bit for kernel_thread_helper
      x86: Sync 32/64-bit kernel_thread
      x86: Merge kernel_thread()

FUJITA Tomonori (1):
      x86: Split swiotlb initialization into two stages

H. Peter Anvin (4):
      x86-32: Avoid pipeline serialization in PTREGSCALL1 and 2
      x86-64, paravirt: Call set_iopl_mask() on 64 bits
      x86, msr: Remove incorrect, duplicated code in the MSR driver
      x86: Regex support and known-movable symbols for relocs, fix _end

Jonathan Nieder (1):
      x86: Fix kprobes build with non-gawk awk

Rusty Russell (1):
      cpumask: Use modern cpumask style in arch/x86/kernel/cpu/mcheck/mce-inject.c


 arch/x86/boot/compressed/relocs.c       |   87 +++++++++++++++++++++----------
 arch/x86/include/asm/swiotlb.h          |    8 ++-
 arch/x86/include/asm/syscalls.h         |   32 ++++--------
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   22 ++++----
 arch/x86/kernel/entry_32.S              |   69 ++++++++++++++++++------
 arch/x86/kernel/entry_64.S              |   49 +----------------
 arch/x86/kernel/ioport.c                |   28 ++---------
 arch/x86/kernel/msr.c                   |    5 +-
 arch/x86/kernel/pci-dma.c               |    9 ++--
 arch/x86/kernel/pci-swiotlb.c           |   11 +++--
 arch/x86/kernel/process.c               |   70 +++++++++++++++++++++++++
 arch/x86/kernel/process_32.c            |   73 --------------------------
 arch/x86/kernel/process_64.c            |   35 +-----------
 arch/x86/kernel/signal.c                |   12 +----
 arch/x86/kernel/vm86_32.c               |   11 ++--
 arch/x86/kernel/vmlinux.lds.S           |    4 +-
 arch/x86/kernel/x8664_ksyms_64.c        |    2 -
 arch/x86/tools/gen-insn-attr-x86.awk    |   10 ++--
 18 files changed, 244 insertions(+), 293 deletions(-)

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index bbeb0c3..89bbf4e 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -9,6 +9,9 @@
 #include <byteswap.h>
 #define USE_BSD
 #include <endian.h>
+#include <regex.h>
+
+static void die(char *fmt, ...);
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 static Elf32_Ehdr ehdr;
@@ -30,25 +33,47 @@ static struct section *secs;
  * the address for which it has been compiled. Don't warn user about
  * absolute relocations present w.r.t these symbols.
  */
-static const char* safe_abs_relocs[] = {
-		"xen_irq_disable_direct_reloc",
-		"xen_save_fl_direct_reloc",
-};
+static const char abs_sym_regex[] =
+	"^(xen_irq_disable_direct_reloc$|"
+	"xen_save_fl_direct_reloc$|"
+	"VDSO|"
+	"__crc_)";
+static regex_t abs_sym_regex_c;
+static int is_abs_reloc(const char *sym_name)
+{
+	return !regexec(&abs_sym_regex_c, sym_name, 0, NULL, 0);
+}
 
-static int is_safe_abs_reloc(const char* sym_name)
+/*
+ * These symbols are known to be relative, even if the linker marks them
+ * as absolute (typically defined outside any section in the linker script.)
+ */
+static const char rel_sym_regex[] =
+	"^_end$";
+static regex_t rel_sym_regex_c;
+static int is_rel_reloc(const char *sym_name)
 {
-	int i;
+	return !regexec(&rel_sym_regex_c, sym_name, 0, NULL, 0);
+}
 
-	for (i = 0; i < ARRAY_SIZE(safe_abs_relocs); i++) {
-		if (!strcmp(sym_name, safe_abs_relocs[i]))
-			/* Match found */
-			return 1;
-	}
-	if (strncmp(sym_name, "VDSO", 4) == 0)
-		return 1;
-	if (strncmp(sym_name, "__crc_", 6) == 0)
-		return 1;
-	return 0;
+static void regex_init(void)
+{
+        char errbuf[128];
+        int err;
+	
+        err = regcomp(&abs_sym_regex_c, abs_sym_regex,
+                      REG_EXTENDED|REG_NOSUB);
+        if (err) {
+                regerror(err, &abs_sym_regex_c, errbuf, sizeof errbuf);
+                die("%s", errbuf);
+        }
+
+        err = regcomp(&rel_sym_regex_c, rel_sym_regex,
+                      REG_EXTENDED|REG_NOSUB);
+        if (err) {
+                regerror(err, &rel_sym_regex_c, errbuf, sizeof errbuf);
+                die("%s", errbuf);
+        }
 }
 
 static void die(char *fmt, ...)
@@ -131,7 +156,7 @@ static const char *rel_type(unsigned type)
 #undef REL_TYPE
 	};
 	const char *name = "unknown type rel type name";
-	if (type < ARRAY_SIZE(type_name)) {
+	if (type < ARRAY_SIZE(type_name) && type_name[type]) {
 		name = type_name[type];
 	}
 	return name;
@@ -448,7 +473,7 @@ static void print_absolute_relocs(void)
 			 * Before warning check if this absolute symbol
 			 * relocation is harmless.
 			 */
-			if (is_safe_abs_reloc(name))
+			if (is_abs_reloc(name) || is_rel_reloc(name))
 				continue;
 
 			if (!printed) {
@@ -501,21 +526,26 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym))
 			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
 			r_type = ELF32_R_TYPE(rel->r_info);
 			/* Don't visit relocations to absolute symbols */
-			if (sym->st_shndx == SHN_ABS) {
+			if (sym->st_shndx == SHN_ABS &&
+			    !is_rel_reloc(sym_name(sym_strtab, sym))) {
 				continue;
 			}
-			if (r_type == R_386_NONE || r_type == R_386_PC32) {
+			switch (r_type) {
+			case R_386_NONE:
+			case R_386_PC32:
 				/*
 				 * NONE can be ignored and and PC relative
 				 * relocations don't need to be adjusted.
 				 */
-			}
-			else if (r_type == R_386_32) {
+				break;
+			case R_386_32:
 				/* Visit relocations that need to be adjusted */
 				visit(rel, sym);
-			}
-			else {
-				die("Unsupported relocation type: %d\n", r_type);
+				break;
+			default:
+				die("Unsupported relocation type: %s (%d)\n",
+				    rel_type(r_type), r_type);
+				break;
 			}
 		}
 	}
@@ -571,16 +601,15 @@ static void emit_relocs(int as_text)
 	}
 	else {
 		unsigned char buf[4];
-		buf[0] = buf[1] = buf[2] = buf[3] = 0;
 		/* Print a stop */
-		printf("%c%c%c%c", buf[0], buf[1], buf[2], buf[3]);
+		fwrite("\0\0\0\0", 4, 1, stdout);
 		/* Now print each relocation */
 		for (i = 0; i < reloc_count; i++) {
 			buf[0] = (relocs[i] >>  0) & 0xff;
 			buf[1] = (relocs[i] >>  8) & 0xff;
 			buf[2] = (relocs[i] >> 16) & 0xff;
 			buf[3] = (relocs[i] >> 24) & 0xff;
-			printf("%c%c%c%c", buf[0], buf[1], buf[2], buf[3]);
+			fwrite(buf, 4, 1, stdout);
 		}
 	}
 }
@@ -598,6 +627,8 @@ int main(int argc, char **argv)
 	FILE *fp;
 	int i;
 
+	regex_init();
+
 	show_absolute_syms = 0;
 	show_absolute_relocs = 0;
 	as_text = 0;
diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
index 87ffcb1..8085277 100644
--- a/arch/x86/include/asm/swiotlb.h
+++ b/arch/x86/include/asm/swiotlb.h
@@ -5,13 +5,17 @@
 
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
-extern int pci_swiotlb_init(void);
+extern int __init pci_swiotlb_detect(void);
+extern void __init pci_swiotlb_init(void);
 #else
 #define swiotlb 0
-static inline int pci_swiotlb_init(void)
+static inline int pci_swiotlb_detect(void)
 {
 	return 0;
 }
+static inline void pci_swiotlb_init(void)
+{
+}
 #endif
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 372b76e..b0ce780 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -18,16 +18,24 @@
 /* Common in X86_32 and X86_64 */
 /* kernel/ioport.c */
 asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
+long sys_iopl(unsigned int, struct pt_regs *);
 
 /* kernel/process.c */
 int sys_fork(struct pt_regs *);
 int sys_vfork(struct pt_regs *);
+long sys_execve(char __user *, char __user * __user *,
+		char __user * __user *, struct pt_regs *);
+long sys_clone(unsigned long, unsigned long, void __user *,
+	       void __user *, struct pt_regs *);
 
 /* kernel/ldt.c */
 asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
 
 /* kernel/signal.c */
 long sys_rt_sigreturn(struct pt_regs *);
+long sys_sigaltstack(const stack_t __user *, stack_t __user *,
+		     struct pt_regs *);
+
 
 /* kernel/tls.c */
 asmlinkage int sys_set_thread_area(struct user_desc __user *);
@@ -35,18 +43,11 @@ asmlinkage int sys_get_thread_area(struct user_desc __user *);
 
 /* X86_32 only */
 #ifdef CONFIG_X86_32
-/* kernel/ioport.c */
-long sys_iopl(struct pt_regs *);
-
-/* kernel/process_32.c */
-int sys_clone(struct pt_regs *);
-int sys_execve(struct pt_regs *);
 
 /* kernel/signal.c */
 asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
 asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
-int sys_sigaltstack(struct pt_regs *);
 unsigned long sys_sigreturn(struct pt_regs *);
 
 /* kernel/sys_i386_32.c */
@@ -64,28 +65,15 @@ asmlinkage int sys_uname(struct old_utsname __user *);
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
 
 /* kernel/vm86_32.c */
-int sys_vm86old(struct pt_regs *);
-int sys_vm86(struct pt_regs *);
+int sys_vm86old(struct vm86_struct __user *, struct pt_regs *);
+int sys_vm86(unsigned long, unsigned long, struct pt_regs *);
 
 #else /* CONFIG_X86_32 */
 
 /* X86_64 only */
-/* kernel/ioport.c */
-asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
-
 /* kernel/process_64.c */
-asmlinkage long sys_clone(unsigned long, unsigned long,
-			  void __user *, void __user *,
-			  struct pt_regs *);
-asmlinkage long sys_execve(char __user *, char __user * __user *,
-			   char __user * __user *,
-			   struct pt_regs *);
 long sys_arch_prctl(int, unsigned long);
 
-/* kernel/signal.c */
-asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
-				struct pt_regs *);
-
 /* kernel/sys_x86_64.c */
 struct new_utsname;
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 472763d..73734ba 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -74,7 +74,7 @@ static void raise_exception(struct mce *m, struct pt_regs *pregs)
 	m->finished = 0;
 }
 
-static cpumask_t mce_inject_cpumask;
+static cpumask_var_t mce_inject_cpumask;
 
 static int mce_raise_notify(struct notifier_block *self,
 			    unsigned long val, void *data)
@@ -82,9 +82,9 @@ static int mce_raise_notify(struct notifier_block *self,
 	struct die_args *args = (struct die_args *)data;
 	int cpu = smp_processor_id();
 	struct mce *m = &__get_cpu_var(injectm);
-	if (val != DIE_NMI_IPI || !cpu_isset(cpu, mce_inject_cpumask))
+	if (val != DIE_NMI_IPI || !cpumask_test_cpu(cpu, mce_inject_cpumask))
 		return NOTIFY_DONE;
-	cpu_clear(cpu, mce_inject_cpumask);
+	cpumask_clear_cpu(cpu, mce_inject_cpumask);
 	if (m->inject_flags & MCJ_EXCEPTION)
 		raise_exception(m, args->regs);
 	else if (m->status)
@@ -148,22 +148,22 @@ static void raise_mce(struct mce *m)
 		unsigned long start;
 		int cpu;
 		get_online_cpus();
-		mce_inject_cpumask = cpu_online_map;
-		cpu_clear(get_cpu(), mce_inject_cpumask);
+		cpumask_copy(mce_inject_cpumask, cpu_online_mask);
+		cpumask_clear_cpu(get_cpu(), mce_inject_cpumask);
 		for_each_online_cpu(cpu) {
 			struct mce *mcpu = &per_cpu(injectm, cpu);
 			if (!mcpu->finished ||
 			    MCJ_CTX(mcpu->inject_flags) != MCJ_CTX_RANDOM)
-				cpu_clear(cpu, mce_inject_cpumask);
+				cpumask_clear_cpu(cpu, mce_inject_cpumask);
 		}
-		if (!cpus_empty(mce_inject_cpumask))
-			apic->send_IPI_mask(&mce_inject_cpumask, NMI_VECTOR);
+		if (!cpumask_empty(mce_inject_cpumask))
+			apic->send_IPI_mask(mce_inject_cpumask, NMI_VECTOR);
 		start = jiffies;
-		while (!cpus_empty(mce_inject_cpumask)) {
+		while (!cpumask_empty(mce_inject_cpumask)) {
 			if (!time_before(jiffies, start + 2*HZ)) {
 				printk(KERN_ERR
 				"Timeout waiting for mce inject NMI %lx\n",
-					*cpus_addr(mce_inject_cpumask));
+					*cpumask_bits(mce_inject_cpumask));
 				break;
 			}
 			cpu_relax();
@@ -210,6 +210,8 @@ static ssize_t mce_write(struct file *filp, const char __user *ubuf,
 
 static int inject_init(void)
 {
+	if (!alloc_cpumask_var(&mce_inject_cpumask, GFP_KERNEL))
+		return -ENOMEM;
 	printk(KERN_INFO "Machine check injector initialized\n");
 	mce_chrdev_ops.write = mce_write;
 	register_die_notifier(&mce_raise_nb);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 50b9c22..44a8e0d 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -725,22 +725,61 @@ END(syscall_badsys)
 /*
  * System calls that need a pt_regs pointer.
  */
-#define PTREGSCALL(name) \
+#define PTREGSCALL0(name) \
 	ALIGN; \
 ptregs_##name: \
 	leal 4(%esp),%eax; \
 	jmp sys_##name;
 
-PTREGSCALL(iopl)
-PTREGSCALL(fork)
-PTREGSCALL(clone)
-PTREGSCALL(vfork)
-PTREGSCALL(execve)
-PTREGSCALL(sigaltstack)
-PTREGSCALL(sigreturn)
-PTREGSCALL(rt_sigreturn)
-PTREGSCALL(vm86)
-PTREGSCALL(vm86old)
+#define PTREGSCALL1(name) \
+	ALIGN; \
+ptregs_##name: \
+	leal 4(%esp),%edx; \
+	movl (PT_EBX+4)(%esp),%eax; \
+	jmp sys_##name;
+
+#define PTREGSCALL2(name) \
+	ALIGN; \
+ptregs_##name: \
+	leal 4(%esp),%ecx; \
+	movl (PT_ECX+4)(%esp),%edx; \
+	movl (PT_EBX+4)(%esp),%eax; \
+	jmp sys_##name;
+
+#define PTREGSCALL3(name) \
+	ALIGN; \
+ptregs_##name: \
+	leal 4(%esp),%eax; \
+	pushl %eax; \
+	movl PT_EDX(%eax),%ecx; \
+	movl PT_ECX(%eax),%edx; \
+	movl PT_EBX(%eax),%eax; \
+	call sys_##name; \
+	addl $4,%esp; \
+	ret
+
+PTREGSCALL1(iopl)
+PTREGSCALL0(fork)
+PTREGSCALL0(vfork)
+PTREGSCALL3(execve)
+PTREGSCALL2(sigaltstack)
+PTREGSCALL0(sigreturn)
+PTREGSCALL0(rt_sigreturn)
+PTREGSCALL2(vm86)
+PTREGSCALL1(vm86old)
+
+/* Clone is an oddball.  The 4th arg is in %edi */
+	ALIGN;
+ptregs_clone:
+	leal 4(%esp),%eax
+	pushl %eax
+	pushl PT_EDI(%eax)
+	movl PT_EDX(%eax),%ecx
+	movl PT_ECX(%eax),%edx
+	movl PT_EBX(%eax),%eax
+	call sys_clone
+	addl $8,%esp
+	ret
 
 .macro FIXUP_ESPFIX_STACK
 /*
@@ -1008,12 +1047,8 @@ END(spurious_interrupt_bug)
 ENTRY(kernel_thread_helper)
 	pushl $0		# fake return address for unwinder
 	CFI_STARTPROC
-	movl %edx,%eax
-	push %edx
-	CFI_ADJUST_CFA_OFFSET 4
-	call *%ebx
-	push %eax
-	CFI_ADJUST_CFA_OFFSET 4
+	movl %edi,%eax
+	call *%esi
 	call do_exit
 	ud2			# padding for call trace
 	CFI_ENDPROC
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 63bca79..73d9b2c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1166,63 +1166,20 @@ bad_gs:
 	jmp  2b
 	.previous
 
-/*
- * Create a kernel thread.
- *
- * C extern interface:
- *	extern long kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
- *
- * asm input arguments:
- *	rdi: fn, rsi: arg, rdx: flags
- */
-ENTRY(kernel_thread)
-	CFI_STARTPROC
-	FAKE_STACK_FRAME $child_rip
-	SAVE_ALL
-
-	# rdi: flags, rsi: usp, rdx: will be &pt_regs
-	movq %rdx,%rdi
-	orq  kernel_thread_flags(%rip),%rdi
-	movq $-1, %rsi
-	movq %rsp, %rdx
-
-	xorl %r8d,%r8d
-	xorl %r9d,%r9d
-
-	# clone now
-	call do_fork
-	movq %rax,RAX(%rsp)
-	xorl %edi,%edi
-
-	/*
-	 * It isn't worth to check for reschedule here,
-	 * so internally to the x86_64 port you can rely on kernel_thread()
-	 * not to reschedule the child before returning, this avoids the need
-	 * of hacks for example to fork off the per-CPU idle tasks.
-	 * [Hopefully no generic code relies on the reschedule -AK]
-	 */
-	RESTORE_ALL
-	UNFAKE_STACK_FRAME
-	ret
-	CFI_ENDPROC
-END(kernel_thread)
-
-ENTRY(child_rip)
+ENTRY(kernel_thread_helper)
 	pushq $0		# fake return address
 	CFI_STARTPROC
 	/*
 	 * Here we are in the child and the registers are set as they were
 	 * at kernel_thread() invocation in the parent.
 	 */
-	movq %rdi, %rax
-	movq %rsi, %rdi
-	call *%rax
+	call *%rsi
 	# exit
 	mov %eax, %edi
 	call do_exit
 	ud2			# padding for call trace
 	CFI_ENDPROC
-END(child_rip)
+END(kernel_thread_helper)
 
 /*
  * execve(). This function needs to use IRET, not SYSRET, to set up all state properly.
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 99c4d30..8eec0ec 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -103,9 +103,10 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
  * on system-call entry - see also fork() and the signal handling
  * code.
  */
-static int do_iopl(unsigned int level, struct pt_regs *regs)
+long sys_iopl(unsigned int level, struct pt_regs *regs)
 {
 	unsigned int old = (regs->flags >> 12) & 3;
+	struct thread_struct *t = &current->thread;
 
 	if (level > 3)
 		return -EINVAL;
@@ -115,29 +116,8 @@ static int do_iopl(unsigned int level, struct pt_regs *regs)
 			return -EPERM;
 	}
 	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
-
-	return 0;
-}
-
-#ifdef CONFIG_X86_32
-long sys_iopl(struct pt_regs *regs)
-{
-	unsigned int level = regs->bx;
-	struct thread_struct *t = &current->thread;
-	int rc;
-
-	rc = do_iopl(level, regs);
-	if (rc < 0)
-		goto out;
-
 	t->iopl = level << 12;
 	set_iopl_mask(t->iopl);
-out:
-	return rc;
-}
-#else
-asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
-{
-	return do_iopl(level, regs);
+
+	return 0;
 }
-#endif
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 5534499..572b07e 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -172,11 +172,10 @@ static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
 
 static int msr_open(struct inode *inode, struct file *file)
 {
-	unsigned int cpu = iminor(file->f_path.dentry->d_inode);
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	unsigned int cpu;
+	struct cpuinfo_x86 *c;
 
 	cpu = iminor(file->f_path.dentry->d_inode);
-
 	if (cpu >= nr_cpu_ids || !cpu_online(cpu))
 		return -ENXIO;	/* No such CPU */
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index fcc2f2b..75e14e2 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -120,15 +120,12 @@ static void __init dma32_free_bootmem(void)
 
 void __init pci_iommu_alloc(void)
 {
-	int use_swiotlb;
-
-	use_swiotlb = pci_swiotlb_init();
 #ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #endif
-	if (use_swiotlb)
-		return;
+	if (pci_swiotlb_detect())
+		goto out;
 
 	gart_iommu_hole_init();
 
@@ -138,6 +135,8 @@ void __init pci_iommu_alloc(void)
 
 	/* needs to be called after gart_iommu_hole_init */
 	amd_iommu_detect();
+out:
+	pci_swiotlb_init();
 }
 
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index e3c0a66..7d2829d 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -43,12 +43,12 @@ static struct dma_map_ops swiotlb_dma_ops = {
 };
 
 /*
- * pci_swiotlb_init - initialize swiotlb if necessary
+ * pci_swiotlb_detect - set swiotlb to 1 if necessary
  *
  * This returns non-zero if we are forced to use swiotlb (by the boot
  * option).
  */
-int __init pci_swiotlb_init(void)
+int __init pci_swiotlb_detect(void)
 {
 	int use_swiotlb = swiotlb | swiotlb_force;
 
@@ -60,10 +60,13 @@ int __init pci_swiotlb_init(void)
 	if (swiotlb_force)
 		swiotlb = 1;
 
+	return use_swiotlb;
+}
+
+void __init pci_swiotlb_init(void)
+{
 	if (swiotlb) {
 		swiotlb_init(0);
 		dma_ops = &swiotlb_dma_ops;
 	}
-
-	return use_swiotlb;
 }
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 7a7bd4e..98c2cde 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -255,6 +255,76 @@ int sys_vfork(struct pt_regs *regs)
 		       NULL, NULL);
 }
 
+long
+sys_clone(unsigned long clone_flags, unsigned long newsp,
+	  void __user *parent_tid, void __user *child_tid, struct pt_regs *regs)
+{
+	if (!newsp)
+		newsp = regs->sp;
+	return do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
+}
+
+/*
+ * This gets run with %si containing the
+ * function to call, and %di containing
+ * the "args".
+ */
+extern void kernel_thread_helper(void);
+
+/*
+ * Create a kernel thread
+ */
+int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
+{
+	struct pt_regs regs;
+
+	memset(&regs, 0, sizeof(regs));
+
+	regs.si = (unsigned long) fn;
+	regs.di = (unsigned long) arg;
+
+#ifdef CONFIG_X86_32
+	regs.ds = __USER_DS;
+	regs.es = __USER_DS;
+	regs.fs = __KERNEL_PERCPU;
+	regs.gs = __KERNEL_STACK_CANARY;
+#endif
+
+	regs.orig_ax = -1;
+	regs.ip = (unsigned long) kernel_thread_helper;
+	regs.cs = __KERNEL_CS | get_kernel_rpl();
+	regs.flags = X86_EFLAGS_IF | 0x2;
+
+	/* Ok, create the new process.. */
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
+}
+EXPORT_SYMBOL(kernel_thread);
+
+/*
+ * sys_execve() executes a new program.
+ */
+long sys_execve(char __user *name, char __user * __user *argv,
+		char __user * __user *envp, struct pt_regs *regs)
+{
+	long error;
+	char *filename;
+
+	filename = getname(name);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		return error;
+	error = do_execve(filename, argv, envp, regs);
+
+#ifdef CONFIG_X86_32
+	if (error == 0) {
+		/* Make sure we don't return using sysenter.. */
+                set_thread_flag(TIF_IRET);
+        }
+#endif
+
+	putname(filename);
+	return error;
+}
 
 /*
  * Idle related variables and functions
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 120b887..9c517b5 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -180,39 +180,6 @@ void show_regs(struct pt_regs *regs)
 	show_trace(NULL, regs, &regs->sp, regs->bp);
 }
 
-/*
- * This gets run with %bx containing the
- * function to call, and %dx containing
- * the "args".
- */
-extern void kernel_thread_helper(void);
-
-/*
- * Create a kernel thread
- */
-int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
-{
-	struct pt_regs regs;
-
-	memset(&regs, 0, sizeof(regs));
-
-	regs.bx = (unsigned long) fn;
-	regs.dx = (unsigned long) arg;
-
-	regs.ds = __USER_DS;
-	regs.es = __USER_DS;
-	regs.fs = __KERNEL_PERCPU;
-	regs.gs = __KERNEL_STACK_CANARY;
-	regs.orig_ax = -1;
-	regs.ip = (unsigned long) kernel_thread_helper;
-	regs.cs = __KERNEL_CS | get_kernel_rpl();
-	regs.flags = X86_EFLAGS_IF | X86_EFLAGS_SF | X86_EFLAGS_PF | 0x2;
-
-	/* Ok, create the new process.. */
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
-}
-EXPORT_SYMBOL(kernel_thread);
-
 void release_thread(struct task_struct *dead_task)
 {
 	BUG_ON(dead_task->mm);
@@ -424,46 +391,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	return prev_p;
 }
 
-int sys_clone(struct pt_regs *regs)
-{
-	unsigned long clone_flags;
-	unsigned long newsp;
-	int __user *parent_tidptr, *child_tidptr;
-
-	clone_flags = regs->bx;
-	newsp = regs->cx;
-	parent_tidptr = (int __user *)regs->dx;
-	child_tidptr = (int __user *)regs->di;
-	if (!newsp)
-		newsp = regs->sp;
-	return do_fork(clone_flags, newsp, regs, 0, parent_tidptr, child_tidptr);
-}
-
-/*
- * sys_execve() executes a new program.
- */
-int sys_execve(struct pt_regs *regs)
-{
-	int error;
-	char *filename;
-
-	filename = getname((char __user *) regs->bx);
-	error = PTR_ERR(filename);
-	if (IS_ERR(filename))
-		goto out;
-	error = do_execve(filename,
-			(char __user * __user *) regs->cx,
-			(char __user * __user *) regs->dx,
-			regs);
-	if (error == 0) {
-		/* Make sure we don't return using sysenter.. */
-		set_thread_flag(TIF_IRET);
-	}
-	putname(filename);
-out:
-	return error;
-}
-
 #define top_esp                (THREAD_SIZE - sizeof(unsigned long))
 #define top_ebp                (THREAD_SIZE - 2*sizeof(unsigned long))
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index e5ab0cd..52fbd0c 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -57,8 +57,6 @@ asmlinkage extern void ret_from_fork(void);
 DEFINE_PER_CPU(unsigned long, old_rsp);
 static DEFINE_PER_CPU(unsigned char, is_idle);
 
-unsigned long kernel_thread_flags = CLONE_VM | CLONE_UNTRACED;
-
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);
 
 void idle_notifier_register(struct notifier_block *n)
@@ -273,8 +271,9 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	*childregs = *regs;
 
 	childregs->ax = 0;
-	childregs->sp = sp;
-	if (sp == ~0UL)
+	if (user_mode(regs))
+		childregs->sp = sp;
+	else
 		childregs->sp = (unsigned long)childregs;
 
 	p->thread.sp = (unsigned long) childregs;
@@ -508,25 +507,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	return prev_p;
 }
 
-/*
- * sys_execve() executes a new program.
- */
-asmlinkage
-long sys_execve(char __user *name, char __user * __user *argv,
-		char __user * __user *envp, struct pt_regs *regs)
-{
-	long error;
-	char *filename;
-
-	filename = getname(name);
-	error = PTR_ERR(filename);
-	if (IS_ERR(filename))
-		return error;
-	error = do_execve(filename, argv, envp, regs);
-	putname(filename);
-	return error;
-}
-
 void set_personality_64bit(void)
 {
 	/* inherit personality from parent */
@@ -541,15 +521,6 @@ void set_personality_64bit(void)
 	current->personality &= ~READ_IMPLIES_EXEC;
 }
 
-asmlinkage long
-sys_clone(unsigned long clone_flags, unsigned long newsp,
-	  void __user *parent_tid, void __user *child_tid, struct pt_regs *regs)
-{
-	if (!newsp)
-		newsp = regs->sp;
-	return do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
-}
-
 unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long stack;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 74fe6d8..4fd173c 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -545,22 +545,12 @@ sys_sigaction(int sig, const struct old_sigaction __user *act,
 }
 #endif /* CONFIG_X86_32 */
 
-#ifdef CONFIG_X86_32
-int sys_sigaltstack(struct pt_regs *regs)
-{
-	const stack_t __user *uss = (const stack_t __user *)regs->bx;
-	stack_t __user *uoss = (stack_t __user *)regs->cx;
-
-	return do_sigaltstack(uss, uoss, regs->sp);
-}
-#else /* !CONFIG_X86_32 */
-asmlinkage long
+long
 sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		struct pt_regs *regs)
 {
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
-#endif /* CONFIG_X86_32 */
 
 /*
  * Do a signal return; undo the signal stack.
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 9c4e625..5ffb562 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -197,9 +197,8 @@ out:
 static int do_vm86_irq_handling(int subfunction, int irqnumber);
 static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk);
 
-int sys_vm86old(struct pt_regs *regs)
+int sys_vm86old(struct vm86_struct __user *v86, struct pt_regs *regs)
 {
-	struct vm86_struct __user *v86 = (struct vm86_struct __user *)regs->bx;
 	struct kernel_vm86_struct info; /* declare this _on top_,
 					 * this avoids wasting of stack space.
 					 * This remains on the stack until we
@@ -227,7 +226,7 @@ out:
 }
 
 
-int sys_vm86(struct pt_regs *regs)
+int sys_vm86(unsigned long cmd, unsigned long arg, struct pt_regs *regs)
 {
 	struct kernel_vm86_struct info; /* declare this _on top_,
 					 * this avoids wasting of stack space.
@@ -239,12 +238,12 @@ int sys_vm86(struct pt_regs *regs)
 	struct vm86plus_struct __user *v86;
 
 	tsk = current;
-	switch (regs->bx) {
+	switch (cmd) {
 	case VM86_REQUEST_IRQ:
 	case VM86_FREE_IRQ:
 	case VM86_GET_IRQ_BITS:
 	case VM86_GET_AND_RESET_IRQ:
-		ret = do_vm86_irq_handling(regs->bx, (int)regs->cx);
+		ret = do_vm86_irq_handling(cmd, (int)arg);
 		goto out;
 	case VM86_PLUS_INSTALL_CHECK:
 		/*
@@ -261,7 +260,7 @@ int sys_vm86(struct pt_regs *regs)
 	ret = -EPERM;
 	if (tsk->thread.saved_sp0)
 		goto out;
-	v86 = (struct vm86plus_struct __user *)regs->cx;
+	v86 = (struct vm86plus_struct __user *)arg;
 	tmp = copy_vm86_regs_from_user(&info.regs, &v86->regs,
 				       offsetof(struct kernel_vm86_struct, regs32) -
 				       sizeof(info.regs));
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index f3f2104..f92a0da 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -319,9 +319,7 @@ SECTIONS
 		__brk_limit = .;
 	}
 
-	.end : AT(ADDR(.end) - LOAD_OFFSET) {
-		_end = .;
-	}
+	_end = .;
 
         STABS_DEBUG
         DWARF_DEBUG
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index a102976..9fafaf8 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -17,8 +17,6 @@
 EXPORT_SYMBOL(mcount);
 #endif
 
-EXPORT_SYMBOL(kernel_thread);
-
 EXPORT_SYMBOL(__get_user_1);
 EXPORT_SYMBOL(__get_user_2);
 EXPORT_SYMBOL(__get_user_4);
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index e34e92a..7a68506 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -226,12 +226,12 @@ function add_flags(old,new) {
 }
 
 # convert operands to flags.
-function convert_operands(opnd,       i,imm,mod)
+function convert_operands(count,opnd,       i,j,imm,mod)
 {
 	imm = null
 	mod = null
-	for (i in opnd) {
-		i  = opnd[i]
+	for (j = 1; j <= count; j++) {
+		i = opnd[j]
 		if (match(i, imm_expr) == 1) {
 			if (!imm_flag[i])
 				semantic_error("Unknown imm opnd: " i)
@@ -282,8 +282,8 @@ function convert_operands(opnd,       i,imm,mod)
 		# parse one opcode
 		if (match($i, opnd_expr)) {
 			opnd = $i
-			split($(i++), opnds, ",")
-			flags = convert_operands(opnds)
+			count = split($(i++), opnds, ",")
+			flags = convert_operands(count, opnds)
 		}
 		if (match($i, ext_expr))
 			ext = $(i++)
