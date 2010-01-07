Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033Ab0AGPAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab0AGPAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020Ab0AGPAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:00:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43936 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab0AGPAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:00:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CDdsOf+T+cC6jZlN5XYziEdTtg8Gz8hoZG7R6ulzt427jQYf5tDim7vMEiEWDgY0Pp
         ALvRcEa0gWz0RPjbTwuXlIjiu8jPqn83WYq3BgaHSbT58Z4bXiJAIkC5tE7WmElU4osl
         vm3q4NKzUB9ptkfC5/dokTCRO+CNeJd7ZWBdI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] reiserfs: Relax reiserfs_xattr_set_handle() while acquiring xattr locks
Date: Thu,  7 Jan 2010 16:00:28 +0100
Message-Id: <1262876428-4054-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix remaining xattr locks acquired in reiserfs_xattr_set_handle()
while we are holding the reiserfs lock to avoid lock inversions.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/xattr.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 35826d2..b91428e 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -560,8 +560,12 @@ reiserfs_xattr_set_handle(struct reiserfs_transaction_handle *th,
 			.ia_size = buffer_size,
 			.ia_valid = ATTR_SIZE | ATTR_CTIME,
 		};
+
+		reiserfs_write_unlock(inode->i_sb);
 		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_XATTR);
 		down_write(&dentry->d_inode->i_alloc_sem);
+		reiserfs_write_lock(inode->i_sb);
+
 		err = reiserfs_setattr(dentry, &newattrs);
 		up_write(&dentry->d_inode->i_alloc_sem);
 		mutex_unlock(&dentry->d_inode->i_mutex);
-- 
1.6.2.3

