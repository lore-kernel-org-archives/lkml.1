Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbZGABdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbZGABdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZGABdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:33:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:51412 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbZGABdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:33:23 -0400
From: Yong Zhang <yong.zhang@windriver.com>
To: linux-kernel@vger.kernel.org, ralf@linux-mips.org
Subject: [PATCH] MIPS: o32 application running on 64bit kernel core dump
Date: Wed,  1 Jul 2009 09:35:39 +0800
Message-Id: <16bd35f2910f585740f4764fa1e80bf31c80d576.1242178813.git.yong.zhang@windriver.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 01 Jul 2009 01:33:13.0479 (UTC) FILETIME=[E6652970:01C9F9EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an o32 application crashes and generates a core dump on
a 64 bit kernel, the core file will not be correctly
recognized. This is because ELF_CORE_COPY_REGS and
ELF_CORE_COPY_TASK_REGS are not correctly defined for o32
and will use the default register set which would
be CONFIG_64BIT in asm/elf.h.

So we'll switch to use the right register defines in
this situation by checking for WANT_COMPAT_REG_H and
use the right defines of ELF_CORE_COPY_REGS and
ELF_CORE_COPY_TASK_REGS.

Signed-off-by: Yong Zhang <yong.zhang@windriver.com>
---
 arch/mips/include/asm/elf.h      |    4 ++++
 arch/mips/include/asm/reg.h      |    2 +-
 arch/mips/kernel/binfmt_elfo32.c |   20 +++++++++++++++++---
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/mips/include/asm/elf.h b/arch/mips/include/asm/elf.h
index d58f128..7990694 100644
--- a/arch/mips/include/asm/elf.h
+++ b/arch/mips/include/asm/elf.h
@@ -316,9 +316,13 @@ extern void elf_dump_regs(elf_greg_t *, struct pt_regs *regs);
 extern int dump_task_regs(struct task_struct *, elf_gregset_t *);
 extern int dump_task_fpu(struct task_struct *, elf_fpregset_t *);
 
+#ifndef ELF_CORE_COPY_REGS
 #define ELF_CORE_COPY_REGS(elf_regs, regs)			\
 	elf_dump_regs((elf_greg_t *)&(elf_regs), regs);
+#endif
+#ifndef ELF_CORE_COPY_TASK_REGS
 #define ELF_CORE_COPY_TASK_REGS(tsk, elf_regs) dump_task_regs(tsk, elf_regs)
+#endif
 #define ELF_CORE_COPY_FPREGS(tsk, elf_fpregs)			\
 	dump_task_fpu(tsk, elf_fpregs)
 
diff --git a/arch/mips/include/asm/reg.h b/arch/mips/include/asm/reg.h
index 634b55d..910e71a 100644
--- a/arch/mips/include/asm/reg.h
+++ b/arch/mips/include/asm/reg.h
@@ -69,7 +69,7 @@
 
 #endif
 
-#ifdef CONFIG_64BIT
+#if defined(CONFIG_64BIT) && !defined(WANT_COMPAT_REG_H)
 
 #define EF_R0			 0
 #define EF_R1			 1
diff --git a/arch/mips/kernel/binfmt_elfo32.c b/arch/mips/kernel/binfmt_elfo32.c
index e1333d7..53bc6b4 100644
--- a/arch/mips/kernel/binfmt_elfo32.c
+++ b/arch/mips/kernel/binfmt_elfo32.c
@@ -53,6 +53,23 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
 #define ELF_ET_DYN_BASE         (TASK32_SIZE / 3 * 2)
 
 #include <asm/processor.h>
+
+/*
+ * When this file is selected, we are definitely running a 64bit kernel.
+ * So using the right regs define in asm/reg.h
+ */
+#define WANT_COMPAT_REG_H
+
+/* These MUST be defined before elf.h gets included */
+extern void elf32_core_copy_regs(elf_gregset_t grp, struct pt_regs *regs);
+#define ELF_CORE_COPY_REGS(_dest, _regs) elf32_core_copy_regs(_dest, _regs);
+#define ELF_CORE_COPY_TASK_REGS(_tsk, _dest)				\
+({									\
+	int __res = 1;							\
+	elf32_core_copy_regs((*_dest), (task_pt_regs(_tsk)));		\
+	__res;								\
+})
+
 #include <linux/module.h>
 #include <linux/elfcore.h>
 #include <linux/compat.h>
@@ -110,9 +127,6 @@ jiffies_to_compat_timeval(unsigned long jiffies, struct compat_timeval *value)
 	value->tv_usec = rem / NSEC_PER_USEC;
 }
 
-#undef ELF_CORE_COPY_REGS
-#define ELF_CORE_COPY_REGS(_dest, _regs) elf32_core_copy_regs(_dest, _regs);
-
 void elf32_core_copy_regs(elf_gregset_t grp, struct pt_regs *regs)
 {
 	int i;
-- 
1.5.6.5

