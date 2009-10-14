Return-Path: <linux-kernel-owner+w=401wt.eu-S934196AbZJNW0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934196AbZJNW0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934088AbZJNW0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:26:53 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:41890 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933886AbZJNW0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:26:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pCu19VZt0nkmqZc+YUUxYsUva1qs+G3Jr5kMaTdGtVX+1gJlmgr8t2a5aAAite5Hfg
         rTuXQbHh957v4X1Mt3a3u+xwk/QL24+QvCOXESbvUNxQ+ROtaic0l6EVsfuIF9NIHrCA
         lgQj0RK9rRo11ISubQPhXyflmDgDitc1orVDo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Jeff Mahoney <jeffm@suse.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] kill-the-bkl/reiserfs: always lock the ioctl path
Date: Thu, 15 Oct 2009 00:26:05 +0200
Message-Id: <1255559167-5554-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255559167-5554-1-git-send-email-fweisbec@gmail.com>
References: <1255559167-5554-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reiserfs uses the ioctl callback for its file operations, which means
that its ioctl path is still locked by the bkl, this was synchronizing
with the rest of the filsystem operations. We have changed that by
locking it with the new reiserfs lock but we do that only from the
compat_ioctl callback.

Fix that by locking reiserfs_ioctl() everytime.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 fs/reiserfs/ioctl.c |   66 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 39 insertions(+), 27 deletions(-)

diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index 5e40b0c..e30e8be 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -13,44 +13,52 @@
 #include <linux/compat.h>
 
 /*
-** reiserfs_ioctl - handler for ioctl for inode
-** supported commands:
-**  1) REISERFS_IOC_UNPACK - try to unpack tail from direct item into indirect
-**                           and prevent packing file (argument arg has to be non-zero)
-**  2) REISERFS_IOC_[GS]ETFLAGS, REISERFS_IOC_[GS]ETVERSION
-**  3) That's all for a while ...
-*/
+ * reiserfs_ioctl - handler for ioctl for inode
+ * supported commands:
+ *  1) REISERFS_IOC_UNPACK - try to unpack tail from direct item into indirect
+ *                           and prevent packing file (argument arg has to be non-zero)
+ *  2) REISERFS_IOC_[GS]ETFLAGS, REISERFS_IOC_[GS]ETVERSION
+ *  3) That's all for a while ...
+ */
 int reiserfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		   unsigned long arg)
 {
 	unsigned int flags;
 	int err = 0;
 
+	reiserfs_write_lock(inode->i_sb);
+
 	switch (cmd) {
 	case REISERFS_IOC_UNPACK:
 		if (S_ISREG(inode->i_mode)) {
 			if (arg)
-				return reiserfs_unpack(inode, filp);
-			else
-				return 0;
+				err = reiserfs_unpack(inode, filp);
 		} else
-			return -ENOTTY;
-		/* following two cases are taken from fs/ext2/ioctl.c by Remy
-		   Card (card@masi.ibp.fr) */
+			err = -ENOTTY;
+		break;
+		/*
+		 * following two cases are taken from fs/ext2/ioctl.c by Remy
+		 * Card (card@masi.ibp.fr)
+		 */
 	case REISERFS_IOC_GETFLAGS:
-		if (!reiserfs_attrs(inode->i_sb))
-			return -ENOTTY;
+		if (!reiserfs_attrs(inode->i_sb)) {
+			err = -ENOTTY;
+			break;
+		}
 
 		flags = REISERFS_I(inode)->i_attrs;
 		i_attrs_to_sd_attrs(inode, (__u16 *) & flags);
-		return put_user(flags, (int __user *)arg);
+		err = put_user(flags, (int __user *)arg);
+		break;
 	case REISERFS_IOC_SETFLAGS:{
-			if (!reiserfs_attrs(inode->i_sb))
-				return -ENOTTY;
+			if (!reiserfs_attrs(inode->i_sb)) {
+				err = -ENOTTY;
+				break;
+			}
 
 			err = mnt_want_write(filp->f_path.mnt);
 			if (err)
-				return err;
+				break;
 
 			if (!is_owner_or_cap(inode)) {
 				err = -EPERM;
@@ -90,16 +98,18 @@ int reiserfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			mark_inode_dirty(inode);
 setflags_out:
 			mnt_drop_write(filp->f_path.mnt);
-			return err;
+			break;
 		}
 	case REISERFS_IOC_GETVERSION:
-		return put_user(inode->i_generation, (int __user *)arg);
+		err = put_user(inode->i_generation, (int __user *)arg);
+		break;
 	case REISERFS_IOC_SETVERSION:
 		if (!is_owner_or_cap(inode))
-			return -EPERM;
+			err = -EPERM;
+			break;
 		err = mnt_want_write(filp->f_path.mnt);
 		if (err)
-			return err;
+			break;
 		if (get_user(inode->i_generation, (int __user *)arg)) {
 			err = -EFAULT;
 			goto setversion_out;
@@ -108,10 +118,14 @@ setflags_out:
 		mark_inode_dirty(inode);
 setversion_out:
 		mnt_drop_write(filp->f_path.mnt);
-		return err;
+		break;
 	default:
-		return -ENOTTY;
+		err = -ENOTTY;
 	}
+
+	reiserfs_write_unlock(inode->i_sb);
+
+	return err;
 }
 
 #ifdef CONFIG_COMPAT
@@ -142,9 +156,7 @@ long reiserfs_compat_ioctl(struct file *file, unsigned int cmd,
 		return -ENOIOCTLCMD;
 	}
 
-	reiserfs_write_lock(inode->i_sb);
 	ret = reiserfs_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
-	reiserfs_write_unlock(inode->i_sb);
 
 	return ret;
 }
-- 
1.6.2.3

