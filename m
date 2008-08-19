Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYHSWGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYHSWGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbYHSWGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:06:32 -0400
Received: from tau.jukie.net ([216.239.93.128]:56732 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbYHSWGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:06:31 -0400
From: Bart Trojanowski <bart@jukie.net>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, Bart Trojanowski <bart@jukie.net>
Subject: [PATCH] make lock_super recursive to simulate BKL
Date: Tue, 19 Aug 2008 18:06:30 -0400
Message-Id: <1219183590-19529-1-git-send-email-bart@jukie.net>
X-Mailer: git-send-email 1.5.3.7.1150.g149d432
In-Reply-To: <20080819220311.GA28029@jukie.net>
References: <20080819220311.GA28029@jukie.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a regression introduced when BKL was removed from the
vfat driver in commit 8f5934278d1d86590244c2791b28f77d67466007.

With vfat, the unlink syscall would result in the following call chain
that caused deadlock.

        - do_unlinkat
          - vfs_unlink
            - vfat_unlink
              * lock_super
              - fat_remove_entries
                - fat_sync_inode
                  - fat_write_inode
                    * lock_super

This is not the ideal fix, but it should reverse some regressions
caused by BKL removal in code that depended on BKL being recursive.

Signed-off-by: Bart Trojanowski <bart@jukie.net>
---
 fs/super.c         |   20 ++++++++++++++++++--
 include/linux/fs.h |    2 ++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index e931ae9..8f813db 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -73,6 +73,8 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
+		s->s_lock_cookie = NULL;
+		s->s_lock_refcnt = 0;
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
 		/*
 		 * The locking rules for s_lock are up to the
@@ -227,14 +229,28 @@ static int grab_super(struct super_block *s) __releases(sb_lock)
  */
 void lock_super(struct super_block * sb)
 {
+	if (sb->s_lock_heldby == current) {
+		sb->s_lock_refcnt ++;
+		return;
+	}
+
 	get_fs_excl();
 	mutex_lock(&sb->s_lock);
+
+	sb->s_lock_heldby = current;
+	sb->s_lock_refcnt = 1;
 }
 
 void unlock_super(struct super_block * sb)
 {
-	put_fs_excl();
-	mutex_unlock(&sb->s_lock);
+	BUG_ON(sb->s_lock_heldby != current);
+
+	if (! -- sb->s_lock_refcnt) {
+		sb->s_lock_heldby = NULL;
+
+		put_fs_excl();
+		mutex_unlock(&sb->s_lock);
+	}
 }
 
 EXPORT_SYMBOL(lock_super);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 580b513..d88178e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1076,6 +1076,8 @@ struct super_block {
 	struct dentry		*s_root;
 	struct rw_semaphore	s_umount;
 	struct mutex		s_lock;
+	void			*s_lock_heldby;
+	u32			s_lock_refcnt;
 	int			s_count;
 	int			s_syncing;
 	int			s_need_sync_fs;
-- 
1.5.6.2.221.g3c6e79

