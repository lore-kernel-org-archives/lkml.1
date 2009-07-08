Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbZGHLn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbZGHLn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZGHLnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:43:50 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:41979 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbZGHLnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:43:49 -0400
In-Reply-To: <20090623145059.GA6478@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Subject: [PATCH] score: add regsets support for score
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF5282122C.261603C7-ON482575ED.003A86FA-482575ED.003C4AEE@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 8 Jul 2009 18:53:12 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/07/08 ?? 06:53:13,
	Serialize complete at 2009/07/08 ?? 06:53:13
Content-Type: text/plain; charset="US-ASCII"
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
 arch/score/include/asm/elf.h |    3 +-
 arch/score/kernel/ptrace.c   |   78 
++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/arch/score/include/asm/elf.h b/arch/score/include/asm/elf.h
index 8324363..d69668c 100644
--- a/arch/score/include/asm/elf.h
+++ b/arch/score/include/asm/elf.h
@@ -2,7 +2,7 @@
 #define _ASM_SCORE_ELF_H
 
 /* ELF register definitions */
-#define ELF_NGREG      45
+#define ELF_NGREG      42
 #define ELF_NFPREG     33
 #define EM_SCORE7      135
 
@@ -57,6 +57,7 @@ do { \
 struct task_struct;
 struct pt_regs;
 
+#define CORE_DUMP_USE_REGSET
 #define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE      PAGE_SIZE
 
diff --git a/arch/score/kernel/ptrace.c b/arch/score/kernel/ptrace.c
index 1db876b..9eec6a2 100644
--- a/arch/score/kernel/ptrace.c
+++ b/arch/score/kernel/ptrace.c
@@ -23,11 +23,89 @@
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
+                      const struct user_regset *regset,
+                      unsigned int pos, unsigned int count,
+                      void *kbuf, void __user *ubuf)
+{
+       const struct pt_regs *regs = task_pt_regs(target);
+       int end_pos = sizeof(struct pt_regs) - 9 * sizeof(long);
+       int ret;
+
+       ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+                                 regs->regs,
+                                 offsetof(struct pt_regs, regs),
+                                 end_pos);
+       if (!ret)
+               ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+                                               end_pos, -1);
+
+       return ret;
+}
+
+/*
+ * update the contents of the SCORE userspace general registers
+ */
+static int genregs_set(struct task_struct *target,
+                      const struct user_regset *regset,
+                      unsigned int pos, unsigned int count,
+                      const void *kbuf, const void __user *ubuf)
+{
+       struct pt_regs *regs = task_pt_regs(target);
+       int end_pos = sizeof(struct pt_regs) - 9 * sizeof(long);
+       int ret;
+
+       ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+                                regs->regs,
+                                offsetof(struct pt_regs, regs),
+                                end_pos);
+       if (!ret)
+               ret = user_regset_copyin_ignore(&pos, &count, &kbuf, 
&ubuf,
+                                               end_pos, -1);
+
+       return ret;
+}
+
+/*
+ * Define the register sets available on the score7 under Linux
+ */
+enum score7_regset {
+       REGSET_GENERAL,
+};
+
+static const struct user_regset score7_regsets[] = {
+       [REGSET_GENERAL] = {
+               .core_note_type = NT_PRSTATUS,
+               .n              = ELF_NGREG,
+               .size           = sizeof(long),
+               .align          = sizeof(long),
+               .get            = genregs_get,
+               .set            = genregs_set,
+       },
+};
+
+static const struct user_regset_view user_score_native_view = {
+       .name           = "score7",
+       .e_machine      = EM_SCORE7,
+       .regsets        = score7_regsets,
+       .n              = ARRAY_SIZE(score7_regsets),
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct 
*task)
+{
+       return &user_score_native_view;
+}
+
 static int is_16bitinsn(unsigned long insn)
 {
        if ((insn & INSN32_MASK) == INSN32_MASK)
-- 
1.6.2

