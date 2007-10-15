Return-Path: <linux-kernel-owner+w=401wt.eu-S1764880AbXJOW3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764880AbXJOW3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761694AbXJOW0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:26:19 -0400
Received: from waste.org ([66.93.16.53]:1300 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757333AbXJOW0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:26:11 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <1.290135367@selenic.com>
Message-Id: <11.290135367@selenic.com>
Subject: [PATCH 10/11] maps3: add /proc/kpagecount and /proc/kpageflags interfaces
Date: Mon, 15 Oct 2007 17:26:07 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>

This makes physical page map counts available to userspace. Together
with /proc/pid/pagemap and /proc/pid/clear_refs, this can be used to
monitor memory usage on a per-page basis.

[bunk@stusta.de: make struct proc_kpagemap static]
Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Index: l/fs/proc/proc_misc.c
===================================================================
--- l.orig/fs/proc/proc_misc.c	2007-10-09 17:37:57.000000000 -0500
+++ l/fs/proc/proc_misc.c	2007-10-10 11:46:50.000000000 -0500
@@ -46,6 +46,7 @@
 #include <linux/vmalloc.h>
 #include <linux/crash_dump.h>
 #include <linux/pid_namespace.h>
+#include <linux/bootmem.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -656,6 +657,106 @@ static const struct file_operations proc
 };
 #endif
 
+#define KPMSIZE sizeof(u64)
+#define KPMMASK (KPMSIZE - 1)
+/* /proc/kpagecount - an array exposing page counts
+ *
+ * Each entry is a u64 representing the corresponding
+ * physical page count.
+ */
+static ssize_t kpagecount_read(struct file *file, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	u64 __user *out = (u64 __user *)buf;
+	struct page *ppage;
+	unsigned long src = *ppos;
+	unsigned long pfn;
+	ssize_t ret = 0;
+	u64 pcount;
+
+	if (!access_ok(VERIFY_WRITE, buf, count))
+		return -EFAULT;
+
+	pfn = src / KPMSIZE;
+	count = min_t(size_t, count, (max_pfn * KPMSIZE) - src);
+	if (src & KPMMASK || count & KPMMASK)
+		return -EIO;
+
+	while (count > 0) {
+		ppage = pfn_to_page(pfn++);
+		if (!ppage)
+			pcount = 0;
+		else
+			pcount = atomic_read(&ppage->_count);
+
+		if (put_user(pcount, out++)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		count -= KPMSIZE;
+	}
+
+	*ppos += (char __user *)out - buf;
+	if (!ret)
+		ret = (char __user *)out - buf;
+	return ret;
+}
+
+static struct file_operations proc_kpagecount_operations = {
+	.llseek = mem_lseek,
+	.read = kpagecount_read,
+};
+
+/* /proc/kpageflags - an array exposing page flags
+ *
+ * Each entry is a u64 representing the corresponding
+ * physical page flags.
+ */
+static ssize_t kpageflags_read(struct file *file, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	u64 __user *out = (u64 __user *)buf;
+	struct page *ppage;
+	unsigned long src = *ppos;
+	unsigned long pfn;
+	ssize_t ret = 0;
+	u64 pflags;
+
+	if (!access_ok(VERIFY_WRITE, buf, count))
+		return -EFAULT;
+
+	pfn = src / KPMSIZE;
+	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
+	if (src & KPMMASK || count & KPMMASK)
+		return -EIO;
+
+	while (count > 0) {
+		ppage = pfn_to_page(pfn++);
+		if (!ppage)
+			pflags = 0;
+		else
+			pflags = ppage->flags;
+
+		if (put_user(pflags, out++)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		count -= KPMSIZE;
+	}
+
+	*ppos += (char __user *)out - buf;
+	if (!ret)
+		ret = (char __user *)out - buf;
+	return ret;
+}
+
+static struct file_operations proc_kpageflags_operations = {
+	.llseek = mem_lseek,
+	.read = kpageflags_read,
+};
+
 struct proc_dir_entry *proc_root_kcore;
 
 void create_seq_entry(char *name, mode_t mode, const struct file_operations *f)
@@ -735,6 +836,8 @@ void __init proc_misc_init(void)
 				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
 	}
 #endif
+	create_seq_entry("kpagecount", S_IRUSR, &proc_kpagecount_operations);
+	create_seq_entry("kpageflags", S_IRUSR, &proc_kpageflags_operations);
 #ifdef CONFIG_PROC_VMCORE
 	proc_vmcore = create_proc_entry("vmcore", S_IRUSR, NULL);
 	if (proc_vmcore)
