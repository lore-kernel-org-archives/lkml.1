Return-Path: <linux-kernel-owner+w=401wt.eu-S1762440AbZARIHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762440AbZARIHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 03:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762704AbZARIGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 03:06:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53657 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1761632AbZARIGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 03:06:39 -0500
Message-ID: <4972E2FD.1010902@cn.fujitsu.com>
Date: Sun, 18 Jan 2009 16:06:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: menage@google.com, miaox@cn.fujitsu.com, maxk@qualcomm.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] cgroup: convert open-coded mutex_lock(&cgroup_mutex)
 calls into cgroup_lock() calls
References: <496FEFCA.9050908@cn.fujitsu.com>	<4970000E.7040902@cn.fujitsu.com> <20090116125738.22c21bf2.akpm@linux-foundation.org>
In-Reply-To: <20090116125738.22c21bf2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Convert open-coded mutex_lock(&cgroup_mutex) calls into cgroup_lock()
calls and convert mutex_unlock(&cgroup_mutex) calls into cgroup_unlock()
calls.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c298310..75a352b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -616,7 +688,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		 * agent */
 		synchronize_rcu();
 
-		mutex_lock(&cgroup_mutex);
+		cgroup_lock();
 		/*
 		 * Release the subsystem state objects.
 		 */
@@ -624,7 +696,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 			ss->destroy(ss, cgrp);
 
 		cgrp->root->number_of_cgroups--;
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 
 		/*
 		 * Drop the active superblock reference that we took when we
@@ -761,14 +833,14 @@ static int cgroup_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	struct cgroupfs_root *root = vfs->mnt_sb->s_fs_info;
 	struct cgroup_subsys *ss;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	for_each_subsys(root, ss)
 		seq_printf(seq, ",%s", ss->name);
 	if (test_bit(ROOT_NOPREFIX, &root->flags))
 		seq_puts(seq, ",noprefix");
 	if (strlen(root->release_agent_path))
 		seq_printf(seq, ",release_agent=%s", root->release_agent_path);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return 0;
 }
 
@@ -843,7 +915,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	struct cgroup_sb_opts opts;
 
 	mutex_lock(&cgrp->dentry->d_inode->i_mutex);
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	/* See what subsystems are wanted */
 	ret = parse_cgroupfs_options(data, &opts);
@@ -867,7 +939,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
  out_unlock:
 	if (opts.release_agent)
 		kfree(opts.release_agent);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
 	return ret;
 }
@@ -1015,7 +1087,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 		inode = sb->s_root->d_inode;
 
 		mutex_lock(&inode->i_mutex);
-		mutex_lock(&cgroup_mutex);
+		cgroup_lock();
 
 		/*
 		 * We're accessing css_set_count without locking
@@ -1026,14 +1098,14 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 		 */
 		ret = allocate_cg_links(css_set_count, &tmp_cg_links);
 		if (ret) {
-			mutex_unlock(&cgroup_mutex);
+			cgroup_unlock();
 			mutex_unlock(&inode->i_mutex);
 			goto drop_new_super;
 		}
 
 		ret = rebind_subsystems(root, root->subsys_bits);
 		if (ret == -EBUSY) {
-			mutex_unlock(&cgroup_mutex);
+			cgroup_unlock();
 			mutex_unlock(&inode->i_mutex);
 			goto free_cg_links;
 		}
@@ -1068,7 +1140,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 
 		cgroup_populate_dir(root_cgrp);
 		mutex_unlock(&inode->i_mutex);
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 	}
 
 	return simple_set_mnt(mnt, sb);
@@ -1094,7 +1166,7 @@ static void cgroup_kill_sb(struct super_block *sb) {
 	BUG_ON(!list_empty(&cgrp->children));
 	BUG_ON(!list_empty(&cgrp->sibling));
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	/* Rebind all subsystems back to the default hierarchy */
 	ret = rebind_subsystems(root, 0);
@@ -1118,7 +1190,7 @@ static void cgroup_kill_sb(struct super_block *sb) {
 	list_del(&root->root_list);
 	root_count--;
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	kfree(root);
 	kill_litter_super(sb);
@@ -2392,7 +2464,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	 * fs */
 	atomic_inc(&sb->s_active);
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	init_cgroup_housekeeping(cgrp);
 
@@ -2427,7 +2499,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	err = cgroup_populate_dir(cgrp);
 	/* If err < 0, we have a half-filled directory - oh well ;) */
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
 
 	return 0;
@@ -2444,7 +2516,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 			ss->destroy(ss, cgrp);
 	}
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	/* Release the reference count that we took on the superblock */
 	deactivate_super(sb);
@@ -2550,16 +2622,16 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 
 	/* the vfs holds both inode->i_mutex already */
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	if (atomic_read(&cgrp->count) != 0) {
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		return -EBUSY;
 	}
 	if (!list_empty(&cgrp->children)) {
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		return -EBUSY;
 	}
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	/*
 	 * Call pre_destroy handlers of subsys. Notify subsystems
@@ -2567,13 +2639,13 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 	 */
 	cgroup_call_pre_destroy(cgrp);
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	parent = cgrp->parent;
 
 	if (atomic_read(&cgrp->count)
 	    || !list_empty(&cgrp->children)
 	    || !cgroup_clear_css_refs(cgrp)) {
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		return -EBUSY;
 	}
 
@@ -2598,7 +2670,7 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 	set_bit(CGRP_RELEASABLE, &parent->flags);
 	check_for_release(parent);
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return 0;
 }
 
@@ -2752,7 +2824,7 @@ static int proc_cgroup_show(struct seq_file *m, void *v)
 
 	retval = 0;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	for_each_active_root(root) {
 		struct cgroup_subsys *ss;
@@ -2774,7 +2846,7 @@ static int proc_cgroup_show(struct seq_file *m, void *v)
 	}
 
 out_unlock:
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	put_task_struct(tsk);
 out_free:
 	kfree(buf);
@@ -2801,14 +2873,14 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 	int i;
 
 	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
 		seq_printf(m, "%s\t%lu\t%d\t%d\n",
 			   ss->name, ss->root->subsys_bits,
 			   ss->root->number_of_cgroups, !ss->disabled);
 	}
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return 0;
 }
 
@@ -2984,11 +3056,11 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 
 	/* First figure out what hierarchy and cgroup we're dealing
 	 * with, and pin them so we can drop cgroup_mutex */
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
  again:
 	root = subsys->root;
 	if (root == &rootnode) {
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		return 0;
 	}
 	task_lock(tsk);
@@ -2998,14 +3070,14 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 	/* Pin the hierarchy */
 	if (!atomic_inc_not_zero(&parent->root->sb->s_active)) {
 		/* We race with the final deactivate_super() */
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		return 0;
 	}
 
 	/* Keep the cgroup alive */
 	get_css_set(cg);
 	task_unlock(tsk);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	/* Now do the VFS work to create a cgroup */
 	inode = parent->dentry->d_inode;
@@ -3036,7 +3108,7 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 	/* The cgroup now exists. Retake cgroup_mutex and check
 	 * that we're still in the same state that we thought we
 	 * were. */
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	if ((root != subsys->root) ||
 	    (parent != task_cgroup(tsk, subsys->subsys_id))) {
 		/* Aargh, we raced ... */
@@ -3061,14 +3133,14 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 
 	/* All seems fine. Finish by moving the task into the new cgroup */
 	ret = cgroup_attach_task(child, tsk);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
  out_release:
 	mutex_unlock(&inode->i_mutex);
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	put_css_set(cg);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	deactivate_super(parent->root->sb);
 	return ret;
 }
@@ -3162,7 +3234,7 @@ void __css_put(struct cgroup_subsys_state *css)
 static void cgroup_release_agent(struct work_struct *work)
 {
 	BUG_ON(work != &release_agent_work);
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	spin_lock(&release_list_lock);
 	while (!list_empty(&release_list)) {
 		char *argv[3], *envp[3];
@@ -3196,16 +3268,16 @@ static void cgroup_release_agent(struct work_struct *work)
 		/* Drop the lock while we invoke the usermode helper,
 		 * since the exec could involve hitting disk and hence
 		 * be a slow process */
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
-		mutex_lock(&cgroup_mutex);
+		cgroup_lock();
  continue_free:
 		kfree(pathbuf);
 		kfree(agentbuf);
 		spin_lock(&release_list_lock);
 	}
 	spin_unlock(&release_list_lock);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 }
 
 static int __init cgroup_disable(char *str)



