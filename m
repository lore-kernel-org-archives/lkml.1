Return-Path: <linux-kernel-owner+w=401wt.eu-S1762738AbXLTMKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762738AbXLTMKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761087AbXLTMBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761094AbXLTMAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 36/43] x86 user_regset_view
Message-Id: <20071220120003.9DE5B26F98D@magilla.localdomain>
Date: Thu, 20 Dec 2007 04:00:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defines task_user_regset_view and the tables
describing the x86 user_regset layouts for 32 and 64.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/ptrace.c |   87 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index c520ad7..ede27e9 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -15,6 +15,7 @@
 #include <linux/ptrace.h>
 #include <linux/regset.h>
 #include <linux/user.h>
+#include <linux/elf.h>
 #include <linux/security.h>
 #include <linux/audit.h>
 #include <linux/seccomp.h>
@@ -32,6 +33,14 @@
 #include <asm/proto.h>
 #include <asm/ds.h>
 
+#include "tls.h"
+
+enum x86_regset {
+	REGSET_GENERAL,
+	REGSET_FP,
+	REGSET_XFP,
+	REGSET_TLS,
+};
 
 /*
  * does not yet catch signals sent when the child dies.
@@ -1336,6 +1345,84 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 
 #endif	/* CONFIG_IA32_EMULATION */
 
+#ifdef CONFIG_X86_64
+
+static const struct user_regset x86_64_regsets[] = {
+	[REGSET_GENERAL] = {
+		.core_note_type = NT_PRSTATUS,
+		.n = sizeof(struct user_regs_struct) / sizeof(long),
+		.size = sizeof(long), .align = sizeof(long),
+		.get = genregs_get, .set = genregs_set
+	},
+	[REGSET_FP] = {
+		.core_note_type = NT_PRFPREG,
+		.n = sizeof(struct user_i387_struct) / sizeof(long),
+		.size = sizeof(long), .align = sizeof(long),
+		.active = xfpregs_active, .get = xfpregs_get, .set = xfpregs_set
+	},
+};
+
+static const struct user_regset_view user_x86_64_view = {
+	.name = "x86_64", .e_machine = EM_X86_64,
+	.regsets = x86_64_regsets, .n = ARRAY_SIZE(x86_64_regsets)
+};
+
+#else  /* CONFIG_X86_32 */
+
+#define user_regs_struct32	user_regs_struct
+#define genregs32_get		genregs_get
+#define genregs32_set		genregs_set
+
+#endif	/* CONFIG_X86_64 */
+
+#if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
+static const struct user_regset x86_32_regsets[] = {
+	[REGSET_GENERAL] = {
+		.core_note_type = NT_PRSTATUS,
+		.n = sizeof(struct user_regs_struct32) / sizeof(u32),
+		.size = sizeof(u32), .align = sizeof(u32),
+		.get = genregs32_get, .set = genregs32_set
+	},
+	[REGSET_FP] = {
+		.core_note_type = NT_PRFPREG,
+		.n = sizeof(struct user_i387_struct) / sizeof(u32),
+		.size = sizeof(u32), .align = sizeof(u32),
+		.active = fpregs_active, .get = fpregs_get, .set = fpregs_set
+	},
+	[REGSET_XFP] = {
+		.core_note_type = NT_PRXFPREG,
+		.n = sizeof(struct user_i387_struct) / sizeof(u32),
+		.size = sizeof(u32), .align = sizeof(u32),
+		.active = xfpregs_active, .get = xfpregs_get, .set = xfpregs_set
+	},
+	[REGSET_TLS] = {
+		.n = GDT_ENTRY_TLS_ENTRIES, .bias = GDT_ENTRY_TLS_MIN,
+		.size = sizeof(struct user_desc),
+		.align = sizeof(struct user_desc),
+		.active = regset_tls_active,
+		.get = regset_tls_get, .set = regset_tls_set
+	},
+};
+
+static const struct user_regset_view user_x86_32_view = {
+	.name = "i386", .e_machine = EM_386,
+	.regsets = x86_32_regsets, .n = ARRAY_SIZE(x86_32_regsets)
+};
+#endif
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+#ifdef CONFIG_IA32_EMULATION
+	if (test_tsk_thread_flag(task, TIF_IA32))
+#endif
+#if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
+		return &user_x86_32_view;
+#endif
+#ifdef CONFIG_X86_64
+	return &user_x86_64_view;
+#endif
+}
+
 #ifdef CONFIG_X86_32
 
 void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
-- 
1.5.3.6

