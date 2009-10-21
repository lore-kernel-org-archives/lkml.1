Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZJUTU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZJUTU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbZJUTU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:20:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935AbZJUTUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:20:20 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/41] VFS: Add read-only users count to superblock
Date: Wed, 21 Oct 2009 12:19:05 -0700
Message-Id: <1256152779-10054-8-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-7-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we can check if a file system is currently read-only, we can't
guarantee that it will stay read-only.  The file system can be
remounted read-write at any time; it's also conceivable that a file
system can be mounted a second time and converted to read-write if the
underlying fs allows it.  This is a problem for union mounts, which
require the underlying file system be read-only.  Add a read-only
users count and don't allow remounts to change the file system to
read-write or read-write mounts if there are any read-only users.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/super.c         |   14 ++++++++++++++
 include/linux/fs.h |    5 +++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 2761d3e..c8140ac 100644
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
@@ -889,6 +898,11 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
  	if (error)
  		goto out_sb;
 
+	error = -EROFS;
+	if (!(flags & MS_RDONLY) &&
+	    (mnt->mnt_sb->s_readonly_users))
+		goto out_sb;
+
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	mnt->mnt_parent = mnt;
 	up_write(&mnt->mnt_sb->s_umount);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 73e9b64..5fb7343 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1379,6 +1379,11 @@ struct super_block {
 	 * generic_show_options()
 	 */
 	char *s_options;
+
+	/*
+	 * Users who require read-only access - e.g., union mounts
+	 */
+	int s_readonly_users;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
-- 
1.6.3.3

