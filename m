Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbZBFGGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbZBFGGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbZBFGFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:05:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZBFGFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:05:34 -0500
Message-Id: <20090206060527.148611255@goodmis.org>
References: <20090206060328.181057235@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Feb 2009 01:03:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michael Neuling <mikey@neuling.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] ftrace, powerpc: replace debug macro with proper pr_deug
Content-Disposition: inline; filename=0001-ftrace-powerpc-replace-debug-macro-with-proper-pr_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: cleanup

The PowerPC ftrace code uses a hacked up DEBUGP macro for prints.
This patch converts it to the standard pr_debug.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/ftrace.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 5355244..a913f91 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -20,12 +20,6 @@
 #include <asm/code-patching.h>
 #include <asm/ftrace.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(fmt , ...)	do { } while (0)
-#endif
-
 static unsigned int ftrace_nop = PPC_NOP_INSTR;
 
 #ifdef CONFIG_PPC32
@@ -175,7 +169,7 @@ __ftrace_make_nop(struct module *mod,
 	 * 0xe8, 0x4c, 0x00, 0x28,    ld      r2,40(r12)
 	 */
 
-	DEBUGP("ip:%lx jumps to %lx r2: %lx", ip, tramp, mod->arch.toc);
+	pr_debug("ip:%lx jumps to %lx r2: %lx", ip, tramp, mod->arch.toc);
 
 	/* Find where the trampoline jumps to */
 	if (probe_kernel_read(jmp, (void *)tramp, sizeof(jmp))) {
@@ -183,7 +177,7 @@ __ftrace_make_nop(struct module *mod,
 		return -EFAULT;
 	}
 
-	DEBUGP(" %08x %08x", jmp[0], jmp[1]);
+	pr_debug(" %08x %08x", jmp[0], jmp[1]);
 
 	/* verify that this is what we expect it to be */
 	if (((jmp[0] & 0xffff0000) != 0x3d820000) ||
@@ -198,18 +192,18 @@ __ftrace_make_nop(struct module *mod,
 	offset = (unsigned)((unsigned short)jmp[0]) << 16 |
 		(unsigned)((unsigned short)jmp[1]);
 
-	DEBUGP(" %x ", offset);
+	pr_debug(" %x ", offset);
 
 	/* get the address this jumps too */
 	tramp = mod->arch.toc + offset + 32;
-	DEBUGP("toc: %lx", tramp);
+	pr_debug("toc: %lx", tramp);
 
 	if (probe_kernel_read(jmp, (void *)tramp, 8)) {
 		printk(KERN_ERR "Failed to read %lx\n", tramp);
 		return -EFAULT;
 	}
 
-	DEBUGP(" %08x %08x\n", jmp[0], jmp[1]);
+	pr_debug(" %08x %08x\n", jmp[0], jmp[1]);
 
 	ptr = ((unsigned long)jmp[0] << 32) + jmp[1];
 
@@ -286,7 +280,7 @@ __ftrace_make_nop(struct module *mod,
 	 *  0x4e, 0x80, 0x04, 0x20  bctr
 	 */
 
-	DEBUGP("ip:%lx jumps to %lx", ip, tramp);
+	pr_debug("ip:%lx jumps to %lx", ip, tramp);
 
 	/* Find where the trampoline jumps to */
 	if (probe_kernel_read(jmp, (void *)tramp, sizeof(jmp))) {
@@ -294,7 +288,7 @@ __ftrace_make_nop(struct module *mod,
 		return -EFAULT;
 	}
 
-	DEBUGP(" %08x %08x ", jmp[0], jmp[1]);
+	pr_debug(" %08x %08x ", jmp[0], jmp[1]);
 
 	/* verify that this is what we expect it to be */
 	if (((jmp[0] & 0xffff0000) != 0x3d600000) ||
@@ -310,7 +304,7 @@ __ftrace_make_nop(struct module *mod,
 	if (tramp & 0x8000)
 		tramp -= 0x10000;
 
-	DEBUGP(" %x ", tramp);
+	pr_debug(" %x ", tramp);
 
 	if (tramp != addr) {
 		printk(KERN_ERR
@@ -413,7 +407,7 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	/* ld r2,40(r1) */
 	op[1] = 0xe8410028;
 
-	DEBUGP("write to %lx\n", rec->ip);
+	pr_debug("write to %lx\n", rec->ip);
 
 	if (probe_kernel_write((void *)ip, op, MCOUNT_INSN_SIZE * 2))
 		return -EPERM;
@@ -453,7 +447,7 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 		return -EINVAL;
 	}
 
-	DEBUGP("write to %lx\n", rec->ip);
+	pr_debug("write to %lx\n", rec->ip);
 
 	if (probe_kernel_write((void *)ip, &op, MCOUNT_INSN_SIZE))
 		return -EPERM;
-- 
1.5.6.5

-- 
