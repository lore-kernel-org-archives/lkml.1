Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZEZJeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZEZJeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZEZJdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:33:53 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54775 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZEZJdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:33:52 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 01/12] ntfs: remove old debug check for dirty data in ntfs_put_super()
Date: Tue, 26 May 2009 11:33:39 +0200
Message-Id: <1243330430-9964-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should not trigger anymore, so kill it.

Acked-by: Anton Altaparmakov <aia21@cam.ac.uk>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/ntfs/super.c |   33 +++------------------------------
 1 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index f76951d..3fc03bd 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2373,39 +2373,12 @@ static void ntfs_put_super(struct super_block *sb)
 		vol->mftmirr_ino = NULL;
 	}
 	/*
-	 * If any dirty inodes are left, throw away all mft data page cache
-	 * pages to allow a clean umount.  This should never happen any more
-	 * due to mft.c::ntfs_mft_writepage() cleaning all the dirty pages as
-	 * the underlying mft records are written out and cleaned.  If it does,
-	 * happen anyway, we want to know...
+	 * We should have no dirty inodes left, due to
+	 * mft.c::ntfs_mft_writepage() cleaning all the dirty pages as
+	 * the underlying mft records are written out and cleaned.
 	 */
 	ntfs_commit_inode(vol->mft_ino);
 	write_inode_now(vol->mft_ino, 1);
-	if (sb_has_dirty_inodes(sb)) {
-		const char *s1, *s2;
-
-		mutex_lock(&vol->mft_ino->i_mutex);
-		truncate_inode_pages(vol->mft_ino->i_mapping, 0);
-		mutex_unlock(&vol->mft_ino->i_mutex);
-		write_inode_now(vol->mft_ino, 1);
-		if (sb_has_dirty_inodes(sb)) {
-			static const char *_s1 = "inodes";
-			static const char *_s2 = "";
-			s1 = _s1;
-			s2 = _s2;
-		} else {
-			static const char *_s1 = "mft pages";
-			static const char *_s2 = "They have been thrown "
-					"away.  ";
-			s1 = _s1;
-			s2 = _s2;
-		}
-		ntfs_error(sb, "Dirty %s found at umount time.  %sYou should "
-				"run chkdsk.  Please email "
-				"linux-ntfs-dev@lists.sourceforge.net and say "
-				"that you saw this message.  Thank you.", s1,
-				s2);
-	}
 #endif /* NTFS_RW */
 
 	iput(vol->mft_ino);
-- 
1.6.3.rc0.1.gf800

