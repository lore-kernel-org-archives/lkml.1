Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbZEFWJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbZEFWJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761503AbZEFVyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:54 -0400
Received: from kroah.org ([198.145.64.141]:57239 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761454AbZEFVyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:49 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:00 2009
Message-Id: <20090506214800.136205337@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
Subject: [patch 35/58] fix setuid sometimes wouldnt
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=fix-setuid-sometimes-wouldn-t.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hugh@veritas.com>

commit 7c2c7d993044cddc5010f6f429b100c63bc7dffb upstream.

check_unsafe_exec() also notes whether the fs_struct is being
shared by more threads than will get killed by the exec, and if so
sets LSM_UNSAFE_SHARE to make bprm_set_creds() careful about euid.
But /proc/<pid>/cwd and /proc/<pid>/root lookups make transient
use of get_fs_struct(), which also raises that sharing count.

This might occasionally cause a setuid program not to change euid,
in the same way as happened with files->count (check_unsafe_exec
also looks at sighand->count, but /proc doesn't raise that one).

We'd prefer exec not to unshare fs_struct: so fix this in procfs,
replacing get_fs_struct() by get_fs_path(), which does path_get
while still holding task_lock, instead of raising fs->count.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/base.c |   50 ++++++++++++++++----------------------------------
 1 file changed, 16 insertions(+), 34 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -146,15 +146,22 @@ static unsigned int pid_entry_count_dirs
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
@@ -172,42 +179,24 @@ static int get_nr_threads(struct task_st
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
 
@@ -596,7 +585,6 @@ static int mounts_open_common(struct ino
 	struct task_struct *task = get_proc_task(inode);
 	struct nsproxy *nsp;
 	struct mnt_namespace *ns = NULL;
-	struct fs_struct *fs = NULL;
 	struct path root;
 	struct proc_mounts *p;
 	int ret = -EINVAL;
@@ -610,22 +598,16 @@ static int mounts_open_common(struct ino
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


