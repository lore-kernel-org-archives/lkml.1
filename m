Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbZE2PFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbZE2PFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758466AbZE2PFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:05:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:11618 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215AbZE2PFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:05:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DB4xLJyf8/yb8wzUa7u9oEevG6aqKIEuxCeLNQn9gJX78AnjE3o3yCNzcy2sgU2DrE
         gKaPdsaZtXN/JjeKH9mVgBTcuMh6Bgdok0eIAwrWCVoXn5ycTEMnmuLfJWgJdZBhfM2n
         t2ImGB+n4mNHKJ+4rJftqOHOCeLB3mR05oaVs=
From: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v2 4/6] mips function graph tracer support
Date: Fri, 29 May 2009 23:05:21 +0800
Message-Id: <0319d4a73d59ce5e147df1b77f70b3474b5b1009.1243604390.git.wuzj@lemote.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1243604390.git.wuzj@lemote.com>
References: <cover.1243604390.git.wuzj@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

this works something like -finstrument-functions does, instead of using

                void __cyg_profile_func_enter (void *this_fn,
                                                  void *call_site);
                   void __cyg_profile_func_exit  (void *this_fn,
                                                  void *call_site);

-pg use _mcount, so some tricks are adoptive by the author of orignal function
graph tracer:

	the _mcount function will call prepare_function_return to save the
	parent_ip, ip and calltime in a tracing array, if success, the
	address of a hooker function named return_to_handler will be
	substitued to the parent_ip, so, after return from _mcount it will
	call the return_to_handler, not back to the parent_ip, but calling
	ftrace_return_to_handler to remember the rettime, and return the
	parent_ip to let return_to_handler go back to the real parent.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/Kconfig              |    1 +
 arch/mips/kernel/ftrace.c      |   72 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/mcount.S      |   58 +++++++++++++++++++++++++++++++-
 arch/mips/kernel/vmlinux.lds.S |    1 +
 4 files changed, 131 insertions(+), 1 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 0c00536..ac1437e 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -9,6 +9,7 @@ config MIPS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
+	select HAVE_FUNCTION_GRAPH_TRACER
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index ad490cc..123cc09 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -205,3 +205,75 @@ int __init ftrace_dyn_arch_init(void *data)
     return 0;
 }
 #endif				/* CONFIG_DYNAMIC_FTRACE */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+#define JMP	0x08000000			/* jump to target directly */
+extern void ftrace_graph_call(void);
+
+int ftrace_enable_ftrace_graph_caller(void)
+{
+    unsigned long ip = (unsigned long) (&ftrace_graph_call);
+    unsigned char old[MCOUNT_INSN_SIZE], *new;
+    int ret;
+
+	/* j ftrace_stub */
+    memcpy(old, (unsigned long *) ip, MCOUNT_INSN_SIZE);
+    new = ftrace_call_replace(JMP, (unsigned long) ftrace_graph_caller);
+
+    ret = ftrace_modify_code(ip, old, new);
+
+    return ret;
+}
+
+int ftrace_disable_ftrace_graph_caller(void)
+{
+    unsigned long ip = (unsigned long) (&ftrace_graph_call);
+    unsigned char old[MCOUNT_INSN_SIZE], *new;
+    int ret;
+
+	/* j ftrace_graph_caller */
+    memcpy(old, (unsigned long *) ip, MCOUNT_INSN_SIZE);
+    new = ftrace_call_replace(JMP, (unsigned long) ftrace_stub);
+
+    ret = ftrace_modify_code(ip, old, new);
+
+    return ret;
+}
+
+#endif				/* !CONFIG_DYNAMIC_FTRACE */
+
+/*
+ * Hook the return address and push it in the stack of return addrs
+ * in current thread info.
+ */
+
+unsigned long prepare_ftrace_return(unsigned long ip,
+				    unsigned long parent_ip)
+{
+    struct ftrace_graph_ent trace;
+
+    /* Nmi's are currently unsupported */
+    if (unlikely(in_nmi()))
+		goto out;
+
+    if (unlikely(atomic_read(&current->tracing_graph_pause)))
+		goto out;
+
+    if (ftrace_push_return_trace(parent_ip, ip, &trace.depth) == -EBUSY)
+		goto out;
+
+    trace.func = ip;
+
+    /* Only trace if the calling function expects to */
+    if (!ftrace_graph_entry(&trace)) {
+		current->curr_ret_stack--;
+		goto out;
+    }
+    return (unsigned long) &return_to_handler;
+out:
+    return parent_ip;
+}
+#endif				/* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index ce8a0ba..bd58f16 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -28,6 +28,10 @@
 	PTR_SUBU	sp, PT_SIZE
 	PTR_S	ra, PT_R31(sp)
 	PTR_S	$1, PT_R1(sp)
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	PTR_S	v0, PT_R2(sp)
+	PTR_S	v1, PT_R3(sp)
+#endif
 	PTR_S	a0, PT_R4(sp)
 	PTR_S	a1, PT_R5(sp)
 	PTR_S	a2, PT_R6(sp)
@@ -43,6 +47,10 @@
 	.macro MCOUNT_RESTORE_REGS
 	PTR_L	ra, PT_R31(sp)
 	PTR_L	$1, PT_R1(sp)
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	PTR_L	v0, PT_R2(sp)
+	PTR_L	v1, PT_R3(sp)
+#endif
 	PTR_L	a0, PT_R4(sp)
 	PTR_L	a1, PT_R5(sp)
 	PTR_L	a2, PT_R6(sp)
@@ -89,6 +97,14 @@ ftrace_call:
 	nop
 
 	MCOUNT_RESTORE_REGS
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.globl ftrace_graph_call
+ftrace_graph_call:
+	j	ftrace_stub
+	nop
+#endif
+
 	.globl ftrace_stub
 ftrace_stub:
 	RETURN_BACK
@@ -106,7 +122,15 @@ NESTED(_mcount, PT_SIZE, ra)
 	PTR_L	t1, ftrace_trace_function /* please don't use t1 later, safe? */
 	bne	t0, t1, static_trace
 	nop
-
+#ifdef	CONFIG_FUNCTION_GRAPH_TRACER
+	PTR_L	t2, ftrace_graph_return
+	bne	t0,	t2, ftrace_graph_caller
+	nop
+	PTR_LA	t0, ftrace_graph_entry_stub
+	PTR_L	t2, ftrace_graph_entry
+	bne	t0,	t2, ftrace_graph_caller
+	nop
+#endif
 	j	ftrace_stub
 	nop
 
@@ -125,5 +149,37 @@ ftrace_stub:
 
 #endif	/* ! CONFIG_DYNAMIC_FTRACE */
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+NESTED(ftrace_graph_caller, PT_SIZE, ra)
+	MCOUNT_SAVE_REGS
+
+	MCOUNT_SET_ARGS
+	jal	prepare_ftrace_return
+	nop
+
+	/* overwrite the parent as &return_to_handler: v0 -> $1(at) */
+	PTR_S	v0, PT_R1(sp)
+
+	MCOUNT_RESTORE_REGS
+	RETURN_BACK
+	END(ftrace_graph_caller)
+
+	.align	2
+	.globl	return_to_handler
+return_to_handler:
+	MCOUNT_SAVE_REGS
+
+	jal	ftrace_return_to_handler
+	nop
+
+	/* restore the real parent address: v0 -> ra */
+	PTR_S	v0, PT_R31(sp)
+
+	MCOUNT_RESTORE_REGS
+	RETURN_BACK
+
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 	.set at
 	.set reorder
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 58738c8..67435e5 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -36,6 +36,7 @@ SECTIONS
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
+		IRQENTRY_TEXT
 		*(.text.*)
 		*(.fixup)
 		*(.gnu.warning)
-- 
1.6.0.4

