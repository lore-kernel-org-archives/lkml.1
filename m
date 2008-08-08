Return-Path: <linux-kernel-owner+w=401wt.eu-S1763435AbYHHW7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763435AbYHHW7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbYHHW7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:59:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413AbYHHW7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:59:13 -0400
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86 ioperm user_regset
X-Fcc: ~/Mail/linus
X-Windows: there's got to be a better way.
Message-Id: <20080808225840.04ECD154208@magilla.localdomain>
Date: Fri,  8 Aug 2008 15:58:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f2d7499be1b1fe1cd8a5e6a01c1f44173894a241:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git x86/ioperm

Roland McGrath (1):
      x86 ioperm user_regset

 arch/x86/kernel/ptrace.c |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/elf.h      |    1 +
 2 files changed, 38 insertions(+), 0 deletions(-)


Thanks,
Roland
---
[PATCH] x86 ioperm user_regset

This adds a user_regset type for the x86 io permissions bitmap.
This makes it appear in core dumps (when ioperm has been used).
It will also make it visible to debuggers in the future.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/elf.h      |    1 +
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index e37dccc..da1a33c 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -39,7 +39,9 @@ enum x86_regset {
 	REGSET_GENERAL,
 	REGSET_FP,
 	REGSET_XFP,
+	REGSET_IOPERM64 = REGSET_XFP,
 	REGSET_TLS,
+	REGSET_IOPERM32,
 };
 
 /*
@@ -554,6 +556,29 @@ static int ptrace_set_debugreg(struct task_struct *child,
 	return 0;
 }
 
+/*
+ * These access the current or another (stopped) task's io permission
+ * bitmap for debugging or core dump.
+ */
+static int ioperm_active(struct task_struct *target,
+			 const struct user_regset *regset)
+{
+	return target->thread.io_bitmap_max / regset->size;
+}
+
+static int ioperm_get(struct task_struct *target,
+		      const struct user_regset *regset,
+		      unsigned int pos, unsigned int count,
+		      void *kbuf, void __user *ubuf)
+{
+	if (!target->thread.io_bitmap_ptr)
+		return -ENXIO;
+
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				   target->thread.io_bitmap_ptr,
+				   0, IO_BITMAP_BYTES);
+}
+
 #ifdef X86_BTS
 
 static int ptrace_bts_get_size(struct task_struct *child)
@@ -1290,6 +1315,12 @@ static const struct user_regset x86_64_regsets[] = {
 		.size = sizeof(long), .align = sizeof(long),
 		.active = xfpregs_active, .get = xfpregs_get, .set = xfpregs_set
 	},
+	[REGSET_IOPERM64] = {
+		.core_note_type = NT_386_IOPERM,
+		.n = IO_BITMAP_LONGS,
+		.size = sizeof(long), .align = sizeof(long),
+		.active = ioperm_active, .get = ioperm_get
+	},
 };
 
 static const struct user_regset_view user_x86_64_view = {
@@ -1336,6 +1367,12 @@ static const struct user_regset x86_32_regsets[] = {
 		.active = regset_tls_active,
 		.get = regset_tls_get, .set = regset_tls_set
 	},
+	[REGSET_IOPERM32] = {
+		.core_note_type = NT_386_IOPERM,
+		.n = IO_BITMAP_BYTES / sizeof(u32),
+		.size = sizeof(u32), .align = sizeof(u32),
+		.active = ioperm_active, .get = ioperm_get
+	},
 };
 
 static const struct user_regset_view user_x86_32_view = {
diff --git a/include/linux/elf.h b/include/linux/elf.h
index edc3dac..0b61ca4 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -360,6 +360,7 @@ typedef struct elf64_shdr {
 #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
 #define NT_PPC_VSX	0x102		/* PowerPC VSX registers */
 #define NT_386_TLS	0x200		/* i386 TLS slots (struct user_desc) */
+#define NT_386_IOPERM	0x201		/* x86 io permission bitmap (1=deny) */
 
 
 /* Note header in a PT_NOTE section */
