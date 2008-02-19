Return-Path: <linux-kernel-owner+w=401wt.eu-S1761148AbYBSUj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761148AbYBSUj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbYBSUjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:39:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35227 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbYBSUjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:39:16 -0500
Date: Tue, 19 Feb 2008 12:37:56 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080219123756.6261c13c@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Soren Sandmann <sandmann@redhat.com>
Subject: [PATCH] x86: add the debugfs interface for the sysprof tool

The sysprof tool is a very easy to use GUI tool to find out where
userspace is spending CPU time. See
http://www.daimi.au.dk/~sandmann/sysprof/
for more information and screenshots on this tool.

Sysprof needs a 200 line kernel module to do it's work, this
module puts some simple profiling data into debugfs.

Signed-off-by: Soren Sandmann <sandmann@redhat.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/Kconfig.debug    |   10 ++
 arch/x86/kernel/Makefile  |    2 +
 arch/x86/kernel/sysprof.c |  200 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/sysprof.h |   34 ++++++++
 4 files changed, 246 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/sysprof.c
 create mode 100644 arch/x86/kernel/sysprof.h

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 12c98ea..8eb06c0 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -206,6 +206,16 @@ config MMIOTRACE_TEST
 
 	  Say N, unless you absolutely know what you are doing.
 
+config SYSPROF
+	tristate "Enable sysprof userland performance sampler"
+	depends on PROFILING
+	help
+	  This option enables the sysprof debugfs file that is used by the
+	  sysprof tool. sysprof is a tool to show where in userspace CPU
+	  time is spent.
+
+	  When in doubt, say N
+
 #
 # IO delay types:
 #
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4a4260c..1e8fb66 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -80,6 +80,8 @@ obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 
+obj-$(CONFIG_SYSPROF)		+= sysprof.o
+
 ifdef CONFIG_INPUT_PCSPKR
 obj-y				+= pcspeaker.o
 endif
diff --git a/arch/x86/kernel/sysprof.c b/arch/x86/kernel/sysprof.c
new file mode 100644
index 0000000..6220b9f
--- /dev/null
+++ b/arch/x86/kernel/sysprof.c
@@ -0,0 +1,200 @@
+/* -*- c-basic-offset: 8 -*- */
+
+/* Sysprof -- Sampling, systemwide CPU profiler
+ * Copyright 2004, Red Hat, Inc.
+ * Copyright 2004, 2005, Soeren Sandmann
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/poll.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+#include <linux/profile.h>
+#include <linux/debugfs.h>
+#include <asm/uaccess.h>
+#include <asm/atomic.h>
+
+#include "sysprof.h"
+
+#define SAMPLES_PER_SECOND (200)
+#define INTERVAL ((HZ <= SAMPLES_PER_SECOND)? 1 : (HZ / SAMPLES_PER_SECOND))
+#define N_TRACES 256
+
+static struct sysprof_stacktrace stack_traces[N_TRACES];
+static struct sysprof_stacktrace *head = &stack_traces[0];
+static struct sysprof_stacktrace *tail = &stack_traces[0];
+static DECLARE_WAIT_QUEUE_HEAD(wait_for_trace);
+static DECLARE_WAIT_QUEUE_HEAD(wait_for_exit);
+
+struct userspace_reader {
+	struct task_struct *task;
+	unsigned long cache_address;
+	unsigned long *cache;
+};
+
+struct stack_frame;
+
+struct stack_frame {
+	struct stack_frame __user *next;
+	unsigned long return_address;
+};
+
+static int read_frame(struct stack_frame __user *frame_pointer,
+					struct stack_frame *frame)
+{
+	if (__copy_from_user_inatomic(frame, frame_pointer,
+					sizeof(struct stack_frame)))
+		return 1;
+	return 0;
+}
+
+static DEFINE_PER_CPU(int, n_samples);
+
+static int timer_notify(struct pt_regs *regs)
+{
+	struct sysprof_stacktrace *trace = head;
+	int i;
+	int is_user;
+	static atomic_t in_timer_notify = ATOMIC_INIT(1);
+	int n;
+
+	n = ++get_cpu_var(n_samples);
+	put_cpu_var(n_samples);
+
+	if (n % INTERVAL != 0)
+		return 0;
+
+	/* 0: locked, 1: unlocked */
+
+	if (!atomic_dec_and_test(&in_timer_notify))
+		goto out;
+
+	is_user = user_mode(regs);
+
+	if (!current || current->pid == 0)
+		goto out;
+
+	if (is_user && current->state != TASK_RUNNING)
+		goto out;
+
+	if (!is_user) {
+		/* kernel */
+		trace->pid = current->pid;
+		trace->truncated = 0;
+		trace->n_addresses = 1;
+
+		/* 0x1 is taken by sysprof to mean "in kernel" */
+		trace->addresses[0] = 0x1;
+	} else {
+		struct stack_frame __user *frame_pointer;
+		struct stack_frame frame;
+		memset(trace, 0, sizeof(struct sysprof_stacktrace));
+
+		trace->pid = current->pid;
+		trace->truncated = 0;
+
+		i = 0;
+
+		trace->addresses[i++] = regs->ip;
+
+		frame_pointer = (struct stack_frame __user *)regs->bp;
+
+		while (read_frame(frame_pointer, &frame) == 0 &&
+		       i < SYSPROF_MAX_ADDRESSES &&
+		       (unsigned long)frame_pointer >= regs->sp) {
+			trace->addresses[i++] = frame.return_address;
+			frame_pointer = frame.next;
+		}
+
+		trace->n_addresses = i;
+
+		if (i == SYSPROF_MAX_ADDRESSES)
+			trace->truncated = 1;
+		else
+			trace->truncated = 0;
+	}
+
+	if (head++ == &stack_traces[N_TRACES - 1])
+		head = &stack_traces[0];
+
+	wake_up(&wait_for_trace);
+
+out:
+	atomic_inc(&in_timer_notify);
+	return 0;
+}
+
+static ssize_t procfile_read(struct file *filp, char __user *buffer,
+			size_t count, loff_t *ppos)
+{
+	ssize_t bcount;
+	if (head == tail)
+		return -EWOULDBLOCK;
+
+	BUG_ON(tail->pid == 0);
+	*ppos = 0;
+	bcount = simple_read_from_buffer(buffer, count, ppos,
+			tail, sizeof(struct sysprof_stacktrace));
+
+	if (tail++ == &stack_traces[N_TRACES - 1])
+		tail = &stack_traces[0];
+
+	return bcount;
+}
+
+static unsigned int procfile_poll(struct file *filp, poll_table * poll_table)
+{
+	if (head != tail)
+		return POLLIN | POLLRDNORM;
+
+	poll_wait(filp, &wait_for_trace, poll_table);
+
+	if (head != tail)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
+static const struct file_operations sysprof_fops = {
+	.owner = THIS_MODULE,
+	.read = procfile_read,
+	.poll = procfile_poll,
+};
+
+static struct dentry *debugfs_pe;
+int init_module(void)
+{
+	debugfs_pe = debugfs_create_file("sysprof-trace", 0600, NULL, NULL,
+				&sysprof_fops);
+	if (!debugfs_pe)
+		return -ENODEV;
+	register_timer_hook(timer_notify);
+
+	return 0;
+}
+
+void cleanup_module(void)
+{
+	unregister_timer_hook(timer_notify);
+	debugfs_remove(debugfs_pe);
+}
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Soeren Sandmann (sandmann@daimi.au.dk)");
+MODULE_DESCRIPTION("Kernel driver for the sysprof performance analysis tool");
diff --git a/arch/x86/kernel/sysprof.h b/arch/x86/kernel/sysprof.h
new file mode 100644
index 0000000..6e16d6f
--- /dev/null
+++ b/arch/x86/kernel/sysprof.h
@@ -0,0 +1,34 @@
+/* Sysprof -- Sampling, systemwide CPU profiler
+ * Copyright 2004, Red Hat, Inc.
+ * Copyright 2004, 2005, Soeren Sandmann
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef SYSPROF_MODULE_H
+#define SYSPROF_MODULE_H
+
+#define SYSPROF_MAX_ADDRESSES 512
+
+struct sysprof_stacktrace {
+    int	pid;		/* -1 if in kernel */
+    int truncated;
+    int n_addresses;	/* note: this can be 1 if the process was compiled
+			 * with -fomit-frame-pointer or is otherwise weird
+			 */
+    unsigned long addresses[SYSPROF_MAX_ADDRESSES];
+};
+
+#endif
-- 
1.5.4.1



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
