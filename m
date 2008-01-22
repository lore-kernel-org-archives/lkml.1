Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbYAVWoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbYAVWoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYAVWor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:44:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52808 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbYAVWoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:44:46 -0500
Date: Tue, 22 Jan 2008 14:44:20 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [patch] x86: test case for the RODATA config option
Message-ID: <20080122144420.4ebcf95f@laptopd505.fenrus.org>
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


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: x86: test case for the RODATA config option

This patch adds a test module for the DEBUG_RODATA config
option to make sure change_page_attr() did indeed make
"const" data read only.

This testcase both tests the DEBUG_RODATA code as well as
the change_page_attr() code for correct operation.

When the tests/ patch gets merged, this module should move
to the tests/ directory.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/Kconfig.debug        |    8 +++++
 arch/x86/kernel/Makefile_32   |    1 
 arch/x86/kernel/Makefile_64   |    2 +
 arch/x86/kernel/test_rodata.c |   65 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/init_32.c         |    3 +
 arch/x86/mm/init_64.c         |    3 +
 6 files changed, 82 insertions(+)

Index: linux-2.6.24-rc8/arch/x86/Kconfig.debug
===================================================================
--- linux-2.6.24-rc8.orig/arch/x86/Kconfig.debug
+++ linux-2.6.24-rc8/arch/x86/Kconfig.debug
@@ -57,6 +57,14 @@ config DEBUG_RODATA
 	  portion of the kernel code won't be covered by a 2MB TLB anymore.
 	  If in doubt, say "N".
 
+config DEBUG_RODATA_TEST
+	tristate "Testcase for the DEBUG_RODATA feature"
+	depends on DEBUG_RODATA && m
+	help
+	  This option enables a testcase for the DEBUG_RODATA
+	  feature as well as for the change_page_attr() infrastructure.
+	  If in doubt, say "N"
+
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on DEBUG_KERNEL
Index: linux-2.6.24-rc8/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.24-rc8.orig/arch/x86/mm/init_32.c
+++ linux-2.6.24-rc8/arch/x86/mm/init_32.c
@@ -790,6 +790,9 @@ static int noinline do_test_wp_bit(void)
 
 #ifdef CONFIG_DEBUG_RODATA
 
+const int rodata_test_data;
+EXPORT_SYMBOL_GPL(rodata_test_data);
+
 void mark_rodata_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
Index: linux-2.6.24-rc8/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.24-rc8.orig/arch/x86/mm/init_64.c
+++ linux-2.6.24-rc8/arch/x86/mm/init_64.c
@@ -590,6 +590,9 @@ void free_initmem(void)
 
 #ifdef CONFIG_DEBUG_RODATA
 
+const int rodata_test_data = 5;
+EXPORT_SYMBOL_GPL(rodata_test_data);
+
 void mark_rodata_ro(void)
 {
 	unsigned long start = (unsigned long)_stext, end;
Index: linux-2.6.24-rc8/arch/x86/kernel/Makefile_64
===================================================================
--- linux-2.6.24-rc8.orig/arch/x86/kernel/Makefile_64
+++ linux-2.6.24-rc8/arch/x86/kernel/Makefile_64
@@ -39,6 +39,8 @@ obj-$(CONFIG_AUDIT)		+= audit_64.o
 obj-$(CONFIG_MODULES)		+= module_64.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 
+obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
+
 obj-y				+= topology.o
 obj-y				+= pcspeaker.o
 
Index: linux-2.6.24-rc8/arch/x86/kernel/test_rodata.c
===================================================================
--- /dev/null
+++ linux-2.6.24-rc8/arch/x86/kernel/test_rodata.c
@@ -0,0 +1,65 @@
+#include <linux/module.h>
+
+
+extern int rodata_test_data;
+
+int rodata_test_init(void)
+{
+	unsigned long result;
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
+		"       .align 8\n"
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
+
+	return 0;
+}
+
+void rodata_test_exit(void)
+{
+}
+
+module_init(rodata_test_init);
+module_exit(rodata_test_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Testcase for the DEBUG_RODATA infrastructure");
+MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
Index: linux-2.6.24-rc8/arch/x86/kernel/Makefile_32
===================================================================
--- linux-2.6.24-rc8.orig/arch/x86/kernel/Makefile_32
+++ linux-2.6.24-rc8/arch/x86/kernel/Makefile_32
@@ -42,6 +42,7 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_prin
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
+obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
