Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab0BWBIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:08:54 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59939 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab0BWBFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:05:13 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH tip/core/rcu 08/21] vfs: apply lockdep-based checking to rcu_dereference() uses
Date: Mon, 22 Feb 2010 17:04:52 -0800
Message-Id: <1266887105-1528-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100223010435.GA666@linux.vnet.ibm.com>
References: <20100223010435.GA666@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lockdep-ified RCU primitives to alloc_fd(), files_fdtable() and
fcheck_files().

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 fs/file.c               |    2 +-
 fs/proc/array.c         |    2 ++
 fs/proc/base.c          |    6 +++++-
 include/linux/fdtable.h |    8 ++++++--
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 87e1290..38039af 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -478,7 +478,7 @@ repeat:
 	error = fd;
 #if 1
 	/* Sanity check */
-	if (rcu_dereference(fdt->fd[fd]) != NULL) {
+	if (rcu_dereference_raw(fdt->fd[fd]) != NULL) {
 		printk(KERN_WARNING "alloc_fd: slot %d not NULL!\n", fd);
 		rcu_assign_pointer(fdt->fd[fd], NULL);
 	}
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 13b5d07..18e20fe 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -270,7 +270,9 @@ static inline void task_sig(struct seq_file *m, struct task_struct *p)
 		blocked = p->blocked;
 		collect_sigign_sigcatch(p, &ignored, &caught);
 		num_threads = atomic_read(&p->signal->count);
+		rcu_read_lock();  /* FIXME: is this correct? */
 		qsize = atomic_read(&__task_cred(p)->user->sigpending);
+		rcu_read_unlock();
 		qlim = p->signal->rlim[RLIMIT_SIGPENDING].rlim_cur;
 		unlock_task_sighand(p, &flags);
 	}
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 18d5cc6..db19ca8 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1095,8 +1095,12 @@ static ssize_t proc_loginuid_write(struct file * file, const char __user * buf,
 	if (!capable(CAP_AUDIT_CONTROL))
 		return -EPERM;
 
-	if (current != pid_task(proc_pid(inode), PIDTYPE_PID))
+	rcu_read_lock();
+	if (current != pid_task(proc_pid(inode), PIDTYPE_PID)) {
+		rcu_read_unlock();
 		return -EPERM;
+	}
+	rcu_read_unlock();
 
 	if (count >= PAGE_SIZE)
 		count = PAGE_SIZE - 1;
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index a2ec74b..144412f 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -57,7 +57,11 @@ struct files_struct {
 	struct file * fd_array[NR_OPEN_DEFAULT];
 };
 
-#define files_fdtable(files) (rcu_dereference((files)->fdt))
+#define files_fdtable(files) \
+	(rcu_dereference_check((files)->fdt, \
+			       rcu_read_lock_held() || \
+			       lockdep_is_held(&(files)->file_lock) || \
+			       atomic_read(&files->count) == 1))
 
 struct file_operations;
 struct vfsmount;
@@ -78,7 +82,7 @@ static inline struct file * fcheck_files(struct files_struct *files, unsigned in
 	struct fdtable *fdt = files_fdtable(files);
 
 	if (fd < fdt->max_fds)
-		file = rcu_dereference(fdt->fd[fd]);
+		file = rcu_dereference_check(fdt->fd[fd], rcu_read_lock_held() || lockdep_is_held(&files->file_lock) || atomic_read(&files->count) == 1);
 	return file;
 }
 
-- 
1.6.6

