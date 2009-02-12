Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbZBLBOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbZBLBOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbZBLBNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:13:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48894 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118AbZBLBNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:13:47 -0500
Message-Id: <20090212011343.755562859@goodmis.org>
References: <20090212011051.265346435@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 11 Feb 2009 20:10:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 6/7][RFC] powerpc32, ftrace: port function graph tracer to ppc32, static only
Content-Disposition: inline; filename=0006-powerpc32-ftrace-port-function-graph-tracer-to-ppc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

This patch ports the function graph tracer for PowerPC, but only
for static function tracing.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/Kconfig           |    2 +-
 arch/powerpc/kernel/entry_32.S |   43 +++++++++++++++++++++++++++++++++++++++-
 arch/powerpc/kernel/ftrace.c   |    2 +-
 3 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6e1ee1b..9e4bd20 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -111,7 +111,7 @@ config PPC
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUNCTION_GRAPH_TRACER if PPC64
+	select HAVE_FUNCTION_GRAPH_TRACER if PPC64 || !DYNAMIC_FTRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index eb0c13e..9cf7083 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -1199,9 +1199,11 @@ _GLOBAL(_mcount)
 
 	mtctr	r5
 	bctrl
-
 	nop
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	b	ftrace_graph_caller
+#endif
 	MCOUNT_RESTORE_FRAME
 	
 	bctr
@@ -1210,4 +1212,43 @@ _GLOBAL(_mcount)
 _GLOBAL(ftrace_stub)
 	blr
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+_GLOBAL(ftrace_graph_caller)
+	/* load r4 with local address */
+	lwz	r4, 44(r1)
+	subi	r4, r4, MCOUNT_INSN_SIZE
+
+	/* get the parent address */
+	addi	r3, r1, 52
+
+	bl	prepare_ftrace_return
+	nop
+
+	MCOUNT_RESTORE_FRAME
+	/* old link register ends up in ctr reg */
+	bctr
+
+_GLOBAL(return_to_handler)
+	/* need to save return values */
+	stwu	r1, -32(r1)
+	stw	r3, 20(r1)
+	stw	r4, 16(r1)
+	stw	r31, 12(r1)
+	mr	r31, r1
+
+	bl	ftrace_return_to_handler
+	nop
+
+	/* return value has real return address */
+	mtlr	r3
+
+	lwz	r3, 20(r1)
+	lwz	r4, 16(r1)
+	lwz	r31,12(r1)
+	lwz	r1, 0(r1)
+
+	/* Jump back to real return address */
+	blr
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 #endif /* CONFIG_MCOUNT */
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 5c6dfa9..dddd99b 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -603,7 +603,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		"1: " PPC_LL "%[old], 0(%[parent])\n"
 		"2: " PPC_STL "%[return_hooker], 0(%[parent])\n"
 		"   li %[faulted], 0\n"
-		"3:"
+		"3:\n"
 
 		".section .fixup, \"ax\"\n"
 		"4: li %[faulted], 1\n"
-- 
1.5.6.5

-- 
