Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbYGPCOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbYGPCOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 22:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbYGPCOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 22:14:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:22743 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbYGPCOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 22:14:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gFEmqgWI4+tbqTA7s5vjbm6E/QgoGtGQB4WrzSddAFPbL3426zg0uQ84/85Up1QIYO
         j2D8pNmEIl28hwMymqf8yq6LmIH7oELyG3u6KgIdres3kWa8czc855w9jNaz9IkxQcPd
         cl++DaQDEdGPO2nPkTgh/6ISGdyWmDoNH//ts=
Date: Wed, 16 Jul 2008 06:11:35 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: viro@zeniv.linux.org.uk, kees@outflux.net
Cc: linux-kernel@vger.kernel.org
Subject: useless kernel.maps_protect and more
Message-ID: <20080716021135.GA5973@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 5096add84b9e96e2e0a9c72675c442fe5433388a
"proc: maps protection"

commit 831830b5a2b5d413407adf380ef62fe17d6fcbf2
"restrict reading from /proc/<pid>/maps to those who share ->mm or can ptrace pid"

After Al added mm_for_maps(), maps_protect stopped controlling anything,
because they're run at ->show time, but mm_for_maps() checks are done at
->start time.

Unless anyone objects, I'll remove maps_protect.

Also, logic behind second commit applies to /proc/*/pagemap , don't you
think?


diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 7f268f3..040d5c4 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1288,13 +1288,6 @@ determine whether or not they are still functioning properly.
 Because the NMI watchdog shares registers with oprofile, by disabling the NMI
 watchdog, oprofile may have more registers to utilize.
 
-maps_protect
-------------
-
-Enables/Disables the protection of the per-process proc entries "maps" and
-"smaps".  When enabled, the contents of these files are visible only to
-readers that are allowed to ptrace() the given process.
-
 
 2.4 /proc/sys/vm - The virtual memory subsystem
 -----------------------------------------------
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 58c3e6a..b0599d5 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -146,9 +146,6 @@ static unsigned int pid_entry_count_dirs(const struct pid_entry *entries,
 	return count;
 }
 
-int maps_protect;
-EXPORT_SYMBOL(maps_protect);
-
 static struct fs_struct *get_fs_struct(struct task_struct *task)
 {
 	struct fs_struct *fs;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 28cbca8..26ffe7d 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -45,8 +45,6 @@ do {						\
 extern int nommu_vma_show(struct seq_file *, struct vm_area_struct *);
 #endif
 
-extern int maps_protect;
-
 extern int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
 extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 164bd9f..13c5d35 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -210,9 +210,6 @@ static int show_map(struct seq_file *m, void *v)
 	dev_t dev = 0;
 	int len;
 
-	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
-
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
@@ -742,22 +739,11 @@ const struct file_operations proc_pagemap_operations = {
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
 
-static int show_numa_map_checked(struct seq_file *m, void *v)
-{
-	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
-
-	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
-
-	return show_numa_map(m, v);
-}
-
 static const struct seq_operations proc_pid_numa_maps_op = {
         .start  = m_start,
         .next   = m_next,
         .stop   = m_stop,
-        .show   = show_numa_map_checked
+        .show   = show_numa_map,
 };
 
 static int numa_maps_open(struct inode *inode, struct file *file)
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 5d84e71..3af080a 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -113,9 +113,6 @@ static int show_map(struct seq_file *m, void *_vml)
 	struct proc_maps_private *priv = m->private;
 	struct task_struct *task = priv->task;
 
-	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
-
 	return nommu_vma_show(m, vml->vma);
 }
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6b16e16..fb76984 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -79,7 +79,6 @@ extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
-extern int maps_protect;
 extern int sysctl_stat_interval;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
@@ -796,16 +795,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_PROC_FS
-	{
-		.ctl_name       = CTL_UNNUMBERED,
-		.procname       = "maps_protect",
-		.data           = &maps_protect,
-		.maxlen         = sizeof(int),
-		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
-	},
-#endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "poweroff_cmd",

