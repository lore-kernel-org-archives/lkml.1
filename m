Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbXGJCIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbXGJCIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbXGJCIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:08:34 -0400
Received: from ozlabs.org ([203.10.76.45]:38056 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205AbXGJCId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:08:33 -0400
Subject: Re: maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070709202414.GT11115@waste.org>
References: <1183875574.6005.275.camel@localhost.localdomain>
	 <20070709202414.GT11115@waste.org>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 12:08:16 +1000
Message-Id: <1184033296.6005.442.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-09 at 15:24 -0500, Matt Mackall wrote:
> On Sun, Jul 08, 2007 at 04:19:34PM +1000, Rusty Russell wrote:
> > Matt wrote:
> > > This interface is primarily useful for doing memory profiling and not much use
> > > on deployed embedded boxes.  Make it optional.  Together with
> > > /proc/pid/clear_refs, this save a few K.
> > 
> > How about a single config option for all these?
> 
> I suppose. This looks like half a patch though. I think you forgot a
> quilt add somewhere.

Yep: I forgot hg qrefresh 8)

==
maps2-CONFIG_PROC_PAGE_MONITOR.patch

Merge the three config options PROC_SMAPS/PROC_CLEAR_REFS/PROC_PAGEMAP
and report the approximate memory usage (i386 SMP).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 5a7ada4f5442 fs/proc/base.c
--- a/fs/proc/base.c	Sun Jul 08 15:29:26 2007 +1000
+++ b/fs/proc/base.c	Sun Jul 08 16:07:14 2007 +1000
@@ -2029,13 +2029,9 @@ static const struct pid_entry tgid_base_
 	REG("mounts",     S_IRUGO, mounts),
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_MMU
-#ifdef CONFIG_PROC_CLEAR_REFS
+#ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
-#endif
-#ifdef CONFIG_PROC_SMAPS
 	REG("smaps",      S_IRUGO, smaps),
-#endif
-#ifdef CONFIG_PROC_PAGEMAP
 	REG("pagemap",    S_IRUSR, pagemap),
 #endif
 #endif
@@ -2323,13 +2319,9 @@ static const struct pid_entry tid_base_s
 	LNK("exe",       exe),
 	REG("mounts",    S_IRUGO, mounts),
 #ifdef CONFIG_MMU
-#ifdef CONFIG_PROC_CLEAR_REFS
+#ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
-#endif
-#ifdef CONFIG_PROC_SMAPS
 	REG("smaps",     S_IRUGO, smaps),
-#endif
-#ifdef CONFIG_PROC_PAGEMAP
 	REG("pagemap",    S_IRUSR, pagemap),
 #endif
 #endif
diff -r 5a7ada4f5442 fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c	Sun Jul 08 15:29:26 2007 +1000
+++ b/fs/proc/proc_misc.c	Sun Jul 08 21:40:57 2007 +1000
@@ -661,7 +661,7 @@ static const struct file_operations proc
 };
 #endif
 
-#ifdef CONFIG_PROC_KPAGEMAP
+#ifdef CONFIG_PROC_PAGE_MONITOR
 #define KPMSIZE (sizeof(unsigned long) * 2)
 #define KPMMASK (KPMSIZE - 1)
 /* /proc/kpagemap - an array exposing page flags and counts
@@ -688,7 +688,7 @@ static ssize_t kpagemap_read(struct file
 	int chunk, i;
 
 	pfn = src / KPMSIZE - 1;
-	count = min_t(size_t, count, ((max_pfn + 1) * KPMSIZE) - src);
+	count = min(count, ((max_pfn + 1) * KPMSIZE) - src);
 	if (src & KPMMASK || count & KPMMASK)
 		return -EIO;
 
@@ -960,7 +960,7 @@ void __init proc_misc_init(void)
 				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
 	}
 #endif
-#ifdef CONFIG_PROC_KPAGEMAP
+#ifdef CONFIG_PROC_PAGE_MONITOR
 	proc_kpagemap = create_proc_entry("kpagemap", S_IRUSR, NULL);
 	if (proc_kpagemap)
 		proc_kpagemap->proc_fops = &proc_kpagemap_operations;
diff -r 5a7ada4f5442 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c	Sun Jul 08 15:29:26 2007 +1000
+++ b/fs/proc/task_mmu.c	Sun Jul 08 16:09:34 2007 +1000
@@ -315,7 +315,7 @@ const struct file_operations proc_maps_o
 	.release	= seq_release_private,
 };
 
-#ifdef CONFIG_PROC_SMAPS
+#ifdef CONFIG_PROC_PAGE_MONITOR
 struct mem_size_stats
 {
 	unsigned long resident;
@@ -429,9 +429,7 @@ const struct file_operations proc_smaps_
 	.llseek		= seq_lseek,
 	.release	= seq_release_private,
 };
-#endif
-
-#ifdef CONFIG_PROC_CLEAR_REFS
+
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, void *private)
 {
@@ -501,43 +499,7 @@ const struct file_operations proc_clear_
 const struct file_operations proc_clear_refs_operations = {
 	.write		= clear_refs_write,
 };
-#endif
-
-#ifdef CONFIG_NUMA
-extern int show_numa_map(struct seq_file *m, void *v);
-
-static int show_numa_map_checked(struct seq_file *m, void *v)
-{
-	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
-
-	if (maps_protect && !ptrace_may_attach(task))
-		return -EACCES;
-
-	return show_numa_map(m, v);
-}
-
-static struct seq_operations proc_pid_numa_maps_op = {
-        .start  = m_start,
-        .next   = m_next,
-        .stop   = m_stop,
-        .show   = show_numa_map_checked
-};
-
-static int numa_maps_open(struct inode *inode, struct file *file)
-{
-	return do_maps_open(inode, file, &proc_pid_numa_maps_op);
-}
-
-const struct file_operations proc_numa_maps_operations = {
-	.open		= numa_maps_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_private,
-};
-#endif
-
-#ifdef CONFIG_PROC_PAGEMAP
+
 struct pagemapread {
 	struct mm_struct *mm;
 	unsigned long next;
@@ -744,4 +706,38 @@ const struct file_operations proc_pagema
 	.llseek		= mem_lseek, /* borrow this */
 	.read		= pagemap_read,
 };
-#endif
+#endif /* CONFIG_PROC_PAGE_MONITOR */
+
+#ifdef CONFIG_NUMA
+extern int show_numa_map(struct seq_file *m, void *v);
+
+static int show_numa_map_checked(struct seq_file *m, void *v)
+{
+	struct proc_maps_private *priv = m->private;
+	struct task_struct *task = priv->task;
+
+	if (maps_protect && !ptrace_may_attach(task))
+		return -EACCES;
+
+	return show_numa_map(m, v);
+}
+
+static struct seq_operations proc_pid_numa_maps_op = {
+        .start  = m_start,
+        .next   = m_next,
+        .stop   = m_stop,
+        .show   = show_numa_map_checked
+};
+
+static int numa_maps_open(struct inode *inode, struct file *file)
+{
+	return do_maps_open(inode, file, &proc_pid_numa_maps_op);
+}
+
+const struct file_operations proc_numa_maps_operations = {
+	.open		= numa_maps_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
+#endif /* CONFIG_NUMA */
diff -r 5a7ada4f5442 init/Kconfig
--- a/init/Kconfig	Sun Jul 08 15:29:26 2007 +1000
+++ b/init/Kconfig	Sun Jul 08 16:01:35 2007 +1000
@@ -636,32 +636,14 @@ config SLOB
 
 endchoice
 
-config PROC_SMAPS
-	default y
-	bool "Enable /proc/pid/smaps support" if EMBEDDED && PROC_FS && MMU
-	help
-	  The /proc/pid/smaps interface reports a process's private and
-          shared memory per mapping. Disabling this interface will reduce
-          the size of the kernel for small machines.
-
-config PROC_CLEAR_REFS
-	default y
-	bool "Enable /proc/pid/clear_refs support" if EMBEDDED && PROC_FS && MMU
-	help
-	  The /proc/pid/clear_refs interface allows clearing the
-          referenced bits on a process's memory maps to allow monitoring
-          working set size. Disabling this interface will reduce
-          the size of the kernel for small machines.
-
-config PROC_PAGEMAP
-	default y
-	bool "Enable /proc/pid/pagemap support" if EMBEDDED && PROC_FS && MMU
-	help
-	  The /proc/pid/pagemap interface allows reading the
-          kernel's virtual memory to page frame mapping to determine which
-          individual pages a process has mapped and which pages it shares
-          with other processes. Disabling this interface will reduce the
-          size of the kernel for small machines.
+config PROC_PAGE_MONITOR
+	default y
+	bool "Enable /proc page monitoring" if EMBEDDED && PROC_FS && MMU
+	help
+	  Various /proc files exist to monitor process memory utilization:
+	  /proc/pid/smaps, /proc/pid/clear_refs and /proc/pid/pagemap.
+	  Disabling these interfaces will reduce the size of the kernel by
+	  approximately 4kb.
 
 config PROC_KPAGEMAP
 	default y
@@ -670,7 +652,7 @@ config PROC_KPAGEMAP
 	  The /proc/pid/kpagemap interface allows reading the
           kernel's per-page flag and usage counts to gather precise
           information on page-level memory usage. Disabling this interface
-          will reduce the size of the kernel for small machines.
+          will reduce the size of the kernel by around 600 bytes.
 
 endmenu		# General setup
 


