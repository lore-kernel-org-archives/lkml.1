Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYJ2RwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYJ2RwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 13:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYJ2RwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 13:52:04 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:48108 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYJ2RwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 13:52:02 -0400
Date: Wed, 29 Oct 2008 18:51:59 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <Jesper.Nilsson@axis.com>
Subject: [PATCH] [CRIS] Merge asm-offsets.c for both arches into one file.
Message-ID: <20081029175159.GN4608@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminates the link to arch specific asm-offsets.c from CRIS
architecture build system.

Resulting asm-offsets.s are identical before and after change
for both arch-v10 and arch-v32.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/Makefile                      |    6 +--
 arch/cris/arch-v10/kernel/asm-offsets.c |   47 ----------------------
 arch/cris/arch-v32/kernel/asm-offsets.c |   49 -----------------------
 arch/cris/kernel/asm-offsets.c          |   64 +++++++++++++++++++++++++++++++
 4 files changed, 66 insertions(+), 100 deletions(-)
 delete mode 100644 arch/cris/arch-v10/kernel/asm-offsets.c
 delete mode 100644 arch/cris/arch-v32/kernel/asm-offsets.c
 create mode 100644 arch/cris/kernel/asm-offsets.c

diff --git a/arch/cris/Makefile b/arch/cris/Makefile
index 22825a7..241e35b 100644
--- a/arch/cris/Makefile
+++ b/arch/cris/Makefile
@@ -95,8 +95,6 @@ ifdef CONFIG_ETRAX_ARCH_V32
 endif
 	@rm -rf $(SRC_ARCH)/kernel/vmlinux.lds.S
 	@ln -sfn ../$(SARCH)/vmlinux.lds.S $(SRC_ARCH)/kernel/vmlinux.lds.S
-	@rm -rf $(SRC_ARCH)/kernel/asm-offsets.c
-	@ln -sfn ../$(SARCH)/kernel/asm-offsets.c $(SRC_ARCH)/kernel/asm-offsets.c
 	@touch $@
 
 archclean:
@@ -116,8 +114,8 @@ MRPROPER_FILES += \
 	$(SRC_ARCH)/boot \
 	$(SRC_ARCH)/lib \
 	$(SRC_ARCH)/arch \
-	$(SRC_ARCH)/kernel/vmlinux.lds.S \
-	$(SRC_ARCH)/kernel/asm-offsets.c
+	$(SRC_ARCH)/kernel/vmlinux.lds.S
+
 
 define archhelp
   echo  '* zImage        - Compressed kernel image (arch/$(ARCH)/boot/zImage)'
diff --git a/arch/cris/arch-v10/kernel/asm-offsets.c b/arch/cris/arch-v10/kernel/asm-offsets.c
deleted file mode 100644
index 1aa3cc4..0000000
--- a/arch/cris/arch-v10/kernel/asm-offsets.c
+++ /dev/null
@@ -1,47 +0,0 @@
-#include <linux/sched.h>
-#include <asm/thread_info.h>
-
-/*
- * Generate definitions needed by assembly language modules.
- * This code generates raw asm output which is post-processed to extract
- * and format the required data.
- */
-
-#define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )
-
-int main(void)
-{
-#define ENTRY(entry) DEFINE(PT_ ## entry, offsetof(struct pt_regs, entry))
-	ENTRY(orig_r10);
-	ENTRY(r13); 
-	ENTRY(r12); 
-	ENTRY(r11);
-        ENTRY(r10);
-        ENTRY(r9);
-        ENTRY(mof);
-        ENTRY(dccr);
-        ENTRY(srp);
-	BLANK();
-#undef ENTRY
-#define ENTRY(entry) DEFINE(TI_ ## entry, offsetof(struct thread_info, entry))
-        ENTRY(task);
-        ENTRY(flags);
-        ENTRY(preempt_count);
-        BLANK();
-#undef ENTRY
-#define ENTRY(entry) DEFINE(THREAD_ ## entry, offsetof(struct thread_struct, entry))
-	ENTRY(ksp);
-        ENTRY(usp);
-        ENTRY(dccr);
-        BLANK();
-#undef ENTRY
-#define ENTRY(entry) DEFINE(TASK_ ## entry, offsetof(struct task_struct, entry))
-        ENTRY(pid);
-        BLANK();
-        DEFINE(LCLONE_VM, CLONE_VM);
-        DEFINE(LCLONE_UNTRACED, CLONE_UNTRACED);
-        return 0;
-}
diff --git a/arch/cris/arch-v32/kernel/asm-offsets.c b/arch/cris/arch-v32/kernel/asm-offsets.c
deleted file mode 100644
index 15b3d93..0000000
--- a/arch/cris/arch-v32/kernel/asm-offsets.c
+++ /dev/null
@@ -1,49 +0,0 @@
-#include <linux/sched.h>
-#include <asm/thread_info.h>
-
-/*
- * Generate definitions needed by assembly language modules.
- * This code generates raw asm output which is post-processed to extract
- * and format the required data.
- */
-
-#define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )
-
-int main(void)
-{
-#define ENTRY(entry) DEFINE(PT_ ## entry, offsetof(struct pt_regs, entry))
-	ENTRY(orig_r10);
-	ENTRY(r13);
-	ENTRY(r12);
-	ENTRY(r11);
-        ENTRY(r10);
-        ENTRY(r9);
-	ENTRY(acr);
-	ENTRY(srs);
-        ENTRY(mof);
-        ENTRY(ccs);
-        ENTRY(srp);
-	BLANK();
-#undef ENTRY
-#define ENTRY(entry) DEFINE(TI_ ## entry, offsetof(struct thread_info, entry))
-        ENTRY(task);
-        ENTRY(flags);
-        ENTRY(preempt_count);
-        BLANK();
-#undef ENTRY
-#define ENTRY(entry) DEFINE(THREAD_ ## entry, offsetof(struct thread_struct, entry))
-	ENTRY(ksp);
-        ENTRY(usp);
-        ENTRY(ccs);
-        BLANK();
-#undef ENTRY
-#define ENTRY(entry) DEFINE(TASK_ ## entry, offsetof(struct task_struct, entry))
-        ENTRY(pid);
-        BLANK();
-        DEFINE(LCLONE_VM, CLONE_VM);
-        DEFINE(LCLONE_UNTRACED, CLONE_UNTRACED);
-        return 0;
-}
diff --git a/arch/cris/kernel/asm-offsets.c b/arch/cris/kernel/asm-offsets.c
new file mode 100644
index 0000000..ddd6fbb
--- /dev/null
+++ b/arch/cris/kernel/asm-offsets.c
@@ -0,0 +1,64 @@
+#include <linux/sched.h>
+#include <asm/thread_info.h>
+#include <linux/autoconf.h>
+
+/*
+ * Generate definitions needed by assembly language modules.
+ * This code generates raw asm output which is post-processed to extract
+ * and format the required data.
+ */
+
+#define DEFINE(sym, val) \
+	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+
+#define BLANK() asm volatile("\n->" : : )
+
+#if !defined(CONFIG_ETRAX_ARCH_V10) && !defined(CONFIG_ETRAX_ARCH_V32)
+#error One of ARCH v10 and ARCH v32 must be true!
+#endif
+
+int main(void)
+{
+#define ENTRY(entry) DEFINE(PT_ ## entry, offsetof(struct pt_regs, entry))
+	ENTRY(orig_r10);
+	ENTRY(r13);
+	ENTRY(r12);
+	ENTRY(r11);
+	ENTRY(r10);
+	ENTRY(r9);
+#ifdef CONFIG_ETRAX_ARCH_V32
+	ENTRY(acr);
+	ENTRY(srs);
+#endif
+	ENTRY(mof);
+#ifdef CONFIG_ETRAX_ARCH_V10
+	ENTRY(dccr);
+#else
+	ENTRY(ccs);
+#endif
+	ENTRY(srp);
+	BLANK();
+#undef ENTRY
+#define ENTRY(entry) DEFINE(TI_ ## entry, offsetof(struct thread_info, entry))
+	ENTRY(task);
+	ENTRY(flags);
+	ENTRY(preempt_count);
+	BLANK();
+#undef ENTRY
+#define ENTRY(entry) DEFINE(THREAD_ ## entry, offsetof(struct thread_struct, entry))
+	ENTRY(ksp);
+	ENTRY(usp);
+#ifdef CONFIG_ETRAX_ARCH_V10
+	ENTRY(dccr);
+#else
+	ENTRY(ccs);
+#endif
+	BLANK();
+#undef ENTRY
+#define ENTRY(entry) DEFINE(TASK_ ## entry, offsetof(struct task_struct, entry))
+	ENTRY(pid);
+	BLANK();
+	DEFINE(LCLONE_VM, CLONE_VM);
+	DEFINE(LCLONE_UNTRACED, CLONE_UNTRACED);
+	return 0;
+}
-- 
1.5.6.5


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
