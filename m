Return-Path: <linux-kernel-owner+w=401wt.eu-S1764313AbXJZQlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764313AbXJZQlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763955AbXJZQgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:36:45 -0400
Received: from waste.org ([66.93.16.53]:56594 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755258AbXJZQgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:36:40 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <1.430487409@selenic.com>
Message-Id: <13.430487409@selenic.com>
Subject: [PATCH 12/12] maps4: make page monitoring /proc file optional
Date: Fri, 26 Oct 2007 11:36:38 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make /proc/ page monitoring configurable

This puts the following files under an embedded config option:

/proc/pid/clear_refs
/proc/pid/smaps
/proc/pid/pagemap
/proc/kpagecount
/proc/kpageflags

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: l/fs/proc/base.c
===================================================================
--- l.orig/fs/proc/base.c	2007-10-26 11:33:16.000000000 -0500
+++ l/fs/proc/base.c	2007-10-26 11:34:47.000000000 -0500
@@ -2027,7 +2027,7 @@ static const struct pid_entry tgid_base_
 	LNK("exe",        exe),
 	REG("mounts",     S_IRUGO, mounts),
 	REG("mountstats", S_IRUSR, mountstats),
-#ifdef CONFIG_MMU
+#ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",      S_IRUGO, smaps),
 	REG("pagemap",    S_IRUSR, pagemap),
@@ -2314,7 +2314,7 @@ static const struct pid_entry tid_base_s
 	LNK("root",      root),
 	LNK("exe",       exe),
 	REG("mounts",    S_IRUGO, mounts),
-#ifdef CONFIG_MMU
+#ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",     S_IRUGO, smaps),
 	REG("pagemap",    S_IRUSR, pagemap),
Index: l/fs/proc/proc_misc.c
===================================================================
--- l.orig/fs/proc/proc_misc.c	2007-10-26 11:34:43.000000000 -0500
+++ l/fs/proc/proc_misc.c	2007-10-26 11:34:47.000000000 -0500
@@ -657,6 +657,7 @@ static const struct file_operations proc
 };
 #endif
 
+#ifdef CONFIG_PROC_PAGE_MONITOR
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
 /* /proc/kpagecount - an array exposing page counts
@@ -785,6 +786,7 @@ static struct file_operations proc_kpage
 	.llseek = mem_lseek,
 	.read = kpageflags_read,
 };
+#endif /* CONFIG_PROC_PAGE_MONITOR */
 
 struct proc_dir_entry *proc_root_kcore;
 
@@ -865,8 +867,10 @@ void __init proc_misc_init(void)
 				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
 	}
 #endif
+#ifdef CONFIG_PROC_PAGE_MONITOR
 	create_seq_entry("kpagecount", S_IRUSR, &proc_kpagecount_operations);
 	create_seq_entry("kpageflags", S_IRUSR, &proc_kpageflags_operations);
+#endif
 #ifdef CONFIG_PROC_VMCORE
 	proc_vmcore = create_proc_entry("vmcore", S_IRUSR, NULL);
 	if (proc_vmcore)
Index: l/fs/proc/task_mmu.c
===================================================================
--- l.orig/fs/proc/task_mmu.c	2007-10-26 11:34:33.000000000 -0500
+++ l/fs/proc/task_mmu.c	2007-10-26 11:34:47.000000000 -0500
@@ -338,6 +338,7 @@ const struct file_operations proc_maps_o
  */
 #define PSS_SHIFT 12
 
+#ifdef CONFIG_PROC_PAGE_MONITOR
 struct mem_size_stats
 {
 	struct vm_area_struct *vma;
@@ -717,6 +718,7 @@ const struct file_operations proc_pagema
 	.llseek		= mem_lseek, /* borrow this */
 	.read		= pagemap_read,
 };
+#endif /* CONFIG_PROC_PAGE_MONITOR */
 
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
Index: l/init/Kconfig
===================================================================
--- l.orig/init/Kconfig	2007-10-26 11:19:35.000000000 -0500
+++ l/init/Kconfig	2007-10-26 11:34:47.000000000 -0500
@@ -571,6 +571,16 @@ config SLOB
 
 endchoice
 
+config PROC_PAGE_MONITOR
+ 	default y
+	depends PROC_FS && MMU
+	bool "Enable /proc page monitoring" if EMBEDDED
+ 	help
+	  Various /proc files exist to monitor process memory utilization:
+	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
+	  /proc/kpagecount, and /proc/kpageflags. Disabling these
+          interfaces will reduce the size of the kernel by approximately 4kb.
+
 endmenu		# General setup
 
 config RT_MUTEXES
Index: l/mm/Makefile
===================================================================
--- l.orig/mm/Makefile	2007-10-26 11:20:01.000000000 -0500
+++ l/mm/Makefile	2007-10-26 11:34:47.000000000 -0500
@@ -5,7 +5,7 @@
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o pagewalk.o
+			   vmalloc.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   page_alloc.o page-writeback.o pdflush.o \
@@ -13,6 +13,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   $(mmu-y)
 
+obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
