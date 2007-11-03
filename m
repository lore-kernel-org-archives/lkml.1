Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbXKCLNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbXKCLNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 07:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbXKCLNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 07:13:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbXKCLNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 07:13:01 -0400
Message-ID: <472C56E5.1040901@RedHat.com>
Date: Sat, 03 Nov 2007 07:09:25 -0400
From: Steve Dickson <SteveD@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alexander Viro <aviro@redhat.com>, Christoph Hellwig <hch@infradead.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] NFS: Stop sillyname renames and unmounts from racing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch stops NFS sillyname renames and umounts from racing.
I have a test script does the following:
     1) start nfs server
      2) mount loopback
      3) open file in background
      4) remove file
      5) stop nfs server
      6) kill -9 process which has file open
      7) restart nfs server
      8) umount looback mount.

After umount I got the "VFS: Busy inodes after unmount" message
because the processing of the rename has not finished.

Below is a patch that the uses the new silly_count mechanism to
synchronize sillyname processing and umounts. The patch introduces a
nfs_put_super() routine that waits until the nfsi->silly_count count
is zero.

A side-effect of finding and waiting for all the inode to
find the sillyname processing, is I need to traverse
the sb->s_inodes list in the supper block. To do that
safely the inode_lock spin lock has to be held. So for
modules to be able to "see" that lock I needed to
EXPORT_SYMBOL_GPL() it.

Any objections to exporting the inode_lock spin lock?
If so, how should modules _safely_ access the s_inode list?

steved.


Author: Steve Dickson <steved@redhat.com>
Date:   Wed Oct 31 12:19:26 2007 -0400

     Close a unlink/sillyname rename and umount race by added a
     nfs_put_super routine that will run through all the inode
     currently on the super block, waiting for those that are
     in the middle of a sillyname rename or removal.

     This patch stop the infamous "VFS: Busy inodes after unmount... "
     warning during umounts.

     Signed-off-by: Steve Dickson <steved@redhat.com>

diff --git a/fs/inode.c b/fs/inode.c
index ed35383..da9034a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -81,6 +81,7 @@ static struct hlist_head *inode_hashtable __read_mostly;
   * the i_state of an inode while it is in use..
   */
  DEFINE_SPINLOCK(inode_lock);
+EXPORT_SYMBOL_GPL(inode_lock);

  /*
   * iprune_mutex provides exclusion between the kswapd or try_to_free_pages
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index fa517ae..2ac3c34 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -48,6 +48,7 @@
  #include <linux/nfs_xdr.h>
  #include <linux/magic.h>
  #include <linux/parser.h>
+#include <linux/writeback.h>

  #include <asm/system.h>
  #include <asm/uaccess.h>
@@ -202,6 +203,7 @@ static int nfs_get_sb(struct file_system_type *,
int, const char *, void *, stru
  static int nfs_xdev_get_sb(struct file_system_type *fs_type,
  		int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt);
  static void nfs_kill_super(struct super_block *);
+static void nfs_put_super(struct super_block *);

  static struct file_system_type nfs_fs_type = {
  	.owner		= THIS_MODULE,
@@ -223,6 +225,7 @@ static const struct super_operations nfs_sops = {
  	.alloc_inode	= nfs_alloc_inode,
  	.destroy_inode	= nfs_destroy_inode,
  	.write_inode	= nfs_write_inode,
+	.put_super	= nfs_put_super,
  	.statfs		= nfs_statfs,
  	.clear_inode	= nfs_clear_inode,
  	.umount_begin	= nfs_umount_begin,
@@ -1767,6 +1770,30 @@ static void nfs4_kill_super(struct super_block *sb)
  	nfs_free_server(server);
  }

+void nfs_put_super(struct super_block *sb)
+{
+	struct inode *inode;
+	struct nfs_inode *nfsi;
+	/*
+	 * Make sure there are no outstanding renames
+	 */
+relock:
+	spin_lock(&inode_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		nfsi = NFS_I(inode);
+		if (atomic_read(&nfsi->silly_count) > 0) {
+			/* Keep this inode around  during the wait */
+			atomic_inc(&inode->i_count);
+			spin_unlock(&inode_lock);
+			wait_event(nfsi->waitqueue,
+				atomic_read(&nfsi->silly_count) == 1);
+			iput(inode);
+			goto relock;
+		}
+	}
+	spin_unlock(&inode_lock);
+}
+
  /*
   * Clone an NFS4 server record on xdev traversal (FSID-change)
   */

