Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYBKKum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYBKKum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYBKKud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:50:33 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33023 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbYBKKuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:50:32 -0500
Date: Mon, 11 Feb 2008 16:21:02 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Christoph Hellwig <hch@infradead.org>,
       sam@ravnborg.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 6/8] Move kprobes smoke tests to tests/
Message-ID: <20080211105102.GH7944@in.ibm.com>
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

Move kprobe smoke tests to tests/

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 kernel/test_kprobes.c |  228 --------------------------------------------------
 kernel/Makefile       |    1 
 lib/Kconfig.debug     |   12 --
 tests/Kconfig         |   12 ++
 tests/Makefile        |    1 
 tests/test_kprobes.c  |  228 ++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 241 insertions(+), 241 deletions(-)

Index: linux-2.6.25-rc1/kernel/Makefile
===================================================================
--- linux-2.6.25-rc1.orig/kernel/Makefile
+++ linux-2.6.25-rc1/kernel/Makefile
@@ -47,7 +47,6 @@ obj-$(CONFIG_PID_NS) += pid_namespace.o
 obj-$(CONFIG_IKCONFIG) += configs.o
 obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
 obj-$(CONFIG_STOP_MACHINE) += stop_machine.o
-obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
Index: linux-2.6.25-rc1/kernel/test_kprobes.c
===================================================================
--- linux-2.6.25-rc1.orig/kernel/test_kprobes.c
+++ /dev/null
@@ -1,228 +0,0 @@
-/*
- * test_kprobes.c - simple sanity test for *probes
- *
- * Copyright IBM Corp. 2008
- *
- * This program is free software;  you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
- * the GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/kprobes.h>
-#include <linux/random.h>
-
-#define div_factor 3
-
-static u32 rand1, preh_val, posth_val, jph_val;
-static int errors, handler_errors, num_tests;
-
-static noinline u32 kprobe_target(u32 value)
-{
-	/*
-	 * gcc ignores noinline on some architectures unless we stuff
-	 * sufficient lard into the function. The get_kprobe() here is
-	 * just for that.
-	 *
-	 * NOTE: We aren't concerned about the correctness of get_kprobe()
-	 * here; hence, this call is neither under !preempt nor with the
-	 * kprobe_mutex held. This is fine(tm)
-	 */
-	if (get_kprobe((void *)0xdeadbeef))
-		printk(KERN_INFO "Kprobe smoke test: probe on 0xdeadbeef!\n");
-
-	return (value / div_factor);
-}
-
-static int kp_pre_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	preh_val = (rand1 / div_factor);
-	return 0;
-}
-
-static void kp_post_handler(struct kprobe *p, struct pt_regs *regs,
-		unsigned long flags)
-{
-	if (preh_val != (rand1 / div_factor)) {
-		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"incorrect value in post_handler\n");
-	}
-	posth_val = preh_val + div_factor;
-}
-
-static struct kprobe kp = {
-	.symbol_name = "kprobe_target",
-	.pre_handler = kp_pre_handler,
-	.post_handler = kp_post_handler
-};
-
-static int test_kprobe(void)
-{
-	int ret;
-
-	ret = register_kprobe(&kp);
-	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_kprobe returned %d\n", ret);
-		return ret;
-	}
-
-	ret = kprobe_target(rand1);
-	unregister_kprobe(&kp);
-
-	if (preh_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe pre_handler not called\n");
-		handler_errors++;
-	}
-
-	if (posth_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe post_handler not called\n");
-		handler_errors++;
-	}
-
-	return 0;
-}
-
-static u32 j_kprobe_target(u32 value)
-{
-	if (value != rand1) {
-		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"incorrect value in jprobe handler\n");
-	}
-
-	jph_val = rand1;
-	jprobe_return();
-	return 0;
-}
-
-static struct jprobe jp = {
-	.entry		= j_kprobe_target,
-	.kp.symbol_name = "kprobe_target"
-};
-
-static int test_jprobe(void)
-{
-	int ret;
-
-	ret = register_jprobe(&jp);
-	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_jprobe returned %d\n", ret);
-		return ret;
-	}
-
-	ret = kprobe_target(rand1);
-	unregister_jprobe(&jp);
-	if (jph_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"jprobe handler not called\n");
-		handler_errors++;
-	}
-
-	return 0;
-}
-
-#ifdef CONFIG_KRETPROBES
-static u32 krph_val;
-
-static int entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
-{
-	krph_val = (rand1 / div_factor);
-	return 0;
-}
-
-static int return_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
-{
-	unsigned long ret = regs_return_value(regs);
-
-	if (ret != (rand1 / div_factor)) {
-		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"incorrect value in kretprobe handler\n");
-	}
-	if (krph_val == 0) {
-		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"call to kretprobe entry handler failed\n");
-	}
-
-	krph_val = rand1;
-	return 0;
-}
-
-static struct kretprobe rp = {
-	.handler	= return_handler,
-	.entry_handler  = entry_handler,
-	.kp.symbol_name = "kprobe_target"
-};
-
-static int test_kretprobe(void)
-{
-	int ret;
-
-	ret = register_kretprobe(&rp);
-	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_kretprobe returned %d\n", ret);
-		return ret;
-	}
-
-	ret = kprobe_target(rand1);
-	unregister_kretprobe(&rp);
-	if (krph_val != rand1) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kretprobe handler not called\n");
-		handler_errors++;
-	}
-
-	return 0;
-}
-#endif /* CONFIG_KRETPROBES */
-
-int init_test_probes(void)
-{
-	int ret;
-
-	do {
-		rand1 = random32();
-	} while (rand1 <= div_factor);
-
-	printk(KERN_INFO "Kprobe smoke test started\n");
-	num_tests++;
-	ret = test_kprobe();
-	if (ret < 0)
-		errors++;
-
-	num_tests++;
-	ret = test_jprobe();
-	if (ret < 0)
-		errors++;
-
-#ifdef CONFIG_KRETPROBES
-	num_tests++;
-	ret = test_kretprobe();
-	if (ret < 0)
-		errors++;
-#endif /* CONFIG_KRETPROBES */
-
-	if (errors)
-		printk(KERN_ERR "BUG: Kprobe smoke test: %d out of "
-				"%d tests failed\n", errors, num_tests);
-	else if (handler_errors)
-		printk(KERN_ERR "BUG: Kprobe smoke test: %d error(s) "
-				"running handlers\n", handler_errors);
-	else
-		printk(KERN_INFO "Kprobe smoke test passed successfully\n");
-
-	return 0;
-}
Index: linux-2.6.25-rc1/lib/Kconfig.debug
===================================================================
--- linux-2.6.25-rc1.orig/lib/Kconfig.debug
+++ linux-2.6.25-rc1/lib/Kconfig.debug
@@ -466,18 +466,6 @@ config BOOT_PRINTK_DELAY
 	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
 	  what it believes to be lockup conditions.
 
-config KPROBES_SANITY_TEST
-	bool "Kprobes sanity tests"
-	depends on DEBUG_KERNEL
-	depends on KPROBES
-	default n
-	help
-	  This option provides for testing basic kprobes functionality on
-	  boot. A sample kprobe, jprobe and kretprobe are inserted and
-	  verified for functionality.
-
-	  Say N if you are unsure.
-
 config BACKTRACE_SELF_TEST
 	tristate "Self test for the backtrace code"
 	depends on DEBUG_KERNEL
Index: linux-2.6.25-rc1/tests/Kconfig
===================================================================
--- linux-2.6.25-rc1.orig/tests/Kconfig
+++ linux-2.6.25-rc1/tests/Kconfig
@@ -52,4 +52,16 @@ config LKDTM
 	Documentation on how to use the module can be found in
 	tests/lkdtm.c
 
+config KPROBES_SANITY_TEST
+	bool "Kprobes sanity tests"
+	depends on DEBUG_KERNEL
+	depends on KPROBES
+	default n
+	help
+	  This option provides for testing basic kprobes functionality on
+	  boot. A sample kprobe, jprobe and kretprobe are inserted and
+	  verified for functionality.
+
+	  Say N if you are unsure.
+
 endif # KERNEL_TESTS
Index: linux-2.6.25-rc1/tests/Makefile
===================================================================
--- linux-2.6.25-rc1.orig/tests/Makefile
+++ linux-2.6.25-rc1/tests/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_LKDTM) += lkdtm.o
+obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
Index: linux-2.6.25-rc1/tests/test_kprobes.c
===================================================================
--- /dev/null
+++ linux-2.6.25-rc1/tests/test_kprobes.c
@@ -0,0 +1,228 @@
+/*
+ * test_kprobes.c - simple sanity test for *probes
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/kprobes.h>
+#include <linux/random.h>
+
+#define div_factor 3
+
+static u32 rand1, preh_val, posth_val, jph_val;
+static int errors, handler_errors, num_tests;
+
+static noinline u32 kprobe_target(u32 value)
+{
+	/*
+	 * gcc ignores noinline on some architectures unless we stuff
+	 * sufficient lard into the function. The get_kprobe() here is
+	 * just for that.
+	 *
+	 * NOTE: We aren't concerned about the correctness of get_kprobe()
+	 * here; hence, this call is neither under !preempt nor with the
+	 * kprobe_mutex held. This is fine(tm)
+	 */
+	if (get_kprobe((void *)0xdeadbeef))
+		printk(KERN_INFO "Kprobe smoke test: probe on 0xdeadbeef!\n");
+
+	return (value / div_factor);
+}
+
+static int kp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	preh_val = (rand1 / div_factor);
+	return 0;
+}
+
+static void kp_post_handler(struct kprobe *p, struct pt_regs *regs,
+		unsigned long flags)
+{
+	if (preh_val != (rand1 / div_factor)) {
+		handler_errors++;
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"incorrect value in post_handler\n");
+	}
+	posth_val = preh_val + div_factor;
+}
+
+static struct kprobe kp = {
+	.symbol_name = "kprobe_target",
+	.pre_handler = kp_pre_handler,
+	.post_handler = kp_post_handler
+};
+
+static int test_kprobe(void)
+{
+	int ret;
+
+	ret = register_kprobe(&kp);
+	if (ret < 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"register_kprobe returned %d\n", ret);
+		return ret;
+	}
+
+	ret = kprobe_target(rand1);
+	unregister_kprobe(&kp);
+
+	if (preh_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kprobe pre_handler not called\n");
+		handler_errors++;
+	}
+
+	if (posth_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kprobe post_handler not called\n");
+		handler_errors++;
+	}
+
+	return 0;
+}
+
+static u32 j_kprobe_target(u32 value)
+{
+	if (value != rand1) {
+		handler_errors++;
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"incorrect value in jprobe handler\n");
+	}
+
+	jph_val = rand1;
+	jprobe_return();
+	return 0;
+}
+
+static struct jprobe jp = {
+	.entry		= j_kprobe_target,
+	.kp.symbol_name = "kprobe_target"
+};
+
+static int test_jprobe(void)
+{
+	int ret;
+
+	ret = register_jprobe(&jp);
+	if (ret < 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"register_jprobe returned %d\n", ret);
+		return ret;
+	}
+
+	ret = kprobe_target(rand1);
+	unregister_jprobe(&jp);
+	if (jph_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"jprobe handler not called\n");
+		handler_errors++;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_KRETPROBES
+static u32 krph_val;
+
+static int entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	krph_val = (rand1 / div_factor);
+	return 0;
+}
+
+static int return_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	unsigned long ret = regs_return_value(regs);
+
+	if (ret != (rand1 / div_factor)) {
+		handler_errors++;
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"incorrect value in kretprobe handler\n");
+	}
+	if (krph_val == 0) {
+		handler_errors++;
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"call to kretprobe entry handler failed\n");
+	}
+
+	krph_val = rand1;
+	return 0;
+}
+
+static struct kretprobe rp = {
+	.handler	= return_handler,
+	.entry_handler  = entry_handler,
+	.kp.symbol_name = "kprobe_target"
+};
+
+static int test_kretprobe(void)
+{
+	int ret;
+
+	ret = register_kretprobe(&rp);
+	if (ret < 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"register_kretprobe returned %d\n", ret);
+		return ret;
+	}
+
+	ret = kprobe_target(rand1);
+	unregister_kretprobe(&rp);
+	if (krph_val != rand1) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kretprobe handler not called\n");
+		handler_errors++;
+	}
+
+	return 0;
+}
+#endif /* CONFIG_KRETPROBES */
+
+int init_test_probes(void)
+{
+	int ret;
+
+	do {
+		rand1 = random32();
+	} while (rand1 <= div_factor);
+
+	printk(KERN_INFO "Kprobe smoke test started\n");
+	num_tests++;
+	ret = test_kprobe();
+	if (ret < 0)
+		errors++;
+
+	num_tests++;
+	ret = test_jprobe();
+	if (ret < 0)
+		errors++;
+
+#ifdef CONFIG_KRETPROBES
+	num_tests++;
+	ret = test_kretprobe();
+	if (ret < 0)
+		errors++;
+#endif /* CONFIG_KRETPROBES */
+
+	if (errors)
+		printk(KERN_ERR "BUG: Kprobe smoke test: %d out of "
+				"%d tests failed\n", errors, num_tests);
+	else if (handler_errors)
+		printk(KERN_ERR "BUG: Kprobe smoke test: %d error(s) "
+				"running handlers\n", handler_errors);
+	else
+		printk(KERN_INFO "Kprobe smoke test passed successfully\n");
+
+	return 0;
+}
