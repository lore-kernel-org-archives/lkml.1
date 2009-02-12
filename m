Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbZBLBN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbZBLBN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbZBLBNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:13:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57629 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbZBLBNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:13:47 -0500
Message-Id: <20090212011343.322127562@goodmis.org>
References: <20090212011051.265346435@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 11 Feb 2009 20:10:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/7][RFC] powerpc64, ftrace: save toc only on modules for function graph
Content-Disposition: inline; filename=0004-powerpc64-ftrace-save-toc-only-on-modules-for-func.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The TOCS used by modules are different than the one used by
the core kernel code. The function graph tracer must save and
restore the TOC whenever it traces a module call. But this
is an added overhead to burden the majority of core kernel
code being traced.

Benjamin Herrenschmidt suggested in testing the entry of
the call to tell if it is a core kernel function or a module.
He recommended using the REGION_ID() macro to perform this test.

This patch implements Benjamin's idea, and uses a different
return_to_handler routine dependent on if the entry is a core
kernel function or not. The module version saves the TOC, where as
the core kernel version does not.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/entry_64.S |   27 ++++++++++++++++++++++++++-
 arch/powerpc/kernel/ftrace.c   |   13 +++++++++++--
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 9f61fd6..abfc323 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -971,6 +971,28 @@ _GLOBAL(ftrace_graph_caller)
 
 _GLOBAL(return_to_handler)
 	/* need to save return values */
+	std	r4,  -24(r1)
+	std	r3,  -16(r1)
+	std	r31, -8(r1)
+	mr	r31, r1
+	stdu	r1, -112(r1)
+
+	bl	.ftrace_return_to_handler
+	nop
+
+	/* return value has real return address */
+	mtlr	r3
+
+	ld	r1, 0(r1)
+	ld	r4,  -24(r1)
+	ld	r3,  -16(r1)
+	ld	r31, -8(r1)
+
+	/* Jump back to real return address */
+	blr
+
+_GLOBAL(mod_return_to_handler)
+	/* need to save return values */
 	std	r4,  -32(r1)
 	std	r3,  -24(r1)
 	/* save TOC */
@@ -979,7 +1001,10 @@ _GLOBAL(return_to_handler)
 	mr	r31, r1
 	stdu	r1, -112(r1)
 
-	/* update the TOC */
+	/*
+	 * We are in a module using the module's TOC.
+	 * Switch to our TOC to run inside the core kernel.
+	 */
 	LOAD_REG_IMMEDIATE(r4,ftrace_return_to_handler)
 	ld	r2, 8(r4)
 
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 7538b94..5c6dfa9 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -567,6 +567,10 @@ int ftrace_disable_ftrace_graph_caller(void)
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
+#ifdef CONFIG_PPC64
+extern void mod_return_to_handler(void);
+#endif
+
 /*
  * Hook the return address and push it in the stack of return addrs
  * in current thread info.
@@ -577,12 +581,17 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	unsigned long long calltime;
 	int faulted;
 	struct ftrace_graph_ent trace;
-	unsigned long return_hooker = (unsigned long)
-				&return_to_handler;
+	unsigned long return_hooker = (unsigned long)&return_to_handler;
 
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
+#if CONFIG_PPC64
+	/* non core kernel code needs to save and restore the TOC */
+	if (REGION_ID(self_addr) != KERNEL_REGION_ID)
+		return_hooker = (unsigned long)&mod_return_to_handler;
+#endif
+
 	return_hooker = GET_ADDR(return_hooker);
 
 	/*
-- 
1.5.6.5

-- 
