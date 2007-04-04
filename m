Return-Path: <linux-kernel-owner+w=401wt.eu-S2992443AbXDDCnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992443AbXDDCnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946034AbXDDCnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:43:19 -0400
Received: from waste.org ([66.93.16.53]:54665 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966313AbXDDCmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:42:32 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1.486631555@selenic.com>
Message-Id: <14.486631555@selenic.com>
Subject: [PATCH 13/13] maps: Add /proc/kpagemap interface
Date: Tue, 03 Apr 2007 21:43:44 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add /proc/kpagemap interface

This makes physical page flags and counts available to userspace.
Together with /proc/pid/pagemap and /proc/pid/clear_refs, this can be
used to measure memory usage on a per-page basis.

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/fs/proc/proc_misc.c
===================================================================
--- mm.orig/fs/proc/proc_misc.c	2007-04-03 14:47:45.000000000 -0500
+++ mm/fs/proc/proc_misc.c	2007-04-03 17:57:14.000000000 -0500
@@ -46,6 +46,8 @@
 #include <linux/vmalloc.h>
 #include <linux/crash_dump.h>
 #include <linux/pid_namespace.h>
+#include <linux/ptrace.h>
+#include <linux/bootmem.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -733,6 +735,72 @@ static struct file_operations proc_page_
 };
 #endif
 
+#ifdef CONFIG_PROC_KPAGEMAP
+#define KPMSIZE (sizeof(unsigned long) * 2)
+#define KPMMASK (KPMSIZE - 1)
+/* /proc/kpagemap - an array exposing page flags and counts
+ *
+ * Each entry is a pair of unsigned longs representing the
+ * corresponding physical page, the first containing the page flags
+ * and the second containing the page use count.
+ */
+static ssize_t kpagemap_read(struct file *file, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	unsigned long *page;
+	struct page *ppage;
+	unsigned long src = *ppos;
+	unsigned long pfn;
+	ssize_t ret = 0;
+	int chunk, i;
+
+	pfn = src / KPMSIZE;
+	count = min_t(size_t, count, (max_pfn * KPMSIZE) - src);
+	if (src & KPMMASK || count & KPMMASK)
+		return -EIO;
+
+	page = (unsigned long *)__get_free_page(GFP_USER);
+	if (!page)
+		return -ENOMEM;
+
+	while (count > 0) {
+		chunk = min_t(size_t, count, PAGE_SIZE);
+		for (i = 0; i < 2 * chunk / KPMSIZE; i += 2) {
+			ppage = pfn_to_page(pfn);
+			if (!ppage) {
+				page[i] = 0;
+				page[i + 1] = 0;
+			} else {
+				page[i] = ppage->flags;
+				page[i + 1] = atomic_read(&ppage->_count);
+			}
+			pfn++;
+		}
+		chunk = (i / 2) * KPMSIZE;
+
+		if (copy_to_user(buf, page, chunk)) {
+			ret = -EFAULT;
+			break;
+		}
+		ret += chunk;
+		src += chunk;
+		buf += chunk;
+		count -= chunk;
+		cond_resched();
+	}
+	*ppos = src;
+
+	free_page((unsigned long)page);
+	return ret;
+}
+
+struct proc_dir_entry *proc_kpagemap;
+static struct file_operations proc_kpagemap_operations = {
+	.llseek = mem_lseek,
+	.read = kpagemap_read,
+};
+#endif
+
 struct proc_dir_entry *proc_root_kcore;
 
 void create_seq_entry(char *name, mode_t mode, const struct file_operations *f)
@@ -812,6 +880,11 @@ void __init proc_misc_init(void)
 				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
 	}
 #endif
+#ifdef CONFIG_PROC_KPAGEMAP
+	proc_kpagemap = create_proc_entry("kpagemap", S_IRUSR, NULL);
+	if (proc_kpagemap)
+		proc_kpagemap->proc_fops = &proc_kpagemap_operations;
+#endif
 #ifdef CONFIG_PROC_VMCORE
 	proc_vmcore = create_proc_entry("vmcore", S_IRUSR, NULL);
 	if (proc_vmcore)
Index: mm/init/Kconfig
===================================================================
--- mm.orig/init/Kconfig	2007-04-03 14:50:33.000000000 -0500
+++ mm/init/Kconfig	2007-04-03 14:50:33.000000000 -0500
@@ -612,6 +612,15 @@ config PROC_PAGEMAP
           with other processes. Disabling this interface will reduce the
           size of the kernel for small machines.
 
+config PROC_KPAGEMAP
+	default y
+	bool "Enable /proc/kpagemap support" if EMBEDDED && PROC_FS
+	help
+	  The /proc/pid/kpagemap interface allows reading the
+          kernel's per-page flag and usage counts to gather precise
+          information on page-level memory usage. Disabling this interface
+          will reduce the size of the kernel for small machines.
+
 endmenu		# General setup
 
 config RT_MUTEXES
