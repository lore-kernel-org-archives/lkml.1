Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZKTMfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZKTMfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 07:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZKTMfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 07:35:53 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:40938 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbZKTMft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 07:35:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DxnN5oOjQkh0nOt5kDY0MxOa7UYFxkxk6O87/xT7bBaNBYcq8HJxQD2HFOl+Tut8/u
         XxeXB3BWNwBk5nKidg6j0cfMrAliG/0fUO6U/xBGScLRi2IImnC0iSsCmd9zXvxblyIm
         wtjDcCFcRTDj/FdCDxcPDfFvStQDgTutQnftU=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org
Cc: Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       Wu Zhangjin <wuzhangjin@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: [PATCH v9 08/10] tracing: make ftrace for MIPS work without -fno-omit-frame-pointer
Date: Fri, 20 Nov 2009 20:34:36 +0800
Message-Id: <16e57c64d806acc5fc3440370aa0ff97a5db7dc3.1258719323.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <c08257b0ef370f6e04ff9719bf7499bae28c70f4.1258719323.git.wuzhangjin@gmail.com>
References: <adf867c5a6864fa196c667d3f09a6a694f3903c5.1258719323.git.wuzhangjin@gmail.com>
 <51e30436a435480f1f0dec146a82f2b250900690.1258719323.git.wuzhangjin@gmail.com>
 <267c0824194b659b46fc038ba43492df30369fec.1258719323.git.wuzhangjin@gmail.com>
 <6a25a6132d64830bbd7339fe8b3841a51d02ac6d.1258719323.git.wuzhangjin@gmail.com>
 <2ffd3ecb5f0c96b43150968ce270dee71f6afdb8.1258719323.git.wuzhangjin@gmail.com>
 <2276758e661b2b2362432851003df1d7c99d6cc0.1258719323.git.wuzhangjin@gmail.com>
 <c08257b0ef370f6e04ff9719bf7499bae28c70f4.1258719323.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1258719323.git.wuzhangjin@gmail.com>
References: <cover.1258719323.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

When remove the -fno-omit-frame-pointer, gcc will not save the frame
pointer for us, we need to save one ourselves.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/include/asm/ftrace.h |   57 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/ftrace.c      |   56 ++++++++++++++++++++++++++++----------
 arch/mips/kernel/mcount.S      |    8 +++++
 3 files changed, 106 insertions(+), 15 deletions(-)

diff --git a/arch/mips/include/asm/ftrace.h b/arch/mips/include/asm/ftrace.h
index 7094a40..3986cd8 100644
--- a/arch/mips/include/asm/ftrace.h
+++ b/arch/mips/include/asm/ftrace.h
@@ -19,6 +19,62 @@
 extern void _mcount(void);
 #define mcount _mcount
 
+#define safe_load(load, src, dst, error)		\
+do {							\
+	asm volatile (					\
+		"1: " load " %[" STR(dst) "], 0(%[" STR(src) "])\n"\
+		"   li %[" STR(error) "], 0\n"		\
+		"2:\n"					\
+							\
+		".section .fixup, \"ax\"\n"		\
+		"3: li %[" STR(error) "], 1\n"		\
+		"   j 2b\n"				\
+		".previous\n"				\
+							\
+		".section\t__ex_table,\"a\"\n\t"	\
+		STR(PTR) "\t1b, 3b\n\t"			\
+		".previous\n"				\
+							\
+		: [dst] "=&r" (dst), [error] "=r" (error)\
+		: [src] "r" (src)			\
+		: "memory"				\
+	);						\
+} while (0)
+
+#define safe_store(store, src, dst, error)	\
+do {						\
+	asm volatile (				\
+		"1: " store " %[" STR(src) "], 0(%[" STR(dst) "])\n"\
+		"   li %[" STR(error) "], 0\n"	\
+		"2:\n"				\
+						\
+		".section .fixup, \"ax\"\n"	\
+		"3: li %[" STR(error) "], 1\n"	\
+		"   j 2b\n"			\
+		".previous\n"			\
+						\
+		".section\t__ex_table,\"a\"\n\t"\
+		STR(PTR) "\t1b, 3b\n\t"		\
+		".previous\n"			\
+						\
+		: [error] "=r" (error)		\
+		: [dst] "r" (dst), [src] "r" (src)\
+		: "memory"			\
+	);					\
+} while (0)
+
+#define safe_load_code(dst, src, error) \
+	safe_load(STR(lw), src, dst, error)
+#define safe_store_code(src, dst, error) \
+	safe_store(STR(sw), src, dst, error)
+
+#define safe_load_stack(dst, src, error) \
+	safe_load(STR(PTR_L), src, dst, error)
+
+#define safe_store_stack(src, dst, error) \
+	safe_store(STR(PTR_S), src, dst, error)
+
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
@@ -27,6 +83,7 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 
 struct dyn_arch_ftrace {
 };
+
 #endif /*  CONFIG_DYNAMIC_FTRACE */
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index e981a49..e363fc6 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -27,7 +27,13 @@ static unsigned int ftrace_nop = 0x00000000;
 
 static int ftrace_modify_code(unsigned long ip, unsigned int new_code)
 {
-	*(unsigned int *)ip = new_code;
+	int faulted;
+
+	/* *(unsigned int *)ip = new_code; */
+	safe_store_code(new_code, ip, faulted);
+
+	if (unlikely(faulted))
+		return -EFAULT;
 
 	flush_icache_range(ip, ip + 8);
 
@@ -41,14 +47,20 @@ int ftrace_make_nop(struct module *mod,
 		    struct dyn_ftrace *rec, unsigned long addr)
 {
 	unsigned int new;
+	int faulted;
 	unsigned long ip = rec->ip;
 
 	/* We have compiled module with -mlong-calls, but compiled the kernel
 	 * without it, we need to cope with them respectively. */
 	if (ip & 0x40000000) {
 		/* record it for ftrace_make_call */
-		if (lui_v1 == 0)
-			lui_v1 = *(unsigned int *)ip;
+		if (lui_v1 == 0) {
+			/* lui_v1 = *(unsigned int *)ip; */
+			safe_load_code(lui_v1, ip, faulted);
+
+			if (unlikely(faulted))
+				return -EFAULT;
+		}
 
 		/* lui v1, hi_16bit_of_mcount        --> b 1f (0x10000004)
 		 * addiu v1, v1, low_16bit_of_mcount
@@ -147,6 +159,7 @@ unsigned long ftrace_get_parent_addr(unsigned long self_addr,
 {
 	unsigned long sp, ip, ra;
 	unsigned int code;
+	int faulted;
 
 	/* in module or kernel? */
 	if (self_addr & 0x40000000) {
@@ -162,8 +175,11 @@ unsigned long ftrace_get_parent_addr(unsigned long self_addr,
 	do {
 		ip -= 4;
 
-		/* get the code at "ip" */
-		code = *(unsigned int *)ip;
+		/* get the code at "ip": code = *(unsigned int *)ip; */
+		safe_load_code(code, ip, faulted);
+
+		if (unlikely(faulted))
+			return 0;
 
 		/* If we hit the non-store instruction before finding where the
 		 * ra is stored, then this is a leaf function and it does not
@@ -174,11 +190,14 @@ unsigned long ftrace_get_parent_addr(unsigned long self_addr,
 	} while (((code & S_RA_SP) != S_RA_SP));
 
 	sp = fp + (code & OFFSET_MASK);
-	ra = *(unsigned long *)sp;
+
+	/* ra = *(unsigned long *)sp; */
+	safe_load_stack(ra, sp, faulted);
+	if (unlikely(faulted))
+		return 0;
 
 	if (ra == parent)
 		return sp;
-
 	return 0;
 }
 
@@ -193,6 +212,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	struct ftrace_graph_ent trace;
 	unsigned long return_hooker = (unsigned long)
 	    &return_to_handler;
+	int faulted;
 
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
@@ -206,21 +226,23 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	 * ftrace_get_parent_addr() does it!
 	 */
 
-	old = *parent;
+	/* old = *parent; */
+	safe_load_stack(old, parent, faulted);
+	if (unlikely(faulted))
+		goto out;
 
 	parent = (unsigned long *)ftrace_get_parent_addr(self_addr, old,
 							 (unsigned long)parent,
 							 fp);
-
 	/* If fails when getting the stack address of the non-leaf function's
 	 * ra, stop function graph tracer and return */
-	if (parent == 0) {
-		ftrace_graph_stop();
-		WARN_ON(1);
-		return;
-	}
+	if (parent == 0)
+		goto out;
 
-	*parent = return_hooker;
+	/* *parent = return_hooker; */
+	safe_store_stack(return_hooker, parent, faulted);
+	if (unlikely(faulted))
+		goto out;
 
 	if (ftrace_push_return_trace(old, self_addr, &trace.depth, fp) ==
 	    -EBUSY) {
@@ -235,5 +257,9 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 		current->curr_ret_stack--;
 		*parent = old;
 	}
+	return;
+out:
+	ftrace_graph_stop();
+	WARN_ON(1);
 }
 #endif				/* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index 98d4690..bdfef2c 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -139,7 +139,15 @@ NESTED(ftrace_graph_caller, PT_SIZE, ra)
 #endif
 	PTR_LA	a0, PT_R1(sp)	/* arg1: &AT -> a0 */
 	jal	prepare_ftrace_return
+#ifdef CONFIG_FRAME_POINTER
 	 move	a2, fp		/* arg3: frame pointer */
+#else
+#ifdef CONFIG_64BIT
+	 PTR_LA	a2, PT_SIZE(sp)
+#else
+	 PTR_LA	a2, (PT_SIZE+8)(sp)
+#endif
+#endif
 
 	MCOUNT_RESTORE_REGS
 	RETURN_BACK
-- 
1.6.2.1

