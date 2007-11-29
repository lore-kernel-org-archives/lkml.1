Return-Path: <linux-kernel-owner+w=401wt.eu-S1762680AbXK2MAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680AbXK2MAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761151AbXK2MAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:00:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761200AbXK2MAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:00:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH x86/mm 08/11] x86 ia32 ptrace getreg/putreg merge
In-Reply-To: Roland McGrath's message of  Thursday, 29 November 2007 03:57:11 -0800 <20071129115711.9FC8526F8E7@magilla.localdomain>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071129120031.F0F4F26F989@magilla.localdomain>
Date: Thu, 29 Nov 2007 04:00:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This reimplements the 64-bit IA32-emulation register access
functions in arch/x86/kernel/ptrace.c, where they can share
some guts with the native access functions directly.

These functions are not used yet, but this paves the way to move
IA32 ptrace support into this file to share its local functions.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |  126 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 126 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 2eac631..bac5058 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -632,6 +632,132 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	return ret;
 }
 
+#ifdef CONFIG_IA32_EMULATION
+
+#include <asm/user32.h>
+
+#define R32(l,q)							\
+	case offsetof(struct user32, regs.l):				\
+		regs->q = value; break
+
+#define SEG32(rs)							\
+	case offsetof(struct user32, regs.rs):				\
+		return set_segment_reg(child,				\
+				       offsetof(struct user_regs_struct, rs), \
+				       value);				\
+		break
+
+static int putreg32(struct task_struct *child, unsigned regno, u32 value)
+{
+	struct pt_regs *regs = task_pt_regs(child);
+
+	switch (regno) {
+
+	SEG32(cs);
+	SEG32(ds);
+	SEG32(es);
+	SEG32(fs);
+	SEG32(gs);
+	SEG32(ss);
+
+	R32(ebx, bx);
+	R32(ecx, cx);
+	R32(edx, dx);
+	R32(edi, di);
+	R32(esi, si);
+	R32(ebp, bp);
+	R32(eax, ax);
+	R32(orig_eax, orig_ax);
+	R32(eip, ip);
+	R32(esp, sp);
+
+	case offsetof(struct user32, regs.eflags):
+		return set_flags(child, value);
+
+	case offsetof(struct user32, u_debugreg[0]) ...
+		offsetof(struct user32, u_debugreg[7]):
+		regno -= offsetof(struct user32, u_debugreg[0]);
+		return ptrace_set_debugreg(child, regno / 4, value);
+
+	default:
+		if (regno > sizeof(struct user32) || (regno & 3))
+			return -EIO;
+
+		/*
+		 * Other dummy fields in the virtual user structure
+		 * are ignored
+		 */
+		break;
+	}
+	return 0;
+}
+
+#undef R32
+#undef SEG32
+
+#define R32(l,q)							\
+	case offsetof(struct user32, regs.l):				\
+		*val = regs->q; break
+
+#define SEG32(rs)							\
+	case offsetof(struct user32, regs.rs):				\
+		*val = get_segment_reg(child,				\
+				       offsetof(struct user_regs_struct, rs)); \
+		break
+
+static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
+{
+	struct pt_regs *regs = task_pt_regs(child);
+
+	switch (regno) {
+
+	SEG32(ds);
+	SEG32(es);
+	SEG32(fs);
+	SEG32(gs);
+
+	R32(cs, cs);
+	R32(ss, ss);
+	R32(ebx, bx);
+	R32(ecx, cx);
+	R32(edx, dx);
+	R32(edi, di);
+	R32(esi, si);
+	R32(ebp, bp);
+	R32(eax, ax);
+	R32(orig_eax, orig_ax);
+	R32(eip, ip);
+	R32(esp, sp);
+
+	case offsetof(struct user32, regs.eflags):
+		*val = get_flags(child);
+		break;
+
+	case offsetof(struct user32, u_debugreg[0]) ...
+		offsetof(struct user32, u_debugreg[7]):
+		regno -= offsetof(struct user32, u_debugreg[0]);
+		*val = ptrace_get_debugreg(child, regno / 4);
+		break;
+
+	default:
+		if (regno > sizeof(struct user32) || (regno & 3))
+			return -EIO;
+
+		/*
+		 * Other dummy fields in the virtual user structure
+		 * are ignored
+		 */
+		*val = 0;
+		break;
+	}
+	return 0;
+}
+
+#undef R32
+#undef SEG32
+
+#endif	/* CONFIG_IA32_EMULATION */
+
 #ifdef CONFIG_X86_32
 
 void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
