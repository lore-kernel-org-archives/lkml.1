Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbZKNGfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbZKNGfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbZKNGfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:35:52 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:54304 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbZKNGfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:35:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Z9r37yqSi6M8AmDxDvvB6V2mnig5kIYkc/P+JYlPQ7Xq6XfSi3tKHQhTS66MVM+zHw
         lyeWTYq5q4EGfFAetmIl3peAKwJPuaE7Tm4lCXwOklsfgqFRH2QlMiMcZgwbg1W9xAhz
         8rD5pNr16EHeIU8WRuptTsC0ZLpZKVnndfodw=
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
Subject: [PATCH v8 12/16] tracing: add function graph tracer support for MIPS
Date: Sat, 14 Nov 2009 14:33:27 +0800
Message-Id: <8a7987bba58526a0e156f531dba31d9a65d3d744.1258177321.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <b98ca1b2048aeab8aac82ec8723ac729c2cd4b54.1258177321.git.wuzhangjin@gmail.com>
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
In-Reply-To: <cover.1258177321.git.wuzhangjin@gmail.com>
References: <cover.1258177321.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

The implementation of function graph tracer for MIPS is a little
different from X86.

in MIPS, gcc(with -pg) only transfer the caller's return address(at) and
the _mcount's return address(ra) to us.

For the kernel part without -mlong-calls:

move at, ra
jal _mcount

For the module part with -mlong-calls:

lui v1, hi16bit_of_mcount
addiu v1, v1, low16bit_of_mcount
move at, ra
jal _mcount

Without -mlong-calls,

if the function is a leaf, it will not save the return address(ra):

ffffffff80101298 <au1k_wait>:
ffffffff80101298:       67bdfff0        daddiu  sp,sp,-16
ffffffff8010129c:       ffbe0008        sd      s8,8(sp)
ffffffff801012a0:       03a0f02d        move    s8,sp
ffffffff801012a4:       03e0082d        move    at,ra
ffffffff801012a8:       0c042930        jal     ffffffff8010a4c0 <_mcount>
ffffffff801012ac:       00020021        nop

so, we can hijack it directly in _mcount, but if the function is non-leaf, the
return address is saved in the stack.

ffffffff80133030 <copy_process>:
ffffffff80133030:       67bdff50        daddiu  sp,sp,-176
ffffffff80133034:       ffbe00a0        sd      s8,160(sp)
ffffffff80133038:       03a0f02d        move    s8,sp
ffffffff8013303c:       ffbf00a8        sd      ra,168(sp)
ffffffff80133040:       ffb70098        sd      s7,152(sp)
ffffffff80133044:       ffb60090        sd      s6,144(sp)
ffffffff80133048:       ffb50088        sd      s5,136(sp)
ffffffff8013304c:       ffb40080        sd      s4,128(sp)
ffffffff80133050:       ffb30078        sd      s3,120(sp)
ffffffff80133054:       ffb20070        sd      s2,112(sp)
ffffffff80133058:       ffb10068        sd      s1,104(sp)
ffffffff8013305c:       ffb00060        sd      s0,96(sp)
ffffffff80133060:       03e0082d        move    at,ra
ffffffff80133064:       0c042930        jal     ffffffff8010a4c0 <_mcount>
ffffffff80133068:       00020021        nop

but we can not get the exact stack address(which saved ra) directly in
_mcount, we need to search the content of at register in the stack space
or search the "s{d,w} ra, offset(sp)" instruction in the text. 'Cause we
can not prove there is only a match in the stack space, so, we search
the text instead.

as we can see, if the first instruction above "move at, ra" is not a
store instruction, there should be a leaf function, so we hijack the at
register directly via putting &return_to_handler into it, otherwise, we
search the "s{d,w} ra, offset(sp)" instruction to get the stack offset,
and then the stack address. we use the above copy_process() as an
example, we at last find "ffbf00a8", 0xa8 is the stack offset, we plus
it with s8(fp), that is the stack address, we hijack the content via
writing the &return_to_handler in.

If with -mlong-calls, since there are two more instructions above "move
at, ra", so, we can move the pointer to the position above "lui v1,
hi16bit_of_mcount".

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Kconfig         |    1 +
 arch/mips/kernel/ftrace.c |  106 +++++++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/mcount.S |   42 ++++++++++++++++++
 3 files changed, 149 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 147fbbc..de690fd 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -8,6 +8,7 @@ config MIPS
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
+	select HAVE_FUNCTION_GRAPH_TRACER
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB if !LEMOTE_FULOONG2E
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index 5459a78..65a3f8a 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -13,6 +13,8 @@
 #include <linux/ftrace.h>
 
 #include <asm/cacheflush.h>
+#include <asm/asm.h>
+#include <asm/asm-offsets.h>
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
@@ -110,3 +112,107 @@ int __init ftrace_dyn_arch_init(void *data)
 	return 0;
 }
 #endif				/* CONFIG_DYNAMIC_FTRACE */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+#define S_RA_SP	(0xafbf << 16)	/* s{d,w} ra, offset(sp) */
+#define S_R_SP	(0xafb0 << 16)  /* s{d,w} R, offset(sp) */
+#define OFFSET_MASK	0xffff	/* stack offset range: 0 ~ PT_SIZE */
+
+unsigned long ftrace_get_parent_addr(unsigned long self_addr,
+				     unsigned long parent,
+				     unsigned long parent_addr,
+				     unsigned long fp)
+{
+	unsigned long sp, ip, ra;
+	unsigned int code;
+
+	/* in module or kernel? */
+	if (self_addr & 0x40000000) {
+		/* module: move to the instruction "lui v1, HI_16BIT_OF_MCOUNT" */
+		ip = self_addr - 20;
+	} else {
+		/* kernel: move to the instruction "move ra, at" */
+		ip = self_addr - 12;
+	}
+
+	/* search the text until finding the non-store instruction or "s{d,w}
+	 * ra, offset(sp)" instruction */
+	do {
+		ip -= 4;
+
+		/* get the code at "ip" */
+		code = *(unsigned int *)ip;
+
+		/* If we hit the non-store instruction before finding where the
+		 * ra is stored, then this is a leaf function and it does not
+		 * store the ra on the stack. */
+		if ((code & S_R_SP) != S_R_SP)
+			return parent_addr;
+
+	} while (((code & S_RA_SP) != S_RA_SP));
+
+	sp = fp + (code & OFFSET_MASK);
+	ra = *(unsigned long *)sp;
+
+	if (ra == parent)
+		return sp;
+
+	return 0;
+}
+
+/*
+ * Hook the return address and push it in the stack of return addrs
+ * in current thread info.
+ */
+void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
+			   unsigned long fp)
+{
+	unsigned long old;
+	struct ftrace_graph_ent trace;
+	unsigned long return_hooker = (unsigned long)
+	    &return_to_handler;
+
+	if (unlikely(atomic_read(&current->tracing_graph_pause)))
+		return;
+
+	/* "parent" is the stack address saved the return address of the caller
+	 * of _mcount, for a leaf function not save the return address in the
+	 * stack address, so, we "emulate" one in _mcount's stack space, and
+	 * hijack it directly, but for a non-leaf function, it will save the
+	 * return address to the its stack space, so, we can not hijack the
+	 * "parent" directly, but need to find the real stack address,
+	 * ftrace_get_parent_addr() does it!
+	 */
+
+	old = *parent;
+
+	parent = (unsigned long *)ftrace_get_parent_addr(self_addr, old,
+							 (unsigned long)parent,
+							 fp);
+
+	/* If fails when getting the stack address of the non-leaf function's
+	 * ra, stop function graph tracer and return */
+	if (parent == 0) {
+		ftrace_graph_stop();
+		WARN_ON(1);
+		return;
+	}
+
+	*parent = return_hooker;
+
+	if (ftrace_push_return_trace(old, self_addr, &trace.depth, fp) ==
+	    -EBUSY) {
+		*parent = old;
+		return;
+	}
+
+	trace.func = self_addr;
+
+	/* Only trace if the calling function expects to */
+	if (!ftrace_graph_entry(&trace)) {
+		current->curr_ret_stack--;
+		*parent = old;
+	}
+}
+#endif				/* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index ffc4259..b50e38d 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -93,6 +93,16 @@ NESTED(_mcount, PT_SIZE, ra)
 	PTR_L	t1, ftrace_trace_function /* Prepare t1 for (1) */
 	bne	t0, t1, static_trace
 	 nop
+
+#ifdef	CONFIG_FUNCTION_GRAPH_TRACER
+	PTR_L	t2, ftrace_graph_return
+	bne	t0, t2, ftrace_graph_caller
+	 nop
+	PTR_LA	t0, ftrace_graph_entry_stub
+	PTR_L	t2, ftrace_graph_entry
+	bne	t0, t2, ftrace_graph_caller
+	 nop
+#endif
 	b	ftrace_stub
 	 nop
 
@@ -111,5 +121,37 @@ ftrace_stub:
 
 #endif	/* ! CONFIG_DYNAMIC_FTRACE */
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+NESTED(ftrace_graph_caller, PT_SIZE, ra)
+	MCOUNT_SAVE_REGS
+
+	PTR_LA	a0, PT_R1(sp)	/* arg1: &AT -> a0 */
+	move	a1, ra		/* arg2: next ip, selfaddr */
+	jal	prepare_ftrace_return
+	 move	a2, fp		/* arg3: frame pointer */
+
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
+	 PTR_S	v1, PT_R3(sp)
+
+	/* restore the real parent address: v0 -> ra */
+	move	ra, v0
+
+	PTR_L	v0, PT_R2(sp)
+	PTR_L	v1, PT_R3(sp)
+	jr	ra
+	 PTR_ADDIU	sp, PT_SIZE
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 	.set at
 	.set reorder
-- 
1.6.2.1

