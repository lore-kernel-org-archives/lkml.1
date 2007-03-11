Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbXCKBnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbXCKBnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 20:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbXCKBnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 20:43:40 -0500
Received: from mylar.outflux.net ([69.93.193.226]:39011 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbXCKBnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 20:43:39 -0500
Date: Sat, 10 Mar 2007 17:43:10 -0800
From: Kees Cook <kees@outflux.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: maps protection
Message-ID: <20070311014310.GG10460@outflux.net>
References: <20070306175609.267bd7a9.akpm@linux-foundation.org> <20070307021335.GR9621@outflux.net> <20070306185942.585e7cd1.akpm@linux-foundation.org> <20070307031429.GU9621@outflux.net> <1173241331.3236.10.camel@laptopd505.fenrus.org> <20070308205525.GJ6805@outflux.net> <20070309183006.7ff23eff.akpm@linux-foundation.org> <45F23BB5.8090907@linux.intel.com> <20070310183341.GB10460@outflux.net> <20070310162101.716b6b57.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310162101.716b6b57.akpm@linux-foundation.org>
Organization: Outflux
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The /proc/pid/ "maps", "smaps", and "numa_maps" files contain sensitive 
information about the memory location and usage of processes.  Issues:

- maps should not be world-readable, especially if programs expect any 
  kind of ASLR protection from local attackers.
- maps cannot just be 0400 because "-D_FORTIFY_SOURCE=2 -O2" makes glibc
  check the maps when %n is in a *printf call, and a setuid(getuid()) 
  process wouldn't be able to read its own maps file.  (For reference
  see http://lkml.org/lkml/2006/1/22/150)
- a system-wide toggle is needed to allow prior behavior in the case of
  non-root applications that depend on access to the maps contents.

This change implements a check using "ptrace_may_attach" before allowing 
access to read the maps contents.  To control this protection, the new 
knob /proc/sys/kernel/maps_protect has been added, with corresponding 
updates to the procfs documentation.

Signed-off-by: Kees Cook <kees@outflux.net>
---
 CREDITS                            |    2 +-
 Documentation/filesystems/proc.txt |    7 +++++++
 fs/proc/base.c                     |    3 +++
 fs/proc/internal.h                 |    2 ++
 fs/proc/task_mmu.c                 |   16 +++++++++++++++-
 fs/proc/task_nommu.c               |    6 ++++++
 include/linux/sysctl.h             |    1 +
 kernel/sysctl.c                    |    9 +++++++++
 8 files changed, 44 insertions(+), 2 deletions(-)
---
diff --git a/CREDITS b/CREDITS
index 6bd8ab8..38c3ada 100644
--- a/CREDITS
+++ b/CREDITS
@@ -655,7 +655,7 @@ N: Kees Cook
 E: kees@outflux.net
 W: http://outflux.net/
 P: 1024D/17063E6D 9FA3 C49C 23C9 D1BC 2E30  1975 1FFF 4BA9 1706 3E6D
-D: Minor updates to SCSI code for the Communications type
+D: Minor updates to SCSI types, added /proc/pid/maps protection
 S: (ask for current address)
 S: USA
 
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 5484ab5..d9b06b5 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1137,6 +1137,13 @@ determine whether or not they are still functioning properly.
 Because the NMI watchdog shares registers with oprofile, by disabling the NMI
 watchdog, oprofile may have more registers to utilize.
 
+maps_protect
+------------
+
+Enables/Disables the protection of the per-process proc entries "maps" and
+"smaps".  When enabled, the contents of these files are visible only to
+readers that are allowed to ptrace() the given process.
+
 
 2.4 /proc/sys/vm - The virtual memory subsystem
 -----------------------------------------------
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 01f7769..6feccbc 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -123,6 +123,9 @@ struct pid_entry {
 		NULL, &proc_info_file_operations,	\
 		{ .proc_read = &proc_##OTYPE } )
 
+int maps_protect = 0;
+EXPORT_SYMBOL(maps_protect);
+
 static struct fs_struct *get_fs_struct(struct task_struct *task)
 {
 	struct fs_struct *fs;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index c932aa6..2c65b6e 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -33,6 +33,8 @@ do {						\
 extern int nommu_vma_show(struct seq_file *, struct vm_area_struct *);
 #endif
 
+extern int maps_protect;
+
 extern void create_seq_entry(char *name, mode_t mode, const struct file_operations *f);
 extern int proc_exe_link(struct inode *, struct dentry **, struct vfsmount **);
 extern int proc_tid_stat(struct task_struct *,  char *);
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 7445980..45a0f3e 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -134,6 +134,9 @@ static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats
 	dev_t dev = 0;
 	int len;
 
+	if (maps_protect && !ptrace_may_attach(task))
+		return -EACCES;
+
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
@@ -444,11 +447,22 @@ const struct file_operations proc_maps_operations = {
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
 
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
 static struct seq_operations proc_pid_numa_maps_op = {
         .start  = m_start,
         .next   = m_next,
         .stop   = m_stop,
-        .show   = show_numa_map
+        .show   = show_numa_map_checked
 };
 
 static int numa_maps_open(struct inode *inode, struct file *file)
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 7cddf6b..c2747c9 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -143,6 +143,12 @@ out:
 static int show_map(struct seq_file *m, void *_vml)
 {
 	struct vm_list_struct *vml = _vml;
+	struct proc_maps_private *priv = m->private;
+	struct task_struct *task = priv->task;
+	
+	if (maps_protect && !ptrace_may_attach(task))
+		return -EACCES;
+
 	return nommu_vma_show(m, vml->vma);
 }
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 2c5fb38..608a331 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -165,6 +165,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_MAPS_PROTECT=77, /* int: whether we protect maps from public visibility */
 };
 
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 1b255df..ca4d69f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -76,6 +76,7 @@ extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
+extern int maps_protect;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -603,6 +604,14 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+	{,
+		.ctl_name       = KERN_MAPS_PROTECT,
+		.procname       = "maps_protect",
+		.data           = &maps_protect,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
 
 	{ .ctl_name = 0 }
 };



-- 
Kees Cook
