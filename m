Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbZJZPQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbZJZPQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbZJZPP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:15:59 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:4631 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZJZPP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Vs8BsphV/9eQ/+yIc14vtwueqrfJGYBQQNTBxJZ9t1YIEI9uJv7imMKvZ78B+X+gac
         Q2HwT9oVzWdVGdNuXdC4uAfza+vOuOMgvRJK9UTHV/8vXBivs5ETevrMzLPxGV9NZNa/
         zP/Y1TH4XuMBoco2tS4lhBr/HII2gYz0SlNQw=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
Subject: [PATCH -v6 12/13] tracing: add function graph tracer support for MIPS
Date: Mon, 26 Oct 2009 23:13:29 +0800
Message-Id: <60dd7085d4df145318582d0a829887b4abf6e6c1.1256569489.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <bdfc54ea3c82f1d34149a5565132ff896edd4f76.1256569489.git.wuzhangjin@gmail.com>
References: <cover.1256569489.git.wuzhangjin@gmail.com>
 <747deea2f18d5ccffe842df95a9dd1c86251a958.1256569489.git.wuzhangjin@gmail.com>
 <3f47087b70a965fd679b17a59521671296457df1.1256569489.git.wuzhangjin@gmail.com>
 <f290e125634d164ec65b09b24b269815f78455ab.1256569489.git.wuzhangjin@gmail.com>
 <07dc907ec62353b1aca99b2850d3b2e4b734189a.1256569489.git.wuzhangjin@gmail.com>
 <374da7039d2e1b97083edd8bcd7811356884d427.1256569489.git.wuzhangjin@gmail.com>
 <3c82af564d70be05b92687949ed134ce034bf8db.1256569489.git.wuzhangjin@gmail.com>
 <a11775df0ec9665fab5861f4fa63a3e192b9ffec.1256569489.git.wuzhangjin@gmail.com>
 <f746f813531a16bd650f9290787c66cbc0cdc34d.1256569489.git.wuzhangjin@gmail.com>
 <07e35715c3af78e3c4b537940277240ed031365a.1256569489.git.wuzhangjin@gmail.com>
 <4e022c090601c3585a8d69a54deade2a53f93e8c.1256569489.git.wuzhangjin@gmail.com>
 <bdfc54ea3c82f1d34149a5565132ff896edd4f76.1256569489.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1256569489.git.wuzhangjin@gmail.com>
References: <cover.1256569489.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation of function graph tracer for MIPS is a little
different from X86.

in MIPS, gcc(with -pg) only transfer the caller's return address(at) and
the _mcount's return address(ra) to us.

move at, ra
jal _mcount

if the function is a leaf, it will no save the return address(ra):

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

as we can see, if the first instruction above "move at, ra" is "move
s8(fp), sp"(only available with -fno-omit-frame-pointer which is enabled
by CONFIG_FRAME_POINTER), it is a leaf function, so we hijack the at
register directly via putting &return_to_handler into it, otherwise, we
search the "s{d,w} ra, offset(sp)" instruction to get the stack offset,
and then the stack address. we use the above copy_process() as an
example, we at last find "ffbf00a8", 0xa8 is the stack offset, we plus
it with s8(fp), that is the stack address, we hijack the content via
writing the &return_to_handler in.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Kconfig         |    1 +
 arch/mips/kernel/ftrace.c |   93 +++++++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/mcount.S |   47 ++++++++++++++++++++++-
 3 files changed, 140 insertions(+), 1 deletions(-)

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
index 0be30cf..4cf11f5 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -13,6 +13,8 @@
 #include <linux/ftrace.h>
 
 #include <asm/cacheflush.h>
+#include <asm/asm.h>
+#include <asm/asm-offsets.h>
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
@@ -74,3 +76,94 @@ int __init ftrace_dyn_arch_init(void *data)
 	return 0;
 }
 #endif				/* CONFIG_DYNAMIC_FTRACE */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+#define S_RA    (0x2fbf << 16)	/* 32bit: afbf, 64bit: ffbf */
+#define MOV_FP_SP       0x03a0f021	/* 32bit: 0x03a0f021, 64bit: 0x03a0f02d */
+#define STACK_OFFSET_MASK	0xfff	/* stack offset range: 0 ~ PT_SIZE(304) */
+
+unsigned long ftrace_get_parent_addr(unsigned long self_addr,
+				     unsigned long parent,
+				     unsigned long parent_addr,
+				     unsigned long fp)
+{
+	unsigned long sp, ip, ra;
+	unsigned int code;
+
+	/* move to the instruction "move ra, at" */
+	ip = self_addr - 8;
+
+	/* search the text until finding the "move s8, sp" instruction or
+	 * "s{d,w} ra, offset(sp)" instruction */
+	do {
+		ip -= 4;
+
+		/* get the code at "ip" */
+		code = *(unsigned int *)ip;
+
+		/* If we hit the "move s8(fp), sp" instruction before finding
+		 * where the ra is stored, then this is a leaf function and it
+		 * does not store the ra on the stack. */
+		if ((code & MOV_FP_SP) == MOV_FP_SP)
+			return parent_addr;
+	} while (((code & S_RA) != S_RA));
+
+	sp = fp + (code & STACK_OFFSET_MASK);
+	ra = *(unsigned long *)sp;
+
+	if (ra == parent)
+		return sp;
+
+	ftrace_graph_stop();
+	WARN_ON(1);
+	return parent_addr;
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
index 389be7b..a9ba888 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -99,7 +99,15 @@ NESTED(_mcount, PT_SIZE, ra)
 	PTR_L	t1, ftrace_trace_function /* Prepare t1 for (1) */
 	bne	t0, t1, static_trace
 	nop
-
+#ifdef	CONFIG_FUNCTION_GRAPH_TRACER
+	PTR_L	t2, ftrace_graph_return
+	bne	t0, t2, ftrace_graph_caller
+	nop
+	PTR_LA	t0, ftrace_graph_entry_stub
+	PTR_L	t2, ftrace_graph_entry
+	bne	t0, t2, ftrace_graph_caller
+	nop
+#endif
 	j	ftrace_stub
 	nop
 
@@ -118,5 +126,42 @@ ftrace_stub:
 
 #endif	/* ! CONFIG_DYNAMIC_FTRACE */
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+NESTED(ftrace_graph_caller, PT_SIZE, ra)
+	MCOUNT_SAVE_REGS
+
+	PTR_LA	a0, PT_R1(sp)	/* arg1: &AT -> a0 */
+	move	a1, ra		/* arg2: next ip, selfaddr */
+	PTR_SUBU a1, MCOUNT_INSN_SIZE
+	move	a2, fp		/* arg3: frame pointer */
+	jal	prepare_ftrace_return
+	nop
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
+	PTR_S	v1, PT_R3(sp)
+
+	jal	ftrace_return_to_handler
+	nop
+
+	/* restore the real parent address: v0 -> ra */
+	move	ra, v0
+
+	PTR_L	v0, PT_R2(sp)
+	PTR_L	v1, PT_R3(sp)
+	PTR_ADDIU	sp, PT_SIZE
+
+	jr	ra
+	nop
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 	.set at
 	.set reorder
-- 
1.6.2.1

