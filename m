Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYAWTGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYAWTGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYAWTGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:06:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42482 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbYAWTGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:06:10 -0500
Date: Wed, 23 Jan 2008 11:05:52 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [patch v2] x86: Add testcases for RODATA and NX
 protections/attributes
Message-ID: <20080123110552.1f19fa25@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86: Add testcases for RODATA and NX protections/attributes
From: Arjan van de Ven <arjan@linux.intel.com>

This patch adds testcases for the CONFIG_DEBUG_RODATA configuration option
as well as the NX CPU feature/mappings. Both testcases can move to tests/
once that patch gets merged into mainline.
(I'm half considering moving the rodata test into mm/init.c but I'll
wait with that until init.c is unified)

As part of this I had to fix a not-quite-right alignment in the vmlinux.lds.h
for the RODATA sections, which lead to 1 page less being marked read only.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/Kconfig.debug            |   16 +++
 arch/x86/kernel/Makefile_32       |    2 
 arch/x86/kernel/Makefile_64       |    3 
 arch/x86/kernel/test_nx.c         |  179 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/test_rodata.c     |   81 +++++++++++++++++
 arch/x86/mm/init_32.c             |    2 
 arch/x86/mm/init_64.c             |    2 
 include/asm-generic/vmlinux.lds.h |    1 
 include/asm-x86/cacheflush.h      |    7 +
 9 files changed, 292 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc8/arch/x86/Kconfig.debug
===================================================================
--- linux-2.6.24-rc8.orig/arch/x86/Kconfig.debug
+++ linux-2.6.24-rc8/arch/x86/Kconfig.debug
@@ -57,6 +57,22 @@ config DEBUG_RODATA
 	  portion of the kernel code won't be covered by a 2MB TLB anymore.
 	  If in doubt, say "N".
 
+config DEBUG_RODATA_TEST
+	bool "Testcase for the DEBUG_RODATA feature"
+	depends on DEBUG_RODATA
+	help
+	  This option enables a testcase for the DEBUG_RODATA
+	  feature as well as for the change_page_attr() infrastructure.
+	  If in doubt, say "N"
+
+config DEBUG_NX_TEST
+	tristate "Testcase for the NX non-executable stack feature"
+	depends on DEBUG_KERNEL && m
+	help
+	  This option enables a testcase for the CPU NX capability
+	  and the software setup of this feature.
+	  If in doubt, say "N"
+
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on DEBUG_KERNEL
Index: linux-2.6.24-rc8/arch/x86/kernel/Makefile_32
===================================================================
--- linux-2.6.24-rc8.orig/arch/x86/kernel/Makefile_32
+++ linux-2.6.24-rc8/arch/x86/kernel/Makefile_32
@@ -42,6 +42,8 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_prin
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
+obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
+obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
Index: linux-2.6.24-rc8/arch/x86/kernel/Makefile_64
===================================================================
--- linux-2.6.24-rc8.orig/arch/x86/kernel/Makefile_64
+++ linux-2.6.24-rc8/arch/x86/kernel/Makefile_64
@@ -39,6 +39,9 @@ obj-$(CONFIG_AUDIT)		+= audit_64.o
 obj-$(CONFIG_MODULES)		+= module_64.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 
+obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
+obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
+
 obj-y				+= topology.o
 obj-y				+= pcspeaker.o
 
Index: linux-2.6.24-rc8/arch/x86/kernel/test_nx.c
===================================================================
--- /dev/null
+++ linux-2.6.24-rc8/arch/x86/kernel/test_nx.c
@@ -0,0 +1,179 @@
+/*
+ * test_nx.c: functional test for NX functionality
+ *
+ * (C) Copyright 2008 Intel Corporation
+ * Author: Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#include <linux/module.h>
+#include <linux/sort.h>
+#include <asm/uaccess.h>
+
+
+/*
+ * This file checks 2 things:
+ * 1) Check if the stack is not-executable
+ * 2) Check if kmalloc memory is not executable
+ *
+ * To do this, the test code tries to execute memory in stack/kmalloc,
+ * want checks if the expected trap happens.
+ *
+ * Sadly, this implies having dynamic exception handling table entries.
+ * ... which can be done (but will make Rusty cry), but only in a module.
+ */
+
+
+
+
+/* exeption table sorting blatantly stolen from lib/extable.c */
+
+/*
+ * The exception table needs to be sorted so that the binary
+ * search that we use to find entries in it works properly.
+ * This is used both for the kernel exception table and for
+ * the exception tables of modules that get loaded.
+ */
+static int cmp_ex(const void *a, const void *b)
+{
+	const struct exception_table_entry *x = a, *y = b;
+
+	/* avoid overflow */
+	if (x->insn > y->insn)
+		return 1;
+	if (x->insn < y->insn)
+		return -1;
+	return 0;
+}
+
+/*
+ * We want to set up an exception handling point on our stack,
+ * which means a variable value. This function is rather dirty
+ * and walks the exception table of the module, looking for a magic
+ * marker and replaces it with a specific function.
+ */
+static noinline void fudze_exception_table(void *marker, void *new)
+{
+	struct module *mod = THIS_MODULE;
+	struct exception_table_entry *extable;
+	int i;
+
+	extable = (struct exception_table_entry *)mod->extable;
+	for (i = 0; i < mod->num_exentries; i++)
+		if (extable[i].insn == (unsigned long)marker)
+			extable[i].insn = (unsigned long)new;
+
+	sort(extable, mod->num_exentries, sizeof(struct exception_table_entry),
+		cmp_ex, NULL);
+}
+
+
+/*
+ * exception tables get their symbols resolved so we need
+ * to use real symbols to put in there for the fudzing
+ */
+void foo_label(void);
+void foo_label2(void);
+
+static int test_NX(void)
+{
+	unsigned long result;
+	int ret = 0;
+	/* 0xC3 is the opcode for "ret" */
+	char stackcode[] = {0xC3, 0x90, 0 };
+	char *heap;
+
+	printk(KERN_INFO "Testing NX protection\n");
+
+	/* Test 1: check if the stack is not executable */
+	/*
+	 * If this test fails, we managed to execute from the stack
+	 *
+	 * This is written in assembly to be able to catch the
+	 * exception that is supposed to happen in the correct
+	 * case
+	 */
+
+	fudze_exception_table(&foo_label, &stackcode);
+	result = 1;
+
+	asm volatile(
+		"foo_label:\n"
+		"0:	call *%[fake_code]\n"
+		"1:\n"
+		".section .fixup,\"ax\"\n"
+		"2:	mov %[zero], %[rslt]\n"
+		"	ret\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"       .align 16\n"
+		"	.quad 0b\n"
+		"	.quad 2b\n"
+		".previous\n"
+		: [rslt] "=r" (result)
+		: [fake_code] "r" (&stackcode), [zero] "r" (0UL)
+	);
+	/* change the exception table back */
+	fudze_exception_table(&stackcode, &foo_label);
+
+	if (result) {
+		printk(KERN_ERR "test_nx: stack was executable\n");
+		ret = -ENODEV;
+	}
+
+	/* Test 2: Check if the heap is executable */
+	/*
+	 * If this test fails, we managed to execute from the heap
+	 *
+	 * This is written in assembly to be able to catch the
+	 * exception that is supposed to happen in the correct
+	 * case
+	 */
+
+	heap = kmalloc(64, GFP_KERNEL);
+	if (!heap)
+		return -ENOMEM;
+
+	heap[0] = 0xC3; /* opcode for "ret" */
+
+	fudze_exception_table(&foo_label2, heap);
+	result = 1;
+	asm volatile(
+		"foo_label2:\n"
+		"0:	call *%[fake_code]\n"
+		"1:\n"
+		".section .fixup,\"ax\"\n"
+		"2:	mov %[zero], %[rslt]\n"
+		"	ret\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"       .align 16\n"
+		"	.quad 0b, 2b\n"
+		".previous\n"
+		: [rslt] "=r" (result)
+		: [fake_code] "r" (heap), [zero] "r" (0UL)
+	);
+	fudze_exception_table(heap, &foo_label2);
+
+	kfree(heap);
+
+	if (result) {
+		printk(KERN_ERR "test_nx: kmalloc data was executable\n");
+		ret = -ENODEV;
+	}
+
+	return ret;
+}
+
+static void test_exit(void)
+{
+}
+
+module_init(test_NX);
+module_exit(test_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Testcase for the DEBUG_RODATA infrastructure");
+MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
Index: linux-2.6.24-rc8/arch/x86/kernel/test_rodata.c
===================================================================
--- /dev/null
+++ linux-2.6.24-rc8/arch/x86/kernel/test_rodata.c
@@ -0,0 +1,81 @@
+/*
+ * test_rodata.c: functional test for mark_rodata_ro function
+ *
+ * (C) Copyright 2008 Intel Corporation
+ * Author: Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#include <linux/module.h>
+#include <asm/sections.h>
+extern int rodata_test_data;
+
+int rodata_test(void)
+{
+	unsigned long result;
+	unsigned long start, end;
+	/* test 1: read the value */
+	/* If this test fails, some previous testrun has clobbered the state */
+	if (!rodata_test_data) {
+		printk(KERN_ERR "rodata_test: test 1 fails (start data)\n");
+		return -ENODEV;
+	}
+
+	/* test 2: write to the variable; this should fault */
+	/*
+	 * If this test fails, we managed to overwrite the data
+	 *
+	 * This is written in assembly to be able to catch the
+	 * exception that is supposed to happen in the correct
+	 * case
+	 */
+
+	result = 1;
+	asm volatile(
+		"0:	mov %[zero],(%[rodata_test])\n"
+		"	mov %[zero], %[rslt]\n"
+		"1:\n"
+		".section .fixup,\"ax\"\n"
+		"2:	jmp 1b\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"       .align 16\n"
+		"	.quad 0b,2b\n"
+		".previous"
+		: [rslt] "=r" (result)
+		: [rodata_test] "r" (&rodata_test_data), [zero] "r" (0UL)
+	);
+
+
+	if (!result) {
+		printk(KERN_ERR "rodata_test: test data was not read only\n");
+		return -ENODEV;
+	}
+
+	/* test 3: check the value hasn't changed */
+	/* If this test fails, we managed to overwrite the data */
+	if (!rodata_test_data) {
+		printk(KERN_ERR "rodata_test: Test 3 failes (end data)\n");
+		return -ENODEV;
+	}
+	/* test 4: check if the rodata section is 4Kb aligned */
+	start = (unsigned long)__start_rodata;
+	end = (unsigned long)__end_rodata;
+	if (start & (PAGE_SIZE - 1)) {
+		printk(KERN_ERR "rodata_test: .rodata is not 4k aligned\n");
+		return -ENODEV;
+	}
+	if (end & (PAGE_SIZE - 1)) {
+		printk(KERN_ERR "rodata_test: .rodata end is not 4k aligned\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Testcase for the DEBUG_RODATA infrastructure");
+MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
Index: linux-2.6.24-rc8/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.24-rc8.orig/arch/x86/mm/init_32.c
+++ linux-2.6.24-rc8/arch/x86/mm/init_32.c
@@ -789,6 +789,7 @@ static int noinline do_test_wp_bit(void)
 }
 
 #ifdef CONFIG_DEBUG_RODATA
+const int rodata_test_data = 5;
 
 void mark_rodata_ro(void)
 {
@@ -820,6 +821,7 @@ void mark_rodata_ro(void)
 	 * of who is the culprit.
 	 */
 	global_flush_tlb();
+	rodata_test();
 }
 #endif
 
Index: linux-2.6.24-rc8/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.24-rc8.orig/arch/x86/mm/init_64.c
+++ linux-2.6.24-rc8/arch/x86/mm/init_64.c
@@ -589,6 +589,7 @@ void free_initmem(void)
 }
 
 #ifdef CONFIG_DEBUG_RODATA
+const int rodata_test_data = 5;
 
 void mark_rodata_ro(void)
 {
@@ -622,6 +623,7 @@ void mark_rodata_ro(void)
 	 * of who is the culprit.
 	 */
 	global_flush_tlb();
+	rodata_test();
 }
 #endif
 
Index: linux-2.6.24-rc8/include/asm-x86/cacheflush.h
===================================================================
--- linux-2.6.24-rc8.orig/include/asm-x86/cacheflush.h
+++ linux-2.6.24-rc8/include/asm-x86/cacheflush.h
@@ -34,8 +34,13 @@ void clflush_cache_range(void *addr, int
 void kernel_map_pages(struct page *page, int numpages, int enable);
 #endif
 
-#ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
+#ifdef CONFIG_DEBUG_RODATA_TEST
+void rodata_test(void);
+#else
+static inline void rodata_test(void)
+{
+}
 #endif
 
 #endif
Index: linux-2.6.24-rc8/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.24-rc8.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6.24-rc8/include/asm-generic/vmlinux.lds.h
@@ -137,6 +137,7 @@
 		VMLINUX_SYMBOL(__start___param) = .;			\
 		*(__param)						\
 		VMLINUX_SYMBOL(__stop___param) = .;			\
+		. = ALIGN((align));					\
 		VMLINUX_SYMBOL(__end_rodata) = .;			\
 	}								\
 									\


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
