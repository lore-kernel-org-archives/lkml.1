Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbYLLP3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbYLLP3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 10:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbYLLP3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 10:29:15 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:57902 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbYLLP3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 10:29:14 -0500
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
       swhiteho@redhat.com, Louis Rilling <louis.rilling@kerlabs.com>
Subject: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and configfs_depend_item()
Date: Fri, 12 Dec 2008 16:29:11 +0100
Message-Id: <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081212100615.GD19128@hawkmoon.kerlabs.com>
References: <20081212100615.GD19128@hawkmoon.kerlabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When attaching default groups (subdirs) of a new group (in mkdir() or
in configfs_register()), configfs recursively takes inode's mutexes
along the path from the parent of the new group to the default
subdirs. This is needed to ensure that the VFS will not race with
operations on these sub-dirs. This is safe for the following reasons:

- the VFS allows one to lock first an inode and second one of its
  children (The lock subclasses for this pattern are respectively
  I_MUTEX_PARENT and I_MUTEX_CHILD);
- from this rule any inode path can be recursively locked in
  descending order as long as it stays under a single mountpoint and
  does not follow symlinks.

Unfortunately lockdep does not know (yet?) how to handle such
recursion.

I've tried to use Peter Zijlstra's lock_set_subclass() helper to
upgrade i_mutexes from I_MUTEX_CHILD to I_MUTEX_PARENT when we know
that we might recursively lock some of their descendant, but this
usage does not seem to fit the purpose of lock_set_subclass() because
it leads to several i_mutex locked with subclass I_MUTEX_PARENT by
the same task.

>From inside configfs it is not possible to serialize those recursive
locking with a top-level one, because mkdir() and rmdir() are already
called with inodes locked by the VFS. So using some
mutex_lock_nest_lock() is not an option.

I am proposing two solutions:
1) one that wraps recursive mutex_lock()s with
   lockdep_off()/lockdep_on().
2) (as suggested earlier by Peter Zijlstra) one that puts the
   i_mutexes recursively locked in different classes based on their
   depth from the top-level config_group created. This
   induces an arbitrary limit (MAX_LOCK_DEPTH - 2 == 46) on the
   nesting of configfs default groups whenever lockdep is activated
   but this limit looks reasonably high. Unfortunately, this alos
   isolates VFS operations on configfs default groups from the others
   and thus lowers the chances to detect locking issues.

This patch implements solution 1).

Solution 2) looks better from lockdep's point of view, but fails with
configfs_depend_item(). This needs to rework the locking
scheme of configfs_depend_item() by removing the variable lock recursion
depth, and I think that it's doable thanks to the configfs_dirent_lock.
For now, let's stick to solution 1).

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 fs/configfs/dir.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 8e93341..9c23583 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -553,12 +553,24 @@ static void detach_groups(struct config_group *group)
 
 		child = sd->s_dentry;
 
+		/*
+		 * Note: we hide this from lockdep since we have no way
+		 * to teach lockdep about recursive
+		 * I_MUTEX_PARENT -> I_MUTEX_CHILD patterns along a path
+		 * in an inode tree, which are valid as soon as
+		 * I_MUTEX_PARENT -> I_MUTEX_CHILD is valid from a
+		 * parent inode to one of its children.
+		 */
+		lockdep_off();
 		mutex_lock(&child->d_inode->i_mutex);
+		lockdep_on();
 
 		configfs_detach_group(sd->s_element);
 		child->d_inode->i_flags |= S_DEAD;
 
+		lockdep_off();
 		mutex_unlock(&child->d_inode->i_mutex);
+		lockdep_on();
 
 		d_delete(child);
 		dput(child);
@@ -748,11 +760,22 @@ static int configfs_attach_item(struct config_item *parent_item,
 			 * We are going to remove an inode and its dentry but
 			 * the VFS may already have hit and used them. Thus,
 			 * we must lock them as rmdir() would.
+			 *
+			 * Note: we hide this from lockdep since we have no way
+			 * to teach lockdep about recursive
+			 * I_MUTEX_PARENT -> I_MUTEX_CHILD patterns along a path
+			 * in an inode tree, which are valid as soon as
+			 * I_MUTEX_PARENT -> I_MUTEX_CHILD is valid from a
+			 * parent inode to one of its children.
 			 */
+			lockdep_off();
 			mutex_lock(&dentry->d_inode->i_mutex);
+			lockdep_on();
 			configfs_remove_dir(item);
 			dentry->d_inode->i_flags |= S_DEAD;
+			lockdep_off();
 			mutex_unlock(&dentry->d_inode->i_mutex);
+			lockdep_on();
 			d_delete(dentry);
 		}
 	}
@@ -787,14 +810,25 @@ static int configfs_attach_group(struct config_item *parent_item,
 		 *
 		 * We must also lock the inode to remove it safely in case of
 		 * error, as rmdir() would.
+		 *
+		 * Note: we hide this from lockdep since we have no way
+		 * to teach lockdep about recursive
+		 * I_MUTEX_PARENT -> I_MUTEX_CHILD patterns along a path
+		 * in an inode tree, which are valid as soon as
+		 * I_MUTEX_PARENT -> I_MUTEX_CHILD is valid from a
+		 * parent inode to one of its children.
 		 */
+		lockdep_off();
 		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
+		lockdep_on();
 		ret = populate_groups(to_config_group(item));
 		if (ret) {
 			configfs_detach_item(item);
 			dentry->d_inode->i_flags |= S_DEAD;
 		}
+		lockdep_off();
 		mutex_unlock(&dentry->d_inode->i_mutex);
+		lockdep_on();
 		if (ret)
 			d_delete(dentry);
 	}
@@ -956,7 +990,17 @@ static int configfs_depend_prep(struct dentry *origin,
 	BUG_ON(!origin || !sd);
 
 	/* Lock this guy on the way down */
+	/*
+	 * Note: we hide this from lockdep since we have no way
+	 * to teach lockdep about recursive
+	 * I_MUTEX_PARENT -> I_MUTEX_CHILD patterns along a path
+	 * in an inode tree, which are valid as soon as
+	 * I_MUTEX_PARENT -> I_MUTEX_CHILD is valid from a
+	 * parent inode to one of its children.
+	 */
+	lockdep_off();
 	mutex_lock(&sd->s_dentry->d_inode->i_mutex);
+	lockdep_on();
 	if (sd->s_element == target)  /* Boo-yah */
 		goto out;
 
@@ -970,7 +1014,9 @@ static int configfs_depend_prep(struct dentry *origin,
 	}
 
 	/* We looped all our children and didn't find target */
+	lockdep_off();
 	mutex_unlock(&sd->s_dentry->d_inode->i_mutex);
+	lockdep_on();
 	ret = -ENOENT;
 
 out:
@@ -990,11 +1036,16 @@ static void configfs_depend_rollback(struct dentry *origin,
 	struct dentry *dentry = item->ci_dentry;
 
 	while (dentry != origin) {
+		/* See comments in configfs_depend_prep() */
+		lockdep_off();
 		mutex_unlock(&dentry->d_inode->i_mutex);
+		lockdep_on();
 		dentry = dentry->d_parent;
 	}
 
+	lockdep_off();
 	mutex_unlock(&origin->d_inode->i_mutex);
+	lockdep_on();
 }
 
 int configfs_depend_item(struct configfs_subsystem *subsys,
@@ -1329,8 +1380,16 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 			}
 
 			/* Wait until the racing operation terminates */
+			/*
+			 * Note: we hide this from lockdep since we are locked
+			 * with subclass I_MUTEX_NORMAL from vfs_rmdir() (why
+			 * not I_MUTEX_CHILD?), and I_MUTEX_XATTR or
+			 * I_MUTEX_QUOTA are not relevant for the locked inode.
+			 */
+			lockdep_off();
 			mutex_lock(wait_mutex);
 			mutex_unlock(wait_mutex);
+			lockdep_on();
 		}
 	} while (ret == -EAGAIN);
 
-- 
1.5.6.5

