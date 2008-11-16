Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYKPV1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYKPV1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 16:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYKPVZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 16:25:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60552 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbYKPVZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 16:25:18 -0500
Message-Id: <20081116212516.391730787@goodmis.org>
References: <20081116212428.938752312@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sun, 16 Nov 2008 16:24:35 -0500
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
Subject: [PATCH 7/7] ftrace,ppc32: dynamic ftrace to handle modules
Content-Disposition: inline; filename=0007-ftrace-ppc32-dynamic-ftrace-to-handle-modules.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: enable modules for dynamic ftrace on PPC32

This patch performs the necessary trampoline calls to handle
modules with dynamic ftrace.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/include/asm/ftrace.h |    1 -
 arch/powerpc/include/asm/module.h |    5 +-
 arch/powerpc/kernel/ftrace.c      |  219 +++++++++++++++++++++++++++++++-----
 arch/powerpc/kernel/module_32.c   |   10 ++
 4 files changed, 202 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index d57f5bc..e5f2ae8 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -17,7 +17,6 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 
 struct dyn_arch_ftrace {
 	struct module *mod;
-	unsigned long tramp;
 };
 #endif /*  CONFIG_DYNAMIC_FTRACE */
 #endif /* __ASSEMBLY__ */
diff --git a/arch/powerpc/include/asm/module.h b/arch/powerpc/include/asm/module.h
index 340bc69..0845488 100644
--- a/arch/powerpc/include/asm/module.h
+++ b/arch/powerpc/include/asm/module.h
@@ -39,11 +39,14 @@ struct mod_arch_specific {
 	unsigned long tramp;
 #endif
 
-#else
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
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index acbec66..57fdda8 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -119,36 +119,20 @@ static int test_24bit_addr(unsigned long ip, unsigned long addr)
 	return !(diff & ((unsigned long)-1 << 24));
 }
 
-int ftrace_make_nop(struct module *mod,
-		    struct dyn_ftrace *rec, unsigned long addr)
+#ifdef CONFIG_PPC64
+static int
+__ftrace_make_nop(struct module *mod,
+		  struct dyn_ftrace *rec, unsigned long addr)
 {
 	unsigned char replaced[MCOUNT_INSN_SIZE * 2];
 	unsigned int *op = (unsigned *)&replaced;
 	unsigned char jmp[8];
 	unsigned long *ptr = (unsigned long *)&jmp;
-	unsigned char *old, *new;
 	unsigned long ip = rec->ip;
 	unsigned long tramp;
 	int offset;
 
 	/*
-	 * If the calling address is more that 24 bits away,
-	 * then we had to use a trampoline to make the call.
-	 * Otherwise just update the call site.
-	 */
-	if (test_24bit_addr(ip, addr)) {
-		/* within range */
-		old = ftrace_call_replace(ip, addr);
-		new = ftrace_nop_replace();
-		return ftrace_modify_code(ip, old, new);
-	}
-
-#ifndef CONFIG_PPC64
-	/* only supported for PPC64 for now */
-	return 0;
-#else
-
-	/*
 	 * Out of range jumps are called from modules.
 	 * We should either already have a pointer to the module
 	 * or it has been passed in.
@@ -258,16 +242,105 @@ int ftrace_make_nop(struct module *mod,
 		return -EPERM;
 
 	return 0;
-#endif /* CONFIG_PPC64 */
 }
 
-int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+#else /* !PPC64 */
+static int
+__ftrace_make_nop(struct module *mod,
+		  struct dyn_ftrace *rec, unsigned long addr)
 {
-	unsigned char replaced[MCOUNT_INSN_SIZE * 2];
+	unsigned char replaced[MCOUNT_INSN_SIZE];
 	unsigned int *op = (unsigned *)&replaced;
+	unsigned char jmp[8];
+	unsigned int *ptr = (unsigned int *)&jmp;
+	unsigned long ip = rec->ip;
+	unsigned long tramp;
+	int offset;
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
+	 * On PPC32 the trampoline looks like:
+	 * lis r11,sym@ha
+	 * addi r11,r11,sym@l
+	 * mtctr r11
+	 * bctr
+	 */
+
+	DEBUGP("ip:%lx jumps to %lx", ip, tramp);
+
+	/* Find where the trampoline jumps to */
+	if (probe_kernel_read(jmp, (void *)tramp, 8)) {
+		printk(KERN_ERR "Failed to read %lx\n", tramp);
+		return -EFAULT;
+	}
+
+	DEBUGP(" %08x %08x ", ptr[0], ptr[1]);
+
+	tramp = (ptr[1] & 0xffff) |
+		((ptr[0] & 0xffff) << 16);
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
+	op[0] = PPC_NOP_INSTR;
+
+	if (probe_kernel_write((void *)ip, replaced, MCOUNT_INSN_SIZE))
+		return -EPERM;
+
+	return 0;
+}
+#endif /* PPC64 */
+
+int ftrace_make_nop(struct module *mod,
+		    struct dyn_ftrace *rec, unsigned long addr)
+{
 	unsigned char *old, *new;
 	unsigned long ip = rec->ip;
-	unsigned long offset;
 
 	/*
 	 * If the calling address is more that 24 bits away,
@@ -276,15 +349,23 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	 */
 	if (test_24bit_addr(ip, addr)) {
 		/* within range */
-		old = ftrace_nop_replace();
-		new = ftrace_call_replace(ip, addr);
+		old = ftrace_call_replace(ip, addr);
+		new = ftrace_nop_replace();
 		return ftrace_modify_code(ip, old, new);
 	}
 
-#ifndef CONFIG_PPC64
-	/* only supported for PPC64 for now */
-	return 0;
-#else
+	return __ftrace_make_nop(mod, rec, addr);
+
+}
+
+#ifdef CONFIG_PPC64
+static int
+__ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned char replaced[MCOUNT_INSN_SIZE * 2];
+	unsigned int *op = (unsigned *)&replaced;
+	unsigned long ip = rec->ip;
+	unsigned long offset;
 
 	/*
 	 * Out of range jumps are called from modules.
@@ -334,7 +415,83 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 		return -EPERM;
 
 	return 0;
-#endif /* CONFIG_PPC64 */
+}
+#else
+static int
+__ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned char replaced[MCOUNT_INSN_SIZE];
+	unsigned int *op = (unsigned *)&replaced;
+	unsigned long ip = rec->ip;
+	unsigned long offset;
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
+	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	/* It should be pointing to a nop */
+	if (op[0] != PPC_NOP_INSTR) {
+		printk(KERN_ERR "Expected NOP but have %x\n", op[0]);
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
+
+	DEBUGP("write to %lx\n", rec->ip);
+
+	if (probe_kernel_write((void *)ip, replaced, MCOUNT_INSN_SIZE))
+		return -EPERM;
+
+	return 0;
+}
+#endif
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
+	return __ftrace_make_call(rec, addr);
+
 }
 
 int ftrace_update_ftrace_func(ftrace_func_t func)
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
-- 
1.5.6.5

-- 
