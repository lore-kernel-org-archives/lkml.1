Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYJAVBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYJAVBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYJAVBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:01:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:47142 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbYJAVBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:01:03 -0400
Subject: patch sysfs-use-ilookup5-instead-of-ilookup5_nowait.patch added to gregkh-2.6 tree
To: tj@kernel.org, gregkh@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org, viro@hera.kernel.org
From: <gregkh@suse.de>
Date: Wed, 01 Oct 2008 13:56:35 -0700
In-Reply-To: <48DEB828.3020408@kernel.org>
Message-ID: <1222894595646@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: sysfs: use ilookup5() instead of ilookup5_nowait()

to my gregkh-2.6 tree.  Its filename is

    sysfs-use-ilookup5-instead-of-ilookup5_nowait.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From tj@kernel.org  Wed Oct  1 13:34:14 2008
From: Tejun Heo <tj@kernel.org>
Date: Sun, 28 Sep 2008 07:48:08 +0900
Subject: sysfs: use ilookup5() instead of ilookup5_nowait()
To: Greg KH <greg@kroah.com>, viro@hera.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <48DEB828.3020408@kernel.org>

From: Tejun Heo <tj@kernel.org>

As inode creation is protected by sysfs_mutex, ilookup5_nowait()
always either fails to find at all or finds one which is fully
initialized, so using ilookup5_nowait() or ilookup5() doesn't make any
difference.  Switch to ilookup5() as it's planned to be removed.  This
change also makes lookup return value handling a bit simpler.

This change was suggested by Al Viro.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@hera.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/sysfs/dir.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -370,17 +370,17 @@ void sysfs_addrm_start(struct sysfs_addr
 	memset(acxt, 0, sizeof(*acxt));
 	acxt->parent_sd = parent_sd;
 
-	/* Lookup parent inode.  inode initialization and I_NEW
-	 * clearing are protected by sysfs_mutex.  By grabbing it and
-	 * looking up with _nowait variant, inode state can be
-	 * determined reliably.
+	/* Lookup parent inode.  inode initialization is protected by
+	 * sysfs_mutex, so inode existence can be determined by
+	 * looking up inode while holding sysfs_mutex.
 	 */
 	mutex_lock(&sysfs_mutex);
 
-	inode = ilookup5_nowait(sysfs_sb, parent_sd->s_ino, sysfs_ilookup_test,
-				parent_sd);
+	inode = ilookup5(sysfs_sb, parent_sd->s_ino, sysfs_ilookup_test,
+			 parent_sd);
+	if (inode) {
+		WARN_ON(inode->i_state & I_NEW);
 
-	if (inode && !(inode->i_state & I_NEW)) {
 		/* parent inode available */
 		acxt->parent_inode = inode;
 
@@ -393,8 +393,7 @@ void sysfs_addrm_start(struct sysfs_addr
 			mutex_lock(&inode->i_mutex);
 			mutex_lock(&sysfs_mutex);
 		}
-	} else
-		iput(inode);
+	}
 }
 
 /**


Patches currently in gregkh-2.6 which might be from tj@kernel.org are

driver-core/sysfs-support-sysfs_notify-from-atomic-context-with-new-sysfs_notify_dirent.patch
driver-core/driver-core-use-klist-for-class-device-list-and-implement-iterator.patch
driver-core/klist-don-t-iterate-over-deleted-entries.patch
driver-core/kobject-cleanup-kobject_rename-and-config_sysfs.patch
driver-core/sysfs-implement-__sysfs_get_dentry.patch
driver-core/sysfs-introduce-sysfs_sd_setattr-and-fix-sysfs_chmod.patch
driver-core/sysfs-sysfs_get_dentry-add-a-sb-parameter.patch
driver-core/sysfs-rename-support-multiple-superblocks.patch
driver-core/sysfs-support-for-preventing-unmounts.patch
driver-core/sysfs-sysfs_chmod_file-handle-multiple-superblocks.patch
driver-core/sysfs-implement-sysfs_delete_link-and-sysfs_rename_link.patch
driver-core/sysfs-use-ilookup5-instead-of-ilookup5_nowait.patch
