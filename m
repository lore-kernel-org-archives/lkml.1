Return-Path: <linux-kernel-owner+w=401wt.eu-S966309AbXDDCnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966309AbXDDCnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966310AbXDDCnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:43:15 -0400
Received: from waste.org ([66.93.16.53]:54658 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966311AbXDDCm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:42:29 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1.486631555@selenic.com>
Message-Id: <12.486631555@selenic.com>
Subject: [PATCH 11/13] maps: Make /proc/pid/clear_refs option under CONFIG_EMBEDDED
Date: Tue, 03 Apr 2007 21:43:42 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make /proc/pid/clear_refs option under CONFIG_EMBEDDED

This interface is primarily useful for doing memory profiling and not
much use on deployed embedded boxes. Make it optional. Together with
/proc/pid/smaps, this save a few K.

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/fs/proc/base.c
===================================================================
--- mm.orig/fs/proc/base.c	2007-04-03 14:50:33.000000000 -0500
+++ mm/fs/proc/base.c	2007-04-03 18:04:59.000000000 -0500
@@ -2000,7 +2000,9 @@ static const struct pid_entry tgid_base_
 	REG("mounts",     S_IRUGO, mounts),
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_MMU
+#ifdef CONFIG_PROC_CLEAR_REFS
 	REG("clear_refs", S_IWUSR, clear_refs),
+#endif
 #ifdef CONFIG_PROC_SMAPS
 	REG("smaps",      S_IRUGO, smaps),
 #endif
@@ -2285,7 +2287,9 @@ static const struct pid_entry tid_base_s
 	LNK("exe",       exe),
 	REG("mounts",    S_IRUGO, mounts),
 #ifdef CONFIG_MMU
+#ifdef CONFIG_PROC_CLEAR_REFS
 	REG("clear_refs", S_IWUSR, clear_refs),
+#endif
 #ifdef CONFIG_PROC_SMAPS
 	REG("smaps",     S_IRUGO, smaps),
 #endif
Index: mm/fs/proc/task_mmu.c
===================================================================
--- mm.orig/fs/proc/task_mmu.c	2007-04-03 14:50:33.000000000 -0500
+++ mm/fs/proc/task_mmu.c	2007-04-03 18:04:59.000000000 -0500
@@ -424,6 +424,7 @@ const struct file_operations proc_smaps_
 };
 #endif
 
+#ifdef CONFIG_PROC_CLEAR_REFS
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, void *private)
 {
@@ -493,6 +494,7 @@ static ssize_t clear_refs_write(struct f
 const struct file_operations proc_clear_refs_operations = {
 	.write		= clear_refs_write,
 };
+#endif
 
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
Index: mm/init/Kconfig
===================================================================
--- mm.orig/init/Kconfig	2007-04-03 14:50:33.000000000 -0500
+++ mm/init/Kconfig	2007-04-03 18:04:59.000000000 -0500
@@ -593,6 +593,15 @@ config PROC_SMAPS
           shared memory per mapping. Disabling this interface will reduce
           the size of the kernel for small machines.
 
+config PROC_CLEAR_REFS
+	default y
+	bool "Enable /proc/pid/clear_refs support" if EMBEDDED && PROC_FS && MMU
+	help
+	  The /proc/pid/clear_refs interface allows clearing the
+          referenced bits on a process's memory maps to allow monitoring
+          working set size. Disabling this interface will reduce
+          the size of the kernel for small machines.
+
 endmenu		# General setup
 
 config RT_MUTEXES
