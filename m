Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZGJJji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZGJJji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZGJJja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:39:30 -0400
Received: from 219-87-157-179.static.tfn.net.tw ([219.87.157.179]:35180 "EHLO
	mswedge1.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZGJJj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:39:29 -0400
X-Greylist: delayed 1299 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jul 2009 05:39:28 EDT
Message-ID: <4A570650.3060309@sunplusct.com>
Date: Fri, 10 Jul 2009 17:13:52 +0800
From: "liqin.chen" <liqin.chen@sunplusct.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060524)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
       linux-arch@vger.kernel.org, linux-arch-owner@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH V2] score: add regset support
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/elf.h    |   18 +++--
 arch/score/include/asm/ptrace.h |    2 +
 arch/score/kernel/ptrace.c      |  140 
++++++++++++++++++++++++++++++--------
 3 files changed, 123 insertions(+), 37 deletions(-)

diff --git a/arch/score/include/asm/elf.h b/arch/score/include/asm/elf.h
index 8324363..43526d9 100644
--- a/arch/score/include/asm/elf.h
+++ b/arch/score/include/asm/elf.h
@@ -1,9 +1,8 @@
 #ifndef _ASM_SCORE_ELF_H
 #define _ASM_SCORE_ELF_H
 
-/* ELF register definitions */
-#define ELF_NGREG    45
-#define ELF_NFPREG    33
+#include <linux/ptrace.h>
+
 #define EM_SCORE7    135
 
 /* Relocation types. */
@@ -30,11 +29,15 @@
 #define R_SCORE_IMM30        20
 #define R_SCORE_IMM32        21
 
-typedef unsigned long elf_greg_t;
-typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+/* ELF register definitions */
+typedef unsigned long    elf_greg_t;
+
+#define ELF_NGREG    (sizeof(struct pt_regs) / sizeof(elf_greg_t))
+typedef elf_greg_t    elf_gregset_t[ELF_NGREG];
 
-typedef double elf_fpreg_t;
-typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
+/* Score does not have fp regs. */
+typedef double        elf_fpreg_t;
+typedef elf_fpreg_t    elf_fpregset_t;
 
 #define elf_check_arch(x)    ((x)->e_machine == EM_SCORE7)
 
@@ -57,6 +60,7 @@ do {                                \
 struct task_struct;
 struct pt_regs;
 
+#define CORE_DUMP_USE_REGSET
 #define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE    PAGE_SIZE
 
diff --git a/arch/score/include/asm/ptrace.h 
b/arch/score/include/asm/ptrace.h
index 66b14c8..19ce850 100644
--- a/arch/score/include/asm/ptrace.h
+++ b/arch/score/include/asm/ptrace.h
@@ -74,6 +74,8 @@ struct pt_regs {
 
 #ifdef __KERNEL__
 
+struct task_struct;
+
 /*
  * Does the process account for user or for system time?
  */
diff --git a/arch/score/kernel/ptrace.c b/arch/score/kernel/ptrace.c
index 1db876b..43784d8 100644
--- a/arch/score/kernel/ptrace.c
+++ b/arch/score/kernel/ptrace.c
@@ -23,11 +23,113 @@
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
+               const struct user_regset *regset,
+               unsigned int pos, unsigned int count,
+               void *kbuf, void __user *ubuf)
+{
+    const struct pt_regs *regs = task_pt_regs(target);
+    int ret;
+
+    /* skip 8 * sizeof(unsigned long) not use for pt_regs */
+    ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+                    0, offsetof(struct pt_regs, regs));
+
+    /* r0 - r31 */
+    ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+                  regs->regs,
+                  offsetof(struct pt_regs, regs),
+                  offsetof(struct pt_regs, cel));
+
+    if (!ret)
+        /* cel, ceh, sr0, sr1, sr2, epc, ema, psr, ecr, condition */
+        ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+                    &regs->cel,
+                    offsetof(struct pt_regs, cel),
+                    offsetof(struct pt_regs, is_syscall));
+
+    if (!ret)
+        ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+                        sizeof(struct pt_regs), -1);
+
+    return ret;
+}
+
+/*
+ * update the contents of the SCORE userspace general registers
+ */
+static int genregs_set(struct task_struct *target,
+               const struct user_regset *regset,
+               unsigned int pos, unsigned int count,
+               const void *kbuf, const void __user *ubuf)
+{
+    struct pt_regs *regs = task_pt_regs(target);
+    int ret;
+
+    /* skip 8 * sizeof(unsigned long) */
+    ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+                    0, offsetof(struct pt_regs, regs));
+
+    /* r0 - r31 */
+    ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+                  regs->regs,
+                  offsetof(struct pt_regs, regs),
+                  offsetof(struct pt_regs, cel));
+
+    if (!ret)
+        /* cel, ceh, sr0, sr1, sr2, epc, ema, psr, ecr, condition */
+        ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+                    &regs->cel,
+                    offsetof(struct pt_regs, cel),
+                    offsetof(struct pt_regs, is_syscall));
+
+    if (!ret)
+        ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+                        sizeof(struct pt_regs), -1);
+
+    return ret;
+}
+
+/*
+ * Define the register sets available on the score7 under Linux
+ */
+enum score7_regset {
+    REGSET_GENERAL,
+};
+
+static const struct user_regset score7_regsets[] = {
+    [REGSET_GENERAL] = {
+        .core_note_type    = NT_PRSTATUS,
+        .n        = ELF_NGREG,
+        .size        = sizeof(long),
+        .align        = sizeof(long),
+        .get        = genregs_get,
+        .set        = genregs_set,
+    },
+};
+
+static const struct user_regset_view user_score_native_view = {
+    .name        = "score7",
+    .e_machine    = EM_SCORE7,
+    .regsets    = score7_regsets,
+    .n        = ARRAY_SIZE(score7_regsets),
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct 
*task)
+{
+    return &user_score_native_view;
+}
+
 static int is_16bitinsn(unsigned long insn)
 {
     if ((insn & INSN32_MASK) == INSN32_MASK)
@@ -80,34 +182,6 @@ write_tsk_long(struct task_struct *child,
     return copied != sizeof(val) ? -EIO : 0;
 }
 
-/*
- * Get all user integer registers.
- */
-static int ptrace_getregs(struct task_struct *tsk, void __user *uregs)
-{
-    struct pt_regs *regs = task_pt_regs(tsk);
-
-    return copy_to_user(uregs, regs, sizeof(struct pt_regs)) ? -EFAULT : 0;
-}
-
-/*
- * Set all user integer registers.
- */
-static int ptrace_setregs(struct task_struct *tsk, void __user *uregs)
-{
-    struct pt_regs newregs;
-    int ret;
-
-    ret = -EFAULT;
-    if (copy_from_user(&newregs, uregs, sizeof(struct pt_regs)) == 0) {
-        struct pt_regs *regs = task_pt_regs(tsk);
-        *regs = newregs;
-        ret = 0;
-    }
-
-    return ret;
-}
-
 void user_enable_single_step(struct task_struct *child)
 {
     /* far_epc is the target of branch */
@@ -356,11 +430,17 @@ arch_ptrace(struct task_struct *child, long 
request, long addr, long data)
     }
 
     case PTRACE_GETREGS:
-        ret = ptrace_getregs(child, (void __user *)datap);
+        return copy_regset_to_user(child, &user_score_native_view,
+                        REGSET_GENERAL,
+                        0, sizeof(struct pt_regs),
+                        (void __user *)datap);
         break;
 
     case PTRACE_SETREGS:
-        ret = ptrace_setregs(child, (void __user *)datap);
+        return copy_regset_from_user(child, &user_score_native_view,
+                        REGSET_GENERAL,
+                        0, sizeof(struct pt_regs),
+                        (const void __user *)datap);
         break;
 
     default:
-- 
1.6.2

