Return-Path: <linux-kernel-owner+w=401wt.eu-S1762065AbZBMFci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762065AbZBMFci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 00:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZBMFaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 00:30:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50438 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbZBMFaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 00:30:07 -0500
Message-Id: <20090213053005.974748513@goodmis.org>
References: <20090213052358.524970112@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 13 Feb 2009 00:24:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: [PATCH 5/7] powerpc32, ftrace: save and restore mcount regs with macro
Content-Disposition: inline; filename=0005-powerpc32-ftrace-save-and-restore-mcount-regs-with.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Impact: clean up

Use a macro to save and restore the registers for PowerPC32,
since that code is duplicated.

This is similar to the work done by Cyrill Gorcunov for the
mcount code in x86_64.

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/include/asm/ftrace.h |   39 ++++++++++++++++++++-
 arch/powerpc/kernel/entry_32.S    |   68 +++++--------------------------------
 2 files changed, 47 insertions(+), 60 deletions(-)

diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index e5f2ae8..dde1296 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -5,7 +5,44 @@
 #define MCOUNT_ADDR		((long)(_mcount))
 #define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
 
-#ifndef __ASSEMBLY__
+#ifdef __ASSEMBLY__
+
+/* Based off of objdump optput from glibc */
+
+#define MCOUNT_SAVE_FRAME			\
+	stwu	r1,-48(r1);			\
+	stw	r3, 12(r1);			\
+	stw	r4, 16(r1);			\
+	stw	r5, 20(r1);			\
+	stw	r6, 24(r1);			\
+	mflr	r3;				\
+	lwz	r4, 52(r1);			\
+	mfcr	r5;				\
+	stw	r7, 28(r1);			\
+	stw	r8, 32(r1);			\
+	stw	r9, 36(r1);			\
+	stw	r10,40(r1);			\
+	stw	r3, 44(r1);			\
+	stw	r5, 8(r1)
+
+#define MCOUNT_RESTORE_FRAME			\
+	lwz	r6, 8(r1);			\
+	lwz	r0, 44(r1);			\
+	lwz	r3, 12(r1);			\
+	mtctr	r0;				\
+	lwz	r4, 16(r1);			\
+	mtcr	r6;				\
+	lwz	r5, 20(r1);			\
+	lwz	r6, 24(r1);			\
+	lwz	r0, 52(r1);			\
+	lwz	r7, 28(r1);			\
+	lwz	r8, 32(r1);			\
+	mtlr	r0;				\
+	lwz	r9, 36(r1);			\
+	lwz	r10,40(r1);			\
+	addi	r1, r1, 48
+
+#else /* !__ASSEMBLY__ */
 extern void _mcount(void);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 6f7eb7e..eb0c13e 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -1176,59 +1176,22 @@ _GLOBAL(_mcount)
 	bctr
 
 _GLOBAL(ftrace_caller)
-	/* Based off of objdump optput from glibc */
-	stwu	r1,-48(r1)
-	stw	r3, 12(r1)
-	stw	r4, 16(r1)
-	stw	r5, 20(r1)
-	stw	r6, 24(r1)
-	mflr	r3
-	lwz	r4, 52(r1)
-	mfcr	r5
-	stw	r7, 28(r1)
-	stw	r8, 32(r1)
-	stw	r9, 36(r1)
-	stw	r10,40(r1)
-	stw	r3, 44(r1)
-	stw	r5, 8(r1)
+	MCOUNT_SAVE_FRAME
+	/* r3 ends up with link register */
 	subi	r3, r3, MCOUNT_INSN_SIZE
 .globl ftrace_call
 ftrace_call:
 	bl	ftrace_stub
 	nop
-	lwz	r6, 8(r1)
-	lwz	r0, 44(r1)
-	lwz	r3, 12(r1)
-	mtctr	r0
-	lwz	r4, 16(r1)
-	mtcr	r6
-	lwz	r5, 20(r1)
-	lwz	r6, 24(r1)
-	lwz	r0, 52(r1)
-	lwz	r7, 28(r1)
-	lwz	r8, 32(r1)
-	mtlr	r0
-	lwz	r9, 36(r1)
-	lwz	r10,40(r1)
-	addi	r1, r1, 48
+
+	MCOUNT_RESTORE_FRAME
+	/* old link register ends up in ctr reg */
 	bctr
 #else
 _GLOBAL(mcount)
 _GLOBAL(_mcount)
-	stwu	r1,-48(r1)
-	stw	r3, 12(r1)
-	stw	r4, 16(r1)
-	stw	r5, 20(r1)
-	stw	r6, 24(r1)
-	mflr	r3
-	lwz	r4, 52(r1)
-	mfcr	r5
-	stw	r7, 28(r1)
-	stw	r8, 32(r1)
-	stw	r9, 36(r1)
-	stw	r10,40(r1)
-	stw	r3, 44(r1)
-	stw	r5, 8(r1)
+
+	MCOUNT_SAVE_FRAME
 
 	subi	r3, r3, MCOUNT_INSN_SIZE
 	LOAD_REG_ADDR(r5, ftrace_trace_function)
@@ -1239,21 +1202,8 @@ _GLOBAL(_mcount)
 
 	nop
 
-	lwz	r6, 8(r1)
-	lwz	r0, 44(r1)
-	lwz	r3, 12(r1)
-	mtctr	r0
-	lwz	r4, 16(r1)
-	mtcr	r6
-	lwz	r5, 20(r1)
-	lwz	r6, 24(r1)
-	lwz	r0, 52(r1)
-	lwz	r7, 28(r1)
-	lwz	r8, 32(r1)
-	mtlr	r0
-	lwz	r9, 36(r1)
-	lwz	r10,40(r1)
-	addi	r1, r1, 48
+	MCOUNT_RESTORE_FRAME
+	
 	bctr
 #endif
 
-- 
1.5.6.5

-- 
