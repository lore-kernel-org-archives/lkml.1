Return-Path: <linux-kernel-owner+w=401wt.eu-S933193AbXDFWCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbXDFWCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXDFWCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:02:13 -0400
Received: from waste.org ([66.93.16.53]:8276 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933193AbXDFWBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:01:45 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1.469046093@selenic.com>
Message-Id: <11.469046093@selenic.com>
Subject: [PATCH 10/13] maps#2: Make /proc/pid/smaps optional under CONFIG_EMBEDDED
Date: Fri, 06 Apr 2007 17:03:11 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make /proc/pid/smaps optional under CONFIG_EMBEDDED

This interface is primarily useful for doing memory profiling and not
much use on deployed embedded boxes. Make it optional. Together with
/proc/pid/clear_refs, this save a few K.

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/fs/proc/base.c
===================================================================
--- mm.orig/fs/proc/base.c	2007-03-29 13:01:49.000000000 -0500
+++ mm/fs/proc/base.c	2007-03-29 13:05:21.000000000 -0500
@@ -1907,8 +1907,10 @@ static const struct pid_entry tgid_base_
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_MMU
 	REG("clear_refs", S_IWUSR, clear_refs),
+#ifdef CONFIG_PROC_SMAPS
 	REG("smaps",      S_IRUGO, smaps),
 #endif
+#endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, attr_dir),
 #endif
@@ -2189,8 +2191,10 @@ static const struct pid_entry tid_base_s
 	REG("mounts",    S_IRUGO, mounts),
 #ifdef CONFIG_MMU
 	REG("clear_refs", S_IWUSR, clear_refs),
+#ifdef CONFIG_PROC_SMAPS
 	REG("smaps",     S_IRUGO, smaps),
 #endif
+#endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",      S_IRUGO|S_IXUGO, attr_dir),
 #endif
Index: mm/fs/proc/task_mmu.c
===================================================================
--- mm.orig/fs/proc/task_mmu.c	2007-03-29 13:01:52.000000000 -0500
+++ mm/fs/proc/task_mmu.c	2007-03-29 13:05:21.000000000 -0500
@@ -314,6 +314,7 @@ const struct file_operations proc_maps_o
 	.release	= seq_release_private,
 };
 
+#ifdef CONFIG_PROC_SMAPS
 struct mem_size_stats
 {
 	struct vm_area_struct *vma;
@@ -421,6 +422,7 @@ const struct file_operations proc_smaps_
 	.llseek		= seq_lseek,
 	.release	= seq_release_private,
 };
+#endif
 
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, void *private)
Index: mm/init/Kconfig
===================================================================
--- mm.orig/init/Kconfig	2007-03-29 13:00:36.000000000 -0500
+++ mm/init/Kconfig	2007-03-29 13:05:21.000000000 -0500
@@ -514,6 +514,14 @@ config VM_EVENT_COUNTERS
 	  on EMBEDDED systems.  /proc/vmstat will only show page counts
 	  if VM event counters are disabled.
 
+config PROC_SMAPS
+	default y
+	bool "Enable /proc/pid/smaps support" if EMBEDDED && PROC_FS && MMU
+	help
+	  The /proc/pid/smaps interface reports a process's private and
+          shared memory per mapping. Disabling this interface will reduce
+          the size of the kernel for small machines.
+
 endmenu		# General setup
 
 config RT_MUTEXES
