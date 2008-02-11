Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbYBKKwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbYBKKwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYBKKwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:52:01 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43826 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYBKKv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:51:59 -0500
Date: Mon, 11 Feb 2008 16:22:29 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Christoph Hellwig <hch@infradead.org>,
       sam@ravnborg.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 8/8] Move RODATA and NX tests to tests/
Message-ID: <20080211105229.GJ7944@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20080211104452.GB7944@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211104452.GB7944@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Move RODATA and NX testcases to tests/

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/x86/kernel/test_nx.c     |  173 ------------------------------------------
 arch/x86/kernel/test_rodata.c |   86 --------------------
 arch/x86/Kconfig.debug        |   16 ---
 arch/x86/kernel/Makefile      |    2 
 tests/Kconfig                 |   16 +++
 tests/Makefile                |    2 
 tests/test_nx.c               |  173 ++++++++++++++++++++++++++++++++++++++++++
 tests/test_rodata.c           |   86 ++++++++++++++++++++
 8 files changed, 277 insertions(+), 277 deletions(-)

Index: linux-2.6.25-rc1/arch/x86/Kconfig.debug
===================================================================
--- linux-2.6.25-rc1.orig/arch/x86/Kconfig.debug
+++ linux-2.6.25-rc1/arch/x86/Kconfig.debug
@@ -64,22 +64,6 @@ config DEBUG_RODATA
 	  data. This is recommended so that we can catch kernel bugs sooner.
 	  If in doubt, say "Y".
 
-config DEBUG_RODATA_TEST
-	bool "Testcase for the DEBUG_RODATA feature"
-	depends on DEBUG_RODATA
-	help
-	  This option enables a testcase for the DEBUG_RODATA
-	  feature as well as for the change_page_attr() infrastructure.
-	  If in doubt, say "N"
-
-config DEBUG_NX_TEST
-	tristate "Testcase for the NX non-executable stack feature"
-	depends on DEBUG_KERNEL && m
-	help
-	  This option enables a testcase for the CPU NX capability
-	  and the software setup of this feature.
-	  If in doubt, say "N"
-
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on DEBUG_KERNEL
Index: linux-2.6.25-rc1/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.25-rc1.orig/arch/x86/kernel/Makefile
+++ linux-2.6.25-rc1/arch/x86/kernel/Makefile
@@ -65,8 +65,6 @@ obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
-obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
-obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
Index: linux-2.6.25-rc1/arch/x86/kernel/test_nx.c
===================================================================
--- linux-2.6.25-rc1.orig/arch/x86/kernel/test_nx.c
+++ /dev/null
@@ -1,173 +0,0 @@
-/*
- * test_nx.c: functional test for NX functionality
- *
- * (C) Copyright 2008 Intel Corporation
- * Author: Arjan van de Ven <arjan@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; version 2
- * of the License.
- */
-#include <linux/module.h>
-#include <linux/sort.h>
-#include <asm/uaccess.h>
-#include <asm/asm.h>
-
-extern int rodata_test_data;
-
-/*
- * This file checks 4 things:
- * 1) Check if the stack is not executable
- * 2) Check if kmalloc memory is not executable
- * 3) Check if the .rodata section is not executable
- * 4) Check if the .data section of a module is not executable
- *
- * To do this, the test code tries to execute memory in stack/kmalloc/etc,
- * and then checks if the expected trap happens.
- *
- * Sadly, this implies having a dynamic exception handling table entry.
- * ... which can be done (and will make Rusty cry)... but it can only
- * be done in a stand-alone module with only 1 entry total.
- * (otherwise we'd have to sort and that's just too messy)
- */
-
-
-
-/*
- * We want to set up an exception handling point on our stack,
- * which means a variable value. This function is rather dirty
- * and walks the exception table of the module, looking for a magic
- * marker and replaces it with a specific function.
- */
-static void fudze_exception_table(void *marker, void *new)
-{
-	struct module *mod = THIS_MODULE;
-	struct exception_table_entry *extable;
-
-	/*
-	 * Note: This module has only 1 exception table entry,
-	 * so searching and sorting is not needed. If that changes,
-	 * this would be the place to search and re-sort the exception
-	 * table.
-	 */
-	if (mod->num_exentries > 1) {
-		printk(KERN_ERR "test_nx: too many exception table entries!\n");
-		printk(KERN_ERR "test_nx: test results are not reliable.\n");
-		return;
-	}
-	extable = (struct exception_table_entry *)mod->extable;
-	extable[0].insn = (unsigned long)new;
-}
-
-
-/*
- * exception tables get their symbols translated so we need
- * to use a fake function to put in there, which we can then
- * replace at runtime.
- */
-void foo_label(void);
-
-/*
- * returns 0 for not-executable, negative for executable
- *
- * Note: we cannot allow this function to be inlined, because
- * that would give us more than 1 exception table entry.
- * This in turn would break the assumptions above.
- */
-static noinline int test_address(void *address)
-{
-	unsigned long result;
-
-	/* Set up an exception table entry for our address */
-	fudze_exception_table(&foo_label, address);
-	result = 1;
-	asm volatile(
-		"foo_label:\n"
-		"0:	call *%[fake_code]\n"
-		"1:\n"
-		".section .fixup,\"ax\"\n"
-		"2:	mov %[zero], %[rslt]\n"
-		"	ret\n"
-		".previous\n"
-		_ASM_EXTABLE(0b,2b)
-		: [rslt] "=r" (result)
-		: [fake_code] "r" (address), [zero] "r" (0UL), "0" (result)
-	);
-	/* change the exception table back for the next round */
-	fudze_exception_table(address, &foo_label);
-
-	if (result)
-		return -ENODEV;
-	return 0;
-}
-
-static unsigned char test_data = 0xC3; /* 0xC3 is the opcode for "ret" */
-
-static int test_NX(void)
-{
-	int ret = 0;
-	/* 0xC3 is the opcode for "ret" */
-	char stackcode[] = {0xC3, 0x90, 0 };
-	char *heap;
-
-	test_data = 0xC3;
-
-	printk(KERN_INFO "Testing NX protection\n");
-
-	/* Test 1: check if the stack is not executable */
-	if (test_address(&stackcode)) {
-		printk(KERN_ERR "test_nx: stack was executable\n");
-		ret = -ENODEV;
-	}
-
-
-	/* Test 2: Check if the heap is executable */
-	heap = kmalloc(64, GFP_KERNEL);
-	if (!heap)
-		return -ENOMEM;
-	heap[0] = 0xC3; /* opcode for "ret" */
-
-	if (test_address(heap)) {
-		printk(KERN_ERR "test_nx: heap was executable\n");
-		ret = -ENODEV;
-	}
-	kfree(heap);
-
-	/*
-	 * The following 2 tests currently fail, this needs to get fixed
-	 * Until then, don't run them to avoid too many people getting scared
-	 * by the error message
-	 */
-
-#ifdef CONFIG_DEBUG_RODATA
-	/* Test 3: Check if the .rodata section is executable */
-	if (rodata_test_data != 0xC3) {
-		printk(KERN_ERR "test_nx: .rodata marker has invalid value\n");
-		ret = -ENODEV;
-	} else if (test_address(&rodata_test_data)) {
-		printk(KERN_ERR "test_nx: .rodata section is executable\n");
-		ret = -ENODEV;
-	}
-#endif
-
-#if 0
-	/* Test 4: Check if the .data section of a module is executable */
-	if (test_address(&test_data)) {
-		printk(KERN_ERR "test_nx: .data section is executable\n");
-		ret = -ENODEV;
-	}
-
-#endif
-	return 0;
-}
-
-static void test_exit(void)
-{
-}
-
-module_init(test_NX);
-module_exit(test_exit);
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Testcase for the NX infrastructure");
-MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
Index: linux-2.6.25-rc1/arch/x86/kernel/test_rodata.c
===================================================================
--- linux-2.6.25-rc1.orig/arch/x86/kernel/test_rodata.c
+++ /dev/null
@@ -1,86 +0,0 @@
-/*
- * test_rodata.c: functional test for mark_rodata_ro function
- *
- * (C) Copyright 2008 Intel Corporation
- * Author: Arjan van de Ven <arjan@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; version 2
- * of the License.
- */
-#include <linux/module.h>
-#include <asm/sections.h>
-extern int rodata_test_data;
-
-int rodata_test(void)
-{
-	unsigned long result;
-	unsigned long start, end;
-
-	/* test 1: read the value */
-	/* If this test fails, some previous testrun has clobbered the state */
-	if (!rodata_test_data) {
-		printk(KERN_ERR "rodata_test: test 1 fails (start data)\n");
-		return -ENODEV;
-	}
-
-	/* test 2: write to the variable; this should fault */
-	/*
-	 * If this test fails, we managed to overwrite the data
-	 *
-	 * This is written in assembly to be able to catch the
-	 * exception that is supposed to happen in the correct
-	 * case
-	 */
-
-	result = 1;
-	asm volatile(
-		"0:	mov %[zero],(%[rodata_test])\n"
-		"	mov %[zero], %[rslt]\n"
-		"1:\n"
-		".section .fixup,\"ax\"\n"
-		"2:	jmp 1b\n"
-		".previous\n"
-		".section __ex_table,\"a\"\n"
-		"       .align 16\n"
-#ifdef CONFIG_X86_32
-		"	.long 0b,2b\n"
-#else
-		"	.quad 0b,2b\n"
-#endif
-		".previous"
-		: [rslt] "=r" (result)
-		: [rodata_test] "r" (&rodata_test_data), [zero] "r" (0UL)
-	);
-
-
-	if (!result) {
-		printk(KERN_ERR "rodata_test: test data was not read only\n");
-		return -ENODEV;
-	}
-
-	/* test 3: check the value hasn't changed */
-	/* If this test fails, we managed to overwrite the data */
-	if (!rodata_test_data) {
-		printk(KERN_ERR "rodata_test: Test 3 failes (end data)\n");
-		return -ENODEV;
-	}
-	/* test 4: check if the rodata section is 4Kb aligned */
-	start = (unsigned long)__start_rodata;
-	end = (unsigned long)__end_rodata;
-	if (start & (PAGE_SIZE - 1)) {
-		printk(KERN_ERR "rodata_test: .rodata is not 4k aligned\n");
-		return -ENODEV;
-	}
-	if (end & (PAGE_SIZE - 1)) {
-		printk(KERN_ERR "rodata_test: .rodata end is not 4k aligned\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Testcase for the DEBUG_RODATA infrastructure");
-MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
Index: linux-2.6.25-rc1/tests/Kconfig
===================================================================
--- linux-2.6.25-rc1.orig/tests/Kconfig
+++ linux-2.6.25-rc1/tests/Kconfig
@@ -76,4 +76,20 @@ config BACKTRACE_SELF_TEST
 
 	  Say N if you are unsure.
 
+config DEBUG_RODATA_TEST
+	bool "Testcase for the DEBUG_RODATA feature"
+	depends on X86 && DEBUG_RODATA
+	help
+	  This option enables a testcase for the DEBUG_RODATA
+	  feature as well as for the change_page_attr() infrastructure.
+	  If in doubt, say "N"
+
+config DEBUG_NX_TEST
+	tristate "Testcase for the NX non-executable stack feature"
+	depends on X86 && DEBUG_KERNEL && m
+	help
+	  This option enables a testcase for the CPU NX capability
+	  and the software setup of this feature.
+	  If in doubt, say "N"
+
 endif # KERNEL_TESTS
Index: linux-2.6.25-rc1/tests/Makefile
===================================================================
--- linux-2.6.25-rc1.orig/tests/Makefile
+++ linux-2.6.25-rc1/tests/Makefile
@@ -8,3 +8,5 @@ obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex
 obj-$(CONFIG_LKDTM) += lkdtm.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
+obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
+obj-$(CONFIG_DEBUG_NX_TEST) += test_nx.o
Index: linux-2.6.25-rc1/tests/test_nx.c
===================================================================
--- /dev/null
+++ linux-2.6.25-rc1/tests/test_nx.c
@@ -0,0 +1,173 @@
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
+#include <asm/asm.h>
+
+extern int rodata_test_data;
+
+/*
+ * This file checks 4 things:
+ * 1) Check if the stack is not executable
+ * 2) Check if kmalloc memory is not executable
+ * 3) Check if the .rodata section is not executable
+ * 4) Check if the .data section of a module is not executable
+ *
+ * To do this, the test code tries to execute memory in stack/kmalloc/etc,
+ * and then checks if the expected trap happens.
+ *
+ * Sadly, this implies having a dynamic exception handling table entry.
+ * ... which can be done (and will make Rusty cry)... but it can only
+ * be done in a stand-alone module with only 1 entry total.
+ * (otherwise we'd have to sort and that's just too messy)
+ */
+
+
+
+/*
+ * We want to set up an exception handling point on our stack,
+ * which means a variable value. This function is rather dirty
+ * and walks the exception table of the module, looking for a magic
+ * marker and replaces it with a specific function.
+ */
+static void fudze_exception_table(void *marker, void *new)
+{
+	struct module *mod = THIS_MODULE;
+	struct exception_table_entry *extable;
+
+	/*
+	 * Note: This module has only 1 exception table entry,
+	 * so searching and sorting is not needed. If that changes,
+	 * this would be the place to search and re-sort the exception
+	 * table.
+	 */
+	if (mod->num_exentries > 1) {
+		printk(KERN_ERR "test_nx: too many exception table entries!\n");
+		printk(KERN_ERR "test_nx: test results are not reliable.\n");
+		return;
+	}
+	extable = (struct exception_table_entry *)mod->extable;
+	extable[0].insn = (unsigned long)new;
+}
+
+
+/*
+ * exception tables get their symbols translated so we need
+ * to use a fake function to put in there, which we can then
+ * replace at runtime.
+ */
+void foo_label(void);
+
+/*
+ * returns 0 for not-executable, negative for executable
+ *
+ * Note: we cannot allow this function to be inlined, because
+ * that would give us more than 1 exception table entry.
+ * This in turn would break the assumptions above.
+ */
+static noinline int test_address(void *address)
+{
+	unsigned long result;
+
+	/* Set up an exception table entry for our address */
+	fudze_exception_table(&foo_label, address);
+	result = 1;
+	asm volatile(
+		"foo_label:\n"
+		"0:	call *%[fake_code]\n"
+		"1:\n"
+		".section .fixup,\"ax\"\n"
+		"2:	mov %[zero], %[rslt]\n"
+		"	ret\n"
+		".previous\n"
+		_ASM_EXTABLE(0b,2b)
+		: [rslt] "=r" (result)
+		: [fake_code] "r" (address), [zero] "r" (0UL), "0" (result)
+	);
+	/* change the exception table back for the next round */
+	fudze_exception_table(address, &foo_label);
+
+	if (result)
+		return -ENODEV;
+	return 0;
+}
+
+static unsigned char test_data = 0xC3; /* 0xC3 is the opcode for "ret" */
+
+static int test_NX(void)
+{
+	int ret = 0;
+	/* 0xC3 is the opcode for "ret" */
+	char stackcode[] = {0xC3, 0x90, 0 };
+	char *heap;
+
+	test_data = 0xC3;
+
+	printk(KERN_INFO "Testing NX protection\n");
+
+	/* Test 1: check if the stack is not executable */
+	if (test_address(&stackcode)) {
+		printk(KERN_ERR "test_nx: stack was executable\n");
+		ret = -ENODEV;
+	}
+
+
+	/* Test 2: Check if the heap is executable */
+	heap = kmalloc(64, GFP_KERNEL);
+	if (!heap)
+		return -ENOMEM;
+	heap[0] = 0xC3; /* opcode for "ret" */
+
+	if (test_address(heap)) {
+		printk(KERN_ERR "test_nx: heap was executable\n");
+		ret = -ENODEV;
+	}
+	kfree(heap);
+
+	/*
+	 * The following 2 tests currently fail, this needs to get fixed
+	 * Until then, don't run them to avoid too many people getting scared
+	 * by the error message
+	 */
+
+#ifdef CONFIG_DEBUG_RODATA
+	/* Test 3: Check if the .rodata section is executable */
+	if (rodata_test_data != 0xC3) {
+		printk(KERN_ERR "test_nx: .rodata marker has invalid value\n");
+		ret = -ENODEV;
+	} else if (test_address(&rodata_test_data)) {
+		printk(KERN_ERR "test_nx: .rodata section is executable\n");
+		ret = -ENODEV;
+	}
+#endif
+
+#if 0
+	/* Test 4: Check if the .data section of a module is executable */
+	if (test_address(&test_data)) {
+		printk(KERN_ERR "test_nx: .data section is executable\n");
+		ret = -ENODEV;
+	}
+
+#endif
+	return 0;
+}
+
+static void test_exit(void)
+{
+}
+
+module_init(test_NX);
+module_exit(test_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Testcase for the NX infrastructure");
+MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
Index: linux-2.6.25-rc1/tests/test_rodata.c
===================================================================
--- /dev/null
+++ linux-2.6.25-rc1/tests/test_rodata.c
@@ -0,0 +1,86 @@
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
+
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
+#ifdef CONFIG_X86_32
+		"	.long 0b,2b\n"
+#else
+		"	.quad 0b,2b\n"
+#endif
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
