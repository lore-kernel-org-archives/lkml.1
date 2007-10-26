Return-Path: <linux-kernel-owner+w=401wt.eu-S1764304AbXJZQkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764304AbXJZQkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763868AbXJZQgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:36:43 -0400
Received: from waste.org ([66.93.16.53]:56588 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762251AbXJZQgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:36:37 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <1.430487409@selenic.com>
Message-Id: <11.430487409@selenic.com>
Subject: [PATCH 10/12] maps4: add /proc/kpagecount interface
Date: Fri, 26 Oct 2007 11:36:36 -0500
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
--- l.orig/fs/proc/proc_misc.c	2007-10-22 16:24:34.000000000 -0500
+++ l/fs/proc/proc_misc.c	2007-10-22 17:53:48.000000000 -0500
@@ -46,6 +46,7 @@
 #include <linux/vmalloc.h>
 #include <linux/crash_dump.h>
 #include <linux/pid_namespace.h>
+#include <linux/bootmem.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -656,6 +657,57 @@ static const struct file_operations proc
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
 struct proc_dir_entry *proc_root_kcore;
 
 void create_seq_entry(char *name, mode_t mode, const struct file_operations *f)
@@ -735,6 +787,7 @@ void __init proc_misc_init(void)
 				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
 	}
 #endif
+	create_seq_entry("kpagecount", S_IRUSR, &proc_kpagecount_operations);
 #ifdef CONFIG_PROC_VMCORE
 	proc_vmcore = create_proc_entry("vmcore", S_IRUSR, NULL);
 	if (proc_vmcore)
