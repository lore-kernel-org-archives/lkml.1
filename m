Return-Path: <linux-kernel-owner+w=401wt.eu-S1764178AbXHCXYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764178AbXHCXYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 19:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXHCXX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 19:23:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbXHCXX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 19:23:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: Use linux/elfcore-compat.h
In-Reply-To: Roland McGrath's message of  Friday, 3 August 2007 16:21:21 -0700 <20070803232121.A252E4D04BC@magilla.localdomain>
X-Fcc: ~/Mail/linus
X-Zippy-Says: Didn't I buy a 1951 Packard from you last March in Cairo?
Message-Id: <20070803232321.74DB84D04BC@magilla.localdomain>
Date: Fri,  3 Aug 2007 16:23:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This makes powerpc64's compat code use the new linux/elfcore-compat.h,
reducing some hand-copied duplication.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/binfmt_elf32.c |   67 ++++++++++++++++-------------------
 include/asm-powerpc/elf.h          |   38 +++++++++++----------
 2 files changed, 51 insertions(+), 54 deletions(-)

diff --git a/arch/powerpc/kernel/binfmt_elf32.c b/arch/powerpc/kernel/binfmt_elf32.c
index 5cb5875..1d45d77 100644
--- a/arch/powerpc/kernel/binfmt_elf32.c
+++ b/arch/powerpc/kernel/binfmt_elf32.c
@@ -13,49 +13,44 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#define ELF_ARCH		EM_PPC
-#define ELF_CLASS		ELFCLASS32
-#define ELF_DATA		ELFDATA2MSB;
-
 #include <asm/processor.h>
 #include <linux/module.h>
-#include <linux/elfcore.h>
 #include <linux/compat.h>
+#include <linux/elfcore-compat.h>
+
+#undef	ELF_ARCH
+#undef	ELF_CLASS
+#define ELF_CLASS	ELFCLASS32
+#define ELF_ARCH	EM_PPC
+
+#undef	elfhdr
+#undef	elf_phdr
+#undef	elf_note
+#undef	elf_addr_t
+#define elfhdr		elf32_hdr
+#define elf_phdr	elf32_phdr
+#define elf_note	elf32_note
+#define elf_addr_t	Elf32_Off
 
-#define elf_prstatus elf_prstatus32
-struct elf_prstatus32
+#define elf_prstatus	compat_elf_prstatus
+#define elf_prpsinfo	compat_elf_prpsinfo
+
+#define elf_core_copy_regs compat_elf_core_copy_regs
+static inline void compat_elf_core_copy_regs(compat_elf_gregset_t *elf_regs,
+					     struct pt_regs *regs)
 {
-	struct elf_siginfo pr_info;	/* Info associated with signal */
-	short	pr_cursig;		/* Current signal */
-	unsigned int pr_sigpend;	/* Set of pending signals */
-	unsigned int pr_sighold;	/* Set of held signals */
-	pid_t	pr_pid;
-	pid_t	pr_ppid;
-	pid_t	pr_pgrp;
-	pid_t	pr_sid;
-	struct compat_timeval pr_utime;	/* User time */
-	struct compat_timeval pr_stime;	/* System time */
-	struct compat_timeval pr_cutime;	/* Cumulative user time */
-	struct compat_timeval pr_cstime;	/* Cumulative system time */
-	elf_gregset_t pr_reg;		/* General purpose registers. */
-	int pr_fpvalid;		/* True if math co-processor being used. */
-};
+	PPC_ELF_CORE_COPY_REGS((*elf_regs), regs);
+}
 
-#define elf_prpsinfo elf_prpsinfo32
-struct elf_prpsinfo32
+#define elf_core_copy_task_regs compat_elf_core_copy_task_regs
+static int compat_elf_core_copy_task_regs(struct task_struct *tsk,
+					  compat_elf_gregset_t *elf_regs)
 {
-	char	pr_state;	/* numeric process state */
-	char	pr_sname;	/* char for pr_state */
-	char	pr_zomb;	/* zombie */
-	char	pr_nice;	/* nice val */
-	unsigned int pr_flag;	/* flags */
-	u32	pr_uid;
-	u32	pr_gid;
-	pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
-	/* Lots missing */
-	char	pr_fname[16];	/* filename of executable */
-	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
-};
+	struct pt_regs *regs = tsk->thread.regs;
+	if (regs)
+		compat_elf_core_copy_regs(elf_regs, regs);
+	return 1;
+}
 
 #include <linux/time.h>
 
diff --git a/include/asm-powerpc/elf.h b/include/asm-powerpc/elf.h
index de50799..b6a1aef 100644
--- a/include/asm-powerpc/elf.h
+++ b/include/asm-powerpc/elf.h
@@ -101,6 +101,7 @@ typedef elf_greg_t64 elf_gregset_t64[ELF_NGREG];
 
 typedef unsigned int elf_greg_t32;
 typedef elf_greg_t32 elf_gregset_t32[ELF_NGREG];
+typedef elf_gregset_t32 compat_elf_gregset_t;
 
 /*
  * ELF_ARCH, CLASS, and DATA are used to set parameters in the core dumps.
@@ -175,26 +176,27 @@ typedef elf_vrreg_t elf_vrregset_t32[ELF_NVRREG32];
 
 #define ELF_ET_DYN_BASE         (0x20000000)
 
-/* Common routine for both 32-bit and 64-bit processes */
+/*
+ * Our registers are always unsigned longs, whether we're a 32 bit
+ * process or 64 bit, on either a 64 bit or 32 bit kernel.
+ *
+ * This macro relies on elf_regs[i] having the right type to truncate to,
+ * either u32 or u64.  It defines the body of the elf_core_copy_regs
+ * function, either the native one with elf_gregset_t elf_regs or
+ * the 32-bit one with elf_gregset_t32 elf_regs.
+ */
+#define PPC_ELF_CORE_COPY_REGS(elf_regs, regs) \
+	int i, nregs = min(sizeof(*regs) / sizeof(unsigned long), \
+			   (size_t)ELF_NGREG);			  \
+	for (i = 0; i < nregs; i++) \
+		elf_regs[i] = ((unsigned long *) regs)[i]; \
+	memset(&elf_regs[i], 0, (ELF_NGREG - i) * sizeof(elf_regs[0]))
+
+/* Common routine for both 32-bit and 64-bit native processes */
 static inline void ppc_elf_core_copy_regs(elf_gregset_t elf_regs,
-					    struct pt_regs *regs)
+					  struct pt_regs *regs)
 {
-	int i, nregs;
-
-	memset((void *)elf_regs, 0, sizeof(elf_gregset_t));
-
-	/* Our registers are always unsigned longs, whether we're a 32 bit
-	 * process or 64 bit, on either a 64 bit or 32 bit kernel.
-	 * Don't use ELF_GREG_TYPE here. */
-	nregs = sizeof(struct pt_regs) / sizeof(unsigned long);
-	if (nregs > ELF_NGREG)
-		nregs = ELF_NGREG;
-
-	for (i = 0; i < nregs; i++) {
-		/* This will correctly truncate 64 bit registers to 32 bits
-		 * for a 32 bit process on a 64 bit kernel. */
-		elf_regs[i] = (elf_greg_t)((ELF_GREG_TYPE *)regs)[i];
-	}
+	PPC_ELF_CORE_COPY_REGS(elf_regs, regs);
 }
 #define ELF_CORE_COPY_REGS(gregs, regs) ppc_elf_core_copy_regs(gregs, regs);
 
