Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbYJJJAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbYJJJAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYJJJAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:00:44 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36737 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYJJJAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:00:42 -0400
X-AuditID: 0ac90650-aaac9ba000006fc9-3b-48ef19b86d0a
Message-ID: <48EF19B5.2090200@hitachi.com>
Date: Fri, 10 Oct 2008 18:00:37 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: tytso@mit.edu, adilger@sun.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: [PATCH 3/4] ext4: add checks for errors from jbd2
References: <48EF168A.4000705@hitachi.com>
In-Reply-To: <48EF168A.4000705@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the journal has aborted due to a checkpointing failure, we
have to keep the contents of the journal space.  Otherwise, the
filesystem will lose uncheckpointed metadata completely and
become inconsistent.  To avoid this, we need to keep needs_recovery
flag if checkpoint has failed.

With this patch, ext4_put_super() detects a checkpointing failure
from the return value of journal_destroy(), then it invokes
ext4_abort() to make the filesystem read only and keep
needs_recovery flag.  Errors from jbd2_journal_flush() are also
handled by this patch in some places.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/ext4/ioctl.c |   12 ++++++++----
 fs/ext4/super.c |   23 +++++++++++++++++++----
 2 files changed, 27 insertions(+), 8 deletions(-)

Index: linux-2.6.27-rc9-ex4-1/fs/ext4/ioctl.c
===================================================================
--- linux-2.6.27-rc9-ex4-1.orig/fs/ext4/ioctl.c
+++ linux-2.6.27-rc9-ex4-1/fs/ext4/ioctl.c
@@ -192,7 +192,7 @@ setversion_out:
 	case EXT4_IOC_GROUP_EXTEND: {
 		ext4_fsblk_t n_blocks_count;
 		struct super_block *sb = inode->i_sb;
-		int err;
+		int err, err2;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -206,8 +206,10 @@ setversion_out:
 
 		err = ext4_group_extend(sb, EXT4_SB(sb)->s_es, n_blocks_count);
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
-		jbd2_journal_flush(EXT4_SB(sb)->s_journal);
+		err2 = jbd2_journal_flush(EXT4_SB(sb)->s_journal);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		if (err == 0)
+			err = err2;
 		mnt_drop_write(filp->f_path.mnt);
 
 		return err;
@@ -220,7 +222,7 @@ setversion_out:
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
 		struct super_block *sb = inode->i_sb;
-		int err;
+		int err, err2;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -235,8 +237,10 @@ setversion_out:
 
 		err = ext4_group_add(sb, &input);
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
-		jbd2_journal_flush(EXT4_SB(sb)->s_journal);
+		err2 = jbd2_journal_flush(EXT4_SB(sb)->s_journal);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		if (err == 0)
+			err = err2;
 		mnt_drop_write(filp->f_path.mnt);
 
 		return err;
Index: linux-2.6.27-rc9-ex4-1/fs/ext4/super.c
===================================================================
--- linux-2.6.27-rc9-ex4-1.orig/fs/ext4/super.c
+++ linux-2.6.27-rc9-ex4-1/fs/ext4/super.c
@@ -507,7 +507,8 @@ static void ext4_put_super(struct super_
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
 	ext4_xattr_put_super(sb);
-	jbd2_journal_destroy(sbi->s_journal);
+	if (jbd2_journal_destroy(sbi->s_journal) < 0)
+		ext4_abort(sb, __func__, "Couldn't clean up the journal");
 	sbi->s_journal = NULL;
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
@@ -2863,7 +2864,9 @@ static void ext4_mark_recovery_complete(
 	journal_t *journal = EXT4_SB(sb)->s_journal;
 
 	jbd2_journal_lock_updates(journal);
-	jbd2_journal_flush(journal);
+	if (jbd2_journal_flush(journal) < 0)
+		goto out;
+
 	lock_super(sb);
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER) &&
 	    sb->s_flags & MS_RDONLY) {
@@ -2872,6 +2875,8 @@ static void ext4_mark_recovery_complete(
 		ext4_commit_super(sb, es, 1);
 	}
 	unlock_super(sb);
+
+out:
 	jbd2_journal_unlock_updates(journal);
 }
 
@@ -2972,7 +2977,13 @@ static void ext4_write_super_lockfs(stru
 
 		/* Now we set up the journal barrier. */
 		jbd2_journal_lock_updates(journal);
-		jbd2_journal_flush(journal);
+
+		/*
+		 * We don't want to clear needs_recovery flag when we failed
+		 * to flush the journal.
+		 */
+		if (jbd2_journal_flush(journal) < 0)
+			return;
 
 		/* Journal blocked and flushed, clear needs_recovery flag. */
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
@@ -3412,8 +3423,12 @@ static int ext4_quota_on(struct super_bl
 		 * otherwise be livelocked...
 		 */
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
-		jbd2_journal_flush(EXT4_SB(sb)->s_journal);
+		err = jbd2_journal_flush(EXT4_SB(sb)->s_journal);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		if (err) {
+			path_put(&nd.path);
+			return err;
+		}
 	}
 
 	err = vfs_quota_on_path(sb, type, format_id, &nd.path);


