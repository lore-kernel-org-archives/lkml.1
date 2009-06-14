Return-Path: <linux-kernel-owner+w=401wt.eu-S1762472AbZFNPxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762472AbZFNPxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 11:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762565AbZFNPxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 11:53:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:38350 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762522AbZFNPxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fMPR7ZWAmIu57YZ5zwOcYQKG85W4G1CSdQ1tIsoxI+Fc1l63byZs9bS4WcHWa8Vb+w
         YwFf6fczY3Kd4hK6c89to1ltj0LcIRSedE8hq/+i3RL+sWzODKIm1c4EIo5kRQsd8uMc
         ykn6hUNX6ltcojYL+Z2LmYFsqEhdcYlQV21Rk=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wang Liming <liming.wang@windriver.com>, Wu Zhangjin <wuzj@lemote.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v3] mips function graph tracer support
Date: Sun, 14 Jun 2009 23:53:09 +0800
Message-Id: <80e0889dc1b610e73809b9899ada7442ee9749dc.1244994151.git.wuzj@lemote.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1244994151.git.wuzj@lemote.com>
References: <cover.1244994151.git.wuzj@lemote.com>
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
	address of a hooker function &return_to_handler will be substitued
	to the parent_ip, so, after return from _mcount it will call the
	&return_to_handler, not back to the parent_ip, but calling
	ftrace_return_to_handler to remember the rettime, and return the
	parent_ip to let &return_to_handler go back to the real parent.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/Kconfig              |    1 +
 arch/mips/kernel/ftrace.c      |   66 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/mcount.S      |   61 +++++++++++++++++++++++++++++++++++--
 arch/mips/kernel/vmlinux.lds.S |    1 +
 4 files changed, 126 insertions(+), 3 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 0857239..5ac9f45 100644
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
index ad490cc..65d4d56 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -205,3 +205,69 @@ int __init ftrace_dyn_arch_init(void *data)
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
+    if (unlikely(in_nmi()) ||
+		unlikely(atomic_read(&current->tracing_graph_pause)) ||
+		(ftrace_push_return_trace(parent_ip, ip, &trace.depth) == -EBUSY))
+		return parent_ip;
+
+	trace.func = ip;
+
+	/* Only trace if the calling function expects to */
+	if (ftrace_graph_entry(&trace))
+		return (unsigned long) &return_to_handler;
+
+	current->curr_ret_stack--;
+	return parent_ip;
+}
+#endif				/* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index 723ace2..559f9bd 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -27,7 +27,6 @@
 	.macro MCOUNT_SAVE_REGS
 	PTR_SUBU	sp, PT_SIZE
 	PTR_S	ra, PT_R31(sp)
-	PTR_S	$1, PT_R1(sp)
 	PTR_S	a0, PT_R4(sp)
 	PTR_S	a1, PT_R5(sp)
 	PTR_S	a2, PT_R6(sp)
@@ -42,7 +41,6 @@
 
 	.macro MCOUNT_RESTORE_REGS
 	PTR_L	ra, PT_R31(sp)
-	PTR_L	$1, PT_R1(sp)
 	PTR_L	a0, PT_R4(sp)
 	PTR_L	a1, PT_R5(sp)
 	PTR_L	a2, PT_R6(sp)
@@ -81,6 +79,7 @@ NESTED(ftrace_caller, PT_SIZE, ra)
 	nop
 
 	MCOUNT_SAVE_REGS
+	PTR_S	$1, PT_R1(sp)
 
 	MCOUNT_SET_ARGS
 	.globl ftrace_call
@@ -88,7 +87,16 @@ ftrace_call:
 	jal	ftrace_stub
 	nop
 
+	PTR_L	$1, PT_R1(sp)
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
@@ -106,17 +114,27 @@ NESTED(_mcount, PT_SIZE, ra)
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
 
 static_trace:
 	MCOUNT_SAVE_REGS
+	PTR_S	$1, PT_R1(sp)
 
 	MCOUNT_SET_ARGS			/* call *ftrace_trace_function */
 	jalr	t1
 	nop
 
+	PTR_L	$1, PT_R1(sp)
 	MCOUNT_RESTORE_REGS
 	.globl ftrace_stub
 ftrace_stub:
@@ -125,5 +143,42 @@ ftrace_stub:
 
 #endif	/* ! CONFIG_DYNAMIC_FTRACE */
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+NESTED(ftrace_graph_caller, PT_SIZE, ra)
+	MCOUNT_SAVE_REGS
+	PTR_S	v0, PT_R2(sp)
+
+	MCOUNT_SET_ARGS
+	jal	prepare_ftrace_return
+	nop
+
+	/* overwrite the parent as &return_to_handler: v0 -> $1(at) */
+	move	$1,	v0
+
+	PTR_L	v0, PT_R2(sp)
+	MCOUNT_RESTORE_REGS
+	RETURN_BACK
+	END(ftrace_graph_caller)
+
+	.align	2
+	.globl	return_to_handler
+return_to_handler:
+	PTR_SUBU	sp, PT_SIZE
+	PTR_S	v0, PT_R2(sp)
+
+	jal	ftrace_return_to_handler
+	nop
+
+	/* restore the real parent address: v0 -> ra */
+	move	ra, v0
+
+	PTR_L	v0, PT_R2(sp)
+	PTR_ADDIU	sp, PT_SIZE
+
+	jr	ra
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

