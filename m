Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbZJBBcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbZJBBcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZJBBcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:46 -0400
Received: from kroah.org ([198.145.64.141]:32947 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799AbZJBBcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:08 2009
Message-Id: <20091002012408.786364159@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Serge Hallyn <serue@us.ibm.com>, Eric Sandeen <esandeen@redhat.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       ecryptfs-devel@lists.launchpad.net,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [020/136] eCryptfs: Check for O_RDONLY lower inodes when opening lower files
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=ecryptfs-check-for-o_rdonly-lower-inodes-when-opening-lower-files.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit ac22ba23b659e34a5961aec8c945608e471b0d5b upstream.

If the lower inode is read-only, don't attempt to open the lower file
read/write and don't hand off the open request to the privileged
eCryptfs kthread for opening it read/write.  Instead, only try an
unprivileged, read-only open of the file and give up if that fails.
This patch fixes an oops when eCryptfs is mounted on top of a read-only
mount.

Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Eric Sandeen <esandeen@redhat.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: ecryptfs-devel@lists.launchpad.net
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/kthread.c |   24 ++++++++----------------
 fs/ecryptfs/main.c    |    3 +--
 2 files changed, 9 insertions(+), 18 deletions(-)

--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -136,6 +136,7 @@ int ecryptfs_privileged_open(struct file
 			     const struct cred *cred)
 {
 	struct ecryptfs_open_req *req;
+	int flags = O_LARGEFILE;
 	int rc = 0;
 
 	/* Corresponding dput() and mntput() are done when the
@@ -143,10 +144,14 @@ int ecryptfs_privileged_open(struct file
 	 * destroyed. */
 	dget(lower_dentry);
 	mntget(lower_mnt);
-	(*lower_file) = dentry_open(lower_dentry, lower_mnt,
-				    (O_RDWR | O_LARGEFILE), cred);
+	flags |= IS_RDONLY(lower_dentry->d_inode) ? O_RDONLY : O_RDWR;
+	(*lower_file) = dentry_open(lower_dentry, lower_mnt, flags, cred);
 	if (!IS_ERR(*lower_file))
 		goto out;
+	if (flags & O_RDONLY) {
+		rc = PTR_ERR((*lower_file));
+		goto out;
+	}
 	req = kmem_cache_alloc(ecryptfs_open_req_cache, GFP_KERNEL);
 	if (!req) {
 		rc = -ENOMEM;
@@ -180,21 +185,8 @@ int ecryptfs_privileged_open(struct file
 		       __func__);
 		goto out_unlock;
 	}
-	if (IS_ERR(*req->lower_file)) {
+	if (IS_ERR(*req->lower_file))
 		rc = PTR_ERR(*req->lower_file);
-		dget(lower_dentry);
-		mntget(lower_mnt);
-		(*lower_file) = dentry_open(lower_dentry, lower_mnt,
-					    (O_RDONLY | O_LARGEFILE), cred);
-		if (IS_ERR(*lower_file)) {
-			rc = PTR_ERR(*req->lower_file);
-			(*lower_file) = NULL;
-			printk(KERN_WARNING "%s: Error attempting privileged "
-			       "open of lower file with either RW or RO "
-			       "perms; rc = [%d]. Giving up.\n",
-			       __func__, rc);
-		}
-	}
 out_unlock:
 	mutex_unlock(&req->mux);
 out_free:
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -129,11 +129,10 @@ int ecryptfs_init_persistent_file(struct
 		lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
 		rc = ecryptfs_privileged_open(&inode_info->lower_file,
 					      lower_dentry, lower_mnt, cred);
-		if (rc || IS_ERR(inode_info->lower_file)) {
+		if (rc) {
 			printk(KERN_ERR "Error opening lower persistent file "
 			       "for lower_dentry [0x%p] and lower_mnt [0x%p]; "
 			       "rc = [%d]\n", lower_dentry, lower_mnt, rc);
-			rc = PTR_ERR(inode_info->lower_file);
 			inode_info->lower_file = NULL;
 		}
 	}


