Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab0BKSfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:35:34 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:36210 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab0BKSfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:35:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gfUZYav6dzGzvTgnqP8KRQAsMhF63I/XULjB6igO5BQgjP3ZNm0OKJUStCnhDlnm3R
         HVRLEz3bQiBygFbNA5Q88RtA+bd8GwvmyYV5S5xfo7DyHB3EALJd1t7ZQqz6y5zeaO9F
         IxrcpYPl5n90VQ48DaOW8ihQzZC1pPhKrSfbs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] reiserfs: Fix softlockup while waiting on an inode
Date: Thu, 11 Feb 2010 19:35:22 +0100
Message-Id: <1265913322-7046-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20100205093752.GA13441@orion>
References: <20100205093752.GA13441@orion>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we wait for an inode through reiserfs_iget(), we hold
the reiserfs lock. And waiting for an inode may imply waiting
for its writeback. But the inode writeback path may also require
the reiserfs lock, which leads to a deadlock.

We just need to release the reiserfs lock from reiserfs_iget()
to fix this.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Chris Mason <chris.mason@oracle.com>
---
 fs/reiserfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 9087b10..2df0f5c 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1497,9 +1497,11 @@ struct inode *reiserfs_iget(struct super_block *s, const struct cpu_key *key)
 
 	args.objectid = key->on_disk_key.k_objectid;
 	args.dirid = key->on_disk_key.k_dir_id;
+	reiserfs_write_unlock(s);
 	inode = iget5_locked(s, key->on_disk_key.k_objectid,
 			     reiserfs_find_actor, reiserfs_init_locked_inode,
 			     (void *)(&args));
+	reiserfs_write_lock(s);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.6.2.3

