Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967Ab0AEHCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab0AEHCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963Ab0AEHCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:02:43 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34568 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab0AEHCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:02:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WMHEE/olqIsfqKEkKfE2iyGIMz4YpwG13/Jnq9yXfUQ9NDmmLxyCatFs4SxAQ+cbJH
         zOXZN070o7t6C44+6hmAKPEeWhBfEplSBtj2fq/vd/fp8W7ZxHD/kphdD3jNTqDyuld2
         C/VEB1Sm/3L3VrMoql1cqE/ro64/UifeJkPvc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/3] reiserfs: Fix recursive lock on lchown
Date: Tue,  5 Jan 2010 08:02:36 +0100
Message-Id: <1262674958-23312-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On chown, reiserfs will call reiserfs_setattr() to change the owner
of the given inode, but it may also recursively call
reiserfs_setattr() to propagate the owner change to the private xattr
files for this inode.

Hence, the reiserfs lock may be acquired twice which is not wanted
as reiserfs_setattr() calls journal_begin() that is going to try to
relax the lock in order to safely acquire the journal mutex.

Using reiserfs_write_lock_once() from reiserfs_setattr() solves
the problem.

This fixes the following warning, that precedes a lockdep report.

WARNING: at fs/reiserfs/lock.c:95 reiserfs_lock_check_recursive+0x3f/0x50()
Hardware name: MS-7418
Unwanted recursive reiserfs lock!
Pid: 4189, comm: fsstress Not tainted 2.6.33-rc2-tip-atom+ #195
Call Trace:
 [<c1178bff>] ? reiserfs_lock_check_recursive+0x3f/0x50
 [<c1178bff>] ? reiserfs_lock_check_recursive+0x3f/0x50
 [<c103f7ac>] warn_slowpath_common+0x6c/0xc0
 [<c1178bff>] ? reiserfs_lock_check_recursive+0x3f/0x50
 [<c103f84b>] warn_slowpath_fmt+0x2b/0x30
 [<c1178bff>] reiserfs_lock_check_recursive+0x3f/0x50
 [<c1172ae3>] do_journal_begin_r+0x83/0x350
 [<c1172f2d>] journal_begin+0x7d/0x140
 [<c106509a>] ? in_group_p+0x2a/0x30
 [<c10fda71>] ? inode_change_ok+0x91/0x140
 [<c115007d>] reiserfs_setattr+0x15d/0x2e0
 [<c10f9bf3>] ? dput+0xe3/0x140
 [<c1465adc>] ? _raw_spin_unlock+0x2c/0x50
 [<c117831d>] chown_one_xattr+0xd/0x10
 [<c11780a3>] reiserfs_for_each_xattr+0x113/0x2c0
 [<c1178310>] ? chown_one_xattr+0x0/0x10
 [<c14641e9>] ? mutex_lock_nested+0x2a9/0x350
 [<c117826f>] reiserfs_chown_xattrs+0x1f/0x60
 [<c106509a>] ? in_group_p+0x2a/0x30
 [<c10fda71>] ? inode_change_ok+0x91/0x140
 [<c1150046>] reiserfs_setattr+0x126/0x2e0
 [<c1177c20>] ? reiserfs_getxattr+0x0/0x90
 [<c11b0d57>] ? cap_inode_need_killpriv+0x37/0x50
 [<c10fde01>] notify_change+0x151/0x330
 [<c10e659f>] chown_common+0x6f/0x90
 [<c10e67bd>] sys_lchown+0x6d/0x80
 [<c1002ccc>] sysenter_do_call+0x12/0x32
---[ end trace 7c2b77224c1442fc ]---

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/inode.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index bd615df..47dbfb1 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3052,13 +3052,14 @@ static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
 int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
-	int error;
 	unsigned int ia_valid;
+	int depth;
+	int error;
 
 	/* must be turned off for recursive notify_change calls */
 	ia_valid = attr->ia_valid &= ~(ATTR_KILL_SUID|ATTR_KILL_SGID);
 
-	reiserfs_write_lock(inode->i_sb);
+	depth = reiserfs_write_lock_once(inode->i_sb);
 	if (attr->ia_valid & ATTR_SIZE) {
 		/* version 2 items will be caught by the s_maxbytes check
 		 ** done for us in vmtruncate
@@ -3149,7 +3150,8 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
       out:
-	reiserfs_write_unlock(inode->i_sb);
+	reiserfs_write_unlock_once(inode->i_sb, depth);
+
 	return error;
 }
 
-- 
1.6.2.3

