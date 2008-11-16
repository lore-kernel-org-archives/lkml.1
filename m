Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYKPV1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYKPV1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 16:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYKPVZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 16:25:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60529 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYKPVZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 16:25:17 -0500
Message-Id: <20081116212516.000516128@goodmis.org>
References: <20081116212428.938752312@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sun, 16 Nov 2008 16:24:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/7] ftrace, PPC64: handle module trampolines for dyn ftrace
Content-Disposition: inline; filename=0005-ftrace-PPC64-handle-module-trampolines-for-dyn-ftr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Implement PPC64 module trampolines for dyn ftrace

This adds code to handle the PPC64 module trampolines, and allows for
PPC64 to use dynamic ftrace.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/include/asm/ftrace.h |    3 +-
 arch/powerpc/include/asm/module.h |   11 ++
 arch/powerpc/kernel/ftrace.c      |  202 +++++++++++++++++++++++++++++++++++--
 arch/powerpc/kernel/module_64.c   |   13 +++
 4 files changed, 220 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index 17efecc..d57f5bc 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -16,7 +16,8 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 }
 
 struct dyn_arch_ftrace {
-	/* nothing yet */
+	struct module *mod;
+	unsigned long tramp;
 };
 #endif /*  CONFIG_DYNAMIC_FTRACE */
 #endif /* __ASSEMBLY__ */
diff --git a/arch/powerpc/include/asm/module.h b/arch/powerpc/include/asm/module.h
index e5f14b1..340bc69 100644
--- a/arch/powerpc/include/asm/module.h
+++ b/arch/powerpc/include/asm/module.h
@@ -34,6 +34,11 @@ struct mod_arch_specific {
 #ifdef __powerpc64__
 	unsigned int stubs_section;	/* Index of stubs section in module */
 	unsigned int toc_section;	/* What section is the TOC? */
+#ifdef CONFIG_DYNAMIC_FTRACE
+	unsigned long toc;
+	unsigned long tramp;
+#endif
+
 #else
 	/* Indices of PLT sections within module. */
 	unsigned int core_plt_section;
@@ -68,6 +73,12 @@ struct mod_arch_specific {
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
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 3852919..acbec66 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -10,22 +10,29 @@
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
 #include <linux/uaccess.h>
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
 
 
@@ -115,40 +122,219 @@ static int test_24bit_addr(unsigned long ip, unsigned long addr)
 int ftrace_make_nop(struct module *mod,
 		    struct dyn_ftrace *rec, unsigned long addr)
 {
+	unsigned char replaced[MCOUNT_INSN_SIZE * 2];
+	unsigned int *op = (unsigned *)&replaced;
+	unsigned char jmp[8];
+	unsigned long *ptr = (unsigned long *)&jmp;
 	unsigned char *old, *new;
+	unsigned long ip = rec->ip;
+	unsigned long tramp;
+	int offset;
 
 	/*
 	 * If the calling address is more that 24 bits away,
 	 * then we had to use a trampoline to make the call.
 	 * Otherwise just update the call site.
 	 */
-	if (test_24bit_addr(rec->ip, addr)) {
+	if (test_24bit_addr(ip, addr)) {
 		/* within range */
-		old = ftrace_call_replace(rec->ip, addr);
+		old = ftrace_call_replace(ip, addr);
 		new = ftrace_nop_replace();
-		return ftrace_modify_code(rec->ip, old, new);
+		return ftrace_modify_code(ip, old, new);
 	}
 
+#ifndef CONFIG_PPC64
+	/* only supported for PPC64 for now */
 	return 0;
+#else
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
+		printk(KERN_ERR
+		       "Record mod %p not equal to passed in mod %p\n",
+		       rec->arch.mod, mod);
+		return -EINVAL;
+	} else
+		mod = rec->arch.mod;
+
+	/* read where this goes */
+	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	/* Make sure that that this is still a 24bit jump */
+	if ((*op & 0xff000000) != 0x48000000) {
+		printk(KERN_ERR "Not expected bl: opcode is %x\n", *op);
+		return -EINVAL;
+	}
+
+	/* lets find where the pointer goes */
+	offset = (*op & 0x03fffffc);
+	/* make it signed */
+	if (offset & 0x02000000)
+		offset |= 0xfe000000;
+
+	tramp = ip + (long)offset;
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
+	if (probe_kernel_read(jmp, (void *)tramp, 8)) {
+		printk(KERN_ERR "Failed to read %lx\n", tramp);
+		return -EFAULT;
+	}
+
+	DEBUGP(" %08x %08x",
+	       (unsigned)(*ptr >> 32),
+	       (unsigned)*ptr);
+
+	offset = (unsigned)jmp[2] << 24 |
+		(unsigned)jmp[3] << 16 |
+		(unsigned)jmp[6] << 8 |
+		(unsigned)jmp[7];
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
+	DEBUGP(" %08x %08x\n",
+	       (unsigned)(*ptr >> 32),
+	       (unsigned)*ptr);
+
+	/* This should match what was called */
+	if (*ptr != GET_ADDR(addr)) {
+		printk(KERN_ERR "addr does not match %lx\n", *ptr);
+		return -EINVAL;
+	}
+
+	/*
+	 * We want to nop the line, but the next line is
+	 *  0xe8, 0x41, 0x00, 0x28   ld r2,40(r1)
+	 * This needs to be turned to a nop too.
+	 */
+	if (probe_kernel_read(replaced, (void *)(ip+4), MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	if (*op != 0xe8410028) {
+		printk(KERN_ERR "Next line is not ld! (%08x)\n", *op);
+		return -EINVAL;
+	}
+
+	op[0] = PPC_NOP_INSTR;
+	op[1] = PPC_NOP_INSTR;
+
+	if (probe_kernel_write((void *)ip, replaced, MCOUNT_INSN_SIZE * 2))
+		return -EPERM;
+
+	return 0;
+#endif /* CONFIG_PPC64 */
 }
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
+	unsigned char replaced[MCOUNT_INSN_SIZE * 2];
+	unsigned int *op = (unsigned *)&replaced;
 	unsigned char *old, *new;
+	unsigned long ip = rec->ip;
+	unsigned long offset;
 
 	/*
 	 * If the calling address is more that 24 bits away,
 	 * then we had to use a trampoline to make the call.
 	 * Otherwise just update the call site.
 	 */
-	if (test_24bit_addr(rec->ip, addr)) {
+	if (test_24bit_addr(ip, addr)) {
 		/* within range */
 		old = ftrace_nop_replace();
-		new = ftrace_call_replace(rec->ip, addr);
-		return ftrace_modify_code(rec->ip, old, new);
+		new = ftrace_call_replace(ip, addr);
+		return ftrace_modify_code(ip, old, new);
 	}
 
+#ifndef CONFIG_PPC64
+	/* only supported for PPC64 for now */
+	return 0;
+#else
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
+	/* read where this goes */
+	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE * 2))
+		return -EFAULT;
+
+	/* It should be pointing to two nops */
+	if ((op[0] != PPC_NOP_INSTR) ||
+	    (op[1] != PPC_NOP_INSTR)) {
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
+	/* now calculate a jump to the ftrace caller trampoline */
+	offset = rec->arch.mod->arch.tramp - ip;
+
+	if (offset + 0x2000000 > 0x3ffffff || (offset & 3) != 0) {
+		printk(KERN_ERR "REL24 %li out of range!\n",
+		       (long int)offset);
+		return -EINVAL;
+	}
+
+
+	/* Set to "bl addr" */
+	op[0] = 0x48000001 | (offset & 0x03fffffc);
+	/* ld r2,40(r1) */
+	op[1] = 0xe8410028;
+
+	DEBUGP("write to %lx\n", rec->ip);
+
+	if (probe_kernel_write((void *)ip, replaced, MCOUNT_INSN_SIZE * 2))
+		return -EPERM;
+
 	return 0;
+#endif /* CONFIG_PPC64 */
 }
 
 int ftrace_update_ftrace_func(ftrace_func_t func)
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
-- 
1.5.6.5

-- 
