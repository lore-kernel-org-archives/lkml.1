Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYK1NLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYK1NLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYK1NKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:10:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34199 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYK1NKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:10:52 -0500
Date: Fri, 28 Nov 2008 14:10:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/5] powerpc: ftrace updates to previous patch series
Message-ID: <20081128131014.GC26793@elte.hu>
References: <20081126215821.263324391@goodmis.org> <alpine.DEB.1.10.0811261749310.1501@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811261749310.1501@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 26 Nov 2008, Steven Rostedt wrote:
> 
> > Paul,
> > 
> > This patch series addresses the issues you brought up as well as
> > adds some more enhancements and fixes. This series is added on
> > top of the previous patch series.
> > 
> > The new patches are: (and are posted now)
> > 5987225... powerpc/ppc32: static ftrace fixes for PPC32
> 
> The new commit id with the fix in Author and SoB is:
> fd90db4bdc1ccf71927365cd634188cec4d7b151
>  powerpc/ppc32: static ftrace fixes for 

Steve, you rebased the previous commits, and that's a no-no. I sorted it 
all out, find below the stable URI for stuff that we'd like Paul to pull 
shortly before the merge window.

Thanks,

	Ingo

-------------------------->
Please pull the latest tracing/powerpc git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/powerpc

 Thanks,

	Ingo

------------------>
Steven Rostedt (10):
      powerpc: ftrace, do not latency trace idle
      powerpc: ftrace, convert to new dynamic ftrace arch API
      powerpc: ftrace, use probe_kernel API to modify code
      powerpc/ppc64: ftrace, handle module trampolines for dyn ftrace
      powerpc/ppc32: ftrace, dynamic ftrace to handle modules
      powerpc: ftrace, do nothing in mcount call for dyn ftrace
      powerpc: ftrace, fix cast aliasing and add code verification
      powerpc: ftrace, added missing icache flush
      powerpc: ftrace, use create_branch
      powerpc/ppc32: static ftrace fixes for PPC32


 arch/powerpc/include/asm/ftrace.h |   14 +-
 arch/powerpc/include/asm/module.h |   16 ++-
 arch/powerpc/kernel/Makefile      |    1 +
 arch/powerpc/kernel/entry_32.S    |   40 +---
 arch/powerpc/kernel/entry_64.S    |   12 -
 arch/powerpc/kernel/ftrace.c      |  461 +++++++++++++++++++++++++++++++++----
 arch/powerpc/kernel/idle.c        |    5 +
 arch/powerpc/kernel/module_32.c   |   10 +
 arch/powerpc/kernel/module_64.c   |   13 +
 arch/powerpc/lib/Makefile         |    3 +
 10 files changed, 490 insertions(+), 85 deletions(-)

diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index b298f7a..e5f2ae8 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -7,7 +7,19 @@
 
 #ifndef __ASSEMBLY__
 extern void _mcount(void);
-#endif
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+static inline unsigned long ftrace_call_adjust(unsigned long addr)
+{
+       /* reloction of mcount call site is the same as the address */
+       return addr;
+}
+
+struct dyn_arch_ftrace {
+	struct module *mod;
+};
+#endif /*  CONFIG_DYNAMIC_FTRACE */
+#endif /* __ASSEMBLY__ */
 
 #endif
 
diff --git a/arch/powerpc/include/asm/module.h b/arch/powerpc/include/asm/module.h
index e5f14b1..0845488 100644
--- a/arch/powerpc/include/asm/module.h
+++ b/arch/powerpc/include/asm/module.h
@@ -34,11 +34,19 @@ struct mod_arch_specific {
 #ifdef __powerpc64__
 	unsigned int stubs_section;	/* Index of stubs section in module */
 	unsigned int toc_section;	/* What section is the TOC? */
-#else
+#ifdef CONFIG_DYNAMIC_FTRACE
+	unsigned long toc;
+	unsigned long tramp;
+#endif
+
+#else /* powerpc64 */
 	/* Indices of PLT sections within module. */
 	unsigned int core_plt_section;
 	unsigned int init_plt_section;
+#ifdef CONFIG_DYNAMIC_FTRACE
+	unsigned long tramp;
 #endif
+#endif /* powerpc64 */
 
 	/* List of BUG addresses, source line numbers and filenames */
 	struct list_head bug_list;
@@ -68,6 +76,12 @@ struct mod_arch_specific {
 #    endif	/* MODULE */
 #endif
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+#    ifdef MODULE
+	asm(".section .ftrace.tramp,\"ax\",@nobits; .align 3; .previous");
+#    endif	/* MODULE */
+#endif
+
 
 struct exception_table_entry;
 void sort_ex_table(struct exception_table_entry *start,
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 92673b4..d17edb4 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -17,6 +17,7 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_cputable.o = -pg -mno-sched-epilog
 CFLAGS_REMOVE_prom_init.o = -pg -mno-sched-epilog
 CFLAGS_REMOVE_btext.o = -pg -mno-sched-epilog
+CFLAGS_REMOVE_prom.o = -pg -mno-sched-epilog
 
 ifdef CONFIG_DYNAMIC_FTRACE
 # dynamic ftrace setup.
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 7ecc0d1..6f7eb7e 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -1162,39 +1162,17 @@ machine_check_in_rtas:
 #ifdef CONFIG_DYNAMIC_FTRACE
 _GLOBAL(mcount)
 _GLOBAL(_mcount)
-	stwu	r1,-48(r1)
-	stw	r3, 12(r1)
-	stw	r4, 16(r1)
-	stw	r5, 20(r1)
-	stw	r6, 24(r1)
-	mflr	r3
-	stw	r7, 28(r1)
-	mfcr	r5
-	stw	r8, 32(r1)
-	stw	r9, 36(r1)
-	stw	r10,40(r1)
-	stw	r3, 44(r1)
-	stw	r5, 8(r1)
-	subi	r3, r3, MCOUNT_INSN_SIZE
-	.globl mcount_call
-mcount_call:
-	bl	ftrace_stub
-	nop
-	lwz	r6, 8(r1)
-	lwz	r0, 44(r1)
-	lwz	r3, 12(r1)
+	/*
+	 * It is required that _mcount on PPC32 must preserve the
+	 * link register. But we have r0 to play with. We use r0
+	 * to push the return address back to the caller of mcount
+	 * into the ctr register, restore the link register and
+	 * then jump back using the ctr register.
+	 */
+	mflr	r0
 	mtctr	r0
-	lwz	r4, 16(r1)
-	mtcr	r6
-	lwz	r5, 20(r1)
-	lwz	r6, 24(r1)
-	lwz	r0, 52(r1)
-	lwz	r7, 28(r1)
-	lwz	r8, 32(r1)
+	lwz	r0, 4(r1)
 	mtlr	r0
-	lwz	r9, 36(r1)
-	lwz	r10,40(r1)
-	addi	r1, r1, 48
 	bctr
 
 _GLOBAL(ftrace_caller)
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index e6d5284..b00982e 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -888,18 +888,6 @@ _GLOBAL(enter_prom)
 #ifdef CONFIG_DYNAMIC_FTRACE
 _GLOBAL(mcount)
 _GLOBAL(_mcount)
-	/* Taken from output of objdump from lib64/glibc */
-	mflr	r3
-	stdu	r1, -112(r1)
-	std	r3, 128(r1)
-	subi	r3, r3, MCOUNT_INSN_SIZE
-	.globl mcount_call
-mcount_call:
-	bl	ftrace_stub
-	nop
-	ld	r0, 128(r1)
-	mtlr	r0
-	addi	r1, r1, 112
 	blr
 
 _GLOBAL(ftrace_caller)
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index f4b006e..5355244 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -9,22 +9,30 @@
 
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
+#include <linux/uaccess.h>
+#include <linux/module.h>
 #include <linux/ftrace.h>
 #include <linux/percpu.h>
 #include <linux/init.h>
 #include <linux/list.h>
 
 #include <asm/cacheflush.h>
+#include <asm/code-patching.h>
 #include <asm/ftrace.h>
 
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(fmt , ...)	do { } while (0)
+#endif
 
-static unsigned int ftrace_nop = 0x60000000;
+static unsigned int ftrace_nop = PPC_NOP_INSTR;
 
 #ifdef CONFIG_PPC32
 # define GET_ADDR(addr) addr
 #else
 /* PowerPC64's functions are data that points to the functions */
-# define GET_ADDR(addr) *(unsigned long *)addr
+# define GET_ADDR(addr) (*(unsigned long *)addr)
 #endif
 
 
@@ -33,12 +41,12 @@ static unsigned int ftrace_calc_offset(long ip, long addr)
 	return (int)(addr - ip);
 }
 
-unsigned char *ftrace_nop_replace(void)
+static unsigned char *ftrace_nop_replace(void)
 {
 	return (char *)&ftrace_nop;
 }
 
-unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 {
 	static unsigned int op;
 
@@ -68,49 +76,422 @@ unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 # define _ASM_PTR	" .long "
 #endif
 
-int
+static int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
 {
-	unsigned replaced;
-	unsigned old = *(unsigned *)old_code;
-	unsigned new = *(unsigned *)new_code;
-	int faulted = 0;
+	unsigned char replaced[MCOUNT_INSN_SIZE];
 
 	/*
 	 * Note: Due to modules and __init, code can
 	 *  disappear and change, we need to protect against faulting
-	 *  as well as code changing.
+	 *  as well as code changing. We do this by using the
+	 *  probe_kernel_* functions.
 	 *
 	 * No real locking needed, this code is run through
-	 * kstop_machine.
+	 * kstop_machine, or before SMP starts.
 	 */
-	asm volatile (
-		"1: lwz		%1, 0(%2)\n"
-		"   cmpw	%1, %5\n"
-		"   bne		2f\n"
-		"   stwu	%3, 0(%2)\n"
-		"2:\n"
-		".section .fixup, \"ax\"\n"
-		"3:	li %0, 1\n"
-		"	b 2b\n"
-		".previous\n"
-		".section __ex_table,\"a\"\n"
-		_ASM_ALIGN "\n"
-		_ASM_PTR "1b, 3b\n"
-		".previous"
-		: "=r"(faulted), "=r"(replaced)
-		: "r"(ip), "r"(new),
-		  "0"(faulted), "r"(old)
-		: "memory");
-
-	if (replaced != old && replaced != new)
-		faulted = 2;
-
-	if (!faulted)
-		flush_icache_range(ip, ip + 8);
-
-	return faulted;
+
+	/* read the text we want to modify */
+	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	/* Make sure it is what we expect it to be */
+	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
+		return -EINVAL;
+
+	/* replace the text with the new text */
+	if (probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE))
+		return -EPERM;
+
+	flush_icache_range(ip, ip + 8);
+
+	return 0;
+}
+
+/*
+ * Helper functions that are the same for both PPC64 and PPC32.
+ */
+static int test_24bit_addr(unsigned long ip, unsigned long addr)
+{
+
+	/* use the create_branch to verify that this offset can be branched */
+	return create_branch((unsigned int *)ip, addr, 0);
+}
+
+static int is_bl_op(unsigned int op)
+{
+	return (op & 0xfc000003) == 0x48000001;
+}
+
+static unsigned long find_bl_target(unsigned long ip, unsigned int op)
+{
+	static int offset;
+
+	offset = (op & 0x03fffffc);
+	/* make it signed */
+	if (offset & 0x02000000)
+		offset |= 0xfe000000;
+
+	return ip + (long)offset;
+}
+
+#ifdef CONFIG_PPC64
+static int
+__ftrace_make_nop(struct module *mod,
+		  struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned int op;
+	unsigned int jmp[5];
+	unsigned long ptr;
+	unsigned long ip = rec->ip;
+	unsigned long tramp;
+	int offset;
+
+	/* read where this goes */
+	if (probe_kernel_read(&op, (void *)ip, sizeof(int)))
+		return -EFAULT;
+
+	/* Make sure that that this is still a 24bit jump */
+	if (!is_bl_op(op)) {
+		printk(KERN_ERR "Not expected bl: opcode is %x\n", op);
+		return -EINVAL;
+	}
+
+	/* lets find where the pointer goes */
+	tramp = find_bl_target(ip, op);
+
+	/*
+	 * On PPC64 the trampoline looks like:
+	 * 0x3d, 0x82, 0x00, 0x00,    addis   r12,r2, <high>
+	 * 0x39, 0x8c, 0x00, 0x00,    addi    r12,r12, <low>
+	 *   Where the bytes 2,3,6 and 7 make up the 32bit offset
+	 *   to the TOC that holds the pointer.
+	 *   to jump to.
+	 * 0xf8, 0x41, 0x00, 0x28,    std     r2,40(r1)
+	 * 0xe9, 0x6c, 0x00, 0x20,    ld      r11,32(r12)
+	 *   The actually address is 32 bytes from the offset
+	 *   into the TOC.
+	 * 0xe8, 0x4c, 0x00, 0x28,    ld      r2,40(r12)
+	 */
+
+	DEBUGP("ip:%lx jumps to %lx r2: %lx", ip, tramp, mod->arch.toc);
+
+	/* Find where the trampoline jumps to */
+	if (probe_kernel_read(jmp, (void *)tramp, sizeof(jmp))) {
+		printk(KERN_ERR "Failed to read %lx\n", tramp);
+		return -EFAULT;
+	}
+
+	DEBUGP(" %08x %08x", jmp[0], jmp[1]);
+
+	/* verify that this is what we expect it to be */
+	if (((jmp[0] & 0xffff0000) != 0x3d820000) ||
+	    ((jmp[1] & 0xffff0000) != 0x398c0000) ||
+	    (jmp[2] != 0xf8410028) ||
+	    (jmp[3] != 0xe96c0020) ||
+	    (jmp[4] != 0xe84c0028)) {
+		printk(KERN_ERR "Not a trampoline\n");
+		return -EINVAL;
+	}
+
+	offset = (unsigned)((unsigned short)jmp[0]) << 16 |
+		(unsigned)((unsigned short)jmp[1]);
+
+	DEBUGP(" %x ", offset);
+
+	/* get the address this jumps too */
+	tramp = mod->arch.toc + offset + 32;
+	DEBUGP("toc: %lx", tramp);
+
+	if (probe_kernel_read(jmp, (void *)tramp, 8)) {
+		printk(KERN_ERR "Failed to read %lx\n", tramp);
+		return -EFAULT;
+	}
+
+	DEBUGP(" %08x %08x\n", jmp[0], jmp[1]);
+
+	ptr = ((unsigned long)jmp[0] << 32) + jmp[1];
+
+	/* This should match what was called */
+	if (ptr != GET_ADDR(addr)) {
+		printk(KERN_ERR "addr does not match %lx\n", ptr);
+		return -EINVAL;
+	}
+
+	/*
+	 * We want to nop the line, but the next line is
+	 *  0xe8, 0x41, 0x00, 0x28   ld r2,40(r1)
+	 * This needs to be turned to a nop too.
+	 */
+	if (probe_kernel_read(&op, (void *)(ip+4), MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	if (op != 0xe8410028) {
+		printk(KERN_ERR "Next line is not ld! (%08x)\n", op);
+		return -EINVAL;
+	}
+
+	/*
+	 * Milton Miller pointed out that we can not blindly do nops.
+	 * If a task was preempted when calling a trace function,
+	 * the nops will remove the way to restore the TOC in r2
+	 * and the r2 TOC will get corrupted.
+	 */
+
+	/*
+	 * Replace:
+	 *   bl <tramp>  <==== will be replaced with "b 1f"
+	 *   ld r2,40(r1)
+	 *  1:
+	 */
+	op = 0x48000008;	/* b +8 */
+
+	if (probe_kernel_write((void *)ip, &op, MCOUNT_INSN_SIZE))
+		return -EPERM;
+
+
+	flush_icache_range(ip, ip + 8);
+
+	return 0;
+}
+
+#else /* !PPC64 */
+static int
+__ftrace_make_nop(struct module *mod,
+		  struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned int op;
+	unsigned int jmp[4];
+	unsigned long ip = rec->ip;
+	unsigned long tramp;
+
+	if (probe_kernel_read(&op, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	/* Make sure that that this is still a 24bit jump */
+	if (!is_bl_op(op)) {
+		printk(KERN_ERR "Not expected bl: opcode is %x\n", op);
+		return -EINVAL;
+	}
+
+	/* lets find where the pointer goes */
+	tramp = find_bl_target(ip, op);
+
+	/*
+	 * On PPC32 the trampoline looks like:
+	 *  0x3d, 0x60, 0x00, 0x00  lis r11,sym@ha
+	 *  0x39, 0x6b, 0x00, 0x00  addi r11,r11,sym@l
+	 *  0x7d, 0x69, 0x03, 0xa6  mtctr r11
+	 *  0x4e, 0x80, 0x04, 0x20  bctr
+	 */
+
+	DEBUGP("ip:%lx jumps to %lx", ip, tramp);
+
+	/* Find where the trampoline jumps to */
+	if (probe_kernel_read(jmp, (void *)tramp, sizeof(jmp))) {
+		printk(KERN_ERR "Failed to read %lx\n", tramp);
+		return -EFAULT;
+	}
+
+	DEBUGP(" %08x %08x ", jmp[0], jmp[1]);
+
+	/* verify that this is what we expect it to be */
+	if (((jmp[0] & 0xffff0000) != 0x3d600000) ||
+	    ((jmp[1] & 0xffff0000) != 0x396b0000) ||
+	    (jmp[2] != 0x7d6903a6) ||
+	    (jmp[3] != 0x4e800420)) {
+		printk(KERN_ERR "Not a trampoline\n");
+		return -EINVAL;
+	}
+
+	tramp = (jmp[1] & 0xffff) |
+		((jmp[0] & 0xffff) << 16);
+	if (tramp & 0x8000)
+		tramp -= 0x10000;
+
+	DEBUGP(" %x ", tramp);
+
+	if (tramp != addr) {
+		printk(KERN_ERR
+		       "Trampoline location %08lx does not match addr\n",
+		       tramp);
+		return -EINVAL;
+	}
+
+	op = PPC_NOP_INSTR;
+
+	if (probe_kernel_write((void *)ip, &op, MCOUNT_INSN_SIZE))
+		return -EPERM;
+
+	flush_icache_range(ip, ip + 8);
+
+	return 0;
+}
+#endif /* PPC64 */
+
+int ftrace_make_nop(struct module *mod,
+		    struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned char *old, *new;
+	unsigned long ip = rec->ip;
+
+	/*
+	 * If the calling address is more that 24 bits away,
+	 * then we had to use a trampoline to make the call.
+	 * Otherwise just update the call site.
+	 */
+	if (test_24bit_addr(ip, addr)) {
+		/* within range */
+		old = ftrace_call_replace(ip, addr);
+		new = ftrace_nop_replace();
+		return ftrace_modify_code(ip, old, new);
+	}
+
+	/*
+	 * Out of range jumps are called from modules.
+	 * We should either already have a pointer to the module
+	 * or it has been passed in.
+	 */
+	if (!rec->arch.mod) {
+		if (!mod) {
+			printk(KERN_ERR "No module loaded addr=%lx\n",
+			       addr);
+			return -EFAULT;
+		}
+		rec->arch.mod = mod;
+	} else if (mod) {
+		if (mod != rec->arch.mod) {
+			printk(KERN_ERR
+			       "Record mod %p not equal to passed in mod %p\n",
+			       rec->arch.mod, mod);
+			return -EINVAL;
+		}
+		/* nothing to do if mod == rec->arch.mod */
+	} else
+		mod = rec->arch.mod;
+
+	return __ftrace_make_nop(mod, rec, addr);
+
+}
+
+#ifdef CONFIG_PPC64
+static int
+__ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned int op[2];
+	unsigned long ip = rec->ip;
+
+	/* read where this goes */
+	if (probe_kernel_read(op, (void *)ip, MCOUNT_INSN_SIZE * 2))
+		return -EFAULT;
+
+	/*
+	 * It should be pointing to two nops or
+	 *  b +8; ld r2,40(r1)
+	 */
+	if (((op[0] != 0x48000008) || (op[1] != 0xe8410028)) &&
+	    ((op[0] != PPC_NOP_INSTR) || (op[1] != PPC_NOP_INSTR))) {
+		printk(KERN_ERR "Expected NOPs but have %x %x\n", op[0], op[1]);
+		return -EINVAL;
+	}
+
+	/* If we never set up a trampoline to ftrace_caller, then bail */
+	if (!rec->arch.mod->arch.tramp) {
+		printk(KERN_ERR "No ftrace trampoline\n");
+		return -EINVAL;
+	}
+
+	/* create the branch to the trampoline */
+	op[0] = create_branch((unsigned int *)ip,
+			      rec->arch.mod->arch.tramp, BRANCH_SET_LINK);
+	if (!op[0]) {
+		printk(KERN_ERR "REL24 out of range!\n");
+		return -EINVAL;
+	}
+
+	/* ld r2,40(r1) */
+	op[1] = 0xe8410028;
+
+	DEBUGP("write to %lx\n", rec->ip);
+
+	if (probe_kernel_write((void *)ip, op, MCOUNT_INSN_SIZE * 2))
+		return -EPERM;
+
+	flush_icache_range(ip, ip + 8);
+
+	return 0;
+}
+#else
+static int
+__ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned int op;
+	unsigned long ip = rec->ip;
+
+	/* read where this goes */
+	if (probe_kernel_read(&op, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	/* It should be pointing to a nop */
+	if (op != PPC_NOP_INSTR) {
+		printk(KERN_ERR "Expected NOP but have %x\n", op);
+		return -EINVAL;
+	}
+
+	/* If we never set up a trampoline to ftrace_caller, then bail */
+	if (!rec->arch.mod->arch.tramp) {
+		printk(KERN_ERR "No ftrace trampoline\n");
+		return -EINVAL;
+	}
+
+	/* create the branch to the trampoline */
+	op = create_branch((unsigned int *)ip,
+			   rec->arch.mod->arch.tramp, BRANCH_SET_LINK);
+	if (!op) {
+		printk(KERN_ERR "REL24 out of range!\n");
+		return -EINVAL;
+	}
+
+	DEBUGP("write to %lx\n", rec->ip);
+
+	if (probe_kernel_write((void *)ip, &op, MCOUNT_INSN_SIZE))
+		return -EPERM;
+
+	flush_icache_range(ip, ip + 8);
+
+	return 0;
+}
+#endif /* CONFIG_PPC64 */
+
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned char *old, *new;
+	unsigned long ip = rec->ip;
+
+	/*
+	 * If the calling address is more that 24 bits away,
+	 * then we had to use a trampoline to make the call.
+	 * Otherwise just update the call site.
+	 */
+	if (test_24bit_addr(ip, addr)) {
+		/* within range */
+		old = ftrace_nop_replace();
+		new = ftrace_call_replace(ip, addr);
+		return ftrace_modify_code(ip, old, new);
+	}
+
+	/*
+	 * Out of range jumps are called from modules.
+	 * Being that we are converting from nop, it had better
+	 * already have a module defined.
+	 */
+	if (!rec->arch.mod) {
+		printk(KERN_ERR "No module loaded\n");
+		return -EINVAL;
+	}
+
+	return __ftrace_make_call(rec, addr);
 }
 
 int ftrace_update_ftrace_func(ftrace_func_t func)
@@ -128,10 +509,10 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	/* This is running in kstop_machine */
+	/* caller expects data to be zero */
+	unsigned long *p = data;
 
-	ftrace_mcount_set(data);
+	*p = 0;
 
 	return 0;
 }
-
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 31982d0..88d9c1d 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -69,10 +69,15 @@ void cpu_idle(void)
 				smp_mb();
 				local_irq_disable();
 
+				/* Don't trace irqs off for idle */
+				stop_critical_timings();
+
 				/* check again after disabling irqs */
 				if (!need_resched() && !cpu_should_die())
 					ppc_md.power_save();
 
+				start_critical_timings();
+
 				local_irq_enable();
 				set_thread_flag(TIF_POLLING_NRFLAG);
 
diff --git a/arch/powerpc/kernel/module_32.c b/arch/powerpc/kernel/module_32.c
index 2df91a0..f832773 100644
--- a/arch/powerpc/kernel/module_32.c
+++ b/arch/powerpc/kernel/module_32.c
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/ftrace.h>
 #include <linux/cache.h>
 #include <linux/bug.h>
 #include <linux/sort.h>
@@ -53,6 +54,9 @@ static unsigned int count_relocs(const Elf32_Rela *rela, unsigned int num)
 			r_addend = rela[i].r_addend;
 		}
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+	_count_relocs++;	/* add one for ftrace_caller */
+#endif
 	return _count_relocs;
 }
 
@@ -306,5 +310,11 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 			return -ENOEXEC;
 		}
 	}
+#ifdef CONFIG_DYNAMIC_FTRACE
+	module->arch.tramp =
+		do_plt_call(module->module_core,
+			    (unsigned long)ftrace_caller,
+			    sechdrs, module);
+#endif
 	return 0;
 }
diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index 1af2377..8992b03 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -20,6 +20,7 @@
 #include <linux/moduleloader.h>
 #include <linux/err.h>
 #include <linux/vmalloc.h>
+#include <linux/ftrace.h>
 #include <linux/bug.h>
 #include <asm/module.h>
 #include <asm/firmware.h>
@@ -163,6 +164,11 @@ static unsigned long get_stubs_size(const Elf64_Ehdr *hdr,
 		}
 	}
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+	/* make the trampoline to the ftrace_caller */
+	relocs++;
+#endif
+
 	DEBUGP("Looks like a total of %lu stubs, max\n", relocs);
 	return relocs * sizeof(struct ppc64_stub_entry);
 }
@@ -441,5 +447,12 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 		}
 	}
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+	me->arch.toc = my_r2(sechdrs, me);
+	me->arch.tramp = stub_for_addr(sechdrs,
+				       (unsigned long)ftrace_caller,
+				       me);
+#endif
+
 	return 0;
 }
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index d69912c..8db3527 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -6,6 +6,9 @@ ifeq ($(CONFIG_PPC64),y)
 EXTRA_CFLAGS		+= -mno-minimal-toc
 endif
 
+CFLAGS_REMOVE_code-patching.o = -pg
+CFLAGS_REMOVE_feature-fixups.o = -pg
+
 obj-y			:= string.o alloc.o \
 			   checksum_$(CONFIG_WORD_SIZE).o
 obj-$(CONFIG_PPC32)	+= div64.o copy_32.o crtsavres.o
