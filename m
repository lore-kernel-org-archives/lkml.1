Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbZFHTep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbZFHTep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbZFHTYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:24:03 -0400
Received: from thunk.org ([69.25.196.29]:39633 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbZFHTXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 13/49] ext4: ext4_mark_recovery_complete() doesn't need to use lock_super
Date: Mon,  8 Jun 2009 15:22:31 -0400
Message-Id: <1244488987-32564-14-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-13-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function ext4_mark_recovery_complete() is called from two call
paths: either (a) while mounting the filesystem, in which case there's
no danger of any other CPU calling write_super() until the mount is
completed, and (b) while remounting the filesystem read-write, in
which case the fs core has already locked the superblock.  This also
allows us to take out a very vile unlock_super()/lock_super() pair in
ext4_remount().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e3b35f2..45d0ada 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3219,13 +3219,11 @@ static void ext4_mark_recovery_complete(struct super_block *sb,
 	if (jbd2_journal_flush(journal) < 0)
 		goto out;
 
-	lock_super(sb);
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER) &&
 	    sb->s_flags & MS_RDONLY) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		ext4_commit_super(sb, 1);
 	}
-	unlock_super(sb);
 
 out:
 	jbd2_journal_unlock_updates(journal);
@@ -3436,15 +3434,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			    (sbi->s_mount_state & EXT4_VALID_FS))
 				es->s_state = cpu_to_le16(sbi->s_mount_state);
 
-			/*
-			 * We have to unlock super so that we can wait for
-			 * transactions.
-			 */
-			if (sbi->s_journal) {
-				unlock_super(sb);
+			if (sbi->s_journal)
 				ext4_mark_recovery_complete(sb, es);
-				lock_super(sb);
-			}
 		} else {
 			int ret;
 			if ((ret = EXT4_HAS_RO_COMPAT_FEATURE(sb,
-- 
1.6.3.2.1.gb9f7d.dirty

