Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbZBZQHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbZBZQHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZBZQHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:07:45 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34581 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbZBZQHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:07:44 -0500
Date: Thu, 26 Feb 2009 16:06:38 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Joe Malicki <jmalicki@metacarta.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Kenneth Baker <bakerkj@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG: setuid sometimes doesn't.
In-Reply-To: <18521844.9754741235649981642.JavaMail.root@ouachita>
Message-ID: <Pine.LNX.4.64.0902261553510.12173@blonde.anvils>
References: <18521844.9754741235649981642.JavaMail.root@ouachita>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009, Joe Malicki wrote:
> ----- "Joe Malicki" <jmalicki@metacarta.com> wrote:
> 
> > Very rarely, we experience a setuid program not properly getting
> > the euid of its owner.
> > 
> > Thus far, we have only seen failures for the program being setuid
> > root, being run by a non-root user, on a multi-core machine.  Trying
> > to
> > setuid to a user from root, *or* booting with maxcpus=1 and trying to
> > setuid from a non-root user to root, both fail.
> 
> Sorry, misstated that.
> 
> setuid from nonroot->root, or with maxcpus=1, always seems to work.
> 
> Only multiple cores with setuid to root has failed for us.

Here's a shot in the dark: I may be misreading things, and I don't
quite see how it fits with the finer details you mention here; but
it looks to me as if /proc/*/cwd and /proc/*/root lookup interferes
with the fs->count check in fs/exec.c's unsafe_exec().

If you would, please give this patch against 2.6.28* a try (applies
to 2.6.29-rc too, but not to 2.6.24*), to see if it makes any
difference to you.  I'm hoping not to hear from you for a while!

(I assume it's okay to read_lock fs->lock while holding task_lock:
I didn't see anywhere else doing so, but lockdep hasn't objected yet.)

Hugh

--- 2.6.28/fs/proc/base.c	2008-12-24 23:26:37.000000000 +0000
+++ linux/fs/proc/base.c	2009-02-26 15:39:00.000000000 +0000
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
