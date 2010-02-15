Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0BOGP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:15:58 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56976 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab0BOGPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:15:55 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracehook: add some self tests
Date: Mon, 15 Feb 2010 01:15:53 -0500
Message-Id: <1266214553-29476-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment, we stress test the asm/syscall.h functions.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/Kconfig           |    2 +
 kernel/Makefile        |    1 +
 kernel/tracehooktest.c |  134 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug      |   15 +++++
 4 files changed, 152 insertions(+), 0 deletions(-)
 create mode 100644 kernel/tracehooktest.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 7f418bb..9c2add3 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -105,6 +105,8 @@ config HAVE_KRETPROBES
 #	TIF_NOTIFY_RESUME	calls tracehook_notify_resume()
 #	signal delivery		calls tracehook_signal_handler()
 #
+#	See CONFIG_TRACEHOOK_SELF_TEST for some test code to help.
+#
 config HAVE_ARCH_TRACEHOOK
 	bool
 
diff --git a/kernel/Makefile b/kernel/Makefile
index d7c13d2..5b5e4e4 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_FREEZER) += power/
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
+obj-$(CONFIG_TRACEHOOK_SELF_TEST) += tracehooktest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
diff --git a/kernel/tracehooktest.c b/kernel/tracehooktest.c
new file mode 100644
index 0000000..3a7d491
--- /dev/null
+++ b/kernel/tracehooktest.c
@@ -0,0 +1,134 @@
+/*
+ * Self tests for the misc pieces of the tracehook code.
+ *
+ * Copyright 2010 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ptrace.h>
+
+#include <asm/syscall.h>
+
+static int __init syscall_test(void)
+{
+	struct pt_regs _regs, *regs = &_regs;
+	long _args[8];
+	long *args = _args + 1;
+	long *sys_args[6], *sa;
+	unsigned int i, n, s;
+
+	/*
+	 * First find each system register in pt_regs.  We have to assume
+	 * syscall_set_arguments() works with very basic arguments.
+	 */
+	pr_info("TEST: asm/syscall.h: arg offsets: { ");
+
+	for (s = 0; s < 6; ++s)
+		args[s] = s;
+	memset(regs, 0xad, sizeof(*regs));
+	syscall_set_arguments(NULL, regs, 0, 6, args);
+
+	for (s = 0; s < 6; ++s) {
+		for (sa = (long *)regs; sa < (long *)(regs + 1); ++sa)
+			if (memcmp(&s, sa, sizeof(s)) == 0)
+				break;
+		if (sa == (long *)(regs + 1)) {
+			pr_cont(" FAIL (couldn't locate sys arg %u)\n", s);
+			return 1;
+		}
+		sys_args[s] = sa;
+		pr_cont("%li ", (unsigned long)sa - (unsigned long)regs);
+	}
+	pr_cont("}: PASS\n");
+
+	/* Make sure syscall_get_arguments() works with basic args */
+	pr_info("TEST: asm/syscall.h: basic syscall_get_arguments(): ");
+	memset(regs, 0xad, sizeof(*regs));
+	for (s = 0; s < 6; ++s)
+		*sys_args[s] = s;
+	syscall_get_arguments(NULL, regs, 0, 6, args);
+	for (s = 0; s < 6; ++s)
+		if (args[s] != s) {
+			pr_cont("FAIL with arg %i (%li)\n", s, args[s]);
+			return 1;
+		}
+	pr_cont("PASS\n");
+
+	/* Now brute force all values of i/n */
+	pr_info("TEST: asm/syscall.h: all i/n get/set combos: ");
+	for (i = 0; i < 6; ++i) {
+		for (n = 0; n < 7 - i; ++n) {
+
+			/* Seed for syscall_get_arguments() test */
+			for (s = 0; s < 6; ++s)
+				*sys_args[s] = -(s + 1);
+			memset(_args, 0, sizeof(_args));
+			syscall_get_arguments(NULL, regs, i, n, args);
+
+			/* Check canaries */
+			if (_args[0] != 0 || _args[7] != 0)
+				goto abort_i_n_get_tests;
+
+			/* Check all system argument values */
+			for (s = i; s < i + n; ++s)
+				if (*sys_args[s] != args[s - i])
+					goto abort_i_n_get_tests;
+
+			/* Check all unused slots */
+			for (s = i + n; s < 7; ++s)
+				if (args[s] != 0)
+					goto abort_i_n_get_tests;
+
+			/* Seed for syscall_set_arguments() test */
+			for (s = 0; s < 6; ++s)
+				args[s] = -(s + 1);
+			memset(regs, 0, sizeof(*regs));
+			syscall_set_arguments(NULL, regs, i, n, args);
+
+			/* Check the entire register set */
+			for (sa = (long *)regs; sa < (long *)(regs + 1); ++sa) {
+				if (*sa == 0)
+					continue;
+				/* Only some args should be set */
+				for (s = i; s < i + n; ++s)
+					if (sa == sys_args[s])
+						break;
+				if (s == i + n)
+					goto abort_i_n_set_tests;
+			}
+
+			/* Check the valid system argument values */
+			for (s = i; s < i + n; ++s)
+				if (*sys_args[s] != -(s + 1 - i))
+					goto abort_i_n_set_tests;
+		}
+	}
+	pr_cont("PASS\n");
+
+	return 0;
+
+ abort_i_n_get_tests:
+	pr_cont("FAIL (get @ i=%u n=%u)\n", i, n);
+	return 1;
+ abort_i_n_set_tests:
+	pr_cont("FAIL (set @ i=%u n=%u)\n", i, n);
+	return 1;
+}
+
+static int __init tracehooktest_init(void)
+{
+	return syscall_test();
+}
+module_init(tracehooktest_init);
+
+static void __exit tracehooktest_exit(void)
+{
+	/* stub to unload */
+}
+module_exit(tracehooktest_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mike Frysinger <vapier@gentoo.org>");
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 139fdbc..34b6793 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -788,6 +788,21 @@ config BACKTRACE_SELF_TEST
 
 	  Say N if you are unsure.
 
+config TRACEHOOK_SELF_TEST
+	tristate "Self test for the tracehook code"
+	depends on HAVE_ARCH_TRACEHOOK
+	default n
+	help
+	  This option provides a kernel module that can be used to test
+	  the kernel stack tracehook code. This option is not useful
+	  for distributions or general kernels, but only for kernel
+	  developers working on architecture code.
+
+	  Say N if you are unsure.
+
+	  Choose M here to compile this code as a module. The module will
+	  be called tracehooktest.
+
 config DEBUG_BLOCK_EXT_DEVT
         bool "Force extended block device numbers and spread them"
 	depends on DEBUG_KERNEL
-- 
1.7.0

