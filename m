Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZKNGgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZKNGgO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZKNGgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:36:11 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:62298 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbZKNGgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:36:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kMl5o2cMlodMKzqxKqowhH0GJUiTy9k6b14ePVXLsUOA+1rkO59XRs635t6IufEn8N
         Y8kBwtdwKT8f5oEris2tktSJGGl7lEtPOpvp2D4U8uJLqBWhXiZxdNZMpg/SDd3K5XX4
         Wz2ViZJ1UVQVFh2/ON0gNg2W6lHLKC4fa52hQ=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: rostedt@goodmis.org, Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>,
       "Maciej W . Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com
Subject: [PATCH v8 14/16] tracing: make ftrace for MIPS work without -fno-omit-frame-pointer
Date: Sat, 14 Nov 2009 14:33:29 +0800
Message-Id: <24733f375d853dd6dc44138c53f2f57493915d8f.1258177321.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <af765bca2a5f969f13de1b9f61744e6523d1afe8.1258177321.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1258177321.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1258177321.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1258177321.git.wuzhangjin@gmail.com>
 <ea337742d3ca7eec2825416041a6d4fa917d5cc4.1258177321.git.wuzhangjin@gmail.com>
 <7c7568247ad6cc109ec20387cfc3ca258d1d430f.1258177321.git.wuzhangjin@gmail.com>
 <3fcaffcfb3c8c8cd3015151ed5b7480ccaecde0f.1258177321.git.wuzhangjin@gmail.com>
 <48676d84140dbafd46e530611766121e18abc4ef.1258177321.git.wuzhangjin@gmail.com>
 <99ebd8fcb19e4cccd702fca966405ffc45f8540b.1258177321.git.wuzhangjin@gmail.com>
 <c1fe0d6822e98bc0ffd2dfee7a579fbbe21430e0.1258177321.git.wuzhangjin@gmail.com>
 <f3a54cef2de00885ee75a930b243083a716370bd.1258177321.git.wuzhangjin@gmail.com>
 <b98ca1b2048aeab8aac82ec8723ac729c2cd4b54.1258177321.git.wuzhangjin@gmail.com>
 <8a7987bba58526a0e156f531dba31d9a65d3d744.1258177321.git.wuzhangjin@gmail.com>
 <af765bca2a5f969f13de1b9f61744e6523d1afe8.1258177321.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1258177321.git.wuzhangjin@gmail.com>
References: <cover.1258177321.git.wuzhangjin@gmail.com>
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
index aa7c80b..f78d763 100644
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
 
 /* not trace the timecounter_read* in kernel/time/clocksource.c */
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

