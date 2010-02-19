Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab0BSRMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:12:55 -0500
Received: from kroah.org ([198.145.64.141]:57518 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab0BSRAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:34 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:40 2010
Message-Id: <20100219163240.623130905@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [36/93] NFS: Fix a umount race
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 387c149b54b4321cbc790dadbd4f8eedb5a90468 upstream.

Ensure that we unregister the bdi before kill_anon_super() calls
ida_remove() on our device name.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/super.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -241,6 +241,7 @@ static int  nfs_show_stats(struct seq_fi
 static int nfs_get_sb(struct file_system_type *, int, const char *, void *, struct vfsmount *);
 static int nfs_xdev_get_sb(struct file_system_type *fs_type,
 		int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt);
+static void nfs_put_super(struct super_block *);
 static void nfs_kill_super(struct super_block *);
 static int nfs_remount(struct super_block *sb, int *flags, char *raw_data);
 
@@ -264,6 +265,7 @@ static const struct super_operations nfs
 	.alloc_inode	= nfs_alloc_inode,
 	.destroy_inode	= nfs_destroy_inode,
 	.write_inode	= nfs_write_inode,
+	.put_super	= nfs_put_super,
 	.statfs		= nfs_statfs,
 	.clear_inode	= nfs_clear_inode,
 	.umount_begin	= nfs_umount_begin,
@@ -333,6 +335,7 @@ static const struct super_operations nfs
 	.alloc_inode	= nfs_alloc_inode,
 	.destroy_inode	= nfs_destroy_inode,
 	.write_inode	= nfs_write_inode,
+	.put_super	= nfs_put_super,
 	.statfs		= nfs_statfs,
 	.clear_inode	= nfs4_clear_inode,
 	.umount_begin	= nfs_umount_begin,
@@ -2196,6 +2199,17 @@ error_splat_super:
 }
 
 /*
+ * Ensure that we unregister the bdi before kill_anon_super
+ * releases the device name
+ */
+static void nfs_put_super(struct super_block *s)
+{
+	struct nfs_server *server = NFS_SB(s);
+
+	bdi_unregister(&server->backing_dev_info);
+}
+
+/*
  * Destroy an NFS2/3 superblock
  */
 static void nfs_kill_super(struct super_block *s)
@@ -2203,7 +2217,6 @@ static void nfs_kill_super(struct super_
 	struct nfs_server *server = NFS_SB(s);
 
 	kill_anon_super(s);
-	bdi_unregister(&server->backing_dev_info);
 	nfs_fscache_release_super_cookie(s);
 	nfs_free_server(server);
 }


