Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZCJXle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZCJXle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 19:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbZCJXlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 19:41:24 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42712 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbZCJXlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 19:41:23 -0400
Date: Tue, 10 Mar 2009 23:40:21 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: David Howells <dhowells@redhat.com>
cc: jmalicki@metacarta.com, chrisw@sous-sol.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix check_unsafe_exec()
In-Reply-To: <6503.1236726067@redhat.com>
Message-ID: <Pine.LNX.4.64.0903102329020.8584@blonde.anvils>
References: <Pine.LNX.4.64.0903102105590.21727@blonde.anvils>
 <20090310180740.29065.10735.stgit@warthog.procyon.org.uk> <6503.1236726067@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, David Howells wrote:
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > Surely we'd prefer to avoid the overhead of additional confusing
> > counts if they can be avoided?
> 
> As long as they are properly commented, it shouldn't be too confusing.

I'd rather have one count that doesn't need commenting
to distinguish from it another: I believe we all would.

> 
> > We already have what I think is a satisfactory patch for the struct fs
> > part of it:
> 
> We do?

We do.  See the original thread.  It's here at
http://lkml.org/lkml/2009/2/26/233
and appended below for convenience.  We do know that patch did not
fix Joe's problem, and we don't yet know whether addressing the
files->count issue will actually fix it, but I'm hopeful.

> 
> > /proc can easily manage root and pwd while holding the lock
> > instead of raising fs->count.
> 
> I'm assume you mean by extending the time we hold task->alloc_lock until we've
> completed the path_get().

Yep.

> 
> > I don't understand why check_unsafe_exec() needs to check
> > current->files->count at all, since do_execve() has already
> > done an unshare_files() to get its own copy - and proceeds with
> > that one if the exec succeeds.
> > 
> > My belief is that the files->count check could/should have been
> > removed when that unshare_files() was put in.  Please explain why
> > I'm wrong on that - I can quite accept that I'm muddled about it,
> > but please do explain it to me.
> 
> It seems you're right about that.  I think someone else on the security list
> probably needs to answer that.

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
