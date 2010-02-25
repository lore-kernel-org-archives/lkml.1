Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab0BYKMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:12:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:40864 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758944Ab0BYKMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:12:42 -0500
Date: Thu, 25 Feb 2010 10:11:40 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, mingo@elte.hu
In-Reply-To: <1266887105-1528-8-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-8-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] vfs: Apply lockdep-based checking to rcu_dereference() uses
Message-ID: <tip-7dc52157982ab771f40e3c0b7dc55b954c3c2d19@git.kernel.org>
Git-Commit-ID: 7dc52157982ab771f40e3c0b7dc55b954c3c2d19
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:11:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7dc52157982ab771f40e3c0b7dc55b954c3c2d19
Gitweb:     http://git.kernel.org/tip/7dc52157982ab771f40e3c0b7dc55b954c3c2d19
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 22 Feb 2010 17:04:52 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 10:34:48 +0100

vfs: Apply lockdep-based checking to rcu_dereference() uses

Add lockdep-ified RCU primitives to alloc_fd(), files_fdtable()
and fcheck_files().

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
LKML-Reference: <1266887105-1528-8-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 58324c2..623e2ff 100644
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
 
