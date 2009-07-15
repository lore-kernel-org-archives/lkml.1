Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZGOHUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZGOHUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZGOHUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:20:19 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:50929 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZGOHUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:20:17 -0400
Subject: [PATCH V3] score: add ptrace regsets support for score.
From: Chen Liqin <liqin.chen@sunplusct.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, liqin.gnu@gmail.com
Content-Type: text/plain
Date: Wed, 15 Jul 2009 14:33:46 +0800
Message-Id: <1247639626.6808.10.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 417a404114f3d69d42a9bb29258d67b08512c9d0 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 15 Jul 2009 13:52:41 +0800
Subject: [PATCH V3] score: add ptrace regsets support for score.
ptrace.c add register sets support for score architecture.

- genregs_get(struct task_struct *target,
		const struct user_regset *regset,
		unsigned int pos, unsigned int count,
		void *kbuf, void __user *ubuf)
	Retrieve the contents of score userspace general registers.

- genregs_set(struct task_struct *target,
		const struct user_regset *regset,
		unsigned int pos, unsigned int count,
		const void *kbuf, const void __user *ubuf)
	Update the contents of the score userspace general registers.

- remove PTRACE_PEEKUSR and PTRACE_POKEUSR code from arch_ptrace.

Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/elf.h    |   18 ++--
 arch/score/include/asm/ptrace.h |    8 +-
 arch/score/include/asm/user.h   |   17 +++
 arch/score/kernel/ptrace.c      |  211 ++++++++++++++++++---------------------
 4 files changed, 129 insertions(+), 125 deletions(-)

diff --git a/arch/score/include/asm/elf.h b/arch/score/include/asm/elf.h
index 8324363..43526d9 100644
--- a/arch/score/include/asm/elf.h
+++ b/arch/score/include/asm/elf.h
@@ -1,9 +1,8 @@
 #ifndef _ASM_SCORE_ELF_H
 #define _ASM_SCORE_ELF_H
 
-/* ELF register definitions */
-#define ELF_NGREG	45
-#define ELF_NFPREG	33
+#include <linux/ptrace.h>
+
 #define EM_SCORE7	135
 
 /* Relocation types. */
@@ -30,11 +29,15 @@
 #define R_SCORE_IMM30		20
 #define R_SCORE_IMM32		21
 
-typedef unsigned long elf_greg_t;
-typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+/* ELF register definitions */
+typedef unsigned long	elf_greg_t;
+
+#define ELF_NGREG	(sizeof(struct pt_regs) / sizeof(elf_greg_t))
+typedef elf_greg_t	elf_gregset_t[ELF_NGREG];
 
-typedef double elf_fpreg_t;
-typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
+/* Score does not have fp regs. */
+typedef double		elf_fpreg_t;
+typedef elf_fpreg_t	elf_fpregset_t;
 
 #define elf_check_arch(x)	((x)->e_machine == EM_SCORE7)
 
@@ -57,6 +60,7 @@ do {								\
 struct task_struct;
 struct pt_regs;
 
+#define CORE_DUMP_USE_REGSET
 #define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
diff --git a/arch/score/include/asm/ptrace.h b/arch/score/include/asm/ptrace.h
index 66b14c8..d40e691 100644
--- a/arch/score/include/asm/ptrace.h
+++ b/arch/score/include/asm/ptrace.h
@@ -51,9 +51,11 @@
  * system call/exception. As usual the registers k0/k1 aren't being saved.
  */
 struct pt_regs {
-	unsigned long pad0[6];
+	unsigned long pad0[6];	/* stack arguments */
 	unsigned long orig_r4;
 	unsigned long orig_r7;
+	long is_syscall;
+
 	unsigned long regs[32];
 
 	unsigned long cel;
@@ -68,12 +70,12 @@ struct pt_regs {
 	unsigned long cp0_psr;
 	unsigned long cp0_ecr;
 	unsigned long cp0_condition;
-
-	long is_syscall;
 };
 
 #ifdef __KERNEL__
 
+struct task_struct;
+
 /*
  * Does the process account for user or for system time?
  */
diff --git a/arch/score/include/asm/user.h b/arch/score/include/asm/user.h
index 3cf7572..7bfb8e2 100644
--- a/arch/score/include/asm/user.h
+++ b/arch/score/include/asm/user.h
@@ -1,4 +1,21 @@
 #ifndef _ASM_SCORE_USER_H
 #define _ASM_SCORE_USER_H
 
+struct user_regs_struct {
+	unsigned long regs[32];
+
+	unsigned long cel;
+	unsigned long ceh;
+
+	unsigned long sr0;	/* cnt */
+	unsigned long sr1;	/* lcr */
+	unsigned long sr2;	/* scr */
+
+	unsigned long cp0_epc;
+	unsigned long cp0_ema;
+	unsigned long cp0_psr;
+	unsigned long cp0_ecr;
+	unsigned long cp0_condition;
+};
+
 #endif /* _ASM_SCORE_USER_H */
diff --git a/arch/score/kernel/ptrace.c b/arch/score/kernel/ptrace.c
index 1db876b..c353f84 100644
--- a/arch/score/kernel/ptrace.c
+++ b/arch/score/kernel/ptrace.c
@@ -23,11 +23,99 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/elf.h>
 #include <linux/kernel.h>
 #include <linux/ptrace.h>
+#include <linux/regset.h>
 
 #include <asm/uaccess.h>
 
+/*
+ * retrieve the contents of SCORE userspace general registers
+ */
+static int genregs_get(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       void *kbuf, void __user *ubuf)
+{
+	const struct pt_regs *regs = task_pt_regs(target);
+	int ret;
+
+	/* skip 9 * sizeof(unsigned long) not use for pt_regs */
+	ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					0, offsetof(struct pt_regs, regs));
+
+	/* r0 - r31, cel, ceh, sr0, sr1, sr2, epc, ema, psr, ecr, condition */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  regs->regs,
+				  offsetof(struct pt_regs, regs),
+				  offsetof(struct pt_regs, cp0_condition));
+
+	if (!ret)
+		ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+						sizeof(struct pt_regs), -1);
+
+	return ret;
+}
+
+/*
+ * update the contents of the SCORE userspace general registers
+ */
+static int genregs_set(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       const void *kbuf, const void __user *ubuf)
+{
+	struct pt_regs *regs = task_pt_regs(target);
+	int ret;
+
+	/* skip 9 * sizeof(unsigned long) */
+	ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					0, offsetof(struct pt_regs, regs));
+
+	/* r0 - r31, cel, ceh, sr0, sr1, sr2, epc, ema, psr, ecr, condition */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				  regs->regs,
+				  offsetof(struct pt_regs, regs),
+				  offsetof(struct pt_regs, cp0_condition));
+
+	if (!ret)
+		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+						sizeof(struct pt_regs), -1);
+
+	return ret;
+}
+
+/*
+ * Define the register sets available on the score7 under Linux
+ */
+enum score7_regset {
+	REGSET_GENERAL,
+};
+
+static const struct user_regset score7_regsets[] = {
+	[REGSET_GENERAL] = {
+		.core_note_type	= NT_PRSTATUS,
+		.n		= ELF_NGREG,
+		.size		= sizeof(long),
+		.align		= sizeof(long),
+		.get		= genregs_get,
+		.set		= genregs_set,
+	},
+};
+
+static const struct user_regset_view user_score_native_view = {
+	.name		= "score7",
+	.e_machine	= EM_SCORE7,
+	.regsets	= score7_regsets,
+	.n		= ARRAY_SIZE(score7_regsets),
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return &user_score_native_view;
+}
+
 static int is_16bitinsn(unsigned long insn)
 {
 	if ((insn & INSN32_MASK) == INSN32_MASK)
@@ -80,34 +168,6 @@ write_tsk_long(struct task_struct *child,
 	return copied != sizeof(val) ? -EIO : 0;
 }
 
-/*
- * Get all user integer registers.
- */
-static int ptrace_getregs(struct task_struct *tsk, void __user *uregs)
-{
-	struct pt_regs *regs = task_pt_regs(tsk);
-
-	return copy_to_user(uregs, regs, sizeof(struct pt_regs)) ? -EFAULT : 0;
-}
-
-/*
- * Set all user integer registers.
- */
-static int ptrace_setregs(struct task_struct *tsk, void __user *uregs)
-{
-	struct pt_regs newregs;
-	int ret;
-
-	ret = -EFAULT;
-	if (copy_from_user(&newregs, uregs, sizeof(struct pt_regs)) == 0) {
-		struct pt_regs *regs = task_pt_regs(tsk);
-		*regs = newregs;
-		ret = 0;
-	}
-
-	return ret;
-}
-
 void user_enable_single_step(struct task_struct *child)
 {
 	/* far_epc is the target of branch */
@@ -270,97 +330,18 @@ arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	unsigned long __user *datap = (void __user *)data;
 
 	switch (request) {
-	/* Read the word at location addr in the USER area.  */
-	case PTRACE_PEEKUSR: {
-		struct pt_regs *regs;
-		unsigned long tmp;
-
-		regs = task_pt_regs(child);
-
-		tmp = 0;  /* Default return value. */
-		switch (addr) {
-		case 0 ... 31:
-			tmp = regs->regs[addr];
-			break;
-		case PC:
-			tmp = regs->cp0_epc;
-			break;
-		case ECR:
-			tmp = regs->cp0_ecr;
-			break;
-		case EMA:
-			tmp = regs->cp0_ema;
-			break;
-		case CEH:
-			tmp = regs->ceh;
-			break;
-		case CEL:
-			tmp = regs->cel;
-			break;
-		case CONDITION:
-			tmp = regs->cp0_condition;
-			break;
-		case PSR:
-			tmp = regs->cp0_psr;
-			break;
-		case COUNTER:
-			tmp = regs->sr0;
-			break;
-		case LDCR:
-			tmp = regs->sr1;
-			break;
-		case STCR:
-			tmp = regs->sr2;
-			break;
-		default:
-			tmp = 0;
-			return -EIO;
-		}
-
-		ret = put_user(tmp, (unsigned int __user *) datap);
-		return ret;
-	}
-
-	case PTRACE_POKEUSR: {
-		struct pt_regs *regs;
-		ret = 0;
-		regs = task_pt_regs(child);
-
-		switch (addr) {
-		case 0 ... 31:
-			regs->regs[addr] = data;
-			break;
-		case PC:
-			regs->cp0_epc = data;
-			break;
-		case CEH:
-			regs->ceh = data;
-			break;
-		case CEL:
-			regs->cel = data;
-			break;
-		case CONDITION:
-			regs->cp0_condition = data;
-			break;
-		case PSR:
-		case COUNTER:
-		case STCR:
-		case LDCR:
-			break; /* user can't write the reg */
-		default:
-			/* The rest are not allowed. */
-			ret = -EIO;
-			break;
-		}
-		break;
-	}
-
 	case PTRACE_GETREGS:
-		ret = ptrace_getregs(child, (void __user *)datap);
+		ret = copy_regset_to_user(child, &user_score_native_view,
+						REGSET_GENERAL,
+						0, sizeof(struct pt_regs),
+						(void __user *)datap);
 		break;
 
 	case PTRACE_SETREGS:
-		ret = ptrace_setregs(child, (void __user *)datap);
+		ret = copy_regset_from_user(child, &user_score_native_view,
+						REGSET_GENERAL,
+						0, sizeof(struct pt_regs),
+						(const void __user *)datap);
 		break;
 
 	default:
-- 
1.6.2



