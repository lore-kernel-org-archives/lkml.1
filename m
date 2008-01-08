Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYAHGdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYAHGdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 01:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYAHGdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 01:33:36 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34817 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbYAHGdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 01:33:35 -0500
Date: Tue, 8 Jan 2008 12:03:34 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: akpm@linux-foundation.org
Cc: lkml <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Jim Keniston <jkenisto@us.ibm.com>, mhiramat@redhat.com,
       davem@davemloft.net, hskinnemoen@atmel.com
Subject: [PATCH] Kprobes: Add kprobes smoke tests that run on boot
Message-ID: <20080108063334.GA29385@in.ibm.com>
Reply-To: ananth@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Here is a quick and naive smoke test for kprobes. This is intended to
just verify if some unrelated change broke the *probes subsystem. It is
self contained, architecture agnostic and isn't of any great use by itself.

This needs to be built in the kernel and runs a basic set of tests to
verify if kprobes, jprobes and kretprobes run fine on the kernel. In case
of an error, it'll print out a message with a "BUG" prefix.

This is a start; we intend to add more tests to this bucket over time.

Thanks to Jim Keniston and Masami Hiramatsu for comments and suggestions.

Tested on x86 (32/64) and powerpc.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 include/linux/kprobes.h |   10 ++
 kernel/Makefile         |    1 
 kernel/kprobes.c        |    2 
 kernel/test_kprobes.c   |  216 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug       |   12 ++
 5 files changed, 241 insertions(+)

Index: linux-2.6.24-rc6/kernel/Makefile
===================================================================
--- linux-2.6.24-rc6.orig/kernel/Makefile
+++ linux-2.6.24-rc6/kernel/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_DEBUG_SYNCHRO_TEST) += synchro-test.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
+obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
 ifeq ($(CONFIG_PREEMPT_RCU),y)
Index: linux-2.6.24-rc6/kernel/test_kprobes.c
===================================================================
--- /dev/null
+++ linux-2.6.24-rc6/kernel/test_kprobes.c
@@ -0,0 +1,216 @@
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
+static int return_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	unsigned long ret = regs_return_value(regs);
+
+	if (ret != (rand1 / div_factor)) {
+		handler_errors++;
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"incorrect value in kretprobe handler\n");
+	}
+
+	krph_val = (rand1 / div_factor);
+	return 0;
+}
+
+static struct kretprobe rp = {
+	.handler	= return_handler,
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
+	if (krph_val == 0) {
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
Index: linux-2.6.24-rc6/lib/Kconfig.debug
===================================================================
--- linux-2.6.24-rc6.orig/lib/Kconfig.debug
+++ linux-2.6.24-rc6/lib/Kconfig.debug
@@ -511,6 +511,18 @@ config RCU_TORTURE_TEST
 	  Say M if you want the RCU torture tests to build as a module.
 	  Say N if you are unsure.
 
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
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
 	depends on DEBUG_KERNEL
Index: linux-2.6.24-rc6/include/linux/kprobes.h
===================================================================
--- linux-2.6.24-rc6.orig/include/linux/kprobes.h
+++ linux-2.6.24-rc6/include/linux/kprobes.h
@@ -182,6 +182,15 @@ static inline void kretprobe_assert(stru
 	}
 }
 
+#ifdef CONFIG_KPROBES_SANITY_TEST
+extern int init_test_probes(void);
+#else
+static inline int init_test_probes(void)
+{
+	return 0;
+}
+#endif /* CONFIG_KPROBES_SANITY_TEST */
+
 extern spinlock_t kretprobe_lock;
 extern struct mutex kprobe_mutex;
 extern int arch_prepare_kprobe(struct kprobe *p);
@@ -227,6 +236,7 @@ void unregister_kretprobe(struct kretpro
 
 void kprobe_flush_task(struct task_struct *tk);
 void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
+
 #else /* CONFIG_KPROBES */
 
 #define __kprobes	/**/
Index: linux-2.6.24-rc6/kernel/kprobes.c
===================================================================
--- linux-2.6.24-rc6.orig/kernel/kprobes.c
+++ linux-2.6.24-rc6/kernel/kprobes.c
@@ -821,6 +821,8 @@ static int __init init_kprobes(void)
 	if (!err)
 		err = register_die_notifier(&kprobe_exceptions_nb);
 
+	if (!err)
+		init_test_probes();
 	return err;
 }
 
