Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbZC3WqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbZC3WqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZC3Wp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:45:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:7038 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbZC3Wp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=sPXeHCb+B93YpP9YXcSjbEPfjfYvcq0RH7PZRq/tx4Z1yDCiOKl4DxS14YdHQTaYZD
         474NFdBMtd5D/hgYMlgOgWfQkGWEJJQ4Xf8xKxlgukXVid2QVOGSG1881xWIdurPQ2Gz
         XMiYlQZXnxdFELHgCTibXxt5UoMQS03jk9tiE=
Date: Tue, 31 Mar 2009 02:53:26 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: viro@ZenIV.linux.org.uk
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: [PATCH] proc 1/6: implement support for automounts in task
	directories
Message-ID: <20090330225326.GB19892@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have a lot of opinion on this bug. I checked patchset to fix known
reproducer, timeout is obviously taken out of air and not nice.

6/6 looks orthogonal to whole patch series, CCing Andreas just in case.
---------------------------------------------------------------------
>From 1999fb8c093a55b93e81dc41192ccaa86daad3d0 Mon Sep 17 00:00:00 2001
From: Eric W. Biederman <ebiederm@xmission.com>
Date: Wed, 19 Nov 2008 03:57:02 +0300
Subject: [PATCH 06/11] proc 1/6: implement support for automounts in task directories

This is a general mechanism that is capable of removing any unused mounts on
/proc in any directory.  As we flush the mounts when a processes dies this
mechanism is tailored for flushing mounts in the per task and per task group
directories.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/Makefile        |    1 +
 fs/proc/automount.c     |   28 ++++++++++++++++++++++++++++
 fs/proc/internal.h      |    2 ++
 include/linux/proc_fs.h |    5 +++++
 kernel/exit.c           |    2 +-
 5 files changed, 37 insertions(+), 1 deletions(-)
 create mode 100644 fs/proc/automount.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 63d9651..757f7c1 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -9,6 +9,7 @@ proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 
 proc-y       += inode.o root.o base.o generic.o array.o \
 		proc_tty.o
+proc-y	+= automount.o
 proc-y	+= cmdline.o
 proc-y	+= cpuinfo.o
 proc-y	+= devices.o
diff --git a/fs/proc/automount.c b/fs/proc/automount.c
new file mode 100644
index 0000000..5d22b5a
--- /dev/null
+++ b/fs/proc/automount.c
@@ -0,0 +1,28 @@
+#include <linux/list.h>
+#include <linux/mount.h>
+#include <linux/workqueue.h>
+#include "internal.h"
+
+LIST_HEAD(proc_automounts);
+
+static void proc_expire_automounts(struct work_struct *work);
+
+static DECLARE_DELAYED_WORK(proc_automount_task, proc_expire_automounts);
+static int proc_automount_timeout = 500 * HZ;
+
+void proc_shrink_automounts(void)
+{
+	struct list_head *list = &proc_automounts;
+
+	mark_mounts_for_expiry(list);
+	mark_mounts_for_expiry(list);
+	if (list_empty(list))
+		return;
+
+	schedule_delayed_work(&proc_automount_task, proc_automount_timeout);
+}
+
+static void proc_expire_automounts(struct work_struct *work)
+{
+	proc_shrink_automounts();
+}
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index f6db961..475fce4 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -92,3 +92,5 @@ struct pde_opener {
 	struct list_head lh;
 };
 void pde_users_dec(struct proc_dir_entry *pde);
+
+extern struct list_head proc_automounts;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index fbfa3d4..da2b53c 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -97,6 +97,7 @@ extern spinlock_t proc_subdir_lock;
 
 extern void proc_root_init(void);
 
+void proc_shrink_automounts(void);
 void proc_flush_task(struct task_struct *task);
 struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *);
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
@@ -203,6 +204,10 @@ static inline void proc_flush_task(struct task_struct *task)
 {
 }
 
+static inline void proc_shrink_automounts(void)
+{
+}
+
 static inline struct proc_dir_entry *create_proc_entry(const char *name,
 	mode_t mode, struct proc_dir_entry *parent) { return NULL; }
 static inline struct proc_dir_entry *proc_create(const char *name,
diff --git a/kernel/exit.c b/kernel/exit.c
index 167e1e3..b4796ef 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -176,7 +176,7 @@ repeat:
 	/* don't need to get the RCU readlock here - the process is dead and
 	 * can't be modifying its own credentials */
 	atomic_dec(&__task_cred(p)->user->processes);
-
+	proc_shrink_automounts();
 	proc_flush_task(p);
 	write_lock_irq(&tasklist_lock);
 	tracehook_finish_release_task(p);
-- 
1.5.6.5

