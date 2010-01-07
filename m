Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823Ab0AGPc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab0AGPc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403Ab0AGPc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:32:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44153 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0AGPc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:32:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=twfyEzrW/E+I2Y2b9KNIQUqYDuT4SplJuBwioAH2JzhZj+k7rV3Pof3O15XETrIVrm
         bYv7rA6o23iBbIysbcL8RiuzwEypIctVRzDdPNC/FKuu5Dgp8mcTmvj9dLMOb4kC0V02
         pTKPPW9WXFGO9wxiA9gbMCkddNfN3Sl2MdnGY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Jiri Slaby <jslaby@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: [GIT PULL] reiserfs fixes for -rc3
Date: Thu,  7 Jan 2010 16:32:21 +0100
Message-Id: <1262878341-4541-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the reiserfs/kill-bkl branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-bkl

These mostly fix xattr lock inversions/softlockups enlighted by stress
testing with xfs test suite, plus a fix on an ioctl that wasn't working.

Thanks,
	Frederic
---

Frederic Weisbecker (6):
      reiserfs: Fix mistake in down_write() conversion
      reiserfs: Fix recursive lock on lchown
      reiserfs: Relax the lock before truncating pages
      reiserfs: Relax lock on xattr removing
      reiserfs: Don't call reiserfs_get_acl() with the reiserfs lock
      reiserfs: Relax reiserfs_xattr_set_handle() while acquiring xattr locks

Jiri Slaby (1):
      reiserfs: Fix unreachable statement


 fs/reiserfs/inode.c     |   19 +++++++++++++++----
 fs/reiserfs/ioctl.c     |    3 ++-
 fs/reiserfs/xattr.c     |   18 ++++++++++++++----
 fs/reiserfs/xattr_acl.c |    2 ++
 4 files changed, 33 insertions(+), 9 deletions(-)

---

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index bd615df..c876341 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3052,13 +3052,14 @@ static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
 int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
-	int error;
 	unsigned int ia_valid;
+	int depth;
+	int error;
 
 	/* must be turned off for recursive notify_change calls */
 	ia_valid = attr->ia_valid &= ~(ATTR_KILL_SUID|ATTR_KILL_SGID);
 
-	reiserfs_write_lock(inode->i_sb);
+	depth = reiserfs_write_lock_once(inode->i_sb);
 	if (attr->ia_valid & ATTR_SIZE) {
 		/* version 2 items will be caught by the s_maxbytes check
 		 ** done for us in vmtruncate
@@ -3139,8 +3140,17 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 				    journal_end(&th, inode->i_sb, jbegin_count);
 			}
 		}
-		if (!error)
+		if (!error) {
+			/*
+			 * Relax the lock here, as it might truncate the
+			 * inode pages and wait for inode pages locks.
+			 * To release such page lock, the owner needs the
+			 * reiserfs lock
+			 */
+			reiserfs_write_unlock_once(inode->i_sb, depth);
 			error = inode_setattr(inode, attr);
+			depth = reiserfs_write_lock_once(inode->i_sb);
+		}
 	}
 
 	if (!error && reiserfs_posixacl(inode->i_sb)) {
@@ -3149,7 +3159,8 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
       out:
-	reiserfs_write_unlock(inode->i_sb);
+	reiserfs_write_unlock_once(inode->i_sb, depth);
+
 	return error;
 }
 
diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index ace7745..f53505d 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -104,9 +104,10 @@ setflags_out:
 		err = put_user(inode->i_generation, (int __user *)arg);
 		break;
 	case REISERFS_IOC_SETVERSION:
-		if (!is_owner_or_cap(inode))
+		if (!is_owner_or_cap(inode)) {
 			err = -EPERM;
 			break;
+		}
 		err = mnt_want_write(filp->f_path.mnt);
 		if (err)
 			break;
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 9623cfe..7fee995 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -451,7 +451,9 @@ static int lookup_and_delete_xattr(struct inode *inode, const char *name)
 	}
 
 	if (dentry->d_inode) {
+		reiserfs_write_lock(inode->i_sb);
 		err = xattr_unlink(xadir->d_inode, dentry);
+		reiserfs_write_unlock(inode->i_sb);
 		update_ctime(inode);
 	}
 
@@ -485,17 +487,21 @@ reiserfs_xattr_set_handle(struct reiserfs_transaction_handle *th,
 	if (get_inode_sd_version(inode) == STAT_DATA_V1)
 		return -EOPNOTSUPP;
 
-	if (!buffer)
-		return lookup_and_delete_xattr(inode, name);
-
 	reiserfs_write_unlock(inode->i_sb);
+
+	if (!buffer) {
+		err = lookup_and_delete_xattr(inode, name);
+		reiserfs_write_lock(inode->i_sb);
+		return err;
+	}
+
 	dentry = xattr_lookup(inode, name, flags);
 	if (IS_ERR(dentry)) {
 		reiserfs_write_lock(inode->i_sb);
 		return PTR_ERR(dentry);
 	}
 
-	down_read(&REISERFS_I(inode)->i_xattr_sem);
+	down_write(&REISERFS_I(inode)->i_xattr_sem);
 
 	reiserfs_write_lock(inode->i_sb);
 
@@ -553,8 +559,12 @@ reiserfs_xattr_set_handle(struct reiserfs_transaction_handle *th,
 			.ia_size = buffer_size,
 			.ia_valid = ATTR_SIZE | ATTR_CTIME,
 		};
+
+		reiserfs_write_unlock(inode->i_sb);
 		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_XATTR);
 		down_write(&dentry->d_inode->i_alloc_sem);
+		reiserfs_write_lock(inode->i_sb);
+
 		err = reiserfs_setattr(dentry, &newattrs);
 		up_write(&dentry->d_inode->i_alloc_sem);
 		mutex_unlock(&dentry->d_inode->i_mutex);
diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index 35d6e67..f559c9e 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -452,7 +452,9 @@ int reiserfs_acl_chmod(struct inode *inode)
 		return 0;
 	}
 
+	reiserfs_write_unlock(inode->i_sb);
 	acl = reiserfs_get_acl(inode, ACL_TYPE_ACCESS);
+	reiserfs_write_lock(inode->i_sb);
 	if (!acl)
 		return 0;
 	if (IS_ERR(acl))
