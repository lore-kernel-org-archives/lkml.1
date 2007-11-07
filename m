Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbXKGRnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbXKGRnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759208AbXKGRnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:43:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759079AbXKGRng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:43:36 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] Suppress A.OUT library support in ELF binfmt if
	!CONFIG_BINFMT_AOUT [try #3]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Wed, 07 Nov 2007 17:43:28 +0000
Message-ID: <20071107174328.31820.62935.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071107174323.31820.65054.stgit@warthog.procyon.org.uk>
References: <20071107174323.31820.65054.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suppress A.OUT library support in ELF binfmt if CONFIG_BINFMT_AOUT is not set.

Not all architectures support the A.OUT binfmt, so the ELF binfmt should not
be permitted to go looking for A.OUT libraries to load in such a case.  Not
only that, but under such conditions A.OUT core dumps are not produced either.

To make this work, this patch also does the following:

 (1) Makes the existence of the contents of linux/a.out.h more or less
     contingent on CONFIG_BINFMT_AOUT=[ym] or CONFIG_IA32_AOUT=[ym].

 (2) Moves STACK_TOP[_MAX] out of asm/a.out.h and into asm/processor.h as
     they're required whether or not A.OUT format is available.

 (3) Renames dump_thread() to aout_dump_thread() as it's only called by A.OUT
     core dumping code.

 (4) Makes aout_dump_thread()'s existence contingent on
     CONFIG_BINFMT_AOUT=[ym].

I suspect certain other arches that have an aout_dump_thread() function can
dispense entirely with it as they don't and won't support A.OUT.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/alpha/kernel/process.c         |    6 ++++--
 arch/arm/kernel/process.c           |    8 +++++---
 arch/blackfin/kernel/bfin_ksyms.c   |    1 -
 arch/blackfin/kernel/process.c      |    7 +++++--
 arch/m68k/kernel/process.c          |    8 +++++---
 arch/sparc/kernel/process.c         |    7 +++++--
 arch/sparc/kernel/sparc_ksyms.c     |    2 --
 arch/sparc64/kernel/binfmt_aout32.c |    2 +-
 arch/sparc64/kernel/binfmt_elf32.c  |    2 --
 arch/sparc64/kernel/process.c       |    6 ++++--
 arch/sparc64/kernel/sparc64_ksyms.c |    1 -
 arch/sparc64/kernel/sys_sparc.c     |    2 +-
 arch/sparc64/kernel/sys_sparc32.c   |    2 +-
 arch/um/kernel/ksyms.c              |    1 -
 arch/um/kernel/process.c            |    6 +++++-
 arch/x86/kernel/process_32.c        |    8 +++++---
 fs/binfmt_aout.c                    |    2 +-
 fs/binfmt_elf.c                     |   30 ++++++++++++++++++++++--------
 fs/exec.c                           |    2 +-
 include/asm-alpha/a.out.h           |    5 -----
 include/asm-alpha/processor.h       |    5 +++++
 include/asm-arm/a.out.h             |    6 ------
 include/asm-arm/processor.h         |    6 ++++++
 include/asm-avr32/a.out.h           |    7 -------
 include/asm-avr32/processor.h       |    5 +++++
 include/asm-blackfin/a.out.h        |    6 ------
 include/asm-blackfin/processor.h    |    4 ++++
 include/asm-cris/a.out.h            |    6 ------
 include/asm-cris/processor.h        |    3 +++
 include/asm-h8300/a.out.h           |    7 -------
 include/asm-h8300/processor.h       |    5 +++++
 include/asm-ia64/a.out.h            |    3 ---
 include/asm-m32r/a.out.h            |    7 -------
 include/asm-m32r/processor.h        |    5 +++++
 include/asm-m68k/a.out.h            |    7 -------
 include/asm-m68k/processor.h        |    5 +++++
 include/asm-mips/a.out.h            |   13 -------------
 include/asm-mips/processor.h        |    7 +++++++
 include/asm-parisc/a.out.h          |   10 ----------
 include/asm-parisc/processor.h      |   10 ++++++++++
 include/asm-powerpc/a.out.h         |   19 -------------------
 include/asm-powerpc/processor.h     |   19 +++++++++++++++++++
 include/asm-s390/a.out.h            |    7 -------
 include/asm-s390/processor.h        |    7 +++++++
 include/asm-sh/a.out.h              |    7 -------
 include/asm-sh/processor.h          |    7 +++++++
 include/asm-sh64/a.out.h            |    7 -------
 include/asm-sparc/a.out.h           |    9 ---------
 include/asm-sparc/processor.h       |    4 ++++
 include/asm-sparc64/a.out.h         |   12 ------------
 include/asm-sparc64/processor.h     |   14 +++++++++++++-
 include/asm-sparc64/uaccess.h       |    2 +-
 include/asm-sparc64/user.h          |    2 +-
 include/asm-um/a.out.h              |   13 -------------
 include/asm-um/processor-generic.h  |    8 ++++++++
 include/asm-x86/a.out.h             |   10 ----------
 include/asm-x86/processor_32.h      |    2 ++
 include/asm-x86/processor_64.h      |    2 ++
 include/asm-xtensa/a.out.h          |    5 -----
 include/asm-xtensa/processor.h      |    2 ++
 include/linux/a.out.h               |   17 +++++++++++++++++
 include/linux/kernel.h              |    2 --
 62 files changed, 203 insertions(+), 209 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 92b6162..e2e6593 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -320,8 +320,9 @@ copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
 /*
  * Fill in the user structure for an ECOFF core dump.
  */
+#if defined(CONFIG_BINFMT_AOUT) || defined defined(CONFIG_BINFMT_AOUT_MODULE)
 void
-dump_thread(struct pt_regs * pt, struct user * dump)
+aout_dump_thread(struct pt_regs * pt, struct user * dump)
 {
 	/* switch stack follows right below pt_regs: */
 	struct switch_stack * sw = ((struct switch_stack *) pt) - 1;
@@ -377,7 +378,8 @@ dump_thread(struct pt_regs * pt, struct user * dump)
 	dump->regs[EF_A2]  = pt->r18;
 	memcpy((char *)dump->regs + EF_SIZE, sw->fp, 32 * 8);
 }
-EXPORT_SYMBOL(dump_thread);
+EXPORT_SYMBOL(aout_dump_thread);
+#endif
 
 /*
  * Fill in the user structure for a ELF core dump.
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 4f1a031..7c91e0c 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -368,9 +368,10 @@ int dump_fpu (struct pt_regs *regs, struct user_fp *fp)
 EXPORT_SYMBOL(dump_fpu);
 
 /*
- * fill in the user structure for a core dump..
+ * fill in the user structure for an AOUT core dump..
  */
-void dump_thread(struct pt_regs * regs, struct user * dump)
+#if defined(CONFIG_BINFMT_AOUT) || defined defined(CONFIG_BINFMT_AOUT_MODULE)
+void aout_dump_thread(struct pt_regs * regs, struct user * dump)
 {
 	struct task_struct *tsk = current;
 
@@ -394,7 +395,8 @@ void dump_thread(struct pt_regs * regs, struct user * dump)
 	dump->regs = *regs;
 	dump->u_fpvalid = dump_fpu (regs, &dump->u_fp);
 }
-EXPORT_SYMBOL(dump_thread);
+EXPORT_SYMBOL(aout_dump_thread);
+#endif
 
 /*
  * Shuffle the argument into the correct register before calling the
diff --git a/arch/blackfin/kernel/bfin_ksyms.c b/arch/blackfin/kernel/bfin_ksyms.c
index 2198afe..99ea57c 100644
--- a/arch/blackfin/kernel/bfin_ksyms.c
+++ b/arch/blackfin/kernel/bfin_ksyms.c
@@ -39,7 +39,6 @@
 EXPORT_SYMBOL(__ioremap);
 EXPORT_SYMBOL(strcmp);
 EXPORT_SYMBOL(strncmp);
-EXPORT_SYMBOL(dump_thread);
 
 EXPORT_SYMBOL(ip_fast_csum);
 
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 9124467..4523b6f 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -239,9 +239,10 @@ copy_thread(int nr, unsigned long clone_flags,
 }
 
 /*
- * fill in the user structure for a core dump..
+ * fill in the user structure for an A.OUT core dump..
  */
-void dump_thread(struct pt_regs *regs, struct user *dump)
+#if defined(CONFIG_BINFMT_AOUT) || defined defined(CONFIG_BINFMT_AOUT_MODULE)
+void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 {
 	dump->magic = CMAGIC;
 	dump->start_code = 0;
@@ -282,6 +283,8 @@ void dump_thread(struct pt_regs *regs, struct user *dump)
 	dump->regs.astat = regs->astat;
 	dump->regs.pc = regs->pc;
 }
+EXPORT_SYMBOL(aout_dump_thread);
+#endif
 
 /*
  * sys_execve() executes a new program.
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 3ee9186..4a44099 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -316,9 +316,10 @@ int dump_fpu (struct pt_regs *regs, struct user_m68kfp_struct *fpu)
 EXPORT_SYMBOL(dump_fpu);
 
 /*
- * fill in the user structure for a core dump..
+ * fill in the user structure for an A.OUT core dump..
  */
-void dump_thread(struct pt_regs * regs, struct user * dump)
+#if defined(CONFIG_BINFMT_AOUT) || defined defined(CONFIG_BINFMT_AOUT_MODULE)
+void aout_dump_thread(struct pt_regs * regs, struct user * dump)
 {
 	struct switch_stack *sw;
 
@@ -360,7 +361,8 @@ void dump_thread(struct pt_regs * regs, struct user * dump)
 	/* dump floating point stuff */
 	dump->u_fpvalid = dump_fpu (regs, &dump->m68kfp);
 }
-EXPORT_SYMBOL(dump_thread);
+EXPORT_SYMBOL(aout_dump_thread);
+#endif
 
 /*
  * sys_execve() executes a new program.
diff --git a/arch/sparc/kernel/process.c b/arch/sparc/kernel/process.c
index 77460e3..d6dc76c 100644
--- a/arch/sparc/kernel/process.c
+++ b/arch/sparc/kernel/process.c
@@ -567,9 +567,10 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 }
 
 /*
- * fill in the user structure for a core dump..
+ * fill in the user structure for an A.OUT core dump..
  */
-void dump_thread(struct pt_regs * regs, struct user * dump)
+#if defined(CONFIG_BINFMT_AOUT) || defined defined(CONFIG_BINFMT_AOUT_MODULE)
+void aout_dump_thread(struct pt_regs * regs, struct user * dump)
 {
 	unsigned long first_stack_page;
 
@@ -597,6 +598,8 @@ void dump_thread(struct pt_regs * regs, struct user * dump)
 	       ((sizeof(unsigned long) * 2) * 16));
 	dump->sigcode = 0;
 }
+EXPORT_SYMBOL(aout_dump_thread);
+#endif
 
 /*
  * fill in the fpu structure for a core dump.
diff --git a/arch/sparc/kernel/sparc_ksyms.c b/arch/sparc/kernel/sparc_ksyms.c
index ef647ac..62f6221 100644
--- a/arch/sparc/kernel/sparc_ksyms.c
+++ b/arch/sparc/kernel/sparc_ksyms.c
@@ -214,8 +214,6 @@ EXPORT_SYMBOL(kunmap_atomic);
 EXPORT_SYMBOL(svr4_setcontext);
 EXPORT_SYMBOL(svr4_getcontext);
 
-EXPORT_SYMBOL(dump_thread);
-
 /* prom symbols */
 EXPORT_SYMBOL(idprom);
 EXPORT_SYMBOL(prom_root_node);
diff --git a/arch/sparc64/kernel/binfmt_aout32.c b/arch/sparc64/kernel/binfmt_aout32.c
index 92c1b36..2c24f93 100644
--- a/arch/sparc64/kernel/binfmt_aout32.c
+++ b/arch/sparc64/kernel/binfmt_aout32.c
@@ -101,7 +101,7 @@ static int aout32_core_dump(long signr, struct pt_regs *regs, struct file *file,
 	current->flags |= PF_DUMPCORE;
        	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
 	dump.signal = signr;
-	dump_thread(regs, &dump);
+	aout_dump_thread(regs, &dump);
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
diff --git a/arch/sparc64/kernel/binfmt_elf32.c b/arch/sparc64/kernel/binfmt_elf32.c
index 1587a29..bf635be 100644
--- a/arch/sparc64/kernel/binfmt_elf32.c
+++ b/arch/sparc64/kernel/binfmt_elf32.c
@@ -151,8 +151,6 @@ MODULE_AUTHOR("Eric Youngdale, David S. Miller, Jakub Jelinek");
 #undef MODULE_DESCRIPTION
 #undef MODULE_AUTHOR
 
-#include <asm/a.out.h>
-
 #undef TASK_SIZE
 #define TASK_SIZE STACK_TOP32
 
diff --git a/arch/sparc64/kernel/process.c b/arch/sparc64/kernel/process.c
index ca7cdfd..3642467 100644
--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -726,15 +726,17 @@ pid_t kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
 }
 
 /*
- * fill in the user structure for a core dump..
+ * fill in the user structure for an A.OUT core dump..
  */
-void dump_thread(struct pt_regs * regs, struct user * dump)
+#if defined(CONFIG_BINFMT_AOUT) || defined defined(CONFIG_BINFMT_AOUT_MODULE)
+void aout_dump_thread(struct pt_regs * regs, struct user * dump)
 {
 	/* Only should be used for SunOS and ancient a.out
 	 * SparcLinux binaries...  Not worth implementing.
 	 */
 	memset(dump, 0, sizeof(struct user));
 }
+#endif
 
 typedef struct {
 	union {
diff --git a/arch/sparc64/kernel/sparc64_ksyms.c b/arch/sparc64/kernel/sparc64_ksyms.c
index 60765e3..29a5af5 100644
--- a/arch/sparc64/kernel/sparc64_ksyms.c
+++ b/arch/sparc64/kernel/sparc64_ksyms.c
@@ -53,7 +53,6 @@
 #include <asm/ebus.h>
 #include <asm/isa.h>
 #endif
-#include <asm/a.out.h>
 #include <asm/ns87303.h>
 #include <asm/timer.h>
 #include <asm/cpudata.h>
diff --git a/arch/sparc64/kernel/sys_sparc.c b/arch/sparc64/kernel/sys_sparc.c
index c56573a..3c1a3ae 100644
--- a/arch/sparc64/kernel/sys_sparc.c
+++ b/arch/sparc64/kernel/sys_sparc.c
@@ -24,11 +24,11 @@
 #include <linux/ipc.h>
 #include <linux/personality.h>
 #include <linux/random.h>
+#include <linux/a.out.h>
 
 #include <asm/uaccess.h>
 #include <asm/utrap.h>
 #include <asm/perfctr.h>
-#include <asm/a.out.h>
 #include <asm/unistd.h>
 
 /* #define DEBUG_UNIMP_SYSCALL */
diff --git a/arch/sparc64/kernel/sys_sparc32.c b/arch/sparc64/kernel/sys_sparc32.c
index 78caff9..102a62a 100644
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -52,13 +52,13 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/ptrace.h>
 #include <linux/highuid.h>
+#include <linux/a.out.h>
 
 #include <asm/types.h>
 #include <asm/uaccess.h>
 #include <asm/fpumacro.h>
 #include <asm/semaphore.h>
 #include <asm/mmu_context.h>
-#include <asm/a.out.h>
 #include <asm/compat_signal.h>
 
 asmlinkage long sys32_chown16(const char __user * filename, u16 user, u16 group)
diff --git a/arch/um/kernel/ksyms.c b/arch/um/kernel/ksyms.c
index 1b388b4..d3a81dd 100644
--- a/arch/um/kernel/ksyms.c
+++ b/arch/um/kernel/ksyms.c
@@ -65,7 +65,6 @@ EXPORT_SYMBOL(os_accept_connection);
 EXPORT_SYMBOL(os_rcv_fd);
 EXPORT_SYMBOL(run_helper);
 EXPORT_SYMBOL(start_thread);
-EXPORT_SYMBOL(dump_thread);
 
 #ifdef CONFIG_SMP
 
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 0eae00b..19ebda0 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -4,6 +4,7 @@
  * Licensed under the GPL
  */
 
+#include "linux/module.h"
 #include "linux/stddef.h"
 #include "linux/err.h"
 #include "linux/hardirq.h"
@@ -303,9 +304,12 @@ char *current_cmd(void)
 #endif
 }
 
-void dump_thread(struct pt_regs *regs, struct user *u)
+#if defined(CONFIG_BINFMT_AOUT) || defined defined(CONFIG_BINFMT_AOUT_MODULE)
+void aout_dump_thread(struct pt_regs *regs, struct user *u)
 {
 }
+EXPORT_SYMBOL(aout_dump_thread);
+#endif
 
 int __cant_sleep(void) {
 	return in_atomic() || irqs_disabled() || in_interrupt();
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7b89958..14dc54d 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -514,9 +514,10 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long esp,
 }
 
 /*
- * fill in the user structure for a core dump..
+ * fill in the user structure for an A.OUT core dump..
  */
-void dump_thread(struct pt_regs * regs, struct user * dump)
+#if defined(CONFIG_BINFMT_AOUT) || defined defined(CONFIG_BINFMT_AOUT_MODULE)
+void aout_dump_thread(struct pt_regs * regs, struct user * dump)
 {
 	int i;
 
@@ -554,7 +555,8 @@ void dump_thread(struct pt_regs * regs, struct user * dump)
 
 	dump->u_fpvalid = dump_fpu (regs, &dump->i387);
 }
-EXPORT_SYMBOL(dump_thread);
+EXPORT_SYMBOL(aout_dump_thread);
+#endif
 
 /* 
  * Capture the user space registers if the task is not running (in user space)
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index e176d19..eb9f9d9 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -118,7 +118,7 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, u
 	dump.u_ar0 = (void *)(((unsigned long)(&dump.regs)) - ((unsigned long)(&dump)));
 #endif
 	dump.signal = signr;
-	dump_thread(regs, &dump);
+	aout_dump_thread(regs, &dump);
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index ba8de7c..b734848 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -464,6 +464,7 @@ out:
 	return error;
 }
 
+#ifdef CONFIG_BINFMT_AOUT
 static unsigned long load_aout_interp(struct exec *interp_ex,
 		struct file *interpreter)
 {
@@ -509,6 +510,10 @@ static unsigned long load_aout_interp(struct exec *interp_ex,
 out:
 	return elf_entry;
 }
+#else
+extern unsigned long load_aout_interp(struct exec *interp_ex,
+				      struct file *interpreter);
+#endif
 
 /*
  * These are the functions used to load ELF style executables and shared
@@ -516,9 +521,15 @@ out:
  */
 
 #define INTERPRETER_NONE 0
-#define INTERPRETER_AOUT 1
 #define INTERPRETER_ELF 2
 
+#ifdef CONFIG_BINFMT_AOUT
+#define INTERPRETER_AOUT 1
+#define IS_AOUT_INTERP(x) ((x) == INTERPRETER_AOUT)
+#else
+#define IS_AOUT_INTERP(x) (0)
+#endif
+
 #ifndef STACK_RND_MASK
 #define STACK_RND_MASK (0x7ff >> (PAGE_SHIFT - 12))	/* 8MB of VA */
 #endif
@@ -734,6 +745,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
 		static int warn;
+#ifdef CONFIG_BINFMT_AOUT
 		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
 
 		/* Now figure out which format our binary is */
@@ -741,11 +753,13 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		    (N_MAGIC(loc->interp_ex) != ZMAGIC) &&
 		    (N_MAGIC(loc->interp_ex) != QMAGIC))
 			interpreter_type = INTERPRETER_ELF;
-
+#else
+		interpreter_type = INTERPRETER_ELF;
+#endif
 		if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
 			interpreter_type &= ~INTERPRETER_ELF;
 
-		if (interpreter_type == INTERPRETER_AOUT && warn < 10) {
+		if (IS_AOUT_INTERP(interpreter_type) && warn < 10) {
 			printk(KERN_WARNING "a.out ELF interpreter %s is "
 				"deprecated and will not be supported "
 				"after Linux 2.6.25\n", elf_interpreter);
@@ -774,7 +788,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	/* OK, we are done with that, now set up the arg stuff,
 	   and then start this sucker up */
-	if ((!bprm->sh_bang) && (interpreter_type == INTERPRETER_AOUT)) {
+	if (IS_AOUT_INTERP(interpreter_type) && !bprm->sh_bang) {
 		char *passed_p = passed_fileno;
 		sprintf(passed_fileno, "%d", elf_exec_fileno);
 
@@ -961,7 +975,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT)
+		if (IS_AOUT_INTERP(interpreter_type))
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
 		else
@@ -990,7 +1004,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	kfree(elf_phdata);
 
-	if (interpreter_type != INTERPRETER_AOUT)
+	if (!IS_AOUT_INTERP(interpreter_type))
 		sys_close(elf_exec_fileno);
 
 	set_binfmt(&elf_format);
@@ -1006,14 +1020,14 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	compute_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 	retval = create_elf_tables(bprm, &loc->elf_ex,
-			  (interpreter_type == INTERPRETER_AOUT),
+			  IS_AOUT_INTERP(interpreter_type),
 			  load_addr, interp_load_addr);
 	if (retval < 0) {
 		send_sig(SIGKILL, current, 0);
 		goto out;
 	}
 	/* N.B. passed_fileno might not be initialized? */
-	if (interpreter_type == INTERPRETER_AOUT)
+	if (IS_AOUT_INTERP(interpreter_type))
 		current->mm->arg_start += strlen(passed_fileno) + 1;
 	current->mm->end_code = end_code;
 	current->mm->start_code = start_code;
diff --git a/fs/exec.c b/fs/exec.c
index 2c942e2..3eb8543 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1188,7 +1188,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 {
 	int try,retval;
 	struct linux_binfmt *fmt;
-#ifdef __alpha__
+#if defined(__alpha__) && defined(CONFIG_BINFMT_AOUT)
 	/* handle /sbin/loader.. */
 	{
 	    struct exec * eh = (struct exec *) bprm->buf;
diff --git a/include/asm-alpha/a.out.h b/include/asm-alpha/a.out.h
index e43cf61..a6a7c1e 100644
--- a/include/asm-alpha/a.out.h
+++ b/include/asm-alpha/a.out.h
@@ -98,11 +98,6 @@ struct exec
 	set_personality (((BFPM->sh_bang || EX.ah.entry < 0x100000000L \
 			   ? ADDR_LIMIT_32BIT : 0) | PER_OSF4))
 
-#define STACK_TOP \
-  (current->personality & ADDR_LIMIT_32BIT ? 0x80000000 : 0x00120000000UL)
-
-#define STACK_TOP_MAX	0x00120000000UL
-
 #endif
 
 #endif /* __A_OUT_GNU_H__ */
diff --git a/include/asm-alpha/processor.h b/include/asm-alpha/processor.h
index 425b7b6..94afe58 100644
--- a/include/asm-alpha/processor.h
+++ b/include/asm-alpha/processor.h
@@ -20,6 +20,11 @@
  */
 #define TASK_SIZE (0x40000000000UL)
 
+#define STACK_TOP \
+  (current->personality & ADDR_LIMIT_32BIT ? 0x80000000 : 0x00120000000UL)
+
+#define STACK_TOP_MAX	0x00120000000UL
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-arm/a.out.h b/include/asm-arm/a.out.h
index d7165e8..79489fd 100644
--- a/include/asm-arm/a.out.h
+++ b/include/asm-arm/a.out.h
@@ -27,12 +27,6 @@ struct exec
 
 #define M_ARM 103
 
-#ifdef __KERNEL__
-#define STACK_TOP	((current->personality == PER_LINUX_32BIT) ? \
-			 TASK_SIZE : TASK_SIZE_26)
-#define STACK_TOP_MAX	TASK_SIZE
-#endif
-
 #ifndef LIBRARY_START_TEXT
 #define LIBRARY_START_TEXT	(0x00c00000)
 #endif
diff --git a/include/asm-arm/processor.h b/include/asm-arm/processor.h
index 1bbf161..bd8029e 100644
--- a/include/asm-arm/processor.h
+++ b/include/asm-arm/processor.h
@@ -22,6 +22,12 @@
 #include <asm/ptrace.h>
 #include <asm/types.h>
 
+#ifdef __KERNEL__
+#define STACK_TOP	((current->personality == PER_LINUX_32BIT) ? \
+			 TASK_SIZE : TASK_SIZE_26)
+#define STACK_TOP_MAX	TASK_SIZE
+#endif
+
 union debug_insn {
 	u32	arm;
 	u16	thumb;
diff --git a/include/asm-avr32/a.out.h b/include/asm-avr32/a.out.h
index 9f398ab..e46375a 100644
--- a/include/asm-avr32/a.out.h
+++ b/include/asm-avr32/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __ASM_AVR32_A_OUT_H */
diff --git a/include/asm-avr32/processor.h b/include/asm-avr32/processor.h
index 6a64833..545520e 100644
--- a/include/asm-avr32/processor.h
+++ b/include/asm-avr32/processor.h
@@ -13,6 +13,11 @@
 
 #define TASK_SIZE	0x80000000
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 #ifndef __ASSEMBLY__
 
 static inline void *current_text_addr(void)
diff --git a/include/asm-blackfin/a.out.h b/include/asm-blackfin/a.out.h
index d37a684..6c3d652 100644
--- a/include/asm-blackfin/a.out.h
+++ b/include/asm-blackfin/a.out.h
@@ -16,10 +16,4 @@ struct exec {
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-
-#endif
-
 #endif				/* __BFIN_A_OUT_H__ */
diff --git a/include/asm-blackfin/processor.h b/include/asm-blackfin/processor.h
index c571e95..1033e5c 100644
--- a/include/asm-blackfin/processor.h
+++ b/include/asm-blackfin/processor.h
@@ -30,6 +30,10 @@ static inline void wrusp(unsigned long usp)
 extern unsigned long memory_end;
 #define TASK_SIZE	(memory_end)
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#endif
+
 #define TASK_UNMAPPED_BASE	0
 
 struct thread_struct {
diff --git a/include/asm-cris/a.out.h b/include/asm-cris/a.out.h
index 919b34a..c82e9f9 100644
--- a/include/asm-cris/a.out.h
+++ b/include/asm-cris/a.out.h
@@ -6,11 +6,6 @@
  * wants to know about a.out even if there is no interpreter available...
  */
 
-/* grabbed from the intel stuff  */   
-#define STACK_TOP TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-
 struct exec
 {
   unsigned long a_info;		/* Use macros N_MAGIC, etc for access */
@@ -28,5 +23,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-
 #endif
diff --git a/include/asm-cris/processor.h b/include/asm-cris/processor.h
index 568da1d..cdc0c1d 100644
--- a/include/asm-cris/processor.h
+++ b/include/asm-cris/processor.h
@@ -17,6 +17,9 @@
 
 struct task_struct;
 
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-h8300/a.out.h b/include/asm-h8300/a.out.h
index aa5d227..ded780f 100644
--- a/include/asm-h8300/a.out.h
+++ b/include/asm-h8300/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __H8300_A_OUT_H__ */
diff --git a/include/asm-h8300/processor.h b/include/asm-h8300/processor.h
index 49fc886..69e8a34 100644
--- a/include/asm-h8300/processor.h
+++ b/include/asm-h8300/processor.h
@@ -39,6 +39,11 @@ static inline void wrusp(unsigned long usp) {
  */
 #define TASK_SIZE	(0xFFFFFFFFUL)
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 /*
  * This decides where the kernel will search for a free chunk of vm
  * space during mmap's. We won't be using it
diff --git a/include/asm-ia64/a.out.h b/include/asm-ia64/a.out.h
index 7293ac1..193dcfb 100644
--- a/include/asm-ia64/a.out.h
+++ b/include/asm-ia64/a.out.h
@@ -29,7 +29,4 @@ struct exec {
 #define N_SYMSIZE(x)	0
 #define N_TXTOFF(x)	0
 
-#ifdef __KERNEL__
-#include <asm/ustack.h>
-#endif
 #endif /* _ASM_IA64_A_OUT_H */
diff --git a/include/asm-m32r/a.out.h b/include/asm-m32r/a.out.h
index 6a1b5d4..ab150f5 100644
--- a/include/asm-m32r/a.out.h
+++ b/include/asm-m32r/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* _ASM_M32R_A_OUT_H */
diff --git a/include/asm-m32r/processor.h b/include/asm-m32r/processor.h
index 32755bf..1a997fc 100644
--- a/include/asm-m32r/processor.h
+++ b/include/asm-m32r/processor.h
@@ -60,6 +60,11 @@ extern struct cpuinfo_m32r cpu_data[];
 #define TASK_SIZE  (0x00400000UL)
 #endif
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-m68k/a.out.h b/include/asm-m68k/a.out.h
index 6fc86a2..3885fe4 100644
--- a/include/asm-m68k/a.out.h
+++ b/include/asm-m68k/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __M68K_A_OUT_H__ */
diff --git a/include/asm-m68k/processor.h b/include/asm-m68k/processor.h
index 4453ec3..1f61ef5 100644
--- a/include/asm-m68k/processor.h
+++ b/include/asm-m68k/processor.h
@@ -41,6 +41,11 @@ static inline void wrusp(unsigned long usp)
 #define TASK_SIZE	(0x0E000000UL)
 #endif
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-mips/a.out.h b/include/asm-mips/a.out.h
index bf55a5b..cad8371 100644
--- a/include/asm-mips/a.out.h
+++ b/include/asm-mips/a.out.h
@@ -32,17 +32,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#ifdef CONFIG_32BIT
-#define STACK_TOP	TASK_SIZE
-#endif
-#ifdef CONFIG_64BIT
-#define STACK_TOP	\
-      (test_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
-#endif
-#define STACK_TOP_MAX	TASK_SIZE
-
-#endif
-
 #endif /* _ASM_A_OUT_H */
diff --git a/include/asm-mips/processor.h b/include/asm-mips/processor.h
index 83bc945..612f99e 100644
--- a/include/asm-mips/processor.h
+++ b/include/asm-mips/processor.h
@@ -39,6 +39,7 @@ extern unsigned int vced_count, vcei_count;
  * so don't change it unless you know what you are doing.
  */
 #define TASK_SIZE	0x7fff8000UL
+#define STACK_TOP	TASK_SIZE
 
 /*
  * This decides where the kernel will search for a free chunk of vm
@@ -57,6 +58,8 @@ extern unsigned int vced_count, vcei_count;
  */
 #define TASK_SIZE32	0x7fff8000UL
 #define TASK_SIZE	0x10000000000UL
+#define STACK_TOP	\
+      (test_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
 
 /*
  * This decides where the kernel will search for a free chunk of vm
@@ -67,6 +70,10 @@ extern unsigned int vced_count, vcei_count;
 		PAGE_ALIGN(TASK_SIZE32 / 3) : PAGE_ALIGN(TASK_SIZE / 3))
 #endif
 
+#ifdef __KERNEL__
+#define STACK_TOP_MAX	TASK_SIZE
+#endif
+
 #define NUM_FPU_REGS	32
 
 typedef __u64 fpureg_t;
diff --git a/include/asm-parisc/a.out.h b/include/asm-parisc/a.out.h
index 23e2c90..eb04e34 100644
--- a/include/asm-parisc/a.out.h
+++ b/include/asm-parisc/a.out.h
@@ -17,14 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-/* XXX: STACK_TOP actually should be STACK_BOTTOM for parisc.
- * prumpf */
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
-
-#endif
-
 #endif /* __A_OUT_GNU_H__ */
diff --git a/include/asm-parisc/processor.h b/include/asm-parisc/processor.h
index 6b294fb..802c86c 100644
--- a/include/asm-parisc/processor.h
+++ b/include/asm-parisc/processor.h
@@ -46,6 +46,16 @@
 #define DEFAULT_MAP_BASE	DEFAULT_MAP_BASE32
 #endif
 
+#ifdef __KERNEL__
+
+/* XXX: STACK_TOP actually should be STACK_BOTTOM for parisc.
+ * prumpf */
+
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
+
+#endif
+
 #ifndef __ASSEMBLY__
 
 /*
diff --git a/include/asm-powerpc/a.out.h b/include/asm-powerpc/a.out.h
index 5c5ea83..89cead6 100644
--- a/include/asm-powerpc/a.out.h
+++ b/include/asm-powerpc/a.out.h
@@ -17,23 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-#ifdef __powerpc64__
-
-#define STACK_TOP_USER64 TASK_SIZE_USER64
-#define STACK_TOP_USER32 TASK_SIZE_USER32
-
-#define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
-		   STACK_TOP_USER32 : STACK_TOP_USER64)
-
-#define STACK_TOP_MAX STACK_TOP_USER64
-
-#else /* __powerpc64__ */
-
-#define STACK_TOP TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif /* __powerpc64__ */
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_POWERPC_A_OUT_H */
diff --git a/include/asm-powerpc/processor.h b/include/asm-powerpc/processor.h
index dba7c94..a16d4a2 100644
--- a/include/asm-powerpc/processor.h
+++ b/include/asm-powerpc/processor.h
@@ -112,6 +112,25 @@ extern struct task_struct *last_task_used_spe;
 		TASK_UNMAPPED_BASE_USER32 : TASK_UNMAPPED_BASE_USER64 )
 #endif
 
+#ifdef __KERNEL__
+#ifdef __powerpc64__
+
+#define STACK_TOP_USER64 TASK_SIZE_USER64
+#define STACK_TOP_USER32 TASK_SIZE_USER32
+
+#define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
+		   STACK_TOP_USER32 : STACK_TOP_USER64)
+
+#define STACK_TOP_MAX STACK_TOP_USER64
+
+#else /* __powerpc64__ */
+
+#define STACK_TOP TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+
+#endif /* __powerpc64__ */
+#endif /* __KERNEL__ */
+
 typedef struct {
 	unsigned long seg;
 } mm_segment_t;
diff --git a/include/asm-s390/a.out.h b/include/asm-s390/a.out.h
index 46158dc..8d6bd9c 100644
--- a/include/asm-s390/a.out.h
+++ b/include/asm-s390/a.out.h
@@ -29,11 +29,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
-
-#endif
-
 #endif /* __A_OUT_GNU_H__ */
diff --git a/include/asm-s390/processor.h b/include/asm-s390/processor.h
index 21d40a1..3ade4c4 100644
--- a/include/asm-s390/processor.h
+++ b/include/asm-s390/processor.h
@@ -80,6 +80,13 @@ extern struct task_struct *last_task_used_math;
 
 #endif /* __s390x__ */
 
+#ifdef __KERNEL__
+
+#define STACK_TOP		TASK_SIZE
+#define STACK_TOP_MAX		DEFAULT_TASK_SIZE
+
+#endif
+
 #define HAVE_ARCH_PICK_MMAP_LAYOUT
 
 typedef struct {
diff --git a/include/asm-sh/a.out.h b/include/asm-sh/a.out.h
index 685d0f6..1f93130 100644
--- a/include/asm-sh/a.out.h
+++ b/include/asm-sh/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __ASM_SH_A_OUT_H */
diff --git a/include/asm-sh/processor.h b/include/asm-sh/processor.h
index ab0028d..97e77d9 100644
--- a/include/asm-sh/processor.h
+++ b/include/asm-sh/processor.h
@@ -85,6 +85,13 @@ extern struct sh_cpuinfo cpu_data[];
  */
 #define TASK_SIZE	0x7c000000UL
 
+#ifdef __KERNEL__
+
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+
+#endif
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-sh64/a.out.h b/include/asm-sh64/a.out.h
index 237ee4e..c55b85b 100644
--- a/include/asm-sh64/a.out.h
+++ b/include/asm-sh64/a.out.h
@@ -28,11 +28,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __ASM_SH64_A_OUT_H */
diff --git a/include/asm-sparc/a.out.h b/include/asm-sparc/a.out.h
index 917e042..744cfe6 100644
--- a/include/asm-sparc/a.out.h
+++ b/include/asm-sparc/a.out.h
@@ -87,13 +87,4 @@ struct relocation_info /* used when header.a_machtype == M_SPARC */
 
 #define N_RELOCATION_INFO_DECLARED 1
 
-#ifdef __KERNEL__
-
-#include <asm/page.h>
-
-#define STACK_TOP	(PAGE_OFFSET - PAGE_SIZE)
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif /* __KERNEL__ */
-
 #endif /* __SPARC_A_OUT_H__ */
diff --git a/include/asm-sparc/processor.h b/include/asm-sparc/processor.h
index 6fbb3f0..40b1e41 100644
--- a/include/asm-sparc/processor.h
+++ b/include/asm-sparc/processor.h
@@ -33,6 +33,10 @@
  * we can make our access_ok test faster
  */
 #define TASK_SIZE	PAGE_OFFSET
+#ifdef __KERNEL__
+#define STACK_TOP	(PAGE_OFFSET - PAGE_SIZE)
+#define STACK_TOP_MAX	STACK_TOP
+#endif /* __KERNEL__ */
 
 struct task_struct;
 
diff --git a/include/asm-sparc64/a.out.h b/include/asm-sparc64/a.out.h
index 902e07f..53c95bd 100644
--- a/include/asm-sparc64/a.out.h
+++ b/include/asm-sparc64/a.out.h
@@ -93,18 +93,6 @@ struct relocation_info /* used when header.a_machtype == M_SPARC */
 
 #define N_RELOCATION_INFO_DECLARED 1
 
-#ifdef __KERNEL__
-
-#define STACK_TOP32	((1UL << 32UL) - PAGE_SIZE)
-#define STACK_TOP64	(0x0000080000000000UL - (1UL << 32UL))
-
-#define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
-		   STACK_TOP32 : STACK_TOP64)
-
-#define STACK_TOP_MAX STACK_TOP64
-
-#endif
-
 #endif /* !(__ASSEMBLY__) */
 
 #endif /* !(__SPARC64_A_OUT_H__) */
diff --git a/include/asm-sparc64/processor.h b/include/asm-sparc64/processor.h
index 66dd2fa..16e2819 100644
--- a/include/asm-sparc64/processor.h
+++ b/include/asm-sparc64/processor.h
@@ -14,7 +14,7 @@
 #define current_text_addr() ({ void *pc; __asm__("rd %%pc, %0" : "=r" (pc)); pc; })
 
 #include <asm/asi.h>
-#include <asm/a.out.h>
+#include <linux/a.out.h>
 #include <asm/pstate.h>
 #include <asm/ptrace.h>
 #include <asm/page.h>
@@ -36,7 +36,19 @@
 #else
 #define VPTE_SIZE	(1 << (VA_BITS - PAGE_SHIFT + 3))
 #endif
+
 #define TASK_SIZE	((unsigned long)-VPTE_SIZE)
+#ifdef __KERNEL__
+
+#define STACK_TOP32	((1UL << 32UL) - PAGE_SIZE)
+#define STACK_TOP64	(0x0000080000000000UL - (1UL << 32UL))
+
+#define STACK_TOP	(test_thread_flag(TIF_32BIT) ? \
+			 STACK_TOP32 : STACK_TOP64)
+
+#define STACK_TOP_MAX	STACK_TOP64
+
+#endif
 
 #ifndef __ASSEMBLY__
 
diff --git a/include/asm-sparc64/uaccess.h b/include/asm-sparc64/uaccess.h
index 93720e7..4235fbc 100644
--- a/include/asm-sparc64/uaccess.h
+++ b/include/asm-sparc64/uaccess.h
@@ -10,7 +10,7 @@
 #include <linux/compiler.h>
 #include <linux/sched.h>
 #include <linux/string.h>
-#include <asm/a.out.h>
+#include <linux/a.out.h>
 #include <asm/asi.h>
 #include <asm/system.h>
 #include <asm/spitfire.h>
diff --git a/include/asm-sparc64/user.h b/include/asm-sparc64/user.h
index fce4e85..02b1389 100644
--- a/include/asm-sparc64/user.h
+++ b/include/asm-sparc64/user.h
@@ -8,7 +8,7 @@
 #ifndef _SPARC64_USER_H
 #define _SPARC64_USER_H
 
-#include <asm/a.out.h>
+#include <linux/a.out.h>
 struct sunos_regs {
 	unsigned int psr, pc, npc, y;
 	unsigned int regs[15];
diff --git a/include/asm-um/a.out.h b/include/asm-um/a.out.h
index 9281dd8..754181e 100644
--- a/include/asm-um/a.out.h
+++ b/include/asm-um/a.out.h
@@ -8,17 +8,4 @@
 
 #include "asm/arch/a.out.h"
 
-#undef STACK_TOP
-#undef STACK_TOP_MAX
-
-extern unsigned long stacksizelim;
-
-extern unsigned long host_task_size;
-
-#define STACK_ROOM (stacksizelim)
-
-#define STACK_TOP task_size
-
-#define STACK_TOP_MAX STACK_TOP
-
 #endif
diff --git a/include/asm-um/processor-generic.h b/include/asm-um/processor-generic.h
index 78c0599..4b4bb18 100644
--- a/include/asm-um/processor-generic.h
+++ b/include/asm-um/processor-generic.h
@@ -98,9 +98,17 @@ static inline void mm_copy_segments(struct mm_struct *from_mm,
  * User space process size: 3GB (default).
  */
 extern unsigned long task_size;
+extern unsigned long stacksizelim;
+extern unsigned long host_task_size;
 
 #define TASK_SIZE	(task_size)
 
+#undef STACK_TOP
+#undef STACK_TOP_MAX
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#define STACK_ROOM	(stacksizelim)
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-x86/a.out.h b/include/asm-x86/a.out.h
index a62443e..4684f97 100644
--- a/include/asm-x86/a.out.h
+++ b/include/asm-x86/a.out.h
@@ -17,14 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-# include <linux/thread_info.h>
-# define STACK_TOP	TASK_SIZE
-# ifdef CONFIG_X86_32
-#  define STACK_TOP_MAX	STACK_TOP
-# else
-#  define STACK_TOP_MAX	TASK_SIZE64
-# endif
-#endif
-
 #endif /* _ASM_X86_A_OUT_H */
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index 13976b0..7976787 100644
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -214,6 +214,8 @@ extern int bootloader_type;
  * User space process size: 3GB (default).
  */
 #define TASK_SIZE	(PAGE_OFFSET)
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
diff --git a/include/asm-x86/processor_64.h b/include/asm-x86/processor_64.h
index e4f1997..6b9b33f 100644
--- a/include/asm-x86/processor_64.h
+++ b/include/asm-x86/processor_64.h
@@ -148,6 +148,8 @@ static inline void clear_in_cr4 (unsigned long mask)
 #define TASK_SIZE_OF(child) 	((test_tsk_thread_flag(child, TIF_IA32)) ? IA32_PAGE_OFFSET : TASK_SIZE64)
 
 #define TASK_UNMAPPED_BASE	PAGE_ALIGN(TASK_SIZE/3)
+#define STACK_TOP		TASK_SIZE
+#define STACK_TOP_MAX		TASK_SIZE64
 
 /*
  * Size of io_bitmap.
diff --git a/include/asm-xtensa/a.out.h b/include/asm-xtensa/a.out.h
index 05a2f67..fdf1370 100644
--- a/include/asm-xtensa/a.out.h
+++ b/include/asm-xtensa/a.out.h
@@ -14,11 +14,6 @@
 #ifndef _XTENSA_A_OUT_H
 #define _XTENSA_A_OUT_H
 
-/* Note: the kernel needs the a.out definitions, even if only ELF is used. */
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
 struct exec
 {
   unsigned long a_info;
diff --git a/include/asm-xtensa/processor.h b/include/asm-xtensa/processor.h
index 35145bc..96408f4 100644
--- a/include/asm-xtensa/processor.h
+++ b/include/asm-xtensa/processor.h
@@ -34,6 +34,8 @@
  */
 
 #define TASK_SIZE	__XTENSA_UL_CONST(0x40000000)
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 /*
  * General exception cause assigned to debug exceptions. Debug exceptions go
diff --git a/include/linux/a.out.h b/include/linux/a.out.h
index f913cc3..999ec22 100644
--- a/include/linux/a.out.h
+++ b/include/linux/a.out.h
@@ -1,6 +1,11 @@
 #ifndef __A_OUT_GNU_H__
 #define __A_OUT_GNU_H__
 
+#if defined(CONFIG_BINFMT_AOUT) || \
+	defined(CONFIG_BINFMT_AOUT_MODULE) || \
+	defined(CONFIG_IA32_AOUT) || \
+	defined(CONFIG_IA32_AOUT_MODULE)
+
 #define __GNU_EXEC_MACROS__
 
 #ifndef __STRUCT_EXEC_OVERRIDE__
@@ -265,4 +270,16 @@ struct relocation_info
 #endif /* no N_RELOCATION_INFO_DECLARED.  */
 
 
+#ifdef __KERNEL__
+struct pt_regs;
+struct user;
+extern void aout_dump_thread(struct pt_regs *regs, struct user *dump);
+#endif
+
+#else /* CONFIG_BINFMT_AOUT||CONFIG_IA32_AOUT */
+#ifndef __ASSEMBLY__
+struct exec {
+};
+#endif
+#endif /* CONFIG_BINFMT_AOUT||CONFIG_IA32_AOUT */
 #endif /* __A_OUT_GNU_H__ */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 94bc996..c34055a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -172,8 +172,6 @@ extern int kernel_text_address(unsigned long addr);
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
-extern void dump_thread(struct pt_regs *regs, struct user *dump);
-
 #ifdef CONFIG_PRINTK
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));

