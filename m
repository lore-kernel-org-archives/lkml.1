Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYKSV0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYKSV0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYKSVXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:23:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbYKSVXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:23:36 -0500
Message-Id: <20081119212334.752162513@goodmis.org>
References: <20081119212204.318400312@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 19 Nov 2008 16:22:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 9/9] powerpc/ppc32: ftrace, dynamic ftrace to handle modules
Content-Disposition: inline; filename=0009-powerpc-ppc32-ftrace-dynamic-ftrace-to-handle-modu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add ability to trace modules on 32 bit PowerPC

This patch performs the necessary trampoline calls to handle
modules with dynamic ftrace on 32 bit PowerPC.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/include/asm/module.h |    5 ++-
 arch/powerpc/kernel/ftrace.c      |  101 ++++++++++++++++++++++++++++++++++--
 arch/powerpc/kernel/module_32.c   |   10 ++++
 3 files changed, 109 insertions(+), 7 deletions(-)

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
index 1aec559..3271cd6 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -274,7 +274,63 @@ static int
 __ftrace_make_nop(struct module *mod,
 		  struct dyn_ftrace *rec, unsigned long addr)
 {
-	/* Ignore modules for PPC32 (for now) */
+	unsigned char replaced[MCOUNT_INSN_SIZE];
+	unsigned int *op = (unsigned *)&replaced;
+	unsigned char jmp[8];
+	unsigned int *ptr = (unsigned int *)&jmp;
+	unsigned long ip = rec->ip;
+	unsigned long tramp;
+	int offset;
+
+	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	/* Make sure that that this is still a 24bit jump */
+	if (!is_bl_op(*op)) {
+		printk(KERN_ERR "Not expected bl: opcode is %x\n", *op);
+		return -EINVAL;
+	}
+
+	/* lets find where the pointer goes */
+	tramp = find_bl_target(ip, *op);
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
 	return 0;
 }
 #endif /* PPC64 */
@@ -297,7 +353,6 @@ int ftrace_make_nop(struct module *mod,
 		return ftrace_modify_code(ip, old, new);
 	}
 
-#ifdef CONFIG_PPC64
 	/*
 	 * Out of range jumps are called from modules.
 	 * We should either already have a pointer to the module
@@ -320,7 +375,6 @@ int ftrace_make_nop(struct module *mod,
 		/* nothing to do if mod == rec->arch.mod */
 	} else
 		mod = rec->arch.mod;
-#endif /* CONFIG_PPC64 */
 
 	return __ftrace_make_nop(mod, rec, addr);
 
@@ -380,7 +434,44 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 static int
 __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
-	/* PPC32 ignores modules for now */
+	unsigned char replaced[MCOUNT_INSN_SIZE];
+	unsigned int *op = (unsigned *)&replaced;
+	unsigned long ip = rec->ip;
+	unsigned long offset;
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
+	if (test_offset(offset)) {
+		printk(KERN_ERR "REL24 %li out of range!\n",
+		       (long int)offset);
+		return -EINVAL;
+	}
+
+	/* Set to "bl addr" */
+	op[0] = branch_offset(offset);
+
+	DEBUGP("write to %lx\n", rec->ip);
+
+	if (probe_kernel_write((void *)ip, replaced, MCOUNT_INSN_SIZE))
+		return -EPERM;
+
 	return 0;
 }
 #endif /* CONFIG_PPC64 */
@@ -402,7 +493,6 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 		return ftrace_modify_code(ip, old, new);
 	}
 
-#ifdef CONFIG_PPC64
 	/*
 	 * Out of range jumps are called from modules.
 	 * Being that we are converting from nop, it had better
@@ -412,7 +502,6 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 		printk(KERN_ERR "No module loaded\n");
 		return -EINVAL;
 	}
-#endif
 
 	return __ftrace_make_call(rec, addr);
 }
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
