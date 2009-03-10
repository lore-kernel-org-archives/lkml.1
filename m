Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZCJSI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZCJSI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZCJSIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:08:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57276 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbZCJSIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:08:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Fix check_unsafe_exec()
To: hugh@veritas.com, jmalicki@metacarta.com, chrisw@sous-sol.org,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
       linux-security-module@vger.kernel.org
Date: Tue, 10 Mar 2009 18:07:40 +0000
Message-ID: <20090310180740.29065.10735.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_unsafe_exec() relies on the usage counts of fs_struct and files_struct to
indicate the subscription count of cloned processes to these structures.  This
is not a viable method, however, as /proc can increment these counts when
merely accessing the data.

The effect of this is to occasionally prevent setuid executables from altering
their security details correctly.

To deal with this, subscription counters are added in addition to the usage
counters to fs_struct and files_struct.

This should hopefully fix:

	http://lkml.org/lkml/2009/2/25/491
	Date: Wed, 25 Feb 2009 18:11:54 -0500 (EST)
	From: Joe Malicki <jmalicki@metacarta.com>
	Subject: BUG: setuid sometimes doesn't.

	Very rarely, we experience a setuid program not properly getting
	the euid of its owner.  This happens with (at least) both Linux 2.6.24.7
	and Linux 2.6.28.4, on multiple machines of at least two configurations
	(Dell 860 and Dell 2950 - cpuinfo attached).
	...

Reported-by: Joe Malicki <jmalicki@metacarta.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/exec.c                 |    4 ++--
 fs/file.c                 |    1 +
 include/linux/fdtable.h   |    4 +++-
 include/linux/fs_struct.h |    7 ++++++-
 kernel/exit.c             |    2 ++
 kernel/fork.c             |    3 +++
 6 files changed, 17 insertions(+), 4 deletions(-)


diff --git a/fs/exec.c b/fs/exec.c
index 929b580..67d7a45 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1069,8 +1069,8 @@ void check_unsafe_exec(struct linux_binprm *bprm, struct files_struct *files)
 		n_sighand++;
 	}
 
-	if (atomic_read(&p->fs->count) > n_fs ||
-	    atomic_read(&p->files->count) > n_files ||
+	if (atomic_read(&p->fs->subscribers) > n_fs ||
+	    atomic_read(&p->files->subscribers) > n_files ||
 	    atomic_read(&p->sighand->count) > n_sighand)
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
 
diff --git a/fs/file.c b/fs/file.c
index f313314..6a33a7a 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -303,6 +303,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 		goto out;
 
 	atomic_set(&newf->count, 1);
+	atomic_set(&newf->subscribers, 1);
 
 	spin_lock_init(&newf->file_lock);
 	newf->next_fd = 0;
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 09d6c5b..12e54bc 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -42,7 +42,9 @@ struct files_struct {
   /*
    * read mostly part
    */
-	atomic_t count;
+	atomic_t count;		/* number of processes accessing this set */
+	atomic_t subscribers;	/* number of cloned processes subscribed to
+				 * this set */
 	struct fdtable *fdt;
 	struct fdtable fdtab;
   /*
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index a97c053..47679c1 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -3,8 +3,13 @@
 
 #include <linux/path.h>
 
+/*
+ * General filesystem access parameter block.
+ */
 struct fs_struct {
-	atomic_t count;
+	atomic_t count;		/* number of processes accessing this block */
+	atomic_t subscribers;	/* number of cloned processes subscribed to
+				 * this block */
 	rwlock_t lock;
 	int umask;
 	struct path root, pwd;
diff --git a/kernel/exit.c b/kernel/exit.c
index efd30cc..57b63bb 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -561,6 +561,7 @@ void exit_files(struct task_struct *tsk)
 		task_lock(tsk);
 		tsk->files = NULL;
 		task_unlock(tsk);
+		atomic_dec(&files->subscribers);
 		put_files_struct(files);
 	}
 }
@@ -583,6 +584,7 @@ void exit_fs(struct task_struct *tsk)
 		task_lock(tsk);
 		tsk->fs = NULL;
 		task_unlock(tsk);
+		atomic_dec(&fs->subscribers);
 		put_fs_struct(fs);
 	}
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index 4854c2c..9d1a2a7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -682,6 +682,7 @@ static struct fs_struct *__copy_fs_struct(struct fs_struct *old)
 	/* We don't need to lock fs - think why ;-) */
 	if (fs) {
 		atomic_set(&fs->count, 1);
+		atomic_set(&fs->subscribers, 1);
 		rwlock_init(&fs->lock);
 		fs->umask = old->umask;
 		read_lock(&old->lock);
@@ -705,6 +706,7 @@ static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
 {
 	if (clone_flags & CLONE_FS) {
 		atomic_inc(&current->fs->count);
+		atomic_inc(&current->fs->subscribers);
 		return 0;
 	}
 	tsk->fs = __copy_fs_struct(current->fs);
@@ -727,6 +729,7 @@ static int copy_files(unsigned long clone_flags, struct task_struct * tsk)
 
 	if (clone_flags & CLONE_FILES) {
 		atomic_inc(&oldf->count);
+		atomic_inc(&oldf->subscribers);
 		goto out;
 	}
 

