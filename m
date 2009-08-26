Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbZHZGku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbZHZGku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZHZGkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:40:47 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:43706
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754273AbZHZGkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:40:46 -0400
Subject: Subject: [PATCH 24/33] score: create kernel/ files
	sys_call_table.c sys_score.c
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:30:35 +0800
Message-Id: <1251268235.3153.15.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6272fcf4113acfbf4d3e00fbf6c6ee8738a1e0cf Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:08 +0800
Subject: [PATCH 24/33] score: create kernel/ files sys_call_table.c sys_score.c


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/kernel/sys_call_table.c |   12 +++
 arch/score/kernel/sys_score.c      |  131 ++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/kernel/sys_call_table.c
 create mode 100644 arch/score/kernel/sys_score.c

diff --git a/arch/score/kernel/sys_call_table.c b/arch/score/kernel/sys_call_table.c
new file mode 100644
index 0000000..287369b
--- /dev/null
+++ b/arch/score/kernel/sys_call_table.c
@@ -0,0 +1,12 @@
+#include <linux/syscalls.h>
+#include <linux/signal.h>
+#include <linux/unistd.h>
+
+#include <asm/syscalls.h>
+
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (call),
+
+void *sys_call_table[__NR_syscalls] = {
+#include <asm/unistd.h>
+};
diff --git a/arch/score/kernel/sys_score.c b/arch/score/kernel/sys_score.c
new file mode 100644
index 0000000..61aff8a
--- /dev/null
+++ b/arch/score/kernel/sys_score.c
@@ -0,0 +1,131 @@
+/*
+ * arch/score/kernel/syscall.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/mman.h>
+#include <linux/module.h>
+#include <linux/unistd.h>
+#include <linux/syscalls.h>
+#include <asm/syscalls.h>
+
+asmlinkage long 
+sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
+	  unsigned long flags, unsigned long fd, unsigned long pgoff)
+{
+	int error = -EBADF;
+	struct file *file = NULL;
+
+	if (pgoff & (~PAGE_MASK >> 12))
+		return -EINVAL;
+
+	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+	if (!(flags & MAP_ANONYMOUS)) {
+		file = fget(fd);
+		if (!file)
+			return error;
+	}
+
+	down_write(&current->mm->mmap_sem);
+	error = do_mmap_pgoff(file, addr, len, prot, flags,
+			pgoff >> (PAGE_SHIFT - 12));
+	up_write(&current->mm->mmap_sem);
+
+	if (file)
+		fput(file);
+
+	return error;
+}
+
+/*
+ * Clone a task - this clones the calling program thread.
+ * This is called indirectly via a small wrapper
+ */
+asmlinkage long
+score_clone(struct pt_regs *regs)
+{
+	unsigned long clone_flags;
+	unsigned long newsp;
+	int __user *parent_tidptr, *child_tidptr;
+
+	clone_flags = regs->regs[4];
+	newsp = regs->regs[5];
+	if (!newsp)
+		newsp = regs->regs[0];
+	parent_tidptr = (int __user *)regs->regs[6];
+	child_tidptr = (int __user *)regs->regs[8];
+
+	return do_fork(clone_flags, newsp, regs, 0,
+			parent_tidptr, child_tidptr);
+}
+
+/*
+ * sys_execve() executes a new program.
+ * This is called indirectly via a small wrapper
+ */
+asmlinkage long
+score_execve(struct pt_regs *regs)
+{
+	int error;
+	char *filename;
+
+	filename = getname((char __user*)regs->regs[4]);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		return error;
+
+	error = do_execve(filename, (char __user *__user*)regs->regs[5],
+			  (char __user *__user *) regs->regs[6], regs);
+
+	putname(filename);
+	return error;
+}
+
+/*
+ * Do a system call from kernel instead of calling sys_execve so we
+ * end up with proper pt_regs.
+ */
+int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+{
+	register unsigned long __r4 asm("r4") = (unsigned long) filename;
+	register unsigned long __r5 asm("r5") = (unsigned long) argv;
+	register unsigned long __r6 asm("r6") = (unsigned long) envp;
+	register unsigned long __r7 asm("r7");
+
+	__asm__ __volatile__ ("	\n"
+		"ldi	r27, %5		\n"
+		"syscall		\n"
+		"mv	%0, r4		\n"
+		"mv	%1, r7		\n"
+		: "=&r" (__r4), "=r" (__r7)
+		: "r" (__r4), "r" (__r5), "r" (__r6), "i" (__NR_execve)
+		: "r8", "r9", "r10", "r11", "r22", "r23", "r24", "r25",
+		  "r26", "r27", "memory");
+
+	if (__r7 == 0)
+		return __r4;
+
+	return -__r4;
+}
-- 
1.6.2



