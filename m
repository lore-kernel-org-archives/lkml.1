Return-Path: <linux-kernel-owner+w=401wt.eu-S1765561AbYD1Dvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765561AbYD1Dvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 23:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763929AbYD1Du6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 23:50:58 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:57938 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762596AbYD1Du4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 23:50:56 -0400
Message-Id: <20080428035006.077224947@polymtl.ca>
References: <20080428033415.303000651@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 27 Apr 2008 23:34:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/2] Immediate Values - jump liveliness
Content-Disposition: inline; filename=immediate-values-jump-liveliness.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 28 Apr 2008 03:50:07 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for limited liveliness of ZF and %eax in the search pattern.
Declare a 5-bytes mov in the inline assembly stub and change it for a 5-bytes
jump. We would not want to modify an instruction which gcc reuses for other
purposes (it could jump in the middle of the pattern), but changing our own mov
is ok, because we know that liveliness of %eax is limited to our pattern (mov,
test, branch). It is therefore OK to change:

mov, test, cond. branch
for
jump, test, cond. branch

Where jump has the same behavior as the conditional branch.

It applies on top of the Immediate Values - jump patch. (should be folded with
that patch).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/immediate.c       |  228 +++++++++++++++++---------------------
 include/asm-generic/vmlinux.lds.h |    4 
 include/asm-powerpc/immediate.h   |    1 
 include/asm-x86/immediate.h       |   58 ++++++---
 include/linux/immediate.h         |    4 
 include/linux/module.h            |    8 +
 kernel/immediate.c                |   38 ++++++
 kernel/module.c                   |   23 +++
 8 files changed, 226 insertions(+), 138 deletions(-)

Index: linux-2.6-sched-devel/include/asm-powerpc/immediate.h
===================================================================
--- linux-2.6-sched-devel.orig/include/asm-powerpc/immediate.h	2008-04-26 10:53:53.000000000 -0400
+++ linux-2.6-sched-devel/include/asm-powerpc/immediate.h	2008-04-26 10:54:44.000000000 -0400
@@ -69,6 +69,7 @@ struct __imv {
 	})
 
 #define imv_cond(name)	imv_read(name)
+#define imv_cond_end()
 
 extern int arch_imv_update(const struct __imv *imv, int early);
 
Index: linux-2.6-sched-devel/include/asm-x86/immediate.h
===================================================================
--- linux-2.6-sched-devel.orig/include/asm-x86/immediate.h	2008-04-26 10:53:53.000000000 -0400
+++ linux-2.6-sched-devel/include/asm-x86/immediate.h	2008-04-26 15:38:37.000000000 -0400
@@ -20,8 +20,8 @@ struct __imv {
 				 * Pointer to the memory location of the
 				 * immediate value within the instruction.
 				 */
-	int  jmp_off;		/* offset for jump target */
-	unsigned char size;	/* Type size. */
+	unsigned char var_size;	/* Type size of variable. */
+	unsigned char size;	/* Type size of immediate value. */
 	unsigned char insn_size;/* Instruction size. */
 } __attribute__ ((packed));
 
@@ -58,8 +58,7 @@ struct __imv {
 				".previous\n\t"				\
 				".section __imv,\"aw\",@progbits\n\t"	\
 				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
-				".int 0\n\t"				\
-				".byte %c2, (2b-1b)\n\t"		\
+				".byte %c2, %c2, (2b-1b)\n\t"		\
 				".previous\n\t"				\
 				"mov $0,%0\n\t"				\
 				"3:\n\t"				\
@@ -76,8 +75,7 @@ struct __imv {
 				".previous\n\t"				\
 				".section __imv,\"aw\",@progbits\n\t"	\
 				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
-				".int 0\n\t"				\
-				".byte %c2, (2b-1b)\n\t"		\
+				".byte %c2, %c2, (2b-1b)\n\t"		\
 				".previous\n\t"				\
 				".org . + ((-.-(2b-1b)) & (%c2-1)), 0x90\n\t" \
 				"mov $0,%0\n\t"				\
@@ -98,8 +96,7 @@ struct __imv {
 				".previous\n\t"				\
 				".section __imv,\"aw\",@progbits\n\t"	\
 				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
-				".int 0\n\t"				\
-				".byte %c2, (2b-1b)\n\t"		\
+				".byte %c2, %c2, (2b-1b)\n\t"		\
 				".previous\n\t"				\
 				".org . + ((-.-(2b-1b)) & (%c2-1)), 0x90\n\t" \
 				"mov $0xFEFEFEFE01010101,%0\n\t" 	\
@@ -113,33 +110,60 @@ struct __imv {
 	})
 
 /*
- * Uses %al.
- * size is 0.
- * Use in if (unlikely(imv_cond(var)))
+ * Uses %eax.
+ * immediate value size is declared as 0.
+ * Use in
+ * if (unlikely(imv_cond(var))) {
+ *   imv_cond_end();
+ *   ...
+ * } else {
+ *   imv_cond_end();
+ *   ...
+ * }
  * Given a char as argument.
+ * If the expected code pattern insuring correct liveliness of ZF and %eax isn't
+ * met, fallback on standard immediate value.
+ * patches the 5 bytes mov for a e9 XX XX XX XX (near jump)
+ * Note : Patching the the 4 bytes immediate value with 1 byte variable
+ * on fallback.
  */
 #define imv_cond(name)							\
 	({								\
-		__typeof__(name##__imv) value;				\
-		BUILD_BUG_ON(sizeof(value) > 1);			\
+		uint32_t value;						\
+		BUILD_BUG_ON(sizeof(__typeof__(name##__imv)) > 1);	\
 		asm (".section __discard,\"\",@progbits\n\t"		\
 			"1:\n\t"					\
 			"mov $0,%0\n\t"					\
 			"2:\n\t"					\
 			".previous\n\t"					\
 			".section __imv,\"aw\",@progbits\n\t"		\
-			_ASM_PTR "%c1, (3f)-1\n\t"			\
-			".int 0\n\t"					\
-			".byte %c2, (2b-1b)\n\t"			\
+			_ASM_PTR "%c1, (3f)-%c2\n\t"			\
+			".byte %c3, 0, (2b-1b)\n\t"			\
 			".previous\n\t"					\
 			"mov $0,%0\n\t"					\
 			"3:\n\t"					\
 			: "=a" (value)					\
 			: "i" (&name##__imv),				\
-			  "i" (0));					\
+			  "i" (sizeof(value)),				\
+			  "i" (sizeof(__typeof__(name##__imv))));	\
 		value;							\
 	})
 
+/*
+ * Make sure the %eax register and ZF are not live anymore at the current
+ * address, which is declared in the __imv_cond_end section.
+ * All asm statements clobbers the flags, but add "cc" clobber just to be sure.
+ * Clobbers %eax.
+ */
+#define imv_cond_end()							\
+	do {								\
+		asm (".section __imv_cond_end,\"a\",@progbits\n\t"	\
+				_ASM_PTR "1f\n\t"			\
+				".previous\n\t"				\
+				"1:\n\t"				\
+				: : : "eax", "cc");			\
+	} while (0)
+
 extern int arch_imv_update(struct __imv *imv, int early);
 
 #endif /* _ASM_X86_IMMEDIATE_H */
Index: linux-2.6-sched-devel/include/linux/immediate.h
===================================================================
--- linux-2.6-sched-devel.orig/include/linux/immediate.h	2008-04-26 10:53:56.000000000 -0400
+++ linux-2.6-sched-devel/include/linux/immediate.h	2008-04-26 10:54:44.000000000 -0400
@@ -37,6 +37,9 @@ extern void imv_update_range(struct __im
 extern void imv_unref_core_init(void);
 extern void imv_unref(struct __imv *begin, struct __imv *end, void *start,
 		unsigned long size);
+extern int _is_imv_cond_end(unsigned long *begin, unsigned long *end,
+		unsigned long addr1, unsigned long addr2);
+extern int is_imv_cond_end(unsigned long addr1, unsigned long addr2);
 
 #else
 
@@ -59,6 +62,7 @@ extern void imv_unref(struct __imv *begi
  * Reads the value of @name.
  */
 #define imv_cond(name)			_imv_read(name)
+#define imv_cond_end()
 
 /**
  * imv_set - set immediate variable (with locking)
Index: linux-2.6-sched-devel/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-sched-devel.orig/include/asm-generic/vmlinux.lds.h	2008-04-26 10:53:53.000000000 -0400
+++ linux-2.6-sched-devel/include/asm-generic/vmlinux.lds.h	2008-04-26 10:54:44.000000000 -0400
@@ -63,6 +63,10 @@
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
 		*(.rodata) *(.rodata.*)					\
 		*(__vermagic)		/* Kernel version magic */	\
+		. = ALIGN(8);						\
+		VMLINUX_SYMBOL(__start___imv_cond_end) = .;		\
+		*(__imv_cond_end) /* Immediate condition end pointers */\
+		VMLINUX_SYMBOL(__stop___imv_cond_end) = .;		\
 		*(__markers_strings)	/* Markers: strings */		\
 	}								\
 									\
Index: linux-2.6-sched-devel/include/linux/module.h
===================================================================
--- linux-2.6-sched-devel.orig/include/linux/module.h	2008-04-26 10:53:56.000000000 -0400
+++ linux-2.6-sched-devel/include/linux/module.h	2008-04-26 10:54:44.000000000 -0400
@@ -359,6 +359,8 @@ struct module
 #ifdef CONFIG_IMMEDIATE
 	struct __imv *immediate;
 	unsigned int num_immediate;
+	unsigned long *immediate_cond_end;
+	unsigned int num_immediate_cond_end;
 #endif
 #ifdef CONFIG_MARKERS
 	struct marker *markers;
@@ -581,6 +583,7 @@ static inline void module_update_markers
 #if defined(CONFIG_MODULES) && defined(CONFIG_IMMEDIATE)
 extern void _module_imv_update(void);
 extern void module_imv_update(void);
+extern int is_imv_cond_end_module(unsigned long addr1, unsigned long addr2);
 #else
 static inline void _module_imv_update(void)
 {
@@ -588,6 +591,11 @@ static inline void _module_imv_update(vo
 static inline void module_imv_update(void)
 {
 }
+static inline int is_imv_cond_end_module(unsigned long addr1,
+		unsigned long addr2)
+{
+	return 0;
+}
 #endif
 
 struct device_driver;
Index: linux-2.6-sched-devel/kernel/immediate.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/immediate.c	2008-04-26 10:53:56.000000000 -0400
+++ linux-2.6-sched-devel/kernel/immediate.c	2008-04-26 10:54:44.000000000 -0400
@@ -29,6 +29,8 @@ static int imv_early_boot_complete;
 
 extern struct __imv __start___imv[];
 extern struct __imv __stop___imv[];
+extern unsigned long __start___imv_cond_end[];
+extern unsigned long __stop___imv_cond_end[];
 
 /*
  * imv_mutex nests inside module_mutex. imv_mutex protects builtin
@@ -103,6 +105,42 @@ void imv_unref_core_init(void)
 		(unsigned long)__init_end - (unsigned long)__init_begin);
 }
 
+int _is_imv_cond_end(unsigned long *begin, unsigned long *end,
+		unsigned long addr1, unsigned long addr2)
+{
+	unsigned long *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (*iter == addr1)	/* deals with addr1 == addr2 */
+			found++;
+		if (*iter == addr2)
+			found++;
+		if (found == 2)
+			return 1;
+	}
+	return 0;
+}
+
+/**
+ * is_imv_cond_end
+ *
+ * Check if the two given addresses are located in the immediate value condition
+ * end table. Addresses should be in the same object.
+ * The module mutex should be held when calling this function for non-core
+ * addresses.
+ */
+int is_imv_cond_end(unsigned long addr1, unsigned long addr2)
+{
+	if (core_kernel_text(addr1)) {
+		return _is_imv_cond_end(__start___imv_cond_end,
+			__stop___imv_cond_end, addr1, addr2);
+	} else {
+		return is_imv_cond_end_module(addr1, addr2);
+	}
+	return 0;
+}
+
 void __init imv_init_complete(void)
 {
 	imv_early_boot_complete = 1;
Index: linux-2.6-sched-devel/kernel/module.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/module.c	2008-04-26 10:53:56.000000000 -0400
+++ linux-2.6-sched-devel/kernel/module.c	2008-04-26 10:54:44.000000000 -0400
@@ -1720,6 +1720,7 @@ static struct module *load_module(void _
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
 	unsigned int immediateindex;
+	unsigned int immediatecondendindex;
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
 	struct module *mod;
@@ -1819,6 +1820,8 @@ static struct module *load_module(void _
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
 	immediateindex = find_sec(hdr, sechdrs, secstrings, "__imv");
+	immediatecondendindex = find_sec(hdr, sechdrs, secstrings,
+		"__imv_cond_end");
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1981,6 +1984,11 @@ static struct module *load_module(void _
 	mod->immediate = (void *)sechdrs[immediateindex].sh_addr;
 	mod->num_immediate =
 		sechdrs[immediateindex].sh_size / sizeof(*mod->immediate);
+	mod->immediate_cond_end =
+		(void *)sechdrs[immediatecondendindex].sh_addr;
+	mod->num_immediate_cond_end =
+		sechdrs[immediatecondendindex].sh_size
+			/ sizeof(*mod->immediate_cond_end);
 #endif
 
 	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
@@ -2645,4 +2653,19 @@ void module_imv_update(void)
 	mutex_unlock(&module_mutex);
 }
 EXPORT_SYMBOL_GPL(module_imv_update);
+
+/**
+ * is_imv_cond_end_module
+ *
+ * Check if the two given addresses are located in the immediate value condition
+ * end table. Addresses should be in the same object.
+ * The module mutex should be held.
+ */
+int is_imv_cond_end_module(unsigned long addr1, unsigned long addr2)
+{
+	struct module *mod = __module_text_address(addr1);
+	return _is_imv_cond_end(mod->immediate_cond_end,
+		mod->immediate_cond_end + mod->num_immediate_cond_end,
+		addr1, addr2);
+}
 #endif
Index: linux-2.6-sched-devel/arch/x86/kernel/immediate.c
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/kernel/immediate.c	2008-04-26 10:53:41.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/kernel/immediate.c	2008-04-26 15:43:57.000000000 -0400
@@ -80,10 +80,7 @@
 #include <asm/cacheflush.h>
 
 #define BREAKPOINT_INSTRUCTION  0xcc
-#define JMP_REL8		0xeb
 #define JMP_REL32		0xe9
-#define INSN_NOP1		0x90
-#define INSN_NOP2		0x89, 0xf6
 #define BREAKPOINT_INS_LEN	1
 #define NR_NOPS			10
 
@@ -156,22 +153,14 @@ static int imv_notifier(struct notifier_
 		if (args->regs->ip == target_after_int3) {
 			/* deal with non-relocatable jmp instructions */
 			switch (*(uint8_t *)bypass_eip) {
-			case JMP_REL8: /* eb cb       jmp rel8 */
-				args->regs->ip +=
-					*(signed char *)(bypass_eip + 1) + 1;
-				return NOTIFY_STOP;
 			case JMP_REL32: /* e9 cw    jmp rel16 (valid on ia32) */
 					/* e9 cd    jmp rel32 */
+					/* Skip the 4 bytes (jump offset)
+					 * following the breakpoint. */
 				args->regs->ip +=
 					*(int *)(bypass_eip + 1) + 4;
+				/* The bypass won't be executed. */
 				return NOTIFY_STOP;
-			case INSN_NOP1:
-				/* deal with insertion of nop + jmp_rel32 */
-				if (*((uint8_t *)bypass_eip + 1) == JMP_REL32) {
-					args->regs->ip +=
-						*(int *)(bypass_eip + 2) + 5;
-					return NOTIFY_STOP;
-				}
 			}
 			preempt_disable();
 			args->regs->ip = bypass_eip;
@@ -197,38 +186,62 @@ static struct notifier_block imv_notify 
 static inline int detect_mov_test_jne(uint8_t *addr, uint8_t **opcode,
 		uint8_t **jmp_offset, int *offset_len)
 {
+	uint8_t *addr1, *addr2;
+
 	printk_dbg(KERN_DEBUG "Trying at %p %hx %hx %hx %hx %hx %hx\n",
 		addr, addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
-	/* b0 cb    movb cb,%al */
-	if (addr[0] != 0xb0)
+	/*
+	 * b8 imm32        mov  imm32,%eax or
+	 * c9 XX XX XX XX  jmp  rel32 (patched instruction)
+	 */
+	if (addr[0] != 0xb8 && addr[0] != JMP_REL32)
 		return -1;
-	/* 84 c0    test %al,%al */
-	if (addr[2] != 0x84 || addr[3] != 0xc0)
+	/* 85 c0    test %eax,%eax */
+	if (addr[5] != 0x85 || addr[6] != 0xc0)
 		return -1;
-	printk_dbg(KERN_DEBUG "Found test %%al,%%al at %p\n", addr + 2);
-	switch (addr[4]) {
+	printk_dbg(KERN_DEBUG "Found test %%eax,%%eax at %p\n", addr + 5);
+	switch (addr[7]) {
 	case 0x75: /* 75 cb       jne rel8 */
-		printk_dbg(KERN_DEBUG "Found jne rel8 at %p\n", addr + 4);
-		*opcode = addr + 4;
-		*jmp_offset = addr + 5;
+		printk_dbg(KERN_DEBUG "Found jne rel8 at %p\n", addr + 7);
+		*opcode = addr + 7;
+		*jmp_offset = addr + 8;
 		*offset_len = 1;
-		return 0;
+		/* addr1 is the address following the branch instruction */
+		addr1 = addr + 9;
+		/* addr2 is the branch target */
+		addr2 = addr1 + addr[8];
+		break;
 	case 0x0f:
-		switch (addr[5]) {
+		switch (addr[8]) {
 		case 0x85:	 /* 0F 85 cw    jne rel16 (valid on ia32) */
 				 /* 0F 85 cd    jne rel32 */
 			printk_dbg(KERN_DEBUG "Found jne rel16/32 at %p\n",
-				addr + 5);
-			*opcode = addr + 4;
-			*jmp_offset = addr + 6;
+				addr + 8);
+			*opcode = addr + 7;
+			*jmp_offset = addr + 9;
 			*offset_len = 4;
-			return 0;
+			/*
+			 * addr1 is the address following the branch
+			 * instruction
+			 */
+			addr1 = addr + 13;
+			/* addr2 is the branch target */
+			addr2 = addr1 + *(uint32_t *)(addr + 9);
+			break;
 		default:
 			return -1;
 		}
 		break;
 	default: return -1;
 	}
+	/*
+	 * Now check that the pattern was squeezed between the mov instruction
+	 * end the two epilogues (branch taken and not taken), which ensure
+	 * %eax and ZF liveliness is limited to our instructions.
+	 */
+	if (!is_imv_cond_end((unsigned long)addr1, (unsigned long)addr2))
+		return -1;
+	return 0;
 }
 
 /*
@@ -238,36 +251,60 @@ static inline int detect_mov_test_jne(ui
 static inline int detect_mov_test_je(uint8_t *addr, uint8_t **opcode,
 		uint8_t **jmp_offset, int *offset_len)
 {
-	/* b0 cb    movb cb,%al */
-	if (addr[0] != 0xb0)
+	uint8_t *addr1, *addr2;
+
+	/*
+	 * b8 imm32        mov  imm32,%eax or
+	 * c9 XX XX XX XX  jmp  rel32 (patched instruction)
+	 */
+	if (addr[0] != 0xb8 && addr[0] != JMP_REL32)
 		return -1;
-	/* 84 c0    test %al,%al */
-	if (addr[2] != 0x84 || addr[3] != 0xc0)
+	/* 85 c0    test %eax,%eax */
+	if (addr[5] != 0x85 || addr[6] != 0xc0)
 		return -1;
-	printk_dbg(KERN_DEBUG "Found test %%al,%%al at %p\n", addr + 2);
-	switch (addr[4]) {
+	printk_dbg(KERN_DEBUG "Found test %%eax,%%eax at %p\n", addr + 5);
+	switch (addr[7]) {
 	case 0x74: /* 74 cb       je rel8 */
-		printk_dbg(KERN_DEBUG "Found je rel8 at %p\n", addr + 4);
-		*opcode = addr + 4;
-		*jmp_offset = addr + 5;
+		printk_dbg(KERN_DEBUG "Found je rel8 at %p\n", addr + 7);
+		*opcode = addr + 7;
+		*jmp_offset = addr + 8;
 		*offset_len = 1;
-		return 0;
+		/* addr1 is the address following the branch instruction */
+		addr1 = addr + 9;
+		/* addr2 is the branch target */
+		addr2 = addr1 + addr[8];
+		break;
 	case 0x0f:
-		switch (addr[5]) {
+		switch (addr[8]) {
 		case 0x84:	 /* 0F 84 cw    je rel16 (valid on ia32) */
 				 /* 0F 84 cd    je rel32 */
 			printk_dbg(KERN_DEBUG "Found je rel16/32 at %p\n",
-				addr + 5);
-			*opcode = addr + 4;
-			*jmp_offset = addr + 6;
+				addr + 8);
+			*opcode = addr + 7;
+			*jmp_offset = addr + 9;
 			*offset_len = 4;
-			return 0;
+			/*
+			 * addr1 is the address following the branch
+			 * instruction
+			 */
+			addr1 = addr + 13;
+			/* addr2 is the branch target */
+			addr2 = addr1 + *(uint32_t *)(addr + 9);
+			break;
 		default:
 			return -1;
 		}
 		break;
 	default: return -1;
 	}
+	/*
+	 * Now check that the pattern was squeezed between the mov instruction
+	 * end the two epilogues (branch taken and not taken), which ensure
+	 * %eax and ZF liveliness is limited to our instructions.
+	 */
+	if (!is_imv_cond_end((unsigned long)addr1, (unsigned long)addr2))
+		return -1;
+	return 0;
 }
 
 static int static_early;
@@ -366,95 +403,42 @@ static int patch_jump_target(struct __im
 	uint8_t *opcode, *jmp_offset;
 	int offset_len;
 	int mov_test_j_found = 0;
+	unsigned long logicvar;
 
 	if (!detect_mov_test_jne((uint8_t *)imv->imv - 1,
 			&opcode, &jmp_offset, &offset_len)) {
-		imv->insn_size = 1;	/* positive logic */
+		logicvar = imv->var;	/* positive logic */
 		mov_test_j_found = 1;
 	} else if (!detect_mov_test_je((uint8_t *)imv->imv - 1,
 			&opcode, &jmp_offset, &offset_len)) {
-		imv->insn_size = 0;	/* negative logic */
+		logicvar = !imv->var;	/* negative logic */
 		mov_test_j_found = 1;
 	}
 
 	if (mov_test_j_found) {
-		int logicvar = imv->insn_size ? imv->var : !imv->var;
 		int newoff;
 
 		if (offset_len == 1) {
-			imv->jmp_off = *(signed char *)jmp_offset;
-			/* replace with JMP_REL8 opcode. */
-			replace_instruction_safe(opcode,
-				((unsigned char[]){ JMP_REL8,
-				(logicvar ? (signed char)imv->jmp_off : 0) }),
-				2);
+			if (logicvar)
+				newoff = *(signed char *)jmp_offset;
+			else
+				newoff = 0;
+			newoff += 4; /* jump over test, branch */
 		} else {
-			/* replace with nop and JMP_REL16/32 opcode.
-			 * It's ok to shrink an instruction, never ok to
-			 * grow it afterward. */
-			imv->jmp_off = *(int *)jmp_offset;
-			newoff = logicvar ? (int)imv->jmp_off : 0;
-			replace_instruction_safe(opcode,
-				((unsigned char[]){ INSN_NOP1, JMP_REL32,
-				((unsigned char *)&newoff)[0],
-				((unsigned char *)&newoff)[1],
-				((unsigned char *)&newoff)[2],
-				((unsigned char *)&newoff)[3] }),
-				6);
+			if (logicvar)
+				newoff = *(int *)jmp_offset;
+			else
+				newoff = 0;
+			newoff += 8; /*
+				      * jump over test (2 bytes)
+				      * and branch (6 bytes).
+				      */
 		}
-		/* now we can get rid of the movb */
-		replace_instruction_safe((uint8_t *)imv->imv - 1,
-			((unsigned char[]){ INSN_NOP2 }),
-			2);
-		/* now we can get rid of the testb */
-		replace_instruction_safe((uint8_t *)imv->imv + 1,
-			((unsigned char[]){ INSN_NOP2 }),
-			2);
-		/* remember opcode + 1 to enable the JMP_REL patching */
-		if (offset_len == 1)
-			imv->imv = (unsigned long)opcode + 1;
-		else
-			imv->imv = (unsigned long)opcode + 2;	/* skip nop */
-		return 0;
-
-	}
-
-	if (*((uint8_t *)imv->imv - 1) == JMP_REL8) {
-		int logicvar = imv->insn_size ? imv->var : !imv->var;
-
-		printk_dbg(KERN_DEBUG "Found JMP_REL8 at %p\n",
-			((uint8_t *)imv->imv - 1));
 		/* Speed up by skipping if not changed */
-		if (logicvar) {
-			if (*(int8_t *)imv->imv == (int8_t)imv->jmp_off)
-				return 0;
-		} else {
-			if (*(int8_t *)imv->imv == 0)
-				return 0;
-		}
-
-		replace_instruction_safe((uint8_t *)imv->imv - 1,
-			((unsigned char[]){ JMP_REL8,
-			(logicvar ? (signed char)imv->jmp_off : 0) }),
-			2);
-		return 0;
-	}
-
-	if (*((uint8_t *)imv->imv - 1) == JMP_REL32) {
-		int logicvar = imv->insn_size ? imv->var : !imv->var;
-		int newoff = logicvar ? (int)imv->jmp_off : 0;
-
-		printk_dbg(KERN_DEBUG "Found JMP_REL32 at %p, update with %x\n",
-			((uint8_t *)imv->imv - 1), newoff);
-		/* Speed up by skipping if not changed */
-		if (logicvar) {
-			if (*(int *)imv->imv == (int)imv->jmp_off)
-				return 0;
-		} else {
-			if (*(int *)imv->imv == 0)
-				return 0;
-		}
-
+		if (*(uint8_t *)(imv->imv - 1) == JMP_REL32 &&
+				*(int *)imv->imv == newoff)
+			return 0;
+		/* replace with a 5 bytes jump */
 		replace_instruction_safe((uint8_t *)imv->imv - 1,
 			((unsigned char[]){ JMP_REL32,
 			((unsigned char *)&newoff)[0],
@@ -464,7 +448,6 @@ static int patch_jump_target(struct __im
 			5);
 		return 0;
 	}
-
 	/* Nothing known found. */
 	return -1;
 }
@@ -498,7 +481,7 @@ __kprobes int arch_imv_update(struct __i
 				"Jump target fallback at %lX, nr fail %d\n",
 				imv->imv, ++nr_fail);
 #endif
-			imv->size = 1;
+			imv->size = 4;
 		} else {
 #ifdef DEBUG_IMMEDIATE
 			static int nr_success;
@@ -533,7 +516,8 @@ __kprobes int arch_imv_update(struct __i
 	 * If the variable and the instruction have the same value, there is
 	 * nothing to do.
 	 */
-	switch (imv->size) {
+	BUG_ON(imv->var_size > imv->size);
+	switch (imv->var_size) {
 	case 1:	if (*(uint8_t *)imv->imv == *(uint8_t *)imv->var)
 			return 0;
 		break;
@@ -552,7 +536,9 @@ __kprobes int arch_imv_update(struct __i
 	}
 
 	memcpy(buf, (uint8_t *)insn, opcode_size);
-	memcpy(&buf[opcode_size], (void *)imv->var, imv->size);
+	memcpy(&buf[opcode_size], (void *)imv->var, imv->var_size);
+	/* pad MSBs with 0 */
+	memset(&buf[opcode_size + imv->var_size], 0, imv->size - imv->var_size);
 	replace_instruction_safe((uint8_t *)insn, buf, imv->insn_size);
 
 	return 0;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
