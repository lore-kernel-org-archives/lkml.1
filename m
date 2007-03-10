Return-Path: <linux-kernel-owner+w=401wt.eu-S1751380AbXCJSyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbXCJSyd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 13:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbXCJSyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 13:54:33 -0500
Received: from mylar.outflux.net ([69.93.193.226]:35619 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbXCJSyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 13:54:31 -0500
X-Greylist: delayed 1244 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Mar 2007 13:54:31 EST
Date: Sat, 10 Mar 2007 10:33:41 -0800
From: Kees Cook <kees@outflux.net>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: maps protection
Message-ID: <20070310183341.GB10460@outflux.net>
References: <20070307012234.GN9621@outflux.net> <20070306175609.267bd7a9.akpm@linux-foundation.org> <20070307021335.GR9621@outflux.net> <20070306185942.585e7cd1.akpm@linux-foundation.org> <20070307031429.GU9621@outflux.net> <1173241331.3236.10.camel@laptopd505.fenrus.org> <20070308205525.GJ6805@outflux.net> <20070309183006.7ff23eff.akpm@linux-foundation.org> <45F23BB5.8090907@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F23BB5.8090907@linux.intel.com>
Organization: Outflux
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 09:01:41PM -0800, Arjan van de Ven wrote:
> >I just don't know what it will break - we're changing things so that user A
> >cannot monitor user B's memory maps.  I feel that it's sure to break
> >various people's fancy custom system activity monitoring/logging setups,
> >and the sort of users who will be affected are, alas, the sort of people
> >who won't run a kernel with this change in it for another couple of years
> >yet.
> 
> except if they run RHEL or FC kernels, in which case they already have 
> that change

Right, this is a "gentler" version of just slapping 0400 perms on the 
maps files, which already has the same effect.  I think tightening this 
bit of security is worth some possible breakage.

> >Do we actually need to disable the whole interface?  If all you're
> >concerned about is the pathname then perhaps the knob could cause that
> >pathname to be replaced with "<hidden>".  That'll cause things to
> >break less seriously and still allows somewhat useful info to be gathered.
> 
> the problem part is that you can see EXACLTY where glibc is loaded in 
> memory, which effectively defeats address space randomization for 
> local users....

Right; and since the maps are loaded in a specific order, just dropping 
the filename isn't going to help in protecting the ASLR.  e.g. I can get 
apache's library list from its ELF, and it's very easy to line that up 
with the maps file even if the filenames are missing.

Here's another revision, with both the "can ptrace" and the global /proc 
knob; and I'll beg for defaulting the knob to "on".  :)

Signed-off-by: Kees Cook <kees@outflux.net>

---
 fs/proc/base.c         |    3 +++
 fs/proc/internal.h     |    2 ++
 fs/proc/task_mmu.c     |   16 +++++++++++++++-
 fs/proc/task_nommu.c   |    6 ++++++
 include/linux/sysctl.h |    1 +
 kernel/sysctl.c        |    9 +++++++++
 6 files changed, 36 insertions(+), 1 deletion(-)
---
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1a979ea..9b6e731 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -123,6 +123,9 @@ struct pid_entry {
 		NULL, &proc_info_file_operations,	\
 		{ .proc_read = &proc_##OTYPE } )
 
+int maps_protect = 1;
+EXPORT_SYMBOL(maps_protect);
+
 static struct fs_struct *get_fs_struct(struct task_struct *task)
 {
 	struct fs_struct *fs;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 987c773..596d925 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -31,6 +31,8 @@ do {						\
 extern int nommu_vma_show(struct seq_file *, struct vm_area_struct *);
 #endif
 
+extern int maps_protect;
+
 extern void create_seq_entry(char *name, mode_t mode, const struct file_operations *f);
 extern int proc_exe_link(struct inode *, struct dentry **, struct vfsmount **);
 extern int proc_tid_stat(struct task_struct *,  char *);
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 55ade0d..2e43c12 100644
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
@@ -444,11 +447,22 @@ struct file_operations proc_maps_operations = {
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
index fcc5caf..fb36c6a 100644
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
index 81480e6..743d63d 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -160,6 +160,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_MAPS_PROTECT=77, /* int: whether we protect maps from public visibility */
 };
 
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b01e767..653a6ad 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -76,6 +76,7 @@ extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
+extern int maps_protect;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -782,6 +783,14 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+	{
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
