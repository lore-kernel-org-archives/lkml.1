Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbZDNDfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbZDNDfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 23:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZDNDee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 23:34:34 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51054 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZDNDeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 23:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=woBeJNtbftJ5OtXuvM6+bA+fmuaNJXLfArIsKVHJ4qGNH43qsvIjhyFCCeTnOWB+If
         48gZ+wwKwLyimOZejbDzhw78OaRUBdpqs3u9IQTsq66RGceXhGwP3KyoJtqiyCINsB1Z
         ET06o7/zf1EulpINKpo5zGQB/FwkUs55CSaRE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 3/3] kill-the-BKL/reiserfs: only acquire the write lock once in reiserfs_dirty_inode
Date: Tue, 14 Apr 2009 05:34:25 +0200
Message-Id: <1239680065-25013-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1239680065-25013-1-git-send-email-fweisbec@gmail.com>
References: <1239680065-25013-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix a deadlock

reiserfs_dirty_inode() is the super_operations::dirty_inode() callback
of reiserfs. It can be called from different contexts where the write
lock can be already held.

But this function also grab the write lock (possibly recursively).
Subsequent release of the lock before sleep will actually not release
the lock if the caller of mark_inode_dirty() (which in turn calls
reiserfs_dirty_inode()) already owns the lock.

A typical case:

reiserfs_write_end() {
	acquire_write_lock()
	mark_inode_dirty() {
		reiserfs_dirty_inode() {
			reacquire_write_lock() {
				journal_begin() {
					do_journal_begin_r() {
						/*
						 * fail to release, still
						 * one depth of lock
						 */
						release_write_lock()
						reiserfs_wait_on_write_block() {
							wait_event()

The event is usually provided by something which needs the write lock but
it hasn't been released.

We use reiserfs_write_lock_once() here to ensure we only grab the
write lock in one level.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/super.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 1ac4fcb..f6c5606 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -567,25 +567,28 @@ static void reiserfs_dirty_inode(struct inode *inode)
 	struct reiserfs_transaction_handle th;
 
 	int err = 0;
+	int lock_depth;
+
 	if (inode->i_sb->s_flags & MS_RDONLY) {
 		reiserfs_warning(inode->i_sb, "clm-6006",
 				 "writing inode %lu on readonly FS",
 				 inode->i_ino);
 		return;
 	}
-	reiserfs_write_lock(inode->i_sb);
+	lock_depth = reiserfs_write_lock_once(inode->i_sb);
 
 	/* this is really only used for atime updates, so they don't have
 	 ** to be included in O_SYNC or fsync
 	 */
 	err = journal_begin(&th, inode->i_sb, 1);
-	if (err) {
-		reiserfs_write_unlock(inode->i_sb);
-		return;
-	}
+	if (err)
+		goto out;
+
 	reiserfs_update_sd(&th, inode);
 	journal_end(&th, inode->i_sb, 1);
-	reiserfs_write_unlock(inode->i_sb);
+
+out:
+	reiserfs_write_unlock_once(inode->i_sb, lock_depth);
 }
 
 #ifdef CONFIG_REISERFS_FS_POSIX_ACL
-- 
1.6.1

