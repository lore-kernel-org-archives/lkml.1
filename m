Return-Path: <linux-kernel-owner+w=401wt.eu-S933227AbXDFWCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227AbXDFWCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933222AbXDFWCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:02:05 -0400
Received: from waste.org ([66.93.16.53]:8283 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933213AbXDFWBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:01:48 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1.469046093@selenic.com>
Message-Id: <14.469046093@selenic.com>
Subject: [PATCH 13/13] maps#2: Add /proc/kpagemap interface
Date: Fri, 06 Apr 2007 17:03:14 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add /proc/kpagemap interface

This makes physical page flags and counts available to userspace.
Together with /proc/pid/pagemap and /proc/pid/clear_refs, this can be
used to measure memory usage on a per-page basis.

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/fs/proc/proc_misc.c
===================================================================
--- mm.orig/fs/proc/proc_misc.c	2007-04-05 14:18:49.000000000 -0500
+++ mm/fs/proc/proc_misc.c	2007-04-05 14:26:23.000000000 -0500
@@ -46,6 +46,8 @@
 #include <linux/vmalloc.h>
 #include <linux/crash_dump.h>
 #include <linux/pid_namespace.h>
+#include <linux/ptrace.h>
+#include <linux/bootmem.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -733,6 +735,91 @@ static struct file_operations proc_page_
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
+ *
+ * The first 4 bytes of this file form a simple header:
+ *
+ * first byte:   0 for big endian, 1 for little
+ * second byte:  page shift (eg 12 for 4096 byte pages)
+ * third byte:   entry size in bytes (currently either 4 or 8)
+ * fourth byte:  header size
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
+	pfn = src / KPMSIZE - 1;
+	count = min_t(size_t, count, ((max_pfn + 1) * KPMSIZE) - src);
+	if (src & KPMMASK || count & KPMMASK)
+		return -EIO;
+
+	page = (unsigned long *)__get_free_page(GFP_USER);
+	if (!page)
+		return -ENOMEM;
+
+	while (count > 0) {
+		chunk = min_t(size_t, count, PAGE_SIZE);
+		i = 0;
+
+		if (pfn == -1) {
+			page[0] = 0;
+			page[1] = 0;
+			((char *)page)[0] = (ntohl(1) != 1);
+			((char *)page)[1] = PAGE_SHIFT;
+			((char *)page)[2] = sizeof(unsigned long);
+			((char *)page)[3] = KPMSIZE;
+			i = 2;
+			pfn++;
+		}
+
+		for (; i < 2 * chunk / KPMSIZE; i += 2, pfn++) {
+			ppage = pfn_to_page(pfn);
+			if (!ppage) {
+				page[i] = 0;
+				page[i + 1] = 0;
+			} else {
+				page[i] = ppage->flags;
+				page[i + 1] = atomic_read(&ppage->_count);
+			}
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
@@ -812,6 +899,11 @@ void __init proc_misc_init(void)
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
--- mm.orig/init/Kconfig	2007-04-05 14:18:49.000000000 -0500
+++ mm/init/Kconfig	2007-04-05 14:26:23.000000000 -0500
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
