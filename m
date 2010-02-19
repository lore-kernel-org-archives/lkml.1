Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab0BSRE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:04:28 -0500
Received: from kroah.org ([198.145.64.141]:57838 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080Ab0BSRBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:15 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:55 2010
Message-Id: <20100219163254.864064364@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>, Tim Gardner <timg@tpi.com>
Subject: [86/93] eCryptfs: Add getattr function
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit f8f484d1b6677dd5cd5e7e605db747e8c30bbd47 upstream.

The i_blocks field of an eCryptfs inode cannot be trusted, but
generic_fillattr() uses it to instantiate the blocks field of a stat()
syscall when a filesystem doesn't implement its own getattr().  Users
have noticed that the output of du is incorrect on newly created files.

This patch creates ecryptfs_getattr() which calls into the lower
filesystem's getattr() so that eCryptfs can use its kstat.blocks value
after calling generic_fillattr().  It is important to note that the
block count includes the eCryptfs metadata stored in the beginning of
the lower file plus any padding used to fill an extent before
encryption.

https://bugs.launchpad.net/ecryptfs/+bug/390833

Reported-by: Dominic Sacré <dominic.sacre@gmx.de>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Tim Gardner <timg@tpi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/inode.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -971,6 +971,21 @@ out:
 	return rc;
 }
 
+int ecryptfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		     struct kstat *stat)
+{
+	struct kstat lower_stat;
+	int rc;
+
+	rc = vfs_getattr(ecryptfs_dentry_to_lower_mnt(dentry),
+			 ecryptfs_dentry_to_lower(dentry), &lower_stat);
+	if (!rc) {
+		generic_fillattr(dentry->d_inode, stat);
+		stat->blocks = lower_stat.blocks;
+	}
+	return rc;
+}
+
 int
 ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		  size_t size, int flags)
@@ -1100,6 +1115,7 @@ const struct inode_operations ecryptfs_d
 const struct inode_operations ecryptfs_main_iops = {
 	.permission = ecryptfs_permission,
 	.setattr = ecryptfs_setattr,
+	.getattr = ecryptfs_getattr,
 	.setxattr = ecryptfs_setxattr,
 	.getxattr = ecryptfs_getxattr,
 	.listxattr = ecryptfs_listxattr,


