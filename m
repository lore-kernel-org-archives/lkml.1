Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZIKRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZIKRqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 13:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbZIKRqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 13:46:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776AbZIKRqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 13:46:16 -0400
Subject: [PATCH] mn10300 syscall.h
From: Mark Salter <msalter@redhat.com>
To: dhowells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat, Inc
Date: Fri, 11 Sep 2009 13:46:18 -0400
Message-Id: <1252691178.2174.34.camel@deneb.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds missing asm/syscall.h to mn10300 arch.

Signed-off-by: Mark Salter <msalter@redhat.com>

diff --git a/arch/mn10300/include/asm/syscall.h b/arch/mn10300/include/asm/syscall.h
new file mode 100644
index 0000000..cc5a1f1
--- /dev/null
+++ b/arch/mn10300/include/asm/syscall.h
@@ -0,0 +1,131 @@
+/* syscall parameter access functions
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
+ * Written by Mark Salter <msalter@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_SYSCALL_H
+#define _ASM_SYSCALL_H
+
+#include <linux/err.h>
+#include <asm/ptrace.h>
+
+/*
+ * Get the system call number or -1
+ */
+static inline long syscall_get_nr(struct task_struct *task,
+				  struct pt_regs *regs)
+{
+	return regs->orig_d0;
+}
+
+/*
+ * Restore the clobbered d0 register
+ */
+static inline void syscall_rollback(struct task_struct *task,
+				    struct pt_regs *regs)
+{
+	regs->d0 = regs->orig_d0;
+}
+
+/*
+ * See if the syscall return value is an error, returning it if it is and 0 if
+ * not
+ */
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	return IS_ERR_VALUE(regs->d0) ? regs->d0 : 0;
+}
+
+/*
+ * Get the syscall return value
+ */
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->d0;
+}
+
+/*
+ * Set the syscall return value
+ */
+static inline void syscall_set_return_value(struct task_struct *task,
+					    struct pt_regs *regs,
+					    int error, long val)
+{
+	regs->d0 = (long) error ?: val;
+}
+
+/*
+ * Retrieve the system call arguments
+ */
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+	/*
+	 * Do this simply for now. If we need to start supporting
+	 * fetching arguments from arbitrary indices, this will need some
+	 * extra logic. Presently there are no in-tree users that depend
+	 * on this behaviour.
+	 */
+	BUG_ON(i);
+
+	/* Argument pattern is: a0, d1, a3, a2, d3, d2 */
+	switch (n) {
+	case 6:
+		args[5] = regs->d2;
+	case 5:
+		args[4] = regs->d3;
+	case 4:
+		args[3] = regs->a2;
+	case 3:
+		args[2] = regs->a3;
+	case 2:
+		args[1] = regs->d1;
+	case 1:
+		args[0] = regs->a0;
+		break;
+	default:
+		BUG();
+	}
+}
+
+/*
+ * Alter the system call arguments
+ */
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long *args)
+{
+	/* Same note as above applies */
+	BUG_ON(i);
+
+	switch (n) {
+	case 6:
+		regs->d2 = args[5];
+	case 5:
+		regs->d3 = args[4];
+	case 4:
+		regs->a2 = args[3];
+	case 3:
+		regs->a3 = args[2];
+	case 2:
+		regs->d1 = args[1];
+	case 1:
+		regs->a0 = args[0];
+		break;
+	default:
+		BUG();
+	}
+}
+
+#endif /* _ASM_SYSCALL_H */


