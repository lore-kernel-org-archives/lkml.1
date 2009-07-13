Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZGMT1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZGMT1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 15:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbZGMT1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 15:27:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbZGMT1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 15:27:47 -0400
Date: Mon, 13 Jul 2009 15:27:44 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] VFS: Add read-only users count to superblock
Message-ID: <20090713192743.GA27582@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the last FS summit, Al Viro suggested creating a superblock
level read-only marker so that union mounts could guarantee that the
underlying fs would not become writable.  This patch implements the
VFS support, but doesn't add any users.  The patch making union mounts
use the support is in our union mounts tree.  I think we also need
some way to pass this through NFS mounts, since a read-only NFS mount
for the bottom layer of a union mount is a common use case.

-VAL

commit b0bfe1b9023467184e138c8520a084ca1e7bf8ab
Author: Valerie Aurora (Henson) <vaurora@redhat.com>
Date:   Mon Jul 13 09:30:49 2009 -0700

    VFS: Add read-only users count to superblock
    
    While we can check if a file system is currently read-only, we can't
    guarantee that it will stay read-only.  The file system can be
    remounted read-write at any time; it's also concievable that a file
    system can be mounted a second time and converted to read-write if the
    underlying fs allows it.  This is a problem for union mounts, which
    require the underlying file system be read-only.  Add a read-only
    users count and don't allow remounts to change the file system to
    read-write or read-write mounts if there are any read-only users.
    
    Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>

diff --git a/fs/super.c b/fs/super.c
index 2761d3e..65972df 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -553,6 +553,15 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	}
 	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
 
+	/* If we are remounting read/write, make sure that none of the
+	   users require read-only for correct operation (such as
+	   union mounts). */
+	if (remount_rw && sb->s_readonly_users) {
+		printk(KERN_INFO "%s: In use by %d read-only user(s)\n",
+		       sb->s_id, sb->s_readonly_users);
+		return -EROFS;
+	}
+
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
 		if (retval)
@@ -889,6 +898,10 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
  	if (error)
  		goto out_sb;
 
+	error = -EROFS;
+	if (mnt->mnt_sb->s_readonly_users)
+		goto out_sb;
+
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	mnt->mnt_parent = mnt;
 	up_write(&mnt->mnt_sb->s_umount);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0872372..aff3dca 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1379,6 +1379,10 @@ struct super_block {
 	 * generic_show_options()
 	 */
 	char *s_options;
+	/*
+	 * Users who require read-only access - e.g., union mounts
+	 */
+	int s_readonly_users;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
