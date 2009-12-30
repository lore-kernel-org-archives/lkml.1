Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZL3Umj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZL3Umj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbZL3Umh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:42:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44298 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbZL3Ume (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:42:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ja8+ZRI1D22UAQ4lWUEHkDxVI7vyBnYm7kwc8++gHnY0YhgjPweVLPBHhSoER+8Pzz
         OhQBdKPz2nnbvOKGfPSlyNmSP7NoU7fJZ3P18Qbjpy/AXWxYfDqeoIi3ucr6VxOYJG6v
         JlMxpXy3JTJGNwPN1p0UMeSytrb8OpajuX69Q=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Christian Kujau <lists@nerdbynature.de>
Subject: [PATCH 2/5] reiserfs: Fix unwanted recursive reiserfs lock in reiserfs_unlink()
Date: Wed, 30 Dec 2009 21:42:24 +0100
Message-Id: <1262205747-9208-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_unlink() may or may not be called under the reiserfs
lock.
But it also takes the reiserfs lock and can then acquire it
recursively which leads to do_journal_begin_r() that fails to
relax the reiserfs lock before grabbing the journal mutex,
creating an unexpected lock inversion.

We need to ensure reiserfs_unlink() won't get the reiserfs lock
recursively using reiserfs_write_lock_once().

This fixes the following warning that precedes a lock inversion
report (reiserfs lock <-> journal mutex).

------------[ cut here ]------------
WARNING: at fs/reiserfs/lock.c:95 reiserfs_lock_check_recursive+0x3a/0x50()
Hardware name: MS-7418
Unwanted recursive reiserfs lock!
Pid: 3208, comm: dbench Not tainted 2.6.32-atom #177
Call Trace:
 [<c114327a>] ? reiserfs_lock_check_recursive+0x3a/0x50
 [<c114327a>] ? reiserfs_lock_check_recursive+0x3a/0x50
 [<c10373a7>] warn_slowpath_common+0x67/0xc0
 [<c114327a>] ? reiserfs_lock_check_recursive+0x3a/0x50
 [<c1037446>] warn_slowpath_fmt+0x26/0x30
 [<c114327a>] reiserfs_lock_check_recursive+0x3a/0x50
 [<c113c213>] do_journal_begin_r+0x83/0x360
 [<c105eb16>] ? __lock_acquire+0x1296/0x19e0
 [<c1142a57>] ? xattr_unlink+0x57/0xb0
 [<c113c670>] journal_begin+0x80/0x130
 [<c1116d5d>] reiserfs_unlink+0x7d/0x2d0
 [<c1142a57>] ? xattr_unlink+0x57/0xb0
 [<c1142a57>] ? xattr_unlink+0x57/0xb0
 [<c1142a57>] ? xattr_unlink+0x57/0xb0
 [<c1142a64>] xattr_unlink+0x64/0xb0
 [<c1143169>] delete_one_xattr+0x29/0x100
 [<c11427ab>] reiserfs_for_each_xattr+0x10b/0x290
 [<c1143140>] ? delete_one_xattr+0x0/0x100
 [<c1401ca9>] ? mutex_lock_nested+0x299/0x340
 [<c11429aa>] reiserfs_delete_xattrs+0x1a/0x60
 [<c11432f9>] ? reiserfs_write_lock_once+0x29/0x50
 [<c111ea1f>] reiserfs_delete_inode+0x9f/0x150
 [<c11b0d0f>] ? _atomic_dec_and_lock+0x4f/0x70
 [<c111e980>] ? reiserfs_delete_inode+0x0/0x150
 [<c10c9c32>] generic_delete_inode+0xa2/0x170
 [<c10c9d4f>] generic_drop_inode+0x4f/0x70
 [<c10c8b07>] iput+0x47/0x50
 [<c10c0965>] do_unlinkat+0xd5/0x160
 [<c10505c6>] ? up_read+0x16/0x30
 [<c1022ab7>] ? do_page_fault+0x187/0x330
 [<c1002fd8>] ? restore_all_notrace+0x0/0x18
 [<c1022930>] ? do_page_fault+0x0/0x330
 [<c105cbe4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c10c0a00>] sys_unlink+0x10/0x20
 [<c1002ec4>] sysenter_do_call+0x12/0x32
---[ end trace 2e35d71a6cc69d0c ]---

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christian Kujau <lists@nerdbynature.de>
---
 fs/reiserfs/namei.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index e296ff7..9d4dcf0 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -921,6 +921,7 @@ static int reiserfs_unlink(struct inode *dir, struct dentry *dentry)
 	struct reiserfs_transaction_handle th;
 	int jbegin_count;
 	unsigned long savelink;
+	int depth;
 
 	inode = dentry->d_inode;
 
@@ -932,7 +933,7 @@ static int reiserfs_unlink(struct inode *dir, struct dentry *dentry)
 	    JOURNAL_PER_BALANCE_CNT * 2 + 2 +
 	    4 * REISERFS_QUOTA_TRANS_BLOCKS(dir->i_sb);
 
-	reiserfs_write_lock(dir->i_sb);
+	depth = reiserfs_write_lock_once(dir->i_sb);
 	retval = journal_begin(&th, dir->i_sb, jbegin_count);
 	if (retval)
 		goto out_unlink;
@@ -993,7 +994,7 @@ static int reiserfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	retval = journal_end(&th, dir->i_sb, jbegin_count);
 	reiserfs_check_path(&path);
-	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_write_unlock_once(dir->i_sb, depth);
 	return retval;
 
       end_unlink:
@@ -1003,7 +1004,7 @@ static int reiserfs_unlink(struct inode *dir, struct dentry *dentry)
 	if (err)
 		retval = err;
       out_unlink:
-	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_write_unlock_once(dir->i_sb, depth);
 	return retval;
 }
 
-- 
1.6.2.3

