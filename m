Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZKIPdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZKIPdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZKIPdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:33:36 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39623 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbZKIPde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:33:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SutUslWo4CEKX7eDnGmdGucECSW5mZ4QtppP1Ck8h93VaGX8Ggcmor6jyL4Ad1UUcN
         vPt3WzbgMqavaR4NZJqAZ490PPX+1Zvb7nXjOUv6nTZZlv9ysDxxuE/cUMhJOY/SQYfW
         ELf1WPUYjwsDjuovutR9n4V2HWRauvaPQ69e4=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: zhangfx@lemote.com, zhouqg@gmail.com, Wu Zhangjin <wuzhangjin@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH v7 15/17] tracing: make ftrace for MIPS more robust
Date: Mon,  9 Nov 2009 23:31:32 +0800
Message-Id: <406a8e5e3117737e401bb2bba84ad9b17f99857d.1257779502.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <695747bff7cddb97d6f43c05c4cf05eb269e402d.1257779502.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com>
 <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>
 <6199d7b3956b544fc65896af1062787a2e1283ce.1257779502.git.wuzhangjin@gmail.com>
 <58a7558730fbea6cd0417100c8fcd6f45668d1e3.1257779502.git.wuzhangjin@gmail.com>
 <3a9fc9ca02e8e6e9c3c28797a4c084c1f9d91f69.1257779502.git.wuzhangjin@gmail.com>
 <0cef783a71333ff96a78aaea8961e3b6b5392665.1257779502.git.wuzhangjin@gmail.com>
 <18e1d617ed824bb1c10f15216f2ed9ed3de78abd.1257779502.git.wuzhangjin@gmail.com>
 <3da916c1cb6e05445438826f98a91111f43ff6cd.1257779502.git.wuzhangjin@gmail.com>
 <d4aa4cdb9b4c25e7a683c923bdeabed847bd8010.1257779502.git.wuzhangjin@gmail.com>
 <451c55dead5d6afd871de6afd14dbbcf70a0f834.1257779502.git.wuzhangjin@gmail.com>
 <0c463e2af521e613fd15751a9f610c74cf887292.1257779502.git.wuzhangjin@gmail.com>
 <695747bff7cddb97d6f43c05c4cf05eb269e402d.1257779502.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1257779502.git.wuzhangjin@gmail.com>
References: <cover.1257779502.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

Seems there is no failure meet when working with the C source code to
load/hijack the text & stack space, but we must ensure our source code
is robust enough, This patch does it via adding extra exception
handling.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/include/asm/ftrace.h |   57 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/ftrace.c      |   46 +++++++++++++++++++++++---------
 2 files changed, 90 insertions(+), 13 deletions(-)

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
index af3ceed..a4e25b8 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -31,7 +31,13 @@ static unsigned int ftrace_nop = 0x00000000;
 
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
 
@@ -124,6 +130,7 @@ unsigned long ftrace_get_parent_addr(unsigned long self_addr,
 {
 	unsigned long sp, ip, ra;
 	unsigned int code;
+	int faulted;
 
 	/* move to the instruction "lui v1, HI_16BIT_OF_MCOUNT" */
 	ip = self_addr - 20;
@@ -133,8 +140,11 @@ unsigned long ftrace_get_parent_addr(unsigned long self_addr,
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
@@ -145,11 +155,14 @@ unsigned long ftrace_get_parent_addr(unsigned long self_addr,
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
 
@@ -164,6 +177,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	struct ftrace_graph_ent trace;
 	unsigned long return_hooker = (unsigned long)
 	    &return_to_handler;
+	int faulted;
 
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
@@ -177,21 +191,23 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
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
@@ -206,5 +222,9 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 		current->curr_ret_stack--;
 		*parent = old;
 	}
+	return;
+out:
+	ftrace_graph_stop();
+	WARN_ON(1);
 }
 #endif				/* CONFIG_FUNCTION_GRAPH_TRACER */
-- 
1.6.2.1

