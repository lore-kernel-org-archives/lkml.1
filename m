Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbZL3Umy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbZL3Umy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbZL3Umm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:42:42 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:40205 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZL3Umk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:42:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pOQYD0fVwh87ZugwWAgO12kBZ5yNCmgX331JX/61OX+k/hJ/yvlKv6C0qNTv1T244T
         f6NPfZM8A2FAgAydQvjfBFs1ZUoqCv/18PU5fA3Kn+bnFKZBOI3+m9EkI6jksZTnWh9R
         wm7VdUynpd8JCocLlsVptIyQFe8LSkIFAF2qw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Christian Kujau <lists@nerdbynature.de>
Subject: [PATCH 5/5] reiserfs: Safely acquire i_mutex from xattr_rmdir
Date: Wed, 30 Dec 2009 21:42:27 +0100
Message-Id: <1262205747-9208-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relax the reiserfs lock before taking the inode mutex from
xattr_rmdir() to avoid the usual reiserfs lock <-> inode mutex
bad dependency.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christian Kujau <lists@nerdbynature.de>
---
 fs/reiserfs/xattr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index bfdac66..9623cfe 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -98,7 +98,8 @@ static int xattr_rmdir(struct inode *dir, struct dentry *dentry)
 	BUG_ON(!mutex_is_locked(&dir->i_mutex));
 	vfs_dq_init(dir);
 
-	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
+	reiserfs_mutex_lock_nested_safe(&dentry->d_inode->i_mutex,
+					I_MUTEX_CHILD, dir->i_sb);
 	dentry_unhash(dentry);
 	error = dir->i_op->rmdir(dir, dentry);
 	if (!error)
-- 
1.6.2.3

