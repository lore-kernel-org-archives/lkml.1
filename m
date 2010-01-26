Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917Ab0AZJ4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab0AZJ4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914Ab0AZJ4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:56:48 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:64507 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751845Ab0AZJ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:56:47 -0500
Date: Tue, 26 Jan 2010 10:56:40 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Provide ways of crashing the kernel through debugfs
Message-ID: <20100126105640.6bf9488c@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For development and testing it's sometimes useful to crash or injure the
kernel in various ways. This patch adds a debugfs interface to provoke
null-pointer dereferences, stack corruption, panics, bugons etc. For
example:

  mount -t debugfs debugfs /mnt
  echo 1 > /mnt/provoke-crash/null_dereference

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
---
Obviously this feature is for debugging and testing only, and of
interest to fairly few people. I've used it for testing the kmsg_dump
stuff (hence the CC:s above) and kdump, and have found it fairly useful.

If it's not of interest, at least this mail will be in the archives if
someone else needs something like it :-)

 lib/Kconfig.debug   |    8 +++
 lib/Makefile        |    2 +
 lib/provoke-crash.c |  163 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 173 insertions(+), 0 deletions(-)
 create mode 100644 lib/provoke-crash.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 25c3ed5..8c82a1d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1054,6 +1054,14 @@ config DMA_API_DEBUG
 	  This option causes a performance degredation.  Use only if you want
 	  to debug device drivers. If unsure, say N.
 
+config PROVOKE_CRASH
+	tristate "Provoke kernel crashes through a debugfs interface"
+	depends on DEBUG_FS
+	help
+	  Enable the kernel to crash in different ways through a debugfs interface.
+	  NOTE: This feature is dangerous!
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff --git a/lib/Makefile b/lib/Makefile
index 3b0b4a6..6018057 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -100,6 +100,8 @@ obj-$(CONFIG_GENERIC_CSUM) += checksum.o
 
 obj-$(CONFIG_GENERIC_ATOMIC64) += atomic64.o
 
+obj-$(CONFIG_PROVOKE_CRASH) += provoke-crash.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/provoke-crash.c b/lib/provoke-crash.c
new file mode 100644
index 0000000..5904e1f
--- /dev/null
+++ b/lib/provoke-crash.c
@@ -0,0 +1,163 @@
+/*
+ * Copyright (C) 2009 Net Insight
+ *
+ * Kernel module to crash or cause problems for the kernel in
+ * various ways.
+ *
+ * Author: Simon Kagstrom <simon.kagstrom@netinsight.net>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/hardirq.h>
+#include <linux/debugfs.h>
+
+static ssize_t bugon_write(struct file *f, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	BUG_ON(1);
+
+	return count;
+}
+
+static ssize_t null_dereference_write(struct file *f, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	*(volatile int*)NULL;
+
+	return count;
+}
+
+static ssize_t oops_interrupt_context_write(struct file *f, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	add_preempt_count(SOFTIRQ_MASK);
+	return null_dereference_write(f, buf, count, off);
+}
+
+static ssize_t panic_write(struct file *f, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	panic("User-caused panic\n");
+
+	return count;
+}
+
+static ssize_t write_after_free_write(struct file *f, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	size_t len = 1024;
+	u32 *data = kmalloc(len, GFP_KERNEL);
+
+	kfree(data);
+	schedule();
+	memset(data, 0x78, len);
+
+	return count;
+}
+
+static ssize_t overwrite_allocation_write(struct file *f,
+		const char __user *buf, size_t count, loff_t *off)
+{
+	size_t len = 1020;
+	u32 *data = kmalloc(len, GFP_KERNEL);
+
+	data[1024 / sizeof(u32)] = 0x12345678;
+	kfree(data);
+
+	return count;
+}
+
+static ssize_t corrupt_stack_write(struct file *f, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	volatile u32 data[8];
+
+	data[12] = 0x12345678;
+
+	return count;
+}
+
+
+static ssize_t unaligned_load_store_write(struct file *f,
+		const char __user *buf, size_t count, loff_t *off)
+{
+	static u8 data[5] __attribute__((aligned(4))) = {1,2,3,4,5};
+	u32 *p;
+	u32 val = 0x12345678;
+
+	p = (u32*)(data + 1);
+	if (*p == 0)
+		val = 0x87654321;
+	*p = val;
+
+	return count;
+}
+
+
+struct crash_entry
+{
+	const char *name;
+	struct file_operations fops;
+};
+
+static struct crash_entry crash_entries[] = {
+	{"unaligned_load_store",	{.write = unaligned_load_store_write}},
+	{"write_after_free",		{.write = write_after_free_write}},
+	{"overwrite_allocation",	{.write = overwrite_allocation_write}},
+	{"corrupt_stack", 		{.write = corrupt_stack_write}},
+	{"bugon",			{.write = bugon_write}},
+	{"panic",			{.write = panic_write}},
+	{"null_dereference",		{.write = null_dereference_write}},
+	{"oops_interrupt_context",	{.write = oops_interrupt_context_write}},
+};
+
+static struct dentry *provoke_crash_root;
+
+static int __init provoke_crash_init(void)
+{
+	int i;
+
+	provoke_crash_root = debugfs_create_dir("provoke-crash", NULL);
+	if (!provoke_crash_root) {
+		printk(KERN_ERR "provoke-crash: creating root dir failed\n");
+		return -ENODEV;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(crash_entries); i++) {
+		struct crash_entry *cur = &crash_entries[i];
+		struct dentry *de;
+
+		cur->fops.open = debugfs_file_operations.open;
+		de = debugfs_create_file(cur->name, 0200, provoke_crash_root,
+				NULL, &cur->fops);
+		if (de == NULL) {
+			printk(KERN_ERR "provoke_crash: could not create %s\n",
+					cur->name);
+			goto out_err;
+		}
+	}
+
+	return 0;
+out_err:
+	debugfs_remove_recursive(provoke_crash_root);
+
+	return -ENODEV;
+}
+
+static void __exit provoke_crash_exit(void)
+{
+	debugfs_remove_recursive(provoke_crash_root);
+}
+
+module_init(provoke_crash_init);
+module_exit(provoke_crash_exit);
+
+MODULE_AUTHOR("Simon Kagstrom <simon.kagstrom@netinsight.net>");
+MODULE_DESCRIPTION("Provoke crashes through a debugfs");
+MODULE_LICENSE("GPL");
-- 
1.6.0.4

