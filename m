Return-Path: <linux-kernel-owner+w=401wt.eu-S1764941AbZD3RpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764941AbZD3RpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764741AbZD3RIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:46 -0400
Received: from kroah.org ([198.145.64.141]:56956 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764702AbZD3RI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:50 2009
Message-Id: <20090430165750.307931445@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:57:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Chris Wright <chrisw@sous-sol.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hugh Dickins <hugh@veritas.com>
Subject: [patch 81/88] fs core fixes
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=fs-core-fixes.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hugh@veritas.com>

Please add the following 4 commits to 2.6.27-stable and 2.6.28-stable.
However, there has been a lot of change here between 2.6.28 and 2.6.29:
in particular, fs/exec.c's unsafe_exec() grew into the more complicated
check_unsafe_exec().  So applying the original patches gives too many
rejects: at the bottom is the diffstat and the combined patch required.

1
Commit: 53e9309e01277ec99c38e84e0ca16921287cf470
Author: Hugh Dickins <hugh@veritas.com>
Date: Sat, 28 Mar 2009 23:16:03 +0000 (+0000)
Subject: [patch 81/88] compat_do_execve should unshare_files

2
Commit: e426b64c412aaa3e9eb3e4b261dc5be0d5a83e78
Author: Hugh Dickins <hugh@veritas.com>
Date: Sat, 28 Mar 2009 23:20:19 +0000 (+0000)
Subject: [patch 81/88] fix setuid sometimes doesn't

3
Commit: 7c2c7d993044cddc5010f6f429b100c63bc7dffb
Author: Hugh Dickins <hugh@veritas.com>
Date: Sat, 28 Mar 2009 23:21:27 +0000 (+0000)
Subject: [patch 81/88] fix setuid sometimes wouldn't

4
Commit: f1191b50ec11c8e2ca766d6d99eb5bb9d2c084a3
Author: Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 30 Mar 2009 11:35:18 +0000 (-0400)
Subject: [patch 81/88] check_unsafe_exec() doesn't care about signal handlers sharing

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/compat.c    |   12 +++++++++++-
 fs/exec.c      |    4 +---
 fs/proc/base.c |   50 ++++++++++++++++----------------------------------
 3 files changed, 28 insertions(+), 38 deletions(-)

--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1386,12 +1386,17 @@ int compat_do_execve(char * filename,
 {
 	struct linux_binprm *bprm;
 	struct file *file;
+	struct files_struct *displaced;
 	int retval;
 
+	retval = unshare_files(&displaced);
+	if (retval)
+		goto out_ret;
+
 	retval = -ENOMEM;
 	bprm = kzalloc(sizeof(*bprm), GFP_KERNEL);
 	if (!bprm)
-		goto out_ret;
+		goto out_files;
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
@@ -1443,6 +1448,8 @@ int compat_do_execve(char * filename,
 		security_bprm_free(bprm);
 		acct_update_integrals(current);
 		free_bprm(bprm);
+		if (displaced)
+			put_files_struct(displaced);
 		return retval;
 	}
 
@@ -1463,6 +1470,9 @@ out_file:
 out_kfree:
 	free_bprm(bprm);
 
+out_files:
+	if (displaced)
+		reset_files_struct(displaced);
 out_ret:
 	return retval;
 }
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1084,9 +1084,7 @@ static int unsafe_exec(struct task_struc
 {
 	int unsafe = tracehook_unsafe_exec(p);
 
-	if (atomic_read(&p->fs->count) > 1 ||
-	    atomic_read(&p->files->count) > 1 ||
-	    atomic_read(&p->sighand->count) > 1)
+	if (atomic_read(&p->fs->count) > 1)
 		unsafe |= LSM_UNSAFE_SHARE;
 
 	return unsafe;
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -148,15 +148,22 @@ static unsigned int pid_entry_count_dirs
 	return count;
 }
 
-static struct fs_struct *get_fs_struct(struct task_struct *task)
+static int get_fs_path(struct task_struct *task, struct path *path, bool root)
 {
 	struct fs_struct *fs;
+	int result = -ENOENT;
+
 	task_lock(task);
 	fs = task->fs;
-	if(fs)
-		atomic_inc(&fs->count);
+	if (fs) {
+		read_lock(&fs->lock);
+		*path = root ? fs->root : fs->pwd;
+		path_get(path);
+		read_unlock(&fs->lock);
+		result = 0;
+	}
 	task_unlock(task);
-	return fs;
+	return result;
 }
 
 static int get_nr_threads(struct task_struct *tsk)
@@ -174,42 +181,24 @@ static int get_nr_threads(struct task_st
 static int proc_cwd_link(struct inode *inode, struct path *path)
 {
 	struct task_struct *task = get_proc_task(inode);
-	struct fs_struct *fs = NULL;
 	int result = -ENOENT;
 
 	if (task) {
-		fs = get_fs_struct(task);
+		result = get_fs_path(task, path, 0);
 		put_task_struct(task);
 	}
-	if (fs) {
-		read_lock(&fs->lock);
-		*path = fs->pwd;
-		path_get(&fs->pwd);
-		read_unlock(&fs->lock);
-		result = 0;
-		put_fs_struct(fs);
-	}
 	return result;
 }
 
 static int proc_root_link(struct inode *inode, struct path *path)
 {
 	struct task_struct *task = get_proc_task(inode);
-	struct fs_struct *fs = NULL;
 	int result = -ENOENT;
 
 	if (task) {
-		fs = get_fs_struct(task);
+		result = get_fs_path(task, path, 1);
 		put_task_struct(task);
 	}
-	if (fs) {
-		read_lock(&fs->lock);
-		*path = fs->root;
-		path_get(&fs->root);
-		read_unlock(&fs->lock);
-		result = 0;
-		put_fs_struct(fs);
-	}
 	return result;
 }
 
@@ -567,7 +556,6 @@ static int mounts_open_common(struct ino
 	struct task_struct *task = get_proc_task(inode);
 	struct nsproxy *nsp;
 	struct mnt_namespace *ns = NULL;
-	struct fs_struct *fs = NULL;
 	struct path root;
 	struct proc_mounts *p;
 	int ret = -EINVAL;
@@ -581,22 +569,16 @@ static int mounts_open_common(struct ino
 				get_mnt_ns(ns);
 		}
 		rcu_read_unlock();
-		if (ns)
-			fs = get_fs_struct(task);
+		if (ns && get_fs_path(task, &root, 1) == 0)
+			ret = 0;
 		put_task_struct(task);
 	}
 
 	if (!ns)
 		goto err;
-	if (!fs)
+	if (ret)
 		goto err_put_ns;
 
-	read_lock(&fs->lock);
-	root = fs->root;
-	path_get(&root);
-	read_unlock(&fs->lock);
-	put_fs_struct(fs);
-
 	ret = -ENOMEM;
 	p = kmalloc(sizeof(struct proc_mounts), GFP_KERNEL);
 	if (!p)


