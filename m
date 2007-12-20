Return-Path: <linux-kernel-owner+w=401wt.eu-S1762076AbXLTMKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762076AbXLTMKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761117AbXLTMBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41848 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761105AbXLTMAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 15/43] powerpc user_regset_view
Message-Id: <20071220115800.C538426F98D@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:58:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the task_user_regset_view entry point and support for all the
native-mode (64 on CONFIG_PPC64, 32 on CONFIG_PPC32) thread register state.
This will enable generic machine-independent code to access user-mode
threads' registers for debugging and dumping.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/Makefile |    2 +
 arch/powerpc/kernel/ptrace.c |   52 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index ca51f0c..615ed96 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the linux kernel.
 #
 
+CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
+
 ifeq ($(CONFIG_PPC64),y)
 EXTRA_CFLAGS	+= -mno-minimal-toc
 endif
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index e493fc0..b32ac5f 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -455,6 +455,58 @@ static int set_evrregs(struct task_struct *task, unsigned long *data)
 #endif /* CONFIG_SPE */
 
 
+/*
+ * These are our native regset flavors.
+ */
+enum powerpc_regset {
+	REGSET_GPR,
+	REGSET_FPR,
+#ifdef CONFIG_ALTIVEC
+	REGSET_VMX,
+#endif
+#ifdef CONFIG_SPE
+	REGSET_SPE,
+#endif
+};
+
+static const struct user_regset native_regsets[] = {
+	[REGSET_GPR] = {
+		.core_note_type = NT_PRSTATUS, .n = ELF_NGREG,
+		.size = sizeof(long), .align = sizeof(long),
+		.get = gpr_get, .set = gpr_set
+	},
+	[REGSET_FPR] = {
+		.core_note_type = NT_PRFPREG, .n = ELF_NFPREG,
+		.size = sizeof(double), .align = sizeof(double),
+		.get = fpr_get, .set = fpr_set
+	},
+#ifdef CONFIG_ALTIVEC
+	[REGSET_VMX] = {
+		.core_note_type = NT_PPC_VMX, .n = 34,
+		.size = sizeof(vector128), .align = sizeof(vector128),
+		.active = vr_active, .get = vr_get, .set = vr_set
+	},
+#endif
+#ifdef CONFIG_SPE
+	[REGSET_SPE] = {
+		.n = 35,
+		.size = sizeof(u32), .align = sizeof(u32),
+		.active = evr_active, .get = evr_get, .set = evr_set
+	},
+#endif
+};
+
+static const struct user_regset_view user_ppc_native_view = {
+	.name = UTS_MACHINE, .e_machine = ELF_ARCH, .ei_osabi = ELF_OSABI,
+	.regsets = native_regsets, .n = ARRAY_SIZE(native_regsets)
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return &user_ppc_native_view;
+}
+
+
 void user_enable_single_step(struct task_struct *task)
 {
 	struct pt_regs *regs = task->thread.regs;
-- 
1.5.3.6

